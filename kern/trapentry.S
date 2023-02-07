/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>
#include <kern/macro.h>

#include <kern/picirq.h>


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
	.data;		\
		.quad name;			\
	.text;		\
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
	.data;					\
		.quad name;				\
	.text;		\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
  pushq $0;							\
	pushq $(num);							\
	jmp _alltraps


.data
	.globl handlers

handlers:
/*
 * Lab 3: Your code here for generating entry points for the different traps.
  Find the PUSHA,POPA macros in kern/macro.h. Since amd64 doesn't support
   pusha,popa so you will find these macros handy.
 */
	TRAPHANDLER_NOEC(TH_divide, T_DIVIDE)
	TRAPHANDLER_NOEC(TH_debug, T_DEBUG)
	TRAPHANDLER_NOEC(TH_nmi, T_NMI)
	TRAPHANDLER_NOEC(TH_brkpt, T_BRKPT)
	TRAPHANDLER_NOEC(TH_oflow, T_OFLOW)
	TRAPHANDLER_NOEC(TH_bound, T_BOUND)
	TRAPHANDLER_NOEC(TH_illop, T_ILLOP)
	TRAPHANDLER_NOEC(TH_device, T_DEVICE)
	TRAPHANDLER(TH_dblflt, T_DBLFLT)
	TRAPHANDLER_NOEC(TH_coproc, 9)
	TRAPHANDLER(TH_tss, T_TSS)
	TRAPHANDLER(TH_segnp, T_SEGNP)
	TRAPHANDLER(TH_stack, T_STACK)
	TRAPHANDLER(TH_gpflt, T_GPFLT)
	TRAPHANDLER(TH_pgflt, T_PGFLT)
	TRAPHANDLER_NOEC(TH_res, 15)
	TRAPHANDLER_NOEC(TH_fperr, T_FPERR)
	TRAPHANDLER(TH_align, T_ALIGN)
	TRAPHANDLER_NOEC(TH_mchk, T_MCHK)
	TRAPHANDLER_NOEC(TH_simderr, T_SIMDERR)
	TRAPHANDLER_NOEC(TH_syscall, T_SYSCALL)
	TRAPHANDLER_NOEC(TH_default, T_DEFAULT)

	//TRAPHANDLER_NOEC(TH_irq_offset,  IRQ_OFFSET)
	TRAPHANDLER_NOEC(TH_irq_timer, IRQ_OFFSET + IRQ_TIMER)
	TRAPHANDLER_NOEC(TH_irq_kbd,  IRQ_OFFSET + IRQ_KBD)
	TRAPHANDLER_NOEC(TH_irq_2, IRQ_OFFSET + 2)
	TRAPHANDLER_NOEC(TH_irq_3, IRQ_OFFSET + 3)
	TRAPHANDLER_NOEC(TH_irq_serial,  IRQ_OFFSET + IRQ_SERIAL)
	TRAPHANDLER_NOEC(TH_irq_5, IRQ_OFFSET + 5)
	TRAPHANDLER_NOEC(TH_irq_6, IRQ_OFFSET + 6)
	TRAPHANDLER_NOEC(TH_irq_spurious,  IRQ_OFFSET + IRQ_SPURIOUS)
	TRAPHANDLER_NOEC(TH_irq_8, IRQ_OFFSET + 8)
	TRAPHANDLER_NOEC(TH_irq_9, IRQ_OFFSET + 9)
	TRAPHANDLER_NOEC(TH_irq_10, IRQ_OFFSET + 10)
	TRAPHANDLER_NOEC(TH_irq_11, IRQ_OFFSET + 11)
	TRAPHANDLER_NOEC(TH_irq_12, IRQ_OFFSET + 12)
	TRAPHANDLER_NOEC(TH_irq_13, IRQ_OFFSET + 13)
	TRAPHANDLER_NOEC(TH_irq_ide,  IRQ_OFFSET + IRQ_IDE)
	TRAPHANDLER_NOEC(TH_irq_15, IRQ_OFFSET + 15)
	//TRAPHANDLER_NOEC(TH_irq_error,  IRQ_OFFSET + IRQ_ERROR)
/*
 * Lab 3: Your code here for _alltraps
 *
 * Hint: Be sure to review the x64 calling convention from lab1
 *       for how to pass a pointer to the trapframe.
 */

.globl sysenter_handler
.type sysenter_handler, @function
.align 2
sysenter_handler:
	/*push $0x0
	push %rdi
	push %rbx
	push %rcx
	push %rdx
	push %rax*/
	//int $3
  //PUSHA
	push %r14
	push %rbp
	call syscall
	pop %rbp
	pop %r14
	//int $3
	//add $0x18, %rsp
	mov %r14, %rdx
	mov %rbp, %rcx
	//int $3
	sysexit

_alltraps:
subq $16, %rsp
mov %ds, 8(%rsp)
mov %es, 0(%rsp)
PUSHA
mov %rsp, %rdi
push %r15
xor %r15, %r15
mov $(GD_KD), %r15
mov %r15, %ds
mov %r15, %es
pop %r15
call trap
