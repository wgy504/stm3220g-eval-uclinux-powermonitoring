/* Misc system-specific crap */

#ifndef _PORTING_H_
#define _PORTING_H_

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <sys/types.h>

#ifdef __LDSO_LDD_SUPPORT__
# include <sys/wait.h>
#endif

#if defined(_WIN32) || defined(_WINNT)
# include "mmap-windows.c"
#else
# include <sys/mman.h>
#endif

#include <link.h>
/* makefile will include elf.h for us */

#include "bswap.h"
#include "dl-defs.h"

#ifdef DMALLOC
#include <dmalloc.h>
#endif

/* For SunOS */
#ifndef PATH_MAX
#define PATH_MAX _POSIX_PATH_MAX
#endif

#ifndef UCLIBC_RUNTIME_PREFIX
# define UCLIBC_RUNTIME_PREFIX "/"
#endif

#undef UCLIBC_ENDIAN_HOST
#define UCLIBC_ENDIAN_LITTLE 1234
#define UCLIBC_ENDIAN_BIG    4321
#if defined(BYTE_ORDER)
# if BYTE_ORDER == LITTLE_ENDIAN
#  define UCLIBC_ENDIAN_HOST UCLIBC_ENDIAN_LITTLE
# elif BYTE_ORDER == BIG_ENDIAN
#  define UCLIBC_ENDIAN_HOST UCLIBC_ENDIAN_BIG
# endif
#elif defined(__BYTE_ORDER)
# if __BYTE_ORDER == __LITTLE_ENDIAN
#  define UCLIBC_ENDIAN_HOST UCLIBC_ENDIAN_LITTLE
# elif __BYTE_ORDER == __BIG_ENDIAN
#  define UCLIBC_ENDIAN_HOST UCLIBC_ENDIAN_BIG
# endif
#endif
#if !defined(UCLIBC_ENDIAN_HOST)
# error "Unknown host byte order!"
#endif

#endif
