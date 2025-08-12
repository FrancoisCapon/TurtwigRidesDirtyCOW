// setbuf(stdout, NULL); // gcc -pthread main.c -lrt
setbuf(stdout, NULL); // gcc -pthread main.c -lrt
// https://ascii.co.uk/art/computer
printf("\nMain check arguments\n");

g_memory_page_size = sysconf(_SC_PAGE_SIZE);
gp_madvise_count = mmap(NULL, sizeof(long),
                        PROT_READ | PROT_WRITE,
                        MAP_SHARED | MAP_ANONYMOUS,
                        -1, 0);

*gp_madvise_count = 0;

if (!(main_parse_arguments(argc, argv) &&
      main_mmap_file()))
{
    printf("\n      //@@\n");
    printf("     @@-OO)\n");
    printf("    @@@ ^ @    _____\n");
    printf("    /  \\ / \\  |\\____\\\n");
    printf("   /  ( X ) | | |   |\n");
    printf("<___=\\      | | |   |\n");
    printf("      \\======\\ \\|_\"_|\n");
    printf("                  (____\n\n");
    exit(1);
} else {
    printf("\n      //@@\n");
    printf("     @@-OO)\n");
    printf("    @@@ v @    _____\n");
    printf("    /  \\ / \\  |\\____\\\n");
    printf("   /  ( X ) | | |   |\n");
    printf("<___=\\      | | |   |\n");
    printf("      \\======\\ \\|_\"_|\n");
    printf("                  (____\n");
}
