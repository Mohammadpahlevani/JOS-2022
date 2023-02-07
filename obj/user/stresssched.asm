
obj/user/stresssched:     file format elf64-x86-64


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
  80003c:	e8 74 01 00 00       	callq  8001b5 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800052:	48 b8 09 19 80 00 00 	movabs $0x801909,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// Fork several environments
	for (i = 0; i < 20; i++)
  800061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800068:	eb 16                	jmp    800080 <umain+0x3d>
		if (fork() == 0)
  80006a:	48 b8 45 1e 80 00 00 	movabs $0x801e45,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	85 c0                	test   %eax,%eax
  800078:	75 02                	jne    80007c <umain+0x39>
			break;
  80007a:	eb 0a                	jmp    800086 <umain+0x43>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80007c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800080:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
  800084:	7e e4                	jle    80006a <umain+0x27>
		if (fork() == 0)
			break;
	if (i == 20) {
  800086:	83 7d fc 14          	cmpl   $0x14,-0x4(%rbp)
  80008a:	75 11                	jne    80009d <umain+0x5a>
		sys_yield();
  80008c:	48 b8 47 19 80 00 00 	movabs $0x801947,%rax
  800093:	00 00 00 
  800096:	ff d0                	callq  *%rax
		return;
  800098:	e9 16 01 00 00       	jmpq   8001b3 <umain+0x170>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80009d:	eb 02                	jmp    8000a1 <umain+0x5e>
		asm volatile("pause");
  80009f:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  8000a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8000a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a9:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8000b0:	00 00 00 
  8000b3:	48 63 d0             	movslq %eax,%rdx
  8000b6:	48 89 d0             	mov    %rdx,%rax
  8000b9:	48 c1 e0 03          	shl    $0x3,%rax
  8000bd:	48 01 d0             	add    %rdx,%rax
  8000c0:	48 c1 e0 05          	shl    $0x5,%rax
  8000c4:	48 01 c8             	add    %rcx,%rax
  8000c7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8000cd:	8b 40 04             	mov    0x4(%rax),%eax
  8000d0:	85 c0                	test   %eax,%eax
  8000d2:	75 cb                	jne    80009f <umain+0x5c>
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000db:	eb 41                	jmp    80011e <umain+0xdb>
		sys_yield();
  8000dd:	48 b8 47 19 80 00 00 	movabs $0x801947,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
		for (j = 0; j < 10000; j++)
  8000e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8000f0:	eb 1f                	jmp    800111 <umain+0xce>
			counter++;
  8000f2:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8000f9:	00 00 00 
  8000fc:	8b 00                	mov    (%rax),%eax
  8000fe:	8d 50 01             	lea    0x1(%rax),%edx
  800101:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  800108:	00 00 00 
  80010b:	89 10                	mov    %edx,(%rax)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  80010d:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800111:	81 7d f8 0f 27 00 00 	cmpl   $0x270f,-0x8(%rbp)
  800118:	7e d8                	jle    8000f2 <umain+0xaf>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  800122:	7e b9                	jle    8000dd <umain+0x9a>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  800124:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80012b:	00 00 00 
  80012e:	8b 00                	mov    (%rax),%eax
  800130:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  800135:	74 39                	je     800170 <umain+0x12d>
		panic("ran on two CPUs at once (counter is %d)", counter);
  800137:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80013e:	00 00 00 
  800141:	8b 00                	mov    (%rax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	48 ba a0 3c 80 00 00 	movabs $0x803ca0,%rdx
  80014c:	00 00 00 
  80014f:	be 21 00 00 00       	mov    $0x21,%esi
  800154:	48 bf c8 3c 80 00 00 	movabs $0x803cc8,%rdi
  80015b:	00 00 00 
  80015e:	b8 00 00 00 00       	mov    $0x0,%eax
  800163:	49 b8 68 02 80 00 00 	movabs $0x800268,%r8
  80016a:	00 00 00 
  80016d:	41 ff d0             	callq  *%r8

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  800170:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800177:	00 00 00 
  80017a:	48 8b 00             	mov    (%rax),%rax
  80017d:	8b 90 dc 00 00 00    	mov    0xdc(%rax),%edx
  800183:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80018a:	00 00 00 
  80018d:	48 8b 00             	mov    (%rax),%rax
  800190:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800196:	89 c6                	mov    %eax,%esi
  800198:	48 bf db 3c 80 00 00 	movabs $0x803cdb,%rdi
  80019f:	00 00 00 
  8001a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a7:	48 b9 a1 04 80 00 00 	movabs $0x8004a1,%rcx
  8001ae:	00 00 00 
  8001b1:	ff d1                	callq  *%rcx

}
  8001b3:	c9                   	leaveq 
  8001b4:	c3                   	retq   

00000000008001b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b5:	55                   	push   %rbp
  8001b6:	48 89 e5             	mov    %rsp,%rbp
  8001b9:	48 83 ec 10          	sub    $0x10,%rsp
  8001bd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  8001c4:	48 b8 09 19 80 00 00 	movabs $0x801909,%rax
  8001cb:	00 00 00 
  8001ce:	ff d0                	callq  *%rax
  8001d0:	48 98                	cltq   
  8001d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d7:	48 89 c2             	mov    %rax,%rdx
  8001da:	48 89 d0             	mov    %rdx,%rax
  8001dd:	48 c1 e0 03          	shl    $0x3,%rax
  8001e1:	48 01 d0             	add    %rdx,%rax
  8001e4:	48 c1 e0 05          	shl    $0x5,%rax
  8001e8:	48 89 c2             	mov    %rax,%rdx
  8001eb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001f2:	00 00 00 
  8001f5:	48 01 c2             	add    %rax,%rdx
  8001f8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001ff:	00 00 00 
  800202:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800205:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800209:	7e 14                	jle    80021f <libmain+0x6a>
		binaryname = argv[0];
  80020b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020f:	48 8b 10             	mov    (%rax),%rdx
  800212:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800219:	00 00 00 
  80021c:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80021f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800223:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800226:	48 89 d6             	mov    %rdx,%rsi
  800229:	89 c7                	mov    %eax,%edi
  80022b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800232:	00 00 00 
  800235:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800237:	48 b8 45 02 80 00 00 	movabs $0x800245,%rax
  80023e:	00 00 00 
  800241:	ff d0                	callq  *%rax
}
  800243:	c9                   	leaveq 
  800244:	c3                   	retq   

0000000000800245 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800245:	55                   	push   %rbp
  800246:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800249:	48 b8 7e 24 80 00 00 	movabs $0x80247e,%rax
  800250:	00 00 00 
  800253:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800255:	bf 00 00 00 00       	mov    $0x0,%edi
  80025a:	48 b8 c5 18 80 00 00 	movabs $0x8018c5,%rax
  800261:	00 00 00 
  800264:	ff d0                	callq  *%rax
}
  800266:	5d                   	pop    %rbp
  800267:	c3                   	retq   

0000000000800268 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800268:	55                   	push   %rbp
  800269:	48 89 e5             	mov    %rsp,%rbp
  80026c:	53                   	push   %rbx
  80026d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800274:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80027b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800281:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800288:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80028f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800296:	84 c0                	test   %al,%al
  800298:	74 23                	je     8002bd <_panic+0x55>
  80029a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8002a1:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8002a5:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8002a9:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8002ad:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8002b1:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8002b5:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002b9:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002bd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002c4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002cb:	00 00 00 
  8002ce:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002d5:	00 00 00 
  8002d8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002dc:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002e3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002ea:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002f1:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002f8:	00 00 00 
  8002fb:	48 8b 18             	mov    (%rax),%rbx
  8002fe:	48 b8 09 19 80 00 00 	movabs $0x801909,%rax
  800305:	00 00 00 
  800308:	ff d0                	callq  *%rax
  80030a:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800310:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800317:	41 89 c8             	mov    %ecx,%r8d
  80031a:	48 89 d1             	mov    %rdx,%rcx
  80031d:	48 89 da             	mov    %rbx,%rdx
  800320:	89 c6                	mov    %eax,%esi
  800322:	48 bf 08 3d 80 00 00 	movabs $0x803d08,%rdi
  800329:	00 00 00 
  80032c:	b8 00 00 00 00       	mov    $0x0,%eax
  800331:	49 b9 a1 04 80 00 00 	movabs $0x8004a1,%r9
  800338:	00 00 00 
  80033b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80033e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800345:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80034c:	48 89 d6             	mov    %rdx,%rsi
  80034f:	48 89 c7             	mov    %rax,%rdi
  800352:	48 b8 f5 03 80 00 00 	movabs $0x8003f5,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
	cprintf("\n");
  80035e:	48 bf 2b 3d 80 00 00 	movabs $0x803d2b,%rdi
  800365:	00 00 00 
  800368:	b8 00 00 00 00       	mov    $0x0,%eax
  80036d:	48 ba a1 04 80 00 00 	movabs $0x8004a1,%rdx
  800374:	00 00 00 
  800377:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800379:	cc                   	int3   
  80037a:	eb fd                	jmp    800379 <_panic+0x111>

000000000080037c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80037c:	55                   	push   %rbp
  80037d:	48 89 e5             	mov    %rsp,%rbp
  800380:	48 83 ec 10          	sub    $0x10,%rsp
  800384:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800387:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80038b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038f:	8b 00                	mov    (%rax),%eax
  800391:	8d 48 01             	lea    0x1(%rax),%ecx
  800394:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800398:	89 0a                	mov    %ecx,(%rdx)
  80039a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80039d:	89 d1                	mov    %edx,%ecx
  80039f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003a3:	48 98                	cltq   
  8003a5:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8003a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ad:	8b 00                	mov    (%rax),%eax
  8003af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b4:	75 2c                	jne    8003e2 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8003b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ba:	8b 00                	mov    (%rax),%eax
  8003bc:	48 98                	cltq   
  8003be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c2:	48 83 c2 08          	add    $0x8,%rdx
  8003c6:	48 89 c6             	mov    %rax,%rsi
  8003c9:	48 89 d7             	mov    %rdx,%rdi
  8003cc:	48 b8 3d 18 80 00 00 	movabs $0x80183d,%rax
  8003d3:	00 00 00 
  8003d6:	ff d0                	callq  *%rax
        b->idx = 0;
  8003d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003dc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003e6:	8b 40 04             	mov    0x4(%rax),%eax
  8003e9:	8d 50 01             	lea    0x1(%rax),%edx
  8003ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003f0:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003f3:	c9                   	leaveq 
  8003f4:	c3                   	retq   

00000000008003f5 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003f5:	55                   	push   %rbp
  8003f6:	48 89 e5             	mov    %rsp,%rbp
  8003f9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800400:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800407:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80040e:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800415:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80041c:	48 8b 0a             	mov    (%rdx),%rcx
  80041f:	48 89 08             	mov    %rcx,(%rax)
  800422:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800426:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80042a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80042e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800432:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800439:	00 00 00 
    b.cnt = 0;
  80043c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800443:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800446:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80044d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800454:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80045b:	48 89 c6             	mov    %rax,%rsi
  80045e:	48 bf 7c 03 80 00 00 	movabs $0x80037c,%rdi
  800465:	00 00 00 
  800468:	48 b8 54 08 80 00 00 	movabs $0x800854,%rax
  80046f:	00 00 00 
  800472:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800474:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80047a:	48 98                	cltq   
  80047c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800483:	48 83 c2 08          	add    $0x8,%rdx
  800487:	48 89 c6             	mov    %rax,%rsi
  80048a:	48 89 d7             	mov    %rdx,%rdi
  80048d:	48 b8 3d 18 80 00 00 	movabs $0x80183d,%rax
  800494:	00 00 00 
  800497:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800499:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80049f:	c9                   	leaveq 
  8004a0:	c3                   	retq   

00000000008004a1 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8004a1:	55                   	push   %rbp
  8004a2:	48 89 e5             	mov    %rsp,%rbp
  8004a5:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8004ac:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8004b3:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004ba:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004c1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004c8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004cf:	84 c0                	test   %al,%al
  8004d1:	74 20                	je     8004f3 <cprintf+0x52>
  8004d3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004d7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004db:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004df:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004e3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004e7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004eb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004ef:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004f3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004fa:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800501:	00 00 00 
  800504:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80050b:	00 00 00 
  80050e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800512:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800519:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800520:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800527:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80052e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800535:	48 8b 0a             	mov    (%rdx),%rcx
  800538:	48 89 08             	mov    %rcx,(%rax)
  80053b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80053f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800543:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800547:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80054b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800552:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800559:	48 89 d6             	mov    %rdx,%rsi
  80055c:	48 89 c7             	mov    %rax,%rdi
  80055f:	48 b8 f5 03 80 00 00 	movabs $0x8003f5,%rax
  800566:	00 00 00 
  800569:	ff d0                	callq  *%rax
  80056b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800571:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800577:	c9                   	leaveq 
  800578:	c3                   	retq   

0000000000800579 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800579:	55                   	push   %rbp
  80057a:	48 89 e5             	mov    %rsp,%rbp
  80057d:	53                   	push   %rbx
  80057e:	48 83 ec 38          	sub    $0x38,%rsp
  800582:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800586:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80058a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80058e:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800591:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800595:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800599:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80059c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8005a0:	77 3b                	ja     8005dd <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005a2:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8005a5:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8005a9:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8005ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	48 f7 f3             	div    %rbx
  8005b8:	48 89 c2             	mov    %rax,%rdx
  8005bb:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005be:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005c1:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c9:	41 89 f9             	mov    %edi,%r9d
  8005cc:	48 89 c7             	mov    %rax,%rdi
  8005cf:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  8005d6:	00 00 00 
  8005d9:	ff d0                	callq  *%rax
  8005db:	eb 1e                	jmp    8005fb <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005dd:	eb 12                	jmp    8005f1 <printnum+0x78>
			putch(padc, putdat);
  8005df:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005e3:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ea:	48 89 ce             	mov    %rcx,%rsi
  8005ed:	89 d7                	mov    %edx,%edi
  8005ef:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f1:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005f5:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005f9:	7f e4                	jg     8005df <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005fb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800602:	ba 00 00 00 00       	mov    $0x0,%edx
  800607:	48 f7 f1             	div    %rcx
  80060a:	48 89 d0             	mov    %rdx,%rax
  80060d:	48 ba 30 3f 80 00 00 	movabs $0x803f30,%rdx
  800614:	00 00 00 
  800617:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80061b:	0f be d0             	movsbl %al,%edx
  80061e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	48 89 ce             	mov    %rcx,%rsi
  800629:	89 d7                	mov    %edx,%edi
  80062b:	ff d0                	callq  *%rax
}
  80062d:	48 83 c4 38          	add    $0x38,%rsp
  800631:	5b                   	pop    %rbx
  800632:	5d                   	pop    %rbp
  800633:	c3                   	retq   

0000000000800634 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800634:	55                   	push   %rbp
  800635:	48 89 e5             	mov    %rsp,%rbp
  800638:	48 83 ec 1c          	sub    $0x1c,%rsp
  80063c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800640:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800643:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800647:	7e 52                	jle    80069b <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064d:	8b 00                	mov    (%rax),%eax
  80064f:	83 f8 30             	cmp    $0x30,%eax
  800652:	73 24                	jae    800678 <getuint+0x44>
  800654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800658:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80065c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800660:	8b 00                	mov    (%rax),%eax
  800662:	89 c0                	mov    %eax,%eax
  800664:	48 01 d0             	add    %rdx,%rax
  800667:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066b:	8b 12                	mov    (%rdx),%edx
  80066d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800670:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800674:	89 0a                	mov    %ecx,(%rdx)
  800676:	eb 17                	jmp    80068f <getuint+0x5b>
  800678:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800680:	48 89 d0             	mov    %rdx,%rax
  800683:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800687:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80068f:	48 8b 00             	mov    (%rax),%rax
  800692:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800696:	e9 a3 00 00 00       	jmpq   80073e <getuint+0x10a>
	else if (lflag)
  80069b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80069f:	74 4f                	je     8006f0 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8006a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a5:	8b 00                	mov    (%rax),%eax
  8006a7:	83 f8 30             	cmp    $0x30,%eax
  8006aa:	73 24                	jae    8006d0 <getuint+0x9c>
  8006ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b8:	8b 00                	mov    (%rax),%eax
  8006ba:	89 c0                	mov    %eax,%eax
  8006bc:	48 01 d0             	add    %rdx,%rax
  8006bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c3:	8b 12                	mov    (%rdx),%edx
  8006c5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cc:	89 0a                	mov    %ecx,(%rdx)
  8006ce:	eb 17                	jmp    8006e7 <getuint+0xb3>
  8006d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d8:	48 89 d0             	mov    %rdx,%rax
  8006db:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e7:	48 8b 00             	mov    (%rax),%rax
  8006ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006ee:	eb 4e                	jmp    80073e <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f4:	8b 00                	mov    (%rax),%eax
  8006f6:	83 f8 30             	cmp    $0x30,%eax
  8006f9:	73 24                	jae    80071f <getuint+0xeb>
  8006fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ff:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800707:	8b 00                	mov    (%rax),%eax
  800709:	89 c0                	mov    %eax,%eax
  80070b:	48 01 d0             	add    %rdx,%rax
  80070e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800712:	8b 12                	mov    (%rdx),%edx
  800714:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800717:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071b:	89 0a                	mov    %ecx,(%rdx)
  80071d:	eb 17                	jmp    800736 <getuint+0x102>
  80071f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800723:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800727:	48 89 d0             	mov    %rdx,%rax
  80072a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80072e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800732:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800736:	8b 00                	mov    (%rax),%eax
  800738:	89 c0                	mov    %eax,%eax
  80073a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80073e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800742:	c9                   	leaveq 
  800743:	c3                   	retq   

0000000000800744 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800744:	55                   	push   %rbp
  800745:	48 89 e5             	mov    %rsp,%rbp
  800748:	48 83 ec 1c          	sub    $0x1c,%rsp
  80074c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800750:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800753:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800757:	7e 52                	jle    8007ab <getint+0x67>
		x=va_arg(*ap, long long);
  800759:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075d:	8b 00                	mov    (%rax),%eax
  80075f:	83 f8 30             	cmp    $0x30,%eax
  800762:	73 24                	jae    800788 <getint+0x44>
  800764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800768:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80076c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800770:	8b 00                	mov    (%rax),%eax
  800772:	89 c0                	mov    %eax,%eax
  800774:	48 01 d0             	add    %rdx,%rax
  800777:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077b:	8b 12                	mov    (%rdx),%edx
  80077d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800780:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800784:	89 0a                	mov    %ecx,(%rdx)
  800786:	eb 17                	jmp    80079f <getint+0x5b>
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800790:	48 89 d0             	mov    %rdx,%rax
  800793:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800797:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80079f:	48 8b 00             	mov    (%rax),%rax
  8007a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a6:	e9 a3 00 00 00       	jmpq   80084e <getint+0x10a>
	else if (lflag)
  8007ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007af:	74 4f                	je     800800 <getint+0xbc>
		x=va_arg(*ap, long);
  8007b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b5:	8b 00                	mov    (%rax),%eax
  8007b7:	83 f8 30             	cmp    $0x30,%eax
  8007ba:	73 24                	jae    8007e0 <getint+0x9c>
  8007bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c8:	8b 00                	mov    (%rax),%eax
  8007ca:	89 c0                	mov    %eax,%eax
  8007cc:	48 01 d0             	add    %rdx,%rax
  8007cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d3:	8b 12                	mov    (%rdx),%edx
  8007d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007dc:	89 0a                	mov    %ecx,(%rdx)
  8007de:	eb 17                	jmp    8007f7 <getint+0xb3>
  8007e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e8:	48 89 d0             	mov    %rdx,%rax
  8007eb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007f7:	48 8b 00             	mov    (%rax),%rax
  8007fa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007fe:	eb 4e                	jmp    80084e <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800804:	8b 00                	mov    (%rax),%eax
  800806:	83 f8 30             	cmp    $0x30,%eax
  800809:	73 24                	jae    80082f <getint+0xeb>
  80080b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80080f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800817:	8b 00                	mov    (%rax),%eax
  800819:	89 c0                	mov    %eax,%eax
  80081b:	48 01 d0             	add    %rdx,%rax
  80081e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800822:	8b 12                	mov    (%rdx),%edx
  800824:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800827:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082b:	89 0a                	mov    %ecx,(%rdx)
  80082d:	eb 17                	jmp    800846 <getint+0x102>
  80082f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800833:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800837:	48 89 d0             	mov    %rdx,%rax
  80083a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80083e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800842:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800846:	8b 00                	mov    (%rax),%eax
  800848:	48 98                	cltq   
  80084a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80084e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800852:	c9                   	leaveq 
  800853:	c3                   	retq   

0000000000800854 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800854:	55                   	push   %rbp
  800855:	48 89 e5             	mov    %rsp,%rbp
  800858:	41 54                	push   %r12
  80085a:	53                   	push   %rbx
  80085b:	48 83 ec 60          	sub    $0x60,%rsp
  80085f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800863:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800867:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80086b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80086f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800873:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800877:	48 8b 0a             	mov    (%rdx),%rcx
  80087a:	48 89 08             	mov    %rcx,(%rax)
  80087d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800881:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800885:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800889:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088d:	eb 17                	jmp    8008a6 <vprintfmt+0x52>
			if (ch == '\0')
  80088f:	85 db                	test   %ebx,%ebx
  800891:	0f 84 cc 04 00 00    	je     800d63 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800897:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80089b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80089f:	48 89 d6             	mov    %rdx,%rsi
  8008a2:	89 df                	mov    %ebx,%edi
  8008a4:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008aa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008ae:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008b2:	0f b6 00             	movzbl (%rax),%eax
  8008b5:	0f b6 d8             	movzbl %al,%ebx
  8008b8:	83 fb 25             	cmp    $0x25,%ebx
  8008bb:	75 d2                	jne    80088f <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008bd:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008c1:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008c8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008d6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008dd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008e1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008e5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008e9:	0f b6 00             	movzbl (%rax),%eax
  8008ec:	0f b6 d8             	movzbl %al,%ebx
  8008ef:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008f2:	83 f8 55             	cmp    $0x55,%eax
  8008f5:	0f 87 34 04 00 00    	ja     800d2f <vprintfmt+0x4db>
  8008fb:	89 c0                	mov    %eax,%eax
  8008fd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800904:	00 
  800905:	48 b8 58 3f 80 00 00 	movabs $0x803f58,%rax
  80090c:	00 00 00 
  80090f:	48 01 d0             	add    %rdx,%rax
  800912:	48 8b 00             	mov    (%rax),%rax
  800915:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800917:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80091b:	eb c0                	jmp    8008dd <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80091d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800921:	eb ba                	jmp    8008dd <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800923:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80092a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80092d:	89 d0                	mov    %edx,%eax
  80092f:	c1 e0 02             	shl    $0x2,%eax
  800932:	01 d0                	add    %edx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d8                	add    %ebx,%eax
  800938:	83 e8 30             	sub    $0x30,%eax
  80093b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80093e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800942:	0f b6 00             	movzbl (%rax),%eax
  800945:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800948:	83 fb 2f             	cmp    $0x2f,%ebx
  80094b:	7e 0c                	jle    800959 <vprintfmt+0x105>
  80094d:	83 fb 39             	cmp    $0x39,%ebx
  800950:	7f 07                	jg     800959 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800952:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800957:	eb d1                	jmp    80092a <vprintfmt+0xd6>
			goto process_precision;
  800959:	eb 58                	jmp    8009b3 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80095b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095e:	83 f8 30             	cmp    $0x30,%eax
  800961:	73 17                	jae    80097a <vprintfmt+0x126>
  800963:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800967:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096a:	89 c0                	mov    %eax,%eax
  80096c:	48 01 d0             	add    %rdx,%rax
  80096f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800972:	83 c2 08             	add    $0x8,%edx
  800975:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800978:	eb 0f                	jmp    800989 <vprintfmt+0x135>
  80097a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80097e:	48 89 d0             	mov    %rdx,%rax
  800981:	48 83 c2 08          	add    $0x8,%rdx
  800985:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800989:	8b 00                	mov    (%rax),%eax
  80098b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80098e:	eb 23                	jmp    8009b3 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800990:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800994:	79 0c                	jns    8009a2 <vprintfmt+0x14e>
				width = 0;
  800996:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80099d:	e9 3b ff ff ff       	jmpq   8008dd <vprintfmt+0x89>
  8009a2:	e9 36 ff ff ff       	jmpq   8008dd <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8009a7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8009ae:	e9 2a ff ff ff       	jmpq   8008dd <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8009b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009b7:	79 12                	jns    8009cb <vprintfmt+0x177>
				width = precision, precision = -1;
  8009b9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009bc:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009bf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009c6:	e9 12 ff ff ff       	jmpq   8008dd <vprintfmt+0x89>
  8009cb:	e9 0d ff ff ff       	jmpq   8008dd <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009d0:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009d4:	e9 04 ff ff ff       	jmpq   8008dd <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009dc:	83 f8 30             	cmp    $0x30,%eax
  8009df:	73 17                	jae    8009f8 <vprintfmt+0x1a4>
  8009e1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009e8:	89 c0                	mov    %eax,%eax
  8009ea:	48 01 d0             	add    %rdx,%rax
  8009ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009f0:	83 c2 08             	add    $0x8,%edx
  8009f3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009f6:	eb 0f                	jmp    800a07 <vprintfmt+0x1b3>
  8009f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009fc:	48 89 d0             	mov    %rdx,%rax
  8009ff:	48 83 c2 08          	add    $0x8,%rdx
  800a03:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a07:	8b 10                	mov    (%rax),%edx
  800a09:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a11:	48 89 ce             	mov    %rcx,%rsi
  800a14:	89 d7                	mov    %edx,%edi
  800a16:	ff d0                	callq  *%rax
			break;
  800a18:	e9 40 03 00 00       	jmpq   800d5d <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a1d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a20:	83 f8 30             	cmp    $0x30,%eax
  800a23:	73 17                	jae    800a3c <vprintfmt+0x1e8>
  800a25:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a29:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a2c:	89 c0                	mov    %eax,%eax
  800a2e:	48 01 d0             	add    %rdx,%rax
  800a31:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a34:	83 c2 08             	add    $0x8,%edx
  800a37:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a3a:	eb 0f                	jmp    800a4b <vprintfmt+0x1f7>
  800a3c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a40:	48 89 d0             	mov    %rdx,%rax
  800a43:	48 83 c2 08          	add    $0x8,%rdx
  800a47:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a4b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a4d:	85 db                	test   %ebx,%ebx
  800a4f:	79 02                	jns    800a53 <vprintfmt+0x1ff>
				err = -err;
  800a51:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a53:	83 fb 15             	cmp    $0x15,%ebx
  800a56:	7f 16                	jg     800a6e <vprintfmt+0x21a>
  800a58:	48 b8 80 3e 80 00 00 	movabs $0x803e80,%rax
  800a5f:	00 00 00 
  800a62:	48 63 d3             	movslq %ebx,%rdx
  800a65:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a69:	4d 85 e4             	test   %r12,%r12
  800a6c:	75 2e                	jne    800a9c <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a6e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a76:	89 d9                	mov    %ebx,%ecx
  800a78:	48 ba 41 3f 80 00 00 	movabs $0x803f41,%rdx
  800a7f:	00 00 00 
  800a82:	48 89 c7             	mov    %rax,%rdi
  800a85:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8a:	49 b8 6c 0d 80 00 00 	movabs $0x800d6c,%r8
  800a91:	00 00 00 
  800a94:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a97:	e9 c1 02 00 00       	jmpq   800d5d <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aa0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa4:	4c 89 e1             	mov    %r12,%rcx
  800aa7:	48 ba 4a 3f 80 00 00 	movabs $0x803f4a,%rdx
  800aae:	00 00 00 
  800ab1:	48 89 c7             	mov    %rax,%rdi
  800ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab9:	49 b8 6c 0d 80 00 00 	movabs $0x800d6c,%r8
  800ac0:	00 00 00 
  800ac3:	41 ff d0             	callq  *%r8
			break;
  800ac6:	e9 92 02 00 00       	jmpq   800d5d <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800acb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ace:	83 f8 30             	cmp    $0x30,%eax
  800ad1:	73 17                	jae    800aea <vprintfmt+0x296>
  800ad3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ada:	89 c0                	mov    %eax,%eax
  800adc:	48 01 d0             	add    %rdx,%rax
  800adf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae2:	83 c2 08             	add    $0x8,%edx
  800ae5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae8:	eb 0f                	jmp    800af9 <vprintfmt+0x2a5>
  800aea:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aee:	48 89 d0             	mov    %rdx,%rax
  800af1:	48 83 c2 08          	add    $0x8,%rdx
  800af5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800af9:	4c 8b 20             	mov    (%rax),%r12
  800afc:	4d 85 e4             	test   %r12,%r12
  800aff:	75 0a                	jne    800b0b <vprintfmt+0x2b7>
				p = "(null)";
  800b01:	49 bc 4d 3f 80 00 00 	movabs $0x803f4d,%r12
  800b08:	00 00 00 
			if (width > 0 && padc != '-')
  800b0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b0f:	7e 3f                	jle    800b50 <vprintfmt+0x2fc>
  800b11:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800b15:	74 39                	je     800b50 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b17:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b1a:	48 98                	cltq   
  800b1c:	48 89 c6             	mov    %rax,%rsi
  800b1f:	4c 89 e7             	mov    %r12,%rdi
  800b22:	48 b8 18 10 80 00 00 	movabs $0x801018,%rax
  800b29:	00 00 00 
  800b2c:	ff d0                	callq  *%rax
  800b2e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b31:	eb 17                	jmp    800b4a <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b33:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b37:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3f:	48 89 ce             	mov    %rcx,%rsi
  800b42:	89 d7                	mov    %edx,%edi
  800b44:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b46:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b4e:	7f e3                	jg     800b33 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b50:	eb 37                	jmp    800b89 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b52:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b56:	74 1e                	je     800b76 <vprintfmt+0x322>
  800b58:	83 fb 1f             	cmp    $0x1f,%ebx
  800b5b:	7e 05                	jle    800b62 <vprintfmt+0x30e>
  800b5d:	83 fb 7e             	cmp    $0x7e,%ebx
  800b60:	7e 14                	jle    800b76 <vprintfmt+0x322>
					putch('?', putdat);
  800b62:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b66:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b6a:	48 89 d6             	mov    %rdx,%rsi
  800b6d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b72:	ff d0                	callq  *%rax
  800b74:	eb 0f                	jmp    800b85 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b76:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7e:	48 89 d6             	mov    %rdx,%rsi
  800b81:	89 df                	mov    %ebx,%edi
  800b83:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b85:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b89:	4c 89 e0             	mov    %r12,%rax
  800b8c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b90:	0f b6 00             	movzbl (%rax),%eax
  800b93:	0f be d8             	movsbl %al,%ebx
  800b96:	85 db                	test   %ebx,%ebx
  800b98:	74 10                	je     800baa <vprintfmt+0x356>
  800b9a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b9e:	78 b2                	js     800b52 <vprintfmt+0x2fe>
  800ba0:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ba4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ba8:	79 a8                	jns    800b52 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800baa:	eb 16                	jmp    800bc2 <vprintfmt+0x36e>
				putch(' ', putdat);
  800bac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb4:	48 89 d6             	mov    %rdx,%rsi
  800bb7:	bf 20 00 00 00       	mov    $0x20,%edi
  800bbc:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bc2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bc6:	7f e4                	jg     800bac <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bc8:	e9 90 01 00 00       	jmpq   800d5d <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bcd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bd1:	be 03 00 00 00       	mov    $0x3,%esi
  800bd6:	48 89 c7             	mov    %rax,%rdi
  800bd9:	48 b8 44 07 80 00 00 	movabs $0x800744,%rax
  800be0:	00 00 00 
  800be3:	ff d0                	callq  *%rax
  800be5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800be9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bed:	48 85 c0             	test   %rax,%rax
  800bf0:	79 1d                	jns    800c0f <vprintfmt+0x3bb>
				putch('-', putdat);
  800bf2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bf6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bfa:	48 89 d6             	mov    %rdx,%rsi
  800bfd:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c02:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c08:	48 f7 d8             	neg    %rax
  800c0b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800c0f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c16:	e9 d5 00 00 00       	jmpq   800cf0 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c1b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c1f:	be 03 00 00 00       	mov    $0x3,%esi
  800c24:	48 89 c7             	mov    %rax,%rdi
  800c27:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  800c2e:	00 00 00 
  800c31:	ff d0                	callq  *%rax
  800c33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c37:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c3e:	e9 ad 00 00 00       	jmpq   800cf0 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800c43:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c47:	be 03 00 00 00       	mov    $0x3,%esi
  800c4c:	48 89 c7             	mov    %rax,%rdi
  800c4f:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  800c56:	00 00 00 
  800c59:	ff d0                	callq  *%rax
  800c5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800c5f:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800c66:	e9 85 00 00 00       	jmpq   800cf0 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c6b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c73:	48 89 d6             	mov    %rdx,%rsi
  800c76:	bf 30 00 00 00       	mov    $0x30,%edi
  800c7b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c7d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c81:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c85:	48 89 d6             	mov    %rdx,%rsi
  800c88:	bf 78 00 00 00       	mov    $0x78,%edi
  800c8d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c8f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c92:	83 f8 30             	cmp    $0x30,%eax
  800c95:	73 17                	jae    800cae <vprintfmt+0x45a>
  800c97:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c9e:	89 c0                	mov    %eax,%eax
  800ca0:	48 01 d0             	add    %rdx,%rax
  800ca3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca6:	83 c2 08             	add    $0x8,%edx
  800ca9:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cac:	eb 0f                	jmp    800cbd <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800cae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb2:	48 89 d0             	mov    %rdx,%rax
  800cb5:	48 83 c2 08          	add    $0x8,%rdx
  800cb9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cbd:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cc0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cc4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800ccb:	eb 23                	jmp    800cf0 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ccd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cd1:	be 03 00 00 00       	mov    $0x3,%esi
  800cd6:	48 89 c7             	mov    %rax,%rdi
  800cd9:	48 b8 34 06 80 00 00 	movabs $0x800634,%rax
  800ce0:	00 00 00 
  800ce3:	ff d0                	callq  *%rax
  800ce5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ce9:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cf5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cf8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cfb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cff:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d07:	45 89 c1             	mov    %r8d,%r9d
  800d0a:	41 89 f8             	mov    %edi,%r8d
  800d0d:	48 89 c7             	mov    %rax,%rdi
  800d10:	48 b8 79 05 80 00 00 	movabs $0x800579,%rax
  800d17:	00 00 00 
  800d1a:	ff d0                	callq  *%rax
			break;
  800d1c:	eb 3f                	jmp    800d5d <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d26:	48 89 d6             	mov    %rdx,%rsi
  800d29:	89 df                	mov    %ebx,%edi
  800d2b:	ff d0                	callq  *%rax
			break;
  800d2d:	eb 2e                	jmp    800d5d <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d37:	48 89 d6             	mov    %rdx,%rsi
  800d3a:	bf 25 00 00 00       	mov    $0x25,%edi
  800d3f:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d41:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d46:	eb 05                	jmp    800d4d <vprintfmt+0x4f9>
  800d48:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d4d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d51:	48 83 e8 01          	sub    $0x1,%rax
  800d55:	0f b6 00             	movzbl (%rax),%eax
  800d58:	3c 25                	cmp    $0x25,%al
  800d5a:	75 ec                	jne    800d48 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d5c:	90                   	nop
		}
	}
  800d5d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d5e:	e9 43 fb ff ff       	jmpq   8008a6 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d63:	48 83 c4 60          	add    $0x60,%rsp
  800d67:	5b                   	pop    %rbx
  800d68:	41 5c                	pop    %r12
  800d6a:	5d                   	pop    %rbp
  800d6b:	c3                   	retq   

0000000000800d6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d6c:	55                   	push   %rbp
  800d6d:	48 89 e5             	mov    %rsp,%rbp
  800d70:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d77:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d7e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d85:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d8c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d93:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d9a:	84 c0                	test   %al,%al
  800d9c:	74 20                	je     800dbe <printfmt+0x52>
  800d9e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800da2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800da6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800daa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dae:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800db2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800db6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dba:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dbe:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dc5:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dcc:	00 00 00 
  800dcf:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dd6:	00 00 00 
  800dd9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ddd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800de4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800deb:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800df2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800df9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e00:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e07:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e0e:	48 89 c7             	mov    %rax,%rdi
  800e11:	48 b8 54 08 80 00 00 	movabs $0x800854,%rax
  800e18:	00 00 00 
  800e1b:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e1d:	c9                   	leaveq 
  800e1e:	c3                   	retq   

0000000000800e1f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e1f:	55                   	push   %rbp
  800e20:	48 89 e5             	mov    %rsp,%rbp
  800e23:	48 83 ec 10          	sub    $0x10,%rsp
  800e27:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e2a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e32:	8b 40 10             	mov    0x10(%rax),%eax
  800e35:	8d 50 01             	lea    0x1(%rax),%edx
  800e38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3c:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e43:	48 8b 10             	mov    (%rax),%rdx
  800e46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e4a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e4e:	48 39 c2             	cmp    %rax,%rdx
  800e51:	73 17                	jae    800e6a <sprintputch+0x4b>
		*b->buf++ = ch;
  800e53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e57:	48 8b 00             	mov    (%rax),%rax
  800e5a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e62:	48 89 0a             	mov    %rcx,(%rdx)
  800e65:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e68:	88 10                	mov    %dl,(%rax)
}
  800e6a:	c9                   	leaveq 
  800e6b:	c3                   	retq   

0000000000800e6c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e6c:	55                   	push   %rbp
  800e6d:	48 89 e5             	mov    %rsp,%rbp
  800e70:	48 83 ec 50          	sub    $0x50,%rsp
  800e74:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e78:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e7b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e7f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e83:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e87:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e8b:	48 8b 0a             	mov    (%rdx),%rcx
  800e8e:	48 89 08             	mov    %rcx,(%rax)
  800e91:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e95:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e99:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e9d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ea1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ea5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ea9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800eac:	48 98                	cltq   
  800eae:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800eb2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb6:	48 01 d0             	add    %rdx,%rax
  800eb9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800ebd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ec4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ec9:	74 06                	je     800ed1 <vsnprintf+0x65>
  800ecb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ecf:	7f 07                	jg     800ed8 <vsnprintf+0x6c>
		return -E_INVAL;
  800ed1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed6:	eb 2f                	jmp    800f07 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ed8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800edc:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800ee0:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800ee4:	48 89 c6             	mov    %rax,%rsi
  800ee7:	48 bf 1f 0e 80 00 00 	movabs $0x800e1f,%rdi
  800eee:	00 00 00 
  800ef1:	48 b8 54 08 80 00 00 	movabs $0x800854,%rax
  800ef8:	00 00 00 
  800efb:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800efd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f01:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f04:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f07:	c9                   	leaveq 
  800f08:	c3                   	retq   

0000000000800f09 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f09:	55                   	push   %rbp
  800f0a:	48 89 e5             	mov    %rsp,%rbp
  800f0d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f14:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f1b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f21:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f28:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f2f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f36:	84 c0                	test   %al,%al
  800f38:	74 20                	je     800f5a <snprintf+0x51>
  800f3a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f3e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f42:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f46:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f4a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f4e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f52:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f56:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f5a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f61:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f68:	00 00 00 
  800f6b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f72:	00 00 00 
  800f75:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f79:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f80:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f87:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f8e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f95:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f9c:	48 8b 0a             	mov    (%rdx),%rcx
  800f9f:	48 89 08             	mov    %rcx,(%rax)
  800fa2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fa6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800faa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fae:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fb2:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fb9:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fc0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fc6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fcd:	48 89 c7             	mov    %rax,%rdi
  800fd0:	48 b8 6c 0e 80 00 00 	movabs $0x800e6c,%rax
  800fd7:	00 00 00 
  800fda:	ff d0                	callq  *%rax
  800fdc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fe2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fe8:	c9                   	leaveq 
  800fe9:	c3                   	retq   

0000000000800fea <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fea:	55                   	push   %rbp
  800feb:	48 89 e5             	mov    %rsp,%rbp
  800fee:	48 83 ec 18          	sub    $0x18,%rsp
  800ff2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ffd:	eb 09                	jmp    801008 <strlen+0x1e>
		n++;
  800fff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801003:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801008:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100c:	0f b6 00             	movzbl (%rax),%eax
  80100f:	84 c0                	test   %al,%al
  801011:	75 ec                	jne    800fff <strlen+0x15>
		n++;
	return n;
  801013:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801016:	c9                   	leaveq 
  801017:	c3                   	retq   

0000000000801018 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801018:	55                   	push   %rbp
  801019:	48 89 e5             	mov    %rsp,%rbp
  80101c:	48 83 ec 20          	sub    $0x20,%rsp
  801020:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801024:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801028:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80102f:	eb 0e                	jmp    80103f <strnlen+0x27>
		n++;
  801031:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801035:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80103a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80103f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801044:	74 0b                	je     801051 <strnlen+0x39>
  801046:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104a:	0f b6 00             	movzbl (%rax),%eax
  80104d:	84 c0                	test   %al,%al
  80104f:	75 e0                	jne    801031 <strnlen+0x19>
		n++;
	return n;
  801051:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801054:	c9                   	leaveq 
  801055:	c3                   	retq   

0000000000801056 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801056:	55                   	push   %rbp
  801057:	48 89 e5             	mov    %rsp,%rbp
  80105a:	48 83 ec 20          	sub    $0x20,%rsp
  80105e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801062:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80106e:	90                   	nop
  80106f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801073:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801077:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80107b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80107f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801083:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801087:	0f b6 12             	movzbl (%rdx),%edx
  80108a:	88 10                	mov    %dl,(%rax)
  80108c:	0f b6 00             	movzbl (%rax),%eax
  80108f:	84 c0                	test   %al,%al
  801091:	75 dc                	jne    80106f <strcpy+0x19>
		/* do nothing */;
	return ret;
  801093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801097:	c9                   	leaveq 
  801098:	c3                   	retq   

0000000000801099 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801099:	55                   	push   %rbp
  80109a:	48 89 e5             	mov    %rsp,%rbp
  80109d:	48 83 ec 20          	sub    $0x20,%rsp
  8010a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ad:	48 89 c7             	mov    %rax,%rdi
  8010b0:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  8010b7:	00 00 00 
  8010ba:	ff d0                	callq  *%rax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010c2:	48 63 d0             	movslq %eax,%rdx
  8010c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c9:	48 01 c2             	add    %rax,%rdx
  8010cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d0:	48 89 c6             	mov    %rax,%rsi
  8010d3:	48 89 d7             	mov    %rdx,%rdi
  8010d6:	48 b8 56 10 80 00 00 	movabs $0x801056,%rax
  8010dd:	00 00 00 
  8010e0:	ff d0                	callq  *%rax
	return dst;
  8010e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010e6:	c9                   	leaveq 
  8010e7:	c3                   	retq   

00000000008010e8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010e8:	55                   	push   %rbp
  8010e9:	48 89 e5             	mov    %rsp,%rbp
  8010ec:	48 83 ec 28          	sub    $0x28,%rsp
  8010f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801100:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801104:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80110b:	00 
  80110c:	eb 2a                	jmp    801138 <strncpy+0x50>
		*dst++ = *src;
  80110e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801112:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801116:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80111a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80111e:	0f b6 12             	movzbl (%rdx),%edx
  801121:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801123:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801127:	0f b6 00             	movzbl (%rax),%eax
  80112a:	84 c0                	test   %al,%al
  80112c:	74 05                	je     801133 <strncpy+0x4b>
			src++;
  80112e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801133:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801138:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801140:	72 cc                	jb     80110e <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801142:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801146:	c9                   	leaveq 
  801147:	c3                   	retq   

0000000000801148 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801148:	55                   	push   %rbp
  801149:	48 89 e5             	mov    %rsp,%rbp
  80114c:	48 83 ec 28          	sub    $0x28,%rsp
  801150:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801154:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801158:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80115c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801160:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801164:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801169:	74 3d                	je     8011a8 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80116b:	eb 1d                	jmp    80118a <strlcpy+0x42>
			*dst++ = *src++;
  80116d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801171:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801175:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801179:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80117d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801181:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801185:	0f b6 12             	movzbl (%rdx),%edx
  801188:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80118a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80118f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801194:	74 0b                	je     8011a1 <strlcpy+0x59>
  801196:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80119a:	0f b6 00             	movzbl (%rax),%eax
  80119d:	84 c0                	test   %al,%al
  80119f:	75 cc                	jne    80116d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8011a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b0:	48 29 c2             	sub    %rax,%rdx
  8011b3:	48 89 d0             	mov    %rdx,%rax
}
  8011b6:	c9                   	leaveq 
  8011b7:	c3                   	retq   

00000000008011b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011b8:	55                   	push   %rbp
  8011b9:	48 89 e5             	mov    %rsp,%rbp
  8011bc:	48 83 ec 10          	sub    $0x10,%rsp
  8011c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011c8:	eb 0a                	jmp    8011d4 <strcmp+0x1c>
		p++, q++;
  8011ca:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011cf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d8:	0f b6 00             	movzbl (%rax),%eax
  8011db:	84 c0                	test   %al,%al
  8011dd:	74 12                	je     8011f1 <strcmp+0x39>
  8011df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e3:	0f b6 10             	movzbl (%rax),%edx
  8011e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ea:	0f b6 00             	movzbl (%rax),%eax
  8011ed:	38 c2                	cmp    %al,%dl
  8011ef:	74 d9                	je     8011ca <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f5:	0f b6 00             	movzbl (%rax),%eax
  8011f8:	0f b6 d0             	movzbl %al,%edx
  8011fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ff:	0f b6 00             	movzbl (%rax),%eax
  801202:	0f b6 c0             	movzbl %al,%eax
  801205:	29 c2                	sub    %eax,%edx
  801207:	89 d0                	mov    %edx,%eax
}
  801209:	c9                   	leaveq 
  80120a:	c3                   	retq   

000000000080120b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80120b:	55                   	push   %rbp
  80120c:	48 89 e5             	mov    %rsp,%rbp
  80120f:	48 83 ec 18          	sub    $0x18,%rsp
  801213:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801217:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80121b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80121f:	eb 0f                	jmp    801230 <strncmp+0x25>
		n--, p++, q++;
  801221:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801226:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80122b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801230:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801235:	74 1d                	je     801254 <strncmp+0x49>
  801237:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123b:	0f b6 00             	movzbl (%rax),%eax
  80123e:	84 c0                	test   %al,%al
  801240:	74 12                	je     801254 <strncmp+0x49>
  801242:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801246:	0f b6 10             	movzbl (%rax),%edx
  801249:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124d:	0f b6 00             	movzbl (%rax),%eax
  801250:	38 c2                	cmp    %al,%dl
  801252:	74 cd                	je     801221 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801254:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801259:	75 07                	jne    801262 <strncmp+0x57>
		return 0;
  80125b:	b8 00 00 00 00       	mov    $0x0,%eax
  801260:	eb 18                	jmp    80127a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801266:	0f b6 00             	movzbl (%rax),%eax
  801269:	0f b6 d0             	movzbl %al,%edx
  80126c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801270:	0f b6 00             	movzbl (%rax),%eax
  801273:	0f b6 c0             	movzbl %al,%eax
  801276:	29 c2                	sub    %eax,%edx
  801278:	89 d0                	mov    %edx,%eax
}
  80127a:	c9                   	leaveq 
  80127b:	c3                   	retq   

000000000080127c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80127c:	55                   	push   %rbp
  80127d:	48 89 e5             	mov    %rsp,%rbp
  801280:	48 83 ec 0c          	sub    $0xc,%rsp
  801284:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801288:	89 f0                	mov    %esi,%eax
  80128a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80128d:	eb 17                	jmp    8012a6 <strchr+0x2a>
		if (*s == c)
  80128f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801293:	0f b6 00             	movzbl (%rax),%eax
  801296:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801299:	75 06                	jne    8012a1 <strchr+0x25>
			return (char *) s;
  80129b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129f:	eb 15                	jmp    8012b6 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012aa:	0f b6 00             	movzbl (%rax),%eax
  8012ad:	84 c0                	test   %al,%al
  8012af:	75 de                	jne    80128f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b6:	c9                   	leaveq 
  8012b7:	c3                   	retq   

00000000008012b8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b8:	55                   	push   %rbp
  8012b9:	48 89 e5             	mov    %rsp,%rbp
  8012bc:	48 83 ec 0c          	sub    $0xc,%rsp
  8012c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c4:	89 f0                	mov    %esi,%eax
  8012c6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012c9:	eb 13                	jmp    8012de <strfind+0x26>
		if (*s == c)
  8012cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cf:	0f b6 00             	movzbl (%rax),%eax
  8012d2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012d5:	75 02                	jne    8012d9 <strfind+0x21>
			break;
  8012d7:	eb 10                	jmp    8012e9 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e2:	0f b6 00             	movzbl (%rax),%eax
  8012e5:	84 c0                	test   %al,%al
  8012e7:	75 e2                	jne    8012cb <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012ed:	c9                   	leaveq 
  8012ee:	c3                   	retq   

00000000008012ef <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012ef:	55                   	push   %rbp
  8012f0:	48 89 e5             	mov    %rsp,%rbp
  8012f3:	48 83 ec 18          	sub    $0x18,%rsp
  8012f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012fb:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012fe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801302:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801307:	75 06                	jne    80130f <memset+0x20>
		return v;
  801309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130d:	eb 69                	jmp    801378 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80130f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801313:	83 e0 03             	and    $0x3,%eax
  801316:	48 85 c0             	test   %rax,%rax
  801319:	75 48                	jne    801363 <memset+0x74>
  80131b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131f:	83 e0 03             	and    $0x3,%eax
  801322:	48 85 c0             	test   %rax,%rax
  801325:	75 3c                	jne    801363 <memset+0x74>
		c &= 0xFF;
  801327:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80132e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801331:	c1 e0 18             	shl    $0x18,%eax
  801334:	89 c2                	mov    %eax,%edx
  801336:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801339:	c1 e0 10             	shl    $0x10,%eax
  80133c:	09 c2                	or     %eax,%edx
  80133e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801341:	c1 e0 08             	shl    $0x8,%eax
  801344:	09 d0                	or     %edx,%eax
  801346:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801349:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134d:	48 c1 e8 02          	shr    $0x2,%rax
  801351:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801354:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801358:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80135b:	48 89 d7             	mov    %rdx,%rdi
  80135e:	fc                   	cld    
  80135f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801361:	eb 11                	jmp    801374 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801363:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801367:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80136a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80136e:	48 89 d7             	mov    %rdx,%rdi
  801371:	fc                   	cld    
  801372:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801374:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801378:	c9                   	leaveq 
  801379:	c3                   	retq   

000000000080137a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80137a:	55                   	push   %rbp
  80137b:	48 89 e5             	mov    %rsp,%rbp
  80137e:	48 83 ec 28          	sub    $0x28,%rsp
  801382:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801386:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80138a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80138e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801392:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801396:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80139e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a6:	0f 83 88 00 00 00    	jae    801434 <memmove+0xba>
  8013ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b4:	48 01 d0             	add    %rdx,%rax
  8013b7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013bb:	76 77                	jbe    801434 <memmove+0xba>
		s += n;
  8013bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d1:	83 e0 03             	and    $0x3,%eax
  8013d4:	48 85 c0             	test   %rax,%rax
  8013d7:	75 3b                	jne    801414 <memmove+0x9a>
  8013d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013dd:	83 e0 03             	and    $0x3,%eax
  8013e0:	48 85 c0             	test   %rax,%rax
  8013e3:	75 2f                	jne    801414 <memmove+0x9a>
  8013e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e9:	83 e0 03             	and    $0x3,%eax
  8013ec:	48 85 c0             	test   %rax,%rax
  8013ef:	75 23                	jne    801414 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f5:	48 83 e8 04          	sub    $0x4,%rax
  8013f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013fd:	48 83 ea 04          	sub    $0x4,%rdx
  801401:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801405:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801409:	48 89 c7             	mov    %rax,%rdi
  80140c:	48 89 d6             	mov    %rdx,%rsi
  80140f:	fd                   	std    
  801410:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801412:	eb 1d                	jmp    801431 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801414:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801418:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80141c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801420:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801424:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801428:	48 89 d7             	mov    %rdx,%rdi
  80142b:	48 89 c1             	mov    %rax,%rcx
  80142e:	fd                   	std    
  80142f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801431:	fc                   	cld    
  801432:	eb 57                	jmp    80148b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801438:	83 e0 03             	and    $0x3,%eax
  80143b:	48 85 c0             	test   %rax,%rax
  80143e:	75 36                	jne    801476 <memmove+0xfc>
  801440:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801444:	83 e0 03             	and    $0x3,%eax
  801447:	48 85 c0             	test   %rax,%rax
  80144a:	75 2a                	jne    801476 <memmove+0xfc>
  80144c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801450:	83 e0 03             	and    $0x3,%eax
  801453:	48 85 c0             	test   %rax,%rax
  801456:	75 1e                	jne    801476 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801458:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145c:	48 c1 e8 02          	shr    $0x2,%rax
  801460:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801463:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801467:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80146b:	48 89 c7             	mov    %rax,%rdi
  80146e:	48 89 d6             	mov    %rdx,%rsi
  801471:	fc                   	cld    
  801472:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801474:	eb 15                	jmp    80148b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80147e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801482:	48 89 c7             	mov    %rax,%rdi
  801485:	48 89 d6             	mov    %rdx,%rsi
  801488:	fc                   	cld    
  801489:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80148b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80148f:	c9                   	leaveq 
  801490:	c3                   	retq   

0000000000801491 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801491:	55                   	push   %rbp
  801492:	48 89 e5             	mov    %rsp,%rbp
  801495:	48 83 ec 18          	sub    $0x18,%rsp
  801499:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80149d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8014a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014a9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b1:	48 89 ce             	mov    %rcx,%rsi
  8014b4:	48 89 c7             	mov    %rax,%rdi
  8014b7:	48 b8 7a 13 80 00 00 	movabs $0x80137a,%rax
  8014be:	00 00 00 
  8014c1:	ff d0                	callq  *%rax
}
  8014c3:	c9                   	leaveq 
  8014c4:	c3                   	retq   

00000000008014c5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014c5:	55                   	push   %rbp
  8014c6:	48 89 e5             	mov    %rsp,%rbp
  8014c9:	48 83 ec 28          	sub    $0x28,%rsp
  8014cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014e9:	eb 36                	jmp    801521 <memcmp+0x5c>
		if (*s1 != *s2)
  8014eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ef:	0f b6 10             	movzbl (%rax),%edx
  8014f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f6:	0f b6 00             	movzbl (%rax),%eax
  8014f9:	38 c2                	cmp    %al,%dl
  8014fb:	74 1a                	je     801517 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801501:	0f b6 00             	movzbl (%rax),%eax
  801504:	0f b6 d0             	movzbl %al,%edx
  801507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150b:	0f b6 00             	movzbl (%rax),%eax
  80150e:	0f b6 c0             	movzbl %al,%eax
  801511:	29 c2                	sub    %eax,%edx
  801513:	89 d0                	mov    %edx,%eax
  801515:	eb 20                	jmp    801537 <memcmp+0x72>
		s1++, s2++;
  801517:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80151c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801525:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801529:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80152d:	48 85 c0             	test   %rax,%rax
  801530:	75 b9                	jne    8014eb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801537:	c9                   	leaveq 
  801538:	c3                   	retq   

0000000000801539 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801539:	55                   	push   %rbp
  80153a:	48 89 e5             	mov    %rsp,%rbp
  80153d:	48 83 ec 28          	sub    $0x28,%rsp
  801541:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801545:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801548:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80154c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801550:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801554:	48 01 d0             	add    %rdx,%rax
  801557:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80155b:	eb 15                	jmp    801572 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80155d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801561:	0f b6 10             	movzbl (%rax),%edx
  801564:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801567:	38 c2                	cmp    %al,%dl
  801569:	75 02                	jne    80156d <memfind+0x34>
			break;
  80156b:	eb 0f                	jmp    80157c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80156d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801576:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80157a:	72 e1                	jb     80155d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80157c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801580:	c9                   	leaveq 
  801581:	c3                   	retq   

0000000000801582 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801582:	55                   	push   %rbp
  801583:	48 89 e5             	mov    %rsp,%rbp
  801586:	48 83 ec 34          	sub    $0x34,%rsp
  80158a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80158e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801592:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801595:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80159c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8015a3:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a4:	eb 05                	jmp    8015ab <strtol+0x29>
		s++;
  8015a6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015af:	0f b6 00             	movzbl (%rax),%eax
  8015b2:	3c 20                	cmp    $0x20,%al
  8015b4:	74 f0                	je     8015a6 <strtol+0x24>
  8015b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ba:	0f b6 00             	movzbl (%rax),%eax
  8015bd:	3c 09                	cmp    $0x9,%al
  8015bf:	74 e5                	je     8015a6 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c5:	0f b6 00             	movzbl (%rax),%eax
  8015c8:	3c 2b                	cmp    $0x2b,%al
  8015ca:	75 07                	jne    8015d3 <strtol+0x51>
		s++;
  8015cc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d1:	eb 17                	jmp    8015ea <strtol+0x68>
	else if (*s == '-')
  8015d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d7:	0f b6 00             	movzbl (%rax),%eax
  8015da:	3c 2d                	cmp    $0x2d,%al
  8015dc:	75 0c                	jne    8015ea <strtol+0x68>
		s++, neg = 1;
  8015de:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015e3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ea:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015ee:	74 06                	je     8015f6 <strtol+0x74>
  8015f0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015f4:	75 28                	jne    80161e <strtol+0x9c>
  8015f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fa:	0f b6 00             	movzbl (%rax),%eax
  8015fd:	3c 30                	cmp    $0x30,%al
  8015ff:	75 1d                	jne    80161e <strtol+0x9c>
  801601:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801605:	48 83 c0 01          	add    $0x1,%rax
  801609:	0f b6 00             	movzbl (%rax),%eax
  80160c:	3c 78                	cmp    $0x78,%al
  80160e:	75 0e                	jne    80161e <strtol+0x9c>
		s += 2, base = 16;
  801610:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801615:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80161c:	eb 2c                	jmp    80164a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80161e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801622:	75 19                	jne    80163d <strtol+0xbb>
  801624:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801628:	0f b6 00             	movzbl (%rax),%eax
  80162b:	3c 30                	cmp    $0x30,%al
  80162d:	75 0e                	jne    80163d <strtol+0xbb>
		s++, base = 8;
  80162f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801634:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80163b:	eb 0d                	jmp    80164a <strtol+0xc8>
	else if (base == 0)
  80163d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801641:	75 07                	jne    80164a <strtol+0xc8>
		base = 10;
  801643:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80164a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164e:	0f b6 00             	movzbl (%rax),%eax
  801651:	3c 2f                	cmp    $0x2f,%al
  801653:	7e 1d                	jle    801672 <strtol+0xf0>
  801655:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801659:	0f b6 00             	movzbl (%rax),%eax
  80165c:	3c 39                	cmp    $0x39,%al
  80165e:	7f 12                	jg     801672 <strtol+0xf0>
			dig = *s - '0';
  801660:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801664:	0f b6 00             	movzbl (%rax),%eax
  801667:	0f be c0             	movsbl %al,%eax
  80166a:	83 e8 30             	sub    $0x30,%eax
  80166d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801670:	eb 4e                	jmp    8016c0 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801672:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801676:	0f b6 00             	movzbl (%rax),%eax
  801679:	3c 60                	cmp    $0x60,%al
  80167b:	7e 1d                	jle    80169a <strtol+0x118>
  80167d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801681:	0f b6 00             	movzbl (%rax),%eax
  801684:	3c 7a                	cmp    $0x7a,%al
  801686:	7f 12                	jg     80169a <strtol+0x118>
			dig = *s - 'a' + 10;
  801688:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168c:	0f b6 00             	movzbl (%rax),%eax
  80168f:	0f be c0             	movsbl %al,%eax
  801692:	83 e8 57             	sub    $0x57,%eax
  801695:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801698:	eb 26                	jmp    8016c0 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80169a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80169e:	0f b6 00             	movzbl (%rax),%eax
  8016a1:	3c 40                	cmp    $0x40,%al
  8016a3:	7e 48                	jle    8016ed <strtol+0x16b>
  8016a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a9:	0f b6 00             	movzbl (%rax),%eax
  8016ac:	3c 5a                	cmp    $0x5a,%al
  8016ae:	7f 3d                	jg     8016ed <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b4:	0f b6 00             	movzbl (%rax),%eax
  8016b7:	0f be c0             	movsbl %al,%eax
  8016ba:	83 e8 37             	sub    $0x37,%eax
  8016bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016c0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016c3:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016c6:	7c 02                	jl     8016ca <strtol+0x148>
			break;
  8016c8:	eb 23                	jmp    8016ed <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016ca:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016cf:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016d2:	48 98                	cltq   
  8016d4:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016d9:	48 89 c2             	mov    %rax,%rdx
  8016dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016df:	48 98                	cltq   
  8016e1:	48 01 d0             	add    %rdx,%rax
  8016e4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016e8:	e9 5d ff ff ff       	jmpq   80164a <strtol+0xc8>

	if (endptr)
  8016ed:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016f2:	74 0b                	je     8016ff <strtol+0x17d>
		*endptr = (char *) s;
  8016f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016fc:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801703:	74 09                	je     80170e <strtol+0x18c>
  801705:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801709:	48 f7 d8             	neg    %rax
  80170c:	eb 04                	jmp    801712 <strtol+0x190>
  80170e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801712:	c9                   	leaveq 
  801713:	c3                   	retq   

0000000000801714 <strstr>:

char * strstr(const char *in, const char *str)
{
  801714:	55                   	push   %rbp
  801715:	48 89 e5             	mov    %rsp,%rbp
  801718:	48 83 ec 30          	sub    $0x30,%rsp
  80171c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801720:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801724:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801728:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80172c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801730:	0f b6 00             	movzbl (%rax),%eax
  801733:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801736:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80173a:	75 06                	jne    801742 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80173c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801740:	eb 6b                	jmp    8017ad <strstr+0x99>

	len = strlen(str);
  801742:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801746:	48 89 c7             	mov    %rax,%rdi
  801749:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  801750:	00 00 00 
  801753:	ff d0                	callq  *%rax
  801755:	48 98                	cltq   
  801757:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80175b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801763:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801767:	0f b6 00             	movzbl (%rax),%eax
  80176a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80176d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801771:	75 07                	jne    80177a <strstr+0x66>
				return (char *) 0;
  801773:	b8 00 00 00 00       	mov    $0x0,%eax
  801778:	eb 33                	jmp    8017ad <strstr+0x99>
		} while (sc != c);
  80177a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80177e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801781:	75 d8                	jne    80175b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801783:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801787:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80178b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178f:	48 89 ce             	mov    %rcx,%rsi
  801792:	48 89 c7             	mov    %rax,%rdi
  801795:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  80179c:	00 00 00 
  80179f:	ff d0                	callq  *%rax
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	75 b6                	jne    80175b <strstr+0x47>

	return (char *) (in - 1);
  8017a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a9:	48 83 e8 01          	sub    $0x1,%rax
}
  8017ad:	c9                   	leaveq 
  8017ae:	c3                   	retq   

00000000008017af <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017af:	55                   	push   %rbp
  8017b0:	48 89 e5             	mov    %rsp,%rbp
  8017b3:	53                   	push   %rbx
  8017b4:	48 83 ec 48          	sub    $0x48,%rsp
  8017b8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017bb:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017be:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017c2:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017c6:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017ca:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8017ce:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017d1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017d5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017d9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017dd:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017e1:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017e5:	4c 89 c3             	mov    %r8,%rbx
  8017e8:	cd 30                	int    $0x30
  8017ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  8017ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017f2:	74 3e                	je     801832 <syscall+0x83>
  8017f4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017f9:	7e 37                	jle    801832 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801802:	49 89 d0             	mov    %rdx,%r8
  801805:	89 c1                	mov    %eax,%ecx
  801807:	48 ba 08 42 80 00 00 	movabs $0x804208,%rdx
  80180e:	00 00 00 
  801811:	be 4a 00 00 00       	mov    $0x4a,%esi
  801816:	48 bf 25 42 80 00 00 	movabs $0x804225,%rdi
  80181d:	00 00 00 
  801820:	b8 00 00 00 00       	mov    $0x0,%eax
  801825:	49 b9 68 02 80 00 00 	movabs $0x800268,%r9
  80182c:	00 00 00 
  80182f:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801832:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801836:	48 83 c4 48          	add    $0x48,%rsp
  80183a:	5b                   	pop    %rbx
  80183b:	5d                   	pop    %rbp
  80183c:	c3                   	retq   

000000000080183d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80183d:	55                   	push   %rbp
  80183e:	48 89 e5             	mov    %rsp,%rbp
  801841:	48 83 ec 20          	sub    $0x20,%rsp
  801845:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801849:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80184d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801851:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801855:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80185c:	00 
  80185d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801863:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801869:	48 89 d1             	mov    %rdx,%rcx
  80186c:	48 89 c2             	mov    %rax,%rdx
  80186f:	be 00 00 00 00       	mov    $0x0,%esi
  801874:	bf 00 00 00 00       	mov    $0x0,%edi
  801879:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  801880:	00 00 00 
  801883:	ff d0                	callq  *%rax
}
  801885:	c9                   	leaveq 
  801886:	c3                   	retq   

0000000000801887 <sys_cgetc>:

int
sys_cgetc(void)
{
  801887:	55                   	push   %rbp
  801888:	48 89 e5             	mov    %rsp,%rbp
  80188b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80188f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801896:	00 
  801897:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80189d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ad:	be 00 00 00 00       	mov    $0x0,%esi
  8018b2:	bf 01 00 00 00       	mov    $0x1,%edi
  8018b7:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  8018be:	00 00 00 
  8018c1:	ff d0                	callq  *%rax
}
  8018c3:	c9                   	leaveq 
  8018c4:	c3                   	retq   

00000000008018c5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018c5:	55                   	push   %rbp
  8018c6:	48 89 e5             	mov    %rsp,%rbp
  8018c9:	48 83 ec 10          	sub    $0x10,%rsp
  8018cd:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d3:	48 98                	cltq   
  8018d5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018dc:	00 
  8018dd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018ee:	48 89 c2             	mov    %rax,%rdx
  8018f1:	be 01 00 00 00       	mov    $0x1,%esi
  8018f6:	bf 03 00 00 00       	mov    $0x3,%edi
  8018fb:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  801902:	00 00 00 
  801905:	ff d0                	callq  *%rax
}
  801907:	c9                   	leaveq 
  801908:	c3                   	retq   

0000000000801909 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801909:	55                   	push   %rbp
  80190a:	48 89 e5             	mov    %rsp,%rbp
  80190d:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801911:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801918:	00 
  801919:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801925:	b9 00 00 00 00       	mov    $0x0,%ecx
  80192a:	ba 00 00 00 00       	mov    $0x0,%edx
  80192f:	be 00 00 00 00       	mov    $0x0,%esi
  801934:	bf 02 00 00 00       	mov    $0x2,%edi
  801939:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  801940:	00 00 00 
  801943:	ff d0                	callq  *%rax
}
  801945:	c9                   	leaveq 
  801946:	c3                   	retq   

0000000000801947 <sys_yield>:

void
sys_yield(void)
{
  801947:	55                   	push   %rbp
  801948:	48 89 e5             	mov    %rsp,%rbp
  80194b:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80194f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801956:	00 
  801957:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801963:	b9 00 00 00 00       	mov    $0x0,%ecx
  801968:	ba 00 00 00 00       	mov    $0x0,%edx
  80196d:	be 00 00 00 00       	mov    $0x0,%esi
  801972:	bf 0b 00 00 00       	mov    $0xb,%edi
  801977:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  80197e:	00 00 00 
  801981:	ff d0                	callq  *%rax
}
  801983:	c9                   	leaveq 
  801984:	c3                   	retq   

0000000000801985 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801985:	55                   	push   %rbp
  801986:	48 89 e5             	mov    %rsp,%rbp
  801989:	48 83 ec 20          	sub    $0x20,%rsp
  80198d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801990:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801994:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801997:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80199a:	48 63 c8             	movslq %eax,%rcx
  80199d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a4:	48 98                	cltq   
  8019a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ad:	00 
  8019ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b4:	49 89 c8             	mov    %rcx,%r8
  8019b7:	48 89 d1             	mov    %rdx,%rcx
  8019ba:	48 89 c2             	mov    %rax,%rdx
  8019bd:	be 01 00 00 00       	mov    $0x1,%esi
  8019c2:	bf 04 00 00 00       	mov    $0x4,%edi
  8019c7:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  8019ce:	00 00 00 
  8019d1:	ff d0                	callq  *%rax
}
  8019d3:	c9                   	leaveq 
  8019d4:	c3                   	retq   

00000000008019d5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019d5:	55                   	push   %rbp
  8019d6:	48 89 e5             	mov    %rsp,%rbp
  8019d9:	48 83 ec 30          	sub    $0x30,%rsp
  8019dd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019e4:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019e7:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019eb:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019ef:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019f2:	48 63 c8             	movslq %eax,%rcx
  8019f5:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019fc:	48 63 f0             	movslq %eax,%rsi
  8019ff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a06:	48 98                	cltq   
  801a08:	48 89 0c 24          	mov    %rcx,(%rsp)
  801a0c:	49 89 f9             	mov    %rdi,%r9
  801a0f:	49 89 f0             	mov    %rsi,%r8
  801a12:	48 89 d1             	mov    %rdx,%rcx
  801a15:	48 89 c2             	mov    %rax,%rdx
  801a18:	be 01 00 00 00       	mov    $0x1,%esi
  801a1d:	bf 05 00 00 00       	mov    $0x5,%edi
  801a22:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  801a29:	00 00 00 
  801a2c:	ff d0                	callq  *%rax
}
  801a2e:	c9                   	leaveq 
  801a2f:	c3                   	retq   

0000000000801a30 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801a30:	55                   	push   %rbp
  801a31:	48 89 e5             	mov    %rsp,%rbp
  801a34:	48 83 ec 20          	sub    $0x20,%rsp
  801a38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a3b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a3f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a46:	48 98                	cltq   
  801a48:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a4f:	00 
  801a50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5c:	48 89 d1             	mov    %rdx,%rcx
  801a5f:	48 89 c2             	mov    %rax,%rdx
  801a62:	be 01 00 00 00       	mov    $0x1,%esi
  801a67:	bf 06 00 00 00       	mov    $0x6,%edi
  801a6c:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  801a73:	00 00 00 
  801a76:	ff d0                	callq  *%rax
}
  801a78:	c9                   	leaveq 
  801a79:	c3                   	retq   

0000000000801a7a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a7a:	55                   	push   %rbp
  801a7b:	48 89 e5             	mov    %rsp,%rbp
  801a7e:	48 83 ec 10          	sub    $0x10,%rsp
  801a82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a85:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a88:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a8b:	48 63 d0             	movslq %eax,%rdx
  801a8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a91:	48 98                	cltq   
  801a93:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a9a:	00 
  801a9b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa7:	48 89 d1             	mov    %rdx,%rcx
  801aaa:	48 89 c2             	mov    %rax,%rdx
  801aad:	be 01 00 00 00       	mov    $0x1,%esi
  801ab2:	bf 08 00 00 00       	mov    $0x8,%edi
  801ab7:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  801abe:	00 00 00 
  801ac1:	ff d0                	callq  *%rax
}
  801ac3:	c9                   	leaveq 
  801ac4:	c3                   	retq   

0000000000801ac5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801ac5:	55                   	push   %rbp
  801ac6:	48 89 e5             	mov    %rsp,%rbp
  801ac9:	48 83 ec 20          	sub    $0x20,%rsp
  801acd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ad4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801adb:	48 98                	cltq   
  801add:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae4:	00 
  801ae5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aeb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af1:	48 89 d1             	mov    %rdx,%rcx
  801af4:	48 89 c2             	mov    %rax,%rdx
  801af7:	be 01 00 00 00       	mov    $0x1,%esi
  801afc:	bf 09 00 00 00       	mov    $0x9,%edi
  801b01:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  801b08:	00 00 00 
  801b0b:	ff d0                	callq  *%rax
}
  801b0d:	c9                   	leaveq 
  801b0e:	c3                   	retq   

0000000000801b0f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801b0f:	55                   	push   %rbp
  801b10:	48 89 e5             	mov    %rsp,%rbp
  801b13:	48 83 ec 20          	sub    $0x20,%rsp
  801b17:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801b1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b25:	48 98                	cltq   
  801b27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2e:	00 
  801b2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3b:	48 89 d1             	mov    %rdx,%rcx
  801b3e:	48 89 c2             	mov    %rax,%rdx
  801b41:	be 01 00 00 00       	mov    $0x1,%esi
  801b46:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b4b:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  801b52:	00 00 00 
  801b55:	ff d0                	callq  *%rax
}
  801b57:	c9                   	leaveq 
  801b58:	c3                   	retq   

0000000000801b59 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b59:	55                   	push   %rbp
  801b5a:	48 89 e5             	mov    %rsp,%rbp
  801b5d:	48 83 ec 20          	sub    $0x20,%rsp
  801b61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b68:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b6c:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b6f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b72:	48 63 f0             	movslq %eax,%rsi
  801b75:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b7c:	48 98                	cltq   
  801b7e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b82:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b89:	00 
  801b8a:	49 89 f1             	mov    %rsi,%r9
  801b8d:	49 89 c8             	mov    %rcx,%r8
  801b90:	48 89 d1             	mov    %rdx,%rcx
  801b93:	48 89 c2             	mov    %rax,%rdx
  801b96:	be 00 00 00 00       	mov    $0x0,%esi
  801b9b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ba0:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  801ba7:	00 00 00 
  801baa:	ff d0                	callq  *%rax
}
  801bac:	c9                   	leaveq 
  801bad:	c3                   	retq   

0000000000801bae <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801bae:	55                   	push   %rbp
  801baf:	48 89 e5             	mov    %rsp,%rbp
  801bb2:	48 83 ec 10          	sub    $0x10,%rsp
  801bb6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801bba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bbe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc5:	00 
  801bc6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bcc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bd7:	48 89 c2             	mov    %rax,%rdx
  801bda:	be 01 00 00 00       	mov    $0x1,%esi
  801bdf:	bf 0d 00 00 00       	mov    $0xd,%edi
  801be4:	48 b8 af 17 80 00 00 	movabs $0x8017af,%rax
  801beb:	00 00 00 
  801bee:	ff d0                	callq  *%rax
}
  801bf0:	c9                   	leaveq 
  801bf1:	c3                   	retq   

0000000000801bf2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801bf2:	55                   	push   %rbp
  801bf3:	48 89 e5             	mov    %rsp,%rbp
  801bf6:	53                   	push   %rbx
  801bf7:	48 83 ec 48          	sub    $0x48,%rsp
  801bfb:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801bff:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801c03:	48 8b 00             	mov    (%rax),%rax
  801c06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801c0a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801c0e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801c12:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801c15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c19:	48 c1 e8 0c          	shr    $0xc,%rax
  801c1d:	48 89 c2             	mov    %rax,%rdx
  801c20:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c27:	01 00 00 
  801c2a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c2e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801c32:	48 b8 09 19 80 00 00 	movabs $0x801909,%rax
  801c39:	00 00 00 
  801c3c:	ff d0                	callq  *%rax
  801c3e:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801c41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c45:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801c49:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801c4d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801c53:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801c57:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c5a:	83 e0 02             	and    $0x2,%eax
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	0f 84 8d 00 00 00    	je     801cf2 <pgfault+0x100>
  801c65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c69:	25 00 08 00 00       	and    $0x800,%eax
  801c6e:	48 85 c0             	test   %rax,%rax
  801c71:	74 7f                	je     801cf2 <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801c73:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801c76:	ba 07 00 00 00       	mov    $0x7,%edx
  801c7b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c80:	89 c7                	mov    %eax,%edi
  801c82:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801c89:	00 00 00 
  801c8c:	ff d0                	callq  *%rax
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	75 60                	jne    801cf2 <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801c92:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801c96:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c9b:	48 89 c6             	mov    %rax,%rsi
  801c9e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801ca3:	48 b8 7a 13 80 00 00 	movabs $0x80137a,%rax
  801caa:	00 00 00 
  801cad:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801caf:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801cb3:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801cb6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801cb9:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801cbf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cc4:	89 c7                	mov    %eax,%edi
  801cc6:	48 b8 d5 19 80 00 00 	movabs $0x8019d5,%rax
  801ccd:	00 00 00 
  801cd0:	ff d0                	callq  *%rax
  801cd2:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801cd4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801cd7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801cdc:	89 c7                	mov    %eax,%edi
  801cde:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  801ce5:	00 00 00 
  801ce8:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801cea:	09 d8                	or     %ebx,%eax
  801cec:	85 c0                	test   %eax,%eax
  801cee:	75 02                	jne    801cf2 <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801cf0:	eb 2a                	jmp    801d1c <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801cf2:	48 ba 33 42 80 00 00 	movabs $0x804233,%rdx
  801cf9:	00 00 00 
  801cfc:	be 26 00 00 00       	mov    $0x26,%esi
  801d01:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  801d08:	00 00 00 
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d10:	48 b9 68 02 80 00 00 	movabs $0x800268,%rcx
  801d17:	00 00 00 
  801d1a:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801d1c:	48 83 c4 48          	add    $0x48,%rsp
  801d20:	5b                   	pop    %rbx
  801d21:	5d                   	pop    %rbp
  801d22:	c3                   	retq   

0000000000801d23 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801d23:	55                   	push   %rbp
  801d24:	48 89 e5             	mov    %rsp,%rbp
  801d27:	53                   	push   %rbx
  801d28:	48 83 ec 38          	sub    $0x38,%rsp
  801d2c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801d2f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801d32:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d39:	01 00 00 
  801d3c:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801d3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d43:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801d47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d4b:	25 07 0e 00 00       	and    $0xe07,%eax
  801d50:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801d53:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d56:	48 c1 e0 0c          	shl    $0xc,%rax
  801d5a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801d5e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d61:	25 00 04 00 00       	and    $0x400,%eax
  801d66:	85 c0                	test   %eax,%eax
  801d68:	74 30                	je     801d9a <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801d6a:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801d6d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801d71:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801d74:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d78:	41 89 f0             	mov    %esi,%r8d
  801d7b:	48 89 c6             	mov    %rax,%rsi
  801d7e:	bf 00 00 00 00       	mov    $0x0,%edi
  801d83:	48 b8 d5 19 80 00 00 	movabs $0x8019d5,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
  801d8f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801d92:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d95:	e9 a4 00 00 00       	jmpq   801e3e <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801d9a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801d9d:	83 e0 02             	and    $0x2,%eax
  801da0:	85 c0                	test   %eax,%eax
  801da2:	75 0c                	jne    801db0 <duppage+0x8d>
  801da4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801da7:	25 00 08 00 00       	and    $0x800,%eax
  801dac:	85 c0                	test   %eax,%eax
  801dae:	74 63                	je     801e13 <duppage+0xf0>
		perm &= ~PTE_W;
  801db0:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  801db4:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  801dbb:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801dbe:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801dc2:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801dc5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801dc9:	41 89 f0             	mov    %esi,%r8d
  801dcc:	48 89 c6             	mov    %rax,%rsi
  801dcf:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd4:	48 b8 d5 19 80 00 00 	movabs $0x8019d5,%rax
  801ddb:	00 00 00 
  801dde:	ff d0                	callq  *%rax
  801de0:	89 c3                	mov    %eax,%ebx
  801de2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801de5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801de9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ded:	41 89 c8             	mov    %ecx,%r8d
  801df0:	48 89 d1             	mov    %rdx,%rcx
  801df3:	ba 00 00 00 00       	mov    $0x0,%edx
  801df8:	48 89 c6             	mov    %rax,%rsi
  801dfb:	bf 00 00 00 00       	mov    $0x0,%edi
  801e00:	48 b8 d5 19 80 00 00 	movabs $0x8019d5,%rax
  801e07:	00 00 00 
  801e0a:	ff d0                	callq  *%rax
  801e0c:	09 d8                	or     %ebx,%eax
  801e0e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801e11:	eb 28                	jmp    801e3b <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  801e13:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801e16:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e1a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801e1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e21:	41 89 f0             	mov    %esi,%r8d
  801e24:	48 89 c6             	mov    %rax,%rsi
  801e27:	bf 00 00 00 00       	mov    $0x0,%edi
  801e2c:	48 b8 d5 19 80 00 00 	movabs $0x8019d5,%rax
  801e33:	00 00 00 
  801e36:	ff d0                	callq  *%rax
  801e38:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  801e3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801e3e:	48 83 c4 38          	add    $0x38,%rsp
  801e42:	5b                   	pop    %rbx
  801e43:	5d                   	pop    %rbp
  801e44:	c3                   	retq   

0000000000801e45 <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  801e45:	55                   	push   %rbp
  801e46:	48 89 e5             	mov    %rsp,%rbp
  801e49:	53                   	push   %rbx
  801e4a:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801e4e:	48 bf f2 1b 80 00 00 	movabs $0x801bf2,%rdi
  801e55:	00 00 00 
  801e58:	48 b8 0a 39 80 00 00 	movabs $0x80390a,%rax
  801e5f:	00 00 00 
  801e62:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e64:	b8 07 00 00 00       	mov    $0x7,%eax
  801e69:	cd 30                	int    $0x30
  801e6b:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801e6e:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  801e71:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  801e74:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e78:	79 30                	jns    801eaa <fork+0x65>
  801e7a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801e7d:	89 c1                	mov    %eax,%ecx
  801e7f:	48 ba 5a 42 80 00 00 	movabs $0x80425a,%rdx
  801e86:	00 00 00 
  801e89:	be 72 00 00 00       	mov    $0x72,%esi
  801e8e:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  801e95:	00 00 00 
  801e98:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9d:	49 b8 68 02 80 00 00 	movabs $0x800268,%r8
  801ea4:	00 00 00 
  801ea7:	41 ff d0             	callq  *%r8
	if(cid == 0){
  801eaa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801eae:	75 46                	jne    801ef6 <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  801eb0:	48 b8 09 19 80 00 00 	movabs $0x801909,%rax
  801eb7:	00 00 00 
  801eba:	ff d0                	callq  *%rax
  801ebc:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ec1:	48 63 d0             	movslq %eax,%rdx
  801ec4:	48 89 d0             	mov    %rdx,%rax
  801ec7:	48 c1 e0 03          	shl    $0x3,%rax
  801ecb:	48 01 d0             	add    %rdx,%rax
  801ece:	48 c1 e0 05          	shl    $0x5,%rax
  801ed2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801ed9:	00 00 00 
  801edc:	48 01 c2             	add    %rax,%rdx
  801edf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801ee6:	00 00 00 
  801ee9:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801eec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef1:	e9 12 02 00 00       	jmpq   802108 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801ef6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ef9:	ba 07 00 00 00       	mov    $0x7,%edx
  801efe:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801f03:	89 c7                	mov    %eax,%edi
  801f05:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  801f0c:	00 00 00 
  801f0f:	ff d0                	callq  *%rax
  801f11:	89 45 c8             	mov    %eax,-0x38(%rbp)
  801f14:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  801f18:	79 30                	jns    801f4a <fork+0x105>
		panic("fork failed: %e\n", result);
  801f1a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f1d:	89 c1                	mov    %eax,%ecx
  801f1f:	48 ba 5a 42 80 00 00 	movabs $0x80425a,%rdx
  801f26:	00 00 00 
  801f29:	be 79 00 00 00       	mov    $0x79,%esi
  801f2e:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  801f35:	00 00 00 
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3d:	49 b8 68 02 80 00 00 	movabs $0x800268,%r8
  801f44:	00 00 00 
  801f47:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  801f4a:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801f51:	00 
  801f52:	e9 40 01 00 00       	jmpq   802097 <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  801f57:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801f5e:	01 00 00 
  801f61:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801f65:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f69:	83 e0 01             	and    $0x1,%eax
  801f6c:	48 85 c0             	test   %rax,%rax
  801f6f:	0f 84 1d 01 00 00    	je     802092 <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  801f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f79:	48 c1 e0 09          	shl    $0x9,%rax
  801f7d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  801f81:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  801f88:	00 
  801f89:	e9 f6 00 00 00       	jmpq   802084 <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  801f8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f92:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801f96:	48 01 c2             	add    %rax,%rdx
  801f99:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801fa0:	01 00 00 
  801fa3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fa7:	83 e0 01             	and    $0x1,%eax
  801faa:	48 85 c0             	test   %rax,%rax
  801fad:	0f 84 cc 00 00 00    	je     80207f <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  801fb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fb7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801fbb:	48 01 d0             	add    %rdx,%rax
  801fbe:	48 c1 e0 09          	shl    $0x9,%rax
  801fc2:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  801fc6:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  801fcd:	00 
  801fce:	e9 9e 00 00 00       	jmpq   802071 <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  801fd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801fdb:	48 01 c2             	add    %rax,%rdx
  801fde:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801fe5:	01 00 00 
  801fe8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fec:	83 e0 01             	and    $0x1,%eax
  801fef:	48 85 c0             	test   %rax,%rax
  801ff2:	74 78                	je     80206c <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  801ff4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801ffc:	48 01 d0             	add    %rdx,%rax
  801fff:	48 c1 e0 09          	shl    $0x9,%rax
  802003:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  802007:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  80200e:	00 
  80200f:	eb 51                	jmp    802062 <fork+0x21d>
								entry = base_pde + pte;
  802011:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802015:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  802019:	48 01 d0             	add    %rdx,%rax
  80201c:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  802020:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802027:	01 00 00 
  80202a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80202e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802032:	83 e0 01             	and    $0x1,%eax
  802035:	48 85 c0             	test   %rax,%rax
  802038:	74 23                	je     80205d <fork+0x218>
  80203a:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  802041:	00 
  802042:	74 19                	je     80205d <fork+0x218>
									duppage(cid, entry);
  802044:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802048:	89 c2                	mov    %eax,%edx
  80204a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80204d:	89 d6                	mov    %edx,%esi
  80204f:	89 c7                	mov    %eax,%edi
  802051:	48 b8 23 1d 80 00 00 	movabs $0x801d23,%rax
  802058:	00 00 00 
  80205b:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  80205d:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  802062:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  802069:	00 
  80206a:	76 a5                	jbe    802011 <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  80206c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802071:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  802078:	00 
  802079:	0f 86 54 ff ff ff    	jbe    801fd3 <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  80207f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  802084:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  80208b:	00 
  80208c:	0f 86 fc fe ff ff    	jbe    801f8e <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  802092:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802097:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80209c:	0f 84 b5 fe ff ff    	je     801f57 <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  8020a2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020a5:	48 be 9f 39 80 00 00 	movabs $0x80399f,%rsi
  8020ac:	00 00 00 
  8020af:	89 c7                	mov    %eax,%edi
  8020b1:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  8020b8:	00 00 00 
  8020bb:	ff d0                	callq  *%rax
  8020bd:	89 c3                	mov    %eax,%ebx
  8020bf:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8020c2:	be 02 00 00 00       	mov    $0x2,%esi
  8020c7:	89 c7                	mov    %eax,%edi
  8020c9:	48 b8 7a 1a 80 00 00 	movabs $0x801a7a,%rax
  8020d0:	00 00 00 
  8020d3:	ff d0                	callq  *%rax
  8020d5:	09 d8                	or     %ebx,%eax
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	74 2a                	je     802105 <fork+0x2c0>
		panic("fork failed\n");
  8020db:	48 ba 6b 42 80 00 00 	movabs $0x80426b,%rdx
  8020e2:	00 00 00 
  8020e5:	be 92 00 00 00       	mov    $0x92,%esi
  8020ea:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  8020f1:	00 00 00 
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f9:	48 b9 68 02 80 00 00 	movabs $0x800268,%rcx
  802100:	00 00 00 
  802103:	ff d1                	callq  *%rcx
	return cid;
  802105:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  802108:	48 83 c4 58          	add    $0x58,%rsp
  80210c:	5b                   	pop    %rbx
  80210d:	5d                   	pop    %rbp
  80210e:	c3                   	retq   

000000000080210f <sfork>:


// Challenge!
int
sfork(void)
{
  80210f:	55                   	push   %rbp
  802110:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802113:	48 ba 78 42 80 00 00 	movabs $0x804278,%rdx
  80211a:	00 00 00 
  80211d:	be 9c 00 00 00       	mov    $0x9c,%esi
  802122:	48 bf 4f 42 80 00 00 	movabs $0x80424f,%rdi
  802129:	00 00 00 
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
  802131:	48 b9 68 02 80 00 00 	movabs $0x800268,%rcx
  802138:	00 00 00 
  80213b:	ff d1                	callq  *%rcx

000000000080213d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80213d:	55                   	push   %rbp
  80213e:	48 89 e5             	mov    %rsp,%rbp
  802141:	48 83 ec 08          	sub    $0x8,%rsp
  802145:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802149:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80214d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802154:	ff ff ff 
  802157:	48 01 d0             	add    %rdx,%rax
  80215a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80215e:	c9                   	leaveq 
  80215f:	c3                   	retq   

0000000000802160 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802160:	55                   	push   %rbp
  802161:	48 89 e5             	mov    %rsp,%rbp
  802164:	48 83 ec 08          	sub    $0x8,%rsp
  802168:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80216c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802170:	48 89 c7             	mov    %rax,%rdi
  802173:	48 b8 3d 21 80 00 00 	movabs $0x80213d,%rax
  80217a:	00 00 00 
  80217d:	ff d0                	callq  *%rax
  80217f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802185:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802189:	c9                   	leaveq 
  80218a:	c3                   	retq   

000000000080218b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80218b:	55                   	push   %rbp
  80218c:	48 89 e5             	mov    %rsp,%rbp
  80218f:	48 83 ec 18          	sub    $0x18,%rsp
  802193:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802197:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80219e:	eb 6b                	jmp    80220b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8021a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a3:	48 98                	cltq   
  8021a5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021ab:	48 c1 e0 0c          	shl    $0xc,%rax
  8021af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8021b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021b7:	48 c1 e8 15          	shr    $0x15,%rax
  8021bb:	48 89 c2             	mov    %rax,%rdx
  8021be:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021c5:	01 00 00 
  8021c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021cc:	83 e0 01             	and    $0x1,%eax
  8021cf:	48 85 c0             	test   %rax,%rax
  8021d2:	74 21                	je     8021f5 <fd_alloc+0x6a>
  8021d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8021dc:	48 89 c2             	mov    %rax,%rdx
  8021df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e6:	01 00 00 
  8021e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021ed:	83 e0 01             	and    $0x1,%eax
  8021f0:	48 85 c0             	test   %rax,%rax
  8021f3:	75 12                	jne    802207 <fd_alloc+0x7c>
			*fd_store = fd;
  8021f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021fd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
  802205:	eb 1a                	jmp    802221 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802207:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80220b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80220f:	7e 8f                	jle    8021a0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802215:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80221c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802221:	c9                   	leaveq 
  802222:	c3                   	retq   

0000000000802223 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802223:	55                   	push   %rbp
  802224:	48 89 e5             	mov    %rsp,%rbp
  802227:	48 83 ec 20          	sub    $0x20,%rsp
  80222b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80222e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802232:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802236:	78 06                	js     80223e <fd_lookup+0x1b>
  802238:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80223c:	7e 07                	jle    802245 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80223e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802243:	eb 6c                	jmp    8022b1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802245:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802248:	48 98                	cltq   
  80224a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802250:	48 c1 e0 0c          	shl    $0xc,%rax
  802254:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802258:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80225c:	48 c1 e8 15          	shr    $0x15,%rax
  802260:	48 89 c2             	mov    %rax,%rdx
  802263:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80226a:	01 00 00 
  80226d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802271:	83 e0 01             	and    $0x1,%eax
  802274:	48 85 c0             	test   %rax,%rax
  802277:	74 21                	je     80229a <fd_lookup+0x77>
  802279:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80227d:	48 c1 e8 0c          	shr    $0xc,%rax
  802281:	48 89 c2             	mov    %rax,%rdx
  802284:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80228b:	01 00 00 
  80228e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802292:	83 e0 01             	and    $0x1,%eax
  802295:	48 85 c0             	test   %rax,%rax
  802298:	75 07                	jne    8022a1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80229a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80229f:	eb 10                	jmp    8022b1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8022a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022a9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8022ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b1:	c9                   	leaveq 
  8022b2:	c3                   	retq   

00000000008022b3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8022b3:	55                   	push   %rbp
  8022b4:	48 89 e5             	mov    %rsp,%rbp
  8022b7:	48 83 ec 30          	sub    $0x30,%rsp
  8022bb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022bf:	89 f0                	mov    %esi,%eax
  8022c1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022c8:	48 89 c7             	mov    %rax,%rdi
  8022cb:	48 b8 3d 21 80 00 00 	movabs $0x80213d,%rax
  8022d2:	00 00 00 
  8022d5:	ff d0                	callq  *%rax
  8022d7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022db:	48 89 d6             	mov    %rdx,%rsi
  8022de:	89 c7                	mov    %eax,%edi
  8022e0:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8022e7:	00 00 00 
  8022ea:	ff d0                	callq  *%rax
  8022ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f3:	78 0a                	js     8022ff <fd_close+0x4c>
	    || fd != fd2)
  8022f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022f9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8022fd:	74 12                	je     802311 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8022ff:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802303:	74 05                	je     80230a <fd_close+0x57>
  802305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802308:	eb 05                	jmp    80230f <fd_close+0x5c>
  80230a:	b8 00 00 00 00       	mov    $0x0,%eax
  80230f:	eb 69                	jmp    80237a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802311:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802315:	8b 00                	mov    (%rax),%eax
  802317:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80231b:	48 89 d6             	mov    %rdx,%rsi
  80231e:	89 c7                	mov    %eax,%edi
  802320:	48 b8 7c 23 80 00 00 	movabs $0x80237c,%rax
  802327:	00 00 00 
  80232a:	ff d0                	callq  *%rax
  80232c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80232f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802333:	78 2a                	js     80235f <fd_close+0xac>
		if (dev->dev_close)
  802335:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802339:	48 8b 40 20          	mov    0x20(%rax),%rax
  80233d:	48 85 c0             	test   %rax,%rax
  802340:	74 16                	je     802358 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802346:	48 8b 40 20          	mov    0x20(%rax),%rax
  80234a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80234e:	48 89 d7             	mov    %rdx,%rdi
  802351:	ff d0                	callq  *%rax
  802353:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802356:	eb 07                	jmp    80235f <fd_close+0xac>
		else
			r = 0;
  802358:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80235f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802363:	48 89 c6             	mov    %rax,%rsi
  802366:	bf 00 00 00 00       	mov    $0x0,%edi
  80236b:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  802372:	00 00 00 
  802375:	ff d0                	callq  *%rax
	return r;
  802377:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80237a:	c9                   	leaveq 
  80237b:	c3                   	retq   

000000000080237c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80237c:	55                   	push   %rbp
  80237d:	48 89 e5             	mov    %rsp,%rbp
  802380:	48 83 ec 20          	sub    $0x20,%rsp
  802384:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802387:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80238b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802392:	eb 41                	jmp    8023d5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802394:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80239b:	00 00 00 
  80239e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023a1:	48 63 d2             	movslq %edx,%rdx
  8023a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023a8:	8b 00                	mov    (%rax),%eax
  8023aa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023ad:	75 22                	jne    8023d1 <dev_lookup+0x55>
			*dev = devtab[i];
  8023af:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8023b6:	00 00 00 
  8023b9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023bc:	48 63 d2             	movslq %edx,%rdx
  8023bf:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8023c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023c7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cf:	eb 60                	jmp    802431 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8023d1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023d5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8023dc:	00 00 00 
  8023df:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023e2:	48 63 d2             	movslq %edx,%rdx
  8023e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023e9:	48 85 c0             	test   %rax,%rax
  8023ec:	75 a6                	jne    802394 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8023ee:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8023f5:	00 00 00 
  8023f8:	48 8b 00             	mov    (%rax),%rax
  8023fb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802401:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802404:	89 c6                	mov    %eax,%esi
  802406:	48 bf 90 42 80 00 00 	movabs $0x804290,%rdi
  80240d:	00 00 00 
  802410:	b8 00 00 00 00       	mov    $0x0,%eax
  802415:	48 b9 a1 04 80 00 00 	movabs $0x8004a1,%rcx
  80241c:	00 00 00 
  80241f:	ff d1                	callq  *%rcx
	*dev = 0;
  802421:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802425:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80242c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802431:	c9                   	leaveq 
  802432:	c3                   	retq   

0000000000802433 <close>:

int
close(int fdnum)
{
  802433:	55                   	push   %rbp
  802434:	48 89 e5             	mov    %rsp,%rbp
  802437:	48 83 ec 20          	sub    $0x20,%rsp
  80243b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80243e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802442:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802445:	48 89 d6             	mov    %rdx,%rsi
  802448:	89 c7                	mov    %eax,%edi
  80244a:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802451:	00 00 00 
  802454:	ff d0                	callq  *%rax
  802456:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802459:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245d:	79 05                	jns    802464 <close+0x31>
		return r;
  80245f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802462:	eb 18                	jmp    80247c <close+0x49>
	else
		return fd_close(fd, 1);
  802464:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802468:	be 01 00 00 00       	mov    $0x1,%esi
  80246d:	48 89 c7             	mov    %rax,%rdi
  802470:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  802477:	00 00 00 
  80247a:	ff d0                	callq  *%rax
}
  80247c:	c9                   	leaveq 
  80247d:	c3                   	retq   

000000000080247e <close_all>:

void
close_all(void)
{
  80247e:	55                   	push   %rbp
  80247f:	48 89 e5             	mov    %rsp,%rbp
  802482:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802486:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80248d:	eb 15                	jmp    8024a4 <close_all+0x26>
		close(i);
  80248f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802492:	89 c7                	mov    %eax,%edi
  802494:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  80249b:	00 00 00 
  80249e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8024a0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024a4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024a8:	7e e5                	jle    80248f <close_all+0x11>
		close(i);
}
  8024aa:	c9                   	leaveq 
  8024ab:	c3                   	retq   

00000000008024ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8024ac:	55                   	push   %rbp
  8024ad:	48 89 e5             	mov    %rsp,%rbp
  8024b0:	48 83 ec 40          	sub    $0x40,%rsp
  8024b4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8024b7:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8024ba:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8024be:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8024c1:	48 89 d6             	mov    %rdx,%rsi
  8024c4:	89 c7                	mov    %eax,%edi
  8024c6:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8024cd:	00 00 00 
  8024d0:	ff d0                	callq  *%rax
  8024d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024d9:	79 08                	jns    8024e3 <dup+0x37>
		return r;
  8024db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024de:	e9 70 01 00 00       	jmpq   802653 <dup+0x1a7>
	close(newfdnum);
  8024e3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024e6:	89 c7                	mov    %eax,%edi
  8024e8:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  8024ef:	00 00 00 
  8024f2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8024f4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024f7:	48 98                	cltq   
  8024f9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024ff:	48 c1 e0 0c          	shl    $0xc,%rax
  802503:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802507:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80250b:	48 89 c7             	mov    %rax,%rdi
  80250e:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  802515:	00 00 00 
  802518:	ff d0                	callq  *%rax
  80251a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80251e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802522:	48 89 c7             	mov    %rax,%rdi
  802525:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  80252c:	00 00 00 
  80252f:	ff d0                	callq  *%rax
  802531:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802539:	48 c1 e8 15          	shr    $0x15,%rax
  80253d:	48 89 c2             	mov    %rax,%rdx
  802540:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802547:	01 00 00 
  80254a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80254e:	83 e0 01             	and    $0x1,%eax
  802551:	48 85 c0             	test   %rax,%rax
  802554:	74 73                	je     8025c9 <dup+0x11d>
  802556:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80255a:	48 c1 e8 0c          	shr    $0xc,%rax
  80255e:	48 89 c2             	mov    %rax,%rdx
  802561:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802568:	01 00 00 
  80256b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80256f:	83 e0 01             	and    $0x1,%eax
  802572:	48 85 c0             	test   %rax,%rax
  802575:	74 52                	je     8025c9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80257b:	48 c1 e8 0c          	shr    $0xc,%rax
  80257f:	48 89 c2             	mov    %rax,%rdx
  802582:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802589:	01 00 00 
  80258c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802590:	25 07 0e 00 00       	and    $0xe07,%eax
  802595:	89 c1                	mov    %eax,%ecx
  802597:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80259b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259f:	41 89 c8             	mov    %ecx,%r8d
  8025a2:	48 89 d1             	mov    %rdx,%rcx
  8025a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8025aa:	48 89 c6             	mov    %rax,%rsi
  8025ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b2:	48 b8 d5 19 80 00 00 	movabs $0x8019d5,%rax
  8025b9:	00 00 00 
  8025bc:	ff d0                	callq  *%rax
  8025be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025c5:	79 02                	jns    8025c9 <dup+0x11d>
			goto err;
  8025c7:	eb 57                	jmp    802620 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8025c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025cd:	48 c1 e8 0c          	shr    $0xc,%rax
  8025d1:	48 89 c2             	mov    %rax,%rdx
  8025d4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025db:	01 00 00 
  8025de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025e2:	25 07 0e 00 00       	and    $0xe07,%eax
  8025e7:	89 c1                	mov    %eax,%ecx
  8025e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025f1:	41 89 c8             	mov    %ecx,%r8d
  8025f4:	48 89 d1             	mov    %rdx,%rcx
  8025f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fc:	48 89 c6             	mov    %rax,%rsi
  8025ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802604:	48 b8 d5 19 80 00 00 	movabs $0x8019d5,%rax
  80260b:	00 00 00 
  80260e:	ff d0                	callq  *%rax
  802610:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802613:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802617:	79 02                	jns    80261b <dup+0x16f>
		goto err;
  802619:	eb 05                	jmp    802620 <dup+0x174>

	return newfdnum;
  80261b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80261e:	eb 33                	jmp    802653 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802620:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802624:	48 89 c6             	mov    %rax,%rsi
  802627:	bf 00 00 00 00       	mov    $0x0,%edi
  80262c:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  802633:	00 00 00 
  802636:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802638:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80263c:	48 89 c6             	mov    %rax,%rsi
  80263f:	bf 00 00 00 00       	mov    $0x0,%edi
  802644:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  80264b:	00 00 00 
  80264e:	ff d0                	callq  *%rax
	return r;
  802650:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802653:	c9                   	leaveq 
  802654:	c3                   	retq   

0000000000802655 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802655:	55                   	push   %rbp
  802656:	48 89 e5             	mov    %rsp,%rbp
  802659:	48 83 ec 40          	sub    $0x40,%rsp
  80265d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802660:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802664:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802668:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80266c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80266f:	48 89 d6             	mov    %rdx,%rsi
  802672:	89 c7                	mov    %eax,%edi
  802674:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  80267b:	00 00 00 
  80267e:	ff d0                	callq  *%rax
  802680:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802683:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802687:	78 24                	js     8026ad <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80268d:	8b 00                	mov    (%rax),%eax
  80268f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802693:	48 89 d6             	mov    %rdx,%rsi
  802696:	89 c7                	mov    %eax,%edi
  802698:	48 b8 7c 23 80 00 00 	movabs $0x80237c,%rax
  80269f:	00 00 00 
  8026a2:	ff d0                	callq  *%rax
  8026a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ab:	79 05                	jns    8026b2 <read+0x5d>
		return r;
  8026ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026b0:	eb 76                	jmp    802728 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8026b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b6:	8b 40 08             	mov    0x8(%rax),%eax
  8026b9:	83 e0 03             	and    $0x3,%eax
  8026bc:	83 f8 01             	cmp    $0x1,%eax
  8026bf:	75 3a                	jne    8026fb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8026c1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026c8:	00 00 00 
  8026cb:	48 8b 00             	mov    (%rax),%rax
  8026ce:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026d4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026d7:	89 c6                	mov    %eax,%esi
  8026d9:	48 bf af 42 80 00 00 	movabs $0x8042af,%rdi
  8026e0:	00 00 00 
  8026e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e8:	48 b9 a1 04 80 00 00 	movabs $0x8004a1,%rcx
  8026ef:	00 00 00 
  8026f2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026f9:	eb 2d                	jmp    802728 <read+0xd3>
	}
	if (!dev->dev_read)
  8026fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ff:	48 8b 40 10          	mov    0x10(%rax),%rax
  802703:	48 85 c0             	test   %rax,%rax
  802706:	75 07                	jne    80270f <read+0xba>
		return -E_NOT_SUPP;
  802708:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80270d:	eb 19                	jmp    802728 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80270f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802713:	48 8b 40 10          	mov    0x10(%rax),%rax
  802717:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80271b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80271f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802723:	48 89 cf             	mov    %rcx,%rdi
  802726:	ff d0                	callq  *%rax
}
  802728:	c9                   	leaveq 
  802729:	c3                   	retq   

000000000080272a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80272a:	55                   	push   %rbp
  80272b:	48 89 e5             	mov    %rsp,%rbp
  80272e:	48 83 ec 30          	sub    $0x30,%rsp
  802732:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802735:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802739:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80273d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802744:	eb 49                	jmp    80278f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802746:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802749:	48 98                	cltq   
  80274b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80274f:	48 29 c2             	sub    %rax,%rdx
  802752:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802755:	48 63 c8             	movslq %eax,%rcx
  802758:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80275c:	48 01 c1             	add    %rax,%rcx
  80275f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802762:	48 89 ce             	mov    %rcx,%rsi
  802765:	89 c7                	mov    %eax,%edi
  802767:	48 b8 55 26 80 00 00 	movabs $0x802655,%rax
  80276e:	00 00 00 
  802771:	ff d0                	callq  *%rax
  802773:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802776:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80277a:	79 05                	jns    802781 <readn+0x57>
			return m;
  80277c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80277f:	eb 1c                	jmp    80279d <readn+0x73>
		if (m == 0)
  802781:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802785:	75 02                	jne    802789 <readn+0x5f>
			break;
  802787:	eb 11                	jmp    80279a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802789:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80278c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80278f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802792:	48 98                	cltq   
  802794:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802798:	72 ac                	jb     802746 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80279a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80279d:	c9                   	leaveq 
  80279e:	c3                   	retq   

000000000080279f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80279f:	55                   	push   %rbp
  8027a0:	48 89 e5             	mov    %rsp,%rbp
  8027a3:	48 83 ec 40          	sub    $0x40,%rsp
  8027a7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027ae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027b2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027b9:	48 89 d6             	mov    %rdx,%rsi
  8027bc:	89 c7                	mov    %eax,%edi
  8027be:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8027c5:	00 00 00 
  8027c8:	ff d0                	callq  *%rax
  8027ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027d1:	78 24                	js     8027f7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d7:	8b 00                	mov    (%rax),%eax
  8027d9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027dd:	48 89 d6             	mov    %rdx,%rsi
  8027e0:	89 c7                	mov    %eax,%edi
  8027e2:	48 b8 7c 23 80 00 00 	movabs $0x80237c,%rax
  8027e9:	00 00 00 
  8027ec:	ff d0                	callq  *%rax
  8027ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f5:	79 05                	jns    8027fc <write+0x5d>
		return r;
  8027f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027fa:	eb 75                	jmp    802871 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802800:	8b 40 08             	mov    0x8(%rax),%eax
  802803:	83 e0 03             	and    $0x3,%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	75 3a                	jne    802844 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80280a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802811:	00 00 00 
  802814:	48 8b 00             	mov    (%rax),%rax
  802817:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80281d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802820:	89 c6                	mov    %eax,%esi
  802822:	48 bf cb 42 80 00 00 	movabs $0x8042cb,%rdi
  802829:	00 00 00 
  80282c:	b8 00 00 00 00       	mov    $0x0,%eax
  802831:	48 b9 a1 04 80 00 00 	movabs $0x8004a1,%rcx
  802838:	00 00 00 
  80283b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80283d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802842:	eb 2d                	jmp    802871 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802844:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802848:	48 8b 40 18          	mov    0x18(%rax),%rax
  80284c:	48 85 c0             	test   %rax,%rax
  80284f:	75 07                	jne    802858 <write+0xb9>
		return -E_NOT_SUPP;
  802851:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802856:	eb 19                	jmp    802871 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802858:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285c:	48 8b 40 18          	mov    0x18(%rax),%rax
  802860:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802864:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802868:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80286c:	48 89 cf             	mov    %rcx,%rdi
  80286f:	ff d0                	callq  *%rax
}
  802871:	c9                   	leaveq 
  802872:	c3                   	retq   

0000000000802873 <seek>:

int
seek(int fdnum, off_t offset)
{
  802873:	55                   	push   %rbp
  802874:	48 89 e5             	mov    %rsp,%rbp
  802877:	48 83 ec 18          	sub    $0x18,%rsp
  80287b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80287e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802881:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802885:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802888:	48 89 d6             	mov    %rdx,%rsi
  80288b:	89 c7                	mov    %eax,%edi
  80288d:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  802894:	00 00 00 
  802897:	ff d0                	callq  *%rax
  802899:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80289c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a0:	79 05                	jns    8028a7 <seek+0x34>
		return r;
  8028a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028a5:	eb 0f                	jmp    8028b6 <seek+0x43>
	fd->fd_offset = offset;
  8028a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8028ae:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8028b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b6:	c9                   	leaveq 
  8028b7:	c3                   	retq   

00000000008028b8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8028b8:	55                   	push   %rbp
  8028b9:	48 89 e5             	mov    %rsp,%rbp
  8028bc:	48 83 ec 30          	sub    $0x30,%rsp
  8028c0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028c3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028cd:	48 89 d6             	mov    %rdx,%rsi
  8028d0:	89 c7                	mov    %eax,%edi
  8028d2:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8028d9:	00 00 00 
  8028dc:	ff d0                	callq  *%rax
  8028de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e5:	78 24                	js     80290b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028eb:	8b 00                	mov    (%rax),%eax
  8028ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f1:	48 89 d6             	mov    %rdx,%rsi
  8028f4:	89 c7                	mov    %eax,%edi
  8028f6:	48 b8 7c 23 80 00 00 	movabs $0x80237c,%rax
  8028fd:	00 00 00 
  802900:	ff d0                	callq  *%rax
  802902:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802905:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802909:	79 05                	jns    802910 <ftruncate+0x58>
		return r;
  80290b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290e:	eb 72                	jmp    802982 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802910:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802914:	8b 40 08             	mov    0x8(%rax),%eax
  802917:	83 e0 03             	and    $0x3,%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	75 3a                	jne    802958 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80291e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802925:	00 00 00 
  802928:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80292b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802931:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802934:	89 c6                	mov    %eax,%esi
  802936:	48 bf e8 42 80 00 00 	movabs $0x8042e8,%rdi
  80293d:	00 00 00 
  802940:	b8 00 00 00 00       	mov    $0x0,%eax
  802945:	48 b9 a1 04 80 00 00 	movabs $0x8004a1,%rcx
  80294c:	00 00 00 
  80294f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802951:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802956:	eb 2a                	jmp    802982 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802960:	48 85 c0             	test   %rax,%rax
  802963:	75 07                	jne    80296c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802965:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80296a:	eb 16                	jmp    802982 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80296c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802970:	48 8b 40 30          	mov    0x30(%rax),%rax
  802974:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802978:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80297b:	89 ce                	mov    %ecx,%esi
  80297d:	48 89 d7             	mov    %rdx,%rdi
  802980:	ff d0                	callq  *%rax
}
  802982:	c9                   	leaveq 
  802983:	c3                   	retq   

0000000000802984 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802984:	55                   	push   %rbp
  802985:	48 89 e5             	mov    %rsp,%rbp
  802988:	48 83 ec 30          	sub    $0x30,%rsp
  80298c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80298f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802993:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802997:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80299a:	48 89 d6             	mov    %rdx,%rsi
  80299d:	89 c7                	mov    %eax,%edi
  80299f:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8029a6:	00 00 00 
  8029a9:	ff d0                	callq  *%rax
  8029ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b2:	78 24                	js     8029d8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029b8:	8b 00                	mov    (%rax),%eax
  8029ba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029be:	48 89 d6             	mov    %rdx,%rsi
  8029c1:	89 c7                	mov    %eax,%edi
  8029c3:	48 b8 7c 23 80 00 00 	movabs $0x80237c,%rax
  8029ca:	00 00 00 
  8029cd:	ff d0                	callq  *%rax
  8029cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d6:	79 05                	jns    8029dd <fstat+0x59>
		return r;
  8029d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029db:	eb 5e                	jmp    802a3b <fstat+0xb7>
	if (!dev->dev_stat)
  8029dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8029e5:	48 85 c0             	test   %rax,%rax
  8029e8:	75 07                	jne    8029f1 <fstat+0x6d>
		return -E_NOT_SUPP;
  8029ea:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029ef:	eb 4a                	jmp    802a3b <fstat+0xb7>
	stat->st_name[0] = 0;
  8029f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029f5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8029f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029fc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a03:	00 00 00 
	stat->st_isdir = 0;
  802a06:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a0a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a11:	00 00 00 
	stat->st_dev = dev;
  802a14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a1c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a27:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a2b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a2f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a33:	48 89 ce             	mov    %rcx,%rsi
  802a36:	48 89 d7             	mov    %rdx,%rdi
  802a39:	ff d0                	callq  *%rax
}
  802a3b:	c9                   	leaveq 
  802a3c:	c3                   	retq   

0000000000802a3d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a3d:	55                   	push   %rbp
  802a3e:	48 89 e5             	mov    %rsp,%rbp
  802a41:	48 83 ec 20          	sub    $0x20,%rsp
  802a45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a51:	be 00 00 00 00       	mov    $0x0,%esi
  802a56:	48 89 c7             	mov    %rax,%rdi
  802a59:	48 b8 2b 2b 80 00 00 	movabs $0x802b2b,%rax
  802a60:	00 00 00 
  802a63:	ff d0                	callq  *%rax
  802a65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6c:	79 05                	jns    802a73 <stat+0x36>
		return fd;
  802a6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a71:	eb 2f                	jmp    802aa2 <stat+0x65>
	r = fstat(fd, stat);
  802a73:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a7a:	48 89 d6             	mov    %rdx,%rsi
  802a7d:	89 c7                	mov    %eax,%edi
  802a7f:	48 b8 84 29 80 00 00 	movabs $0x802984,%rax
  802a86:	00 00 00 
  802a89:	ff d0                	callq  *%rax
  802a8b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802a8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a91:	89 c7                	mov    %eax,%edi
  802a93:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
	return r;
  802a9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802aa2:	c9                   	leaveq 
  802aa3:	c3                   	retq   

0000000000802aa4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802aa4:	55                   	push   %rbp
  802aa5:	48 89 e5             	mov    %rsp,%rbp
  802aa8:	48 83 ec 10          	sub    $0x10,%rsp
  802aac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802aaf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802ab3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802aba:	00 00 00 
  802abd:	8b 00                	mov    (%rax),%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	75 1d                	jne    802ae0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802ac3:	bf 01 00 00 00       	mov    $0x1,%edi
  802ac8:	48 b8 8c 3b 80 00 00 	movabs $0x803b8c,%rax
  802acf:	00 00 00 
  802ad2:	ff d0                	callq  *%rax
  802ad4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802adb:	00 00 00 
  802ade:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ae0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ae7:	00 00 00 
  802aea:	8b 00                	mov    (%rax),%eax
  802aec:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802aef:	b9 07 00 00 00       	mov    $0x7,%ecx
  802af4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802afb:	00 00 00 
  802afe:	89 c7                	mov    %eax,%edi
  802b00:	48 b8 ef 3a 80 00 00 	movabs $0x803aef,%rax
  802b07:	00 00 00 
  802b0a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b10:	ba 00 00 00 00       	mov    $0x0,%edx
  802b15:	48 89 c6             	mov    %rax,%rsi
  802b18:	bf 00 00 00 00       	mov    $0x0,%edi
  802b1d:	48 b8 29 3a 80 00 00 	movabs $0x803a29,%rax
  802b24:	00 00 00 
  802b27:	ff d0                	callq  *%rax
}
  802b29:	c9                   	leaveq 
  802b2a:	c3                   	retq   

0000000000802b2b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b2b:	55                   	push   %rbp
  802b2c:	48 89 e5             	mov    %rsp,%rbp
  802b2f:	48 83 ec 20          	sub    $0x20,%rsp
  802b33:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b37:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802b3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b3e:	48 89 c7             	mov    %rax,%rdi
  802b41:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  802b48:	00 00 00 
  802b4b:	ff d0                	callq  *%rax
  802b4d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b52:	7e 0a                	jle    802b5e <open+0x33>
  802b54:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b59:	e9 a5 00 00 00       	jmpq   802c03 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802b5e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b62:	48 89 c7             	mov    %rax,%rdi
  802b65:	48 b8 8b 21 80 00 00 	movabs $0x80218b,%rax
  802b6c:	00 00 00 
  802b6f:	ff d0                	callq  *%rax
  802b71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b78:	79 08                	jns    802b82 <open+0x57>
		return r;
  802b7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b7d:	e9 81 00 00 00       	jmpq   802c03 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802b82:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b89:	00 00 00 
  802b8c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802b8f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802b95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b99:	48 89 c6             	mov    %rax,%rsi
  802b9c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802ba3:	00 00 00 
  802ba6:	48 b8 56 10 80 00 00 	movabs $0x801056,%rax
  802bad:	00 00 00 
  802bb0:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802bb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bb6:	48 89 c6             	mov    %rax,%rsi
  802bb9:	bf 01 00 00 00       	mov    $0x1,%edi
  802bbe:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  802bc5:	00 00 00 
  802bc8:	ff d0                	callq  *%rax
  802bca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd1:	79 1d                	jns    802bf0 <open+0xc5>
		fd_close(fd, 0);
  802bd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd7:	be 00 00 00 00       	mov    $0x0,%esi
  802bdc:	48 89 c7             	mov    %rax,%rdi
  802bdf:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  802be6:	00 00 00 
  802be9:	ff d0                	callq  *%rax
		return r;
  802beb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bee:	eb 13                	jmp    802c03 <open+0xd8>
	}
	return fd2num(fd);
  802bf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf4:	48 89 c7             	mov    %rax,%rdi
  802bf7:	48 b8 3d 21 80 00 00 	movabs $0x80213d,%rax
  802bfe:	00 00 00 
  802c01:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802c03:	c9                   	leaveq 
  802c04:	c3                   	retq   

0000000000802c05 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c05:	55                   	push   %rbp
  802c06:	48 89 e5             	mov    %rsp,%rbp
  802c09:	48 83 ec 10          	sub    $0x10,%rsp
  802c0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c15:	8b 50 0c             	mov    0xc(%rax),%edx
  802c18:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c1f:	00 00 00 
  802c22:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c24:	be 00 00 00 00       	mov    $0x0,%esi
  802c29:	bf 06 00 00 00       	mov    $0x6,%edi
  802c2e:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  802c35:	00 00 00 
  802c38:	ff d0                	callq  *%rax
}
  802c3a:	c9                   	leaveq 
  802c3b:	c3                   	retq   

0000000000802c3c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c3c:	55                   	push   %rbp
  802c3d:	48 89 e5             	mov    %rsp,%rbp
  802c40:	48 83 ec 30          	sub    $0x30,%rsp
  802c44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c4c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802c50:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c54:	8b 50 0c             	mov    0xc(%rax),%edx
  802c57:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c5e:	00 00 00 
  802c61:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802c63:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c6a:	00 00 00 
  802c6d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c71:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802c75:	be 00 00 00 00       	mov    $0x0,%esi
  802c7a:	bf 03 00 00 00       	mov    $0x3,%edi
  802c7f:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  802c86:	00 00 00 
  802c89:	ff d0                	callq  *%rax
  802c8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c92:	79 05                	jns    802c99 <devfile_read+0x5d>
		return r;
  802c94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c97:	eb 26                	jmp    802cbf <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802c99:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c9c:	48 63 d0             	movslq %eax,%rdx
  802c9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ca3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802caa:	00 00 00 
  802cad:	48 89 c7             	mov    %rax,%rdi
  802cb0:	48 b8 91 14 80 00 00 	movabs $0x801491,%rax
  802cb7:	00 00 00 
  802cba:	ff d0                	callq  *%rax
	return r;
  802cbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802cbf:	c9                   	leaveq 
  802cc0:	c3                   	retq   

0000000000802cc1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802cc1:	55                   	push   %rbp
  802cc2:	48 89 e5             	mov    %rsp,%rbp
  802cc5:	48 83 ec 30          	sub    $0x30,%rsp
  802cc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ccd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cd1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802cd5:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802cdc:	00 
	n = n > max ? max : n;
  802cdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce1:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802ce5:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802cea:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802cee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cf2:	8b 50 0c             	mov    0xc(%rax),%edx
  802cf5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cfc:	00 00 00 
  802cff:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802d01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d08:	00 00 00 
  802d0b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d0f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802d13:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d1b:	48 89 c6             	mov    %rax,%rsi
  802d1e:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802d25:	00 00 00 
  802d28:	48 b8 91 14 80 00 00 	movabs $0x801491,%rax
  802d2f:	00 00 00 
  802d32:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802d34:	be 00 00 00 00       	mov    $0x0,%esi
  802d39:	bf 04 00 00 00       	mov    $0x4,%edi
  802d3e:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  802d45:	00 00 00 
  802d48:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802d4a:	c9                   	leaveq 
  802d4b:	c3                   	retq   

0000000000802d4c <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d4c:	55                   	push   %rbp
  802d4d:	48 89 e5             	mov    %rsp,%rbp
  802d50:	48 83 ec 20          	sub    $0x20,%rsp
  802d54:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d58:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d60:	8b 50 0c             	mov    0xc(%rax),%edx
  802d63:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d6a:	00 00 00 
  802d6d:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802d6f:	be 00 00 00 00       	mov    $0x0,%esi
  802d74:	bf 05 00 00 00       	mov    $0x5,%edi
  802d79:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  802d80:	00 00 00 
  802d83:	ff d0                	callq  *%rax
  802d85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8c:	79 05                	jns    802d93 <devfile_stat+0x47>
		return r;
  802d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d91:	eb 56                	jmp    802de9 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802d93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d97:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802d9e:	00 00 00 
  802da1:	48 89 c7             	mov    %rax,%rdi
  802da4:	48 b8 56 10 80 00 00 	movabs $0x801056,%rax
  802dab:	00 00 00 
  802dae:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802db0:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802db7:	00 00 00 
  802dba:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802dc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dc4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802dca:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dd1:	00 00 00 
  802dd4:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802dda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dde:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802de4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de9:	c9                   	leaveq 
  802dea:	c3                   	retq   

0000000000802deb <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802deb:	55                   	push   %rbp
  802dec:	48 89 e5             	mov    %rsp,%rbp
  802def:	48 83 ec 10          	sub    $0x10,%rsp
  802df3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802df7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802dfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dfe:	8b 50 0c             	mov    0xc(%rax),%edx
  802e01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e08:	00 00 00 
  802e0b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e0d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e14:	00 00 00 
  802e17:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e1a:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e1d:	be 00 00 00 00       	mov    $0x0,%esi
  802e22:	bf 02 00 00 00       	mov    $0x2,%edi
  802e27:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  802e2e:	00 00 00 
  802e31:	ff d0                	callq  *%rax
}
  802e33:	c9                   	leaveq 
  802e34:	c3                   	retq   

0000000000802e35 <remove>:

// Delete a file
int
remove(const char *path)
{
  802e35:	55                   	push   %rbp
  802e36:	48 89 e5             	mov    %rsp,%rbp
  802e39:	48 83 ec 10          	sub    $0x10,%rsp
  802e3d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e45:	48 89 c7             	mov    %rax,%rdi
  802e48:	48 b8 ea 0f 80 00 00 	movabs $0x800fea,%rax
  802e4f:	00 00 00 
  802e52:	ff d0                	callq  *%rax
  802e54:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e59:	7e 07                	jle    802e62 <remove+0x2d>
		return -E_BAD_PATH;
  802e5b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e60:	eb 33                	jmp    802e95 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802e62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e66:	48 89 c6             	mov    %rax,%rsi
  802e69:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e70:	00 00 00 
  802e73:	48 b8 56 10 80 00 00 	movabs $0x801056,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802e7f:	be 00 00 00 00       	mov    $0x0,%esi
  802e84:	bf 07 00 00 00       	mov    $0x7,%edi
  802e89:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  802e90:	00 00 00 
  802e93:	ff d0                	callq  *%rax
}
  802e95:	c9                   	leaveq 
  802e96:	c3                   	retq   

0000000000802e97 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802e97:	55                   	push   %rbp
  802e98:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802e9b:	be 00 00 00 00       	mov    $0x0,%esi
  802ea0:	bf 08 00 00 00       	mov    $0x8,%edi
  802ea5:	48 b8 a4 2a 80 00 00 	movabs $0x802aa4,%rax
  802eac:	00 00 00 
  802eaf:	ff d0                	callq  *%rax
}
  802eb1:	5d                   	pop    %rbp
  802eb2:	c3                   	retq   

0000000000802eb3 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802eb3:	55                   	push   %rbp
  802eb4:	48 89 e5             	mov    %rsp,%rbp
  802eb7:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ebe:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802ec5:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802ecc:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802ed3:	be 00 00 00 00       	mov    $0x0,%esi
  802ed8:	48 89 c7             	mov    %rax,%rdi
  802edb:	48 b8 2b 2b 80 00 00 	movabs $0x802b2b,%rax
  802ee2:	00 00 00 
  802ee5:	ff d0                	callq  *%rax
  802ee7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802eea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eee:	79 28                	jns    802f18 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ef0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ef3:	89 c6                	mov    %eax,%esi
  802ef5:	48 bf 0e 43 80 00 00 	movabs $0x80430e,%rdi
  802efc:	00 00 00 
  802eff:	b8 00 00 00 00       	mov    $0x0,%eax
  802f04:	48 ba a1 04 80 00 00 	movabs $0x8004a1,%rdx
  802f0b:	00 00 00 
  802f0e:	ff d2                	callq  *%rdx
		return fd_src;
  802f10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f13:	e9 74 01 00 00       	jmpq   80308c <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802f18:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802f1f:	be 01 01 00 00       	mov    $0x101,%esi
  802f24:	48 89 c7             	mov    %rax,%rdi
  802f27:	48 b8 2b 2b 80 00 00 	movabs $0x802b2b,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
  802f33:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802f36:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f3a:	79 39                	jns    802f75 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802f3c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f3f:	89 c6                	mov    %eax,%esi
  802f41:	48 bf 24 43 80 00 00 	movabs $0x804324,%rdi
  802f48:	00 00 00 
  802f4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f50:	48 ba a1 04 80 00 00 	movabs $0x8004a1,%rdx
  802f57:	00 00 00 
  802f5a:	ff d2                	callq  *%rdx
		close(fd_src);
  802f5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f5f:	89 c7                	mov    %eax,%edi
  802f61:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  802f68:	00 00 00 
  802f6b:	ff d0                	callq  *%rax
		return fd_dest;
  802f6d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f70:	e9 17 01 00 00       	jmpq   80308c <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802f75:	eb 74                	jmp    802feb <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802f77:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f7a:	48 63 d0             	movslq %eax,%rdx
  802f7d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f84:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f87:	48 89 ce             	mov    %rcx,%rsi
  802f8a:	89 c7                	mov    %eax,%edi
  802f8c:	48 b8 9f 27 80 00 00 	movabs $0x80279f,%rax
  802f93:	00 00 00 
  802f96:	ff d0                	callq  *%rax
  802f98:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802f9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802f9f:	79 4a                	jns    802feb <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802fa1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fa4:	89 c6                	mov    %eax,%esi
  802fa6:	48 bf 3e 43 80 00 00 	movabs $0x80433e,%rdi
  802fad:	00 00 00 
  802fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb5:	48 ba a1 04 80 00 00 	movabs $0x8004a1,%rdx
  802fbc:	00 00 00 
  802fbf:	ff d2                	callq  *%rdx
			close(fd_src);
  802fc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc4:	89 c7                	mov    %eax,%edi
  802fc6:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  802fcd:	00 00 00 
  802fd0:	ff d0                	callq  *%rax
			close(fd_dest);
  802fd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fd5:	89 c7                	mov    %eax,%edi
  802fd7:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  802fde:	00 00 00 
  802fe1:	ff d0                	callq  *%rax
			return write_size;
  802fe3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fe6:	e9 a1 00 00 00       	jmpq   80308c <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802feb:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ff2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff5:	ba 00 02 00 00       	mov    $0x200,%edx
  802ffa:	48 89 ce             	mov    %rcx,%rsi
  802ffd:	89 c7                	mov    %eax,%edi
  802fff:	48 b8 55 26 80 00 00 	movabs $0x802655,%rax
  803006:	00 00 00 
  803009:	ff d0                	callq  *%rax
  80300b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80300e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803012:	0f 8f 5f ff ff ff    	jg     802f77 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803018:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80301c:	79 47                	jns    803065 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80301e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803021:	89 c6                	mov    %eax,%esi
  803023:	48 bf 51 43 80 00 00 	movabs $0x804351,%rdi
  80302a:	00 00 00 
  80302d:	b8 00 00 00 00       	mov    $0x0,%eax
  803032:	48 ba a1 04 80 00 00 	movabs $0x8004a1,%rdx
  803039:	00 00 00 
  80303c:	ff d2                	callq  *%rdx
		close(fd_src);
  80303e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803041:	89 c7                	mov    %eax,%edi
  803043:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  80304a:	00 00 00 
  80304d:	ff d0                	callq  *%rax
		close(fd_dest);
  80304f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803052:	89 c7                	mov    %eax,%edi
  803054:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  80305b:	00 00 00 
  80305e:	ff d0                	callq  *%rax
		return read_size;
  803060:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803063:	eb 27                	jmp    80308c <copy+0x1d9>
	}
	close(fd_src);
  803065:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803068:	89 c7                	mov    %eax,%edi
  80306a:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  803071:	00 00 00 
  803074:	ff d0                	callq  *%rax
	close(fd_dest);
  803076:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803079:	89 c7                	mov    %eax,%edi
  80307b:	48 b8 33 24 80 00 00 	movabs $0x802433,%rax
  803082:	00 00 00 
  803085:	ff d0                	callq  *%rax
	return 0;
  803087:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80308c:	c9                   	leaveq 
  80308d:	c3                   	retq   

000000000080308e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80308e:	55                   	push   %rbp
  80308f:	48 89 e5             	mov    %rsp,%rbp
  803092:	53                   	push   %rbx
  803093:	48 83 ec 38          	sub    $0x38,%rsp
  803097:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80309b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80309f:	48 89 c7             	mov    %rax,%rdi
  8030a2:	48 b8 8b 21 80 00 00 	movabs $0x80218b,%rax
  8030a9:	00 00 00 
  8030ac:	ff d0                	callq  *%rax
  8030ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030b5:	0f 88 bf 01 00 00    	js     80327a <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030bf:	ba 07 04 00 00       	mov    $0x407,%edx
  8030c4:	48 89 c6             	mov    %rax,%rsi
  8030c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8030cc:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  8030d3:	00 00 00 
  8030d6:	ff d0                	callq  *%rax
  8030d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030db:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030df:	0f 88 95 01 00 00    	js     80327a <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8030e5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8030e9:	48 89 c7             	mov    %rax,%rdi
  8030ec:	48 b8 8b 21 80 00 00 	movabs $0x80218b,%rax
  8030f3:	00 00 00 
  8030f6:	ff d0                	callq  *%rax
  8030f8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8030fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8030ff:	0f 88 5d 01 00 00    	js     803262 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803105:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803109:	ba 07 04 00 00       	mov    $0x407,%edx
  80310e:	48 89 c6             	mov    %rax,%rsi
  803111:	bf 00 00 00 00       	mov    $0x0,%edi
  803116:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
  803122:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803125:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803129:	0f 88 33 01 00 00    	js     803262 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80312f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803133:	48 89 c7             	mov    %rax,%rdi
  803136:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  80313d:	00 00 00 
  803140:	ff d0                	callq  *%rax
  803142:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803146:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314a:	ba 07 04 00 00       	mov    $0x407,%edx
  80314f:	48 89 c6             	mov    %rax,%rsi
  803152:	bf 00 00 00 00       	mov    $0x0,%edi
  803157:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  80315e:	00 00 00 
  803161:	ff d0                	callq  *%rax
  803163:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803166:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80316a:	79 05                	jns    803171 <pipe+0xe3>
		goto err2;
  80316c:	e9 d9 00 00 00       	jmpq   80324a <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803171:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803175:	48 89 c7             	mov    %rax,%rdi
  803178:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
  803184:	48 89 c2             	mov    %rax,%rdx
  803187:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80318b:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803191:	48 89 d1             	mov    %rdx,%rcx
  803194:	ba 00 00 00 00       	mov    $0x0,%edx
  803199:	48 89 c6             	mov    %rax,%rsi
  80319c:	bf 00 00 00 00       	mov    $0x0,%edi
  8031a1:	48 b8 d5 19 80 00 00 	movabs $0x8019d5,%rax
  8031a8:	00 00 00 
  8031ab:	ff d0                	callq  *%rax
  8031ad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031b4:	79 1b                	jns    8031d1 <pipe+0x143>
		goto err3;
  8031b6:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8031b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031bb:	48 89 c6             	mov    %rax,%rsi
  8031be:	bf 00 00 00 00       	mov    $0x0,%edi
  8031c3:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  8031ca:	00 00 00 
  8031cd:	ff d0                	callq  *%rax
  8031cf:	eb 79                	jmp    80324a <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8031d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031d5:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8031dc:	00 00 00 
  8031df:	8b 12                	mov    (%rdx),%edx
  8031e1:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8031e3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8031e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8031ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031f2:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8031f9:	00 00 00 
  8031fc:	8b 12                	mov    (%rdx),%edx
  8031fe:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803200:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803204:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80320b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80320f:	48 89 c7             	mov    %rax,%rdi
  803212:	48 b8 3d 21 80 00 00 	movabs $0x80213d,%rax
  803219:	00 00 00 
  80321c:	ff d0                	callq  *%rax
  80321e:	89 c2                	mov    %eax,%edx
  803220:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803224:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803226:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80322a:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80322e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803232:	48 89 c7             	mov    %rax,%rdi
  803235:	48 b8 3d 21 80 00 00 	movabs $0x80213d,%rax
  80323c:	00 00 00 
  80323f:	ff d0                	callq  *%rax
  803241:	89 03                	mov    %eax,(%rbx)
	return 0;
  803243:	b8 00 00 00 00       	mov    $0x0,%eax
  803248:	eb 33                	jmp    80327d <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80324a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80324e:	48 89 c6             	mov    %rax,%rsi
  803251:	bf 00 00 00 00       	mov    $0x0,%edi
  803256:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  80325d:	00 00 00 
  803260:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803262:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803266:	48 89 c6             	mov    %rax,%rsi
  803269:	bf 00 00 00 00       	mov    $0x0,%edi
  80326e:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  803275:	00 00 00 
  803278:	ff d0                	callq  *%rax
err:
	return r;
  80327a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80327d:	48 83 c4 38          	add    $0x38,%rsp
  803281:	5b                   	pop    %rbx
  803282:	5d                   	pop    %rbp
  803283:	c3                   	retq   

0000000000803284 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803284:	55                   	push   %rbp
  803285:	48 89 e5             	mov    %rsp,%rbp
  803288:	53                   	push   %rbx
  803289:	48 83 ec 28          	sub    $0x28,%rsp
  80328d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803291:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803295:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80329c:	00 00 00 
  80329f:	48 8b 00             	mov    (%rax),%rax
  8032a2:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8032ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032af:	48 89 c7             	mov    %rax,%rdi
  8032b2:	48 b8 0e 3c 80 00 00 	movabs $0x803c0e,%rax
  8032b9:	00 00 00 
  8032bc:	ff d0                	callq  *%rax
  8032be:	89 c3                	mov    %eax,%ebx
  8032c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032c4:	48 89 c7             	mov    %rax,%rdi
  8032c7:	48 b8 0e 3c 80 00 00 	movabs $0x803c0e,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
  8032d3:	39 c3                	cmp    %eax,%ebx
  8032d5:	0f 94 c0             	sete   %al
  8032d8:	0f b6 c0             	movzbl %al,%eax
  8032db:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8032de:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8032e5:	00 00 00 
  8032e8:	48 8b 00             	mov    (%rax),%rax
  8032eb:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8032f1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8032f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032f7:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8032fa:	75 05                	jne    803301 <_pipeisclosed+0x7d>
			return ret;
  8032fc:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032ff:	eb 4f                	jmp    803350 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803301:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803304:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803307:	74 42                	je     80334b <_pipeisclosed+0xc7>
  803309:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80330d:	75 3c                	jne    80334b <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80330f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803316:	00 00 00 
  803319:	48 8b 00             	mov    (%rax),%rax
  80331c:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803322:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803325:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803328:	89 c6                	mov    %eax,%esi
  80332a:	48 bf 6c 43 80 00 00 	movabs $0x80436c,%rdi
  803331:	00 00 00 
  803334:	b8 00 00 00 00       	mov    $0x0,%eax
  803339:	49 b8 a1 04 80 00 00 	movabs $0x8004a1,%r8
  803340:	00 00 00 
  803343:	41 ff d0             	callq  *%r8
	}
  803346:	e9 4a ff ff ff       	jmpq   803295 <_pipeisclosed+0x11>
  80334b:	e9 45 ff ff ff       	jmpq   803295 <_pipeisclosed+0x11>
}
  803350:	48 83 c4 28          	add    $0x28,%rsp
  803354:	5b                   	pop    %rbx
  803355:	5d                   	pop    %rbp
  803356:	c3                   	retq   

0000000000803357 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803357:	55                   	push   %rbp
  803358:	48 89 e5             	mov    %rsp,%rbp
  80335b:	48 83 ec 30          	sub    $0x30,%rsp
  80335f:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803362:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803366:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803369:	48 89 d6             	mov    %rdx,%rsi
  80336c:	89 c7                	mov    %eax,%edi
  80336e:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  803375:	00 00 00 
  803378:	ff d0                	callq  *%rax
  80337a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803381:	79 05                	jns    803388 <pipeisclosed+0x31>
		return r;
  803383:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803386:	eb 31                	jmp    8033b9 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803388:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80338c:	48 89 c7             	mov    %rax,%rdi
  80338f:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  803396:	00 00 00 
  803399:	ff d0                	callq  *%rax
  80339b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80339f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033a7:	48 89 d6             	mov    %rdx,%rsi
  8033aa:	48 89 c7             	mov    %rax,%rdi
  8033ad:	48 b8 84 32 80 00 00 	movabs $0x803284,%rax
  8033b4:	00 00 00 
  8033b7:	ff d0                	callq  *%rax
}
  8033b9:	c9                   	leaveq 
  8033ba:	c3                   	retq   

00000000008033bb <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8033bb:	55                   	push   %rbp
  8033bc:	48 89 e5             	mov    %rsp,%rbp
  8033bf:	48 83 ec 40          	sub    $0x40,%rsp
  8033c3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033c7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033cb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8033cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033d3:	48 89 c7             	mov    %rax,%rdi
  8033d6:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  8033dd:	00 00 00 
  8033e0:	ff d0                	callq  *%rax
  8033e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8033e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8033ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8033ee:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8033f5:	00 
  8033f6:	e9 92 00 00 00       	jmpq   80348d <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8033fb:	eb 41                	jmp    80343e <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8033fd:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803402:	74 09                	je     80340d <devpipe_read+0x52>
				return i;
  803404:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803408:	e9 92 00 00 00       	jmpq   80349f <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80340d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803411:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803415:	48 89 d6             	mov    %rdx,%rsi
  803418:	48 89 c7             	mov    %rax,%rdi
  80341b:	48 b8 84 32 80 00 00 	movabs $0x803284,%rax
  803422:	00 00 00 
  803425:	ff d0                	callq  *%rax
  803427:	85 c0                	test   %eax,%eax
  803429:	74 07                	je     803432 <devpipe_read+0x77>
				return 0;
  80342b:	b8 00 00 00 00       	mov    $0x0,%eax
  803430:	eb 6d                	jmp    80349f <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803432:	48 b8 47 19 80 00 00 	movabs $0x801947,%rax
  803439:	00 00 00 
  80343c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80343e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803442:	8b 10                	mov    (%rax),%edx
  803444:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803448:	8b 40 04             	mov    0x4(%rax),%eax
  80344b:	39 c2                	cmp    %eax,%edx
  80344d:	74 ae                	je     8033fd <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80344f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803453:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803457:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80345b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80345f:	8b 00                	mov    (%rax),%eax
  803461:	99                   	cltd   
  803462:	c1 ea 1b             	shr    $0x1b,%edx
  803465:	01 d0                	add    %edx,%eax
  803467:	83 e0 1f             	and    $0x1f,%eax
  80346a:	29 d0                	sub    %edx,%eax
  80346c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803470:	48 98                	cltq   
  803472:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803477:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80347d:	8b 00                	mov    (%rax),%eax
  80347f:	8d 50 01             	lea    0x1(%rax),%edx
  803482:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803486:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803488:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80348d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803491:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803495:	0f 82 60 ff ff ff    	jb     8033fb <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80349b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80349f:	c9                   	leaveq 
  8034a0:	c3                   	retq   

00000000008034a1 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8034a1:	55                   	push   %rbp
  8034a2:	48 89 e5             	mov    %rsp,%rbp
  8034a5:	48 83 ec 40          	sub    $0x40,%rsp
  8034a9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8034ad:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8034b1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8034b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034b9:	48 89 c7             	mov    %rax,%rdi
  8034bc:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  8034c3:	00 00 00 
  8034c6:	ff d0                	callq  *%rax
  8034c8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8034cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8034d4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034db:	00 
  8034dc:	e9 8e 00 00 00       	jmpq   80356f <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8034e1:	eb 31                	jmp    803514 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8034e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8034eb:	48 89 d6             	mov    %rdx,%rsi
  8034ee:	48 89 c7             	mov    %rax,%rdi
  8034f1:	48 b8 84 32 80 00 00 	movabs $0x803284,%rax
  8034f8:	00 00 00 
  8034fb:	ff d0                	callq  *%rax
  8034fd:	85 c0                	test   %eax,%eax
  8034ff:	74 07                	je     803508 <devpipe_write+0x67>
				return 0;
  803501:	b8 00 00 00 00       	mov    $0x0,%eax
  803506:	eb 79                	jmp    803581 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803508:	48 b8 47 19 80 00 00 	movabs $0x801947,%rax
  80350f:	00 00 00 
  803512:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803518:	8b 40 04             	mov    0x4(%rax),%eax
  80351b:	48 63 d0             	movslq %eax,%rdx
  80351e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803522:	8b 00                	mov    (%rax),%eax
  803524:	48 98                	cltq   
  803526:	48 83 c0 20          	add    $0x20,%rax
  80352a:	48 39 c2             	cmp    %rax,%rdx
  80352d:	73 b4                	jae    8034e3 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80352f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803533:	8b 40 04             	mov    0x4(%rax),%eax
  803536:	99                   	cltd   
  803537:	c1 ea 1b             	shr    $0x1b,%edx
  80353a:	01 d0                	add    %edx,%eax
  80353c:	83 e0 1f             	and    $0x1f,%eax
  80353f:	29 d0                	sub    %edx,%eax
  803541:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803545:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803549:	48 01 ca             	add    %rcx,%rdx
  80354c:	0f b6 0a             	movzbl (%rdx),%ecx
  80354f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803553:	48 98                	cltq   
  803555:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803559:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80355d:	8b 40 04             	mov    0x4(%rax),%eax
  803560:	8d 50 01             	lea    0x1(%rax),%edx
  803563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803567:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80356a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80356f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803573:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803577:	0f 82 64 ff ff ff    	jb     8034e1 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80357d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803581:	c9                   	leaveq 
  803582:	c3                   	retq   

0000000000803583 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803583:	55                   	push   %rbp
  803584:	48 89 e5             	mov    %rsp,%rbp
  803587:	48 83 ec 20          	sub    $0x20,%rsp
  80358b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80358f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803593:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803597:	48 89 c7             	mov    %rax,%rdi
  80359a:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  8035a1:	00 00 00 
  8035a4:	ff d0                	callq  *%rax
  8035a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8035aa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035ae:	48 be 7f 43 80 00 00 	movabs $0x80437f,%rsi
  8035b5:	00 00 00 
  8035b8:	48 89 c7             	mov    %rax,%rdi
  8035bb:	48 b8 56 10 80 00 00 	movabs $0x801056,%rax
  8035c2:	00 00 00 
  8035c5:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8035c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035cb:	8b 50 04             	mov    0x4(%rax),%edx
  8035ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d2:	8b 00                	mov    (%rax),%eax
  8035d4:	29 c2                	sub    %eax,%edx
  8035d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035da:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8035e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035e4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8035eb:	00 00 00 
	stat->st_dev = &devpipe;
  8035ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035f2:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  8035f9:	00 00 00 
  8035fc:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803608:	c9                   	leaveq 
  803609:	c3                   	retq   

000000000080360a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80360a:	55                   	push   %rbp
  80360b:	48 89 e5             	mov    %rsp,%rbp
  80360e:	48 83 ec 10          	sub    $0x10,%rsp
  803612:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803616:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80361a:	48 89 c6             	mov    %rax,%rsi
  80361d:	bf 00 00 00 00       	mov    $0x0,%edi
  803622:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  803629:	00 00 00 
  80362c:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80362e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803632:	48 89 c7             	mov    %rax,%rdi
  803635:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  80363c:	00 00 00 
  80363f:	ff d0                	callq  *%rax
  803641:	48 89 c6             	mov    %rax,%rsi
  803644:	bf 00 00 00 00       	mov    $0x0,%edi
  803649:	48 b8 30 1a 80 00 00 	movabs $0x801a30,%rax
  803650:	00 00 00 
  803653:	ff d0                	callq  *%rax
}
  803655:	c9                   	leaveq 
  803656:	c3                   	retq   

0000000000803657 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803657:	55                   	push   %rbp
  803658:	48 89 e5             	mov    %rsp,%rbp
  80365b:	48 83 ec 20          	sub    $0x20,%rsp
  80365f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803662:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803665:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803668:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80366c:	be 01 00 00 00       	mov    $0x1,%esi
  803671:	48 89 c7             	mov    %rax,%rdi
  803674:	48 b8 3d 18 80 00 00 	movabs $0x80183d,%rax
  80367b:	00 00 00 
  80367e:	ff d0                	callq  *%rax
}
  803680:	c9                   	leaveq 
  803681:	c3                   	retq   

0000000000803682 <getchar>:

int
getchar(void)
{
  803682:	55                   	push   %rbp
  803683:	48 89 e5             	mov    %rsp,%rbp
  803686:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80368a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80368e:	ba 01 00 00 00       	mov    $0x1,%edx
  803693:	48 89 c6             	mov    %rax,%rsi
  803696:	bf 00 00 00 00       	mov    $0x0,%edi
  80369b:	48 b8 55 26 80 00 00 	movabs $0x802655,%rax
  8036a2:	00 00 00 
  8036a5:	ff d0                	callq  *%rax
  8036a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8036aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ae:	79 05                	jns    8036b5 <getchar+0x33>
		return r;
  8036b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b3:	eb 14                	jmp    8036c9 <getchar+0x47>
	if (r < 1)
  8036b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036b9:	7f 07                	jg     8036c2 <getchar+0x40>
		return -E_EOF;
  8036bb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8036c0:	eb 07                	jmp    8036c9 <getchar+0x47>
	return c;
  8036c2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8036c6:	0f b6 c0             	movzbl %al,%eax
}
  8036c9:	c9                   	leaveq 
  8036ca:	c3                   	retq   

00000000008036cb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8036cb:	55                   	push   %rbp
  8036cc:	48 89 e5             	mov    %rsp,%rbp
  8036cf:	48 83 ec 20          	sub    $0x20,%rsp
  8036d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036d6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036dd:	48 89 d6             	mov    %rdx,%rsi
  8036e0:	89 c7                	mov    %eax,%edi
  8036e2:	48 b8 23 22 80 00 00 	movabs $0x802223,%rax
  8036e9:	00 00 00 
  8036ec:	ff d0                	callq  *%rax
  8036ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036f5:	79 05                	jns    8036fc <iscons+0x31>
		return r;
  8036f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fa:	eb 1a                	jmp    803716 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8036fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803700:	8b 10                	mov    (%rax),%edx
  803702:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803709:	00 00 00 
  80370c:	8b 00                	mov    (%rax),%eax
  80370e:	39 c2                	cmp    %eax,%edx
  803710:	0f 94 c0             	sete   %al
  803713:	0f b6 c0             	movzbl %al,%eax
}
  803716:	c9                   	leaveq 
  803717:	c3                   	retq   

0000000000803718 <opencons>:

int
opencons(void)
{
  803718:	55                   	push   %rbp
  803719:	48 89 e5             	mov    %rsp,%rbp
  80371c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803720:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803724:	48 89 c7             	mov    %rax,%rdi
  803727:	48 b8 8b 21 80 00 00 	movabs $0x80218b,%rax
  80372e:	00 00 00 
  803731:	ff d0                	callq  *%rax
  803733:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803736:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80373a:	79 05                	jns    803741 <opencons+0x29>
		return r;
  80373c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373f:	eb 5b                	jmp    80379c <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803745:	ba 07 04 00 00       	mov    $0x407,%edx
  80374a:	48 89 c6             	mov    %rax,%rsi
  80374d:	bf 00 00 00 00       	mov    $0x0,%edi
  803752:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  803759:	00 00 00 
  80375c:	ff d0                	callq  *%rax
  80375e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803761:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803765:	79 05                	jns    80376c <opencons+0x54>
		return r;
  803767:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80376a:	eb 30                	jmp    80379c <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80376c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803770:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803777:	00 00 00 
  80377a:	8b 12                	mov    (%rdx),%edx
  80377c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80377e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803782:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803789:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378d:	48 89 c7             	mov    %rax,%rdi
  803790:	48 b8 3d 21 80 00 00 	movabs $0x80213d,%rax
  803797:	00 00 00 
  80379a:	ff d0                	callq  *%rax
}
  80379c:	c9                   	leaveq 
  80379d:	c3                   	retq   

000000000080379e <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80379e:	55                   	push   %rbp
  80379f:	48 89 e5             	mov    %rsp,%rbp
  8037a2:	48 83 ec 30          	sub    $0x30,%rsp
  8037a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8037b2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8037b7:	75 07                	jne    8037c0 <devcons_read+0x22>
		return 0;
  8037b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037be:	eb 4b                	jmp    80380b <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8037c0:	eb 0c                	jmp    8037ce <devcons_read+0x30>
		sys_yield();
  8037c2:	48 b8 47 19 80 00 00 	movabs $0x801947,%rax
  8037c9:	00 00 00 
  8037cc:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8037ce:	48 b8 87 18 80 00 00 	movabs $0x801887,%rax
  8037d5:	00 00 00 
  8037d8:	ff d0                	callq  *%rax
  8037da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e1:	74 df                	je     8037c2 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8037e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e7:	79 05                	jns    8037ee <devcons_read+0x50>
		return c;
  8037e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ec:	eb 1d                	jmp    80380b <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8037ee:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8037f2:	75 07                	jne    8037fb <devcons_read+0x5d>
		return 0;
  8037f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f9:	eb 10                	jmp    80380b <devcons_read+0x6d>
	*(char*)vbuf = c;
  8037fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037fe:	89 c2                	mov    %eax,%edx
  803800:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803804:	88 10                	mov    %dl,(%rax)
	return 1;
  803806:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80380b:	c9                   	leaveq 
  80380c:	c3                   	retq   

000000000080380d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80380d:	55                   	push   %rbp
  80380e:	48 89 e5             	mov    %rsp,%rbp
  803811:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803818:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80381f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803826:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80382d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803834:	eb 76                	jmp    8038ac <devcons_write+0x9f>
		m = n - tot;
  803836:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80383d:	89 c2                	mov    %eax,%edx
  80383f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803842:	29 c2                	sub    %eax,%edx
  803844:	89 d0                	mov    %edx,%eax
  803846:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803849:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80384c:	83 f8 7f             	cmp    $0x7f,%eax
  80384f:	76 07                	jbe    803858 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803851:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803858:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80385b:	48 63 d0             	movslq %eax,%rdx
  80385e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803861:	48 63 c8             	movslq %eax,%rcx
  803864:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80386b:	48 01 c1             	add    %rax,%rcx
  80386e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803875:	48 89 ce             	mov    %rcx,%rsi
  803878:	48 89 c7             	mov    %rax,%rdi
  80387b:	48 b8 7a 13 80 00 00 	movabs $0x80137a,%rax
  803882:	00 00 00 
  803885:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803887:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80388a:	48 63 d0             	movslq %eax,%rdx
  80388d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803894:	48 89 d6             	mov    %rdx,%rsi
  803897:	48 89 c7             	mov    %rax,%rdi
  80389a:	48 b8 3d 18 80 00 00 	movabs $0x80183d,%rax
  8038a1:	00 00 00 
  8038a4:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8038a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038a9:	01 45 fc             	add    %eax,-0x4(%rbp)
  8038ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038af:	48 98                	cltq   
  8038b1:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8038b8:	0f 82 78 ff ff ff    	jb     803836 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8038be:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8038c1:	c9                   	leaveq 
  8038c2:	c3                   	retq   

00000000008038c3 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8038c3:	55                   	push   %rbp
  8038c4:	48 89 e5             	mov    %rsp,%rbp
  8038c7:	48 83 ec 08          	sub    $0x8,%rsp
  8038cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8038cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038d4:	c9                   	leaveq 
  8038d5:	c3                   	retq   

00000000008038d6 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8038d6:	55                   	push   %rbp
  8038d7:	48 89 e5             	mov    %rsp,%rbp
  8038da:	48 83 ec 10          	sub    $0x10,%rsp
  8038de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8038e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ea:	48 be 8b 43 80 00 00 	movabs $0x80438b,%rsi
  8038f1:	00 00 00 
  8038f4:	48 89 c7             	mov    %rax,%rdi
  8038f7:	48 b8 56 10 80 00 00 	movabs $0x801056,%rax
  8038fe:	00 00 00 
  803901:	ff d0                	callq  *%rax
	return 0;
  803903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803908:	c9                   	leaveq 
  803909:	c3                   	retq   

000000000080390a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80390a:	55                   	push   %rbp
  80390b:	48 89 e5             	mov    %rsp,%rbp
  80390e:	48 83 ec 10          	sub    $0x10,%rsp
  803912:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803916:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80391d:	00 00 00 
  803920:	48 8b 00             	mov    (%rax),%rax
  803923:	48 85 c0             	test   %rax,%rax
  803926:	75 64                	jne    80398c <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  803928:	ba 07 00 00 00       	mov    $0x7,%edx
  80392d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803932:	bf 00 00 00 00       	mov    $0x0,%edi
  803937:	48 b8 85 19 80 00 00 	movabs $0x801985,%rax
  80393e:	00 00 00 
  803941:	ff d0                	callq  *%rax
  803943:	85 c0                	test   %eax,%eax
  803945:	74 2a                	je     803971 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  803947:	48 ba 98 43 80 00 00 	movabs $0x804398,%rdx
  80394e:	00 00 00 
  803951:	be 22 00 00 00       	mov    $0x22,%esi
  803956:	48 bf c0 43 80 00 00 	movabs $0x8043c0,%rdi
  80395d:	00 00 00 
  803960:	b8 00 00 00 00       	mov    $0x0,%eax
  803965:	48 b9 68 02 80 00 00 	movabs $0x800268,%rcx
  80396c:	00 00 00 
  80396f:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803971:	48 be 9f 39 80 00 00 	movabs $0x80399f,%rsi
  803978:	00 00 00 
  80397b:	bf 00 00 00 00       	mov    $0x0,%edi
  803980:	48 b8 0f 1b 80 00 00 	movabs $0x801b0f,%rax
  803987:	00 00 00 
  80398a:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80398c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803993:	00 00 00 
  803996:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80399a:	48 89 10             	mov    %rdx,(%rax)
}
  80399d:	c9                   	leaveq 
  80399e:	c3                   	retq   

000000000080399f <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  80399f:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8039a2:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  8039a9:	00 00 00 
call *%rax
  8039ac:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  8039ae:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  8039b5:	00 
mov 136(%rsp), %r9
  8039b6:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  8039bd:	00 
sub $8, %r8
  8039be:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  8039c2:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  8039c5:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  8039cc:	00 
add $16, %rsp
  8039cd:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  8039d1:	4c 8b 3c 24          	mov    (%rsp),%r15
  8039d5:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8039da:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8039df:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8039e4:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8039e9:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8039ee:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8039f3:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8039f8:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8039fd:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803a02:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803a07:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803a0c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803a11:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803a16:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803a1b:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  803a1f:	48 83 c4 08          	add    $0x8,%rsp
popf
  803a23:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  803a24:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  803a28:	c3                   	retq   

0000000000803a29 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a29:	55                   	push   %rbp
  803a2a:	48 89 e5             	mov    %rsp,%rbp
  803a2d:	48 83 ec 30          	sub    $0x30,%rsp
  803a31:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a35:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a39:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803a3d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a42:	74 18                	je     803a5c <ipc_recv+0x33>
  803a44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a48:	48 89 c7             	mov    %rax,%rdi
  803a4b:	48 b8 ae 1b 80 00 00 	movabs $0x801bae,%rax
  803a52:	00 00 00 
  803a55:	ff d0                	callq  *%rax
  803a57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a5a:	eb 19                	jmp    803a75 <ipc_recv+0x4c>
  803a5c:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803a63:	00 00 00 
  803a66:	48 b8 ae 1b 80 00 00 	movabs $0x801bae,%rax
  803a6d:	00 00 00 
  803a70:	ff d0                	callq  *%rax
  803a72:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803a75:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a7a:	74 26                	je     803aa2 <ipc_recv+0x79>
  803a7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a80:	75 15                	jne    803a97 <ipc_recv+0x6e>
  803a82:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a89:	00 00 00 
  803a8c:	48 8b 00             	mov    (%rax),%rax
  803a8f:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803a95:	eb 05                	jmp    803a9c <ipc_recv+0x73>
  803a97:	b8 00 00 00 00       	mov    $0x0,%eax
  803a9c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803aa0:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803aa2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803aa7:	74 26                	je     803acf <ipc_recv+0xa6>
  803aa9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aad:	75 15                	jne    803ac4 <ipc_recv+0x9b>
  803aaf:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803ab6:	00 00 00 
  803ab9:	48 8b 00             	mov    (%rax),%rax
  803abc:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803ac2:	eb 05                	jmp    803ac9 <ipc_recv+0xa0>
  803ac4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803acd:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803acf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ad3:	75 15                	jne    803aea <ipc_recv+0xc1>
  803ad5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803adc:	00 00 00 
  803adf:	48 8b 00             	mov    (%rax),%rax
  803ae2:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803ae8:	eb 03                	jmp    803aed <ipc_recv+0xc4>
  803aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803aed:	c9                   	leaveq 
  803aee:	c3                   	retq   

0000000000803aef <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803aef:	55                   	push   %rbp
  803af0:	48 89 e5             	mov    %rsp,%rbp
  803af3:	48 83 ec 30          	sub    $0x30,%rsp
  803af7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803afa:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803afd:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803b01:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803b04:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803b0b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803b10:	75 10                	jne    803b22 <ipc_send+0x33>
  803b12:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803b19:	00 00 00 
  803b1c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803b20:	eb 62                	jmp    803b84 <ipc_send+0x95>
  803b22:	eb 60                	jmp    803b84 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803b24:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803b28:	74 30                	je     803b5a <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803b2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b2d:	89 c1                	mov    %eax,%ecx
  803b2f:	48 ba ce 43 80 00 00 	movabs $0x8043ce,%rdx
  803b36:	00 00 00 
  803b39:	be 33 00 00 00       	mov    $0x33,%esi
  803b3e:	48 bf ea 43 80 00 00 	movabs $0x8043ea,%rdi
  803b45:	00 00 00 
  803b48:	b8 00 00 00 00       	mov    $0x0,%eax
  803b4d:	49 b8 68 02 80 00 00 	movabs $0x800268,%r8
  803b54:	00 00 00 
  803b57:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803b5a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b5d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803b60:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b67:	89 c7                	mov    %eax,%edi
  803b69:	48 b8 59 1b 80 00 00 	movabs $0x801b59,%rax
  803b70:	00 00 00 
  803b73:	ff d0                	callq  *%rax
  803b75:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803b78:	48 b8 47 19 80 00 00 	movabs $0x801947,%rax
  803b7f:	00 00 00 
  803b82:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803b84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b88:	75 9a                	jne    803b24 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803b8a:	c9                   	leaveq 
  803b8b:	c3                   	retq   

0000000000803b8c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b8c:	55                   	push   %rbp
  803b8d:	48 89 e5             	mov    %rsp,%rbp
  803b90:	48 83 ec 14          	sub    $0x14,%rsp
  803b94:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803b97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b9e:	eb 5e                	jmp    803bfe <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803ba0:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803ba7:	00 00 00 
  803baa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bad:	48 63 d0             	movslq %eax,%rdx
  803bb0:	48 89 d0             	mov    %rdx,%rax
  803bb3:	48 c1 e0 03          	shl    $0x3,%rax
  803bb7:	48 01 d0             	add    %rdx,%rax
  803bba:	48 c1 e0 05          	shl    $0x5,%rax
  803bbe:	48 01 c8             	add    %rcx,%rax
  803bc1:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803bc7:	8b 00                	mov    (%rax),%eax
  803bc9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803bcc:	75 2c                	jne    803bfa <ipc_find_env+0x6e>
			return envs[i].env_id;
  803bce:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803bd5:	00 00 00 
  803bd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bdb:	48 63 d0             	movslq %eax,%rdx
  803bde:	48 89 d0             	mov    %rdx,%rax
  803be1:	48 c1 e0 03          	shl    $0x3,%rax
  803be5:	48 01 d0             	add    %rdx,%rax
  803be8:	48 c1 e0 05          	shl    $0x5,%rax
  803bec:	48 01 c8             	add    %rcx,%rax
  803bef:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803bf5:	8b 40 08             	mov    0x8(%rax),%eax
  803bf8:	eb 12                	jmp    803c0c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803bfa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803bfe:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803c05:	7e 99                	jle    803ba0 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803c07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c0c:	c9                   	leaveq 
  803c0d:	c3                   	retq   

0000000000803c0e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803c0e:	55                   	push   %rbp
  803c0f:	48 89 e5             	mov    %rsp,%rbp
  803c12:	48 83 ec 18          	sub    $0x18,%rsp
  803c16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803c1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c1e:	48 c1 e8 15          	shr    $0x15,%rax
  803c22:	48 89 c2             	mov    %rax,%rdx
  803c25:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c2c:	01 00 00 
  803c2f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c33:	83 e0 01             	and    $0x1,%eax
  803c36:	48 85 c0             	test   %rax,%rax
  803c39:	75 07                	jne    803c42 <pageref+0x34>
		return 0;
  803c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c40:	eb 53                	jmp    803c95 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c46:	48 c1 e8 0c          	shr    $0xc,%rax
  803c4a:	48 89 c2             	mov    %rax,%rdx
  803c4d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c54:	01 00 00 
  803c57:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c5b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c63:	83 e0 01             	and    $0x1,%eax
  803c66:	48 85 c0             	test   %rax,%rax
  803c69:	75 07                	jne    803c72 <pageref+0x64>
		return 0;
  803c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c70:	eb 23                	jmp    803c95 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c76:	48 c1 e8 0c          	shr    $0xc,%rax
  803c7a:	48 89 c2             	mov    %rax,%rdx
  803c7d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c84:	00 00 00 
  803c87:	48 c1 e2 04          	shl    $0x4,%rdx
  803c8b:	48 01 d0             	add    %rdx,%rax
  803c8e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c92:	0f b7 c0             	movzwl %ax,%eax
}
  803c95:	c9                   	leaveq 
  803c96:	c3                   	retq   
