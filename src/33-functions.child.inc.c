void *child_do_madvise(void *dummy_argument)
{
    while (1)
    {

        usleep(g_madvise_interval);
        madvise(
            gp_file_memory_mapping,
            // 1, // FC dont matter must be > 0 but only 4Ko
            g_file_size,
            MADV_DONTNEED);
        (*gp_madvise_count)++; // not *gp_madvise_count++ oups !!
    }
    //*gp_madvise_count = 123456;
}

/*
madv_dontneed all the page so lenght dont matter ?

Great question! When using madvise() with MADV_DONTNEED, the length absolutely matters—but the kernel will round it up to a multiple of the system's page size (usually 4 KB on x86 systems).

Exactly! Even though you specify a length of 1 byte in madvise(), the kernel rounds it up to the entire containing memory page.

If you want to discard all pages in a mapping, you must pass the full size of the mapping.
*/