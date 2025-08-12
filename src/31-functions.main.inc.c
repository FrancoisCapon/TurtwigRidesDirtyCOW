void main_parse_stdin()
{
    // thanks ms copilot
    const int chunk_size = 512;
    char *stdin_buffer = NULL;
    size_t total_size = 0;
    size_t bytes_read;
    char buffer[chunk_size];

    while ((bytes_read = read(STDIN_FILENO, buffer, chunk_size)) > 0)
    {
        char *new_buffer = realloc(stdin_buffer, total_size + bytes_read + 1);
        if (!new_buffer)
        {
            free(stdin_buffer);
            g_parsed_arguments.data_bytes = NULL; // Allocation failed
            g_parsed_arguments.data_size = 0;
            return;
        }
        stdin_buffer = new_buffer;
        memcpy(stdin_buffer + total_size, buffer, bytes_read);
        total_size += bytes_read;
    }
    g_parsed_arguments.data_size = total_size;
    g_parsed_arguments.data_bytes = stdin_buffer;
}

int main_parse_arguments(int argc, char *argv[])
{
    if (argc < 1 + 2)
    {
        printf("\nusage:\tfile_path data_offset [ride_length [ride_interval [madvise_interval]]]\n");
        printf("\ndata:\tread from stdin ( | or < )\n");
        return 0;
    }

    // file_path argv[1]
    if (access(argv[1], R_OK))
    {
        printf("\nfile_path: can not read %s \n", argv[1]);
        return 0;
    }
    g_parsed_arguments.file_path = argv[1];

    // data_offset argv[2]
    char *end_of_strtol;
    g_parsed_arguments.data_offset = strtol(argv[2], &end_of_strtol, 10);
    if (*end_of_strtol != '\0')
    {
        printf("\ndata_offset: not an integer %s\n", argv[2]);
        return 0;
    }
    FILE *data_file = fopen(g_parsed_arguments.file_path, "rb");
    fseek(data_file, 0, SEEK_END);
    g_file_size = ftell(data_file);
    g_parsed_arguments.file_size = g_file_size;
    long last_offset_of_file = g_parsed_arguments.file_size - 1;
    if (g_parsed_arguments.data_offset > last_offset_of_file)
    {
        printf("\ndata_offset: out of file %s, maximum is %ld\n", argv[2], last_offset_of_file);
        return 0;
    }

    // stdin
    main_parse_stdin();
    if (g_parsed_arguments.data_bytes == NULL)
    {
        perror("read stdin fail");
        exit(1);
    }

    long last_data_bytes_offset = g_parsed_arguments.data_offset + g_parsed_arguments.data_size - 1;
    int offsets_delta = last_data_bytes_offset - last_offset_of_file;
    if (offsets_delta > 0)
    {
        printf("\nlast data bytes offset: %ld (%ld && %d) out of file, maximum is %ld\n",
               last_data_bytes_offset,
               g_parsed_arguments.data_offset,
               g_parsed_arguments.data_size - 1,
               last_offset_of_file);
        printf("\t\t\tmaximum data bytes offset: %ld\n",
               last_offset_of_file - g_parsed_arguments.data_size + 1);
        return 0;
    }

    short last_data_incomplete_word_size = g_parsed_arguments.data_size % WORD_SIZE;
    if (last_data_incomplete_word_size)
    {
        printf("\ndata_size: %d is not a multiple of %d\n", g_parsed_arguments.data_size, WORD_SIZE);
        printf("\t   I can handle it!\n");
        printf("\t   last data \"word\" size is %d\n", last_data_incomplete_word_size);
        fseek(data_file, last_data_bytes_offset + 1, SEEK_SET);
        short missing_bytes_number = WORD_SIZE - last_data_incomplete_word_size;
        unsigned char missing_bytes[WORD_SIZE];
        short i;
        for (i = 0; i < WORD_SIZE; i++)
        {
            missing_bytes[i] = 0;
        }
        // if end of file missing_bytes_read can be < missing_bytes_size
        int missing_bytes_read = fread(missing_bytes, 1, missing_bytes_number, data_file);
        g_parsed_arguments.data_bytes = realloc(g_parsed_arguments.data_bytes,
                                                g_parsed_arguments.data_size + missing_bytes_number);
        memcpy(g_parsed_arguments.data_bytes + g_parsed_arguments.data_size,
               missing_bytes, missing_bytes_number);
        g_parsed_arguments.data_size += missing_bytes_number;
        last_data_bytes_offset = g_parsed_arguments.data_offset + g_parsed_arguments.data_size - 1;
        printf("\t   %d bytes of the file was added to last incomplete word\n",
               missing_bytes_read);
        if (missing_bytes_read < missing_bytes_number)
        {
            printf("\t   %d zeros was added to last incomplete word (EOF reached)\n", missing_bytes_number - missing_bytes_read);
        }
        printf("\t   data_size is now %d\n", g_parsed_arguments.data_size);
    }
    fclose(data_file);

    // to shift dummy bytes if last data word ovelap end of file
    offsets_delta = last_data_bytes_offset - last_offset_of_file;
    if (offsets_delta)
    {
        g_parsed_arguments.offsets_delta = offsets_delta;
    }
    else
    {
        g_parsed_arguments.offsets_delta = 0;
    }

    if (argc > 3)
    {
        g_ride_length = (int)strtol(argv[3], &end_of_strtol, 10);
        if (*end_of_strtol != '\0')
        {
            printf("\nride_length: not an integer %s\n", argv[3]);
            return 0;
        }
        if (argc > 4)
        {
            g_ride_interval = (short)strtol(argv[4], &end_of_strtol, 10);
            if (*end_of_strtol != '\0')
            {
                printf("\nride_interval: not an integer %s\n", argv[4]);
                return 0;
            }
            if (argc > 5)
            {
                g_madvise_interval = (short)strtol(argv[5], &end_of_strtol, 10);
                if (*end_of_strtol != '\0')
                {
                    printf("\nmadvise_interval: not an integer %s\n", argv[5]);
                    return 0;
                }
            }
        }
    }
    return 1;
}

int main_mmap_file()
{
    //  first 4ko of file to begin
    int file_descriptor;
    file_descriptor = open(g_parsed_arguments.file_path, O_RDONLY);
    // printf("\n%d", file_descriptor);
    gp_file_memory_mapping = mmap(
        NULL,
        // fc_memory_page_size,
        // 1, // 1 or  => sysconf(_SC_PAGE_SIZE) => 4ko
        g_parsed_arguments.file_size,
        PROT_READ,
        MAP_PRIVATE,
        file_descriptor,
        0
        // 4 * 1024 // OKAY
        // sysconf(_SC_PAGE_SIZE) // multiple
        // 50 MAP_FAILED
        //  g_parsed_arguments.data_offset
    );
    if (gp_file_memory_mapping == MAP_FAILED)
    {
        perror("MAP_FAILED");
        return 0;
    }
    return 1;
}
