
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
  800067:	48 b8 a4 01 80 00 00 	movabs $0x8001a4,%rax
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
  800079:	48 83 ec 10          	sub    $0x10,%rsp
  80007d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800080:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  800084:	48 b8 70 02 80 00 00 	movabs $0x800270,%rax
  80008b:	00 00 00 
  80008e:	ff d0                	callq  *%rax
  800090:	25 ff 03 00 00       	and    $0x3ff,%eax
  800095:	48 98                	cltq   
  800097:	48 c1 e0 03          	shl    $0x3,%rax
  80009b:	48 89 c2             	mov    %rax,%rdx
  80009e:	48 c1 e2 05          	shl    $0x5,%rdx
  8000a2:	48 29 c2             	sub    %rax,%rdx
  8000a5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000ac:	00 00 00 
  8000af:	48 01 c2             	add    %rax,%rdx
  8000b2:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8000b9:	00 00 00 
  8000bc:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c3:	7e 14                	jle    8000d9 <libmain+0x64>
		binaryname = argv[0];
  8000c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000c9:	48 8b 10             	mov    (%rax),%rdx
  8000cc:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000d3:	00 00 00 
  8000d6:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e0:	48 89 d6             	mov    %rdx,%rsi
  8000e3:	89 c7                	mov    %eax,%edi
  8000e5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ec:	00 00 00 
  8000ef:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f1:	48 b8 ff 00 80 00 00 	movabs $0x8000ff,%rax
  8000f8:	00 00 00 
  8000fb:	ff d0                	callq  *%rax
}
  8000fd:	c9                   	leaveq 
  8000fe:	c3                   	retq   

00000000008000ff <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ff:	55                   	push   %rbp
  800100:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800103:	bf 00 00 00 00       	mov    $0x0,%edi
  800108:	48 b8 2c 02 80 00 00 	movabs $0x80022c,%rax
  80010f:	00 00 00 
  800112:	ff d0                	callq  *%rax
}
  800114:	5d                   	pop    %rbp
  800115:	c3                   	retq   

0000000000800116 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  800116:	55                   	push   %rbp
  800117:	48 89 e5             	mov    %rsp,%rbp
  80011a:	53                   	push   %rbx
  80011b:	48 83 ec 48          	sub    $0x48,%rsp
  80011f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800122:	89 75 d8             	mov    %esi,-0x28(%rbp)
  800125:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800129:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80012d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  800131:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800135:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800138:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80013c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800140:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  800144:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800148:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80014c:	4c 89 c3             	mov    %r8,%rbx
  80014f:	cd 30                	int    $0x30
  800151:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800155:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800159:	74 3e                	je     800199 <syscall+0x83>
  80015b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800160:	7e 37                	jle    800199 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800162:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800166:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800169:	49 89 d0             	mov    %rdx,%r8
  80016c:	89 c1                	mov    %eax,%ecx
  80016e:	48 ba 38 18 80 00 00 	movabs $0x801838,%rdx
  800175:	00 00 00 
  800178:	be 23 00 00 00       	mov    $0x23,%esi
  80017d:	48 bf 55 18 80 00 00 	movabs $0x801855,%rdi
  800184:	00 00 00 
  800187:	b8 00 00 00 00       	mov    $0x0,%eax
  80018c:	49 b9 ae 02 80 00 00 	movabs $0x8002ae,%r9
  800193:	00 00 00 
  800196:	41 ff d1             	callq  *%r9

	return ret;
  800199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80019d:	48 83 c4 48          	add    $0x48,%rsp
  8001a1:	5b                   	pop    %rbx
  8001a2:	5d                   	pop    %rbp
  8001a3:	c3                   	retq   

00000000008001a4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001a4:	55                   	push   %rbp
  8001a5:	48 89 e5             	mov    %rsp,%rbp
  8001a8:	48 83 ec 20          	sub    $0x20,%rsp
  8001ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001b8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001bc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001c3:	00 
  8001c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001ca:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d0:	48 89 d1             	mov    %rdx,%rcx
  8001d3:	48 89 c2             	mov    %rax,%rdx
  8001d6:	be 00 00 00 00       	mov    $0x0,%esi
  8001db:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e0:	48 b8 16 01 80 00 00 	movabs $0x800116,%rax
  8001e7:	00 00 00 
  8001ea:	ff d0                	callq  *%rax
}
  8001ec:	c9                   	leaveq 
  8001ed:	c3                   	retq   

00000000008001ee <sys_cgetc>:

int
sys_cgetc(void)
{
  8001ee:	55                   	push   %rbp
  8001ef:	48 89 e5             	mov    %rsp,%rbp
  8001f2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8001fd:	00 
  8001fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800204:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80020a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80020f:	ba 00 00 00 00       	mov    $0x0,%edx
  800214:	be 00 00 00 00       	mov    $0x0,%esi
  800219:	bf 01 00 00 00       	mov    $0x1,%edi
  80021e:	48 b8 16 01 80 00 00 	movabs $0x800116,%rax
  800225:	00 00 00 
  800228:	ff d0                	callq  *%rax
}
  80022a:	c9                   	leaveq 
  80022b:	c3                   	retq   

000000000080022c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	48 83 ec 10          	sub    $0x10,%rsp
  800234:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800237:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80023a:	48 98                	cltq   
  80023c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  800243:	00 
  800244:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80024a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800250:	b9 00 00 00 00       	mov    $0x0,%ecx
  800255:	48 89 c2             	mov    %rax,%rdx
  800258:	be 01 00 00 00       	mov    $0x1,%esi
  80025d:	bf 03 00 00 00       	mov    $0x3,%edi
  800262:	48 b8 16 01 80 00 00 	movabs $0x800116,%rax
  800269:	00 00 00 
  80026c:	ff d0                	callq  *%rax
}
  80026e:	c9                   	leaveq 
  80026f:	c3                   	retq   

0000000000800270 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800270:	55                   	push   %rbp
  800271:	48 89 e5             	mov    %rsp,%rbp
  800274:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800278:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80027f:	00 
  800280:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800286:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80028c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800291:	ba 00 00 00 00       	mov    $0x0,%edx
  800296:	be 00 00 00 00       	mov    $0x0,%esi
  80029b:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a0:	48 b8 16 01 80 00 00 	movabs $0x800116,%rax
  8002a7:	00 00 00 
  8002aa:	ff d0                	callq  *%rax
}
  8002ac:	c9                   	leaveq 
  8002ad:	c3                   	retq   

00000000008002ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002ae:	55                   	push   %rbp
  8002af:	48 89 e5             	mov    %rsp,%rbp
  8002b2:	53                   	push   %rbx
  8002b3:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8002ba:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8002c1:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8002c7:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8002ce:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8002d5:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8002dc:	84 c0                	test   %al,%al
  8002de:	74 23                	je     800303 <_panic+0x55>
  8002e0:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002e7:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002eb:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002ef:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002f3:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002f7:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002fb:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002ff:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800303:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80030a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800311:	00 00 00 
  800314:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80031b:	00 00 00 
  80031e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800322:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800329:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800330:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800337:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80033e:	00 00 00 
  800341:	48 8b 18             	mov    (%rax),%rbx
  800344:	48 b8 70 02 80 00 00 	movabs $0x800270,%rax
  80034b:	00 00 00 
  80034e:	ff d0                	callq  *%rax
  800350:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800356:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80035d:	41 89 c8             	mov    %ecx,%r8d
  800360:	48 89 d1             	mov    %rdx,%rcx
  800363:	48 89 da             	mov    %rbx,%rdx
  800366:	89 c6                	mov    %eax,%esi
  800368:	48 bf 68 18 80 00 00 	movabs $0x801868,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	49 b9 e7 04 80 00 00 	movabs $0x8004e7,%r9
  80037e:	00 00 00 
  800381:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800384:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80038b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800392:	48 89 d6             	mov    %rdx,%rsi
  800395:	48 89 c7             	mov    %rax,%rdi
  800398:	48 b8 3b 04 80 00 00 	movabs $0x80043b,%rax
  80039f:	00 00 00 
  8003a2:	ff d0                	callq  *%rax
	cprintf("\n");
  8003a4:	48 bf 8b 18 80 00 00 	movabs $0x80188b,%rdi
  8003ab:	00 00 00 
  8003ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b3:	48 ba e7 04 80 00 00 	movabs $0x8004e7,%rdx
  8003ba:	00 00 00 
  8003bd:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003bf:	cc                   	int3   
  8003c0:	eb fd                	jmp    8003bf <_panic+0x111>

00000000008003c2 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8003c2:	55                   	push   %rbp
  8003c3:	48 89 e5             	mov    %rsp,%rbp
  8003c6:	48 83 ec 10          	sub    $0x10,%rsp
  8003ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8003d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d5:	8b 00                	mov    (%rax),%eax
  8003d7:	8d 48 01             	lea    0x1(%rax),%ecx
  8003da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003de:	89 0a                	mov    %ecx,(%rdx)
  8003e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8003e3:	89 d1                	mov    %edx,%ecx
  8003e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003e9:	48 98                	cltq   
  8003eb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f3:	8b 00                	mov    (%rax),%eax
  8003f5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003fa:	75 2c                	jne    800428 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800400:	8b 00                	mov    (%rax),%eax
  800402:	48 98                	cltq   
  800404:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800408:	48 83 c2 08          	add    $0x8,%rdx
  80040c:	48 89 c6             	mov    %rax,%rsi
  80040f:	48 89 d7             	mov    %rdx,%rdi
  800412:	48 b8 a4 01 80 00 00 	movabs $0x8001a4,%rax
  800419:	00 00 00 
  80041c:	ff d0                	callq  *%rax
        b->idx = 0;
  80041e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800422:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800428:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042c:	8b 40 04             	mov    0x4(%rax),%eax
  80042f:	8d 50 01             	lea    0x1(%rax),%edx
  800432:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800436:	89 50 04             	mov    %edx,0x4(%rax)
}
  800439:	c9                   	leaveq 
  80043a:	c3                   	retq   

000000000080043b <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80043b:	55                   	push   %rbp
  80043c:	48 89 e5             	mov    %rsp,%rbp
  80043f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800446:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80044d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800454:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80045b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800462:	48 8b 0a             	mov    (%rdx),%rcx
  800465:	48 89 08             	mov    %rcx,(%rax)
  800468:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80046c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800470:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800474:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800478:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80047f:	00 00 00 
    b.cnt = 0;
  800482:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800489:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80048c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800493:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80049a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004a1:	48 89 c6             	mov    %rax,%rsi
  8004a4:	48 bf c2 03 80 00 00 	movabs $0x8003c2,%rdi
  8004ab:	00 00 00 
  8004ae:	48 b8 9a 08 80 00 00 	movabs $0x80089a,%rax
  8004b5:	00 00 00 
  8004b8:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8004ba:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8004c0:	48 98                	cltq   
  8004c2:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8004c9:	48 83 c2 08          	add    $0x8,%rdx
  8004cd:	48 89 c6             	mov    %rax,%rsi
  8004d0:	48 89 d7             	mov    %rdx,%rdi
  8004d3:	48 b8 a4 01 80 00 00 	movabs $0x8001a4,%rax
  8004da:	00 00 00 
  8004dd:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8004df:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8004e5:	c9                   	leaveq 
  8004e6:	c3                   	retq   

00000000008004e7 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004e7:	55                   	push   %rbp
  8004e8:	48 89 e5             	mov    %rsp,%rbp
  8004eb:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004f2:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004f9:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800500:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800507:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80050e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800515:	84 c0                	test   %al,%al
  800517:	74 20                	je     800539 <cprintf+0x52>
  800519:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80051d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800521:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800525:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800529:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80052d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800531:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800535:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800539:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800540:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800547:	00 00 00 
  80054a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800551:	00 00 00 
  800554:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800558:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80055f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800566:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80056d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800574:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80057b:	48 8b 0a             	mov    (%rdx),%rcx
  80057e:	48 89 08             	mov    %rcx,(%rax)
  800581:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800585:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800589:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80058d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800591:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800598:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80059f:	48 89 d6             	mov    %rdx,%rsi
  8005a2:	48 89 c7             	mov    %rax,%rdi
  8005a5:	48 b8 3b 04 80 00 00 	movabs $0x80043b,%rax
  8005ac:	00 00 00 
  8005af:	ff d0                	callq  *%rax
  8005b1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8005b7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8005bd:	c9                   	leaveq 
  8005be:	c3                   	retq   

00000000008005bf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005bf:	55                   	push   %rbp
  8005c0:	48 89 e5             	mov    %rsp,%rbp
  8005c3:	53                   	push   %rbx
  8005c4:	48 83 ec 38          	sub    $0x38,%rsp
  8005c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8005d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8005d4:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8005d7:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8005db:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005df:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8005e2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005e6:	77 3b                	ja     800623 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005e8:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005eb:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005ef:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fb:	48 f7 f3             	div    %rbx
  8005fe:	48 89 c2             	mov    %rax,%rdx
  800601:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800604:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800607:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80060b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060f:	41 89 f9             	mov    %edi,%r9d
  800612:	48 89 c7             	mov    %rax,%rdi
  800615:	48 b8 bf 05 80 00 00 	movabs $0x8005bf,%rax
  80061c:	00 00 00 
  80061f:	ff d0                	callq  *%rax
  800621:	eb 1e                	jmp    800641 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800623:	eb 12                	jmp    800637 <printnum+0x78>
			putch(padc, putdat);
  800625:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800629:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80062c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800630:	48 89 ce             	mov    %rcx,%rsi
  800633:	89 d7                	mov    %edx,%edi
  800635:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800637:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80063b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80063f:	7f e4                	jg     800625 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800641:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800644:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800648:	ba 00 00 00 00       	mov    $0x0,%edx
  80064d:	48 f7 f1             	div    %rcx
  800650:	48 89 d0             	mov    %rdx,%rax
  800653:	48 ba d0 19 80 00 00 	movabs $0x8019d0,%rdx
  80065a:	00 00 00 
  80065d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800661:	0f be d0             	movsbl %al,%edx
  800664:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066c:	48 89 ce             	mov    %rcx,%rsi
  80066f:	89 d7                	mov    %edx,%edi
  800671:	ff d0                	callq  *%rax
}
  800673:	48 83 c4 38          	add    $0x38,%rsp
  800677:	5b                   	pop    %rbx
  800678:	5d                   	pop    %rbp
  800679:	c3                   	retq   

000000000080067a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067a:	55                   	push   %rbp
  80067b:	48 89 e5             	mov    %rsp,%rbp
  80067e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800682:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800686:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800689:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80068d:	7e 52                	jle    8006e1 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80068f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800693:	8b 00                	mov    (%rax),%eax
  800695:	83 f8 30             	cmp    $0x30,%eax
  800698:	73 24                	jae    8006be <getuint+0x44>
  80069a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a6:	8b 00                	mov    (%rax),%eax
  8006a8:	89 c0                	mov    %eax,%eax
  8006aa:	48 01 d0             	add    %rdx,%rax
  8006ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b1:	8b 12                	mov    (%rdx),%edx
  8006b3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ba:	89 0a                	mov    %ecx,(%rdx)
  8006bc:	eb 17                	jmp    8006d5 <getuint+0x5b>
  8006be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c6:	48 89 d0             	mov    %rdx,%rax
  8006c9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d5:	48 8b 00             	mov    (%rax),%rax
  8006d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006dc:	e9 a3 00 00 00       	jmpq   800784 <getuint+0x10a>
	else if (lflag)
  8006e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006e5:	74 4f                	je     800736 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006eb:	8b 00                	mov    (%rax),%eax
  8006ed:	83 f8 30             	cmp    $0x30,%eax
  8006f0:	73 24                	jae    800716 <getuint+0x9c>
  8006f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fe:	8b 00                	mov    (%rax),%eax
  800700:	89 c0                	mov    %eax,%eax
  800702:	48 01 d0             	add    %rdx,%rax
  800705:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800709:	8b 12                	mov    (%rdx),%edx
  80070b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800712:	89 0a                	mov    %ecx,(%rdx)
  800714:	eb 17                	jmp    80072d <getuint+0xb3>
  800716:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80071a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80071e:	48 89 d0             	mov    %rdx,%rax
  800721:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800725:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800729:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80072d:	48 8b 00             	mov    (%rax),%rax
  800730:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800734:	eb 4e                	jmp    800784 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073a:	8b 00                	mov    (%rax),%eax
  80073c:	83 f8 30             	cmp    $0x30,%eax
  80073f:	73 24                	jae    800765 <getuint+0xeb>
  800741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800745:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074d:	8b 00                	mov    (%rax),%eax
  80074f:	89 c0                	mov    %eax,%eax
  800751:	48 01 d0             	add    %rdx,%rax
  800754:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800758:	8b 12                	mov    (%rdx),%edx
  80075a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800761:	89 0a                	mov    %ecx,(%rdx)
  800763:	eb 17                	jmp    80077c <getuint+0x102>
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076d:	48 89 d0             	mov    %rdx,%rax
  800770:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800774:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800778:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077c:	8b 00                	mov    (%rax),%eax
  80077e:	89 c0                	mov    %eax,%eax
  800780:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800784:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800788:	c9                   	leaveq 
  800789:	c3                   	retq   

000000000080078a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80078a:	55                   	push   %rbp
  80078b:	48 89 e5             	mov    %rsp,%rbp
  80078e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800792:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800796:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800799:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80079d:	7e 52                	jle    8007f1 <getint+0x67>
		x=va_arg(*ap, long long);
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	8b 00                	mov    (%rax),%eax
  8007a5:	83 f8 30             	cmp    $0x30,%eax
  8007a8:	73 24                	jae    8007ce <getint+0x44>
  8007aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ae:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b6:	8b 00                	mov    (%rax),%eax
  8007b8:	89 c0                	mov    %eax,%eax
  8007ba:	48 01 d0             	add    %rdx,%rax
  8007bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c1:	8b 12                	mov    (%rdx),%edx
  8007c3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ca:	89 0a                	mov    %ecx,(%rdx)
  8007cc:	eb 17                	jmp    8007e5 <getint+0x5b>
  8007ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d6:	48 89 d0             	mov    %rdx,%rax
  8007d9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007e5:	48 8b 00             	mov    (%rax),%rax
  8007e8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007ec:	e9 a3 00 00 00       	jmpq   800894 <getint+0x10a>
	else if (lflag)
  8007f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007f5:	74 4f                	je     800846 <getint+0xbc>
		x=va_arg(*ap, long);
  8007f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fb:	8b 00                	mov    (%rax),%eax
  8007fd:	83 f8 30             	cmp    $0x30,%eax
  800800:	73 24                	jae    800826 <getint+0x9c>
  800802:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800806:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80080a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080e:	8b 00                	mov    (%rax),%eax
  800810:	89 c0                	mov    %eax,%eax
  800812:	48 01 d0             	add    %rdx,%rax
  800815:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800819:	8b 12                	mov    (%rdx),%edx
  80081b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80081e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800822:	89 0a                	mov    %ecx,(%rdx)
  800824:	eb 17                	jmp    80083d <getint+0xb3>
  800826:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80082a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80082e:	48 89 d0             	mov    %rdx,%rax
  800831:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800835:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800839:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80083d:	48 8b 00             	mov    (%rax),%rax
  800840:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800844:	eb 4e                	jmp    800894 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800846:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084a:	8b 00                	mov    (%rax),%eax
  80084c:	83 f8 30             	cmp    $0x30,%eax
  80084f:	73 24                	jae    800875 <getint+0xeb>
  800851:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800855:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800859:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085d:	8b 00                	mov    (%rax),%eax
  80085f:	89 c0                	mov    %eax,%eax
  800861:	48 01 d0             	add    %rdx,%rax
  800864:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800868:	8b 12                	mov    (%rdx),%edx
  80086a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80086d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800871:	89 0a                	mov    %ecx,(%rdx)
  800873:	eb 17                	jmp    80088c <getint+0x102>
  800875:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800879:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80087d:	48 89 d0             	mov    %rdx,%rax
  800880:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800884:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800888:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088c:	8b 00                	mov    (%rax),%eax
  80088e:	48 98                	cltq   
  800890:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800894:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800898:	c9                   	leaveq 
  800899:	c3                   	retq   

000000000080089a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80089a:	55                   	push   %rbp
  80089b:	48 89 e5             	mov    %rsp,%rbp
  80089e:	41 54                	push   %r12
  8008a0:	53                   	push   %rbx
  8008a1:	48 83 ec 60          	sub    $0x60,%rsp
  8008a5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008a9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008ad:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008b1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8008b5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8008b9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8008bd:	48 8b 0a             	mov    (%rdx),%rcx
  8008c0:	48 89 08             	mov    %rcx,(%rax)
  8008c3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008c7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008cb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008cf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d3:	eb 17                	jmp    8008ec <vprintfmt+0x52>
			if (ch == '\0')
  8008d5:	85 db                	test   %ebx,%ebx
  8008d7:	0f 84 df 04 00 00    	je     800dbc <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  8008dd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8008e1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e5:	48 89 d6             	mov    %rdx,%rsi
  8008e8:	89 df                	mov    %ebx,%edi
  8008ea:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ec:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008f0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008f4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008f8:	0f b6 00             	movzbl (%rax),%eax
  8008fb:	0f b6 d8             	movzbl %al,%ebx
  8008fe:	83 fb 25             	cmp    $0x25,%ebx
  800901:	75 d2                	jne    8008d5 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800903:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800907:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80090e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800915:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80091c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800923:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800927:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80092b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80092f:	0f b6 00             	movzbl (%rax),%eax
  800932:	0f b6 d8             	movzbl %al,%ebx
  800935:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800938:	83 f8 55             	cmp    $0x55,%eax
  80093b:	0f 87 47 04 00 00    	ja     800d88 <vprintfmt+0x4ee>
  800941:	89 c0                	mov    %eax,%eax
  800943:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80094a:	00 
  80094b:	48 b8 f8 19 80 00 00 	movabs $0x8019f8,%rax
  800952:	00 00 00 
  800955:	48 01 d0             	add    %rdx,%rax
  800958:	48 8b 00             	mov    (%rax),%rax
  80095b:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80095d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800961:	eb c0                	jmp    800923 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800963:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800967:	eb ba                	jmp    800923 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800969:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800970:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800973:	89 d0                	mov    %edx,%eax
  800975:	c1 e0 02             	shl    $0x2,%eax
  800978:	01 d0                	add    %edx,%eax
  80097a:	01 c0                	add    %eax,%eax
  80097c:	01 d8                	add    %ebx,%eax
  80097e:	83 e8 30             	sub    $0x30,%eax
  800981:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800984:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800988:	0f b6 00             	movzbl (%rax),%eax
  80098b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80098e:	83 fb 2f             	cmp    $0x2f,%ebx
  800991:	7e 0c                	jle    80099f <vprintfmt+0x105>
  800993:	83 fb 39             	cmp    $0x39,%ebx
  800996:	7f 07                	jg     80099f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800998:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80099d:	eb d1                	jmp    800970 <vprintfmt+0xd6>
			goto process_precision;
  80099f:	eb 58                	jmp    8009f9 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a4:	83 f8 30             	cmp    $0x30,%eax
  8009a7:	73 17                	jae    8009c0 <vprintfmt+0x126>
  8009a9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b0:	89 c0                	mov    %eax,%eax
  8009b2:	48 01 d0             	add    %rdx,%rax
  8009b5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009b8:	83 c2 08             	add    $0x8,%edx
  8009bb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009be:	eb 0f                	jmp    8009cf <vprintfmt+0x135>
  8009c0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009c4:	48 89 d0             	mov    %rdx,%rax
  8009c7:	48 83 c2 08          	add    $0x8,%rdx
  8009cb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009cf:	8b 00                	mov    (%rax),%eax
  8009d1:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8009d4:	eb 23                	jmp    8009f9 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8009d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009da:	79 0c                	jns    8009e8 <vprintfmt+0x14e>
				width = 0;
  8009dc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8009e3:	e9 3b ff ff ff       	jmpq   800923 <vprintfmt+0x89>
  8009e8:	e9 36 ff ff ff       	jmpq   800923 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009ed:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009f4:	e9 2a ff ff ff       	jmpq   800923 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009fd:	79 12                	jns    800a11 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009ff:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a02:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a05:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a0c:	e9 12 ff ff ff       	jmpq   800923 <vprintfmt+0x89>
  800a11:	e9 0d ff ff ff       	jmpq   800923 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a16:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a1a:	e9 04 ff ff ff       	jmpq   800923 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a1f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a22:	83 f8 30             	cmp    $0x30,%eax
  800a25:	73 17                	jae    800a3e <vprintfmt+0x1a4>
  800a27:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2e:	89 c0                	mov    %eax,%eax
  800a30:	48 01 d0             	add    %rdx,%rax
  800a33:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a36:	83 c2 08             	add    $0x8,%edx
  800a39:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a3c:	eb 0f                	jmp    800a4d <vprintfmt+0x1b3>
  800a3e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a42:	48 89 d0             	mov    %rdx,%rax
  800a45:	48 83 c2 08          	add    $0x8,%rdx
  800a49:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a4d:	8b 10                	mov    (%rax),%edx
  800a4f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a57:	48 89 ce             	mov    %rcx,%rsi
  800a5a:	89 d7                	mov    %edx,%edi
  800a5c:	ff d0                	callq  *%rax
			break;
  800a5e:	e9 53 03 00 00       	jmpq   800db6 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a66:	83 f8 30             	cmp    $0x30,%eax
  800a69:	73 17                	jae    800a82 <vprintfmt+0x1e8>
  800a6b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a72:	89 c0                	mov    %eax,%eax
  800a74:	48 01 d0             	add    %rdx,%rax
  800a77:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7a:	83 c2 08             	add    $0x8,%edx
  800a7d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a80:	eb 0f                	jmp    800a91 <vprintfmt+0x1f7>
  800a82:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a86:	48 89 d0             	mov    %rdx,%rax
  800a89:	48 83 c2 08          	add    $0x8,%rdx
  800a8d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a91:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a93:	85 db                	test   %ebx,%ebx
  800a95:	79 02                	jns    800a99 <vprintfmt+0x1ff>
				err = -err;
  800a97:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a99:	83 fb 15             	cmp    $0x15,%ebx
  800a9c:	7f 16                	jg     800ab4 <vprintfmt+0x21a>
  800a9e:	48 b8 20 19 80 00 00 	movabs $0x801920,%rax
  800aa5:	00 00 00 
  800aa8:	48 63 d3             	movslq %ebx,%rdx
  800aab:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800aaf:	4d 85 e4             	test   %r12,%r12
  800ab2:	75 2e                	jne    800ae2 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800ab4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abc:	89 d9                	mov    %ebx,%ecx
  800abe:	48 ba e1 19 80 00 00 	movabs $0x8019e1,%rdx
  800ac5:	00 00 00 
  800ac8:	48 89 c7             	mov    %rax,%rdi
  800acb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad0:	49 b8 c5 0d 80 00 00 	movabs $0x800dc5,%r8
  800ad7:	00 00 00 
  800ada:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800add:	e9 d4 02 00 00       	jmpq   800db6 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ae6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aea:	4c 89 e1             	mov    %r12,%rcx
  800aed:	48 ba ea 19 80 00 00 	movabs $0x8019ea,%rdx
  800af4:	00 00 00 
  800af7:	48 89 c7             	mov    %rax,%rdi
  800afa:	b8 00 00 00 00       	mov    $0x0,%eax
  800aff:	49 b8 c5 0d 80 00 00 	movabs $0x800dc5,%r8
  800b06:	00 00 00 
  800b09:	41 ff d0             	callq  *%r8
			break;
  800b0c:	e9 a5 02 00 00       	jmpq   800db6 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b14:	83 f8 30             	cmp    $0x30,%eax
  800b17:	73 17                	jae    800b30 <vprintfmt+0x296>
  800b19:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b20:	89 c0                	mov    %eax,%eax
  800b22:	48 01 d0             	add    %rdx,%rax
  800b25:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b28:	83 c2 08             	add    $0x8,%edx
  800b2b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b2e:	eb 0f                	jmp    800b3f <vprintfmt+0x2a5>
  800b30:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b34:	48 89 d0             	mov    %rdx,%rax
  800b37:	48 83 c2 08          	add    $0x8,%rdx
  800b3b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b3f:	4c 8b 20             	mov    (%rax),%r12
  800b42:	4d 85 e4             	test   %r12,%r12
  800b45:	75 0a                	jne    800b51 <vprintfmt+0x2b7>
				p = "(null)";
  800b47:	49 bc ed 19 80 00 00 	movabs $0x8019ed,%r12
  800b4e:	00 00 00 
			if (width > 0 && padc != '-')
  800b51:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b55:	7e 3f                	jle    800b96 <vprintfmt+0x2fc>
  800b57:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b5b:	74 39                	je     800b96 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b60:	48 98                	cltq   
  800b62:	48 89 c6             	mov    %rax,%rsi
  800b65:	4c 89 e7             	mov    %r12,%rdi
  800b68:	48 b8 71 10 80 00 00 	movabs $0x801071,%rax
  800b6f:	00 00 00 
  800b72:	ff d0                	callq  *%rax
  800b74:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b77:	eb 17                	jmp    800b90 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b79:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b7d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b81:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b85:	48 89 ce             	mov    %rcx,%rsi
  800b88:	89 d7                	mov    %edx,%edi
  800b8a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b90:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b94:	7f e3                	jg     800b79 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	eb 37                	jmp    800bcf <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b98:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b9c:	74 1e                	je     800bbc <vprintfmt+0x322>
  800b9e:	83 fb 1f             	cmp    $0x1f,%ebx
  800ba1:	7e 05                	jle    800ba8 <vprintfmt+0x30e>
  800ba3:	83 fb 7e             	cmp    $0x7e,%ebx
  800ba6:	7e 14                	jle    800bbc <vprintfmt+0x322>
					putch('?', putdat);
  800ba8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb0:	48 89 d6             	mov    %rdx,%rsi
  800bb3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800bb8:	ff d0                	callq  *%rax
  800bba:	eb 0f                	jmp    800bcb <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800bbc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc4:	48 89 d6             	mov    %rdx,%rsi
  800bc7:	89 df                	mov    %ebx,%edi
  800bc9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bcb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bcf:	4c 89 e0             	mov    %r12,%rax
  800bd2:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800bd6:	0f b6 00             	movzbl (%rax),%eax
  800bd9:	0f be d8             	movsbl %al,%ebx
  800bdc:	85 db                	test   %ebx,%ebx
  800bde:	74 10                	je     800bf0 <vprintfmt+0x356>
  800be0:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800be4:	78 b2                	js     800b98 <vprintfmt+0x2fe>
  800be6:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800bea:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800bee:	79 a8                	jns    800b98 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf0:	eb 16                	jmp    800c08 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bf2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bfa:	48 89 d6             	mov    %rdx,%rsi
  800bfd:	bf 20 00 00 00       	mov    $0x20,%edi
  800c02:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c04:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c08:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c0c:	7f e4                	jg     800bf2 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c0e:	e9 a3 01 00 00       	jmpq   800db6 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c13:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c17:	be 03 00 00 00       	mov    $0x3,%esi
  800c1c:	48 89 c7             	mov    %rax,%rdi
  800c1f:	48 b8 8a 07 80 00 00 	movabs $0x80078a,%rax
  800c26:	00 00 00 
  800c29:	ff d0                	callq  *%rax
  800c2b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c33:	48 85 c0             	test   %rax,%rax
  800c36:	79 1d                	jns    800c55 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c40:	48 89 d6             	mov    %rdx,%rsi
  800c43:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c48:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c4e:	48 f7 d8             	neg    %rax
  800c51:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c55:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c5c:	e9 e8 00 00 00       	jmpq   800d49 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c61:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c65:	be 03 00 00 00       	mov    $0x3,%esi
  800c6a:	48 89 c7             	mov    %rax,%rdi
  800c6d:	48 b8 7a 06 80 00 00 	movabs $0x80067a,%rax
  800c74:	00 00 00 
  800c77:	ff d0                	callq  *%rax
  800c79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c7d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c84:	e9 c0 00 00 00       	jmpq   800d49 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c91:	48 89 d6             	mov    %rdx,%rsi
  800c94:	bf 58 00 00 00       	mov    $0x58,%edi
  800c99:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca3:	48 89 d6             	mov    %rdx,%rsi
  800ca6:	bf 58 00 00 00       	mov    $0x58,%edi
  800cab:	ff d0                	callq  *%rax
			putch('X', putdat);
  800cad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb5:	48 89 d6             	mov    %rdx,%rsi
  800cb8:	bf 58 00 00 00       	mov    $0x58,%edi
  800cbd:	ff d0                	callq  *%rax
			break;
  800cbf:	e9 f2 00 00 00       	jmpq   800db6 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800cc4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccc:	48 89 d6             	mov    %rdx,%rsi
  800ccf:	bf 30 00 00 00       	mov    $0x30,%edi
  800cd4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800cd6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cda:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cde:	48 89 d6             	mov    %rdx,%rsi
  800ce1:	bf 78 00 00 00       	mov    $0x78,%edi
  800ce6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ce8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ceb:	83 f8 30             	cmp    $0x30,%eax
  800cee:	73 17                	jae    800d07 <vprintfmt+0x46d>
  800cf0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cf4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf7:	89 c0                	mov    %eax,%eax
  800cf9:	48 01 d0             	add    %rdx,%rax
  800cfc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cff:	83 c2 08             	add    $0x8,%edx
  800d02:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d05:	eb 0f                	jmp    800d16 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800d07:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d0b:	48 89 d0             	mov    %rdx,%rax
  800d0e:	48 83 c2 08          	add    $0x8,%rdx
  800d12:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d16:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d19:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d1d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d24:	eb 23                	jmp    800d49 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d26:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d2a:	be 03 00 00 00       	mov    $0x3,%esi
  800d2f:	48 89 c7             	mov    %rax,%rdi
  800d32:	48 b8 7a 06 80 00 00 	movabs $0x80067a,%rax
  800d39:	00 00 00 
  800d3c:	ff d0                	callq  *%rax
  800d3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d42:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d49:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d4e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d51:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d58:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d60:	45 89 c1             	mov    %r8d,%r9d
  800d63:	41 89 f8             	mov    %edi,%r8d
  800d66:	48 89 c7             	mov    %rax,%rdi
  800d69:	48 b8 bf 05 80 00 00 	movabs $0x8005bf,%rax
  800d70:	00 00 00 
  800d73:	ff d0                	callq  *%rax
			break;
  800d75:	eb 3f                	jmp    800db6 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d7f:	48 89 d6             	mov    %rdx,%rsi
  800d82:	89 df                	mov    %ebx,%edi
  800d84:	ff d0                	callq  *%rax
			break;
  800d86:	eb 2e                	jmp    800db6 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d88:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d8c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d90:	48 89 d6             	mov    %rdx,%rsi
  800d93:	bf 25 00 00 00       	mov    $0x25,%edi
  800d98:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d9a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d9f:	eb 05                	jmp    800da6 <vprintfmt+0x50c>
  800da1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800da6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800daa:	48 83 e8 01          	sub    $0x1,%rax
  800dae:	0f b6 00             	movzbl (%rax),%eax
  800db1:	3c 25                	cmp    $0x25,%al
  800db3:	75 ec                	jne    800da1 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800db5:	90                   	nop
		}
	}
  800db6:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db7:	e9 30 fb ff ff       	jmpq   8008ec <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800dbc:	48 83 c4 60          	add    $0x60,%rsp
  800dc0:	5b                   	pop    %rbx
  800dc1:	41 5c                	pop    %r12
  800dc3:	5d                   	pop    %rbp
  800dc4:	c3                   	retq   

0000000000800dc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dc5:	55                   	push   %rbp
  800dc6:	48 89 e5             	mov    %rsp,%rbp
  800dc9:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800dd0:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800dd7:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800dde:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800de5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800df3:	84 c0                	test   %al,%al
  800df5:	74 20                	je     800e17 <printfmt+0x52>
  800df7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dfb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e03:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e07:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e0b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e0f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e13:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e17:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e1e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e25:	00 00 00 
  800e28:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e2f:	00 00 00 
  800e32:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e36:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e3d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e44:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e4b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e52:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e59:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e60:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e67:	48 89 c7             	mov    %rax,%rdi
  800e6a:	48 b8 9a 08 80 00 00 	movabs $0x80089a,%rax
  800e71:	00 00 00 
  800e74:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e76:	c9                   	leaveq 
  800e77:	c3                   	retq   

0000000000800e78 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e78:	55                   	push   %rbp
  800e79:	48 89 e5             	mov    %rsp,%rbp
  800e7c:	48 83 ec 10          	sub    $0x10,%rsp
  800e80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e8b:	8b 40 10             	mov    0x10(%rax),%eax
  800e8e:	8d 50 01             	lea    0x1(%rax),%edx
  800e91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e95:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9c:	48 8b 10             	mov    (%rax),%rdx
  800e9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ea7:	48 39 c2             	cmp    %rax,%rdx
  800eaa:	73 17                	jae    800ec3 <sprintputch+0x4b>
		*b->buf++ = ch;
  800eac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eb0:	48 8b 00             	mov    (%rax),%rax
  800eb3:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800eb7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ebb:	48 89 0a             	mov    %rcx,(%rdx)
  800ebe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ec1:	88 10                	mov    %dl,(%rax)
}
  800ec3:	c9                   	leaveq 
  800ec4:	c3                   	retq   

0000000000800ec5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ec5:	55                   	push   %rbp
  800ec6:	48 89 e5             	mov    %rsp,%rbp
  800ec9:	48 83 ec 50          	sub    $0x50,%rsp
  800ecd:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ed1:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800ed4:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800ed8:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800edc:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800ee0:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ee4:	48 8b 0a             	mov    (%rdx),%rcx
  800ee7:	48 89 08             	mov    %rcx,(%rax)
  800eea:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800eee:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ef2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ef6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800efa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800efe:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f02:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f05:	48 98                	cltq   
  800f07:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f0f:	48 01 d0             	add    %rdx,%rax
  800f12:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f16:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f1d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f22:	74 06                	je     800f2a <vsnprintf+0x65>
  800f24:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f28:	7f 07                	jg     800f31 <vsnprintf+0x6c>
		return -E_INVAL;
  800f2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f2f:	eb 2f                	jmp    800f60 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f31:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f35:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f39:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f3d:	48 89 c6             	mov    %rax,%rsi
  800f40:	48 bf 78 0e 80 00 00 	movabs $0x800e78,%rdi
  800f47:	00 00 00 
  800f4a:	48 b8 9a 08 80 00 00 	movabs $0x80089a,%rax
  800f51:	00 00 00 
  800f54:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f56:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f5a:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f5d:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f60:	c9                   	leaveq 
  800f61:	c3                   	retq   

0000000000800f62 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f62:	55                   	push   %rbp
  800f63:	48 89 e5             	mov    %rsp,%rbp
  800f66:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f6d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f74:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f7a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f81:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f88:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f8f:	84 c0                	test   %al,%al
  800f91:	74 20                	je     800fb3 <snprintf+0x51>
  800f93:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f97:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f9b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f9f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fa3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fa7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fab:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800faf:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fb3:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800fba:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800fc1:	00 00 00 
  800fc4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fcb:	00 00 00 
  800fce:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fd2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fd9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fe0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800fe7:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fee:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ff5:	48 8b 0a             	mov    (%rdx),%rcx
  800ff8:	48 89 08             	mov    %rcx,(%rax)
  800ffb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801003:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801007:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80100b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801012:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801019:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80101f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801026:	48 89 c7             	mov    %rax,%rdi
  801029:	48 b8 c5 0e 80 00 00 	movabs $0x800ec5,%rax
  801030:	00 00 00 
  801033:	ff d0                	callq  *%rax
  801035:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80103b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801041:	c9                   	leaveq 
  801042:	c3                   	retq   

0000000000801043 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801043:	55                   	push   %rbp
  801044:	48 89 e5             	mov    %rsp,%rbp
  801047:	48 83 ec 18          	sub    $0x18,%rsp
  80104b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80104f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801056:	eb 09                	jmp    801061 <strlen+0x1e>
		n++;
  801058:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80105c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	0f b6 00             	movzbl (%rax),%eax
  801068:	84 c0                	test   %al,%al
  80106a:	75 ec                	jne    801058 <strlen+0x15>
		n++;
	return n;
  80106c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80106f:	c9                   	leaveq 
  801070:	c3                   	retq   

0000000000801071 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801071:	55                   	push   %rbp
  801072:	48 89 e5             	mov    %rsp,%rbp
  801075:	48 83 ec 20          	sub    $0x20,%rsp
  801079:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80107d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801081:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801088:	eb 0e                	jmp    801098 <strnlen+0x27>
		n++;
  80108a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80108e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801093:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801098:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80109d:	74 0b                	je     8010aa <strnlen+0x39>
  80109f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a3:	0f b6 00             	movzbl (%rax),%eax
  8010a6:	84 c0                	test   %al,%al
  8010a8:	75 e0                	jne    80108a <strnlen+0x19>
		n++;
	return n;
  8010aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010ad:	c9                   	leaveq 
  8010ae:	c3                   	retq   

00000000008010af <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010af:	55                   	push   %rbp
  8010b0:	48 89 e5             	mov    %rsp,%rbp
  8010b3:	48 83 ec 20          	sub    $0x20,%rsp
  8010b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8010c7:	90                   	nop
  8010c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010d8:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010dc:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010e0:	0f b6 12             	movzbl (%rdx),%edx
  8010e3:	88 10                	mov    %dl,(%rax)
  8010e5:	0f b6 00             	movzbl (%rax),%eax
  8010e8:	84 c0                	test   %al,%al
  8010ea:	75 dc                	jne    8010c8 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8010ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010f0:	c9                   	leaveq 
  8010f1:	c3                   	retq   

00000000008010f2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8010f2:	55                   	push   %rbp
  8010f3:	48 89 e5             	mov    %rsp,%rbp
  8010f6:	48 83 ec 20          	sub    $0x20,%rsp
  8010fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801102:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801106:	48 89 c7             	mov    %rax,%rdi
  801109:	48 b8 43 10 80 00 00 	movabs $0x801043,%rax
  801110:	00 00 00 
  801113:	ff d0                	callq  *%rax
  801115:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80111b:	48 63 d0             	movslq %eax,%rdx
  80111e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801122:	48 01 c2             	add    %rax,%rdx
  801125:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801129:	48 89 c6             	mov    %rax,%rsi
  80112c:	48 89 d7             	mov    %rdx,%rdi
  80112f:	48 b8 af 10 80 00 00 	movabs $0x8010af,%rax
  801136:	00 00 00 
  801139:	ff d0                	callq  *%rax
	return dst;
  80113b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80113f:	c9                   	leaveq 
  801140:	c3                   	retq   

0000000000801141 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801141:	55                   	push   %rbp
  801142:	48 89 e5             	mov    %rsp,%rbp
  801145:	48 83 ec 28          	sub    $0x28,%rsp
  801149:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801151:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801155:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801159:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80115d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801164:	00 
  801165:	eb 2a                	jmp    801191 <strncpy+0x50>
		*dst++ = *src;
  801167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80116f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801173:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801177:	0f b6 12             	movzbl (%rdx),%edx
  80117a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80117c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801180:	0f b6 00             	movzbl (%rax),%eax
  801183:	84 c0                	test   %al,%al
  801185:	74 05                	je     80118c <strncpy+0x4b>
			src++;
  801187:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80118c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801191:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801195:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801199:	72 cc                	jb     801167 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80119b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80119f:	c9                   	leaveq 
  8011a0:	c3                   	retq   

00000000008011a1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011a1:	55                   	push   %rbp
  8011a2:	48 89 e5             	mov    %rsp,%rbp
  8011a5:	48 83 ec 28          	sub    $0x28,%rsp
  8011a9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011b1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011bd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011c2:	74 3d                	je     801201 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011c4:	eb 1d                	jmp    8011e3 <strlcpy+0x42>
			*dst++ = *src++;
  8011c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011d2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011d6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8011da:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8011de:	0f b6 12             	movzbl (%rdx),%edx
  8011e1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011e3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8011e8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011ed:	74 0b                	je     8011fa <strlcpy+0x59>
  8011ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011f3:	0f b6 00             	movzbl (%rax),%eax
  8011f6:	84 c0                	test   %al,%al
  8011f8:	75 cc                	jne    8011c6 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011fe:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801201:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801205:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801209:	48 29 c2             	sub    %rax,%rdx
  80120c:	48 89 d0             	mov    %rdx,%rax
}
  80120f:	c9                   	leaveq 
  801210:	c3                   	retq   

0000000000801211 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801211:	55                   	push   %rbp
  801212:	48 89 e5             	mov    %rsp,%rbp
  801215:	48 83 ec 10          	sub    $0x10,%rsp
  801219:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80121d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801221:	eb 0a                	jmp    80122d <strcmp+0x1c>
		p++, q++;
  801223:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801228:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801231:	0f b6 00             	movzbl (%rax),%eax
  801234:	84 c0                	test   %al,%al
  801236:	74 12                	je     80124a <strcmp+0x39>
  801238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123c:	0f b6 10             	movzbl (%rax),%edx
  80123f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801243:	0f b6 00             	movzbl (%rax),%eax
  801246:	38 c2                	cmp    %al,%dl
  801248:	74 d9                	je     801223 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80124a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124e:	0f b6 00             	movzbl (%rax),%eax
  801251:	0f b6 d0             	movzbl %al,%edx
  801254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801258:	0f b6 00             	movzbl (%rax),%eax
  80125b:	0f b6 c0             	movzbl %al,%eax
  80125e:	29 c2                	sub    %eax,%edx
  801260:	89 d0                	mov    %edx,%eax
}
  801262:	c9                   	leaveq 
  801263:	c3                   	retq   

0000000000801264 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801264:	55                   	push   %rbp
  801265:	48 89 e5             	mov    %rsp,%rbp
  801268:	48 83 ec 18          	sub    $0x18,%rsp
  80126c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801270:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801274:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801278:	eb 0f                	jmp    801289 <strncmp+0x25>
		n--, p++, q++;
  80127a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80127f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801284:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801289:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80128e:	74 1d                	je     8012ad <strncmp+0x49>
  801290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801294:	0f b6 00             	movzbl (%rax),%eax
  801297:	84 c0                	test   %al,%al
  801299:	74 12                	je     8012ad <strncmp+0x49>
  80129b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129f:	0f b6 10             	movzbl (%rax),%edx
  8012a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a6:	0f b6 00             	movzbl (%rax),%eax
  8012a9:	38 c2                	cmp    %al,%dl
  8012ab:	74 cd                	je     80127a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012ad:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012b2:	75 07                	jne    8012bb <strncmp+0x57>
		return 0;
  8012b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b9:	eb 18                	jmp    8012d3 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bf:	0f b6 00             	movzbl (%rax),%eax
  8012c2:	0f b6 d0             	movzbl %al,%edx
  8012c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c9:	0f b6 00             	movzbl (%rax),%eax
  8012cc:	0f b6 c0             	movzbl %al,%eax
  8012cf:	29 c2                	sub    %eax,%edx
  8012d1:	89 d0                	mov    %edx,%eax
}
  8012d3:	c9                   	leaveq 
  8012d4:	c3                   	retq   

00000000008012d5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012d5:	55                   	push   %rbp
  8012d6:	48 89 e5             	mov    %rsp,%rbp
  8012d9:	48 83 ec 0c          	sub    $0xc,%rsp
  8012dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012e1:	89 f0                	mov    %esi,%eax
  8012e3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012e6:	eb 17                	jmp    8012ff <strchr+0x2a>
		if (*s == c)
  8012e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ec:	0f b6 00             	movzbl (%rax),%eax
  8012ef:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012f2:	75 06                	jne    8012fa <strchr+0x25>
			return (char *) s;
  8012f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f8:	eb 15                	jmp    80130f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012fa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801303:	0f b6 00             	movzbl (%rax),%eax
  801306:	84 c0                	test   %al,%al
  801308:	75 de                	jne    8012e8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80130a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130f:	c9                   	leaveq 
  801310:	c3                   	retq   

0000000000801311 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801311:	55                   	push   %rbp
  801312:	48 89 e5             	mov    %rsp,%rbp
  801315:	48 83 ec 0c          	sub    $0xc,%rsp
  801319:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131d:	89 f0                	mov    %esi,%eax
  80131f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801322:	eb 13                	jmp    801337 <strfind+0x26>
		if (*s == c)
  801324:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801328:	0f b6 00             	movzbl (%rax),%eax
  80132b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80132e:	75 02                	jne    801332 <strfind+0x21>
			break;
  801330:	eb 10                	jmp    801342 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801332:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133b:	0f b6 00             	movzbl (%rax),%eax
  80133e:	84 c0                	test   %al,%al
  801340:	75 e2                	jne    801324 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801346:	c9                   	leaveq 
  801347:	c3                   	retq   

0000000000801348 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801348:	55                   	push   %rbp
  801349:	48 89 e5             	mov    %rsp,%rbp
  80134c:	48 83 ec 18          	sub    $0x18,%rsp
  801350:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801354:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801357:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80135b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801360:	75 06                	jne    801368 <memset+0x20>
		return v;
  801362:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801366:	eb 69                	jmp    8013d1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801368:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136c:	83 e0 03             	and    $0x3,%eax
  80136f:	48 85 c0             	test   %rax,%rax
  801372:	75 48                	jne    8013bc <memset+0x74>
  801374:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801378:	83 e0 03             	and    $0x3,%eax
  80137b:	48 85 c0             	test   %rax,%rax
  80137e:	75 3c                	jne    8013bc <memset+0x74>
		c &= 0xFF;
  801380:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801387:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80138a:	c1 e0 18             	shl    $0x18,%eax
  80138d:	89 c2                	mov    %eax,%edx
  80138f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801392:	c1 e0 10             	shl    $0x10,%eax
  801395:	09 c2                	or     %eax,%edx
  801397:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80139a:	c1 e0 08             	shl    $0x8,%eax
  80139d:	09 d0                	or     %edx,%eax
  80139f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a6:	48 c1 e8 02          	shr    $0x2,%rax
  8013aa:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b4:	48 89 d7             	mov    %rdx,%rdi
  8013b7:	fc                   	cld    
  8013b8:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013ba:	eb 11                	jmp    8013cd <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8013c7:	48 89 d7             	mov    %rdx,%rdi
  8013ca:	fc                   	cld    
  8013cb:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8013cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013d1:	c9                   	leaveq 
  8013d2:	c3                   	retq   

00000000008013d3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8013d3:	55                   	push   %rbp
  8013d4:	48 89 e5             	mov    %rsp,%rbp
  8013d7:	48 83 ec 28          	sub    $0x28,%rsp
  8013db:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013df:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8013e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8013ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8013f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013fb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013ff:	0f 83 88 00 00 00    	jae    80148d <memmove+0xba>
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80140d:	48 01 d0             	add    %rdx,%rax
  801410:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801414:	76 77                	jbe    80148d <memmove+0xba>
		s += n;
  801416:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80141e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801422:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80142a:	83 e0 03             	and    $0x3,%eax
  80142d:	48 85 c0             	test   %rax,%rax
  801430:	75 3b                	jne    80146d <memmove+0x9a>
  801432:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801436:	83 e0 03             	and    $0x3,%eax
  801439:	48 85 c0             	test   %rax,%rax
  80143c:	75 2f                	jne    80146d <memmove+0x9a>
  80143e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801442:	83 e0 03             	and    $0x3,%eax
  801445:	48 85 c0             	test   %rax,%rax
  801448:	75 23                	jne    80146d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80144a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80144e:	48 83 e8 04          	sub    $0x4,%rax
  801452:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801456:	48 83 ea 04          	sub    $0x4,%rdx
  80145a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80145e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801462:	48 89 c7             	mov    %rax,%rdi
  801465:	48 89 d6             	mov    %rdx,%rsi
  801468:	fd                   	std    
  801469:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80146b:	eb 1d                	jmp    80148a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80146d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801471:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801475:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801479:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80147d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801481:	48 89 d7             	mov    %rdx,%rdi
  801484:	48 89 c1             	mov    %rax,%rcx
  801487:	fd                   	std    
  801488:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80148a:	fc                   	cld    
  80148b:	eb 57                	jmp    8014e4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80148d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801491:	83 e0 03             	and    $0x3,%eax
  801494:	48 85 c0             	test   %rax,%rax
  801497:	75 36                	jne    8014cf <memmove+0xfc>
  801499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149d:	83 e0 03             	and    $0x3,%eax
  8014a0:	48 85 c0             	test   %rax,%rax
  8014a3:	75 2a                	jne    8014cf <memmove+0xfc>
  8014a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a9:	83 e0 03             	and    $0x3,%eax
  8014ac:	48 85 c0             	test   %rax,%rax
  8014af:	75 1e                	jne    8014cf <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b5:	48 c1 e8 02          	shr    $0x2,%rax
  8014b9:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014c4:	48 89 c7             	mov    %rax,%rdi
  8014c7:	48 89 d6             	mov    %rdx,%rsi
  8014ca:	fc                   	cld    
  8014cb:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014cd:	eb 15                	jmp    8014e4 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8014cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014d7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014db:	48 89 c7             	mov    %rax,%rdi
  8014de:	48 89 d6             	mov    %rdx,%rsi
  8014e1:	fc                   	cld    
  8014e2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8014e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014e8:	c9                   	leaveq 
  8014e9:	c3                   	retq   

00000000008014ea <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014ea:	55                   	push   %rbp
  8014eb:	48 89 e5             	mov    %rsp,%rbp
  8014ee:	48 83 ec 18          	sub    $0x18,%rsp
  8014f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801502:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801506:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150a:	48 89 ce             	mov    %rcx,%rsi
  80150d:	48 89 c7             	mov    %rax,%rdi
  801510:	48 b8 d3 13 80 00 00 	movabs $0x8013d3,%rax
  801517:	00 00 00 
  80151a:	ff d0                	callq  *%rax
}
  80151c:	c9                   	leaveq 
  80151d:	c3                   	retq   

000000000080151e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80151e:	55                   	push   %rbp
  80151f:	48 89 e5             	mov    %rsp,%rbp
  801522:	48 83 ec 28          	sub    $0x28,%rsp
  801526:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80152a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80152e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801536:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80153a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80153e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801542:	eb 36                	jmp    80157a <memcmp+0x5c>
		if (*s1 != *s2)
  801544:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801548:	0f b6 10             	movzbl (%rax),%edx
  80154b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80154f:	0f b6 00             	movzbl (%rax),%eax
  801552:	38 c2                	cmp    %al,%dl
  801554:	74 1a                	je     801570 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155a:	0f b6 00             	movzbl (%rax),%eax
  80155d:	0f b6 d0             	movzbl %al,%edx
  801560:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801564:	0f b6 00             	movzbl (%rax),%eax
  801567:	0f b6 c0             	movzbl %al,%eax
  80156a:	29 c2                	sub    %eax,%edx
  80156c:	89 d0                	mov    %edx,%eax
  80156e:	eb 20                	jmp    801590 <memcmp+0x72>
		s1++, s2++;
  801570:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801575:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80157a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801582:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801586:	48 85 c0             	test   %rax,%rax
  801589:	75 b9                	jne    801544 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801590:	c9                   	leaveq 
  801591:	c3                   	retq   

0000000000801592 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801592:	55                   	push   %rbp
  801593:	48 89 e5             	mov    %rsp,%rbp
  801596:	48 83 ec 28          	sub    $0x28,%rsp
  80159a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80159e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015ad:	48 01 d0             	add    %rdx,%rax
  8015b0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015b4:	eb 15                	jmp    8015cb <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015ba:	0f b6 10             	movzbl (%rax),%edx
  8015bd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015c0:	38 c2                	cmp    %al,%dl
  8015c2:	75 02                	jne    8015c6 <memfind+0x34>
			break;
  8015c4:	eb 0f                	jmp    8015d5 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015c6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8015cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cf:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8015d3:	72 e1                	jb     8015b6 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8015d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015d9:	c9                   	leaveq 
  8015da:	c3                   	retq   

00000000008015db <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015db:	55                   	push   %rbp
  8015dc:	48 89 e5             	mov    %rsp,%rbp
  8015df:	48 83 ec 34          	sub    $0x34,%rsp
  8015e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015eb:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8015ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8015f5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015fc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015fd:	eb 05                	jmp    801604 <strtol+0x29>
		s++;
  8015ff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801604:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801608:	0f b6 00             	movzbl (%rax),%eax
  80160b:	3c 20                	cmp    $0x20,%al
  80160d:	74 f0                	je     8015ff <strtol+0x24>
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	0f b6 00             	movzbl (%rax),%eax
  801616:	3c 09                	cmp    $0x9,%al
  801618:	74 e5                	je     8015ff <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	0f b6 00             	movzbl (%rax),%eax
  801621:	3c 2b                	cmp    $0x2b,%al
  801623:	75 07                	jne    80162c <strtol+0x51>
		s++;
  801625:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80162a:	eb 17                	jmp    801643 <strtol+0x68>
	else if (*s == '-')
  80162c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801630:	0f b6 00             	movzbl (%rax),%eax
  801633:	3c 2d                	cmp    $0x2d,%al
  801635:	75 0c                	jne    801643 <strtol+0x68>
		s++, neg = 1;
  801637:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80163c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801643:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801647:	74 06                	je     80164f <strtol+0x74>
  801649:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80164d:	75 28                	jne    801677 <strtol+0x9c>
  80164f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801653:	0f b6 00             	movzbl (%rax),%eax
  801656:	3c 30                	cmp    $0x30,%al
  801658:	75 1d                	jne    801677 <strtol+0x9c>
  80165a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165e:	48 83 c0 01          	add    $0x1,%rax
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	3c 78                	cmp    $0x78,%al
  801667:	75 0e                	jne    801677 <strtol+0x9c>
		s += 2, base = 16;
  801669:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80166e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801675:	eb 2c                	jmp    8016a3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801677:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80167b:	75 19                	jne    801696 <strtol+0xbb>
  80167d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801681:	0f b6 00             	movzbl (%rax),%eax
  801684:	3c 30                	cmp    $0x30,%al
  801686:	75 0e                	jne    801696 <strtol+0xbb>
		s++, base = 8;
  801688:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80168d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801694:	eb 0d                	jmp    8016a3 <strtol+0xc8>
	else if (base == 0)
  801696:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80169a:	75 07                	jne    8016a3 <strtol+0xc8>
		base = 10;
  80169c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a7:	0f b6 00             	movzbl (%rax),%eax
  8016aa:	3c 2f                	cmp    $0x2f,%al
  8016ac:	7e 1d                	jle    8016cb <strtol+0xf0>
  8016ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b2:	0f b6 00             	movzbl (%rax),%eax
  8016b5:	3c 39                	cmp    $0x39,%al
  8016b7:	7f 12                	jg     8016cb <strtol+0xf0>
			dig = *s - '0';
  8016b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bd:	0f b6 00             	movzbl (%rax),%eax
  8016c0:	0f be c0             	movsbl %al,%eax
  8016c3:	83 e8 30             	sub    $0x30,%eax
  8016c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016c9:	eb 4e                	jmp    801719 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8016cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016cf:	0f b6 00             	movzbl (%rax),%eax
  8016d2:	3c 60                	cmp    $0x60,%al
  8016d4:	7e 1d                	jle    8016f3 <strtol+0x118>
  8016d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016da:	0f b6 00             	movzbl (%rax),%eax
  8016dd:	3c 7a                	cmp    $0x7a,%al
  8016df:	7f 12                	jg     8016f3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8016e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e5:	0f b6 00             	movzbl (%rax),%eax
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	83 e8 57             	sub    $0x57,%eax
  8016ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016f1:	eb 26                	jmp    801719 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8016f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f7:	0f b6 00             	movzbl (%rax),%eax
  8016fa:	3c 40                	cmp    $0x40,%al
  8016fc:	7e 48                	jle    801746 <strtol+0x16b>
  8016fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801702:	0f b6 00             	movzbl (%rax),%eax
  801705:	3c 5a                	cmp    $0x5a,%al
  801707:	7f 3d                	jg     801746 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801709:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170d:	0f b6 00             	movzbl (%rax),%eax
  801710:	0f be c0             	movsbl %al,%eax
  801713:	83 e8 37             	sub    $0x37,%eax
  801716:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801719:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80171c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80171f:	7c 02                	jl     801723 <strtol+0x148>
			break;
  801721:	eb 23                	jmp    801746 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801723:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801728:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80172b:	48 98                	cltq   
  80172d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801732:	48 89 c2             	mov    %rax,%rdx
  801735:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801738:	48 98                	cltq   
  80173a:	48 01 d0             	add    %rdx,%rax
  80173d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801741:	e9 5d ff ff ff       	jmpq   8016a3 <strtol+0xc8>

	if (endptr)
  801746:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80174b:	74 0b                	je     801758 <strtol+0x17d>
		*endptr = (char *) s;
  80174d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801751:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801755:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801758:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80175c:	74 09                	je     801767 <strtol+0x18c>
  80175e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801762:	48 f7 d8             	neg    %rax
  801765:	eb 04                	jmp    80176b <strtol+0x190>
  801767:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80176b:	c9                   	leaveq 
  80176c:	c3                   	retq   

000000000080176d <strstr>:

char * strstr(const char *in, const char *str)
{
  80176d:	55                   	push   %rbp
  80176e:	48 89 e5             	mov    %rsp,%rbp
  801771:	48 83 ec 30          	sub    $0x30,%rsp
  801775:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801779:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80177d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801781:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801785:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801789:	0f b6 00             	movzbl (%rax),%eax
  80178c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80178f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801793:	75 06                	jne    80179b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801795:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801799:	eb 6b                	jmp    801806 <strstr+0x99>

	len = strlen(str);
  80179b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80179f:	48 89 c7             	mov    %rax,%rdi
  8017a2:	48 b8 43 10 80 00 00 	movabs $0x801043,%rax
  8017a9:	00 00 00 
  8017ac:	ff d0                	callq  *%rax
  8017ae:	48 98                	cltq   
  8017b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017c0:	0f b6 00             	movzbl (%rax),%eax
  8017c3:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8017c6:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8017ca:	75 07                	jne    8017d3 <strstr+0x66>
				return (char *) 0;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d1:	eb 33                	jmp    801806 <strstr+0x99>
		} while (sc != c);
  8017d3:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8017d7:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8017da:	75 d8                	jne    8017b4 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8017dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017e0:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8017e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e8:	48 89 ce             	mov    %rcx,%rsi
  8017eb:	48 89 c7             	mov    %rax,%rdi
  8017ee:	48 b8 64 12 80 00 00 	movabs $0x801264,%rax
  8017f5:	00 00 00 
  8017f8:	ff d0                	callq  *%rax
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	75 b6                	jne    8017b4 <strstr+0x47>

	return (char *) (in - 1);
  8017fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801802:	48 83 e8 01          	sub    $0x1,%rax
}
  801806:	c9                   	leaveq 
  801807:	c3                   	retq   
