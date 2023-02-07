
obj/user/softint:     file format elf64-x86-64


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
  80003c:	e8 15 00 00 00       	callq  800056 <libmain>
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
	asm volatile("int $14");	// page fault
  800052:	cd 0e                	int    $0xe
}
  800054:	c9                   	leaveq 
  800055:	c3                   	retq   

0000000000800056 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800056:	55                   	push   %rbp
  800057:	48 89 e5             	mov    %rsp,%rbp
  80005a:	48 83 ec 20          	sub    $0x20,%rsp
  80005e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800061:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800065:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80006c:	00 00 00 
  80006f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  800076:	48 b8 6b 02 80 00 00 	movabs $0x80026b,%rax
  80007d:	00 00 00 
  800080:	ff d0                	callq  *%rax
  800082:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  800085:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  80008c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008f:	48 63 d0             	movslq %eax,%rdx
  800092:	48 89 d0             	mov    %rdx,%rax
  800095:	48 c1 e0 03          	shl    $0x3,%rax
  800099:	48 01 d0             	add    %rdx,%rax
  80009c:	48 c1 e0 05          	shl    $0x5,%rax
  8000a0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000a7:	00 00 00 
  8000aa:	48 01 c2             	add    %rax,%rdx
  8000ad:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000b4:	00 00 00 
  8000b7:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000be:	7e 14                	jle    8000d4 <libmain+0x7e>
		binaryname = argv[0];
  8000c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000c4:	48 8b 10             	mov    (%rax),%rdx
  8000c7:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000ce:	00 00 00 
  8000d1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000db:	48 89 d6             	mov    %rdx,%rsi
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  8000ec:	48 b8 fa 00 80 00 00 	movabs $0x8000fa,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax
}
  8000f8:	c9                   	leaveq 
  8000f9:	c3                   	retq   

00000000008000fa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fa:	55                   	push   %rbp
  8000fb:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8000fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800103:	48 b8 27 02 80 00 00 	movabs $0x800227,%rax
  80010a:	00 00 00 
  80010d:	ff d0                	callq  *%rax
}
  80010f:	5d                   	pop    %rbp
  800110:	c3                   	retq   

0000000000800111 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800111:	55                   	push   %rbp
  800112:	48 89 e5             	mov    %rsp,%rbp
  800115:	53                   	push   %rbx
  800116:	48 83 ec 48          	sub    $0x48,%rsp
  80011a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80011d:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800120:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800124:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800128:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80012c:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800130:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800133:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800137:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80013b:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80013f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800143:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800147:	4c 89 c3             	mov    %r8,%rbx
  80014a:	cd 30                	int    $0x30
  80014c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800150:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800154:	74 3e                	je     800194 <syscall+0x83>
  800156:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80015b:	7e 37                	jle    800194 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80015d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800161:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800164:	49 89 d0             	mov    %rdx,%r8
  800167:	89 c1                	mov    %eax,%ecx
  800169:	48 ba 6a 1a 80 00 00 	movabs $0x801a6a,%rdx
  800170:	00 00 00 
  800173:	be 23 00 00 00       	mov    $0x23,%esi
  800178:	48 bf 87 1a 80 00 00 	movabs $0x801a87,%rdi
  80017f:	00 00 00 
  800182:	b8 00 00 00 00       	mov    $0x0,%eax
  800187:	49 b9 0a 05 80 00 00 	movabs $0x80050a,%r9
  80018e:	00 00 00 
  800191:	41 ff d1             	callq  *%r9

	return ret;
  800194:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800198:	48 83 c4 48          	add    $0x48,%rsp
  80019c:	5b                   	pop    %rbx
  80019d:	5d                   	pop    %rbp
  80019e:	c3                   	retq   

000000000080019f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80019f:	55                   	push   %rbp
  8001a0:	48 89 e5             	mov    %rsp,%rbp
  8001a3:	48 83 ec 20          	sub    $0x20,%rsp
  8001a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001be:	00 
  8001bf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001c5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001cb:	48 89 d1             	mov    %rdx,%rcx
  8001ce:	48 89 c2             	mov    %rax,%rdx
  8001d1:	be 00 00 00 00       	mov    $0x0,%esi
  8001d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8001db:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax
}
  8001e7:	c9                   	leaveq 
  8001e8:	c3                   	retq   

00000000008001e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001e9:	55                   	push   %rbp
  8001ea:	48 89 e5             	mov    %rsp,%rbp
  8001ed:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001f8:	00 
  8001f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800205:	b9 00 00 00 00       	mov    $0x0,%ecx
  80020a:	ba 00 00 00 00       	mov    $0x0,%edx
  80020f:	be 00 00 00 00       	mov    $0x0,%esi
  800214:	bf 01 00 00 00       	mov    $0x1,%edi
  800219:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  800220:	00 00 00 
  800223:	ff d0                	callq  *%rax
}
  800225:	c9                   	leaveq 
  800226:	c3                   	retq   

0000000000800227 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800227:	55                   	push   %rbp
  800228:	48 89 e5             	mov    %rsp,%rbp
  80022b:	48 83 ec 10          	sub    $0x10,%rsp
  80022f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800232:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800235:	48 98                	cltq   
  800237:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80023e:	00 
  80023f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800245:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80024b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800250:	48 89 c2             	mov    %rax,%rdx
  800253:	be 01 00 00 00       	mov    $0x1,%esi
  800258:	bf 03 00 00 00       	mov    $0x3,%edi
  80025d:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
}
  800269:	c9                   	leaveq 
  80026a:	c3                   	retq   

000000000080026b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80026b:	55                   	push   %rbp
  80026c:	48 89 e5             	mov    %rsp,%rbp
  80026f:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800273:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80027a:	00 
  80027b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800281:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800287:	b9 00 00 00 00       	mov    $0x0,%ecx
  80028c:	ba 00 00 00 00       	mov    $0x0,%edx
  800291:	be 00 00 00 00       	mov    $0x0,%esi
  800296:	bf 02 00 00 00       	mov    $0x2,%edi
  80029b:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  8002a2:	00 00 00 
  8002a5:	ff d0                	callq  *%rax
}
  8002a7:	c9                   	leaveq 
  8002a8:	c3                   	retq   

00000000008002a9 <sys_yield>:

void
sys_yield(void)
{
  8002a9:	55                   	push   %rbp
  8002aa:	48 89 e5             	mov    %rsp,%rbp
  8002ad:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002b1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002b8:	00 
  8002b9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002c5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8002cf:	be 00 00 00 00       	mov    $0x0,%esi
  8002d4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002d9:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  8002e0:	00 00 00 
  8002e3:	ff d0                	callq  *%rax
}
  8002e5:	c9                   	leaveq 
  8002e6:	c3                   	retq   

00000000008002e7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002e7:	55                   	push   %rbp
  8002e8:	48 89 e5             	mov    %rsp,%rbp
  8002eb:	48 83 ec 20          	sub    $0x20,%rsp
  8002ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002f6:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8002f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002fc:	48 63 c8             	movslq %eax,%rcx
  8002ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800303:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800306:	48 98                	cltq   
  800308:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80030f:	00 
  800310:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800316:	49 89 c8             	mov    %rcx,%r8
  800319:	48 89 d1             	mov    %rdx,%rcx
  80031c:	48 89 c2             	mov    %rax,%rdx
  80031f:	be 01 00 00 00       	mov    $0x1,%esi
  800324:	bf 04 00 00 00       	mov    $0x4,%edi
  800329:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  800330:	00 00 00 
  800333:	ff d0                	callq  *%rax
}
  800335:	c9                   	leaveq 
  800336:	c3                   	retq   

0000000000800337 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800337:	55                   	push   %rbp
  800338:	48 89 e5             	mov    %rsp,%rbp
  80033b:	48 83 ec 30          	sub    $0x30,%rsp
  80033f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800342:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800346:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800349:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80034d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800351:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800354:	48 63 c8             	movslq %eax,%rcx
  800357:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80035b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80035e:	48 63 f0             	movslq %eax,%rsi
  800361:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800365:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800368:	48 98                	cltq   
  80036a:	48 89 0c 24          	mov    %rcx,(%rsp)
  80036e:	49 89 f9             	mov    %rdi,%r9
  800371:	49 89 f0             	mov    %rsi,%r8
  800374:	48 89 d1             	mov    %rdx,%rcx
  800377:	48 89 c2             	mov    %rax,%rdx
  80037a:	be 01 00 00 00       	mov    $0x1,%esi
  80037f:	bf 05 00 00 00       	mov    $0x5,%edi
  800384:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  80038b:	00 00 00 
  80038e:	ff d0                	callq  *%rax
}
  800390:	c9                   	leaveq 
  800391:	c3                   	retq   

0000000000800392 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800392:	55                   	push   %rbp
  800393:	48 89 e5             	mov    %rsp,%rbp
  800396:	48 83 ec 20          	sub    $0x20,%rsp
  80039a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80039d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003a1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a8:	48 98                	cltq   
  8003aa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003b1:	00 
  8003b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003be:	48 89 d1             	mov    %rdx,%rcx
  8003c1:	48 89 c2             	mov    %rax,%rdx
  8003c4:	be 01 00 00 00       	mov    $0x1,%esi
  8003c9:	bf 06 00 00 00       	mov    $0x6,%edi
  8003ce:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  8003d5:	00 00 00 
  8003d8:	ff d0                	callq  *%rax
}
  8003da:	c9                   	leaveq 
  8003db:	c3                   	retq   

00000000008003dc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003dc:	55                   	push   %rbp
  8003dd:	48 89 e5             	mov    %rsp,%rbp
  8003e0:	48 83 ec 10          	sub    $0x10,%rsp
  8003e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003e7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ed:	48 63 d0             	movslq %eax,%rdx
  8003f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f3:	48 98                	cltq   
  8003f5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003fc:	00 
  8003fd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800403:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800409:	48 89 d1             	mov    %rdx,%rcx
  80040c:	48 89 c2             	mov    %rax,%rdx
  80040f:	be 01 00 00 00       	mov    $0x1,%esi
  800414:	bf 08 00 00 00       	mov    $0x8,%edi
  800419:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  800420:	00 00 00 
  800423:	ff d0                	callq  *%rax
}
  800425:	c9                   	leaveq 
  800426:	c3                   	retq   

0000000000800427 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800427:	55                   	push   %rbp
  800428:	48 89 e5             	mov    %rsp,%rbp
  80042b:	48 83 ec 20          	sub    $0x20,%rsp
  80042f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800432:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800436:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80043a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80043d:	48 98                	cltq   
  80043f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800446:	00 
  800447:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80044d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800453:	48 89 d1             	mov    %rdx,%rcx
  800456:	48 89 c2             	mov    %rax,%rdx
  800459:	be 01 00 00 00       	mov    $0x1,%esi
  80045e:	bf 09 00 00 00       	mov    $0x9,%edi
  800463:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  80046a:	00 00 00 
  80046d:	ff d0                	callq  *%rax
}
  80046f:	c9                   	leaveq 
  800470:	c3                   	retq   

0000000000800471 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800471:	55                   	push   %rbp
  800472:	48 89 e5             	mov    %rsp,%rbp
  800475:	48 83 ec 20          	sub    $0x20,%rsp
  800479:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80047c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800480:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800484:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800487:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80048a:	48 63 f0             	movslq %eax,%rsi
  80048d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800491:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800494:	48 98                	cltq   
  800496:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004a1:	00 
  8004a2:	49 89 f1             	mov    %rsi,%r9
  8004a5:	49 89 c8             	mov    %rcx,%r8
  8004a8:	48 89 d1             	mov    %rdx,%rcx
  8004ab:	48 89 c2             	mov    %rax,%rdx
  8004ae:	be 00 00 00 00       	mov    $0x0,%esi
  8004b3:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004b8:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  8004bf:	00 00 00 
  8004c2:	ff d0                	callq  *%rax
}
  8004c4:	c9                   	leaveq 
  8004c5:	c3                   	retq   

00000000008004c6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004c6:	55                   	push   %rbp
  8004c7:	48 89 e5             	mov    %rsp,%rbp
  8004ca:	48 83 ec 10          	sub    $0x10,%rsp
  8004ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004dd:	00 
  8004de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004ef:	48 89 c2             	mov    %rax,%rdx
  8004f2:	be 01 00 00 00       	mov    $0x1,%esi
  8004f7:	bf 0c 00 00 00       	mov    $0xc,%edi
  8004fc:	48 b8 11 01 80 00 00 	movabs $0x800111,%rax
  800503:	00 00 00 
  800506:	ff d0                	callq  *%rax
}
  800508:	c9                   	leaveq 
  800509:	c3                   	retq   

000000000080050a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80050a:	55                   	push   %rbp
  80050b:	48 89 e5             	mov    %rsp,%rbp
  80050e:	53                   	push   %rbx
  80050f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800516:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80051d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800523:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80052a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800531:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800538:	84 c0                	test   %al,%al
  80053a:	74 23                	je     80055f <_panic+0x55>
  80053c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800543:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800547:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80054b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80054f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800553:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800557:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80055b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80055f:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800566:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80056d:	00 00 00 
  800570:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800577:	00 00 00 
  80057a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80057e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800585:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80058c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800593:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80059a:	00 00 00 
  80059d:	48 8b 18             	mov    (%rax),%rbx
  8005a0:	48 b8 6b 02 80 00 00 	movabs $0x80026b,%rax
  8005a7:	00 00 00 
  8005aa:	ff d0                	callq  *%rax
  8005ac:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005b2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005b9:	41 89 c8             	mov    %ecx,%r8d
  8005bc:	48 89 d1             	mov    %rdx,%rcx
  8005bf:	48 89 da             	mov    %rbx,%rdx
  8005c2:	89 c6                	mov    %eax,%esi
  8005c4:	48 bf 98 1a 80 00 00 	movabs $0x801a98,%rdi
  8005cb:	00 00 00 
  8005ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d3:	49 b9 43 07 80 00 00 	movabs $0x800743,%r9
  8005da:	00 00 00 
  8005dd:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e0:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005e7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005ee:	48 89 d6             	mov    %rdx,%rsi
  8005f1:	48 89 c7             	mov    %rax,%rdi
  8005f4:	48 b8 97 06 80 00 00 	movabs $0x800697,%rax
  8005fb:	00 00 00 
  8005fe:	ff d0                	callq  *%rax
	cprintf("\n");
  800600:	48 bf bb 1a 80 00 00 	movabs $0x801abb,%rdi
  800607:	00 00 00 
  80060a:	b8 00 00 00 00       	mov    $0x0,%eax
  80060f:	48 ba 43 07 80 00 00 	movabs $0x800743,%rdx
  800616:	00 00 00 
  800619:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80061b:	cc                   	int3   
  80061c:	eb fd                	jmp    80061b <_panic+0x111>

000000000080061e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80061e:	55                   	push   %rbp
  80061f:	48 89 e5             	mov    %rsp,%rbp
  800622:	48 83 ec 10          	sub    $0x10,%rsp
  800626:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800629:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80062d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800631:	8b 00                	mov    (%rax),%eax
  800633:	8d 48 01             	lea    0x1(%rax),%ecx
  800636:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80063a:	89 0a                	mov    %ecx,(%rdx)
  80063c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80063f:	89 d1                	mov    %edx,%ecx
  800641:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800645:	48 98                	cltq   
  800647:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80064b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80064f:	8b 00                	mov    (%rax),%eax
  800651:	3d ff 00 00 00       	cmp    $0xff,%eax
  800656:	75 2c                	jne    800684 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800658:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80065c:	8b 00                	mov    (%rax),%eax
  80065e:	48 98                	cltq   
  800660:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800664:	48 83 c2 08          	add    $0x8,%rdx
  800668:	48 89 c6             	mov    %rax,%rsi
  80066b:	48 89 d7             	mov    %rdx,%rdi
  80066e:	48 b8 9f 01 80 00 00 	movabs $0x80019f,%rax
  800675:	00 00 00 
  800678:	ff d0                	callq  *%rax
		b->idx = 0;
  80067a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800688:	8b 40 04             	mov    0x4(%rax),%eax
  80068b:	8d 50 01             	lea    0x1(%rax),%edx
  80068e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800692:	89 50 04             	mov    %edx,0x4(%rax)
}
  800695:	c9                   	leaveq 
  800696:	c3                   	retq   

0000000000800697 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800697:	55                   	push   %rbp
  800698:	48 89 e5             	mov    %rsp,%rbp
  80069b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006a2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006a9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8006b0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006b7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006be:	48 8b 0a             	mov    (%rdx),%rcx
  8006c1:	48 89 08             	mov    %rcx,(%rax)
  8006c4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006c8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006cc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8006d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006db:	00 00 00 
	b.cnt = 0;
  8006de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006e5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8006e8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006ef:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006f6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006fd:	48 89 c6             	mov    %rax,%rsi
  800700:	48 bf 1e 06 80 00 00 	movabs $0x80061e,%rdi
  800707:	00 00 00 
  80070a:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  800711:	00 00 00 
  800714:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800716:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80071c:	48 98                	cltq   
  80071e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800725:	48 83 c2 08          	add    $0x8,%rdx
  800729:	48 89 c6             	mov    %rax,%rsi
  80072c:	48 89 d7             	mov    %rdx,%rdi
  80072f:	48 b8 9f 01 80 00 00 	movabs $0x80019f,%rax
  800736:	00 00 00 
  800739:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80073b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800741:	c9                   	leaveq 
  800742:	c3                   	retq   

0000000000800743 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800743:	55                   	push   %rbp
  800744:	48 89 e5             	mov    %rsp,%rbp
  800747:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80074e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800755:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80075c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800763:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80076a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800771:	84 c0                	test   %al,%al
  800773:	74 20                	je     800795 <cprintf+0x52>
  800775:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800779:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80077d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800781:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800785:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800789:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80078d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800791:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800795:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80079c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007a3:	00 00 00 
  8007a6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007ad:	00 00 00 
  8007b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007b4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007bb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007c2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8007c9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007d0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007d7:	48 8b 0a             	mov    (%rdx),%rcx
  8007da:	48 89 08             	mov    %rcx,(%rax)
  8007dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8007ed:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007f4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007fb:	48 89 d6             	mov    %rdx,%rsi
  8007fe:	48 89 c7             	mov    %rax,%rdi
  800801:	48 b8 97 06 80 00 00 	movabs $0x800697,%rax
  800808:	00 00 00 
  80080b:	ff d0                	callq  *%rax
  80080d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800813:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800819:	c9                   	leaveq 
  80081a:	c3                   	retq   

000000000080081b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80081b:	55                   	push   %rbp
  80081c:	48 89 e5             	mov    %rsp,%rbp
  80081f:	53                   	push   %rbx
  800820:	48 83 ec 38          	sub    $0x38,%rsp
  800824:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800828:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80082c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800830:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800833:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800837:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80083b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80083e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800842:	77 3b                	ja     80087f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800844:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800847:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80084b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80084e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800852:	ba 00 00 00 00       	mov    $0x0,%edx
  800857:	48 f7 f3             	div    %rbx
  80085a:	48 89 c2             	mov    %rax,%rdx
  80085d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800860:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800863:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086b:	41 89 f9             	mov    %edi,%r9d
  80086e:	48 89 c7             	mov    %rax,%rdi
  800871:	48 b8 1b 08 80 00 00 	movabs $0x80081b,%rax
  800878:	00 00 00 
  80087b:	ff d0                	callq  *%rax
  80087d:	eb 1e                	jmp    80089d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80087f:	eb 12                	jmp    800893 <printnum+0x78>
			putch(padc, putdat);
  800881:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800885:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800888:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088c:	48 89 ce             	mov    %rcx,%rsi
  80088f:	89 d7                	mov    %edx,%edi
  800891:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800893:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800897:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80089b:	7f e4                	jg     800881 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80089d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a9:	48 f7 f1             	div    %rcx
  8008ac:	48 89 d0             	mov    %rdx,%rax
  8008af:	48 ba b0 1b 80 00 00 	movabs $0x801bb0,%rdx
  8008b6:	00 00 00 
  8008b9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008bd:	0f be d0             	movsbl %al,%edx
  8008c0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c8:	48 89 ce             	mov    %rcx,%rsi
  8008cb:	89 d7                	mov    %edx,%edi
  8008cd:	ff d0                	callq  *%rax
}
  8008cf:	48 83 c4 38          	add    $0x38,%rsp
  8008d3:	5b                   	pop    %rbx
  8008d4:	5d                   	pop    %rbp
  8008d5:	c3                   	retq   

00000000008008d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008d6:	55                   	push   %rbp
  8008d7:	48 89 e5             	mov    %rsp,%rbp
  8008da:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008e5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008e9:	7e 52                	jle    80093d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ef:	8b 00                	mov    (%rax),%eax
  8008f1:	83 f8 30             	cmp    $0x30,%eax
  8008f4:	73 24                	jae    80091a <getuint+0x44>
  8008f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800902:	8b 00                	mov    (%rax),%eax
  800904:	89 c0                	mov    %eax,%eax
  800906:	48 01 d0             	add    %rdx,%rax
  800909:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80090d:	8b 12                	mov    (%rdx),%edx
  80090f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800912:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800916:	89 0a                	mov    %ecx,(%rdx)
  800918:	eb 17                	jmp    800931 <getuint+0x5b>
  80091a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80091e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800922:	48 89 d0             	mov    %rdx,%rax
  800925:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800929:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800931:	48 8b 00             	mov    (%rax),%rax
  800934:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800938:	e9 a3 00 00 00       	jmpq   8009e0 <getuint+0x10a>
	else if (lflag)
  80093d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800941:	74 4f                	je     800992 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800943:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800947:	8b 00                	mov    (%rax),%eax
  800949:	83 f8 30             	cmp    $0x30,%eax
  80094c:	73 24                	jae    800972 <getuint+0x9c>
  80094e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800952:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095a:	8b 00                	mov    (%rax),%eax
  80095c:	89 c0                	mov    %eax,%eax
  80095e:	48 01 d0             	add    %rdx,%rax
  800961:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800965:	8b 12                	mov    (%rdx),%edx
  800967:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80096a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096e:	89 0a                	mov    %ecx,(%rdx)
  800970:	eb 17                	jmp    800989 <getuint+0xb3>
  800972:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800976:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80097a:	48 89 d0             	mov    %rdx,%rax
  80097d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800981:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800985:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800989:	48 8b 00             	mov    (%rax),%rax
  80098c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800990:	eb 4e                	jmp    8009e0 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800992:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800996:	8b 00                	mov    (%rax),%eax
  800998:	83 f8 30             	cmp    $0x30,%eax
  80099b:	73 24                	jae    8009c1 <getuint+0xeb>
  80099d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a9:	8b 00                	mov    (%rax),%eax
  8009ab:	89 c0                	mov    %eax,%eax
  8009ad:	48 01 d0             	add    %rdx,%rax
  8009b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b4:	8b 12                	mov    (%rdx),%edx
  8009b6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bd:	89 0a                	mov    %ecx,(%rdx)
  8009bf:	eb 17                	jmp    8009d8 <getuint+0x102>
  8009c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009c9:	48 89 d0             	mov    %rdx,%rax
  8009cc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009d8:	8b 00                	mov    (%rax),%eax
  8009da:	89 c0                	mov    %eax,%eax
  8009dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009e4:	c9                   	leaveq 
  8009e5:	c3                   	retq   

00000000008009e6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009e6:	55                   	push   %rbp
  8009e7:	48 89 e5             	mov    %rsp,%rbp
  8009ea:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009f2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009f5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009f9:	7e 52                	jle    800a4d <getint+0x67>
		x=va_arg(*ap, long long);
  8009fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ff:	8b 00                	mov    (%rax),%eax
  800a01:	83 f8 30             	cmp    $0x30,%eax
  800a04:	73 24                	jae    800a2a <getint+0x44>
  800a06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a12:	8b 00                	mov    (%rax),%eax
  800a14:	89 c0                	mov    %eax,%eax
  800a16:	48 01 d0             	add    %rdx,%rax
  800a19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1d:	8b 12                	mov    (%rdx),%edx
  800a1f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a26:	89 0a                	mov    %ecx,(%rdx)
  800a28:	eb 17                	jmp    800a41 <getint+0x5b>
  800a2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a32:	48 89 d0             	mov    %rdx,%rax
  800a35:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a41:	48 8b 00             	mov    (%rax),%rax
  800a44:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a48:	e9 a3 00 00 00       	jmpq   800af0 <getint+0x10a>
	else if (lflag)
  800a4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a51:	74 4f                	je     800aa2 <getint+0xbc>
		x=va_arg(*ap, long);
  800a53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a57:	8b 00                	mov    (%rax),%eax
  800a59:	83 f8 30             	cmp    $0x30,%eax
  800a5c:	73 24                	jae    800a82 <getint+0x9c>
  800a5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a62:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6a:	8b 00                	mov    (%rax),%eax
  800a6c:	89 c0                	mov    %eax,%eax
  800a6e:	48 01 d0             	add    %rdx,%rax
  800a71:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a75:	8b 12                	mov    (%rdx),%edx
  800a77:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7e:	89 0a                	mov    %ecx,(%rdx)
  800a80:	eb 17                	jmp    800a99 <getint+0xb3>
  800a82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a86:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a8a:	48 89 d0             	mov    %rdx,%rax
  800a8d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a91:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a95:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a99:	48 8b 00             	mov    (%rax),%rax
  800a9c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aa0:	eb 4e                	jmp    800af0 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa6:	8b 00                	mov    (%rax),%eax
  800aa8:	83 f8 30             	cmp    $0x30,%eax
  800aab:	73 24                	jae    800ad1 <getint+0xeb>
  800aad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ab5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab9:	8b 00                	mov    (%rax),%eax
  800abb:	89 c0                	mov    %eax,%eax
  800abd:	48 01 d0             	add    %rdx,%rax
  800ac0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ac4:	8b 12                	mov    (%rdx),%edx
  800ac6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ac9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acd:	89 0a                	mov    %ecx,(%rdx)
  800acf:	eb 17                	jmp    800ae8 <getint+0x102>
  800ad1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ad9:	48 89 d0             	mov    %rdx,%rax
  800adc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ae0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ae8:	8b 00                	mov    (%rax),%eax
  800aea:	48 98                	cltq   
  800aec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800af0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800af4:	c9                   	leaveq 
  800af5:	c3                   	retq   

0000000000800af6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800af6:	55                   	push   %rbp
  800af7:	48 89 e5             	mov    %rsp,%rbp
  800afa:	41 54                	push   %r12
  800afc:	53                   	push   %rbx
  800afd:	48 83 ec 60          	sub    $0x60,%rsp
  800b01:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b05:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b09:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b0d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b11:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b15:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b19:	48 8b 0a             	mov    (%rdx),%rcx
  800b1c:	48 89 08             	mov    %rcx,(%rax)
  800b1f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b23:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b27:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b2b:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2f:	eb 17                	jmp    800b48 <vprintfmt+0x52>
			if (ch == '\0')
  800b31:	85 db                	test   %ebx,%ebx
  800b33:	0f 84 cc 04 00 00    	je     801005 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800b39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b41:	48 89 d6             	mov    %rdx,%rsi
  800b44:	89 df                	mov    %ebx,%edi
  800b46:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b48:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b4c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b50:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b54:	0f b6 00             	movzbl (%rax),%eax
  800b57:	0f b6 d8             	movzbl %al,%ebx
  800b5a:	83 fb 25             	cmp    $0x25,%ebx
  800b5d:	75 d2                	jne    800b31 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800b5f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b63:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b6a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b78:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b7f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b83:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b87:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b8b:	0f b6 00             	movzbl (%rax),%eax
  800b8e:	0f b6 d8             	movzbl %al,%ebx
  800b91:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b94:	83 f8 55             	cmp    $0x55,%eax
  800b97:	0f 87 34 04 00 00    	ja     800fd1 <vprintfmt+0x4db>
  800b9d:	89 c0                	mov    %eax,%eax
  800b9f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800ba6:	00 
  800ba7:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  800bae:	00 00 00 
  800bb1:	48 01 d0             	add    %rdx,%rax
  800bb4:	48 8b 00             	mov    (%rax),%rax
  800bb7:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bb9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bbd:	eb c0                	jmp    800b7f <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bbf:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bc3:	eb ba                	jmp    800b7f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bcc:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bcf:	89 d0                	mov    %edx,%eax
  800bd1:	c1 e0 02             	shl    $0x2,%eax
  800bd4:	01 d0                	add    %edx,%eax
  800bd6:	01 c0                	add    %eax,%eax
  800bd8:	01 d8                	add    %ebx,%eax
  800bda:	83 e8 30             	sub    $0x30,%eax
  800bdd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800be0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800be4:	0f b6 00             	movzbl (%rax),%eax
  800be7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bea:	83 fb 2f             	cmp    $0x2f,%ebx
  800bed:	7e 0c                	jle    800bfb <vprintfmt+0x105>
  800bef:	83 fb 39             	cmp    $0x39,%ebx
  800bf2:	7f 07                	jg     800bfb <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf9:	eb d1                	jmp    800bcc <vprintfmt+0xd6>
			goto process_precision;
  800bfb:	eb 58                	jmp    800c55 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800bfd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c00:	83 f8 30             	cmp    $0x30,%eax
  800c03:	73 17                	jae    800c1c <vprintfmt+0x126>
  800c05:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c0c:	89 c0                	mov    %eax,%eax
  800c0e:	48 01 d0             	add    %rdx,%rax
  800c11:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c14:	83 c2 08             	add    $0x8,%edx
  800c17:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c1a:	eb 0f                	jmp    800c2b <vprintfmt+0x135>
  800c1c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c20:	48 89 d0             	mov    %rdx,%rax
  800c23:	48 83 c2 08          	add    $0x8,%rdx
  800c27:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c2b:	8b 00                	mov    (%rax),%eax
  800c2d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c30:	eb 23                	jmp    800c55 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c32:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c36:	79 0c                	jns    800c44 <vprintfmt+0x14e>
				width = 0;
  800c38:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c3f:	e9 3b ff ff ff       	jmpq   800b7f <vprintfmt+0x89>
  800c44:	e9 36 ff ff ff       	jmpq   800b7f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c49:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c50:	e9 2a ff ff ff       	jmpq   800b7f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c55:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c59:	79 12                	jns    800c6d <vprintfmt+0x177>
				width = precision, precision = -1;
  800c5b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c5e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c61:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c68:	e9 12 ff ff ff       	jmpq   800b7f <vprintfmt+0x89>
  800c6d:	e9 0d ff ff ff       	jmpq   800b7f <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c72:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c76:	e9 04 ff ff ff       	jmpq   800b7f <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800c7b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c7e:	83 f8 30             	cmp    $0x30,%eax
  800c81:	73 17                	jae    800c9a <vprintfmt+0x1a4>
  800c83:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c87:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8a:	89 c0                	mov    %eax,%eax
  800c8c:	48 01 d0             	add    %rdx,%rax
  800c8f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c92:	83 c2 08             	add    $0x8,%edx
  800c95:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c98:	eb 0f                	jmp    800ca9 <vprintfmt+0x1b3>
  800c9a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c9e:	48 89 d0             	mov    %rdx,%rax
  800ca1:	48 83 c2 08          	add    $0x8,%rdx
  800ca5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ca9:	8b 10                	mov    (%rax),%edx
  800cab:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800caf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb3:	48 89 ce             	mov    %rcx,%rsi
  800cb6:	89 d7                	mov    %edx,%edi
  800cb8:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800cba:	e9 40 03 00 00       	jmpq   800fff <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800cbf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cc2:	83 f8 30             	cmp    $0x30,%eax
  800cc5:	73 17                	jae    800cde <vprintfmt+0x1e8>
  800cc7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ccb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cce:	89 c0                	mov    %eax,%eax
  800cd0:	48 01 d0             	add    %rdx,%rax
  800cd3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cd6:	83 c2 08             	add    $0x8,%edx
  800cd9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cdc:	eb 0f                	jmp    800ced <vprintfmt+0x1f7>
  800cde:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ce2:	48 89 d0             	mov    %rdx,%rax
  800ce5:	48 83 c2 08          	add    $0x8,%rdx
  800ce9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ced:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cef:	85 db                	test   %ebx,%ebx
  800cf1:	79 02                	jns    800cf5 <vprintfmt+0x1ff>
				err = -err;
  800cf3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cf5:	83 fb 09             	cmp    $0x9,%ebx
  800cf8:	7f 16                	jg     800d10 <vprintfmt+0x21a>
  800cfa:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800d01:	00 00 00 
  800d04:	48 63 d3             	movslq %ebx,%rdx
  800d07:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d0b:	4d 85 e4             	test   %r12,%r12
  800d0e:	75 2e                	jne    800d3e <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d10:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d14:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d18:	89 d9                	mov    %ebx,%ecx
  800d1a:	48 ba c1 1b 80 00 00 	movabs $0x801bc1,%rdx
  800d21:	00 00 00 
  800d24:	48 89 c7             	mov    %rax,%rdi
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2c:	49 b8 0e 10 80 00 00 	movabs $0x80100e,%r8
  800d33:	00 00 00 
  800d36:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d39:	e9 c1 02 00 00       	jmpq   800fff <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d3e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d46:	4c 89 e1             	mov    %r12,%rcx
  800d49:	48 ba ca 1b 80 00 00 	movabs $0x801bca,%rdx
  800d50:	00 00 00 
  800d53:	48 89 c7             	mov    %rax,%rdi
  800d56:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5b:	49 b8 0e 10 80 00 00 	movabs $0x80100e,%r8
  800d62:	00 00 00 
  800d65:	41 ff d0             	callq  *%r8
			break;
  800d68:	e9 92 02 00 00       	jmpq   800fff <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800d6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d70:	83 f8 30             	cmp    $0x30,%eax
  800d73:	73 17                	jae    800d8c <vprintfmt+0x296>
  800d75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d7c:	89 c0                	mov    %eax,%eax
  800d7e:	48 01 d0             	add    %rdx,%rax
  800d81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d84:	83 c2 08             	add    $0x8,%edx
  800d87:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d8a:	eb 0f                	jmp    800d9b <vprintfmt+0x2a5>
  800d8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d90:	48 89 d0             	mov    %rdx,%rax
  800d93:	48 83 c2 08          	add    $0x8,%rdx
  800d97:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d9b:	4c 8b 20             	mov    (%rax),%r12
  800d9e:	4d 85 e4             	test   %r12,%r12
  800da1:	75 0a                	jne    800dad <vprintfmt+0x2b7>
				p = "(null)";
  800da3:	49 bc cd 1b 80 00 00 	movabs $0x801bcd,%r12
  800daa:	00 00 00 
			if (width > 0 && padc != '-')
  800dad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800db1:	7e 3f                	jle    800df2 <vprintfmt+0x2fc>
  800db3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800db7:	74 39                	je     800df2 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800db9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dbc:	48 98                	cltq   
  800dbe:	48 89 c6             	mov    %rax,%rsi
  800dc1:	4c 89 e7             	mov    %r12,%rdi
  800dc4:	48 b8 ba 12 80 00 00 	movabs $0x8012ba,%rax
  800dcb:	00 00 00 
  800dce:	ff d0                	callq  *%rax
  800dd0:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800dd3:	eb 17                	jmp    800dec <vprintfmt+0x2f6>
					putch(padc, putdat);
  800dd5:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800dd9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ddd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de1:	48 89 ce             	mov    %rcx,%rsi
  800de4:	89 d7                	mov    %edx,%edi
  800de6:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dec:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800df0:	7f e3                	jg     800dd5 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df2:	eb 37                	jmp    800e2b <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800df4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800df8:	74 1e                	je     800e18 <vprintfmt+0x322>
  800dfa:	83 fb 1f             	cmp    $0x1f,%ebx
  800dfd:	7e 05                	jle    800e04 <vprintfmt+0x30e>
  800dff:	83 fb 7e             	cmp    $0x7e,%ebx
  800e02:	7e 14                	jle    800e18 <vprintfmt+0x322>
					putch('?', putdat);
  800e04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0c:	48 89 d6             	mov    %rdx,%rsi
  800e0f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e14:	ff d0                	callq  *%rax
  800e16:	eb 0f                	jmp    800e27 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e18:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e1c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e20:	48 89 d6             	mov    %rdx,%rsi
  800e23:	89 df                	mov    %ebx,%edi
  800e25:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e27:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e2b:	4c 89 e0             	mov    %r12,%rax
  800e2e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e32:	0f b6 00             	movzbl (%rax),%eax
  800e35:	0f be d8             	movsbl %al,%ebx
  800e38:	85 db                	test   %ebx,%ebx
  800e3a:	74 10                	je     800e4c <vprintfmt+0x356>
  800e3c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e40:	78 b2                	js     800df4 <vprintfmt+0x2fe>
  800e42:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e46:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e4a:	79 a8                	jns    800df4 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e4c:	eb 16                	jmp    800e64 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e4e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e52:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e56:	48 89 d6             	mov    %rdx,%rsi
  800e59:	bf 20 00 00 00       	mov    $0x20,%edi
  800e5e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e60:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e64:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e68:	7f e4                	jg     800e4e <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800e6a:	e9 90 01 00 00       	jmpq   800fff <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800e6f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e73:	be 03 00 00 00       	mov    $0x3,%esi
  800e78:	48 89 c7             	mov    %rax,%rdi
  800e7b:	48 b8 e6 09 80 00 00 	movabs $0x8009e6,%rax
  800e82:	00 00 00 
  800e85:	ff d0                	callq  *%rax
  800e87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8f:	48 85 c0             	test   %rax,%rax
  800e92:	79 1d                	jns    800eb1 <vprintfmt+0x3bb>
				putch('-', putdat);
  800e94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e9c:	48 89 d6             	mov    %rdx,%rsi
  800e9f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ea4:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eaa:	48 f7 d8             	neg    %rax
  800ead:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800eb1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eb8:	e9 d5 00 00 00       	jmpq   800f92 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800ebd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ec1:	be 03 00 00 00       	mov    $0x3,%esi
  800ec6:	48 89 c7             	mov    %rax,%rdi
  800ec9:	48 b8 d6 08 80 00 00 	movabs $0x8008d6,%rax
  800ed0:	00 00 00 
  800ed3:	ff d0                	callq  *%rax
  800ed5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ed9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ee0:	e9 ad 00 00 00       	jmpq   800f92 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800ee5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ee9:	be 03 00 00 00       	mov    $0x3,%esi
  800eee:	48 89 c7             	mov    %rax,%rdi
  800ef1:	48 b8 d6 08 80 00 00 	movabs $0x8008d6,%rax
  800ef8:	00 00 00 
  800efb:	ff d0                	callq  *%rax
  800efd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f01:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f08:	e9 85 00 00 00       	jmpq   800f92 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800f0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f15:	48 89 d6             	mov    %rdx,%rsi
  800f18:	bf 30 00 00 00       	mov    $0x30,%edi
  800f1d:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f27:	48 89 d6             	mov    %rdx,%rsi
  800f2a:	bf 78 00 00 00       	mov    $0x78,%edi
  800f2f:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f31:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f34:	83 f8 30             	cmp    $0x30,%eax
  800f37:	73 17                	jae    800f50 <vprintfmt+0x45a>
  800f39:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f3d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f40:	89 c0                	mov    %eax,%eax
  800f42:	48 01 d0             	add    %rdx,%rax
  800f45:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f48:	83 c2 08             	add    $0x8,%edx
  800f4b:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f4e:	eb 0f                	jmp    800f5f <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f50:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f54:	48 89 d0             	mov    %rdx,%rax
  800f57:	48 83 c2 08          	add    $0x8,%rdx
  800f5b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f5f:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f62:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f66:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f6d:	eb 23                	jmp    800f92 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800f6f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f73:	be 03 00 00 00       	mov    $0x3,%esi
  800f78:	48 89 c7             	mov    %rax,%rdi
  800f7b:	48 b8 d6 08 80 00 00 	movabs $0x8008d6,%rax
  800f82:	00 00 00 
  800f85:	ff d0                	callq  *%rax
  800f87:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f8b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800f92:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f97:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f9a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f9d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fa1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fa5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa9:	45 89 c1             	mov    %r8d,%r9d
  800fac:	41 89 f8             	mov    %edi,%r8d
  800faf:	48 89 c7             	mov    %rax,%rdi
  800fb2:	48 b8 1b 08 80 00 00 	movabs $0x80081b,%rax
  800fb9:	00 00 00 
  800fbc:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800fbe:	eb 3f                	jmp    800fff <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fc0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc8:	48 89 d6             	mov    %rdx,%rsi
  800fcb:	89 df                	mov    %ebx,%edi
  800fcd:	ff d0                	callq  *%rax
			break;
  800fcf:	eb 2e                	jmp    800fff <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fd1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd9:	48 89 d6             	mov    %rdx,%rsi
  800fdc:	bf 25 00 00 00       	mov    $0x25,%edi
  800fe1:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800fe3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fe8:	eb 05                	jmp    800fef <vprintfmt+0x4f9>
  800fea:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800fef:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ff3:	48 83 e8 01          	sub    $0x1,%rax
  800ff7:	0f b6 00             	movzbl (%rax),%eax
  800ffa:	3c 25                	cmp    $0x25,%al
  800ffc:	75 ec                	jne    800fea <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800ffe:	90                   	nop
		}
	}
  800fff:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801000:	e9 43 fb ff ff       	jmpq   800b48 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  801005:	48 83 c4 60          	add    $0x60,%rsp
  801009:	5b                   	pop    %rbx
  80100a:	41 5c                	pop    %r12
  80100c:	5d                   	pop    %rbp
  80100d:	c3                   	retq   

000000000080100e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80100e:	55                   	push   %rbp
  80100f:	48 89 e5             	mov    %rsp,%rbp
  801012:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801019:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801020:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801027:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80102e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801035:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80103c:	84 c0                	test   %al,%al
  80103e:	74 20                	je     801060 <printfmt+0x52>
  801040:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801044:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801048:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80104c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801050:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801054:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801058:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80105c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801060:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801067:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80106e:	00 00 00 
  801071:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801078:	00 00 00 
  80107b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80107f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801086:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80108d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801094:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80109b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010a2:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010a9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010b0:	48 89 c7             	mov    %rax,%rdi
  8010b3:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  8010ba:	00 00 00 
  8010bd:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010bf:	c9                   	leaveq 
  8010c0:	c3                   	retq   

00000000008010c1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010c1:	55                   	push   %rbp
  8010c2:	48 89 e5             	mov    %rsp,%rbp
  8010c5:	48 83 ec 10          	sub    $0x10,%rsp
  8010c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d4:	8b 40 10             	mov    0x10(%rax),%eax
  8010d7:	8d 50 01             	lea    0x1(%rax),%edx
  8010da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010de:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e5:	48 8b 10             	mov    (%rax),%rdx
  8010e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ec:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010f0:	48 39 c2             	cmp    %rax,%rdx
  8010f3:	73 17                	jae    80110c <sprintputch+0x4b>
		*b->buf++ = ch;
  8010f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f9:	48 8b 00             	mov    (%rax),%rax
  8010fc:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801100:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801104:	48 89 0a             	mov    %rcx,(%rdx)
  801107:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80110a:	88 10                	mov    %dl,(%rax)
}
  80110c:	c9                   	leaveq 
  80110d:	c3                   	retq   

000000000080110e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80110e:	55                   	push   %rbp
  80110f:	48 89 e5             	mov    %rsp,%rbp
  801112:	48 83 ec 50          	sub    $0x50,%rsp
  801116:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80111a:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80111d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801121:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801125:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801129:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80112d:	48 8b 0a             	mov    (%rdx),%rcx
  801130:	48 89 08             	mov    %rcx,(%rax)
  801133:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801137:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80113b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80113f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801143:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801147:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80114b:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80114e:	48 98                	cltq   
  801150:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801154:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801158:	48 01 d0             	add    %rdx,%rax
  80115b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80115f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801166:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80116b:	74 06                	je     801173 <vsnprintf+0x65>
  80116d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801171:	7f 07                	jg     80117a <vsnprintf+0x6c>
		return -E_INVAL;
  801173:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801178:	eb 2f                	jmp    8011a9 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80117a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80117e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801182:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801186:	48 89 c6             	mov    %rax,%rsi
  801189:	48 bf c1 10 80 00 00 	movabs $0x8010c1,%rdi
  801190:	00 00 00 
  801193:	48 b8 f6 0a 80 00 00 	movabs $0x800af6,%rax
  80119a:	00 00 00 
  80119d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80119f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011a3:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011a6:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011a9:	c9                   	leaveq 
  8011aa:	c3                   	retq   

00000000008011ab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011ab:	55                   	push   %rbp
  8011ac:	48 89 e5             	mov    %rsp,%rbp
  8011af:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011b6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011bd:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011c3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011ca:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011d1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011d8:	84 c0                	test   %al,%al
  8011da:	74 20                	je     8011fc <snprintf+0x51>
  8011dc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011e0:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011e4:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011e8:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011ec:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011f0:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011f4:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8011f8:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8011fc:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801203:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80120a:	00 00 00 
  80120d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801214:	00 00 00 
  801217:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80121b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801222:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801229:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801230:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801237:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80123e:	48 8b 0a             	mov    (%rdx),%rcx
  801241:	48 89 08             	mov    %rcx,(%rax)
  801244:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801248:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80124c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801250:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801254:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80125b:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801262:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801268:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80126f:	48 89 c7             	mov    %rax,%rdi
  801272:	48 b8 0e 11 80 00 00 	movabs $0x80110e,%rax
  801279:	00 00 00 
  80127c:	ff d0                	callq  *%rax
  80127e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801284:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80128a:	c9                   	leaveq 
  80128b:	c3                   	retq   

000000000080128c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80128c:	55                   	push   %rbp
  80128d:	48 89 e5             	mov    %rsp,%rbp
  801290:	48 83 ec 18          	sub    $0x18,%rsp
  801294:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801298:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80129f:	eb 09                	jmp    8012aa <strlen+0x1e>
		n++;
  8012a1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ae:	0f b6 00             	movzbl (%rax),%eax
  8012b1:	84 c0                	test   %al,%al
  8012b3:	75 ec                	jne    8012a1 <strlen+0x15>
		n++;
	return n;
  8012b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012b8:	c9                   	leaveq 
  8012b9:	c3                   	retq   

00000000008012ba <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012ba:	55                   	push   %rbp
  8012bb:	48 89 e5             	mov    %rsp,%rbp
  8012be:	48 83 ec 20          	sub    $0x20,%rsp
  8012c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012d1:	eb 0e                	jmp    8012e1 <strnlen+0x27>
		n++;
  8012d3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012dc:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012e1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012e6:	74 0b                	je     8012f3 <strnlen+0x39>
  8012e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ec:	0f b6 00             	movzbl (%rax),%eax
  8012ef:	84 c0                	test   %al,%al
  8012f1:	75 e0                	jne    8012d3 <strnlen+0x19>
		n++;
	return n;
  8012f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012f6:	c9                   	leaveq 
  8012f7:	c3                   	retq   

00000000008012f8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012f8:	55                   	push   %rbp
  8012f9:	48 89 e5             	mov    %rsp,%rbp
  8012fc:	48 83 ec 20          	sub    $0x20,%rsp
  801300:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801304:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801310:	90                   	nop
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801315:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801319:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80131d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801321:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801325:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801329:	0f b6 12             	movzbl (%rdx),%edx
  80132c:	88 10                	mov    %dl,(%rax)
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	84 c0                	test   %al,%al
  801333:	75 dc                	jne    801311 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801339:	c9                   	leaveq 
  80133a:	c3                   	retq   

000000000080133b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80133b:	55                   	push   %rbp
  80133c:	48 89 e5             	mov    %rsp,%rbp
  80133f:	48 83 ec 20          	sub    $0x20,%rsp
  801343:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801347:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80134b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134f:	48 89 c7             	mov    %rax,%rdi
  801352:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  801359:	00 00 00 
  80135c:	ff d0                	callq  *%rax
  80135e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801361:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801364:	48 63 d0             	movslq %eax,%rdx
  801367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136b:	48 01 c2             	add    %rax,%rdx
  80136e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801372:	48 89 c6             	mov    %rax,%rsi
  801375:	48 89 d7             	mov    %rdx,%rdi
  801378:	48 b8 f8 12 80 00 00 	movabs $0x8012f8,%rax
  80137f:	00 00 00 
  801382:	ff d0                	callq  *%rax
	return dst;
  801384:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801388:	c9                   	leaveq 
  801389:	c3                   	retq   

000000000080138a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80138a:	55                   	push   %rbp
  80138b:	48 89 e5             	mov    %rsp,%rbp
  80138e:	48 83 ec 28          	sub    $0x28,%rsp
  801392:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801396:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80139a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80139e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013a6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013ad:	00 
  8013ae:	eb 2a                	jmp    8013da <strncpy+0x50>
		*dst++ = *src;
  8013b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013bc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013c0:	0f b6 12             	movzbl (%rdx),%edx
  8013c3:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013c9:	0f b6 00             	movzbl (%rax),%eax
  8013cc:	84 c0                	test   %al,%al
  8013ce:	74 05                	je     8013d5 <strncpy+0x4b>
			src++;
  8013d0:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013de:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013e2:	72 cc                	jb     8013b0 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013e8:	c9                   	leaveq 
  8013e9:	c3                   	retq   

00000000008013ea <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013ea:	55                   	push   %rbp
  8013eb:	48 89 e5             	mov    %rsp,%rbp
  8013ee:	48 83 ec 28          	sub    $0x28,%rsp
  8013f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013fa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8013fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801402:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801406:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80140b:	74 3d                	je     80144a <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80140d:	eb 1d                	jmp    80142c <strlcpy+0x42>
			*dst++ = *src++;
  80140f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801413:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801417:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80141b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80141f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801423:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801427:	0f b6 12             	movzbl (%rdx),%edx
  80142a:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80142c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801431:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801436:	74 0b                	je     801443 <strlcpy+0x59>
  801438:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80143c:	0f b6 00             	movzbl (%rax),%eax
  80143f:	84 c0                	test   %al,%al
  801441:	75 cc                	jne    80140f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801447:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80144a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80144e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801452:	48 29 c2             	sub    %rax,%rdx
  801455:	48 89 d0             	mov    %rdx,%rax
}
  801458:	c9                   	leaveq 
  801459:	c3                   	retq   

000000000080145a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80145a:	55                   	push   %rbp
  80145b:	48 89 e5             	mov    %rsp,%rbp
  80145e:	48 83 ec 10          	sub    $0x10,%rsp
  801462:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801466:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80146a:	eb 0a                	jmp    801476 <strcmp+0x1c>
		p++, q++;
  80146c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801471:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147a:	0f b6 00             	movzbl (%rax),%eax
  80147d:	84 c0                	test   %al,%al
  80147f:	74 12                	je     801493 <strcmp+0x39>
  801481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801485:	0f b6 10             	movzbl (%rax),%edx
  801488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148c:	0f b6 00             	movzbl (%rax),%eax
  80148f:	38 c2                	cmp    %al,%dl
  801491:	74 d9                	je     80146c <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801497:	0f b6 00             	movzbl (%rax),%eax
  80149a:	0f b6 d0             	movzbl %al,%edx
  80149d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a1:	0f b6 00             	movzbl (%rax),%eax
  8014a4:	0f b6 c0             	movzbl %al,%eax
  8014a7:	29 c2                	sub    %eax,%edx
  8014a9:	89 d0                	mov    %edx,%eax
}
  8014ab:	c9                   	leaveq 
  8014ac:	c3                   	retq   

00000000008014ad <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014ad:	55                   	push   %rbp
  8014ae:	48 89 e5             	mov    %rsp,%rbp
  8014b1:	48 83 ec 18          	sub    $0x18,%rsp
  8014b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014c1:	eb 0f                	jmp    8014d2 <strncmp+0x25>
		n--, p++, q++;
  8014c3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014cd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014d7:	74 1d                	je     8014f6 <strncmp+0x49>
  8014d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014dd:	0f b6 00             	movzbl (%rax),%eax
  8014e0:	84 c0                	test   %al,%al
  8014e2:	74 12                	je     8014f6 <strncmp+0x49>
  8014e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e8:	0f b6 10             	movzbl (%rax),%edx
  8014eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ef:	0f b6 00             	movzbl (%rax),%eax
  8014f2:	38 c2                	cmp    %al,%dl
  8014f4:	74 cd                	je     8014c3 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014f6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014fb:	75 07                	jne    801504 <strncmp+0x57>
		return 0;
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801502:	eb 18                	jmp    80151c <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801504:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	0f b6 d0             	movzbl %al,%edx
  80150e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801512:	0f b6 00             	movzbl (%rax),%eax
  801515:	0f b6 c0             	movzbl %al,%eax
  801518:	29 c2                	sub    %eax,%edx
  80151a:	89 d0                	mov    %edx,%eax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 0c          	sub    $0xc,%rsp
  801526:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80152a:	89 f0                	mov    %esi,%eax
  80152c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80152f:	eb 17                	jmp    801548 <strchr+0x2a>
		if (*s == c)
  801531:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801535:	0f b6 00             	movzbl (%rax),%eax
  801538:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80153b:	75 06                	jne    801543 <strchr+0x25>
			return (char *) s;
  80153d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801541:	eb 15                	jmp    801558 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801543:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801548:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154c:	0f b6 00             	movzbl (%rax),%eax
  80154f:	84 c0                	test   %al,%al
  801551:	75 de                	jne    801531 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801553:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801558:	c9                   	leaveq 
  801559:	c3                   	retq   

000000000080155a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80155a:	55                   	push   %rbp
  80155b:	48 89 e5             	mov    %rsp,%rbp
  80155e:	48 83 ec 0c          	sub    $0xc,%rsp
  801562:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801566:	89 f0                	mov    %esi,%eax
  801568:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80156b:	eb 13                	jmp    801580 <strfind+0x26>
		if (*s == c)
  80156d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801571:	0f b6 00             	movzbl (%rax),%eax
  801574:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801577:	75 02                	jne    80157b <strfind+0x21>
			break;
  801579:	eb 10                	jmp    80158b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80157b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801580:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801584:	0f b6 00             	movzbl (%rax),%eax
  801587:	84 c0                	test   %al,%al
  801589:	75 e2                	jne    80156d <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80158b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80158f:	c9                   	leaveq 
  801590:	c3                   	retq   

0000000000801591 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801591:	55                   	push   %rbp
  801592:	48 89 e5             	mov    %rsp,%rbp
  801595:	48 83 ec 18          	sub    $0x18,%rsp
  801599:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80159d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015a0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015a4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a9:	75 06                	jne    8015b1 <memset+0x20>
		return v;
  8015ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015af:	eb 69                	jmp    80161a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b5:	83 e0 03             	and    $0x3,%eax
  8015b8:	48 85 c0             	test   %rax,%rax
  8015bb:	75 48                	jne    801605 <memset+0x74>
  8015bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015c1:	83 e0 03             	and    $0x3,%eax
  8015c4:	48 85 c0             	test   %rax,%rax
  8015c7:	75 3c                	jne    801605 <memset+0x74>
		c &= 0xFF;
  8015c9:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015d3:	c1 e0 18             	shl    $0x18,%eax
  8015d6:	89 c2                	mov    %eax,%edx
  8015d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015db:	c1 e0 10             	shl    $0x10,%eax
  8015de:	09 c2                	or     %eax,%edx
  8015e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e3:	c1 e0 08             	shl    $0x8,%eax
  8015e6:	09 d0                	or     %edx,%eax
  8015e8:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8015eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ef:	48 c1 e8 02          	shr    $0x2,%rax
  8015f3:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fd:	48 89 d7             	mov    %rdx,%rdi
  801600:	fc                   	cld    
  801601:	f3 ab                	rep stos %eax,%es:(%rdi)
  801603:	eb 11                	jmp    801616 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801605:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801609:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80160c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801610:	48 89 d7             	mov    %rdx,%rdi
  801613:	fc                   	cld    
  801614:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801616:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80161a:	c9                   	leaveq 
  80161b:	c3                   	retq   

000000000080161c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80161c:	55                   	push   %rbp
  80161d:	48 89 e5             	mov    %rsp,%rbp
  801620:	48 83 ec 28          	sub    $0x28,%rsp
  801624:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801628:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80162c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801630:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801634:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80163c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801640:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801644:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801648:	0f 83 88 00 00 00    	jae    8016d6 <memmove+0xba>
  80164e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801652:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801656:	48 01 d0             	add    %rdx,%rax
  801659:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80165d:	76 77                	jbe    8016d6 <memmove+0xba>
		s += n;
  80165f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801663:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80166f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801673:	83 e0 03             	and    $0x3,%eax
  801676:	48 85 c0             	test   %rax,%rax
  801679:	75 3b                	jne    8016b6 <memmove+0x9a>
  80167b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167f:	83 e0 03             	and    $0x3,%eax
  801682:	48 85 c0             	test   %rax,%rax
  801685:	75 2f                	jne    8016b6 <memmove+0x9a>
  801687:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168b:	83 e0 03             	and    $0x3,%eax
  80168e:	48 85 c0             	test   %rax,%rax
  801691:	75 23                	jne    8016b6 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801693:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801697:	48 83 e8 04          	sub    $0x4,%rax
  80169b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80169f:	48 83 ea 04          	sub    $0x4,%rdx
  8016a3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016a7:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016ab:	48 89 c7             	mov    %rax,%rdi
  8016ae:	48 89 d6             	mov    %rdx,%rsi
  8016b1:	fd                   	std    
  8016b2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016b4:	eb 1d                	jmp    8016d3 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ba:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c2:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ca:	48 89 d7             	mov    %rdx,%rdi
  8016cd:	48 89 c1             	mov    %rax,%rcx
  8016d0:	fd                   	std    
  8016d1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016d3:	fc                   	cld    
  8016d4:	eb 57                	jmp    80172d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016da:	83 e0 03             	and    $0x3,%eax
  8016dd:	48 85 c0             	test   %rax,%rax
  8016e0:	75 36                	jne    801718 <memmove+0xfc>
  8016e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016e6:	83 e0 03             	and    $0x3,%eax
  8016e9:	48 85 c0             	test   %rax,%rax
  8016ec:	75 2a                	jne    801718 <memmove+0xfc>
  8016ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f2:	83 e0 03             	and    $0x3,%eax
  8016f5:	48 85 c0             	test   %rax,%rax
  8016f8:	75 1e                	jne    801718 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fe:	48 c1 e8 02          	shr    $0x2,%rax
  801702:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801705:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801709:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80170d:	48 89 c7             	mov    %rax,%rdi
  801710:	48 89 d6             	mov    %rdx,%rsi
  801713:	fc                   	cld    
  801714:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801716:	eb 15                	jmp    80172d <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801718:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80171c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801720:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801724:	48 89 c7             	mov    %rax,%rdi
  801727:	48 89 d6             	mov    %rdx,%rsi
  80172a:	fc                   	cld    
  80172b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80172d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801731:	c9                   	leaveq 
  801732:	c3                   	retq   

0000000000801733 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801733:	55                   	push   %rbp
  801734:	48 89 e5             	mov    %rsp,%rbp
  801737:	48 83 ec 18          	sub    $0x18,%rsp
  80173b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80173f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801743:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801747:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80174b:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80174f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801753:	48 89 ce             	mov    %rcx,%rsi
  801756:	48 89 c7             	mov    %rax,%rdi
  801759:	48 b8 1c 16 80 00 00 	movabs $0x80161c,%rax
  801760:	00 00 00 
  801763:	ff d0                	callq  *%rax
}
  801765:	c9                   	leaveq 
  801766:	c3                   	retq   

0000000000801767 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801767:	55                   	push   %rbp
  801768:	48 89 e5             	mov    %rsp,%rbp
  80176b:	48 83 ec 28          	sub    $0x28,%rsp
  80176f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801773:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801777:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80177b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801783:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801787:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80178b:	eb 36                	jmp    8017c3 <memcmp+0x5c>
		if (*s1 != *s2)
  80178d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801791:	0f b6 10             	movzbl (%rax),%edx
  801794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801798:	0f b6 00             	movzbl (%rax),%eax
  80179b:	38 c2                	cmp    %al,%dl
  80179d:	74 1a                	je     8017b9 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80179f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017a3:	0f b6 00             	movzbl (%rax),%eax
  8017a6:	0f b6 d0             	movzbl %al,%edx
  8017a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ad:	0f b6 00             	movzbl (%rax),%eax
  8017b0:	0f b6 c0             	movzbl %al,%eax
  8017b3:	29 c2                	sub    %eax,%edx
  8017b5:	89 d0                	mov    %edx,%eax
  8017b7:	eb 20                	jmp    8017d9 <memcmp+0x72>
		s1++, s2++;
  8017b9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017be:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017c7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017cf:	48 85 c0             	test   %rax,%rax
  8017d2:	75 b9                	jne    80178d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d9:	c9                   	leaveq 
  8017da:	c3                   	retq   

00000000008017db <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017db:	55                   	push   %rbp
  8017dc:	48 89 e5             	mov    %rsp,%rbp
  8017df:	48 83 ec 28          	sub    $0x28,%rsp
  8017e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017e7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f6:	48 01 d0             	add    %rdx,%rax
  8017f9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8017fd:	eb 15                	jmp    801814 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801803:	0f b6 10             	movzbl (%rax),%edx
  801806:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801809:	38 c2                	cmp    %al,%dl
  80180b:	75 02                	jne    80180f <memfind+0x34>
			break;
  80180d:	eb 0f                	jmp    80181e <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80180f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801818:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80181c:	72 e1                	jb     8017ff <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80181e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801822:	c9                   	leaveq 
  801823:	c3                   	retq   

0000000000801824 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801824:	55                   	push   %rbp
  801825:	48 89 e5             	mov    %rsp,%rbp
  801828:	48 83 ec 34          	sub    $0x34,%rsp
  80182c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801830:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801834:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801837:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80183e:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801845:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801846:	eb 05                	jmp    80184d <strtol+0x29>
		s++;
  801848:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80184d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801851:	0f b6 00             	movzbl (%rax),%eax
  801854:	3c 20                	cmp    $0x20,%al
  801856:	74 f0                	je     801848 <strtol+0x24>
  801858:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185c:	0f b6 00             	movzbl (%rax),%eax
  80185f:	3c 09                	cmp    $0x9,%al
  801861:	74 e5                	je     801848 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801867:	0f b6 00             	movzbl (%rax),%eax
  80186a:	3c 2b                	cmp    $0x2b,%al
  80186c:	75 07                	jne    801875 <strtol+0x51>
		s++;
  80186e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801873:	eb 17                	jmp    80188c <strtol+0x68>
	else if (*s == '-')
  801875:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801879:	0f b6 00             	movzbl (%rax),%eax
  80187c:	3c 2d                	cmp    $0x2d,%al
  80187e:	75 0c                	jne    80188c <strtol+0x68>
		s++, neg = 1;
  801880:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801885:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801890:	74 06                	je     801898 <strtol+0x74>
  801892:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801896:	75 28                	jne    8018c0 <strtol+0x9c>
  801898:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189c:	0f b6 00             	movzbl (%rax),%eax
  80189f:	3c 30                	cmp    $0x30,%al
  8018a1:	75 1d                	jne    8018c0 <strtol+0x9c>
  8018a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a7:	48 83 c0 01          	add    $0x1,%rax
  8018ab:	0f b6 00             	movzbl (%rax),%eax
  8018ae:	3c 78                	cmp    $0x78,%al
  8018b0:	75 0e                	jne    8018c0 <strtol+0x9c>
		s += 2, base = 16;
  8018b2:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018b7:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018be:	eb 2c                	jmp    8018ec <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018c0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018c4:	75 19                	jne    8018df <strtol+0xbb>
  8018c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ca:	0f b6 00             	movzbl (%rax),%eax
  8018cd:	3c 30                	cmp    $0x30,%al
  8018cf:	75 0e                	jne    8018df <strtol+0xbb>
		s++, base = 8;
  8018d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018d6:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018dd:	eb 0d                	jmp    8018ec <strtol+0xc8>
	else if (base == 0)
  8018df:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018e3:	75 07                	jne    8018ec <strtol+0xc8>
		base = 10;
  8018e5:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f0:	0f b6 00             	movzbl (%rax),%eax
  8018f3:	3c 2f                	cmp    $0x2f,%al
  8018f5:	7e 1d                	jle    801914 <strtol+0xf0>
  8018f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fb:	0f b6 00             	movzbl (%rax),%eax
  8018fe:	3c 39                	cmp    $0x39,%al
  801900:	7f 12                	jg     801914 <strtol+0xf0>
			dig = *s - '0';
  801902:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801906:	0f b6 00             	movzbl (%rax),%eax
  801909:	0f be c0             	movsbl %al,%eax
  80190c:	83 e8 30             	sub    $0x30,%eax
  80190f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801912:	eb 4e                	jmp    801962 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801914:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801918:	0f b6 00             	movzbl (%rax),%eax
  80191b:	3c 60                	cmp    $0x60,%al
  80191d:	7e 1d                	jle    80193c <strtol+0x118>
  80191f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801923:	0f b6 00             	movzbl (%rax),%eax
  801926:	3c 7a                	cmp    $0x7a,%al
  801928:	7f 12                	jg     80193c <strtol+0x118>
			dig = *s - 'a' + 10;
  80192a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192e:	0f b6 00             	movzbl (%rax),%eax
  801931:	0f be c0             	movsbl %al,%eax
  801934:	83 e8 57             	sub    $0x57,%eax
  801937:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80193a:	eb 26                	jmp    801962 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80193c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801940:	0f b6 00             	movzbl (%rax),%eax
  801943:	3c 40                	cmp    $0x40,%al
  801945:	7e 48                	jle    80198f <strtol+0x16b>
  801947:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194b:	0f b6 00             	movzbl (%rax),%eax
  80194e:	3c 5a                	cmp    $0x5a,%al
  801950:	7f 3d                	jg     80198f <strtol+0x16b>
			dig = *s - 'A' + 10;
  801952:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801956:	0f b6 00             	movzbl (%rax),%eax
  801959:	0f be c0             	movsbl %al,%eax
  80195c:	83 e8 37             	sub    $0x37,%eax
  80195f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801962:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801965:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801968:	7c 02                	jl     80196c <strtol+0x148>
			break;
  80196a:	eb 23                	jmp    80198f <strtol+0x16b>
		s++, val = (val * base) + dig;
  80196c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801971:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801974:	48 98                	cltq   
  801976:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80197b:	48 89 c2             	mov    %rax,%rdx
  80197e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801981:	48 98                	cltq   
  801983:	48 01 d0             	add    %rdx,%rax
  801986:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80198a:	e9 5d ff ff ff       	jmpq   8018ec <strtol+0xc8>

	if (endptr)
  80198f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801994:	74 0b                	je     8019a1 <strtol+0x17d>
		*endptr = (char *) s;
  801996:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80199a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80199e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019a5:	74 09                	je     8019b0 <strtol+0x18c>
  8019a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ab:	48 f7 d8             	neg    %rax
  8019ae:	eb 04                	jmp    8019b4 <strtol+0x190>
  8019b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019b4:	c9                   	leaveq 
  8019b5:	c3                   	retq   

00000000008019b6 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019b6:	55                   	push   %rbp
  8019b7:	48 89 e5             	mov    %rsp,%rbp
  8019ba:	48 83 ec 30          	sub    $0x30,%rsp
  8019be:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019c2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019ca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ce:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019d2:	0f b6 00             	movzbl (%rax),%eax
  8019d5:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8019d8:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019dc:	75 06                	jne    8019e4 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8019de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e2:	eb 6b                	jmp    801a4f <strstr+0x99>

    len = strlen(str);
  8019e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e8:	48 89 c7             	mov    %rax,%rdi
  8019eb:	48 b8 8c 12 80 00 00 	movabs $0x80128c,%rax
  8019f2:	00 00 00 
  8019f5:	ff d0                	callq  *%rax
  8019f7:	48 98                	cltq   
  8019f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8019fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a01:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a05:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a09:	0f b6 00             	movzbl (%rax),%eax
  801a0c:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801a0f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a13:	75 07                	jne    801a1c <strstr+0x66>
                return (char *) 0;
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1a:	eb 33                	jmp    801a4f <strstr+0x99>
        } while (sc != c);
  801a1c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a20:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a23:	75 d8                	jne    8019fd <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a25:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a29:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a31:	48 89 ce             	mov    %rcx,%rsi
  801a34:	48 89 c7             	mov    %rax,%rdi
  801a37:	48 b8 ad 14 80 00 00 	movabs $0x8014ad,%rax
  801a3e:	00 00 00 
  801a41:	ff d0                	callq  *%rax
  801a43:	85 c0                	test   %eax,%eax
  801a45:	75 b6                	jne    8019fd <strstr+0x47>

    return (char *) (in - 1);
  801a47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4b:	48 83 e8 01          	sub    $0x1,%rax
}
  801a4f:	c9                   	leaveq 
  801a50:	c3                   	retq   
