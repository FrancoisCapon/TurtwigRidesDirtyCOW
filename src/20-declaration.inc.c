int g_memory_page_size;
long g_file_size;

short g_madvise_interval = 3;
short g_ride_interval = 1;
// int g_ride_length = 256;
int g_ride_length = 512;

void *gp_file_memory_mapping;

typedef struct
{
    char *file_path;
    long file_size;
    short file_size_dont_fits_words;

    long data_offset;
    int data_size;
    unsigned char *data_bytes;
    
    int offsets_delta;

} struct_parsed_arguments;

struct_parsed_arguments g_parsed_arguments;

long *gp_madvise_count;
long g_pokedata_count;

/*
Prefix	Purpose	Example
g_	Indicates a global variable	g_counter
gp_	Global pointer	gp_buffer
gk_	Global constant (sometimes used)	gk_max_value
s_	Static global (file scope only)	s_config
m_	Module-level variable (used in some styles)	m_status
*/