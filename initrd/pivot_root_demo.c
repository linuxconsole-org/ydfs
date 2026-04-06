       /* pivot_root_demo.c */

       #define _GNU_SOURCE
       #include <err.h>
       #include <limits.h>
       #include <sched.h>
       #include <signal.h>
       #include <stdio.h>
       #include <stdlib.h>
       #include <sys/mman.h>
       #include <sys/mount.h>
       #include <sys/stat.h>
       #include <sys/syscall.h>
       #include <sys/wait.h>
       #include <unistd.h>

       static int
       pivot_root(const char *new_root, const char *put_old)
       {
           return syscall(SYS_pivot_root, new_root, put_old);
       }

       #define STACK_SIZE (1024 * 1024)

       static int              /* Startup function for cloned child */
       child(void *arg)
       {
           char        path[PATH_MAX];
           char        **args = arg;
           char        *new_root = args[0];
           const char  *put_old = "/oldrootfs";

           /* Ensure that 'new_root' and its parent mount don't have
              shared propagation (which would cause pivot_root() to
              return an error), and prevent propagation of mount
              events to the initial mount namespace.  */

           if (mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL) == -1)
               err(EXIT_FAILURE, "mount-MS_PRIVATE");

           /* Ensure that 'new_root' is a mount point.  */

           if (mount(new_root, new_root, NULL, MS_BIND, NULL) == -1)
               err(EXIT_FAILURE, "mount-MS_BIND");

           /* Create directory to which old root will be pivoted.  */

           snprintf(path, sizeof(path), "%s/%s", new_root, put_old);
           if (mkdir(path, 0777) == -1)
               err(EXIT_FAILURE, "mkdir");

           /* And pivot the root filesystem.  */

           if (pivot_root(new_root, path) == -1)
               err(EXIT_FAILURE, "pivot_root");

           /* Switch the current working directory to "/".  */

           if (chdir("/") == -1)
               err(EXIT_FAILURE, "chdir");

           /* Unmount old root and remove mount point.  */

           if (umount2(put_old, MNT_DETACH) == -1)
               perror("umount2");
           if (rmdir(put_old) == -1)
               perror("rmdir");

           /* Execute the command specified in argv[1]...  */

           execv(args[1], &args[1]);
           err(EXIT_FAILURE, "execv");
       }

       int
       main(int argc, char *argv[])
       {
           char *stack;

           /* Create a child process in a new mount namespace.  */

           stack = mmap(NULL, STACK_SIZE, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
           if (stack == MAP_FAILED)
               err(EXIT_FAILURE, "mmap");

           if (clone(child, stack + STACK_SIZE,
                     CLONE_NEWNS | SIGCHLD, &argv[1]) == -1)
               err(EXIT_FAILURE, "clone");

           /* Parent falls through to here; wait for child.  */

           if (wait(NULL) == -1)
               err(EXIT_FAILURE, "wait");

           exit(EXIT_SUCCESS);
       }
