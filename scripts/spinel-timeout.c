/* spinel-timeout: a minimal timeout wrapper.
 *
 * GNU coreutils' `timeout` returns 124 when the command runs past the
 * duration. Busybox's applet and other implementations return different
 * values (143 = 128+SIGTERM, or 399 on some BSDs). The Makefile's bench
 * target keys on 124 to mark a benchmark as SKIP, so it needs a uniform
 * exit code regardless of which `timeout` is on PATH.
 *
 * Usage: spinel-timeout SECONDS COMMAND [ARG...]
 *
 * Implementation: fork, exec the child, arm SIGALRM for SECONDS. If the
 * child is still running when the alarm fires, send SIGTERM and wait
 * for it to exit (or SIGKILL after a grace period). The wrapper returns
 * 124 on timeout, otherwise the child's exit status.
 *
 * No dependencies beyond POSIX.1-2001 (fork, exec, kill, sigaction,
 * alarm, waitpid). */

#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <time.h>

static volatile sig_atomic_t timed_out;

static void on_alarm(int sig) {
  (void)sig;
  timed_out = 1;
}

int main(int argc, char **argv) {
  if (argc < 3) {
    const char *u = "usage: spinel-timeout SECONDS COMMAND [ARG...]\n";
    write(2, u, strlen(u));
    return 2;
  }
  long secs = atol(argv[1]);
  if (secs <= 0) secs = 1;

  struct sigaction sa = {0};
  sa.sa_handler = on_alarm;
  sigaction(SIGALRM, &sa, NULL);
  alarm((unsigned)secs);

  pid_t pid = fork();
  if (pid < 0) { perror("fork"); return 1; }
  if (pid == 0) {
    /* child: reset alarm disposition, exec the command */
    alarm(0);
    struct sigaction dfl = {0};
    dfl.sa_handler = SIG_DFL;
    sigaction(SIGALRM, &dfl, NULL);
    execvp(argv[2], argv + 2);
    perror("execvp");
    _exit(127);
  }

  int status;
  while (waitpid(pid, &status, 0) < 0 && errno == EINTR) {}

  if (timed_out) {
    /* give the child a moment to exit on SIGTERM, then force it */
    kill(pid, SIGTERM);
    struct timespec grace = {0, 100 * 1000 * 1000};  /* 100ms */
    nanosleep(&grace, NULL);
    kill(pid, SIGKILL);
    while (waitpid(pid, &status, 0) < 0 && errno == EINTR) {}
    return 124;
  }

  if (WIFEXITED(status)) return WEXITSTATUS(status);
  if (WIFSIGNALED(status)) return 128 + WTERMSIG(status);
  return 1;
}
