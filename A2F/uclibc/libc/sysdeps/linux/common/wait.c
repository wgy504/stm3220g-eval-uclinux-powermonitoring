/*
 * Copyright (C) 2000-2006 Erik Andersen <andersen@uclibc.org>
 *
 * Licensed under the LGPL v2.1, see the file COPYING.LIB in this tarball.
 */

#include <stdlib.h>
#include <syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/resource.h>

#ifdef __LINUXTHREADS_OLD__
extern __typeof(wait) weak_function wait;
strong_alias(wait,__libc_wait)
#endif

/* Wait for a child to die.  When one does, put its status in *STAT_LOC
 * and return its process ID.  For errors, return (pid_t) -1.  */
__pid_t wait(__WAIT_STATUS_DEFN stat_loc)
{
	return wait4(WAIT_ANY, stat_loc, 0, NULL);
}
