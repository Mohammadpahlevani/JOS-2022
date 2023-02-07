
obj/user/evilhello:     file format elf64-x86-64


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
  80003c:	e8 2e 00 00 00       	callq  80006f <libmain>
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
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0x800420000c, 100);
  800052:	be 64 00 00 00       	mov    $0x64,%esi
  800057:	48 bf 0c 00 20 04 80 	movabs $0x800420000c,%rdi
  80005e:	00 00 00 
  800061:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
}
  80006d:	c9                   	leaveq 
  80006e:	c3                   	retq   

000000000080006f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80006f:	55                   	push   %rbp
  800070:	48 89 e5             	mov    %rsp,%rbp
  800073:	48 83 ec 20          	sub    $0x20,%rsp
  800077:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80007a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80007e:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800085:	00 00 00 
  800088:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  80008f:	48 b8 84 02 80 00 00 	movabs $0x800284,%rax
  800096:	00 00 00 
  800099:	ff d0                	callq  *%rax
  80009b:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  80009e:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  8000a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a8:	48 63 d0             	movslq %eax,%rdx
  8000ab:	48 89 d0             	mov    %rdx,%rax
  8000ae:	48 c1 e0 03          	shl    $0x3,%rax
  8000b2:	48 01 d0             	add    %rdx,%rax
  8000b5:	48 c1 e0 05          	shl    $0x5,%rax
  8000b9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000c0:	00 00 00 
  8000c3:	48 01 c2             	add    %rax,%rdx
  8000c6:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000cd:	00 00 00 
  8000d0:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000d7:	7e 14                	jle    8000ed <libmain+0x7e>
		binaryname = argv[0];
  8000d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000dd:	48 8b 10             	mov    (%rax),%rdx
  8000e0:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000e7:	00 00 00 
  8000ea:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000ed:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000f4:	48 89 d6             	mov    %rdx,%rsi
  8000f7:	89 c7                	mov    %eax,%edi
  8000f9:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800100:	00 00 00 
  800103:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  800105:	48 b8 13 01 80 00 00 	movabs $0x800113,%rax
  80010c:	00 00 00 
  80010f:	ff d0                	callq  *%rax
}
  800111:	c9                   	leaveq 
  800112:	c3                   	retq   

0000000000800113 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800113:	55                   	push   %rbp
  800114:	48 89 e5             	mov    %rsp,%rbp
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
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

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
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

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
  800182:	48 ba 8a 1a 80 00 00 	movabs $0x801a8a,%rdx
  800189:	00 00 00 
  80018c:	be 23 00 00 00       	mov    $0x23,%esi
  800191:	48 bf a7 1a 80 00 00 	movabs $0x801aa7,%rdi
  800198:	00 00 00 
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a0:	49 b9 23 05 80 00 00 	movabs $0x800523,%r9
  8001a7:	00 00 00 
  8001aa:	41 ff d1             	callq  *%r9

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
  8002ed:	bf 0a 00 00 00       	mov    $0xa,%edi
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

0000000000800440 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800440:	55                   	push   %rbp
  800441:	48 89 e5             	mov    %rsp,%rbp
  800444:	48 83 ec 20          	sub    $0x20,%rsp
  800448:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80044b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
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

000000000080048a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80048a:	55                   	push   %rbp
  80048b:	48 89 e5             	mov    %rsp,%rbp
  80048e:	48 83 ec 20          	sub    $0x20,%rsp
  800492:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800495:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800499:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80049d:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004a3:	48 63 f0             	movslq %eax,%rsi
  8004a6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004ad:	48 98                	cltq   
  8004af:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004ba:	00 
  8004bb:	49 89 f1             	mov    %rsi,%r9
  8004be:	49 89 c8             	mov    %rcx,%r8
  8004c1:	48 89 d1             	mov    %rdx,%rcx
  8004c4:	48 89 c2             	mov    %rax,%rdx
  8004c7:	be 00 00 00 00       	mov    $0x0,%esi
  8004cc:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004d1:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  8004d8:	00 00 00 
  8004db:	ff d0                	callq  *%rax
}
  8004dd:	c9                   	leaveq 
  8004de:	c3                   	retq   

00000000008004df <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004df:	55                   	push   %rbp
  8004e0:	48 89 e5             	mov    %rsp,%rbp
  8004e3:	48 83 ec 10          	sub    $0x10,%rsp
  8004e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004ef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004f6:	00 
  8004f7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004fd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800503:	b9 00 00 00 00       	mov    $0x0,%ecx
  800508:	48 89 c2             	mov    %rax,%rdx
  80050b:	be 01 00 00 00       	mov    $0x1,%esi
  800510:	bf 0c 00 00 00       	mov    $0xc,%edi
  800515:	48 b8 2a 01 80 00 00 	movabs $0x80012a,%rax
  80051c:	00 00 00 
  80051f:	ff d0                	callq  *%rax
}
  800521:	c9                   	leaveq 
  800522:	c3                   	retq   

0000000000800523 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800523:	55                   	push   %rbp
  800524:	48 89 e5             	mov    %rsp,%rbp
  800527:	53                   	push   %rbx
  800528:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80052f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800536:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80053c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800543:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80054a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800551:	84 c0                	test   %al,%al
  800553:	74 23                	je     800578 <_panic+0x55>
  800555:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80055c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800560:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800564:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800568:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80056c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800570:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800574:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800578:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80057f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800586:	00 00 00 
  800589:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800590:	00 00 00 
  800593:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800597:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80059e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005a5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005ac:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005b3:	00 00 00 
  8005b6:	48 8b 18             	mov    (%rax),%rbx
  8005b9:	48 b8 84 02 80 00 00 	movabs $0x800284,%rax
  8005c0:	00 00 00 
  8005c3:	ff d0                	callq  *%rax
  8005c5:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005cb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005d2:	41 89 c8             	mov    %ecx,%r8d
  8005d5:	48 89 d1             	mov    %rdx,%rcx
  8005d8:	48 89 da             	mov    %rbx,%rdx
  8005db:	89 c6                	mov    %eax,%esi
  8005dd:	48 bf b8 1a 80 00 00 	movabs $0x801ab8,%rdi
  8005e4:	00 00 00 
  8005e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ec:	49 b9 5c 07 80 00 00 	movabs $0x80075c,%r9
  8005f3:	00 00 00 
  8005f6:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005f9:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800600:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800607:	48 89 d6             	mov    %rdx,%rsi
  80060a:	48 89 c7             	mov    %rax,%rdi
  80060d:	48 b8 b0 06 80 00 00 	movabs $0x8006b0,%rax
  800614:	00 00 00 
  800617:	ff d0                	callq  *%rax
	cprintf("\n");
  800619:	48 bf db 1a 80 00 00 	movabs $0x801adb,%rdi
  800620:	00 00 00 
  800623:	b8 00 00 00 00       	mov    $0x0,%eax
  800628:	48 ba 5c 07 80 00 00 	movabs $0x80075c,%rdx
  80062f:	00 00 00 
  800632:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800634:	cc                   	int3   
  800635:	eb fd                	jmp    800634 <_panic+0x111>

0000000000800637 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800637:	55                   	push   %rbp
  800638:	48 89 e5             	mov    %rsp,%rbp
  80063b:	48 83 ec 10          	sub    $0x10,%rsp
  80063f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800642:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064a:	8b 00                	mov    (%rax),%eax
  80064c:	8d 48 01             	lea    0x1(%rax),%ecx
  80064f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800653:	89 0a                	mov    %ecx,(%rdx)
  800655:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800658:	89 d1                	mov    %edx,%ecx
  80065a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80065e:	48 98                	cltq   
  800660:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800668:	8b 00                	mov    (%rax),%eax
  80066a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066f:	75 2c                	jne    80069d <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800671:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800675:	8b 00                	mov    (%rax),%eax
  800677:	48 98                	cltq   
  800679:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80067d:	48 83 c2 08          	add    $0x8,%rdx
  800681:	48 89 c6             	mov    %rax,%rsi
  800684:	48 89 d7             	mov    %rdx,%rdi
  800687:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  80068e:	00 00 00 
  800691:	ff d0                	callq  *%rax
		b->idx = 0;
  800693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800697:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80069d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a1:	8b 40 04             	mov    0x4(%rax),%eax
  8006a4:	8d 50 01             	lea    0x1(%rax),%edx
  8006a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ab:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006ae:	c9                   	leaveq 
  8006af:	c3                   	retq   

00000000008006b0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006b0:	55                   	push   %rbp
  8006b1:	48 89 e5             	mov    %rsp,%rbp
  8006b4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006bb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006c2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8006c9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006d0:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006d7:	48 8b 0a             	mov    (%rdx),%rcx
  8006da:	48 89 08             	mov    %rcx,(%rax)
  8006dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8006ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006f4:	00 00 00 
	b.cnt = 0;
  8006f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006fe:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800701:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800708:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80070f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800716:	48 89 c6             	mov    %rax,%rsi
  800719:	48 bf 37 06 80 00 00 	movabs $0x800637,%rdi
  800720:	00 00 00 
  800723:	48 b8 0f 0b 80 00 00 	movabs $0x800b0f,%rax
  80072a:	00 00 00 
  80072d:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80072f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800735:	48 98                	cltq   
  800737:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80073e:	48 83 c2 08          	add    $0x8,%rdx
  800742:	48 89 c6             	mov    %rax,%rsi
  800745:	48 89 d7             	mov    %rdx,%rdi
  800748:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  80074f:	00 00 00 
  800752:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800754:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80075a:	c9                   	leaveq 
  80075b:	c3                   	retq   

000000000080075c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80075c:	55                   	push   %rbp
  80075d:	48 89 e5             	mov    %rsp,%rbp
  800760:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800767:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80076e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800775:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80077c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800783:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80078a:	84 c0                	test   %al,%al
  80078c:	74 20                	je     8007ae <cprintf+0x52>
  80078e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800792:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800796:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80079a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80079e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007a2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007a6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007aa:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007ae:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8007b5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007bc:	00 00 00 
  8007bf:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007c6:	00 00 00 
  8007c9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007cd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007d4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007db:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8007e2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007e9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007f0:	48 8b 0a             	mov    (%rdx),%rcx
  8007f3:	48 89 08             	mov    %rcx,(%rax)
  8007f6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007fa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007fe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800802:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800806:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80080d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800814:	48 89 d6             	mov    %rdx,%rsi
  800817:	48 89 c7             	mov    %rax,%rdi
  80081a:	48 b8 b0 06 80 00 00 	movabs $0x8006b0,%rax
  800821:	00 00 00 
  800824:	ff d0                	callq  *%rax
  800826:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80082c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800832:	c9                   	leaveq 
  800833:	c3                   	retq   

0000000000800834 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800834:	55                   	push   %rbp
  800835:	48 89 e5             	mov    %rsp,%rbp
  800838:	53                   	push   %rbx
  800839:	48 83 ec 38          	sub    $0x38,%rsp
  80083d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800841:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800845:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800849:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80084c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800850:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800854:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800857:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80085b:	77 3b                	ja     800898 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80085d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800860:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800864:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80086b:	ba 00 00 00 00       	mov    $0x0,%edx
  800870:	48 f7 f3             	div    %rbx
  800873:	48 89 c2             	mov    %rax,%rdx
  800876:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800879:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80087c:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800880:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800884:	41 89 f9             	mov    %edi,%r9d
  800887:	48 89 c7             	mov    %rax,%rdi
  80088a:	48 b8 34 08 80 00 00 	movabs $0x800834,%rax
  800891:	00 00 00 
  800894:	ff d0                	callq  *%rax
  800896:	eb 1e                	jmp    8008b6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800898:	eb 12                	jmp    8008ac <printnum+0x78>
			putch(padc, putdat);
  80089a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80089e:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8008a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a5:	48 89 ce             	mov    %rcx,%rsi
  8008a8:	89 d7                	mov    %edx,%edi
  8008aa:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008ac:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008b0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008b4:	7f e4                	jg     80089a <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008b6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c2:	48 f7 f1             	div    %rcx
  8008c5:	48 89 d0             	mov    %rdx,%rax
  8008c8:	48 ba d0 1b 80 00 00 	movabs $0x801bd0,%rdx
  8008cf:	00 00 00 
  8008d2:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008d6:	0f be d0             	movsbl %al,%edx
  8008d9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e1:	48 89 ce             	mov    %rcx,%rsi
  8008e4:	89 d7                	mov    %edx,%edi
  8008e6:	ff d0                	callq  *%rax
}
  8008e8:	48 83 c4 38          	add    $0x38,%rsp
  8008ec:	5b                   	pop    %rbx
  8008ed:	5d                   	pop    %rbp
  8008ee:	c3                   	retq   

00000000008008ef <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ef:	55                   	push   %rbp
  8008f0:	48 89 e5             	mov    %rsp,%rbp
  8008f3:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008fb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008fe:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800902:	7e 52                	jle    800956 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800904:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800908:	8b 00                	mov    (%rax),%eax
  80090a:	83 f8 30             	cmp    $0x30,%eax
  80090d:	73 24                	jae    800933 <getuint+0x44>
  80090f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800913:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091b:	8b 00                	mov    (%rax),%eax
  80091d:	89 c0                	mov    %eax,%eax
  80091f:	48 01 d0             	add    %rdx,%rax
  800922:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800926:	8b 12                	mov    (%rdx),%edx
  800928:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80092b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092f:	89 0a                	mov    %ecx,(%rdx)
  800931:	eb 17                	jmp    80094a <getuint+0x5b>
  800933:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800937:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80093b:	48 89 d0             	mov    %rdx,%rax
  80093e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800942:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800946:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80094a:	48 8b 00             	mov    (%rax),%rax
  80094d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800951:	e9 a3 00 00 00       	jmpq   8009f9 <getuint+0x10a>
	else if (lflag)
  800956:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80095a:	74 4f                	je     8009ab <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80095c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800960:	8b 00                	mov    (%rax),%eax
  800962:	83 f8 30             	cmp    $0x30,%eax
  800965:	73 24                	jae    80098b <getuint+0x9c>
  800967:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80096b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80096f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800973:	8b 00                	mov    (%rax),%eax
  800975:	89 c0                	mov    %eax,%eax
  800977:	48 01 d0             	add    %rdx,%rax
  80097a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097e:	8b 12                	mov    (%rdx),%edx
  800980:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800983:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800987:	89 0a                	mov    %ecx,(%rdx)
  800989:	eb 17                	jmp    8009a2 <getuint+0xb3>
  80098b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800993:	48 89 d0             	mov    %rdx,%rax
  800996:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80099a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009a2:	48 8b 00             	mov    (%rax),%rax
  8009a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009a9:	eb 4e                	jmp    8009f9 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009af:	8b 00                	mov    (%rax),%eax
  8009b1:	83 f8 30             	cmp    $0x30,%eax
  8009b4:	73 24                	jae    8009da <getuint+0xeb>
  8009b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ba:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c2:	8b 00                	mov    (%rax),%eax
  8009c4:	89 c0                	mov    %eax,%eax
  8009c6:	48 01 d0             	add    %rdx,%rax
  8009c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009cd:	8b 12                	mov    (%rdx),%edx
  8009cf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d6:	89 0a                	mov    %ecx,(%rdx)
  8009d8:	eb 17                	jmp    8009f1 <getuint+0x102>
  8009da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009de:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e2:	48 89 d0             	mov    %rdx,%rax
  8009e5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ed:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f1:	8b 00                	mov    (%rax),%eax
  8009f3:	89 c0                	mov    %eax,%eax
  8009f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009fd:	c9                   	leaveq 
  8009fe:	c3                   	retq   

00000000008009ff <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ff:	55                   	push   %rbp
  800a00:	48 89 e5             	mov    %rsp,%rbp
  800a03:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a0b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a0e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a12:	7e 52                	jle    800a66 <getint+0x67>
		x=va_arg(*ap, long long);
  800a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a18:	8b 00                	mov    (%rax),%eax
  800a1a:	83 f8 30             	cmp    $0x30,%eax
  800a1d:	73 24                	jae    800a43 <getint+0x44>
  800a1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a23:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2b:	8b 00                	mov    (%rax),%eax
  800a2d:	89 c0                	mov    %eax,%eax
  800a2f:	48 01 d0             	add    %rdx,%rax
  800a32:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a36:	8b 12                	mov    (%rdx),%edx
  800a38:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3f:	89 0a                	mov    %ecx,(%rdx)
  800a41:	eb 17                	jmp    800a5a <getint+0x5b>
  800a43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a47:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a4b:	48 89 d0             	mov    %rdx,%rax
  800a4e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a56:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a5a:	48 8b 00             	mov    (%rax),%rax
  800a5d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a61:	e9 a3 00 00 00       	jmpq   800b09 <getint+0x10a>
	else if (lflag)
  800a66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a6a:	74 4f                	je     800abb <getint+0xbc>
		x=va_arg(*ap, long);
  800a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a70:	8b 00                	mov    (%rax),%eax
  800a72:	83 f8 30             	cmp    $0x30,%eax
  800a75:	73 24                	jae    800a9b <getint+0x9c>
  800a77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a83:	8b 00                	mov    (%rax),%eax
  800a85:	89 c0                	mov    %eax,%eax
  800a87:	48 01 d0             	add    %rdx,%rax
  800a8a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8e:	8b 12                	mov    (%rdx),%edx
  800a90:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a93:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a97:	89 0a                	mov    %ecx,(%rdx)
  800a99:	eb 17                	jmp    800ab2 <getint+0xb3>
  800a9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a9f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aa3:	48 89 d0             	mov    %rdx,%rax
  800aa6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aaa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ab2:	48 8b 00             	mov    (%rax),%rax
  800ab5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ab9:	eb 4e                	jmp    800b09 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800abf:	8b 00                	mov    (%rax),%eax
  800ac1:	83 f8 30             	cmp    $0x30,%eax
  800ac4:	73 24                	jae    800aea <getint+0xeb>
  800ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ace:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad2:	8b 00                	mov    (%rax),%eax
  800ad4:	89 c0                	mov    %eax,%eax
  800ad6:	48 01 d0             	add    %rdx,%rax
  800ad9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800add:	8b 12                	mov    (%rdx),%edx
  800adf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ae2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae6:	89 0a                	mov    %ecx,(%rdx)
  800ae8:	eb 17                	jmp    800b01 <getint+0x102>
  800aea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aee:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800af2:	48 89 d0             	mov    %rdx,%rax
  800af5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800af9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800afd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b01:	8b 00                	mov    (%rax),%eax
  800b03:	48 98                	cltq   
  800b05:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b0d:	c9                   	leaveq 
  800b0e:	c3                   	retq   

0000000000800b0f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b0f:	55                   	push   %rbp
  800b10:	48 89 e5             	mov    %rsp,%rbp
  800b13:	41 54                	push   %r12
  800b15:	53                   	push   %rbx
  800b16:	48 83 ec 60          	sub    $0x60,%rsp
  800b1a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b1e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b22:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b26:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b2a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b2e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b32:	48 8b 0a             	mov    (%rdx),%rcx
  800b35:	48 89 08             	mov    %rcx,(%rax)
  800b38:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b3c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b40:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b44:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b48:	eb 17                	jmp    800b61 <vprintfmt+0x52>
			if (ch == '\0')
  800b4a:	85 db                	test   %ebx,%ebx
  800b4c:	0f 84 cc 04 00 00    	je     80101e <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800b52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5a:	48 89 d6             	mov    %rdx,%rsi
  800b5d:	89 df                	mov    %ebx,%edi
  800b5f:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b61:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b65:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b69:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b6d:	0f b6 00             	movzbl (%rax),%eax
  800b70:	0f b6 d8             	movzbl %al,%ebx
  800b73:	83 fb 25             	cmp    $0x25,%ebx
  800b76:	75 d2                	jne    800b4a <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800b78:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b7c:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b83:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b8a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b91:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b98:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b9c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ba0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ba4:	0f b6 00             	movzbl (%rax),%eax
  800ba7:	0f b6 d8             	movzbl %al,%ebx
  800baa:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800bad:	83 f8 55             	cmp    $0x55,%eax
  800bb0:	0f 87 34 04 00 00    	ja     800fea <vprintfmt+0x4db>
  800bb6:	89 c0                	mov    %eax,%eax
  800bb8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bbf:	00 
  800bc0:	48 b8 f8 1b 80 00 00 	movabs $0x801bf8,%rax
  800bc7:	00 00 00 
  800bca:	48 01 d0             	add    %rdx,%rax
  800bcd:	48 8b 00             	mov    (%rax),%rax
  800bd0:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bd2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bd6:	eb c0                	jmp    800b98 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bd8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bdc:	eb ba                	jmp    800b98 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bde:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800be5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800be8:	89 d0                	mov    %edx,%eax
  800bea:	c1 e0 02             	shl    $0x2,%eax
  800bed:	01 d0                	add    %edx,%eax
  800bef:	01 c0                	add    %eax,%eax
  800bf1:	01 d8                	add    %ebx,%eax
  800bf3:	83 e8 30             	sub    $0x30,%eax
  800bf6:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bf9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bfd:	0f b6 00             	movzbl (%rax),%eax
  800c00:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c03:	83 fb 2f             	cmp    $0x2f,%ebx
  800c06:	7e 0c                	jle    800c14 <vprintfmt+0x105>
  800c08:	83 fb 39             	cmp    $0x39,%ebx
  800c0b:	7f 07                	jg     800c14 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c12:	eb d1                	jmp    800be5 <vprintfmt+0xd6>
			goto process_precision;
  800c14:	eb 58                	jmp    800c6e <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c16:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c19:	83 f8 30             	cmp    $0x30,%eax
  800c1c:	73 17                	jae    800c35 <vprintfmt+0x126>
  800c1e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c25:	89 c0                	mov    %eax,%eax
  800c27:	48 01 d0             	add    %rdx,%rax
  800c2a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c2d:	83 c2 08             	add    $0x8,%edx
  800c30:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c33:	eb 0f                	jmp    800c44 <vprintfmt+0x135>
  800c35:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c39:	48 89 d0             	mov    %rdx,%rax
  800c3c:	48 83 c2 08          	add    $0x8,%rdx
  800c40:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c44:	8b 00                	mov    (%rax),%eax
  800c46:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c49:	eb 23                	jmp    800c6e <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4f:	79 0c                	jns    800c5d <vprintfmt+0x14e>
				width = 0;
  800c51:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c58:	e9 3b ff ff ff       	jmpq   800b98 <vprintfmt+0x89>
  800c5d:	e9 36 ff ff ff       	jmpq   800b98 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c62:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c69:	e9 2a ff ff ff       	jmpq   800b98 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c72:	79 12                	jns    800c86 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c74:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c77:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c7a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c81:	e9 12 ff ff ff       	jmpq   800b98 <vprintfmt+0x89>
  800c86:	e9 0d ff ff ff       	jmpq   800b98 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c8b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c8f:	e9 04 ff ff ff       	jmpq   800b98 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800c94:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c97:	83 f8 30             	cmp    $0x30,%eax
  800c9a:	73 17                	jae    800cb3 <vprintfmt+0x1a4>
  800c9c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca3:	89 c0                	mov    %eax,%eax
  800ca5:	48 01 d0             	add    %rdx,%rax
  800ca8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cab:	83 c2 08             	add    $0x8,%edx
  800cae:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cb1:	eb 0f                	jmp    800cc2 <vprintfmt+0x1b3>
  800cb3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb7:	48 89 d0             	mov    %rdx,%rax
  800cba:	48 83 c2 08          	add    $0x8,%rdx
  800cbe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc2:	8b 10                	mov    (%rax),%edx
  800cc4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccc:	48 89 ce             	mov    %rcx,%rsi
  800ccf:	89 d7                	mov    %edx,%edi
  800cd1:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800cd3:	e9 40 03 00 00       	jmpq   801018 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800cd8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cdb:	83 f8 30             	cmp    $0x30,%eax
  800cde:	73 17                	jae    800cf7 <vprintfmt+0x1e8>
  800ce0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ce4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce7:	89 c0                	mov    %eax,%eax
  800ce9:	48 01 d0             	add    %rdx,%rax
  800cec:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cef:	83 c2 08             	add    $0x8,%edx
  800cf2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cf5:	eb 0f                	jmp    800d06 <vprintfmt+0x1f7>
  800cf7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cfb:	48 89 d0             	mov    %rdx,%rax
  800cfe:	48 83 c2 08          	add    $0x8,%rdx
  800d02:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d06:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d08:	85 db                	test   %ebx,%ebx
  800d0a:	79 02                	jns    800d0e <vprintfmt+0x1ff>
				err = -err;
  800d0c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d0e:	83 fb 09             	cmp    $0x9,%ebx
  800d11:	7f 16                	jg     800d29 <vprintfmt+0x21a>
  800d13:	48 b8 80 1b 80 00 00 	movabs $0x801b80,%rax
  800d1a:	00 00 00 
  800d1d:	48 63 d3             	movslq %ebx,%rdx
  800d20:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d24:	4d 85 e4             	test   %r12,%r12
  800d27:	75 2e                	jne    800d57 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d29:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d2d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d31:	89 d9                	mov    %ebx,%ecx
  800d33:	48 ba e1 1b 80 00 00 	movabs $0x801be1,%rdx
  800d3a:	00 00 00 
  800d3d:	48 89 c7             	mov    %rax,%rdi
  800d40:	b8 00 00 00 00       	mov    $0x0,%eax
  800d45:	49 b8 27 10 80 00 00 	movabs $0x801027,%r8
  800d4c:	00 00 00 
  800d4f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d52:	e9 c1 02 00 00       	jmpq   801018 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d57:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5f:	4c 89 e1             	mov    %r12,%rcx
  800d62:	48 ba ea 1b 80 00 00 	movabs $0x801bea,%rdx
  800d69:	00 00 00 
  800d6c:	48 89 c7             	mov    %rax,%rdi
  800d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d74:	49 b8 27 10 80 00 00 	movabs $0x801027,%r8
  800d7b:	00 00 00 
  800d7e:	41 ff d0             	callq  *%r8
			break;
  800d81:	e9 92 02 00 00       	jmpq   801018 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800d86:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d89:	83 f8 30             	cmp    $0x30,%eax
  800d8c:	73 17                	jae    800da5 <vprintfmt+0x296>
  800d8e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d92:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d95:	89 c0                	mov    %eax,%eax
  800d97:	48 01 d0             	add    %rdx,%rax
  800d9a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d9d:	83 c2 08             	add    $0x8,%edx
  800da0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800da3:	eb 0f                	jmp    800db4 <vprintfmt+0x2a5>
  800da5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da9:	48 89 d0             	mov    %rdx,%rax
  800dac:	48 83 c2 08          	add    $0x8,%rdx
  800db0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db4:	4c 8b 20             	mov    (%rax),%r12
  800db7:	4d 85 e4             	test   %r12,%r12
  800dba:	75 0a                	jne    800dc6 <vprintfmt+0x2b7>
				p = "(null)";
  800dbc:	49 bc ed 1b 80 00 00 	movabs $0x801bed,%r12
  800dc3:	00 00 00 
			if (width > 0 && padc != '-')
  800dc6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dca:	7e 3f                	jle    800e0b <vprintfmt+0x2fc>
  800dcc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dd0:	74 39                	je     800e0b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dd5:	48 98                	cltq   
  800dd7:	48 89 c6             	mov    %rax,%rsi
  800dda:	4c 89 e7             	mov    %r12,%rdi
  800ddd:	48 b8 d3 12 80 00 00 	movabs $0x8012d3,%rax
  800de4:	00 00 00 
  800de7:	ff d0                	callq  *%rax
  800de9:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dec:	eb 17                	jmp    800e05 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800dee:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800df2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800df6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfa:	48 89 ce             	mov    %rcx,%rsi
  800dfd:	89 d7                	mov    %edx,%edi
  800dff:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e01:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e05:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e09:	7f e3                	jg     800dee <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0b:	eb 37                	jmp    800e44 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e11:	74 1e                	je     800e31 <vprintfmt+0x322>
  800e13:	83 fb 1f             	cmp    $0x1f,%ebx
  800e16:	7e 05                	jle    800e1d <vprintfmt+0x30e>
  800e18:	83 fb 7e             	cmp    $0x7e,%ebx
  800e1b:	7e 14                	jle    800e31 <vprintfmt+0x322>
					putch('?', putdat);
  800e1d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e21:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e25:	48 89 d6             	mov    %rdx,%rsi
  800e28:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e2d:	ff d0                	callq  *%rax
  800e2f:	eb 0f                	jmp    800e40 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e31:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e39:	48 89 d6             	mov    %rdx,%rsi
  800e3c:	89 df                	mov    %ebx,%edi
  800e3e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e40:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e44:	4c 89 e0             	mov    %r12,%rax
  800e47:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e4b:	0f b6 00             	movzbl (%rax),%eax
  800e4e:	0f be d8             	movsbl %al,%ebx
  800e51:	85 db                	test   %ebx,%ebx
  800e53:	74 10                	je     800e65 <vprintfmt+0x356>
  800e55:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e59:	78 b2                	js     800e0d <vprintfmt+0x2fe>
  800e5b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e5f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e63:	79 a8                	jns    800e0d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e65:	eb 16                	jmp    800e7d <vprintfmt+0x36e>
				putch(' ', putdat);
  800e67:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e6f:	48 89 d6             	mov    %rdx,%rsi
  800e72:	bf 20 00 00 00       	mov    $0x20,%edi
  800e77:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e79:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e81:	7f e4                	jg     800e67 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800e83:	e9 90 01 00 00       	jmpq   801018 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800e88:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e8c:	be 03 00 00 00       	mov    $0x3,%esi
  800e91:	48 89 c7             	mov    %rax,%rdi
  800e94:	48 b8 ff 09 80 00 00 	movabs $0x8009ff,%rax
  800e9b:	00 00 00 
  800e9e:	ff d0                	callq  *%rax
  800ea0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea8:	48 85 c0             	test   %rax,%rax
  800eab:	79 1d                	jns    800eca <vprintfmt+0x3bb>
				putch('-', putdat);
  800ead:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb5:	48 89 d6             	mov    %rdx,%rsi
  800eb8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ebd:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec3:	48 f7 d8             	neg    %rax
  800ec6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800eca:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ed1:	e9 d5 00 00 00       	jmpq   800fab <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800ed6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eda:	be 03 00 00 00       	mov    $0x3,%esi
  800edf:	48 89 c7             	mov    %rax,%rdi
  800ee2:	48 b8 ef 08 80 00 00 	movabs $0x8008ef,%rax
  800ee9:	00 00 00 
  800eec:	ff d0                	callq  *%rax
  800eee:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ef2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ef9:	e9 ad 00 00 00       	jmpq   800fab <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800efe:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f02:	be 03 00 00 00       	mov    $0x3,%esi
  800f07:	48 89 c7             	mov    %rax,%rdi
  800f0a:	48 b8 ef 08 80 00 00 	movabs $0x8008ef,%rax
  800f11:	00 00 00 
  800f14:	ff d0                	callq  *%rax
  800f16:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f1a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f21:	e9 85 00 00 00       	jmpq   800fab <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800f26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f2e:	48 89 d6             	mov    %rdx,%rsi
  800f31:	bf 30 00 00 00       	mov    $0x30,%edi
  800f36:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f40:	48 89 d6             	mov    %rdx,%rsi
  800f43:	bf 78 00 00 00       	mov    $0x78,%edi
  800f48:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f4a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f4d:	83 f8 30             	cmp    $0x30,%eax
  800f50:	73 17                	jae    800f69 <vprintfmt+0x45a>
  800f52:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f56:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f59:	89 c0                	mov    %eax,%eax
  800f5b:	48 01 d0             	add    %rdx,%rax
  800f5e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f61:	83 c2 08             	add    $0x8,%edx
  800f64:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f67:	eb 0f                	jmp    800f78 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f69:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f6d:	48 89 d0             	mov    %rdx,%rax
  800f70:	48 83 c2 08          	add    $0x8,%rdx
  800f74:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f78:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f7f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f86:	eb 23                	jmp    800fab <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800f88:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f8c:	be 03 00 00 00       	mov    $0x3,%esi
  800f91:	48 89 c7             	mov    %rax,%rdi
  800f94:	48 b8 ef 08 80 00 00 	movabs $0x8008ef,%rax
  800f9b:	00 00 00 
  800f9e:	ff d0                	callq  *%rax
  800fa0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fa4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800fab:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fb0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fb3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fb6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fba:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc2:	45 89 c1             	mov    %r8d,%r9d
  800fc5:	41 89 f8             	mov    %edi,%r8d
  800fc8:	48 89 c7             	mov    %rax,%rdi
  800fcb:	48 b8 34 08 80 00 00 	movabs $0x800834,%rax
  800fd2:	00 00 00 
  800fd5:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800fd7:	eb 3f                	jmp    801018 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fdd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe1:	48 89 d6             	mov    %rdx,%rsi
  800fe4:	89 df                	mov    %ebx,%edi
  800fe6:	ff d0                	callq  *%rax
			break;
  800fe8:	eb 2e                	jmp    801018 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ff2:	48 89 d6             	mov    %rdx,%rsi
  800ff5:	bf 25 00 00 00       	mov    $0x25,%edi
  800ffa:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800ffc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801001:	eb 05                	jmp    801008 <vprintfmt+0x4f9>
  801003:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801008:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80100c:	48 83 e8 01          	sub    $0x1,%rax
  801010:	0f b6 00             	movzbl (%rax),%eax
  801013:	3c 25                	cmp    $0x25,%al
  801015:	75 ec                	jne    801003 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801017:	90                   	nop
		}
	}
  801018:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801019:	e9 43 fb ff ff       	jmpq   800b61 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  80101e:	48 83 c4 60          	add    $0x60,%rsp
  801022:	5b                   	pop    %rbx
  801023:	41 5c                	pop    %r12
  801025:	5d                   	pop    %rbp
  801026:	c3                   	retq   

0000000000801027 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801027:	55                   	push   %rbp
  801028:	48 89 e5             	mov    %rsp,%rbp
  80102b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801032:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801039:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801040:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801047:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80104e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801055:	84 c0                	test   %al,%al
  801057:	74 20                	je     801079 <printfmt+0x52>
  801059:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80105d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801061:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801065:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801069:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80106d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801071:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801075:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801079:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801080:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801087:	00 00 00 
  80108a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801091:	00 00 00 
  801094:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801098:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80109f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010a6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010ad:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010b4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010bb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010c2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010c9:	48 89 c7             	mov    %rax,%rdi
  8010cc:	48 b8 0f 0b 80 00 00 	movabs $0x800b0f,%rax
  8010d3:	00 00 00 
  8010d6:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010d8:	c9                   	leaveq 
  8010d9:	c3                   	retq   

00000000008010da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010da:	55                   	push   %rbp
  8010db:	48 89 e5             	mov    %rsp,%rbp
  8010de:	48 83 ec 10          	sub    $0x10,%rsp
  8010e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ed:	8b 40 10             	mov    0x10(%rax),%eax
  8010f0:	8d 50 01             	lea    0x1(%rax),%edx
  8010f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fe:	48 8b 10             	mov    (%rax),%rdx
  801101:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801105:	48 8b 40 08          	mov    0x8(%rax),%rax
  801109:	48 39 c2             	cmp    %rax,%rdx
  80110c:	73 17                	jae    801125 <sprintputch+0x4b>
		*b->buf++ = ch;
  80110e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801112:	48 8b 00             	mov    (%rax),%rax
  801115:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801119:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80111d:	48 89 0a             	mov    %rcx,(%rdx)
  801120:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801123:	88 10                	mov    %dl,(%rax)
}
  801125:	c9                   	leaveq 
  801126:	c3                   	retq   

0000000000801127 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801127:	55                   	push   %rbp
  801128:	48 89 e5             	mov    %rsp,%rbp
  80112b:	48 83 ec 50          	sub    $0x50,%rsp
  80112f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801133:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801136:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80113a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80113e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801142:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801146:	48 8b 0a             	mov    (%rdx),%rcx
  801149:	48 89 08             	mov    %rcx,(%rax)
  80114c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801150:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801154:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801158:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80115c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801160:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801164:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801167:	48 98                	cltq   
  801169:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80116d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801171:	48 01 d0             	add    %rdx,%rax
  801174:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801178:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80117f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801184:	74 06                	je     80118c <vsnprintf+0x65>
  801186:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80118a:	7f 07                	jg     801193 <vsnprintf+0x6c>
		return -E_INVAL;
  80118c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801191:	eb 2f                	jmp    8011c2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801193:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801197:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80119b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80119f:	48 89 c6             	mov    %rax,%rsi
  8011a2:	48 bf da 10 80 00 00 	movabs $0x8010da,%rdi
  8011a9:	00 00 00 
  8011ac:	48 b8 0f 0b 80 00 00 	movabs $0x800b0f,%rax
  8011b3:	00 00 00 
  8011b6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011bc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011bf:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011c2:	c9                   	leaveq 
  8011c3:	c3                   	retq   

00000000008011c4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011c4:	55                   	push   %rbp
  8011c5:	48 89 e5             	mov    %rsp,%rbp
  8011c8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011cf:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011d6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011dc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011e3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011ea:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011f1:	84 c0                	test   %al,%al
  8011f3:	74 20                	je     801215 <snprintf+0x51>
  8011f5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011f9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011fd:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801201:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801205:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801209:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80120d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801211:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801215:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80121c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801223:	00 00 00 
  801226:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80122d:	00 00 00 
  801230:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801234:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80123b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801242:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801249:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801250:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801257:	48 8b 0a             	mov    (%rdx),%rcx
  80125a:	48 89 08             	mov    %rcx,(%rax)
  80125d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801261:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801265:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801269:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80126d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801274:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80127b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801281:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801288:	48 89 c7             	mov    %rax,%rdi
  80128b:	48 b8 27 11 80 00 00 	movabs $0x801127,%rax
  801292:	00 00 00 
  801295:	ff d0                	callq  *%rax
  801297:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80129d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012a3:	c9                   	leaveq 
  8012a4:	c3                   	retq   

00000000008012a5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012a5:	55                   	push   %rbp
  8012a6:	48 89 e5             	mov    %rsp,%rbp
  8012a9:	48 83 ec 18          	sub    $0x18,%rsp
  8012ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012b8:	eb 09                	jmp    8012c3 <strlen+0x1e>
		n++;
  8012ba:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012be:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	0f b6 00             	movzbl (%rax),%eax
  8012ca:	84 c0                	test   %al,%al
  8012cc:	75 ec                	jne    8012ba <strlen+0x15>
		n++;
	return n;
  8012ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012d1:	c9                   	leaveq 
  8012d2:	c3                   	retq   

00000000008012d3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012d3:	55                   	push   %rbp
  8012d4:	48 89 e5             	mov    %rsp,%rbp
  8012d7:	48 83 ec 20          	sub    $0x20,%rsp
  8012db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012ea:	eb 0e                	jmp    8012fa <strnlen+0x27>
		n++;
  8012ec:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012f5:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012fa:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012ff:	74 0b                	je     80130c <strnlen+0x39>
  801301:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801305:	0f b6 00             	movzbl (%rax),%eax
  801308:	84 c0                	test   %al,%al
  80130a:	75 e0                	jne    8012ec <strnlen+0x19>
		n++;
	return n;
  80130c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80130f:	c9                   	leaveq 
  801310:	c3                   	retq   

0000000000801311 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801311:	55                   	push   %rbp
  801312:	48 89 e5             	mov    %rsp,%rbp
  801315:	48 83 ec 20          	sub    $0x20,%rsp
  801319:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80131d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801321:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801325:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801329:	90                   	nop
  80132a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801332:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801336:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80133a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80133e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801342:	0f b6 12             	movzbl (%rdx),%edx
  801345:	88 10                	mov    %dl,(%rax)
  801347:	0f b6 00             	movzbl (%rax),%eax
  80134a:	84 c0                	test   %al,%al
  80134c:	75 dc                	jne    80132a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801352:	c9                   	leaveq 
  801353:	c3                   	retq   

0000000000801354 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801354:	55                   	push   %rbp
  801355:	48 89 e5             	mov    %rsp,%rbp
  801358:	48 83 ec 20          	sub    $0x20,%rsp
  80135c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801360:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801364:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801368:	48 89 c7             	mov    %rax,%rdi
  80136b:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  801372:	00 00 00 
  801375:	ff d0                	callq  *%rax
  801377:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80137a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80137d:	48 63 d0             	movslq %eax,%rdx
  801380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801384:	48 01 c2             	add    %rax,%rdx
  801387:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80138b:	48 89 c6             	mov    %rax,%rsi
  80138e:	48 89 d7             	mov    %rdx,%rdi
  801391:	48 b8 11 13 80 00 00 	movabs $0x801311,%rax
  801398:	00 00 00 
  80139b:	ff d0                	callq  *%rax
	return dst;
  80139d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013a1:	c9                   	leaveq 
  8013a2:	c3                   	retq   

00000000008013a3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013a3:	55                   	push   %rbp
  8013a4:	48 89 e5             	mov    %rsp,%rbp
  8013a7:	48 83 ec 28          	sub    $0x28,%rsp
  8013ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013bf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013c6:	00 
  8013c7:	eb 2a                	jmp    8013f3 <strncpy+0x50>
		*dst++ = *src;
  8013c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013d1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013d5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013d9:	0f b6 12             	movzbl (%rdx),%edx
  8013dc:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e2:	0f b6 00             	movzbl (%rax),%eax
  8013e5:	84 c0                	test   %al,%al
  8013e7:	74 05                	je     8013ee <strncpy+0x4b>
			src++;
  8013e9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013fb:	72 cc                	jb     8013c9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801401:	c9                   	leaveq 
  801402:	c3                   	retq   

0000000000801403 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801403:	55                   	push   %rbp
  801404:	48 89 e5             	mov    %rsp,%rbp
  801407:	48 83 ec 28          	sub    $0x28,%rsp
  80140b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80140f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801413:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801417:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80141f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801424:	74 3d                	je     801463 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801426:	eb 1d                	jmp    801445 <strlcpy+0x42>
			*dst++ = *src++;
  801428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801430:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801434:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801438:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80143c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801440:	0f b6 12             	movzbl (%rdx),%edx
  801443:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80144a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80144f:	74 0b                	je     80145c <strlcpy+0x59>
  801451:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	84 c0                	test   %al,%al
  80145a:	75 cc                	jne    801428 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80145c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801460:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801463:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146b:	48 29 c2             	sub    %rax,%rdx
  80146e:	48 89 d0             	mov    %rdx,%rax
}
  801471:	c9                   	leaveq 
  801472:	c3                   	retq   

0000000000801473 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801473:	55                   	push   %rbp
  801474:	48 89 e5             	mov    %rsp,%rbp
  801477:	48 83 ec 10          	sub    $0x10,%rsp
  80147b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801483:	eb 0a                	jmp    80148f <strcmp+0x1c>
		p++, q++;
  801485:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80148a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80148f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801493:	0f b6 00             	movzbl (%rax),%eax
  801496:	84 c0                	test   %al,%al
  801498:	74 12                	je     8014ac <strcmp+0x39>
  80149a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149e:	0f b6 10             	movzbl (%rax),%edx
  8014a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a5:	0f b6 00             	movzbl (%rax),%eax
  8014a8:	38 c2                	cmp    %al,%dl
  8014aa:	74 d9                	je     801485 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b0:	0f b6 00             	movzbl (%rax),%eax
  8014b3:	0f b6 d0             	movzbl %al,%edx
  8014b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ba:	0f b6 00             	movzbl (%rax),%eax
  8014bd:	0f b6 c0             	movzbl %al,%eax
  8014c0:	29 c2                	sub    %eax,%edx
  8014c2:	89 d0                	mov    %edx,%eax
}
  8014c4:	c9                   	leaveq 
  8014c5:	c3                   	retq   

00000000008014c6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014c6:	55                   	push   %rbp
  8014c7:	48 89 e5             	mov    %rsp,%rbp
  8014ca:	48 83 ec 18          	sub    $0x18,%rsp
  8014ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014da:	eb 0f                	jmp    8014eb <strncmp+0x25>
		n--, p++, q++;
  8014dc:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014e1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014eb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014f0:	74 1d                	je     80150f <strncmp+0x49>
  8014f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f6:	0f b6 00             	movzbl (%rax),%eax
  8014f9:	84 c0                	test   %al,%al
  8014fb:	74 12                	je     80150f <strncmp+0x49>
  8014fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801501:	0f b6 10             	movzbl (%rax),%edx
  801504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	38 c2                	cmp    %al,%dl
  80150d:	74 cd                	je     8014dc <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80150f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801514:	75 07                	jne    80151d <strncmp+0x57>
		return 0;
  801516:	b8 00 00 00 00       	mov    $0x0,%eax
  80151b:	eb 18                	jmp    801535 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801521:	0f b6 00             	movzbl (%rax),%eax
  801524:	0f b6 d0             	movzbl %al,%edx
  801527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80152b:	0f b6 00             	movzbl (%rax),%eax
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
}
  801535:	c9                   	leaveq 
  801536:	c3                   	retq   

0000000000801537 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801537:	55                   	push   %rbp
  801538:	48 89 e5             	mov    %rsp,%rbp
  80153b:	48 83 ec 0c          	sub    $0xc,%rsp
  80153f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801543:	89 f0                	mov    %esi,%eax
  801545:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801548:	eb 17                	jmp    801561 <strchr+0x2a>
		if (*s == c)
  80154a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154e:	0f b6 00             	movzbl (%rax),%eax
  801551:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801554:	75 06                	jne    80155c <strchr+0x25>
			return (char *) s;
  801556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155a:	eb 15                	jmp    801571 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80155c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801565:	0f b6 00             	movzbl (%rax),%eax
  801568:	84 c0                	test   %al,%al
  80156a:	75 de                	jne    80154a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801571:	c9                   	leaveq 
  801572:	c3                   	retq   

0000000000801573 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801573:	55                   	push   %rbp
  801574:	48 89 e5             	mov    %rsp,%rbp
  801577:	48 83 ec 0c          	sub    $0xc,%rsp
  80157b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80157f:	89 f0                	mov    %esi,%eax
  801581:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801584:	eb 13                	jmp    801599 <strfind+0x26>
		if (*s == c)
  801586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158a:	0f b6 00             	movzbl (%rax),%eax
  80158d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801590:	75 02                	jne    801594 <strfind+0x21>
			break;
  801592:	eb 10                	jmp    8015a4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801594:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801599:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159d:	0f b6 00             	movzbl (%rax),%eax
  8015a0:	84 c0                	test   %al,%al
  8015a2:	75 e2                	jne    801586 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8015a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015a8:	c9                   	leaveq 
  8015a9:	c3                   	retq   

00000000008015aa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015aa:	55                   	push   %rbp
  8015ab:	48 89 e5             	mov    %rsp,%rbp
  8015ae:	48 83 ec 18          	sub    $0x18,%rsp
  8015b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015b6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015bd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015c2:	75 06                	jne    8015ca <memset+0x20>
		return v;
  8015c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015c8:	eb 69                	jmp    801633 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ce:	83 e0 03             	and    $0x3,%eax
  8015d1:	48 85 c0             	test   %rax,%rax
  8015d4:	75 48                	jne    80161e <memset+0x74>
  8015d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015da:	83 e0 03             	and    $0x3,%eax
  8015dd:	48 85 c0             	test   %rax,%rax
  8015e0:	75 3c                	jne    80161e <memset+0x74>
		c &= 0xFF;
  8015e2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ec:	c1 e0 18             	shl    $0x18,%eax
  8015ef:	89 c2                	mov    %eax,%edx
  8015f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f4:	c1 e0 10             	shl    $0x10,%eax
  8015f7:	09 c2                	or     %eax,%edx
  8015f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fc:	c1 e0 08             	shl    $0x8,%eax
  8015ff:	09 d0                	or     %edx,%eax
  801601:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801604:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801608:	48 c1 e8 02          	shr    $0x2,%rax
  80160c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80160f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801613:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801616:	48 89 d7             	mov    %rdx,%rdi
  801619:	fc                   	cld    
  80161a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80161c:	eb 11                	jmp    80162f <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80161e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801622:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801625:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801629:	48 89 d7             	mov    %rdx,%rdi
  80162c:	fc                   	cld    
  80162d:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80162f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801633:	c9                   	leaveq 
  801634:	c3                   	retq   

0000000000801635 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801635:	55                   	push   %rbp
  801636:	48 89 e5             	mov    %rsp,%rbp
  801639:	48 83 ec 28          	sub    $0x28,%rsp
  80163d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801641:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801645:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801649:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80164d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801655:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801659:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801661:	0f 83 88 00 00 00    	jae    8016ef <memmove+0xba>
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80166f:	48 01 d0             	add    %rdx,%rax
  801672:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801676:	76 77                	jbe    8016ef <memmove+0xba>
		s += n;
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801680:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801684:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801688:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168c:	83 e0 03             	and    $0x3,%eax
  80168f:	48 85 c0             	test   %rax,%rax
  801692:	75 3b                	jne    8016cf <memmove+0x9a>
  801694:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801698:	83 e0 03             	and    $0x3,%eax
  80169b:	48 85 c0             	test   %rax,%rax
  80169e:	75 2f                	jne    8016cf <memmove+0x9a>
  8016a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a4:	83 e0 03             	and    $0x3,%eax
  8016a7:	48 85 c0             	test   %rax,%rax
  8016aa:	75 23                	jne    8016cf <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b0:	48 83 e8 04          	sub    $0x4,%rax
  8016b4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b8:	48 83 ea 04          	sub    $0x4,%rdx
  8016bc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016c0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016c4:	48 89 c7             	mov    %rax,%rdi
  8016c7:	48 89 d6             	mov    %rdx,%rsi
  8016ca:	fd                   	std    
  8016cb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016cd:	eb 1d                	jmp    8016ec <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016db:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e3:	48 89 d7             	mov    %rdx,%rdi
  8016e6:	48 89 c1             	mov    %rax,%rcx
  8016e9:	fd                   	std    
  8016ea:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016ec:	fc                   	cld    
  8016ed:	eb 57                	jmp    801746 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f3:	83 e0 03             	and    $0x3,%eax
  8016f6:	48 85 c0             	test   %rax,%rax
  8016f9:	75 36                	jne    801731 <memmove+0xfc>
  8016fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ff:	83 e0 03             	and    $0x3,%eax
  801702:	48 85 c0             	test   %rax,%rax
  801705:	75 2a                	jne    801731 <memmove+0xfc>
  801707:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170b:	83 e0 03             	and    $0x3,%eax
  80170e:	48 85 c0             	test   %rax,%rax
  801711:	75 1e                	jne    801731 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801713:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801717:	48 c1 e8 02          	shr    $0x2,%rax
  80171b:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80171e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801722:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801726:	48 89 c7             	mov    %rax,%rdi
  801729:	48 89 d6             	mov    %rdx,%rsi
  80172c:	fc                   	cld    
  80172d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80172f:	eb 15                	jmp    801746 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801731:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801735:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801739:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80173d:	48 89 c7             	mov    %rax,%rdi
  801740:	48 89 d6             	mov    %rdx,%rsi
  801743:	fc                   	cld    
  801744:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801746:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80174a:	c9                   	leaveq 
  80174b:	c3                   	retq   

000000000080174c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80174c:	55                   	push   %rbp
  80174d:	48 89 e5             	mov    %rsp,%rbp
  801750:	48 83 ec 18          	sub    $0x18,%rsp
  801754:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801758:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80175c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801760:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801764:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80176c:	48 89 ce             	mov    %rcx,%rsi
  80176f:	48 89 c7             	mov    %rax,%rdi
  801772:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  801779:	00 00 00 
  80177c:	ff d0                	callq  *%rax
}
  80177e:	c9                   	leaveq 
  80177f:	c3                   	retq   

0000000000801780 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801780:	55                   	push   %rbp
  801781:	48 89 e5             	mov    %rsp,%rbp
  801784:	48 83 ec 28          	sub    $0x28,%rsp
  801788:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80178c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801790:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801798:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80179c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8017a4:	eb 36                	jmp    8017dc <memcmp+0x5c>
		if (*s1 != *s2)
  8017a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017aa:	0f b6 10             	movzbl (%rax),%edx
  8017ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b1:	0f b6 00             	movzbl (%rax),%eax
  8017b4:	38 c2                	cmp    %al,%dl
  8017b6:	74 1a                	je     8017d2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017bc:	0f b6 00             	movzbl (%rax),%eax
  8017bf:	0f b6 d0             	movzbl %al,%edx
  8017c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017c6:	0f b6 00             	movzbl (%rax),%eax
  8017c9:	0f b6 c0             	movzbl %al,%eax
  8017cc:	29 c2                	sub    %eax,%edx
  8017ce:	89 d0                	mov    %edx,%eax
  8017d0:	eb 20                	jmp    8017f2 <memcmp+0x72>
		s1++, s2++;
  8017d2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017d7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017e8:	48 85 c0             	test   %rax,%rax
  8017eb:	75 b9                	jne    8017a6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f2:	c9                   	leaveq 
  8017f3:	c3                   	retq   

00000000008017f4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017f4:	55                   	push   %rbp
  8017f5:	48 89 e5             	mov    %rsp,%rbp
  8017f8:	48 83 ec 28          	sub    $0x28,%rsp
  8017fc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801800:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801803:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801807:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80180f:	48 01 d0             	add    %rdx,%rax
  801812:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801816:	eb 15                	jmp    80182d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801818:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80181c:	0f b6 10             	movzbl (%rax),%edx
  80181f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801822:	38 c2                	cmp    %al,%dl
  801824:	75 02                	jne    801828 <memfind+0x34>
			break;
  801826:	eb 0f                	jmp    801837 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801828:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80182d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801831:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801835:	72 e1                	jb     801818 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80183b:	c9                   	leaveq 
  80183c:	c3                   	retq   

000000000080183d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80183d:	55                   	push   %rbp
  80183e:	48 89 e5             	mov    %rsp,%rbp
  801841:	48 83 ec 34          	sub    $0x34,%rsp
  801845:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801849:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80184d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801850:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801857:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80185e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80185f:	eb 05                	jmp    801866 <strtol+0x29>
		s++;
  801861:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801866:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186a:	0f b6 00             	movzbl (%rax),%eax
  80186d:	3c 20                	cmp    $0x20,%al
  80186f:	74 f0                	je     801861 <strtol+0x24>
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	0f b6 00             	movzbl (%rax),%eax
  801878:	3c 09                	cmp    $0x9,%al
  80187a:	74 e5                	je     801861 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80187c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801880:	0f b6 00             	movzbl (%rax),%eax
  801883:	3c 2b                	cmp    $0x2b,%al
  801885:	75 07                	jne    80188e <strtol+0x51>
		s++;
  801887:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188c:	eb 17                	jmp    8018a5 <strtol+0x68>
	else if (*s == '-')
  80188e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801892:	0f b6 00             	movzbl (%rax),%eax
  801895:	3c 2d                	cmp    $0x2d,%al
  801897:	75 0c                	jne    8018a5 <strtol+0x68>
		s++, neg = 1;
  801899:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80189e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018a9:	74 06                	je     8018b1 <strtol+0x74>
  8018ab:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018af:	75 28                	jne    8018d9 <strtol+0x9c>
  8018b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b5:	0f b6 00             	movzbl (%rax),%eax
  8018b8:	3c 30                	cmp    $0x30,%al
  8018ba:	75 1d                	jne    8018d9 <strtol+0x9c>
  8018bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c0:	48 83 c0 01          	add    $0x1,%rax
  8018c4:	0f b6 00             	movzbl (%rax),%eax
  8018c7:	3c 78                	cmp    $0x78,%al
  8018c9:	75 0e                	jne    8018d9 <strtol+0x9c>
		s += 2, base = 16;
  8018cb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018d0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018d7:	eb 2c                	jmp    801905 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018dd:	75 19                	jne    8018f8 <strtol+0xbb>
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	0f b6 00             	movzbl (%rax),%eax
  8018e6:	3c 30                	cmp    $0x30,%al
  8018e8:	75 0e                	jne    8018f8 <strtol+0xbb>
		s++, base = 8;
  8018ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018ef:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018f6:	eb 0d                	jmp    801905 <strtol+0xc8>
	else if (base == 0)
  8018f8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018fc:	75 07                	jne    801905 <strtol+0xc8>
		base = 10;
  8018fe:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801905:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801909:	0f b6 00             	movzbl (%rax),%eax
  80190c:	3c 2f                	cmp    $0x2f,%al
  80190e:	7e 1d                	jle    80192d <strtol+0xf0>
  801910:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801914:	0f b6 00             	movzbl (%rax),%eax
  801917:	3c 39                	cmp    $0x39,%al
  801919:	7f 12                	jg     80192d <strtol+0xf0>
			dig = *s - '0';
  80191b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191f:	0f b6 00             	movzbl (%rax),%eax
  801922:	0f be c0             	movsbl %al,%eax
  801925:	83 e8 30             	sub    $0x30,%eax
  801928:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80192b:	eb 4e                	jmp    80197b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80192d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801931:	0f b6 00             	movzbl (%rax),%eax
  801934:	3c 60                	cmp    $0x60,%al
  801936:	7e 1d                	jle    801955 <strtol+0x118>
  801938:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193c:	0f b6 00             	movzbl (%rax),%eax
  80193f:	3c 7a                	cmp    $0x7a,%al
  801941:	7f 12                	jg     801955 <strtol+0x118>
			dig = *s - 'a' + 10;
  801943:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801947:	0f b6 00             	movzbl (%rax),%eax
  80194a:	0f be c0             	movsbl %al,%eax
  80194d:	83 e8 57             	sub    $0x57,%eax
  801950:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801953:	eb 26                	jmp    80197b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801955:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801959:	0f b6 00             	movzbl (%rax),%eax
  80195c:	3c 40                	cmp    $0x40,%al
  80195e:	7e 48                	jle    8019a8 <strtol+0x16b>
  801960:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801964:	0f b6 00             	movzbl (%rax),%eax
  801967:	3c 5a                	cmp    $0x5a,%al
  801969:	7f 3d                	jg     8019a8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80196b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196f:	0f b6 00             	movzbl (%rax),%eax
  801972:	0f be c0             	movsbl %al,%eax
  801975:	83 e8 37             	sub    $0x37,%eax
  801978:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80197b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80197e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801981:	7c 02                	jl     801985 <strtol+0x148>
			break;
  801983:	eb 23                	jmp    8019a8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801985:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80198a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80198d:	48 98                	cltq   
  80198f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801994:	48 89 c2             	mov    %rax,%rdx
  801997:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80199a:	48 98                	cltq   
  80199c:	48 01 d0             	add    %rdx,%rax
  80199f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019a3:	e9 5d ff ff ff       	jmpq   801905 <strtol+0xc8>

	if (endptr)
  8019a8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019ad:	74 0b                	je     8019ba <strtol+0x17d>
		*endptr = (char *) s;
  8019af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019b7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019be:	74 09                	je     8019c9 <strtol+0x18c>
  8019c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019c4:	48 f7 d8             	neg    %rax
  8019c7:	eb 04                	jmp    8019cd <strtol+0x190>
  8019c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019cd:	c9                   	leaveq 
  8019ce:	c3                   	retq   

00000000008019cf <strstr>:

char * strstr(const char *in, const char *str)
{
  8019cf:	55                   	push   %rbp
  8019d0:	48 89 e5             	mov    %rsp,%rbp
  8019d3:	48 83 ec 30          	sub    $0x30,%rsp
  8019d7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019db:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019e7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019eb:	0f b6 00             	movzbl (%rax),%eax
  8019ee:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8019f1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019f5:	75 06                	jne    8019fd <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8019f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fb:	eb 6b                	jmp    801a68 <strstr+0x99>

    len = strlen(str);
  8019fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a01:	48 89 c7             	mov    %rax,%rdi
  801a04:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  801a0b:	00 00 00 
  801a0e:	ff d0                	callq  *%rax
  801a10:	48 98                	cltq   
  801a12:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801a16:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a1e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a22:	0f b6 00             	movzbl (%rax),%eax
  801a25:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801a28:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a2c:	75 07                	jne    801a35 <strstr+0x66>
                return (char *) 0;
  801a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a33:	eb 33                	jmp    801a68 <strstr+0x99>
        } while (sc != c);
  801a35:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a39:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a3c:	75 d8                	jne    801a16 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a3e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a42:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4a:	48 89 ce             	mov    %rcx,%rsi
  801a4d:	48 89 c7             	mov    %rax,%rdi
  801a50:	48 b8 c6 14 80 00 00 	movabs $0x8014c6,%rax
  801a57:	00 00 00 
  801a5a:	ff d0                	callq  *%rax
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	75 b6                	jne    801a16 <strstr+0x47>

    return (char *) (in - 1);
  801a60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a64:	48 83 e8 01          	sub    $0x1,%rax
}
  801a68:	c9                   	leaveq 
  801a69:	c3                   	retq   
