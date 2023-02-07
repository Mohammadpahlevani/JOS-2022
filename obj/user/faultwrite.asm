
obj/user/faultwrite:     file format elf64-x86-64


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
  80003c:	e8 1e 00 00 00       	callq  80005f <libmain>
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
	*(unsigned*)0 = 0;
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  80005d:	c9                   	leaveq 
  80005e:	c3                   	retq   

000000000080005f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005f:	55                   	push   %rbp
  800060:	48 89 e5             	mov    %rsp,%rbp
  800063:	48 83 ec 20          	sub    $0x20,%rsp
  800067:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80006a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80006e:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800075:	00 00 00 
  800078:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  80007f:	48 b8 74 02 80 00 00 	movabs $0x800274,%rax
  800086:	00 00 00 
  800089:	ff d0                	callq  *%rax
  80008b:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  80008e:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  800095:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800098:	48 63 d0             	movslq %eax,%rdx
  80009b:	48 89 d0             	mov    %rdx,%rax
  80009e:	48 c1 e0 03          	shl    $0x3,%rax
  8000a2:	48 01 d0             	add    %rdx,%rax
  8000a5:	48 c1 e0 05          	shl    $0x5,%rax
  8000a9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000b0:	00 00 00 
  8000b3:	48 01 c2             	add    %rax,%rdx
  8000b6:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000bd:	00 00 00 
  8000c0:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000c7:	7e 14                	jle    8000dd <libmain+0x7e>
		binaryname = argv[0];
  8000c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000cd:	48 8b 10             	mov    (%rax),%rdx
  8000d0:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000d7:	00 00 00 
  8000da:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000dd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e4:	48 89 d6             	mov    %rdx,%rsi
  8000e7:	89 c7                	mov    %eax,%edi
  8000e9:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f0:	00 00 00 
  8000f3:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  8000f5:	48 b8 03 01 80 00 00 	movabs $0x800103,%rax
  8000fc:	00 00 00 
  8000ff:	ff d0                	callq  *%rax
}
  800101:	c9                   	leaveq 
  800102:	c3                   	retq   

0000000000800103 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800103:	55                   	push   %rbp
  800104:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800107:	bf 00 00 00 00       	mov    $0x0,%edi
  80010c:	48 b8 30 02 80 00 00 	movabs $0x800230,%rax
  800113:	00 00 00 
  800116:	ff d0                	callq  *%rax
}
  800118:	5d                   	pop    %rbp
  800119:	c3                   	retq   

000000000080011a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80011a:	55                   	push   %rbp
  80011b:	48 89 e5             	mov    %rsp,%rbp
  80011e:	53                   	push   %rbx
  80011f:	48 83 ec 48          	sub    $0x48,%rsp
  800123:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800126:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800129:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80012d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800131:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800135:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800139:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80013c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800140:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800144:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800148:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80014c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800150:	4c 89 c3             	mov    %r8,%rbx
  800153:	cd 30                	int    $0x30
  800155:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800159:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80015d:	74 3e                	je     80019d <syscall+0x83>
  80015f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800164:	7e 37                	jle    80019d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800166:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80016a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80016d:	49 89 d0             	mov    %rdx,%r8
  800170:	89 c1                	mov    %eax,%ecx
  800172:	48 ba 6a 1a 80 00 00 	movabs $0x801a6a,%rdx
  800179:	00 00 00 
  80017c:	be 23 00 00 00       	mov    $0x23,%esi
  800181:	48 bf 87 1a 80 00 00 	movabs $0x801a87,%rdi
  800188:	00 00 00 
  80018b:	b8 00 00 00 00       	mov    $0x0,%eax
  800190:	49 b9 13 05 80 00 00 	movabs $0x800513,%r9
  800197:	00 00 00 
  80019a:	41 ff d1             	callq  *%r9

	return ret;
  80019d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001a1:	48 83 c4 48          	add    $0x48,%rsp
  8001a5:	5b                   	pop    %rbx
  8001a6:	5d                   	pop    %rbp
  8001a7:	c3                   	retq   

00000000008001a8 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001a8:	55                   	push   %rbp
  8001a9:	48 89 e5             	mov    %rsp,%rbp
  8001ac:	48 83 ec 20          	sub    $0x20,%rsp
  8001b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001bc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001c7:	00 
  8001c8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ce:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d4:	48 89 d1             	mov    %rdx,%rcx
  8001d7:	48 89 c2             	mov    %rax,%rdx
  8001da:	be 00 00 00 00       	mov    $0x0,%esi
  8001df:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e4:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8001eb:	00 00 00 
  8001ee:	ff d0                	callq  *%rax
}
  8001f0:	c9                   	leaveq 
  8001f1:	c3                   	retq   

00000000008001f2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8001f2:	55                   	push   %rbp
  8001f3:	48 89 e5             	mov    %rsp,%rbp
  8001f6:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001fa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800201:	00 
  800202:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800208:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80020e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800213:	ba 00 00 00 00       	mov    $0x0,%edx
  800218:	be 00 00 00 00       	mov    $0x0,%esi
  80021d:	bf 01 00 00 00       	mov    $0x1,%edi
  800222:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800229:	00 00 00 
  80022c:	ff d0                	callq  *%rax
}
  80022e:	c9                   	leaveq 
  80022f:	c3                   	retq   

0000000000800230 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800230:	55                   	push   %rbp
  800231:	48 89 e5             	mov    %rsp,%rbp
  800234:	48 83 ec 10          	sub    $0x10,%rsp
  800238:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80023b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80023e:	48 98                	cltq   
  800240:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800247:	00 
  800248:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80024e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800254:	b9 00 00 00 00       	mov    $0x0,%ecx
  800259:	48 89 c2             	mov    %rax,%rdx
  80025c:	be 01 00 00 00       	mov    $0x1,%esi
  800261:	bf 03 00 00 00       	mov    $0x3,%edi
  800266:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  80026d:	00 00 00 
  800270:	ff d0                	callq  *%rax
}
  800272:	c9                   	leaveq 
  800273:	c3                   	retq   

0000000000800274 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800274:	55                   	push   %rbp
  800275:	48 89 e5             	mov    %rsp,%rbp
  800278:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80027c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800283:	00 
  800284:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80028a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800290:	b9 00 00 00 00       	mov    $0x0,%ecx
  800295:	ba 00 00 00 00       	mov    $0x0,%edx
  80029a:	be 00 00 00 00       	mov    $0x0,%esi
  80029f:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a4:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8002ab:	00 00 00 
  8002ae:	ff d0                	callq  *%rax
}
  8002b0:	c9                   	leaveq 
  8002b1:	c3                   	retq   

00000000008002b2 <sys_yield>:

void
sys_yield(void)
{
  8002b2:	55                   	push   %rbp
  8002b3:	48 89 e5             	mov    %rsp,%rbp
  8002b6:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002ba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002c1:	00 
  8002c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d8:	be 00 00 00 00       	mov    $0x0,%esi
  8002dd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002e2:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	callq  *%rax
}
  8002ee:	c9                   	leaveq 
  8002ef:	c3                   	retq   

00000000008002f0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002f0:	55                   	push   %rbp
  8002f1:	48 89 e5             	mov    %rsp,%rbp
  8002f4:	48 83 ec 20          	sub    $0x20,%rsp
  8002f8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002fb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8002ff:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800302:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800305:	48 63 c8             	movslq %eax,%rcx
  800308:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80030c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80030f:	48 98                	cltq   
  800311:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800318:	00 
  800319:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80031f:	49 89 c8             	mov    %rcx,%r8
  800322:	48 89 d1             	mov    %rdx,%rcx
  800325:	48 89 c2             	mov    %rax,%rdx
  800328:	be 01 00 00 00       	mov    $0x1,%esi
  80032d:	bf 04 00 00 00       	mov    $0x4,%edi
  800332:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800339:	00 00 00 
  80033c:	ff d0                	callq  *%rax
}
  80033e:	c9                   	leaveq 
  80033f:	c3                   	retq   

0000000000800340 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800340:	55                   	push   %rbp
  800341:	48 89 e5             	mov    %rsp,%rbp
  800344:	48 83 ec 30          	sub    $0x30,%rsp
  800348:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80034b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80034f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800352:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800356:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80035a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80035d:	48 63 c8             	movslq %eax,%rcx
  800360:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800364:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800367:	48 63 f0             	movslq %eax,%rsi
  80036a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80036e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800371:	48 98                	cltq   
  800373:	48 89 0c 24          	mov    %rcx,(%rsp)
  800377:	49 89 f9             	mov    %rdi,%r9
  80037a:	49 89 f0             	mov    %rsi,%r8
  80037d:	48 89 d1             	mov    %rdx,%rcx
  800380:	48 89 c2             	mov    %rax,%rdx
  800383:	be 01 00 00 00       	mov    $0x1,%esi
  800388:	bf 05 00 00 00       	mov    $0x5,%edi
  80038d:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800394:	00 00 00 
  800397:	ff d0                	callq  *%rax
}
  800399:	c9                   	leaveq 
  80039a:	c3                   	retq   

000000000080039b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80039b:	55                   	push   %rbp
  80039c:	48 89 e5             	mov    %rsp,%rbp
  80039f:	48 83 ec 20          	sub    $0x20,%rsp
  8003a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003b1:	48 98                	cltq   
  8003b3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003ba:	00 
  8003bb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003c7:	48 89 d1             	mov    %rdx,%rcx
  8003ca:	48 89 c2             	mov    %rax,%rdx
  8003cd:	be 01 00 00 00       	mov    $0x1,%esi
  8003d2:	bf 06 00 00 00       	mov    $0x6,%edi
  8003d7:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8003de:	00 00 00 
  8003e1:	ff d0                	callq  *%rax
}
  8003e3:	c9                   	leaveq 
  8003e4:	c3                   	retq   

00000000008003e5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003e5:	55                   	push   %rbp
  8003e6:	48 89 e5             	mov    %rsp,%rbp
  8003e9:	48 83 ec 10          	sub    $0x10,%rsp
  8003ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003f0:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8003f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003f6:	48 63 d0             	movslq %eax,%rdx
  8003f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003fc:	48 98                	cltq   
  8003fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800405:	00 
  800406:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80040c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800412:	48 89 d1             	mov    %rdx,%rcx
  800415:	48 89 c2             	mov    %rax,%rdx
  800418:	be 01 00 00 00       	mov    $0x1,%esi
  80041d:	bf 08 00 00 00       	mov    $0x8,%edi
  800422:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800429:	00 00 00 
  80042c:	ff d0                	callq  *%rax
}
  80042e:	c9                   	leaveq 
  80042f:	c3                   	retq   

0000000000800430 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800430:	55                   	push   %rbp
  800431:	48 89 e5             	mov    %rsp,%rbp
  800434:	48 83 ec 20          	sub    $0x20,%rsp
  800438:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80043b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80043f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800443:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800446:	48 98                	cltq   
  800448:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80044f:	00 
  800450:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800456:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80045c:	48 89 d1             	mov    %rdx,%rcx
  80045f:	48 89 c2             	mov    %rax,%rdx
  800462:	be 01 00 00 00       	mov    $0x1,%esi
  800467:	bf 09 00 00 00       	mov    $0x9,%edi
  80046c:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  800473:	00 00 00 
  800476:	ff d0                	callq  *%rax
}
  800478:	c9                   	leaveq 
  800479:	c3                   	retq   

000000000080047a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80047a:	55                   	push   %rbp
  80047b:	48 89 e5             	mov    %rsp,%rbp
  80047e:	48 83 ec 20          	sub    $0x20,%rsp
  800482:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800485:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800489:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80048d:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800490:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800493:	48 63 f0             	movslq %eax,%rsi
  800496:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80049a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80049d:	48 98                	cltq   
  80049f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004aa:	00 
  8004ab:	49 89 f1             	mov    %rsi,%r9
  8004ae:	49 89 c8             	mov    %rcx,%r8
  8004b1:	48 89 d1             	mov    %rdx,%rcx
  8004b4:	48 89 c2             	mov    %rax,%rdx
  8004b7:	be 00 00 00 00       	mov    $0x0,%esi
  8004bc:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004c1:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  8004c8:	00 00 00 
  8004cb:	ff d0                	callq  *%rax
}
  8004cd:	c9                   	leaveq 
  8004ce:	c3                   	retq   

00000000008004cf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004cf:	55                   	push   %rbp
  8004d0:	48 89 e5             	mov    %rsp,%rbp
  8004d3:	48 83 ec 10          	sub    $0x10,%rsp
  8004d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004df:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004e6:	00 
  8004e7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004ed:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004f8:	48 89 c2             	mov    %rax,%rdx
  8004fb:	be 01 00 00 00       	mov    $0x1,%esi
  800500:	bf 0c 00 00 00       	mov    $0xc,%edi
  800505:	48 b8 1a 01 80 00 00 	movabs $0x80011a,%rax
  80050c:	00 00 00 
  80050f:	ff d0                	callq  *%rax
}
  800511:	c9                   	leaveq 
  800512:	c3                   	retq   

0000000000800513 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800513:	55                   	push   %rbp
  800514:	48 89 e5             	mov    %rsp,%rbp
  800517:	53                   	push   %rbx
  800518:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80051f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800526:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80052c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800533:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80053a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800541:	84 c0                	test   %al,%al
  800543:	74 23                	je     800568 <_panic+0x55>
  800545:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80054c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800550:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800554:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800558:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80055c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800560:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800564:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800568:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80056f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800576:	00 00 00 
  800579:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800580:	00 00 00 
  800583:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800587:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80058e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800595:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80059c:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8005a3:	00 00 00 
  8005a6:	48 8b 18             	mov    (%rax),%rbx
  8005a9:	48 b8 74 02 80 00 00 	movabs $0x800274,%rax
  8005b0:	00 00 00 
  8005b3:	ff d0                	callq  *%rax
  8005b5:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005bb:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005c2:	41 89 c8             	mov    %ecx,%r8d
  8005c5:	48 89 d1             	mov    %rdx,%rcx
  8005c8:	48 89 da             	mov    %rbx,%rdx
  8005cb:	89 c6                	mov    %eax,%esi
  8005cd:	48 bf 98 1a 80 00 00 	movabs $0x801a98,%rdi
  8005d4:	00 00 00 
  8005d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8005dc:	49 b9 4c 07 80 00 00 	movabs $0x80074c,%r9
  8005e3:	00 00 00 
  8005e6:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e9:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005f0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005f7:	48 89 d6             	mov    %rdx,%rsi
  8005fa:	48 89 c7             	mov    %rax,%rdi
  8005fd:	48 b8 a0 06 80 00 00 	movabs $0x8006a0,%rax
  800604:	00 00 00 
  800607:	ff d0                	callq  *%rax
	cprintf("\n");
  800609:	48 bf bb 1a 80 00 00 	movabs $0x801abb,%rdi
  800610:	00 00 00 
  800613:	b8 00 00 00 00       	mov    $0x0,%eax
  800618:	48 ba 4c 07 80 00 00 	movabs $0x80074c,%rdx
  80061f:	00 00 00 
  800622:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800624:	cc                   	int3   
  800625:	eb fd                	jmp    800624 <_panic+0x111>

0000000000800627 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800627:	55                   	push   %rbp
  800628:	48 89 e5             	mov    %rsp,%rbp
  80062b:	48 83 ec 10          	sub    $0x10,%rsp
  80062f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800632:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800636:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80063a:	8b 00                	mov    (%rax),%eax
  80063c:	8d 48 01             	lea    0x1(%rax),%ecx
  80063f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800643:	89 0a                	mov    %ecx,(%rdx)
  800645:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800648:	89 d1                	mov    %edx,%ecx
  80064a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80064e:	48 98                	cltq   
  800650:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800658:	8b 00                	mov    (%rax),%eax
  80065a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80065f:	75 2c                	jne    80068d <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800661:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800665:	8b 00                	mov    (%rax),%eax
  800667:	48 98                	cltq   
  800669:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80066d:	48 83 c2 08          	add    $0x8,%rdx
  800671:	48 89 c6             	mov    %rax,%rsi
  800674:	48 89 d7             	mov    %rdx,%rdi
  800677:	48 b8 a8 01 80 00 00 	movabs $0x8001a8,%rax
  80067e:	00 00 00 
  800681:	ff d0                	callq  *%rax
		b->idx = 0;
  800683:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800687:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80068d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800691:	8b 40 04             	mov    0x4(%rax),%eax
  800694:	8d 50 01             	lea    0x1(%rax),%edx
  800697:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069b:	89 50 04             	mov    %edx,0x4(%rax)
}
  80069e:	c9                   	leaveq 
  80069f:	c3                   	retq   

00000000008006a0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006a0:	55                   	push   %rbp
  8006a1:	48 89 e5             	mov    %rsp,%rbp
  8006a4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006ab:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006b2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8006b9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006c0:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006c7:	48 8b 0a             	mov    (%rdx),%rcx
  8006ca:	48 89 08             	mov    %rcx,(%rax)
  8006cd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8006dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006e4:	00 00 00 
	b.cnt = 0;
  8006e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006ee:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8006f1:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006f8:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006ff:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800706:	48 89 c6             	mov    %rax,%rsi
  800709:	48 bf 27 06 80 00 00 	movabs $0x800627,%rdi
  800710:	00 00 00 
  800713:	48 b8 ff 0a 80 00 00 	movabs $0x800aff,%rax
  80071a:	00 00 00 
  80071d:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80071f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800725:	48 98                	cltq   
  800727:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80072e:	48 83 c2 08          	add    $0x8,%rdx
  800732:	48 89 c6             	mov    %rax,%rsi
  800735:	48 89 d7             	mov    %rdx,%rdi
  800738:	48 b8 a8 01 80 00 00 	movabs $0x8001a8,%rax
  80073f:	00 00 00 
  800742:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800744:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80074a:	c9                   	leaveq 
  80074b:	c3                   	retq   

000000000080074c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80074c:	55                   	push   %rbp
  80074d:	48 89 e5             	mov    %rsp,%rbp
  800750:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800757:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80075e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800765:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80076c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800773:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80077a:	84 c0                	test   %al,%al
  80077c:	74 20                	je     80079e <cprintf+0x52>
  80077e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800782:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800786:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80078a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80078e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800792:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800796:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80079a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80079e:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8007a5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007ac:	00 00 00 
  8007af:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007b6:	00 00 00 
  8007b9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007bd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007c4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007cb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8007d2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007d9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007e0:	48 8b 0a             	mov    (%rdx),%rcx
  8007e3:	48 89 08             	mov    %rcx,(%rax)
  8007e6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007ea:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007ee:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007f2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8007f6:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007fd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800804:	48 89 d6             	mov    %rdx,%rsi
  800807:	48 89 c7             	mov    %rax,%rdi
  80080a:	48 b8 a0 06 80 00 00 	movabs $0x8006a0,%rax
  800811:	00 00 00 
  800814:	ff d0                	callq  *%rax
  800816:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80081c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800822:	c9                   	leaveq 
  800823:	c3                   	retq   

0000000000800824 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800824:	55                   	push   %rbp
  800825:	48 89 e5             	mov    %rsp,%rbp
  800828:	53                   	push   %rbx
  800829:	48 83 ec 38          	sub    $0x38,%rsp
  80082d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800831:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800835:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800839:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80083c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800840:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800844:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800847:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80084b:	77 3b                	ja     800888 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80084d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800850:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800854:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80085b:	ba 00 00 00 00       	mov    $0x0,%edx
  800860:	48 f7 f3             	div    %rbx
  800863:	48 89 c2             	mov    %rax,%rdx
  800866:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800869:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80086c:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800874:	41 89 f9             	mov    %edi,%r9d
  800877:	48 89 c7             	mov    %rax,%rdi
  80087a:	48 b8 24 08 80 00 00 	movabs $0x800824,%rax
  800881:	00 00 00 
  800884:	ff d0                	callq  *%rax
  800886:	eb 1e                	jmp    8008a6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800888:	eb 12                	jmp    80089c <printnum+0x78>
			putch(padc, putdat);
  80088a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80088e:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800895:	48 89 ce             	mov    %rcx,%rsi
  800898:	89 d7                	mov    %edx,%edi
  80089a:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80089c:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008a0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008a4:	7f e4                	jg     80088a <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008a6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b2:	48 f7 f1             	div    %rcx
  8008b5:	48 89 d0             	mov    %rdx,%rax
  8008b8:	48 ba b0 1b 80 00 00 	movabs $0x801bb0,%rdx
  8008bf:	00 00 00 
  8008c2:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008c6:	0f be d0             	movsbl %al,%edx
  8008c9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d1:	48 89 ce             	mov    %rcx,%rsi
  8008d4:	89 d7                	mov    %edx,%edi
  8008d6:	ff d0                	callq  *%rax
}
  8008d8:	48 83 c4 38          	add    $0x38,%rsp
  8008dc:	5b                   	pop    %rbx
  8008dd:	5d                   	pop    %rbp
  8008de:	c3                   	retq   

00000000008008df <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008df:	55                   	push   %rbp
  8008e0:	48 89 e5             	mov    %rsp,%rbp
  8008e3:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008ee:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f2:	7e 52                	jle    800946 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f8:	8b 00                	mov    (%rax),%eax
  8008fa:	83 f8 30             	cmp    $0x30,%eax
  8008fd:	73 24                	jae    800923 <getuint+0x44>
  8008ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800903:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090b:	8b 00                	mov    (%rax),%eax
  80090d:	89 c0                	mov    %eax,%eax
  80090f:	48 01 d0             	add    %rdx,%rax
  800912:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800916:	8b 12                	mov    (%rdx),%edx
  800918:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091f:	89 0a                	mov    %ecx,(%rdx)
  800921:	eb 17                	jmp    80093a <getuint+0x5b>
  800923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800927:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80092b:	48 89 d0             	mov    %rdx,%rax
  80092e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800932:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800936:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80093a:	48 8b 00             	mov    (%rax),%rax
  80093d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800941:	e9 a3 00 00 00       	jmpq   8009e9 <getuint+0x10a>
	else if (lflag)
  800946:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80094a:	74 4f                	je     80099b <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80094c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800950:	8b 00                	mov    (%rax),%eax
  800952:	83 f8 30             	cmp    $0x30,%eax
  800955:	73 24                	jae    80097b <getuint+0x9c>
  800957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80095f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800963:	8b 00                	mov    (%rax),%eax
  800965:	89 c0                	mov    %eax,%eax
  800967:	48 01 d0             	add    %rdx,%rax
  80096a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096e:	8b 12                	mov    (%rdx),%edx
  800970:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800973:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800977:	89 0a                	mov    %ecx,(%rdx)
  800979:	eb 17                	jmp    800992 <getuint+0xb3>
  80097b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800983:	48 89 d0             	mov    %rdx,%rax
  800986:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80098a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800992:	48 8b 00             	mov    (%rax),%rax
  800995:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800999:	eb 4e                	jmp    8009e9 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80099b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099f:	8b 00                	mov    (%rax),%eax
  8009a1:	83 f8 30             	cmp    $0x30,%eax
  8009a4:	73 24                	jae    8009ca <getuint+0xeb>
  8009a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009aa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b2:	8b 00                	mov    (%rax),%eax
  8009b4:	89 c0                	mov    %eax,%eax
  8009b6:	48 01 d0             	add    %rdx,%rax
  8009b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bd:	8b 12                	mov    (%rdx),%edx
  8009bf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c6:	89 0a                	mov    %ecx,(%rdx)
  8009c8:	eb 17                	jmp    8009e1 <getuint+0x102>
  8009ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ce:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d2:	48 89 d0             	mov    %rdx,%rax
  8009d5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009dd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e1:	8b 00                	mov    (%rax),%eax
  8009e3:	89 c0                	mov    %eax,%eax
  8009e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009ed:	c9                   	leaveq 
  8009ee:	c3                   	retq   

00000000008009ef <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ef:	55                   	push   %rbp
  8009f0:	48 89 e5             	mov    %rsp,%rbp
  8009f3:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009fb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009fe:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a02:	7e 52                	jle    800a56 <getint+0x67>
		x=va_arg(*ap, long long);
  800a04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a08:	8b 00                	mov    (%rax),%eax
  800a0a:	83 f8 30             	cmp    $0x30,%eax
  800a0d:	73 24                	jae    800a33 <getint+0x44>
  800a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a13:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1b:	8b 00                	mov    (%rax),%eax
  800a1d:	89 c0                	mov    %eax,%eax
  800a1f:	48 01 d0             	add    %rdx,%rax
  800a22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a26:	8b 12                	mov    (%rdx),%edx
  800a28:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2f:	89 0a                	mov    %ecx,(%rdx)
  800a31:	eb 17                	jmp    800a4a <getint+0x5b>
  800a33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a37:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a3b:	48 89 d0             	mov    %rdx,%rax
  800a3e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a42:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a46:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a4a:	48 8b 00             	mov    (%rax),%rax
  800a4d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a51:	e9 a3 00 00 00       	jmpq   800af9 <getint+0x10a>
	else if (lflag)
  800a56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a5a:	74 4f                	je     800aab <getint+0xbc>
		x=va_arg(*ap, long);
  800a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a60:	8b 00                	mov    (%rax),%eax
  800a62:	83 f8 30             	cmp    $0x30,%eax
  800a65:	73 24                	jae    800a8b <getint+0x9c>
  800a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a73:	8b 00                	mov    (%rax),%eax
  800a75:	89 c0                	mov    %eax,%eax
  800a77:	48 01 d0             	add    %rdx,%rax
  800a7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7e:	8b 12                	mov    (%rdx),%edx
  800a80:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a83:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a87:	89 0a                	mov    %ecx,(%rdx)
  800a89:	eb 17                	jmp    800aa2 <getint+0xb3>
  800a8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a93:	48 89 d0             	mov    %rdx,%rax
  800a96:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a9a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa2:	48 8b 00             	mov    (%rax),%rax
  800aa5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aa9:	eb 4e                	jmp    800af9 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800aab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aaf:	8b 00                	mov    (%rax),%eax
  800ab1:	83 f8 30             	cmp    $0x30,%eax
  800ab4:	73 24                	jae    800ada <getint+0xeb>
  800ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aba:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800abe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac2:	8b 00                	mov    (%rax),%eax
  800ac4:	89 c0                	mov    %eax,%eax
  800ac6:	48 01 d0             	add    %rdx,%rax
  800ac9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acd:	8b 12                	mov    (%rdx),%edx
  800acf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad6:	89 0a                	mov    %ecx,(%rdx)
  800ad8:	eb 17                	jmp    800af1 <getint+0x102>
  800ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ade:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ae2:	48 89 d0             	mov    %rdx,%rax
  800ae5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ae9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aed:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800af1:	8b 00                	mov    (%rax),%eax
  800af3:	48 98                	cltq   
  800af5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800af9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800afd:	c9                   	leaveq 
  800afe:	c3                   	retq   

0000000000800aff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aff:	55                   	push   %rbp
  800b00:	48 89 e5             	mov    %rsp,%rbp
  800b03:	41 54                	push   %r12
  800b05:	53                   	push   %rbx
  800b06:	48 83 ec 60          	sub    $0x60,%rsp
  800b0a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b0e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b12:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b16:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b1a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b1e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b22:	48 8b 0a             	mov    (%rdx),%rcx
  800b25:	48 89 08             	mov    %rcx,(%rax)
  800b28:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b2c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b30:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b34:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b38:	eb 17                	jmp    800b51 <vprintfmt+0x52>
			if (ch == '\0')
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	0f 84 cc 04 00 00    	je     80100e <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800b42:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4a:	48 89 d6             	mov    %rdx,%rsi
  800b4d:	89 df                	mov    %ebx,%edi
  800b4f:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b51:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b55:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b59:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b5d:	0f b6 00             	movzbl (%rax),%eax
  800b60:	0f b6 d8             	movzbl %al,%ebx
  800b63:	83 fb 25             	cmp    $0x25,%ebx
  800b66:	75 d2                	jne    800b3a <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800b68:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b6c:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b73:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b7a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b81:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b88:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b8c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b90:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b94:	0f b6 00             	movzbl (%rax),%eax
  800b97:	0f b6 d8             	movzbl %al,%ebx
  800b9a:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b9d:	83 f8 55             	cmp    $0x55,%eax
  800ba0:	0f 87 34 04 00 00    	ja     800fda <vprintfmt+0x4db>
  800ba6:	89 c0                	mov    %eax,%eax
  800ba8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800baf:	00 
  800bb0:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  800bb7:	00 00 00 
  800bba:	48 01 d0             	add    %rdx,%rax
  800bbd:	48 8b 00             	mov    (%rax),%rax
  800bc0:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bc2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bc6:	eb c0                	jmp    800b88 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bc8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bcc:	eb ba                	jmp    800b88 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800bd5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bd8:	89 d0                	mov    %edx,%eax
  800bda:	c1 e0 02             	shl    $0x2,%eax
  800bdd:	01 d0                	add    %edx,%eax
  800bdf:	01 c0                	add    %eax,%eax
  800be1:	01 d8                	add    %ebx,%eax
  800be3:	83 e8 30             	sub    $0x30,%eax
  800be6:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800be9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bed:	0f b6 00             	movzbl (%rax),%eax
  800bf0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bf3:	83 fb 2f             	cmp    $0x2f,%ebx
  800bf6:	7e 0c                	jle    800c04 <vprintfmt+0x105>
  800bf8:	83 fb 39             	cmp    $0x39,%ebx
  800bfb:	7f 07                	jg     800c04 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bfd:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c02:	eb d1                	jmp    800bd5 <vprintfmt+0xd6>
			goto process_precision;
  800c04:	eb 58                	jmp    800c5e <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c06:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c09:	83 f8 30             	cmp    $0x30,%eax
  800c0c:	73 17                	jae    800c25 <vprintfmt+0x126>
  800c0e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c12:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c15:	89 c0                	mov    %eax,%eax
  800c17:	48 01 d0             	add    %rdx,%rax
  800c1a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c1d:	83 c2 08             	add    $0x8,%edx
  800c20:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c23:	eb 0f                	jmp    800c34 <vprintfmt+0x135>
  800c25:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c29:	48 89 d0             	mov    %rdx,%rax
  800c2c:	48 83 c2 08          	add    $0x8,%rdx
  800c30:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c34:	8b 00                	mov    (%rax),%eax
  800c36:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c39:	eb 23                	jmp    800c5e <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c3b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c3f:	79 0c                	jns    800c4d <vprintfmt+0x14e>
				width = 0;
  800c41:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c48:	e9 3b ff ff ff       	jmpq   800b88 <vprintfmt+0x89>
  800c4d:	e9 36 ff ff ff       	jmpq   800b88 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c52:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c59:	e9 2a ff ff ff       	jmpq   800b88 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c62:	79 12                	jns    800c76 <vprintfmt+0x177>
				width = precision, precision = -1;
  800c64:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c67:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c6a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c71:	e9 12 ff ff ff       	jmpq   800b88 <vprintfmt+0x89>
  800c76:	e9 0d ff ff ff       	jmpq   800b88 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c7b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c7f:	e9 04 ff ff ff       	jmpq   800b88 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800c84:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c87:	83 f8 30             	cmp    $0x30,%eax
  800c8a:	73 17                	jae    800ca3 <vprintfmt+0x1a4>
  800c8c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c90:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c93:	89 c0                	mov    %eax,%eax
  800c95:	48 01 d0             	add    %rdx,%rax
  800c98:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c9b:	83 c2 08             	add    $0x8,%edx
  800c9e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ca1:	eb 0f                	jmp    800cb2 <vprintfmt+0x1b3>
  800ca3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ca7:	48 89 d0             	mov    %rdx,%rax
  800caa:	48 83 c2 08          	add    $0x8,%rdx
  800cae:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb2:	8b 10                	mov    (%rax),%edx
  800cb4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cb8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cbc:	48 89 ce             	mov    %rcx,%rsi
  800cbf:	89 d7                	mov    %edx,%edi
  800cc1:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800cc3:	e9 40 03 00 00       	jmpq   801008 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800cc8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ccb:	83 f8 30             	cmp    $0x30,%eax
  800cce:	73 17                	jae    800ce7 <vprintfmt+0x1e8>
  800cd0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cd4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cd7:	89 c0                	mov    %eax,%eax
  800cd9:	48 01 d0             	add    %rdx,%rax
  800cdc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cdf:	83 c2 08             	add    $0x8,%edx
  800ce2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ce5:	eb 0f                	jmp    800cf6 <vprintfmt+0x1f7>
  800ce7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ceb:	48 89 d0             	mov    %rdx,%rax
  800cee:	48 83 c2 08          	add    $0x8,%rdx
  800cf2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cf6:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	79 02                	jns    800cfe <vprintfmt+0x1ff>
				err = -err;
  800cfc:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cfe:	83 fb 09             	cmp    $0x9,%ebx
  800d01:	7f 16                	jg     800d19 <vprintfmt+0x21a>
  800d03:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800d0a:	00 00 00 
  800d0d:	48 63 d3             	movslq %ebx,%rdx
  800d10:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d14:	4d 85 e4             	test   %r12,%r12
  800d17:	75 2e                	jne    800d47 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d19:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d21:	89 d9                	mov    %ebx,%ecx
  800d23:	48 ba c1 1b 80 00 00 	movabs $0x801bc1,%rdx
  800d2a:	00 00 00 
  800d2d:	48 89 c7             	mov    %rax,%rdi
  800d30:	b8 00 00 00 00       	mov    $0x0,%eax
  800d35:	49 b8 17 10 80 00 00 	movabs $0x801017,%r8
  800d3c:	00 00 00 
  800d3f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d42:	e9 c1 02 00 00       	jmpq   801008 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d47:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d4f:	4c 89 e1             	mov    %r12,%rcx
  800d52:	48 ba ca 1b 80 00 00 	movabs $0x801bca,%rdx
  800d59:	00 00 00 
  800d5c:	48 89 c7             	mov    %rax,%rdi
  800d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d64:	49 b8 17 10 80 00 00 	movabs $0x801017,%r8
  800d6b:	00 00 00 
  800d6e:	41 ff d0             	callq  *%r8
			break;
  800d71:	e9 92 02 00 00       	jmpq   801008 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800d76:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d79:	83 f8 30             	cmp    $0x30,%eax
  800d7c:	73 17                	jae    800d95 <vprintfmt+0x296>
  800d7e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d85:	89 c0                	mov    %eax,%eax
  800d87:	48 01 d0             	add    %rdx,%rax
  800d8a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d8d:	83 c2 08             	add    $0x8,%edx
  800d90:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d93:	eb 0f                	jmp    800da4 <vprintfmt+0x2a5>
  800d95:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d99:	48 89 d0             	mov    %rdx,%rax
  800d9c:	48 83 c2 08          	add    $0x8,%rdx
  800da0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800da4:	4c 8b 20             	mov    (%rax),%r12
  800da7:	4d 85 e4             	test   %r12,%r12
  800daa:	75 0a                	jne    800db6 <vprintfmt+0x2b7>
				p = "(null)";
  800dac:	49 bc cd 1b 80 00 00 	movabs $0x801bcd,%r12
  800db3:	00 00 00 
			if (width > 0 && padc != '-')
  800db6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dba:	7e 3f                	jle    800dfb <vprintfmt+0x2fc>
  800dbc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dc0:	74 39                	je     800dfb <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dc5:	48 98                	cltq   
  800dc7:	48 89 c6             	mov    %rax,%rsi
  800dca:	4c 89 e7             	mov    %r12,%rdi
  800dcd:	48 b8 c3 12 80 00 00 	movabs $0x8012c3,%rax
  800dd4:	00 00 00 
  800dd7:	ff d0                	callq  *%rax
  800dd9:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ddc:	eb 17                	jmp    800df5 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800dde:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800de2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800de6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dea:	48 89 ce             	mov    %rcx,%rsi
  800ded:	89 d7                	mov    %edx,%edi
  800def:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800df5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800df9:	7f e3                	jg     800dde <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dfb:	eb 37                	jmp    800e34 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800dfd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e01:	74 1e                	je     800e21 <vprintfmt+0x322>
  800e03:	83 fb 1f             	cmp    $0x1f,%ebx
  800e06:	7e 05                	jle    800e0d <vprintfmt+0x30e>
  800e08:	83 fb 7e             	cmp    $0x7e,%ebx
  800e0b:	7e 14                	jle    800e21 <vprintfmt+0x322>
					putch('?', putdat);
  800e0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e15:	48 89 d6             	mov    %rdx,%rsi
  800e18:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e1d:	ff d0                	callq  *%rax
  800e1f:	eb 0f                	jmp    800e30 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e21:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e29:	48 89 d6             	mov    %rdx,%rsi
  800e2c:	89 df                	mov    %ebx,%edi
  800e2e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e30:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e34:	4c 89 e0             	mov    %r12,%rax
  800e37:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e3b:	0f b6 00             	movzbl (%rax),%eax
  800e3e:	0f be d8             	movsbl %al,%ebx
  800e41:	85 db                	test   %ebx,%ebx
  800e43:	74 10                	je     800e55 <vprintfmt+0x356>
  800e45:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e49:	78 b2                	js     800dfd <vprintfmt+0x2fe>
  800e4b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e4f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e53:	79 a8                	jns    800dfd <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e55:	eb 16                	jmp    800e6d <vprintfmt+0x36e>
				putch(' ', putdat);
  800e57:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e5b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e5f:	48 89 d6             	mov    %rdx,%rsi
  800e62:	bf 20 00 00 00       	mov    $0x20,%edi
  800e67:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e69:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e71:	7f e4                	jg     800e57 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800e73:	e9 90 01 00 00       	jmpq   801008 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800e78:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e7c:	be 03 00 00 00       	mov    $0x3,%esi
  800e81:	48 89 c7             	mov    %rax,%rdi
  800e84:	48 b8 ef 09 80 00 00 	movabs $0x8009ef,%rax
  800e8b:	00 00 00 
  800e8e:	ff d0                	callq  *%rax
  800e90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e98:	48 85 c0             	test   %rax,%rax
  800e9b:	79 1d                	jns    800eba <vprintfmt+0x3bb>
				putch('-', putdat);
  800e9d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea5:	48 89 d6             	mov    %rdx,%rsi
  800ea8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ead:	ff d0                	callq  *%rax
				num = -(long long) num;
  800eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb3:	48 f7 d8             	neg    %rax
  800eb6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800eba:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ec1:	e9 d5 00 00 00       	jmpq   800f9b <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800ec6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800eca:	be 03 00 00 00       	mov    $0x3,%esi
  800ecf:	48 89 c7             	mov    %rax,%rdi
  800ed2:	48 b8 df 08 80 00 00 	movabs $0x8008df,%rax
  800ed9:	00 00 00 
  800edc:	ff d0                	callq  *%rax
  800ede:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ee2:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ee9:	e9 ad 00 00 00       	jmpq   800f9b <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800eee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ef2:	be 03 00 00 00       	mov    $0x3,%esi
  800ef7:	48 89 c7             	mov    %rax,%rdi
  800efa:	48 b8 df 08 80 00 00 	movabs $0x8008df,%rax
  800f01:	00 00 00 
  800f04:	ff d0                	callq  *%rax
  800f06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f0a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f11:	e9 85 00 00 00       	jmpq   800f9b <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800f16:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f1a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1e:	48 89 d6             	mov    %rdx,%rsi
  800f21:	bf 30 00 00 00       	mov    $0x30,%edi
  800f26:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f28:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f30:	48 89 d6             	mov    %rdx,%rsi
  800f33:	bf 78 00 00 00       	mov    $0x78,%edi
  800f38:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f3a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f3d:	83 f8 30             	cmp    $0x30,%eax
  800f40:	73 17                	jae    800f59 <vprintfmt+0x45a>
  800f42:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f49:	89 c0                	mov    %eax,%eax
  800f4b:	48 01 d0             	add    %rdx,%rax
  800f4e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f51:	83 c2 08             	add    $0x8,%edx
  800f54:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f57:	eb 0f                	jmp    800f68 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f59:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f5d:	48 89 d0             	mov    %rdx,%rax
  800f60:	48 83 c2 08          	add    $0x8,%rdx
  800f64:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f68:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f6f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f76:	eb 23                	jmp    800f9b <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800f78:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f7c:	be 03 00 00 00       	mov    $0x3,%esi
  800f81:	48 89 c7             	mov    %rax,%rdi
  800f84:	48 b8 df 08 80 00 00 	movabs $0x8008df,%rax
  800f8b:	00 00 00 
  800f8e:	ff d0                	callq  *%rax
  800f90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f94:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800f9b:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fa0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fa3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fa6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800faa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb2:	45 89 c1             	mov    %r8d,%r9d
  800fb5:	41 89 f8             	mov    %edi,%r8d
  800fb8:	48 89 c7             	mov    %rax,%rdi
  800fbb:	48 b8 24 08 80 00 00 	movabs $0x800824,%rax
  800fc2:	00 00 00 
  800fc5:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800fc7:	eb 3f                	jmp    801008 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fc9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fcd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fd1:	48 89 d6             	mov    %rdx,%rsi
  800fd4:	89 df                	mov    %ebx,%edi
  800fd6:	ff d0                	callq  *%rax
			break;
  800fd8:	eb 2e                	jmp    801008 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fda:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe2:	48 89 d6             	mov    %rdx,%rsi
  800fe5:	bf 25 00 00 00       	mov    $0x25,%edi
  800fea:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800fec:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ff1:	eb 05                	jmp    800ff8 <vprintfmt+0x4f9>
  800ff3:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ff8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ffc:	48 83 e8 01          	sub    $0x1,%rax
  801000:	0f b6 00             	movzbl (%rax),%eax
  801003:	3c 25                	cmp    $0x25,%al
  801005:	75 ec                	jne    800ff3 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  801007:	90                   	nop
		}
	}
  801008:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801009:	e9 43 fb ff ff       	jmpq   800b51 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  80100e:	48 83 c4 60          	add    $0x60,%rsp
  801012:	5b                   	pop    %rbx
  801013:	41 5c                	pop    %r12
  801015:	5d                   	pop    %rbp
  801016:	c3                   	retq   

0000000000801017 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801017:	55                   	push   %rbp
  801018:	48 89 e5             	mov    %rsp,%rbp
  80101b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801022:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801029:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801030:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801037:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80103e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801045:	84 c0                	test   %al,%al
  801047:	74 20                	je     801069 <printfmt+0x52>
  801049:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80104d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801051:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801055:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801059:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80105d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801061:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801065:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801069:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801070:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801077:	00 00 00 
  80107a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801081:	00 00 00 
  801084:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801088:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80108f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801096:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  80109d:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010a4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010ab:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010b2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010b9:	48 89 c7             	mov    %rax,%rdi
  8010bc:	48 b8 ff 0a 80 00 00 	movabs $0x800aff,%rax
  8010c3:	00 00 00 
  8010c6:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010c8:	c9                   	leaveq 
  8010c9:	c3                   	retq   

00000000008010ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010ca:	55                   	push   %rbp
  8010cb:	48 89 e5             	mov    %rsp,%rbp
  8010ce:	48 83 ec 10          	sub    $0x10,%rsp
  8010d2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010dd:	8b 40 10             	mov    0x10(%rax),%eax
  8010e0:	8d 50 01             	lea    0x1(%rax),%edx
  8010e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8010ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ee:	48 8b 10             	mov    (%rax),%rdx
  8010f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010f9:	48 39 c2             	cmp    %rax,%rdx
  8010fc:	73 17                	jae    801115 <sprintputch+0x4b>
		*b->buf++ = ch;
  8010fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801102:	48 8b 00             	mov    (%rax),%rax
  801105:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801109:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80110d:	48 89 0a             	mov    %rcx,(%rdx)
  801110:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801113:	88 10                	mov    %dl,(%rax)
}
  801115:	c9                   	leaveq 
  801116:	c3                   	retq   

0000000000801117 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801117:	55                   	push   %rbp
  801118:	48 89 e5             	mov    %rsp,%rbp
  80111b:	48 83 ec 50          	sub    $0x50,%rsp
  80111f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801123:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801126:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80112a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80112e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801132:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801136:	48 8b 0a             	mov    (%rdx),%rcx
  801139:	48 89 08             	mov    %rcx,(%rax)
  80113c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801140:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801144:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801148:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80114c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801150:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801154:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801157:	48 98                	cltq   
  801159:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80115d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801161:	48 01 d0             	add    %rdx,%rax
  801164:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801168:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80116f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801174:	74 06                	je     80117c <vsnprintf+0x65>
  801176:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80117a:	7f 07                	jg     801183 <vsnprintf+0x6c>
		return -E_INVAL;
  80117c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801181:	eb 2f                	jmp    8011b2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801183:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801187:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80118b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80118f:	48 89 c6             	mov    %rax,%rsi
  801192:	48 bf ca 10 80 00 00 	movabs $0x8010ca,%rdi
  801199:	00 00 00 
  80119c:	48 b8 ff 0a 80 00 00 	movabs $0x800aff,%rax
  8011a3:	00 00 00 
  8011a6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011ac:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011af:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011b2:	c9                   	leaveq 
  8011b3:	c3                   	retq   

00000000008011b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011b4:	55                   	push   %rbp
  8011b5:	48 89 e5             	mov    %rsp,%rbp
  8011b8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011bf:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011c6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011cc:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011d3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011da:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011e1:	84 c0                	test   %al,%al
  8011e3:	74 20                	je     801205 <snprintf+0x51>
  8011e5:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011e9:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8011ed:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8011f1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8011f5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8011f9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8011fd:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801201:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801205:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80120c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801213:	00 00 00 
  801216:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80121d:	00 00 00 
  801220:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801224:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80122b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801232:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801239:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801240:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801247:	48 8b 0a             	mov    (%rdx),%rcx
  80124a:	48 89 08             	mov    %rcx,(%rax)
  80124d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801251:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801255:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801259:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80125d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801264:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80126b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801271:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801278:	48 89 c7             	mov    %rax,%rdi
  80127b:	48 b8 17 11 80 00 00 	movabs $0x801117,%rax
  801282:	00 00 00 
  801285:	ff d0                	callq  *%rax
  801287:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80128d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801293:	c9                   	leaveq 
  801294:	c3                   	retq   

0000000000801295 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801295:	55                   	push   %rbp
  801296:	48 89 e5             	mov    %rsp,%rbp
  801299:	48 83 ec 18          	sub    $0x18,%rsp
  80129d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012a8:	eb 09                	jmp    8012b3 <strlen+0x1e>
		n++;
  8012aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ae:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b7:	0f b6 00             	movzbl (%rax),%eax
  8012ba:	84 c0                	test   %al,%al
  8012bc:	75 ec                	jne    8012aa <strlen+0x15>
		n++;
	return n;
  8012be:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012c1:	c9                   	leaveq 
  8012c2:	c3                   	retq   

00000000008012c3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012c3:	55                   	push   %rbp
  8012c4:	48 89 e5             	mov    %rsp,%rbp
  8012c7:	48 83 ec 20          	sub    $0x20,%rsp
  8012cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012da:	eb 0e                	jmp    8012ea <strnlen+0x27>
		n++;
  8012dc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012e5:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8012ea:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8012ef:	74 0b                	je     8012fc <strnlen+0x39>
  8012f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f5:	0f b6 00             	movzbl (%rax),%eax
  8012f8:	84 c0                	test   %al,%al
  8012fa:	75 e0                	jne    8012dc <strnlen+0x19>
		n++;
	return n;
  8012fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012ff:	c9                   	leaveq 
  801300:	c3                   	retq   

0000000000801301 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801301:	55                   	push   %rbp
  801302:	48 89 e5             	mov    %rsp,%rbp
  801305:	48 83 ec 20          	sub    $0x20,%rsp
  801309:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80130d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801315:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801319:	90                   	nop
  80131a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801322:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801326:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80132a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80132e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801332:	0f b6 12             	movzbl (%rdx),%edx
  801335:	88 10                	mov    %dl,(%rax)
  801337:	0f b6 00             	movzbl (%rax),%eax
  80133a:	84 c0                	test   %al,%al
  80133c:	75 dc                	jne    80131a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80133e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801342:	c9                   	leaveq 
  801343:	c3                   	retq   

0000000000801344 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801344:	55                   	push   %rbp
  801345:	48 89 e5             	mov    %rsp,%rbp
  801348:	48 83 ec 20          	sub    $0x20,%rsp
  80134c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801350:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801354:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801358:	48 89 c7             	mov    %rax,%rdi
  80135b:	48 b8 95 12 80 00 00 	movabs $0x801295,%rax
  801362:	00 00 00 
  801365:	ff d0                	callq  *%rax
  801367:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80136a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80136d:	48 63 d0             	movslq %eax,%rdx
  801370:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801374:	48 01 c2             	add    %rax,%rdx
  801377:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80137b:	48 89 c6             	mov    %rax,%rsi
  80137e:	48 89 d7             	mov    %rdx,%rdi
  801381:	48 b8 01 13 80 00 00 	movabs $0x801301,%rax
  801388:	00 00 00 
  80138b:	ff d0                	callq  *%rax
	return dst;
  80138d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801391:	c9                   	leaveq 
  801392:	c3                   	retq   

0000000000801393 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801393:	55                   	push   %rbp
  801394:	48 89 e5             	mov    %rsp,%rbp
  801397:	48 83 ec 28          	sub    $0x28,%rsp
  80139b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013a3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ab:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013af:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013b6:	00 
  8013b7:	eb 2a                	jmp    8013e3 <strncpy+0x50>
		*dst++ = *src;
  8013b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013c1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013c9:	0f b6 12             	movzbl (%rdx),%edx
  8013cc:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013d2:	0f b6 00             	movzbl (%rax),%eax
  8013d5:	84 c0                	test   %al,%al
  8013d7:	74 05                	je     8013de <strncpy+0x4b>
			src++;
  8013d9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013de:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8013eb:	72 cc                	jb     8013b9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8013f1:	c9                   	leaveq 
  8013f2:	c3                   	retq   

00000000008013f3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013f3:	55                   	push   %rbp
  8013f4:	48 89 e5             	mov    %rsp,%rbp
  8013f7:	48 83 ec 28          	sub    $0x28,%rsp
  8013fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801403:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801407:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80140f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801414:	74 3d                	je     801453 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801416:	eb 1d                	jmp    801435 <strlcpy+0x42>
			*dst++ = *src++;
  801418:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80141c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801420:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801424:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801428:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80142c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801430:	0f b6 12             	movzbl (%rdx),%edx
  801433:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801435:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80143a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80143f:	74 0b                	je     80144c <strlcpy+0x59>
  801441:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801445:	0f b6 00             	movzbl (%rax),%eax
  801448:	84 c0                	test   %al,%al
  80144a:	75 cc                	jne    801418 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80144c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801450:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801453:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145b:	48 29 c2             	sub    %rax,%rdx
  80145e:	48 89 d0             	mov    %rdx,%rax
}
  801461:	c9                   	leaveq 
  801462:	c3                   	retq   

0000000000801463 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801463:	55                   	push   %rbp
  801464:	48 89 e5             	mov    %rsp,%rbp
  801467:	48 83 ec 10          	sub    $0x10,%rsp
  80146b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80146f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801473:	eb 0a                	jmp    80147f <strcmp+0x1c>
		p++, q++;
  801475:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80147a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80147f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801483:	0f b6 00             	movzbl (%rax),%eax
  801486:	84 c0                	test   %al,%al
  801488:	74 12                	je     80149c <strcmp+0x39>
  80148a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80148e:	0f b6 10             	movzbl (%rax),%edx
  801491:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801495:	0f b6 00             	movzbl (%rax),%eax
  801498:	38 c2                	cmp    %al,%dl
  80149a:	74 d9                	je     801475 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80149c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	0f b6 d0             	movzbl %al,%edx
  8014a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014aa:	0f b6 00             	movzbl (%rax),%eax
  8014ad:	0f b6 c0             	movzbl %al,%eax
  8014b0:	29 c2                	sub    %eax,%edx
  8014b2:	89 d0                	mov    %edx,%eax
}
  8014b4:	c9                   	leaveq 
  8014b5:	c3                   	retq   

00000000008014b6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014b6:	55                   	push   %rbp
  8014b7:	48 89 e5             	mov    %rsp,%rbp
  8014ba:	48 83 ec 18          	sub    $0x18,%rsp
  8014be:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014c6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014ca:	eb 0f                	jmp    8014db <strncmp+0x25>
		n--, p++, q++;
  8014cc:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014d6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014e0:	74 1d                	je     8014ff <strncmp+0x49>
  8014e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e6:	0f b6 00             	movzbl (%rax),%eax
  8014e9:	84 c0                	test   %al,%al
  8014eb:	74 12                	je     8014ff <strncmp+0x49>
  8014ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f1:	0f b6 10             	movzbl (%rax),%edx
  8014f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f8:	0f b6 00             	movzbl (%rax),%eax
  8014fb:	38 c2                	cmp    %al,%dl
  8014fd:	74 cd                	je     8014cc <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8014ff:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801504:	75 07                	jne    80150d <strncmp+0x57>
		return 0;
  801506:	b8 00 00 00 00       	mov    $0x0,%eax
  80150b:	eb 18                	jmp    801525 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80150d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801511:	0f b6 00             	movzbl (%rax),%eax
  801514:	0f b6 d0             	movzbl %al,%edx
  801517:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151b:	0f b6 00             	movzbl (%rax),%eax
  80151e:	0f b6 c0             	movzbl %al,%eax
  801521:	29 c2                	sub    %eax,%edx
  801523:	89 d0                	mov    %edx,%eax
}
  801525:	c9                   	leaveq 
  801526:	c3                   	retq   

0000000000801527 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801527:	55                   	push   %rbp
  801528:	48 89 e5             	mov    %rsp,%rbp
  80152b:	48 83 ec 0c          	sub    $0xc,%rsp
  80152f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801533:	89 f0                	mov    %esi,%eax
  801535:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801538:	eb 17                	jmp    801551 <strchr+0x2a>
		if (*s == c)
  80153a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80153e:	0f b6 00             	movzbl (%rax),%eax
  801541:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801544:	75 06                	jne    80154c <strchr+0x25>
			return (char *) s;
  801546:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80154a:	eb 15                	jmp    801561 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80154c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801551:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801555:	0f b6 00             	movzbl (%rax),%eax
  801558:	84 c0                	test   %al,%al
  80155a:	75 de                	jne    80153a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801561:	c9                   	leaveq 
  801562:	c3                   	retq   

0000000000801563 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801563:	55                   	push   %rbp
  801564:	48 89 e5             	mov    %rsp,%rbp
  801567:	48 83 ec 0c          	sub    $0xc,%rsp
  80156b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80156f:	89 f0                	mov    %esi,%eax
  801571:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801574:	eb 13                	jmp    801589 <strfind+0x26>
		if (*s == c)
  801576:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157a:	0f b6 00             	movzbl (%rax),%eax
  80157d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801580:	75 02                	jne    801584 <strfind+0x21>
			break;
  801582:	eb 10                	jmp    801594 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801584:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801589:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158d:	0f b6 00             	movzbl (%rax),%eax
  801590:	84 c0                	test   %al,%al
  801592:	75 e2                	jne    801576 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801598:	c9                   	leaveq 
  801599:	c3                   	retq   

000000000080159a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80159a:	55                   	push   %rbp
  80159b:	48 89 e5             	mov    %rsp,%rbp
  80159e:	48 83 ec 18          	sub    $0x18,%rsp
  8015a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015a6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015a9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015b2:	75 06                	jne    8015ba <memset+0x20>
		return v;
  8015b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b8:	eb 69                	jmp    801623 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015be:	83 e0 03             	and    $0x3,%eax
  8015c1:	48 85 c0             	test   %rax,%rax
  8015c4:	75 48                	jne    80160e <memset+0x74>
  8015c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ca:	83 e0 03             	and    $0x3,%eax
  8015cd:	48 85 c0             	test   %rax,%rax
  8015d0:	75 3c                	jne    80160e <memset+0x74>
		c &= 0xFF;
  8015d2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015dc:	c1 e0 18             	shl    $0x18,%eax
  8015df:	89 c2                	mov    %eax,%edx
  8015e1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015e4:	c1 e0 10             	shl    $0x10,%eax
  8015e7:	09 c2                	or     %eax,%edx
  8015e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015ec:	c1 e0 08             	shl    $0x8,%eax
  8015ef:	09 d0                	or     %edx,%eax
  8015f1:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8015f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f8:	48 c1 e8 02          	shr    $0x2,%rax
  8015fc:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801603:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801606:	48 89 d7             	mov    %rdx,%rdi
  801609:	fc                   	cld    
  80160a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80160c:	eb 11                	jmp    80161f <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80160e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801612:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801615:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801619:	48 89 d7             	mov    %rdx,%rdi
  80161c:	fc                   	cld    
  80161d:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80161f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801623:	c9                   	leaveq 
  801624:	c3                   	retq   

0000000000801625 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801625:	55                   	push   %rbp
  801626:	48 89 e5             	mov    %rsp,%rbp
  801629:	48 83 ec 28          	sub    $0x28,%rsp
  80162d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801631:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801635:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801639:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80163d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801641:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801645:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801649:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801651:	0f 83 88 00 00 00    	jae    8016df <memmove+0xba>
  801657:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80165f:	48 01 d0             	add    %rdx,%rax
  801662:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801666:	76 77                	jbe    8016df <memmove+0xba>
		s += n;
  801668:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801674:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167c:	83 e0 03             	and    $0x3,%eax
  80167f:	48 85 c0             	test   %rax,%rax
  801682:	75 3b                	jne    8016bf <memmove+0x9a>
  801684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801688:	83 e0 03             	and    $0x3,%eax
  80168b:	48 85 c0             	test   %rax,%rax
  80168e:	75 2f                	jne    8016bf <memmove+0x9a>
  801690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801694:	83 e0 03             	and    $0x3,%eax
  801697:	48 85 c0             	test   %rax,%rax
  80169a:	75 23                	jne    8016bf <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80169c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a0:	48 83 e8 04          	sub    $0x4,%rax
  8016a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016a8:	48 83 ea 04          	sub    $0x4,%rdx
  8016ac:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016b0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016b4:	48 89 c7             	mov    %rax,%rdi
  8016b7:	48 89 d6             	mov    %rdx,%rsi
  8016ba:	fd                   	std    
  8016bb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016bd:	eb 1d                	jmp    8016dc <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cb:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d3:	48 89 d7             	mov    %rdx,%rdi
  8016d6:	48 89 c1             	mov    %rax,%rcx
  8016d9:	fd                   	std    
  8016da:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016dc:	fc                   	cld    
  8016dd:	eb 57                	jmp    801736 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e3:	83 e0 03             	and    $0x3,%eax
  8016e6:	48 85 c0             	test   %rax,%rax
  8016e9:	75 36                	jne    801721 <memmove+0xfc>
  8016eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016ef:	83 e0 03             	and    $0x3,%eax
  8016f2:	48 85 c0             	test   %rax,%rax
  8016f5:	75 2a                	jne    801721 <memmove+0xfc>
  8016f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fb:	83 e0 03             	and    $0x3,%eax
  8016fe:	48 85 c0             	test   %rax,%rax
  801701:	75 1e                	jne    801721 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801703:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801707:	48 c1 e8 02          	shr    $0x2,%rax
  80170b:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80170e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801712:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801716:	48 89 c7             	mov    %rax,%rdi
  801719:	48 89 d6             	mov    %rdx,%rsi
  80171c:	fc                   	cld    
  80171d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80171f:	eb 15                	jmp    801736 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801721:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801725:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801729:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80172d:	48 89 c7             	mov    %rax,%rdi
  801730:	48 89 d6             	mov    %rdx,%rsi
  801733:	fc                   	cld    
  801734:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80173a:	c9                   	leaveq 
  80173b:	c3                   	retq   

000000000080173c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80173c:	55                   	push   %rbp
  80173d:	48 89 e5             	mov    %rsp,%rbp
  801740:	48 83 ec 18          	sub    $0x18,%rsp
  801744:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801748:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80174c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801750:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801754:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175c:	48 89 ce             	mov    %rcx,%rsi
  80175f:	48 89 c7             	mov    %rax,%rdi
  801762:	48 b8 25 16 80 00 00 	movabs $0x801625,%rax
  801769:	00 00 00 
  80176c:	ff d0                	callq  *%rax
}
  80176e:	c9                   	leaveq 
  80176f:	c3                   	retq   

0000000000801770 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801770:	55                   	push   %rbp
  801771:	48 89 e5             	mov    %rsp,%rbp
  801774:	48 83 ec 28          	sub    $0x28,%rsp
  801778:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80177c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801780:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801788:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80178c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801790:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801794:	eb 36                	jmp    8017cc <memcmp+0x5c>
		if (*s1 != *s2)
  801796:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80179a:	0f b6 10             	movzbl (%rax),%edx
  80179d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a1:	0f b6 00             	movzbl (%rax),%eax
  8017a4:	38 c2                	cmp    %al,%dl
  8017a6:	74 1a                	je     8017c2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ac:	0f b6 00             	movzbl (%rax),%eax
  8017af:	0f b6 d0             	movzbl %al,%edx
  8017b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b6:	0f b6 00             	movzbl (%rax),%eax
  8017b9:	0f b6 c0             	movzbl %al,%eax
  8017bc:	29 c2                	sub    %eax,%edx
  8017be:	89 d0                	mov    %edx,%eax
  8017c0:	eb 20                	jmp    8017e2 <memcmp+0x72>
		s1++, s2++;
  8017c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017c7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017d4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017d8:	48 85 c0             	test   %rax,%rax
  8017db:	75 b9                	jne    801796 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e2:	c9                   	leaveq 
  8017e3:	c3                   	retq   

00000000008017e4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017e4:	55                   	push   %rbp
  8017e5:	48 89 e5             	mov    %rsp,%rbp
  8017e8:	48 83 ec 28          	sub    $0x28,%rsp
  8017ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017f0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8017f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8017f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ff:	48 01 d0             	add    %rdx,%rax
  801802:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801806:	eb 15                	jmp    80181d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180c:	0f b6 10             	movzbl (%rax),%edx
  80180f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801812:	38 c2                	cmp    %al,%dl
  801814:	75 02                	jne    801818 <memfind+0x34>
			break;
  801816:	eb 0f                	jmp    801827 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801818:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80181d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801821:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801825:	72 e1                	jb     801808 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801827:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80182b:	c9                   	leaveq 
  80182c:	c3                   	retq   

000000000080182d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80182d:	55                   	push   %rbp
  80182e:	48 89 e5             	mov    %rsp,%rbp
  801831:	48 83 ec 34          	sub    $0x34,%rsp
  801835:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801839:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80183d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801840:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801847:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80184e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80184f:	eb 05                	jmp    801856 <strtol+0x29>
		s++;
  801851:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801856:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185a:	0f b6 00             	movzbl (%rax),%eax
  80185d:	3c 20                	cmp    $0x20,%al
  80185f:	74 f0                	je     801851 <strtol+0x24>
  801861:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801865:	0f b6 00             	movzbl (%rax),%eax
  801868:	3c 09                	cmp    $0x9,%al
  80186a:	74 e5                	je     801851 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80186c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801870:	0f b6 00             	movzbl (%rax),%eax
  801873:	3c 2b                	cmp    $0x2b,%al
  801875:	75 07                	jne    80187e <strtol+0x51>
		s++;
  801877:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80187c:	eb 17                	jmp    801895 <strtol+0x68>
	else if (*s == '-')
  80187e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801882:	0f b6 00             	movzbl (%rax),%eax
  801885:	3c 2d                	cmp    $0x2d,%al
  801887:	75 0c                	jne    801895 <strtol+0x68>
		s++, neg = 1;
  801889:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80188e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801895:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801899:	74 06                	je     8018a1 <strtol+0x74>
  80189b:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80189f:	75 28                	jne    8018c9 <strtol+0x9c>
  8018a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a5:	0f b6 00             	movzbl (%rax),%eax
  8018a8:	3c 30                	cmp    $0x30,%al
  8018aa:	75 1d                	jne    8018c9 <strtol+0x9c>
  8018ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b0:	48 83 c0 01          	add    $0x1,%rax
  8018b4:	0f b6 00             	movzbl (%rax),%eax
  8018b7:	3c 78                	cmp    $0x78,%al
  8018b9:	75 0e                	jne    8018c9 <strtol+0x9c>
		s += 2, base = 16;
  8018bb:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018c0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018c7:	eb 2c                	jmp    8018f5 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018cd:	75 19                	jne    8018e8 <strtol+0xbb>
  8018cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d3:	0f b6 00             	movzbl (%rax),%eax
  8018d6:	3c 30                	cmp    $0x30,%al
  8018d8:	75 0e                	jne    8018e8 <strtol+0xbb>
		s++, base = 8;
  8018da:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018df:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018e6:	eb 0d                	jmp    8018f5 <strtol+0xc8>
	else if (base == 0)
  8018e8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018ec:	75 07                	jne    8018f5 <strtol+0xc8>
		base = 10;
  8018ee:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f9:	0f b6 00             	movzbl (%rax),%eax
  8018fc:	3c 2f                	cmp    $0x2f,%al
  8018fe:	7e 1d                	jle    80191d <strtol+0xf0>
  801900:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801904:	0f b6 00             	movzbl (%rax),%eax
  801907:	3c 39                	cmp    $0x39,%al
  801909:	7f 12                	jg     80191d <strtol+0xf0>
			dig = *s - '0';
  80190b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190f:	0f b6 00             	movzbl (%rax),%eax
  801912:	0f be c0             	movsbl %al,%eax
  801915:	83 e8 30             	sub    $0x30,%eax
  801918:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80191b:	eb 4e                	jmp    80196b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80191d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801921:	0f b6 00             	movzbl (%rax),%eax
  801924:	3c 60                	cmp    $0x60,%al
  801926:	7e 1d                	jle    801945 <strtol+0x118>
  801928:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192c:	0f b6 00             	movzbl (%rax),%eax
  80192f:	3c 7a                	cmp    $0x7a,%al
  801931:	7f 12                	jg     801945 <strtol+0x118>
			dig = *s - 'a' + 10;
  801933:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801937:	0f b6 00             	movzbl (%rax),%eax
  80193a:	0f be c0             	movsbl %al,%eax
  80193d:	83 e8 57             	sub    $0x57,%eax
  801940:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801943:	eb 26                	jmp    80196b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801949:	0f b6 00             	movzbl (%rax),%eax
  80194c:	3c 40                	cmp    $0x40,%al
  80194e:	7e 48                	jle    801998 <strtol+0x16b>
  801950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801954:	0f b6 00             	movzbl (%rax),%eax
  801957:	3c 5a                	cmp    $0x5a,%al
  801959:	7f 3d                	jg     801998 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80195b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195f:	0f b6 00             	movzbl (%rax),%eax
  801962:	0f be c0             	movsbl %al,%eax
  801965:	83 e8 37             	sub    $0x37,%eax
  801968:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80196b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80196e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801971:	7c 02                	jl     801975 <strtol+0x148>
			break;
  801973:	eb 23                	jmp    801998 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801975:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80197a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80197d:	48 98                	cltq   
  80197f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801984:	48 89 c2             	mov    %rax,%rdx
  801987:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80198a:	48 98                	cltq   
  80198c:	48 01 d0             	add    %rdx,%rax
  80198f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801993:	e9 5d ff ff ff       	jmpq   8018f5 <strtol+0xc8>

	if (endptr)
  801998:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80199d:	74 0b                	je     8019aa <strtol+0x17d>
		*endptr = (char *) s;
  80199f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019a3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019a7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019ae:	74 09                	je     8019b9 <strtol+0x18c>
  8019b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019b4:	48 f7 d8             	neg    %rax
  8019b7:	eb 04                	jmp    8019bd <strtol+0x190>
  8019b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019bd:	c9                   	leaveq 
  8019be:	c3                   	retq   

00000000008019bf <strstr>:

char * strstr(const char *in, const char *str)
{
  8019bf:	55                   	push   %rbp
  8019c0:	48 89 e5             	mov    %rsp,%rbp
  8019c3:	48 83 ec 30          	sub    $0x30,%rsp
  8019c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019d7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019db:	0f b6 00             	movzbl (%rax),%eax
  8019de:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8019e1:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019e5:	75 06                	jne    8019ed <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8019e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019eb:	eb 6b                	jmp    801a58 <strstr+0x99>

    len = strlen(str);
  8019ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019f1:	48 89 c7             	mov    %rax,%rdi
  8019f4:	48 b8 95 12 80 00 00 	movabs $0x801295,%rax
  8019fb:	00 00 00 
  8019fe:	ff d0                	callq  *%rax
  801a00:	48 98                	cltq   
  801a02:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801a06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a0e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a12:	0f b6 00             	movzbl (%rax),%eax
  801a15:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801a18:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a1c:	75 07                	jne    801a25 <strstr+0x66>
                return (char *) 0;
  801a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801a23:	eb 33                	jmp    801a58 <strstr+0x99>
        } while (sc != c);
  801a25:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a29:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a2c:	75 d8                	jne    801a06 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a32:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3a:	48 89 ce             	mov    %rcx,%rsi
  801a3d:	48 89 c7             	mov    %rax,%rdi
  801a40:	48 b8 b6 14 80 00 00 	movabs $0x8014b6,%rax
  801a47:	00 00 00 
  801a4a:	ff d0                	callq  *%rax
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	75 b6                	jne    801a06 <strstr+0x47>

    return (char *) (in - 1);
  801a50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a54:	48 83 e8 01          	sub    $0x1,%rax
}
  801a58:	c9                   	leaveq 
  801a59:	c3                   	retq   
