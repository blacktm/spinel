# Shared build configuration for Spinel.
#
# Included by ./Makefile (the C compiler + test/bench harness). Keep only
# toolchain-level knobs here; target rules live in the Makefile.

# Machine-local overrides (gitignored). Lets a developer set OPT/CC/etc.
# without editing committed defaults. A command-line `make VAR=...` still wins.
-include $(dir $(lastword $(MAKEFILE_LIST)))local.mk

CC       ?= cc
# Auto-wrap CC with sccache or ccache when present. Skip when CC is
# already wrapped — the substring guard catches both "ccache" and
# "sccache" since "ccache" is a substring of "sccache", so CI's
# `CC=sccache <cc>` env stays untouched. NO_CCACHE=1 opts out.
# `override` is required so that a command-line `make CC=gcc` is also
# wrapped — without it the wrap would be silently ignored.
ifeq (,$(findstring ccache,$(CC)))
ifeq (,$(NO_CCACHE))
  CCACHE_BIN := $(shell command -v sccache 2>/dev/null || command -v ccache 2>/dev/null)
  ifneq (,$(CCACHE_BIN))
    override CC := $(CCACHE_BIN) $(CC)
  endif
endif
endif

# Optimization level for the C compiles driven by the test/bench harness
# (each .rb gets parsed → codegen → cc'd → run). CI overrides this to -O0
# to cut cc time; locally -O2 keeps the test binaries reasonable-speed.
# `-Wno-alloc-size-larger-than` silences a gcc 13+ paranoia warning on the
# inlined `h->cap *= 2` in sp_*Hash_grow; `-Wno-unknown-warning-option`
# keeps clang (which lacks that flag) from turning it into a -Werror fail.
# `-Wno-format-truncation` silences gcc's FORTIFY-driven paranoia on benign
# `snprintf(buf, sizeof buf, "@%s", name)` ivar/path builds (the buffers are
# sized for real identifiers; the warning fires independently of -Wall under
# _FORTIFY_SOURCE, so -Wno-all does not cover it). clang lacks the flag and
# ignores it via -Wno-unknown-warning-option above.
OPT     ?= $(COPT)
# String#crypt is libc crypt(3): glibc keeps it in libcrypt (macOS has it in
# libSystem). --as-needed drops the DSO when a program never calls it.
ifeq ($(shell uname -s),Linux)
LDFLAGS += -lcrypt
endif
CFLAGS   = $(OPT) -Wno-all -Wno-unknown-warning-option -Wno-alloc-size-larger-than -Wno-format-truncation

# The product build -- bin/spinel, libspinel_rt.a, and the generated
# programs -- uses CFLAGS and never used LTO, so there is no LTO toggle.

# Per-function sections let the linker strip unused bigint/regexp code.
SEC_FLAGS = -ffunction-sections -fdata-sections
# Apple ld64 spells dead-code stripping --dead_strip; GNU ld --gc-sections.
ifeq ($(shell uname -s),Darwin)
  GC_FLAGS = -Wl,-dead_strip
else
  GC_FLAGS = -Wl,--gc-sections
endif

# `timeout` is GNU coreutils on Linux, `gtimeout` on macOS (brew coreutils).
# Busybox also ships a `timeout` applet with a different syntax
# (`-t SECS PROG ARGS` instead of `SECS PROG ARGS`). Pick the form that
# works: probe with `timeout 1 sh -c true`; if it succeeds, the GNU form
# is available; if it fails with "can't execute", busybox is the only
# `timeout` on PATH and we need `-t SECS`. If no `timeout` is found, run
# without limits. The result is the full prefix including the duration
# argument (e.g. `timeout 10`), so callers can append the command directly.
TIMEOUT_BIN := $(shell { timeout 1 sh -c true; } 2>/dev/null >/dev/null && echo 'timeout 1' || \
           { command -v timeout >/dev/null && echo 'timeout -t 1'; } || \
           { command -v gtimeout >/dev/null && gtimeout 1 sh -c true && echo 'gtimeout 1'; } || echo '')
TIMEOUT10 := $(if $(TIMEOUT_BIN),$(subst 1,10,$(TIMEOUT_BIN)),)
TIMEOUT60 := $(if $(TIMEOUT_BIN),$(subst 1,60,$(TIMEOUT_BIN)),)

# Default to a parallel build at the logical CPU count, unless the
# invocation already asked for a job count. Applied ONLY at the top level
# (MAKELEVEL 0): a sub-make inherits the parent's jobserver, and forcing
# -j again in a sub-make's MAKEFLAGS triggers GNU Make's "-j forced in
# makefile: resetting jobserver mode" warning (the --jobserver-auth flag
# isn't visible in MAKEFLAGS at sub-make parse time, so a plain -j guard
# can't see it — MAKELEVEL is the reliable discriminator). A command-line
# -jN still wins by precedence; the env form `MAKEFLAGS=-jN` is honored
# by the inner guard.
ifeq ($(MAKELEVEL),0)
ifeq (,$(filter -j%,$(MAKEFLAGS))$(findstring j,$(firstword -$(MAKEFLAGS))))
  MAKEFLAGS += -j$(shell getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)
endif
endif

# Reference Ruby for test/bench output comparison. Override on the command
# line to use a freshly-built interpreter, e.g. `REF_RUBY=miniruby make test`.
REF_RUBY ?= ruby
