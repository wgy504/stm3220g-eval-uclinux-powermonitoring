/* Adapted from glibc */
/* Copyright (C) 1996, 1997 Free Software Foundation, Inc. */

/* clone is even more special than fork as it mucks with stacks
   and invokes a function in the right context after its all over.  */

#define _ERRNO_H
#include <features.h>
#include <bits/errno.h>
#include <sys/syscall.h>
#include "m68k_pic.S"

/* int _clone(int (*fn)(void *arg), void *child_stack, int flags, void *arg); */

.text
.align 4
.type	clone,@function
.globl	clone;
clone:
	/* Sanity check arguments.  */
	movel   #-EINVAL, %d0
	movel   4(%sp), %d1             /* no NULL function pointers */
	movel	%d1, %a0
	tstl    %d1
	beq.w	__syscall_error_trampoline
	movel   8(%sp), %d1             /* no NULL stack pointers */
	movel	%d1, %a1
	tstl    %d1
	beq.w   __syscall_error_trampoline

	/* Allocate space and copy the argument onto the new stack.  */
	movel   16(%sp), -(%a1)

	/* Do the system call */
#if 1 /* defined (CONFIG_COLDFIRE) */
	movel   %d2, %d1                /* save %d2 and get stack pointer */
	movel   %a1, %d2
	movel   %d1, %a1
#else
	exg     %d2, %a1                /* save %d2 and get stack pointer */
#endif
	movel   12(%sp), %d1            /* get flags */
	movel   #__NR_clone, %d0
	trap    #0
#if 1 /* defined (CONFIG_COLDFIRE) */
	movel   %d2, %d1                /* restore %d2 */
	movel   %a1, %d2
	movel   %d1, %a1
#else
	exg     %d2, %a1                /* restore %d2 */
#endif

	tstl    %d0
	bmi.w   __syscall_error_trampoline
	beq.w   thread_start

	rts

thread_start:
	/*subl    %fp, %fp*/        /* terminate the stack frame */
	jsr     (%a0)
	movel   %d0, -(%sp)
	movel	#__NR_exit, %d0
	trap	#0
	/*jsr    exit*/
.Lthread_start_end:

__syscall_error_trampoline:
	JUMP	__syscall_error,%a0

/* DWARF information to prevent unwinding past the frame
   corresponding to thread_start.  */

	.section	.debug_frame, "", @progbits
.Lcie_start:
	.long	.Lcie_body_end - .Lcie_body_start /* Size of CIE block body */
.Lcie_body_start:
	.long	0xffffffff	/* CIE identifier tag */
	.byte	0x1		/* CIE version */
	.ascii	"\0"		/* CIE augmentation */
	.uleb128 0x1		/* CIE code alignment factor */
	.sleb128 0x1		/* CIE data alignment factor */
	.byte	25		/* CIE return address column */
	.byte	0xc		/* DW_CFA_def_cfa */
	.uleb128 0x0
	.uleb128 0x0
	.byte	0x7		/* DW_CFA_undefined */
	.byte	25		/* Column to match with above */
	.align 4
.Lcie_body_end:

.Lfde_start:
	.long	.Lfde_body_end - .Lfde_body_start /* Size of FDE block body */
.Lfde_body_start:
	.long	.Lcie_start	/* CIE position */
	.long	thread_start	/* Code start address */
	.long	.Lthread_start_end - thread_start	/* Code size */

.Lfde_body_end:

