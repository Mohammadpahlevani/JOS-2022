
obj/user/faultnostack:     file format elf64-x86-64


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
  80003c:	e8 39 00 00 00       	callq  80007a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800052:	48 be 70 05 80 00 00 	movabs $0x800570,%rsi
  800059:	00 00 00 
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 8d 04 80 00 00 	movabs $0x80048d,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
	*(int*)0 = 0;
  80006d:	b8 00 00 00 00       	mov    $0x0,%eax
  800072:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  800078:	c9                   	leaveq 
  800079:	c3                   	retq   

000000000080007a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007a:	55                   	push   %rbp
  80007b:	48 89 e5             	mov    %rsp,%rbp
  80007e:	48 83 ec 10          	sub    $0x10,%rsp
  800082:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800085:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800089:	48 b8 87 02 80 00 00 	movabs $0x800287,%rax
  800090:	00 00 00 
  800093:	ff d0                	callq  *%rax
  800095:	48 98                	cltq   
  800097:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009c:	48 89 c2             	mov    %rax,%rdx
  80009f:	48 89 d0             	mov    %rdx,%rax
  8000a2:	48 c1 e0 03          	shl    $0x3,%rax
  8000a6:	48 01 d0             	add    %rdx,%rax
  8000a9:	48 c1 e0 05          	shl    $0x5,%rax
  8000ad:	48 89 c2             	mov    %rax,%rdx
  8000b0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000b7:	00 00 00 
  8000ba:	48 01 c2             	add    %rax,%rdx
  8000bd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000c4:	00 00 00 
  8000c7:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ce:	7e 14                	jle    8000e4 <libmain+0x6a>
		binaryname = argv[0];
  8000d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000d4:	48 8b 10             	mov    (%rax),%rdx
  8000d7:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000de:	00 00 00 
  8000e1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000eb:	48 89 d6             	mov    %rdx,%rsi
  8000ee:	89 c7                	mov    %eax,%edi
  8000f0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f7:	00 00 00 
  8000fa:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000fc:	48 b8 0a 01 80 00 00 	movabs $0x80010a,%rax
  800103:	00 00 00 
  800106:	ff d0                	callq  *%rax
}
  800108:	c9                   	leaveq 
  800109:	c3                   	retq   

000000000080010a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010a:	55                   	push   %rbp
  80010b:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80010e:	48 b8 3b 09 80 00 00 	movabs $0x80093b,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80011a:	bf 00 00 00 00       	mov    $0x0,%edi
  80011f:	48 b8 43 02 80 00 00 	movabs $0x800243,%rax
  800126:	00 00 00 
  800129:	ff d0                	callq  *%rax
}
  80012b:	5d                   	pop    %rbp
  80012c:	c3                   	retq   

000000000080012d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80012d:	55                   	push   %rbp
  80012e:	48 89 e5             	mov    %rsp,%rbp
  800131:	53                   	push   %rbx
  800132:	48 83 ec 48          	sub    $0x48,%rsp
  800136:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800139:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80013c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800140:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800144:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800148:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  80014c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800153:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800157:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80015b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80015f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800163:	4c 89 c3             	mov    %r8,%rbx
  800166:	cd 30                	int    $0x30
  800168:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  80016c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800170:	74 3e                	je     8001b0 <syscall+0x83>
  800172:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800177:	7e 37                	jle    8001b0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800179:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80017d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800180:	49 89 d0             	mov    %rdx,%r8
  800183:	89 c1                	mov    %eax,%ecx
  800185:	48 ba 2a 36 80 00 00 	movabs $0x80362a,%rdx
  80018c:	00 00 00 
  80018f:	be 4a 00 00 00       	mov    $0x4a,%esi
  800194:	48 bf 47 36 80 00 00 	movabs $0x803647,%rdi
  80019b:	00 00 00 
  80019e:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a3:	49 b9 c7 1d 80 00 00 	movabs $0x801dc7,%r9
  8001aa:	00 00 00 
  8001ad:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8001b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001b4:	48 83 c4 48          	add    $0x48,%rsp
  8001b8:	5b                   	pop    %rbx
  8001b9:	5d                   	pop    %rbp
  8001ba:	c3                   	retq   

00000000008001bb <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001bb:	55                   	push   %rbp
  8001bc:	48 89 e5             	mov    %rsp,%rbp
  8001bf:	48 83 ec 20          	sub    $0x20,%rsp
  8001c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001da:	00 
  8001db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001e7:	48 89 d1             	mov    %rdx,%rcx
  8001ea:	48 89 c2             	mov    %rax,%rdx
  8001ed:	be 00 00 00 00       	mov    $0x0,%esi
  8001f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f7:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8001fe:	00 00 00 
  800201:	ff d0                	callq  *%rax
}
  800203:	c9                   	leaveq 
  800204:	c3                   	retq   

0000000000800205 <sys_cgetc>:

int
sys_cgetc(void)
{
  800205:	55                   	push   %rbp
  800206:	48 89 e5             	mov    %rsp,%rbp
  800209:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80020d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800214:	00 
  800215:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80021b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800221:	b9 00 00 00 00       	mov    $0x0,%ecx
  800226:	ba 00 00 00 00       	mov    $0x0,%edx
  80022b:	be 00 00 00 00       	mov    $0x0,%esi
  800230:	bf 01 00 00 00       	mov    $0x1,%edi
  800235:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  80023c:	00 00 00 
  80023f:	ff d0                	callq  *%rax
}
  800241:	c9                   	leaveq 
  800242:	c3                   	retq   

0000000000800243 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800243:	55                   	push   %rbp
  800244:	48 89 e5             	mov    %rsp,%rbp
  800247:	48 83 ec 10          	sub    $0x10,%rsp
  80024b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80024e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800251:	48 98                	cltq   
  800253:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80025a:	00 
  80025b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800261:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800267:	b9 00 00 00 00       	mov    $0x0,%ecx
  80026c:	48 89 c2             	mov    %rax,%rdx
  80026f:	be 01 00 00 00       	mov    $0x1,%esi
  800274:	bf 03 00 00 00       	mov    $0x3,%edi
  800279:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  800280:	00 00 00 
  800283:	ff d0                	callq  *%rax
}
  800285:	c9                   	leaveq 
  800286:	c3                   	retq   

0000000000800287 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800287:	55                   	push   %rbp
  800288:	48 89 e5             	mov    %rsp,%rbp
  80028b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80028f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800296:	00 
  800297:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80029d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ad:	be 00 00 00 00       	mov    $0x0,%esi
  8002b2:	bf 02 00 00 00       	mov    $0x2,%edi
  8002b7:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
}
  8002c3:	c9                   	leaveq 
  8002c4:	c3                   	retq   

00000000008002c5 <sys_yield>:

void
sys_yield(void)
{
  8002c5:	55                   	push   %rbp
  8002c6:	48 89 e5             	mov    %rsp,%rbp
  8002c9:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002cd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002d4:	00 
  8002d5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8002eb:	be 00 00 00 00       	mov    $0x0,%esi
  8002f0:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002f5:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8002fc:	00 00 00 
  8002ff:	ff d0                	callq  *%rax
}
  800301:	c9                   	leaveq 
  800302:	c3                   	retq   

0000000000800303 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800303:	55                   	push   %rbp
  800304:	48 89 e5             	mov    %rsp,%rbp
  800307:	48 83 ec 20          	sub    $0x20,%rsp
  80030b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80030e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800312:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800315:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800318:	48 63 c8             	movslq %eax,%rcx
  80031b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80031f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800322:	48 98                	cltq   
  800324:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80032b:	00 
  80032c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800332:	49 89 c8             	mov    %rcx,%r8
  800335:	48 89 d1             	mov    %rdx,%rcx
  800338:	48 89 c2             	mov    %rax,%rdx
  80033b:	be 01 00 00 00       	mov    $0x1,%esi
  800340:	bf 04 00 00 00       	mov    $0x4,%edi
  800345:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  80034c:	00 00 00 
  80034f:	ff d0                	callq  *%rax
}
  800351:	c9                   	leaveq 
  800352:	c3                   	retq   

0000000000800353 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800353:	55                   	push   %rbp
  800354:	48 89 e5             	mov    %rsp,%rbp
  800357:	48 83 ec 30          	sub    $0x30,%rsp
  80035b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80035e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800362:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800365:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800369:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80036d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800370:	48 63 c8             	movslq %eax,%rcx
  800373:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800377:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80037a:	48 63 f0             	movslq %eax,%rsi
  80037d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800384:	48 98                	cltq   
  800386:	48 89 0c 24          	mov    %rcx,(%rsp)
  80038a:	49 89 f9             	mov    %rdi,%r9
  80038d:	49 89 f0             	mov    %rsi,%r8
  800390:	48 89 d1             	mov    %rdx,%rcx
  800393:	48 89 c2             	mov    %rax,%rdx
  800396:	be 01 00 00 00       	mov    $0x1,%esi
  80039b:	bf 05 00 00 00       	mov    $0x5,%edi
  8003a0:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8003a7:	00 00 00 
  8003aa:	ff d0                	callq  *%rax
}
  8003ac:	c9                   	leaveq 
  8003ad:	c3                   	retq   

00000000008003ae <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003ae:	55                   	push   %rbp
  8003af:	48 89 e5             	mov    %rsp,%rbp
  8003b2:	48 83 ec 20          	sub    $0x20,%rsp
  8003b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c4:	48 98                	cltq   
  8003c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003cd:	00 
  8003ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003da:	48 89 d1             	mov    %rdx,%rcx
  8003dd:	48 89 c2             	mov    %rax,%rdx
  8003e0:	be 01 00 00 00       	mov    $0x1,%esi
  8003e5:	bf 06 00 00 00       	mov    $0x6,%edi
  8003ea:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8003f1:	00 00 00 
  8003f4:	ff d0                	callq  *%rax
}
  8003f6:	c9                   	leaveq 
  8003f7:	c3                   	retq   

00000000008003f8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f8:	55                   	push   %rbp
  8003f9:	48 89 e5             	mov    %rsp,%rbp
  8003fc:	48 83 ec 10          	sub    $0x10,%rsp
  800400:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800403:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800406:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800409:	48 63 d0             	movslq %eax,%rdx
  80040c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040f:	48 98                	cltq   
  800411:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800418:	00 
  800419:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80041f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800425:	48 89 d1             	mov    %rdx,%rcx
  800428:	48 89 c2             	mov    %rax,%rdx
  80042b:	be 01 00 00 00       	mov    $0x1,%esi
  800430:	bf 08 00 00 00       	mov    $0x8,%edi
  800435:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  80043c:	00 00 00 
  80043f:	ff d0                	callq  *%rax
}
  800441:	c9                   	leaveq 
  800442:	c3                   	retq   

0000000000800443 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800443:	55                   	push   %rbp
  800444:	48 89 e5             	mov    %rsp,%rbp
  800447:	48 83 ec 20          	sub    $0x20,%rsp
  80044b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80044e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800452:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800456:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800459:	48 98                	cltq   
  80045b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800462:	00 
  800463:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800469:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80046f:	48 89 d1             	mov    %rdx,%rcx
  800472:	48 89 c2             	mov    %rax,%rdx
  800475:	be 01 00 00 00       	mov    $0x1,%esi
  80047a:	bf 09 00 00 00       	mov    $0x9,%edi
  80047f:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  800486:	00 00 00 
  800489:	ff d0                	callq  *%rax
}
  80048b:	c9                   	leaveq 
  80048c:	c3                   	retq   

000000000080048d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80048d:	55                   	push   %rbp
  80048e:	48 89 e5             	mov    %rsp,%rbp
  800491:	48 83 ec 20          	sub    $0x20,%rsp
  800495:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800498:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80049c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a3:	48 98                	cltq   
  8004a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004ac:	00 
  8004ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004b9:	48 89 d1             	mov    %rdx,%rcx
  8004bc:	48 89 c2             	mov    %rax,%rdx
  8004bf:	be 01 00 00 00       	mov    $0x1,%esi
  8004c4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004c9:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
}
  8004d5:	c9                   	leaveq 
  8004d6:	c3                   	retq   

00000000008004d7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004d7:	55                   	push   %rbp
  8004d8:	48 89 e5             	mov    %rsp,%rbp
  8004db:	48 83 ec 20          	sub    $0x20,%rsp
  8004df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004ea:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004f0:	48 63 f0             	movslq %eax,%rsi
  8004f3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004fa:	48 98                	cltq   
  8004fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800500:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800507:	00 
  800508:	49 89 f1             	mov    %rsi,%r9
  80050b:	49 89 c8             	mov    %rcx,%r8
  80050e:	48 89 d1             	mov    %rdx,%rcx
  800511:	48 89 c2             	mov    %rax,%rdx
  800514:	be 00 00 00 00       	mov    $0x0,%esi
  800519:	bf 0c 00 00 00       	mov    $0xc,%edi
  80051e:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  800525:	00 00 00 
  800528:	ff d0                	callq  *%rax
}
  80052a:	c9                   	leaveq 
  80052b:	c3                   	retq   

000000000080052c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80052c:	55                   	push   %rbp
  80052d:	48 89 e5             	mov    %rsp,%rbp
  800530:	48 83 ec 10          	sub    $0x10,%rsp
  800534:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800538:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80053c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800543:	00 
  800544:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80054a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800550:	b9 00 00 00 00       	mov    $0x0,%ecx
  800555:	48 89 c2             	mov    %rax,%rdx
  800558:	be 01 00 00 00       	mov    $0x1,%esi
  80055d:	bf 0d 00 00 00       	mov    $0xd,%edi
  800562:	48 b8 2d 01 80 00 00 	movabs $0x80012d,%rax
  800569:	00 00 00 
  80056c:	ff d0                	callq  *%rax
}
  80056e:	c9                   	leaveq 
  80056f:	c3                   	retq   

0000000000800570 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  800570:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  800573:	48 a1 08 80 80 00 00 	movabs 0x808008,%rax
  80057a:	00 00 00 
call *%rax
  80057d:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  80057f:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  800586:	00 
mov 136(%rsp), %r9
  800587:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  80058e:	00 
sub $8, %r8
  80058f:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  800593:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  800596:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  80059d:	00 
add $16, %rsp
  80059e:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  8005a2:	4c 8b 3c 24          	mov    (%rsp),%r15
  8005a6:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8005ab:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8005b0:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8005b5:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8005ba:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8005bf:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8005c4:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8005c9:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8005ce:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8005d3:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8005d8:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8005dd:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8005e2:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8005e7:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8005ec:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  8005f0:	48 83 c4 08          	add    $0x8,%rsp
popf
  8005f4:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  8005f5:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  8005f9:	c3                   	retq   

00000000008005fa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8005fa:	55                   	push   %rbp
  8005fb:	48 89 e5             	mov    %rsp,%rbp
  8005fe:	48 83 ec 08          	sub    $0x8,%rsp
  800602:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800606:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80060a:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800611:	ff ff ff 
  800614:	48 01 d0             	add    %rdx,%rax
  800617:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80061b:	c9                   	leaveq 
  80061c:	c3                   	retq   

000000000080061d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80061d:	55                   	push   %rbp
  80061e:	48 89 e5             	mov    %rsp,%rbp
  800621:	48 83 ec 08          	sub    $0x8,%rsp
  800625:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  800629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80062d:	48 89 c7             	mov    %rax,%rdi
  800630:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  800637:	00 00 00 
  80063a:	ff d0                	callq  *%rax
  80063c:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800642:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800646:	c9                   	leaveq 
  800647:	c3                   	retq   

0000000000800648 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800648:	55                   	push   %rbp
  800649:	48 89 e5             	mov    %rsp,%rbp
  80064c:	48 83 ec 18          	sub    $0x18,%rsp
  800650:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800654:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80065b:	eb 6b                	jmp    8006c8 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80065d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800660:	48 98                	cltq   
  800662:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800668:	48 c1 e0 0c          	shl    $0xc,%rax
  80066c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800670:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800674:	48 c1 e8 15          	shr    $0x15,%rax
  800678:	48 89 c2             	mov    %rax,%rdx
  80067b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800682:	01 00 00 
  800685:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800689:	83 e0 01             	and    $0x1,%eax
  80068c:	48 85 c0             	test   %rax,%rax
  80068f:	74 21                	je     8006b2 <fd_alloc+0x6a>
  800691:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800695:	48 c1 e8 0c          	shr    $0xc,%rax
  800699:	48 89 c2             	mov    %rax,%rdx
  80069c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006a3:	01 00 00 
  8006a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006aa:	83 e0 01             	and    $0x1,%eax
  8006ad:	48 85 c0             	test   %rax,%rax
  8006b0:	75 12                	jne    8006c4 <fd_alloc+0x7c>
			*fd_store = fd;
  8006b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006ba:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8006bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c2:	eb 1a                	jmp    8006de <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8006c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8006c8:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8006cc:	7e 8f                	jle    80065d <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8006ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8006d9:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8006de:	c9                   	leaveq 
  8006df:	c3                   	retq   

00000000008006e0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8006e0:	55                   	push   %rbp
  8006e1:	48 89 e5             	mov    %rsp,%rbp
  8006e4:	48 83 ec 20          	sub    $0x20,%rsp
  8006e8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8006eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8006ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8006f3:	78 06                	js     8006fb <fd_lookup+0x1b>
  8006f5:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8006f9:	7e 07                	jle    800702 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800700:	eb 6c                	jmp    80076e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800702:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800705:	48 98                	cltq   
  800707:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80070d:	48 c1 e0 0c          	shl    $0xc,%rax
  800711:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800715:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800719:	48 c1 e8 15          	shr    $0x15,%rax
  80071d:	48 89 c2             	mov    %rax,%rdx
  800720:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800727:	01 00 00 
  80072a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80072e:	83 e0 01             	and    $0x1,%eax
  800731:	48 85 c0             	test   %rax,%rax
  800734:	74 21                	je     800757 <fd_lookup+0x77>
  800736:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80073a:	48 c1 e8 0c          	shr    $0xc,%rax
  80073e:	48 89 c2             	mov    %rax,%rdx
  800741:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800748:	01 00 00 
  80074b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80074f:	83 e0 01             	and    $0x1,%eax
  800752:	48 85 c0             	test   %rax,%rax
  800755:	75 07                	jne    80075e <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800757:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075c:	eb 10                	jmp    80076e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80075e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800762:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800766:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  800769:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80076e:	c9                   	leaveq 
  80076f:	c3                   	retq   

0000000000800770 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800770:	55                   	push   %rbp
  800771:	48 89 e5             	mov    %rsp,%rbp
  800774:	48 83 ec 30          	sub    $0x30,%rsp
  800778:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80077c:	89 f0                	mov    %esi,%eax
  80077e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800781:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800785:	48 89 c7             	mov    %rax,%rdi
  800788:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  80078f:	00 00 00 
  800792:	ff d0                	callq  *%rax
  800794:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800798:	48 89 d6             	mov    %rdx,%rsi
  80079b:	89 c7                	mov    %eax,%edi
  80079d:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  8007a4:	00 00 00 
  8007a7:	ff d0                	callq  *%rax
  8007a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007b0:	78 0a                	js     8007bc <fd_close+0x4c>
	    || fd != fd2)
  8007b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007b6:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8007ba:	74 12                	je     8007ce <fd_close+0x5e>
		return (must_exist ? r : 0);
  8007bc:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8007c0:	74 05                	je     8007c7 <fd_close+0x57>
  8007c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8007c5:	eb 05                	jmp    8007cc <fd_close+0x5c>
  8007c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cc:	eb 69                	jmp    800837 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8007ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d2:	8b 00                	mov    (%rax),%eax
  8007d4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8007d8:	48 89 d6             	mov    %rdx,%rsi
  8007db:	89 c7                	mov    %eax,%edi
  8007dd:	48 b8 39 08 80 00 00 	movabs $0x800839,%rax
  8007e4:	00 00 00 
  8007e7:	ff d0                	callq  *%rax
  8007e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007f0:	78 2a                	js     80081c <fd_close+0xac>
		if (dev->dev_close)
  8007f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8007fa:	48 85 c0             	test   %rax,%rax
  8007fd:	74 16                	je     800815 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8007ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800803:	48 8b 40 20          	mov    0x20(%rax),%rax
  800807:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80080b:	48 89 d7             	mov    %rdx,%rdi
  80080e:	ff d0                	callq  *%rax
  800810:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800813:	eb 07                	jmp    80081c <fd_close+0xac>
		else
			r = 0;
  800815:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80081c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800820:	48 89 c6             	mov    %rax,%rsi
  800823:	bf 00 00 00 00       	mov    $0x0,%edi
  800828:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  80082f:	00 00 00 
  800832:	ff d0                	callq  *%rax
	return r;
  800834:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800837:	c9                   	leaveq 
  800838:	c3                   	retq   

0000000000800839 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800839:	55                   	push   %rbp
  80083a:	48 89 e5             	mov    %rsp,%rbp
  80083d:	48 83 ec 20          	sub    $0x20,%rsp
  800841:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800844:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  800848:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80084f:	eb 41                	jmp    800892 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  800851:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800858:	00 00 00 
  80085b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80085e:	48 63 d2             	movslq %edx,%rdx
  800861:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800865:	8b 00                	mov    (%rax),%eax
  800867:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80086a:	75 22                	jne    80088e <dev_lookup+0x55>
			*dev = devtab[i];
  80086c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800873:	00 00 00 
  800876:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800879:	48 63 d2             	movslq %edx,%rdx
  80087c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  800880:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800884:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800887:	b8 00 00 00 00       	mov    $0x0,%eax
  80088c:	eb 60                	jmp    8008ee <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80088e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800892:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800899:	00 00 00 
  80089c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80089f:	48 63 d2             	movslq %edx,%rdx
  8008a2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8008a6:	48 85 c0             	test   %rax,%rax
  8008a9:	75 a6                	jne    800851 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8008ab:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8008b2:	00 00 00 
  8008b5:	48 8b 00             	mov    (%rax),%rax
  8008b8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8008be:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8008c1:	89 c6                	mov    %eax,%esi
  8008c3:	48 bf 58 36 80 00 00 	movabs $0x803658,%rdi
  8008ca:	00 00 00 
  8008cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d2:	48 b9 00 20 80 00 00 	movabs $0x802000,%rcx
  8008d9:	00 00 00 
  8008dc:	ff d1                	callq  *%rcx
	*dev = 0;
  8008de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008e2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8008e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8008ee:	c9                   	leaveq 
  8008ef:	c3                   	retq   

00000000008008f0 <close>:

int
close(int fdnum)
{
  8008f0:	55                   	push   %rbp
  8008f1:	48 89 e5             	mov    %rsp,%rbp
  8008f4:	48 83 ec 20          	sub    $0x20,%rsp
  8008f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008fb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8008ff:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800902:	48 89 d6             	mov    %rdx,%rsi
  800905:	89 c7                	mov    %eax,%edi
  800907:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  80090e:	00 00 00 
  800911:	ff d0                	callq  *%rax
  800913:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800916:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80091a:	79 05                	jns    800921 <close+0x31>
		return r;
  80091c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80091f:	eb 18                	jmp    800939 <close+0x49>
	else
		return fd_close(fd, 1);
  800921:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800925:	be 01 00 00 00       	mov    $0x1,%esi
  80092a:	48 89 c7             	mov    %rax,%rdi
  80092d:	48 b8 70 07 80 00 00 	movabs $0x800770,%rax
  800934:	00 00 00 
  800937:	ff d0                	callq  *%rax
}
  800939:	c9                   	leaveq 
  80093a:	c3                   	retq   

000000000080093b <close_all>:

void
close_all(void)
{
  80093b:	55                   	push   %rbp
  80093c:	48 89 e5             	mov    %rsp,%rbp
  80093f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800943:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80094a:	eb 15                	jmp    800961 <close_all+0x26>
		close(i);
  80094c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80094f:	89 c7                	mov    %eax,%edi
  800951:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  800958:	00 00 00 
  80095b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80095d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800961:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800965:	7e e5                	jle    80094c <close_all+0x11>
		close(i);
}
  800967:	c9                   	leaveq 
  800968:	c3                   	retq   

0000000000800969 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800969:	55                   	push   %rbp
  80096a:	48 89 e5             	mov    %rsp,%rbp
  80096d:	48 83 ec 40          	sub    $0x40,%rsp
  800971:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800974:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800977:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80097b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80097e:	48 89 d6             	mov    %rdx,%rsi
  800981:	89 c7                	mov    %eax,%edi
  800983:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  80098a:	00 00 00 
  80098d:	ff d0                	callq  *%rax
  80098f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800992:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800996:	79 08                	jns    8009a0 <dup+0x37>
		return r;
  800998:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80099b:	e9 70 01 00 00       	jmpq   800b10 <dup+0x1a7>
	close(newfdnum);
  8009a0:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009a3:	89 c7                	mov    %eax,%edi
  8009a5:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  8009ac:	00 00 00 
  8009af:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8009b1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8009b4:	48 98                	cltq   
  8009b6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8009bc:	48 c1 e0 0c          	shl    $0xc,%rax
  8009c0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8009c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009c8:	48 89 c7             	mov    %rax,%rdi
  8009cb:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  8009d2:	00 00 00 
  8009d5:	ff d0                	callq  *%rax
  8009d7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8009db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009df:	48 89 c7             	mov    %rax,%rdi
  8009e2:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  8009e9:	00 00 00 
  8009ec:	ff d0                	callq  *%rax
  8009ee:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8009f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f6:	48 c1 e8 15          	shr    $0x15,%rax
  8009fa:	48 89 c2             	mov    %rax,%rdx
  8009fd:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800a04:	01 00 00 
  800a07:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a0b:	83 e0 01             	and    $0x1,%eax
  800a0e:	48 85 c0             	test   %rax,%rax
  800a11:	74 73                	je     800a86 <dup+0x11d>
  800a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a17:	48 c1 e8 0c          	shr    $0xc,%rax
  800a1b:	48 89 c2             	mov    %rax,%rdx
  800a1e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a25:	01 00 00 
  800a28:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a2c:	83 e0 01             	and    $0x1,%eax
  800a2f:	48 85 c0             	test   %rax,%rax
  800a32:	74 52                	je     800a86 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800a34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a38:	48 c1 e8 0c          	shr    $0xc,%rax
  800a3c:	48 89 c2             	mov    %rax,%rdx
  800a3f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a46:	01 00 00 
  800a49:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a4d:	25 07 0e 00 00       	and    $0xe07,%eax
  800a52:	89 c1                	mov    %eax,%ecx
  800a54:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5c:	41 89 c8             	mov    %ecx,%r8d
  800a5f:	48 89 d1             	mov    %rdx,%rcx
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	48 89 c6             	mov    %rax,%rsi
  800a6a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6f:	48 b8 53 03 80 00 00 	movabs $0x800353,%rax
  800a76:	00 00 00 
  800a79:	ff d0                	callq  *%rax
  800a7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a82:	79 02                	jns    800a86 <dup+0x11d>
			goto err;
  800a84:	eb 57                	jmp    800add <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a8a:	48 c1 e8 0c          	shr    $0xc,%rax
  800a8e:	48 89 c2             	mov    %rax,%rdx
  800a91:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a98:	01 00 00 
  800a9b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a9f:	25 07 0e 00 00       	and    $0xe07,%eax
  800aa4:	89 c1                	mov    %eax,%ecx
  800aa6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800aaa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aae:	41 89 c8             	mov    %ecx,%r8d
  800ab1:	48 89 d1             	mov    %rdx,%rcx
  800ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab9:	48 89 c6             	mov    %rax,%rsi
  800abc:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac1:	48 b8 53 03 80 00 00 	movabs $0x800353,%rax
  800ac8:	00 00 00 
  800acb:	ff d0                	callq  *%rax
  800acd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ad0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ad4:	79 02                	jns    800ad8 <dup+0x16f>
		goto err;
  800ad6:	eb 05                	jmp    800add <dup+0x174>

	return newfdnum;
  800ad8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800adb:	eb 33                	jmp    800b10 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800add:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ae1:	48 89 c6             	mov    %rax,%rsi
  800ae4:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae9:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  800af0:	00 00 00 
  800af3:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800af5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800af9:	48 89 c6             	mov    %rax,%rsi
  800afc:	bf 00 00 00 00       	mov    $0x0,%edi
  800b01:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  800b08:	00 00 00 
  800b0b:	ff d0                	callq  *%rax
	return r;
  800b0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800b10:	c9                   	leaveq 
  800b11:	c3                   	retq   

0000000000800b12 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b12:	55                   	push   %rbp
  800b13:	48 89 e5             	mov    %rsp,%rbp
  800b16:	48 83 ec 40          	sub    $0x40,%rsp
  800b1a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800b1d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800b21:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b25:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800b29:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800b2c:	48 89 d6             	mov    %rdx,%rsi
  800b2f:	89 c7                	mov    %eax,%edi
  800b31:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800b38:	00 00 00 
  800b3b:	ff d0                	callq  *%rax
  800b3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b44:	78 24                	js     800b6a <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4a:	8b 00                	mov    (%rax),%eax
  800b4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800b50:	48 89 d6             	mov    %rdx,%rsi
  800b53:	89 c7                	mov    %eax,%edi
  800b55:	48 b8 39 08 80 00 00 	movabs $0x800839,%rax
  800b5c:	00 00 00 
  800b5f:	ff d0                	callq  *%rax
  800b61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b68:	79 05                	jns    800b6f <read+0x5d>
		return r;
  800b6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b6d:	eb 76                	jmp    800be5 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800b6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b73:	8b 40 08             	mov    0x8(%rax),%eax
  800b76:	83 e0 03             	and    $0x3,%eax
  800b79:	83 f8 01             	cmp    $0x1,%eax
  800b7c:	75 3a                	jne    800bb8 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b7e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800b85:	00 00 00 
  800b88:	48 8b 00             	mov    (%rax),%rax
  800b8b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b91:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b94:	89 c6                	mov    %eax,%esi
  800b96:	48 bf 77 36 80 00 00 	movabs $0x803677,%rdi
  800b9d:	00 00 00 
  800ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba5:	48 b9 00 20 80 00 00 	movabs $0x802000,%rcx
  800bac:	00 00 00 
  800baf:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800bb1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bb6:	eb 2d                	jmp    800be5 <read+0xd3>
	}
	if (!dev->dev_read)
  800bb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bbc:	48 8b 40 10          	mov    0x10(%rax),%rax
  800bc0:	48 85 c0             	test   %rax,%rax
  800bc3:	75 07                	jne    800bcc <read+0xba>
		return -E_NOT_SUPP;
  800bc5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800bca:	eb 19                	jmp    800be5 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800bcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd0:	48 8b 40 10          	mov    0x10(%rax),%rax
  800bd4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800bd8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bdc:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800be0:	48 89 cf             	mov    %rcx,%rdi
  800be3:	ff d0                	callq  *%rax
}
  800be5:	c9                   	leaveq 
  800be6:	c3                   	retq   

0000000000800be7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800be7:	55                   	push   %rbp
  800be8:	48 89 e5             	mov    %rsp,%rbp
  800beb:	48 83 ec 30          	sub    $0x30,%rsp
  800bef:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800bf2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800bf6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bfa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800c01:	eb 49                	jmp    800c4c <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800c03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c06:	48 98                	cltq   
  800c08:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800c0c:	48 29 c2             	sub    %rax,%rdx
  800c0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c12:	48 63 c8             	movslq %eax,%rcx
  800c15:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800c19:	48 01 c1             	add    %rax,%rcx
  800c1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800c1f:	48 89 ce             	mov    %rcx,%rsi
  800c22:	89 c7                	mov    %eax,%edi
  800c24:	48 b8 12 0b 80 00 00 	movabs $0x800b12,%rax
  800c2b:	00 00 00 
  800c2e:	ff d0                	callq  *%rax
  800c30:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800c33:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c37:	79 05                	jns    800c3e <readn+0x57>
			return m;
  800c39:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c3c:	eb 1c                	jmp    800c5a <readn+0x73>
		if (m == 0)
  800c3e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800c42:	75 02                	jne    800c46 <readn+0x5f>
			break;
  800c44:	eb 11                	jmp    800c57 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800c46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c49:	01 45 fc             	add    %eax,-0x4(%rbp)
  800c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c4f:	48 98                	cltq   
  800c51:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800c55:	72 ac                	jb     800c03 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800c57:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800c5a:	c9                   	leaveq 
  800c5b:	c3                   	retq   

0000000000800c5c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800c5c:	55                   	push   %rbp
  800c5d:	48 89 e5             	mov    %rsp,%rbp
  800c60:	48 83 ec 40          	sub    $0x40,%rsp
  800c64:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800c67:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800c6b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c6f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800c73:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800c76:	48 89 d6             	mov    %rdx,%rsi
  800c79:	89 c7                	mov    %eax,%edi
  800c7b:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800c82:	00 00 00 
  800c85:	ff d0                	callq  *%rax
  800c87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c8e:	78 24                	js     800cb4 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c94:	8b 00                	mov    (%rax),%eax
  800c96:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c9a:	48 89 d6             	mov    %rdx,%rsi
  800c9d:	89 c7                	mov    %eax,%edi
  800c9f:	48 b8 39 08 80 00 00 	movabs $0x800839,%rax
  800ca6:	00 00 00 
  800ca9:	ff d0                	callq  *%rax
  800cab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cb2:	79 05                	jns    800cb9 <write+0x5d>
		return r;
  800cb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cb7:	eb 75                	jmp    800d2e <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800cb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cbd:	8b 40 08             	mov    0x8(%rax),%eax
  800cc0:	83 e0 03             	and    $0x3,%eax
  800cc3:	85 c0                	test   %eax,%eax
  800cc5:	75 3a                	jne    800d01 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800cc7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cce:	00 00 00 
  800cd1:	48 8b 00             	mov    (%rax),%rax
  800cd4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800cda:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800cdd:	89 c6                	mov    %eax,%esi
  800cdf:	48 bf 93 36 80 00 00 	movabs $0x803693,%rdi
  800ce6:	00 00 00 
  800ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cee:	48 b9 00 20 80 00 00 	movabs $0x802000,%rcx
  800cf5:	00 00 00 
  800cf8:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800cfa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cff:	eb 2d                	jmp    800d2e <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800d01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d05:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d09:	48 85 c0             	test   %rax,%rax
  800d0c:	75 07                	jne    800d15 <write+0xb9>
		return -E_NOT_SUPP;
  800d0e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d13:	eb 19                	jmp    800d2e <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d19:	48 8b 40 18          	mov    0x18(%rax),%rax
  800d1d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800d21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d25:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800d29:	48 89 cf             	mov    %rcx,%rdi
  800d2c:	ff d0                	callq  *%rax
}
  800d2e:	c9                   	leaveq 
  800d2f:	c3                   	retq   

0000000000800d30 <seek>:

int
seek(int fdnum, off_t offset)
{
  800d30:	55                   	push   %rbp
  800d31:	48 89 e5             	mov    %rsp,%rbp
  800d34:	48 83 ec 18          	sub    $0x18,%rsp
  800d38:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800d3b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d3e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d42:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800d45:	48 89 d6             	mov    %rdx,%rsi
  800d48:	89 c7                	mov    %eax,%edi
  800d4a:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800d51:	00 00 00 
  800d54:	ff d0                	callq  *%rax
  800d56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d5d:	79 05                	jns    800d64 <seek+0x34>
		return r;
  800d5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d62:	eb 0f                	jmp    800d73 <seek+0x43>
	fd->fd_offset = offset;
  800d64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d68:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800d6b:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800d6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d73:	c9                   	leaveq 
  800d74:	c3                   	retq   

0000000000800d75 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800d75:	55                   	push   %rbp
  800d76:	48 89 e5             	mov    %rsp,%rbp
  800d79:	48 83 ec 30          	sub    $0x30,%rsp
  800d7d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d80:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d83:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d87:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d8a:	48 89 d6             	mov    %rdx,%rsi
  800d8d:	89 c7                	mov    %eax,%edi
  800d8f:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800d96:	00 00 00 
  800d99:	ff d0                	callq  *%rax
  800d9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800da2:	78 24                	js     800dc8 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800da4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800da8:	8b 00                	mov    (%rax),%eax
  800daa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dae:	48 89 d6             	mov    %rdx,%rsi
  800db1:	89 c7                	mov    %eax,%edi
  800db3:	48 b8 39 08 80 00 00 	movabs $0x800839,%rax
  800dba:	00 00 00 
  800dbd:	ff d0                	callq  *%rax
  800dbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dc6:	79 05                	jns    800dcd <ftruncate+0x58>
		return r;
  800dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dcb:	eb 72                	jmp    800e3f <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800dcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd1:	8b 40 08             	mov    0x8(%rax),%eax
  800dd4:	83 e0 03             	and    $0x3,%eax
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	75 3a                	jne    800e15 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800ddb:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800de2:	00 00 00 
  800de5:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800de8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800dee:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800df1:	89 c6                	mov    %eax,%esi
  800df3:	48 bf b0 36 80 00 00 	movabs $0x8036b0,%rdi
  800dfa:	00 00 00 
  800dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800e02:	48 b9 00 20 80 00 00 	movabs $0x802000,%rcx
  800e09:	00 00 00 
  800e0c:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e13:	eb 2a                	jmp    800e3f <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800e15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e19:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e1d:	48 85 c0             	test   %rax,%rax
  800e20:	75 07                	jne    800e29 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800e22:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e27:	eb 16                	jmp    800e3f <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2d:	48 8b 40 30          	mov    0x30(%rax),%rax
  800e31:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e35:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800e38:	89 ce                	mov    %ecx,%esi
  800e3a:	48 89 d7             	mov    %rdx,%rdi
  800e3d:	ff d0                	callq  *%rax
}
  800e3f:	c9                   	leaveq 
  800e40:	c3                   	retq   

0000000000800e41 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e41:	55                   	push   %rbp
  800e42:	48 89 e5             	mov    %rsp,%rbp
  800e45:	48 83 ec 30          	sub    $0x30,%rsp
  800e49:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e4c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e50:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e54:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e57:	48 89 d6             	mov    %rdx,%rsi
  800e5a:	89 c7                	mov    %eax,%edi
  800e5c:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  800e63:	00 00 00 
  800e66:	ff d0                	callq  *%rax
  800e68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e6f:	78 24                	js     800e95 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e75:	8b 00                	mov    (%rax),%eax
  800e77:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e7b:	48 89 d6             	mov    %rdx,%rsi
  800e7e:	89 c7                	mov    %eax,%edi
  800e80:	48 b8 39 08 80 00 00 	movabs $0x800839,%rax
  800e87:	00 00 00 
  800e8a:	ff d0                	callq  *%rax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e93:	79 05                	jns    800e9a <fstat+0x59>
		return r;
  800e95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e98:	eb 5e                	jmp    800ef8 <fstat+0xb7>
	if (!dev->dev_stat)
  800e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9e:	48 8b 40 28          	mov    0x28(%rax),%rax
  800ea2:	48 85 c0             	test   %rax,%rax
  800ea5:	75 07                	jne    800eae <fstat+0x6d>
		return -E_NOT_SUPP;
  800ea7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800eac:	eb 4a                	jmp    800ef8 <fstat+0xb7>
	stat->st_name[0] = 0;
  800eae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eb2:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800eb5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eb9:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800ec0:	00 00 00 
	stat->st_isdir = 0;
  800ec3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ec7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800ece:	00 00 00 
	stat->st_dev = dev;
  800ed1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ed5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ed9:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800ee0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ee4:	48 8b 40 28          	mov    0x28(%rax),%rax
  800ee8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800eec:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800ef0:	48 89 ce             	mov    %rcx,%rsi
  800ef3:	48 89 d7             	mov    %rdx,%rdi
  800ef6:	ff d0                	callq  *%rax
}
  800ef8:	c9                   	leaveq 
  800ef9:	c3                   	retq   

0000000000800efa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800efa:	55                   	push   %rbp
  800efb:	48 89 e5             	mov    %rsp,%rbp
  800efe:	48 83 ec 20          	sub    $0x20,%rsp
  800f02:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f06:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0e:	be 00 00 00 00       	mov    $0x0,%esi
  800f13:	48 89 c7             	mov    %rax,%rdi
  800f16:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  800f1d:	00 00 00 
  800f20:	ff d0                	callq  *%rax
  800f22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f29:	79 05                	jns    800f30 <stat+0x36>
		return fd;
  800f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f2e:	eb 2f                	jmp    800f5f <stat+0x65>
	r = fstat(fd, stat);
  800f30:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f37:	48 89 d6             	mov    %rdx,%rsi
  800f3a:	89 c7                	mov    %eax,%edi
  800f3c:	48 b8 41 0e 80 00 00 	movabs $0x800e41,%rax
  800f43:	00 00 00 
  800f46:	ff d0                	callq  *%rax
  800f48:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800f4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f4e:	89 c7                	mov    %eax,%edi
  800f50:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  800f57:	00 00 00 
  800f5a:	ff d0                	callq  *%rax
	return r;
  800f5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800f5f:	c9                   	leaveq 
  800f60:	c3                   	retq   

0000000000800f61 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800f61:	55                   	push   %rbp
  800f62:	48 89 e5             	mov    %rsp,%rbp
  800f65:	48 83 ec 10          	sub    $0x10,%rsp
  800f69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800f70:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f77:	00 00 00 
  800f7a:	8b 00                	mov    (%rax),%eax
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	75 1d                	jne    800f9d <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800f80:	bf 01 00 00 00       	mov    $0x1,%edi
  800f85:	48 b8 06 35 80 00 00 	movabs $0x803506,%rax
  800f8c:	00 00 00 
  800f8f:	ff d0                	callq  *%rax
  800f91:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f98:	00 00 00 
  800f9b:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f9d:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800fa4:	00 00 00 
  800fa7:	8b 00                	mov    (%rax),%eax
  800fa9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800fac:	b9 07 00 00 00       	mov    $0x7,%ecx
  800fb1:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800fb8:	00 00 00 
  800fbb:	89 c7                	mov    %eax,%edi
  800fbd:	48 b8 69 34 80 00 00 	movabs $0x803469,%rax
  800fc4:	00 00 00 
  800fc7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd2:	48 89 c6             	mov    %rax,%rsi
  800fd5:	bf 00 00 00 00       	mov    $0x0,%edi
  800fda:	48 b8 a3 33 80 00 00 	movabs $0x8033a3,%rax
  800fe1:	00 00 00 
  800fe4:	ff d0                	callq  *%rax
}
  800fe6:	c9                   	leaveq 
  800fe7:	c3                   	retq   

0000000000800fe8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800fe8:	55                   	push   %rbp
  800fe9:	48 89 e5             	mov    %rsp,%rbp
  800fec:	48 83 ec 20          	sub    $0x20,%rsp
  800ff0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ff4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  800ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffb:	48 89 c7             	mov    %rax,%rdi
  800ffe:	48 b8 49 2b 80 00 00 	movabs $0x802b49,%rax
  801005:	00 00 00 
  801008:	ff d0                	callq  *%rax
  80100a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80100f:	7e 0a                	jle    80101b <open+0x33>
  801011:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801016:	e9 a5 00 00 00       	jmpq   8010c0 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  80101b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80101f:	48 89 c7             	mov    %rax,%rdi
  801022:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  801029:	00 00 00 
  80102c:	ff d0                	callq  *%rax
  80102e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801031:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801035:	79 08                	jns    80103f <open+0x57>
		return r;
  801037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80103a:	e9 81 00 00 00       	jmpq   8010c0 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  80103f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801046:	00 00 00 
  801049:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80104c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  801052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801056:	48 89 c6             	mov    %rax,%rsi
  801059:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  801060:	00 00 00 
  801063:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  80106a:	00 00 00 
  80106d:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  80106f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801073:	48 89 c6             	mov    %rax,%rsi
  801076:	bf 01 00 00 00       	mov    $0x1,%edi
  80107b:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  801082:	00 00 00 
  801085:	ff d0                	callq  *%rax
  801087:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80108a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80108e:	79 1d                	jns    8010ad <open+0xc5>
		fd_close(fd, 0);
  801090:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801094:	be 00 00 00 00       	mov    $0x0,%esi
  801099:	48 89 c7             	mov    %rax,%rdi
  80109c:	48 b8 70 07 80 00 00 	movabs $0x800770,%rax
  8010a3:	00 00 00 
  8010a6:	ff d0                	callq  *%rax
		return r;
  8010a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010ab:	eb 13                	jmp    8010c0 <open+0xd8>
	}
	return fd2num(fd);
  8010ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b1:	48 89 c7             	mov    %rax,%rdi
  8010b4:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  8010bb:	00 00 00 
  8010be:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  8010c0:	c9                   	leaveq 
  8010c1:	c3                   	retq   

00000000008010c2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8010c2:	55                   	push   %rbp
  8010c3:	48 89 e5             	mov    %rsp,%rbp
  8010c6:	48 83 ec 10          	sub    $0x10,%rsp
  8010ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8010ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d2:	8b 50 0c             	mov    0xc(%rax),%edx
  8010d5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8010dc:	00 00 00 
  8010df:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8010e1:	be 00 00 00 00       	mov    $0x0,%esi
  8010e6:	bf 06 00 00 00       	mov    $0x6,%edi
  8010eb:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  8010f2:	00 00 00 
  8010f5:	ff d0                	callq  *%rax
}
  8010f7:	c9                   	leaveq 
  8010f8:	c3                   	retq   

00000000008010f9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8010f9:	55                   	push   %rbp
  8010fa:	48 89 e5             	mov    %rsp,%rbp
  8010fd:	48 83 ec 30          	sub    $0x30,%rsp
  801101:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801105:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801109:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80110d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801111:	8b 50 0c             	mov    0xc(%rax),%edx
  801114:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80111b:	00 00 00 
  80111e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801120:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801127:	00 00 00 
  80112a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80112e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  801132:	be 00 00 00 00       	mov    $0x0,%esi
  801137:	bf 03 00 00 00       	mov    $0x3,%edi
  80113c:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  801143:	00 00 00 
  801146:	ff d0                	callq  *%rax
  801148:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80114b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80114f:	79 05                	jns    801156 <devfile_read+0x5d>
		return r;
  801151:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801154:	eb 26                	jmp    80117c <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  801156:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801159:	48 63 d0             	movslq %eax,%rdx
  80115c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801160:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  801167:	00 00 00 
  80116a:	48 89 c7             	mov    %rax,%rdi
  80116d:	48 b8 f0 2f 80 00 00 	movabs $0x802ff0,%rax
  801174:	00 00 00 
  801177:	ff d0                	callq  *%rax
	return r;
  801179:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80117c:	c9                   	leaveq 
  80117d:	c3                   	retq   

000000000080117e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80117e:	55                   	push   %rbp
  80117f:	48 89 e5             	mov    %rsp,%rbp
  801182:	48 83 ec 30          	sub    $0x30,%rsp
  801186:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80118a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80118e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  801192:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  801199:	00 
	n = n > max ? max : n;
  80119a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8011a2:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8011a7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8011ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011af:	8b 50 0c             	mov    0xc(%rax),%edx
  8011b2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011b9:	00 00 00 
  8011bc:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8011be:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011c5:	00 00 00 
  8011c8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011cc:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8011d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8011d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011d8:	48 89 c6             	mov    %rax,%rsi
  8011db:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8011e2:	00 00 00 
  8011e5:	48 b8 f0 2f 80 00 00 	movabs $0x802ff0,%rax
  8011ec:	00 00 00 
  8011ef:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  8011f1:	be 00 00 00 00       	mov    $0x0,%esi
  8011f6:	bf 04 00 00 00       	mov    $0x4,%edi
  8011fb:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  801202:	00 00 00 
  801205:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  801207:	c9                   	leaveq 
  801208:	c3                   	retq   

0000000000801209 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801209:	55                   	push   %rbp
  80120a:	48 89 e5             	mov    %rsp,%rbp
  80120d:	48 83 ec 20          	sub    $0x20,%rsp
  801211:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801215:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121d:	8b 50 0c             	mov    0xc(%rax),%edx
  801220:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801227:	00 00 00 
  80122a:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80122c:	be 00 00 00 00       	mov    $0x0,%esi
  801231:	bf 05 00 00 00       	mov    $0x5,%edi
  801236:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  80123d:	00 00 00 
  801240:	ff d0                	callq  *%rax
  801242:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801245:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801249:	79 05                	jns    801250 <devfile_stat+0x47>
		return r;
  80124b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80124e:	eb 56                	jmp    8012a6 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801250:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801254:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80125b:	00 00 00 
  80125e:	48 89 c7             	mov    %rax,%rdi
  801261:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  801268:	00 00 00 
  80126b:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80126d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801274:	00 00 00 
  801277:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80127d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801281:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801287:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80128e:	00 00 00 
  801291:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801297:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80129b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8012a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a6:	c9                   	leaveq 
  8012a7:	c3                   	retq   

00000000008012a8 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8012a8:	55                   	push   %rbp
  8012a9:	48 89 e5             	mov    %rsp,%rbp
  8012ac:	48 83 ec 10          	sub    $0x10,%rsp
  8012b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b4:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8012b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bb:	8b 50 0c             	mov    0xc(%rax),%edx
  8012be:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012c5:	00 00 00 
  8012c8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8012ca:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8012d1:	00 00 00 
  8012d4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8012d7:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8012da:	be 00 00 00 00       	mov    $0x0,%esi
  8012df:	bf 02 00 00 00       	mov    $0x2,%edi
  8012e4:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  8012eb:	00 00 00 
  8012ee:	ff d0                	callq  *%rax
}
  8012f0:	c9                   	leaveq 
  8012f1:	c3                   	retq   

00000000008012f2 <remove>:

// Delete a file
int
remove(const char *path)
{
  8012f2:	55                   	push   %rbp
  8012f3:	48 89 e5             	mov    %rsp,%rbp
  8012f6:	48 83 ec 10          	sub    $0x10,%rsp
  8012fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8012fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801302:	48 89 c7             	mov    %rax,%rdi
  801305:	48 b8 49 2b 80 00 00 	movabs $0x802b49,%rax
  80130c:	00 00 00 
  80130f:	ff d0                	callq  *%rax
  801311:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801316:	7e 07                	jle    80131f <remove+0x2d>
		return -E_BAD_PATH;
  801318:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80131d:	eb 33                	jmp    801352 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80131f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801323:	48 89 c6             	mov    %rax,%rsi
  801326:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80132d:	00 00 00 
  801330:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  801337:	00 00 00 
  80133a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80133c:	be 00 00 00 00       	mov    $0x0,%esi
  801341:	bf 07 00 00 00       	mov    $0x7,%edi
  801346:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  80134d:	00 00 00 
  801350:	ff d0                	callq  *%rax
}
  801352:	c9                   	leaveq 
  801353:	c3                   	retq   

0000000000801354 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801354:	55                   	push   %rbp
  801355:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801358:	be 00 00 00 00       	mov    $0x0,%esi
  80135d:	bf 08 00 00 00       	mov    $0x8,%edi
  801362:	48 b8 61 0f 80 00 00 	movabs $0x800f61,%rax
  801369:	00 00 00 
  80136c:	ff d0                	callq  *%rax
}
  80136e:	5d                   	pop    %rbp
  80136f:	c3                   	retq   

0000000000801370 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801370:	55                   	push   %rbp
  801371:	48 89 e5             	mov    %rsp,%rbp
  801374:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80137b:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801382:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801389:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801390:	be 00 00 00 00       	mov    $0x0,%esi
  801395:	48 89 c7             	mov    %rax,%rdi
  801398:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  80139f:	00 00 00 
  8013a2:	ff d0                	callq  *%rax
  8013a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8013a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013ab:	79 28                	jns    8013d5 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8013ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013b0:	89 c6                	mov    %eax,%esi
  8013b2:	48 bf d6 36 80 00 00 	movabs $0x8036d6,%rdi
  8013b9:	00 00 00 
  8013bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c1:	48 ba 00 20 80 00 00 	movabs $0x802000,%rdx
  8013c8:	00 00 00 
  8013cb:	ff d2                	callq  *%rdx
		return fd_src;
  8013cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013d0:	e9 74 01 00 00       	jmpq   801549 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8013d5:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8013dc:	be 01 01 00 00       	mov    $0x101,%esi
  8013e1:	48 89 c7             	mov    %rax,%rdi
  8013e4:	48 b8 e8 0f 80 00 00 	movabs $0x800fe8,%rax
  8013eb:	00 00 00 
  8013ee:	ff d0                	callq  *%rax
  8013f0:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8013f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8013f7:	79 39                	jns    801432 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8013f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8013fc:	89 c6                	mov    %eax,%esi
  8013fe:	48 bf ec 36 80 00 00 	movabs $0x8036ec,%rdi
  801405:	00 00 00 
  801408:	b8 00 00 00 00       	mov    $0x0,%eax
  80140d:	48 ba 00 20 80 00 00 	movabs $0x802000,%rdx
  801414:	00 00 00 
  801417:	ff d2                	callq  *%rdx
		close(fd_src);
  801419:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80141c:	89 c7                	mov    %eax,%edi
  80141e:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  801425:	00 00 00 
  801428:	ff d0                	callq  *%rax
		return fd_dest;
  80142a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80142d:	e9 17 01 00 00       	jmpq   801549 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  801432:	eb 74                	jmp    8014a8 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  801434:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801437:	48 63 d0             	movslq %eax,%rdx
  80143a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801441:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801444:	48 89 ce             	mov    %rcx,%rsi
  801447:	89 c7                	mov    %eax,%edi
  801449:	48 b8 5c 0c 80 00 00 	movabs $0x800c5c,%rax
  801450:	00 00 00 
  801453:	ff d0                	callq  *%rax
  801455:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801458:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80145c:	79 4a                	jns    8014a8 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80145e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801461:	89 c6                	mov    %eax,%esi
  801463:	48 bf 06 37 80 00 00 	movabs $0x803706,%rdi
  80146a:	00 00 00 
  80146d:	b8 00 00 00 00       	mov    $0x0,%eax
  801472:	48 ba 00 20 80 00 00 	movabs $0x802000,%rdx
  801479:	00 00 00 
  80147c:	ff d2                	callq  *%rdx
			close(fd_src);
  80147e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801481:	89 c7                	mov    %eax,%edi
  801483:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  80148a:	00 00 00 
  80148d:	ff d0                	callq  *%rax
			close(fd_dest);
  80148f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801492:	89 c7                	mov    %eax,%edi
  801494:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  80149b:	00 00 00 
  80149e:	ff d0                	callq  *%rax
			return write_size;
  8014a0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014a3:	e9 a1 00 00 00       	jmpq   801549 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8014a8:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8014af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014b2:	ba 00 02 00 00       	mov    $0x200,%edx
  8014b7:	48 89 ce             	mov    %rcx,%rsi
  8014ba:	89 c7                	mov    %eax,%edi
  8014bc:	48 b8 12 0b 80 00 00 	movabs $0x800b12,%rax
  8014c3:	00 00 00 
  8014c6:	ff d0                	callq  *%rax
  8014c8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8014cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8014cf:	0f 8f 5f ff ff ff    	jg     801434 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8014d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8014d9:	79 47                	jns    801522 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8014db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014de:	89 c6                	mov    %eax,%esi
  8014e0:	48 bf 19 37 80 00 00 	movabs $0x803719,%rdi
  8014e7:	00 00 00 
  8014ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ef:	48 ba 00 20 80 00 00 	movabs $0x802000,%rdx
  8014f6:	00 00 00 
  8014f9:	ff d2                	callq  *%rdx
		close(fd_src);
  8014fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014fe:	89 c7                	mov    %eax,%edi
  801500:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  801507:	00 00 00 
  80150a:	ff d0                	callq  *%rax
		close(fd_dest);
  80150c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80150f:	89 c7                	mov    %eax,%edi
  801511:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  801518:	00 00 00 
  80151b:	ff d0                	callq  *%rax
		return read_size;
  80151d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801520:	eb 27                	jmp    801549 <copy+0x1d9>
	}
	close(fd_src);
  801522:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801525:	89 c7                	mov    %eax,%edi
  801527:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  80152e:	00 00 00 
  801531:	ff d0                	callq  *%rax
	close(fd_dest);
  801533:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801536:	89 c7                	mov    %eax,%edi
  801538:	48 b8 f0 08 80 00 00 	movabs $0x8008f0,%rax
  80153f:	00 00 00 
  801542:	ff d0                	callq  *%rax
	return 0;
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  801549:	c9                   	leaveq 
  80154a:	c3                   	retq   

000000000080154b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80154b:	55                   	push   %rbp
  80154c:	48 89 e5             	mov    %rsp,%rbp
  80154f:	53                   	push   %rbx
  801550:	48 83 ec 38          	sub    $0x38,%rsp
  801554:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801558:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80155c:	48 89 c7             	mov    %rax,%rdi
  80155f:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  801566:	00 00 00 
  801569:	ff d0                	callq  *%rax
  80156b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80156e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801572:	0f 88 bf 01 00 00    	js     801737 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801578:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157c:	ba 07 04 00 00       	mov    $0x407,%edx
  801581:	48 89 c6             	mov    %rax,%rsi
  801584:	bf 00 00 00 00       	mov    $0x0,%edi
  801589:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  801590:	00 00 00 
  801593:	ff d0                	callq  *%rax
  801595:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801598:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80159c:	0f 88 95 01 00 00    	js     801737 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8015a2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8015a6:	48 89 c7             	mov    %rax,%rdi
  8015a9:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  8015b0:	00 00 00 
  8015b3:	ff d0                	callq  *%rax
  8015b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015bc:	0f 88 5d 01 00 00    	js     80171f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015c2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015c6:	ba 07 04 00 00       	mov    $0x407,%edx
  8015cb:	48 89 c6             	mov    %rax,%rsi
  8015ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8015d3:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  8015da:	00 00 00 
  8015dd:	ff d0                	callq  *%rax
  8015df:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015e6:	0f 88 33 01 00 00    	js     80171f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8015ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f0:	48 89 c7             	mov    %rax,%rdi
  8015f3:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  8015fa:	00 00 00 
  8015fd:	ff d0                	callq  *%rax
  8015ff:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801603:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801607:	ba 07 04 00 00       	mov    $0x407,%edx
  80160c:	48 89 c6             	mov    %rax,%rsi
  80160f:	bf 00 00 00 00       	mov    $0x0,%edi
  801614:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  80161b:	00 00 00 
  80161e:	ff d0                	callq  *%rax
  801620:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801623:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801627:	79 05                	jns    80162e <pipe+0xe3>
		goto err2;
  801629:	e9 d9 00 00 00       	jmpq   801707 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80162e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801632:	48 89 c7             	mov    %rax,%rdi
  801635:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  80163c:	00 00 00 
  80163f:	ff d0                	callq  *%rax
  801641:	48 89 c2             	mov    %rax,%rdx
  801644:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801648:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80164e:	48 89 d1             	mov    %rdx,%rcx
  801651:	ba 00 00 00 00       	mov    $0x0,%edx
  801656:	48 89 c6             	mov    %rax,%rsi
  801659:	bf 00 00 00 00       	mov    $0x0,%edi
  80165e:	48 b8 53 03 80 00 00 	movabs $0x800353,%rax
  801665:	00 00 00 
  801668:	ff d0                	callq  *%rax
  80166a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80166d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801671:	79 1b                	jns    80168e <pipe+0x143>
		goto err3;
  801673:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  801674:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801678:	48 89 c6             	mov    %rax,%rsi
  80167b:	bf 00 00 00 00       	mov    $0x0,%edi
  801680:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  801687:	00 00 00 
  80168a:	ff d0                	callq  *%rax
  80168c:	eb 79                	jmp    801707 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80168e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801692:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801699:	00 00 00 
  80169c:	8b 12                	mov    (%rdx),%edx
  80169e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8016a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8016ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016af:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  8016b6:	00 00 00 
  8016b9:	8b 12                	mov    (%rdx),%edx
  8016bb:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8016bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8016c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cc:	48 89 c7             	mov    %rax,%rdi
  8016cf:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  8016d6:	00 00 00 
  8016d9:	ff d0                	callq  *%rax
  8016db:	89 c2                	mov    %eax,%edx
  8016dd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8016e1:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8016e3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8016e7:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8016eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ef:	48 89 c7             	mov    %rax,%rdi
  8016f2:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  8016f9:	00 00 00 
  8016fc:	ff d0                	callq  *%rax
  8016fe:	89 03                	mov    %eax,(%rbx)
	return 0;
  801700:	b8 00 00 00 00       	mov    $0x0,%eax
  801705:	eb 33                	jmp    80173a <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  801707:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80170b:	48 89 c6             	mov    %rax,%rsi
  80170e:	bf 00 00 00 00       	mov    $0x0,%edi
  801713:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  80171a:	00 00 00 
  80171d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80171f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801723:	48 89 c6             	mov    %rax,%rsi
  801726:	bf 00 00 00 00       	mov    $0x0,%edi
  80172b:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  801732:	00 00 00 
  801735:	ff d0                	callq  *%rax
err:
	return r;
  801737:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80173a:	48 83 c4 38          	add    $0x38,%rsp
  80173e:	5b                   	pop    %rbx
  80173f:	5d                   	pop    %rbp
  801740:	c3                   	retq   

0000000000801741 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801741:	55                   	push   %rbp
  801742:	48 89 e5             	mov    %rsp,%rbp
  801745:	53                   	push   %rbx
  801746:	48 83 ec 28          	sub    $0x28,%rsp
  80174a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80174e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801752:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801759:	00 00 00 
  80175c:	48 8b 00             	mov    (%rax),%rax
  80175f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801765:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  801768:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176c:	48 89 c7             	mov    %rax,%rdi
  80176f:	48 b8 88 35 80 00 00 	movabs $0x803588,%rax
  801776:	00 00 00 
  801779:	ff d0                	callq  *%rax
  80177b:	89 c3                	mov    %eax,%ebx
  80177d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801781:	48 89 c7             	mov    %rax,%rdi
  801784:	48 b8 88 35 80 00 00 	movabs $0x803588,%rax
  80178b:	00 00 00 
  80178e:	ff d0                	callq  *%rax
  801790:	39 c3                	cmp    %eax,%ebx
  801792:	0f 94 c0             	sete   %al
  801795:	0f b6 c0             	movzbl %al,%eax
  801798:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80179b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017a2:	00 00 00 
  8017a5:	48 8b 00             	mov    (%rax),%rax
  8017a8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8017ae:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8017b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017b4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8017b7:	75 05                	jne    8017be <_pipeisclosed+0x7d>
			return ret;
  8017b9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8017bc:	eb 4f                	jmp    80180d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8017be:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017c1:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8017c4:	74 42                	je     801808 <_pipeisclosed+0xc7>
  8017c6:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8017ca:	75 3c                	jne    801808 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8017cc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8017d3:	00 00 00 
  8017d6:	48 8b 00             	mov    (%rax),%rax
  8017d9:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8017df:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8017e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017e5:	89 c6                	mov    %eax,%esi
  8017e7:	48 bf 34 37 80 00 00 	movabs $0x803734,%rdi
  8017ee:	00 00 00 
  8017f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f6:	49 b8 00 20 80 00 00 	movabs $0x802000,%r8
  8017fd:	00 00 00 
  801800:	41 ff d0             	callq  *%r8
	}
  801803:	e9 4a ff ff ff       	jmpq   801752 <_pipeisclosed+0x11>
  801808:	e9 45 ff ff ff       	jmpq   801752 <_pipeisclosed+0x11>
}
  80180d:	48 83 c4 28          	add    $0x28,%rsp
  801811:	5b                   	pop    %rbx
  801812:	5d                   	pop    %rbp
  801813:	c3                   	retq   

0000000000801814 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801814:	55                   	push   %rbp
  801815:	48 89 e5             	mov    %rsp,%rbp
  801818:	48 83 ec 30          	sub    $0x30,%rsp
  80181c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80181f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801823:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801826:	48 89 d6             	mov    %rdx,%rsi
  801829:	89 c7                	mov    %eax,%edi
  80182b:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  801832:	00 00 00 
  801835:	ff d0                	callq  *%rax
  801837:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80183a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80183e:	79 05                	jns    801845 <pipeisclosed+0x31>
		return r;
  801840:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801843:	eb 31                	jmp    801876 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  801845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801849:	48 89 c7             	mov    %rax,%rdi
  80184c:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  801853:	00 00 00 
  801856:	ff d0                	callq  *%rax
  801858:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80185c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801860:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801864:	48 89 d6             	mov    %rdx,%rsi
  801867:	48 89 c7             	mov    %rax,%rdi
  80186a:	48 b8 41 17 80 00 00 	movabs $0x801741,%rax
  801871:	00 00 00 
  801874:	ff d0                	callq  *%rax
}
  801876:	c9                   	leaveq 
  801877:	c3                   	retq   

0000000000801878 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801878:	55                   	push   %rbp
  801879:	48 89 e5             	mov    %rsp,%rbp
  80187c:	48 83 ec 40          	sub    $0x40,%rsp
  801880:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801884:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801888:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80188c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801890:	48 89 c7             	mov    %rax,%rdi
  801893:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  80189a:	00 00 00 
  80189d:	ff d0                	callq  *%rax
  80189f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8018a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018a7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8018ab:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8018b2:	00 
  8018b3:	e9 92 00 00 00       	jmpq   80194a <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8018b8:	eb 41                	jmp    8018fb <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8018ba:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8018bf:	74 09                	je     8018ca <devpipe_read+0x52>
				return i;
  8018c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c5:	e9 92 00 00 00       	jmpq   80195c <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8018ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d2:	48 89 d6             	mov    %rdx,%rsi
  8018d5:	48 89 c7             	mov    %rax,%rdi
  8018d8:	48 b8 41 17 80 00 00 	movabs $0x801741,%rax
  8018df:	00 00 00 
  8018e2:	ff d0                	callq  *%rax
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	74 07                	je     8018ef <devpipe_read+0x77>
				return 0;
  8018e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ed:	eb 6d                	jmp    80195c <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8018ef:	48 b8 c5 02 80 00 00 	movabs $0x8002c5,%rax
  8018f6:	00 00 00 
  8018f9:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8018fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ff:	8b 10                	mov    (%rax),%edx
  801901:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801905:	8b 40 04             	mov    0x4(%rax),%eax
  801908:	39 c2                	cmp    %eax,%edx
  80190a:	74 ae                	je     8018ba <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80190c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801910:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801914:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  801918:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80191c:	8b 00                	mov    (%rax),%eax
  80191e:	99                   	cltd   
  80191f:	c1 ea 1b             	shr    $0x1b,%edx
  801922:	01 d0                	add    %edx,%eax
  801924:	83 e0 1f             	and    $0x1f,%eax
  801927:	29 d0                	sub    %edx,%eax
  801929:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192d:	48 98                	cltq   
  80192f:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  801934:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  801936:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80193a:	8b 00                	mov    (%rax),%eax
  80193c:	8d 50 01             	lea    0x1(%rax),%edx
  80193f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801943:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801945:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80194a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80194e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801952:	0f 82 60 ff ff ff    	jb     8018b8 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801958:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80195c:	c9                   	leaveq 
  80195d:	c3                   	retq   

000000000080195e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80195e:	55                   	push   %rbp
  80195f:	48 89 e5             	mov    %rsp,%rbp
  801962:	48 83 ec 40          	sub    $0x40,%rsp
  801966:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80196a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80196e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801972:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801976:	48 89 c7             	mov    %rax,%rdi
  801979:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  801980:	00 00 00 
  801983:	ff d0                	callq  *%rax
  801985:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801989:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80198d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801991:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801998:	00 
  801999:	e9 8e 00 00 00       	jmpq   801a2c <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80199e:	eb 31                	jmp    8019d1 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8019a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a8:	48 89 d6             	mov    %rdx,%rsi
  8019ab:	48 89 c7             	mov    %rax,%rdi
  8019ae:	48 b8 41 17 80 00 00 	movabs $0x801741,%rax
  8019b5:	00 00 00 
  8019b8:	ff d0                	callq  *%rax
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	74 07                	je     8019c5 <devpipe_write+0x67>
				return 0;
  8019be:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c3:	eb 79                	jmp    801a3e <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8019c5:	48 b8 c5 02 80 00 00 	movabs $0x8002c5,%rax
  8019cc:	00 00 00 
  8019cf:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019d5:	8b 40 04             	mov    0x4(%rax),%eax
  8019d8:	48 63 d0             	movslq %eax,%rdx
  8019db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019df:	8b 00                	mov    (%rax),%eax
  8019e1:	48 98                	cltq   
  8019e3:	48 83 c0 20          	add    $0x20,%rax
  8019e7:	48 39 c2             	cmp    %rax,%rdx
  8019ea:	73 b4                	jae    8019a0 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019f0:	8b 40 04             	mov    0x4(%rax),%eax
  8019f3:	99                   	cltd   
  8019f4:	c1 ea 1b             	shr    $0x1b,%edx
  8019f7:	01 d0                	add    %edx,%eax
  8019f9:	83 e0 1f             	and    $0x1f,%eax
  8019fc:	29 d0                	sub    %edx,%eax
  8019fe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a02:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a06:	48 01 ca             	add    %rcx,%rdx
  801a09:	0f b6 0a             	movzbl (%rdx),%ecx
  801a0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a10:	48 98                	cltq   
  801a12:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801a16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a1a:	8b 40 04             	mov    0x4(%rax),%eax
  801a1d:	8d 50 01             	lea    0x1(%rax),%edx
  801a20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a24:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a27:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a30:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801a34:	0f 82 64 ff ff ff    	jb     80199e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801a3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801a3e:	c9                   	leaveq 
  801a3f:	c3                   	retq   

0000000000801a40 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a40:	55                   	push   %rbp
  801a41:	48 89 e5             	mov    %rsp,%rbp
  801a44:	48 83 ec 20          	sub    $0x20,%rsp
  801a48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a54:	48 89 c7             	mov    %rax,%rdi
  801a57:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  801a5e:	00 00 00 
  801a61:	ff d0                	callq  *%rax
  801a63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  801a67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a6b:	48 be 47 37 80 00 00 	movabs $0x803747,%rsi
  801a72:	00 00 00 
  801a75:	48 89 c7             	mov    %rax,%rdi
  801a78:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  801a7f:	00 00 00 
  801a82:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  801a84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a88:	8b 50 04             	mov    0x4(%rax),%edx
  801a8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a8f:	8b 00                	mov    (%rax),%eax
  801a91:	29 c2                	sub    %eax,%edx
  801a93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a97:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801a9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aa1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801aa8:	00 00 00 
	stat->st_dev = &devpipe;
  801aab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801aaf:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801ab6:	00 00 00 
  801ab9:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801ac0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac5:	c9                   	leaveq 
  801ac6:	c3                   	retq   

0000000000801ac7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ac7:	55                   	push   %rbp
  801ac8:	48 89 e5             	mov    %rsp,%rbp
  801acb:	48 83 ec 10          	sub    $0x10,%rsp
  801acf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801ad3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ad7:	48 89 c6             	mov    %rax,%rsi
  801ada:	bf 00 00 00 00       	mov    $0x0,%edi
  801adf:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  801ae6:	00 00 00 
  801ae9:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aef:	48 89 c7             	mov    %rax,%rdi
  801af2:	48 b8 1d 06 80 00 00 	movabs $0x80061d,%rax
  801af9:	00 00 00 
  801afc:	ff d0                	callq  *%rax
  801afe:	48 89 c6             	mov    %rax,%rsi
  801b01:	bf 00 00 00 00       	mov    $0x0,%edi
  801b06:	48 b8 ae 03 80 00 00 	movabs $0x8003ae,%rax
  801b0d:	00 00 00 
  801b10:	ff d0                	callq  *%rax
}
  801b12:	c9                   	leaveq 
  801b13:	c3                   	retq   

0000000000801b14 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b14:	55                   	push   %rbp
  801b15:	48 89 e5             	mov    %rsp,%rbp
  801b18:	48 83 ec 20          	sub    $0x20,%rsp
  801b1c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801b1f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b22:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b25:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801b29:	be 01 00 00 00       	mov    $0x1,%esi
  801b2e:	48 89 c7             	mov    %rax,%rdi
  801b31:	48 b8 bb 01 80 00 00 	movabs $0x8001bb,%rax
  801b38:	00 00 00 
  801b3b:	ff d0                	callq  *%rax
}
  801b3d:	c9                   	leaveq 
  801b3e:	c3                   	retq   

0000000000801b3f <getchar>:

int
getchar(void)
{
  801b3f:	55                   	push   %rbp
  801b40:	48 89 e5             	mov    %rsp,%rbp
  801b43:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801b47:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801b4b:	ba 01 00 00 00       	mov    $0x1,%edx
  801b50:	48 89 c6             	mov    %rax,%rsi
  801b53:	bf 00 00 00 00       	mov    $0x0,%edi
  801b58:	48 b8 12 0b 80 00 00 	movabs $0x800b12,%rax
  801b5f:	00 00 00 
  801b62:	ff d0                	callq  *%rax
  801b64:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801b67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b6b:	79 05                	jns    801b72 <getchar+0x33>
		return r;
  801b6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b70:	eb 14                	jmp    801b86 <getchar+0x47>
	if (r < 1)
  801b72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b76:	7f 07                	jg     801b7f <getchar+0x40>
		return -E_EOF;
  801b78:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801b7d:	eb 07                	jmp    801b86 <getchar+0x47>
	return c;
  801b7f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801b83:	0f b6 c0             	movzbl %al,%eax
}
  801b86:	c9                   	leaveq 
  801b87:	c3                   	retq   

0000000000801b88 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801b88:	55                   	push   %rbp
  801b89:	48 89 e5             	mov    %rsp,%rbp
  801b8c:	48 83 ec 20          	sub    $0x20,%rsp
  801b90:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b93:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b97:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b9a:	48 89 d6             	mov    %rdx,%rsi
  801b9d:	89 c7                	mov    %eax,%edi
  801b9f:	48 b8 e0 06 80 00 00 	movabs $0x8006e0,%rax
  801ba6:	00 00 00 
  801ba9:	ff d0                	callq  *%rax
  801bab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bb2:	79 05                	jns    801bb9 <iscons+0x31>
		return r;
  801bb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb7:	eb 1a                	jmp    801bd3 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bbd:	8b 10                	mov    (%rax),%edx
  801bbf:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801bc6:	00 00 00 
  801bc9:	8b 00                	mov    (%rax),%eax
  801bcb:	39 c2                	cmp    %eax,%edx
  801bcd:	0f 94 c0             	sete   %al
  801bd0:	0f b6 c0             	movzbl %al,%eax
}
  801bd3:	c9                   	leaveq 
  801bd4:	c3                   	retq   

0000000000801bd5 <opencons>:

int
opencons(void)
{
  801bd5:	55                   	push   %rbp
  801bd6:	48 89 e5             	mov    %rsp,%rbp
  801bd9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801bdd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801be1:	48 89 c7             	mov    %rax,%rdi
  801be4:	48 b8 48 06 80 00 00 	movabs $0x800648,%rax
  801beb:	00 00 00 
  801bee:	ff d0                	callq  *%rax
  801bf0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bf7:	79 05                	jns    801bfe <opencons+0x29>
		return r;
  801bf9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfc:	eb 5b                	jmp    801c59 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801bfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c02:	ba 07 04 00 00       	mov    $0x407,%edx
  801c07:	48 89 c6             	mov    %rax,%rsi
  801c0a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c0f:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  801c16:	00 00 00 
  801c19:	ff d0                	callq  *%rax
  801c1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c22:	79 05                	jns    801c29 <opencons+0x54>
		return r;
  801c24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c27:	eb 30                	jmp    801c59 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801c29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c2d:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801c34:	00 00 00 
  801c37:	8b 12                	mov    (%rdx),%edx
  801c39:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801c3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c3f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801c46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c4a:	48 89 c7             	mov    %rax,%rdi
  801c4d:	48 b8 fa 05 80 00 00 	movabs $0x8005fa,%rax
  801c54:	00 00 00 
  801c57:	ff d0                	callq  *%rax
}
  801c59:	c9                   	leaveq 
  801c5a:	c3                   	retq   

0000000000801c5b <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801c5b:	55                   	push   %rbp
  801c5c:	48 89 e5             	mov    %rsp,%rbp
  801c5f:	48 83 ec 30          	sub    $0x30,%rsp
  801c63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c67:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c6b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801c6f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c74:	75 07                	jne    801c7d <devcons_read+0x22>
		return 0;
  801c76:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7b:	eb 4b                	jmp    801cc8 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801c7d:	eb 0c                	jmp    801c8b <devcons_read+0x30>
		sys_yield();
  801c7f:	48 b8 c5 02 80 00 00 	movabs $0x8002c5,%rax
  801c86:	00 00 00 
  801c89:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801c8b:	48 b8 05 02 80 00 00 	movabs $0x800205,%rax
  801c92:	00 00 00 
  801c95:	ff d0                	callq  *%rax
  801c97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c9e:	74 df                	je     801c7f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801ca0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ca4:	79 05                	jns    801cab <devcons_read+0x50>
		return c;
  801ca6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca9:	eb 1d                	jmp    801cc8 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801cab:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801caf:	75 07                	jne    801cb8 <devcons_read+0x5d>
		return 0;
  801cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb6:	eb 10                	jmp    801cc8 <devcons_read+0x6d>
	*(char*)vbuf = c;
  801cb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cbb:	89 c2                	mov    %eax,%edx
  801cbd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cc1:	88 10                	mov    %dl,(%rax)
	return 1;
  801cc3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc8:	c9                   	leaveq 
  801cc9:	c3                   	retq   

0000000000801cca <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801cca:	55                   	push   %rbp
  801ccb:	48 89 e5             	mov    %rsp,%rbp
  801cce:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801cd5:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801cdc:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801ce3:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801cf1:	eb 76                	jmp    801d69 <devcons_write+0x9f>
		m = n - tot;
  801cf3:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801cfa:	89 c2                	mov    %eax,%edx
  801cfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cff:	29 c2                	sub    %eax,%edx
  801d01:	89 d0                	mov    %edx,%eax
  801d03:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801d06:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d09:	83 f8 7f             	cmp    $0x7f,%eax
  801d0c:	76 07                	jbe    801d15 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801d0e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801d15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d18:	48 63 d0             	movslq %eax,%rdx
  801d1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1e:	48 63 c8             	movslq %eax,%rcx
  801d21:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801d28:	48 01 c1             	add    %rax,%rcx
  801d2b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d32:	48 89 ce             	mov    %rcx,%rsi
  801d35:	48 89 c7             	mov    %rax,%rdi
  801d38:	48 b8 d9 2e 80 00 00 	movabs $0x802ed9,%rax
  801d3f:	00 00 00 
  801d42:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801d44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d47:	48 63 d0             	movslq %eax,%rdx
  801d4a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801d51:	48 89 d6             	mov    %rdx,%rsi
  801d54:	48 89 c7             	mov    %rax,%rdi
  801d57:	48 b8 bb 01 80 00 00 	movabs $0x8001bb,%rax
  801d5e:	00 00 00 
  801d61:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801d63:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d66:	01 45 fc             	add    %eax,-0x4(%rbp)
  801d69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6c:	48 98                	cltq   
  801d6e:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801d75:	0f 82 78 ff ff ff    	jb     801cf3 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801d7b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d7e:	c9                   	leaveq 
  801d7f:	c3                   	retq   

0000000000801d80 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801d80:	55                   	push   %rbp
  801d81:	48 89 e5             	mov    %rsp,%rbp
  801d84:	48 83 ec 08          	sub    $0x8,%rsp
  801d88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d91:	c9                   	leaveq 
  801d92:	c3                   	retq   

0000000000801d93 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d93:	55                   	push   %rbp
  801d94:	48 89 e5             	mov    %rsp,%rbp
  801d97:	48 83 ec 10          	sub    $0x10,%rsp
  801d9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d9f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801da3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801da7:	48 be 53 37 80 00 00 	movabs $0x803753,%rsi
  801dae:	00 00 00 
  801db1:	48 89 c7             	mov    %rax,%rdi
  801db4:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  801dbb:	00 00 00 
  801dbe:	ff d0                	callq  *%rax
	return 0;
  801dc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc5:	c9                   	leaveq 
  801dc6:	c3                   	retq   

0000000000801dc7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801dc7:	55                   	push   %rbp
  801dc8:	48 89 e5             	mov    %rsp,%rbp
  801dcb:	53                   	push   %rbx
  801dcc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801dd3:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801dda:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801de0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801de7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801dee:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801df5:	84 c0                	test   %al,%al
  801df7:	74 23                	je     801e1c <_panic+0x55>
  801df9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801e00:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801e04:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801e08:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801e0c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801e10:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801e14:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801e18:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801e1c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e23:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801e2a:	00 00 00 
  801e2d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801e34:	00 00 00 
  801e37:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e3b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801e42:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801e49:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e50:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801e57:	00 00 00 
  801e5a:	48 8b 18             	mov    (%rax),%rbx
  801e5d:	48 b8 87 02 80 00 00 	movabs $0x800287,%rax
  801e64:	00 00 00 
  801e67:	ff d0                	callq  *%rax
  801e69:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801e6f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801e76:	41 89 c8             	mov    %ecx,%r8d
  801e79:	48 89 d1             	mov    %rdx,%rcx
  801e7c:	48 89 da             	mov    %rbx,%rdx
  801e7f:	89 c6                	mov    %eax,%esi
  801e81:	48 bf 60 37 80 00 00 	movabs $0x803760,%rdi
  801e88:	00 00 00 
  801e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e90:	49 b9 00 20 80 00 00 	movabs $0x802000,%r9
  801e97:	00 00 00 
  801e9a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e9d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801ea4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801eab:	48 89 d6             	mov    %rdx,%rsi
  801eae:	48 89 c7             	mov    %rax,%rdi
  801eb1:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  801eb8:	00 00 00 
  801ebb:	ff d0                	callq  *%rax
	cprintf("\n");
  801ebd:	48 bf 83 37 80 00 00 	movabs $0x803783,%rdi
  801ec4:	00 00 00 
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecc:	48 ba 00 20 80 00 00 	movabs $0x802000,%rdx
  801ed3:	00 00 00 
  801ed6:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ed8:	cc                   	int3   
  801ed9:	eb fd                	jmp    801ed8 <_panic+0x111>

0000000000801edb <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801edb:	55                   	push   %rbp
  801edc:	48 89 e5             	mov    %rsp,%rbp
  801edf:	48 83 ec 10          	sub    $0x10,%rsp
  801ee3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ee6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801eea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eee:	8b 00                	mov    (%rax),%eax
  801ef0:	8d 48 01             	lea    0x1(%rax),%ecx
  801ef3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ef7:	89 0a                	mov    %ecx,(%rdx)
  801ef9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801efc:	89 d1                	mov    %edx,%ecx
  801efe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f02:	48 98                	cltq   
  801f04:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801f08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0c:	8b 00                	mov    (%rax),%eax
  801f0e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801f13:	75 2c                	jne    801f41 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801f15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f19:	8b 00                	mov    (%rax),%eax
  801f1b:	48 98                	cltq   
  801f1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f21:	48 83 c2 08          	add    $0x8,%rdx
  801f25:	48 89 c6             	mov    %rax,%rsi
  801f28:	48 89 d7             	mov    %rdx,%rdi
  801f2b:	48 b8 bb 01 80 00 00 	movabs $0x8001bb,%rax
  801f32:	00 00 00 
  801f35:	ff d0                	callq  *%rax
        b->idx = 0;
  801f37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f3b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801f41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f45:	8b 40 04             	mov    0x4(%rax),%eax
  801f48:	8d 50 01             	lea    0x1(%rax),%edx
  801f4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f4f:	89 50 04             	mov    %edx,0x4(%rax)
}
  801f52:	c9                   	leaveq 
  801f53:	c3                   	retq   

0000000000801f54 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801f54:	55                   	push   %rbp
  801f55:	48 89 e5             	mov    %rsp,%rbp
  801f58:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801f5f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801f66:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801f6d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801f74:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801f7b:	48 8b 0a             	mov    (%rdx),%rcx
  801f7e:	48 89 08             	mov    %rcx,(%rax)
  801f81:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f85:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f89:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f8d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801f91:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801f98:	00 00 00 
    b.cnt = 0;
  801f9b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801fa2:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801fa5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801fac:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801fb3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801fba:	48 89 c6             	mov    %rax,%rsi
  801fbd:	48 bf db 1e 80 00 00 	movabs $0x801edb,%rdi
  801fc4:	00 00 00 
  801fc7:	48 b8 b3 23 80 00 00 	movabs $0x8023b3,%rax
  801fce:	00 00 00 
  801fd1:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  801fd3:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801fd9:	48 98                	cltq   
  801fdb:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801fe2:	48 83 c2 08          	add    $0x8,%rdx
  801fe6:	48 89 c6             	mov    %rax,%rsi
  801fe9:	48 89 d7             	mov    %rdx,%rdi
  801fec:	48 b8 bb 01 80 00 00 	movabs $0x8001bb,%rax
  801ff3:	00 00 00 
  801ff6:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  801ff8:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801ffe:	c9                   	leaveq 
  801fff:	c3                   	retq   

0000000000802000 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802000:	55                   	push   %rbp
  802001:	48 89 e5             	mov    %rsp,%rbp
  802004:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80200b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802012:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802019:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802020:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802027:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80202e:	84 c0                	test   %al,%al
  802030:	74 20                	je     802052 <cprintf+0x52>
  802032:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802036:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80203a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80203e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802042:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802046:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80204a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80204e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802052:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802059:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802060:	00 00 00 
  802063:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80206a:	00 00 00 
  80206d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802071:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802078:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80207f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  802086:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80208d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802094:	48 8b 0a             	mov    (%rdx),%rcx
  802097:	48 89 08             	mov    %rcx,(%rax)
  80209a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80209e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8020a2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8020a6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8020aa:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8020b1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8020b8:	48 89 d6             	mov    %rdx,%rsi
  8020bb:	48 89 c7             	mov    %rax,%rdi
  8020be:	48 b8 54 1f 80 00 00 	movabs $0x801f54,%rax
  8020c5:	00 00 00 
  8020c8:	ff d0                	callq  *%rax
  8020ca:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8020d0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8020d6:	c9                   	leaveq 
  8020d7:	c3                   	retq   

00000000008020d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8020d8:	55                   	push   %rbp
  8020d9:	48 89 e5             	mov    %rsp,%rbp
  8020dc:	53                   	push   %rbx
  8020dd:	48 83 ec 38          	sub    $0x38,%rsp
  8020e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8020e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8020e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8020ed:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8020f0:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8020f4:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8020f8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8020fb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8020ff:	77 3b                	ja     80213c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802101:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802104:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  802108:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80210b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80210f:	ba 00 00 00 00       	mov    $0x0,%edx
  802114:	48 f7 f3             	div    %rbx
  802117:	48 89 c2             	mov    %rax,%rdx
  80211a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80211d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802120:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802124:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802128:	41 89 f9             	mov    %edi,%r9d
  80212b:	48 89 c7             	mov    %rax,%rdi
  80212e:	48 b8 d8 20 80 00 00 	movabs $0x8020d8,%rax
  802135:	00 00 00 
  802138:	ff d0                	callq  *%rax
  80213a:	eb 1e                	jmp    80215a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80213c:	eb 12                	jmp    802150 <printnum+0x78>
			putch(padc, putdat);
  80213e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802142:	8b 55 cc             	mov    -0x34(%rbp),%edx
  802145:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802149:	48 89 ce             	mov    %rcx,%rsi
  80214c:	89 d7                	mov    %edx,%edi
  80214e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802150:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  802154:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  802158:	7f e4                	jg     80213e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80215a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80215d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802161:	ba 00 00 00 00       	mov    $0x0,%edx
  802166:	48 f7 f1             	div    %rcx
  802169:	48 89 d0             	mov    %rdx,%rax
  80216c:	48 ba 90 39 80 00 00 	movabs $0x803990,%rdx
  802173:	00 00 00 
  802176:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80217a:	0f be d0             	movsbl %al,%edx
  80217d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802181:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802185:	48 89 ce             	mov    %rcx,%rsi
  802188:	89 d7                	mov    %edx,%edi
  80218a:	ff d0                	callq  *%rax
}
  80218c:	48 83 c4 38          	add    $0x38,%rsp
  802190:	5b                   	pop    %rbx
  802191:	5d                   	pop    %rbp
  802192:	c3                   	retq   

0000000000802193 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802193:	55                   	push   %rbp
  802194:	48 89 e5             	mov    %rsp,%rbp
  802197:	48 83 ec 1c          	sub    $0x1c,%rsp
  80219b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80219f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8021a2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8021a6:	7e 52                	jle    8021fa <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8021a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ac:	8b 00                	mov    (%rax),%eax
  8021ae:	83 f8 30             	cmp    $0x30,%eax
  8021b1:	73 24                	jae    8021d7 <getuint+0x44>
  8021b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8021bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bf:	8b 00                	mov    (%rax),%eax
  8021c1:	89 c0                	mov    %eax,%eax
  8021c3:	48 01 d0             	add    %rdx,%rax
  8021c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021ca:	8b 12                	mov    (%rdx),%edx
  8021cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8021cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021d3:	89 0a                	mov    %ecx,(%rdx)
  8021d5:	eb 17                	jmp    8021ee <getuint+0x5b>
  8021d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021df:	48 89 d0             	mov    %rdx,%rax
  8021e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8021e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8021ee:	48 8b 00             	mov    (%rax),%rax
  8021f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8021f5:	e9 a3 00 00 00       	jmpq   80229d <getuint+0x10a>
	else if (lflag)
  8021fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8021fe:	74 4f                	je     80224f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802204:	8b 00                	mov    (%rax),%eax
  802206:	83 f8 30             	cmp    $0x30,%eax
  802209:	73 24                	jae    80222f <getuint+0x9c>
  80220b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802213:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802217:	8b 00                	mov    (%rax),%eax
  802219:	89 c0                	mov    %eax,%eax
  80221b:	48 01 d0             	add    %rdx,%rax
  80221e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802222:	8b 12                	mov    (%rdx),%edx
  802224:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802227:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80222b:	89 0a                	mov    %ecx,(%rdx)
  80222d:	eb 17                	jmp    802246 <getuint+0xb3>
  80222f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802233:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802237:	48 89 d0             	mov    %rdx,%rax
  80223a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80223e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802242:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802246:	48 8b 00             	mov    (%rax),%rax
  802249:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80224d:	eb 4e                	jmp    80229d <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80224f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802253:	8b 00                	mov    (%rax),%eax
  802255:	83 f8 30             	cmp    $0x30,%eax
  802258:	73 24                	jae    80227e <getuint+0xeb>
  80225a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802266:	8b 00                	mov    (%rax),%eax
  802268:	89 c0                	mov    %eax,%eax
  80226a:	48 01 d0             	add    %rdx,%rax
  80226d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802271:	8b 12                	mov    (%rdx),%edx
  802273:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802276:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80227a:	89 0a                	mov    %ecx,(%rdx)
  80227c:	eb 17                	jmp    802295 <getuint+0x102>
  80227e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802282:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802286:	48 89 d0             	mov    %rdx,%rax
  802289:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80228d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802291:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802295:	8b 00                	mov    (%rax),%eax
  802297:	89 c0                	mov    %eax,%eax
  802299:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80229d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022a1:	c9                   	leaveq 
  8022a2:	c3                   	retq   

00000000008022a3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8022a3:	55                   	push   %rbp
  8022a4:	48 89 e5             	mov    %rsp,%rbp
  8022a7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8022ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022af:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8022b2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8022b6:	7e 52                	jle    80230a <getint+0x67>
		x=va_arg(*ap, long long);
  8022b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bc:	8b 00                	mov    (%rax),%eax
  8022be:	83 f8 30             	cmp    $0x30,%eax
  8022c1:	73 24                	jae    8022e7 <getint+0x44>
  8022c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cf:	8b 00                	mov    (%rax),%eax
  8022d1:	89 c0                	mov    %eax,%eax
  8022d3:	48 01 d0             	add    %rdx,%rax
  8022d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022da:	8b 12                	mov    (%rdx),%edx
  8022dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022e3:	89 0a                	mov    %ecx,(%rdx)
  8022e5:	eb 17                	jmp    8022fe <getint+0x5b>
  8022e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022ef:	48 89 d0             	mov    %rdx,%rax
  8022f2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022fe:	48 8b 00             	mov    (%rax),%rax
  802301:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802305:	e9 a3 00 00 00       	jmpq   8023ad <getint+0x10a>
	else if (lflag)
  80230a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80230e:	74 4f                	je     80235f <getint+0xbc>
		x=va_arg(*ap, long);
  802310:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802314:	8b 00                	mov    (%rax),%eax
  802316:	83 f8 30             	cmp    $0x30,%eax
  802319:	73 24                	jae    80233f <getint+0x9c>
  80231b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802323:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802327:	8b 00                	mov    (%rax),%eax
  802329:	89 c0                	mov    %eax,%eax
  80232b:	48 01 d0             	add    %rdx,%rax
  80232e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802332:	8b 12                	mov    (%rdx),%edx
  802334:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802337:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80233b:	89 0a                	mov    %ecx,(%rdx)
  80233d:	eb 17                	jmp    802356 <getint+0xb3>
  80233f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802343:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802347:	48 89 d0             	mov    %rdx,%rax
  80234a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80234e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802352:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802356:	48 8b 00             	mov    (%rax),%rax
  802359:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80235d:	eb 4e                	jmp    8023ad <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80235f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802363:	8b 00                	mov    (%rax),%eax
  802365:	83 f8 30             	cmp    $0x30,%eax
  802368:	73 24                	jae    80238e <getint+0xeb>
  80236a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802376:	8b 00                	mov    (%rax),%eax
  802378:	89 c0                	mov    %eax,%eax
  80237a:	48 01 d0             	add    %rdx,%rax
  80237d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802381:	8b 12                	mov    (%rdx),%edx
  802383:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802386:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80238a:	89 0a                	mov    %ecx,(%rdx)
  80238c:	eb 17                	jmp    8023a5 <getint+0x102>
  80238e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802392:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802396:	48 89 d0             	mov    %rdx,%rax
  802399:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80239d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023a1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8023a5:	8b 00                	mov    (%rax),%eax
  8023a7:	48 98                	cltq   
  8023a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8023ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8023b1:	c9                   	leaveq 
  8023b2:	c3                   	retq   

00000000008023b3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8023b3:	55                   	push   %rbp
  8023b4:	48 89 e5             	mov    %rsp,%rbp
  8023b7:	41 54                	push   %r12
  8023b9:	53                   	push   %rbx
  8023ba:	48 83 ec 60          	sub    $0x60,%rsp
  8023be:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8023c2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8023c6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8023ca:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8023ce:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8023d2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8023d6:	48 8b 0a             	mov    (%rdx),%rcx
  8023d9:	48 89 08             	mov    %rcx,(%rax)
  8023dc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8023e0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8023e4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8023e8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8023ec:	eb 17                	jmp    802405 <vprintfmt+0x52>
			if (ch == '\0')
  8023ee:	85 db                	test   %ebx,%ebx
  8023f0:	0f 84 cc 04 00 00    	je     8028c2 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8023f6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8023fa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8023fe:	48 89 d6             	mov    %rdx,%rsi
  802401:	89 df                	mov    %ebx,%edi
  802403:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802405:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802409:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80240d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802411:	0f b6 00             	movzbl (%rax),%eax
  802414:	0f b6 d8             	movzbl %al,%ebx
  802417:	83 fb 25             	cmp    $0x25,%ebx
  80241a:	75 d2                	jne    8023ee <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80241c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802420:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802427:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80242e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802435:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80243c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802440:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802444:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802448:	0f b6 00             	movzbl (%rax),%eax
  80244b:	0f b6 d8             	movzbl %al,%ebx
  80244e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802451:	83 f8 55             	cmp    $0x55,%eax
  802454:	0f 87 34 04 00 00    	ja     80288e <vprintfmt+0x4db>
  80245a:	89 c0                	mov    %eax,%eax
  80245c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802463:	00 
  802464:	48 b8 b8 39 80 00 00 	movabs $0x8039b8,%rax
  80246b:	00 00 00 
  80246e:	48 01 d0             	add    %rdx,%rax
  802471:	48 8b 00             	mov    (%rax),%rax
  802474:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802476:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80247a:	eb c0                	jmp    80243c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80247c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802480:	eb ba                	jmp    80243c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802482:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802489:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80248c:	89 d0                	mov    %edx,%eax
  80248e:	c1 e0 02             	shl    $0x2,%eax
  802491:	01 d0                	add    %edx,%eax
  802493:	01 c0                	add    %eax,%eax
  802495:	01 d8                	add    %ebx,%eax
  802497:	83 e8 30             	sub    $0x30,%eax
  80249a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80249d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8024a1:	0f b6 00             	movzbl (%rax),%eax
  8024a4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8024a7:	83 fb 2f             	cmp    $0x2f,%ebx
  8024aa:	7e 0c                	jle    8024b8 <vprintfmt+0x105>
  8024ac:	83 fb 39             	cmp    $0x39,%ebx
  8024af:	7f 07                	jg     8024b8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8024b1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8024b6:	eb d1                	jmp    802489 <vprintfmt+0xd6>
			goto process_precision;
  8024b8:	eb 58                	jmp    802512 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8024ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024bd:	83 f8 30             	cmp    $0x30,%eax
  8024c0:	73 17                	jae    8024d9 <vprintfmt+0x126>
  8024c2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024c9:	89 c0                	mov    %eax,%eax
  8024cb:	48 01 d0             	add    %rdx,%rax
  8024ce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8024d1:	83 c2 08             	add    $0x8,%edx
  8024d4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8024d7:	eb 0f                	jmp    8024e8 <vprintfmt+0x135>
  8024d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024dd:	48 89 d0             	mov    %rdx,%rax
  8024e0:	48 83 c2 08          	add    $0x8,%rdx
  8024e4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8024e8:	8b 00                	mov    (%rax),%eax
  8024ea:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8024ed:	eb 23                	jmp    802512 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8024ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8024f3:	79 0c                	jns    802501 <vprintfmt+0x14e>
				width = 0;
  8024f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8024fc:	e9 3b ff ff ff       	jmpq   80243c <vprintfmt+0x89>
  802501:	e9 36 ff ff ff       	jmpq   80243c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802506:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80250d:	e9 2a ff ff ff       	jmpq   80243c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802512:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802516:	79 12                	jns    80252a <vprintfmt+0x177>
				width = precision, precision = -1;
  802518:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80251b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80251e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802525:	e9 12 ff ff ff       	jmpq   80243c <vprintfmt+0x89>
  80252a:	e9 0d ff ff ff       	jmpq   80243c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80252f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802533:	e9 04 ff ff ff       	jmpq   80243c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802538:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80253b:	83 f8 30             	cmp    $0x30,%eax
  80253e:	73 17                	jae    802557 <vprintfmt+0x1a4>
  802540:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802544:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802547:	89 c0                	mov    %eax,%eax
  802549:	48 01 d0             	add    %rdx,%rax
  80254c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80254f:	83 c2 08             	add    $0x8,%edx
  802552:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802555:	eb 0f                	jmp    802566 <vprintfmt+0x1b3>
  802557:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80255b:	48 89 d0             	mov    %rdx,%rax
  80255e:	48 83 c2 08          	add    $0x8,%rdx
  802562:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802566:	8b 10                	mov    (%rax),%edx
  802568:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80256c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802570:	48 89 ce             	mov    %rcx,%rsi
  802573:	89 d7                	mov    %edx,%edi
  802575:	ff d0                	callq  *%rax
			break;
  802577:	e9 40 03 00 00       	jmpq   8028bc <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80257c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80257f:	83 f8 30             	cmp    $0x30,%eax
  802582:	73 17                	jae    80259b <vprintfmt+0x1e8>
  802584:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802588:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80258b:	89 c0                	mov    %eax,%eax
  80258d:	48 01 d0             	add    %rdx,%rax
  802590:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802593:	83 c2 08             	add    $0x8,%edx
  802596:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802599:	eb 0f                	jmp    8025aa <vprintfmt+0x1f7>
  80259b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80259f:	48 89 d0             	mov    %rdx,%rax
  8025a2:	48 83 c2 08          	add    $0x8,%rdx
  8025a6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025aa:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8025ac:	85 db                	test   %ebx,%ebx
  8025ae:	79 02                	jns    8025b2 <vprintfmt+0x1ff>
				err = -err;
  8025b0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8025b2:	83 fb 15             	cmp    $0x15,%ebx
  8025b5:	7f 16                	jg     8025cd <vprintfmt+0x21a>
  8025b7:	48 b8 e0 38 80 00 00 	movabs $0x8038e0,%rax
  8025be:	00 00 00 
  8025c1:	48 63 d3             	movslq %ebx,%rdx
  8025c4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8025c8:	4d 85 e4             	test   %r12,%r12
  8025cb:	75 2e                	jne    8025fb <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8025cd:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8025d1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8025d5:	89 d9                	mov    %ebx,%ecx
  8025d7:	48 ba a1 39 80 00 00 	movabs $0x8039a1,%rdx
  8025de:	00 00 00 
  8025e1:	48 89 c7             	mov    %rax,%rdi
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e9:	49 b8 cb 28 80 00 00 	movabs $0x8028cb,%r8
  8025f0:	00 00 00 
  8025f3:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8025f6:	e9 c1 02 00 00       	jmpq   8028bc <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8025fb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8025ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802603:	4c 89 e1             	mov    %r12,%rcx
  802606:	48 ba aa 39 80 00 00 	movabs $0x8039aa,%rdx
  80260d:	00 00 00 
  802610:	48 89 c7             	mov    %rax,%rdi
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
  802618:	49 b8 cb 28 80 00 00 	movabs $0x8028cb,%r8
  80261f:	00 00 00 
  802622:	41 ff d0             	callq  *%r8
			break;
  802625:	e9 92 02 00 00       	jmpq   8028bc <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80262a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80262d:	83 f8 30             	cmp    $0x30,%eax
  802630:	73 17                	jae    802649 <vprintfmt+0x296>
  802632:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802636:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802639:	89 c0                	mov    %eax,%eax
  80263b:	48 01 d0             	add    %rdx,%rax
  80263e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802641:	83 c2 08             	add    $0x8,%edx
  802644:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802647:	eb 0f                	jmp    802658 <vprintfmt+0x2a5>
  802649:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80264d:	48 89 d0             	mov    %rdx,%rax
  802650:	48 83 c2 08          	add    $0x8,%rdx
  802654:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802658:	4c 8b 20             	mov    (%rax),%r12
  80265b:	4d 85 e4             	test   %r12,%r12
  80265e:	75 0a                	jne    80266a <vprintfmt+0x2b7>
				p = "(null)";
  802660:	49 bc ad 39 80 00 00 	movabs $0x8039ad,%r12
  802667:	00 00 00 
			if (width > 0 && padc != '-')
  80266a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80266e:	7e 3f                	jle    8026af <vprintfmt+0x2fc>
  802670:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  802674:	74 39                	je     8026af <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  802676:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802679:	48 98                	cltq   
  80267b:	48 89 c6             	mov    %rax,%rsi
  80267e:	4c 89 e7             	mov    %r12,%rdi
  802681:	48 b8 77 2b 80 00 00 	movabs $0x802b77,%rax
  802688:	00 00 00 
  80268b:	ff d0                	callq  *%rax
  80268d:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802690:	eb 17                	jmp    8026a9 <vprintfmt+0x2f6>
					putch(padc, putdat);
  802692:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802696:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80269a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80269e:	48 89 ce             	mov    %rcx,%rsi
  8026a1:	89 d7                	mov    %edx,%edi
  8026a3:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8026a5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8026a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8026ad:	7f e3                	jg     802692 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8026af:	eb 37                	jmp    8026e8 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8026b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8026b5:	74 1e                	je     8026d5 <vprintfmt+0x322>
  8026b7:	83 fb 1f             	cmp    $0x1f,%ebx
  8026ba:	7e 05                	jle    8026c1 <vprintfmt+0x30e>
  8026bc:	83 fb 7e             	cmp    $0x7e,%ebx
  8026bf:	7e 14                	jle    8026d5 <vprintfmt+0x322>
					putch('?', putdat);
  8026c1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026c5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026c9:	48 89 d6             	mov    %rdx,%rsi
  8026cc:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8026d1:	ff d0                	callq  *%rax
  8026d3:	eb 0f                	jmp    8026e4 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8026d5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026d9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026dd:	48 89 d6             	mov    %rdx,%rsi
  8026e0:	89 df                	mov    %ebx,%edi
  8026e2:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8026e4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8026e8:	4c 89 e0             	mov    %r12,%rax
  8026eb:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8026ef:	0f b6 00             	movzbl (%rax),%eax
  8026f2:	0f be d8             	movsbl %al,%ebx
  8026f5:	85 db                	test   %ebx,%ebx
  8026f7:	74 10                	je     802709 <vprintfmt+0x356>
  8026f9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8026fd:	78 b2                	js     8026b1 <vprintfmt+0x2fe>
  8026ff:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802703:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802707:	79 a8                	jns    8026b1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802709:	eb 16                	jmp    802721 <vprintfmt+0x36e>
				putch(' ', putdat);
  80270b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80270f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802713:	48 89 d6             	mov    %rdx,%rsi
  802716:	bf 20 00 00 00       	mov    $0x20,%edi
  80271b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80271d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802721:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802725:	7f e4                	jg     80270b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  802727:	e9 90 01 00 00       	jmpq   8028bc <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80272c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802730:	be 03 00 00 00       	mov    $0x3,%esi
  802735:	48 89 c7             	mov    %rax,%rdi
  802738:	48 b8 a3 22 80 00 00 	movabs $0x8022a3,%rax
  80273f:	00 00 00 
  802742:	ff d0                	callq  *%rax
  802744:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  802748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80274c:	48 85 c0             	test   %rax,%rax
  80274f:	79 1d                	jns    80276e <vprintfmt+0x3bb>
				putch('-', putdat);
  802751:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802755:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802759:	48 89 d6             	mov    %rdx,%rsi
  80275c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  802761:	ff d0                	callq  *%rax
				num = -(long long) num;
  802763:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802767:	48 f7 d8             	neg    %rax
  80276a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80276e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802775:	e9 d5 00 00 00       	jmpq   80284f <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80277a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80277e:	be 03 00 00 00       	mov    $0x3,%esi
  802783:	48 89 c7             	mov    %rax,%rdi
  802786:	48 b8 93 21 80 00 00 	movabs $0x802193,%rax
  80278d:	00 00 00 
  802790:	ff d0                	callq  *%rax
  802792:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802796:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80279d:	e9 ad 00 00 00       	jmpq   80284f <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  8027a2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027a6:	be 03 00 00 00       	mov    $0x3,%esi
  8027ab:	48 89 c7             	mov    %rax,%rdi
  8027ae:	48 b8 93 21 80 00 00 	movabs $0x802193,%rax
  8027b5:	00 00 00 
  8027b8:	ff d0                	callq  *%rax
  8027ba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  8027be:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  8027c5:	e9 85 00 00 00       	jmpq   80284f <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  8027ca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027d2:	48 89 d6             	mov    %rdx,%rsi
  8027d5:	bf 30 00 00 00       	mov    $0x30,%edi
  8027da:	ff d0                	callq  *%rax
			putch('x', putdat);
  8027dc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027e4:	48 89 d6             	mov    %rdx,%rsi
  8027e7:	bf 78 00 00 00       	mov    $0x78,%edi
  8027ec:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8027ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8027f1:	83 f8 30             	cmp    $0x30,%eax
  8027f4:	73 17                	jae    80280d <vprintfmt+0x45a>
  8027f6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8027fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8027fd:	89 c0                	mov    %eax,%eax
  8027ff:	48 01 d0             	add    %rdx,%rax
  802802:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802805:	83 c2 08             	add    $0x8,%edx
  802808:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80280b:	eb 0f                	jmp    80281c <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  80280d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802811:	48 89 d0             	mov    %rdx,%rax
  802814:	48 83 c2 08          	add    $0x8,%rdx
  802818:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80281c:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80281f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802823:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80282a:	eb 23                	jmp    80284f <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80282c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802830:	be 03 00 00 00       	mov    $0x3,%esi
  802835:	48 89 c7             	mov    %rax,%rdi
  802838:	48 b8 93 21 80 00 00 	movabs $0x802193,%rax
  80283f:	00 00 00 
  802842:	ff d0                	callq  *%rax
  802844:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  802848:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80284f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  802854:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802857:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80285a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80285e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802862:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802866:	45 89 c1             	mov    %r8d,%r9d
  802869:	41 89 f8             	mov    %edi,%r8d
  80286c:	48 89 c7             	mov    %rax,%rdi
  80286f:	48 b8 d8 20 80 00 00 	movabs $0x8020d8,%rax
  802876:	00 00 00 
  802879:	ff d0                	callq  *%rax
			break;
  80287b:	eb 3f                	jmp    8028bc <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80287d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802881:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802885:	48 89 d6             	mov    %rdx,%rsi
  802888:	89 df                	mov    %ebx,%edi
  80288a:	ff d0                	callq  *%rax
			break;
  80288c:	eb 2e                	jmp    8028bc <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80288e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802892:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802896:	48 89 d6             	mov    %rdx,%rsi
  802899:	bf 25 00 00 00       	mov    $0x25,%edi
  80289e:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8028a0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8028a5:	eb 05                	jmp    8028ac <vprintfmt+0x4f9>
  8028a7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8028ac:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8028b0:	48 83 e8 01          	sub    $0x1,%rax
  8028b4:	0f b6 00             	movzbl (%rax),%eax
  8028b7:	3c 25                	cmp    $0x25,%al
  8028b9:	75 ec                	jne    8028a7 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8028bb:	90                   	nop
		}
	}
  8028bc:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8028bd:	e9 43 fb ff ff       	jmpq   802405 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8028c2:	48 83 c4 60          	add    $0x60,%rsp
  8028c6:	5b                   	pop    %rbx
  8028c7:	41 5c                	pop    %r12
  8028c9:	5d                   	pop    %rbp
  8028ca:	c3                   	retq   

00000000008028cb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8028cb:	55                   	push   %rbp
  8028cc:	48 89 e5             	mov    %rsp,%rbp
  8028cf:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8028d6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8028dd:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8028e4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8028eb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8028f2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8028f9:	84 c0                	test   %al,%al
  8028fb:	74 20                	je     80291d <printfmt+0x52>
  8028fd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802901:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802905:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802909:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80290d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802911:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802915:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802919:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80291d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802924:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80292b:	00 00 00 
  80292e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  802935:	00 00 00 
  802938:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80293c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  802943:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80294a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  802951:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  802958:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80295f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  802966:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80296d:	48 89 c7             	mov    %rax,%rdi
  802970:	48 b8 b3 23 80 00 00 	movabs $0x8023b3,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
	va_end(ap);
}
  80297c:	c9                   	leaveq 
  80297d:	c3                   	retq   

000000000080297e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80297e:	55                   	push   %rbp
  80297f:	48 89 e5             	mov    %rsp,%rbp
  802982:	48 83 ec 10          	sub    $0x10,%rsp
  802986:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802989:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80298d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802991:	8b 40 10             	mov    0x10(%rax),%eax
  802994:	8d 50 01             	lea    0x1(%rax),%edx
  802997:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80299e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a2:	48 8b 10             	mov    (%rax),%rdx
  8029a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8029ad:	48 39 c2             	cmp    %rax,%rdx
  8029b0:	73 17                	jae    8029c9 <sprintputch+0x4b>
		*b->buf++ = ch;
  8029b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029b6:	48 8b 00             	mov    (%rax),%rax
  8029b9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8029bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029c1:	48 89 0a             	mov    %rcx,(%rdx)
  8029c4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029c7:	88 10                	mov    %dl,(%rax)
}
  8029c9:	c9                   	leaveq 
  8029ca:	c3                   	retq   

00000000008029cb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8029cb:	55                   	push   %rbp
  8029cc:	48 89 e5             	mov    %rsp,%rbp
  8029cf:	48 83 ec 50          	sub    $0x50,%rsp
  8029d3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8029d7:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8029da:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8029de:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8029e2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8029e6:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8029ea:	48 8b 0a             	mov    (%rdx),%rcx
  8029ed:	48 89 08             	mov    %rcx,(%rax)
  8029f0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8029f4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8029f8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8029fc:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802a00:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a04:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  802a08:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  802a0b:	48 98                	cltq   
  802a0d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802a11:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a15:	48 01 d0             	add    %rdx,%rax
  802a18:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  802a1c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802a23:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  802a28:	74 06                	je     802a30 <vsnprintf+0x65>
  802a2a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  802a2e:	7f 07                	jg     802a37 <vsnprintf+0x6c>
		return -E_INVAL;
  802a30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a35:	eb 2f                	jmp    802a66 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  802a37:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  802a3b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  802a3f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802a43:	48 89 c6             	mov    %rax,%rsi
  802a46:	48 bf 7e 29 80 00 00 	movabs $0x80297e,%rdi
  802a4d:	00 00 00 
  802a50:	48 b8 b3 23 80 00 00 	movabs $0x8023b3,%rax
  802a57:	00 00 00 
  802a5a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  802a5c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a60:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  802a63:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  802a66:	c9                   	leaveq 
  802a67:	c3                   	retq   

0000000000802a68 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802a68:	55                   	push   %rbp
  802a69:	48 89 e5             	mov    %rsp,%rbp
  802a6c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  802a73:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802a7a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  802a80:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802a87:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802a8e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802a95:	84 c0                	test   %al,%al
  802a97:	74 20                	je     802ab9 <snprintf+0x51>
  802a99:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802a9d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802aa1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802aa5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802aa9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802aad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802ab1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802ab5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802ab9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802ac0:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802ac7:	00 00 00 
  802aca:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802ad1:	00 00 00 
  802ad4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ad8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802adf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802ae6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802aed:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802af4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802afb:	48 8b 0a             	mov    (%rdx),%rcx
  802afe:	48 89 08             	mov    %rcx,(%rax)
  802b01:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b05:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b09:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b0d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802b11:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802b18:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802b1f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802b25:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802b2c:	48 89 c7             	mov    %rax,%rdi
  802b2f:	48 b8 cb 29 80 00 00 	movabs $0x8029cb,%rax
  802b36:	00 00 00 
  802b39:	ff d0                	callq  *%rax
  802b3b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802b41:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802b47:	c9                   	leaveq 
  802b48:	c3                   	retq   

0000000000802b49 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802b49:	55                   	push   %rbp
  802b4a:	48 89 e5             	mov    %rsp,%rbp
  802b4d:	48 83 ec 18          	sub    $0x18,%rsp
  802b51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802b55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b5c:	eb 09                	jmp    802b67 <strlen+0x1e>
		n++;
  802b5e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802b62:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802b67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b6b:	0f b6 00             	movzbl (%rax),%eax
  802b6e:	84 c0                	test   %al,%al
  802b70:	75 ec                	jne    802b5e <strlen+0x15>
		n++;
	return n;
  802b72:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b75:	c9                   	leaveq 
  802b76:	c3                   	retq   

0000000000802b77 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802b77:	55                   	push   %rbp
  802b78:	48 89 e5             	mov    %rsp,%rbp
  802b7b:	48 83 ec 20          	sub    $0x20,%rsp
  802b7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802b87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b8e:	eb 0e                	jmp    802b9e <strnlen+0x27>
		n++;
  802b90:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802b94:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802b99:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802b9e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802ba3:	74 0b                	je     802bb0 <strnlen+0x39>
  802ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba9:	0f b6 00             	movzbl (%rax),%eax
  802bac:	84 c0                	test   %al,%al
  802bae:	75 e0                	jne    802b90 <strnlen+0x19>
		n++;
	return n;
  802bb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bb3:	c9                   	leaveq 
  802bb4:	c3                   	retq   

0000000000802bb5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802bb5:	55                   	push   %rbp
  802bb6:	48 89 e5             	mov    %rsp,%rbp
  802bb9:	48 83 ec 20          	sub    $0x20,%rsp
  802bbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bc1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802bcd:	90                   	nop
  802bce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802bd6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802bda:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bde:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802be2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802be6:	0f b6 12             	movzbl (%rdx),%edx
  802be9:	88 10                	mov    %dl,(%rax)
  802beb:	0f b6 00             	movzbl (%rax),%eax
  802bee:	84 c0                	test   %al,%al
  802bf0:	75 dc                	jne    802bce <strcpy+0x19>
		/* do nothing */;
	return ret;
  802bf2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802bf6:	c9                   	leaveq 
  802bf7:	c3                   	retq   

0000000000802bf8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802bf8:	55                   	push   %rbp
  802bf9:	48 89 e5             	mov    %rsp,%rbp
  802bfc:	48 83 ec 20          	sub    $0x20,%rsp
  802c00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802c08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0c:	48 89 c7             	mov    %rax,%rdi
  802c0f:	48 b8 49 2b 80 00 00 	movabs $0x802b49,%rax
  802c16:	00 00 00 
  802c19:	ff d0                	callq  *%rax
  802c1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802c1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c21:	48 63 d0             	movslq %eax,%rdx
  802c24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c28:	48 01 c2             	add    %rax,%rdx
  802c2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c2f:	48 89 c6             	mov    %rax,%rsi
  802c32:	48 89 d7             	mov    %rdx,%rdi
  802c35:	48 b8 b5 2b 80 00 00 	movabs $0x802bb5,%rax
  802c3c:	00 00 00 
  802c3f:	ff d0                	callq  *%rax
	return dst;
  802c41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802c45:	c9                   	leaveq 
  802c46:	c3                   	retq   

0000000000802c47 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802c47:	55                   	push   %rbp
  802c48:	48 89 e5             	mov    %rsp,%rbp
  802c4b:	48 83 ec 28          	sub    $0x28,%rsp
  802c4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c57:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802c5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c5f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802c63:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802c6a:	00 
  802c6b:	eb 2a                	jmp    802c97 <strncpy+0x50>
		*dst++ = *src;
  802c6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c71:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c75:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c79:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c7d:	0f b6 12             	movzbl (%rdx),%edx
  802c80:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802c82:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c86:	0f b6 00             	movzbl (%rax),%eax
  802c89:	84 c0                	test   %al,%al
  802c8b:	74 05                	je     802c92 <strncpy+0x4b>
			src++;
  802c8d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802c92:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802c97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c9b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c9f:	72 cc                	jb     802c6d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802ca1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802ca5:	c9                   	leaveq 
  802ca6:	c3                   	retq   

0000000000802ca7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802ca7:	55                   	push   %rbp
  802ca8:	48 89 e5             	mov    %rsp,%rbp
  802cab:	48 83 ec 28          	sub    $0x28,%rsp
  802caf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cb3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cb7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802cbb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cbf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802cc3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802cc8:	74 3d                	je     802d07 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802cca:	eb 1d                	jmp    802ce9 <strlcpy+0x42>
			*dst++ = *src++;
  802ccc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802cd4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802cd8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cdc:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802ce0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802ce4:	0f b6 12             	movzbl (%rdx),%edx
  802ce7:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802ce9:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802cee:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802cf3:	74 0b                	je     802d00 <strlcpy+0x59>
  802cf5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf9:	0f b6 00             	movzbl (%rax),%eax
  802cfc:	84 c0                	test   %al,%al
  802cfe:	75 cc                	jne    802ccc <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d04:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802d07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d0f:	48 29 c2             	sub    %rax,%rdx
  802d12:	48 89 d0             	mov    %rdx,%rax
}
  802d15:	c9                   	leaveq 
  802d16:	c3                   	retq   

0000000000802d17 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802d17:	55                   	push   %rbp
  802d18:	48 89 e5             	mov    %rsp,%rbp
  802d1b:	48 83 ec 10          	sub    $0x10,%rsp
  802d1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d23:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802d27:	eb 0a                	jmp    802d33 <strcmp+0x1c>
		p++, q++;
  802d29:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d2e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802d33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d37:	0f b6 00             	movzbl (%rax),%eax
  802d3a:	84 c0                	test   %al,%al
  802d3c:	74 12                	je     802d50 <strcmp+0x39>
  802d3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d42:	0f b6 10             	movzbl (%rax),%edx
  802d45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d49:	0f b6 00             	movzbl (%rax),%eax
  802d4c:	38 c2                	cmp    %al,%dl
  802d4e:	74 d9                	je     802d29 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802d50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d54:	0f b6 00             	movzbl (%rax),%eax
  802d57:	0f b6 d0             	movzbl %al,%edx
  802d5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5e:	0f b6 00             	movzbl (%rax),%eax
  802d61:	0f b6 c0             	movzbl %al,%eax
  802d64:	29 c2                	sub    %eax,%edx
  802d66:	89 d0                	mov    %edx,%eax
}
  802d68:	c9                   	leaveq 
  802d69:	c3                   	retq   

0000000000802d6a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802d6a:	55                   	push   %rbp
  802d6b:	48 89 e5             	mov    %rsp,%rbp
  802d6e:	48 83 ec 18          	sub    $0x18,%rsp
  802d72:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d7a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802d7e:	eb 0f                	jmp    802d8f <strncmp+0x25>
		n--, p++, q++;
  802d80:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802d85:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d8a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802d8f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d94:	74 1d                	je     802db3 <strncmp+0x49>
  802d96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d9a:	0f b6 00             	movzbl (%rax),%eax
  802d9d:	84 c0                	test   %al,%al
  802d9f:	74 12                	je     802db3 <strncmp+0x49>
  802da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da5:	0f b6 10             	movzbl (%rax),%edx
  802da8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dac:	0f b6 00             	movzbl (%rax),%eax
  802daf:	38 c2                	cmp    %al,%dl
  802db1:	74 cd                	je     802d80 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802db3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802db8:	75 07                	jne    802dc1 <strncmp+0x57>
		return 0;
  802dba:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbf:	eb 18                	jmp    802dd9 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802dc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dc5:	0f b6 00             	movzbl (%rax),%eax
  802dc8:	0f b6 d0             	movzbl %al,%edx
  802dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcf:	0f b6 00             	movzbl (%rax),%eax
  802dd2:	0f b6 c0             	movzbl %al,%eax
  802dd5:	29 c2                	sub    %eax,%edx
  802dd7:	89 d0                	mov    %edx,%eax
}
  802dd9:	c9                   	leaveq 
  802dda:	c3                   	retq   

0000000000802ddb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802ddb:	55                   	push   %rbp
  802ddc:	48 89 e5             	mov    %rsp,%rbp
  802ddf:	48 83 ec 0c          	sub    $0xc,%rsp
  802de3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802de7:	89 f0                	mov    %esi,%eax
  802de9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802dec:	eb 17                	jmp    802e05 <strchr+0x2a>
		if (*s == c)
  802dee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df2:	0f b6 00             	movzbl (%rax),%eax
  802df5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802df8:	75 06                	jne    802e00 <strchr+0x25>
			return (char *) s;
  802dfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dfe:	eb 15                	jmp    802e15 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802e00:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e09:	0f b6 00             	movzbl (%rax),%eax
  802e0c:	84 c0                	test   %al,%al
  802e0e:	75 de                	jne    802dee <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e15:	c9                   	leaveq 
  802e16:	c3                   	retq   

0000000000802e17 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802e17:	55                   	push   %rbp
  802e18:	48 89 e5             	mov    %rsp,%rbp
  802e1b:	48 83 ec 0c          	sub    $0xc,%rsp
  802e1f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e23:	89 f0                	mov    %esi,%eax
  802e25:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802e28:	eb 13                	jmp    802e3d <strfind+0x26>
		if (*s == c)
  802e2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e2e:	0f b6 00             	movzbl (%rax),%eax
  802e31:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802e34:	75 02                	jne    802e38 <strfind+0x21>
			break;
  802e36:	eb 10                	jmp    802e48 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802e38:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e41:	0f b6 00             	movzbl (%rax),%eax
  802e44:	84 c0                	test   %al,%al
  802e46:	75 e2                	jne    802e2a <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802e48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e4c:	c9                   	leaveq 
  802e4d:	c3                   	retq   

0000000000802e4e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802e4e:	55                   	push   %rbp
  802e4f:	48 89 e5             	mov    %rsp,%rbp
  802e52:	48 83 ec 18          	sub    $0x18,%rsp
  802e56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e5a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802e5d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802e61:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802e66:	75 06                	jne    802e6e <memset+0x20>
		return v;
  802e68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e6c:	eb 69                	jmp    802ed7 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802e6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e72:	83 e0 03             	and    $0x3,%eax
  802e75:	48 85 c0             	test   %rax,%rax
  802e78:	75 48                	jne    802ec2 <memset+0x74>
  802e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7e:	83 e0 03             	and    $0x3,%eax
  802e81:	48 85 c0             	test   %rax,%rax
  802e84:	75 3c                	jne    802ec2 <memset+0x74>
		c &= 0xFF;
  802e86:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802e8d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e90:	c1 e0 18             	shl    $0x18,%eax
  802e93:	89 c2                	mov    %eax,%edx
  802e95:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e98:	c1 e0 10             	shl    $0x10,%eax
  802e9b:	09 c2                	or     %eax,%edx
  802e9d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ea0:	c1 e0 08             	shl    $0x8,%eax
  802ea3:	09 d0                	or     %edx,%eax
  802ea5:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802ea8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eac:	48 c1 e8 02          	shr    $0x2,%rax
  802eb0:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802eb3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802eb7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eba:	48 89 d7             	mov    %rdx,%rdi
  802ebd:	fc                   	cld    
  802ebe:	f3 ab                	rep stos %eax,%es:(%rdi)
  802ec0:	eb 11                	jmp    802ed3 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802ec2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ec6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ec9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ecd:	48 89 d7             	mov    %rdx,%rdi
  802ed0:	fc                   	cld    
  802ed1:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802ed3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802ed7:	c9                   	leaveq 
  802ed8:	c3                   	retq   

0000000000802ed9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802ed9:	55                   	push   %rbp
  802eda:	48 89 e5             	mov    %rsp,%rbp
  802edd:	48 83 ec 28          	sub    $0x28,%rsp
  802ee1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ee5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ee9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802eed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ef1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802ef5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ef9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802efd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f01:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f05:	0f 83 88 00 00 00    	jae    802f93 <memmove+0xba>
  802f0b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f0f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f13:	48 01 d0             	add    %rdx,%rax
  802f16:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802f1a:	76 77                	jbe    802f93 <memmove+0xba>
		s += n;
  802f1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f20:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802f24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f28:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f30:	83 e0 03             	and    $0x3,%eax
  802f33:	48 85 c0             	test   %rax,%rax
  802f36:	75 3b                	jne    802f73 <memmove+0x9a>
  802f38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3c:	83 e0 03             	and    $0x3,%eax
  802f3f:	48 85 c0             	test   %rax,%rax
  802f42:	75 2f                	jne    802f73 <memmove+0x9a>
  802f44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f48:	83 e0 03             	and    $0x3,%eax
  802f4b:	48 85 c0             	test   %rax,%rax
  802f4e:	75 23                	jne    802f73 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802f50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f54:	48 83 e8 04          	sub    $0x4,%rax
  802f58:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f5c:	48 83 ea 04          	sub    $0x4,%rdx
  802f60:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802f64:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802f68:	48 89 c7             	mov    %rax,%rdi
  802f6b:	48 89 d6             	mov    %rdx,%rsi
  802f6e:	fd                   	std    
  802f6f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802f71:	eb 1d                	jmp    802f90 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802f73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f77:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802f7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f7f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802f83:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f87:	48 89 d7             	mov    %rdx,%rdi
  802f8a:	48 89 c1             	mov    %rax,%rcx
  802f8d:	fd                   	std    
  802f8e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802f90:	fc                   	cld    
  802f91:	eb 57                	jmp    802fea <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f97:	83 e0 03             	and    $0x3,%eax
  802f9a:	48 85 c0             	test   %rax,%rax
  802f9d:	75 36                	jne    802fd5 <memmove+0xfc>
  802f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fa3:	83 e0 03             	and    $0x3,%eax
  802fa6:	48 85 c0             	test   %rax,%rax
  802fa9:	75 2a                	jne    802fd5 <memmove+0xfc>
  802fab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802faf:	83 e0 03             	and    $0x3,%eax
  802fb2:	48 85 c0             	test   %rax,%rax
  802fb5:	75 1e                	jne    802fd5 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802fb7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fbb:	48 c1 e8 02          	shr    $0x2,%rax
  802fbf:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802fc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fca:	48 89 c7             	mov    %rax,%rdi
  802fcd:	48 89 d6             	mov    %rdx,%rsi
  802fd0:	fc                   	cld    
  802fd1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802fd3:	eb 15                	jmp    802fea <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802fd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802fdd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802fe1:	48 89 c7             	mov    %rax,%rdi
  802fe4:	48 89 d6             	mov    %rdx,%rsi
  802fe7:	fc                   	cld    
  802fe8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  802fea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802fee:	c9                   	leaveq 
  802fef:	c3                   	retq   

0000000000802ff0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802ff0:	55                   	push   %rbp
  802ff1:	48 89 e5             	mov    %rsp,%rbp
  802ff4:	48 83 ec 18          	sub    $0x18,%rsp
  802ff8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ffc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803000:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803004:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803008:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80300c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803010:	48 89 ce             	mov    %rcx,%rsi
  803013:	48 89 c7             	mov    %rax,%rdi
  803016:	48 b8 d9 2e 80 00 00 	movabs $0x802ed9,%rax
  80301d:	00 00 00 
  803020:	ff d0                	callq  *%rax
}
  803022:	c9                   	leaveq 
  803023:	c3                   	retq   

0000000000803024 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803024:	55                   	push   %rbp
  803025:	48 89 e5             	mov    %rsp,%rbp
  803028:	48 83 ec 28          	sub    $0x28,%rsp
  80302c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803030:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803034:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  803038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80303c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803040:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803044:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  803048:	eb 36                	jmp    803080 <memcmp+0x5c>
		if (*s1 != *s2)
  80304a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80304e:	0f b6 10             	movzbl (%rax),%edx
  803051:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803055:	0f b6 00             	movzbl (%rax),%eax
  803058:	38 c2                	cmp    %al,%dl
  80305a:	74 1a                	je     803076 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80305c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803060:	0f b6 00             	movzbl (%rax),%eax
  803063:	0f b6 d0             	movzbl %al,%edx
  803066:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80306a:	0f b6 00             	movzbl (%rax),%eax
  80306d:	0f b6 c0             	movzbl %al,%eax
  803070:	29 c2                	sub    %eax,%edx
  803072:	89 d0                	mov    %edx,%eax
  803074:	eb 20                	jmp    803096 <memcmp+0x72>
		s1++, s2++;
  803076:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80307b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803080:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803084:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803088:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80308c:	48 85 c0             	test   %rax,%rax
  80308f:	75 b9                	jne    80304a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803091:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803096:	c9                   	leaveq 
  803097:	c3                   	retq   

0000000000803098 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803098:	55                   	push   %rbp
  803099:	48 89 e5             	mov    %rsp,%rbp
  80309c:	48 83 ec 28          	sub    $0x28,%rsp
  8030a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030a4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8030a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8030ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030b3:	48 01 d0             	add    %rdx,%rax
  8030b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8030ba:	eb 15                	jmp    8030d1 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8030bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c0:	0f b6 10             	movzbl (%rax),%edx
  8030c3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8030c6:	38 c2                	cmp    %al,%dl
  8030c8:	75 02                	jne    8030cc <memfind+0x34>
			break;
  8030ca:	eb 0f                	jmp    8030db <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8030cc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8030d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d5:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8030d9:	72 e1                	jb     8030bc <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8030db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8030df:	c9                   	leaveq 
  8030e0:	c3                   	retq   

00000000008030e1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8030e1:	55                   	push   %rbp
  8030e2:	48 89 e5             	mov    %rsp,%rbp
  8030e5:	48 83 ec 34          	sub    $0x34,%rsp
  8030e9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030ed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030f1:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8030f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8030fb:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803102:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803103:	eb 05                	jmp    80310a <strtol+0x29>
		s++;
  803105:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80310a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80310e:	0f b6 00             	movzbl (%rax),%eax
  803111:	3c 20                	cmp    $0x20,%al
  803113:	74 f0                	je     803105 <strtol+0x24>
  803115:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803119:	0f b6 00             	movzbl (%rax),%eax
  80311c:	3c 09                	cmp    $0x9,%al
  80311e:	74 e5                	je     803105 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803120:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803124:	0f b6 00             	movzbl (%rax),%eax
  803127:	3c 2b                	cmp    $0x2b,%al
  803129:	75 07                	jne    803132 <strtol+0x51>
		s++;
  80312b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803130:	eb 17                	jmp    803149 <strtol+0x68>
	else if (*s == '-')
  803132:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803136:	0f b6 00             	movzbl (%rax),%eax
  803139:	3c 2d                	cmp    $0x2d,%al
  80313b:	75 0c                	jne    803149 <strtol+0x68>
		s++, neg = 1;
  80313d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803142:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803149:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80314d:	74 06                	je     803155 <strtol+0x74>
  80314f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  803153:	75 28                	jne    80317d <strtol+0x9c>
  803155:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803159:	0f b6 00             	movzbl (%rax),%eax
  80315c:	3c 30                	cmp    $0x30,%al
  80315e:	75 1d                	jne    80317d <strtol+0x9c>
  803160:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803164:	48 83 c0 01          	add    $0x1,%rax
  803168:	0f b6 00             	movzbl (%rax),%eax
  80316b:	3c 78                	cmp    $0x78,%al
  80316d:	75 0e                	jne    80317d <strtol+0x9c>
		s += 2, base = 16;
  80316f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803174:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80317b:	eb 2c                	jmp    8031a9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80317d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803181:	75 19                	jne    80319c <strtol+0xbb>
  803183:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803187:	0f b6 00             	movzbl (%rax),%eax
  80318a:	3c 30                	cmp    $0x30,%al
  80318c:	75 0e                	jne    80319c <strtol+0xbb>
		s++, base = 8;
  80318e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803193:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80319a:	eb 0d                	jmp    8031a9 <strtol+0xc8>
	else if (base == 0)
  80319c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8031a0:	75 07                	jne    8031a9 <strtol+0xc8>
		base = 10;
  8031a2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8031a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031ad:	0f b6 00             	movzbl (%rax),%eax
  8031b0:	3c 2f                	cmp    $0x2f,%al
  8031b2:	7e 1d                	jle    8031d1 <strtol+0xf0>
  8031b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031b8:	0f b6 00             	movzbl (%rax),%eax
  8031bb:	3c 39                	cmp    $0x39,%al
  8031bd:	7f 12                	jg     8031d1 <strtol+0xf0>
			dig = *s - '0';
  8031bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031c3:	0f b6 00             	movzbl (%rax),%eax
  8031c6:	0f be c0             	movsbl %al,%eax
  8031c9:	83 e8 30             	sub    $0x30,%eax
  8031cc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031cf:	eb 4e                	jmp    80321f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8031d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d5:	0f b6 00             	movzbl (%rax),%eax
  8031d8:	3c 60                	cmp    $0x60,%al
  8031da:	7e 1d                	jle    8031f9 <strtol+0x118>
  8031dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e0:	0f b6 00             	movzbl (%rax),%eax
  8031e3:	3c 7a                	cmp    $0x7a,%al
  8031e5:	7f 12                	jg     8031f9 <strtol+0x118>
			dig = *s - 'a' + 10;
  8031e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031eb:	0f b6 00             	movzbl (%rax),%eax
  8031ee:	0f be c0             	movsbl %al,%eax
  8031f1:	83 e8 57             	sub    $0x57,%eax
  8031f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031f7:	eb 26                	jmp    80321f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8031f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031fd:	0f b6 00             	movzbl (%rax),%eax
  803200:	3c 40                	cmp    $0x40,%al
  803202:	7e 48                	jle    80324c <strtol+0x16b>
  803204:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803208:	0f b6 00             	movzbl (%rax),%eax
  80320b:	3c 5a                	cmp    $0x5a,%al
  80320d:	7f 3d                	jg     80324c <strtol+0x16b>
			dig = *s - 'A' + 10;
  80320f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803213:	0f b6 00             	movzbl (%rax),%eax
  803216:	0f be c0             	movsbl %al,%eax
  803219:	83 e8 37             	sub    $0x37,%eax
  80321c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80321f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803222:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803225:	7c 02                	jl     803229 <strtol+0x148>
			break;
  803227:	eb 23                	jmp    80324c <strtol+0x16b>
		s++, val = (val * base) + dig;
  803229:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80322e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803231:	48 98                	cltq   
  803233:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803238:	48 89 c2             	mov    %rax,%rdx
  80323b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80323e:	48 98                	cltq   
  803240:	48 01 d0             	add    %rdx,%rax
  803243:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803247:	e9 5d ff ff ff       	jmpq   8031a9 <strtol+0xc8>

	if (endptr)
  80324c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803251:	74 0b                	je     80325e <strtol+0x17d>
		*endptr = (char *) s;
  803253:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803257:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80325b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80325e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803262:	74 09                	je     80326d <strtol+0x18c>
  803264:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803268:	48 f7 d8             	neg    %rax
  80326b:	eb 04                	jmp    803271 <strtol+0x190>
  80326d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803271:	c9                   	leaveq 
  803272:	c3                   	retq   

0000000000803273 <strstr>:

char * strstr(const char *in, const char *str)
{
  803273:	55                   	push   %rbp
  803274:	48 89 e5             	mov    %rsp,%rbp
  803277:	48 83 ec 30          	sub    $0x30,%rsp
  80327b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80327f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  803283:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803287:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80328b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80328f:	0f b6 00             	movzbl (%rax),%eax
  803292:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803295:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803299:	75 06                	jne    8032a1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80329b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80329f:	eb 6b                	jmp    80330c <strstr+0x99>

	len = strlen(str);
  8032a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032a5:	48 89 c7             	mov    %rax,%rdi
  8032a8:	48 b8 49 2b 80 00 00 	movabs $0x802b49,%rax
  8032af:	00 00 00 
  8032b2:	ff d0                	callq  *%rax
  8032b4:	48 98                	cltq   
  8032b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8032ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032be:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8032c2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8032c6:	0f b6 00             	movzbl (%rax),%eax
  8032c9:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8032cc:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8032d0:	75 07                	jne    8032d9 <strstr+0x66>
				return (char *) 0;
  8032d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d7:	eb 33                	jmp    80330c <strstr+0x99>
		} while (sc != c);
  8032d9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8032dd:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8032e0:	75 d8                	jne    8032ba <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8032e2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032e6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8032ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032ee:	48 89 ce             	mov    %rcx,%rsi
  8032f1:	48 89 c7             	mov    %rax,%rdi
  8032f4:	48 b8 6a 2d 80 00 00 	movabs $0x802d6a,%rax
  8032fb:	00 00 00 
  8032fe:	ff d0                	callq  *%rax
  803300:	85 c0                	test   %eax,%eax
  803302:	75 b6                	jne    8032ba <strstr+0x47>

	return (char *) (in - 1);
  803304:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803308:	48 83 e8 01          	sub    $0x1,%rax
}
  80330c:	c9                   	leaveq 
  80330d:	c3                   	retq   

000000000080330e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80330e:	55                   	push   %rbp
  80330f:	48 89 e5             	mov    %rsp,%rbp
  803312:	48 83 ec 10          	sub    $0x10,%rsp
  803316:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80331a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803321:	00 00 00 
  803324:	48 8b 00             	mov    (%rax),%rax
  803327:	48 85 c0             	test   %rax,%rax
  80332a:	75 64                	jne    803390 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  80332c:	ba 07 00 00 00       	mov    $0x7,%edx
  803331:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803336:	bf 00 00 00 00       	mov    $0x0,%edi
  80333b:	48 b8 03 03 80 00 00 	movabs $0x800303,%rax
  803342:	00 00 00 
  803345:	ff d0                	callq  *%rax
  803347:	85 c0                	test   %eax,%eax
  803349:	74 2a                	je     803375 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  80334b:	48 ba 68 3c 80 00 00 	movabs $0x803c68,%rdx
  803352:	00 00 00 
  803355:	be 22 00 00 00       	mov    $0x22,%esi
  80335a:	48 bf 90 3c 80 00 00 	movabs $0x803c90,%rdi
  803361:	00 00 00 
  803364:	b8 00 00 00 00       	mov    $0x0,%eax
  803369:	48 b9 c7 1d 80 00 00 	movabs $0x801dc7,%rcx
  803370:	00 00 00 
  803373:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803375:	48 be 70 05 80 00 00 	movabs $0x800570,%rsi
  80337c:	00 00 00 
  80337f:	bf 00 00 00 00       	mov    $0x0,%edi
  803384:	48 b8 8d 04 80 00 00 	movabs $0x80048d,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803390:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803397:	00 00 00 
  80339a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80339e:	48 89 10             	mov    %rdx,(%rax)
}
  8033a1:	c9                   	leaveq 
  8033a2:	c3                   	retq   

00000000008033a3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8033a3:	55                   	push   %rbp
  8033a4:	48 89 e5             	mov    %rsp,%rbp
  8033a7:	48 83 ec 30          	sub    $0x30,%rsp
  8033ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  8033b7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033bc:	74 18                	je     8033d6 <ipc_recv+0x33>
  8033be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033c2:	48 89 c7             	mov    %rax,%rdi
  8033c5:	48 b8 2c 05 80 00 00 	movabs $0x80052c,%rax
  8033cc:	00 00 00 
  8033cf:	ff d0                	callq  *%rax
  8033d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033d4:	eb 19                	jmp    8033ef <ipc_recv+0x4c>
  8033d6:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8033dd:	00 00 00 
  8033e0:	48 b8 2c 05 80 00 00 	movabs $0x80052c,%rax
  8033e7:	00 00 00 
  8033ea:	ff d0                	callq  *%rax
  8033ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8033ef:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8033f4:	74 26                	je     80341c <ipc_recv+0x79>
  8033f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033fa:	75 15                	jne    803411 <ipc_recv+0x6e>
  8033fc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803403:	00 00 00 
  803406:	48 8b 00             	mov    (%rax),%rax
  803409:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  80340f:	eb 05                	jmp    803416 <ipc_recv+0x73>
  803411:	b8 00 00 00 00       	mov    $0x0,%eax
  803416:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80341a:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  80341c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803421:	74 26                	je     803449 <ipc_recv+0xa6>
  803423:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803427:	75 15                	jne    80343e <ipc_recv+0x9b>
  803429:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803430:	00 00 00 
  803433:	48 8b 00             	mov    (%rax),%rax
  803436:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80343c:	eb 05                	jmp    803443 <ipc_recv+0xa0>
  80343e:	b8 00 00 00 00       	mov    $0x0,%eax
  803443:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803447:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803449:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80344d:	75 15                	jne    803464 <ipc_recv+0xc1>
  80344f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803456:	00 00 00 
  803459:	48 8b 00             	mov    (%rax),%rax
  80345c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803462:	eb 03                	jmp    803467 <ipc_recv+0xc4>
  803464:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803467:	c9                   	leaveq 
  803468:	c3                   	retq   

0000000000803469 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803469:	55                   	push   %rbp
  80346a:	48 89 e5             	mov    %rsp,%rbp
  80346d:	48 83 ec 30          	sub    $0x30,%rsp
  803471:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803474:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803477:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80347b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  80347e:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803485:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80348a:	75 10                	jne    80349c <ipc_send+0x33>
  80348c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803493:	00 00 00 
  803496:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  80349a:	eb 62                	jmp    8034fe <ipc_send+0x95>
  80349c:	eb 60                	jmp    8034fe <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  80349e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8034a2:	74 30                	je     8034d4 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  8034a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a7:	89 c1                	mov    %eax,%ecx
  8034a9:	48 ba 9e 3c 80 00 00 	movabs $0x803c9e,%rdx
  8034b0:	00 00 00 
  8034b3:	be 33 00 00 00       	mov    $0x33,%esi
  8034b8:	48 bf ba 3c 80 00 00 	movabs $0x803cba,%rdi
  8034bf:	00 00 00 
  8034c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c7:	49 b8 c7 1d 80 00 00 	movabs $0x801dc7,%r8
  8034ce:	00 00 00 
  8034d1:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  8034d4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8034d7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8034da:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8034de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034e1:	89 c7                	mov    %eax,%edi
  8034e3:	48 b8 d7 04 80 00 00 	movabs $0x8004d7,%rax
  8034ea:	00 00 00 
  8034ed:	ff d0                	callq  *%rax
  8034ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8034f2:	48 b8 c5 02 80 00 00 	movabs $0x8002c5,%rax
  8034f9:	00 00 00 
  8034fc:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8034fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803502:	75 9a                	jne    80349e <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803504:	c9                   	leaveq 
  803505:	c3                   	retq   

0000000000803506 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803506:	55                   	push   %rbp
  803507:	48 89 e5             	mov    %rsp,%rbp
  80350a:	48 83 ec 14          	sub    $0x14,%rsp
  80350e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803511:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803518:	eb 5e                	jmp    803578 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80351a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803521:	00 00 00 
  803524:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803527:	48 63 d0             	movslq %eax,%rdx
  80352a:	48 89 d0             	mov    %rdx,%rax
  80352d:	48 c1 e0 03          	shl    $0x3,%rax
  803531:	48 01 d0             	add    %rdx,%rax
  803534:	48 c1 e0 05          	shl    $0x5,%rax
  803538:	48 01 c8             	add    %rcx,%rax
  80353b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803541:	8b 00                	mov    (%rax),%eax
  803543:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803546:	75 2c                	jne    803574 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803548:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80354f:	00 00 00 
  803552:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803555:	48 63 d0             	movslq %eax,%rdx
  803558:	48 89 d0             	mov    %rdx,%rax
  80355b:	48 c1 e0 03          	shl    $0x3,%rax
  80355f:	48 01 d0             	add    %rdx,%rax
  803562:	48 c1 e0 05          	shl    $0x5,%rax
  803566:	48 01 c8             	add    %rcx,%rax
  803569:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80356f:	8b 40 08             	mov    0x8(%rax),%eax
  803572:	eb 12                	jmp    803586 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803574:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803578:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80357f:	7e 99                	jle    80351a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803586:	c9                   	leaveq 
  803587:	c3                   	retq   

0000000000803588 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803588:	55                   	push   %rbp
  803589:	48 89 e5             	mov    %rsp,%rbp
  80358c:	48 83 ec 18          	sub    $0x18,%rsp
  803590:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803598:	48 c1 e8 15          	shr    $0x15,%rax
  80359c:	48 89 c2             	mov    %rax,%rdx
  80359f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8035a6:	01 00 00 
  8035a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035ad:	83 e0 01             	and    $0x1,%eax
  8035b0:	48 85 c0             	test   %rax,%rax
  8035b3:	75 07                	jne    8035bc <pageref+0x34>
		return 0;
  8035b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ba:	eb 53                	jmp    80360f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8035bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c0:	48 c1 e8 0c          	shr    $0xc,%rax
  8035c4:	48 89 c2             	mov    %rax,%rdx
  8035c7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035ce:	01 00 00 
  8035d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8035d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035dd:	83 e0 01             	and    $0x1,%eax
  8035e0:	48 85 c0             	test   %rax,%rax
  8035e3:	75 07                	jne    8035ec <pageref+0x64>
		return 0;
  8035e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ea:	eb 23                	jmp    80360f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8035ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f0:	48 c1 e8 0c          	shr    $0xc,%rax
  8035f4:	48 89 c2             	mov    %rax,%rdx
  8035f7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8035fe:	00 00 00 
  803601:	48 c1 e2 04          	shl    $0x4,%rdx
  803605:	48 01 d0             	add    %rdx,%rax
  803608:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80360c:	0f b7 c0             	movzwl %ax,%eax
}
  80360f:	c9                   	leaveq 
  803610:	c3                   	retq   
