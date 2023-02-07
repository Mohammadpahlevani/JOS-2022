
obj/user/idle:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 36 00 00 00       	callq  800077 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800052:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800059:	00 00 00 
  80005c:	48 ba 80 1a 80 00 00 	movabs $0x801a80,%rdx
  800063:	00 00 00 
  800066:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800069:	48 b8 ca 02 80 00 00 	movabs $0x8002ca,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	}
  800075:	eb f2                	jmp    800069 <umain+0x26>

0000000000800077 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800077:	55                   	push   %rbp
  800078:	48 89 e5             	mov    %rsp,%rbp
  80007b:	48 83 ec 20          	sub    $0x20,%rsp
  80007f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800082:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800086:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80008d:	00 00 00 
  800090:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  800097:	48 b8 8c 02 80 00 00 	movabs $0x80028c,%rax
  80009e:	00 00 00 
  8000a1:	ff d0                	callq  *%rax
  8000a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  8000a6:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  8000ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b0:	48 63 d0             	movslq %eax,%rdx
  8000b3:	48 89 d0             	mov    %rdx,%rax
  8000b6:	48 c1 e0 03          	shl    $0x3,%rax
  8000ba:	48 01 d0             	add    %rdx,%rax
  8000bd:	48 c1 e0 05          	shl    $0x5,%rax
  8000c1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000c8:	00 00 00 
  8000cb:	48 01 c2             	add    %rax,%rdx
  8000ce:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000d5:	00 00 00 
  8000d8:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000db:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000df:	7e 14                	jle    8000f5 <libmain+0x7e>
		binaryname = argv[0];
  8000e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e5:	48 8b 10             	mov    (%rax),%rdx
  8000e8:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000ef:	00 00 00 
  8000f2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000f5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000fc:	48 89 d6             	mov    %rdx,%rsi
  8000ff:	89 c7                	mov    %eax,%edi
  800101:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800108:	00 00 00 
  80010b:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  80010d:	48 b8 1b 01 80 00 00 	movabs $0x80011b,%rax
  800114:	00 00 00 
  800117:	ff d0                	callq  *%rax
}
  800119:	c9                   	leaveq 
  80011a:	c3                   	retq   

000000000080011b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011b:	55                   	push   %rbp
  80011c:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80011f:	bf 00 00 00 00       	mov    $0x0,%edi
  800124:	48 b8 48 02 80 00 00 	movabs $0x800248,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
}
  800130:	5d                   	pop    %rbp
  800131:	c3                   	retq   

0000000000800132 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800132:	55                   	push   %rbp
  800133:	48 89 e5             	mov    %rsp,%rbp
  800136:	53                   	push   %rbx
  800137:	48 83 ec 48          	sub    $0x48,%rsp
  80013b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80013e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800141:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800145:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800149:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80014d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800151:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800154:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800158:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80015c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800160:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800164:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800168:	4c 89 c3             	mov    %r8,%rbx
  80016b:	cd 30                	int    $0x30
  80016d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800171:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800175:	74 3e                	je     8001b5 <syscall+0x83>
  800177:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80017c:	7e 37                	jle    8001b5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80017e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800182:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800185:	49 89 d0             	mov    %rdx,%r8
  800188:	89 c1                	mov    %eax,%ecx
  80018a:	48 ba 8f 1a 80 00 00 	movabs $0x801a8f,%rdx
  800191:	00 00 00 
  800194:	be 23 00 00 00       	mov    $0x23,%esi
  800199:	48 bf ac 1a 80 00 00 	movabs $0x801aac,%rdi
  8001a0:	00 00 00 
  8001a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a8:	49 b9 2b 05 80 00 00 	movabs $0x80052b,%r9
  8001af:	00 00 00 
  8001b2:	41 ff d1             	callq  *%r9

	return ret;
  8001b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001b9:	48 83 c4 48          	add    $0x48,%rsp
  8001bd:	5b                   	pop    %rbx
  8001be:	5d                   	pop    %rbp
  8001bf:	c3                   	retq   

00000000008001c0 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001c0:	55                   	push   %rbp
  8001c1:	48 89 e5             	mov    %rsp,%rbp
  8001c4:	48 83 ec 20          	sub    $0x20,%rsp
  8001c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001df:	00 
  8001e0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ec:	48 89 d1             	mov    %rdx,%rcx
  8001ef:	48 89 c2             	mov    %rax,%rdx
  8001f2:	be 00 00 00 00       	mov    $0x0,%esi
  8001f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fc:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
}
  800208:	c9                   	leaveq 
  800209:	c3                   	retq   

000000000080020a <sys_cgetc>:

int
sys_cgetc(void)
{
  80020a:	55                   	push   %rbp
  80020b:	48 89 e5             	mov    %rsp,%rbp
  80020e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800212:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800219:	00 
  80021a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800220:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800226:	b9 00 00 00 00       	mov    $0x0,%ecx
  80022b:	ba 00 00 00 00       	mov    $0x0,%edx
  800230:	be 00 00 00 00       	mov    $0x0,%esi
  800235:	bf 01 00 00 00       	mov    $0x1,%edi
  80023a:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  800241:	00 00 00 
  800244:	ff d0                	callq  *%rax
}
  800246:	c9                   	leaveq 
  800247:	c3                   	retq   

0000000000800248 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800248:	55                   	push   %rbp
  800249:	48 89 e5             	mov    %rsp,%rbp
  80024c:	48 83 ec 10          	sub    $0x10,%rsp
  800250:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800253:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800256:	48 98                	cltq   
  800258:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80025f:	00 
  800260:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800266:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80026c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800271:	48 89 c2             	mov    %rax,%rdx
  800274:	be 01 00 00 00       	mov    $0x1,%esi
  800279:	bf 03 00 00 00       	mov    $0x3,%edi
  80027e:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  800285:	00 00 00 
  800288:	ff d0                	callq  *%rax
}
  80028a:	c9                   	leaveq 
  80028b:	c3                   	retq   

000000000080028c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80028c:	55                   	push   %rbp
  80028d:	48 89 e5             	mov    %rsp,%rbp
  800290:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800294:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80029b:	00 
  80029c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b2:	be 00 00 00 00       	mov    $0x0,%esi
  8002b7:	bf 02 00 00 00       	mov    $0x2,%edi
  8002bc:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  8002c3:	00 00 00 
  8002c6:	ff d0                	callq  *%rax
}
  8002c8:	c9                   	leaveq 
  8002c9:	c3                   	retq   

00000000008002ca <sys_yield>:

void
sys_yield(void)
{
  8002ca:	55                   	push   %rbp
  8002cb:	48 89 e5             	mov    %rsp,%rbp
  8002ce:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002d2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002d9:	00 
  8002da:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f0:	be 00 00 00 00       	mov    $0x0,%esi
  8002f5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002fa:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax
}
  800306:	c9                   	leaveq 
  800307:	c3                   	retq   

0000000000800308 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800308:	55                   	push   %rbp
  800309:	48 89 e5             	mov    %rsp,%rbp
  80030c:	48 83 ec 20          	sub    $0x20,%rsp
  800310:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800313:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800317:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80031a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80031d:	48 63 c8             	movslq %eax,%rcx
  800320:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800327:	48 98                	cltq   
  800329:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800330:	00 
  800331:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800337:	49 89 c8             	mov    %rcx,%r8
  80033a:	48 89 d1             	mov    %rdx,%rcx
  80033d:	48 89 c2             	mov    %rax,%rdx
  800340:	be 01 00 00 00       	mov    $0x1,%esi
  800345:	bf 04 00 00 00       	mov    $0x4,%edi
  80034a:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  800351:	00 00 00 
  800354:	ff d0                	callq  *%rax
}
  800356:	c9                   	leaveq 
  800357:	c3                   	retq   

0000000000800358 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800358:	55                   	push   %rbp
  800359:	48 89 e5             	mov    %rsp,%rbp
  80035c:	48 83 ec 30          	sub    $0x30,%rsp
  800360:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800363:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800367:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80036a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80036e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800372:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800375:	48 63 c8             	movslq %eax,%rcx
  800378:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80037c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80037f:	48 63 f0             	movslq %eax,%rsi
  800382:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800386:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800389:	48 98                	cltq   
  80038b:	48 89 0c 24          	mov    %rcx,(%rsp)
  80038f:	49 89 f9             	mov    %rdi,%r9
  800392:	49 89 f0             	mov    %rsi,%r8
  800395:	48 89 d1             	mov    %rdx,%rcx
  800398:	48 89 c2             	mov    %rax,%rdx
  80039b:	be 01 00 00 00       	mov    $0x1,%esi
  8003a0:	bf 05 00 00 00       	mov    $0x5,%edi
  8003a5:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  8003ac:	00 00 00 
  8003af:	ff d0                	callq  *%rax
}
  8003b1:	c9                   	leaveq 
  8003b2:	c3                   	retq   

00000000008003b3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003b3:	55                   	push   %rbp
  8003b4:	48 89 e5             	mov    %rsp,%rbp
  8003b7:	48 83 ec 20          	sub    $0x20,%rsp
  8003bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c9:	48 98                	cltq   
  8003cb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003d2:	00 
  8003d3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003d9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003df:	48 89 d1             	mov    %rdx,%rcx
  8003e2:	48 89 c2             	mov    %rax,%rdx
  8003e5:	be 01 00 00 00       	mov    $0x1,%esi
  8003ea:	bf 06 00 00 00       	mov    $0x6,%edi
  8003ef:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  8003f6:	00 00 00 
  8003f9:	ff d0                	callq  *%rax
}
  8003fb:	c9                   	leaveq 
  8003fc:	c3                   	retq   

00000000008003fd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003fd:	55                   	push   %rbp
  8003fe:	48 89 e5             	mov    %rsp,%rbp
  800401:	48 83 ec 10          	sub    $0x10,%rsp
  800405:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800408:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80040b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040e:	48 63 d0             	movslq %eax,%rdx
  800411:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800414:	48 98                	cltq   
  800416:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80041d:	00 
  80041e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800424:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80042a:	48 89 d1             	mov    %rdx,%rcx
  80042d:	48 89 c2             	mov    %rax,%rdx
  800430:	be 01 00 00 00       	mov    $0x1,%esi
  800435:	bf 08 00 00 00       	mov    $0x8,%edi
  80043a:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  800441:	00 00 00 
  800444:	ff d0                	callq  *%rax
}
  800446:	c9                   	leaveq 
  800447:	c3                   	retq   

0000000000800448 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800448:	55                   	push   %rbp
  800449:	48 89 e5             	mov    %rsp,%rbp
  80044c:	48 83 ec 20          	sub    $0x20,%rsp
  800450:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800453:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800457:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80045b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80045e:	48 98                	cltq   
  800460:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800467:	00 
  800468:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80046e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800474:	48 89 d1             	mov    %rdx,%rcx
  800477:	48 89 c2             	mov    %rax,%rdx
  80047a:	be 01 00 00 00       	mov    $0x1,%esi
  80047f:	bf 09 00 00 00       	mov    $0x9,%edi
  800484:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  80048b:	00 00 00 
  80048e:	ff d0                	callq  *%rax
}
  800490:	c9                   	leaveq 
  800491:	c3                   	retq   

0000000000800492 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800492:	55                   	push   %rbp
  800493:	48 89 e5             	mov    %rsp,%rbp
  800496:	48 83 ec 20          	sub    $0x20,%rsp
  80049a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80049d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004a5:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004ab:	48 63 f0             	movslq %eax,%rsi
  8004ae:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004b5:	48 98                	cltq   
  8004b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004c2:	00 
  8004c3:	49 89 f1             	mov    %rsi,%r9
  8004c6:	49 89 c8             	mov    %rcx,%r8
  8004c9:	48 89 d1             	mov    %rdx,%rcx
  8004cc:	48 89 c2             	mov    %rax,%rdx
  8004cf:	be 00 00 00 00       	mov    $0x0,%esi
  8004d4:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004d9:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  8004e0:	00 00 00 
  8004e3:	ff d0                	callq  *%rax
}
  8004e5:	c9                   	leaveq 
  8004e6:	c3                   	retq   

00000000008004e7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004e7:	55                   	push   %rbp
  8004e8:	48 89 e5             	mov    %rsp,%rbp
  8004eb:	48 83 ec 10          	sub    $0x10,%rsp
  8004ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004fe:	00 
  8004ff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800505:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80050b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800510:	48 89 c2             	mov    %rax,%rdx
  800513:	be 01 00 00 00       	mov    $0x1,%esi
  800518:	bf 0c 00 00 00       	mov    $0xc,%edi
  80051d:	48 b8 32 01 80 00 00 	movabs $0x800132,%rax
  800524:	00 00 00 
  800527:	ff d0                	callq  *%rax
}
  800529:	c9                   	leaveq 
  80052a:	c3                   	retq   

000000000080052b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80052b:	55                   	push   %rbp
  80052c:	48 89 e5             	mov    %rsp,%rbp
  80052f:	53                   	push   %rbx
  800530:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800537:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80053e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800544:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80054b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800552:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800559:	84 c0                	test   %al,%al
  80055b:	74 23                	je     800580 <_panic+0x55>
  80055d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800564:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800568:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80056c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800570:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800574:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800578:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80057c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800580:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800587:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80058e:	00 00 00 
  800591:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800598:	00 00 00 
  80059b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80059f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8005a6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005ad:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005b4:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005bb:	00 00 00 
  8005be:	48 8b 18             	mov    (%rax),%rbx
  8005c1:	48 b8 8c 02 80 00 00 	movabs $0x80028c,%rax
  8005c8:	00 00 00 
  8005cb:	ff d0                	callq  *%rax
  8005cd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005d3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005da:	41 89 c8             	mov    %ecx,%r8d
  8005dd:	48 89 d1             	mov    %rdx,%rcx
  8005e0:	48 89 da             	mov    %rbx,%rdx
  8005e3:	89 c6                	mov    %eax,%esi
  8005e5:	48 bf c0 1a 80 00 00 	movabs $0x801ac0,%rdi
  8005ec:	00 00 00 
  8005ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f4:	49 b9 64 07 80 00 00 	movabs $0x800764,%r9
  8005fb:	00 00 00 
  8005fe:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800601:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800608:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80060f:	48 89 d6             	mov    %rdx,%rsi
  800612:	48 89 c7             	mov    %rax,%rdi
  800615:	48 b8 b8 06 80 00 00 	movabs $0x8006b8,%rax
  80061c:	00 00 00 
  80061f:	ff d0                	callq  *%rax
	cprintf("\n");
  800621:	48 bf e3 1a 80 00 00 	movabs $0x801ae3,%rdi
  800628:	00 00 00 
  80062b:	b8 00 00 00 00       	mov    $0x0,%eax
  800630:	48 ba 64 07 80 00 00 	movabs $0x800764,%rdx
  800637:	00 00 00 
  80063a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80063c:	cc                   	int3   
  80063d:	eb fd                	jmp    80063c <_panic+0x111>

000000000080063f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80063f:	55                   	push   %rbp
  800640:	48 89 e5             	mov    %rsp,%rbp
  800643:	48 83 ec 10          	sub    $0x10,%rsp
  800647:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80064a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80064e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800652:	8b 00                	mov    (%rax),%eax
  800654:	8d 48 01             	lea    0x1(%rax),%ecx
  800657:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80065b:	89 0a                	mov    %ecx,(%rdx)
  80065d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800660:	89 d1                	mov    %edx,%ecx
  800662:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800666:	48 98                	cltq   
  800668:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80066c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	3d ff 00 00 00       	cmp    $0xff,%eax
  800677:	75 2c                	jne    8006a5 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800679:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067d:	8b 00                	mov    (%rax),%eax
  80067f:	48 98                	cltq   
  800681:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800685:	48 83 c2 08          	add    $0x8,%rdx
  800689:	48 89 c6             	mov    %rax,%rsi
  80068c:	48 89 d7             	mov    %rdx,%rdi
  80068f:	48 b8 c0 01 80 00 00 	movabs $0x8001c0,%rax
  800696:	00 00 00 
  800699:	ff d0                	callq  *%rax
		b->idx = 0;
  80069b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8006a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a9:	8b 40 04             	mov    0x4(%rax),%eax
  8006ac:	8d 50 01             	lea    0x1(%rax),%edx
  8006af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006b6:	c9                   	leaveq 
  8006b7:	c3                   	retq   

00000000008006b8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006b8:	55                   	push   %rbp
  8006b9:	48 89 e5             	mov    %rsp,%rbp
  8006bc:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006c3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006ca:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8006d1:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006d8:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006df:	48 8b 0a             	mov    (%rdx),%rcx
  8006e2:	48 89 08             	mov    %rcx,(%rax)
  8006e5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006ed:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006f1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8006f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006fc:	00 00 00 
	b.cnt = 0;
  8006ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800706:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800709:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800710:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800717:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80071e:	48 89 c6             	mov    %rax,%rsi
  800721:	48 bf 3f 06 80 00 00 	movabs $0x80063f,%rdi
  800728:	00 00 00 
  80072b:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  800732:	00 00 00 
  800735:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800737:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80073d:	48 98                	cltq   
  80073f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800746:	48 83 c2 08          	add    $0x8,%rdx
  80074a:	48 89 c6             	mov    %rax,%rsi
  80074d:	48 89 d7             	mov    %rdx,%rdi
  800750:	48 b8 c0 01 80 00 00 	movabs $0x8001c0,%rax
  800757:	00 00 00 
  80075a:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80075c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800762:	c9                   	leaveq 
  800763:	c3                   	retq   

0000000000800764 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800764:	55                   	push   %rbp
  800765:	48 89 e5             	mov    %rsp,%rbp
  800768:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80076f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800776:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80077d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800784:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80078b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800792:	84 c0                	test   %al,%al
  800794:	74 20                	je     8007b6 <cprintf+0x52>
  800796:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80079a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80079e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8007a2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8007a6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007aa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007ae:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007b2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007b6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8007bd:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007c4:	00 00 00 
  8007c7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007ce:	00 00 00 
  8007d1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007d5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007dc:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007e3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8007ea:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007f1:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007f8:	48 8b 0a             	mov    (%rdx),%rcx
  8007fb:	48 89 08             	mov    %rcx,(%rax)
  8007fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800802:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800806:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80080a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80080e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800815:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80081c:	48 89 d6             	mov    %rdx,%rsi
  80081f:	48 89 c7             	mov    %rax,%rdi
  800822:	48 b8 b8 06 80 00 00 	movabs $0x8006b8,%rax
  800829:	00 00 00 
  80082c:	ff d0                	callq  *%rax
  80082e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800834:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80083a:	c9                   	leaveq 
  80083b:	c3                   	retq   

000000000080083c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80083c:	55                   	push   %rbp
  80083d:	48 89 e5             	mov    %rsp,%rbp
  800840:	53                   	push   %rbx
  800841:	48 83 ec 38          	sub    $0x38,%rsp
  800845:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800849:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80084d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800851:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800854:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800858:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80085c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80085f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800863:	77 3b                	ja     8008a0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800865:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800868:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80086c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80086f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800873:	ba 00 00 00 00       	mov    $0x0,%edx
  800878:	48 f7 f3             	div    %rbx
  80087b:	48 89 c2             	mov    %rax,%rdx
  80087e:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800881:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800884:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088c:	41 89 f9             	mov    %edi,%r9d
  80088f:	48 89 c7             	mov    %rax,%rdi
  800892:	48 b8 3c 08 80 00 00 	movabs $0x80083c,%rax
  800899:	00 00 00 
  80089c:	ff d0                	callq  *%rax
  80089e:	eb 1e                	jmp    8008be <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a0:	eb 12                	jmp    8008b4 <printnum+0x78>
			putch(padc, putdat);
  8008a2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008a6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8008a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ad:	48 89 ce             	mov    %rcx,%rsi
  8008b0:	89 d7                	mov    %edx,%edi
  8008b2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008b4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008b8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008bc:	7f e4                	jg     8008a2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008be:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	48 f7 f1             	div    %rcx
  8008cd:	48 89 d0             	mov    %rdx,%rax
  8008d0:	48 ba f0 1b 80 00 00 	movabs $0x801bf0,%rdx
  8008d7:	00 00 00 
  8008da:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008de:	0f be d0             	movsbl %al,%edx
  8008e1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e9:	48 89 ce             	mov    %rcx,%rsi
  8008ec:	89 d7                	mov    %edx,%edi
  8008ee:	ff d0                	callq  *%rax
}
  8008f0:	48 83 c4 38          	add    $0x38,%rsp
  8008f4:	5b                   	pop    %rbx
  8008f5:	5d                   	pop    %rbp
  8008f6:	c3                   	retq   

00000000008008f7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008f7:	55                   	push   %rbp
  8008f8:	48 89 e5             	mov    %rsp,%rbp
  8008fb:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800903:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800906:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80090a:	7e 52                	jle    80095e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80090c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800910:	8b 00                	mov    (%rax),%eax
  800912:	83 f8 30             	cmp    $0x30,%eax
  800915:	73 24                	jae    80093b <getuint+0x44>
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80091f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800923:	8b 00                	mov    (%rax),%eax
  800925:	89 c0                	mov    %eax,%eax
  800927:	48 01 d0             	add    %rdx,%rax
  80092a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092e:	8b 12                	mov    (%rdx),%edx
  800930:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800933:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800937:	89 0a                	mov    %ecx,(%rdx)
  800939:	eb 17                	jmp    800952 <getuint+0x5b>
  80093b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800943:	48 89 d0             	mov    %rdx,%rax
  800946:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80094a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800952:	48 8b 00             	mov    (%rax),%rax
  800955:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800959:	e9 a3 00 00 00       	jmpq   800a01 <getuint+0x10a>
	else if (lflag)
  80095e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800962:	74 4f                	je     8009b3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800964:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800968:	8b 00                	mov    (%rax),%eax
  80096a:	83 f8 30             	cmp    $0x30,%eax
  80096d:	73 24                	jae    800993 <getuint+0x9c>
  80096f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800973:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800977:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097b:	8b 00                	mov    (%rax),%eax
  80097d:	89 c0                	mov    %eax,%eax
  80097f:	48 01 d0             	add    %rdx,%rax
  800982:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800986:	8b 12                	mov    (%rdx),%edx
  800988:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80098b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098f:	89 0a                	mov    %ecx,(%rdx)
  800991:	eb 17                	jmp    8009aa <getuint+0xb3>
  800993:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800997:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80099b:	48 89 d0             	mov    %rdx,%rax
  80099e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009aa:	48 8b 00             	mov    (%rax),%rax
  8009ad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009b1:	eb 4e                	jmp    800a01 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b7:	8b 00                	mov    (%rax),%eax
  8009b9:	83 f8 30             	cmp    $0x30,%eax
  8009bc:	73 24                	jae    8009e2 <getuint+0xeb>
  8009be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	8b 00                	mov    (%rax),%eax
  8009cc:	89 c0                	mov    %eax,%eax
  8009ce:	48 01 d0             	add    %rdx,%rax
  8009d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d5:	8b 12                	mov    (%rdx),%edx
  8009d7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009de:	89 0a                	mov    %ecx,(%rdx)
  8009e0:	eb 17                	jmp    8009f9 <getuint+0x102>
  8009e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009ea:	48 89 d0             	mov    %rdx,%rax
  8009ed:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f9:	8b 00                	mov    (%rax),%eax
  8009fb:	89 c0                	mov    %eax,%eax
  8009fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a05:	c9                   	leaveq 
  800a06:	c3                   	retq   

0000000000800a07 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a07:	55                   	push   %rbp
  800a08:	48 89 e5             	mov    %rsp,%rbp
  800a0b:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a0f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a13:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a16:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a1a:	7e 52                	jle    800a6e <getint+0x67>
		x=va_arg(*ap, long long);
  800a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a20:	8b 00                	mov    (%rax),%eax
  800a22:	83 f8 30             	cmp    $0x30,%eax
  800a25:	73 24                	jae    800a4b <getint+0x44>
  800a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a33:	8b 00                	mov    (%rax),%eax
  800a35:	89 c0                	mov    %eax,%eax
  800a37:	48 01 d0             	add    %rdx,%rax
  800a3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3e:	8b 12                	mov    (%rdx),%edx
  800a40:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a43:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a47:	89 0a                	mov    %ecx,(%rdx)
  800a49:	eb 17                	jmp    800a62 <getint+0x5b>
  800a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a53:	48 89 d0             	mov    %rdx,%rax
  800a56:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a5e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a62:	48 8b 00             	mov    (%rax),%rax
  800a65:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a69:	e9 a3 00 00 00       	jmpq   800b11 <getint+0x10a>
	else if (lflag)
  800a6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a72:	74 4f                	je     800ac3 <getint+0xbc>
		x=va_arg(*ap, long);
  800a74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a78:	8b 00                	mov    (%rax),%eax
  800a7a:	83 f8 30             	cmp    $0x30,%eax
  800a7d:	73 24                	jae    800aa3 <getint+0x9c>
  800a7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a83:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8b:	8b 00                	mov    (%rax),%eax
  800a8d:	89 c0                	mov    %eax,%eax
  800a8f:	48 01 d0             	add    %rdx,%rax
  800a92:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a96:	8b 12                	mov    (%rdx),%edx
  800a98:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9f:	89 0a                	mov    %ecx,(%rdx)
  800aa1:	eb 17                	jmp    800aba <getint+0xb3>
  800aa3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aab:	48 89 d0             	mov    %rdx,%rax
  800aae:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ab2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aba:	48 8b 00             	mov    (%rax),%rax
  800abd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ac1:	eb 4e                	jmp    800b11 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ac3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac7:	8b 00                	mov    (%rax),%eax
  800ac9:	83 f8 30             	cmp    $0x30,%eax
  800acc:	73 24                	jae    800af2 <getint+0xeb>
  800ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ad6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ada:	8b 00                	mov    (%rax),%eax
  800adc:	89 c0                	mov    %eax,%eax
  800ade:	48 01 d0             	add    %rdx,%rax
  800ae1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae5:	8b 12                	mov    (%rdx),%edx
  800ae7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aee:	89 0a                	mov    %ecx,(%rdx)
  800af0:	eb 17                	jmp    800b09 <getint+0x102>
  800af2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800afa:	48 89 d0             	mov    %rdx,%rax
  800afd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b01:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b05:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b09:	8b 00                	mov    (%rax),%eax
  800b0b:	48 98                	cltq   
  800b0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b15:	c9                   	leaveq 
  800b16:	c3                   	retq   

0000000000800b17 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b17:	55                   	push   %rbp
  800b18:	48 89 e5             	mov    %rsp,%rbp
  800b1b:	41 54                	push   %r12
  800b1d:	53                   	push   %rbx
  800b1e:	48 83 ec 60          	sub    $0x60,%rsp
  800b22:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b26:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b2a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b2e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b32:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b36:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b3a:	48 8b 0a             	mov    (%rdx),%rcx
  800b3d:	48 89 08             	mov    %rcx,(%rax)
  800b40:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b44:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b48:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b4c:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b50:	eb 17                	jmp    800b69 <vprintfmt+0x52>
			if (ch == '\0')
  800b52:	85 db                	test   %ebx,%ebx
  800b54:	0f 84 cc 04 00 00    	je     801026 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800b5a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b62:	48 89 d6             	mov    %rdx,%rsi
  800b65:	89 df                	mov    %ebx,%edi
  800b67:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b69:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b6d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b71:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b75:	0f b6 00             	movzbl (%rax),%eax
  800b78:	0f b6 d8             	movzbl %al,%ebx
  800b7b:	83 fb 25             	cmp    $0x25,%ebx
  800b7e:	75 d2                	jne    800b52 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800b80:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b84:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b8b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b99:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ba0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ba8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bac:	0f b6 00             	movzbl (%rax),%eax
  800baf:	0f b6 d8             	movzbl %al,%ebx
  800bb2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800bb5:	83 f8 55             	cmp    $0x55,%eax
  800bb8:	0f 87 34 04 00 00    	ja     800ff2 <vprintfmt+0x4db>
  800bbe:	89 c0                	mov    %eax,%eax
  800bc0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bc7:	00 
  800bc8:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  800bcf:	00 00 00 
  800bd2:	48 01 d0             	add    %rdx,%rax
  800bd5:	48 8b 00             	mov    (%rax),%rax
  800bd8:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bda:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bde:	eb c0                	jmp    800ba0 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800be0:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800be4:	eb ba                	jmp    800ba0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bed:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bf0:	89 d0                	mov    %edx,%eax
  800bf2:	c1 e0 02             	shl    $0x2,%eax
  800bf5:	01 d0                	add    %edx,%eax
  800bf7:	01 c0                	add    %eax,%eax
  800bf9:	01 d8                	add    %ebx,%eax
  800bfb:	83 e8 30             	sub    $0x30,%eax
  800bfe:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c01:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c05:	0f b6 00             	movzbl (%rax),%eax
  800c08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800c0e:	7e 0c                	jle    800c1c <vprintfmt+0x105>
  800c10:	83 fb 39             	cmp    $0x39,%ebx
  800c13:	7f 07                	jg     800c1c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c15:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c1a:	eb d1                	jmp    800bed <vprintfmt+0xd6>
			goto process_precision;
  800c1c:	eb 58                	jmp    800c76 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c1e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c21:	83 f8 30             	cmp    $0x30,%eax
  800c24:	73 17                	jae    800c3d <vprintfmt+0x126>
  800c26:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c2a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2d:	89 c0                	mov    %eax,%eax
  800c2f:	48 01 d0             	add    %rdx,%rax
  800c32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c35:	83 c2 08             	add    $0x8,%edx
  800c38:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c3b:	eb 0f                	jmp    800c4c <vprintfmt+0x135>
  800c3d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c41:	48 89 d0             	mov    %rdx,%rax
  800c44:	48 83 c2 08          	add    $0x8,%rdx
  800c48:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c4c:	8b 00                	mov    (%rax),%eax
  800c4e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c51:	eb 23                	jmp    800c76 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c53:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c57:	79 0c                	jns    800c65 <vprintfmt+0x14e>
				width = 0;
  800c59:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c60:	e9 3b ff ff ff       	jmpq   800ba0 <vprintfmt+0x89>
  800c65:	e9 36 ff ff ff       	jmpq   800ba0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c6a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c71:	e9 2a ff ff ff       	jmpq   800ba0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c76:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c7a:	79 12                	jns    800c8e <vprintfmt+0x177>
				width = precision, precision = -1;
  800c7c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c7f:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c82:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c89:	e9 12 ff ff ff       	jmpq   800ba0 <vprintfmt+0x89>
  800c8e:	e9 0d ff ff ff       	jmpq   800ba0 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c93:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c97:	e9 04 ff ff ff       	jmpq   800ba0 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800c9c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9f:	83 f8 30             	cmp    $0x30,%eax
  800ca2:	73 17                	jae    800cbb <vprintfmt+0x1a4>
  800ca4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cab:	89 c0                	mov    %eax,%eax
  800cad:	48 01 d0             	add    %rdx,%rax
  800cb0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb3:	83 c2 08             	add    $0x8,%edx
  800cb6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cb9:	eb 0f                	jmp    800cca <vprintfmt+0x1b3>
  800cbb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cbf:	48 89 d0             	mov    %rdx,%rax
  800cc2:	48 83 c2 08          	add    $0x8,%rdx
  800cc6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cca:	8b 10                	mov    (%rax),%edx
  800ccc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd4:	48 89 ce             	mov    %rcx,%rsi
  800cd7:	89 d7                	mov    %edx,%edi
  800cd9:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800cdb:	e9 40 03 00 00       	jmpq   801020 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800ce0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce3:	83 f8 30             	cmp    $0x30,%eax
  800ce6:	73 17                	jae    800cff <vprintfmt+0x1e8>
  800ce8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cec:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cef:	89 c0                	mov    %eax,%eax
  800cf1:	48 01 d0             	add    %rdx,%rax
  800cf4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cf7:	83 c2 08             	add    $0x8,%edx
  800cfa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cfd:	eb 0f                	jmp    800d0e <vprintfmt+0x1f7>
  800cff:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d03:	48 89 d0             	mov    %rdx,%rax
  800d06:	48 83 c2 08          	add    $0x8,%rdx
  800d0a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d0e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d10:	85 db                	test   %ebx,%ebx
  800d12:	79 02                	jns    800d16 <vprintfmt+0x1ff>
				err = -err;
  800d14:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d16:	83 fb 09             	cmp    $0x9,%ebx
  800d19:	7f 16                	jg     800d31 <vprintfmt+0x21a>
  800d1b:	48 b8 a0 1b 80 00 00 	movabs $0x801ba0,%rax
  800d22:	00 00 00 
  800d25:	48 63 d3             	movslq %ebx,%rdx
  800d28:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d2c:	4d 85 e4             	test   %r12,%r12
  800d2f:	75 2e                	jne    800d5f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d31:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d39:	89 d9                	mov    %ebx,%ecx
  800d3b:	48 ba 01 1c 80 00 00 	movabs $0x801c01,%rdx
  800d42:	00 00 00 
  800d45:	48 89 c7             	mov    %rax,%rdi
  800d48:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4d:	49 b8 2f 10 80 00 00 	movabs $0x80102f,%r8
  800d54:	00 00 00 
  800d57:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d5a:	e9 c1 02 00 00       	jmpq   801020 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d5f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d63:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d67:	4c 89 e1             	mov    %r12,%rcx
  800d6a:	48 ba 0a 1c 80 00 00 	movabs $0x801c0a,%rdx
  800d71:	00 00 00 
  800d74:	48 89 c7             	mov    %rax,%rdi
  800d77:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7c:	49 b8 2f 10 80 00 00 	movabs $0x80102f,%r8
  800d83:	00 00 00 
  800d86:	41 ff d0             	callq  *%r8
			break;
  800d89:	e9 92 02 00 00       	jmpq   801020 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800d8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d91:	83 f8 30             	cmp    $0x30,%eax
  800d94:	73 17                	jae    800dad <vprintfmt+0x296>
  800d96:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d9d:	89 c0                	mov    %eax,%eax
  800d9f:	48 01 d0             	add    %rdx,%rax
  800da2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800da5:	83 c2 08             	add    $0x8,%edx
  800da8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dab:	eb 0f                	jmp    800dbc <vprintfmt+0x2a5>
  800dad:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800db1:	48 89 d0             	mov    %rdx,%rax
  800db4:	48 83 c2 08          	add    $0x8,%rdx
  800db8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dbc:	4c 8b 20             	mov    (%rax),%r12
  800dbf:	4d 85 e4             	test   %r12,%r12
  800dc2:	75 0a                	jne    800dce <vprintfmt+0x2b7>
				p = "(null)";
  800dc4:	49 bc 0d 1c 80 00 00 	movabs $0x801c0d,%r12
  800dcb:	00 00 00 
			if (width > 0 && padc != '-')
  800dce:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dd2:	7e 3f                	jle    800e13 <vprintfmt+0x2fc>
  800dd4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dd8:	74 39                	je     800e13 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dda:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ddd:	48 98                	cltq   
  800ddf:	48 89 c6             	mov    %rax,%rsi
  800de2:	4c 89 e7             	mov    %r12,%rdi
  800de5:	48 b8 db 12 80 00 00 	movabs $0x8012db,%rax
  800dec:	00 00 00 
  800def:	ff d0                	callq  *%rax
  800df1:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800df4:	eb 17                	jmp    800e0d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800df6:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dfa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e02:	48 89 ce             	mov    %rcx,%rsi
  800e05:	89 d7                	mov    %edx,%edi
  800e07:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e09:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e11:	7f e3                	jg     800df6 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e13:	eb 37                	jmp    800e4c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e15:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e19:	74 1e                	je     800e39 <vprintfmt+0x322>
  800e1b:	83 fb 1f             	cmp    $0x1f,%ebx
  800e1e:	7e 05                	jle    800e25 <vprintfmt+0x30e>
  800e20:	83 fb 7e             	cmp    $0x7e,%ebx
  800e23:	7e 14                	jle    800e39 <vprintfmt+0x322>
					putch('?', putdat);
  800e25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2d:	48 89 d6             	mov    %rdx,%rsi
  800e30:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e35:	ff d0                	callq  *%rax
  800e37:	eb 0f                	jmp    800e48 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e41:	48 89 d6             	mov    %rdx,%rsi
  800e44:	89 df                	mov    %ebx,%edi
  800e46:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e48:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e4c:	4c 89 e0             	mov    %r12,%rax
  800e4f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e53:	0f b6 00             	movzbl (%rax),%eax
  800e56:	0f be d8             	movsbl %al,%ebx
  800e59:	85 db                	test   %ebx,%ebx
  800e5b:	74 10                	je     800e6d <vprintfmt+0x356>
  800e5d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e61:	78 b2                	js     800e15 <vprintfmt+0x2fe>
  800e63:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e67:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e6b:	79 a8                	jns    800e15 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e6d:	eb 16                	jmp    800e85 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e6f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e73:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e77:	48 89 d6             	mov    %rdx,%rsi
  800e7a:	bf 20 00 00 00       	mov    $0x20,%edi
  800e7f:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e81:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e85:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e89:	7f e4                	jg     800e6f <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800e8b:	e9 90 01 00 00       	jmpq   801020 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800e90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e94:	be 03 00 00 00       	mov    $0x3,%esi
  800e99:	48 89 c7             	mov    %rax,%rdi
  800e9c:	48 b8 07 0a 80 00 00 	movabs $0x800a07,%rax
  800ea3:	00 00 00 
  800ea6:	ff d0                	callq  *%rax
  800ea8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800eac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb0:	48 85 c0             	test   %rax,%rax
  800eb3:	79 1d                	jns    800ed2 <vprintfmt+0x3bb>
				putch('-', putdat);
  800eb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebd:	48 89 d6             	mov    %rdx,%rsi
  800ec0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ec5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ec7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ecb:	48 f7 d8             	neg    %rax
  800ece:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ed2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ed9:	e9 d5 00 00 00       	jmpq   800fb3 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800ede:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ee2:	be 03 00 00 00       	mov    $0x3,%esi
  800ee7:	48 89 c7             	mov    %rax,%rdi
  800eea:	48 b8 f7 08 80 00 00 	movabs $0x8008f7,%rax
  800ef1:	00 00 00 
  800ef4:	ff d0                	callq  *%rax
  800ef6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800efa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f01:	e9 ad 00 00 00       	jmpq   800fb3 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800f06:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f0a:	be 03 00 00 00       	mov    $0x3,%esi
  800f0f:	48 89 c7             	mov    %rax,%rdi
  800f12:	48 b8 f7 08 80 00 00 	movabs $0x8008f7,%rax
  800f19:	00 00 00 
  800f1c:	ff d0                	callq  *%rax
  800f1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f22:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f29:	e9 85 00 00 00       	jmpq   800fb3 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800f2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f36:	48 89 d6             	mov    %rdx,%rsi
  800f39:	bf 30 00 00 00       	mov    $0x30,%edi
  800f3e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f48:	48 89 d6             	mov    %rdx,%rsi
  800f4b:	bf 78 00 00 00       	mov    $0x78,%edi
  800f50:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f55:	83 f8 30             	cmp    $0x30,%eax
  800f58:	73 17                	jae    800f71 <vprintfmt+0x45a>
  800f5a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f5e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f61:	89 c0                	mov    %eax,%eax
  800f63:	48 01 d0             	add    %rdx,%rax
  800f66:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f69:	83 c2 08             	add    $0x8,%edx
  800f6c:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f6f:	eb 0f                	jmp    800f80 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f71:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f75:	48 89 d0             	mov    %rdx,%rax
  800f78:	48 83 c2 08          	add    $0x8,%rdx
  800f7c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f80:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f87:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f8e:	eb 23                	jmp    800fb3 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800f90:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f94:	be 03 00 00 00       	mov    $0x3,%esi
  800f99:	48 89 c7             	mov    %rax,%rdi
  800f9c:	48 b8 f7 08 80 00 00 	movabs $0x8008f7,%rax
  800fa3:	00 00 00 
  800fa6:	ff d0                	callq  *%rax
  800fa8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fac:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800fb3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fb8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fbb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fbe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fc2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fc6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fca:	45 89 c1             	mov    %r8d,%r9d
  800fcd:	41 89 f8             	mov    %edi,%r8d
  800fd0:	48 89 c7             	mov    %rax,%rdi
  800fd3:	48 b8 3c 08 80 00 00 	movabs $0x80083c,%rax
  800fda:	00 00 00 
  800fdd:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800fdf:	eb 3f                	jmp    801020 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fe1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe9:	48 89 d6             	mov    %rdx,%rsi
  800fec:	89 df                	mov    %ebx,%edi
  800fee:	ff d0                	callq  *%rax
			break;
  800ff0:	eb 2e                	jmp    801020 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ff2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ff6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ffa:	48 89 d6             	mov    %rdx,%rsi
  800ffd:	bf 25 00 00 00       	mov    $0x25,%edi
  801002:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  801004:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801009:	eb 05                	jmp    801010 <vprintfmt+0x4f9>
  80100b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801010:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801014:	48 83 e8 01          	sub    $0x1,%rax
  801018:	0f b6 00             	movzbl (%rax),%eax
  80101b:	3c 25                	cmp    $0x25,%al
  80101d:	75 ec                	jne    80100b <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80101f:	90                   	nop
		}
	}
  801020:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801021:	e9 43 fb ff ff       	jmpq   800b69 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  801026:	48 83 c4 60          	add    $0x60,%rsp
  80102a:	5b                   	pop    %rbx
  80102b:	41 5c                	pop    %r12
  80102d:	5d                   	pop    %rbp
  80102e:	c3                   	retq   

000000000080102f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80102f:	55                   	push   %rbp
  801030:	48 89 e5             	mov    %rsp,%rbp
  801033:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  80103a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801041:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801048:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80104f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801056:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80105d:	84 c0                	test   %al,%al
  80105f:	74 20                	je     801081 <printfmt+0x52>
  801061:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801065:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801069:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80106d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801071:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801075:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801079:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80107d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801081:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801088:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80108f:	00 00 00 
  801092:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801099:	00 00 00 
  80109c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010a0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010a7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010ae:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010b5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010bc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010c3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010ca:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010d1:	48 89 c7             	mov    %rax,%rdi
  8010d4:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  8010db:	00 00 00 
  8010de:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010e0:	c9                   	leaveq 
  8010e1:	c3                   	retq   

00000000008010e2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010e2:	55                   	push   %rbp
  8010e3:	48 89 e5             	mov    %rsp,%rbp
  8010e6:	48 83 ec 10          	sub    $0x10,%rsp
  8010ea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f5:	8b 40 10             	mov    0x10(%rax),%eax
  8010f8:	8d 50 01             	lea    0x1(%rax),%edx
  8010fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ff:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801102:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801106:	48 8b 10             	mov    (%rax),%rdx
  801109:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801111:	48 39 c2             	cmp    %rax,%rdx
  801114:	73 17                	jae    80112d <sprintputch+0x4b>
		*b->buf++ = ch;
  801116:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80111a:	48 8b 00             	mov    (%rax),%rax
  80111d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801121:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801125:	48 89 0a             	mov    %rcx,(%rdx)
  801128:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80112b:	88 10                	mov    %dl,(%rax)
}
  80112d:	c9                   	leaveq 
  80112e:	c3                   	retq   

000000000080112f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80112f:	55                   	push   %rbp
  801130:	48 89 e5             	mov    %rsp,%rbp
  801133:	48 83 ec 50          	sub    $0x50,%rsp
  801137:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80113b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80113e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801142:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801146:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80114a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80114e:	48 8b 0a             	mov    (%rdx),%rcx
  801151:	48 89 08             	mov    %rcx,(%rax)
  801154:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801158:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80115c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801160:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801164:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801168:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80116c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80116f:	48 98                	cltq   
  801171:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801175:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801179:	48 01 d0             	add    %rdx,%rax
  80117c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801180:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801187:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80118c:	74 06                	je     801194 <vsnprintf+0x65>
  80118e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801192:	7f 07                	jg     80119b <vsnprintf+0x6c>
		return -E_INVAL;
  801194:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801199:	eb 2f                	jmp    8011ca <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80119b:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80119f:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011a3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011a7:	48 89 c6             	mov    %rax,%rsi
  8011aa:	48 bf e2 10 80 00 00 	movabs $0x8010e2,%rdi
  8011b1:	00 00 00 
  8011b4:	48 b8 17 0b 80 00 00 	movabs $0x800b17,%rax
  8011bb:	00 00 00 
  8011be:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011c4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011c7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011ca:	c9                   	leaveq 
  8011cb:	c3                   	retq   

00000000008011cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011cc:	55                   	push   %rbp
  8011cd:	48 89 e5             	mov    %rsp,%rbp
  8011d0:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011d7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011de:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011e4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011eb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011f2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011f9:	84 c0                	test   %al,%al
  8011fb:	74 20                	je     80121d <snprintf+0x51>
  8011fd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801201:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801205:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801209:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80120d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801211:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801215:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801219:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80121d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801224:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80122b:	00 00 00 
  80122e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801235:	00 00 00 
  801238:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80123c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801243:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80124a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801251:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801258:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80125f:	48 8b 0a             	mov    (%rdx),%rcx
  801262:	48 89 08             	mov    %rcx,(%rax)
  801265:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801269:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80126d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801271:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801275:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80127c:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801283:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801289:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801290:	48 89 c7             	mov    %rax,%rdi
  801293:	48 b8 2f 11 80 00 00 	movabs $0x80112f,%rax
  80129a:	00 00 00 
  80129d:	ff d0                	callq  *%rax
  80129f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012a5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012ab:	c9                   	leaveq 
  8012ac:	c3                   	retq   

00000000008012ad <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012ad:	55                   	push   %rbp
  8012ae:	48 89 e5             	mov    %rsp,%rbp
  8012b1:	48 83 ec 18          	sub    $0x18,%rsp
  8012b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012c0:	eb 09                	jmp    8012cb <strlen+0x1e>
		n++;
  8012c2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cf:	0f b6 00             	movzbl (%rax),%eax
  8012d2:	84 c0                	test   %al,%al
  8012d4:	75 ec                	jne    8012c2 <strlen+0x15>
		n++;
	return n;
  8012d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012d9:	c9                   	leaveq 
  8012da:	c3                   	retq   

00000000008012db <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012db:	55                   	push   %rbp
  8012dc:	48 89 e5             	mov    %rsp,%rbp
  8012df:	48 83 ec 20          	sub    $0x20,%rsp
  8012e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012f2:	eb 0e                	jmp    801302 <strnlen+0x27>
		n++;
  8012f4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012fd:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801302:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801307:	74 0b                	je     801314 <strnlen+0x39>
  801309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130d:	0f b6 00             	movzbl (%rax),%eax
  801310:	84 c0                	test   %al,%al
  801312:	75 e0                	jne    8012f4 <strnlen+0x19>
		n++;
	return n;
  801314:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801317:	c9                   	leaveq 
  801318:	c3                   	retq   

0000000000801319 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801319:	55                   	push   %rbp
  80131a:	48 89 e5             	mov    %rsp,%rbp
  80131d:	48 83 ec 20          	sub    $0x20,%rsp
  801321:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801325:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801331:	90                   	nop
  801332:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801336:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80133a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80133e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801342:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801346:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80134a:	0f b6 12             	movzbl (%rdx),%edx
  80134d:	88 10                	mov    %dl,(%rax)
  80134f:	0f b6 00             	movzbl (%rax),%eax
  801352:	84 c0                	test   %al,%al
  801354:	75 dc                	jne    801332 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801356:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80135a:	c9                   	leaveq 
  80135b:	c3                   	retq   

000000000080135c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80135c:	55                   	push   %rbp
  80135d:	48 89 e5             	mov    %rsp,%rbp
  801360:	48 83 ec 20          	sub    $0x20,%rsp
  801364:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801368:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80136c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801370:	48 89 c7             	mov    %rax,%rdi
  801373:	48 b8 ad 12 80 00 00 	movabs $0x8012ad,%rax
  80137a:	00 00 00 
  80137d:	ff d0                	callq  *%rax
  80137f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801382:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801385:	48 63 d0             	movslq %eax,%rdx
  801388:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138c:	48 01 c2             	add    %rax,%rdx
  80138f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801393:	48 89 c6             	mov    %rax,%rsi
  801396:	48 89 d7             	mov    %rdx,%rdi
  801399:	48 b8 19 13 80 00 00 	movabs $0x801319,%rax
  8013a0:	00 00 00 
  8013a3:	ff d0                	callq  *%rax
	return dst;
  8013a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013a9:	c9                   	leaveq 
  8013aa:	c3                   	retq   

00000000008013ab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013ab:	55                   	push   %rbp
  8013ac:	48 89 e5             	mov    %rsp,%rbp
  8013af:	48 83 ec 28          	sub    $0x28,%rsp
  8013b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013c7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013ce:	00 
  8013cf:	eb 2a                	jmp    8013fb <strncpy+0x50>
		*dst++ = *src;
  8013d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013dd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013e1:	0f b6 12             	movzbl (%rdx),%edx
  8013e4:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ea:	0f b6 00             	movzbl (%rax),%eax
  8013ed:	84 c0                	test   %al,%al
  8013ef:	74 05                	je     8013f6 <strncpy+0x4b>
			src++;
  8013f1:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ff:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801403:	72 cc                	jb     8013d1 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801405:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801409:	c9                   	leaveq 
  80140a:	c3                   	retq   

000000000080140b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80140b:	55                   	push   %rbp
  80140c:	48 89 e5             	mov    %rsp,%rbp
  80140f:	48 83 ec 28          	sub    $0x28,%rsp
  801413:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801417:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80141b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80141f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801423:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801427:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80142c:	74 3d                	je     80146b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80142e:	eb 1d                	jmp    80144d <strlcpy+0x42>
			*dst++ = *src++;
  801430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801434:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801438:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80143c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801440:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801444:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801448:	0f b6 12             	movzbl (%rdx),%edx
  80144b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80144d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801452:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801457:	74 0b                	je     801464 <strlcpy+0x59>
  801459:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	84 c0                	test   %al,%al
  801462:	75 cc                	jne    801430 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801468:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80146b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80146f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801473:	48 29 c2             	sub    %rax,%rdx
  801476:	48 89 d0             	mov    %rdx,%rax
}
  801479:	c9                   	leaveq 
  80147a:	c3                   	retq   

000000000080147b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80147b:	55                   	push   %rbp
  80147c:	48 89 e5             	mov    %rsp,%rbp
  80147f:	48 83 ec 10          	sub    $0x10,%rsp
  801483:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801487:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80148b:	eb 0a                	jmp    801497 <strcmp+0x1c>
		p++, q++;
  80148d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801492:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801497:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149b:	0f b6 00             	movzbl (%rax),%eax
  80149e:	84 c0                	test   %al,%al
  8014a0:	74 12                	je     8014b4 <strcmp+0x39>
  8014a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a6:	0f b6 10             	movzbl (%rax),%edx
  8014a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ad:	0f b6 00             	movzbl (%rax),%eax
  8014b0:	38 c2                	cmp    %al,%dl
  8014b2:	74 d9                	je     80148d <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b8:	0f b6 00             	movzbl (%rax),%eax
  8014bb:	0f b6 d0             	movzbl %al,%edx
  8014be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c2:	0f b6 00             	movzbl (%rax),%eax
  8014c5:	0f b6 c0             	movzbl %al,%eax
  8014c8:	29 c2                	sub    %eax,%edx
  8014ca:	89 d0                	mov    %edx,%eax
}
  8014cc:	c9                   	leaveq 
  8014cd:	c3                   	retq   

00000000008014ce <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014ce:	55                   	push   %rbp
  8014cf:	48 89 e5             	mov    %rsp,%rbp
  8014d2:	48 83 ec 18          	sub    $0x18,%rsp
  8014d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014e2:	eb 0f                	jmp    8014f3 <strncmp+0x25>
		n--, p++, q++;
  8014e4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014ee:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014f3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014f8:	74 1d                	je     801517 <strncmp+0x49>
  8014fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fe:	0f b6 00             	movzbl (%rax),%eax
  801501:	84 c0                	test   %al,%al
  801503:	74 12                	je     801517 <strncmp+0x49>
  801505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801509:	0f b6 10             	movzbl (%rax),%edx
  80150c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801510:	0f b6 00             	movzbl (%rax),%eax
  801513:	38 c2                	cmp    %al,%dl
  801515:	74 cd                	je     8014e4 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801517:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80151c:	75 07                	jne    801525 <strncmp+0x57>
		return 0;
  80151e:	b8 00 00 00 00       	mov    $0x0,%eax
  801523:	eb 18                	jmp    80153d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801525:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801529:	0f b6 00             	movzbl (%rax),%eax
  80152c:	0f b6 d0             	movzbl %al,%edx
  80152f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801533:	0f b6 00             	movzbl (%rax),%eax
  801536:	0f b6 c0             	movzbl %al,%eax
  801539:	29 c2                	sub    %eax,%edx
  80153b:	89 d0                	mov    %edx,%eax
}
  80153d:	c9                   	leaveq 
  80153e:	c3                   	retq   

000000000080153f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80153f:	55                   	push   %rbp
  801540:	48 89 e5             	mov    %rsp,%rbp
  801543:	48 83 ec 0c          	sub    $0xc,%rsp
  801547:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80154b:	89 f0                	mov    %esi,%eax
  80154d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801550:	eb 17                	jmp    801569 <strchr+0x2a>
		if (*s == c)
  801552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80155c:	75 06                	jne    801564 <strchr+0x25>
			return (char *) s;
  80155e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801562:	eb 15                	jmp    801579 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801564:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801569:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156d:	0f b6 00             	movzbl (%rax),%eax
  801570:	84 c0                	test   %al,%al
  801572:	75 de                	jne    801552 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801574:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801579:	c9                   	leaveq 
  80157a:	c3                   	retq   

000000000080157b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80157b:	55                   	push   %rbp
  80157c:	48 89 e5             	mov    %rsp,%rbp
  80157f:	48 83 ec 0c          	sub    $0xc,%rsp
  801583:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801587:	89 f0                	mov    %esi,%eax
  801589:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80158c:	eb 13                	jmp    8015a1 <strfind+0x26>
		if (*s == c)
  80158e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801592:	0f b6 00             	movzbl (%rax),%eax
  801595:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801598:	75 02                	jne    80159c <strfind+0x21>
			break;
  80159a:	eb 10                	jmp    8015ac <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80159c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a5:	0f b6 00             	movzbl (%rax),%eax
  8015a8:	84 c0                	test   %al,%al
  8015aa:	75 e2                	jne    80158e <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8015ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015b0:	c9                   	leaveq 
  8015b1:	c3                   	retq   

00000000008015b2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015b2:	55                   	push   %rbp
  8015b3:	48 89 e5             	mov    %rsp,%rbp
  8015b6:	48 83 ec 18          	sub    $0x18,%rsp
  8015ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015be:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015c5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ca:	75 06                	jne    8015d2 <memset+0x20>
		return v;
  8015cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d0:	eb 69                	jmp    80163b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d6:	83 e0 03             	and    $0x3,%eax
  8015d9:	48 85 c0             	test   %rax,%rax
  8015dc:	75 48                	jne    801626 <memset+0x74>
  8015de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e2:	83 e0 03             	and    $0x3,%eax
  8015e5:	48 85 c0             	test   %rax,%rax
  8015e8:	75 3c                	jne    801626 <memset+0x74>
		c &= 0xFF;
  8015ea:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f4:	c1 e0 18             	shl    $0x18,%eax
  8015f7:	89 c2                	mov    %eax,%edx
  8015f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fc:	c1 e0 10             	shl    $0x10,%eax
  8015ff:	09 c2                	or     %eax,%edx
  801601:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801604:	c1 e0 08             	shl    $0x8,%eax
  801607:	09 d0                	or     %edx,%eax
  801609:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80160c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801610:	48 c1 e8 02          	shr    $0x2,%rax
  801614:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801617:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80161b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80161e:	48 89 d7             	mov    %rdx,%rdi
  801621:	fc                   	cld    
  801622:	f3 ab                	rep stos %eax,%es:(%rdi)
  801624:	eb 11                	jmp    801637 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801626:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80162a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80162d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801631:	48 89 d7             	mov    %rdx,%rdi
  801634:	fc                   	cld    
  801635:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80163b:	c9                   	leaveq 
  80163c:	c3                   	retq   

000000000080163d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80163d:	55                   	push   %rbp
  80163e:	48 89 e5             	mov    %rsp,%rbp
  801641:	48 83 ec 28          	sub    $0x28,%rsp
  801645:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801649:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80164d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801651:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801655:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80165d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801661:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801665:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801669:	0f 83 88 00 00 00    	jae    8016f7 <memmove+0xba>
  80166f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801673:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801677:	48 01 d0             	add    %rdx,%rax
  80167a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80167e:	76 77                	jbe    8016f7 <memmove+0xba>
		s += n;
  801680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801684:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801690:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801694:	83 e0 03             	and    $0x3,%eax
  801697:	48 85 c0             	test   %rax,%rax
  80169a:	75 3b                	jne    8016d7 <memmove+0x9a>
  80169c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a0:	83 e0 03             	and    $0x3,%eax
  8016a3:	48 85 c0             	test   %rax,%rax
  8016a6:	75 2f                	jne    8016d7 <memmove+0x9a>
  8016a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ac:	83 e0 03             	and    $0x3,%eax
  8016af:	48 85 c0             	test   %rax,%rax
  8016b2:	75 23                	jne    8016d7 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b8:	48 83 e8 04          	sub    $0x4,%rax
  8016bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016c0:	48 83 ea 04          	sub    $0x4,%rdx
  8016c4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016c8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016cc:	48 89 c7             	mov    %rax,%rdi
  8016cf:	48 89 d6             	mov    %rdx,%rsi
  8016d2:	fd                   	std    
  8016d3:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016d5:	eb 1d                	jmp    8016f4 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016db:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e3:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016eb:	48 89 d7             	mov    %rdx,%rdi
  8016ee:	48 89 c1             	mov    %rax,%rcx
  8016f1:	fd                   	std    
  8016f2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016f4:	fc                   	cld    
  8016f5:	eb 57                	jmp    80174e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016fb:	83 e0 03             	and    $0x3,%eax
  8016fe:	48 85 c0             	test   %rax,%rax
  801701:	75 36                	jne    801739 <memmove+0xfc>
  801703:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801707:	83 e0 03             	and    $0x3,%eax
  80170a:	48 85 c0             	test   %rax,%rax
  80170d:	75 2a                	jne    801739 <memmove+0xfc>
  80170f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801713:	83 e0 03             	and    $0x3,%eax
  801716:	48 85 c0             	test   %rax,%rax
  801719:	75 1e                	jne    801739 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80171b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171f:	48 c1 e8 02          	shr    $0x2,%rax
  801723:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80172e:	48 89 c7             	mov    %rax,%rdi
  801731:	48 89 d6             	mov    %rdx,%rsi
  801734:	fc                   	cld    
  801735:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801737:	eb 15                	jmp    80174e <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80173d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801741:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801745:	48 89 c7             	mov    %rax,%rdi
  801748:	48 89 d6             	mov    %rdx,%rsi
  80174b:	fc                   	cld    
  80174c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80174e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801752:	c9                   	leaveq 
  801753:	c3                   	retq   

0000000000801754 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801754:	55                   	push   %rbp
  801755:	48 89 e5             	mov    %rsp,%rbp
  801758:	48 83 ec 18          	sub    $0x18,%rsp
  80175c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801760:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801764:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801768:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80176c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801770:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801774:	48 89 ce             	mov    %rcx,%rsi
  801777:	48 89 c7             	mov    %rax,%rdi
  80177a:	48 b8 3d 16 80 00 00 	movabs $0x80163d,%rax
  801781:	00 00 00 
  801784:	ff d0                	callq  *%rax
}
  801786:	c9                   	leaveq 
  801787:	c3                   	retq   

0000000000801788 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801788:	55                   	push   %rbp
  801789:	48 89 e5             	mov    %rsp,%rbp
  80178c:	48 83 ec 28          	sub    $0x28,%rsp
  801790:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801794:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801798:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80179c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8017a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8017ac:	eb 36                	jmp    8017e4 <memcmp+0x5c>
		if (*s1 != *s2)
  8017ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b2:	0f b6 10             	movzbl (%rax),%edx
  8017b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b9:	0f b6 00             	movzbl (%rax),%eax
  8017bc:	38 c2                	cmp    %al,%dl
  8017be:	74 1a                	je     8017da <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c4:	0f b6 00             	movzbl (%rax),%eax
  8017c7:	0f b6 d0             	movzbl %al,%edx
  8017ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ce:	0f b6 00             	movzbl (%rax),%eax
  8017d1:	0f b6 c0             	movzbl %al,%eax
  8017d4:	29 c2                	sub    %eax,%edx
  8017d6:	89 d0                	mov    %edx,%eax
  8017d8:	eb 20                	jmp    8017fa <memcmp+0x72>
		s1++, s2++;
  8017da:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017df:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017f0:	48 85 c0             	test   %rax,%rax
  8017f3:	75 b9                	jne    8017ae <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fa:	c9                   	leaveq 
  8017fb:	c3                   	retq   

00000000008017fc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017fc:	55                   	push   %rbp
  8017fd:	48 89 e5             	mov    %rsp,%rbp
  801800:	48 83 ec 28          	sub    $0x28,%rsp
  801804:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801808:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80180b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80180f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801813:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801817:	48 01 d0             	add    %rdx,%rax
  80181a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80181e:	eb 15                	jmp    801835 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801820:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801824:	0f b6 10             	movzbl (%rax),%edx
  801827:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80182a:	38 c2                	cmp    %al,%dl
  80182c:	75 02                	jne    801830 <memfind+0x34>
			break;
  80182e:	eb 0f                	jmp    80183f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801830:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801835:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801839:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80183d:	72 e1                	jb     801820 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80183f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801843:	c9                   	leaveq 
  801844:	c3                   	retq   

0000000000801845 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801845:	55                   	push   %rbp
  801846:	48 89 e5             	mov    %rsp,%rbp
  801849:	48 83 ec 34          	sub    $0x34,%rsp
  80184d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801851:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801855:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801858:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80185f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801866:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801867:	eb 05                	jmp    80186e <strtol+0x29>
		s++;
  801869:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80186e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801872:	0f b6 00             	movzbl (%rax),%eax
  801875:	3c 20                	cmp    $0x20,%al
  801877:	74 f0                	je     801869 <strtol+0x24>
  801879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187d:	0f b6 00             	movzbl (%rax),%eax
  801880:	3c 09                	cmp    $0x9,%al
  801882:	74 e5                	je     801869 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801888:	0f b6 00             	movzbl (%rax),%eax
  80188b:	3c 2b                	cmp    $0x2b,%al
  80188d:	75 07                	jne    801896 <strtol+0x51>
		s++;
  80188f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801894:	eb 17                	jmp    8018ad <strtol+0x68>
	else if (*s == '-')
  801896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189a:	0f b6 00             	movzbl (%rax),%eax
  80189d:	3c 2d                	cmp    $0x2d,%al
  80189f:	75 0c                	jne    8018ad <strtol+0x68>
		s++, neg = 1;
  8018a1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018b1:	74 06                	je     8018b9 <strtol+0x74>
  8018b3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018b7:	75 28                	jne    8018e1 <strtol+0x9c>
  8018b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bd:	0f b6 00             	movzbl (%rax),%eax
  8018c0:	3c 30                	cmp    $0x30,%al
  8018c2:	75 1d                	jne    8018e1 <strtol+0x9c>
  8018c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c8:	48 83 c0 01          	add    $0x1,%rax
  8018cc:	0f b6 00             	movzbl (%rax),%eax
  8018cf:	3c 78                	cmp    $0x78,%al
  8018d1:	75 0e                	jne    8018e1 <strtol+0x9c>
		s += 2, base = 16;
  8018d3:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018d8:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018df:	eb 2c                	jmp    80190d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018e1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018e5:	75 19                	jne    801900 <strtol+0xbb>
  8018e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018eb:	0f b6 00             	movzbl (%rax),%eax
  8018ee:	3c 30                	cmp    $0x30,%al
  8018f0:	75 0e                	jne    801900 <strtol+0xbb>
		s++, base = 8;
  8018f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018f7:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018fe:	eb 0d                	jmp    80190d <strtol+0xc8>
	else if (base == 0)
  801900:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801904:	75 07                	jne    80190d <strtol+0xc8>
		base = 10;
  801906:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80190d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801911:	0f b6 00             	movzbl (%rax),%eax
  801914:	3c 2f                	cmp    $0x2f,%al
  801916:	7e 1d                	jle    801935 <strtol+0xf0>
  801918:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191c:	0f b6 00             	movzbl (%rax),%eax
  80191f:	3c 39                	cmp    $0x39,%al
  801921:	7f 12                	jg     801935 <strtol+0xf0>
			dig = *s - '0';
  801923:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801927:	0f b6 00             	movzbl (%rax),%eax
  80192a:	0f be c0             	movsbl %al,%eax
  80192d:	83 e8 30             	sub    $0x30,%eax
  801930:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801933:	eb 4e                	jmp    801983 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801935:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801939:	0f b6 00             	movzbl (%rax),%eax
  80193c:	3c 60                	cmp    $0x60,%al
  80193e:	7e 1d                	jle    80195d <strtol+0x118>
  801940:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801944:	0f b6 00             	movzbl (%rax),%eax
  801947:	3c 7a                	cmp    $0x7a,%al
  801949:	7f 12                	jg     80195d <strtol+0x118>
			dig = *s - 'a' + 10;
  80194b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194f:	0f b6 00             	movzbl (%rax),%eax
  801952:	0f be c0             	movsbl %al,%eax
  801955:	83 e8 57             	sub    $0x57,%eax
  801958:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80195b:	eb 26                	jmp    801983 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80195d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801961:	0f b6 00             	movzbl (%rax),%eax
  801964:	3c 40                	cmp    $0x40,%al
  801966:	7e 48                	jle    8019b0 <strtol+0x16b>
  801968:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196c:	0f b6 00             	movzbl (%rax),%eax
  80196f:	3c 5a                	cmp    $0x5a,%al
  801971:	7f 3d                	jg     8019b0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801973:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801977:	0f b6 00             	movzbl (%rax),%eax
  80197a:	0f be c0             	movsbl %al,%eax
  80197d:	83 e8 37             	sub    $0x37,%eax
  801980:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801983:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801986:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801989:	7c 02                	jl     80198d <strtol+0x148>
			break;
  80198b:	eb 23                	jmp    8019b0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80198d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801992:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801995:	48 98                	cltq   
  801997:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80199c:	48 89 c2             	mov    %rax,%rdx
  80199f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019a2:	48 98                	cltq   
  8019a4:	48 01 d0             	add    %rdx,%rax
  8019a7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019ab:	e9 5d ff ff ff       	jmpq   80190d <strtol+0xc8>

	if (endptr)
  8019b0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019b5:	74 0b                	je     8019c2 <strtol+0x17d>
		*endptr = (char *) s;
  8019b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019bb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019bf:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019c6:	74 09                	je     8019d1 <strtol+0x18c>
  8019c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019cc:	48 f7 d8             	neg    %rax
  8019cf:	eb 04                	jmp    8019d5 <strtol+0x190>
  8019d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019d5:	c9                   	leaveq 
  8019d6:	c3                   	retq   

00000000008019d7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019d7:	55                   	push   %rbp
  8019d8:	48 89 e5             	mov    %rsp,%rbp
  8019db:	48 83 ec 30          	sub    $0x30,%rsp
  8019df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019eb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ef:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019f3:	0f b6 00             	movzbl (%rax),%eax
  8019f6:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8019f9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019fd:	75 06                	jne    801a05 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8019ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a03:	eb 6b                	jmp    801a70 <strstr+0x99>

    len = strlen(str);
  801a05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a09:	48 89 c7             	mov    %rax,%rdi
  801a0c:	48 b8 ad 12 80 00 00 	movabs $0x8012ad,%rax
  801a13:	00 00 00 
  801a16:	ff d0                	callq  *%rax
  801a18:	48 98                	cltq   
  801a1a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801a1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a22:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a26:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a2a:	0f b6 00             	movzbl (%rax),%eax
  801a2d:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801a30:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a34:	75 07                	jne    801a3d <strstr+0x66>
                return (char *) 0;
  801a36:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3b:	eb 33                	jmp    801a70 <strstr+0x99>
        } while (sc != c);
  801a3d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a41:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a44:	75 d8                	jne    801a1e <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a4a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a52:	48 89 ce             	mov    %rcx,%rsi
  801a55:	48 89 c7             	mov    %rax,%rdi
  801a58:	48 b8 ce 14 80 00 00 	movabs $0x8014ce,%rax
  801a5f:	00 00 00 
  801a62:	ff d0                	callq  *%rax
  801a64:	85 c0                	test   %eax,%eax
  801a66:	75 b6                	jne    801a1e <strstr+0x47>

    return (char *) (in - 1);
  801a68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6c:	48 83 e8 01          	sub    $0x1,%rax
}
  801a70:	c9                   	leaveq 
  801a71:	c3                   	retq   
