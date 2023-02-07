
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
  800052:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800059:	00 00 00 
  80005c:	48 ba 00 35 80 00 00 	movabs $0x803500,%rdx
  800063:	00 00 00 
  800066:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800069:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
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
  80007b:	48 83 ec 10          	sub    $0x10,%rsp
  80007f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800082:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800086:	48 b8 84 02 80 00 00 	movabs $0x800284,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	48 98                	cltq   
  800094:	25 ff 03 00 00       	and    $0x3ff,%eax
  800099:	48 89 c2             	mov    %rax,%rdx
  80009c:	48 89 d0             	mov    %rdx,%rax
  80009f:	48 c1 e0 03          	shl    $0x3,%rax
  8000a3:	48 01 d0             	add    %rdx,%rax
  8000a6:	48 c1 e0 05          	shl    $0x5,%rax
  8000aa:	48 89 c2             	mov    %rax,%rdx
  8000ad:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000b4:	00 00 00 
  8000b7:	48 01 c2             	add    %rax,%rdx
  8000ba:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000c1:	00 00 00 
  8000c4:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	7e 14                	jle    8000e1 <libmain+0x6a>
		binaryname = argv[0];
  8000cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000d1:	48 8b 10             	mov    (%rax),%rdx
  8000d4:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8000db:	00 00 00 
  8000de:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e8:	48 89 d6             	mov    %rdx,%rsi
  8000eb:	89 c7                	mov    %eax,%edi
  8000ed:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f4:	00 00 00 
  8000f7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f9:	48 b8 07 01 80 00 00 	movabs $0x800107,%rax
  800100:	00 00 00 
  800103:	ff d0                	callq  *%rax
}
  800105:	c9                   	leaveq 
  800106:	c3                   	retq   

0000000000800107 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800107:	55                   	push   %rbp
  800108:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80010b:	48 b8 ae 08 80 00 00 	movabs $0x8008ae,%rax
  800112:	00 00 00 
  800115:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800117:	bf 00 00 00 00       	mov    $0x0,%edi
  80011c:	48 b8 40 02 80 00 00 	movabs $0x800240,%rax
  800123:	00 00 00 
  800126:	ff d0                	callq  *%rax
}
  800128:	5d                   	pop    %rbp
  800129:	c3                   	retq   

000000000080012a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80012a:	55                   	push   %rbp
  80012b:	48 89 e5             	mov    %rsp,%rbp
  80012e:	53                   	push   %rbx
  80012f:	48 83 ec 48          	sub    $0x48,%rsp
  800133:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800136:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800139:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80013d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800141:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800145:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  800149:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80014c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800150:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800154:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800158:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80015c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800160:	4c 89 c3             	mov    %r8,%rbx
  800163:	cd 30                	int    $0x30
  800165:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  800169:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80016d:	74 3e                	je     8001ad <syscall+0x83>
  80016f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800174:	7e 37                	jle    8001ad <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800176:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80017a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80017d:	49 89 d0             	mov    %rdx,%r8
  800180:	89 c1                	mov    %eax,%ecx
  800182:	48 ba 0f 35 80 00 00 	movabs $0x80350f,%rdx
  800189:	00 00 00 
  80018c:	be 4a 00 00 00       	mov    $0x4a,%esi
  800191:	48 bf 2c 35 80 00 00 	movabs $0x80352c,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	49 b9 3a 1d 80 00 00 	movabs $0x801d3a,%r9
  8001a7:	00 00 00 
  8001aa:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8001ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001b1:	48 83 c4 48          	add    $0x48,%rsp
  8001b5:	5b                   	pop    %rbx
  8001b6:	5d                   	pop    %rbp
  8001b7:	c3                   	retq   

00000000008001b8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 20          	sub    $0x20,%rsp
  8001c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001d7:	00 
  8001d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001e4:	48 89 d1             	mov    %rdx,%rcx
  8001e7:	48 89 c2             	mov    %rax,%rdx
  8001ea:	be 00 00 00 00       	mov    $0x0,%esi
  8001ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f4:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
}
  800200:	c9                   	leaveq 
  800201:	c3                   	retq   

0000000000800202 <sys_cgetc>:

int
sys_cgetc(void)
{
  800202:	55                   	push   %rbp
  800203:	48 89 e5             	mov    %rsp,%rbp
  800206:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80020a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800211:	00 
  800212:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800218:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80021e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800223:	ba 00 00 00 00       	mov    $0x0,%edx
  800228:	be 00 00 00 00       	mov    $0x0,%esi
  80022d:	bf 01 00 00 00       	mov    $0x1,%edi
  800232:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800239:	00 00 00 
  80023c:	ff d0                	callq  *%rax
}
  80023e:	c9                   	leaveq 
  80023f:	c3                   	retq   

0000000000800240 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800240:	55                   	push   %rbp
  800241:	48 89 e5             	mov    %rsp,%rbp
  800244:	48 83 ec 10          	sub    $0x10,%rsp
  800248:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80024b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80024e:	48 98                	cltq   
  800250:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800257:	00 
  800258:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80025e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800264:	b9 00 00 00 00       	mov    $0x0,%ecx
  800269:	48 89 c2             	mov    %rax,%rdx
  80026c:	be 01 00 00 00       	mov    $0x1,%esi
  800271:	bf 03 00 00 00       	mov    $0x3,%edi
  800276:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  80027d:	00 00 00 
  800280:	ff d0                	callq  *%rax
}
  800282:	c9                   	leaveq 
  800283:	c3                   	retq   

0000000000800284 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800284:	55                   	push   %rbp
  800285:	48 89 e5             	mov    %rsp,%rbp
  800288:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80028c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800293:	00 
  800294:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80029a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8002aa:	be 00 00 00 00       	mov    $0x0,%esi
  8002af:	bf 02 00 00 00       	mov    $0x2,%edi
  8002b4:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
}
  8002c0:	c9                   	leaveq 
  8002c1:	c3                   	retq   

00000000008002c2 <sys_yield>:

void
sys_yield(void)
{
  8002c2:	55                   	push   %rbp
  8002c3:	48 89 e5             	mov    %rsp,%rbp
  8002c6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002ca:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002d1:	00 
  8002d2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002d8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002de:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e8:	be 00 00 00 00       	mov    $0x0,%esi
  8002ed:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002f2:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8002f9:	00 00 00 
  8002fc:	ff d0                	callq  *%rax
}
  8002fe:	c9                   	leaveq 
  8002ff:	c3                   	retq   

0000000000800300 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800300:	55                   	push   %rbp
  800301:	48 89 e5             	mov    %rsp,%rbp
  800304:	48 83 ec 20          	sub    $0x20,%rsp
  800308:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80030b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80030f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800312:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800315:	48 63 c8             	movslq %eax,%rcx
  800318:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80031c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80031f:	48 98                	cltq   
  800321:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800328:	00 
  800329:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80032f:	49 89 c8             	mov    %rcx,%r8
  800332:	48 89 d1             	mov    %rdx,%rcx
  800335:	48 89 c2             	mov    %rax,%rdx
  800338:	be 01 00 00 00       	mov    $0x1,%esi
  80033d:	bf 04 00 00 00       	mov    $0x4,%edi
  800342:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800349:	00 00 00 
  80034c:	ff d0                	callq  *%rax
}
  80034e:	c9                   	leaveq 
  80034f:	c3                   	retq   

0000000000800350 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800350:	55                   	push   %rbp
  800351:	48 89 e5             	mov    %rsp,%rbp
  800354:	48 83 ec 30          	sub    $0x30,%rsp
  800358:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80035b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80035f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800362:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800366:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80036a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036d:	48 63 c8             	movslq %eax,%rcx
  800370:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800374:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800377:	48 63 f0             	movslq %eax,%rsi
  80037a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80037e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800381:	48 98                	cltq   
  800383:	48 89 0c 24          	mov    %rcx,(%rsp)
  800387:	49 89 f9             	mov    %rdi,%r9
  80038a:	49 89 f0             	mov    %rsi,%r8
  80038d:	48 89 d1             	mov    %rdx,%rcx
  800390:	48 89 c2             	mov    %rax,%rdx
  800393:	be 01 00 00 00       	mov    $0x1,%esi
  800398:	bf 05 00 00 00       	mov    $0x5,%edi
  80039d:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	callq  *%rax
}
  8003a9:	c9                   	leaveq 
  8003aa:	c3                   	retq   

00000000008003ab <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003ab:	55                   	push   %rbp
  8003ac:	48 89 e5             	mov    %rsp,%rbp
  8003af:	48 83 ec 20          	sub    $0x20,%rsp
  8003b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c1:	48 98                	cltq   
  8003c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003ca:	00 
  8003cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d7:	48 89 d1             	mov    %rdx,%rcx
  8003da:	48 89 c2             	mov    %rax,%rdx
  8003dd:	be 01 00 00 00       	mov    $0x1,%esi
  8003e2:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e7:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8003ee:	00 00 00 
  8003f1:	ff d0                	callq  *%rax
}
  8003f3:	c9                   	leaveq 
  8003f4:	c3                   	retq   

00000000008003f5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f5:	55                   	push   %rbp
  8003f6:	48 89 e5             	mov    %rsp,%rbp
  8003f9:	48 83 ec 10          	sub    $0x10,%rsp
  8003fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800400:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800403:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800406:	48 63 d0             	movslq %eax,%rdx
  800409:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040c:	48 98                	cltq   
  80040e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800415:	00 
  800416:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80041c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800422:	48 89 d1             	mov    %rdx,%rcx
  800425:	48 89 c2             	mov    %rax,%rdx
  800428:	be 01 00 00 00       	mov    $0x1,%esi
  80042d:	bf 08 00 00 00       	mov    $0x8,%edi
  800432:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800439:	00 00 00 
  80043c:	ff d0                	callq  *%rax
}
  80043e:	c9                   	leaveq 
  80043f:	c3                   	retq   

0000000000800440 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800440:	55                   	push   %rbp
  800441:	48 89 e5             	mov    %rsp,%rbp
  800444:	48 83 ec 20          	sub    $0x20,%rsp
  800448:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80044b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80044f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800456:	48 98                	cltq   
  800458:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80045f:	00 
  800460:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800466:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80046c:	48 89 d1             	mov    %rdx,%rcx
  80046f:	48 89 c2             	mov    %rax,%rdx
  800472:	be 01 00 00 00       	mov    $0x1,%esi
  800477:	bf 09 00 00 00       	mov    $0x9,%edi
  80047c:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800483:	00 00 00 
  800486:	ff d0                	callq  *%rax
}
  800488:	c9                   	leaveq 
  800489:	c3                   	retq   

000000000080048a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80048a:	55                   	push   %rbp
  80048b:	48 89 e5             	mov    %rsp,%rbp
  80048e:	48 83 ec 20          	sub    $0x20,%rsp
  800492:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800495:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800499:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a0:	48 98                	cltq   
  8004a2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a9:	00 
  8004aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004b6:	48 89 d1             	mov    %rdx,%rcx
  8004b9:	48 89 c2             	mov    %rax,%rdx
  8004bc:	be 01 00 00 00       	mov    $0x1,%esi
  8004c1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004c6:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8004cd:	00 00 00 
  8004d0:	ff d0                	callq  *%rax
}
  8004d2:	c9                   	leaveq 
  8004d3:	c3                   	retq   

00000000008004d4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004d4:	55                   	push   %rbp
  8004d5:	48 89 e5             	mov    %rsp,%rbp
  8004d8:	48 83 ec 20          	sub    $0x20,%rsp
  8004dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004e3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004e7:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004ed:	48 63 f0             	movslq %eax,%rsi
  8004f0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004f7:	48 98                	cltq   
  8004f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800504:	00 
  800505:	49 89 f1             	mov    %rsi,%r9
  800508:	49 89 c8             	mov    %rcx,%r8
  80050b:	48 89 d1             	mov    %rdx,%rcx
  80050e:	48 89 c2             	mov    %rax,%rdx
  800511:	be 00 00 00 00       	mov    $0x0,%esi
  800516:	bf 0c 00 00 00       	mov    $0xc,%edi
  80051b:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800522:	00 00 00 
  800525:	ff d0                	callq  *%rax
}
  800527:	c9                   	leaveq 
  800528:	c3                   	retq   

0000000000800529 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800529:	55                   	push   %rbp
  80052a:	48 89 e5             	mov    %rsp,%rbp
  80052d:	48 83 ec 10          	sub    $0x10,%rsp
  800531:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800535:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800539:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800540:	00 
  800541:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800547:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80054d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800552:	48 89 c2             	mov    %rax,%rdx
  800555:	be 01 00 00 00       	mov    $0x1,%esi
  80055a:	bf 0d 00 00 00       	mov    $0xd,%edi
  80055f:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  800566:	00 00 00 
  800569:	ff d0                	callq  *%rax
}
  80056b:	c9                   	leaveq 
  80056c:	c3                   	retq   

000000000080056d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80056d:	55                   	push   %rbp
  80056e:	48 89 e5             	mov    %rsp,%rbp
  800571:	48 83 ec 08          	sub    $0x8,%rsp
  800575:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800579:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80057d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800584:	ff ff ff 
  800587:	48 01 d0             	add    %rdx,%rax
  80058a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80058e:	c9                   	leaveq 
  80058f:	c3                   	retq   

0000000000800590 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800590:	55                   	push   %rbp
  800591:	48 89 e5             	mov    %rsp,%rbp
  800594:	48 83 ec 08          	sub    $0x8,%rsp
  800598:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80059c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005a0:	48 89 c7             	mov    %rax,%rdi
  8005a3:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  8005aa:	00 00 00 
  8005ad:	ff d0                	callq  *%rax
  8005af:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8005b5:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8005b9:	c9                   	leaveq 
  8005ba:	c3                   	retq   

00000000008005bb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005bb:	55                   	push   %rbp
  8005bc:	48 89 e5             	mov    %rsp,%rbp
  8005bf:	48 83 ec 18          	sub    $0x18,%rsp
  8005c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8005c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8005ce:	eb 6b                	jmp    80063b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8005d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005d3:	48 98                	cltq   
  8005d5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8005db:	48 c1 e0 0c          	shl    $0xc,%rax
  8005df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8005e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e7:	48 c1 e8 15          	shr    $0x15,%rax
  8005eb:	48 89 c2             	mov    %rax,%rdx
  8005ee:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8005f5:	01 00 00 
  8005f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005fc:	83 e0 01             	and    $0x1,%eax
  8005ff:	48 85 c0             	test   %rax,%rax
  800602:	74 21                	je     800625 <fd_alloc+0x6a>
  800604:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800608:	48 c1 e8 0c          	shr    $0xc,%rax
  80060c:	48 89 c2             	mov    %rax,%rdx
  80060f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800616:	01 00 00 
  800619:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80061d:	83 e0 01             	and    $0x1,%eax
  800620:	48 85 c0             	test   %rax,%rax
  800623:	75 12                	jne    800637 <fd_alloc+0x7c>
			*fd_store = fd;
  800625:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800629:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80062d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800630:	b8 00 00 00 00       	mov    $0x0,%eax
  800635:	eb 1a                	jmp    800651 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800637:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80063b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80063f:	7e 8f                	jle    8005d0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800645:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80064c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800651:	c9                   	leaveq 
  800652:	c3                   	retq   

0000000000800653 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800653:	55                   	push   %rbp
  800654:	48 89 e5             	mov    %rsp,%rbp
  800657:	48 83 ec 20          	sub    $0x20,%rsp
  80065b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80065e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800662:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800666:	78 06                	js     80066e <fd_lookup+0x1b>
  800668:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80066c:	7e 07                	jle    800675 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80066e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800673:	eb 6c                	jmp    8006e1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  800675:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800678:	48 98                	cltq   
  80067a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800680:	48 c1 e0 0c          	shl    $0xc,%rax
  800684:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800688:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80068c:	48 c1 e8 15          	shr    $0x15,%rax
  800690:	48 89 c2             	mov    %rax,%rdx
  800693:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80069a:	01 00 00 
  80069d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006a1:	83 e0 01             	and    $0x1,%eax
  8006a4:	48 85 c0             	test   %rax,%rax
  8006a7:	74 21                	je     8006ca <fd_lookup+0x77>
  8006a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006ad:	48 c1 e8 0c          	shr    $0xc,%rax
  8006b1:	48 89 c2             	mov    %rax,%rdx
  8006b4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8006bb:	01 00 00 
  8006be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8006c2:	83 e0 01             	and    $0x1,%eax
  8006c5:	48 85 c0             	test   %rax,%rax
  8006c8:	75 07                	jne    8006d1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8006ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006cf:	eb 10                	jmp    8006e1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8006d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006d5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8006d9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8006dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006e1:	c9                   	leaveq 
  8006e2:	c3                   	retq   

00000000008006e3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8006e3:	55                   	push   %rbp
  8006e4:	48 89 e5             	mov    %rsp,%rbp
  8006e7:	48 83 ec 30          	sub    $0x30,%rsp
  8006eb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8006ef:	89 f0                	mov    %esi,%eax
  8006f1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8006f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006f8:	48 89 c7             	mov    %rax,%rdi
  8006fb:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  800702:	00 00 00 
  800705:	ff d0                	callq  *%rax
  800707:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80070b:	48 89 d6             	mov    %rdx,%rsi
  80070e:	89 c7                	mov    %eax,%edi
  800710:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800717:	00 00 00 
  80071a:	ff d0                	callq  *%rax
  80071c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80071f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800723:	78 0a                	js     80072f <fd_close+0x4c>
	    || fd != fd2)
  800725:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800729:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80072d:	74 12                	je     800741 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80072f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  800733:	74 05                	je     80073a <fd_close+0x57>
  800735:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800738:	eb 05                	jmp    80073f <fd_close+0x5c>
  80073a:	b8 00 00 00 00       	mov    $0x0,%eax
  80073f:	eb 69                	jmp    8007aa <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800741:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800745:	8b 00                	mov    (%rax),%eax
  800747:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80074b:	48 89 d6             	mov    %rdx,%rsi
  80074e:	89 c7                	mov    %eax,%edi
  800750:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800757:	00 00 00 
  80075a:	ff d0                	callq  *%rax
  80075c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80075f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800763:	78 2a                	js     80078f <fd_close+0xac>
		if (dev->dev_close)
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	48 8b 40 20          	mov    0x20(%rax),%rax
  80076d:	48 85 c0             	test   %rax,%rax
  800770:	74 16                	je     800788 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  800772:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800776:	48 8b 40 20          	mov    0x20(%rax),%rax
  80077a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80077e:	48 89 d7             	mov    %rdx,%rdi
  800781:	ff d0                	callq  *%rax
  800783:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800786:	eb 07                	jmp    80078f <fd_close+0xac>
		else
			r = 0;
  800788:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80078f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800793:	48 89 c6             	mov    %rax,%rsi
  800796:	bf 00 00 00 00       	mov    $0x0,%edi
  80079b:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  8007a2:	00 00 00 
  8007a5:	ff d0                	callq  *%rax
	return r;
  8007a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8007aa:	c9                   	leaveq 
  8007ab:	c3                   	retq   

00000000008007ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8007ac:	55                   	push   %rbp
  8007ad:	48 89 e5             	mov    %rsp,%rbp
  8007b0:	48 83 ec 20          	sub    $0x20,%rsp
  8007b4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8007b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8007bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8007c2:	eb 41                	jmp    800805 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8007c4:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007cb:	00 00 00 
  8007ce:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007d1:	48 63 d2             	movslq %edx,%rdx
  8007d4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007d8:	8b 00                	mov    (%rax),%eax
  8007da:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8007dd:	75 22                	jne    800801 <dev_lookup+0x55>
			*dev = devtab[i];
  8007df:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8007e6:	00 00 00 
  8007e9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8007ec:	48 63 d2             	movslq %edx,%rdx
  8007ef:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8007f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8007f7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8007fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ff:	eb 60                	jmp    800861 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800801:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800805:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80080c:	00 00 00 
  80080f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800812:	48 63 d2             	movslq %edx,%rdx
  800815:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800819:	48 85 c0             	test   %rax,%rax
  80081c:	75 a6                	jne    8007c4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80081e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800825:	00 00 00 
  800828:	48 8b 00             	mov    (%rax),%rax
  80082b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800831:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800834:	89 c6                	mov    %eax,%esi
  800836:	48 bf 40 35 80 00 00 	movabs $0x803540,%rdi
  80083d:	00 00 00 
  800840:	b8 00 00 00 00       	mov    $0x0,%eax
  800845:	48 b9 73 1f 80 00 00 	movabs $0x801f73,%rcx
  80084c:	00 00 00 
  80084f:	ff d1                	callq  *%rcx
	*dev = 0;
  800851:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800855:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80085c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800861:	c9                   	leaveq 
  800862:	c3                   	retq   

0000000000800863 <close>:

int
close(int fdnum)
{
  800863:	55                   	push   %rbp
  800864:	48 89 e5             	mov    %rsp,%rbp
  800867:	48 83 ec 20          	sub    $0x20,%rsp
  80086b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80086e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800872:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800875:	48 89 d6             	mov    %rdx,%rsi
  800878:	89 c7                	mov    %eax,%edi
  80087a:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800881:	00 00 00 
  800884:	ff d0                	callq  *%rax
  800886:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800889:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80088d:	79 05                	jns    800894 <close+0x31>
		return r;
  80088f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800892:	eb 18                	jmp    8008ac <close+0x49>
	else
		return fd_close(fd, 1);
  800894:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800898:	be 01 00 00 00       	mov    $0x1,%esi
  80089d:	48 89 c7             	mov    %rax,%rdi
  8008a0:	48 b8 e3 06 80 00 00 	movabs $0x8006e3,%rax
  8008a7:	00 00 00 
  8008aa:	ff d0                	callq  *%rax
}
  8008ac:	c9                   	leaveq 
  8008ad:	c3                   	retq   

00000000008008ae <close_all>:

void
close_all(void)
{
  8008ae:	55                   	push   %rbp
  8008af:	48 89 e5             	mov    %rsp,%rbp
  8008b2:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8008b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8008bd:	eb 15                	jmp    8008d4 <close_all+0x26>
		close(i);
  8008bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008c2:	89 c7                	mov    %eax,%edi
  8008c4:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  8008cb:	00 00 00 
  8008ce:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8008d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008d4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008d8:	7e e5                	jle    8008bf <close_all+0x11>
		close(i);
}
  8008da:	c9                   	leaveq 
  8008db:	c3                   	retq   

00000000008008dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8008dc:	55                   	push   %rbp
  8008dd:	48 89 e5             	mov    %rsp,%rbp
  8008e0:	48 83 ec 40          	sub    $0x40,%rsp
  8008e4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8008e7:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8008ea:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8008ee:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008f1:	48 89 d6             	mov    %rdx,%rsi
  8008f4:	89 c7                	mov    %eax,%edi
  8008f6:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  8008fd:	00 00 00 
  800900:	ff d0                	callq  *%rax
  800902:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800905:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800909:	79 08                	jns    800913 <dup+0x37>
		return r;
  80090b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80090e:	e9 70 01 00 00       	jmpq   800a83 <dup+0x1a7>
	close(newfdnum);
  800913:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800916:	89 c7                	mov    %eax,%edi
  800918:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  80091f:	00 00 00 
  800922:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800924:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800927:	48 98                	cltq   
  800929:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80092f:	48 c1 e0 0c          	shl    $0xc,%rax
  800933:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093b:	48 89 c7             	mov    %rax,%rdi
  80093e:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  800945:	00 00 00 
  800948:	ff d0                	callq  *%rax
  80094a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80094e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800952:	48 89 c7             	mov    %rax,%rdi
  800955:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  80095c:	00 00 00 
  80095f:	ff d0                	callq  *%rax
  800961:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800965:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800969:	48 c1 e8 15          	shr    $0x15,%rax
  80096d:	48 89 c2             	mov    %rax,%rdx
  800970:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800977:	01 00 00 
  80097a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80097e:	83 e0 01             	and    $0x1,%eax
  800981:	48 85 c0             	test   %rax,%rax
  800984:	74 73                	je     8009f9 <dup+0x11d>
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	48 c1 e8 0c          	shr    $0xc,%rax
  80098e:	48 89 c2             	mov    %rax,%rdx
  800991:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800998:	01 00 00 
  80099b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80099f:	83 e0 01             	and    $0x1,%eax
  8009a2:	48 85 c0             	test   %rax,%rax
  8009a5:	74 52                	je     8009f9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8009a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ab:	48 c1 e8 0c          	shr    $0xc,%rax
  8009af:	48 89 c2             	mov    %rax,%rdx
  8009b2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8009b9:	01 00 00 
  8009bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8009c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8009c5:	89 c1                	mov    %eax,%ecx
  8009c7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8009cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cf:	41 89 c8             	mov    %ecx,%r8d
  8009d2:	48 89 d1             	mov    %rdx,%rcx
  8009d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009da:	48 89 c6             	mov    %rax,%rsi
  8009dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e2:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  8009e9:	00 00 00 
  8009ec:	ff d0                	callq  *%rax
  8009ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009f5:	79 02                	jns    8009f9 <dup+0x11d>
			goto err;
  8009f7:	eb 57                	jmp    800a50 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8009f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009fd:	48 c1 e8 0c          	shr    $0xc,%rax
  800a01:	48 89 c2             	mov    %rax,%rdx
  800a04:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800a0b:	01 00 00 
  800a0e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a12:	25 07 0e 00 00       	and    $0xe07,%eax
  800a17:	89 c1                	mov    %eax,%ecx
  800a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a1d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a21:	41 89 c8             	mov    %ecx,%r8d
  800a24:	48 89 d1             	mov    %rdx,%rcx
  800a27:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2c:	48 89 c6             	mov    %rax,%rsi
  800a2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a34:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  800a3b:	00 00 00 
  800a3e:	ff d0                	callq  *%rax
  800a40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a47:	79 02                	jns    800a4b <dup+0x16f>
		goto err;
  800a49:	eb 05                	jmp    800a50 <dup+0x174>

	return newfdnum;
  800a4b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800a4e:	eb 33                	jmp    800a83 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  800a50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800a54:	48 89 c6             	mov    %rax,%rsi
  800a57:	bf 00 00 00 00       	mov    $0x0,%edi
  800a5c:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  800a63:	00 00 00 
  800a66:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800a68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a6c:	48 89 c6             	mov    %rax,%rsi
  800a6f:	bf 00 00 00 00       	mov    $0x0,%edi
  800a74:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  800a7b:	00 00 00 
  800a7e:	ff d0                	callq  *%rax
	return r;
  800a80:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a83:	c9                   	leaveq 
  800a84:	c3                   	retq   

0000000000800a85 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800a85:	55                   	push   %rbp
  800a86:	48 89 e5             	mov    %rsp,%rbp
  800a89:	48 83 ec 40          	sub    $0x40,%rsp
  800a8d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800a90:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800a94:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a98:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800a9c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a9f:	48 89 d6             	mov    %rdx,%rsi
  800aa2:	89 c7                	mov    %eax,%edi
  800aa4:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800aab:	00 00 00 
  800aae:	ff d0                	callq  *%rax
  800ab0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ab3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ab7:	78 24                	js     800add <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ab9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abd:	8b 00                	mov    (%rax),%eax
  800abf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800ac3:	48 89 d6             	mov    %rdx,%rsi
  800ac6:	89 c7                	mov    %eax,%edi
  800ac8:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800acf:	00 00 00 
  800ad2:	ff d0                	callq  *%rax
  800ad4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ad7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800adb:	79 05                	jns    800ae2 <read+0x5d>
		return r;
  800add:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ae0:	eb 76                	jmp    800b58 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800ae2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae6:	8b 40 08             	mov    0x8(%rax),%eax
  800ae9:	83 e0 03             	and    $0x3,%eax
  800aec:	83 f8 01             	cmp    $0x1,%eax
  800aef:	75 3a                	jne    800b2b <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800af1:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800af8:	00 00 00 
  800afb:	48 8b 00             	mov    (%rax),%rax
  800afe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800b04:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800b07:	89 c6                	mov    %eax,%esi
  800b09:	48 bf 5f 35 80 00 00 	movabs $0x80355f,%rdi
  800b10:	00 00 00 
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
  800b18:	48 b9 73 1f 80 00 00 	movabs $0x801f73,%rcx
  800b1f:	00 00 00 
  800b22:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800b24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b29:	eb 2d                	jmp    800b58 <read+0xd3>
	}
	if (!dev->dev_read)
  800b2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b2f:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b33:	48 85 c0             	test   %rax,%rax
  800b36:	75 07                	jne    800b3f <read+0xba>
		return -E_NOT_SUPP;
  800b38:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800b3d:	eb 19                	jmp    800b58 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800b3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b43:	48 8b 40 10          	mov    0x10(%rax),%rax
  800b47:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800b4b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b4f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800b53:	48 89 cf             	mov    %rcx,%rdi
  800b56:	ff d0                	callq  *%rax
}
  800b58:	c9                   	leaveq 
  800b59:	c3                   	retq   

0000000000800b5a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800b5a:	55                   	push   %rbp
  800b5b:	48 89 e5             	mov    %rsp,%rbp
  800b5e:	48 83 ec 30          	sub    $0x30,%rsp
  800b62:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800b65:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800b69:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800b6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b74:	eb 49                	jmp    800bbf <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b79:	48 98                	cltq   
  800b7b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800b7f:	48 29 c2             	sub    %rax,%rdx
  800b82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b85:	48 63 c8             	movslq %eax,%rcx
  800b88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800b8c:	48 01 c1             	add    %rax,%rcx
  800b8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800b92:	48 89 ce             	mov    %rcx,%rsi
  800b95:	89 c7                	mov    %eax,%edi
  800b97:	48 b8 85 0a 80 00 00 	movabs $0x800a85,%rax
  800b9e:	00 00 00 
  800ba1:	ff d0                	callq  *%rax
  800ba3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800ba6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800baa:	79 05                	jns    800bb1 <readn+0x57>
			return m;
  800bac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800baf:	eb 1c                	jmp    800bcd <readn+0x73>
		if (m == 0)
  800bb1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800bb5:	75 02                	jne    800bb9 <readn+0x5f>
			break;
  800bb7:	eb 11                	jmp    800bca <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bb9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bbc:	01 45 fc             	add    %eax,-0x4(%rbp)
  800bbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bc2:	48 98                	cltq   
  800bc4:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800bc8:	72 ac                	jb     800b76 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  800bca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800bcd:	c9                   	leaveq 
  800bce:	c3                   	retq   

0000000000800bcf <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bcf:	55                   	push   %rbp
  800bd0:	48 89 e5             	mov    %rsp,%rbp
  800bd3:	48 83 ec 40          	sub    $0x40,%rsp
  800bd7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800bda:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800bde:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800be2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800be6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800be9:	48 89 d6             	mov    %rdx,%rsi
  800bec:	89 c7                	mov    %eax,%edi
  800bee:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800bf5:	00 00 00 
  800bf8:	ff d0                	callq  *%rax
  800bfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800bfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c01:	78 24                	js     800c27 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c07:	8b 00                	mov    (%rax),%eax
  800c09:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800c0d:	48 89 d6             	mov    %rdx,%rsi
  800c10:	89 c7                	mov    %eax,%edi
  800c12:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800c19:	00 00 00 
  800c1c:	ff d0                	callq  *%rax
  800c1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c25:	79 05                	jns    800c2c <write+0x5d>
		return r;
  800c27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c2a:	eb 75                	jmp    800ca1 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c30:	8b 40 08             	mov    0x8(%rax),%eax
  800c33:	83 e0 03             	and    $0x3,%eax
  800c36:	85 c0                	test   %eax,%eax
  800c38:	75 3a                	jne    800c74 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c3a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800c41:	00 00 00 
  800c44:	48 8b 00             	mov    (%rax),%rax
  800c47:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800c4d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800c50:	89 c6                	mov    %eax,%esi
  800c52:	48 bf 7b 35 80 00 00 	movabs $0x80357b,%rdi
  800c59:	00 00 00 
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c61:	48 b9 73 1f 80 00 00 	movabs $0x801f73,%rcx
  800c68:	00 00 00 
  800c6b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800c6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c72:	eb 2d                	jmp    800ca1 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c78:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c7c:	48 85 c0             	test   %rax,%rax
  800c7f:	75 07                	jne    800c88 <write+0xb9>
		return -E_NOT_SUPP;
  800c81:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800c86:	eb 19                	jmp    800ca1 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800c88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c8c:	48 8b 40 18          	mov    0x18(%rax),%rax
  800c90:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800c94:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c98:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800c9c:	48 89 cf             	mov    %rcx,%rdi
  800c9f:	ff d0                	callq  *%rax
}
  800ca1:	c9                   	leaveq 
  800ca2:	c3                   	retq   

0000000000800ca3 <seek>:

int
seek(int fdnum, off_t offset)
{
  800ca3:	55                   	push   %rbp
  800ca4:	48 89 e5             	mov    %rsp,%rbp
  800ca7:	48 83 ec 18          	sub    $0x18,%rsp
  800cab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800cae:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800cb1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800cb5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800cb8:	48 89 d6             	mov    %rdx,%rsi
  800cbb:	89 c7                	mov    %eax,%edi
  800cbd:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800cc4:	00 00 00 
  800cc7:	ff d0                	callq  *%rax
  800cc9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ccc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cd0:	79 05                	jns    800cd7 <seek+0x34>
		return r;
  800cd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cd5:	eb 0f                	jmp    800ce6 <seek+0x43>
	fd->fd_offset = offset;
  800cd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cdb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800cde:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce6:	c9                   	leaveq 
  800ce7:	c3                   	retq   

0000000000800ce8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800ce8:	55                   	push   %rbp
  800ce9:	48 89 e5             	mov    %rsp,%rbp
  800cec:	48 83 ec 30          	sub    $0x30,%rsp
  800cf0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800cf3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cf6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800cfa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800cfd:	48 89 d6             	mov    %rdx,%rsi
  800d00:	89 c7                	mov    %eax,%edi
  800d02:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800d09:	00 00 00 
  800d0c:	ff d0                	callq  *%rax
  800d0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d15:	78 24                	js     800d3b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d1b:	8b 00                	mov    (%rax),%eax
  800d1d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d21:	48 89 d6             	mov    %rdx,%rsi
  800d24:	89 c7                	mov    %eax,%edi
  800d26:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800d2d:	00 00 00 
  800d30:	ff d0                	callq  *%rax
  800d32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d39:	79 05                	jns    800d40 <ftruncate+0x58>
		return r;
  800d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d3e:	eb 72                	jmp    800db2 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d44:	8b 40 08             	mov    0x8(%rax),%eax
  800d47:	83 e0 03             	and    $0x3,%eax
  800d4a:	85 c0                	test   %eax,%eax
  800d4c:	75 3a                	jne    800d88 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800d4e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800d55:	00 00 00 
  800d58:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d5b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d61:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d64:	89 c6                	mov    %eax,%esi
  800d66:	48 bf 98 35 80 00 00 	movabs $0x803598,%rdi
  800d6d:	00 00 00 
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
  800d75:	48 b9 73 1f 80 00 00 	movabs $0x801f73,%rcx
  800d7c:	00 00 00 
  800d7f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800d81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d86:	eb 2a                	jmp    800db2 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  800d88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d8c:	48 8b 40 30          	mov    0x30(%rax),%rax
  800d90:	48 85 c0             	test   %rax,%rax
  800d93:	75 07                	jne    800d9c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  800d95:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800d9a:	eb 16                	jmp    800db2 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  800d9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800da0:	48 8b 40 30          	mov    0x30(%rax),%rax
  800da4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800da8:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  800dab:	89 ce                	mov    %ecx,%esi
  800dad:	48 89 d7             	mov    %rdx,%rdi
  800db0:	ff d0                	callq  *%rax
}
  800db2:	c9                   	leaveq 
  800db3:	c3                   	retq   

0000000000800db4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800db4:	55                   	push   %rbp
  800db5:	48 89 e5             	mov    %rsp,%rbp
  800db8:	48 83 ec 30          	sub    $0x30,%rsp
  800dbc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800dbf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dc3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800dc7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800dca:	48 89 d6             	mov    %rdx,%rsi
  800dcd:	89 c7                	mov    %eax,%edi
  800dcf:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  800dd6:	00 00 00 
  800dd9:	ff d0                	callq  *%rax
  800ddb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800dde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800de2:	78 24                	js     800e08 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800de4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de8:	8b 00                	mov    (%rax),%eax
  800dea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800dee:	48 89 d6             	mov    %rdx,%rsi
  800df1:	89 c7                	mov    %eax,%edi
  800df3:	48 b8 ac 07 80 00 00 	movabs $0x8007ac,%rax
  800dfa:	00 00 00 
  800dfd:	ff d0                	callq  *%rax
  800dff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e06:	79 05                	jns    800e0d <fstat+0x59>
		return r;
  800e08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e0b:	eb 5e                	jmp    800e6b <fstat+0xb7>
	if (!dev->dev_stat)
  800e0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e11:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e15:	48 85 c0             	test   %rax,%rax
  800e18:	75 07                	jne    800e21 <fstat+0x6d>
		return -E_NOT_SUPP;
  800e1a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800e1f:	eb 4a                	jmp    800e6b <fstat+0xb7>
	stat->st_name[0] = 0;
  800e21:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e25:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  800e28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e2c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  800e33:	00 00 00 
	stat->st_isdir = 0;
  800e36:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e3a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  800e41:	00 00 00 
	stat->st_dev = dev;
  800e44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e48:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e4c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  800e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e57:	48 8b 40 28          	mov    0x28(%rax),%rax
  800e5b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e5f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800e63:	48 89 ce             	mov    %rcx,%rsi
  800e66:	48 89 d7             	mov    %rdx,%rdi
  800e69:	ff d0                	callq  *%rax
}
  800e6b:	c9                   	leaveq 
  800e6c:	c3                   	retq   

0000000000800e6d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800e6d:	55                   	push   %rbp
  800e6e:	48 89 e5             	mov    %rsp,%rbp
  800e71:	48 83 ec 20          	sub    $0x20,%rsp
  800e75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800e7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e81:	be 00 00 00 00       	mov    $0x0,%esi
  800e86:	48 89 c7             	mov    %rax,%rdi
  800e89:	48 b8 5b 0f 80 00 00 	movabs $0x800f5b,%rax
  800e90:	00 00 00 
  800e93:	ff d0                	callq  *%rax
  800e95:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e98:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e9c:	79 05                	jns    800ea3 <stat+0x36>
		return fd;
  800e9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ea1:	eb 2f                	jmp    800ed2 <stat+0x65>
	r = fstat(fd, stat);
  800ea3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ea7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eaa:	48 89 d6             	mov    %rdx,%rsi
  800ead:	89 c7                	mov    %eax,%edi
  800eaf:	48 b8 b4 0d 80 00 00 	movabs $0x800db4,%rax
  800eb6:	00 00 00 
  800eb9:	ff d0                	callq  *%rax
  800ebb:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  800ebe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ec1:	89 c7                	mov    %eax,%edi
  800ec3:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  800eca:	00 00 00 
  800ecd:	ff d0                	callq  *%rax
	return r;
  800ecf:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  800ed2:	c9                   	leaveq 
  800ed3:	c3                   	retq   

0000000000800ed4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ed4:	55                   	push   %rbp
  800ed5:	48 89 e5             	mov    %rsp,%rbp
  800ed8:	48 83 ec 10          	sub    $0x10,%rsp
  800edc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800edf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  800ee3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800eea:	00 00 00 
  800eed:	8b 00                	mov    (%rax),%eax
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	75 1d                	jne    800f10 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ef3:	bf 01 00 00 00       	mov    $0x1,%edi
  800ef8:	48 b8 e4 33 80 00 00 	movabs $0x8033e4,%rax
  800eff:	00 00 00 
  800f02:	ff d0                	callq  *%rax
  800f04:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  800f0b:	00 00 00 
  800f0e:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f10:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800f17:	00 00 00 
  800f1a:	8b 00                	mov    (%rax),%eax
  800f1c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  800f1f:	b9 07 00 00 00       	mov    $0x7,%ecx
  800f24:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  800f2b:	00 00 00 
  800f2e:	89 c7                	mov    %eax,%edi
  800f30:	48 b8 47 33 80 00 00 	movabs $0x803347,%rax
  800f37:	00 00 00 
  800f3a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  800f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f40:	ba 00 00 00 00       	mov    $0x0,%edx
  800f45:	48 89 c6             	mov    %rax,%rsi
  800f48:	bf 00 00 00 00       	mov    $0x0,%edi
  800f4d:	48 b8 81 32 80 00 00 	movabs $0x803281,%rax
  800f54:	00 00 00 
  800f57:	ff d0                	callq  *%rax
}
  800f59:	c9                   	leaveq 
  800f5a:	c3                   	retq   

0000000000800f5b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800f5b:	55                   	push   %rbp
  800f5c:	48 89 e5             	mov    %rsp,%rbp
  800f5f:	48 83 ec 20          	sub    $0x20,%rsp
  800f63:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f67:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  800f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f6e:	48 89 c7             	mov    %rax,%rdi
  800f71:	48 b8 bc 2a 80 00 00 	movabs $0x802abc,%rax
  800f78:	00 00 00 
  800f7b:	ff d0                	callq  *%rax
  800f7d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800f82:	7e 0a                	jle    800f8e <open+0x33>
  800f84:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800f89:	e9 a5 00 00 00       	jmpq   801033 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  800f8e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800f92:	48 89 c7             	mov    %rax,%rdi
  800f95:	48 b8 bb 05 80 00 00 	movabs $0x8005bb,%rax
  800f9c:	00 00 00 
  800f9f:	ff d0                	callq  *%rax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fa4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fa8:	79 08                	jns    800fb2 <open+0x57>
		return r;
  800faa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fad:	e9 81 00 00 00       	jmpq   801033 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  800fb2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800fb9:	00 00 00 
  800fbc:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800fbf:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  800fc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc9:	48 89 c6             	mov    %rax,%rsi
  800fcc:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  800fd3:	00 00 00 
  800fd6:	48 b8 28 2b 80 00 00 	movabs $0x802b28,%rax
  800fdd:	00 00 00 
  800fe0:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  800fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fe6:	48 89 c6             	mov    %rax,%rsi
  800fe9:	bf 01 00 00 00       	mov    $0x1,%edi
  800fee:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  800ff5:	00 00 00 
  800ff8:	ff d0                	callq  *%rax
  800ffa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ffd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801001:	79 1d                	jns    801020 <open+0xc5>
		fd_close(fd, 0);
  801003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801007:	be 00 00 00 00       	mov    $0x0,%esi
  80100c:	48 89 c7             	mov    %rax,%rdi
  80100f:	48 b8 e3 06 80 00 00 	movabs $0x8006e3,%rax
  801016:	00 00 00 
  801019:	ff d0                	callq  *%rax
		return r;
  80101b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80101e:	eb 13                	jmp    801033 <open+0xd8>
	}
	return fd2num(fd);
  801020:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801024:	48 89 c7             	mov    %rax,%rdi
  801027:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  80102e:	00 00 00 
  801031:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  801033:	c9                   	leaveq 
  801034:	c3                   	retq   

0000000000801035 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801035:	55                   	push   %rbp
  801036:	48 89 e5             	mov    %rsp,%rbp
  801039:	48 83 ec 10          	sub    $0x10,%rsp
  80103d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801041:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801045:	8b 50 0c             	mov    0xc(%rax),%edx
  801048:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80104f:	00 00 00 
  801052:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801054:	be 00 00 00 00       	mov    $0x0,%esi
  801059:	bf 06 00 00 00       	mov    $0x6,%edi
  80105e:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  801065:	00 00 00 
  801068:	ff d0                	callq  *%rax
}
  80106a:	c9                   	leaveq 
  80106b:	c3                   	retq   

000000000080106c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80106c:	55                   	push   %rbp
  80106d:	48 89 e5             	mov    %rsp,%rbp
  801070:	48 83 ec 30          	sub    $0x30,%rsp
  801074:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801078:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80107c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801084:	8b 50 0c             	mov    0xc(%rax),%edx
  801087:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80108e:	00 00 00 
  801091:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801093:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80109a:	00 00 00 
  80109d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8010a1:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  8010a5:	be 00 00 00 00       	mov    $0x0,%esi
  8010aa:	bf 03 00 00 00       	mov    $0x3,%edi
  8010af:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  8010b6:	00 00 00 
  8010b9:	ff d0                	callq  *%rax
  8010bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010c2:	79 05                	jns    8010c9 <devfile_read+0x5d>
		return r;
  8010c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c7:	eb 26                	jmp    8010ef <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  8010c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010cc:	48 63 d0             	movslq %eax,%rdx
  8010cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d3:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8010da:	00 00 00 
  8010dd:	48 89 c7             	mov    %rax,%rdi
  8010e0:	48 b8 63 2f 80 00 00 	movabs $0x802f63,%rax
  8010e7:	00 00 00 
  8010ea:	ff d0                	callq  *%rax
	return r;
  8010ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8010ef:	c9                   	leaveq 
  8010f0:	c3                   	retq   

00000000008010f1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8010f1:	55                   	push   %rbp
  8010f2:	48 89 e5             	mov    %rsp,%rbp
  8010f5:	48 83 ec 30          	sub    $0x30,%rsp
  8010f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801101:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  801105:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  80110c:	00 
	n = n > max ? max : n;
  80110d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801111:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801115:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  80111a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80111e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801122:	8b 50 0c             	mov    0xc(%rax),%edx
  801125:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80112c:	00 00 00 
  80112f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801131:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801138:	00 00 00 
  80113b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80113f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801143:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801147:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80114b:	48 89 c6             	mov    %rax,%rsi
  80114e:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  801155:	00 00 00 
  801158:	48 b8 63 2f 80 00 00 	movabs $0x802f63,%rax
  80115f:	00 00 00 
  801162:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  801164:	be 00 00 00 00       	mov    $0x0,%esi
  801169:	bf 04 00 00 00       	mov    $0x4,%edi
  80116e:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  801175:	00 00 00 
  801178:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  80117a:	c9                   	leaveq 
  80117b:	c3                   	retq   

000000000080117c <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80117c:	55                   	push   %rbp
  80117d:	48 89 e5             	mov    %rsp,%rbp
  801180:	48 83 ec 20          	sub    $0x20,%rsp
  801184:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801188:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80118c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801190:	8b 50 0c             	mov    0xc(%rax),%edx
  801193:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80119a:	00 00 00 
  80119d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80119f:	be 00 00 00 00       	mov    $0x0,%esi
  8011a4:	bf 05 00 00 00       	mov    $0x5,%edi
  8011a9:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  8011b0:	00 00 00 
  8011b3:	ff d0                	callq  *%rax
  8011b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011bc:	79 05                	jns    8011c3 <devfile_stat+0x47>
		return r;
  8011be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011c1:	eb 56                	jmp    801219 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8011c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c7:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  8011ce:	00 00 00 
  8011d1:	48 89 c7             	mov    %rax,%rdi
  8011d4:	48 b8 28 2b 80 00 00 	movabs $0x802b28,%rax
  8011db:	00 00 00 
  8011de:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8011e0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8011e7:	00 00 00 
  8011ea:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8011f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8011fa:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801201:	00 00 00 
  801204:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80120a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80120e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801214:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801219:	c9                   	leaveq 
  80121a:	c3                   	retq   

000000000080121b <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80121b:	55                   	push   %rbp
  80121c:	48 89 e5             	mov    %rsp,%rbp
  80121f:	48 83 ec 10          	sub    $0x10,%rsp
  801223:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801227:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80122a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122e:	8b 50 0c             	mov    0xc(%rax),%edx
  801231:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801238:	00 00 00 
  80123b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80123d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801244:	00 00 00 
  801247:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80124a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80124d:	be 00 00 00 00       	mov    $0x0,%esi
  801252:	bf 02 00 00 00       	mov    $0x2,%edi
  801257:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  80125e:	00 00 00 
  801261:	ff d0                	callq  *%rax
}
  801263:	c9                   	leaveq 
  801264:	c3                   	retq   

0000000000801265 <remove>:

// Delete a file
int
remove(const char *path)
{
  801265:	55                   	push   %rbp
  801266:	48 89 e5             	mov    %rsp,%rbp
  801269:	48 83 ec 10          	sub    $0x10,%rsp
  80126d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801275:	48 89 c7             	mov    %rax,%rdi
  801278:	48 b8 bc 2a 80 00 00 	movabs $0x802abc,%rax
  80127f:	00 00 00 
  801282:	ff d0                	callq  *%rax
  801284:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801289:	7e 07                	jle    801292 <remove+0x2d>
		return -E_BAD_PATH;
  80128b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801290:	eb 33                	jmp    8012c5 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801292:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801296:	48 89 c6             	mov    %rax,%rsi
  801299:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8012a0:	00 00 00 
  8012a3:	48 b8 28 2b 80 00 00 	movabs $0x802b28,%rax
  8012aa:	00 00 00 
  8012ad:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8012af:	be 00 00 00 00       	mov    $0x0,%esi
  8012b4:	bf 07 00 00 00       	mov    $0x7,%edi
  8012b9:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  8012c0:	00 00 00 
  8012c3:	ff d0                	callq  *%rax
}
  8012c5:	c9                   	leaveq 
  8012c6:	c3                   	retq   

00000000008012c7 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8012c7:	55                   	push   %rbp
  8012c8:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8012cb:	be 00 00 00 00       	mov    $0x0,%esi
  8012d0:	bf 08 00 00 00       	mov    $0x8,%edi
  8012d5:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  8012dc:	00 00 00 
  8012df:	ff d0                	callq  *%rax
}
  8012e1:	5d                   	pop    %rbp
  8012e2:	c3                   	retq   

00000000008012e3 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8012e3:	55                   	push   %rbp
  8012e4:	48 89 e5             	mov    %rsp,%rbp
  8012e7:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8012ee:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8012f5:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8012fc:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801303:	be 00 00 00 00       	mov    $0x0,%esi
  801308:	48 89 c7             	mov    %rax,%rdi
  80130b:	48 b8 5b 0f 80 00 00 	movabs $0x800f5b,%rax
  801312:	00 00 00 
  801315:	ff d0                	callq  *%rax
  801317:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80131a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80131e:	79 28                	jns    801348 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801320:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801323:	89 c6                	mov    %eax,%esi
  801325:	48 bf be 35 80 00 00 	movabs $0x8035be,%rdi
  80132c:	00 00 00 
  80132f:	b8 00 00 00 00       	mov    $0x0,%eax
  801334:	48 ba 73 1f 80 00 00 	movabs $0x801f73,%rdx
  80133b:	00 00 00 
  80133e:	ff d2                	callq  *%rdx
		return fd_src;
  801340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801343:	e9 74 01 00 00       	jmpq   8014bc <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801348:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80134f:	be 01 01 00 00       	mov    $0x101,%esi
  801354:	48 89 c7             	mov    %rax,%rdi
  801357:	48 b8 5b 0f 80 00 00 	movabs $0x800f5b,%rax
  80135e:	00 00 00 
  801361:	ff d0                	callq  *%rax
  801363:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801366:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80136a:	79 39                	jns    8013a5 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80136c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80136f:	89 c6                	mov    %eax,%esi
  801371:	48 bf d4 35 80 00 00 	movabs $0x8035d4,%rdi
  801378:	00 00 00 
  80137b:	b8 00 00 00 00       	mov    $0x0,%eax
  801380:	48 ba 73 1f 80 00 00 	movabs $0x801f73,%rdx
  801387:	00 00 00 
  80138a:	ff d2                	callq  *%rdx
		close(fd_src);
  80138c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80138f:	89 c7                	mov    %eax,%edi
  801391:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  801398:	00 00 00 
  80139b:	ff d0                	callq  *%rax
		return fd_dest;
  80139d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8013a0:	e9 17 01 00 00       	jmpq   8014bc <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8013a5:	eb 74                	jmp    80141b <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  8013a7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013aa:	48 63 d0             	movslq %eax,%rdx
  8013ad:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8013b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8013b7:	48 89 ce             	mov    %rcx,%rsi
  8013ba:	89 c7                	mov    %eax,%edi
  8013bc:	48 b8 cf 0b 80 00 00 	movabs $0x800bcf,%rax
  8013c3:	00 00 00 
  8013c6:	ff d0                	callq  *%rax
  8013c8:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8013cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8013cf:	79 4a                	jns    80141b <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8013d1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8013d4:	89 c6                	mov    %eax,%esi
  8013d6:	48 bf ee 35 80 00 00 	movabs $0x8035ee,%rdi
  8013dd:	00 00 00 
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e5:	48 ba 73 1f 80 00 00 	movabs $0x801f73,%rdx
  8013ec:	00 00 00 
  8013ef:	ff d2                	callq  *%rdx
			close(fd_src);
  8013f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013f4:	89 c7                	mov    %eax,%edi
  8013f6:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  8013fd:	00 00 00 
  801400:	ff d0                	callq  *%rax
			close(fd_dest);
  801402:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801405:	89 c7                	mov    %eax,%edi
  801407:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  80140e:	00 00 00 
  801411:	ff d0                	callq  *%rax
			return write_size;
  801413:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801416:	e9 a1 00 00 00       	jmpq   8014bc <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80141b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801422:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801425:	ba 00 02 00 00       	mov    $0x200,%edx
  80142a:	48 89 ce             	mov    %rcx,%rsi
  80142d:	89 c7                	mov    %eax,%edi
  80142f:	48 b8 85 0a 80 00 00 	movabs $0x800a85,%rax
  801436:	00 00 00 
  801439:	ff d0                	callq  *%rax
  80143b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80143e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  801442:	0f 8f 5f ff ff ff    	jg     8013a7 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  801448:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80144c:	79 47                	jns    801495 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80144e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801451:	89 c6                	mov    %eax,%esi
  801453:	48 bf 01 36 80 00 00 	movabs $0x803601,%rdi
  80145a:	00 00 00 
  80145d:	b8 00 00 00 00       	mov    $0x0,%eax
  801462:	48 ba 73 1f 80 00 00 	movabs $0x801f73,%rdx
  801469:	00 00 00 
  80146c:	ff d2                	callq  *%rdx
		close(fd_src);
  80146e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801471:	89 c7                	mov    %eax,%edi
  801473:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  80147a:	00 00 00 
  80147d:	ff d0                	callq  *%rax
		close(fd_dest);
  80147f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801482:	89 c7                	mov    %eax,%edi
  801484:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  80148b:	00 00 00 
  80148e:	ff d0                	callq  *%rax
		return read_size;
  801490:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801493:	eb 27                	jmp    8014bc <copy+0x1d9>
	}
	close(fd_src);
  801495:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801498:	89 c7                	mov    %eax,%edi
  80149a:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  8014a1:	00 00 00 
  8014a4:	ff d0                	callq  *%rax
	close(fd_dest);
  8014a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014a9:	89 c7                	mov    %eax,%edi
  8014ab:	48 b8 63 08 80 00 00 	movabs $0x800863,%rax
  8014b2:	00 00 00 
  8014b5:	ff d0                	callq  *%rax
	return 0;
  8014b7:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8014bc:	c9                   	leaveq 
  8014bd:	c3                   	retq   

00000000008014be <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8014be:	55                   	push   %rbp
  8014bf:	48 89 e5             	mov    %rsp,%rbp
  8014c2:	53                   	push   %rbx
  8014c3:	48 83 ec 38          	sub    $0x38,%rsp
  8014c7:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8014cb:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8014cf:	48 89 c7             	mov    %rax,%rdi
  8014d2:	48 b8 bb 05 80 00 00 	movabs $0x8005bb,%rax
  8014d9:	00 00 00 
  8014dc:	ff d0                	callq  *%rax
  8014de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8014e5:	0f 88 bf 01 00 00    	js     8016aa <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ef:	ba 07 04 00 00       	mov    $0x407,%edx
  8014f4:	48 89 c6             	mov    %rax,%rsi
  8014f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8014fc:	48 b8 00 03 80 00 00 	movabs $0x800300,%rax
  801503:	00 00 00 
  801506:	ff d0                	callq  *%rax
  801508:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80150b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80150f:	0f 88 95 01 00 00    	js     8016aa <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801515:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801519:	48 89 c7             	mov    %rax,%rdi
  80151c:	48 b8 bb 05 80 00 00 	movabs $0x8005bb,%rax
  801523:	00 00 00 
  801526:	ff d0                	callq  *%rax
  801528:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80152b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80152f:	0f 88 5d 01 00 00    	js     801692 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801535:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801539:	ba 07 04 00 00       	mov    $0x407,%edx
  80153e:	48 89 c6             	mov    %rax,%rsi
  801541:	bf 00 00 00 00       	mov    $0x0,%edi
  801546:	48 b8 00 03 80 00 00 	movabs $0x800300,%rax
  80154d:	00 00 00 
  801550:	ff d0                	callq  *%rax
  801552:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801555:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801559:	0f 88 33 01 00 00    	js     801692 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80155f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801563:	48 89 c7             	mov    %rax,%rdi
  801566:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  80156d:	00 00 00 
  801570:	ff d0                	callq  *%rax
  801572:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801576:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80157a:	ba 07 04 00 00       	mov    $0x407,%edx
  80157f:	48 89 c6             	mov    %rax,%rsi
  801582:	bf 00 00 00 00       	mov    $0x0,%edi
  801587:	48 b8 00 03 80 00 00 	movabs $0x800300,%rax
  80158e:	00 00 00 
  801591:	ff d0                	callq  *%rax
  801593:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801596:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80159a:	79 05                	jns    8015a1 <pipe+0xe3>
		goto err2;
  80159c:	e9 d9 00 00 00       	jmpq   80167a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a5:	48 89 c7             	mov    %rax,%rdi
  8015a8:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8015af:	00 00 00 
  8015b2:	ff d0                	callq  *%rax
  8015b4:	48 89 c2             	mov    %rax,%rdx
  8015b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015bb:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8015c1:	48 89 d1             	mov    %rdx,%rcx
  8015c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c9:	48 89 c6             	mov    %rax,%rsi
  8015cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8015d1:	48 b8 50 03 80 00 00 	movabs $0x800350,%rax
  8015d8:	00 00 00 
  8015db:	ff d0                	callq  *%rax
  8015dd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8015e4:	79 1b                	jns    801601 <pipe+0x143>
		goto err3;
  8015e6:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8015e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015eb:	48 89 c6             	mov    %rax,%rsi
  8015ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8015f3:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  8015fa:	00 00 00 
  8015fd:	ff d0                	callq  *%rax
  8015ff:	eb 79                	jmp    80167a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801601:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801605:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80160c:	00 00 00 
  80160f:	8b 12                	mov    (%rdx),%edx
  801611:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  801613:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801617:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80161e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801622:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  801629:	00 00 00 
  80162c:	8b 12                	mov    (%rdx),%edx
  80162e:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  801630:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801634:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163f:	48 89 c7             	mov    %rax,%rdi
  801642:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  801649:	00 00 00 
  80164c:	ff d0                	callq  *%rax
  80164e:	89 c2                	mov    %eax,%edx
  801650:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801654:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  801656:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80165a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80165e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801662:	48 89 c7             	mov    %rax,%rdi
  801665:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  80166c:	00 00 00 
  80166f:	ff d0                	callq  *%rax
  801671:	89 03                	mov    %eax,(%rbx)
	return 0;
  801673:	b8 00 00 00 00       	mov    $0x0,%eax
  801678:	eb 33                	jmp    8016ad <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80167a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80167e:	48 89 c6             	mov    %rax,%rsi
  801681:	bf 00 00 00 00       	mov    $0x0,%edi
  801686:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  80168d:	00 00 00 
  801690:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  801692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801696:	48 89 c6             	mov    %rax,%rsi
  801699:	bf 00 00 00 00       	mov    $0x0,%edi
  80169e:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  8016a5:	00 00 00 
  8016a8:	ff d0                	callq  *%rax
err:
	return r;
  8016aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8016ad:	48 83 c4 38          	add    $0x38,%rsp
  8016b1:	5b                   	pop    %rbx
  8016b2:	5d                   	pop    %rbp
  8016b3:	c3                   	retq   

00000000008016b4 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8016b4:	55                   	push   %rbp
  8016b5:	48 89 e5             	mov    %rsp,%rbp
  8016b8:	53                   	push   %rbx
  8016b9:	48 83 ec 28          	sub    $0x28,%rsp
  8016bd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8016c5:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8016cc:	00 00 00 
  8016cf:	48 8b 00             	mov    (%rax),%rax
  8016d2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8016d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8016db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016df:	48 89 c7             	mov    %rax,%rdi
  8016e2:	48 b8 66 34 80 00 00 	movabs $0x803466,%rax
  8016e9:	00 00 00 
  8016ec:	ff d0                	callq  *%rax
  8016ee:	89 c3                	mov    %eax,%ebx
  8016f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f4:	48 89 c7             	mov    %rax,%rdi
  8016f7:	48 b8 66 34 80 00 00 	movabs $0x803466,%rax
  8016fe:	00 00 00 
  801701:	ff d0                	callq  *%rax
  801703:	39 c3                	cmp    %eax,%ebx
  801705:	0f 94 c0             	sete   %al
  801708:	0f b6 c0             	movzbl %al,%eax
  80170b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80170e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801715:	00 00 00 
  801718:	48 8b 00             	mov    (%rax),%rax
  80171b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  801721:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  801724:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801727:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80172a:	75 05                	jne    801731 <_pipeisclosed+0x7d>
			return ret;
  80172c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80172f:	eb 4f                	jmp    801780 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  801731:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801734:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  801737:	74 42                	je     80177b <_pipeisclosed+0xc7>
  801739:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80173d:	75 3c                	jne    80177b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80173f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801746:	00 00 00 
  801749:	48 8b 00             	mov    (%rax),%rax
  80174c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  801752:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801755:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801758:	89 c6                	mov    %eax,%esi
  80175a:	48 bf 1c 36 80 00 00 	movabs $0x80361c,%rdi
  801761:	00 00 00 
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
  801769:	49 b8 73 1f 80 00 00 	movabs $0x801f73,%r8
  801770:	00 00 00 
  801773:	41 ff d0             	callq  *%r8
	}
  801776:	e9 4a ff ff ff       	jmpq   8016c5 <_pipeisclosed+0x11>
  80177b:	e9 45 ff ff ff       	jmpq   8016c5 <_pipeisclosed+0x11>
}
  801780:	48 83 c4 28          	add    $0x28,%rsp
  801784:	5b                   	pop    %rbx
  801785:	5d                   	pop    %rbp
  801786:	c3                   	retq   

0000000000801787 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801787:	55                   	push   %rbp
  801788:	48 89 e5             	mov    %rsp,%rbp
  80178b:	48 83 ec 30          	sub    $0x30,%rsp
  80178f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801792:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801796:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801799:	48 89 d6             	mov    %rdx,%rsi
  80179c:	89 c7                	mov    %eax,%edi
  80179e:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  8017a5:	00 00 00 
  8017a8:	ff d0                	callq  *%rax
  8017aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017b1:	79 05                	jns    8017b8 <pipeisclosed+0x31>
		return r;
  8017b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017b6:	eb 31                	jmp    8017e9 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8017b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017bc:	48 89 c7             	mov    %rax,%rdi
  8017bf:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8017c6:	00 00 00 
  8017c9:	ff d0                	callq  *%rax
  8017cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8017cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d7:	48 89 d6             	mov    %rdx,%rsi
  8017da:	48 89 c7             	mov    %rax,%rdi
  8017dd:	48 b8 b4 16 80 00 00 	movabs $0x8016b4,%rax
  8017e4:	00 00 00 
  8017e7:	ff d0                	callq  *%rax
}
  8017e9:	c9                   	leaveq 
  8017ea:	c3                   	retq   

00000000008017eb <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8017eb:	55                   	push   %rbp
  8017ec:	48 89 e5             	mov    %rsp,%rbp
  8017ef:	48 83 ec 40          	sub    $0x40,%rsp
  8017f3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017fb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8017ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801803:	48 89 c7             	mov    %rax,%rdi
  801806:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  80180d:	00 00 00 
  801810:	ff d0                	callq  *%rax
  801812:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801816:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80181a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80181e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801825:	00 
  801826:	e9 92 00 00 00       	jmpq   8018bd <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80182b:	eb 41                	jmp    80186e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80182d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  801832:	74 09                	je     80183d <devpipe_read+0x52>
				return i;
  801834:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801838:	e9 92 00 00 00       	jmpq   8018cf <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80183d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801841:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801845:	48 89 d6             	mov    %rdx,%rsi
  801848:	48 89 c7             	mov    %rax,%rdi
  80184b:	48 b8 b4 16 80 00 00 	movabs $0x8016b4,%rax
  801852:	00 00 00 
  801855:	ff d0                	callq  *%rax
  801857:	85 c0                	test   %eax,%eax
  801859:	74 07                	je     801862 <devpipe_read+0x77>
				return 0;
  80185b:	b8 00 00 00 00       	mov    $0x0,%eax
  801860:	eb 6d                	jmp    8018cf <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801862:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
  801869:	00 00 00 
  80186c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80186e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801872:	8b 10                	mov    (%rax),%edx
  801874:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801878:	8b 40 04             	mov    0x4(%rax),%eax
  80187b:	39 c2                	cmp    %eax,%edx
  80187d:	74 ae                	je     80182d <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80187f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801883:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801887:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80188b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80188f:	8b 00                	mov    (%rax),%eax
  801891:	99                   	cltd   
  801892:	c1 ea 1b             	shr    $0x1b,%edx
  801895:	01 d0                	add    %edx,%eax
  801897:	83 e0 1f             	and    $0x1f,%eax
  80189a:	29 d0                	sub    %edx,%eax
  80189c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018a0:	48 98                	cltq   
  8018a2:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8018a7:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8018a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ad:	8b 00                	mov    (%rax),%eax
  8018af:	8d 50 01             	lea    0x1(%rax),%edx
  8018b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b6:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018c1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8018c5:	0f 82 60 ff ff ff    	jb     80182b <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8018cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8018cf:	c9                   	leaveq 
  8018d0:	c3                   	retq   

00000000008018d1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8018d1:	55                   	push   %rbp
  8018d2:	48 89 e5             	mov    %rsp,%rbp
  8018d5:	48 83 ec 40          	sub    $0x40,%rsp
  8018d9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018dd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018e1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8018e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e9:	48 89 c7             	mov    %rax,%rdi
  8018ec:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8018f3:	00 00 00 
  8018f6:	ff d0                	callq  *%rax
  8018f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8018fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801900:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  801904:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80190b:	00 
  80190c:	e9 8e 00 00 00       	jmpq   80199f <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801911:	eb 31                	jmp    801944 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801913:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801917:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191b:	48 89 d6             	mov    %rdx,%rsi
  80191e:	48 89 c7             	mov    %rax,%rdi
  801921:	48 b8 b4 16 80 00 00 	movabs $0x8016b4,%rax
  801928:	00 00 00 
  80192b:	ff d0                	callq  *%rax
  80192d:	85 c0                	test   %eax,%eax
  80192f:	74 07                	je     801938 <devpipe_write+0x67>
				return 0;
  801931:	b8 00 00 00 00       	mov    $0x0,%eax
  801936:	eb 79                	jmp    8019b1 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801938:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
  80193f:	00 00 00 
  801942:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801944:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801948:	8b 40 04             	mov    0x4(%rax),%eax
  80194b:	48 63 d0             	movslq %eax,%rdx
  80194e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801952:	8b 00                	mov    (%rax),%eax
  801954:	48 98                	cltq   
  801956:	48 83 c0 20          	add    $0x20,%rax
  80195a:	48 39 c2             	cmp    %rax,%rdx
  80195d:	73 b4                	jae    801913 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80195f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801963:	8b 40 04             	mov    0x4(%rax),%eax
  801966:	99                   	cltd   
  801967:	c1 ea 1b             	shr    $0x1b,%edx
  80196a:	01 d0                	add    %edx,%eax
  80196c:	83 e0 1f             	and    $0x1f,%eax
  80196f:	29 d0                	sub    %edx,%eax
  801971:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801975:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801979:	48 01 ca             	add    %rcx,%rdx
  80197c:	0f b6 0a             	movzbl (%rdx),%ecx
  80197f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801983:	48 98                	cltq   
  801985:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  801989:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80198d:	8b 40 04             	mov    0x4(%rax),%eax
  801990:	8d 50 01             	lea    0x1(%rax),%edx
  801993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801997:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80199a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80199f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019a3:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8019a7:	0f 82 64 ff ff ff    	jb     801911 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8019ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019b1:	c9                   	leaveq 
  8019b2:	c3                   	retq   

00000000008019b3 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019b3:	55                   	push   %rbp
  8019b4:	48 89 e5             	mov    %rsp,%rbp
  8019b7:	48 83 ec 20          	sub    $0x20,%rsp
  8019bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019c7:	48 89 c7             	mov    %rax,%rdi
  8019ca:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  8019d1:	00 00 00 
  8019d4:	ff d0                	callq  *%rax
  8019d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8019da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8019de:	48 be 2f 36 80 00 00 	movabs $0x80362f,%rsi
  8019e5:	00 00 00 
  8019e8:	48 89 c7             	mov    %rax,%rdi
  8019eb:	48 b8 28 2b 80 00 00 	movabs $0x802b28,%rax
  8019f2:	00 00 00 
  8019f5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8019f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fb:	8b 50 04             	mov    0x4(%rax),%edx
  8019fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a02:	8b 00                	mov    (%rax),%eax
  801a04:	29 c2                	sub    %eax,%edx
  801a06:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a0a:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  801a10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a14:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  801a1b:	00 00 00 
	stat->st_dev = &devpipe;
  801a1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a22:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  801a29:	00 00 00 
  801a2c:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  801a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a38:	c9                   	leaveq 
  801a39:	c3                   	retq   

0000000000801a3a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a3a:	55                   	push   %rbp
  801a3b:	48 89 e5             	mov    %rsp,%rbp
  801a3e:	48 83 ec 10          	sub    $0x10,%rsp
  801a42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  801a46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a4a:	48 89 c6             	mov    %rax,%rsi
  801a4d:	bf 00 00 00 00       	mov    $0x0,%edi
  801a52:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  801a59:	00 00 00 
  801a5c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  801a5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a62:	48 89 c7             	mov    %rax,%rdi
  801a65:	48 b8 90 05 80 00 00 	movabs $0x800590,%rax
  801a6c:	00 00 00 
  801a6f:	ff d0                	callq  *%rax
  801a71:	48 89 c6             	mov    %rax,%rsi
  801a74:	bf 00 00 00 00       	mov    $0x0,%edi
  801a79:	48 b8 ab 03 80 00 00 	movabs $0x8003ab,%rax
  801a80:	00 00 00 
  801a83:	ff d0                	callq  *%rax
}
  801a85:	c9                   	leaveq 
  801a86:	c3                   	retq   

0000000000801a87 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801a87:	55                   	push   %rbp
  801a88:	48 89 e5             	mov    %rsp,%rbp
  801a8b:	48 83 ec 20          	sub    $0x20,%rsp
  801a8f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  801a92:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a95:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801a98:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801a9c:	be 01 00 00 00       	mov    $0x1,%esi
  801aa1:	48 89 c7             	mov    %rax,%rdi
  801aa4:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801aab:	00 00 00 
  801aae:	ff d0                	callq  *%rax
}
  801ab0:	c9                   	leaveq 
  801ab1:	c3                   	retq   

0000000000801ab2 <getchar>:

int
getchar(void)
{
  801ab2:	55                   	push   %rbp
  801ab3:	48 89 e5             	mov    %rsp,%rbp
  801ab6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801aba:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801abe:	ba 01 00 00 00       	mov    $0x1,%edx
  801ac3:	48 89 c6             	mov    %rax,%rsi
  801ac6:	bf 00 00 00 00       	mov    $0x0,%edi
  801acb:	48 b8 85 0a 80 00 00 	movabs $0x800a85,%rax
  801ad2:	00 00 00 
  801ad5:	ff d0                	callq  *%rax
  801ad7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801ada:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ade:	79 05                	jns    801ae5 <getchar+0x33>
		return r;
  801ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae3:	eb 14                	jmp    801af9 <getchar+0x47>
	if (r < 1)
  801ae5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ae9:	7f 07                	jg     801af2 <getchar+0x40>
		return -E_EOF;
  801aeb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801af0:	eb 07                	jmp    801af9 <getchar+0x47>
	return c;
  801af2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801af6:	0f b6 c0             	movzbl %al,%eax
}
  801af9:	c9                   	leaveq 
  801afa:	c3                   	retq   

0000000000801afb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801afb:	55                   	push   %rbp
  801afc:	48 89 e5             	mov    %rsp,%rbp
  801aff:	48 83 ec 20          	sub    $0x20,%rsp
  801b03:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b06:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b0d:	48 89 d6             	mov    %rdx,%rsi
  801b10:	89 c7                	mov    %eax,%edi
  801b12:	48 b8 53 06 80 00 00 	movabs $0x800653,%rax
  801b19:	00 00 00 
  801b1c:	ff d0                	callq  *%rax
  801b1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b25:	79 05                	jns    801b2c <iscons+0x31>
		return r;
  801b27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b2a:	eb 1a                	jmp    801b46 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801b2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b30:	8b 10                	mov    (%rax),%edx
  801b32:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  801b39:	00 00 00 
  801b3c:	8b 00                	mov    (%rax),%eax
  801b3e:	39 c2                	cmp    %eax,%edx
  801b40:	0f 94 c0             	sete   %al
  801b43:	0f b6 c0             	movzbl %al,%eax
}
  801b46:	c9                   	leaveq 
  801b47:	c3                   	retq   

0000000000801b48 <opencons>:

int
opencons(void)
{
  801b48:	55                   	push   %rbp
  801b49:	48 89 e5             	mov    %rsp,%rbp
  801b4c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801b50:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801b54:	48 89 c7             	mov    %rax,%rdi
  801b57:	48 b8 bb 05 80 00 00 	movabs $0x8005bb,%rax
  801b5e:	00 00 00 
  801b61:	ff d0                	callq  *%rax
  801b63:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b6a:	79 05                	jns    801b71 <opencons+0x29>
		return r;
  801b6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6f:	eb 5b                	jmp    801bcc <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b75:	ba 07 04 00 00       	mov    $0x407,%edx
  801b7a:	48 89 c6             	mov    %rax,%rsi
  801b7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801b82:	48 b8 00 03 80 00 00 	movabs $0x800300,%rax
  801b89:	00 00 00 
  801b8c:	ff d0                	callq  *%rax
  801b8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b95:	79 05                	jns    801b9c <opencons+0x54>
		return r;
  801b97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b9a:	eb 30                	jmp    801bcc <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ba0:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  801ba7:	00 00 00 
  801baa:	8b 12                	mov    (%rdx),%edx
  801bac:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801bae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bb2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801bb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bbd:	48 89 c7             	mov    %rax,%rdi
  801bc0:	48 b8 6d 05 80 00 00 	movabs $0x80056d,%rax
  801bc7:	00 00 00 
  801bca:	ff d0                	callq  *%rax
}
  801bcc:	c9                   	leaveq 
  801bcd:	c3                   	retq   

0000000000801bce <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801bce:	55                   	push   %rbp
  801bcf:	48 89 e5             	mov    %rsp,%rbp
  801bd2:	48 83 ec 30          	sub    $0x30,%rsp
  801bd6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bda:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bde:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801be2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801be7:	75 07                	jne    801bf0 <devcons_read+0x22>
		return 0;
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bee:	eb 4b                	jmp    801c3b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  801bf0:	eb 0c                	jmp    801bfe <devcons_read+0x30>
		sys_yield();
  801bf2:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
  801bf9:	00 00 00 
  801bfc:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801bfe:	48 b8 02 02 80 00 00 	movabs $0x800202,%rax
  801c05:	00 00 00 
  801c08:	ff d0                	callq  *%rax
  801c0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c11:	74 df                	je     801bf2 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  801c13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c17:	79 05                	jns    801c1e <devcons_read+0x50>
		return c;
  801c19:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c1c:	eb 1d                	jmp    801c3b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  801c1e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801c22:	75 07                	jne    801c2b <devcons_read+0x5d>
		return 0;
  801c24:	b8 00 00 00 00       	mov    $0x0,%eax
  801c29:	eb 10                	jmp    801c3b <devcons_read+0x6d>
	*(char*)vbuf = c;
  801c2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c2e:	89 c2                	mov    %eax,%edx
  801c30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c34:	88 10                	mov    %dl,(%rax)
	return 1;
  801c36:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c3b:	c9                   	leaveq 
  801c3c:	c3                   	retq   

0000000000801c3d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c3d:	55                   	push   %rbp
  801c3e:	48 89 e5             	mov    %rsp,%rbp
  801c41:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801c48:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  801c4f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801c56:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c64:	eb 76                	jmp    801cdc <devcons_write+0x9f>
		m = n - tot;
  801c66:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801c6d:	89 c2                	mov    %eax,%edx
  801c6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c72:	29 c2                	sub    %eax,%edx
  801c74:	89 d0                	mov    %edx,%eax
  801c76:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  801c79:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c7c:	83 f8 7f             	cmp    $0x7f,%eax
  801c7f:	76 07                	jbe    801c88 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  801c81:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  801c88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c8b:	48 63 d0             	movslq %eax,%rdx
  801c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c91:	48 63 c8             	movslq %eax,%rcx
  801c94:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801c9b:	48 01 c1             	add    %rax,%rcx
  801c9e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801ca5:	48 89 ce             	mov    %rcx,%rsi
  801ca8:	48 89 c7             	mov    %rax,%rdi
  801cab:	48 b8 4c 2e 80 00 00 	movabs $0x802e4c,%rax
  801cb2:	00 00 00 
  801cb5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  801cb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cba:	48 63 d0             	movslq %eax,%rdx
  801cbd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801cc4:	48 89 d6             	mov    %rdx,%rsi
  801cc7:	48 89 c7             	mov    %rax,%rdi
  801cca:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801cd1:	00 00 00 
  801cd4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cd9:	01 45 fc             	add    %eax,-0x4(%rbp)
  801cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cdf:	48 98                	cltq   
  801ce1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801ce8:	0f 82 78 ff ff ff    	jb     801c66 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801cee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801cf1:	c9                   	leaveq 
  801cf2:	c3                   	retq   

0000000000801cf3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801cf3:	55                   	push   %rbp
  801cf4:	48 89 e5             	mov    %rsp,%rbp
  801cf7:	48 83 ec 08          	sub    $0x8,%rsp
  801cfb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d04:	c9                   	leaveq 
  801d05:	c3                   	retq   

0000000000801d06 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d06:	55                   	push   %rbp
  801d07:	48 89 e5             	mov    %rsp,%rbp
  801d0a:	48 83 ec 10          	sub    $0x10,%rsp
  801d0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801d16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d1a:	48 be 3b 36 80 00 00 	movabs $0x80363b,%rsi
  801d21:	00 00 00 
  801d24:	48 89 c7             	mov    %rax,%rdi
  801d27:	48 b8 28 2b 80 00 00 	movabs $0x802b28,%rax
  801d2e:	00 00 00 
  801d31:	ff d0                	callq  *%rax
	return 0;
  801d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d38:	c9                   	leaveq 
  801d39:	c3                   	retq   

0000000000801d3a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801d3a:	55                   	push   %rbp
  801d3b:	48 89 e5             	mov    %rsp,%rbp
  801d3e:	53                   	push   %rbx
  801d3f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801d46:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801d4d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801d53:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801d5a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801d61:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801d68:	84 c0                	test   %al,%al
  801d6a:	74 23                	je     801d8f <_panic+0x55>
  801d6c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801d73:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801d77:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801d7b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801d7f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801d83:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801d87:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801d8b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801d8f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801d96:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801d9d:	00 00 00 
  801da0:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801da7:	00 00 00 
  801daa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801dae:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801db5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801dbc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801dc3:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  801dca:	00 00 00 
  801dcd:	48 8b 18             	mov    (%rax),%rbx
  801dd0:	48 b8 84 02 80 00 00 	movabs $0x800284,%rax
  801dd7:	00 00 00 
  801dda:	ff d0                	callq  *%rax
  801ddc:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801de2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801de9:	41 89 c8             	mov    %ecx,%r8d
  801dec:	48 89 d1             	mov    %rdx,%rcx
  801def:	48 89 da             	mov    %rbx,%rdx
  801df2:	89 c6                	mov    %eax,%esi
  801df4:	48 bf 48 36 80 00 00 	movabs $0x803648,%rdi
  801dfb:	00 00 00 
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801e03:	49 b9 73 1f 80 00 00 	movabs $0x801f73,%r9
  801e0a:	00 00 00 
  801e0d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e10:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801e17:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801e1e:	48 89 d6             	mov    %rdx,%rsi
  801e21:	48 89 c7             	mov    %rax,%rdi
  801e24:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  801e2b:	00 00 00 
  801e2e:	ff d0                	callq  *%rax
	cprintf("\n");
  801e30:	48 bf 6b 36 80 00 00 	movabs $0x80366b,%rdi
  801e37:	00 00 00 
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3f:	48 ba 73 1f 80 00 00 	movabs $0x801f73,%rdx
  801e46:	00 00 00 
  801e49:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e4b:	cc                   	int3   
  801e4c:	eb fd                	jmp    801e4b <_panic+0x111>

0000000000801e4e <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801e4e:	55                   	push   %rbp
  801e4f:	48 89 e5             	mov    %rsp,%rbp
  801e52:	48 83 ec 10          	sub    $0x10,%rsp
  801e56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801e5d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e61:	8b 00                	mov    (%rax),%eax
  801e63:	8d 48 01             	lea    0x1(%rax),%ecx
  801e66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e6a:	89 0a                	mov    %ecx,(%rdx)
  801e6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e6f:	89 d1                	mov    %edx,%ecx
  801e71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e75:	48 98                	cltq   
  801e77:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801e7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e7f:	8b 00                	mov    (%rax),%eax
  801e81:	3d ff 00 00 00       	cmp    $0xff,%eax
  801e86:	75 2c                	jne    801eb4 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801e88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e8c:	8b 00                	mov    (%rax),%eax
  801e8e:	48 98                	cltq   
  801e90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e94:	48 83 c2 08          	add    $0x8,%rdx
  801e98:	48 89 c6             	mov    %rax,%rsi
  801e9b:	48 89 d7             	mov    %rdx,%rdi
  801e9e:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801ea5:	00 00 00 
  801ea8:	ff d0                	callq  *%rax
        b->idx = 0;
  801eaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eae:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  801eb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb8:	8b 40 04             	mov    0x4(%rax),%eax
  801ebb:	8d 50 01             	lea    0x1(%rax),%edx
  801ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec2:	89 50 04             	mov    %edx,0x4(%rax)
}
  801ec5:	c9                   	leaveq 
  801ec6:	c3                   	retq   

0000000000801ec7 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  801ec7:	55                   	push   %rbp
  801ec8:	48 89 e5             	mov    %rsp,%rbp
  801ecb:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  801ed2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  801ed9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  801ee0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  801ee7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  801eee:	48 8b 0a             	mov    (%rdx),%rcx
  801ef1:	48 89 08             	mov    %rcx,(%rax)
  801ef4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801ef8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801efc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f00:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801f04:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801f0b:	00 00 00 
    b.cnt = 0;
  801f0e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801f15:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801f18:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801f1f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801f26:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801f2d:	48 89 c6             	mov    %rax,%rsi
  801f30:	48 bf 4e 1e 80 00 00 	movabs $0x801e4e,%rdi
  801f37:	00 00 00 
  801f3a:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  801f41:	00 00 00 
  801f44:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  801f46:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801f4c:	48 98                	cltq   
  801f4e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801f55:	48 83 c2 08          	add    $0x8,%rdx
  801f59:	48 89 c6             	mov    %rax,%rsi
  801f5c:	48 89 d7             	mov    %rdx,%rdi
  801f5f:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  801f6b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  801f71:	c9                   	leaveq 
  801f72:	c3                   	retq   

0000000000801f73 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  801f73:	55                   	push   %rbp
  801f74:	48 89 e5             	mov    %rsp,%rbp
  801f77:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801f7e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801f85:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  801f8c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801f93:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801f9a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801fa1:	84 c0                	test   %al,%al
  801fa3:	74 20                	je     801fc5 <cprintf+0x52>
  801fa5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801fa9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801fad:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801fb1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801fb5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801fb9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801fbd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801fc1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801fc5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  801fcc:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  801fd3:	00 00 00 
  801fd6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801fdd:	00 00 00 
  801fe0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801fe4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801feb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801ff2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  801ff9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802000:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802007:	48 8b 0a             	mov    (%rdx),%rcx
  80200a:	48 89 08             	mov    %rcx,(%rax)
  80200d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802011:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802015:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802019:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80201d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802024:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80202b:	48 89 d6             	mov    %rdx,%rsi
  80202e:	48 89 c7             	mov    %rax,%rdi
  802031:	48 b8 c7 1e 80 00 00 	movabs $0x801ec7,%rax
  802038:	00 00 00 
  80203b:	ff d0                	callq  *%rax
  80203d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802043:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802049:	c9                   	leaveq 
  80204a:	c3                   	retq   

000000000080204b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80204b:	55                   	push   %rbp
  80204c:	48 89 e5             	mov    %rsp,%rbp
  80204f:	53                   	push   %rbx
  802050:	48 83 ec 38          	sub    $0x38,%rsp
  802054:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802058:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80205c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802060:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  802063:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  802067:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80206b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80206e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802072:	77 3b                	ja     8020af <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802074:	8b 45 d0             	mov    -0x30(%rbp),%eax
  802077:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80207b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80207e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802082:	ba 00 00 00 00       	mov    $0x0,%edx
  802087:	48 f7 f3             	div    %rbx
  80208a:	48 89 c2             	mov    %rax,%rdx
  80208d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  802090:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  802093:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  802097:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209b:	41 89 f9             	mov    %edi,%r9d
  80209e:	48 89 c7             	mov    %rax,%rdi
  8020a1:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  8020a8:	00 00 00 
  8020ab:	ff d0                	callq  *%rax
  8020ad:	eb 1e                	jmp    8020cd <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8020af:	eb 12                	jmp    8020c3 <printnum+0x78>
			putch(padc, putdat);
  8020b1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8020b5:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8020b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020bc:	48 89 ce             	mov    %rcx,%rsi
  8020bf:	89 d7                	mov    %edx,%edi
  8020c1:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8020c3:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8020c7:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8020cb:	7f e4                	jg     8020b1 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8020cd:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8020d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d9:	48 f7 f1             	div    %rcx
  8020dc:	48 89 d0             	mov    %rdx,%rax
  8020df:	48 ba 70 38 80 00 00 	movabs $0x803870,%rdx
  8020e6:	00 00 00 
  8020e9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8020ed:	0f be d0             	movsbl %al,%edx
  8020f0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8020f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f8:	48 89 ce             	mov    %rcx,%rsi
  8020fb:	89 d7                	mov    %edx,%edi
  8020fd:	ff d0                	callq  *%rax
}
  8020ff:	48 83 c4 38          	add    $0x38,%rsp
  802103:	5b                   	pop    %rbx
  802104:	5d                   	pop    %rbp
  802105:	c3                   	retq   

0000000000802106 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802106:	55                   	push   %rbp
  802107:	48 89 e5             	mov    %rsp,%rbp
  80210a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80210e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802112:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802115:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802119:	7e 52                	jle    80216d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80211b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211f:	8b 00                	mov    (%rax),%eax
  802121:	83 f8 30             	cmp    $0x30,%eax
  802124:	73 24                	jae    80214a <getuint+0x44>
  802126:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80212a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80212e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802132:	8b 00                	mov    (%rax),%eax
  802134:	89 c0                	mov    %eax,%eax
  802136:	48 01 d0             	add    %rdx,%rax
  802139:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80213d:	8b 12                	mov    (%rdx),%edx
  80213f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802142:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802146:	89 0a                	mov    %ecx,(%rdx)
  802148:	eb 17                	jmp    802161 <getuint+0x5b>
  80214a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80214e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802152:	48 89 d0             	mov    %rdx,%rax
  802155:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802159:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80215d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802161:	48 8b 00             	mov    (%rax),%rax
  802164:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802168:	e9 a3 00 00 00       	jmpq   802210 <getuint+0x10a>
	else if (lflag)
  80216d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802171:	74 4f                	je     8021c2 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  802173:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802177:	8b 00                	mov    (%rax),%eax
  802179:	83 f8 30             	cmp    $0x30,%eax
  80217c:	73 24                	jae    8021a2 <getuint+0x9c>
  80217e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802182:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218a:	8b 00                	mov    (%rax),%eax
  80218c:	89 c0                	mov    %eax,%eax
  80218e:	48 01 d0             	add    %rdx,%rax
  802191:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802195:	8b 12                	mov    (%rdx),%edx
  802197:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80219a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80219e:	89 0a                	mov    %ecx,(%rdx)
  8021a0:	eb 17                	jmp    8021b9 <getuint+0xb3>
  8021a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021aa:	48 89 d0             	mov    %rdx,%rax
  8021ad:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8021b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8021b9:	48 8b 00             	mov    (%rax),%rax
  8021bc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8021c0:	eb 4e                	jmp    802210 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8021c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c6:	8b 00                	mov    (%rax),%eax
  8021c8:	83 f8 30             	cmp    $0x30,%eax
  8021cb:	73 24                	jae    8021f1 <getuint+0xeb>
  8021cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8021d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d9:	8b 00                	mov    (%rax),%eax
  8021db:	89 c0                	mov    %eax,%eax
  8021dd:	48 01 d0             	add    %rdx,%rax
  8021e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021e4:	8b 12                	mov    (%rdx),%edx
  8021e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8021e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8021ed:	89 0a                	mov    %ecx,(%rdx)
  8021ef:	eb 17                	jmp    802208 <getuint+0x102>
  8021f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8021f9:	48 89 d0             	mov    %rdx,%rax
  8021fc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802200:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802204:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802208:	8b 00                	mov    (%rax),%eax
  80220a:	89 c0                	mov    %eax,%eax
  80220c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802214:	c9                   	leaveq 
  802215:	c3                   	retq   

0000000000802216 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802216:	55                   	push   %rbp
  802217:	48 89 e5             	mov    %rsp,%rbp
  80221a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80221e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802222:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802225:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802229:	7e 52                	jle    80227d <getint+0x67>
		x=va_arg(*ap, long long);
  80222b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222f:	8b 00                	mov    (%rax),%eax
  802231:	83 f8 30             	cmp    $0x30,%eax
  802234:	73 24                	jae    80225a <getint+0x44>
  802236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80223e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802242:	8b 00                	mov    (%rax),%eax
  802244:	89 c0                	mov    %eax,%eax
  802246:	48 01 d0             	add    %rdx,%rax
  802249:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80224d:	8b 12                	mov    (%rdx),%edx
  80224f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802252:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802256:	89 0a                	mov    %ecx,(%rdx)
  802258:	eb 17                	jmp    802271 <getint+0x5b>
  80225a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802262:	48 89 d0             	mov    %rdx,%rax
  802265:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802269:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80226d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802271:	48 8b 00             	mov    (%rax),%rax
  802274:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802278:	e9 a3 00 00 00       	jmpq   802320 <getint+0x10a>
	else if (lflag)
  80227d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802281:	74 4f                	je     8022d2 <getint+0xbc>
		x=va_arg(*ap, long);
  802283:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802287:	8b 00                	mov    (%rax),%eax
  802289:	83 f8 30             	cmp    $0x30,%eax
  80228c:	73 24                	jae    8022b2 <getint+0x9c>
  80228e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802292:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802296:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80229a:	8b 00                	mov    (%rax),%eax
  80229c:	89 c0                	mov    %eax,%eax
  80229e:	48 01 d0             	add    %rdx,%rax
  8022a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022a5:	8b 12                	mov    (%rdx),%edx
  8022a7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ae:	89 0a                	mov    %ecx,(%rdx)
  8022b0:	eb 17                	jmp    8022c9 <getint+0xb3>
  8022b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8022ba:	48 89 d0             	mov    %rdx,%rax
  8022bd:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8022c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022c5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8022c9:	48 8b 00             	mov    (%rax),%rax
  8022cc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8022d0:	eb 4e                	jmp    802320 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8022d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d6:	8b 00                	mov    (%rax),%eax
  8022d8:	83 f8 30             	cmp    $0x30,%eax
  8022db:	73 24                	jae    802301 <getint+0xeb>
  8022dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e9:	8b 00                	mov    (%rax),%eax
  8022eb:	89 c0                	mov    %eax,%eax
  8022ed:	48 01 d0             	add    %rdx,%rax
  8022f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022f4:	8b 12                	mov    (%rdx),%edx
  8022f6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8022f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022fd:	89 0a                	mov    %ecx,(%rdx)
  8022ff:	eb 17                	jmp    802318 <getint+0x102>
  802301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802305:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802309:	48 89 d0             	mov    %rdx,%rax
  80230c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  802310:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802314:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802318:	8b 00                	mov    (%rax),%eax
  80231a:	48 98                	cltq   
  80231c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802324:	c9                   	leaveq 
  802325:	c3                   	retq   

0000000000802326 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802326:	55                   	push   %rbp
  802327:	48 89 e5             	mov    %rsp,%rbp
  80232a:	41 54                	push   %r12
  80232c:	53                   	push   %rbx
  80232d:	48 83 ec 60          	sub    $0x60,%rsp
  802331:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802335:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802339:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80233d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802341:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802345:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802349:	48 8b 0a             	mov    (%rdx),%rcx
  80234c:	48 89 08             	mov    %rcx,(%rax)
  80234f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802353:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802357:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80235b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80235f:	eb 17                	jmp    802378 <vprintfmt+0x52>
			if (ch == '\0')
  802361:	85 db                	test   %ebx,%ebx
  802363:	0f 84 cc 04 00 00    	je     802835 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  802369:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80236d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802371:	48 89 d6             	mov    %rdx,%rsi
  802374:	89 df                	mov    %ebx,%edi
  802376:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802378:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80237c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802380:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802384:	0f b6 00             	movzbl (%rax),%eax
  802387:	0f b6 d8             	movzbl %al,%ebx
  80238a:	83 fb 25             	cmp    $0x25,%ebx
  80238d:	75 d2                	jne    802361 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80238f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802393:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80239a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8023a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8023a8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8023af:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8023b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8023b7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8023bb:	0f b6 00             	movzbl (%rax),%eax
  8023be:	0f b6 d8             	movzbl %al,%ebx
  8023c1:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8023c4:	83 f8 55             	cmp    $0x55,%eax
  8023c7:	0f 87 34 04 00 00    	ja     802801 <vprintfmt+0x4db>
  8023cd:	89 c0                	mov    %eax,%eax
  8023cf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8023d6:	00 
  8023d7:	48 b8 98 38 80 00 00 	movabs $0x803898,%rax
  8023de:	00 00 00 
  8023e1:	48 01 d0             	add    %rdx,%rax
  8023e4:	48 8b 00             	mov    (%rax),%rax
  8023e7:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8023e9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8023ed:	eb c0                	jmp    8023af <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8023ef:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8023f3:	eb ba                	jmp    8023af <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8023f5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8023fc:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8023ff:	89 d0                	mov    %edx,%eax
  802401:	c1 e0 02             	shl    $0x2,%eax
  802404:	01 d0                	add    %edx,%eax
  802406:	01 c0                	add    %eax,%eax
  802408:	01 d8                	add    %ebx,%eax
  80240a:	83 e8 30             	sub    $0x30,%eax
  80240d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802410:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802414:	0f b6 00             	movzbl (%rax),%eax
  802417:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80241a:	83 fb 2f             	cmp    $0x2f,%ebx
  80241d:	7e 0c                	jle    80242b <vprintfmt+0x105>
  80241f:	83 fb 39             	cmp    $0x39,%ebx
  802422:	7f 07                	jg     80242b <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802424:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802429:	eb d1                	jmp    8023fc <vprintfmt+0xd6>
			goto process_precision;
  80242b:	eb 58                	jmp    802485 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80242d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802430:	83 f8 30             	cmp    $0x30,%eax
  802433:	73 17                	jae    80244c <vprintfmt+0x126>
  802435:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802439:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80243c:	89 c0                	mov    %eax,%eax
  80243e:	48 01 d0             	add    %rdx,%rax
  802441:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802444:	83 c2 08             	add    $0x8,%edx
  802447:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80244a:	eb 0f                	jmp    80245b <vprintfmt+0x135>
  80244c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802450:	48 89 d0             	mov    %rdx,%rax
  802453:	48 83 c2 08          	add    $0x8,%rdx
  802457:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80245b:	8b 00                	mov    (%rax),%eax
  80245d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802460:	eb 23                	jmp    802485 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  802462:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802466:	79 0c                	jns    802474 <vprintfmt+0x14e>
				width = 0;
  802468:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80246f:	e9 3b ff ff ff       	jmpq   8023af <vprintfmt+0x89>
  802474:	e9 36 ff ff ff       	jmpq   8023af <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802479:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802480:	e9 2a ff ff ff       	jmpq   8023af <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  802485:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802489:	79 12                	jns    80249d <vprintfmt+0x177>
				width = precision, precision = -1;
  80248b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80248e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802491:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802498:	e9 12 ff ff ff       	jmpq   8023af <vprintfmt+0x89>
  80249d:	e9 0d ff ff ff       	jmpq   8023af <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8024a2:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8024a6:	e9 04 ff ff ff       	jmpq   8023af <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8024ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024ae:	83 f8 30             	cmp    $0x30,%eax
  8024b1:	73 17                	jae    8024ca <vprintfmt+0x1a4>
  8024b3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024b7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024ba:	89 c0                	mov    %eax,%eax
  8024bc:	48 01 d0             	add    %rdx,%rax
  8024bf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8024c2:	83 c2 08             	add    $0x8,%edx
  8024c5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8024c8:	eb 0f                	jmp    8024d9 <vprintfmt+0x1b3>
  8024ca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8024ce:	48 89 d0             	mov    %rdx,%rax
  8024d1:	48 83 c2 08          	add    $0x8,%rdx
  8024d5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8024d9:	8b 10                	mov    (%rax),%edx
  8024db:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8024df:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8024e3:	48 89 ce             	mov    %rcx,%rsi
  8024e6:	89 d7                	mov    %edx,%edi
  8024e8:	ff d0                	callq  *%rax
			break;
  8024ea:	e9 40 03 00 00       	jmpq   80282f <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8024ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024f2:	83 f8 30             	cmp    $0x30,%eax
  8024f5:	73 17                	jae    80250e <vprintfmt+0x1e8>
  8024f7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8024fe:	89 c0                	mov    %eax,%eax
  802500:	48 01 d0             	add    %rdx,%rax
  802503:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802506:	83 c2 08             	add    $0x8,%edx
  802509:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80250c:	eb 0f                	jmp    80251d <vprintfmt+0x1f7>
  80250e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802512:	48 89 d0             	mov    %rdx,%rax
  802515:	48 83 c2 08          	add    $0x8,%rdx
  802519:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80251d:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80251f:	85 db                	test   %ebx,%ebx
  802521:	79 02                	jns    802525 <vprintfmt+0x1ff>
				err = -err;
  802523:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  802525:	83 fb 15             	cmp    $0x15,%ebx
  802528:	7f 16                	jg     802540 <vprintfmt+0x21a>
  80252a:	48 b8 c0 37 80 00 00 	movabs $0x8037c0,%rax
  802531:	00 00 00 
  802534:	48 63 d3             	movslq %ebx,%rdx
  802537:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80253b:	4d 85 e4             	test   %r12,%r12
  80253e:	75 2e                	jne    80256e <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  802540:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802544:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802548:	89 d9                	mov    %ebx,%ecx
  80254a:	48 ba 81 38 80 00 00 	movabs $0x803881,%rdx
  802551:	00 00 00 
  802554:	48 89 c7             	mov    %rax,%rdi
  802557:	b8 00 00 00 00       	mov    $0x0,%eax
  80255c:	49 b8 3e 28 80 00 00 	movabs $0x80283e,%r8
  802563:	00 00 00 
  802566:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  802569:	e9 c1 02 00 00       	jmpq   80282f <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80256e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  802572:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802576:	4c 89 e1             	mov    %r12,%rcx
  802579:	48 ba 8a 38 80 00 00 	movabs $0x80388a,%rdx
  802580:	00 00 00 
  802583:	48 89 c7             	mov    %rax,%rdi
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
  80258b:	49 b8 3e 28 80 00 00 	movabs $0x80283e,%r8
  802592:	00 00 00 
  802595:	41 ff d0             	callq  *%r8
			break;
  802598:	e9 92 02 00 00       	jmpq   80282f <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80259d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025a0:	83 f8 30             	cmp    $0x30,%eax
  8025a3:	73 17                	jae    8025bc <vprintfmt+0x296>
  8025a5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8025ac:	89 c0                	mov    %eax,%eax
  8025ae:	48 01 d0             	add    %rdx,%rax
  8025b1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8025b4:	83 c2 08             	add    $0x8,%edx
  8025b7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8025ba:	eb 0f                	jmp    8025cb <vprintfmt+0x2a5>
  8025bc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8025c0:	48 89 d0             	mov    %rdx,%rax
  8025c3:	48 83 c2 08          	add    $0x8,%rdx
  8025c7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8025cb:	4c 8b 20             	mov    (%rax),%r12
  8025ce:	4d 85 e4             	test   %r12,%r12
  8025d1:	75 0a                	jne    8025dd <vprintfmt+0x2b7>
				p = "(null)";
  8025d3:	49 bc 8d 38 80 00 00 	movabs $0x80388d,%r12
  8025da:	00 00 00 
			if (width > 0 && padc != '-')
  8025dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8025e1:	7e 3f                	jle    802622 <vprintfmt+0x2fc>
  8025e3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8025e7:	74 39                	je     802622 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8025e9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8025ec:	48 98                	cltq   
  8025ee:	48 89 c6             	mov    %rax,%rsi
  8025f1:	4c 89 e7             	mov    %r12,%rdi
  8025f4:	48 b8 ea 2a 80 00 00 	movabs $0x802aea,%rax
  8025fb:	00 00 00 
  8025fe:	ff d0                	callq  *%rax
  802600:	29 45 dc             	sub    %eax,-0x24(%rbp)
  802603:	eb 17                	jmp    80261c <vprintfmt+0x2f6>
					putch(padc, putdat);
  802605:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  802609:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80260d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802611:	48 89 ce             	mov    %rcx,%rsi
  802614:	89 d7                	mov    %edx,%edi
  802616:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802618:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80261c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802620:	7f e3                	jg     802605 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802622:	eb 37                	jmp    80265b <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  802624:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  802628:	74 1e                	je     802648 <vprintfmt+0x322>
  80262a:	83 fb 1f             	cmp    $0x1f,%ebx
  80262d:	7e 05                	jle    802634 <vprintfmt+0x30e>
  80262f:	83 fb 7e             	cmp    $0x7e,%ebx
  802632:	7e 14                	jle    802648 <vprintfmt+0x322>
					putch('?', putdat);
  802634:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802638:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80263c:	48 89 d6             	mov    %rdx,%rsi
  80263f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  802644:	ff d0                	callq  *%rax
  802646:	eb 0f                	jmp    802657 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  802648:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80264c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802650:	48 89 d6             	mov    %rdx,%rsi
  802653:	89 df                	mov    %ebx,%edi
  802655:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802657:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80265b:	4c 89 e0             	mov    %r12,%rax
  80265e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  802662:	0f b6 00             	movzbl (%rax),%eax
  802665:	0f be d8             	movsbl %al,%ebx
  802668:	85 db                	test   %ebx,%ebx
  80266a:	74 10                	je     80267c <vprintfmt+0x356>
  80266c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802670:	78 b2                	js     802624 <vprintfmt+0x2fe>
  802672:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  802676:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80267a:	79 a8                	jns    802624 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80267c:	eb 16                	jmp    802694 <vprintfmt+0x36e>
				putch(' ', putdat);
  80267e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802682:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802686:	48 89 d6             	mov    %rdx,%rsi
  802689:	bf 20 00 00 00       	mov    $0x20,%edi
  80268e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802690:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  802694:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802698:	7f e4                	jg     80267e <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80269a:	e9 90 01 00 00       	jmpq   80282f <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80269f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8026a3:	be 03 00 00 00       	mov    $0x3,%esi
  8026a8:	48 89 c7             	mov    %rax,%rdi
  8026ab:	48 b8 16 22 80 00 00 	movabs $0x802216,%rax
  8026b2:	00 00 00 
  8026b5:	ff d0                	callq  *%rax
  8026b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8026bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026bf:	48 85 c0             	test   %rax,%rax
  8026c2:	79 1d                	jns    8026e1 <vprintfmt+0x3bb>
				putch('-', putdat);
  8026c4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8026c8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8026cc:	48 89 d6             	mov    %rdx,%rsi
  8026cf:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8026d4:	ff d0                	callq  *%rax
				num = -(long long) num;
  8026d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026da:	48 f7 d8             	neg    %rax
  8026dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8026e1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8026e8:	e9 d5 00 00 00       	jmpq   8027c2 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8026ed:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8026f1:	be 03 00 00 00       	mov    $0x3,%esi
  8026f6:	48 89 c7             	mov    %rax,%rdi
  8026f9:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802700:	00 00 00 
  802703:	ff d0                	callq  *%rax
  802705:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  802709:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  802710:	e9 ad 00 00 00       	jmpq   8027c2 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  802715:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802719:	be 03 00 00 00       	mov    $0x3,%esi
  80271e:	48 89 c7             	mov    %rax,%rdi
  802721:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  802728:	00 00 00 
  80272b:	ff d0                	callq  *%rax
  80272d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  802731:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  802738:	e9 85 00 00 00       	jmpq   8027c2 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  80273d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802741:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802745:	48 89 d6             	mov    %rdx,%rsi
  802748:	bf 30 00 00 00       	mov    $0x30,%edi
  80274d:	ff d0                	callq  *%rax
			putch('x', putdat);
  80274f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802753:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802757:	48 89 d6             	mov    %rdx,%rsi
  80275a:	bf 78 00 00 00       	mov    $0x78,%edi
  80275f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  802761:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802764:	83 f8 30             	cmp    $0x30,%eax
  802767:	73 17                	jae    802780 <vprintfmt+0x45a>
  802769:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80276d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802770:	89 c0                	mov    %eax,%eax
  802772:	48 01 d0             	add    %rdx,%rax
  802775:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802778:	83 c2 08             	add    $0x8,%edx
  80277b:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80277e:	eb 0f                	jmp    80278f <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  802780:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802784:	48 89 d0             	mov    %rdx,%rax
  802787:	48 83 c2 08          	add    $0x8,%rdx
  80278b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80278f:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802792:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  802796:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80279d:	eb 23                	jmp    8027c2 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80279f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8027a3:	be 03 00 00 00       	mov    $0x3,%esi
  8027a8:	48 89 c7             	mov    %rax,%rdi
  8027ab:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  8027b2:	00 00 00 
  8027b5:	ff d0                	callq  *%rax
  8027b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8027bb:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8027c2:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8027c7:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8027ca:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8027cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027d1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8027d5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027d9:	45 89 c1             	mov    %r8d,%r9d
  8027dc:	41 89 f8             	mov    %edi,%r8d
  8027df:	48 89 c7             	mov    %rax,%rdi
  8027e2:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  8027e9:	00 00 00 
  8027ec:	ff d0                	callq  *%rax
			break;
  8027ee:	eb 3f                	jmp    80282f <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8027f0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8027f4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8027f8:	48 89 d6             	mov    %rdx,%rsi
  8027fb:	89 df                	mov    %ebx,%edi
  8027fd:	ff d0                	callq  *%rax
			break;
  8027ff:	eb 2e                	jmp    80282f <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802801:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802805:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802809:	48 89 d6             	mov    %rdx,%rsi
  80280c:	bf 25 00 00 00       	mov    $0x25,%edi
  802811:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  802813:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  802818:	eb 05                	jmp    80281f <vprintfmt+0x4f9>
  80281a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80281f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802823:	48 83 e8 01          	sub    $0x1,%rax
  802827:	0f b6 00             	movzbl (%rax),%eax
  80282a:	3c 25                	cmp    $0x25,%al
  80282c:	75 ec                	jne    80281a <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80282e:	90                   	nop
		}
	}
  80282f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802830:	e9 43 fb ff ff       	jmpq   802378 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  802835:	48 83 c4 60          	add    $0x60,%rsp
  802839:	5b                   	pop    %rbx
  80283a:	41 5c                	pop    %r12
  80283c:	5d                   	pop    %rbp
  80283d:	c3                   	retq   

000000000080283e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80283e:	55                   	push   %rbp
  80283f:	48 89 e5             	mov    %rsp,%rbp
  802842:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  802849:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  802850:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  802857:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80285e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802865:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80286c:	84 c0                	test   %al,%al
  80286e:	74 20                	je     802890 <printfmt+0x52>
  802870:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802874:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802878:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80287c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802880:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802884:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802888:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80288c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802890:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  802897:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80289e:	00 00 00 
  8028a1:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8028a8:	00 00 00 
  8028ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8028af:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8028b6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8028bd:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8028c4:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8028cb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8028d2:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8028d9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8028e0:	48 89 c7             	mov    %rax,%rdi
  8028e3:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	callq  *%rax
	va_end(ap);
}
  8028ef:	c9                   	leaveq 
  8028f0:	c3                   	retq   

00000000008028f1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8028f1:	55                   	push   %rbp
  8028f2:	48 89 e5             	mov    %rsp,%rbp
  8028f5:	48 83 ec 10          	sub    $0x10,%rsp
  8028f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8028fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  802900:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802904:	8b 40 10             	mov    0x10(%rax),%eax
  802907:	8d 50 01             	lea    0x1(%rax),%edx
  80290a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  802911:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802915:	48 8b 10             	mov    (%rax),%rdx
  802918:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291c:	48 8b 40 08          	mov    0x8(%rax),%rax
  802920:	48 39 c2             	cmp    %rax,%rdx
  802923:	73 17                	jae    80293c <sprintputch+0x4b>
		*b->buf++ = ch;
  802925:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802929:	48 8b 00             	mov    (%rax),%rax
  80292c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  802930:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802934:	48 89 0a             	mov    %rcx,(%rdx)
  802937:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80293a:	88 10                	mov    %dl,(%rax)
}
  80293c:	c9                   	leaveq 
  80293d:	c3                   	retq   

000000000080293e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80293e:	55                   	push   %rbp
  80293f:	48 89 e5             	mov    %rsp,%rbp
  802942:	48 83 ec 50          	sub    $0x50,%rsp
  802946:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80294a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80294d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  802951:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  802955:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802959:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80295d:	48 8b 0a             	mov    (%rdx),%rcx
  802960:	48 89 08             	mov    %rcx,(%rax)
  802963:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802967:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80296b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80296f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  802973:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802977:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80297b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80297e:	48 98                	cltq   
  802980:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802984:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802988:	48 01 d0             	add    %rdx,%rax
  80298b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80298f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  802996:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80299b:	74 06                	je     8029a3 <vsnprintf+0x65>
  80299d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8029a1:	7f 07                	jg     8029aa <vsnprintf+0x6c>
		return -E_INVAL;
  8029a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029a8:	eb 2f                	jmp    8029d9 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8029aa:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8029ae:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8029b2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8029b6:	48 89 c6             	mov    %rax,%rsi
  8029b9:	48 bf f1 28 80 00 00 	movabs $0x8028f1,%rdi
  8029c0:	00 00 00 
  8029c3:	48 b8 26 23 80 00 00 	movabs $0x802326,%rax
  8029ca:	00 00 00 
  8029cd:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8029cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029d3:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8029d6:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8029d9:	c9                   	leaveq 
  8029da:	c3                   	retq   

00000000008029db <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8029db:	55                   	push   %rbp
  8029dc:	48 89 e5             	mov    %rsp,%rbp
  8029df:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8029e6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8029ed:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8029f3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8029fa:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802a01:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802a08:	84 c0                	test   %al,%al
  802a0a:	74 20                	je     802a2c <snprintf+0x51>
  802a0c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802a10:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802a14:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802a18:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802a1c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802a20:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802a24:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802a28:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802a2c:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  802a33:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802a3a:	00 00 00 
  802a3d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802a44:	00 00 00 
  802a47:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802a4b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802a52:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802a59:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802a60:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802a67:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802a6e:	48 8b 0a             	mov    (%rdx),%rcx
  802a71:	48 89 08             	mov    %rcx,(%rax)
  802a74:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a78:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a7c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a80:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802a84:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802a8b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802a92:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802a98:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802a9f:	48 89 c7             	mov    %rax,%rdi
  802aa2:	48 b8 3e 29 80 00 00 	movabs $0x80293e,%rax
  802aa9:	00 00 00 
  802aac:	ff d0                	callq  *%rax
  802aae:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802ab4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802aba:	c9                   	leaveq 
  802abb:	c3                   	retq   

0000000000802abc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802abc:	55                   	push   %rbp
  802abd:	48 89 e5             	mov    %rsp,%rbp
  802ac0:	48 83 ec 18          	sub    $0x18,%rsp
  802ac4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  802ac8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802acf:	eb 09                	jmp    802ada <strlen+0x1e>
		n++;
  802ad1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802ad5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ade:	0f b6 00             	movzbl (%rax),%eax
  802ae1:	84 c0                	test   %al,%al
  802ae3:	75 ec                	jne    802ad1 <strlen+0x15>
		n++;
	return n;
  802ae5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802ae8:	c9                   	leaveq 
  802ae9:	c3                   	retq   

0000000000802aea <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802aea:	55                   	push   %rbp
  802aeb:	48 89 e5             	mov    %rsp,%rbp
  802aee:	48 83 ec 20          	sub    $0x20,%rsp
  802af2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802af6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802afa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b01:	eb 0e                	jmp    802b11 <strnlen+0x27>
		n++;
  802b03:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802b07:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802b0c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802b11:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802b16:	74 0b                	je     802b23 <strnlen+0x39>
  802b18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b1c:	0f b6 00             	movzbl (%rax),%eax
  802b1f:	84 c0                	test   %al,%al
  802b21:	75 e0                	jne    802b03 <strnlen+0x19>
		n++;
	return n;
  802b23:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802b26:	c9                   	leaveq 
  802b27:	c3                   	retq   

0000000000802b28 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802b28:	55                   	push   %rbp
  802b29:	48 89 e5             	mov    %rsp,%rbp
  802b2c:	48 83 ec 20          	sub    $0x20,%rsp
  802b30:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  802b38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802b40:	90                   	nop
  802b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b45:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802b49:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802b4d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b51:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802b55:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802b59:	0f b6 12             	movzbl (%rdx),%edx
  802b5c:	88 10                	mov    %dl,(%rax)
  802b5e:	0f b6 00             	movzbl (%rax),%eax
  802b61:	84 c0                	test   %al,%al
  802b63:	75 dc                	jne    802b41 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802b65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802b69:	c9                   	leaveq 
  802b6a:	c3                   	retq   

0000000000802b6b <strcat>:

char *
strcat(char *dst, const char *src)
{
  802b6b:	55                   	push   %rbp
  802b6c:	48 89 e5             	mov    %rsp,%rbp
  802b6f:	48 83 ec 20          	sub    $0x20,%rsp
  802b73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b77:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  802b7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7f:	48 89 c7             	mov    %rax,%rdi
  802b82:	48 b8 bc 2a 80 00 00 	movabs $0x802abc,%rax
  802b89:	00 00 00 
  802b8c:	ff d0                	callq  *%rax
  802b8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  802b91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b94:	48 63 d0             	movslq %eax,%rdx
  802b97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b9b:	48 01 c2             	add    %rax,%rdx
  802b9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ba2:	48 89 c6             	mov    %rax,%rsi
  802ba5:	48 89 d7             	mov    %rdx,%rdi
  802ba8:	48 b8 28 2b 80 00 00 	movabs $0x802b28,%rax
  802baf:	00 00 00 
  802bb2:	ff d0                	callq  *%rax
	return dst;
  802bb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802bb8:	c9                   	leaveq 
  802bb9:	c3                   	retq   

0000000000802bba <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802bba:	55                   	push   %rbp
  802bbb:	48 89 e5             	mov    %rsp,%rbp
  802bbe:	48 83 ec 28          	sub    $0x28,%rsp
  802bc2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bc6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802bce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bd2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  802bd6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802bdd:	00 
  802bde:	eb 2a                	jmp    802c0a <strncpy+0x50>
		*dst++ = *src;
  802be0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802be8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802bec:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802bf0:	0f b6 12             	movzbl (%rdx),%edx
  802bf3:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802bf5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf9:	0f b6 00             	movzbl (%rax),%eax
  802bfc:	84 c0                	test   %al,%al
  802bfe:	74 05                	je     802c05 <strncpy+0x4b>
			src++;
  802c00:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802c05:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802c0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c0e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c12:	72 cc                	jb     802be0 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802c14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802c18:	c9                   	leaveq 
  802c19:	c3                   	retq   

0000000000802c1a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802c1a:	55                   	push   %rbp
  802c1b:	48 89 e5             	mov    %rsp,%rbp
  802c1e:	48 83 ec 28          	sub    $0x28,%rsp
  802c22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c26:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c2a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802c2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802c36:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c3b:	74 3d                	je     802c7a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802c3d:	eb 1d                	jmp    802c5c <strlcpy+0x42>
			*dst++ = *src++;
  802c3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c43:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802c47:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802c4b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c4f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802c53:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802c57:	0f b6 12             	movzbl (%rdx),%edx
  802c5a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802c5c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802c61:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c66:	74 0b                	je     802c73 <strlcpy+0x59>
  802c68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c6c:	0f b6 00             	movzbl (%rax),%eax
  802c6f:	84 c0                	test   %al,%al
  802c71:	75 cc                	jne    802c3f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802c73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c77:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  802c7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c82:	48 29 c2             	sub    %rax,%rdx
  802c85:	48 89 d0             	mov    %rdx,%rax
}
  802c88:	c9                   	leaveq 
  802c89:	c3                   	retq   

0000000000802c8a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802c8a:	55                   	push   %rbp
  802c8b:	48 89 e5             	mov    %rsp,%rbp
  802c8e:	48 83 ec 10          	sub    $0x10,%rsp
  802c92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c96:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  802c9a:	eb 0a                	jmp    802ca6 <strcmp+0x1c>
		p++, q++;
  802c9c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802ca1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802ca6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802caa:	0f b6 00             	movzbl (%rax),%eax
  802cad:	84 c0                	test   %al,%al
  802caf:	74 12                	je     802cc3 <strcmp+0x39>
  802cb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb5:	0f b6 10             	movzbl (%rax),%edx
  802cb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbc:	0f b6 00             	movzbl (%rax),%eax
  802cbf:	38 c2                	cmp    %al,%dl
  802cc1:	74 d9                	je     802c9c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802cc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cc7:	0f b6 00             	movzbl (%rax),%eax
  802cca:	0f b6 d0             	movzbl %al,%edx
  802ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd1:	0f b6 00             	movzbl (%rax),%eax
  802cd4:	0f b6 c0             	movzbl %al,%eax
  802cd7:	29 c2                	sub    %eax,%edx
  802cd9:	89 d0                	mov    %edx,%eax
}
  802cdb:	c9                   	leaveq 
  802cdc:	c3                   	retq   

0000000000802cdd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802cdd:	55                   	push   %rbp
  802cde:	48 89 e5             	mov    %rsp,%rbp
  802ce1:	48 83 ec 18          	sub    $0x18,%rsp
  802ce5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802ce9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802ced:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802cf1:	eb 0f                	jmp    802d02 <strncmp+0x25>
		n--, p++, q++;
  802cf3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  802cf8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802cfd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802d02:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d07:	74 1d                	je     802d26 <strncmp+0x49>
  802d09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d0d:	0f b6 00             	movzbl (%rax),%eax
  802d10:	84 c0                	test   %al,%al
  802d12:	74 12                	je     802d26 <strncmp+0x49>
  802d14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d18:	0f b6 10             	movzbl (%rax),%edx
  802d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d1f:	0f b6 00             	movzbl (%rax),%eax
  802d22:	38 c2                	cmp    %al,%dl
  802d24:	74 cd                	je     802cf3 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802d26:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d2b:	75 07                	jne    802d34 <strncmp+0x57>
		return 0;
  802d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d32:	eb 18                	jmp    802d4c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802d34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d38:	0f b6 00             	movzbl (%rax),%eax
  802d3b:	0f b6 d0             	movzbl %al,%edx
  802d3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d42:	0f b6 00             	movzbl (%rax),%eax
  802d45:	0f b6 c0             	movzbl %al,%eax
  802d48:	29 c2                	sub    %eax,%edx
  802d4a:	89 d0                	mov    %edx,%eax
}
  802d4c:	c9                   	leaveq 
  802d4d:	c3                   	retq   

0000000000802d4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802d4e:	55                   	push   %rbp
  802d4f:	48 89 e5             	mov    %rsp,%rbp
  802d52:	48 83 ec 0c          	sub    $0xc,%rsp
  802d56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d5a:	89 f0                	mov    %esi,%eax
  802d5c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802d5f:	eb 17                	jmp    802d78 <strchr+0x2a>
		if (*s == c)
  802d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d65:	0f b6 00             	movzbl (%rax),%eax
  802d68:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802d6b:	75 06                	jne    802d73 <strchr+0x25>
			return (char *) s;
  802d6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d71:	eb 15                	jmp    802d88 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802d73:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d7c:	0f b6 00             	movzbl (%rax),%eax
  802d7f:	84 c0                	test   %al,%al
  802d81:	75 de                	jne    802d61 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  802d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d88:	c9                   	leaveq 
  802d89:	c3                   	retq   

0000000000802d8a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802d8a:	55                   	push   %rbp
  802d8b:	48 89 e5             	mov    %rsp,%rbp
  802d8e:	48 83 ec 0c          	sub    $0xc,%rsp
  802d92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802d96:	89 f0                	mov    %esi,%eax
  802d98:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802d9b:	eb 13                	jmp    802db0 <strfind+0x26>
		if (*s == c)
  802d9d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802da1:	0f b6 00             	movzbl (%rax),%eax
  802da4:	3a 45 f4             	cmp    -0xc(%rbp),%al
  802da7:	75 02                	jne    802dab <strfind+0x21>
			break;
  802da9:	eb 10                	jmp    802dbb <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802dab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802db0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db4:	0f b6 00             	movzbl (%rax),%eax
  802db7:	84 c0                	test   %al,%al
  802db9:	75 e2                	jne    802d9d <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  802dbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802dbf:	c9                   	leaveq 
  802dc0:	c3                   	retq   

0000000000802dc1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802dc1:	55                   	push   %rbp
  802dc2:	48 89 e5             	mov    %rsp,%rbp
  802dc5:	48 83 ec 18          	sub    $0x18,%rsp
  802dc9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dcd:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802dd0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  802dd4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802dd9:	75 06                	jne    802de1 <memset+0x20>
		return v;
  802ddb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ddf:	eb 69                	jmp    802e4a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802de1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802de5:	83 e0 03             	and    $0x3,%eax
  802de8:	48 85 c0             	test   %rax,%rax
  802deb:	75 48                	jne    802e35 <memset+0x74>
  802ded:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802df1:	83 e0 03             	and    $0x3,%eax
  802df4:	48 85 c0             	test   %rax,%rax
  802df7:	75 3c                	jne    802e35 <memset+0x74>
		c &= 0xFF;
  802df9:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802e00:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e03:	c1 e0 18             	shl    $0x18,%eax
  802e06:	89 c2                	mov    %eax,%edx
  802e08:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e0b:	c1 e0 10             	shl    $0x10,%eax
  802e0e:	09 c2                	or     %eax,%edx
  802e10:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e13:	c1 e0 08             	shl    $0x8,%eax
  802e16:	09 d0                	or     %edx,%eax
  802e18:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802e1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e1f:	48 c1 e8 02          	shr    $0x2,%rax
  802e23:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802e26:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e2a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e2d:	48 89 d7             	mov    %rdx,%rdi
  802e30:	fc                   	cld    
  802e31:	f3 ab                	rep stos %eax,%es:(%rdi)
  802e33:	eb 11                	jmp    802e46 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802e35:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e39:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e3c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e40:	48 89 d7             	mov    %rdx,%rdi
  802e43:	fc                   	cld    
  802e44:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802e46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e4a:	c9                   	leaveq 
  802e4b:	c3                   	retq   

0000000000802e4c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802e4c:	55                   	push   %rbp
  802e4d:	48 89 e5             	mov    %rsp,%rbp
  802e50:	48 83 ec 28          	sub    $0x28,%rsp
  802e54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e5c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802e60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e64:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  802e68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802e70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e74:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802e78:	0f 83 88 00 00 00    	jae    802f06 <memmove+0xba>
  802e7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e82:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e86:	48 01 d0             	add    %rdx,%rax
  802e89:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  802e8d:	76 77                	jbe    802f06 <memmove+0xba>
		s += n;
  802e8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e93:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  802e97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e9b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802e9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea3:	83 e0 03             	and    $0x3,%eax
  802ea6:	48 85 c0             	test   %rax,%rax
  802ea9:	75 3b                	jne    802ee6 <memmove+0x9a>
  802eab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eaf:	83 e0 03             	and    $0x3,%eax
  802eb2:	48 85 c0             	test   %rax,%rax
  802eb5:	75 2f                	jne    802ee6 <memmove+0x9a>
  802eb7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ebb:	83 e0 03             	and    $0x3,%eax
  802ebe:	48 85 c0             	test   %rax,%rax
  802ec1:	75 23                	jne    802ee6 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec7:	48 83 e8 04          	sub    $0x4,%rax
  802ecb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ecf:	48 83 ea 04          	sub    $0x4,%rdx
  802ed3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802ed7:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802edb:	48 89 c7             	mov    %rax,%rdi
  802ede:	48 89 d6             	mov    %rdx,%rsi
  802ee1:	fd                   	std    
  802ee2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802ee4:	eb 1d                	jmp    802f03 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802ee6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eea:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802eee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ef2:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802ef6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802efa:	48 89 d7             	mov    %rdx,%rdi
  802efd:	48 89 c1             	mov    %rax,%rcx
  802f00:	fd                   	std    
  802f01:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802f03:	fc                   	cld    
  802f04:	eb 57                	jmp    802f5d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802f06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f0a:	83 e0 03             	and    $0x3,%eax
  802f0d:	48 85 c0             	test   %rax,%rax
  802f10:	75 36                	jne    802f48 <memmove+0xfc>
  802f12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f16:	83 e0 03             	and    $0x3,%eax
  802f19:	48 85 c0             	test   %rax,%rax
  802f1c:	75 2a                	jne    802f48 <memmove+0xfc>
  802f1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f22:	83 e0 03             	and    $0x3,%eax
  802f25:	48 85 c0             	test   %rax,%rax
  802f28:	75 1e                	jne    802f48 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802f2a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f2e:	48 c1 e8 02          	shr    $0x2,%rax
  802f32:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802f35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f39:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f3d:	48 89 c7             	mov    %rax,%rdi
  802f40:	48 89 d6             	mov    %rdx,%rsi
  802f43:	fc                   	cld    
  802f44:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802f46:	eb 15                	jmp    802f5d <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802f48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f50:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802f54:	48 89 c7             	mov    %rax,%rdi
  802f57:	48 89 d6             	mov    %rdx,%rsi
  802f5a:	fc                   	cld    
  802f5b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  802f5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802f61:	c9                   	leaveq 
  802f62:	c3                   	retq   

0000000000802f63 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802f63:	55                   	push   %rbp
  802f64:	48 89 e5             	mov    %rsp,%rbp
  802f67:	48 83 ec 18          	sub    $0x18,%rsp
  802f6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f73:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  802f77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f7b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802f7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f83:	48 89 ce             	mov    %rcx,%rsi
  802f86:	48 89 c7             	mov    %rax,%rdi
  802f89:	48 b8 4c 2e 80 00 00 	movabs $0x802e4c,%rax
  802f90:	00 00 00 
  802f93:	ff d0                	callq  *%rax
}
  802f95:	c9                   	leaveq 
  802f96:	c3                   	retq   

0000000000802f97 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802f97:	55                   	push   %rbp
  802f98:	48 89 e5             	mov    %rsp,%rbp
  802f9b:	48 83 ec 28          	sub    $0x28,%rsp
  802f9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fa3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fa7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  802fab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802faf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  802fb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  802fbb:	eb 36                	jmp    802ff3 <memcmp+0x5c>
		if (*s1 != *s2)
  802fbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc1:	0f b6 10             	movzbl (%rax),%edx
  802fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc8:	0f b6 00             	movzbl (%rax),%eax
  802fcb:	38 c2                	cmp    %al,%dl
  802fcd:	74 1a                	je     802fe9 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  802fcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fd3:	0f b6 00             	movzbl (%rax),%eax
  802fd6:	0f b6 d0             	movzbl %al,%edx
  802fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fdd:	0f b6 00             	movzbl (%rax),%eax
  802fe0:	0f b6 c0             	movzbl %al,%eax
  802fe3:	29 c2                	sub    %eax,%edx
  802fe5:	89 d0                	mov    %edx,%eax
  802fe7:	eb 20                	jmp    803009 <memcmp+0x72>
		s1++, s2++;
  802fe9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802fee:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802ff3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ff7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802ffb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802fff:	48 85 c0             	test   %rax,%rax
  803002:	75 b9                	jne    802fbd <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803004:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803009:	c9                   	leaveq 
  80300a:	c3                   	retq   

000000000080300b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80300b:	55                   	push   %rbp
  80300c:	48 89 e5             	mov    %rsp,%rbp
  80300f:	48 83 ec 28          	sub    $0x28,%rsp
  803013:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803017:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80301a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80301e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803022:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803026:	48 01 d0             	add    %rdx,%rax
  803029:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80302d:	eb 15                	jmp    803044 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80302f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803033:	0f b6 10             	movzbl (%rax),%edx
  803036:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803039:	38 c2                	cmp    %al,%dl
  80303b:	75 02                	jne    80303f <memfind+0x34>
			break;
  80303d:	eb 0f                	jmp    80304e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80303f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803048:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80304c:	72 e1                	jb     80302f <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80304e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803052:	c9                   	leaveq 
  803053:	c3                   	retq   

0000000000803054 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803054:	55                   	push   %rbp
  803055:	48 89 e5             	mov    %rsp,%rbp
  803058:	48 83 ec 34          	sub    $0x34,%rsp
  80305c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803060:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803064:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803067:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80306e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803075:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803076:	eb 05                	jmp    80307d <strtol+0x29>
		s++;
  803078:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80307d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803081:	0f b6 00             	movzbl (%rax),%eax
  803084:	3c 20                	cmp    $0x20,%al
  803086:	74 f0                	je     803078 <strtol+0x24>
  803088:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80308c:	0f b6 00             	movzbl (%rax),%eax
  80308f:	3c 09                	cmp    $0x9,%al
  803091:	74 e5                	je     803078 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803093:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803097:	0f b6 00             	movzbl (%rax),%eax
  80309a:	3c 2b                	cmp    $0x2b,%al
  80309c:	75 07                	jne    8030a5 <strtol+0x51>
		s++;
  80309e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8030a3:	eb 17                	jmp    8030bc <strtol+0x68>
	else if (*s == '-')
  8030a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030a9:	0f b6 00             	movzbl (%rax),%eax
  8030ac:	3c 2d                	cmp    $0x2d,%al
  8030ae:	75 0c                	jne    8030bc <strtol+0x68>
		s++, neg = 1;
  8030b0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8030b5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8030bc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8030c0:	74 06                	je     8030c8 <strtol+0x74>
  8030c2:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8030c6:	75 28                	jne    8030f0 <strtol+0x9c>
  8030c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030cc:	0f b6 00             	movzbl (%rax),%eax
  8030cf:	3c 30                	cmp    $0x30,%al
  8030d1:	75 1d                	jne    8030f0 <strtol+0x9c>
  8030d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030d7:	48 83 c0 01          	add    $0x1,%rax
  8030db:	0f b6 00             	movzbl (%rax),%eax
  8030de:	3c 78                	cmp    $0x78,%al
  8030e0:	75 0e                	jne    8030f0 <strtol+0x9c>
		s += 2, base = 16;
  8030e2:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8030e7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8030ee:	eb 2c                	jmp    80311c <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8030f0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8030f4:	75 19                	jne    80310f <strtol+0xbb>
  8030f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030fa:	0f b6 00             	movzbl (%rax),%eax
  8030fd:	3c 30                	cmp    $0x30,%al
  8030ff:	75 0e                	jne    80310f <strtol+0xbb>
		s++, base = 8;
  803101:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803106:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80310d:	eb 0d                	jmp    80311c <strtol+0xc8>
	else if (base == 0)
  80310f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803113:	75 07                	jne    80311c <strtol+0xc8>
		base = 10;
  803115:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80311c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803120:	0f b6 00             	movzbl (%rax),%eax
  803123:	3c 2f                	cmp    $0x2f,%al
  803125:	7e 1d                	jle    803144 <strtol+0xf0>
  803127:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80312b:	0f b6 00             	movzbl (%rax),%eax
  80312e:	3c 39                	cmp    $0x39,%al
  803130:	7f 12                	jg     803144 <strtol+0xf0>
			dig = *s - '0';
  803132:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803136:	0f b6 00             	movzbl (%rax),%eax
  803139:	0f be c0             	movsbl %al,%eax
  80313c:	83 e8 30             	sub    $0x30,%eax
  80313f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803142:	eb 4e                	jmp    803192 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803144:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803148:	0f b6 00             	movzbl (%rax),%eax
  80314b:	3c 60                	cmp    $0x60,%al
  80314d:	7e 1d                	jle    80316c <strtol+0x118>
  80314f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803153:	0f b6 00             	movzbl (%rax),%eax
  803156:	3c 7a                	cmp    $0x7a,%al
  803158:	7f 12                	jg     80316c <strtol+0x118>
			dig = *s - 'a' + 10;
  80315a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80315e:	0f b6 00             	movzbl (%rax),%eax
  803161:	0f be c0             	movsbl %al,%eax
  803164:	83 e8 57             	sub    $0x57,%eax
  803167:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80316a:	eb 26                	jmp    803192 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80316c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803170:	0f b6 00             	movzbl (%rax),%eax
  803173:	3c 40                	cmp    $0x40,%al
  803175:	7e 48                	jle    8031bf <strtol+0x16b>
  803177:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80317b:	0f b6 00             	movzbl (%rax),%eax
  80317e:	3c 5a                	cmp    $0x5a,%al
  803180:	7f 3d                	jg     8031bf <strtol+0x16b>
			dig = *s - 'A' + 10;
  803182:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803186:	0f b6 00             	movzbl (%rax),%eax
  803189:	0f be c0             	movsbl %al,%eax
  80318c:	83 e8 37             	sub    $0x37,%eax
  80318f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803192:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803195:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803198:	7c 02                	jl     80319c <strtol+0x148>
			break;
  80319a:	eb 23                	jmp    8031bf <strtol+0x16b>
		s++, val = (val * base) + dig;
  80319c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8031a1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8031a4:	48 98                	cltq   
  8031a6:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8031ab:	48 89 c2             	mov    %rax,%rdx
  8031ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031b1:	48 98                	cltq   
  8031b3:	48 01 d0             	add    %rdx,%rax
  8031b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8031ba:	e9 5d ff ff ff       	jmpq   80311c <strtol+0xc8>

	if (endptr)
  8031bf:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8031c4:	74 0b                	je     8031d1 <strtol+0x17d>
		*endptr = (char *) s;
  8031c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031ce:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8031d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031d5:	74 09                	je     8031e0 <strtol+0x18c>
  8031d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031db:	48 f7 d8             	neg    %rax
  8031de:	eb 04                	jmp    8031e4 <strtol+0x190>
  8031e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8031e4:	c9                   	leaveq 
  8031e5:	c3                   	retq   

00000000008031e6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8031e6:	55                   	push   %rbp
  8031e7:	48 89 e5             	mov    %rsp,%rbp
  8031ea:	48 83 ec 30          	sub    $0x30,%rsp
  8031ee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031f2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8031f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031fa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8031fe:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803202:	0f b6 00             	movzbl (%rax),%eax
  803205:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803208:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80320c:	75 06                	jne    803214 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80320e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803212:	eb 6b                	jmp    80327f <strstr+0x99>

	len = strlen(str);
  803214:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803218:	48 89 c7             	mov    %rax,%rdi
  80321b:	48 b8 bc 2a 80 00 00 	movabs $0x802abc,%rax
  803222:	00 00 00 
  803225:	ff d0                	callq  *%rax
  803227:	48 98                	cltq   
  803229:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80322d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803231:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803235:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803239:	0f b6 00             	movzbl (%rax),%eax
  80323c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80323f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803243:	75 07                	jne    80324c <strstr+0x66>
				return (char *) 0;
  803245:	b8 00 00 00 00       	mov    $0x0,%eax
  80324a:	eb 33                	jmp    80327f <strstr+0x99>
		} while (sc != c);
  80324c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803250:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803253:	75 d8                	jne    80322d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803255:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803259:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80325d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803261:	48 89 ce             	mov    %rcx,%rsi
  803264:	48 89 c7             	mov    %rax,%rdi
  803267:	48 b8 dd 2c 80 00 00 	movabs $0x802cdd,%rax
  80326e:	00 00 00 
  803271:	ff d0                	callq  *%rax
  803273:	85 c0                	test   %eax,%eax
  803275:	75 b6                	jne    80322d <strstr+0x47>

	return (char *) (in - 1);
  803277:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80327b:	48 83 e8 01          	sub    $0x1,%rax
}
  80327f:	c9                   	leaveq 
  803280:	c3                   	retq   

0000000000803281 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803281:	55                   	push   %rbp
  803282:	48 89 e5             	mov    %rsp,%rbp
  803285:	48 83 ec 30          	sub    $0x30,%rsp
  803289:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80328d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803291:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803295:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80329a:	74 18                	je     8032b4 <ipc_recv+0x33>
  80329c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032a0:	48 89 c7             	mov    %rax,%rdi
  8032a3:	48 b8 29 05 80 00 00 	movabs $0x800529,%rax
  8032aa:	00 00 00 
  8032ad:	ff d0                	callq  *%rax
  8032af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b2:	eb 19                	jmp    8032cd <ipc_recv+0x4c>
  8032b4:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8032bb:	00 00 00 
  8032be:	48 b8 29 05 80 00 00 	movabs $0x800529,%rax
  8032c5:	00 00 00 
  8032c8:	ff d0                	callq  *%rax
  8032ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8032cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8032d2:	74 26                	je     8032fa <ipc_recv+0x79>
  8032d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d8:	75 15                	jne    8032ef <ipc_recv+0x6e>
  8032da:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032e1:	00 00 00 
  8032e4:	48 8b 00             	mov    (%rax),%rax
  8032e7:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8032ed:	eb 05                	jmp    8032f4 <ipc_recv+0x73>
  8032ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032f8:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  8032fa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8032ff:	74 26                	je     803327 <ipc_recv+0xa6>
  803301:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803305:	75 15                	jne    80331c <ipc_recv+0x9b>
  803307:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80330e:	00 00 00 
  803311:	48 8b 00             	mov    (%rax),%rax
  803314:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80331a:	eb 05                	jmp    803321 <ipc_recv+0xa0>
  80331c:	b8 00 00 00 00       	mov    $0x0,%eax
  803321:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803325:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803327:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332b:	75 15                	jne    803342 <ipc_recv+0xc1>
  80332d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803334:	00 00 00 
  803337:	48 8b 00             	mov    (%rax),%rax
  80333a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803340:	eb 03                	jmp    803345 <ipc_recv+0xc4>
  803342:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803345:	c9                   	leaveq 
  803346:	c3                   	retq   

0000000000803347 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803347:	55                   	push   %rbp
  803348:	48 89 e5             	mov    %rsp,%rbp
  80334b:	48 83 ec 30          	sub    $0x30,%rsp
  80334f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803352:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803355:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803359:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  80335c:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803363:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803368:	75 10                	jne    80337a <ipc_send+0x33>
  80336a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803371:	00 00 00 
  803374:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803378:	eb 62                	jmp    8033dc <ipc_send+0x95>
  80337a:	eb 60                	jmp    8033dc <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  80337c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803380:	74 30                	je     8033b2 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803382:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803385:	89 c1                	mov    %eax,%ecx
  803387:	48 ba 48 3b 80 00 00 	movabs $0x803b48,%rdx
  80338e:	00 00 00 
  803391:	be 33 00 00 00       	mov    $0x33,%esi
  803396:	48 bf 64 3b 80 00 00 	movabs $0x803b64,%rdi
  80339d:	00 00 00 
  8033a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a5:	49 b8 3a 1d 80 00 00 	movabs $0x801d3a,%r8
  8033ac:	00 00 00 
  8033af:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  8033b2:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8033b5:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8033b8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033bf:	89 c7                	mov    %eax,%edi
  8033c1:	48 b8 d4 04 80 00 00 	movabs $0x8004d4,%rax
  8033c8:	00 00 00 
  8033cb:	ff d0                	callq  *%rax
  8033cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8033d0:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
  8033d7:	00 00 00 
  8033da:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8033dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e0:	75 9a                	jne    80337c <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  8033e2:	c9                   	leaveq 
  8033e3:	c3                   	retq   

00000000008033e4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8033e4:	55                   	push   %rbp
  8033e5:	48 89 e5             	mov    %rsp,%rbp
  8033e8:	48 83 ec 14          	sub    $0x14,%rsp
  8033ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8033ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8033f6:	eb 5e                	jmp    803456 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8033f8:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8033ff:	00 00 00 
  803402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803405:	48 63 d0             	movslq %eax,%rdx
  803408:	48 89 d0             	mov    %rdx,%rax
  80340b:	48 c1 e0 03          	shl    $0x3,%rax
  80340f:	48 01 d0             	add    %rdx,%rax
  803412:	48 c1 e0 05          	shl    $0x5,%rax
  803416:	48 01 c8             	add    %rcx,%rax
  803419:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80341f:	8b 00                	mov    (%rax),%eax
  803421:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803424:	75 2c                	jne    803452 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803426:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80342d:	00 00 00 
  803430:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803433:	48 63 d0             	movslq %eax,%rdx
  803436:	48 89 d0             	mov    %rdx,%rax
  803439:	48 c1 e0 03          	shl    $0x3,%rax
  80343d:	48 01 d0             	add    %rdx,%rax
  803440:	48 c1 e0 05          	shl    $0x5,%rax
  803444:	48 01 c8             	add    %rcx,%rax
  803447:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80344d:	8b 40 08             	mov    0x8(%rax),%eax
  803450:	eb 12                	jmp    803464 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803452:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803456:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80345d:	7e 99                	jle    8033f8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80345f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803464:	c9                   	leaveq 
  803465:	c3                   	retq   

0000000000803466 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803466:	55                   	push   %rbp
  803467:	48 89 e5             	mov    %rsp,%rbp
  80346a:	48 83 ec 18          	sub    $0x18,%rsp
  80346e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803476:	48 c1 e8 15          	shr    $0x15,%rax
  80347a:	48 89 c2             	mov    %rax,%rdx
  80347d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803484:	01 00 00 
  803487:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80348b:	83 e0 01             	and    $0x1,%eax
  80348e:	48 85 c0             	test   %rax,%rax
  803491:	75 07                	jne    80349a <pageref+0x34>
		return 0;
  803493:	b8 00 00 00 00       	mov    $0x0,%eax
  803498:	eb 53                	jmp    8034ed <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80349a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80349e:	48 c1 e8 0c          	shr    $0xc,%rax
  8034a2:	48 89 c2             	mov    %rax,%rdx
  8034a5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034ac:	01 00 00 
  8034af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8034b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034bb:	83 e0 01             	and    $0x1,%eax
  8034be:	48 85 c0             	test   %rax,%rax
  8034c1:	75 07                	jne    8034ca <pageref+0x64>
		return 0;
  8034c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c8:	eb 23                	jmp    8034ed <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8034ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ce:	48 c1 e8 0c          	shr    $0xc,%rax
  8034d2:	48 89 c2             	mov    %rax,%rdx
  8034d5:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8034dc:	00 00 00 
  8034df:	48 c1 e2 04          	shl    $0x4,%rdx
  8034e3:	48 01 d0             	add    %rdx,%rax
  8034e6:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8034ea:	0f b7 c0             	movzwl %ax,%eax
}
  8034ed:	c9                   	leaveq 
  8034ee:	c3                   	retq   
