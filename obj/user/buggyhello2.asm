
obj/user/buggyhello2:     file format elf64-x86-64


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
  80003c:	e8 34 00 00 00       	callq  800075 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	sys_cputs(hello, 1024*1024);
  800052:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	be 00 00 10 00       	mov    $0x100000,%esi
  800064:	48 89 c7             	mov    %rax,%rdi
  800067:	48 b8 be 01 80 00 00 	movabs $0x8001be,%rax
  80006e:	00 00 00 
  800071:	ff d0                	callq  *%rax
}
  800073:	c9                   	leaveq 
  800074:	c3                   	retq   

0000000000800075 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800075:	55                   	push   %rbp
  800076:	48 89 e5             	mov    %rsp,%rbp
  800079:	48 83 ec 20          	sub    $0x20,%rsp
  80007d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800080:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800084:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  80008b:	00 00 00 
  80008e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  800095:	48 b8 8a 02 80 00 00 	movabs $0x80028a,%rax
  80009c:	00 00 00 
  80009f:	ff d0                	callq  *%rax
  8000a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  8000a4:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  8000ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ae:	48 63 d0             	movslq %eax,%rdx
  8000b1:	48 89 d0             	mov    %rdx,%rax
  8000b4:	48 c1 e0 03          	shl    $0x3,%rax
  8000b8:	48 01 d0             	add    %rdx,%rax
  8000bb:	48 c1 e0 05          	shl    $0x5,%rax
  8000bf:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000c6:	00 00 00 
  8000c9:	48 01 c2             	add    %rax,%rdx
  8000cc:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8000d3:	00 00 00 
  8000d6:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000dd:	7e 14                	jle    8000f3 <libmain+0x7e>
		binaryname = argv[0];
  8000df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e3:	48 8b 10             	mov    (%rax),%rdx
  8000e6:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000ed:	00 00 00 
  8000f0:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000f3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000fa:	48 89 d6             	mov    %rdx,%rsi
  8000fd:	89 c7                	mov    %eax,%edi
  8000ff:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  80010b:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  800112:	00 00 00 
  800115:	ff d0                	callq  *%rax
}
  800117:	c9                   	leaveq 
  800118:	c3                   	retq   

0000000000800119 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800119:	55                   	push   %rbp
  80011a:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80011d:	bf 00 00 00 00       	mov    $0x0,%edi
  800122:	48 b8 46 02 80 00 00 	movabs $0x800246,%rax
  800129:	00 00 00 
  80012c:	ff d0                	callq  *%rax
}
  80012e:	5d                   	pop    %rbp
  80012f:	c3                   	retq   

0000000000800130 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800130:	55                   	push   %rbp
  800131:	48 89 e5             	mov    %rsp,%rbp
  800134:	53                   	push   %rbx
  800135:	48 83 ec 48          	sub    $0x48,%rsp
  800139:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80013c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80013f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800143:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800147:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80014b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80014f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800152:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800156:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80015a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80015e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800162:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800166:	4c 89 c3             	mov    %r8,%rbx
  800169:	cd 30                	int    $0x30
  80016b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80016f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800173:	74 3e                	je     8001b3 <syscall+0x83>
  800175:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80017a:	7e 37                	jle    8001b3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80017c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800180:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800183:	49 89 d0             	mov    %rdx,%r8
  800186:	89 c1                	mov    %eax,%ecx
  800188:	48 ba 98 1a 80 00 00 	movabs $0x801a98,%rdx
  80018f:	00 00 00 
  800192:	be 23 00 00 00       	mov    $0x23,%esi
  800197:	48 bf b5 1a 80 00 00 	movabs $0x801ab5,%rdi
  80019e:	00 00 00 
  8001a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a6:	49 b9 29 05 80 00 00 	movabs $0x800529,%r9
  8001ad:	00 00 00 
  8001b0:	41 ff d1             	callq  *%r9

	return ret;
  8001b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001b7:	48 83 c4 48          	add    $0x48,%rsp
  8001bb:	5b                   	pop    %rbx
  8001bc:	5d                   	pop    %rbp
  8001bd:	c3                   	retq   

00000000008001be <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001be:	55                   	push   %rbp
  8001bf:	48 89 e5             	mov    %rsp,%rbp
  8001c2:	48 83 ec 20          	sub    $0x20,%rsp
  8001c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001dd:	00 
  8001de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001ea:	48 89 d1             	mov    %rdx,%rcx
  8001ed:	48 89 c2             	mov    %rax,%rdx
  8001f0:	be 00 00 00 00       	mov    $0x0,%esi
  8001f5:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fa:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  800201:	00 00 00 
  800204:	ff d0                	callq  *%rax
}
  800206:	c9                   	leaveq 
  800207:	c3                   	retq   

0000000000800208 <sys_cgetc>:

int
sys_cgetc(void)
{
  800208:	55                   	push   %rbp
  800209:	48 89 e5             	mov    %rsp,%rbp
  80020c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800210:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800217:	00 
  800218:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80021e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800224:	b9 00 00 00 00       	mov    $0x0,%ecx
  800229:	ba 00 00 00 00       	mov    $0x0,%edx
  80022e:	be 00 00 00 00       	mov    $0x0,%esi
  800233:	bf 01 00 00 00       	mov    $0x1,%edi
  800238:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  80023f:	00 00 00 
  800242:	ff d0                	callq  *%rax
}
  800244:	c9                   	leaveq 
  800245:	c3                   	retq   

0000000000800246 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800246:	55                   	push   %rbp
  800247:	48 89 e5             	mov    %rsp,%rbp
  80024a:	48 83 ec 10          	sub    $0x10,%rsp
  80024e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800251:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800254:	48 98                	cltq   
  800256:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80025d:	00 
  80025e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800264:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80026a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80026f:	48 89 c2             	mov    %rax,%rdx
  800272:	be 01 00 00 00       	mov    $0x1,%esi
  800277:	bf 03 00 00 00       	mov    $0x3,%edi
  80027c:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  800283:	00 00 00 
  800286:	ff d0                	callq  *%rax
}
  800288:	c9                   	leaveq 
  800289:	c3                   	retq   

000000000080028a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80028a:	55                   	push   %rbp
  80028b:	48 89 e5             	mov    %rsp,%rbp
  80028e:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800292:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800299:	00 
  80029a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002a0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b0:	be 00 00 00 00       	mov    $0x0,%esi
  8002b5:	bf 02 00 00 00       	mov    $0x2,%edi
  8002ba:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  8002c1:	00 00 00 
  8002c4:	ff d0                	callq  *%rax
}
  8002c6:	c9                   	leaveq 
  8002c7:	c3                   	retq   

00000000008002c8 <sys_yield>:

void
sys_yield(void)
{
  8002c8:	55                   	push   %rbp
  8002c9:	48 89 e5             	mov    %rsp,%rbp
  8002cc:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002d0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8002d7:	00 
  8002d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ee:	be 00 00 00 00       	mov    $0x0,%esi
  8002f3:	bf 0a 00 00 00       	mov    $0xa,%edi
  8002f8:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  8002ff:	00 00 00 
  800302:	ff d0                	callq  *%rax
}
  800304:	c9                   	leaveq 
  800305:	c3                   	retq   

0000000000800306 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800306:	55                   	push   %rbp
  800307:	48 89 e5             	mov    %rsp,%rbp
  80030a:	48 83 ec 20          	sub    $0x20,%rsp
  80030e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800311:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800315:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800318:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80031b:	48 63 c8             	movslq %eax,%rcx
  80031e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800322:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800325:	48 98                	cltq   
  800327:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80032e:	00 
  80032f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800335:	49 89 c8             	mov    %rcx,%r8
  800338:	48 89 d1             	mov    %rdx,%rcx
  80033b:	48 89 c2             	mov    %rax,%rdx
  80033e:	be 01 00 00 00       	mov    $0x1,%esi
  800343:	bf 04 00 00 00       	mov    $0x4,%edi
  800348:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  80034f:	00 00 00 
  800352:	ff d0                	callq  *%rax
}
  800354:	c9                   	leaveq 
  800355:	c3                   	retq   

0000000000800356 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800356:	55                   	push   %rbp
  800357:	48 89 e5             	mov    %rsp,%rbp
  80035a:	48 83 ec 30          	sub    $0x30,%rsp
  80035e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800361:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800365:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800368:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80036c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800370:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800373:	48 63 c8             	movslq %eax,%rcx
  800376:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80037a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80037d:	48 63 f0             	movslq %eax,%rsi
  800380:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800384:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800387:	48 98                	cltq   
  800389:	48 89 0c 24          	mov    %rcx,(%rsp)
  80038d:	49 89 f9             	mov    %rdi,%r9
  800390:	49 89 f0             	mov    %rsi,%r8
  800393:	48 89 d1             	mov    %rdx,%rcx
  800396:	48 89 c2             	mov    %rax,%rdx
  800399:	be 01 00 00 00       	mov    $0x1,%esi
  80039e:	bf 05 00 00 00       	mov    $0x5,%edi
  8003a3:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  8003aa:	00 00 00 
  8003ad:	ff d0                	callq  *%rax
}
  8003af:	c9                   	leaveq 
  8003b0:	c3                   	retq   

00000000008003b1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003b1:	55                   	push   %rbp
  8003b2:	48 89 e5             	mov    %rsp,%rbp
  8003b5:	48 83 ec 20          	sub    $0x20,%rsp
  8003b9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c7:	48 98                	cltq   
  8003c9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8003d0:	00 
  8003d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003dd:	48 89 d1             	mov    %rdx,%rcx
  8003e0:	48 89 c2             	mov    %rax,%rdx
  8003e3:	be 01 00 00 00       	mov    $0x1,%esi
  8003e8:	bf 06 00 00 00       	mov    $0x6,%edi
  8003ed:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  8003f4:	00 00 00 
  8003f7:	ff d0                	callq  *%rax
}
  8003f9:	c9                   	leaveq 
  8003fa:	c3                   	retq   

00000000008003fb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003fb:	55                   	push   %rbp
  8003fc:	48 89 e5             	mov    %rsp,%rbp
  8003ff:	48 83 ec 10          	sub    $0x10,%rsp
  800403:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800406:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800409:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040c:	48 63 d0             	movslq %eax,%rdx
  80040f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800412:	48 98                	cltq   
  800414:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80041b:	00 
  80041c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800422:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800428:	48 89 d1             	mov    %rdx,%rcx
  80042b:	48 89 c2             	mov    %rax,%rdx
  80042e:	be 01 00 00 00       	mov    $0x1,%esi
  800433:	bf 08 00 00 00       	mov    $0x8,%edi
  800438:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  80043f:	00 00 00 
  800442:	ff d0                	callq  *%rax
}
  800444:	c9                   	leaveq 
  800445:	c3                   	retq   

0000000000800446 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800446:	55                   	push   %rbp
  800447:	48 89 e5             	mov    %rsp,%rbp
  80044a:	48 83 ec 20          	sub    $0x20,%rsp
  80044e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800451:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800455:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80045c:	48 98                	cltq   
  80045e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800465:	00 
  800466:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80046c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800472:	48 89 d1             	mov    %rdx,%rcx
  800475:	48 89 c2             	mov    %rax,%rdx
  800478:	be 01 00 00 00       	mov    $0x1,%esi
  80047d:	bf 09 00 00 00       	mov    $0x9,%edi
  800482:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  800489:	00 00 00 
  80048c:	ff d0                	callq  *%rax
}
  80048e:	c9                   	leaveq 
  80048f:	c3                   	retq   

0000000000800490 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800490:	55                   	push   %rbp
  800491:	48 89 e5             	mov    %rsp,%rbp
  800494:	48 83 ec 20          	sub    $0x20,%rsp
  800498:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80049b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80049f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004a3:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004a9:	48 63 f0             	movslq %eax,%rsi
  8004ac:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004b3:	48 98                	cltq   
  8004b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004c0:	00 
  8004c1:	49 89 f1             	mov    %rsi,%r9
  8004c4:	49 89 c8             	mov    %rcx,%r8
  8004c7:	48 89 d1             	mov    %rdx,%rcx
  8004ca:	48 89 c2             	mov    %rax,%rdx
  8004cd:	be 00 00 00 00       	mov    $0x0,%esi
  8004d2:	bf 0b 00 00 00       	mov    $0xb,%edi
  8004d7:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  8004de:	00 00 00 
  8004e1:	ff d0                	callq  *%rax
}
  8004e3:	c9                   	leaveq 
  8004e4:	c3                   	retq   

00000000008004e5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8004e5:	55                   	push   %rbp
  8004e6:	48 89 e5             	mov    %rsp,%rbp
  8004e9:	48 83 ec 10          	sub    $0x10,%rsp
  8004ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8004f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8004fc:	00 
  8004fd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800503:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800509:	b9 00 00 00 00       	mov    $0x0,%ecx
  80050e:	48 89 c2             	mov    %rax,%rdx
  800511:	be 01 00 00 00       	mov    $0x1,%esi
  800516:	bf 0c 00 00 00       	mov    $0xc,%edi
  80051b:	48 b8 30 01 80 00 00 	movabs $0x800130,%rax
  800522:	00 00 00 
  800525:	ff d0                	callq  *%rax
}
  800527:	c9                   	leaveq 
  800528:	c3                   	retq   

0000000000800529 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800529:	55                   	push   %rbp
  80052a:	48 89 e5             	mov    %rsp,%rbp
  80052d:	53                   	push   %rbx
  80052e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800535:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80053c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800542:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800549:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800550:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800557:	84 c0                	test   %al,%al
  800559:	74 23                	je     80057e <_panic+0x55>
  80055b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800562:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800566:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80056a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80056e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800572:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800576:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80057a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80057e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800585:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80058c:	00 00 00 
  80058f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800596:	00 00 00 
  800599:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80059d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8005a4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8005ab:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005b2:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8005b9:	00 00 00 
  8005bc:	48 8b 18             	mov    (%rax),%rbx
  8005bf:	48 b8 8a 02 80 00 00 	movabs $0x80028a,%rax
  8005c6:	00 00 00 
  8005c9:	ff d0                	callq  *%rax
  8005cb:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005d1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005d8:	41 89 c8             	mov    %ecx,%r8d
  8005db:	48 89 d1             	mov    %rdx,%rcx
  8005de:	48 89 da             	mov    %rbx,%rdx
  8005e1:	89 c6                	mov    %eax,%esi
  8005e3:	48 bf c8 1a 80 00 00 	movabs $0x801ac8,%rdi
  8005ea:	00 00 00 
  8005ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f2:	49 b9 62 07 80 00 00 	movabs $0x800762,%r9
  8005f9:	00 00 00 
  8005fc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005ff:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800606:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80060d:	48 89 d6             	mov    %rdx,%rsi
  800610:	48 89 c7             	mov    %rax,%rdi
  800613:	48 b8 b6 06 80 00 00 	movabs $0x8006b6,%rax
  80061a:	00 00 00 
  80061d:	ff d0                	callq  *%rax
	cprintf("\n");
  80061f:	48 bf eb 1a 80 00 00 	movabs $0x801aeb,%rdi
  800626:	00 00 00 
  800629:	b8 00 00 00 00       	mov    $0x0,%eax
  80062e:	48 ba 62 07 80 00 00 	movabs $0x800762,%rdx
  800635:	00 00 00 
  800638:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80063a:	cc                   	int3   
  80063b:	eb fd                	jmp    80063a <_panic+0x111>

000000000080063d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80063d:	55                   	push   %rbp
  80063e:	48 89 e5             	mov    %rsp,%rbp
  800641:	48 83 ec 10          	sub    $0x10,%rsp
  800645:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800648:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80064c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800650:	8b 00                	mov    (%rax),%eax
  800652:	8d 48 01             	lea    0x1(%rax),%ecx
  800655:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800659:	89 0a                	mov    %ecx,(%rdx)
  80065b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80065e:	89 d1                	mov    %edx,%ecx
  800660:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800664:	48 98                	cltq   
  800666:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80066a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80066e:	8b 00                	mov    (%rax),%eax
  800670:	3d ff 00 00 00       	cmp    $0xff,%eax
  800675:	75 2c                	jne    8006a3 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  800677:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80067b:	8b 00                	mov    (%rax),%eax
  80067d:	48 98                	cltq   
  80067f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800683:	48 83 c2 08          	add    $0x8,%rdx
  800687:	48 89 c6             	mov    %rax,%rsi
  80068a:	48 89 d7             	mov    %rdx,%rdi
  80068d:	48 b8 be 01 80 00 00 	movabs $0x8001be,%rax
  800694:	00 00 00 
  800697:	ff d0                	callq  *%rax
		b->idx = 0;
  800699:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80069d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8006a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006a7:	8b 40 04             	mov    0x4(%rax),%eax
  8006aa:	8d 50 01             	lea    0x1(%rax),%edx
  8006ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006b1:	89 50 04             	mov    %edx,0x4(%rax)
}
  8006b4:	c9                   	leaveq 
  8006b5:	c3                   	retq   

00000000008006b6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006b6:	55                   	push   %rbp
  8006b7:	48 89 e5             	mov    %rsp,%rbp
  8006ba:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006c1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006c8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8006cf:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006d6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006dd:	48 8b 0a             	mov    (%rdx),%rcx
  8006e0:	48 89 08             	mov    %rcx,(%rax)
  8006e3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006e7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006eb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006ef:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8006f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006fa:	00 00 00 
	b.cnt = 0;
  8006fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800704:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  800707:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80070e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800715:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80071c:	48 89 c6             	mov    %rax,%rsi
  80071f:	48 bf 3d 06 80 00 00 	movabs $0x80063d,%rdi
  800726:	00 00 00 
  800729:	48 b8 15 0b 80 00 00 	movabs $0x800b15,%rax
  800730:	00 00 00 
  800733:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800735:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80073b:	48 98                	cltq   
  80073d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800744:	48 83 c2 08          	add    $0x8,%rdx
  800748:	48 89 c6             	mov    %rax,%rsi
  80074b:	48 89 d7             	mov    %rdx,%rdi
  80074e:	48 b8 be 01 80 00 00 	movabs $0x8001be,%rax
  800755:	00 00 00 
  800758:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80075a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800760:	c9                   	leaveq 
  800761:	c3                   	retq   

0000000000800762 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800762:	55                   	push   %rbp
  800763:	48 89 e5             	mov    %rsp,%rbp
  800766:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80076d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800774:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80077b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800782:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800789:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800790:	84 c0                	test   %al,%al
  800792:	74 20                	je     8007b4 <cprintf+0x52>
  800794:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800798:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80079c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8007a0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8007a4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8007a8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8007ac:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8007b0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8007b4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8007bb:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007c2:	00 00 00 
  8007c5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007cc:	00 00 00 
  8007cf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007d3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007da:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007e1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8007e8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007ef:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007f6:	48 8b 0a             	mov    (%rdx),%rcx
  8007f9:	48 89 08             	mov    %rcx,(%rax)
  8007fc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800800:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800804:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800808:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80080c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800813:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80081a:	48 89 d6             	mov    %rdx,%rsi
  80081d:	48 89 c7             	mov    %rax,%rdi
  800820:	48 b8 b6 06 80 00 00 	movabs $0x8006b6,%rax
  800827:	00 00 00 
  80082a:	ff d0                	callq  *%rax
  80082c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800832:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800838:	c9                   	leaveq 
  800839:	c3                   	retq   

000000000080083a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80083a:	55                   	push   %rbp
  80083b:	48 89 e5             	mov    %rsp,%rbp
  80083e:	53                   	push   %rbx
  80083f:	48 83 ec 38          	sub    $0x38,%rsp
  800843:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800847:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80084b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80084f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800852:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800856:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80085a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80085d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800861:	77 3b                	ja     80089e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800863:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800866:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80086a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80086d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800871:	ba 00 00 00 00       	mov    $0x0,%edx
  800876:	48 f7 f3             	div    %rbx
  800879:	48 89 c2             	mov    %rax,%rdx
  80087c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80087f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800882:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800886:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80088a:	41 89 f9             	mov    %edi,%r9d
  80088d:	48 89 c7             	mov    %rax,%rdi
  800890:	48 b8 3a 08 80 00 00 	movabs $0x80083a,%rax
  800897:	00 00 00 
  80089a:	ff d0                	callq  *%rax
  80089c:	eb 1e                	jmp    8008bc <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80089e:	eb 12                	jmp    8008b2 <printnum+0x78>
			putch(padc, putdat);
  8008a0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008a4:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8008a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ab:	48 89 ce             	mov    %rcx,%rsi
  8008ae:	89 d7                	mov    %edx,%edi
  8008b0:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008b2:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8008b6:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008ba:	7f e4                	jg     8008a0 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008bc:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c8:	48 f7 f1             	div    %rcx
  8008cb:	48 89 d0             	mov    %rdx,%rax
  8008ce:	48 ba f0 1b 80 00 00 	movabs $0x801bf0,%rdx
  8008d5:	00 00 00 
  8008d8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008dc:	0f be d0             	movsbl %al,%edx
  8008df:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e7:	48 89 ce             	mov    %rcx,%rsi
  8008ea:	89 d7                	mov    %edx,%edi
  8008ec:	ff d0                	callq  *%rax
}
  8008ee:	48 83 c4 38          	add    $0x38,%rsp
  8008f2:	5b                   	pop    %rbx
  8008f3:	5d                   	pop    %rbp
  8008f4:	c3                   	retq   

00000000008008f5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008f5:	55                   	push   %rbp
  8008f6:	48 89 e5             	mov    %rsp,%rbp
  8008f9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800901:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800904:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800908:	7e 52                	jle    80095c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80090a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090e:	8b 00                	mov    (%rax),%eax
  800910:	83 f8 30             	cmp    $0x30,%eax
  800913:	73 24                	jae    800939 <getuint+0x44>
  800915:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800919:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80091d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800921:	8b 00                	mov    (%rax),%eax
  800923:	89 c0                	mov    %eax,%eax
  800925:	48 01 d0             	add    %rdx,%rax
  800928:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80092c:	8b 12                	mov    (%rdx),%edx
  80092e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800931:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800935:	89 0a                	mov    %ecx,(%rdx)
  800937:	eb 17                	jmp    800950 <getuint+0x5b>
  800939:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80093d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800941:	48 89 d0             	mov    %rdx,%rax
  800944:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800948:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800950:	48 8b 00             	mov    (%rax),%rax
  800953:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800957:	e9 a3 00 00 00       	jmpq   8009ff <getuint+0x10a>
	else if (lflag)
  80095c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800960:	74 4f                	je     8009b1 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800962:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800966:	8b 00                	mov    (%rax),%eax
  800968:	83 f8 30             	cmp    $0x30,%eax
  80096b:	73 24                	jae    800991 <getuint+0x9c>
  80096d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800971:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800975:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800979:	8b 00                	mov    (%rax),%eax
  80097b:	89 c0                	mov    %eax,%eax
  80097d:	48 01 d0             	add    %rdx,%rax
  800980:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800984:	8b 12                	mov    (%rdx),%edx
  800986:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800989:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098d:	89 0a                	mov    %ecx,(%rdx)
  80098f:	eb 17                	jmp    8009a8 <getuint+0xb3>
  800991:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800995:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800999:	48 89 d0             	mov    %rdx,%rax
  80099c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009a8:	48 8b 00             	mov    (%rax),%rax
  8009ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009af:	eb 4e                	jmp    8009ff <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8009b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b5:	8b 00                	mov    (%rax),%eax
  8009b7:	83 f8 30             	cmp    $0x30,%eax
  8009ba:	73 24                	jae    8009e0 <getuint+0xeb>
  8009bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c8:	8b 00                	mov    (%rax),%eax
  8009ca:	89 c0                	mov    %eax,%eax
  8009cc:	48 01 d0             	add    %rdx,%rax
  8009cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d3:	8b 12                	mov    (%rdx),%edx
  8009d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009dc:	89 0a                	mov    %ecx,(%rdx)
  8009de:	eb 17                	jmp    8009f7 <getuint+0x102>
  8009e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009e8:	48 89 d0             	mov    %rdx,%rax
  8009eb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009f7:	8b 00                	mov    (%rax),%eax
  8009f9:	89 c0                	mov    %eax,%eax
  8009fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a03:	c9                   	leaveq 
  800a04:	c3                   	retq   

0000000000800a05 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a05:	55                   	push   %rbp
  800a06:	48 89 e5             	mov    %rsp,%rbp
  800a09:	48 83 ec 1c          	sub    $0x1c,%rsp
  800a0d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a11:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a14:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a18:	7e 52                	jle    800a6c <getint+0x67>
		x=va_arg(*ap, long long);
  800a1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1e:	8b 00                	mov    (%rax),%eax
  800a20:	83 f8 30             	cmp    $0x30,%eax
  800a23:	73 24                	jae    800a49 <getint+0x44>
  800a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a29:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a31:	8b 00                	mov    (%rax),%eax
  800a33:	89 c0                	mov    %eax,%eax
  800a35:	48 01 d0             	add    %rdx,%rax
  800a38:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3c:	8b 12                	mov    (%rdx),%edx
  800a3e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a45:	89 0a                	mov    %ecx,(%rdx)
  800a47:	eb 17                	jmp    800a60 <getint+0x5b>
  800a49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a51:	48 89 d0             	mov    %rdx,%rax
  800a54:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a5c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a60:	48 8b 00             	mov    (%rax),%rax
  800a63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a67:	e9 a3 00 00 00       	jmpq   800b0f <getint+0x10a>
	else if (lflag)
  800a6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a70:	74 4f                	je     800ac1 <getint+0xbc>
		x=va_arg(*ap, long);
  800a72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a76:	8b 00                	mov    (%rax),%eax
  800a78:	83 f8 30             	cmp    $0x30,%eax
  800a7b:	73 24                	jae    800aa1 <getint+0x9c>
  800a7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a81:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a89:	8b 00                	mov    (%rax),%eax
  800a8b:	89 c0                	mov    %eax,%eax
  800a8d:	48 01 d0             	add    %rdx,%rax
  800a90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a94:	8b 12                	mov    (%rdx),%edx
  800a96:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a99:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9d:	89 0a                	mov    %ecx,(%rdx)
  800a9f:	eb 17                	jmp    800ab8 <getint+0xb3>
  800aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aa9:	48 89 d0             	mov    %rdx,%rax
  800aac:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ab0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ab8:	48 8b 00             	mov    (%rax),%rax
  800abb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800abf:	eb 4e                	jmp    800b0f <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac5:	8b 00                	mov    (%rax),%eax
  800ac7:	83 f8 30             	cmp    $0x30,%eax
  800aca:	73 24                	jae    800af0 <getint+0xeb>
  800acc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad8:	8b 00                	mov    (%rax),%eax
  800ada:	89 c0                	mov    %eax,%eax
  800adc:	48 01 d0             	add    %rdx,%rax
  800adf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae3:	8b 12                	mov    (%rdx),%edx
  800ae5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ae8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aec:	89 0a                	mov    %ecx,(%rdx)
  800aee:	eb 17                	jmp    800b07 <getint+0x102>
  800af0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800af8:	48 89 d0             	mov    %rdx,%rax
  800afb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b03:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b07:	8b 00                	mov    (%rax),%eax
  800b09:	48 98                	cltq   
  800b0b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b13:	c9                   	leaveq 
  800b14:	c3                   	retq   

0000000000800b15 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b15:	55                   	push   %rbp
  800b16:	48 89 e5             	mov    %rsp,%rbp
  800b19:	41 54                	push   %r12
  800b1b:	53                   	push   %rbx
  800b1c:	48 83 ec 60          	sub    $0x60,%rsp
  800b20:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b24:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b28:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b2c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b30:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b34:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b38:	48 8b 0a             	mov    (%rdx),%rcx
  800b3b:	48 89 08             	mov    %rcx,(%rax)
  800b3e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b42:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b46:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b4a:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b4e:	eb 17                	jmp    800b67 <vprintfmt+0x52>
			if (ch == '\0')
  800b50:	85 db                	test   %ebx,%ebx
  800b52:	0f 84 cc 04 00 00    	je     801024 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800b58:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b60:	48 89 d6             	mov    %rdx,%rsi
  800b63:	89 df                	mov    %ebx,%edi
  800b65:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b67:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b6b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b6f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b73:	0f b6 00             	movzbl (%rax),%eax
  800b76:	0f b6 d8             	movzbl %al,%ebx
  800b79:	83 fb 25             	cmp    $0x25,%ebx
  800b7c:	75 d2                	jne    800b50 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800b7e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b82:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b89:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b90:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b97:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b9e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ba6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800baa:	0f b6 00             	movzbl (%rax),%eax
  800bad:	0f b6 d8             	movzbl %al,%ebx
  800bb0:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800bb3:	83 f8 55             	cmp    $0x55,%eax
  800bb6:	0f 87 34 04 00 00    	ja     800ff0 <vprintfmt+0x4db>
  800bbc:	89 c0                	mov    %eax,%eax
  800bbe:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bc5:	00 
  800bc6:	48 b8 18 1c 80 00 00 	movabs $0x801c18,%rax
  800bcd:	00 00 00 
  800bd0:	48 01 d0             	add    %rdx,%rax
  800bd3:	48 8b 00             	mov    (%rax),%rax
  800bd6:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bd8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bdc:	eb c0                	jmp    800b9e <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bde:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800be2:	eb ba                	jmp    800b9e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800beb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800bee:	89 d0                	mov    %edx,%eax
  800bf0:	c1 e0 02             	shl    $0x2,%eax
  800bf3:	01 d0                	add    %edx,%eax
  800bf5:	01 c0                	add    %eax,%eax
  800bf7:	01 d8                	add    %ebx,%eax
  800bf9:	83 e8 30             	sub    $0x30,%eax
  800bfc:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bff:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c03:	0f b6 00             	movzbl (%rax),%eax
  800c06:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c09:	83 fb 2f             	cmp    $0x2f,%ebx
  800c0c:	7e 0c                	jle    800c1a <vprintfmt+0x105>
  800c0e:	83 fb 39             	cmp    $0x39,%ebx
  800c11:	7f 07                	jg     800c1a <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c13:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c18:	eb d1                	jmp    800beb <vprintfmt+0xd6>
			goto process_precision;
  800c1a:	eb 58                	jmp    800c74 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800c1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1f:	83 f8 30             	cmp    $0x30,%eax
  800c22:	73 17                	jae    800c3b <vprintfmt+0x126>
  800c24:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c28:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c2b:	89 c0                	mov    %eax,%eax
  800c2d:	48 01 d0             	add    %rdx,%rax
  800c30:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c33:	83 c2 08             	add    $0x8,%edx
  800c36:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c39:	eb 0f                	jmp    800c4a <vprintfmt+0x135>
  800c3b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c3f:	48 89 d0             	mov    %rdx,%rax
  800c42:	48 83 c2 08          	add    $0x8,%rdx
  800c46:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c4a:	8b 00                	mov    (%rax),%eax
  800c4c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c4f:	eb 23                	jmp    800c74 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800c51:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c55:	79 0c                	jns    800c63 <vprintfmt+0x14e>
				width = 0;
  800c57:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c5e:	e9 3b ff ff ff       	jmpq   800b9e <vprintfmt+0x89>
  800c63:	e9 36 ff ff ff       	jmpq   800b9e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800c68:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c6f:	e9 2a ff ff ff       	jmpq   800b9e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800c74:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c78:	79 12                	jns    800c8c <vprintfmt+0x177>
				width = precision, precision = -1;
  800c7a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c7d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c80:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c87:	e9 12 ff ff ff       	jmpq   800b9e <vprintfmt+0x89>
  800c8c:	e9 0d ff ff ff       	jmpq   800b9e <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c91:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c95:	e9 04 ff ff ff       	jmpq   800b9e <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800c9a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9d:	83 f8 30             	cmp    $0x30,%eax
  800ca0:	73 17                	jae    800cb9 <vprintfmt+0x1a4>
  800ca2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ca6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca9:	89 c0                	mov    %eax,%eax
  800cab:	48 01 d0             	add    %rdx,%rax
  800cae:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb1:	83 c2 08             	add    $0x8,%edx
  800cb4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cb7:	eb 0f                	jmp    800cc8 <vprintfmt+0x1b3>
  800cb9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cbd:	48 89 d0             	mov    %rdx,%rax
  800cc0:	48 83 c2 08          	add    $0x8,%rdx
  800cc4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc8:	8b 10                	mov    (%rax),%edx
  800cca:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd2:	48 89 ce             	mov    %rcx,%rsi
  800cd5:	89 d7                	mov    %edx,%edi
  800cd7:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800cd9:	e9 40 03 00 00       	jmpq   80101e <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  800cde:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce1:	83 f8 30             	cmp    $0x30,%eax
  800ce4:	73 17                	jae    800cfd <vprintfmt+0x1e8>
  800ce6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cea:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ced:	89 c0                	mov    %eax,%eax
  800cef:	48 01 d0             	add    %rdx,%rax
  800cf2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cf5:	83 c2 08             	add    $0x8,%edx
  800cf8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cfb:	eb 0f                	jmp    800d0c <vprintfmt+0x1f7>
  800cfd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d01:	48 89 d0             	mov    %rdx,%rax
  800d04:	48 83 c2 08          	add    $0x8,%rdx
  800d08:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d0c:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d0e:	85 db                	test   %ebx,%ebx
  800d10:	79 02                	jns    800d14 <vprintfmt+0x1ff>
				err = -err;
  800d12:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d14:	83 fb 09             	cmp    $0x9,%ebx
  800d17:	7f 16                	jg     800d2f <vprintfmt+0x21a>
  800d19:	48 b8 a0 1b 80 00 00 	movabs $0x801ba0,%rax
  800d20:	00 00 00 
  800d23:	48 63 d3             	movslq %ebx,%rdx
  800d26:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d2a:	4d 85 e4             	test   %r12,%r12
  800d2d:	75 2e                	jne    800d5d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800d2f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d37:	89 d9                	mov    %ebx,%ecx
  800d39:	48 ba 01 1c 80 00 00 	movabs $0x801c01,%rdx
  800d40:	00 00 00 
  800d43:	48 89 c7             	mov    %rax,%rdi
  800d46:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4b:	49 b8 2d 10 80 00 00 	movabs $0x80102d,%r8
  800d52:	00 00 00 
  800d55:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d58:	e9 c1 02 00 00       	jmpq   80101e <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d5d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d65:	4c 89 e1             	mov    %r12,%rcx
  800d68:	48 ba 0a 1c 80 00 00 	movabs $0x801c0a,%rdx
  800d6f:	00 00 00 
  800d72:	48 89 c7             	mov    %rax,%rdi
  800d75:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7a:	49 b8 2d 10 80 00 00 	movabs $0x80102d,%r8
  800d81:	00 00 00 
  800d84:	41 ff d0             	callq  *%r8
			break;
  800d87:	e9 92 02 00 00       	jmpq   80101e <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800d8c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d8f:	83 f8 30             	cmp    $0x30,%eax
  800d92:	73 17                	jae    800dab <vprintfmt+0x296>
  800d94:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d98:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d9b:	89 c0                	mov    %eax,%eax
  800d9d:	48 01 d0             	add    %rdx,%rax
  800da0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800da3:	83 c2 08             	add    $0x8,%edx
  800da6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800da9:	eb 0f                	jmp    800dba <vprintfmt+0x2a5>
  800dab:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800daf:	48 89 d0             	mov    %rdx,%rax
  800db2:	48 83 c2 08          	add    $0x8,%rdx
  800db6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dba:	4c 8b 20             	mov    (%rax),%r12
  800dbd:	4d 85 e4             	test   %r12,%r12
  800dc0:	75 0a                	jne    800dcc <vprintfmt+0x2b7>
				p = "(null)";
  800dc2:	49 bc 0d 1c 80 00 00 	movabs $0x801c0d,%r12
  800dc9:	00 00 00 
			if (width > 0 && padc != '-')
  800dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dd0:	7e 3f                	jle    800e11 <vprintfmt+0x2fc>
  800dd2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dd6:	74 39                	je     800e11 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ddb:	48 98                	cltq   
  800ddd:	48 89 c6             	mov    %rax,%rsi
  800de0:	4c 89 e7             	mov    %r12,%rdi
  800de3:	48 b8 d9 12 80 00 00 	movabs $0x8012d9,%rax
  800dea:	00 00 00 
  800ded:	ff d0                	callq  *%rax
  800def:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800df2:	eb 17                	jmp    800e0b <vprintfmt+0x2f6>
					putch(padc, putdat);
  800df4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800df8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e00:	48 89 ce             	mov    %rcx,%rsi
  800e03:	89 d7                	mov    %edx,%edi
  800e05:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e07:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e0f:	7f e3                	jg     800df4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e11:	eb 37                	jmp    800e4a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800e13:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e17:	74 1e                	je     800e37 <vprintfmt+0x322>
  800e19:	83 fb 1f             	cmp    $0x1f,%ebx
  800e1c:	7e 05                	jle    800e23 <vprintfmt+0x30e>
  800e1e:	83 fb 7e             	cmp    $0x7e,%ebx
  800e21:	7e 14                	jle    800e37 <vprintfmt+0x322>
					putch('?', putdat);
  800e23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2b:	48 89 d6             	mov    %rdx,%rsi
  800e2e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e33:	ff d0                	callq  *%rax
  800e35:	eb 0f                	jmp    800e46 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800e37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e3f:	48 89 d6             	mov    %rdx,%rsi
  800e42:	89 df                	mov    %ebx,%edi
  800e44:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e46:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e4a:	4c 89 e0             	mov    %r12,%rax
  800e4d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e51:	0f b6 00             	movzbl (%rax),%eax
  800e54:	0f be d8             	movsbl %al,%ebx
  800e57:	85 db                	test   %ebx,%ebx
  800e59:	74 10                	je     800e6b <vprintfmt+0x356>
  800e5b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e5f:	78 b2                	js     800e13 <vprintfmt+0x2fe>
  800e61:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e65:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e69:	79 a8                	jns    800e13 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e6b:	eb 16                	jmp    800e83 <vprintfmt+0x36e>
				putch(' ', putdat);
  800e6d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e71:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e75:	48 89 d6             	mov    %rdx,%rsi
  800e78:	bf 20 00 00 00       	mov    $0x20,%edi
  800e7d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e7f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e83:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e87:	7f e4                	jg     800e6d <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800e89:	e9 90 01 00 00       	jmpq   80101e <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800e8e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e92:	be 03 00 00 00       	mov    $0x3,%esi
  800e97:	48 89 c7             	mov    %rax,%rdi
  800e9a:	48 b8 05 0a 80 00 00 	movabs $0x800a05,%rax
  800ea1:	00 00 00 
  800ea4:	ff d0                	callq  *%rax
  800ea6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800eaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eae:	48 85 c0             	test   %rax,%rax
  800eb1:	79 1d                	jns    800ed0 <vprintfmt+0x3bb>
				putch('-', putdat);
  800eb3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ebb:	48 89 d6             	mov    %rdx,%rsi
  800ebe:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ec3:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec9:	48 f7 d8             	neg    %rax
  800ecc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ed0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ed7:	e9 d5 00 00 00       	jmpq   800fb1 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800edc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ee0:	be 03 00 00 00       	mov    $0x3,%esi
  800ee5:	48 89 c7             	mov    %rax,%rdi
  800ee8:	48 b8 f5 08 80 00 00 	movabs $0x8008f5,%rax
  800eef:	00 00 00 
  800ef2:	ff d0                	callq  *%rax
  800ef4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ef8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800eff:	e9 ad 00 00 00       	jmpq   800fb1 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800f04:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f08:	be 03 00 00 00       	mov    $0x3,%esi
  800f0d:	48 89 c7             	mov    %rax,%rdi
  800f10:	48 b8 f5 08 80 00 00 	movabs $0x8008f5,%rax
  800f17:	00 00 00 
  800f1a:	ff d0                	callq  *%rax
  800f1c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f20:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f27:	e9 85 00 00 00       	jmpq   800fb1 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800f2c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f30:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f34:	48 89 d6             	mov    %rdx,%rsi
  800f37:	bf 30 00 00 00       	mov    $0x30,%edi
  800f3c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f3e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f42:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f46:	48 89 d6             	mov    %rdx,%rsi
  800f49:	bf 78 00 00 00       	mov    $0x78,%edi
  800f4e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f53:	83 f8 30             	cmp    $0x30,%eax
  800f56:	73 17                	jae    800f6f <vprintfmt+0x45a>
  800f58:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f5f:	89 c0                	mov    %eax,%eax
  800f61:	48 01 d0             	add    %rdx,%rax
  800f64:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f67:	83 c2 08             	add    $0x8,%edx
  800f6a:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f6d:	eb 0f                	jmp    800f7e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800f6f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f73:	48 89 d0             	mov    %rdx,%rax
  800f76:	48 83 c2 08          	add    $0x8,%rdx
  800f7a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f7e:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f85:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f8c:	eb 23                	jmp    800fb1 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800f8e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f92:	be 03 00 00 00       	mov    $0x3,%esi
  800f97:	48 89 c7             	mov    %rax,%rdi
  800f9a:	48 b8 f5 08 80 00 00 	movabs $0x8008f5,%rax
  800fa1:	00 00 00 
  800fa4:	ff d0                	callq  *%rax
  800fa6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800faa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800fb1:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800fb6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fb9:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fbc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fc0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc8:	45 89 c1             	mov    %r8d,%r9d
  800fcb:	41 89 f8             	mov    %edi,%r8d
  800fce:	48 89 c7             	mov    %rax,%rdi
  800fd1:	48 b8 3a 08 80 00 00 	movabs $0x80083a,%rax
  800fd8:	00 00 00 
  800fdb:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800fdd:	eb 3f                	jmp    80101e <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fdf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fe3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe7:	48 89 d6             	mov    %rdx,%rsi
  800fea:	89 df                	mov    %ebx,%edi
  800fec:	ff d0                	callq  *%rax
			break;
  800fee:	eb 2e                	jmp    80101e <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ff0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ff4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ff8:	48 89 d6             	mov    %rdx,%rsi
  800ffb:	bf 25 00 00 00       	mov    $0x25,%edi
  801000:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  801002:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801007:	eb 05                	jmp    80100e <vprintfmt+0x4f9>
  801009:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80100e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801012:	48 83 e8 01          	sub    $0x1,%rax
  801016:	0f b6 00             	movzbl (%rax),%eax
  801019:	3c 25                	cmp    $0x25,%al
  80101b:	75 ec                	jne    801009 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  80101d:	90                   	nop
		}
	}
  80101e:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80101f:	e9 43 fb ff ff       	jmpq   800b67 <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  801024:	48 83 c4 60          	add    $0x60,%rsp
  801028:	5b                   	pop    %rbx
  801029:	41 5c                	pop    %r12
  80102b:	5d                   	pop    %rbp
  80102c:	c3                   	retq   

000000000080102d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80102d:	55                   	push   %rbp
  80102e:	48 89 e5             	mov    %rsp,%rbp
  801031:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801038:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80103f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801046:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80104d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801054:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80105b:	84 c0                	test   %al,%al
  80105d:	74 20                	je     80107f <printfmt+0x52>
  80105f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801063:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801067:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80106b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80106f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801073:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801077:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80107b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80107f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801086:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80108d:	00 00 00 
  801090:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801097:	00 00 00 
  80109a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80109e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010a5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010ac:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010b3:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010ba:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010c1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010c8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010cf:	48 89 c7             	mov    %rax,%rdi
  8010d2:	48 b8 15 0b 80 00 00 	movabs $0x800b15,%rax
  8010d9:	00 00 00 
  8010dc:	ff d0                	callq  *%rax
	va_end(ap);
}
  8010de:	c9                   	leaveq 
  8010df:	c3                   	retq   

00000000008010e0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010e0:	55                   	push   %rbp
  8010e1:	48 89 e5             	mov    %rsp,%rbp
  8010e4:	48 83 ec 10          	sub    $0x10,%rsp
  8010e8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8010eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8010ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f3:	8b 40 10             	mov    0x10(%rax),%eax
  8010f6:	8d 50 01             	lea    0x1(%rax),%edx
  8010f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010fd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801100:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801104:	48 8b 10             	mov    (%rax),%rdx
  801107:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80110f:	48 39 c2             	cmp    %rax,%rdx
  801112:	73 17                	jae    80112b <sprintputch+0x4b>
		*b->buf++ = ch;
  801114:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801118:	48 8b 00             	mov    (%rax),%rax
  80111b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80111f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801123:	48 89 0a             	mov    %rcx,(%rdx)
  801126:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801129:	88 10                	mov    %dl,(%rax)
}
  80112b:	c9                   	leaveq 
  80112c:	c3                   	retq   

000000000080112d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80112d:	55                   	push   %rbp
  80112e:	48 89 e5             	mov    %rsp,%rbp
  801131:	48 83 ec 50          	sub    $0x50,%rsp
  801135:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801139:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80113c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801140:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801144:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801148:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80114c:	48 8b 0a             	mov    (%rdx),%rcx
  80114f:	48 89 08             	mov    %rcx,(%rax)
  801152:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801156:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80115a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80115e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801162:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801166:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80116a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80116d:	48 98                	cltq   
  80116f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801173:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801177:	48 01 d0             	add    %rdx,%rax
  80117a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80117e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801185:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80118a:	74 06                	je     801192 <vsnprintf+0x65>
  80118c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801190:	7f 07                	jg     801199 <vsnprintf+0x6c>
		return -E_INVAL;
  801192:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801197:	eb 2f                	jmp    8011c8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801199:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80119d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011a1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011a5:	48 89 c6             	mov    %rax,%rsi
  8011a8:	48 bf e0 10 80 00 00 	movabs $0x8010e0,%rdi
  8011af:	00 00 00 
  8011b2:	48 b8 15 0b 80 00 00 	movabs $0x800b15,%rax
  8011b9:	00 00 00 
  8011bc:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011c2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011c5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011c8:	c9                   	leaveq 
  8011c9:	c3                   	retq   

00000000008011ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011ca:	55                   	push   %rbp
  8011cb:	48 89 e5             	mov    %rsp,%rbp
  8011ce:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011d5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8011dc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8011e2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8011e9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8011f0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8011f7:	84 c0                	test   %al,%al
  8011f9:	74 20                	je     80121b <snprintf+0x51>
  8011fb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8011ff:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801203:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801207:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80120b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80120f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801213:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801217:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80121b:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801222:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801229:	00 00 00 
  80122c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801233:	00 00 00 
  801236:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80123a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801241:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801248:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80124f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801256:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80125d:	48 8b 0a             	mov    (%rdx),%rcx
  801260:	48 89 08             	mov    %rcx,(%rax)
  801263:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801267:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80126b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80126f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801273:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80127a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801281:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801287:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80128e:	48 89 c7             	mov    %rax,%rdi
  801291:	48 b8 2d 11 80 00 00 	movabs $0x80112d,%rax
  801298:	00 00 00 
  80129b:	ff d0                	callq  *%rax
  80129d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012a3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012a9:	c9                   	leaveq 
  8012aa:	c3                   	retq   

00000000008012ab <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012ab:	55                   	push   %rbp
  8012ac:	48 89 e5             	mov    %rsp,%rbp
  8012af:	48 83 ec 18          	sub    $0x18,%rsp
  8012b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012be:	eb 09                	jmp    8012c9 <strlen+0x1e>
		n++;
  8012c0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cd:	0f b6 00             	movzbl (%rax),%eax
  8012d0:	84 c0                	test   %al,%al
  8012d2:	75 ec                	jne    8012c0 <strlen+0x15>
		n++;
	return n;
  8012d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012d7:	c9                   	leaveq 
  8012d8:	c3                   	retq   

00000000008012d9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012d9:	55                   	push   %rbp
  8012da:	48 89 e5             	mov    %rsp,%rbp
  8012dd:	48 83 ec 20          	sub    $0x20,%rsp
  8012e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012f0:	eb 0e                	jmp    801300 <strnlen+0x27>
		n++;
  8012f2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8012fb:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801300:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801305:	74 0b                	je     801312 <strnlen+0x39>
  801307:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130b:	0f b6 00             	movzbl (%rax),%eax
  80130e:	84 c0                	test   %al,%al
  801310:	75 e0                	jne    8012f2 <strnlen+0x19>
		n++;
	return n;
  801312:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801315:	c9                   	leaveq 
  801316:	c3                   	retq   

0000000000801317 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801317:	55                   	push   %rbp
  801318:	48 89 e5             	mov    %rsp,%rbp
  80131b:	48 83 ec 20          	sub    $0x20,%rsp
  80131f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801323:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80132f:	90                   	nop
  801330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801334:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801338:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80133c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801340:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801344:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801348:	0f b6 12             	movzbl (%rdx),%edx
  80134b:	88 10                	mov    %dl,(%rax)
  80134d:	0f b6 00             	movzbl (%rax),%eax
  801350:	84 c0                	test   %al,%al
  801352:	75 dc                	jne    801330 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801354:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801358:	c9                   	leaveq 
  801359:	c3                   	retq   

000000000080135a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80135a:	55                   	push   %rbp
  80135b:	48 89 e5             	mov    %rsp,%rbp
  80135e:	48 83 ec 20          	sub    $0x20,%rsp
  801362:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801366:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80136a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136e:	48 89 c7             	mov    %rax,%rdi
  801371:	48 b8 ab 12 80 00 00 	movabs $0x8012ab,%rax
  801378:	00 00 00 
  80137b:	ff d0                	callq  *%rax
  80137d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801383:	48 63 d0             	movslq %eax,%rdx
  801386:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138a:	48 01 c2             	add    %rax,%rdx
  80138d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801391:	48 89 c6             	mov    %rax,%rsi
  801394:	48 89 d7             	mov    %rdx,%rdi
  801397:	48 b8 17 13 80 00 00 	movabs $0x801317,%rax
  80139e:	00 00 00 
  8013a1:	ff d0                	callq  *%rax
	return dst;
  8013a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013a7:	c9                   	leaveq 
  8013a8:	c3                   	retq   

00000000008013a9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013a9:	55                   	push   %rbp
  8013aa:	48 89 e5             	mov    %rsp,%rbp
  8013ad:	48 83 ec 28          	sub    $0x28,%rsp
  8013b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8013bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8013c5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8013cc:	00 
  8013cd:	eb 2a                	jmp    8013f9 <strncpy+0x50>
		*dst++ = *src;
  8013cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013db:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013df:	0f b6 12             	movzbl (%rdx),%edx
  8013e2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013e8:	0f b6 00             	movzbl (%rax),%eax
  8013eb:	84 c0                	test   %al,%al
  8013ed:	74 05                	je     8013f4 <strncpy+0x4b>
			src++;
  8013ef:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013f4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801401:	72 cc                	jb     8013cf <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801403:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801407:	c9                   	leaveq 
  801408:	c3                   	retq   

0000000000801409 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801409:	55                   	push   %rbp
  80140a:	48 89 e5             	mov    %rsp,%rbp
  80140d:	48 83 ec 28          	sub    $0x28,%rsp
  801411:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801415:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801419:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80141d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801421:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801425:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80142a:	74 3d                	je     801469 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80142c:	eb 1d                	jmp    80144b <strlcpy+0x42>
			*dst++ = *src++;
  80142e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801432:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801436:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80143a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80143e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801442:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801446:	0f b6 12             	movzbl (%rdx),%edx
  801449:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80144b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801450:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801455:	74 0b                	je     801462 <strlcpy+0x59>
  801457:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80145b:	0f b6 00             	movzbl (%rax),%eax
  80145e:	84 c0                	test   %al,%al
  801460:	75 cc                	jne    80142e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801462:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801466:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801469:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80146d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801471:	48 29 c2             	sub    %rax,%rdx
  801474:	48 89 d0             	mov    %rdx,%rax
}
  801477:	c9                   	leaveq 
  801478:	c3                   	retq   

0000000000801479 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801479:	55                   	push   %rbp
  80147a:	48 89 e5             	mov    %rsp,%rbp
  80147d:	48 83 ec 10          	sub    $0x10,%rsp
  801481:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801485:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801489:	eb 0a                	jmp    801495 <strcmp+0x1c>
		p++, q++;
  80148b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801490:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801499:	0f b6 00             	movzbl (%rax),%eax
  80149c:	84 c0                	test   %al,%al
  80149e:	74 12                	je     8014b2 <strcmp+0x39>
  8014a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a4:	0f b6 10             	movzbl (%rax),%edx
  8014a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ab:	0f b6 00             	movzbl (%rax),%eax
  8014ae:	38 c2                	cmp    %al,%dl
  8014b0:	74 d9                	je     80148b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b6:	0f b6 00             	movzbl (%rax),%eax
  8014b9:	0f b6 d0             	movzbl %al,%edx
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	0f b6 00             	movzbl (%rax),%eax
  8014c3:	0f b6 c0             	movzbl %al,%eax
  8014c6:	29 c2                	sub    %eax,%edx
  8014c8:	89 d0                	mov    %edx,%eax
}
  8014ca:	c9                   	leaveq 
  8014cb:	c3                   	retq   

00000000008014cc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014cc:	55                   	push   %rbp
  8014cd:	48 89 e5             	mov    %rsp,%rbp
  8014d0:	48 83 ec 18          	sub    $0x18,%rsp
  8014d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8014e0:	eb 0f                	jmp    8014f1 <strncmp+0x25>
		n--, p++, q++;
  8014e2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8014e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014ec:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014f1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014f6:	74 1d                	je     801515 <strncmp+0x49>
  8014f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	84 c0                	test   %al,%al
  801501:	74 12                	je     801515 <strncmp+0x49>
  801503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801507:	0f b6 10             	movzbl (%rax),%edx
  80150a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150e:	0f b6 00             	movzbl (%rax),%eax
  801511:	38 c2                	cmp    %al,%dl
  801513:	74 cd                	je     8014e2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801515:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80151a:	75 07                	jne    801523 <strncmp+0x57>
		return 0;
  80151c:	b8 00 00 00 00       	mov    $0x0,%eax
  801521:	eb 18                	jmp    80153b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801523:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801527:	0f b6 00             	movzbl (%rax),%eax
  80152a:	0f b6 d0             	movzbl %al,%edx
  80152d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801531:	0f b6 00             	movzbl (%rax),%eax
  801534:	0f b6 c0             	movzbl %al,%eax
  801537:	29 c2                	sub    %eax,%edx
  801539:	89 d0                	mov    %edx,%eax
}
  80153b:	c9                   	leaveq 
  80153c:	c3                   	retq   

000000000080153d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80153d:	55                   	push   %rbp
  80153e:	48 89 e5             	mov    %rsp,%rbp
  801541:	48 83 ec 0c          	sub    $0xc,%rsp
  801545:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801549:	89 f0                	mov    %esi,%eax
  80154b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80154e:	eb 17                	jmp    801567 <strchr+0x2a>
		if (*s == c)
  801550:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801554:	0f b6 00             	movzbl (%rax),%eax
  801557:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80155a:	75 06                	jne    801562 <strchr+0x25>
			return (char *) s;
  80155c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801560:	eb 15                	jmp    801577 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801562:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156b:	0f b6 00             	movzbl (%rax),%eax
  80156e:	84 c0                	test   %al,%al
  801570:	75 de                	jne    801550 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801572:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801577:	c9                   	leaveq 
  801578:	c3                   	retq   

0000000000801579 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801579:	55                   	push   %rbp
  80157a:	48 89 e5             	mov    %rsp,%rbp
  80157d:	48 83 ec 0c          	sub    $0xc,%rsp
  801581:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801585:	89 f0                	mov    %esi,%eax
  801587:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80158a:	eb 13                	jmp    80159f <strfind+0x26>
		if (*s == c)
  80158c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801596:	75 02                	jne    80159a <strfind+0x21>
			break;
  801598:	eb 10                	jmp    8015aa <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80159a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80159f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	84 c0                	test   %al,%al
  8015a8:	75 e2                	jne    80158c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8015aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015ae:	c9                   	leaveq 
  8015af:	c3                   	retq   

00000000008015b0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8015b0:	55                   	push   %rbp
  8015b1:	48 89 e5             	mov    %rsp,%rbp
  8015b4:	48 83 ec 18          	sub    $0x18,%rsp
  8015b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015bc:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8015bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8015c3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015c8:	75 06                	jne    8015d0 <memset+0x20>
		return v;
  8015ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ce:	eb 69                	jmp    801639 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8015d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d4:	83 e0 03             	and    $0x3,%eax
  8015d7:	48 85 c0             	test   %rax,%rax
  8015da:	75 48                	jne    801624 <memset+0x74>
  8015dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e0:	83 e0 03             	and    $0x3,%eax
  8015e3:	48 85 c0             	test   %rax,%rax
  8015e6:	75 3c                	jne    801624 <memset+0x74>
		c &= 0xFF;
  8015e8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8015ef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015f2:	c1 e0 18             	shl    $0x18,%eax
  8015f5:	89 c2                	mov    %eax,%edx
  8015f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8015fa:	c1 e0 10             	shl    $0x10,%eax
  8015fd:	09 c2                	or     %eax,%edx
  8015ff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801602:	c1 e0 08             	shl    $0x8,%eax
  801605:	09 d0                	or     %edx,%eax
  801607:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80160a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160e:	48 c1 e8 02          	shr    $0x2,%rax
  801612:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801615:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801619:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80161c:	48 89 d7             	mov    %rdx,%rdi
  80161f:	fc                   	cld    
  801620:	f3 ab                	rep stos %eax,%es:(%rdi)
  801622:	eb 11                	jmp    801635 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801624:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801628:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80162b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80162f:	48 89 d7             	mov    %rdx,%rdi
  801632:	fc                   	cld    
  801633:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801635:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801639:	c9                   	leaveq 
  80163a:	c3                   	retq   

000000000080163b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80163b:	55                   	push   %rbp
  80163c:	48 89 e5             	mov    %rsp,%rbp
  80163f:	48 83 ec 28          	sub    $0x28,%rsp
  801643:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801647:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80164b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80164f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801653:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801657:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80165b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80165f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801663:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801667:	0f 83 88 00 00 00    	jae    8016f5 <memmove+0xba>
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801675:	48 01 d0             	add    %rdx,%rax
  801678:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80167c:	76 77                	jbe    8016f5 <memmove+0xba>
		s += n;
  80167e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801682:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801686:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80168e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801692:	83 e0 03             	and    $0x3,%eax
  801695:	48 85 c0             	test   %rax,%rax
  801698:	75 3b                	jne    8016d5 <memmove+0x9a>
  80169a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169e:	83 e0 03             	and    $0x3,%eax
  8016a1:	48 85 c0             	test   %rax,%rax
  8016a4:	75 2f                	jne    8016d5 <memmove+0x9a>
  8016a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016aa:	83 e0 03             	and    $0x3,%eax
  8016ad:	48 85 c0             	test   %rax,%rax
  8016b0:	75 23                	jne    8016d5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b6:	48 83 e8 04          	sub    $0x4,%rax
  8016ba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016be:	48 83 ea 04          	sub    $0x4,%rdx
  8016c2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016c6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016ca:	48 89 c7             	mov    %rax,%rdi
  8016cd:	48 89 d6             	mov    %rdx,%rsi
  8016d0:	fd                   	std    
  8016d1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016d3:	eb 1d                	jmp    8016f2 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e9:	48 89 d7             	mov    %rdx,%rdi
  8016ec:	48 89 c1             	mov    %rax,%rcx
  8016ef:	fd                   	std    
  8016f0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016f2:	fc                   	cld    
  8016f3:	eb 57                	jmp    80174c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f9:	83 e0 03             	and    $0x3,%eax
  8016fc:	48 85 c0             	test   %rax,%rax
  8016ff:	75 36                	jne    801737 <memmove+0xfc>
  801701:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801705:	83 e0 03             	and    $0x3,%eax
  801708:	48 85 c0             	test   %rax,%rax
  80170b:	75 2a                	jne    801737 <memmove+0xfc>
  80170d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801711:	83 e0 03             	and    $0x3,%eax
  801714:	48 85 c0             	test   %rax,%rax
  801717:	75 1e                	jne    801737 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801719:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171d:	48 c1 e8 02          	shr    $0x2,%rax
  801721:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801728:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80172c:	48 89 c7             	mov    %rax,%rdi
  80172f:	48 89 d6             	mov    %rdx,%rsi
  801732:	fc                   	cld    
  801733:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801735:	eb 15                	jmp    80174c <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801737:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80173b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80173f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801743:	48 89 c7             	mov    %rax,%rdi
  801746:	48 89 d6             	mov    %rdx,%rsi
  801749:	fc                   	cld    
  80174a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80174c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801750:	c9                   	leaveq 
  801751:	c3                   	retq   

0000000000801752 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801752:	55                   	push   %rbp
  801753:	48 89 e5             	mov    %rsp,%rbp
  801756:	48 83 ec 18          	sub    $0x18,%rsp
  80175a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80175e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801762:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80176a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80176e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801772:	48 89 ce             	mov    %rcx,%rsi
  801775:	48 89 c7             	mov    %rax,%rdi
  801778:	48 b8 3b 16 80 00 00 	movabs $0x80163b,%rax
  80177f:	00 00 00 
  801782:	ff d0                	callq  *%rax
}
  801784:	c9                   	leaveq 
  801785:	c3                   	retq   

0000000000801786 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801786:	55                   	push   %rbp
  801787:	48 89 e5             	mov    %rsp,%rbp
  80178a:	48 83 ec 28          	sub    $0x28,%rsp
  80178e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801792:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801796:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80179a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80179e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8017a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017a6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8017aa:	eb 36                	jmp    8017e2 <memcmp+0x5c>
		if (*s1 != *s2)
  8017ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017b0:	0f b6 10             	movzbl (%rax),%edx
  8017b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b7:	0f b6 00             	movzbl (%rax),%eax
  8017ba:	38 c2                	cmp    %al,%dl
  8017bc:	74 1a                	je     8017d8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8017be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017c2:	0f b6 00             	movzbl (%rax),%eax
  8017c5:	0f b6 d0             	movzbl %al,%edx
  8017c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017cc:	0f b6 00             	movzbl (%rax),%eax
  8017cf:	0f b6 c0             	movzbl %al,%eax
  8017d2:	29 c2                	sub    %eax,%edx
  8017d4:	89 d0                	mov    %edx,%eax
  8017d6:	eb 20                	jmp    8017f8 <memcmp+0x72>
		s1++, s2++;
  8017d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8017dd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017ee:	48 85 c0             	test   %rax,%rax
  8017f1:	75 b9                	jne    8017ac <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f8:	c9                   	leaveq 
  8017f9:	c3                   	retq   

00000000008017fa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8017fa:	55                   	push   %rbp
  8017fb:	48 89 e5             	mov    %rsp,%rbp
  8017fe:	48 83 ec 28          	sub    $0x28,%rsp
  801802:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801806:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801809:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80180d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801811:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801815:	48 01 d0             	add    %rdx,%rax
  801818:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80181c:	eb 15                	jmp    801833 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80181e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801822:	0f b6 10             	movzbl (%rax),%edx
  801825:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801828:	38 c2                	cmp    %al,%dl
  80182a:	75 02                	jne    80182e <memfind+0x34>
			break;
  80182c:	eb 0f                	jmp    80183d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80182e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801833:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801837:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80183b:	72 e1                	jb     80181e <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80183d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801841:	c9                   	leaveq 
  801842:	c3                   	retq   

0000000000801843 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801843:	55                   	push   %rbp
  801844:	48 89 e5             	mov    %rsp,%rbp
  801847:	48 83 ec 34          	sub    $0x34,%rsp
  80184b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80184f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801853:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801856:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80185d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801864:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801865:	eb 05                	jmp    80186c <strtol+0x29>
		s++;
  801867:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80186c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801870:	0f b6 00             	movzbl (%rax),%eax
  801873:	3c 20                	cmp    $0x20,%al
  801875:	74 f0                	je     801867 <strtol+0x24>
  801877:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80187b:	0f b6 00             	movzbl (%rax),%eax
  80187e:	3c 09                	cmp    $0x9,%al
  801880:	74 e5                	je     801867 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801882:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801886:	0f b6 00             	movzbl (%rax),%eax
  801889:	3c 2b                	cmp    $0x2b,%al
  80188b:	75 07                	jne    801894 <strtol+0x51>
		s++;
  80188d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801892:	eb 17                	jmp    8018ab <strtol+0x68>
	else if (*s == '-')
  801894:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801898:	0f b6 00             	movzbl (%rax),%eax
  80189b:	3c 2d                	cmp    $0x2d,%al
  80189d:	75 0c                	jne    8018ab <strtol+0x68>
		s++, neg = 1;
  80189f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018a4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8018ab:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018af:	74 06                	je     8018b7 <strtol+0x74>
  8018b1:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8018b5:	75 28                	jne    8018df <strtol+0x9c>
  8018b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bb:	0f b6 00             	movzbl (%rax),%eax
  8018be:	3c 30                	cmp    $0x30,%al
  8018c0:	75 1d                	jne    8018df <strtol+0x9c>
  8018c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c6:	48 83 c0 01          	add    $0x1,%rax
  8018ca:	0f b6 00             	movzbl (%rax),%eax
  8018cd:	3c 78                	cmp    $0x78,%al
  8018cf:	75 0e                	jne    8018df <strtol+0x9c>
		s += 2, base = 16;
  8018d1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8018d6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8018dd:	eb 2c                	jmp    80190b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8018df:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8018e3:	75 19                	jne    8018fe <strtol+0xbb>
  8018e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e9:	0f b6 00             	movzbl (%rax),%eax
  8018ec:	3c 30                	cmp    $0x30,%al
  8018ee:	75 0e                	jne    8018fe <strtol+0xbb>
		s++, base = 8;
  8018f0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018f5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8018fc:	eb 0d                	jmp    80190b <strtol+0xc8>
	else if (base == 0)
  8018fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801902:	75 07                	jne    80190b <strtol+0xc8>
		base = 10;
  801904:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80190b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190f:	0f b6 00             	movzbl (%rax),%eax
  801912:	3c 2f                	cmp    $0x2f,%al
  801914:	7e 1d                	jle    801933 <strtol+0xf0>
  801916:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80191a:	0f b6 00             	movzbl (%rax),%eax
  80191d:	3c 39                	cmp    $0x39,%al
  80191f:	7f 12                	jg     801933 <strtol+0xf0>
			dig = *s - '0';
  801921:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801925:	0f b6 00             	movzbl (%rax),%eax
  801928:	0f be c0             	movsbl %al,%eax
  80192b:	83 e8 30             	sub    $0x30,%eax
  80192e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801931:	eb 4e                	jmp    801981 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801933:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801937:	0f b6 00             	movzbl (%rax),%eax
  80193a:	3c 60                	cmp    $0x60,%al
  80193c:	7e 1d                	jle    80195b <strtol+0x118>
  80193e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801942:	0f b6 00             	movzbl (%rax),%eax
  801945:	3c 7a                	cmp    $0x7a,%al
  801947:	7f 12                	jg     80195b <strtol+0x118>
			dig = *s - 'a' + 10;
  801949:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80194d:	0f b6 00             	movzbl (%rax),%eax
  801950:	0f be c0             	movsbl %al,%eax
  801953:	83 e8 57             	sub    $0x57,%eax
  801956:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801959:	eb 26                	jmp    801981 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80195b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80195f:	0f b6 00             	movzbl (%rax),%eax
  801962:	3c 40                	cmp    $0x40,%al
  801964:	7e 48                	jle    8019ae <strtol+0x16b>
  801966:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196a:	0f b6 00             	movzbl (%rax),%eax
  80196d:	3c 5a                	cmp    $0x5a,%al
  80196f:	7f 3d                	jg     8019ae <strtol+0x16b>
			dig = *s - 'A' + 10;
  801971:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801975:	0f b6 00             	movzbl (%rax),%eax
  801978:	0f be c0             	movsbl %al,%eax
  80197b:	83 e8 37             	sub    $0x37,%eax
  80197e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801981:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801984:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801987:	7c 02                	jl     80198b <strtol+0x148>
			break;
  801989:	eb 23                	jmp    8019ae <strtol+0x16b>
		s++, val = (val * base) + dig;
  80198b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801990:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801993:	48 98                	cltq   
  801995:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80199a:	48 89 c2             	mov    %rax,%rdx
  80199d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019a0:	48 98                	cltq   
  8019a2:	48 01 d0             	add    %rdx,%rax
  8019a5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8019a9:	e9 5d ff ff ff       	jmpq   80190b <strtol+0xc8>

	if (endptr)
  8019ae:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8019b3:	74 0b                	je     8019c0 <strtol+0x17d>
		*endptr = (char *) s;
  8019b5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019b9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8019bd:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8019c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019c4:	74 09                	je     8019cf <strtol+0x18c>
  8019c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8019ca:	48 f7 d8             	neg    %rax
  8019cd:	eb 04                	jmp    8019d3 <strtol+0x190>
  8019cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019d3:	c9                   	leaveq 
  8019d4:	c3                   	retq   

00000000008019d5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8019d5:	55                   	push   %rbp
  8019d6:	48 89 e5             	mov    %rsp,%rbp
  8019d9:	48 83 ec 30          	sub    $0x30,%rsp
  8019dd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019e1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8019e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019e9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ed:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019f1:	0f b6 00             	movzbl (%rax),%eax
  8019f4:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8019f7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8019fb:	75 06                	jne    801a03 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8019fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a01:	eb 6b                	jmp    801a6e <strstr+0x99>

    len = strlen(str);
  801a03:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a07:	48 89 c7             	mov    %rax,%rdi
  801a0a:	48 b8 ab 12 80 00 00 	movabs $0x8012ab,%rax
  801a11:	00 00 00 
  801a14:	ff d0                	callq  *%rax
  801a16:	48 98                	cltq   
  801a18:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801a1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a20:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a24:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a28:	0f b6 00             	movzbl (%rax),%eax
  801a2b:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801a2e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a32:	75 07                	jne    801a3b <strstr+0x66>
                return (char *) 0;
  801a34:	b8 00 00 00 00       	mov    $0x0,%eax
  801a39:	eb 33                	jmp    801a6e <strstr+0x99>
        } while (sc != c);
  801a3b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801a3f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801a42:	75 d8                	jne    801a1c <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801a44:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a48:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801a4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a50:	48 89 ce             	mov    %rcx,%rsi
  801a53:	48 89 c7             	mov    %rax,%rdi
  801a56:	48 b8 cc 14 80 00 00 	movabs $0x8014cc,%rax
  801a5d:	00 00 00 
  801a60:	ff d0                	callq  *%rax
  801a62:	85 c0                	test   %eax,%eax
  801a64:	75 b6                	jne    801a1c <strstr+0x47>

    return (char *) (in - 1);
  801a66:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6a:	48 83 e8 01          	sub    $0x1,%rax
}
  801a6e:	c9                   	leaveq 
  801a6f:	c3                   	retq   
