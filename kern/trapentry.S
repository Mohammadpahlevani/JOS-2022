/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>
#include <kern/macro.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushq $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushq $0;							\
	pushq $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
   Find the PUSHA,POPA macros in kern/macro.h. Since amd64 doesn't support
   pusha,popa so you will find these macros handy.
 */
 
	/* whether or not to use error code found here:
	 * www3.cs.stonybrook.edu/~porter/courses/cse506/f14/ref/i386/s09_10.htm
	 */
        TRAPHANDLER_NOEC(handleDivideError, T_DIVIDE)
	TRAPHANDLER_NOEC(handleDebugException, T_DEBUG)
	TRAPHANDLER_NOEC(handleNonMaskableInterrupt, T_NMI)
	TRAPHANDLER_NOEC(handleBreakpoint, T_BRKPT)
	TRAPHANDLER_NOEC(handleOverflow, T_OFLOW)
	TRAPHANDLER_NOEC(handleBoundsCheck, T_BOUND)
	TRAPHANDLER_NOEC(handleIllegalOpcode, T_ILLOP)
	TRAPHANDLER_NOEC(handleDeviceNotAvailable, T_DEVICE)
	TRAPHANDLER(handleDoubleFault, T_DBLFLT)
	TRAPHANDLER(handleInvalidTaskSwitchSegment, T_TSS)
	TRAPHANDLER(handleSegmentNotPresent, T_SEGNP)
	TRAPHANDLER(handleStackException, T_STACK)
	TRAPHANDLER(handleGeneralProtectionFault, T_GPFLT)
	TRAPHANDLER(handlePageFault, T_PGFLT)
	TRAPHANDLER_NOEC(handleFloatingPointError, T_FPERR)
	TRAPHANDLER(handleAligmentCheck, T_ALIGN)
	TRAPHANDLER_NOEC(handleMachineCheck, T_MCHK)
	TRAPHANDLER_NOEC(handleSIMDFloatingPointError, T_SIMDERR)
	TRAPHANDLER_NOEC(handleSystemCall, T_SYSCALL)
	TRAPHANDLER_NOEC(handleCatchall, T_DEFAULT)




/*
 * Lab 3: Your code here for _alltraps
 *
 * Hint: Be sure to review the x64 calling convention from lab1
 *       for how to pass a pointer to the trapframe.
 */

_alltraps:
		 
	subq $16, %rsp
	movq $0, 0(%rsp)
	movq $0, 8(%rsp)
	movw %es, 0(%rsp)
	movw %ds, 8(%rsp)
	PUSHA
	
	movw $GD_KD, %ax
	movw %ax, %ds
	movw %ax, %es
	
	movq %rsp, %rdi
	call trap



