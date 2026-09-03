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
    fputs("usage: spinel-timeout SECONDS COMMAND [ARG...]\n", stderr);
    return 2;
  }
  long secs = atol(argv[1]);
  if (secs <= 0) secs = 1;

  pid_t pid = fork();
  if (pid < 0) { perror("fork"); return 1; }
  if (pid == 0) {
    /* child: the alarm is armed in the PARENT after this fork, so there is
       nothing pending here; put SIGALRM back to its default in case the
       command inherits an expectation about it. */
    struct sigaction dfl = {0};
    dfl.sa_handler = SIG_DFL;
    sigaction(SIGALRM, &dfl, NULL);
    execvp(argv[2], argv + 2);
    perror("execvp");
    _exit(127);
  }

  /* Arm AFTER the fork: armed before it, an alarm that fired in the window
     between alarm() and fork() would set timed_out with no child to blame. */
  struct sigaction sa = {0};
  sa.sa_handler = on_alarm;   /* no SA_RESTART: the wait below must be cut short */
  sigaction(SIGALRM, &sa, NULL);
  alarm((unsigned)secs);

  /* The alarm has to END the wait, not just interrupt it. Retrying waitpid on
     every EINTR -- which is what a plain `while (waitpid(...) < 0 && errno ==
     EINTR)` does -- goes straight back to waiting, so the child runs to
     completion and the wrapper reports 124 having enforced nothing: a 15s
     sleep under a 2s limit took 15s and then said it had timed out. `reaped`
     is what tells the two apart, rather than timed_out, so a child that exits
     in the same instant the alarm fires still reports its own status. */
  int status = 0, reaped = 0;
  for (;;) {
    pid_t r = waitpid(pid, &status, 0);
    if (r == pid) { reaped = 1; break; }
    if (r < 0 && errno == EINTR) { if (timed_out) break; continue; }
    break;   /* ECHILD or another error: nothing left to wait for */
  }
  alarm(0);

  if (!reaped) {
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
