
obj/user/faultevilhandler:     file format elf64-x86-64


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
  80003c:	e8 4f 00 00 00       	callq  800090 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800052:	ba 07 00 00 00       	mov    $0x7,%edx
  800057:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  80006d:	be 20 00 10 f0       	mov    $0xf0100020,%esi
  800072:	bf 00 00 00 00       	mov    $0x0,%edi
  800077:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  800083:	b8 00 00 00 00       	mov    $0x0,%eax
  800088:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80008e:	c9                   	leaveq 
  80008f:	c3                   	retq   

0000000000800090 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800090:	55                   	push   %rbp
  800091:	48 89 e5             	mov    %rsp,%rbp
  800094:	48 83 ec 10          	sub    $0x10,%rsp
  800098:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80009b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  80009f:	48 b8 9d 02 80 00 00 	movabs $0x80029d,%rax
  8000a6:	00 00 00 
  8000a9:	ff d0                	callq  *%rax
  8000ab:	48 98                	cltq   
  8000ad:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b2:	48 89 c2             	mov    %rax,%rdx
  8000b5:	48 89 d0             	mov    %rdx,%rax
  8000b8:	48 c1 e0 03          	shl    $0x3,%rax
  8000bc:	48 01 d0             	add    %rdx,%rax
  8000bf:	48 c1 e0 05          	shl    $0x5,%rax
  8000c3:	48 89 c2             	mov    %rax,%rdx
  8000c6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000cd:	00 00 00 
  8000d0:	48 01 c2             	add    %rax,%rdx
  8000d3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000da:	00 00 00 
  8000dd:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000e4:	7e 14                	jle    8000fa <libmain+0x6a>
		binaryname = argv[0];
  8000e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000ea:	48 8b 10             	mov    (%rax),%rdx
  8000ed:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000f4:	00 00 00 
  8000f7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800101:	48 89 d6             	mov    %rdx,%rsi
  800104:	89 c7                	mov    %eax,%edi
  800106:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80010d:	00 00 00 
  800110:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800112:	48 b8 20 01 80 00 00 	movabs $0x800120,%rax
  800119:	00 00 00 
  80011c:	ff d0                	callq  *%rax
}
  80011e:	c9                   	leaveq 
  80011f:	c3                   	retq   

0000000000800120 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800120:	55                   	push   %rbp
  800121:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800124:	48 b8 c7 08 80 00 00 	movabs $0x8008c7,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800130:	bf 00 00 00 00       	mov    $0x0,%edi
  800135:	48 b8 59 02 80 00 00 	movabs $0x800259,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
}
  800141:	5d                   	pop    %rbp
  800142:	c3                   	retq   

0000000000800143 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800143:	55                   	push   %rbp
  800144:	48 89 e5             	mov    %rsp,%rbp
  800147:	53                   	push   %rbx
  800148:	48 83 ec 48          	sub    $0x48,%rsp
  80014c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80014f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800152:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800156:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80015a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80015e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  800162:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800165:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800169:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80016d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800171:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800175:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800179:	4c 89 c3             	mov    %r8,%rbx
  80017c:	cd 30                	int    $0x30
  80017e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  800182:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800186:	74 3e                	je     8001c6 <syscall+0x83>
  800188:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80018d:	7e 37                	jle    8001c6 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80018f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800193:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800196:	49 89 d0             	mov    %rdx,%r8
  800199:	89 c1                	mov    %eax,%ecx
  80019b:	48 ba 2a 35 80 00 00 	movabs $0x80352a,%rdx
  8001a2:	00 00 00 
  8001a5:	be 4a 00 00 00       	mov    $0x4a,%esi
  8001aa:	48 bf 47 35 80 00 00 	movabs $0x803547,%rdi
  8001b1:	00 00 00 
  8001b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b9:	49 b9 53 1d 80 00 00 	movabs $0x801d53,%r9
  8001c0:	00 00 00 
  8001c3:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8001c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001ca:	48 83 c4 48          	add    $0x48,%rsp
  8001ce:	5b                   	pop    %rbx
  8001cf:	5d                   	pop    %rbp
  8001d0:	c3                   	retq   

00000000008001d1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001d1:	55                   	push   %rbp
  8001d2:	48 89 e5             	mov    %rsp,%rbp
  8001d5:	48 83 ec 20          	sub    $0x20,%rsp
  8001d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f0:	00 
  8001f1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001fd:	48 89 d1             	mov    %rdx,%rcx
  800200:	48 89 c2             	mov    %rax,%rdx
  800203:	be 00 00 00 00       	mov    $0x0,%esi
  800208:	bf 00 00 00 00       	mov    $0x0,%edi
  80020d:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
}
  800219:	c9                   	leaveq 
  80021a:	c3                   	retq   

000000000080021b <sys_cgetc>:

int
sys_cgetc(void)
{
  80021b:	55                   	push   %rbp
  80021c:	48 89 e5             	mov    %rsp,%rbp
  80021f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800223:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80022a:	00 
  80022b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800231:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800237:	b9 00 00 00 00       	mov    $0x0,%ecx
  80023c:	ba 00 00 00 00       	mov    $0x0,%edx
  800241:	be 00 00 00 00       	mov    $0x0,%esi
  800246:	bf 01 00 00 00       	mov    $0x1,%edi
  80024b:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800252:	00 00 00 
  800255:	ff d0                	callq  *%rax
}
  800257:	c9                   	leaveq 
  800258:	c3                   	retq   

0000000000800259 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800259:	55                   	push   %rbp
  80025a:	48 89 e5             	mov    %rsp,%rbp
  80025d:	48 83 ec 10          	sub    $0x10,%rsp
  800261:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800264:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800267:	48 98                	cltq   
  800269:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800270:	00 
  800271:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800277:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80027d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800282:	48 89 c2             	mov    %rax,%rdx
  800285:	be 01 00 00 00       	mov    $0x1,%esi
  80028a:	bf 03 00 00 00       	mov    $0x3,%edi
  80028f:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800296:	00 00 00 
  800299:	ff d0                	callq  *%rax
}
  80029b:	c9                   	leaveq 
  80029c:	c3                   	retq   

000000000080029d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80029d:	55                   	push   %rbp
  80029e:	48 89 e5             	mov    %rsp,%rbp
  8002a1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8002a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002ac:	00 
  8002ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002be:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c3:	be 00 00 00 00       	mov    $0x0,%esi
  8002c8:	bf 02 00 00 00       	mov    $0x2,%edi
  8002cd:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  8002d4:	00 00 00 
  8002d7:	ff d0                	callq  *%rax
}
  8002d9:	c9                   	leaveq 
  8002da:	c3                   	retq   

00000000008002db <sys_yield>:

void
sys_yield(void)
{
  8002db:	55                   	push   %rbp
  8002dc:	48 89 e5             	mov    %rsp,%rbp
  8002df:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002e3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002ea:	00 
  8002eb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800301:	be 00 00 00 00       	mov    $0x0,%esi
  800306:	bf 0b 00 00 00       	mov    $0xb,%edi
  80030b:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800312:	00 00 00 
  800315:	ff d0                	callq  *%rax
}
  800317:	c9                   	leaveq 
  800318:	c3                   	retq   

0000000000800319 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800319:	55                   	push   %rbp
  80031a:	48 89 e5             	mov    %rsp,%rbp
  80031d:	48 83 ec 20          	sub    $0x20,%rsp
  800321:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800324:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800328:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80032b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80032e:	48 63 c8             	movslq %eax,%rcx
  800331:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800335:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800338:	48 98                	cltq   
  80033a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800341:	00 
  800342:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800348:	49 89 c8             	mov    %rcx,%r8
  80034b:	48 89 d1             	mov    %rdx,%rcx
  80034e:	48 89 c2             	mov    %rax,%rdx
  800351:	be 01 00 00 00       	mov    $0x1,%esi
  800356:	bf 04 00 00 00       	mov    $0x4,%edi
  80035b:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800362:	00 00 00 
  800365:	ff d0                	callq  *%rax
}
  800367:	c9                   	leaveq 
  800368:	c3                   	retq   

0000000000800369 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800369:	55                   	push   %rbp
  80036a:	48 89 e5             	mov    %rsp,%rbp
  80036d:	48 83 ec 30          	sub    $0x30,%rsp
  800371:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800374:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800378:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80037b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80037f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800383:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800386:	48 63 c8             	movslq %eax,%rcx
  800389:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80038d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800390:	48 63 f0             	movslq %eax,%rsi
  800393:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800397:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80039a:	48 98                	cltq   
  80039c:	48 89 0c 24          	mov    %rcx,(%rsp)
  8003a0:	49 89 f9             	mov    %rdi,%r9
  8003a3:	49 89 f0             	mov    %rsi,%r8
  8003a6:	48 89 d1             	mov    %rdx,%rcx
  8003a9:	48 89 c2             	mov    %rax,%rdx
  8003ac:	be 01 00 00 00       	mov    $0x1,%esi
  8003b1:	bf 05 00 00 00       	mov    $0x5,%edi
  8003b6:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  8003bd:	00 00 00 
  8003c0:	ff d0                	callq  *%rax
}
  8003c2:	c9                   	leaveq 
  8003c3:	c3                   	retq   

00000000008003c4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003c4:	55                   	push   %rbp
  8003c5:	48 89 e5             	mov    %rsp,%rbp
  8003c8:	48 83 ec 20          	sub    $0x20,%rsp
  8003cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003da:	48 98                	cltq   
  8003dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003e3:	00 
  8003e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003f0:	48 89 d1             	mov    %rdx,%rcx
  8003f3:	48 89 c2             	mov    %rax,%rdx
  8003f6:	be 01 00 00 00       	mov    $0x1,%esi
  8003fb:	bf 06 00 00 00       	mov    $0x6,%edi
  800400:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800407:	00 00 00 
  80040a:	ff d0                	callq  *%rax
}
  80040c:	c9                   	leaveq 
  80040d:	c3                   	retq   

000000000080040e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80040e:	55                   	push   %rbp
  80040f:	48 89 e5             	mov    %rsp,%rbp
  800412:	48 83 ec 10          	sub    $0x10,%rsp
  800416:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800419:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80041c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80041f:	48 63 d0             	movslq %eax,%rdx
  800422:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800425:	48 98                	cltq   
  800427:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80042e:	00 
  80042f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800435:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80043b:	48 89 d1             	mov    %rdx,%rcx
  80043e:	48 89 c2             	mov    %rax,%rdx
  800441:	be 01 00 00 00       	mov    $0x1,%esi
  800446:	bf 08 00 00 00       	mov    $0x8,%edi
  80044b:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  800452:	00 00 00 
  800455:	ff d0                	callq  *%rax
}
  800457:	c9                   	leaveq 
  800458:	c3                   	retq   

0000000000800459 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800459:	55                   	push   %rbp
  80045a:	48 89 e5             	mov    %rsp,%rbp
  80045d:	48 83 ec 20          	sub    $0x20,%rsp
  800461:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800464:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800468:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80046c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80046f:	48 98                	cltq   
  800471:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800478:	00 
  800479:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80047f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800485:	48 89 d1             	mov    %rdx,%rcx
  800488:	48 89 c2             	mov    %rax,%rdx
  80048b:	be 01 00 00 00       	mov    $0x1,%esi
  800490:	bf 09 00 00 00       	mov    $0x9,%edi
  800495:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  80049c:	00 00 00 
  80049f:	ff d0                	callq  *%rax
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 20          	sub    $0x20,%rsp
  8004ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8004b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004b9:	48 98                	cltq   
  8004bb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004c2:	00 
  8004c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004cf:	48 89 d1             	mov    %rdx,%rcx
  8004d2:	48 89 c2             	mov    %rax,%rdx
  8004d5:	be 01 00 00 00       	mov    $0x1,%esi
  8004da:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004df:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  8004e6:	00 00 00 
  8004e9:	ff d0                	callq  *%rax
}
  8004eb:	c9                   	leaveq 
  8004ec:	c3                   	retq   

00000000008004ed <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004ed:	55                   	push   %rbp
  8004ee:	48 89 e5             	mov    %rsp,%rbp
  8004f1:	48 83 ec 20          	sub    $0x20,%rsp
  8004f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004fc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800500:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800503:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800506:	48 63 f0             	movslq %eax,%rsi
  800509:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80050d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800510:	48 98                	cltq   
  800512:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800516:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80051d:	00 
  80051e:	49 89 f1             	mov    %rsi,%r9
  800521:	49 89 c8             	mov    %rcx,%r8
  800524:	48 89 d1             	mov    %rdx,%rcx
  800527:	48 89 c2             	mov    %rax,%rdx
  80052a:	be 00 00 00 00       	mov    $0x0,%esi
  80052f:	bf 0c 00 00 00       	mov    $0xc,%edi
  800534:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  80053b:	00 00 00 
  80053e:	ff d0                	callq  *%rax
}
  800540:	c9                   	leaveq 
  800541:	c3                   	retq   

0000000000800542 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800542:	55                   	push   %rbp
  800543:	48 89 e5             	mov    %rsp,%rbp
  800546:	48 83 ec 10          	sub    $0x10,%rsp
  80054a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80054e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800552:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800559:	00 
  80055a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800560:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800566:	b9 00 00 00 00       	mov    $0x0,%ecx
  80056b:	48 89 c2             	mov    %rax,%rdx
  80056e:	be 01 00 00 00       	mov    $0x1,%esi
  800573:	bf 0d 00 00 00       	mov    $0xd,%edi
  800578:	48 b8 43 01 80 00 00 	movabs $0x800143,%rax
  80057f:	00 00 00 
  800582:	ff d0                	callq  *%rax
}
  800584:	c9                   	leaveq 
  800585:	c3                   	retq   

0000000000800586 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  800586:	55                   	push   %rbp
  800587:	48 89 e5             	mov    %rsp,%rbp
  80058a:	48 83 ec 08          	sub    $0x8,%rsp
  80058e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800592:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800596:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80059d:	ff ff ff 
  8005a0:	48 01 d0             	add    %rdx,%rax
  8005a3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8005a7:	c9                   	leaveq 
  8005a8:	c3                   	retq   

00000000008005a9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8005a9:	55                   	push   %rbp
  8005aa:	48 89 e5             	mov    %rsp,%rbp
  8005ad:	48 83 ec 08          	sub    $0x8,%rsp
  8005b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8005b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b9:	48 89 c7             	mov    %rax,%rdi
  8005bc:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  8005c3:	00 00 00 
  8005c6:	ff d0                	callq  *%rax
  8005c8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005ce:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005d2:	c9                   	leaveq 
  8005d3:	c3                   	retq   

00000000008005d4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005d4:	55                   	push   %rbp
  8005d5:	48 89 e5             	mov    %rsp,%rbp
  8005d8:	48 83 ec 18          	sub    $0x18,%rsp
  8005dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005e7:	eb 6b                	jmp    800654 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005ec:	48 98                	cltq   
  8005ee:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005f4:	48 c1 e0 0c          	shl    $0xc,%rax
  8005f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800600:	48 c1 e8 15          	shr    $0x15,%rax
  800604:	48 89 c2             	mov    %rax,%rdx
  800607:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80060e:	01 00 00 
  800611:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800615:	83 e0 01             	and    $0x1,%eax
  800618:	48 85 c0             	test   %rax,%rax
  80061b:	74 21                	je     80063e <fd_alloc+0x6a>
  80061d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800621:	48 c1 e8 0c          	shr    $0xc,%rax
  800625:	48 89 c2             	mov    %rax,%rdx
  800628:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80062f:	01 00 00 
  800632:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800636:	83 e0 01             	and    $0x1,%eax
  800639:	48 85 c0             	test   %rax,%rax
  80063c:	75 12                	jne    800650 <fd_alloc+0x7c>
			*fd_store = fd;
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800646:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800649:	b8 00 00 00 00       	mov    $0x0,%eax
  80064e:	eb 1a                	jmp    80066a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800650:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800654:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800658:	7e 8f                	jle    8005e9 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80065a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  800665:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80066a:	c9                   	leaveq 
  80066b:	c3                   	retq   

000000000080066c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80066c:	55                   	push   %rbp
  80066d:	48 89 e5             	mov    %rsp,%rbp
  800670:	48 83 ec 20          	sub    $0x20,%rsp
  800674:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800677:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80067b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80067f:	78 06                	js     800687 <fd_lookup+0x1b>
  800681:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  800685:	7e 07                	jle    80068e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800687:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80068c:	eb 6c                	jmp    8006fa <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80068e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800691:	48 98                	cltq   
  800693:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800699:	48 c1 e0 0c          	shl    $0xc,%rax
  80069d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8006a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006a5:	48 c1 e8 15          	shr    $0x15,%rax
  8006a9:	48 89 c2             	mov    %rax,%rdx
  8006ac:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8006b3:	01 00 00 
  8006b6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006ba:	83 e0 01             	and    $0x1,%eax
  8006bd:	48 85 c0             	test   %rax,%rax
  8006c0:	74 21                	je     8006e3 <fd_lookup+0x77>
  8006c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006c6:	48 c1 e8 0c          	shr    $0xc,%rax
  8006ca:	48 89 c2             	mov    %rax,%rdx
  8006cd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006d4:	01 00 00 
  8006d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006db:	83 e0 01             	and    $0x1,%eax
  8006de:	48 85 c0             	test   %rax,%rax
  8006e1:	75 07                	jne    8006ea <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006e8:	eb 10                	jmp    8006fa <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006f2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006fa:	c9                   	leaveq 
  8006fb:	c3                   	retq   

00000000008006fc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006fc:	55                   	push   %rbp
  8006fd:	48 89 e5             	mov    %rsp,%rbp
  800700:	48 83 ec 30          	sub    $0x30,%rsp
  800704:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800708:	89 f0                	mov    %esi,%eax
  80070a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80070d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800711:	48 89 c7             	mov    %rax,%rdi
  800714:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  80071b:	00 00 00 
  80071e:	ff d0                	callq  *%rax
  800720:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800724:	48 89 d6             	mov    %rdx,%rsi
  800727:	89 c7                	mov    %eax,%edi
  800729:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800730:	00 00 00 
  800733:	ff d0                	callq  *%rax
  800735:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800738:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80073c:	78 0a                	js     800748 <fd_close+0x4c>
	    || fd != fd2)
  80073e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800742:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  800746:	74 12                	je     80075a <fd_close+0x5e>
		return (must_exist ? r : 0);
  800748:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80074c:	74 05                	je     800753 <fd_close+0x57>
  80074e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800751:	eb 05                	jmp    800758 <fd_close+0x5c>
  800753:	b8 00 00 00 00       	mov    $0x0,%eax
  800758:	eb 69                	jmp    8007c3 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80075a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80075e:	8b 00                	mov    (%rax),%eax
  800760:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800764:	48 89 d6             	mov    %rdx,%rsi
  800767:	89 c7                	mov    %eax,%edi
  800769:	48 b8 c5 07 80 00 00 	movabs $0x8007c5,%rax
  800770:	00 00 00 
  800773:	ff d0                	callq  *%rax
  800775:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800778:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80077c:	78 2a                	js     8007a8 <fd_close+0xac>
		if (dev->dev_close)
  80077e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800782:	48 8b 40 20          	mov    0x20(%rax),%rax
  800786:	48 85 c0             	test   %rax,%rax
  800789:	74 16                	je     8007a1 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  80078b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800793:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800797:	48 89 d7             	mov    %rdx,%rdi
  80079a:	ff d0                	callq  *%rax
  80079c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80079f:	eb 07                	jmp    8007a8 <fd_close+0xac>
		else
			r = 0;
  8007a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8007a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007ac:	48 89 c6             	mov    %rax,%rsi
  8007af:	bf 00 00 00 00       	mov    $0x0,%edi
  8007b4:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  8007bb:	00 00 00 
  8007be:	ff d0                	callq  *%rax
	return r;
  8007c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007c3:	c9                   	leaveq 
  8007c4:	c3                   	retq   

00000000008007c5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007c5:	55                   	push   %rbp
  8007c6:	48 89 e5             	mov    %rsp,%rbp
  8007c9:	48 83 ec 20          	sub    $0x20,%rsp
  8007cd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007d0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007db:	eb 41                	jmp    80081e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007dd:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007e4:	00 00 00 
  8007e7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007ea:	48 63 d2             	movslq %edx,%rdx
  8007ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007f1:	8b 00                	mov    (%rax),%eax
  8007f3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007f6:	75 22                	jne    80081a <dev_lookup+0x55>
			*dev = devtab[i];
  8007f8:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007ff:	00 00 00 
  800802:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800805:	48 63 d2             	movslq %edx,%rdx
  800808:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80080c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800810:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800813:	b8 00 00 00 00       	mov    $0x0,%eax
  800818:	eb 60                	jmp    80087a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80081a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80081e:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800825:	00 00 00 
  800828:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80082b:	48 63 d2             	movslq %edx,%rdx
  80082e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800832:	48 85 c0             	test   %rax,%rax
  800835:	75 a6                	jne    8007dd <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800837:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80083e:	00 00 00 
  800841:	48 8b 00             	mov    (%rax),%rax
  800844:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80084a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80084d:	89 c6                	mov    %eax,%esi
  80084f:	48 bf 58 35 80 00 00 	movabs $0x803558,%rdi
  800856:	00 00 00 
  800859:	b8 00 00 00 00       	mov    $0x0,%eax
  80085e:	48 b9 8c 1f 80 00 00 	movabs $0x801f8c,%rcx
  800865:	00 00 00 
  800868:	ff d1                	callq  *%rcx
	*dev = 0;
  80086a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80086e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800875:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80087a:	c9                   	leaveq 
  80087b:	c3                   	retq   

000000000080087c <close>:

int
close(int fdnum)
{
  80087c:	55                   	push   %rbp
  80087d:	48 89 e5             	mov    %rsp,%rbp
  800880:	48 83 ec 20          	sub    $0x20,%rsp
  800884:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800887:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80088b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80088e:	48 89 d6             	mov    %rdx,%rsi
  800891:	89 c7                	mov    %eax,%edi
  800893:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  80089a:	00 00 00 
  80089d:	ff d0                	callq  *%rax
  80089f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008a6:	79 05                	jns    8008ad <close+0x31>
		return r;
  8008a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008ab:	eb 18                	jmp    8008c5 <close+0x49>
	else
		return fd_close(fd, 1);
  8008ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008b1:	be 01 00 00 00       	mov    $0x1,%esi
  8008b6:	48 89 c7             	mov    %rax,%rdi
  8008b9:	48 b8 fc 06 80 00 00 	movabs $0x8006fc,%rax
  8008c0:	00 00 00 
  8008c3:	ff d0                	callq  *%rax
}
  8008c5:	c9                   	leaveq 
  8008c6:	c3                   	retq   

00000000008008c7 <close_all>:

void
close_all(void)
{
  8008c7:	55                   	push   %rbp
  8008c8:	48 89 e5             	mov    %rsp,%rbp
  8008cb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008d6:	eb 15                	jmp    8008ed <close_all+0x26>
		close(i);
  8008d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008db:	89 c7                	mov    %eax,%edi
  8008dd:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  8008e4:	00 00 00 
  8008e7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008e9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008ed:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008f1:	7e e5                	jle    8008d8 <close_all+0x11>
		close(i);
}
  8008f3:	c9                   	leaveq 
  8008f4:	c3                   	retq   

00000000008008f5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008f5:	55                   	push   %rbp
  8008f6:	48 89 e5             	mov    %rsp,%rbp
  8008f9:	48 83 ec 40          	sub    $0x40,%rsp
  8008fd:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800900:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800903:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800907:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80090a:	48 89 d6             	mov    %rdx,%rsi
  80090d:	89 c7                	mov    %eax,%edi
  80090f:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800916:	00 00 00 
  800919:	ff d0                	callq  *%rax
  80091b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80091e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800922:	79 08                	jns    80092c <dup+0x37>
		return r;
  800924:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800927:	e9 70 01 00 00       	jmpq   800a9c <dup+0x1a7>
	close(newfdnum);
  80092c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80092f:	89 c7                	mov    %eax,%edi
  800931:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  800938:	00 00 00 
  80093b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80093d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800940:	48 98                	cltq   
  800942:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800948:	48 c1 e0 0c          	shl    $0xc,%rax
  80094c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800954:	48 89 c7             	mov    %rax,%rdi
  800957:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  80095e:	00 00 00 
  800961:	ff d0                	callq  *%rax
  800963:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80096b:	48 89 c7             	mov    %rax,%rdi
  80096e:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  800975:	00 00 00 
  800978:	ff d0                	callq  *%rax
  80097a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80097e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800982:	48 c1 e8 15          	shr    $0x15,%rax
  800986:	48 89 c2             	mov    %rax,%rdx
  800989:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800990:	01 00 00 
  800993:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800997:	83 e0 01             	and    $0x1,%eax
  80099a:	48 85 c0             	test   %rax,%rax
  80099d:	74 73                	je     800a12 <dup+0x11d>
  80099f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a3:	48 c1 e8 0c          	shr    $0xc,%rax
  8009a7:	48 89 c2             	mov    %rax,%rdx
  8009aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009b1:	01 00 00 
  8009b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009b8:	83 e0 01             	and    $0x1,%eax
  8009bb:	48 85 c0             	test   %rax,%rax
  8009be:	74 52                	je     800a12 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8009c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c4:	48 c1 e8 0c          	shr    $0xc,%rax
  8009c8:	48 89 c2             	mov    %rax,%rdx
  8009cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009d2:	01 00 00 
  8009d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8009de:	89 c1                	mov    %eax,%ecx
  8009e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e8:	41 89 c8             	mov    %ecx,%r8d
  8009eb:	48 89 d1             	mov    %rdx,%rcx
  8009ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f3:	48 89 c6             	mov    %rax,%rsi
  8009f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8009fb:	48 b8 69 03 80 00 00 	movabs $0x800369,%rax
  800a02:	00 00 00 
  800a05:	ff d0                	callq  *%rax
  800a07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a0e:	79 02                	jns    800a12 <dup+0x11d>
			goto err;
  800a10:	eb 57                	jmp    800a69 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a16:	48 c1 e8 0c          	shr    $0xc,%rax
  800a1a:	48 89 c2             	mov    %rax,%rdx
  800a1d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a24:	01 00 00 
  800a27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a2b:	25 07 0e 00 00       	and    $0xe07,%eax
  800a30:	89 c1                	mov    %eax,%ecx
  800a32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a36:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a3a:	41 89 c8             	mov    %ecx,%r8d
  800a3d:	48 89 d1             	mov    %rdx,%rcx
  800a40:	ba 00 00 00 00       	mov    $0x0,%edx
  800a45:	48 89 c6             	mov    %rax,%rsi
  800a48:	bf 00 00 00 00       	mov    $0x0,%edi
  800a4d:	48 b8 69 03 80 00 00 	movabs $0x800369,%rax
  800a54:	00 00 00 
  800a57:	ff d0                	callq  *%rax
  800a59:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a60:	79 02                	jns    800a64 <dup+0x16f>
		goto err;
  800a62:	eb 05                	jmp    800a69 <dup+0x174>

	return newfdnum;
  800a64:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a67:	eb 33                	jmp    800a9c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a6d:	48 89 c6             	mov    %rax,%rsi
  800a70:	bf 00 00 00 00       	mov    $0x0,%edi
  800a75:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  800a7c:	00 00 00 
  800a7f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a85:	48 89 c6             	mov    %rax,%rsi
  800a88:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8d:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  800a94:	00 00 00 
  800a97:	ff d0                	callq  *%rax
	return r;
  800a99:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a9c:	c9                   	leaveq 
  800a9d:	c3                   	retq   

0000000000800a9e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a9e:	55                   	push   %rbp
  800a9f:	48 89 e5             	mov    %rsp,%rbp
  800aa2:	48 83 ec 40          	sub    $0x40,%rsp
  800aa6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800aa9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800aad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ab1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800ab5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800ab8:	48 89 d6             	mov    %rdx,%rsi
  800abb:	89 c7                	mov    %eax,%edi
  800abd:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800ac4:	00 00 00 
  800ac7:	ff d0                	callq  *%rax
  800ac9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800acc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ad0:	78 24                	js     800af6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ad2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad6:	8b 00                	mov    (%rax),%eax
  800ad8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800adc:	48 89 d6             	mov    %rdx,%rsi
  800adf:	89 c7                	mov    %eax,%edi
  800ae1:	48 b8 c5 07 80 00 00 	movabs $0x8007c5,%rax
  800ae8:	00 00 00 
  800aeb:	ff d0                	callq  *%rax
  800aed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800af0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800af4:	79 05                	jns    800afb <read+0x5d>
		return r;
  800af6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800af9:	eb 76                	jmp    800b71 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800afb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aff:	8b 40 08             	mov    0x8(%rax),%eax
  800b02:	83 e0 03             	and    $0x3,%eax
  800b05:	83 f8 01             	cmp    $0x1,%eax
  800b08:	75 3a                	jne    800b44 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b0a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b11:	00 00 00 
  800b14:	48 8b 00             	mov    (%rax),%rax
  800b17:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b1d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b20:	89 c6                	mov    %eax,%esi
  800b22:	48 bf 77 35 80 00 00 	movabs $0x803577,%rdi
  800b29:	00 00 00 
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b31:	48 b9 8c 1f 80 00 00 	movabs $0x801f8c,%rcx
  800b38:	00 00 00 
  800b3b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b42:	eb 2d                	jmp    800b71 <read+0xd3>
	}
	if (!dev->dev_read)
  800b44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b48:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b4c:	48 85 c0             	test   %rax,%rax
  800b4f:	75 07                	jne    800b58 <read+0xba>
		return -E_NOT_SUPP;
  800b51:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b56:	eb 19                	jmp    800b71 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b5c:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b60:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b64:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b68:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b6c:	48 89 cf             	mov    %rcx,%rdi
  800b6f:	ff d0                	callq  *%rax
}
  800b71:	c9                   	leaveq 
  800b72:	c3                   	retq   

0000000000800b73 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b73:	55                   	push   %rbp
  800b74:	48 89 e5             	mov    %rsp,%rbp
  800b77:	48 83 ec 30          	sub    $0x30,%rsp
  800b7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b82:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b8d:	eb 49                	jmp    800bd8 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b92:	48 98                	cltq   
  800b94:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b98:	48 29 c2             	sub    %rax,%rdx
  800b9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b9e:	48 63 c8             	movslq %eax,%rcx
  800ba1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ba5:	48 01 c1             	add    %rax,%rcx
  800ba8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800bab:	48 89 ce             	mov    %rcx,%rsi
  800bae:	89 c7                	mov    %eax,%edi
  800bb0:	48 b8 9e 0a 80 00 00 	movabs $0x800a9e,%rax
  800bb7:	00 00 00 
  800bba:	ff d0                	callq  *%rax
  800bbc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800bbf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bc3:	79 05                	jns    800bca <readn+0x57>
			return m;
  800bc5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bc8:	eb 1c                	jmp    800be6 <readn+0x73>
		if (m == 0)
  800bca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bce:	75 02                	jne    800bd2 <readn+0x5f>
			break;
  800bd0:	eb 11                	jmp    800be3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bd5:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bdb:	48 98                	cltq   
  800bdd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800be1:	72 ac                	jb     800b8f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800be3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800be6:	c9                   	leaveq 
  800be7:	c3                   	retq   

0000000000800be8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800be8:	55                   	push   %rbp
  800be9:	48 89 e5             	mov    %rsp,%rbp
  800bec:	48 83 ec 40          	sub    $0x40,%rsp
  800bf0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bf3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bf7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bfb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800bff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800c02:	48 89 d6             	mov    %rdx,%rsi
  800c05:	89 c7                	mov    %eax,%edi
  800c07:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800c0e:	00 00 00 
  800c11:	ff d0                	callq  *%rax
  800c13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c1a:	78 24                	js     800c40 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c20:	8b 00                	mov    (%rax),%eax
  800c22:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c26:	48 89 d6             	mov    %rdx,%rsi
  800c29:	89 c7                	mov    %eax,%edi
  800c2b:	48 b8 c5 07 80 00 00 	movabs $0x8007c5,%rax
  800c32:	00 00 00 
  800c35:	ff d0                	callq  *%rax
  800c37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c3e:	79 05                	jns    800c45 <write+0x5d>
		return r;
  800c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c43:	eb 75                	jmp    800cba <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c49:	8b 40 08             	mov    0x8(%rax),%eax
  800c4c:	83 e0 03             	and    $0x3,%eax
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	75 3a                	jne    800c8d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c53:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c5a:	00 00 00 
  800c5d:	48 8b 00             	mov    (%rax),%rax
  800c60:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c66:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c69:	89 c6                	mov    %eax,%esi
  800c6b:	48 bf 93 35 80 00 00 	movabs $0x803593,%rdi
  800c72:	00 00 00 
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7a:	48 b9 8c 1f 80 00 00 	movabs $0x801f8c,%rcx
  800c81:	00 00 00 
  800c84:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c8b:	eb 2d                	jmp    800cba <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c91:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c95:	48 85 c0             	test   %rax,%rax
  800c98:	75 07                	jne    800ca1 <write+0xb9>
		return -E_NOT_SUPP;
  800c9a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c9f:	eb 19                	jmp    800cba <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800ca1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ca5:	48 8b 40 18          	mov    0x18(%rax),%rax
  800ca9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800cad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800cb5:	48 89 cf             	mov    %rcx,%rdi
  800cb8:	ff d0                	callq  *%rax
}
  800cba:	c9                   	leaveq 
  800cbb:	c3                   	retq   

0000000000800cbc <seek>:

int
seek(int fdnum, off_t offset)
{
  800cbc:	55                   	push   %rbp
  800cbd:	48 89 e5             	mov    %rsp,%rbp
  800cc0:	48 83 ec 18          	sub    $0x18,%rsp
  800cc4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800cc7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800cca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cd1:	48 89 d6             	mov    %rdx,%rsi
  800cd4:	89 c7                	mov    %eax,%edi
  800cd6:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800cdd:	00 00 00 
  800ce0:	ff d0                	callq  *%rax
  800ce2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ce5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ce9:	79 05                	jns    800cf0 <seek+0x34>
		return r;
  800ceb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cee:	eb 0f                	jmp    800cff <seek+0x43>
	fd->fd_offset = offset;
  800cf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cf4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cf7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800cfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cff:	c9                   	leaveq 
  800d00:	c3                   	retq   

0000000000800d01 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800d01:	55                   	push   %rbp
  800d02:	48 89 e5             	mov    %rsp,%rbp
  800d05:	48 83 ec 30          	sub    $0x30,%rsp
  800d09:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d0c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d0f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d13:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d16:	48 89 d6             	mov    %rdx,%rsi
  800d19:	89 c7                	mov    %eax,%edi
  800d1b:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800d22:	00 00 00 
  800d25:	ff d0                	callq  *%rax
  800d27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d2e:	78 24                	js     800d54 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d34:	8b 00                	mov    (%rax),%eax
  800d36:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d3a:	48 89 d6             	mov    %rdx,%rsi
  800d3d:	89 c7                	mov    %eax,%edi
  800d3f:	48 b8 c5 07 80 00 00 	movabs $0x8007c5,%rax
  800d46:	00 00 00 
  800d49:	ff d0                	callq  *%rax
  800d4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d52:	79 05                	jns    800d59 <ftruncate+0x58>
		return r;
  800d54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d57:	eb 72                	jmp    800dcb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d5d:	8b 40 08             	mov    0x8(%rax),%eax
  800d60:	83 e0 03             	and    $0x3,%eax
  800d63:	85 c0                	test   %eax,%eax
  800d65:	75 3a                	jne    800da1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d67:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d6e:	00 00 00 
  800d71:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d74:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d7a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d7d:	89 c6                	mov    %eax,%esi
  800d7f:	48 bf b0 35 80 00 00 	movabs $0x8035b0,%rdi
  800d86:	00 00 00 
  800d89:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8e:	48 b9 8c 1f 80 00 00 	movabs $0x801f8c,%rcx
  800d95:	00 00 00 
  800d98:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d9f:	eb 2a                	jmp    800dcb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800da1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da5:	48 8b 40 30          	mov    0x30(%rax),%rax
  800da9:	48 85 c0             	test   %rax,%rax
  800dac:	75 07                	jne    800db5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800dae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800db3:	eb 16                	jmp    800dcb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800db5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800db9:	48 8b 40 30          	mov    0x30(%rax),%rax
  800dbd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800dc1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800dc4:	89 ce                	mov    %ecx,%esi
  800dc6:	48 89 d7             	mov    %rdx,%rdi
  800dc9:	ff d0                	callq  *%rax
}
  800dcb:	c9                   	leaveq 
  800dcc:	c3                   	retq   

0000000000800dcd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800dcd:	55                   	push   %rbp
  800dce:	48 89 e5             	mov    %rsp,%rbp
  800dd1:	48 83 ec 30          	sub    $0x30,%rsp
  800dd5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dd8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ddc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800de0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800de3:	48 89 d6             	mov    %rdx,%rsi
  800de6:	89 c7                	mov    %eax,%edi
  800de8:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800def:	00 00 00 
  800df2:	ff d0                	callq  *%rax
  800df4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800df7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dfb:	78 24                	js     800e21 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e01:	8b 00                	mov    (%rax),%eax
  800e03:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e07:	48 89 d6             	mov    %rdx,%rsi
  800e0a:	89 c7                	mov    %eax,%edi
  800e0c:	48 b8 c5 07 80 00 00 	movabs $0x8007c5,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
  800e18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e1f:	79 05                	jns    800e26 <fstat+0x59>
		return r;
  800e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e24:	eb 5e                	jmp    800e84 <fstat+0xb7>
	if (!dev->dev_stat)
  800e26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2a:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e2e:	48 85 c0             	test   %rax,%rax
  800e31:	75 07                	jne    800e3a <fstat+0x6d>
		return -E_NOT_SUPP;
  800e33:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e38:	eb 4a                	jmp    800e84 <fstat+0xb7>
	stat->st_name[0] = 0;
  800e3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e3e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e45:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e4c:	00 00 00 
	stat->st_isdir = 0;
  800e4f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e53:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e5a:	00 00 00 
	stat->st_dev = dev;
  800e5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e65:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e70:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e74:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e78:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e7c:	48 89 ce             	mov    %rcx,%rsi
  800e7f:	48 89 d7             	mov    %rdx,%rdi
  800e82:	ff d0                	callq  *%rax
}
  800e84:	c9                   	leaveq 
  800e85:	c3                   	retq   

0000000000800e86 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e86:	55                   	push   %rbp
  800e87:	48 89 e5             	mov    %rsp,%rbp
  800e8a:	48 83 ec 20          	sub    $0x20,%rsp
  800e8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9a:	be 00 00 00 00       	mov    $0x0,%esi
  800e9f:	48 89 c7             	mov    %rax,%rdi
  800ea2:	48 b8 74 0f 80 00 00 	movabs $0x800f74,%rax
  800ea9:	00 00 00 
  800eac:	ff d0                	callq  *%rax
  800eae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800eb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800eb5:	79 05                	jns    800ebc <stat+0x36>
		return fd;
  800eb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eba:	eb 2f                	jmp    800eeb <stat+0x65>
	r = fstat(fd, stat);
  800ebc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ec3:	48 89 d6             	mov    %rdx,%rsi
  800ec6:	89 c7                	mov    %eax,%edi
  800ec8:	48 b8 cd 0d 80 00 00 	movabs $0x800dcd,%rax
  800ecf:	00 00 00 
  800ed2:	ff d0                	callq  *%rax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800ed7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eda:	89 c7                	mov    %eax,%edi
  800edc:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  800ee3:	00 00 00 
  800ee6:	ff d0                	callq  *%rax
	return r;
  800ee8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800eeb:	c9                   	leaveq 
  800eec:	c3                   	retq   

0000000000800eed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800eed:	55                   	push   %rbp
  800eee:	48 89 e5             	mov    %rsp,%rbp
  800ef1:	48 83 ec 10          	sub    $0x10,%rsp
  800ef5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ef8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800efc:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f03:	00 00 00 
  800f06:	8b 00                	mov    (%rax),%eax
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	75 1d                	jne    800f29 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800f0c:	bf 01 00 00 00       	mov    $0x1,%edi
  800f11:	48 b8 fd 33 80 00 00 	movabs $0x8033fd,%rax
  800f18:	00 00 00 
  800f1b:	ff d0                	callq  *%rax
  800f1d:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f24:	00 00 00 
  800f27:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f29:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f30:	00 00 00 
  800f33:	8b 00                	mov    (%rax),%eax
  800f35:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f38:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f3d:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f44:	00 00 00 
  800f47:	89 c7                	mov    %eax,%edi
  800f49:	48 b8 60 33 80 00 00 	movabs $0x803360,%rax
  800f50:	00 00 00 
  800f53:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f59:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5e:	48 89 c6             	mov    %rax,%rsi
  800f61:	bf 00 00 00 00       	mov    $0x0,%edi
  800f66:	48 b8 9a 32 80 00 00 	movabs $0x80329a,%rax
  800f6d:	00 00 00 
  800f70:	ff d0                	callq  *%rax
}
  800f72:	c9                   	leaveq 
  800f73:	c3                   	retq   

0000000000800f74 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f74:	55                   	push   %rbp
  800f75:	48 89 e5             	mov    %rsp,%rbp
  800f78:	48 83 ec 20          	sub    $0x20,%rsp
  800f7c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f80:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  800f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f87:	48 89 c7             	mov    %rax,%rdi
  800f8a:	48 b8 d5 2a 80 00 00 	movabs $0x802ad5,%rax
  800f91:	00 00 00 
  800f94:	ff d0                	callq  *%rax
  800f96:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f9b:	7e 0a                	jle    800fa7 <open+0x33>
  800f9d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800fa2:	e9 a5 00 00 00       	jmpq   80104c <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  800fa7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800fab:	48 89 c7             	mov    %rax,%rdi
  800fae:	48 b8 d4 05 80 00 00 	movabs $0x8005d4,%rax
  800fb5:	00 00 00 
  800fb8:	ff d0                	callq  *%rax
  800fba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fc1:	79 08                	jns    800fcb <open+0x57>
		return r;
  800fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fc6:	e9 81 00 00 00       	jmpq   80104c <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  800fcb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fd2:	00 00 00 
  800fd5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fd8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  800fde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe2:	48 89 c6             	mov    %rax,%rsi
  800fe5:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fec:	00 00 00 
  800fef:	48 b8 41 2b 80 00 00 	movabs $0x802b41,%rax
  800ff6:	00 00 00 
  800ff9:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  800ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fff:	48 89 c6             	mov    %rax,%rsi
  801002:	bf 01 00 00 00       	mov    $0x1,%edi
  801007:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  80100e:	00 00 00 
  801011:	ff d0                	callq  *%rax
  801013:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801016:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80101a:	79 1d                	jns    801039 <open+0xc5>
		fd_close(fd, 0);
  80101c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801020:	be 00 00 00 00       	mov    $0x0,%esi
  801025:	48 89 c7             	mov    %rax,%rdi
  801028:	48 b8 fc 06 80 00 00 	movabs $0x8006fc,%rax
  80102f:	00 00 00 
  801032:	ff d0                	callq  *%rax
		return r;
  801034:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801037:	eb 13                	jmp    80104c <open+0xd8>
	}
	return fd2num(fd);
  801039:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103d:	48 89 c7             	mov    %rax,%rdi
  801040:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  801047:	00 00 00 
  80104a:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  80104c:	c9                   	leaveq 
  80104d:	c3                   	retq   

000000000080104e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80104e:	55                   	push   %rbp
  80104f:	48 89 e5             	mov    %rsp,%rbp
  801052:	48 83 ec 10          	sub    $0x10,%rsp
  801056:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80105a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105e:	8b 50 0c             	mov    0xc(%rax),%edx
  801061:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801068:	00 00 00 
  80106b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80106d:	be 00 00 00 00       	mov    $0x0,%esi
  801072:	bf 06 00 00 00       	mov    $0x6,%edi
  801077:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  80107e:	00 00 00 
  801081:	ff d0                	callq  *%rax
}
  801083:	c9                   	leaveq 
  801084:	c3                   	retq   

0000000000801085 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801085:	55                   	push   %rbp
  801086:	48 89 e5             	mov    %rsp,%rbp
  801089:	48 83 ec 30          	sub    $0x30,%rsp
  80108d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801091:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801095:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801099:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109d:	8b 50 0c             	mov    0xc(%rax),%edx
  8010a0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010a7:	00 00 00 
  8010aa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8010ac:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010b3:	00 00 00 
  8010b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8010ba:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  8010be:	be 00 00 00 00       	mov    $0x0,%esi
  8010c3:	bf 03 00 00 00       	mov    $0x3,%edi
  8010c8:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  8010cf:	00 00 00 
  8010d2:	ff d0                	callq  *%rax
  8010d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010db:	79 05                	jns    8010e2 <devfile_read+0x5d>
		return r;
  8010dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e0:	eb 26                	jmp    801108 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  8010e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010e5:	48 63 d0             	movslq %eax,%rdx
  8010e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010ec:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8010f3:	00 00 00 
  8010f6:	48 89 c7             	mov    %rax,%rdi
  8010f9:	48 b8 7c 2f 80 00 00 	movabs $0x802f7c,%rax
  801100:	00 00 00 
  801103:	ff d0                	callq  *%rax
	return r;
  801105:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  801108:	c9                   	leaveq 
  801109:	c3                   	retq   

000000000080110a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80110a:	55                   	push   %rbp
  80110b:	48 89 e5             	mov    %rsp,%rbp
  80110e:	48 83 ec 30          	sub    $0x30,%rsp
  801112:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801116:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80111a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  80111e:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  801125:	00 
	n = n > max ? max : n;
  801126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80112e:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  801133:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801137:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113b:	8b 50 0c             	mov    0xc(%rax),%edx
  80113e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801145:	00 00 00 
  801148:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80114a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801151:	00 00 00 
  801154:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801158:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80115c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801160:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801164:	48 89 c6             	mov    %rax,%rsi
  801167:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  80116e:	00 00 00 
  801171:	48 b8 7c 2f 80 00 00 	movabs $0x802f7c,%rax
  801178:	00 00 00 
  80117b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  80117d:	be 00 00 00 00       	mov    $0x0,%esi
  801182:	bf 04 00 00 00       	mov    $0x4,%edi
  801187:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  80118e:	00 00 00 
  801191:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  801193:	c9                   	leaveq 
  801194:	c3                   	retq   

0000000000801195 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801195:	55                   	push   %rbp
  801196:	48 89 e5             	mov    %rsp,%rbp
  801199:	48 83 ec 20          	sub    $0x20,%rsp
  80119d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8011a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a9:	8b 50 0c             	mov    0xc(%rax),%edx
  8011ac:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011b3:	00 00 00 
  8011b6:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8011b8:	be 00 00 00 00       	mov    $0x0,%esi
  8011bd:	bf 05 00 00 00       	mov    $0x5,%edi
  8011c2:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  8011c9:	00 00 00 
  8011cc:	ff d0                	callq  *%rax
  8011ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011d5:	79 05                	jns    8011dc <devfile_stat+0x47>
		return r;
  8011d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011da:	eb 56                	jmp    801232 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8011dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e0:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8011e7:	00 00 00 
  8011ea:	48 89 c7             	mov    %rax,%rdi
  8011ed:	48 b8 41 2b 80 00 00 	movabs $0x802b41,%rax
  8011f4:	00 00 00 
  8011f7:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8011f9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801200:	00 00 00 
  801203:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801209:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801213:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80121a:	00 00 00 
  80121d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801223:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801227:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80122d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801232:	c9                   	leaveq 
  801233:	c3                   	retq   

0000000000801234 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801234:	55                   	push   %rbp
  801235:	48 89 e5             	mov    %rsp,%rbp
  801238:	48 83 ec 10          	sub    $0x10,%rsp
  80123c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801240:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801243:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801247:	8b 50 0c             	mov    0xc(%rax),%edx
  80124a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801251:	00 00 00 
  801254:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801256:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80125d:	00 00 00 
  801260:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801263:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801266:	be 00 00 00 00       	mov    $0x0,%esi
  80126b:	bf 02 00 00 00       	mov    $0x2,%edi
  801270:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  801277:	00 00 00 
  80127a:	ff d0                	callq  *%rax
}
  80127c:	c9                   	leaveq 
  80127d:	c3                   	retq   

000000000080127e <remove>:

// Delete a file
int
remove(const char *path)
{
  80127e:	55                   	push   %rbp
  80127f:	48 89 e5             	mov    %rsp,%rbp
  801282:	48 83 ec 10          	sub    $0x10,%rsp
  801286:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	48 89 c7             	mov    %rax,%rdi
  801291:	48 b8 d5 2a 80 00 00 	movabs $0x802ad5,%rax
  801298:	00 00 00 
  80129b:	ff d0                	callq  *%rax
  80129d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8012a2:	7e 07                	jle    8012ab <remove+0x2d>
		return -E_BAD_PATH;
  8012a4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8012a9:	eb 33                	jmp    8012de <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8012ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012af:	48 89 c6             	mov    %rax,%rsi
  8012b2:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8012b9:	00 00 00 
  8012bc:	48 b8 41 2b 80 00 00 	movabs $0x802b41,%rax
  8012c3:	00 00 00 
  8012c6:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8012c8:	be 00 00 00 00       	mov    $0x0,%esi
  8012cd:	bf 07 00 00 00       	mov    $0x7,%edi
  8012d2:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  8012d9:	00 00 00 
  8012dc:	ff d0                	callq  *%rax
}
  8012de:	c9                   	leaveq 
  8012df:	c3                   	retq   

00000000008012e0 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8012e0:	55                   	push   %rbp
  8012e1:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8012e4:	be 00 00 00 00       	mov    $0x0,%esi
  8012e9:	bf 08 00 00 00       	mov    $0x8,%edi
  8012ee:	48 b8 ed 0e 80 00 00 	movabs $0x800eed,%rax
  8012f5:	00 00 00 
  8012f8:	ff d0                	callq  *%rax
}
  8012fa:	5d                   	pop    %rbp
  8012fb:	c3                   	retq   

00000000008012fc <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8012fc:	55                   	push   %rbp
  8012fd:	48 89 e5             	mov    %rsp,%rbp
  801300:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801307:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80130e:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801315:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80131c:	be 00 00 00 00       	mov    $0x0,%esi
  801321:	48 89 c7             	mov    %rax,%rdi
  801324:	48 b8 74 0f 80 00 00 	movabs $0x800f74,%rax
  80132b:	00 00 00 
  80132e:	ff d0                	callq  *%rax
  801330:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801333:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801337:	79 28                	jns    801361 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80133c:	89 c6                	mov    %eax,%esi
  80133e:	48 bf d6 35 80 00 00 	movabs $0x8035d6,%rdi
  801345:	00 00 00 
  801348:	b8 00 00 00 00       	mov    $0x0,%eax
  80134d:	48 ba 8c 1f 80 00 00 	movabs $0x801f8c,%rdx
  801354:	00 00 00 
  801357:	ff d2                	callq  *%rdx
		return fd_src;
  801359:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80135c:	e9 74 01 00 00       	jmpq   8014d5 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801361:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801368:	be 01 01 00 00       	mov    $0x101,%esi
  80136d:	48 89 c7             	mov    %rax,%rdi
  801370:	48 b8 74 0f 80 00 00 	movabs $0x800f74,%rax
  801377:	00 00 00 
  80137a:	ff d0                	callq  *%rax
  80137c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80137f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801383:	79 39                	jns    8013be <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801385:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801388:	89 c6                	mov    %eax,%esi
  80138a:	48 bf ec 35 80 00 00 	movabs $0x8035ec,%rdi
  801391:	00 00 00 
  801394:	b8 00 00 00 00       	mov    $0x0,%eax
  801399:	48 ba 8c 1f 80 00 00 	movabs $0x801f8c,%rdx
  8013a0:	00 00 00 
  8013a3:	ff d2                	callq  *%rdx
		close(fd_src);
  8013a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013a8:	89 c7                	mov    %eax,%edi
  8013aa:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  8013b1:	00 00 00 
  8013b4:	ff d0                	callq  *%rax
		return fd_dest;
  8013b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8013b9:	e9 17 01 00 00       	jmpq   8014d5 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8013be:	eb 74                	jmp    801434 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8013c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c3:	48 63 d0             	movslq %eax,%rdx
  8013c6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8013cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8013d0:	48 89 ce             	mov    %rcx,%rsi
  8013d3:	89 c7                	mov    %eax,%edi
  8013d5:	48 b8 e8 0b 80 00 00 	movabs $0x800be8,%rax
  8013dc:	00 00 00 
  8013df:	ff d0                	callq  *%rax
  8013e1:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8013e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8013e8:	79 4a                	jns    801434 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8013ea:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8013ed:	89 c6                	mov    %eax,%esi
  8013ef:	48 bf 06 36 80 00 00 	movabs $0x803606,%rdi
  8013f6:	00 00 00 
  8013f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fe:	48 ba 8c 1f 80 00 00 	movabs $0x801f8c,%rdx
  801405:	00 00 00 
  801408:	ff d2                	callq  *%rdx
			close(fd_src);
  80140a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80140d:	89 c7                	mov    %eax,%edi
  80140f:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  801416:	00 00 00 
  801419:	ff d0                	callq  *%rax
			close(fd_dest);
  80141b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80141e:	89 c7                	mov    %eax,%edi
  801420:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  801427:	00 00 00 
  80142a:	ff d0                	callq  *%rax
			return write_size;
  80142c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80142f:	e9 a1 00 00 00       	jmpq   8014d5 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801434:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80143b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80143e:	ba 00 02 00 00       	mov    $0x200,%edx
  801443:	48 89 ce             	mov    %rcx,%rsi
  801446:	89 c7                	mov    %eax,%edi
  801448:	48 b8 9e 0a 80 00 00 	movabs $0x800a9e,%rax
  80144f:	00 00 00 
  801452:	ff d0                	callq  *%rax
  801454:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801457:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80145b:	0f 8f 5f ff ff ff    	jg     8013c0 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  801461:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801465:	79 47                	jns    8014ae <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  801467:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80146a:	89 c6                	mov    %eax,%esi
  80146c:	48 bf 19 36 80 00 00 	movabs $0x803619,%rdi
  801473:	00 00 00 
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	48 ba 8c 1f 80 00 00 	movabs $0x801f8c,%rdx
  801482:	00 00 00 
  801485:	ff d2                	callq  *%rdx
		close(fd_src);
  801487:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80148a:	89 c7                	mov    %eax,%edi
  80148c:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  801493:	00 00 00 
  801496:	ff d0                	callq  *%rax
		close(fd_dest);
  801498:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80149b:	89 c7                	mov    %eax,%edi
  80149d:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  8014a4:	00 00 00 
  8014a7:	ff d0                	callq  *%rax
		return read_size;
  8014a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014ac:	eb 27                	jmp    8014d5 <copy+0x1d9>
	}
	close(fd_src);
  8014ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014b1:	89 c7                	mov    %eax,%edi
  8014b3:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  8014ba:	00 00 00 
  8014bd:	ff d0                	callq  *%rax
	close(fd_dest);
  8014bf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014c2:	89 c7                	mov    %eax,%edi
  8014c4:	48 b8 7c 08 80 00 00 	movabs $0x80087c,%rax
  8014cb:	00 00 00 
  8014ce:	ff d0                	callq  *%rax
	return 0;
  8014d0:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8014d5:	c9                   	leaveq 
  8014d6:	c3                   	retq   

00000000008014d7 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8014d7:	55                   	push   %rbp
  8014d8:	48 89 e5             	mov    %rsp,%rbp
  8014db:	53                   	push   %rbx
  8014dc:	48 83 ec 38          	sub    $0x38,%rsp
  8014e0:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8014e4:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8014e8:	48 89 c7             	mov    %rax,%rdi
  8014eb:	48 b8 d4 05 80 00 00 	movabs $0x8005d4,%rax
  8014f2:	00 00 00 
  8014f5:	ff d0                	callq  *%rax
  8014f7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8014fe:	0f 88 bf 01 00 00    	js     8016c3 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801504:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801508:	ba 07 04 00 00       	mov    $0x407,%edx
  80150d:	48 89 c6             	mov    %rax,%rsi
  801510:	bf 00 00 00 00       	mov    $0x0,%edi
  801515:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  80151c:	00 00 00 
  80151f:	ff d0                	callq  *%rax
  801521:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801524:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801528:	0f 88 95 01 00 00    	js     8016c3 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80152e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801532:	48 89 c7             	mov    %rax,%rdi
  801535:	48 b8 d4 05 80 00 00 	movabs $0x8005d4,%rax
  80153c:	00 00 00 
  80153f:	ff d0                	callq  *%rax
  801541:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801544:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801548:	0f 88 5d 01 00 00    	js     8016ab <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80154e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801552:	ba 07 04 00 00       	mov    $0x407,%edx
  801557:	48 89 c6             	mov    %rax,%rsi
  80155a:	bf 00 00 00 00       	mov    $0x0,%edi
  80155f:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  801566:	00 00 00 
  801569:	ff d0                	callq  *%rax
  80156b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80156e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801572:	0f 88 33 01 00 00    	js     8016ab <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801578:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157c:	48 89 c7             	mov    %rax,%rdi
  80157f:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  801586:	00 00 00 
  801589:	ff d0                	callq  *%rax
  80158b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80158f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801593:	ba 07 04 00 00       	mov    $0x407,%edx
  801598:	48 89 c6             	mov    %rax,%rsi
  80159b:	bf 00 00 00 00       	mov    $0x0,%edi
  8015a0:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  8015a7:	00 00 00 
  8015aa:	ff d0                	callq  *%rax
  8015ac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015af:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015b3:	79 05                	jns    8015ba <pipe+0xe3>
		goto err2;
  8015b5:	e9 d9 00 00 00       	jmpq   801693 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015be:	48 89 c7             	mov    %rax,%rdi
  8015c1:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  8015c8:	00 00 00 
  8015cb:	ff d0                	callq  *%rax
  8015cd:	48 89 c2             	mov    %rax,%rdx
  8015d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015d4:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8015da:	48 89 d1             	mov    %rdx,%rcx
  8015dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e2:	48 89 c6             	mov    %rax,%rsi
  8015e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8015ea:	48 b8 69 03 80 00 00 	movabs $0x800369,%rax
  8015f1:	00 00 00 
  8015f4:	ff d0                	callq  *%rax
  8015f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015fd:	79 1b                	jns    80161a <pipe+0x143>
		goto err3;
  8015ff:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801600:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801604:	48 89 c6             	mov    %rax,%rsi
  801607:	bf 00 00 00 00       	mov    $0x0,%edi
  80160c:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  801613:	00 00 00 
  801616:	ff d0                	callq  *%rax
  801618:	eb 79                	jmp    801693 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801625:	00 00 00 
  801628:	8b 12                	mov    (%rdx),%edx
  80162a:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80162c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801630:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  801637:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80163b:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801642:	00 00 00 
  801645:	8b 12                	mov    (%rdx),%edx
  801647:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801649:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80164d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801654:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801658:	48 89 c7             	mov    %rax,%rdi
  80165b:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  801662:	00 00 00 
  801665:	ff d0                	callq  *%rax
  801667:	89 c2                	mov    %eax,%edx
  801669:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80166d:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80166f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801673:	48 8d 58 04          	lea    0x4(%rax),%rbx
  801677:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80167b:	48 89 c7             	mov    %rax,%rdi
  80167e:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  801685:	00 00 00 
  801688:	ff d0                	callq  *%rax
  80168a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80168c:	b8 00 00 00 00       	mov    $0x0,%eax
  801691:	eb 33                	jmp    8016c6 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801693:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801697:	48 89 c6             	mov    %rax,%rsi
  80169a:	bf 00 00 00 00       	mov    $0x0,%edi
  80169f:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  8016a6:	00 00 00 
  8016a9:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	48 89 c6             	mov    %rax,%rsi
  8016b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8016b7:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  8016be:	00 00 00 
  8016c1:	ff d0                	callq  *%rax
err:
	return r;
  8016c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8016c6:	48 83 c4 38          	add    $0x38,%rsp
  8016ca:	5b                   	pop    %rbx
  8016cb:	5d                   	pop    %rbp
  8016cc:	c3                   	retq   

00000000008016cd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8016cd:	55                   	push   %rbp
  8016ce:	48 89 e5             	mov    %rsp,%rbp
  8016d1:	53                   	push   %rbx
  8016d2:	48 83 ec 28          	sub    $0x28,%rsp
  8016d6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016da:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8016de:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8016e5:	00 00 00 
  8016e8:	48 8b 00             	mov    (%rax),%rax
  8016eb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8016f1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8016f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f8:	48 89 c7             	mov    %rax,%rdi
  8016fb:	48 b8 7f 34 80 00 00 	movabs $0x80347f,%rax
  801702:	00 00 00 
  801705:	ff d0                	callq  *%rax
  801707:	89 c3                	mov    %eax,%ebx
  801709:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170d:	48 89 c7             	mov    %rax,%rdi
  801710:	48 b8 7f 34 80 00 00 	movabs $0x80347f,%rax
  801717:	00 00 00 
  80171a:	ff d0                	callq  *%rax
  80171c:	39 c3                	cmp    %eax,%ebx
  80171e:	0f 94 c0             	sete   %al
  801721:	0f b6 c0             	movzbl %al,%eax
  801724:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  801727:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80172e:	00 00 00 
  801731:	48 8b 00             	mov    (%rax),%rax
  801734:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80173a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80173d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801740:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801743:	75 05                	jne    80174a <_pipeisclosed+0x7d>
			return ret;
  801745:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801748:	eb 4f                	jmp    801799 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80174a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80174d:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801750:	74 42                	je     801794 <_pipeisclosed+0xc7>
  801752:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  801756:	75 3c                	jne    801794 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801758:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80175f:	00 00 00 
  801762:	48 8b 00             	mov    (%rax),%rax
  801765:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80176b:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80176e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801771:	89 c6                	mov    %eax,%esi
  801773:	48 bf 34 36 80 00 00 	movabs $0x803634,%rdi
  80177a:	00 00 00 
  80177d:	b8 00 00 00 00       	mov    $0x0,%eax
  801782:	49 b8 8c 1f 80 00 00 	movabs $0x801f8c,%r8
  801789:	00 00 00 
  80178c:	41 ff d0             	callq  *%r8
	}
  80178f:	e9 4a ff ff ff       	jmpq   8016de <_pipeisclosed+0x11>
  801794:	e9 45 ff ff ff       	jmpq   8016de <_pipeisclosed+0x11>
}
  801799:	48 83 c4 28          	add    $0x28,%rsp
  80179d:	5b                   	pop    %rbx
  80179e:	5d                   	pop    %rbp
  80179f:	c3                   	retq   

00000000008017a0 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8017a0:	55                   	push   %rbp
  8017a1:	48 89 e5             	mov    %rsp,%rbp
  8017a4:	48 83 ec 30          	sub    $0x30,%rsp
  8017a8:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ab:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8017af:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017b2:	48 89 d6             	mov    %rdx,%rsi
  8017b5:	89 c7                	mov    %eax,%edi
  8017b7:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  8017be:	00 00 00 
  8017c1:	ff d0                	callq  *%rax
  8017c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017ca:	79 05                	jns    8017d1 <pipeisclosed+0x31>
		return r;
  8017cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017cf:	eb 31                	jmp    801802 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8017d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d5:	48 89 c7             	mov    %rax,%rdi
  8017d8:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  8017df:	00 00 00 
  8017e2:	ff d0                	callq  *%rax
  8017e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8017e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f0:	48 89 d6             	mov    %rdx,%rsi
  8017f3:	48 89 c7             	mov    %rax,%rdi
  8017f6:	48 b8 cd 16 80 00 00 	movabs $0x8016cd,%rax
  8017fd:	00 00 00 
  801800:	ff d0                	callq  *%rax
}
  801802:	c9                   	leaveq 
  801803:	c3                   	retq   

0000000000801804 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801804:	55                   	push   %rbp
  801805:	48 89 e5             	mov    %rsp,%rbp
  801808:	48 83 ec 40          	sub    $0x40,%rsp
  80180c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801810:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801814:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801818:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181c:	48 89 c7             	mov    %rax,%rdi
  80181f:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  801826:	00 00 00 
  801829:	ff d0                	callq  *%rax
  80182b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80182f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801833:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801837:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80183e:	00 
  80183f:	e9 92 00 00 00       	jmpq   8018d6 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  801844:	eb 41                	jmp    801887 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801846:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80184b:	74 09                	je     801856 <devpipe_read+0x52>
				return i;
  80184d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801851:	e9 92 00 00 00       	jmpq   8018e8 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801856:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80185a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185e:	48 89 d6             	mov    %rdx,%rsi
  801861:	48 89 c7             	mov    %rax,%rdi
  801864:	48 b8 cd 16 80 00 00 	movabs $0x8016cd,%rax
  80186b:	00 00 00 
  80186e:	ff d0                	callq  *%rax
  801870:	85 c0                	test   %eax,%eax
  801872:	74 07                	je     80187b <devpipe_read+0x77>
				return 0;
  801874:	b8 00 00 00 00       	mov    $0x0,%eax
  801879:	eb 6d                	jmp    8018e8 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80187b:	48 b8 db 02 80 00 00 	movabs $0x8002db,%rax
  801882:	00 00 00 
  801885:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801887:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80188b:	8b 10                	mov    (%rax),%edx
  80188d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801891:	8b 40 04             	mov    0x4(%rax),%eax
  801894:	39 c2                	cmp    %eax,%edx
  801896:	74 ae                	je     801846 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801898:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80189c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8018a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a8:	8b 00                	mov    (%rax),%eax
  8018aa:	99                   	cltd   
  8018ab:	c1 ea 1b             	shr    $0x1b,%edx
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	83 e0 1f             	and    $0x1f,%eax
  8018b3:	29 d0                	sub    %edx,%eax
  8018b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018b9:	48 98                	cltq   
  8018bb:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8018c0:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8018c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c6:	8b 00                	mov    (%rax),%eax
  8018c8:	8d 50 01             	lea    0x1(%rax),%edx
  8018cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cf:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018da:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8018de:	0f 82 60 ff ff ff    	jb     801844 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8018e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8018e8:	c9                   	leaveq 
  8018e9:	c3                   	retq   

00000000008018ea <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8018ea:	55                   	push   %rbp
  8018eb:	48 89 e5             	mov    %rsp,%rbp
  8018ee:	48 83 ec 40          	sub    $0x40,%rsp
  8018f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018fa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8018fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801902:	48 89 c7             	mov    %rax,%rdi
  801905:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  80190c:	00 00 00 
  80190f:	ff d0                	callq  *%rax
  801911:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801915:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801919:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80191d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801924:	00 
  801925:	e9 8e 00 00 00       	jmpq   8019b8 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80192a:	eb 31                	jmp    80195d <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80192c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801934:	48 89 d6             	mov    %rdx,%rsi
  801937:	48 89 c7             	mov    %rax,%rdi
  80193a:	48 b8 cd 16 80 00 00 	movabs $0x8016cd,%rax
  801941:	00 00 00 
  801944:	ff d0                	callq  *%rax
  801946:	85 c0                	test   %eax,%eax
  801948:	74 07                	je     801951 <devpipe_write+0x67>
				return 0;
  80194a:	b8 00 00 00 00       	mov    $0x0,%eax
  80194f:	eb 79                	jmp    8019ca <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801951:	48 b8 db 02 80 00 00 	movabs $0x8002db,%rax
  801958:	00 00 00 
  80195b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80195d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801961:	8b 40 04             	mov    0x4(%rax),%eax
  801964:	48 63 d0             	movslq %eax,%rdx
  801967:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80196b:	8b 00                	mov    (%rax),%eax
  80196d:	48 98                	cltq   
  80196f:	48 83 c0 20          	add    $0x20,%rax
  801973:	48 39 c2             	cmp    %rax,%rdx
  801976:	73 b4                	jae    80192c <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801978:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80197c:	8b 40 04             	mov    0x4(%rax),%eax
  80197f:	99                   	cltd   
  801980:	c1 ea 1b             	shr    $0x1b,%edx
  801983:	01 d0                	add    %edx,%eax
  801985:	83 e0 1f             	and    $0x1f,%eax
  801988:	29 d0                	sub    %edx,%eax
  80198a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80198e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801992:	48 01 ca             	add    %rcx,%rdx
  801995:	0f b6 0a             	movzbl (%rdx),%ecx
  801998:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80199c:	48 98                	cltq   
  80199e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8019a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019a6:	8b 40 04             	mov    0x4(%rax),%eax
  8019a9:	8d 50 01             	lea    0x1(%rax),%edx
  8019ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019b0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019b3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019bc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8019c0:	0f 82 64 ff ff ff    	jb     80192a <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8019c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019ca:	c9                   	leaveq 
  8019cb:	c3                   	retq   

00000000008019cc <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019cc:	55                   	push   %rbp
  8019cd:	48 89 e5             	mov    %rsp,%rbp
  8019d0:	48 83 ec 20          	sub    $0x20,%rsp
  8019d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e0:	48 89 c7             	mov    %rax,%rdi
  8019e3:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  8019ea:	00 00 00 
  8019ed:	ff d0                	callq  *%rax
  8019ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8019f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019f7:	48 be 47 36 80 00 00 	movabs $0x803647,%rsi
  8019fe:	00 00 00 
  801a01:	48 89 c7             	mov    %rax,%rdi
  801a04:	48 b8 41 2b 80 00 00 	movabs $0x802b41,%rax
  801a0b:	00 00 00 
  801a0e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801a10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a14:	8b 50 04             	mov    0x4(%rax),%edx
  801a17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a1b:	8b 00                	mov    (%rax),%eax
  801a1d:	29 c2                	sub    %eax,%edx
  801a1f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a23:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801a29:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a2d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801a34:	00 00 00 
	stat->st_dev = &devpipe;
  801a37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a3b:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801a42:	00 00 00 
  801a45:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801a4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a51:	c9                   	leaveq 
  801a52:	c3                   	retq   

0000000000801a53 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a53:	55                   	push   %rbp
  801a54:	48 89 e5             	mov    %rsp,%rbp
  801a57:	48 83 ec 10          	sub    $0x10,%rsp
  801a5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801a5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a63:	48 89 c6             	mov    %rax,%rsi
  801a66:	bf 00 00 00 00       	mov    $0x0,%edi
  801a6b:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  801a72:	00 00 00 
  801a75:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801a77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a7b:	48 89 c7             	mov    %rax,%rdi
  801a7e:	48 b8 a9 05 80 00 00 	movabs $0x8005a9,%rax
  801a85:	00 00 00 
  801a88:	ff d0                	callq  *%rax
  801a8a:	48 89 c6             	mov    %rax,%rsi
  801a8d:	bf 00 00 00 00       	mov    $0x0,%edi
  801a92:	48 b8 c4 03 80 00 00 	movabs $0x8003c4,%rax
  801a99:	00 00 00 
  801a9c:	ff d0                	callq  *%rax
}
  801a9e:	c9                   	leaveq 
  801a9f:	c3                   	retq   

0000000000801aa0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801aa0:	55                   	push   %rbp
  801aa1:	48 89 e5             	mov    %rsp,%rbp
  801aa4:	48 83 ec 20          	sub    $0x20,%rsp
  801aa8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801aab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801aae:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801ab1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801ab5:	be 01 00 00 00       	mov    $0x1,%esi
  801aba:	48 89 c7             	mov    %rax,%rdi
  801abd:	48 b8 d1 01 80 00 00 	movabs $0x8001d1,%rax
  801ac4:	00 00 00 
  801ac7:	ff d0                	callq  *%rax
}
  801ac9:	c9                   	leaveq 
  801aca:	c3                   	retq   

0000000000801acb <getchar>:

int
getchar(void)
{
  801acb:	55                   	push   %rbp
  801acc:	48 89 e5             	mov    %rsp,%rbp
  801acf:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801ad3:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801ad7:	ba 01 00 00 00       	mov    $0x1,%edx
  801adc:	48 89 c6             	mov    %rax,%rsi
  801adf:	bf 00 00 00 00       	mov    $0x0,%edi
  801ae4:	48 b8 9e 0a 80 00 00 	movabs $0x800a9e,%rax
  801aeb:	00 00 00 
  801aee:	ff d0                	callq  *%rax
  801af0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801af3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801af7:	79 05                	jns    801afe <getchar+0x33>
		return r;
  801af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801afc:	eb 14                	jmp    801b12 <getchar+0x47>
	if (r < 1)
  801afe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b02:	7f 07                	jg     801b0b <getchar+0x40>
		return -E_EOF;
  801b04:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801b09:	eb 07                	jmp    801b12 <getchar+0x47>
	return c;
  801b0b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801b0f:	0f b6 c0             	movzbl %al,%eax
}
  801b12:	c9                   	leaveq 
  801b13:	c3                   	retq   

0000000000801b14 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801b14:	55                   	push   %rbp
  801b15:	48 89 e5             	mov    %rsp,%rbp
  801b18:	48 83 ec 20          	sub    $0x20,%rsp
  801b1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b1f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b23:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b26:	48 89 d6             	mov    %rdx,%rsi
  801b29:	89 c7                	mov    %eax,%edi
  801b2b:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  801b32:	00 00 00 
  801b35:	ff d0                	callq  *%rax
  801b37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b3e:	79 05                	jns    801b45 <iscons+0x31>
		return r;
  801b40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b43:	eb 1a                	jmp    801b5f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801b45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b49:	8b 10                	mov    (%rax),%edx
  801b4b:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801b52:	00 00 00 
  801b55:	8b 00                	mov    (%rax),%eax
  801b57:	39 c2                	cmp    %eax,%edx
  801b59:	0f 94 c0             	sete   %al
  801b5c:	0f b6 c0             	movzbl %al,%eax
}
  801b5f:	c9                   	leaveq 
  801b60:	c3                   	retq   

0000000000801b61 <opencons>:

int
opencons(void)
{
  801b61:	55                   	push   %rbp
  801b62:	48 89 e5             	mov    %rsp,%rbp
  801b65:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801b69:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801b6d:	48 89 c7             	mov    %rax,%rdi
  801b70:	48 b8 d4 05 80 00 00 	movabs $0x8005d4,%rax
  801b77:	00 00 00 
  801b7a:	ff d0                	callq  *%rax
  801b7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b83:	79 05                	jns    801b8a <opencons+0x29>
		return r;
  801b85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b88:	eb 5b                	jmp    801be5 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b8e:	ba 07 04 00 00       	mov    $0x407,%edx
  801b93:	48 89 c6             	mov    %rax,%rsi
  801b96:	bf 00 00 00 00       	mov    $0x0,%edi
  801b9b:	48 b8 19 03 80 00 00 	movabs $0x800319,%rax
  801ba2:	00 00 00 
  801ba5:	ff d0                	callq  *%rax
  801ba7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801baa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bae:	79 05                	jns    801bb5 <opencons+0x54>
		return r;
  801bb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb3:	eb 30                	jmp    801be5 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801bb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bb9:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801bc0:	00 00 00 
  801bc3:	8b 12                	mov    (%rdx),%edx
  801bc5:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801bc7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bcb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801bd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bd6:	48 89 c7             	mov    %rax,%rdi
  801bd9:	48 b8 86 05 80 00 00 	movabs $0x800586,%rax
  801be0:	00 00 00 
  801be3:	ff d0                	callq  *%rax
}
  801be5:	c9                   	leaveq 
  801be6:	c3                   	retq   

0000000000801be7 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801be7:	55                   	push   %rbp
  801be8:	48 89 e5             	mov    %rsp,%rbp
  801beb:	48 83 ec 30          	sub    $0x30,%rsp
  801bef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bf3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bf7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801bfb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c00:	75 07                	jne    801c09 <devcons_read+0x22>
		return 0;
  801c02:	b8 00 00 00 00       	mov    $0x0,%eax
  801c07:	eb 4b                	jmp    801c54 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801c09:	eb 0c                	jmp    801c17 <devcons_read+0x30>
		sys_yield();
  801c0b:	48 b8 db 02 80 00 00 	movabs $0x8002db,%rax
  801c12:	00 00 00 
  801c15:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801c17:	48 b8 1b 02 80 00 00 	movabs $0x80021b,%rax
  801c1e:	00 00 00 
  801c21:	ff d0                	callq  *%rax
  801c23:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c2a:	74 df                	je     801c0b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801c2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c30:	79 05                	jns    801c37 <devcons_read+0x50>
		return c;
  801c32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c35:	eb 1d                	jmp    801c54 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801c37:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801c3b:	75 07                	jne    801c44 <devcons_read+0x5d>
		return 0;
  801c3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c42:	eb 10                	jmp    801c54 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801c44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c47:	89 c2                	mov    %eax,%edx
  801c49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c4d:	88 10                	mov    %dl,(%rax)
	return 1;
  801c4f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c54:	c9                   	leaveq 
  801c55:	c3                   	retq   

0000000000801c56 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c56:	55                   	push   %rbp
  801c57:	48 89 e5             	mov    %rsp,%rbp
  801c5a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801c61:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801c68:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801c6f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c7d:	eb 76                	jmp    801cf5 <devcons_write+0x9f>
		m = n - tot;
  801c7f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801c86:	89 c2                	mov    %eax,%edx
  801c88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c8b:	29 c2                	sub    %eax,%edx
  801c8d:	89 d0                	mov    %edx,%eax
  801c8f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801c92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c95:	83 f8 7f             	cmp    $0x7f,%eax
  801c98:	76 07                	jbe    801ca1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801c9a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801ca1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ca4:	48 63 d0             	movslq %eax,%rdx
  801ca7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801caa:	48 63 c8             	movslq %eax,%rcx
  801cad:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801cb4:	48 01 c1             	add    %rax,%rcx
  801cb7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801cbe:	48 89 ce             	mov    %rcx,%rsi
  801cc1:	48 89 c7             	mov    %rax,%rdi
  801cc4:	48 b8 65 2e 80 00 00 	movabs $0x802e65,%rax
  801ccb:	00 00 00 
  801cce:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801cd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cd3:	48 63 d0             	movslq %eax,%rdx
  801cd6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801cdd:	48 89 d6             	mov    %rdx,%rsi
  801ce0:	48 89 c7             	mov    %rax,%rdi
  801ce3:	48 b8 d1 01 80 00 00 	movabs $0x8001d1,%rax
  801cea:	00 00 00 
  801ced:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cf2:	01 45 fc             	add    %eax,-0x4(%rbp)
  801cf5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf8:	48 98                	cltq   
  801cfa:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801d01:	0f 82 78 ff ff ff    	jb     801c7f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801d07:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d0a:	c9                   	leaveq 
  801d0b:	c3                   	retq   

0000000000801d0c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801d0c:	55                   	push   %rbp
  801d0d:	48 89 e5             	mov    %rsp,%rbp
  801d10:	48 83 ec 08          	sub    $0x8,%rsp
  801d14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1d:	c9                   	leaveq 
  801d1e:	c3                   	retq   

0000000000801d1f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d1f:	55                   	push   %rbp
  801d20:	48 89 e5             	mov    %rsp,%rbp
  801d23:	48 83 ec 10          	sub    $0x10,%rsp
  801d27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801d2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d33:	48 be 53 36 80 00 00 	movabs $0x803653,%rsi
  801d3a:	00 00 00 
  801d3d:	48 89 c7             	mov    %rax,%rdi
  801d40:	48 b8 41 2b 80 00 00 	movabs $0x802b41,%rax
  801d47:	00 00 00 
  801d4a:	ff d0                	callq  *%rax
	return 0;
  801d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d51:	c9                   	leaveq 
  801d52:	c3                   	retq   

0000000000801d53 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d53:	55                   	push   %rbp
  801d54:	48 89 e5             	mov    %rsp,%rbp
  801d57:	53                   	push   %rbx
  801d58:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801d5f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801d66:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801d6c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801d73:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801d7a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801d81:	84 c0                	test   %al,%al
  801d83:	74 23                	je     801da8 <_panic+0x55>
  801d85:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801d8c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801d90:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801d94:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801d98:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801d9c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801da0:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801da4:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801da8:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801daf:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801db6:	00 00 00 
  801db9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801dc0:	00 00 00 
  801dc3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801dc7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801dce:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801dd5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ddc:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801de3:	00 00 00 
  801de6:	48 8b 18             	mov    (%rax),%rbx
  801de9:	48 b8 9d 02 80 00 00 	movabs $0x80029d,%rax
  801df0:	00 00 00 
  801df3:	ff d0                	callq  *%rax
  801df5:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801dfb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801e02:	41 89 c8             	mov    %ecx,%r8d
  801e05:	48 89 d1             	mov    %rdx,%rcx
  801e08:	48 89 da             	mov    %rbx,%rdx
  801e0b:	89 c6                	mov    %eax,%esi
  801e0d:	48 bf 60 36 80 00 00 	movabs $0x803660,%rdi
  801e14:	00 00 00 
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1c:	49 b9 8c 1f 80 00 00 	movabs $0x801f8c,%r9
  801e23:	00 00 00 
  801e26:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e29:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801e30:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801e37:	48 89 d6             	mov    %rdx,%rsi
  801e3a:	48 89 c7             	mov    %rax,%rdi
  801e3d:	48 b8 e0 1e 80 00 00 	movabs $0x801ee0,%rax
  801e44:	00 00 00 
  801e47:	ff d0                	callq  *%rax
	cprintf("\n");
  801e49:	48 bf 83 36 80 00 00 	movabs $0x803683,%rdi
  801e50:	00 00 00 
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	48 ba 8c 1f 80 00 00 	movabs $0x801f8c,%rdx
  801e5f:	00 00 00 
  801e62:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e64:	cc                   	int3   
  801e65:	eb fd                	jmp    801e64 <_panic+0x111>

0000000000801e67 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801e67:	55                   	push   %rbp
  801e68:	48 89 e5             	mov    %rsp,%rbp
  801e6b:	48 83 ec 10          	sub    $0x10,%rsp
  801e6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e7a:	8b 00                	mov    (%rax),%eax
  801e7c:	8d 48 01             	lea    0x1(%rax),%ecx
  801e7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e83:	89 0a                	mov    %ecx,(%rdx)
  801e85:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e88:	89 d1                	mov    %edx,%ecx
  801e8a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e8e:	48 98                	cltq   
  801e90:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801e94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e98:	8b 00                	mov    (%rax),%eax
  801e9a:	3d ff 00 00 00       	cmp    $0xff,%eax
  801e9f:	75 2c                	jne    801ecd <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801ea1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ea5:	8b 00                	mov    (%rax),%eax
  801ea7:	48 98                	cltq   
  801ea9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ead:	48 83 c2 08          	add    $0x8,%rdx
  801eb1:	48 89 c6             	mov    %rax,%rsi
  801eb4:	48 89 d7             	mov    %rdx,%rdi
  801eb7:	48 b8 d1 01 80 00 00 	movabs $0x8001d1,%rax
  801ebe:	00 00 00 
  801ec1:	ff d0                	callq  *%rax
        b->idx = 0;
  801ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed1:	8b 40 04             	mov    0x4(%rax),%eax
  801ed4:	8d 50 01             	lea    0x1(%rax),%edx
  801ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801edb:	89 50 04             	mov    %edx,0x4(%rax)
}
  801ede:	c9                   	leaveq 
  801edf:	c3                   	retq   

0000000000801ee0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801ee0:	55                   	push   %rbp
  801ee1:	48 89 e5             	mov    %rsp,%rbp
  801ee4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801eeb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801ef2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801ef9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801f00:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801f07:	48 8b 0a             	mov    (%rdx),%rcx
  801f0a:	48 89 08             	mov    %rcx,(%rax)
  801f0d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f11:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f15:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f19:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801f1d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801f24:	00 00 00 
    b.cnt = 0;
  801f27:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801f2e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801f31:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801f38:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801f3f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801f46:	48 89 c6             	mov    %rax,%rsi
  801f49:	48 bf 67 1e 80 00 00 	movabs $0x801e67,%rdi
  801f50:	00 00 00 
  801f53:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  801f5a:	00 00 00 
  801f5d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  801f5f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801f65:	48 98                	cltq   
  801f67:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801f6e:	48 83 c2 08          	add    $0x8,%rdx
  801f72:	48 89 c6             	mov    %rax,%rsi
  801f75:	48 89 d7             	mov    %rdx,%rdi
  801f78:	48 b8 d1 01 80 00 00 	movabs $0x8001d1,%rax
  801f7f:	00 00 00 
  801f82:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  801f84:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801f8a:	c9                   	leaveq 
  801f8b:	c3                   	retq   

0000000000801f8c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  801f8c:	55                   	push   %rbp
  801f8d:	48 89 e5             	mov    %rsp,%rbp
  801f90:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801f97:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801f9e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801fa5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801fac:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801fb3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801fba:	84 c0                	test   %al,%al
  801fbc:	74 20                	je     801fde <cprintf+0x52>
  801fbe:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801fc2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801fc6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801fca:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801fce:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801fd2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801fd6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801fda:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801fde:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  801fe5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  801fec:	00 00 00 
  801fef:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801ff6:	00 00 00 
  801ff9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801ffd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802004:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80200b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  802012:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802019:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802020:	48 8b 0a             	mov    (%rdx),%rcx
  802023:	48 89 08             	mov    %rcx,(%rax)
  802026:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80202a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80202e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802032:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802036:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80203d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802044:	48 89 d6             	mov    %rdx,%rsi
  802047:	48 89 c7             	mov    %rax,%rdi
  80204a:	48 b8 e0 1e 80 00 00 	movabs $0x801ee0,%rax
  802051:	00 00 00 
  802054:	ff d0                	callq  *%rax
  802056:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80205c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802062:	c9                   	leaveq 
  802063:	c3                   	retq   

0000000000802064 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802064:	55                   	push   %rbp
  802065:	48 89 e5             	mov    %rsp,%rbp
  802068:	53                   	push   %rbx
  802069:	48 83 ec 38          	sub    $0x38,%rsp
  80206d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802071:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802075:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802079:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80207c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802080:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802084:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802087:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80208b:	77 3b                	ja     8020c8 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80208d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802090:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802094:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  802097:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80209b:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a0:	48 f7 f3             	div    %rbx
  8020a3:	48 89 c2             	mov    %rax,%rdx
  8020a6:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8020a9:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8020ac:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8020b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b4:	41 89 f9             	mov    %edi,%r9d
  8020b7:	48 89 c7             	mov    %rax,%rdi
  8020ba:	48 b8 64 20 80 00 00 	movabs $0x802064,%rax
  8020c1:	00 00 00 
  8020c4:	ff d0                	callq  *%rax
  8020c6:	eb 1e                	jmp    8020e6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8020c8:	eb 12                	jmp    8020dc <printnum+0x78>
			putch(padc, putdat);
  8020ca:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8020ce:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8020d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d5:	48 89 ce             	mov    %rcx,%rsi
  8020d8:	89 d7                	mov    %edx,%edi
  8020da:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8020dc:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8020e0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8020e4:	7f e4                	jg     8020ca <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8020e6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8020e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f2:	48 f7 f1             	div    %rcx
  8020f5:	48 89 d0             	mov    %rdx,%rax
  8020f8:	48 ba 90 38 80 00 00 	movabs $0x803890,%rdx
  8020ff:	00 00 00 
  802102:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  802106:	0f be d0             	movsbl %al,%edx
  802109:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80210d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802111:	48 89 ce             	mov    %rcx,%rsi
  802114:	89 d7                	mov    %edx,%edi
  802116:	ff d0                	callq  *%rax
}
  802118:	48 83 c4 38          	add    $0x38,%rsp
  80211c:	5b                   	pop    %rbx
  80211d:	5d                   	pop    %rbp
  80211e:	c3                   	retq   

000000000080211f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80211f:	55                   	push   %rbp
  802120:	48 89 e5             	mov    %rsp,%rbp
  802123:	48 83 ec 1c          	sub    $0x1c,%rsp
  802127:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80212b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80212e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802132:	7e 52                	jle    802186 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  802134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802138:	8b 00                	mov    (%rax),%eax
  80213a:	83 f8 30             	cmp    $0x30,%eax
  80213d:	73 24                	jae    802163 <getuint+0x44>
  80213f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802143:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802147:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214b:	8b 00                	mov    (%rax),%eax
  80214d:	89 c0                	mov    %eax,%eax
  80214f:	48 01 d0             	add    %rdx,%rax
  802152:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802156:	8b 12                	mov    (%rdx),%edx
  802158:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80215b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80215f:	89 0a                	mov    %ecx,(%rdx)
  802161:	eb 17                	jmp    80217a <getuint+0x5b>
  802163:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802167:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80216b:	48 89 d0             	mov    %rdx,%rax
  80216e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802172:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802176:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80217a:	48 8b 00             	mov    (%rax),%rax
  80217d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802181:	e9 a3 00 00 00       	jmpq   802229 <getuint+0x10a>
	else if (lflag)
  802186:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80218a:	74 4f                	je     8021db <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80218c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802190:	8b 00                	mov    (%rax),%eax
  802192:	83 f8 30             	cmp    $0x30,%eax
  802195:	73 24                	jae    8021bb <getuint+0x9c>
  802197:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80219f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a3:	8b 00                	mov    (%rax),%eax
  8021a5:	89 c0                	mov    %eax,%eax
  8021a7:	48 01 d0             	add    %rdx,%rax
  8021aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021ae:	8b 12                	mov    (%rdx),%edx
  8021b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8021b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021b7:	89 0a                	mov    %ecx,(%rdx)
  8021b9:	eb 17                	jmp    8021d2 <getuint+0xb3>
  8021bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021c3:	48 89 d0             	mov    %rdx,%rax
  8021c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8021ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8021d2:	48 8b 00             	mov    (%rax),%rax
  8021d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8021d9:	eb 4e                	jmp    802229 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8021db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021df:	8b 00                	mov    (%rax),%eax
  8021e1:	83 f8 30             	cmp    $0x30,%eax
  8021e4:	73 24                	jae    80220a <getuint+0xeb>
  8021e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ea:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8021ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f2:	8b 00                	mov    (%rax),%eax
  8021f4:	89 c0                	mov    %eax,%eax
  8021f6:	48 01 d0             	add    %rdx,%rax
  8021f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021fd:	8b 12                	mov    (%rdx),%edx
  8021ff:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802202:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802206:	89 0a                	mov    %ecx,(%rdx)
  802208:	eb 17                	jmp    802221 <getuint+0x102>
  80220a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802212:	48 89 d0             	mov    %rdx,%rax
  802215:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802219:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80221d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802221:	8b 00                	mov    (%rax),%eax
  802223:	89 c0                	mov    %eax,%eax
  802225:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802229:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80222d:	c9                   	leaveq 
  80222e:	c3                   	retq   

000000000080222f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80222f:	55                   	push   %rbp
  802230:	48 89 e5             	mov    %rsp,%rbp
  802233:	48 83 ec 1c          	sub    $0x1c,%rsp
  802237:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80223b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80223e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802242:	7e 52                	jle    802296 <getint+0x67>
		x=va_arg(*ap, long long);
  802244:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802248:	8b 00                	mov    (%rax),%eax
  80224a:	83 f8 30             	cmp    $0x30,%eax
  80224d:	73 24                	jae    802273 <getint+0x44>
  80224f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802253:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802257:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225b:	8b 00                	mov    (%rax),%eax
  80225d:	89 c0                	mov    %eax,%eax
  80225f:	48 01 d0             	add    %rdx,%rax
  802262:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802266:	8b 12                	mov    (%rdx),%edx
  802268:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80226b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80226f:	89 0a                	mov    %ecx,(%rdx)
  802271:	eb 17                	jmp    80228a <getint+0x5b>
  802273:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802277:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80227b:	48 89 d0             	mov    %rdx,%rax
  80227e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802282:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802286:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80228a:	48 8b 00             	mov    (%rax),%rax
  80228d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802291:	e9 a3 00 00 00       	jmpq   802339 <getint+0x10a>
	else if (lflag)
  802296:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80229a:	74 4f                	je     8022eb <getint+0xbc>
		x=va_arg(*ap, long);
  80229c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a0:	8b 00                	mov    (%rax),%eax
  8022a2:	83 f8 30             	cmp    $0x30,%eax
  8022a5:	73 24                	jae    8022cb <getint+0x9c>
  8022a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b3:	8b 00                	mov    (%rax),%eax
  8022b5:	89 c0                	mov    %eax,%eax
  8022b7:	48 01 d0             	add    %rdx,%rax
  8022ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022be:	8b 12                	mov    (%rdx),%edx
  8022c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c7:	89 0a                	mov    %ecx,(%rdx)
  8022c9:	eb 17                	jmp    8022e2 <getint+0xb3>
  8022cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022d3:	48 89 d0             	mov    %rdx,%rax
  8022d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022e2:	48 8b 00             	mov    (%rax),%rax
  8022e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022e9:	eb 4e                	jmp    802339 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8022eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ef:	8b 00                	mov    (%rax),%eax
  8022f1:	83 f8 30             	cmp    $0x30,%eax
  8022f4:	73 24                	jae    80231a <getint+0xeb>
  8022f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802302:	8b 00                	mov    (%rax),%eax
  802304:	89 c0                	mov    %eax,%eax
  802306:	48 01 d0             	add    %rdx,%rax
  802309:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80230d:	8b 12                	mov    (%rdx),%edx
  80230f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802312:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802316:	89 0a                	mov    %ecx,(%rdx)
  802318:	eb 17                	jmp    802331 <getint+0x102>
  80231a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802322:	48 89 d0             	mov    %rdx,%rax
  802325:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802329:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80232d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802331:	8b 00                	mov    (%rax),%eax
  802333:	48 98                	cltq   
  802335:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802339:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80233d:	c9                   	leaveq 
  80233e:	c3                   	retq   

000000000080233f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80233f:	55                   	push   %rbp
  802340:	48 89 e5             	mov    %rsp,%rbp
  802343:	41 54                	push   %r12
  802345:	53                   	push   %rbx
  802346:	48 83 ec 60          	sub    $0x60,%rsp
  80234a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80234e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802352:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802356:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80235a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80235e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802362:	48 8b 0a             	mov    (%rdx),%rcx
  802365:	48 89 08             	mov    %rcx,(%rax)
  802368:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80236c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802370:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802374:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802378:	eb 17                	jmp    802391 <vprintfmt+0x52>
			if (ch == '\0')
  80237a:	85 db                	test   %ebx,%ebx
  80237c:	0f 84 cc 04 00 00    	je     80284e <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802382:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802386:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80238a:	48 89 d6             	mov    %rdx,%rsi
  80238d:	89 df                	mov    %ebx,%edi
  80238f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802391:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802395:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802399:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80239d:	0f b6 00             	movzbl (%rax),%eax
  8023a0:	0f b6 d8             	movzbl %al,%ebx
  8023a3:	83 fb 25             	cmp    $0x25,%ebx
  8023a6:	75 d2                	jne    80237a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8023a8:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8023ac:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8023b3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8023ba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8023c1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8023c8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8023cc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8023d0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8023d4:	0f b6 00             	movzbl (%rax),%eax
  8023d7:	0f b6 d8             	movzbl %al,%ebx
  8023da:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8023dd:	83 f8 55             	cmp    $0x55,%eax
  8023e0:	0f 87 34 04 00 00    	ja     80281a <vprintfmt+0x4db>
  8023e6:	89 c0                	mov    %eax,%eax
  8023e8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8023ef:	00 
  8023f0:	48 b8 b8 38 80 00 00 	movabs $0x8038b8,%rax
  8023f7:	00 00 00 
  8023fa:	48 01 d0             	add    %rdx,%rax
  8023fd:	48 8b 00             	mov    (%rax),%rax
  802400:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802402:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802406:	eb c0                	jmp    8023c8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802408:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80240c:	eb ba                	jmp    8023c8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80240e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802415:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802418:	89 d0                	mov    %edx,%eax
  80241a:	c1 e0 02             	shl    $0x2,%eax
  80241d:	01 d0                	add    %edx,%eax
  80241f:	01 c0                	add    %eax,%eax
  802421:	01 d8                	add    %ebx,%eax
  802423:	83 e8 30             	sub    $0x30,%eax
  802426:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802429:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80242d:	0f b6 00             	movzbl (%rax),%eax
  802430:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802433:	83 fb 2f             	cmp    $0x2f,%ebx
  802436:	7e 0c                	jle    802444 <vprintfmt+0x105>
  802438:	83 fb 39             	cmp    $0x39,%ebx
  80243b:	7f 07                	jg     802444 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80243d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802442:	eb d1                	jmp    802415 <vprintfmt+0xd6>
			goto process_precision;
  802444:	eb 58                	jmp    80249e <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  802446:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802449:	83 f8 30             	cmp    $0x30,%eax
  80244c:	73 17                	jae    802465 <vprintfmt+0x126>
  80244e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802452:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802455:	89 c0                	mov    %eax,%eax
  802457:	48 01 d0             	add    %rdx,%rax
  80245a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80245d:	83 c2 08             	add    $0x8,%edx
  802460:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802463:	eb 0f                	jmp    802474 <vprintfmt+0x135>
  802465:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802469:	48 89 d0             	mov    %rdx,%rax
  80246c:	48 83 c2 08          	add    $0x8,%rdx
  802470:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802474:	8b 00                	mov    (%rax),%eax
  802476:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802479:	eb 23                	jmp    80249e <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80247b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80247f:	79 0c                	jns    80248d <vprintfmt+0x14e>
				width = 0;
  802481:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802488:	e9 3b ff ff ff       	jmpq   8023c8 <vprintfmt+0x89>
  80248d:	e9 36 ff ff ff       	jmpq   8023c8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802492:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802499:	e9 2a ff ff ff       	jmpq   8023c8 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80249e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8024a2:	79 12                	jns    8024b6 <vprintfmt+0x177>
				width = precision, precision = -1;
  8024a4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8024a7:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8024aa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8024b1:	e9 12 ff ff ff       	jmpq   8023c8 <vprintfmt+0x89>
  8024b6:	e9 0d ff ff ff       	jmpq   8023c8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8024bb:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8024bf:	e9 04 ff ff ff       	jmpq   8023c8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8024c4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024c7:	83 f8 30             	cmp    $0x30,%eax
  8024ca:	73 17                	jae    8024e3 <vprintfmt+0x1a4>
  8024cc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024d3:	89 c0                	mov    %eax,%eax
  8024d5:	48 01 d0             	add    %rdx,%rax
  8024d8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8024db:	83 c2 08             	add    $0x8,%edx
  8024de:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8024e1:	eb 0f                	jmp    8024f2 <vprintfmt+0x1b3>
  8024e3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024e7:	48 89 d0             	mov    %rdx,%rax
  8024ea:	48 83 c2 08          	add    $0x8,%rdx
  8024ee:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8024f2:	8b 10                	mov    (%rax),%edx
  8024f4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8024f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8024fc:	48 89 ce             	mov    %rcx,%rsi
  8024ff:	89 d7                	mov    %edx,%edi
  802501:	ff d0                	callq  *%rax
			break;
  802503:	e9 40 03 00 00       	jmpq   802848 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  802508:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80250b:	83 f8 30             	cmp    $0x30,%eax
  80250e:	73 17                	jae    802527 <vprintfmt+0x1e8>
  802510:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802514:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802517:	89 c0                	mov    %eax,%eax
  802519:	48 01 d0             	add    %rdx,%rax
  80251c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80251f:	83 c2 08             	add    $0x8,%edx
  802522:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802525:	eb 0f                	jmp    802536 <vprintfmt+0x1f7>
  802527:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80252b:	48 89 d0             	mov    %rdx,%rax
  80252e:	48 83 c2 08          	add    $0x8,%rdx
  802532:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802536:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  802538:	85 db                	test   %ebx,%ebx
  80253a:	79 02                	jns    80253e <vprintfmt+0x1ff>
				err = -err;
  80253c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80253e:	83 fb 15             	cmp    $0x15,%ebx
  802541:	7f 16                	jg     802559 <vprintfmt+0x21a>
  802543:	48 b8 e0 37 80 00 00 	movabs $0x8037e0,%rax
  80254a:	00 00 00 
  80254d:	48 63 d3             	movslq %ebx,%rdx
  802550:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  802554:	4d 85 e4             	test   %r12,%r12
  802557:	75 2e                	jne    802587 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802559:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80255d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802561:	89 d9                	mov    %ebx,%ecx
  802563:	48 ba a1 38 80 00 00 	movabs $0x8038a1,%rdx
  80256a:	00 00 00 
  80256d:	48 89 c7             	mov    %rax,%rdi
  802570:	b8 00 00 00 00       	mov    $0x0,%eax
  802575:	49 b8 57 28 80 00 00 	movabs $0x802857,%r8
  80257c:	00 00 00 
  80257f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802582:	e9 c1 02 00 00       	jmpq   802848 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  802587:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80258b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80258f:	4c 89 e1             	mov    %r12,%rcx
  802592:	48 ba aa 38 80 00 00 	movabs $0x8038aa,%rdx
  802599:	00 00 00 
  80259c:	48 89 c7             	mov    %rax,%rdi
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a4:	49 b8 57 28 80 00 00 	movabs $0x802857,%r8
  8025ab:	00 00 00 
  8025ae:	41 ff d0             	callq  *%r8
			break;
  8025b1:	e9 92 02 00 00       	jmpq   802848 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8025b6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025b9:	83 f8 30             	cmp    $0x30,%eax
  8025bc:	73 17                	jae    8025d5 <vprintfmt+0x296>
  8025be:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025c2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025c5:	89 c0                	mov    %eax,%eax
  8025c7:	48 01 d0             	add    %rdx,%rax
  8025ca:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025cd:	83 c2 08             	add    $0x8,%edx
  8025d0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025d3:	eb 0f                	jmp    8025e4 <vprintfmt+0x2a5>
  8025d5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025d9:	48 89 d0             	mov    %rdx,%rax
  8025dc:	48 83 c2 08          	add    $0x8,%rdx
  8025e0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025e4:	4c 8b 20             	mov    (%rax),%r12
  8025e7:	4d 85 e4             	test   %r12,%r12
  8025ea:	75 0a                	jne    8025f6 <vprintfmt+0x2b7>
				p = "(null)";
  8025ec:	49 bc ad 38 80 00 00 	movabs $0x8038ad,%r12
  8025f3:	00 00 00 
			if (width > 0 && padc != '-')
  8025f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8025fa:	7e 3f                	jle    80263b <vprintfmt+0x2fc>
  8025fc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802600:	74 39                	je     80263b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802602:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802605:	48 98                	cltq   
  802607:	48 89 c6             	mov    %rax,%rsi
  80260a:	4c 89 e7             	mov    %r12,%rdi
  80260d:	48 b8 03 2b 80 00 00 	movabs $0x802b03,%rax
  802614:	00 00 00 
  802617:	ff d0                	callq  *%rax
  802619:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80261c:	eb 17                	jmp    802635 <vprintfmt+0x2f6>
					putch(padc, putdat);
  80261e:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802622:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  802626:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80262a:	48 89 ce             	mov    %rcx,%rsi
  80262d:	89 d7                	mov    %edx,%edi
  80262f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802631:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802635:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802639:	7f e3                	jg     80261e <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80263b:	eb 37                	jmp    802674 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80263d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802641:	74 1e                	je     802661 <vprintfmt+0x322>
  802643:	83 fb 1f             	cmp    $0x1f,%ebx
  802646:	7e 05                	jle    80264d <vprintfmt+0x30e>
  802648:	83 fb 7e             	cmp    $0x7e,%ebx
  80264b:	7e 14                	jle    802661 <vprintfmt+0x322>
					putch('?', putdat);
  80264d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802651:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802655:	48 89 d6             	mov    %rdx,%rsi
  802658:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80265d:	ff d0                	callq  *%rax
  80265f:	eb 0f                	jmp    802670 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802661:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802665:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802669:	48 89 d6             	mov    %rdx,%rsi
  80266c:	89 df                	mov    %ebx,%edi
  80266e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802670:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802674:	4c 89 e0             	mov    %r12,%rax
  802677:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80267b:	0f b6 00             	movzbl (%rax),%eax
  80267e:	0f be d8             	movsbl %al,%ebx
  802681:	85 db                	test   %ebx,%ebx
  802683:	74 10                	je     802695 <vprintfmt+0x356>
  802685:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802689:	78 b2                	js     80263d <vprintfmt+0x2fe>
  80268b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80268f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802693:	79 a8                	jns    80263d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802695:	eb 16                	jmp    8026ad <vprintfmt+0x36e>
				putch(' ', putdat);
  802697:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80269b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80269f:	48 89 d6             	mov    %rdx,%rsi
  8026a2:	bf 20 00 00 00       	mov    $0x20,%edi
  8026a7:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8026a9:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8026ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026b1:	7f e4                	jg     802697 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8026b3:	e9 90 01 00 00       	jmpq   802848 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8026b8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8026bc:	be 03 00 00 00       	mov    $0x3,%esi
  8026c1:	48 89 c7             	mov    %rax,%rdi
  8026c4:	48 b8 2f 22 80 00 00 	movabs $0x80222f,%rax
  8026cb:	00 00 00 
  8026ce:	ff d0                	callq  *%rax
  8026d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8026d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d8:	48 85 c0             	test   %rax,%rax
  8026db:	79 1d                	jns    8026fa <vprintfmt+0x3bb>
				putch('-', putdat);
  8026dd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026e1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026e5:	48 89 d6             	mov    %rdx,%rsi
  8026e8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8026ed:	ff d0                	callq  *%rax
				num = -(long long) num;
  8026ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f3:	48 f7 d8             	neg    %rax
  8026f6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8026fa:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802701:	e9 d5 00 00 00       	jmpq   8027db <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  802706:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80270a:	be 03 00 00 00       	mov    $0x3,%esi
  80270f:	48 89 c7             	mov    %rax,%rdi
  802712:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  802719:	00 00 00 
  80271c:	ff d0                	callq  *%rax
  80271e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802722:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802729:	e9 ad 00 00 00       	jmpq   8027db <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  80272e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802732:	be 03 00 00 00       	mov    $0x3,%esi
  802737:	48 89 c7             	mov    %rax,%rdi
  80273a:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  802741:	00 00 00 
  802744:	ff d0                	callq  *%rax
  802746:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  80274a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  802751:	e9 85 00 00 00       	jmpq   8027db <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  802756:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80275a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80275e:	48 89 d6             	mov    %rdx,%rsi
  802761:	bf 30 00 00 00       	mov    $0x30,%edi
  802766:	ff d0                	callq  *%rax
			putch('x', putdat);
  802768:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80276c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802770:	48 89 d6             	mov    %rdx,%rsi
  802773:	bf 78 00 00 00       	mov    $0x78,%edi
  802778:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80277a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80277d:	83 f8 30             	cmp    $0x30,%eax
  802780:	73 17                	jae    802799 <vprintfmt+0x45a>
  802782:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802786:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802789:	89 c0                	mov    %eax,%eax
  80278b:	48 01 d0             	add    %rdx,%rax
  80278e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802791:	83 c2 08             	add    $0x8,%edx
  802794:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802797:	eb 0f                	jmp    8027a8 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  802799:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80279d:	48 89 d0             	mov    %rdx,%rax
  8027a0:	48 83 c2 08          	add    $0x8,%rdx
  8027a4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8027a8:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8027ab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8027af:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8027b6:	eb 23                	jmp    8027db <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8027b8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027bc:	be 03 00 00 00       	mov    $0x3,%esi
  8027c1:	48 89 c7             	mov    %rax,%rdi
  8027c4:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  8027cb:	00 00 00 
  8027ce:	ff d0                	callq  *%rax
  8027d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8027d4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8027db:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8027e0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8027e3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8027e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027ea:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8027ee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027f2:	45 89 c1             	mov    %r8d,%r9d
  8027f5:	41 89 f8             	mov    %edi,%r8d
  8027f8:	48 89 c7             	mov    %rax,%rdi
  8027fb:	48 b8 64 20 80 00 00 	movabs $0x802064,%rax
  802802:	00 00 00 
  802805:	ff d0                	callq  *%rax
			break;
  802807:	eb 3f                	jmp    802848 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  802809:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80280d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802811:	48 89 d6             	mov    %rdx,%rsi
  802814:	89 df                	mov    %ebx,%edi
  802816:	ff d0                	callq  *%rax
			break;
  802818:	eb 2e                	jmp    802848 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80281a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80281e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802822:	48 89 d6             	mov    %rdx,%rsi
  802825:	bf 25 00 00 00       	mov    $0x25,%edi
  80282a:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80282c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802831:	eb 05                	jmp    802838 <vprintfmt+0x4f9>
  802833:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802838:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80283c:	48 83 e8 01          	sub    $0x1,%rax
  802840:	0f b6 00             	movzbl (%rax),%eax
  802843:	3c 25                	cmp    $0x25,%al
  802845:	75 ec                	jne    802833 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  802847:	90                   	nop
		}
	}
  802848:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802849:	e9 43 fb ff ff       	jmpq   802391 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80284e:	48 83 c4 60          	add    $0x60,%rsp
  802852:	5b                   	pop    %rbx
  802853:	41 5c                	pop    %r12
  802855:	5d                   	pop    %rbp
  802856:	c3                   	retq   

0000000000802857 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802857:	55                   	push   %rbp
  802858:	48 89 e5             	mov    %rsp,%rbp
  80285b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802862:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802869:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802870:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802877:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80287e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802885:	84 c0                	test   %al,%al
  802887:	74 20                	je     8028a9 <printfmt+0x52>
  802889:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80288d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802891:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802895:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802899:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80289d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8028a1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8028a5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8028a9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8028b0:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8028b7:	00 00 00 
  8028ba:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8028c1:	00 00 00 
  8028c4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8028c8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8028cf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8028d6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8028dd:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8028e4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8028eb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8028f2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8028f9:	48 89 c7             	mov    %rax,%rdi
  8028fc:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  802903:	00 00 00 
  802906:	ff d0                	callq  *%rax
	va_end(ap);
}
  802908:	c9                   	leaveq 
  802909:	c3                   	retq   

000000000080290a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80290a:	55                   	push   %rbp
  80290b:	48 89 e5             	mov    %rsp,%rbp
  80290e:	48 83 ec 10          	sub    $0x10,%rsp
  802912:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802915:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802919:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291d:	8b 40 10             	mov    0x10(%rax),%eax
  802920:	8d 50 01             	lea    0x1(%rax),%edx
  802923:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802927:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80292a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80292e:	48 8b 10             	mov    (%rax),%rdx
  802931:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802935:	48 8b 40 08          	mov    0x8(%rax),%rax
  802939:	48 39 c2             	cmp    %rax,%rdx
  80293c:	73 17                	jae    802955 <sprintputch+0x4b>
		*b->buf++ = ch;
  80293e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802942:	48 8b 00             	mov    (%rax),%rax
  802945:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802949:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80294d:	48 89 0a             	mov    %rcx,(%rdx)
  802950:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802953:	88 10                	mov    %dl,(%rax)
}
  802955:	c9                   	leaveq 
  802956:	c3                   	retq   

0000000000802957 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802957:	55                   	push   %rbp
  802958:	48 89 e5             	mov    %rsp,%rbp
  80295b:	48 83 ec 50          	sub    $0x50,%rsp
  80295f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  802963:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  802966:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80296a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80296e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802972:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802976:	48 8b 0a             	mov    (%rdx),%rcx
  802979:	48 89 08             	mov    %rcx,(%rax)
  80297c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802980:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802984:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802988:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80298c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802990:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802994:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802997:	48 98                	cltq   
  802999:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80299d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029a1:	48 01 d0             	add    %rdx,%rax
  8029a4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8029a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8029af:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8029b4:	74 06                	je     8029bc <vsnprintf+0x65>
  8029b6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8029ba:	7f 07                	jg     8029c3 <vsnprintf+0x6c>
		return -E_INVAL;
  8029bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029c1:	eb 2f                	jmp    8029f2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8029c3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8029c7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8029cb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8029cf:	48 89 c6             	mov    %rax,%rsi
  8029d2:	48 bf 0a 29 80 00 00 	movabs $0x80290a,%rdi
  8029d9:	00 00 00 
  8029dc:	48 b8 3f 23 80 00 00 	movabs $0x80233f,%rax
  8029e3:	00 00 00 
  8029e6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8029e8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029ec:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8029ef:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8029f2:	c9                   	leaveq 
  8029f3:	c3                   	retq   

00000000008029f4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8029f4:	55                   	push   %rbp
  8029f5:	48 89 e5             	mov    %rsp,%rbp
  8029f8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8029ff:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802a06:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802a0c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802a13:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802a1a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802a21:	84 c0                	test   %al,%al
  802a23:	74 20                	je     802a45 <snprintf+0x51>
  802a25:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802a29:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802a2d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802a31:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802a35:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802a39:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802a3d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802a41:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802a45:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802a4c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802a53:	00 00 00 
  802a56:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802a5d:	00 00 00 
  802a60:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a64:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802a6b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802a72:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802a79:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802a80:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802a87:	48 8b 0a             	mov    (%rdx),%rcx
  802a8a:	48 89 08             	mov    %rcx,(%rax)
  802a8d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a91:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a95:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a99:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802a9d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802aa4:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802aab:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802ab1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802ab8:	48 89 c7             	mov    %rax,%rdi
  802abb:	48 b8 57 29 80 00 00 	movabs $0x802957,%rax
  802ac2:	00 00 00 
  802ac5:	ff d0                	callq  *%rax
  802ac7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802acd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802ad3:	c9                   	leaveq 
  802ad4:	c3                   	retq   

0000000000802ad5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802ad5:	55                   	push   %rbp
  802ad6:	48 89 e5             	mov    %rsp,%rbp
  802ad9:	48 83 ec 18          	sub    $0x18,%rsp
  802add:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802ae1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ae8:	eb 09                	jmp    802af3 <strlen+0x1e>
		n++;
  802aea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802aee:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802af3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af7:	0f b6 00             	movzbl (%rax),%eax
  802afa:	84 c0                	test   %al,%al
  802afc:	75 ec                	jne    802aea <strlen+0x15>
		n++;
	return n;
  802afe:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b01:	c9                   	leaveq 
  802b02:	c3                   	retq   

0000000000802b03 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802b03:	55                   	push   %rbp
  802b04:	48 89 e5             	mov    %rsp,%rbp
  802b07:	48 83 ec 20          	sub    $0x20,%rsp
  802b0b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b0f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802b13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b1a:	eb 0e                	jmp    802b2a <strnlen+0x27>
		n++;
  802b1c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802b20:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802b25:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802b2a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802b2f:	74 0b                	je     802b3c <strnlen+0x39>
  802b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b35:	0f b6 00             	movzbl (%rax),%eax
  802b38:	84 c0                	test   %al,%al
  802b3a:	75 e0                	jne    802b1c <strnlen+0x19>
		n++;
	return n;
  802b3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b3f:	c9                   	leaveq 
  802b40:	c3                   	retq   

0000000000802b41 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802b41:	55                   	push   %rbp
  802b42:	48 89 e5             	mov    %rsp,%rbp
  802b45:	48 83 ec 20          	sub    $0x20,%rsp
  802b49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b4d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802b51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b55:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802b59:	90                   	nop
  802b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b5e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802b62:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802b66:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b6a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802b6e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802b72:	0f b6 12             	movzbl (%rdx),%edx
  802b75:	88 10                	mov    %dl,(%rax)
  802b77:	0f b6 00             	movzbl (%rax),%eax
  802b7a:	84 c0                	test   %al,%al
  802b7c:	75 dc                	jne    802b5a <strcpy+0x19>
		/* do nothing */;
	return ret;
  802b7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802b82:	c9                   	leaveq 
  802b83:	c3                   	retq   

0000000000802b84 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802b84:	55                   	push   %rbp
  802b85:	48 89 e5             	mov    %rsp,%rbp
  802b88:	48 83 ec 20          	sub    $0x20,%rsp
  802b8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802b94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b98:	48 89 c7             	mov    %rax,%rdi
  802b9b:	48 b8 d5 2a 80 00 00 	movabs $0x802ad5,%rax
  802ba2:	00 00 00 
  802ba5:	ff d0                	callq  *%rax
  802ba7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802baa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bad:	48 63 d0             	movslq %eax,%rdx
  802bb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bb4:	48 01 c2             	add    %rax,%rdx
  802bb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bbb:	48 89 c6             	mov    %rax,%rsi
  802bbe:	48 89 d7             	mov    %rdx,%rdi
  802bc1:	48 b8 41 2b 80 00 00 	movabs $0x802b41,%rax
  802bc8:	00 00 00 
  802bcb:	ff d0                	callq  *%rax
	return dst;
  802bcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802bd1:	c9                   	leaveq 
  802bd2:	c3                   	retq   

0000000000802bd3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802bd3:	55                   	push   %rbp
  802bd4:	48 89 e5             	mov    %rsp,%rbp
  802bd7:	48 83 ec 28          	sub    $0x28,%rsp
  802bdb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bdf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802be3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802be7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802beb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802bef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802bf6:	00 
  802bf7:	eb 2a                	jmp    802c23 <strncpy+0x50>
		*dst++ = *src;
  802bf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c01:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c05:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c09:	0f b6 12             	movzbl (%rdx),%edx
  802c0c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802c0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c12:	0f b6 00             	movzbl (%rax),%eax
  802c15:	84 c0                	test   %al,%al
  802c17:	74 05                	je     802c1e <strncpy+0x4b>
			src++;
  802c19:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802c1e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802c23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c27:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c2b:	72 cc                	jb     802bf9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802c2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802c31:	c9                   	leaveq 
  802c32:	c3                   	retq   

0000000000802c33 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802c33:	55                   	push   %rbp
  802c34:	48 89 e5             	mov    %rsp,%rbp
  802c37:	48 83 ec 28          	sub    $0x28,%rsp
  802c3b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c3f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c43:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802c47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802c4f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c54:	74 3d                	je     802c93 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802c56:	eb 1d                	jmp    802c75 <strlcpy+0x42>
			*dst++ = *src++;
  802c58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c60:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c64:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c68:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c6c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c70:	0f b6 12             	movzbl (%rdx),%edx
  802c73:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802c75:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802c7a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c7f:	74 0b                	je     802c8c <strlcpy+0x59>
  802c81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c85:	0f b6 00             	movzbl (%rax),%eax
  802c88:	84 c0                	test   %al,%al
  802c8a:	75 cc                	jne    802c58 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802c8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c90:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802c93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c9b:	48 29 c2             	sub    %rax,%rdx
  802c9e:	48 89 d0             	mov    %rdx,%rax
}
  802ca1:	c9                   	leaveq 
  802ca2:	c3                   	retq   

0000000000802ca3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802ca3:	55                   	push   %rbp
  802ca4:	48 89 e5             	mov    %rsp,%rbp
  802ca7:	48 83 ec 10          	sub    $0x10,%rsp
  802cab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802caf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802cb3:	eb 0a                	jmp    802cbf <strcmp+0x1c>
		p++, q++;
  802cb5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802cba:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802cbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cc3:	0f b6 00             	movzbl (%rax),%eax
  802cc6:	84 c0                	test   %al,%al
  802cc8:	74 12                	je     802cdc <strcmp+0x39>
  802cca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cce:	0f b6 10             	movzbl (%rax),%edx
  802cd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd5:	0f b6 00             	movzbl (%rax),%eax
  802cd8:	38 c2                	cmp    %al,%dl
  802cda:	74 d9                	je     802cb5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802cdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce0:	0f b6 00             	movzbl (%rax),%eax
  802ce3:	0f b6 d0             	movzbl %al,%edx
  802ce6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cea:	0f b6 00             	movzbl (%rax),%eax
  802ced:	0f b6 c0             	movzbl %al,%eax
  802cf0:	29 c2                	sub    %eax,%edx
  802cf2:	89 d0                	mov    %edx,%eax
}
  802cf4:	c9                   	leaveq 
  802cf5:	c3                   	retq   

0000000000802cf6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802cf6:	55                   	push   %rbp
  802cf7:	48 89 e5             	mov    %rsp,%rbp
  802cfa:	48 83 ec 18          	sub    $0x18,%rsp
  802cfe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d06:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802d0a:	eb 0f                	jmp    802d1b <strncmp+0x25>
		n--, p++, q++;
  802d0c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802d11:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d16:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802d1b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d20:	74 1d                	je     802d3f <strncmp+0x49>
  802d22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d26:	0f b6 00             	movzbl (%rax),%eax
  802d29:	84 c0                	test   %al,%al
  802d2b:	74 12                	je     802d3f <strncmp+0x49>
  802d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d31:	0f b6 10             	movzbl (%rax),%edx
  802d34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d38:	0f b6 00             	movzbl (%rax),%eax
  802d3b:	38 c2                	cmp    %al,%dl
  802d3d:	74 cd                	je     802d0c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802d3f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d44:	75 07                	jne    802d4d <strncmp+0x57>
		return 0;
  802d46:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4b:	eb 18                	jmp    802d65 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802d4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d51:	0f b6 00             	movzbl (%rax),%eax
  802d54:	0f b6 d0             	movzbl %al,%edx
  802d57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5b:	0f b6 00             	movzbl (%rax),%eax
  802d5e:	0f b6 c0             	movzbl %al,%eax
  802d61:	29 c2                	sub    %eax,%edx
  802d63:	89 d0                	mov    %edx,%eax
}
  802d65:	c9                   	leaveq 
  802d66:	c3                   	retq   

0000000000802d67 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802d67:	55                   	push   %rbp
  802d68:	48 89 e5             	mov    %rsp,%rbp
  802d6b:	48 83 ec 0c          	sub    $0xc,%rsp
  802d6f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d73:	89 f0                	mov    %esi,%eax
  802d75:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802d78:	eb 17                	jmp    802d91 <strchr+0x2a>
		if (*s == c)
  802d7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d7e:	0f b6 00             	movzbl (%rax),%eax
  802d81:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802d84:	75 06                	jne    802d8c <strchr+0x25>
			return (char *) s;
  802d86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d8a:	eb 15                	jmp    802da1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802d8c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d95:	0f b6 00             	movzbl (%rax),%eax
  802d98:	84 c0                	test   %al,%al
  802d9a:	75 de                	jne    802d7a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802d9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802da1:	c9                   	leaveq 
  802da2:	c3                   	retq   

0000000000802da3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802da3:	55                   	push   %rbp
  802da4:	48 89 e5             	mov    %rsp,%rbp
  802da7:	48 83 ec 0c          	sub    $0xc,%rsp
  802dab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802daf:	89 f0                	mov    %esi,%eax
  802db1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802db4:	eb 13                	jmp    802dc9 <strfind+0x26>
		if (*s == c)
  802db6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dba:	0f b6 00             	movzbl (%rax),%eax
  802dbd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802dc0:	75 02                	jne    802dc4 <strfind+0x21>
			break;
  802dc2:	eb 10                	jmp    802dd4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802dc4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802dc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dcd:	0f b6 00             	movzbl (%rax),%eax
  802dd0:	84 c0                	test   %al,%al
  802dd2:	75 e2                	jne    802db6 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802dd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802dd8:	c9                   	leaveq 
  802dd9:	c3                   	retq   

0000000000802dda <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802dda:	55                   	push   %rbp
  802ddb:	48 89 e5             	mov    %rsp,%rbp
  802dde:	48 83 ec 18          	sub    $0x18,%rsp
  802de2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802de6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802de9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802ded:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802df2:	75 06                	jne    802dfa <memset+0x20>
		return v;
  802df4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df8:	eb 69                	jmp    802e63 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802dfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dfe:	83 e0 03             	and    $0x3,%eax
  802e01:	48 85 c0             	test   %rax,%rax
  802e04:	75 48                	jne    802e4e <memset+0x74>
  802e06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e0a:	83 e0 03             	and    $0x3,%eax
  802e0d:	48 85 c0             	test   %rax,%rax
  802e10:	75 3c                	jne    802e4e <memset+0x74>
		c &= 0xFF;
  802e12:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802e19:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e1c:	c1 e0 18             	shl    $0x18,%eax
  802e1f:	89 c2                	mov    %eax,%edx
  802e21:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e24:	c1 e0 10             	shl    $0x10,%eax
  802e27:	09 c2                	or     %eax,%edx
  802e29:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e2c:	c1 e0 08             	shl    $0x8,%eax
  802e2f:	09 d0                	or     %edx,%eax
  802e31:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802e34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e38:	48 c1 e8 02          	shr    $0x2,%rax
  802e3c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802e3f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e43:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e46:	48 89 d7             	mov    %rdx,%rdi
  802e49:	fc                   	cld    
  802e4a:	f3 ab                	rep stos %eax,%es:(%rdi)
  802e4c:	eb 11                	jmp    802e5f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802e4e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e52:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e55:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e59:	48 89 d7             	mov    %rdx,%rdi
  802e5c:	fc                   	cld    
  802e5d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802e5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e63:	c9                   	leaveq 
  802e64:	c3                   	retq   

0000000000802e65 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802e65:	55                   	push   %rbp
  802e66:	48 89 e5             	mov    %rsp,%rbp
  802e69:	48 83 ec 28          	sub    $0x28,%rsp
  802e6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e71:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e75:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802e79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e7d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802e81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e85:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802e89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e8d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802e91:	0f 83 88 00 00 00    	jae    802f1f <memmove+0xba>
  802e97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e9b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e9f:	48 01 d0             	add    %rdx,%rax
  802ea2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802ea6:	76 77                	jbe    802f1f <memmove+0xba>
		s += n;
  802ea8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eac:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802eb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802eb8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ebc:	83 e0 03             	and    $0x3,%eax
  802ebf:	48 85 c0             	test   %rax,%rax
  802ec2:	75 3b                	jne    802eff <memmove+0x9a>
  802ec4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec8:	83 e0 03             	and    $0x3,%eax
  802ecb:	48 85 c0             	test   %rax,%rax
  802ece:	75 2f                	jne    802eff <memmove+0x9a>
  802ed0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ed4:	83 e0 03             	and    $0x3,%eax
  802ed7:	48 85 c0             	test   %rax,%rax
  802eda:	75 23                	jne    802eff <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802edc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee0:	48 83 e8 04          	sub    $0x4,%rax
  802ee4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ee8:	48 83 ea 04          	sub    $0x4,%rdx
  802eec:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802ef0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802ef4:	48 89 c7             	mov    %rax,%rdi
  802ef7:	48 89 d6             	mov    %rdx,%rsi
  802efa:	fd                   	std    
  802efb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802efd:	eb 1d                	jmp    802f1c <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802eff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f03:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802f07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f0b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802f0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f13:	48 89 d7             	mov    %rdx,%rdi
  802f16:	48 89 c1             	mov    %rax,%rcx
  802f19:	fd                   	std    
  802f1a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802f1c:	fc                   	cld    
  802f1d:	eb 57                	jmp    802f76 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f23:	83 e0 03             	and    $0x3,%eax
  802f26:	48 85 c0             	test   %rax,%rax
  802f29:	75 36                	jne    802f61 <memmove+0xfc>
  802f2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2f:	83 e0 03             	and    $0x3,%eax
  802f32:	48 85 c0             	test   %rax,%rax
  802f35:	75 2a                	jne    802f61 <memmove+0xfc>
  802f37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f3b:	83 e0 03             	and    $0x3,%eax
  802f3e:	48 85 c0             	test   %rax,%rax
  802f41:	75 1e                	jne    802f61 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802f43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f47:	48 c1 e8 02          	shr    $0x2,%rax
  802f4b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802f4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f52:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f56:	48 89 c7             	mov    %rax,%rdi
  802f59:	48 89 d6             	mov    %rdx,%rsi
  802f5c:	fc                   	cld    
  802f5d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802f5f:	eb 15                	jmp    802f76 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802f61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f65:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f69:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802f6d:	48 89 c7             	mov    %rax,%rdi
  802f70:	48 89 d6             	mov    %rdx,%rsi
  802f73:	fc                   	cld    
  802f74:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  802f76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802f7a:	c9                   	leaveq 
  802f7b:	c3                   	retq   

0000000000802f7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802f7c:	55                   	push   %rbp
  802f7d:	48 89 e5             	mov    %rsp,%rbp
  802f80:	48 83 ec 18          	sub    $0x18,%rsp
  802f84:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f8c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  802f90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f94:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802f98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f9c:	48 89 ce             	mov    %rcx,%rsi
  802f9f:	48 89 c7             	mov    %rax,%rdi
  802fa2:	48 b8 65 2e 80 00 00 	movabs $0x802e65,%rax
  802fa9:	00 00 00 
  802fac:	ff d0                	callq  *%rax
}
  802fae:	c9                   	leaveq 
  802faf:	c3                   	retq   

0000000000802fb0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802fb0:	55                   	push   %rbp
  802fb1:	48 89 e5             	mov    %rsp,%rbp
  802fb4:	48 83 ec 28          	sub    $0x28,%rsp
  802fb8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fbc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fc0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  802fc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802fcc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  802fd4:	eb 36                	jmp    80300c <memcmp+0x5c>
		if (*s1 != *s2)
  802fd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fda:	0f b6 10             	movzbl (%rax),%edx
  802fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe1:	0f b6 00             	movzbl (%rax),%eax
  802fe4:	38 c2                	cmp    %al,%dl
  802fe6:	74 1a                	je     803002 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  802fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fec:	0f b6 00             	movzbl (%rax),%eax
  802fef:	0f b6 d0             	movzbl %al,%edx
  802ff2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff6:	0f b6 00             	movzbl (%rax),%eax
  802ff9:	0f b6 c0             	movzbl %al,%eax
  802ffc:	29 c2                	sub    %eax,%edx
  802ffe:	89 d0                	mov    %edx,%eax
  803000:	eb 20                	jmp    803022 <memcmp+0x72>
		s1++, s2++;
  803002:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803007:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80300c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803010:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803014:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803018:	48 85 c0             	test   %rax,%rax
  80301b:	75 b9                	jne    802fd6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80301d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803022:	c9                   	leaveq 
  803023:	c3                   	retq   

0000000000803024 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803024:	55                   	push   %rbp
  803025:	48 89 e5             	mov    %rsp,%rbp
  803028:	48 83 ec 28          	sub    $0x28,%rsp
  80302c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803030:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803033:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803037:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80303b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80303f:	48 01 d0             	add    %rdx,%rax
  803042:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803046:	eb 15                	jmp    80305d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  803048:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80304c:	0f b6 10             	movzbl (%rax),%edx
  80304f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803052:	38 c2                	cmp    %al,%dl
  803054:	75 02                	jne    803058 <memfind+0x34>
			break;
  803056:	eb 0f                	jmp    803067 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803058:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80305d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803061:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803065:	72 e1                	jb     803048 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  803067:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80306b:	c9                   	leaveq 
  80306c:	c3                   	retq   

000000000080306d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80306d:	55                   	push   %rbp
  80306e:	48 89 e5             	mov    %rsp,%rbp
  803071:	48 83 ec 34          	sub    $0x34,%rsp
  803075:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803079:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80307d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803080:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803087:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80308e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80308f:	eb 05                	jmp    803096 <strtol+0x29>
		s++;
  803091:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803096:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80309a:	0f b6 00             	movzbl (%rax),%eax
  80309d:	3c 20                	cmp    $0x20,%al
  80309f:	74 f0                	je     803091 <strtol+0x24>
  8030a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a5:	0f b6 00             	movzbl (%rax),%eax
  8030a8:	3c 09                	cmp    $0x9,%al
  8030aa:	74 e5                	je     803091 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8030ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b0:	0f b6 00             	movzbl (%rax),%eax
  8030b3:	3c 2b                	cmp    $0x2b,%al
  8030b5:	75 07                	jne    8030be <strtol+0x51>
		s++;
  8030b7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8030bc:	eb 17                	jmp    8030d5 <strtol+0x68>
	else if (*s == '-')
  8030be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030c2:	0f b6 00             	movzbl (%rax),%eax
  8030c5:	3c 2d                	cmp    $0x2d,%al
  8030c7:	75 0c                	jne    8030d5 <strtol+0x68>
		s++, neg = 1;
  8030c9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8030ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8030d5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8030d9:	74 06                	je     8030e1 <strtol+0x74>
  8030db:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8030df:	75 28                	jne    803109 <strtol+0x9c>
  8030e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e5:	0f b6 00             	movzbl (%rax),%eax
  8030e8:	3c 30                	cmp    $0x30,%al
  8030ea:	75 1d                	jne    803109 <strtol+0x9c>
  8030ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030f0:	48 83 c0 01          	add    $0x1,%rax
  8030f4:	0f b6 00             	movzbl (%rax),%eax
  8030f7:	3c 78                	cmp    $0x78,%al
  8030f9:	75 0e                	jne    803109 <strtol+0x9c>
		s += 2, base = 16;
  8030fb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803100:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803107:	eb 2c                	jmp    803135 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803109:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80310d:	75 19                	jne    803128 <strtol+0xbb>
  80310f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803113:	0f b6 00             	movzbl (%rax),%eax
  803116:	3c 30                	cmp    $0x30,%al
  803118:	75 0e                	jne    803128 <strtol+0xbb>
		s++, base = 8;
  80311a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80311f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803126:	eb 0d                	jmp    803135 <strtol+0xc8>
	else if (base == 0)
  803128:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80312c:	75 07                	jne    803135 <strtol+0xc8>
		base = 10;
  80312e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803135:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803139:	0f b6 00             	movzbl (%rax),%eax
  80313c:	3c 2f                	cmp    $0x2f,%al
  80313e:	7e 1d                	jle    80315d <strtol+0xf0>
  803140:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803144:	0f b6 00             	movzbl (%rax),%eax
  803147:	3c 39                	cmp    $0x39,%al
  803149:	7f 12                	jg     80315d <strtol+0xf0>
			dig = *s - '0';
  80314b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80314f:	0f b6 00             	movzbl (%rax),%eax
  803152:	0f be c0             	movsbl %al,%eax
  803155:	83 e8 30             	sub    $0x30,%eax
  803158:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80315b:	eb 4e                	jmp    8031ab <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80315d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803161:	0f b6 00             	movzbl (%rax),%eax
  803164:	3c 60                	cmp    $0x60,%al
  803166:	7e 1d                	jle    803185 <strtol+0x118>
  803168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80316c:	0f b6 00             	movzbl (%rax),%eax
  80316f:	3c 7a                	cmp    $0x7a,%al
  803171:	7f 12                	jg     803185 <strtol+0x118>
			dig = *s - 'a' + 10;
  803173:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803177:	0f b6 00             	movzbl (%rax),%eax
  80317a:	0f be c0             	movsbl %al,%eax
  80317d:	83 e8 57             	sub    $0x57,%eax
  803180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803183:	eb 26                	jmp    8031ab <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803185:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803189:	0f b6 00             	movzbl (%rax),%eax
  80318c:	3c 40                	cmp    $0x40,%al
  80318e:	7e 48                	jle    8031d8 <strtol+0x16b>
  803190:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803194:	0f b6 00             	movzbl (%rax),%eax
  803197:	3c 5a                	cmp    $0x5a,%al
  803199:	7f 3d                	jg     8031d8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80319b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80319f:	0f b6 00             	movzbl (%rax),%eax
  8031a2:	0f be c0             	movsbl %al,%eax
  8031a5:	83 e8 37             	sub    $0x37,%eax
  8031a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8031ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031ae:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8031b1:	7c 02                	jl     8031b5 <strtol+0x148>
			break;
  8031b3:	eb 23                	jmp    8031d8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8031b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031ba:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8031bd:	48 98                	cltq   
  8031bf:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8031c4:	48 89 c2             	mov    %rax,%rdx
  8031c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031ca:	48 98                	cltq   
  8031cc:	48 01 d0             	add    %rdx,%rax
  8031cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8031d3:	e9 5d ff ff ff       	jmpq   803135 <strtol+0xc8>

	if (endptr)
  8031d8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8031dd:	74 0b                	je     8031ea <strtol+0x17d>
		*endptr = (char *) s;
  8031df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031e7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8031ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ee:	74 09                	je     8031f9 <strtol+0x18c>
  8031f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031f4:	48 f7 d8             	neg    %rax
  8031f7:	eb 04                	jmp    8031fd <strtol+0x190>
  8031f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8031fd:	c9                   	leaveq 
  8031fe:	c3                   	retq   

00000000008031ff <strstr>:

char * strstr(const char *in, const char *str)
{
  8031ff:	55                   	push   %rbp
  803200:	48 89 e5             	mov    %rsp,%rbp
  803203:	48 83 ec 30          	sub    $0x30,%rsp
  803207:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80320b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80320f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803213:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803217:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80321b:	0f b6 00             	movzbl (%rax),%eax
  80321e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803221:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803225:	75 06                	jne    80322d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803227:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80322b:	eb 6b                	jmp    803298 <strstr+0x99>

	len = strlen(str);
  80322d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803231:	48 89 c7             	mov    %rax,%rdi
  803234:	48 b8 d5 2a 80 00 00 	movabs $0x802ad5,%rax
  80323b:	00 00 00 
  80323e:	ff d0                	callq  *%rax
  803240:	48 98                	cltq   
  803242:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803246:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80324e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803252:	0f b6 00             	movzbl (%rax),%eax
  803255:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803258:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80325c:	75 07                	jne    803265 <strstr+0x66>
				return (char *) 0;
  80325e:	b8 00 00 00 00       	mov    $0x0,%eax
  803263:	eb 33                	jmp    803298 <strstr+0x99>
		} while (sc != c);
  803265:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803269:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80326c:	75 d8                	jne    803246 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80326e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803272:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803276:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327a:	48 89 ce             	mov    %rcx,%rsi
  80327d:	48 89 c7             	mov    %rax,%rdi
  803280:	48 b8 f6 2c 80 00 00 	movabs $0x802cf6,%rax
  803287:	00 00 00 
  80328a:	ff d0                	callq  *%rax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	75 b6                	jne    803246 <strstr+0x47>

	return (char *) (in - 1);
  803290:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803294:	48 83 e8 01          	sub    $0x1,%rax
}
  803298:	c9                   	leaveq 
  803299:	c3                   	retq   

000000000080329a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80329a:	55                   	push   %rbp
  80329b:	48 89 e5             	mov    %rsp,%rbp
  80329e:	48 83 ec 30          	sub    $0x30,%rsp
  8032a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  8032ae:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8032b3:	74 18                	je     8032cd <ipc_recv+0x33>
  8032b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032b9:	48 89 c7             	mov    %rax,%rdi
  8032bc:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  8032c3:	00 00 00 
  8032c6:	ff d0                	callq  *%rax
  8032c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032cb:	eb 19                	jmp    8032e6 <ipc_recv+0x4c>
  8032cd:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8032d4:	00 00 00 
  8032d7:	48 b8 42 05 80 00 00 	movabs $0x800542,%rax
  8032de:	00 00 00 
  8032e1:	ff d0                	callq  *%rax
  8032e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8032e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8032eb:	74 26                	je     803313 <ipc_recv+0x79>
  8032ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f1:	75 15                	jne    803308 <ipc_recv+0x6e>
  8032f3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032fa:	00 00 00 
  8032fd:	48 8b 00             	mov    (%rax),%rax
  803300:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803306:	eb 05                	jmp    80330d <ipc_recv+0x73>
  803308:	b8 00 00 00 00       	mov    $0x0,%eax
  80330d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803311:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803313:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803318:	74 26                	je     803340 <ipc_recv+0xa6>
  80331a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80331e:	75 15                	jne    803335 <ipc_recv+0x9b>
  803320:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803327:	00 00 00 
  80332a:	48 8b 00             	mov    (%rax),%rax
  80332d:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803333:	eb 05                	jmp    80333a <ipc_recv+0xa0>
  803335:	b8 00 00 00 00       	mov    $0x0,%eax
  80333a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80333e:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803340:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803344:	75 15                	jne    80335b <ipc_recv+0xc1>
  803346:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80334d:	00 00 00 
  803350:	48 8b 00             	mov    (%rax),%rax
  803353:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803359:	eb 03                	jmp    80335e <ipc_recv+0xc4>
  80335b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80335e:	c9                   	leaveq 
  80335f:	c3                   	retq   

0000000000803360 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803360:	55                   	push   %rbp
  803361:	48 89 e5             	mov    %rsp,%rbp
  803364:	48 83 ec 30          	sub    $0x30,%rsp
  803368:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80336b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80336e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803372:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803375:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  80337c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803381:	75 10                	jne    803393 <ipc_send+0x33>
  803383:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80338a:	00 00 00 
  80338d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803391:	eb 62                	jmp    8033f5 <ipc_send+0x95>
  803393:	eb 60                	jmp    8033f5 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803395:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803399:	74 30                	je     8033cb <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  80339b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339e:	89 c1                	mov    %eax,%ecx
  8033a0:	48 ba 68 3b 80 00 00 	movabs $0x803b68,%rdx
  8033a7:	00 00 00 
  8033aa:	be 33 00 00 00       	mov    $0x33,%esi
  8033af:	48 bf 84 3b 80 00 00 	movabs $0x803b84,%rdi
  8033b6:	00 00 00 
  8033b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033be:	49 b8 53 1d 80 00 00 	movabs $0x801d53,%r8
  8033c5:	00 00 00 
  8033c8:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  8033cb:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8033ce:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8033d1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033d8:	89 c7                	mov    %eax,%edi
  8033da:	48 b8 ed 04 80 00 00 	movabs $0x8004ed,%rax
  8033e1:	00 00 00 
  8033e4:	ff d0                	callq  *%rax
  8033e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8033e9:	48 b8 db 02 80 00 00 	movabs $0x8002db,%rax
  8033f0:	00 00 00 
  8033f3:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8033f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033f9:	75 9a                	jne    803395 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  8033fb:	c9                   	leaveq 
  8033fc:	c3                   	retq   

00000000008033fd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8033fd:	55                   	push   %rbp
  8033fe:	48 89 e5             	mov    %rsp,%rbp
  803401:	48 83 ec 14          	sub    $0x14,%rsp
  803405:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803408:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80340f:	eb 5e                	jmp    80346f <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803411:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803418:	00 00 00 
  80341b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80341e:	48 63 d0             	movslq %eax,%rdx
  803421:	48 89 d0             	mov    %rdx,%rax
  803424:	48 c1 e0 03          	shl    $0x3,%rax
  803428:	48 01 d0             	add    %rdx,%rax
  80342b:	48 c1 e0 05          	shl    $0x5,%rax
  80342f:	48 01 c8             	add    %rcx,%rax
  803432:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803438:	8b 00                	mov    (%rax),%eax
  80343a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80343d:	75 2c                	jne    80346b <ipc_find_env+0x6e>
			return envs[i].env_id;
  80343f:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803446:	00 00 00 
  803449:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344c:	48 63 d0             	movslq %eax,%rdx
  80344f:	48 89 d0             	mov    %rdx,%rax
  803452:	48 c1 e0 03          	shl    $0x3,%rax
  803456:	48 01 d0             	add    %rdx,%rax
  803459:	48 c1 e0 05          	shl    $0x5,%rax
  80345d:	48 01 c8             	add    %rcx,%rax
  803460:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803466:	8b 40 08             	mov    0x8(%rax),%eax
  803469:	eb 12                	jmp    80347d <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80346b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80346f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803476:	7e 99                	jle    803411 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803478:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80347d:	c9                   	leaveq 
  80347e:	c3                   	retq   

000000000080347f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80347f:	55                   	push   %rbp
  803480:	48 89 e5             	mov    %rsp,%rbp
  803483:	48 83 ec 18          	sub    $0x18,%rsp
  803487:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80348b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80348f:	48 c1 e8 15          	shr    $0x15,%rax
  803493:	48 89 c2             	mov    %rax,%rdx
  803496:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80349d:	01 00 00 
  8034a0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034a4:	83 e0 01             	and    $0x1,%eax
  8034a7:	48 85 c0             	test   %rax,%rax
  8034aa:	75 07                	jne    8034b3 <pageref+0x34>
		return 0;
  8034ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b1:	eb 53                	jmp    803506 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8034b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8034bb:	48 89 c2             	mov    %rax,%rdx
  8034be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034c5:	01 00 00 
  8034c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8034d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d4:	83 e0 01             	and    $0x1,%eax
  8034d7:	48 85 c0             	test   %rax,%rax
  8034da:	75 07                	jne    8034e3 <pageref+0x64>
		return 0;
  8034dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e1:	eb 23                	jmp    803506 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8034e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034e7:	48 c1 e8 0c          	shr    $0xc,%rax
  8034eb:	48 89 c2             	mov    %rax,%rdx
  8034ee:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8034f5:	00 00 00 
  8034f8:	48 c1 e2 04          	shl    $0x4,%rdx
  8034fc:	48 01 d0             	add    %rdx,%rax
  8034ff:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803503:	0f b7 c0             	movzwl %ax,%eax
}
  803506:	c9                   	leaveq 
  803507:	c3                   	retq   
