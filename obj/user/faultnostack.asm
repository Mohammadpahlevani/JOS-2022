
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
  800052:	48 be 2e 05 80 00 00 	movabs $0x80052e,%rsi
  800059:	00 00 00 
  80005c:	bf 00 00 00 00       	mov    $0x0,%edi
  800061:	48 b8 4b 04 80 00 00 	movabs $0x80044b,%rax
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
  80007e:	48 83 ec 20          	sub    $0x20,%rsp
  800082:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800085:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800089:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800090:	00 00 00 
  800093:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  80009a:	48 b8 8f 02 80 00 00 	movabs $0x80028f,%rax
  8000a1:	00 00 00 
  8000a4:	ff d0                	callq  *%rax
  8000a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  8000a9:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  8000b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b3:	48 63 d0             	movslq %eax,%rdx
  8000b6:	48 89 d0             	mov    %rdx,%rax
  8000b9:	48 c1 e0 03          	shl    $0x3,%rax
  8000bd:	48 01 d0             	add    %rdx,%rax
  8000c0:	48 c1 e0 05          	shl    $0x5,%rax
  8000c4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000cb:	00 00 00 
  8000ce:	48 01 c2             	add    %rax,%rdx
  8000d1:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000d8:	00 00 00 
  8000db:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000e2:	7e 14                	jle    8000f8 <libmain+0x7e>
		binaryname = argv[0];
  8000e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e8:	48 8b 10             	mov    (%rax),%rdx
  8000eb:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000f2:	00 00 00 
  8000f5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000f8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000ff:	48 89 d6             	mov    %rdx,%rsi
  800102:	89 c7                	mov    %eax,%edi
  800104:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80010b:	00 00 00 
  80010e:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  800110:	48 b8 1e 01 80 00 00 	movabs $0x80011e,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
}
  80011c:	c9                   	leaveq 
  80011d:	c3                   	retq   

000000000080011e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800122:	bf 00 00 00 00       	mov    $0x0,%edi
  800127:	48 b8 4b 02 80 00 00 	movabs $0x80024b,%rax
  80012e:	00 00 00 
  800131:	ff d0                	callq  *%rax
}
  800133:	5d                   	pop    %rbp
  800134:	c3                   	retq   

0000000000800135 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800135:	55                   	push   %rbp
  800136:	48 89 e5             	mov    %rsp,%rbp
  800139:	53                   	push   %rbx
  80013a:	48 83 ec 48          	sub    $0x48,%rsp
  80013e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800141:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800144:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800148:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80014c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800150:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800154:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800157:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80015b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80015f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800163:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800167:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80016b:	4c 89 c3             	mov    %r8,%rbx
  80016e:	cd 30                	int    $0x30
  800170:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800174:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800178:	74 3e                	je     8001b8 <syscall+0x83>
  80017a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80017f:	7e 37                	jle    8001b8 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800181:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800185:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800188:	49 89 d0             	mov    %rdx,%r8
  80018b:	89 c1                	mov    %eax,%ecx
  80018d:	48 ba 0a 1c 80 00 00 	movabs $0x801c0a,%rdx
  800194:	00 00 00 
  800197:	be 23 00 00 00       	mov    $0x23,%esi
  80019c:	48 bf 27 1c 80 00 00 	movabs $0x801c27,%rdi
  8001a3:	00 00 00 
  8001a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ab:	49 b9 b8 05 80 00 00 	movabs $0x8005b8,%r9
  8001b2:	00 00 00 
  8001b5:	41 ff d1             	callq  *%r9

	return ret;
  8001b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001bc:	48 83 c4 48          	add    $0x48,%rsp
  8001c0:	5b                   	pop    %rbx
  8001c1:	5d                   	pop    %rbp
  8001c2:	c3                   	retq   

00000000008001c3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001c3:	55                   	push   %rbp
  8001c4:	48 89 e5             	mov    %rsp,%rbp
  8001c7:	48 83 ec 20          	sub    $0x20,%rsp
  8001cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001e2:	00 
  8001e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ef:	48 89 d1             	mov    %rdx,%rcx
  8001f2:	48 89 c2             	mov    %rax,%rdx
  8001f5:	be 00 00 00 00       	mov    $0x0,%esi
  8001fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ff:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800206:	00 00 00 
  800209:	ff d0                	callq  *%rax
}
  80020b:	c9                   	leaveq 
  80020c:	c3                   	retq   

000000000080020d <sys_cgetc>:

int
sys_cgetc(void)
{
  80020d:	55                   	push   %rbp
  80020e:	48 89 e5             	mov    %rsp,%rbp
  800211:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800215:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80021c:	00 
  80021d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800223:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800229:	b9 00 00 00 00       	mov    $0x0,%ecx
  80022e:	ba 00 00 00 00       	mov    $0x0,%edx
  800233:	be 00 00 00 00       	mov    $0x0,%esi
  800238:	bf 01 00 00 00       	mov    $0x1,%edi
  80023d:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800244:	00 00 00 
  800247:	ff d0                	callq  *%rax
}
  800249:	c9                   	leaveq 
  80024a:	c3                   	retq   

000000000080024b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80024b:	55                   	push   %rbp
  80024c:	48 89 e5             	mov    %rsp,%rbp
  80024f:	48 83 ec 10          	sub    $0x10,%rsp
  800253:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800256:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800259:	48 98                	cltq   
  80025b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800262:	00 
  800263:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800269:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80026f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800274:	48 89 c2             	mov    %rax,%rdx
  800277:	be 01 00 00 00       	mov    $0x1,%esi
  80027c:	bf 03 00 00 00       	mov    $0x3,%edi
  800281:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800288:	00 00 00 
  80028b:	ff d0                	callq  *%rax
}
  80028d:	c9                   	leaveq 
  80028e:	c3                   	retq   

000000000080028f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80028f:	55                   	push   %rbp
  800290:	48 89 e5             	mov    %rsp,%rbp
  800293:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800297:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80029e:	00 
  80029f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b5:	be 00 00 00 00       	mov    $0x0,%esi
  8002ba:	bf 02 00 00 00       	mov    $0x2,%edi
  8002bf:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax
}
  8002cb:	c9                   	leaveq 
  8002cc:	c3                   	retq   

00000000008002cd <sys_yield>:

void
sys_yield(void)
{
  8002cd:	55                   	push   %rbp
  8002ce:	48 89 e5             	mov    %rsp,%rbp
  8002d1:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002d5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002dc:	00 
  8002dd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f3:	be 00 00 00 00       	mov    $0x0,%esi
  8002f8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002fd:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax
}
  800309:	c9                   	leaveq 
  80030a:	c3                   	retq   

000000000080030b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80030b:	55                   	push   %rbp
  80030c:	48 89 e5             	mov    %rsp,%rbp
  80030f:	48 83 ec 20          	sub    $0x20,%rsp
  800313:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800316:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80031a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80031d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800320:	48 63 c8             	movslq %eax,%rcx
  800323:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	48 98                	cltq   
  80032c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800333:	00 
  800334:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80033a:	49 89 c8             	mov    %rcx,%r8
  80033d:	48 89 d1             	mov    %rdx,%rcx
  800340:	48 89 c2             	mov    %rax,%rdx
  800343:	be 01 00 00 00       	mov    $0x1,%esi
  800348:	bf 04 00 00 00       	mov    $0x4,%edi
  80034d:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
}
  800359:	c9                   	leaveq 
  80035a:	c3                   	retq   

000000000080035b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80035b:	55                   	push   %rbp
  80035c:	48 89 e5             	mov    %rsp,%rbp
  80035f:	48 83 ec 30          	sub    $0x30,%rsp
  800363:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800366:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80036a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80036d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800371:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800375:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800378:	48 63 c8             	movslq %eax,%rcx
  80037b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80037f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800382:	48 63 f0             	movslq %eax,%rsi
  800385:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800389:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80038c:	48 98                	cltq   
  80038e:	48 89 0c 24          	mov    %rcx,(%rsp)
  800392:	49 89 f9             	mov    %rdi,%r9
  800395:	49 89 f0             	mov    %rsi,%r8
  800398:	48 89 d1             	mov    %rdx,%rcx
  80039b:	48 89 c2             	mov    %rax,%rdx
  80039e:	be 01 00 00 00       	mov    $0x1,%esi
  8003a3:	bf 05 00 00 00       	mov    $0x5,%edi
  8003a8:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  8003af:	00 00 00 
  8003b2:	ff d0                	callq  *%rax
}
  8003b4:	c9                   	leaveq 
  8003b5:	c3                   	retq   

00000000008003b6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003b6:	55                   	push   %rbp
  8003b7:	48 89 e5             	mov    %rsp,%rbp
  8003ba:	48 83 ec 20          	sub    $0x20,%rsp
  8003be:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003cc:	48 98                	cltq   
  8003ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003d5:	00 
  8003d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003e2:	48 89 d1             	mov    %rdx,%rcx
  8003e5:	48 89 c2             	mov    %rax,%rdx
  8003e8:	be 01 00 00 00       	mov    $0x1,%esi
  8003ed:	bf 06 00 00 00       	mov    $0x6,%edi
  8003f2:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  8003f9:	00 00 00 
  8003fc:	ff d0                	callq  *%rax
}
  8003fe:	c9                   	leaveq 
  8003ff:	c3                   	retq   

0000000000800400 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800400:	55                   	push   %rbp
  800401:	48 89 e5             	mov    %rsp,%rbp
  800404:	48 83 ec 10          	sub    $0x10,%rsp
  800408:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80040b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80040e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800411:	48 63 d0             	movslq %eax,%rdx
  800414:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800417:	48 98                	cltq   
  800419:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800420:	00 
  800421:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800427:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80042d:	48 89 d1             	mov    %rdx,%rcx
  800430:	48 89 c2             	mov    %rax,%rdx
  800433:	be 01 00 00 00       	mov    $0x1,%esi
  800438:	bf 08 00 00 00       	mov    $0x8,%edi
  80043d:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800444:	00 00 00 
  800447:	ff d0                	callq  *%rax
}
  800449:	c9                   	leaveq 
  80044a:	c3                   	retq   

000000000080044b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80044b:	55                   	push   %rbp
  80044c:	48 89 e5             	mov    %rsp,%rbp
  80044f:	48 83 ec 20          	sub    $0x20,%rsp
  800453:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800456:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80045a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80045e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800461:	48 98                	cltq   
  800463:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80046a:	00 
  80046b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800471:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800477:	48 89 d1             	mov    %rdx,%rcx
  80047a:	48 89 c2             	mov    %rax,%rdx
  80047d:	be 01 00 00 00       	mov    $0x1,%esi
  800482:	bf 09 00 00 00       	mov    $0x9,%edi
  800487:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  80048e:	00 00 00 
  800491:	ff d0                	callq  *%rax
}
  800493:	c9                   	leaveq 
  800494:	c3                   	retq   

0000000000800495 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800495:	55                   	push   %rbp
  800496:	48 89 e5             	mov    %rsp,%rbp
  800499:	48 83 ec 20          	sub    $0x20,%rsp
  80049d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004a8:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004ae:	48 63 f0             	movslq %eax,%rsi
  8004b1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004b8:	48 98                	cltq   
  8004ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004c5:	00 
  8004c6:	49 89 f1             	mov    %rsi,%r9
  8004c9:	49 89 c8             	mov    %rcx,%r8
  8004cc:	48 89 d1             	mov    %rdx,%rcx
  8004cf:	48 89 c2             	mov    %rax,%rdx
  8004d2:	be 00 00 00 00       	mov    $0x0,%esi
  8004d7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004dc:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  8004e3:	00 00 00 
  8004e6:	ff d0                	callq  *%rax
}
  8004e8:	c9                   	leaveq 
  8004e9:	c3                   	retq   

00000000008004ea <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004ea:	55                   	push   %rbp
  8004eb:	48 89 e5             	mov    %rsp,%rbp
  8004ee:	48 83 ec 10          	sub    $0x10,%rsp
  8004f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004fa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800501:	00 
  800502:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800508:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80050e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800513:	48 89 c2             	mov    %rax,%rdx
  800516:	be 01 00 00 00       	mov    $0x1,%esi
  80051b:	bf 0c 00 00 00       	mov    $0xc,%edi
  800520:	48 b8 35 01 80 00 00 	movabs $0x800135,%rax
  800527:	00 00 00 
  80052a:	ff d0                	callq  *%rax
}
  80052c:	c9                   	leaveq 
  80052d:	c3                   	retq   

000000000080052e <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  80052e:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  800531:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  800538:	00 00 00 
	call *%rax
  80053b:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.                
	movq %rsp, %rdi;	
  80053d:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  800540:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  800547:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  800548:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  80054f:	00 
	pushq %rbx;
  800550:	53                   	push   %rbx
	movq %rsp, %rbx;	
  800551:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  800554:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  800557:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  80055e:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  80055f:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  800563:	4c 8b 3c 24          	mov    (%rsp),%r15
  800567:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80056c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  800571:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  800576:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80057b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  800580:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  800585:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80058a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80058f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  800594:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  800599:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80059e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8005a3:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8005a8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8005ad:	48 83 c4 78          	add    $0x78,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	add $8, %rsp; //Jump rip field  
  8005b1:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8005b5:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  8005b6:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  8005b7:	c3                   	retq   

00000000008005b8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005b8:	55                   	push   %rbp
  8005b9:	48 89 e5             	mov    %rsp,%rbp
  8005bc:	53                   	push   %rbx
  8005bd:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005c4:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005cb:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005d1:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005d8:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005df:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005e6:	84 c0                	test   %al,%al
  8005e8:	74 23                	je     80060d <_panic+0x55>
  8005ea:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8005f1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8005f5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8005f9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8005fd:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800601:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800605:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800609:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80060d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800614:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80061b:	00 00 00 
  80061e:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800625:	00 00 00 
  800628:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80062c:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800633:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80063a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800641:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800648:	00 00 00 
  80064b:	48 8b 18             	mov    (%rax),%rbx
  80064e:	48 b8 8f 02 80 00 00 	movabs $0x80028f,%rax
  800655:	00 00 00 
  800658:	ff d0                	callq  *%rax
  80065a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800660:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800667:	41 89 c8             	mov    %ecx,%r8d
  80066a:	48 89 d1             	mov    %rdx,%rcx
  80066d:	48 89 da             	mov    %rbx,%rdx
  800670:	89 c6                	mov    %eax,%esi
  800672:	48 bf 38 1c 80 00 00 	movabs $0x801c38,%rdi
  800679:	00 00 00 
  80067c:	b8 00 00 00 00       	mov    $0x0,%eax
  800681:	49 b9 f1 07 80 00 00 	movabs $0x8007f1,%r9
  800688:	00 00 00 
  80068b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80068e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800695:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80069c:	48 89 d6             	mov    %rdx,%rsi
  80069f:	48 89 c7             	mov    %rax,%rdi
  8006a2:	48 b8 45 07 80 00 00 	movabs $0x800745,%rax
  8006a9:	00 00 00 
  8006ac:	ff d0                	callq  *%rax
	cprintf("\n");
  8006ae:	48 bf 5b 1c 80 00 00 	movabs $0x801c5b,%rdi
  8006b5:	00 00 00 
  8006b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8006bd:	48 ba f1 07 80 00 00 	movabs $0x8007f1,%rdx
  8006c4:	00 00 00 
  8006c7:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006c9:	cc                   	int3   
  8006ca:	eb fd                	jmp    8006c9 <_panic+0x111>

00000000008006cc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006cc:	55                   	push   %rbp
  8006cd:	48 89 e5             	mov    %rsp,%rbp
  8006d0:	48 83 ec 10          	sub    $0x10,%rsp
  8006d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  8006db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006df:	8b 00                	mov    (%rax),%eax
  8006e1:	8d 48 01             	lea    0x1(%rax),%ecx
  8006e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006e8:	89 0a                	mov    %ecx,(%rdx)
  8006ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006ed:	89 d1                	mov    %edx,%ecx
  8006ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f3:	48 98                	cltq   
  8006f5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  8006f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006fd:	8b 00                	mov    (%rax),%eax
  8006ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800704:	75 2c                	jne    800732 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800706:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80070a:	8b 00                	mov    (%rax),%eax
  80070c:	48 98                	cltq   
  80070e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800712:	48 83 c2 08          	add    $0x8,%rdx
  800716:	48 89 c6             	mov    %rax,%rsi
  800719:	48 89 d7             	mov    %rdx,%rdi
  80071c:	48 b8 c3 01 80 00 00 	movabs $0x8001c3,%rax
  800723:	00 00 00 
  800726:	ff d0                	callq  *%rax
		b->idx = 0;
  800728:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80072c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800732:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800736:	8b 40 04             	mov    0x4(%rax),%eax
  800739:	8d 50 01             	lea    0x1(%rax),%edx
  80073c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800740:	89 50 04             	mov    %edx,0x4(%rax)
}
  800743:	c9                   	leaveq 
  800744:	c3                   	retq   

0000000000800745 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800745:	55                   	push   %rbp
  800746:	48 89 e5             	mov    %rsp,%rbp
  800749:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800750:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800757:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  80075e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800765:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80076c:	48 8b 0a             	mov    (%rdx),%rcx
  80076f:	48 89 08             	mov    %rcx,(%rax)
  800772:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800776:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80077a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80077e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800782:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800789:	00 00 00 
	b.cnt = 0;
  80078c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800793:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800796:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80079d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007a4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007ab:	48 89 c6             	mov    %rax,%rsi
  8007ae:	48 bf cc 06 80 00 00 	movabs $0x8006cc,%rdi
  8007b5:	00 00 00 
  8007b8:	48 b8 a4 0b 80 00 00 	movabs $0x800ba4,%rax
  8007bf:	00 00 00 
  8007c2:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8007c4:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007ca:	48 98                	cltq   
  8007cc:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007d3:	48 83 c2 08          	add    $0x8,%rdx
  8007d7:	48 89 c6             	mov    %rax,%rsi
  8007da:	48 89 d7             	mov    %rdx,%rdi
  8007dd:	48 b8 c3 01 80 00 00 	movabs $0x8001c3,%rax
  8007e4:	00 00 00 
  8007e7:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  8007e9:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8007ef:	c9                   	leaveq 
  8007f0:	c3                   	retq   

00000000008007f1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007f1:	55                   	push   %rbp
  8007f2:	48 89 e5             	mov    %rsp,%rbp
  8007f5:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8007fc:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800803:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80080a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800811:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800818:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80081f:	84 c0                	test   %al,%al
  800821:	74 20                	je     800843 <cprintf+0x52>
  800823:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800827:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80082b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80082f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800833:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800837:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80083b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80083f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800843:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  80084a:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800851:	00 00 00 
  800854:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80085b:	00 00 00 
  80085e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800862:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800869:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800870:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800877:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80087e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800885:	48 8b 0a             	mov    (%rdx),%rcx
  800888:	48 89 08             	mov    %rcx,(%rax)
  80088b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80088f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800893:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800897:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80089b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008a2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008a9:	48 89 d6             	mov    %rdx,%rsi
  8008ac:	48 89 c7             	mov    %rax,%rdi
  8008af:	48 b8 45 07 80 00 00 	movabs $0x800745,%rax
  8008b6:	00 00 00 
  8008b9:	ff d0                	callq  *%rax
  8008bb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8008c1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008c7:	c9                   	leaveq 
  8008c8:	c3                   	retq   

00000000008008c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008c9:	55                   	push   %rbp
  8008ca:	48 89 e5             	mov    %rsp,%rbp
  8008cd:	53                   	push   %rbx
  8008ce:	48 83 ec 38          	sub    $0x38,%rsp
  8008d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8008da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8008de:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8008e1:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8008e5:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008e9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8008ec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8008f0:	77 3b                	ja     80092d <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008f2:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8008f5:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8008f9:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8008fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800900:	ba 00 00 00 00       	mov    $0x0,%edx
  800905:	48 f7 f3             	div    %rbx
  800908:	48 89 c2             	mov    %rax,%rdx
  80090b:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80090e:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800911:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800915:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800919:	41 89 f9             	mov    %edi,%r9d
  80091c:	48 89 c7             	mov    %rax,%rdi
  80091f:	48 b8 c9 08 80 00 00 	movabs $0x8008c9,%rax
  800926:	00 00 00 
  800929:	ff d0                	callq  *%rax
  80092b:	eb 1e                	jmp    80094b <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80092d:	eb 12                	jmp    800941 <printnum+0x78>
			putch(padc, putdat);
  80092f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800933:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800936:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093a:	48 89 ce             	mov    %rcx,%rsi
  80093d:	89 d7                	mov    %edx,%edi
  80093f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800941:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800945:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800949:	7f e4                	jg     80092f <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80094b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80094e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800952:	ba 00 00 00 00       	mov    $0x0,%edx
  800957:	48 f7 f1             	div    %rcx
  80095a:	48 89 d0             	mov    %rdx,%rax
  80095d:	48 ba 50 1d 80 00 00 	movabs $0x801d50,%rdx
  800964:	00 00 00 
  800967:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80096b:	0f be d0             	movsbl %al,%edx
  80096e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800972:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800976:	48 89 ce             	mov    %rcx,%rsi
  800979:	89 d7                	mov    %edx,%edi
  80097b:	ff d0                	callq  *%rax
}
  80097d:	48 83 c4 38          	add    $0x38,%rsp
  800981:	5b                   	pop    %rbx
  800982:	5d                   	pop    %rbp
  800983:	c3                   	retq   

0000000000800984 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800984:	55                   	push   %rbp
  800985:	48 89 e5             	mov    %rsp,%rbp
  800988:	48 83 ec 1c          	sub    $0x1c,%rsp
  80098c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800990:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800993:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800997:	7e 52                	jle    8009eb <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099d:	8b 00                	mov    (%rax),%eax
  80099f:	83 f8 30             	cmp    $0x30,%eax
  8009a2:	73 24                	jae    8009c8 <getuint+0x44>
  8009a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b0:	8b 00                	mov    (%rax),%eax
  8009b2:	89 c0                	mov    %eax,%eax
  8009b4:	48 01 d0             	add    %rdx,%rax
  8009b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bb:	8b 12                	mov    (%rdx),%edx
  8009bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c4:	89 0a                	mov    %ecx,(%rdx)
  8009c6:	eb 17                	jmp    8009df <getuint+0x5b>
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d0:	48 89 d0             	mov    %rdx,%rax
  8009d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009df:	48 8b 00             	mov    (%rax),%rax
  8009e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009e6:	e9 a3 00 00 00       	jmpq   800a8e <getuint+0x10a>
	else if (lflag)
  8009eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009ef:	74 4f                	je     800a40 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8009f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f5:	8b 00                	mov    (%rax),%eax
  8009f7:	83 f8 30             	cmp    $0x30,%eax
  8009fa:	73 24                	jae    800a20 <getuint+0x9c>
  8009fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a00:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a08:	8b 00                	mov    (%rax),%eax
  800a0a:	89 c0                	mov    %eax,%eax
  800a0c:	48 01 d0             	add    %rdx,%rax
  800a0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a13:	8b 12                	mov    (%rdx),%edx
  800a15:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a18:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1c:	89 0a                	mov    %ecx,(%rdx)
  800a1e:	eb 17                	jmp    800a37 <getuint+0xb3>
  800a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a24:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a28:	48 89 d0             	mov    %rdx,%rax
  800a2b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a33:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a37:	48 8b 00             	mov    (%rax),%rax
  800a3a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a3e:	eb 4e                	jmp    800a8e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a44:	8b 00                	mov    (%rax),%eax
  800a46:	83 f8 30             	cmp    $0x30,%eax
  800a49:	73 24                	jae    800a6f <getuint+0xeb>
  800a4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a57:	8b 00                	mov    (%rax),%eax
  800a59:	89 c0                	mov    %eax,%eax
  800a5b:	48 01 d0             	add    %rdx,%rax
  800a5e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a62:	8b 12                	mov    (%rdx),%edx
  800a64:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6b:	89 0a                	mov    %ecx,(%rdx)
  800a6d:	eb 17                	jmp    800a86 <getuint+0x102>
  800a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a73:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a77:	48 89 d0             	mov    %rdx,%rax
  800a7a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a82:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a86:	8b 00                	mov    (%rax),%eax
  800a88:	89 c0                	mov    %eax,%eax
  800a8a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a92:	c9                   	leaveq 
  800a93:	c3                   	retq   

0000000000800a94 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a94:	55                   	push   %rbp
  800a95:	48 89 e5             	mov    %rsp,%rbp
  800a98:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a9c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800aa0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800aa3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800aa7:	7e 52                	jle    800afb <getint+0x67>
		x=va_arg(*ap, long long);
  800aa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aad:	8b 00                	mov    (%rax),%eax
  800aaf:	83 f8 30             	cmp    $0x30,%eax
  800ab2:	73 24                	jae    800ad8 <getint+0x44>
  800ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac0:	8b 00                	mov    (%rax),%eax
  800ac2:	89 c0                	mov    %eax,%eax
  800ac4:	48 01 d0             	add    %rdx,%rax
  800ac7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acb:	8b 12                	mov    (%rdx),%edx
  800acd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad4:	89 0a                	mov    %ecx,(%rdx)
  800ad6:	eb 17                	jmp    800aef <getint+0x5b>
  800ad8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ae0:	48 89 d0             	mov    %rdx,%rax
  800ae3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ae7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aeb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aef:	48 8b 00             	mov    (%rax),%rax
  800af2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800af6:	e9 a3 00 00 00       	jmpq   800b9e <getint+0x10a>
	else if (lflag)
  800afb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800aff:	74 4f                	je     800b50 <getint+0xbc>
		x=va_arg(*ap, long);
  800b01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b05:	8b 00                	mov    (%rax),%eax
  800b07:	83 f8 30             	cmp    $0x30,%eax
  800b0a:	73 24                	jae    800b30 <getint+0x9c>
  800b0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b10:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b18:	8b 00                	mov    (%rax),%eax
  800b1a:	89 c0                	mov    %eax,%eax
  800b1c:	48 01 d0             	add    %rdx,%rax
  800b1f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b23:	8b 12                	mov    (%rdx),%edx
  800b25:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b28:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b2c:	89 0a                	mov    %ecx,(%rdx)
  800b2e:	eb 17                	jmp    800b47 <getint+0xb3>
  800b30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b34:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b38:	48 89 d0             	mov    %rdx,%rax
  800b3b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b43:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b47:	48 8b 00             	mov    (%rax),%rax
  800b4a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b4e:	eb 4e                	jmp    800b9e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b54:	8b 00                	mov    (%rax),%eax
  800b56:	83 f8 30             	cmp    $0x30,%eax
  800b59:	73 24                	jae    800b7f <getint+0xeb>
  800b5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b67:	8b 00                	mov    (%rax),%eax
  800b69:	89 c0                	mov    %eax,%eax
  800b6b:	48 01 d0             	add    %rdx,%rax
  800b6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b72:	8b 12                	mov    (%rdx),%edx
  800b74:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b77:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7b:	89 0a                	mov    %ecx,(%rdx)
  800b7d:	eb 17                	jmp    800b96 <getint+0x102>
  800b7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b83:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b87:	48 89 d0             	mov    %rdx,%rax
  800b8a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b92:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b96:	8b 00                	mov    (%rax),%eax
  800b98:	48 98                	cltq   
  800b9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ba2:	c9                   	leaveq 
  800ba3:	c3                   	retq   

0000000000800ba4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ba4:	55                   	push   %rbp
  800ba5:	48 89 e5             	mov    %rsp,%rbp
  800ba8:	41 54                	push   %r12
  800baa:	53                   	push   %rbx
  800bab:	48 83 ec 60          	sub    $0x60,%rsp
  800baf:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bb3:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800bb7:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bbb:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bbf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bc7:	48 8b 0a             	mov    (%rdx),%rcx
  800bca:	48 89 08             	mov    %rcx,(%rax)
  800bcd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bd1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bd5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bd9:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bdd:	eb 17                	jmp    800bf6 <vprintfmt+0x52>
			if (ch == '\0')
  800bdf:	85 db                	test   %ebx,%ebx
  800be1:	0f 84 cc 04 00 00    	je     8010b3 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800be7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800beb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bef:	48 89 d6             	mov    %rdx,%rsi
  800bf2:	89 df                	mov    %ebx,%edi
  800bf4:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bfa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bfe:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c02:	0f b6 00             	movzbl (%rax),%eax
  800c05:	0f b6 d8             	movzbl %al,%ebx
  800c08:	83 fb 25             	cmp    $0x25,%ebx
  800c0b:	75 d2                	jne    800bdf <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800c0d:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c11:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c18:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c26:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c2d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c31:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c35:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c39:	0f b6 00             	movzbl (%rax),%eax
  800c3c:	0f b6 d8             	movzbl %al,%ebx
  800c3f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c42:	83 f8 55             	cmp    $0x55,%eax
  800c45:	0f 87 34 04 00 00    	ja     80107f <vprintfmt+0x4db>
  800c4b:	89 c0                	mov    %eax,%eax
  800c4d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c54:	00 
  800c55:	48 b8 78 1d 80 00 00 	movabs $0x801d78,%rax
  800c5c:	00 00 00 
  800c5f:	48 01 d0             	add    %rdx,%rax
  800c62:	48 8b 00             	mov    (%rax),%rax
  800c65:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c67:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c6b:	eb c0                	jmp    800c2d <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c6d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c71:	eb ba                	jmp    800c2d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c73:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c7a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c7d:	89 d0                	mov    %edx,%eax
  800c7f:	c1 e0 02             	shl    $0x2,%eax
  800c82:	01 d0                	add    %edx,%eax
  800c84:	01 c0                	add    %eax,%eax
  800c86:	01 d8                	add    %ebx,%eax
  800c88:	83 e8 30             	sub    $0x30,%eax
  800c8b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c8e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c92:	0f b6 00             	movzbl (%rax),%eax
  800c95:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c98:	83 fb 2f             	cmp    $0x2f,%ebx
  800c9b:	7e 0c                	jle    800ca9 <vprintfmt+0x105>
  800c9d:	83 fb 39             	cmp    $0x39,%ebx
  800ca0:	7f 07                	jg     800ca9 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca2:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ca7:	eb d1                	jmp    800c7a <vprintfmt+0xd6>
			goto process_precision;
  800ca9:	eb 58                	jmp    800d03 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800cab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cae:	83 f8 30             	cmp    $0x30,%eax
  800cb1:	73 17                	jae    800cca <vprintfmt+0x126>
  800cb3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cb7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cba:	89 c0                	mov    %eax,%eax
  800cbc:	48 01 d0             	add    %rdx,%rax
  800cbf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cc2:	83 c2 08             	add    $0x8,%edx
  800cc5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cc8:	eb 0f                	jmp    800cd9 <vprintfmt+0x135>
  800cca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cce:	48 89 d0             	mov    %rdx,%rax
  800cd1:	48 83 c2 08          	add    $0x8,%rdx
  800cd5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cd9:	8b 00                	mov    (%rax),%eax
  800cdb:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cde:	eb 23                	jmp    800d03 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800ce0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce4:	79 0c                	jns    800cf2 <vprintfmt+0x14e>
				width = 0;
  800ce6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ced:	e9 3b ff ff ff       	jmpq   800c2d <vprintfmt+0x89>
  800cf2:	e9 36 ff ff ff       	jmpq   800c2d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800cf7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800cfe:	e9 2a ff ff ff       	jmpq   800c2d <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800d03:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d07:	79 12                	jns    800d1b <vprintfmt+0x177>
				width = precision, precision = -1;
  800d09:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d0c:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d0f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d16:	e9 12 ff ff ff       	jmpq   800c2d <vprintfmt+0x89>
  800d1b:	e9 0d ff ff ff       	jmpq   800c2d <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d20:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d24:	e9 04 ff ff ff       	jmpq   800c2d <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800d29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d2c:	83 f8 30             	cmp    $0x30,%eax
  800d2f:	73 17                	jae    800d48 <vprintfmt+0x1a4>
  800d31:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d38:	89 c0                	mov    %eax,%eax
  800d3a:	48 01 d0             	add    %rdx,%rax
  800d3d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d40:	83 c2 08             	add    $0x8,%edx
  800d43:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d46:	eb 0f                	jmp    800d57 <vprintfmt+0x1b3>
  800d48:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d4c:	48 89 d0             	mov    %rdx,%rax
  800d4f:	48 83 c2 08          	add    $0x8,%rdx
  800d53:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d57:	8b 10                	mov    (%rax),%edx
  800d59:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d5d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d61:	48 89 ce             	mov    %rcx,%rsi
  800d64:	89 d7                	mov    %edx,%edi
  800d66:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800d68:	e9 40 03 00 00       	jmpq   8010ad <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800d6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d70:	83 f8 30             	cmp    $0x30,%eax
  800d73:	73 17                	jae    800d8c <vprintfmt+0x1e8>
  800d75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d7c:	89 c0                	mov    %eax,%eax
  800d7e:	48 01 d0             	add    %rdx,%rax
  800d81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d84:	83 c2 08             	add    $0x8,%edx
  800d87:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d8a:	eb 0f                	jmp    800d9b <vprintfmt+0x1f7>
  800d8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d90:	48 89 d0             	mov    %rdx,%rax
  800d93:	48 83 c2 08          	add    $0x8,%rdx
  800d97:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d9b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d9d:	85 db                	test   %ebx,%ebx
  800d9f:	79 02                	jns    800da3 <vprintfmt+0x1ff>
				err = -err;
  800da1:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800da3:	83 fb 09             	cmp    $0x9,%ebx
  800da6:	7f 16                	jg     800dbe <vprintfmt+0x21a>
  800da8:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  800daf:	00 00 00 
  800db2:	48 63 d3             	movslq %ebx,%rdx
  800db5:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800db9:	4d 85 e4             	test   %r12,%r12
  800dbc:	75 2e                	jne    800dec <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800dbe:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dc2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc6:	89 d9                	mov    %ebx,%ecx
  800dc8:	48 ba 61 1d 80 00 00 	movabs $0x801d61,%rdx
  800dcf:	00 00 00 
  800dd2:	48 89 c7             	mov    %rax,%rdi
  800dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dda:	49 b8 bc 10 80 00 00 	movabs $0x8010bc,%r8
  800de1:	00 00 00 
  800de4:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800de7:	e9 c1 02 00 00       	jmpq   8010ad <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dec:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800df0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df4:	4c 89 e1             	mov    %r12,%rcx
  800df7:	48 ba 6a 1d 80 00 00 	movabs $0x801d6a,%rdx
  800dfe:	00 00 00 
  800e01:	48 89 c7             	mov    %rax,%rdi
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
  800e09:	49 b8 bc 10 80 00 00 	movabs $0x8010bc,%r8
  800e10:	00 00 00 
  800e13:	41 ff d0             	callq  *%r8
			break;
  800e16:	e9 92 02 00 00       	jmpq   8010ad <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800e1b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e1e:	83 f8 30             	cmp    $0x30,%eax
  800e21:	73 17                	jae    800e3a <vprintfmt+0x296>
  800e23:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e27:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e2a:	89 c0                	mov    %eax,%eax
  800e2c:	48 01 d0             	add    %rdx,%rax
  800e2f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e32:	83 c2 08             	add    $0x8,%edx
  800e35:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e38:	eb 0f                	jmp    800e49 <vprintfmt+0x2a5>
  800e3a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e3e:	48 89 d0             	mov    %rdx,%rax
  800e41:	48 83 c2 08          	add    $0x8,%rdx
  800e45:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e49:	4c 8b 20             	mov    (%rax),%r12
  800e4c:	4d 85 e4             	test   %r12,%r12
  800e4f:	75 0a                	jne    800e5b <vprintfmt+0x2b7>
				p = "(null)";
  800e51:	49 bc 6d 1d 80 00 00 	movabs $0x801d6d,%r12
  800e58:	00 00 00 
			if (width > 0 && padc != '-')
  800e5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e5f:	7e 3f                	jle    800ea0 <vprintfmt+0x2fc>
  800e61:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e65:	74 39                	je     800ea0 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e67:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e6a:	48 98                	cltq   
  800e6c:	48 89 c6             	mov    %rax,%rsi
  800e6f:	4c 89 e7             	mov    %r12,%rdi
  800e72:	48 b8 68 13 80 00 00 	movabs $0x801368,%rax
  800e79:	00 00 00 
  800e7c:	ff d0                	callq  *%rax
  800e7e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e81:	eb 17                	jmp    800e9a <vprintfmt+0x2f6>
					putch(padc, putdat);
  800e83:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e87:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e8f:	48 89 ce             	mov    %rcx,%rsi
  800e92:	89 d7                	mov    %edx,%edi
  800e94:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e96:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e9a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e9e:	7f e3                	jg     800e83 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ea0:	eb 37                	jmp    800ed9 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800ea2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ea6:	74 1e                	je     800ec6 <vprintfmt+0x322>
  800ea8:	83 fb 1f             	cmp    $0x1f,%ebx
  800eab:	7e 05                	jle    800eb2 <vprintfmt+0x30e>
  800ead:	83 fb 7e             	cmp    $0x7e,%ebx
  800eb0:	7e 14                	jle    800ec6 <vprintfmt+0x322>
					putch('?', putdat);
  800eb2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eba:	48 89 d6             	mov    %rdx,%rsi
  800ebd:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800ec2:	ff d0                	callq  *%rax
  800ec4:	eb 0f                	jmp    800ed5 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800ec6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ece:	48 89 d6             	mov    %rdx,%rsi
  800ed1:	89 df                	mov    %ebx,%edi
  800ed3:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ed5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ed9:	4c 89 e0             	mov    %r12,%rax
  800edc:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ee0:	0f b6 00             	movzbl (%rax),%eax
  800ee3:	0f be d8             	movsbl %al,%ebx
  800ee6:	85 db                	test   %ebx,%ebx
  800ee8:	74 10                	je     800efa <vprintfmt+0x356>
  800eea:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800eee:	78 b2                	js     800ea2 <vprintfmt+0x2fe>
  800ef0:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ef4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ef8:	79 a8                	jns    800ea2 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800efa:	eb 16                	jmp    800f12 <vprintfmt+0x36e>
				putch(' ', putdat);
  800efc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f04:	48 89 d6             	mov    %rdx,%rsi
  800f07:	bf 20 00 00 00       	mov    $0x20,%edi
  800f0c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f0e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f12:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f16:	7f e4                	jg     800efc <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800f18:	e9 90 01 00 00       	jmpq   8010ad <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800f1d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f21:	be 03 00 00 00       	mov    $0x3,%esi
  800f26:	48 89 c7             	mov    %rax,%rdi
  800f29:	48 b8 94 0a 80 00 00 	movabs $0x800a94,%rax
  800f30:	00 00 00 
  800f33:	ff d0                	callq  *%rax
  800f35:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3d:	48 85 c0             	test   %rax,%rax
  800f40:	79 1d                	jns    800f5f <vprintfmt+0x3bb>
				putch('-', putdat);
  800f42:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f4a:	48 89 d6             	mov    %rdx,%rsi
  800f4d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f52:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f58:	48 f7 d8             	neg    %rax
  800f5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f5f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f66:	e9 d5 00 00 00       	jmpq   801040 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800f6b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f6f:	be 03 00 00 00       	mov    $0x3,%esi
  800f74:	48 89 c7             	mov    %rax,%rdi
  800f77:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  800f7e:	00 00 00 
  800f81:	ff d0                	callq  *%rax
  800f83:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f87:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f8e:	e9 ad 00 00 00       	jmpq   801040 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800f93:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f97:	be 03 00 00 00       	mov    $0x3,%esi
  800f9c:	48 89 c7             	mov    %rax,%rdi
  800f9f:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  800fa6:	00 00 00 
  800fa9:	ff d0                	callq  *%rax
  800fab:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800faf:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800fb6:	e9 85 00 00 00       	jmpq   801040 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800fbb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fbf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc3:	48 89 d6             	mov    %rdx,%rsi
  800fc6:	bf 30 00 00 00       	mov    $0x30,%edi
  800fcb:	ff d0                	callq  *%rax
			putch('x', putdat);
  800fcd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fd1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd5:	48 89 d6             	mov    %rdx,%rsi
  800fd8:	bf 78 00 00 00       	mov    $0x78,%edi
  800fdd:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800fdf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fe2:	83 f8 30             	cmp    $0x30,%eax
  800fe5:	73 17                	jae    800ffe <vprintfmt+0x45a>
  800fe7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800feb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fee:	89 c0                	mov    %eax,%eax
  800ff0:	48 01 d0             	add    %rdx,%rax
  800ff3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ff6:	83 c2 08             	add    $0x8,%edx
  800ff9:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ffc:	eb 0f                	jmp    80100d <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800ffe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801002:	48 89 d0             	mov    %rdx,%rax
  801005:	48 83 c2 08          	add    $0x8,%rdx
  801009:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80100d:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801010:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801014:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80101b:	eb 23                	jmp    801040 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  80101d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801021:	be 03 00 00 00       	mov    $0x3,%esi
  801026:	48 89 c7             	mov    %rax,%rdi
  801029:	48 b8 84 09 80 00 00 	movabs $0x800984,%rax
  801030:	00 00 00 
  801033:	ff d0                	callq  *%rax
  801035:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801039:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  801040:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801045:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801048:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80104b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80104f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801053:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801057:	45 89 c1             	mov    %r8d,%r9d
  80105a:	41 89 f8             	mov    %edi,%r8d
  80105d:	48 89 c7             	mov    %rax,%rdi
  801060:	48 b8 c9 08 80 00 00 	movabs $0x8008c9,%rax
  801067:	00 00 00 
  80106a:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  80106c:	eb 3f                	jmp    8010ad <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80106e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801072:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801076:	48 89 d6             	mov    %rdx,%rsi
  801079:	89 df                	mov    %ebx,%edi
  80107b:	ff d0                	callq  *%rax
			break;
  80107d:	eb 2e                	jmp    8010ad <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80107f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801083:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801087:	48 89 d6             	mov    %rdx,%rsi
  80108a:	bf 25 00 00 00       	mov    $0x25,%edi
  80108f:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  801091:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801096:	eb 05                	jmp    80109d <vprintfmt+0x4f9>
  801098:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80109d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8010a1:	48 83 e8 01          	sub    $0x1,%rax
  8010a5:	0f b6 00             	movzbl (%rax),%eax
  8010a8:	3c 25                	cmp    $0x25,%al
  8010aa:	75 ec                	jne    801098 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  8010ac:	90                   	nop
		}
	}
  8010ad:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010ae:	e9 43 fb ff ff       	jmpq   800bf6 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  8010b3:	48 83 c4 60          	add    $0x60,%rsp
  8010b7:	5b                   	pop    %rbx
  8010b8:	41 5c                	pop    %r12
  8010ba:	5d                   	pop    %rbp
  8010bb:	c3                   	retq   

00000000008010bc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010bc:	55                   	push   %rbp
  8010bd:	48 89 e5             	mov    %rsp,%rbp
  8010c0:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010c7:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010ce:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010d5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010dc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010e3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010ea:	84 c0                	test   %al,%al
  8010ec:	74 20                	je     80110e <printfmt+0x52>
  8010ee:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010f2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010f6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010fa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010fe:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801102:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801106:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80110a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80110e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801115:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80111c:	00 00 00 
  80111f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801126:	00 00 00 
  801129:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80112d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801134:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80113b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801142:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801149:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801150:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801157:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80115e:	48 89 c7             	mov    %rax,%rdi
  801161:	48 b8 a4 0b 80 00 00 	movabs $0x800ba4,%rax
  801168:	00 00 00 
  80116b:	ff d0                	callq  *%rax
	va_end(ap);
}
  80116d:	c9                   	leaveq 
  80116e:	c3                   	retq   

000000000080116f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80116f:	55                   	push   %rbp
  801170:	48 89 e5             	mov    %rsp,%rbp
  801173:	48 83 ec 10          	sub    $0x10,%rsp
  801177:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80117a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80117e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801182:	8b 40 10             	mov    0x10(%rax),%eax
  801185:	8d 50 01             	lea    0x1(%rax),%edx
  801188:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80118c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80118f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801193:	48 8b 10             	mov    (%rax),%rdx
  801196:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80119a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80119e:	48 39 c2             	cmp    %rax,%rdx
  8011a1:	73 17                	jae    8011ba <sprintputch+0x4b>
		*b->buf++ = ch;
  8011a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a7:	48 8b 00             	mov    (%rax),%rax
  8011aa:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8011ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8011b2:	48 89 0a             	mov    %rcx,(%rdx)
  8011b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011b8:	88 10                	mov    %dl,(%rax)
}
  8011ba:	c9                   	leaveq 
  8011bb:	c3                   	retq   

00000000008011bc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011bc:	55                   	push   %rbp
  8011bd:	48 89 e5             	mov    %rsp,%rbp
  8011c0:	48 83 ec 50          	sub    $0x50,%rsp
  8011c4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011c8:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011cb:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011cf:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011d3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011d7:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011db:	48 8b 0a             	mov    (%rdx),%rcx
  8011de:	48 89 08             	mov    %rcx,(%rax)
  8011e1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011e5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011e9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011ed:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011f1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011f5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8011f9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8011fc:	48 98                	cltq   
  8011fe:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801202:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801206:	48 01 d0             	add    %rdx,%rax
  801209:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80120d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801214:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801219:	74 06                	je     801221 <vsnprintf+0x65>
  80121b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80121f:	7f 07                	jg     801228 <vsnprintf+0x6c>
		return -E_INVAL;
  801221:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801226:	eb 2f                	jmp    801257 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801228:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80122c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801230:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801234:	48 89 c6             	mov    %rax,%rsi
  801237:	48 bf 6f 11 80 00 00 	movabs $0x80116f,%rdi
  80123e:	00 00 00 
  801241:	48 b8 a4 0b 80 00 00 	movabs $0x800ba4,%rax
  801248:	00 00 00 
  80124b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80124d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801251:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801254:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801257:	c9                   	leaveq 
  801258:	c3                   	retq   

0000000000801259 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801259:	55                   	push   %rbp
  80125a:	48 89 e5             	mov    %rsp,%rbp
  80125d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801264:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80126b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801271:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801278:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80127f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801286:	84 c0                	test   %al,%al
  801288:	74 20                	je     8012aa <snprintf+0x51>
  80128a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80128e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801292:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801296:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80129a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80129e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8012a2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8012a6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8012aa:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8012b1:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012b8:	00 00 00 
  8012bb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012c2:	00 00 00 
  8012c5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012c9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012d0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012d7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012de:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012e5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012ec:	48 8b 0a             	mov    (%rdx),%rcx
  8012ef:	48 89 08             	mov    %rcx,(%rax)
  8012f2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012f6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012fa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012fe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801302:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801309:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801310:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801316:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80131d:	48 89 c7             	mov    %rax,%rdi
  801320:	48 b8 bc 11 80 00 00 	movabs $0x8011bc,%rax
  801327:	00 00 00 
  80132a:	ff d0                	callq  *%rax
  80132c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801332:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801338:	c9                   	leaveq 
  801339:	c3                   	retq   

000000000080133a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80133a:	55                   	push   %rbp
  80133b:	48 89 e5             	mov    %rsp,%rbp
  80133e:	48 83 ec 18          	sub    $0x18,%rsp
  801342:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801346:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80134d:	eb 09                	jmp    801358 <strlen+0x1e>
		n++;
  80134f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801353:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801358:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135c:	0f b6 00             	movzbl (%rax),%eax
  80135f:	84 c0                	test   %al,%al
  801361:	75 ec                	jne    80134f <strlen+0x15>
		n++;
	return n;
  801363:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801366:	c9                   	leaveq 
  801367:	c3                   	retq   

0000000000801368 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801368:	55                   	push   %rbp
  801369:	48 89 e5             	mov    %rsp,%rbp
  80136c:	48 83 ec 20          	sub    $0x20,%rsp
  801370:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801374:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80137f:	eb 0e                	jmp    80138f <strnlen+0x27>
		n++;
  801381:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801385:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80138a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80138f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801394:	74 0b                	je     8013a1 <strnlen+0x39>
  801396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139a:	0f b6 00             	movzbl (%rax),%eax
  80139d:	84 c0                	test   %al,%al
  80139f:	75 e0                	jne    801381 <strnlen+0x19>
		n++;
	return n;
  8013a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013a4:	c9                   	leaveq 
  8013a5:	c3                   	retq   

00000000008013a6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013a6:	55                   	push   %rbp
  8013a7:	48 89 e5             	mov    %rsp,%rbp
  8013aa:	48 83 ec 20          	sub    $0x20,%rsp
  8013ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8013b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013be:	90                   	nop
  8013bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013c7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013cb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013cf:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013d3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013d7:	0f b6 12             	movzbl (%rdx),%edx
  8013da:	88 10                	mov    %dl,(%rax)
  8013dc:	0f b6 00             	movzbl (%rax),%eax
  8013df:	84 c0                	test   %al,%al
  8013e1:	75 dc                	jne    8013bf <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013e7:	c9                   	leaveq 
  8013e8:	c3                   	retq   

00000000008013e9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013e9:	55                   	push   %rbp
  8013ea:	48 89 e5             	mov    %rsp,%rbp
  8013ed:	48 83 ec 20          	sub    $0x20,%rsp
  8013f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8013f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fd:	48 89 c7             	mov    %rax,%rdi
  801400:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  801407:	00 00 00 
  80140a:	ff d0                	callq  *%rax
  80140c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80140f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801412:	48 63 d0             	movslq %eax,%rdx
  801415:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801419:	48 01 c2             	add    %rax,%rdx
  80141c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801420:	48 89 c6             	mov    %rax,%rsi
  801423:	48 89 d7             	mov    %rdx,%rdi
  801426:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  80142d:	00 00 00 
  801430:	ff d0                	callq  *%rax
	return dst;
  801432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801436:	c9                   	leaveq 
  801437:	c3                   	retq   

0000000000801438 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801438:	55                   	push   %rbp
  801439:	48 89 e5             	mov    %rsp,%rbp
  80143c:	48 83 ec 28          	sub    $0x28,%rsp
  801440:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801444:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801448:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80144c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801450:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801454:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80145b:	00 
  80145c:	eb 2a                	jmp    801488 <strncpy+0x50>
		*dst++ = *src;
  80145e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801462:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801466:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80146a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80146e:	0f b6 12             	movzbl (%rdx),%edx
  801471:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801473:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801477:	0f b6 00             	movzbl (%rax),%eax
  80147a:	84 c0                	test   %al,%al
  80147c:	74 05                	je     801483 <strncpy+0x4b>
			src++;
  80147e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801483:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801488:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801490:	72 cc                	jb     80145e <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801492:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801496:	c9                   	leaveq 
  801497:	c3                   	retq   

0000000000801498 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801498:	55                   	push   %rbp
  801499:	48 89 e5             	mov    %rsp,%rbp
  80149c:	48 83 ec 28          	sub    $0x28,%rsp
  8014a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8014ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8014b4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014b9:	74 3d                	je     8014f8 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014bb:	eb 1d                	jmp    8014da <strlcpy+0x42>
			*dst++ = *src++;
  8014bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014cd:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014d1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014d5:	0f b6 12             	movzbl (%rdx),%edx
  8014d8:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014da:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014e4:	74 0b                	je     8014f1 <strlcpy+0x59>
  8014e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ea:	0f b6 00             	movzbl (%rax),%eax
  8014ed:	84 c0                	test   %al,%al
  8014ef:	75 cc                	jne    8014bd <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8014f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8014f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801500:	48 29 c2             	sub    %rax,%rdx
  801503:	48 89 d0             	mov    %rdx,%rax
}
  801506:	c9                   	leaveq 
  801507:	c3                   	retq   

0000000000801508 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801508:	55                   	push   %rbp
  801509:	48 89 e5             	mov    %rsp,%rbp
  80150c:	48 83 ec 10          	sub    $0x10,%rsp
  801510:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801514:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801518:	eb 0a                	jmp    801524 <strcmp+0x1c>
		p++, q++;
  80151a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80151f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801524:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801528:	0f b6 00             	movzbl (%rax),%eax
  80152b:	84 c0                	test   %al,%al
  80152d:	74 12                	je     801541 <strcmp+0x39>
  80152f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801533:	0f b6 10             	movzbl (%rax),%edx
  801536:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80153a:	0f b6 00             	movzbl (%rax),%eax
  80153d:	38 c2                	cmp    %al,%dl
  80153f:	74 d9                	je     80151a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801545:	0f b6 00             	movzbl (%rax),%eax
  801548:	0f b6 d0             	movzbl %al,%edx
  80154b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154f:	0f b6 00             	movzbl (%rax),%eax
  801552:	0f b6 c0             	movzbl %al,%eax
  801555:	29 c2                	sub    %eax,%edx
  801557:	89 d0                	mov    %edx,%eax
}
  801559:	c9                   	leaveq 
  80155a:	c3                   	retq   

000000000080155b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80155b:	55                   	push   %rbp
  80155c:	48 89 e5             	mov    %rsp,%rbp
  80155f:	48 83 ec 18          	sub    $0x18,%rsp
  801563:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801567:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80156b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80156f:	eb 0f                	jmp    801580 <strncmp+0x25>
		n--, p++, q++;
  801571:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801576:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80157b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801580:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801585:	74 1d                	je     8015a4 <strncmp+0x49>
  801587:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158b:	0f b6 00             	movzbl (%rax),%eax
  80158e:	84 c0                	test   %al,%al
  801590:	74 12                	je     8015a4 <strncmp+0x49>
  801592:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801596:	0f b6 10             	movzbl (%rax),%edx
  801599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159d:	0f b6 00             	movzbl (%rax),%eax
  8015a0:	38 c2                	cmp    %al,%dl
  8015a2:	74 cd                	je     801571 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8015a4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a9:	75 07                	jne    8015b2 <strncmp+0x57>
		return 0;
  8015ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b0:	eb 18                	jmp    8015ca <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b6:	0f b6 00             	movzbl (%rax),%eax
  8015b9:	0f b6 d0             	movzbl %al,%edx
  8015bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	0f b6 c0             	movzbl %al,%eax
  8015c6:	29 c2                	sub    %eax,%edx
  8015c8:	89 d0                	mov    %edx,%eax
}
  8015ca:	c9                   	leaveq 
  8015cb:	c3                   	retq   

00000000008015cc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015cc:	55                   	push   %rbp
  8015cd:	48 89 e5             	mov    %rsp,%rbp
  8015d0:	48 83 ec 0c          	sub    $0xc,%rsp
  8015d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015d8:	89 f0                	mov    %esi,%eax
  8015da:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015dd:	eb 17                	jmp    8015f6 <strchr+0x2a>
		if (*s == c)
  8015df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e3:	0f b6 00             	movzbl (%rax),%eax
  8015e6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015e9:	75 06                	jne    8015f1 <strchr+0x25>
			return (char *) s;
  8015eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ef:	eb 15                	jmp    801606 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015fa:	0f b6 00             	movzbl (%rax),%eax
  8015fd:	84 c0                	test   %al,%al
  8015ff:	75 de                	jne    8015df <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801601:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801606:	c9                   	leaveq 
  801607:	c3                   	retq   

0000000000801608 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801608:	55                   	push   %rbp
  801609:	48 89 e5             	mov    %rsp,%rbp
  80160c:	48 83 ec 0c          	sub    $0xc,%rsp
  801610:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801614:	89 f0                	mov    %esi,%eax
  801616:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801619:	eb 13                	jmp    80162e <strfind+0x26>
		if (*s == c)
  80161b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801625:	75 02                	jne    801629 <strfind+0x21>
			break;
  801627:	eb 10                	jmp    801639 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801629:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80162e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801632:	0f b6 00             	movzbl (%rax),%eax
  801635:	84 c0                	test   %al,%al
  801637:	75 e2                	jne    80161b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801639:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80163d:	c9                   	leaveq 
  80163e:	c3                   	retq   

000000000080163f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80163f:	55                   	push   %rbp
  801640:	48 89 e5             	mov    %rsp,%rbp
  801643:	48 83 ec 18          	sub    $0x18,%rsp
  801647:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80164b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80164e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801652:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801657:	75 06                	jne    80165f <memset+0x20>
		return v;
  801659:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165d:	eb 69                	jmp    8016c8 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80165f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801663:	83 e0 03             	and    $0x3,%eax
  801666:	48 85 c0             	test   %rax,%rax
  801669:	75 48                	jne    8016b3 <memset+0x74>
  80166b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166f:	83 e0 03             	and    $0x3,%eax
  801672:	48 85 c0             	test   %rax,%rax
  801675:	75 3c                	jne    8016b3 <memset+0x74>
		c &= 0xFF;
  801677:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80167e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801681:	c1 e0 18             	shl    $0x18,%eax
  801684:	89 c2                	mov    %eax,%edx
  801686:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801689:	c1 e0 10             	shl    $0x10,%eax
  80168c:	09 c2                	or     %eax,%edx
  80168e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801691:	c1 e0 08             	shl    $0x8,%eax
  801694:	09 d0                	or     %edx,%eax
  801696:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80169d:	48 c1 e8 02          	shr    $0x2,%rax
  8016a1:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8016a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016a8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016ab:	48 89 d7             	mov    %rdx,%rdi
  8016ae:	fc                   	cld    
  8016af:	f3 ab                	rep stos %eax,%es:(%rdi)
  8016b1:	eb 11                	jmp    8016c4 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8016b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016ba:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016be:	48 89 d7             	mov    %rdx,%rdi
  8016c1:	fc                   	cld    
  8016c2:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8016c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016c8:	c9                   	leaveq 
  8016c9:	c3                   	retq   

00000000008016ca <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016ca:	55                   	push   %rbp
  8016cb:	48 89 e5             	mov    %rsp,%rbp
  8016ce:	48 83 ec 28          	sub    $0x28,%rsp
  8016d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016da:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016f6:	0f 83 88 00 00 00    	jae    801784 <memmove+0xba>
  8016fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801700:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801704:	48 01 d0             	add    %rdx,%rax
  801707:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80170b:	76 77                	jbe    801784 <memmove+0xba>
		s += n;
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801719:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80171d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801721:	83 e0 03             	and    $0x3,%eax
  801724:	48 85 c0             	test   %rax,%rax
  801727:	75 3b                	jne    801764 <memmove+0x9a>
  801729:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172d:	83 e0 03             	and    $0x3,%eax
  801730:	48 85 c0             	test   %rax,%rax
  801733:	75 2f                	jne    801764 <memmove+0x9a>
  801735:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801739:	83 e0 03             	and    $0x3,%eax
  80173c:	48 85 c0             	test   %rax,%rax
  80173f:	75 23                	jne    801764 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801745:	48 83 e8 04          	sub    $0x4,%rax
  801749:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80174d:	48 83 ea 04          	sub    $0x4,%rdx
  801751:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801755:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801759:	48 89 c7             	mov    %rax,%rdi
  80175c:	48 89 d6             	mov    %rdx,%rsi
  80175f:	fd                   	std    
  801760:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801762:	eb 1d                	jmp    801781 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801764:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801768:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80176c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801770:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801774:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801778:	48 89 d7             	mov    %rdx,%rdi
  80177b:	48 89 c1             	mov    %rax,%rcx
  80177e:	fd                   	std    
  80177f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801781:	fc                   	cld    
  801782:	eb 57                	jmp    8017db <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801784:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801788:	83 e0 03             	and    $0x3,%eax
  80178b:	48 85 c0             	test   %rax,%rax
  80178e:	75 36                	jne    8017c6 <memmove+0xfc>
  801790:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801794:	83 e0 03             	and    $0x3,%eax
  801797:	48 85 c0             	test   %rax,%rax
  80179a:	75 2a                	jne    8017c6 <memmove+0xfc>
  80179c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a0:	83 e0 03             	and    $0x3,%eax
  8017a3:	48 85 c0             	test   %rax,%rax
  8017a6:	75 1e                	jne    8017c6 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8017a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017ac:	48 c1 e8 02          	shr    $0x2,%rax
  8017b0:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8017b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017bb:	48 89 c7             	mov    %rax,%rdi
  8017be:	48 89 d6             	mov    %rdx,%rsi
  8017c1:	fc                   	cld    
  8017c2:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017c4:	eb 15                	jmp    8017db <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017ca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017ce:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017d2:	48 89 c7             	mov    %rax,%rdi
  8017d5:	48 89 d6             	mov    %rdx,%rsi
  8017d8:	fc                   	cld    
  8017d9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017df:	c9                   	leaveq 
  8017e0:	c3                   	retq   

00000000008017e1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017e1:	55                   	push   %rbp
  8017e2:	48 89 e5             	mov    %rsp,%rbp
  8017e5:	48 83 ec 18          	sub    $0x18,%rsp
  8017e9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017ed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8017f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801801:	48 89 ce             	mov    %rcx,%rsi
  801804:	48 89 c7             	mov    %rax,%rdi
  801807:	48 b8 ca 16 80 00 00 	movabs $0x8016ca,%rax
  80180e:	00 00 00 
  801811:	ff d0                	callq  *%rax
}
  801813:	c9                   	leaveq 
  801814:	c3                   	retq   

0000000000801815 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801815:	55                   	push   %rbp
  801816:	48 89 e5             	mov    %rsp,%rbp
  801819:	48 83 ec 28          	sub    $0x28,%rsp
  80181d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801821:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801825:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801829:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80182d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801831:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801835:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801839:	eb 36                	jmp    801871 <memcmp+0x5c>
		if (*s1 != *s2)
  80183b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183f:	0f b6 10             	movzbl (%rax),%edx
  801842:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801846:	0f b6 00             	movzbl (%rax),%eax
  801849:	38 c2                	cmp    %al,%dl
  80184b:	74 1a                	je     801867 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80184d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801851:	0f b6 00             	movzbl (%rax),%eax
  801854:	0f b6 d0             	movzbl %al,%edx
  801857:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80185b:	0f b6 00             	movzbl (%rax),%eax
  80185e:	0f b6 c0             	movzbl %al,%eax
  801861:	29 c2                	sub    %eax,%edx
  801863:	89 d0                	mov    %edx,%eax
  801865:	eb 20                	jmp    801887 <memcmp+0x72>
		s1++, s2++;
  801867:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80186c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801879:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80187d:	48 85 c0             	test   %rax,%rax
  801880:	75 b9                	jne    80183b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801882:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801887:	c9                   	leaveq 
  801888:	c3                   	retq   

0000000000801889 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801889:	55                   	push   %rbp
  80188a:	48 89 e5             	mov    %rsp,%rbp
  80188d:	48 83 ec 28          	sub    $0x28,%rsp
  801891:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801895:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801898:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80189c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a4:	48 01 d0             	add    %rdx,%rax
  8018a7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8018ab:	eb 15                	jmp    8018c2 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b1:	0f b6 10             	movzbl (%rax),%edx
  8018b4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018b7:	38 c2                	cmp    %al,%dl
  8018b9:	75 02                	jne    8018bd <memfind+0x34>
			break;
  8018bb:	eb 0f                	jmp    8018cc <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018bd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c6:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018ca:	72 e1                	jb     8018ad <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8018cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018d0:	c9                   	leaveq 
  8018d1:	c3                   	retq   

00000000008018d2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018d2:	55                   	push   %rbp
  8018d3:	48 89 e5             	mov    %rsp,%rbp
  8018d6:	48 83 ec 34          	sub    $0x34,%rsp
  8018da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018e2:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018ec:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8018f3:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f4:	eb 05                	jmp    8018fb <strtol+0x29>
		s++;
  8018f6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ff:	0f b6 00             	movzbl (%rax),%eax
  801902:	3c 20                	cmp    $0x20,%al
  801904:	74 f0                	je     8018f6 <strtol+0x24>
  801906:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190a:	0f b6 00             	movzbl (%rax),%eax
  80190d:	3c 09                	cmp    $0x9,%al
  80190f:	74 e5                	je     8018f6 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801911:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801915:	0f b6 00             	movzbl (%rax),%eax
  801918:	3c 2b                	cmp    $0x2b,%al
  80191a:	75 07                	jne    801923 <strtol+0x51>
		s++;
  80191c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801921:	eb 17                	jmp    80193a <strtol+0x68>
	else if (*s == '-')
  801923:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801927:	0f b6 00             	movzbl (%rax),%eax
  80192a:	3c 2d                	cmp    $0x2d,%al
  80192c:	75 0c                	jne    80193a <strtol+0x68>
		s++, neg = 1;
  80192e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801933:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80193a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80193e:	74 06                	je     801946 <strtol+0x74>
  801940:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801944:	75 28                	jne    80196e <strtol+0x9c>
  801946:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194a:	0f b6 00             	movzbl (%rax),%eax
  80194d:	3c 30                	cmp    $0x30,%al
  80194f:	75 1d                	jne    80196e <strtol+0x9c>
  801951:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801955:	48 83 c0 01          	add    $0x1,%rax
  801959:	0f b6 00             	movzbl (%rax),%eax
  80195c:	3c 78                	cmp    $0x78,%al
  80195e:	75 0e                	jne    80196e <strtol+0x9c>
		s += 2, base = 16;
  801960:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801965:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80196c:	eb 2c                	jmp    80199a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80196e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801972:	75 19                	jne    80198d <strtol+0xbb>
  801974:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801978:	0f b6 00             	movzbl (%rax),%eax
  80197b:	3c 30                	cmp    $0x30,%al
  80197d:	75 0e                	jne    80198d <strtol+0xbb>
		s++, base = 8;
  80197f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801984:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80198b:	eb 0d                	jmp    80199a <strtol+0xc8>
	else if (base == 0)
  80198d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801991:	75 07                	jne    80199a <strtol+0xc8>
		base = 10;
  801993:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80199a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199e:	0f b6 00             	movzbl (%rax),%eax
  8019a1:	3c 2f                	cmp    $0x2f,%al
  8019a3:	7e 1d                	jle    8019c2 <strtol+0xf0>
  8019a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a9:	0f b6 00             	movzbl (%rax),%eax
  8019ac:	3c 39                	cmp    $0x39,%al
  8019ae:	7f 12                	jg     8019c2 <strtol+0xf0>
			dig = *s - '0';
  8019b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b4:	0f b6 00             	movzbl (%rax),%eax
  8019b7:	0f be c0             	movsbl %al,%eax
  8019ba:	83 e8 30             	sub    $0x30,%eax
  8019bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019c0:	eb 4e                	jmp    801a10 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c6:	0f b6 00             	movzbl (%rax),%eax
  8019c9:	3c 60                	cmp    $0x60,%al
  8019cb:	7e 1d                	jle    8019ea <strtol+0x118>
  8019cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d1:	0f b6 00             	movzbl (%rax),%eax
  8019d4:	3c 7a                	cmp    $0x7a,%al
  8019d6:	7f 12                	jg     8019ea <strtol+0x118>
			dig = *s - 'a' + 10;
  8019d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019dc:	0f b6 00             	movzbl (%rax),%eax
  8019df:	0f be c0             	movsbl %al,%eax
  8019e2:	83 e8 57             	sub    $0x57,%eax
  8019e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019e8:	eb 26                	jmp    801a10 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ee:	0f b6 00             	movzbl (%rax),%eax
  8019f1:	3c 40                	cmp    $0x40,%al
  8019f3:	7e 48                	jle    801a3d <strtol+0x16b>
  8019f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f9:	0f b6 00             	movzbl (%rax),%eax
  8019fc:	3c 5a                	cmp    $0x5a,%al
  8019fe:	7f 3d                	jg     801a3d <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a04:	0f b6 00             	movzbl (%rax),%eax
  801a07:	0f be c0             	movsbl %al,%eax
  801a0a:	83 e8 37             	sub    $0x37,%eax
  801a0d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a13:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a16:	7c 02                	jl     801a1a <strtol+0x148>
			break;
  801a18:	eb 23                	jmp    801a3d <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a1a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a1f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a22:	48 98                	cltq   
  801a24:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a29:	48 89 c2             	mov    %rax,%rdx
  801a2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a2f:	48 98                	cltq   
  801a31:	48 01 d0             	add    %rdx,%rax
  801a34:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a38:	e9 5d ff ff ff       	jmpq   80199a <strtol+0xc8>

	if (endptr)
  801a3d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a42:	74 0b                	je     801a4f <strtol+0x17d>
		*endptr = (char *) s;
  801a44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a48:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a4c:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a53:	74 09                	je     801a5e <strtol+0x18c>
  801a55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a59:	48 f7 d8             	neg    %rax
  801a5c:	eb 04                	jmp    801a62 <strtol+0x190>
  801a5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a62:	c9                   	leaveq 
  801a63:	c3                   	retq   

0000000000801a64 <strstr>:

char * strstr(const char *in, const char *str)
{
  801a64:	55                   	push   %rbp
  801a65:	48 89 e5             	mov    %rsp,%rbp
  801a68:	48 83 ec 30          	sub    $0x30,%rsp
  801a6c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a70:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  801a74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a78:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a7c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a80:	0f b6 00             	movzbl (%rax),%eax
  801a83:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  801a86:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a8a:	75 06                	jne    801a92 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801a8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a90:	eb 6b                	jmp    801afd <strstr+0x99>

    len = strlen(str);
  801a92:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a96:	48 89 c7             	mov    %rax,%rdi
  801a99:	48 b8 3a 13 80 00 00 	movabs $0x80133a,%rax
  801aa0:	00 00 00 
  801aa3:	ff d0                	callq  *%rax
  801aa5:	48 98                	cltq   
  801aa7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801aab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aaf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ab3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801ab7:	0f b6 00             	movzbl (%rax),%eax
  801aba:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801abd:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ac1:	75 07                	jne    801aca <strstr+0x66>
                return (char *) 0;
  801ac3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac8:	eb 33                	jmp    801afd <strstr+0x99>
        } while (sc != c);
  801aca:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801ace:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ad1:	75 d8                	jne    801aab <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801ad3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801adb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801adf:	48 89 ce             	mov    %rcx,%rsi
  801ae2:	48 89 c7             	mov    %rax,%rdi
  801ae5:	48 b8 5b 15 80 00 00 	movabs $0x80155b,%rax
  801aec:	00 00 00 
  801aef:	ff d0                	callq  *%rax
  801af1:	85 c0                	test   %eax,%eax
  801af3:	75 b6                	jne    801aab <strstr+0x47>

    return (char *) (in - 1);
  801af5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af9:	48 83 e8 01          	sub    $0x1,%rax
}
  801afd:	c9                   	leaveq 
  801afe:	c3                   	retq   

0000000000801aff <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801aff:	55                   	push   %rbp
  801b00:	48 89 e5             	mov    %rsp,%rbp
  801b03:	48 83 ec 10          	sub    $0x10,%rsp
  801b07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;
	
	if (_pgfault_handler == 0) {
  801b0b:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801b12:	00 00 00 
  801b15:	48 8b 00             	mov    (%rax),%rax
  801b18:	48 85 c0             	test   %rax,%rax
  801b1b:	0f 85 b2 00 00 00    	jne    801bd3 <set_pgfault_handler+0xd4>
		// First time through!
		// LAB 4: Your code here.
		
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP-PGSIZE), PTE_P|PTE_U|PTE_W) != 0)
  801b21:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801b28:	00 00 00 
  801b2b:	48 8b 00             	mov    (%rax),%rax
  801b2e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801b34:	ba 07 00 00 00       	mov    $0x7,%edx
  801b39:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801b3e:	89 c7                	mov    %eax,%edi
  801b40:	48 b8 0b 03 80 00 00 	movabs $0x80030b,%rax
  801b47:	00 00 00 
  801b4a:	ff d0                	callq  *%rax
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	74 2a                	je     801b7a <set_pgfault_handler+0x7b>
		  panic("\nproblem in page allocation lib/pgfault.c\n");
  801b50:	48 ba 28 20 80 00 00 	movabs $0x802028,%rdx
  801b57:	00 00 00 
  801b5a:	be 22 00 00 00       	mov    $0x22,%esi
  801b5f:	48 bf 53 20 80 00 00 	movabs $0x802053,%rdi
  801b66:	00 00 00 
  801b69:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6e:	48 b9 b8 05 80 00 00 	movabs $0x8005b8,%rcx
  801b75:	00 00 00 
  801b78:	ff d1                	callq  *%rcx
		
	         if(sys_env_set_pgfault_upcall(thisenv->env_id, (void *)_pgfault_upcall) != 0)
  801b7a:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801b81:	00 00 00 
  801b84:	48 8b 00             	mov    (%rax),%rax
  801b87:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801b8d:	48 be 2e 05 80 00 00 	movabs $0x80052e,%rsi
  801b94:	00 00 00 
  801b97:	89 c7                	mov    %eax,%edi
  801b99:	48 b8 4b 04 80 00 00 	movabs $0x80044b,%rax
  801ba0:	00 00 00 
  801ba3:	ff d0                	callq  *%rax
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	74 2a                	je     801bd3 <set_pgfault_handler+0xd4>
		   panic("set_pgfault_handler implemented but problems lib/pgfault.c");
  801ba9:	48 ba 68 20 80 00 00 	movabs $0x802068,%rdx
  801bb0:	00 00 00 
  801bb3:	be 25 00 00 00       	mov    $0x25,%esi
  801bb8:	48 bf 53 20 80 00 00 	movabs $0x802053,%rdi
  801bbf:	00 00 00 
  801bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc7:	48 b9 b8 05 80 00 00 	movabs $0x8005b8,%rcx
  801bce:	00 00 00 
  801bd1:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801bd3:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801bda:	00 00 00 
  801bdd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801be1:	48 89 10             	mov    %rdx,(%rax)
}
  801be4:	c9                   	leaveq 
  801be5:	c3                   	retq   
