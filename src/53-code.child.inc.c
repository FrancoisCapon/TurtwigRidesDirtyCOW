pthread_t madvise_thread;
pthread_create(&madvise_thread,
               NULL,
               child_do_madvise,
               NULL);
// parent take control to pokedata
// while madvise done by the other thread
ptrace(PTRACE_TRACEME);
raise(SIGSTOP);