// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/dwarf.h>
#include <kern/kdebug.h>
#include <kern/dwarf_api.h>
#include <kern/trap.h>
#include <kern/pmap.h>
#include <kern/env.h>
#define CMDBUF_SIZE	80	// enough for one VGA text line

#define BLACK "\x1b[30m"
#define RED "\x1b[31m"
#define GREEN "\x1b[32m"
#define YELLOW "\x1b[33m"
#define BLUE "\x1b[34m"
#define MAGNETA "\x1b[35m"
#define CYAN "\x1b[36m"
#define WHITE "\x1b[37m"
#define RESET "\x1b[0m"

static const char *const names_of_regs[] =
{
	"rax", "rdx", "rcx", "rbx",
	"rsi", "rdi", "rbp", "rsp",
	"r8",  "r9",  "r10", "r11",
	"r12", "r13", "r14", "r15",
	"rip",
	"xmm0",  "xmm1",  "xmm2",  "xmm3",
	"xmm4",  "xmm5",  "xmm6",  "xmm7",
	"xmm8",  "xmm9",  "xmm10", "xmm11",
	"xmm12", "xmm13", "xmm14", "xmm15",
	"st0", "st1", "st2", "st3",
	"st4", "st5", "st6", "st7",
	"mm0", "mm1", "mm2", "mm3",
	"mm4", "mm5", "mm6", "mm7",
	"rflags",
	"es", "cs", "ss", "ds", "fs", "gs", NULL, NULL,
	"fs.base", "gs.base", NULL, NULL,
	"tr", "ldtr",
	/* "mxcsr", "fcw", "fsw" */
};


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Stack backtrace", mon_backtrace },
	{ "showmm", "Show memory mappings", mon_showmm},
	{ "setperm", "Set the permission bits of page table entries", mon_setperm},
	{ "dumpm", "Dump the words of a memory range", mon_dumpm},
	{ "continue", "Continue from breakpoint", mon_continue},
	{ "si", "Single step from the breakpoint", mon_si},
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/

pml4e_t* get_pml4e(){
	if(curenv->env_status == ENV_RUNNING)
		return curenv->env_pml4e;
	else
		return boot_pml4e;
}
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

/*
uint64_t read_rdi_from_info(struct Ripdebuginfo info) {
	return info.reg_table.rules[5].dw_regnum;
}
*/

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	//cprintf("mon_backtrace(%016x %016x %016x)\n", argc, argv, tf);
	// Your code here.
	uint64_t rip, *rbp;
	read_rip(rip);
	rbp = (uint64_t *) read_rbp();
	cprintf("Stack backtrace:\n");
	while (rbp) {
		cprintf("  rbp %016x  rip %016x\n", rbp, rip);

		// print debuginfo_rip()
		char* rbpc = (char*) rbp;

		struct Ripdebuginfo info;
		debuginfo_rip((uintptr_t) rip, &info);

		cprintf("       %s:%d: %s+%016x  args:%d",
			info.rip_file, info.rip_line, info.rip_fn_name, rip - info.rip_fn_addr, info.rip_fn_narg);
int i;
		for ( i = 0; i < info.rip_fn_narg; ++ i) {
			char* arg_start = &rbpc[info.reg_table.cfa_rule.dw_offset + info.offset_fn_arg[i]];
			if (info.size_fn_arg[i] == 8) {
				cprintf("  %016x", *(uint64_t *) arg_start);
			} else if (info.size_fn_arg[i] == 4) {
				cprintf("  %016x", *(uint32_t *) arg_start);
			}
			else cprintf("  %016x", *arg_start);
		}

    cprintf("\n");
/*
		for (int i = 0; i < info.rip_fn_narg; ++ i) {
			cprintf("  %016x", rbpc[info.reg_table.cfa_rule.dw_offset + info.offset_fn_arg[i]]);
		}
		cprintf("\nCFA: reg %s off %d\n",
			names_of_regs[info.reg_table.cfa_rule.dw_regnum],
			info.reg_table.cfa_rule.dw_offset);
*/
		rip = rbp[1];
		rbp = (uint64_t *) *rbp;
	}
	return 0;
}


int
mon_showmm(int argc, char **argv, struct Trapframe *tf){
	if(argc < 3){
		cprintf("Usage: showmm [va_start] [va_end]\n");
		return 1;
	}
	uintptr_t start = strtol(argv[1], 0, 16), end = strtol(argv[2], 0, 16);
	pte_t* pte;
	pml4e_t* pml4e = get_pml4e();
	cprintf("        VA                  PA            PTE_U   PTE_W   PTE_P\n");
uintptr_t va;
	for(va = ROUNDDOWN(start, PGSIZE); va < ROUNDUP(end + 1, PGSIZE); va += PGSIZE){
		cprintf("0x%016x  ", va);
		if(!page_lookup(pml4e, (void *)va, &pte)){
			cprintf("        -               -       -       -\n");
		} 
		else{
			cprintf("0x%016x      %d       %d       %d\n", PTE_ADDR(*pte), !!(*pte & PTE_U), !!(*pte & PTE_W), !!(*pte & PTE_P));
		}
	}
	return 0;
}


int
mon_setperm(int argc, char **argv, struct Trapframe *tf){
	if(argc < 3){
		cprintf("Usage: setperm [null|-u|-w|-p] va [all bits|one bit]\n");
		cprintf("The 4th need three bits if you choose null for the 2nd parameter, and need only one if you choose the others.\n");
	}
	pml4e_t* pml4e = get_pml4e();
	uintptr_t va;
	pte_t *pte;
	if(argc == 3){
		va = strtol(argv[1], NULL, 16);
		int bits = strtol(argv[2], NULL, 2);
		if(!page_lookup(pml4e, (void *)va, &pte)){
			cprintf("Pte not existed!\n");
			return 1;
		}
		*pte = ((*pte) & (~0x7)) | bits;
	}
	else if(argc == 4){
		char* para = argv[1];
		if(para[0] != '-'){
			cprintf("Usage: setperm [null|-u|-w|-p] va [all bits|one bit]\n");
			return 1;
		}
		va = strtol(argv[2], NULL, 16);
		int bit = strtol(argv[3], NULL, 2);
		if(!page_lookup(pml4e, (void *)va, &pte)){
			cprintf("Pte not existed!\n");
			return 1;
		}	
		if(para[1] == 'u'){
			*pte = ((*pte) & (~PTE_U)) | (bit << 2);
		} 
		else if(para[1] == 'w'){
			*pte = ((*pte) & (~PTE_W)) | (bit << 1);
		}
		else if(para[1] == 'p'){
			*pte = ((*pte) & (~PTE_P)) | bit;
		}
		else{
			cprintf("Usage: setperm [null|-u|-w|-p] va [all bits|one bit]\n");
			return 1;
		}
	}
	return 0;
}

int
mon_dumpm(int argc, char **argv, struct Trapframe *tf){
	if(argc < 3){
		cprintf("Usage: dumpmm [-v|-p] start end\n");
		return 1;
	}
	char* para = argv[1];
	if(para[0] != '-' || (para[1] != 'v' && para[1] != 'p')){
		cprintf("Usage: dumpmm [-v|-p] start end\n");
		return 1;
	}
	pml4e_t* pml4e = get_pml4e();
	uintptr_t offset = para[1] == 'v' ? 0 : KERNBASE;
	uintptr_t start = ROUNDDOWN(strtol(argv[2], NULL, 16) + offset, 4), end = argc == 3 ? start + 1 : ROUNDDOWN(strtol(argv[3], NULL, 16) + offset - 1, 4);
  int count = ((end - start) >> 2) + 1;
	cprintf("Memory dump of [%s, %s), word aligned:", argv[2], argv[3]);
//	for(uint32_t* p = start;p <= end; p++){
	//	cprintf("%016x: %08x\n", (uintptr_t)p - offset, *p);
	//}
	pte_t * pte;
int i;
	for( i = 0; i < count; i++){
		uint32_t* va = ((uint32_t*) start) + i;
		if(i % 8 == 0)
			cprintf("\n%016x", (uintptr_t)va - offset);
		if(!page_lookup(pml4e, va, &pte)){
			cprintf(" --------");
		} 
		else{
			cprintf(" %08x", *va);
		}
	}
	cprintf("\n");
	return 0;
}


int
mon_continue(int argc, char **argv, struct Trapframe *tf){
	if(!tf){
		cprintf("No env running\n");
		return 0;
	} else{
		tf->tf_eflags &= ~FL_TF;
		env_run(curenv);
		panic("Env unsucessfully exited\n");
		return -1;
	}
}
int
mon_si(int argc, char **argv, struct Trapframe *tf){
	if(!tf){
		cprintf("No env running\n");
		return 0;
	} else{
		tf->tf_eflags |= FL_TF;
		cprintf("Step at 0x%016x: %016x\n", tf->tf_rip, *(uint64_t*)(tf->tf_rip));
		env_run(curenv);
		panic("Env unsucessfully exited\n");
		return -1;
	}
}
/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	//cprintf("runcmd(%016x, %016x)\n", buf, tf);
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	cprintf(RED "RED" GREEN"GREEN"YELLOW"YELLOW"BLUE"BLUE"MAGNETA"MAGNETA"CYAN"CYAN\n" RESET);
	if (tf != NULL)
		print_trapframe(tf);
	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
