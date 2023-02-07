
obj/user/spin:     file format elf64-x86-64


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
  80003c:	e8 07 01 00 00       	callq  800148 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800052:	48 bf 40 3c 80 00 00 	movabs $0x803c40,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((env = fork()) == 0) {
  80006d:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800080:	75 1d                	jne    80009f <umain+0x5c>
		cprintf("I am the child.  Spinning...\n");
  800082:	48 bf 68 3c 80 00 00 	movabs $0x803c68,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
		while (1)
			/* do nothing */;
  80009d:	eb fe                	jmp    80009d <umain+0x5a>
	}

	cprintf("I am the parent.  Running the child...\n");
  80009f:	48 bf 88 3c 80 00 00 	movabs $0x803c88,%rdi
  8000a6:	00 00 00 
  8000a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ae:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  8000b5:	00 00 00 
  8000b8:	ff d2                	callq  *%rdx
	sys_yield();
  8000ba:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
	sys_yield();
  8000c6:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax
	sys_yield();
  8000d2:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	callq  *%rax
	sys_yield();
  8000de:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
	sys_yield();
  8000ea:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	callq  *%rax
	sys_yield();
  8000f6:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
	sys_yield();
  800102:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  800109:	00 00 00 
  80010c:	ff d0                	callq  *%rax
	sys_yield();
  80010e:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax

	cprintf("I am the parent.  Killing the child...\n");
  80011a:	48 bf b0 3c 80 00 00 	movabs $0x803cb0,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
	sys_env_destroy(env);
  800135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800138:	89 c7                	mov    %eax,%edi
  80013a:	48 b8 44 17 80 00 00 	movabs $0x801744,%rax
  800141:	00 00 00 
  800144:	ff d0                	callq  *%rax
}
  800146:	c9                   	leaveq 
  800147:	c3                   	retq   

0000000000800148 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800148:	55                   	push   %rbp
  800149:	48 89 e5             	mov    %rsp,%rbp
  80014c:	48 83 ec 10          	sub    $0x10,%rsp
  800150:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800153:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800157:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
  800163:	48 98                	cltq   
  800165:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016a:	48 89 c2             	mov    %rax,%rdx
  80016d:	48 89 d0             	mov    %rdx,%rax
  800170:	48 c1 e0 03          	shl    $0x3,%rax
  800174:	48 01 d0             	add    %rdx,%rax
  800177:	48 c1 e0 05          	shl    $0x5,%rax
  80017b:	48 89 c2             	mov    %rax,%rdx
  80017e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800185:	00 00 00 
  800188:	48 01 c2             	add    %rax,%rdx
  80018b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800192:	00 00 00 
  800195:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800198:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80019c:	7e 14                	jle    8001b2 <libmain+0x6a>
		binaryname = argv[0];
  80019e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a2:	48 8b 10             	mov    (%rax),%rdx
  8001a5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001ac:	00 00 00 
  8001af:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b9:	48 89 d6             	mov    %rdx,%rsi
  8001bc:	89 c7                	mov    %eax,%edi
  8001be:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001ca:	48 b8 d8 01 80 00 00 	movabs $0x8001d8,%rax
  8001d1:	00 00 00 
  8001d4:	ff d0                	callq  *%rax
}
  8001d6:	c9                   	leaveq 
  8001d7:	c3                   	retq   

00000000008001d8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d8:	55                   	push   %rbp
  8001d9:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001dc:	48 b8 fd 22 80 00 00 	movabs $0x8022fd,%rax
  8001e3:	00 00 00 
  8001e6:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ed:	48 b8 44 17 80 00 00 	movabs $0x801744,%rax
  8001f4:	00 00 00 
  8001f7:	ff d0                	callq  *%rax
}
  8001f9:	5d                   	pop    %rbp
  8001fa:	c3                   	retq   

00000000008001fb <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001fb:	55                   	push   %rbp
  8001fc:	48 89 e5             	mov    %rsp,%rbp
  8001ff:	48 83 ec 10          	sub    $0x10,%rsp
  800203:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800206:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80020a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020e:	8b 00                	mov    (%rax),%eax
  800210:	8d 48 01             	lea    0x1(%rax),%ecx
  800213:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800217:	89 0a                	mov    %ecx,(%rdx)
  800219:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80021c:	89 d1                	mov    %edx,%ecx
  80021e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800222:	48 98                	cltq   
  800224:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022c:	8b 00                	mov    (%rax),%eax
  80022e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800233:	75 2c                	jne    800261 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800239:	8b 00                	mov    (%rax),%eax
  80023b:	48 98                	cltq   
  80023d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800241:	48 83 c2 08          	add    $0x8,%rdx
  800245:	48 89 c6             	mov    %rax,%rsi
  800248:	48 89 d7             	mov    %rdx,%rdi
  80024b:	48 b8 bc 16 80 00 00 	movabs $0x8016bc,%rax
  800252:	00 00 00 
  800255:	ff d0                	callq  *%rax
        b->idx = 0;
  800257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80025b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800261:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800265:	8b 40 04             	mov    0x4(%rax),%eax
  800268:	8d 50 01             	lea    0x1(%rax),%edx
  80026b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026f:	89 50 04             	mov    %edx,0x4(%rax)
}
  800272:	c9                   	leaveq 
  800273:	c3                   	retq   

0000000000800274 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800274:	55                   	push   %rbp
  800275:	48 89 e5             	mov    %rsp,%rbp
  800278:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80027f:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800286:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80028d:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800294:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80029b:	48 8b 0a             	mov    (%rdx),%rcx
  80029e:	48 89 08             	mov    %rcx,(%rax)
  8002a1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002a5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002a9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ad:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002b8:	00 00 00 
    b.cnt = 0;
  8002bb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002c2:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002c5:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002cc:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002d3:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002da:	48 89 c6             	mov    %rax,%rsi
  8002dd:	48 bf fb 01 80 00 00 	movabs $0x8001fb,%rdi
  8002e4:	00 00 00 
  8002e7:	48 b8 d3 06 80 00 00 	movabs $0x8006d3,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002f3:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002f9:	48 98                	cltq   
  8002fb:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800302:	48 83 c2 08          	add    $0x8,%rdx
  800306:	48 89 c6             	mov    %rax,%rsi
  800309:	48 89 d7             	mov    %rdx,%rdi
  80030c:	48 b8 bc 16 80 00 00 	movabs $0x8016bc,%rax
  800313:	00 00 00 
  800316:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800318:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80031e:	c9                   	leaveq 
  80031f:	c3                   	retq   

0000000000800320 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800320:	55                   	push   %rbp
  800321:	48 89 e5             	mov    %rsp,%rbp
  800324:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80032b:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800332:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800339:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800340:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800347:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80034e:	84 c0                	test   %al,%al
  800350:	74 20                	je     800372 <cprintf+0x52>
  800352:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800356:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80035a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80035e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800362:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800366:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80036a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80036e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800372:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800379:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800380:	00 00 00 
  800383:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80038a:	00 00 00 
  80038d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800391:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800398:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80039f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003a6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003ad:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003b4:	48 8b 0a             	mov    (%rdx),%rcx
  8003b7:	48 89 08             	mov    %rcx,(%rax)
  8003ba:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003be:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003c2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003c6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003ca:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003d1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d8:	48 89 d6             	mov    %rdx,%rsi
  8003db:	48 89 c7             	mov    %rax,%rdi
  8003de:	48 b8 74 02 80 00 00 	movabs $0x800274,%rax
  8003e5:	00 00 00 
  8003e8:	ff d0                	callq  *%rax
  8003ea:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003f0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003f6:	c9                   	leaveq 
  8003f7:	c3                   	retq   

00000000008003f8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f8:	55                   	push   %rbp
  8003f9:	48 89 e5             	mov    %rsp,%rbp
  8003fc:	53                   	push   %rbx
  8003fd:	48 83 ec 38          	sub    $0x38,%rsp
  800401:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800405:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800409:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80040d:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800410:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800414:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800418:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80041b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80041f:	77 3b                	ja     80045c <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800421:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800424:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800428:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80042b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042f:	ba 00 00 00 00       	mov    $0x0,%edx
  800434:	48 f7 f3             	div    %rbx
  800437:	48 89 c2             	mov    %rax,%rdx
  80043a:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80043d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800440:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800444:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800448:	41 89 f9             	mov    %edi,%r9d
  80044b:	48 89 c7             	mov    %rax,%rdi
  80044e:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  800455:	00 00 00 
  800458:	ff d0                	callq  *%rax
  80045a:	eb 1e                	jmp    80047a <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80045c:	eb 12                	jmp    800470 <printnum+0x78>
			putch(padc, putdat);
  80045e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800462:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800469:	48 89 ce             	mov    %rcx,%rsi
  80046c:	89 d7                	mov    %edx,%edi
  80046e:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800470:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800474:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800478:	7f e4                	jg     80045e <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80047a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80047d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800481:	ba 00 00 00 00       	mov    $0x0,%edx
  800486:	48 f7 f1             	div    %rcx
  800489:	48 89 d0             	mov    %rdx,%rax
  80048c:	48 ba f0 3e 80 00 00 	movabs $0x803ef0,%rdx
  800493:	00 00 00 
  800496:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80049a:	0f be d0             	movsbl %al,%edx
  80049d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a5:	48 89 ce             	mov    %rcx,%rsi
  8004a8:	89 d7                	mov    %edx,%edi
  8004aa:	ff d0                	callq  *%rax
}
  8004ac:	48 83 c4 38          	add    $0x38,%rsp
  8004b0:	5b                   	pop    %rbx
  8004b1:	5d                   	pop    %rbp
  8004b2:	c3                   	retq   

00000000008004b3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b3:	55                   	push   %rbp
  8004b4:	48 89 e5             	mov    %rsp,%rbp
  8004b7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004bf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004c2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004c6:	7e 52                	jle    80051a <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cc:	8b 00                	mov    (%rax),%eax
  8004ce:	83 f8 30             	cmp    $0x30,%eax
  8004d1:	73 24                	jae    8004f7 <getuint+0x44>
  8004d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004df:	8b 00                	mov    (%rax),%eax
  8004e1:	89 c0                	mov    %eax,%eax
  8004e3:	48 01 d0             	add    %rdx,%rax
  8004e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ea:	8b 12                	mov    (%rdx),%edx
  8004ec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f3:	89 0a                	mov    %ecx,(%rdx)
  8004f5:	eb 17                	jmp    80050e <getuint+0x5b>
  8004f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004ff:	48 89 d0             	mov    %rdx,%rax
  800502:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800506:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80050a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80050e:	48 8b 00             	mov    (%rax),%rax
  800511:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800515:	e9 a3 00 00 00       	jmpq   8005bd <getuint+0x10a>
	else if (lflag)
  80051a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80051e:	74 4f                	je     80056f <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800520:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800524:	8b 00                	mov    (%rax),%eax
  800526:	83 f8 30             	cmp    $0x30,%eax
  800529:	73 24                	jae    80054f <getuint+0x9c>
  80052b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800537:	8b 00                	mov    (%rax),%eax
  800539:	89 c0                	mov    %eax,%eax
  80053b:	48 01 d0             	add    %rdx,%rax
  80053e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800542:	8b 12                	mov    (%rdx),%edx
  800544:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800547:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054b:	89 0a                	mov    %ecx,(%rdx)
  80054d:	eb 17                	jmp    800566 <getuint+0xb3>
  80054f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800553:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800557:	48 89 d0             	mov    %rdx,%rax
  80055a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80055e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800562:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800566:	48 8b 00             	mov    (%rax),%rax
  800569:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80056d:	eb 4e                	jmp    8005bd <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80056f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800573:	8b 00                	mov    (%rax),%eax
  800575:	83 f8 30             	cmp    $0x30,%eax
  800578:	73 24                	jae    80059e <getuint+0xeb>
  80057a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	8b 00                	mov    (%rax),%eax
  800588:	89 c0                	mov    %eax,%eax
  80058a:	48 01 d0             	add    %rdx,%rax
  80058d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800591:	8b 12                	mov    (%rdx),%edx
  800593:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800596:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059a:	89 0a                	mov    %ecx,(%rdx)
  80059c:	eb 17                	jmp    8005b5 <getuint+0x102>
  80059e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a6:	48 89 d0             	mov    %rdx,%rax
  8005a9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b5:	8b 00                	mov    (%rax),%eax
  8005b7:	89 c0                	mov    %eax,%eax
  8005b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005c1:	c9                   	leaveq 
  8005c2:	c3                   	retq   

00000000008005c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c3:	55                   	push   %rbp
  8005c4:	48 89 e5             	mov    %rsp,%rbp
  8005c7:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005cf:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005d2:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005d6:	7e 52                	jle    80062a <getint+0x67>
		x=va_arg(*ap, long long);
  8005d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dc:	8b 00                	mov    (%rax),%eax
  8005de:	83 f8 30             	cmp    $0x30,%eax
  8005e1:	73 24                	jae    800607 <getint+0x44>
  8005e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ef:	8b 00                	mov    (%rax),%eax
  8005f1:	89 c0                	mov    %eax,%eax
  8005f3:	48 01 d0             	add    %rdx,%rax
  8005f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fa:	8b 12                	mov    (%rdx),%edx
  8005fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800603:	89 0a                	mov    %ecx,(%rdx)
  800605:	eb 17                	jmp    80061e <getint+0x5b>
  800607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060f:	48 89 d0             	mov    %rdx,%rax
  800612:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800616:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061e:	48 8b 00             	mov    (%rax),%rax
  800621:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800625:	e9 a3 00 00 00       	jmpq   8006cd <getint+0x10a>
	else if (lflag)
  80062a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80062e:	74 4f                	je     80067f <getint+0xbc>
		x=va_arg(*ap, long);
  800630:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800634:	8b 00                	mov    (%rax),%eax
  800636:	83 f8 30             	cmp    $0x30,%eax
  800639:	73 24                	jae    80065f <getint+0x9c>
  80063b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	8b 00                	mov    (%rax),%eax
  800649:	89 c0                	mov    %eax,%eax
  80064b:	48 01 d0             	add    %rdx,%rax
  80064e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800652:	8b 12                	mov    (%rdx),%edx
  800654:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800657:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065b:	89 0a                	mov    %ecx,(%rdx)
  80065d:	eb 17                	jmp    800676 <getint+0xb3>
  80065f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800663:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800667:	48 89 d0             	mov    %rdx,%rax
  80066a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80066e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800672:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800676:	48 8b 00             	mov    (%rax),%rax
  800679:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067d:	eb 4e                	jmp    8006cd <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	83 f8 30             	cmp    $0x30,%eax
  800688:	73 24                	jae    8006ae <getint+0xeb>
  80068a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	8b 00                	mov    (%rax),%eax
  800698:	89 c0                	mov    %eax,%eax
  80069a:	48 01 d0             	add    %rdx,%rax
  80069d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a1:	8b 12                	mov    (%rdx),%edx
  8006a3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006aa:	89 0a                	mov    %ecx,(%rdx)
  8006ac:	eb 17                	jmp    8006c5 <getint+0x102>
  8006ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b6:	48 89 d0             	mov    %rdx,%rax
  8006b9:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c5:	8b 00                	mov    (%rax),%eax
  8006c7:	48 98                	cltq   
  8006c9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006d1:	c9                   	leaveq 
  8006d2:	c3                   	retq   

00000000008006d3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006d3:	55                   	push   %rbp
  8006d4:	48 89 e5             	mov    %rsp,%rbp
  8006d7:	41 54                	push   %r12
  8006d9:	53                   	push   %rbx
  8006da:	48 83 ec 60          	sub    $0x60,%rsp
  8006de:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006e2:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006e6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ea:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006ee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006f2:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006f6:	48 8b 0a             	mov    (%rdx),%rcx
  8006f9:	48 89 08             	mov    %rcx,(%rax)
  8006fc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800700:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800704:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800708:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070c:	eb 17                	jmp    800725 <vprintfmt+0x52>
			if (ch == '\0')
  80070e:	85 db                	test   %ebx,%ebx
  800710:	0f 84 cc 04 00 00    	je     800be2 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800716:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80071a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80071e:	48 89 d6             	mov    %rdx,%rsi
  800721:	89 df                	mov    %ebx,%edi
  800723:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800725:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800729:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80072d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800731:	0f b6 00             	movzbl (%rax),%eax
  800734:	0f b6 d8             	movzbl %al,%ebx
  800737:	83 fb 25             	cmp    $0x25,%ebx
  80073a:	75 d2                	jne    80070e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80073c:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800740:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800747:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80074e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800755:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800760:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800764:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800768:	0f b6 00             	movzbl (%rax),%eax
  80076b:	0f b6 d8             	movzbl %al,%ebx
  80076e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800771:	83 f8 55             	cmp    $0x55,%eax
  800774:	0f 87 34 04 00 00    	ja     800bae <vprintfmt+0x4db>
  80077a:	89 c0                	mov    %eax,%eax
  80077c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800783:	00 
  800784:	48 b8 18 3f 80 00 00 	movabs $0x803f18,%rax
  80078b:	00 00 00 
  80078e:	48 01 d0             	add    %rdx,%rax
  800791:	48 8b 00             	mov    (%rax),%rax
  800794:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800796:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80079a:	eb c0                	jmp    80075c <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007a0:	eb ba                	jmp    80075c <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007a9:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 02             	shl    $0x2,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d8                	add    %ebx,%eax
  8007b7:	83 e8 30             	sub    $0x30,%eax
  8007ba:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007bd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007c1:	0f b6 00             	movzbl (%rax),%eax
  8007c4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c7:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ca:	7e 0c                	jle    8007d8 <vprintfmt+0x105>
  8007cc:	83 fb 39             	cmp    $0x39,%ebx
  8007cf:	7f 07                	jg     8007d8 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d1:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d6:	eb d1                	jmp    8007a9 <vprintfmt+0xd6>
			goto process_precision;
  8007d8:	eb 58                	jmp    800832 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007da:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007dd:	83 f8 30             	cmp    $0x30,%eax
  8007e0:	73 17                	jae    8007f9 <vprintfmt+0x126>
  8007e2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e9:	89 c0                	mov    %eax,%eax
  8007eb:	48 01 d0             	add    %rdx,%rax
  8007ee:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007f1:	83 c2 08             	add    $0x8,%edx
  8007f4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f7:	eb 0f                	jmp    800808 <vprintfmt+0x135>
  8007f9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fd:	48 89 d0             	mov    %rdx,%rax
  800800:	48 83 c2 08          	add    $0x8,%rdx
  800804:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800808:	8b 00                	mov    (%rax),%eax
  80080a:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80080d:	eb 23                	jmp    800832 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80080f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800813:	79 0c                	jns    800821 <vprintfmt+0x14e>
				width = 0;
  800815:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80081c:	e9 3b ff ff ff       	jmpq   80075c <vprintfmt+0x89>
  800821:	e9 36 ff ff ff       	jmpq   80075c <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800826:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80082d:	e9 2a ff ff ff       	jmpq   80075c <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800832:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800836:	79 12                	jns    80084a <vprintfmt+0x177>
				width = precision, precision = -1;
  800838:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80083b:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80083e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800845:	e9 12 ff ff ff       	jmpq   80075c <vprintfmt+0x89>
  80084a:	e9 0d ff ff ff       	jmpq   80075c <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800853:	e9 04 ff ff ff       	jmpq   80075c <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800858:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085b:	83 f8 30             	cmp    $0x30,%eax
  80085e:	73 17                	jae    800877 <vprintfmt+0x1a4>
  800860:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800864:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800867:	89 c0                	mov    %eax,%eax
  800869:	48 01 d0             	add    %rdx,%rax
  80086c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80086f:	83 c2 08             	add    $0x8,%edx
  800872:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800875:	eb 0f                	jmp    800886 <vprintfmt+0x1b3>
  800877:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80087b:	48 89 d0             	mov    %rdx,%rax
  80087e:	48 83 c2 08          	add    $0x8,%rdx
  800882:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800886:	8b 10                	mov    (%rax),%edx
  800888:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80088c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800890:	48 89 ce             	mov    %rcx,%rsi
  800893:	89 d7                	mov    %edx,%edi
  800895:	ff d0                	callq  *%rax
			break;
  800897:	e9 40 03 00 00       	jmpq   800bdc <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80089c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089f:	83 f8 30             	cmp    $0x30,%eax
  8008a2:	73 17                	jae    8008bb <vprintfmt+0x1e8>
  8008a4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ab:	89 c0                	mov    %eax,%eax
  8008ad:	48 01 d0             	add    %rdx,%rax
  8008b0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008b3:	83 c2 08             	add    $0x8,%edx
  8008b6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b9:	eb 0f                	jmp    8008ca <vprintfmt+0x1f7>
  8008bb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008bf:	48 89 d0             	mov    %rdx,%rax
  8008c2:	48 83 c2 08          	add    $0x8,%rdx
  8008c6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008ca:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008cc:	85 db                	test   %ebx,%ebx
  8008ce:	79 02                	jns    8008d2 <vprintfmt+0x1ff>
				err = -err;
  8008d0:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008d2:	83 fb 15             	cmp    $0x15,%ebx
  8008d5:	7f 16                	jg     8008ed <vprintfmt+0x21a>
  8008d7:	48 b8 40 3e 80 00 00 	movabs $0x803e40,%rax
  8008de:	00 00 00 
  8008e1:	48 63 d3             	movslq %ebx,%rdx
  8008e4:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008e8:	4d 85 e4             	test   %r12,%r12
  8008eb:	75 2e                	jne    80091b <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008ed:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f5:	89 d9                	mov    %ebx,%ecx
  8008f7:	48 ba 01 3f 80 00 00 	movabs $0x803f01,%rdx
  8008fe:	00 00 00 
  800901:	48 89 c7             	mov    %rax,%rdi
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	49 b8 eb 0b 80 00 00 	movabs $0x800beb,%r8
  800910:	00 00 00 
  800913:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800916:	e9 c1 02 00 00       	jmpq   800bdc <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80091b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80091f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800923:	4c 89 e1             	mov    %r12,%rcx
  800926:	48 ba 0a 3f 80 00 00 	movabs $0x803f0a,%rdx
  80092d:	00 00 00 
  800930:	48 89 c7             	mov    %rax,%rdi
  800933:	b8 00 00 00 00       	mov    $0x0,%eax
  800938:	49 b8 eb 0b 80 00 00 	movabs $0x800beb,%r8
  80093f:	00 00 00 
  800942:	41 ff d0             	callq  *%r8
			break;
  800945:	e9 92 02 00 00       	jmpq   800bdc <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80094a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094d:	83 f8 30             	cmp    $0x30,%eax
  800950:	73 17                	jae    800969 <vprintfmt+0x296>
  800952:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800956:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800959:	89 c0                	mov    %eax,%eax
  80095b:	48 01 d0             	add    %rdx,%rax
  80095e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800961:	83 c2 08             	add    $0x8,%edx
  800964:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800967:	eb 0f                	jmp    800978 <vprintfmt+0x2a5>
  800969:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80096d:	48 89 d0             	mov    %rdx,%rax
  800970:	48 83 c2 08          	add    $0x8,%rdx
  800974:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800978:	4c 8b 20             	mov    (%rax),%r12
  80097b:	4d 85 e4             	test   %r12,%r12
  80097e:	75 0a                	jne    80098a <vprintfmt+0x2b7>
				p = "(null)";
  800980:	49 bc 0d 3f 80 00 00 	movabs $0x803f0d,%r12
  800987:	00 00 00 
			if (width > 0 && padc != '-')
  80098a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098e:	7e 3f                	jle    8009cf <vprintfmt+0x2fc>
  800990:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800994:	74 39                	je     8009cf <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800996:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800999:	48 98                	cltq   
  80099b:	48 89 c6             	mov    %rax,%rsi
  80099e:	4c 89 e7             	mov    %r12,%rdi
  8009a1:	48 b8 97 0e 80 00 00 	movabs $0x800e97,%rax
  8009a8:	00 00 00 
  8009ab:	ff d0                	callq  *%rax
  8009ad:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009b0:	eb 17                	jmp    8009c9 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009b2:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009b6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009ba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009be:	48 89 ce             	mov    %rcx,%rsi
  8009c1:	89 d7                	mov    %edx,%edi
  8009c3:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c5:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009cd:	7f e3                	jg     8009b2 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009cf:	eb 37                	jmp    800a08 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009d5:	74 1e                	je     8009f5 <vprintfmt+0x322>
  8009d7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009da:	7e 05                	jle    8009e1 <vprintfmt+0x30e>
  8009dc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009df:	7e 14                	jle    8009f5 <vprintfmt+0x322>
					putch('?', putdat);
  8009e1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e9:	48 89 d6             	mov    %rdx,%rsi
  8009ec:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009f1:	ff d0                	callq  *%rax
  8009f3:	eb 0f                	jmp    800a04 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009f5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009fd:	48 89 d6             	mov    %rdx,%rsi
  800a00:	89 df                	mov    %ebx,%edi
  800a02:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a04:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a08:	4c 89 e0             	mov    %r12,%rax
  800a0b:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a0f:	0f b6 00             	movzbl (%rax),%eax
  800a12:	0f be d8             	movsbl %al,%ebx
  800a15:	85 db                	test   %ebx,%ebx
  800a17:	74 10                	je     800a29 <vprintfmt+0x356>
  800a19:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a1d:	78 b2                	js     8009d1 <vprintfmt+0x2fe>
  800a1f:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a23:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a27:	79 a8                	jns    8009d1 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a29:	eb 16                	jmp    800a41 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a2b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a33:	48 89 d6             	mov    %rdx,%rsi
  800a36:	bf 20 00 00 00       	mov    $0x20,%edi
  800a3b:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a45:	7f e4                	jg     800a2b <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a47:	e9 90 01 00 00       	jmpq   800bdc <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a4c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a50:	be 03 00 00 00       	mov    $0x3,%esi
  800a55:	48 89 c7             	mov    %rax,%rdi
  800a58:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800a5f:	00 00 00 
  800a62:	ff d0                	callq  *%rax
  800a64:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6c:	48 85 c0             	test   %rax,%rax
  800a6f:	79 1d                	jns    800a8e <vprintfmt+0x3bb>
				putch('-', putdat);
  800a71:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a75:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a79:	48 89 d6             	mov    %rdx,%rsi
  800a7c:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a81:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a87:	48 f7 d8             	neg    %rax
  800a8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a8e:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a95:	e9 d5 00 00 00       	jmpq   800b6f <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a9a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a9e:	be 03 00 00 00       	mov    $0x3,%esi
  800aa3:	48 89 c7             	mov    %rax,%rdi
  800aa6:	48 b8 b3 04 80 00 00 	movabs $0x8004b3,%rax
  800aad:	00 00 00 
  800ab0:	ff d0                	callq  *%rax
  800ab2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ab6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800abd:	e9 ad 00 00 00       	jmpq   800b6f <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800ac2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac6:	be 03 00 00 00       	mov    $0x3,%esi
  800acb:	48 89 c7             	mov    %rax,%rdi
  800ace:	48 b8 b3 04 80 00 00 	movabs $0x8004b3,%rax
  800ad5:	00 00 00 
  800ad8:	ff d0                	callq  *%rax
  800ada:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800ade:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800ae5:	e9 85 00 00 00       	jmpq   800b6f <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800aea:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af2:	48 89 d6             	mov    %rdx,%rsi
  800af5:	bf 30 00 00 00       	mov    $0x30,%edi
  800afa:	ff d0                	callq  *%rax
			putch('x', putdat);
  800afc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b04:	48 89 d6             	mov    %rdx,%rsi
  800b07:	bf 78 00 00 00       	mov    $0x78,%edi
  800b0c:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b0e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b11:	83 f8 30             	cmp    $0x30,%eax
  800b14:	73 17                	jae    800b2d <vprintfmt+0x45a>
  800b16:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b1a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1d:	89 c0                	mov    %eax,%eax
  800b1f:	48 01 d0             	add    %rdx,%rax
  800b22:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b25:	83 c2 08             	add    $0x8,%edx
  800b28:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2b:	eb 0f                	jmp    800b3c <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b2d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b31:	48 89 d0             	mov    %rdx,%rax
  800b34:	48 83 c2 08          	add    $0x8,%rdx
  800b38:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b3c:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b43:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b4a:	eb 23                	jmp    800b6f <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b4c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b50:	be 03 00 00 00       	mov    $0x3,%esi
  800b55:	48 89 c7             	mov    %rax,%rdi
  800b58:	48 b8 b3 04 80 00 00 	movabs $0x8004b3,%rax
  800b5f:	00 00 00 
  800b62:	ff d0                	callq  *%rax
  800b64:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b68:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6f:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b74:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b77:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b7a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b82:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b86:	45 89 c1             	mov    %r8d,%r9d
  800b89:	41 89 f8             	mov    %edi,%r8d
  800b8c:	48 89 c7             	mov    %rax,%rdi
  800b8f:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  800b96:	00 00 00 
  800b99:	ff d0                	callq  *%rax
			break;
  800b9b:	eb 3f                	jmp    800bdc <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b9d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba5:	48 89 d6             	mov    %rdx,%rsi
  800ba8:	89 df                	mov    %ebx,%edi
  800baa:	ff d0                	callq  *%rax
			break;
  800bac:	eb 2e                	jmp    800bdc <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb6:	48 89 d6             	mov    %rdx,%rsi
  800bb9:	bf 25 00 00 00       	mov    $0x25,%edi
  800bbe:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc0:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bc5:	eb 05                	jmp    800bcc <vprintfmt+0x4f9>
  800bc7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bcc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bd0:	48 83 e8 01          	sub    $0x1,%rax
  800bd4:	0f b6 00             	movzbl (%rax),%eax
  800bd7:	3c 25                	cmp    $0x25,%al
  800bd9:	75 ec                	jne    800bc7 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bdb:	90                   	nop
		}
	}
  800bdc:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bdd:	e9 43 fb ff ff       	jmpq   800725 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800be2:	48 83 c4 60          	add    $0x60,%rsp
  800be6:	5b                   	pop    %rbx
  800be7:	41 5c                	pop    %r12
  800be9:	5d                   	pop    %rbp
  800bea:	c3                   	retq   

0000000000800beb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800beb:	55                   	push   %rbp
  800bec:	48 89 e5             	mov    %rsp,%rbp
  800bef:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bf6:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bfd:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c04:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c0b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c12:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c19:	84 c0                	test   %al,%al
  800c1b:	74 20                	je     800c3d <printfmt+0x52>
  800c1d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c21:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c25:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c29:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c2d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c31:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c35:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c39:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c3d:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c44:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c4b:	00 00 00 
  800c4e:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c55:	00 00 00 
  800c58:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c5c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c63:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c6a:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c71:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c78:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c7f:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c86:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c8d:	48 89 c7             	mov    %rax,%rdi
  800c90:	48 b8 d3 06 80 00 00 	movabs $0x8006d3,%rax
  800c97:	00 00 00 
  800c9a:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c9c:	c9                   	leaveq 
  800c9d:	c3                   	retq   

0000000000800c9e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c9e:	55                   	push   %rbp
  800c9f:	48 89 e5             	mov    %rsp,%rbp
  800ca2:	48 83 ec 10          	sub    $0x10,%rsp
  800ca6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb1:	8b 40 10             	mov    0x10(%rax),%eax
  800cb4:	8d 50 01             	lea    0x1(%rax),%edx
  800cb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cbb:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc2:	48 8b 10             	mov    (%rax),%rdx
  800cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc9:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ccd:	48 39 c2             	cmp    %rax,%rdx
  800cd0:	73 17                	jae    800ce9 <sprintputch+0x4b>
		*b->buf++ = ch;
  800cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd6:	48 8b 00             	mov    (%rax),%rax
  800cd9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cdd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ce1:	48 89 0a             	mov    %rcx,(%rdx)
  800ce4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ce7:	88 10                	mov    %dl,(%rax)
}
  800ce9:	c9                   	leaveq 
  800cea:	c3                   	retq   

0000000000800ceb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ceb:	55                   	push   %rbp
  800cec:	48 89 e5             	mov    %rsp,%rbp
  800cef:	48 83 ec 50          	sub    $0x50,%rsp
  800cf3:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cf7:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cfa:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cfe:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d02:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d06:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d0a:	48 8b 0a             	mov    (%rdx),%rcx
  800d0d:	48 89 08             	mov    %rcx,(%rax)
  800d10:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d14:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d18:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d1c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d20:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d24:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d28:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d2b:	48 98                	cltq   
  800d2d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d31:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d35:	48 01 d0             	add    %rdx,%rax
  800d38:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d43:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d48:	74 06                	je     800d50 <vsnprintf+0x65>
  800d4a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d4e:	7f 07                	jg     800d57 <vsnprintf+0x6c>
		return -E_INVAL;
  800d50:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d55:	eb 2f                	jmp    800d86 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d57:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d5b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d5f:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d63:	48 89 c6             	mov    %rax,%rsi
  800d66:	48 bf 9e 0c 80 00 00 	movabs $0x800c9e,%rdi
  800d6d:	00 00 00 
  800d70:	48 b8 d3 06 80 00 00 	movabs $0x8006d3,%rax
  800d77:	00 00 00 
  800d7a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d7c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d80:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d83:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d86:	c9                   	leaveq 
  800d87:	c3                   	retq   

0000000000800d88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d88:	55                   	push   %rbp
  800d89:	48 89 e5             	mov    %rsp,%rbp
  800d8c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d93:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d9a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800da0:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da7:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dae:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800db5:	84 c0                	test   %al,%al
  800db7:	74 20                	je     800dd9 <snprintf+0x51>
  800db9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dbd:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dc1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dc5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dcd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dd1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dd5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dd9:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800de0:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800de7:	00 00 00 
  800dea:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800df1:	00 00 00 
  800df4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dff:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e06:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e0d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e14:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e1b:	48 8b 0a             	mov    (%rdx),%rcx
  800e1e:	48 89 08             	mov    %rcx,(%rax)
  800e21:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e25:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e29:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e2d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e31:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e38:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e3f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e45:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e4c:	48 89 c7             	mov    %rax,%rdi
  800e4f:	48 b8 eb 0c 80 00 00 	movabs $0x800ceb,%rax
  800e56:	00 00 00 
  800e59:	ff d0                	callq  *%rax
  800e5b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e61:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e67:	c9                   	leaveq 
  800e68:	c3                   	retq   

0000000000800e69 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e69:	55                   	push   %rbp
  800e6a:	48 89 e5             	mov    %rsp,%rbp
  800e6d:	48 83 ec 18          	sub    $0x18,%rsp
  800e71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e7c:	eb 09                	jmp    800e87 <strlen+0x1e>
		n++;
  800e7e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e82:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	0f b6 00             	movzbl (%rax),%eax
  800e8e:	84 c0                	test   %al,%al
  800e90:	75 ec                	jne    800e7e <strlen+0x15>
		n++;
	return n;
  800e92:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e95:	c9                   	leaveq 
  800e96:	c3                   	retq   

0000000000800e97 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e97:	55                   	push   %rbp
  800e98:	48 89 e5             	mov    %rsp,%rbp
  800e9b:	48 83 ec 20          	sub    $0x20,%rsp
  800e9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ea3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800eae:	eb 0e                	jmp    800ebe <strnlen+0x27>
		n++;
  800eb0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eb9:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ebe:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ec3:	74 0b                	je     800ed0 <strnlen+0x39>
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec9:	0f b6 00             	movzbl (%rax),%eax
  800ecc:	84 c0                	test   %al,%al
  800ece:	75 e0                	jne    800eb0 <strnlen+0x19>
		n++;
	return n;
  800ed0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ed3:	c9                   	leaveq 
  800ed4:	c3                   	retq   

0000000000800ed5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ed5:	55                   	push   %rbp
  800ed6:	48 89 e5             	mov    %rsp,%rbp
  800ed9:	48 83 ec 20          	sub    $0x20,%rsp
  800edd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ee1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ee5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800eed:	90                   	nop
  800eee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800efa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800efe:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f02:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f06:	0f b6 12             	movzbl (%rdx),%edx
  800f09:	88 10                	mov    %dl,(%rax)
  800f0b:	0f b6 00             	movzbl (%rax),%eax
  800f0e:	84 c0                	test   %al,%al
  800f10:	75 dc                	jne    800eee <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f12:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f16:	c9                   	leaveq 
  800f17:	c3                   	retq   

0000000000800f18 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f18:	55                   	push   %rbp
  800f19:	48 89 e5             	mov    %rsp,%rbp
  800f1c:	48 83 ec 20          	sub    $0x20,%rsp
  800f20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2c:	48 89 c7             	mov    %rax,%rdi
  800f2f:	48 b8 69 0e 80 00 00 	movabs $0x800e69,%rax
  800f36:	00 00 00 
  800f39:	ff d0                	callq  *%rax
  800f3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f41:	48 63 d0             	movslq %eax,%rdx
  800f44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f48:	48 01 c2             	add    %rax,%rdx
  800f4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f4f:	48 89 c6             	mov    %rax,%rsi
  800f52:	48 89 d7             	mov    %rdx,%rdi
  800f55:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  800f5c:	00 00 00 
  800f5f:	ff d0                	callq  *%rax
	return dst;
  800f61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f65:	c9                   	leaveq 
  800f66:	c3                   	retq   

0000000000800f67 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f67:	55                   	push   %rbp
  800f68:	48 89 e5             	mov    %rsp,%rbp
  800f6b:	48 83 ec 28          	sub    $0x28,%rsp
  800f6f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f73:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f77:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f83:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f8a:	00 
  800f8b:	eb 2a                	jmp    800fb7 <strncpy+0x50>
		*dst++ = *src;
  800f8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f91:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f95:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f99:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f9d:	0f b6 12             	movzbl (%rdx),%edx
  800fa0:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fa2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa6:	0f b6 00             	movzbl (%rax),%eax
  800fa9:	84 c0                	test   %al,%al
  800fab:	74 05                	je     800fb2 <strncpy+0x4b>
			src++;
  800fad:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fb2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fbb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fbf:	72 cc                	jb     800f8d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fc1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fc5:	c9                   	leaveq 
  800fc6:	c3                   	retq   

0000000000800fc7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fc7:	55                   	push   %rbp
  800fc8:	48 89 e5             	mov    %rsp,%rbp
  800fcb:	48 83 ec 28          	sub    $0x28,%rsp
  800fcf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fd7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fdf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fe3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe8:	74 3d                	je     801027 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fea:	eb 1d                	jmp    801009 <strlcpy+0x42>
			*dst++ = *src++;
  800fec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ff4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ff8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ffc:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801000:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801004:	0f b6 12             	movzbl (%rdx),%edx
  801007:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801009:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80100e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801013:	74 0b                	je     801020 <strlcpy+0x59>
  801015:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801019:	0f b6 00             	movzbl (%rax),%eax
  80101c:	84 c0                	test   %al,%al
  80101e:	75 cc                	jne    800fec <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801020:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801024:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801027:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80102b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102f:	48 29 c2             	sub    %rax,%rdx
  801032:	48 89 d0             	mov    %rdx,%rax
}
  801035:	c9                   	leaveq 
  801036:	c3                   	retq   

0000000000801037 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801037:	55                   	push   %rbp
  801038:	48 89 e5             	mov    %rsp,%rbp
  80103b:	48 83 ec 10          	sub    $0x10,%rsp
  80103f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801043:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801047:	eb 0a                	jmp    801053 <strcmp+0x1c>
		p++, q++;
  801049:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80104e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801053:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801057:	0f b6 00             	movzbl (%rax),%eax
  80105a:	84 c0                	test   %al,%al
  80105c:	74 12                	je     801070 <strcmp+0x39>
  80105e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801062:	0f b6 10             	movzbl (%rax),%edx
  801065:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801069:	0f b6 00             	movzbl (%rax),%eax
  80106c:	38 c2                	cmp    %al,%dl
  80106e:	74 d9                	je     801049 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801070:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801074:	0f b6 00             	movzbl (%rax),%eax
  801077:	0f b6 d0             	movzbl %al,%edx
  80107a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107e:	0f b6 00             	movzbl (%rax),%eax
  801081:	0f b6 c0             	movzbl %al,%eax
  801084:	29 c2                	sub    %eax,%edx
  801086:	89 d0                	mov    %edx,%eax
}
  801088:	c9                   	leaveq 
  801089:	c3                   	retq   

000000000080108a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 83 ec 18          	sub    $0x18,%rsp
  801092:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801096:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80109a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80109e:	eb 0f                	jmp    8010af <strncmp+0x25>
		n--, p++, q++;
  8010a0:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010a5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010aa:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010af:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010b4:	74 1d                	je     8010d3 <strncmp+0x49>
  8010b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ba:	0f b6 00             	movzbl (%rax),%eax
  8010bd:	84 c0                	test   %al,%al
  8010bf:	74 12                	je     8010d3 <strncmp+0x49>
  8010c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c5:	0f b6 10             	movzbl (%rax),%edx
  8010c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cc:	0f b6 00             	movzbl (%rax),%eax
  8010cf:	38 c2                	cmp    %al,%dl
  8010d1:	74 cd                	je     8010a0 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010d3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d8:	75 07                	jne    8010e1 <strncmp+0x57>
		return 0;
  8010da:	b8 00 00 00 00       	mov    $0x0,%eax
  8010df:	eb 18                	jmp    8010f9 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e5:	0f b6 00             	movzbl (%rax),%eax
  8010e8:	0f b6 d0             	movzbl %al,%edx
  8010eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ef:	0f b6 00             	movzbl (%rax),%eax
  8010f2:	0f b6 c0             	movzbl %al,%eax
  8010f5:	29 c2                	sub    %eax,%edx
  8010f7:	89 d0                	mov    %edx,%eax
}
  8010f9:	c9                   	leaveq 
  8010fa:	c3                   	retq   

00000000008010fb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010fb:	55                   	push   %rbp
  8010fc:	48 89 e5             	mov    %rsp,%rbp
  8010ff:	48 83 ec 0c          	sub    $0xc,%rsp
  801103:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801107:	89 f0                	mov    %esi,%eax
  801109:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80110c:	eb 17                	jmp    801125 <strchr+0x2a>
		if (*s == c)
  80110e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801112:	0f b6 00             	movzbl (%rax),%eax
  801115:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801118:	75 06                	jne    801120 <strchr+0x25>
			return (char *) s;
  80111a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111e:	eb 15                	jmp    801135 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801120:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801125:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801129:	0f b6 00             	movzbl (%rax),%eax
  80112c:	84 c0                	test   %al,%al
  80112e:	75 de                	jne    80110e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801130:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801135:	c9                   	leaveq 
  801136:	c3                   	retq   

0000000000801137 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801137:	55                   	push   %rbp
  801138:	48 89 e5             	mov    %rsp,%rbp
  80113b:	48 83 ec 0c          	sub    $0xc,%rsp
  80113f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801143:	89 f0                	mov    %esi,%eax
  801145:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801148:	eb 13                	jmp    80115d <strfind+0x26>
		if (*s == c)
  80114a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114e:	0f b6 00             	movzbl (%rax),%eax
  801151:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801154:	75 02                	jne    801158 <strfind+0x21>
			break;
  801156:	eb 10                	jmp    801168 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801158:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80115d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801161:	0f b6 00             	movzbl (%rax),%eax
  801164:	84 c0                	test   %al,%al
  801166:	75 e2                	jne    80114a <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801168:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80116c:	c9                   	leaveq 
  80116d:	c3                   	retq   

000000000080116e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80116e:	55                   	push   %rbp
  80116f:	48 89 e5             	mov    %rsp,%rbp
  801172:	48 83 ec 18          	sub    $0x18,%rsp
  801176:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80117a:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80117d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801181:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801186:	75 06                	jne    80118e <memset+0x20>
		return v;
  801188:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118c:	eb 69                	jmp    8011f7 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80118e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801192:	83 e0 03             	and    $0x3,%eax
  801195:	48 85 c0             	test   %rax,%rax
  801198:	75 48                	jne    8011e2 <memset+0x74>
  80119a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119e:	83 e0 03             	and    $0x3,%eax
  8011a1:	48 85 c0             	test   %rax,%rax
  8011a4:	75 3c                	jne    8011e2 <memset+0x74>
		c &= 0xFF;
  8011a6:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b0:	c1 e0 18             	shl    $0x18,%eax
  8011b3:	89 c2                	mov    %eax,%edx
  8011b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b8:	c1 e0 10             	shl    $0x10,%eax
  8011bb:	09 c2                	or     %eax,%edx
  8011bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c0:	c1 e0 08             	shl    $0x8,%eax
  8011c3:	09 d0                	or     %edx,%eax
  8011c5:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cc:	48 c1 e8 02          	shr    $0x2,%rax
  8011d0:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011d3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011da:	48 89 d7             	mov    %rdx,%rdi
  8011dd:	fc                   	cld    
  8011de:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011e0:	eb 11                	jmp    8011f3 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011ed:	48 89 d7             	mov    %rdx,%rdi
  8011f0:	fc                   	cld    
  8011f1:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011f7:	c9                   	leaveq 
  8011f8:	c3                   	retq   

00000000008011f9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011f9:	55                   	push   %rbp
  8011fa:	48 89 e5             	mov    %rsp,%rbp
  8011fd:	48 83 ec 28          	sub    $0x28,%rsp
  801201:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801205:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801209:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80120d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801211:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801219:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80121d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801221:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801225:	0f 83 88 00 00 00    	jae    8012b3 <memmove+0xba>
  80122b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801233:	48 01 d0             	add    %rdx,%rax
  801236:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80123a:	76 77                	jbe    8012b3 <memmove+0xba>
		s += n;
  80123c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801240:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801244:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801248:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80124c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801250:	83 e0 03             	and    $0x3,%eax
  801253:	48 85 c0             	test   %rax,%rax
  801256:	75 3b                	jne    801293 <memmove+0x9a>
  801258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125c:	83 e0 03             	and    $0x3,%eax
  80125f:	48 85 c0             	test   %rax,%rax
  801262:	75 2f                	jne    801293 <memmove+0x9a>
  801264:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801268:	83 e0 03             	and    $0x3,%eax
  80126b:	48 85 c0             	test   %rax,%rax
  80126e:	75 23                	jne    801293 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801274:	48 83 e8 04          	sub    $0x4,%rax
  801278:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80127c:	48 83 ea 04          	sub    $0x4,%rdx
  801280:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801284:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801288:	48 89 c7             	mov    %rax,%rdi
  80128b:	48 89 d6             	mov    %rdx,%rsi
  80128e:	fd                   	std    
  80128f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801291:	eb 1d                	jmp    8012b0 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801293:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801297:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80129b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129f:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a7:	48 89 d7             	mov    %rdx,%rdi
  8012aa:	48 89 c1             	mov    %rax,%rcx
  8012ad:	fd                   	std    
  8012ae:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012b0:	fc                   	cld    
  8012b1:	eb 57                	jmp    80130a <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b7:	83 e0 03             	and    $0x3,%eax
  8012ba:	48 85 c0             	test   %rax,%rax
  8012bd:	75 36                	jne    8012f5 <memmove+0xfc>
  8012bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c3:	83 e0 03             	and    $0x3,%eax
  8012c6:	48 85 c0             	test   %rax,%rax
  8012c9:	75 2a                	jne    8012f5 <memmove+0xfc>
  8012cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012cf:	83 e0 03             	and    $0x3,%eax
  8012d2:	48 85 c0             	test   %rax,%rax
  8012d5:	75 1e                	jne    8012f5 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012db:	48 c1 e8 02          	shr    $0x2,%rax
  8012df:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ea:	48 89 c7             	mov    %rax,%rdi
  8012ed:	48 89 d6             	mov    %rdx,%rsi
  8012f0:	fc                   	cld    
  8012f1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012f3:	eb 15                	jmp    80130a <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012fd:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801301:	48 89 c7             	mov    %rax,%rdi
  801304:	48 89 d6             	mov    %rdx,%rsi
  801307:	fc                   	cld    
  801308:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80130a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80130e:	c9                   	leaveq 
  80130f:	c3                   	retq   

0000000000801310 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801310:	55                   	push   %rbp
  801311:	48 89 e5             	mov    %rsp,%rbp
  801314:	48 83 ec 18          	sub    $0x18,%rsp
  801318:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801320:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801324:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801328:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80132c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801330:	48 89 ce             	mov    %rcx,%rsi
  801333:	48 89 c7             	mov    %rax,%rdi
  801336:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  80133d:	00 00 00 
  801340:	ff d0                	callq  *%rax
}
  801342:	c9                   	leaveq 
  801343:	c3                   	retq   

0000000000801344 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801344:	55                   	push   %rbp
  801345:	48 89 e5             	mov    %rsp,%rbp
  801348:	48 83 ec 28          	sub    $0x28,%rsp
  80134c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801350:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801354:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801358:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801360:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801364:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801368:	eb 36                	jmp    8013a0 <memcmp+0x5c>
		if (*s1 != *s2)
  80136a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136e:	0f b6 10             	movzbl (%rax),%edx
  801371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801375:	0f b6 00             	movzbl (%rax),%eax
  801378:	38 c2                	cmp    %al,%dl
  80137a:	74 1a                	je     801396 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80137c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801380:	0f b6 00             	movzbl (%rax),%eax
  801383:	0f b6 d0             	movzbl %al,%edx
  801386:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80138a:	0f b6 00             	movzbl (%rax),%eax
  80138d:	0f b6 c0             	movzbl %al,%eax
  801390:	29 c2                	sub    %eax,%edx
  801392:	89 d0                	mov    %edx,%eax
  801394:	eb 20                	jmp    8013b6 <memcmp+0x72>
		s1++, s2++;
  801396:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80139b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013a8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013ac:	48 85 c0             	test   %rax,%rax
  8013af:	75 b9                	jne    80136a <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b6:	c9                   	leaveq 
  8013b7:	c3                   	retq   

00000000008013b8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013b8:	55                   	push   %rbp
  8013b9:	48 89 e5             	mov    %rsp,%rbp
  8013bc:	48 83 ec 28          	sub    $0x28,%rsp
  8013c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013cb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013d3:	48 01 d0             	add    %rdx,%rax
  8013d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013da:	eb 15                	jmp    8013f1 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e0:	0f b6 10             	movzbl (%rax),%edx
  8013e3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	75 02                	jne    8013ec <memfind+0x34>
			break;
  8013ea:	eb 0f                	jmp    8013fb <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013ec:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f5:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013f9:	72 e1                	jb     8013dc <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013ff:	c9                   	leaveq 
  801400:	c3                   	retq   

0000000000801401 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801401:	55                   	push   %rbp
  801402:	48 89 e5             	mov    %rsp,%rbp
  801405:	48 83 ec 34          	sub    $0x34,%rsp
  801409:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80140d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801411:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80141b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801422:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801423:	eb 05                	jmp    80142a <strtol+0x29>
		s++;
  801425:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80142a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	3c 20                	cmp    $0x20,%al
  801433:	74 f0                	je     801425 <strtol+0x24>
  801435:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801439:	0f b6 00             	movzbl (%rax),%eax
  80143c:	3c 09                	cmp    $0x9,%al
  80143e:	74 e5                	je     801425 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801444:	0f b6 00             	movzbl (%rax),%eax
  801447:	3c 2b                	cmp    $0x2b,%al
  801449:	75 07                	jne    801452 <strtol+0x51>
		s++;
  80144b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801450:	eb 17                	jmp    801469 <strtol+0x68>
	else if (*s == '-')
  801452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801456:	0f b6 00             	movzbl (%rax),%eax
  801459:	3c 2d                	cmp    $0x2d,%al
  80145b:	75 0c                	jne    801469 <strtol+0x68>
		s++, neg = 1;
  80145d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801462:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801469:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80146d:	74 06                	je     801475 <strtol+0x74>
  80146f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801473:	75 28                	jne    80149d <strtol+0x9c>
  801475:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801479:	0f b6 00             	movzbl (%rax),%eax
  80147c:	3c 30                	cmp    $0x30,%al
  80147e:	75 1d                	jne    80149d <strtol+0x9c>
  801480:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801484:	48 83 c0 01          	add    $0x1,%rax
  801488:	0f b6 00             	movzbl (%rax),%eax
  80148b:	3c 78                	cmp    $0x78,%al
  80148d:	75 0e                	jne    80149d <strtol+0x9c>
		s += 2, base = 16;
  80148f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801494:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80149b:	eb 2c                	jmp    8014c9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80149d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014a1:	75 19                	jne    8014bc <strtol+0xbb>
  8014a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a7:	0f b6 00             	movzbl (%rax),%eax
  8014aa:	3c 30                	cmp    $0x30,%al
  8014ac:	75 0e                	jne    8014bc <strtol+0xbb>
		s++, base = 8;
  8014ae:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014b3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014ba:	eb 0d                	jmp    8014c9 <strtol+0xc8>
	else if (base == 0)
  8014bc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014c0:	75 07                	jne    8014c9 <strtol+0xc8>
		base = 10;
  8014c2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cd:	0f b6 00             	movzbl (%rax),%eax
  8014d0:	3c 2f                	cmp    $0x2f,%al
  8014d2:	7e 1d                	jle    8014f1 <strtol+0xf0>
  8014d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d8:	0f b6 00             	movzbl (%rax),%eax
  8014db:	3c 39                	cmp    $0x39,%al
  8014dd:	7f 12                	jg     8014f1 <strtol+0xf0>
			dig = *s - '0';
  8014df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e3:	0f b6 00             	movzbl (%rax),%eax
  8014e6:	0f be c0             	movsbl %al,%eax
  8014e9:	83 e8 30             	sub    $0x30,%eax
  8014ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ef:	eb 4e                	jmp    80153f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f5:	0f b6 00             	movzbl (%rax),%eax
  8014f8:	3c 60                	cmp    $0x60,%al
  8014fa:	7e 1d                	jle    801519 <strtol+0x118>
  8014fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801500:	0f b6 00             	movzbl (%rax),%eax
  801503:	3c 7a                	cmp    $0x7a,%al
  801505:	7f 12                	jg     801519 <strtol+0x118>
			dig = *s - 'a' + 10;
  801507:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150b:	0f b6 00             	movzbl (%rax),%eax
  80150e:	0f be c0             	movsbl %al,%eax
  801511:	83 e8 57             	sub    $0x57,%eax
  801514:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801517:	eb 26                	jmp    80153f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801519:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151d:	0f b6 00             	movzbl (%rax),%eax
  801520:	3c 40                	cmp    $0x40,%al
  801522:	7e 48                	jle    80156c <strtol+0x16b>
  801524:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801528:	0f b6 00             	movzbl (%rax),%eax
  80152b:	3c 5a                	cmp    $0x5a,%al
  80152d:	7f 3d                	jg     80156c <strtol+0x16b>
			dig = *s - 'A' + 10;
  80152f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801533:	0f b6 00             	movzbl (%rax),%eax
  801536:	0f be c0             	movsbl %al,%eax
  801539:	83 e8 37             	sub    $0x37,%eax
  80153c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80153f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801542:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801545:	7c 02                	jl     801549 <strtol+0x148>
			break;
  801547:	eb 23                	jmp    80156c <strtol+0x16b>
		s++, val = (val * base) + dig;
  801549:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80154e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801551:	48 98                	cltq   
  801553:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801558:	48 89 c2             	mov    %rax,%rdx
  80155b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80155e:	48 98                	cltq   
  801560:	48 01 d0             	add    %rdx,%rax
  801563:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801567:	e9 5d ff ff ff       	jmpq   8014c9 <strtol+0xc8>

	if (endptr)
  80156c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801571:	74 0b                	je     80157e <strtol+0x17d>
		*endptr = (char *) s;
  801573:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801577:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80157b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80157e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801582:	74 09                	je     80158d <strtol+0x18c>
  801584:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801588:	48 f7 d8             	neg    %rax
  80158b:	eb 04                	jmp    801591 <strtol+0x190>
  80158d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801591:	c9                   	leaveq 
  801592:	c3                   	retq   

0000000000801593 <strstr>:

char * strstr(const char *in, const char *str)
{
  801593:	55                   	push   %rbp
  801594:	48 89 e5             	mov    %rsp,%rbp
  801597:	48 83 ec 30          	sub    $0x30,%rsp
  80159b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80159f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015ab:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015af:	0f b6 00             	movzbl (%rax),%eax
  8015b2:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015b5:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015b9:	75 06                	jne    8015c1 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bf:	eb 6b                	jmp    80162c <strstr+0x99>

	len = strlen(str);
  8015c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015c5:	48 89 c7             	mov    %rax,%rdi
  8015c8:	48 b8 69 0e 80 00 00 	movabs $0x800e69,%rax
  8015cf:	00 00 00 
  8015d2:	ff d0                	callq  *%rax
  8015d4:	48 98                	cltq   
  8015d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015de:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015e6:	0f b6 00             	movzbl (%rax),%eax
  8015e9:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015ec:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015f0:	75 07                	jne    8015f9 <strstr+0x66>
				return (char *) 0;
  8015f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f7:	eb 33                	jmp    80162c <strstr+0x99>
		} while (sc != c);
  8015f9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015fd:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801600:	75 d8                	jne    8015da <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801602:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801606:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80160a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160e:	48 89 ce             	mov    %rcx,%rsi
  801611:	48 89 c7             	mov    %rax,%rdi
  801614:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  80161b:	00 00 00 
  80161e:	ff d0                	callq  *%rax
  801620:	85 c0                	test   %eax,%eax
  801622:	75 b6                	jne    8015da <strstr+0x47>

	return (char *) (in - 1);
  801624:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801628:	48 83 e8 01          	sub    $0x1,%rax
}
  80162c:	c9                   	leaveq 
  80162d:	c3                   	retq   

000000000080162e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80162e:	55                   	push   %rbp
  80162f:	48 89 e5             	mov    %rsp,%rbp
  801632:	53                   	push   %rbx
  801633:	48 83 ec 48          	sub    $0x48,%rsp
  801637:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80163a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80163d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801641:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801645:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801649:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  80164d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801650:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801654:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801658:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80165c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801660:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801664:	4c 89 c3             	mov    %r8,%rbx
  801667:	cd 30                	int    $0x30
  801669:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  80166d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801671:	74 3e                	je     8016b1 <syscall+0x83>
  801673:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801678:	7e 37                	jle    8016b1 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80167a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801681:	49 89 d0             	mov    %rdx,%r8
  801684:	89 c1                	mov    %eax,%ecx
  801686:	48 ba c8 41 80 00 00 	movabs $0x8041c8,%rdx
  80168d:	00 00 00 
  801690:	be 4a 00 00 00       	mov    $0x4a,%esi
  801695:	48 bf e5 41 80 00 00 	movabs $0x8041e5,%rdi
  80169c:	00 00 00 
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a4:	49 b9 89 37 80 00 00 	movabs $0x803789,%r9
  8016ab:	00 00 00 
  8016ae:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8016b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016b5:	48 83 c4 48          	add    $0x48,%rsp
  8016b9:	5b                   	pop    %rbx
  8016ba:	5d                   	pop    %rbp
  8016bb:	c3                   	retq   

00000000008016bc <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016bc:	55                   	push   %rbp
  8016bd:	48 89 e5             	mov    %rsp,%rbp
  8016c0:	48 83 ec 20          	sub    $0x20,%rsp
  8016c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016d4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016db:	00 
  8016dc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016e2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e8:	48 89 d1             	mov    %rdx,%rcx
  8016eb:	48 89 c2             	mov    %rax,%rdx
  8016ee:	be 00 00 00 00       	mov    $0x0,%esi
  8016f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f8:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  8016ff:	00 00 00 
  801702:	ff d0                	callq  *%rax
}
  801704:	c9                   	leaveq 
  801705:	c3                   	retq   

0000000000801706 <sys_cgetc>:

int
sys_cgetc(void)
{
  801706:	55                   	push   %rbp
  801707:	48 89 e5             	mov    %rsp,%rbp
  80170a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80170e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801715:	00 
  801716:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80171c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801722:	b9 00 00 00 00       	mov    $0x0,%ecx
  801727:	ba 00 00 00 00       	mov    $0x0,%edx
  80172c:	be 00 00 00 00       	mov    $0x0,%esi
  801731:	bf 01 00 00 00       	mov    $0x1,%edi
  801736:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  80173d:	00 00 00 
  801740:	ff d0                	callq  *%rax
}
  801742:	c9                   	leaveq 
  801743:	c3                   	retq   

0000000000801744 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801744:	55                   	push   %rbp
  801745:	48 89 e5             	mov    %rsp,%rbp
  801748:	48 83 ec 10          	sub    $0x10,%rsp
  80174c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80174f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801752:	48 98                	cltq   
  801754:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80175b:	00 
  80175c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801762:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801768:	b9 00 00 00 00       	mov    $0x0,%ecx
  80176d:	48 89 c2             	mov    %rax,%rdx
  801770:	be 01 00 00 00       	mov    $0x1,%esi
  801775:	bf 03 00 00 00       	mov    $0x3,%edi
  80177a:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  801781:	00 00 00 
  801784:	ff d0                	callq  *%rax
}
  801786:	c9                   	leaveq 
  801787:	c3                   	retq   

0000000000801788 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801788:	55                   	push   %rbp
  801789:	48 89 e5             	mov    %rsp,%rbp
  80178c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801790:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801797:	00 
  801798:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80179e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ae:	be 00 00 00 00       	mov    $0x0,%esi
  8017b3:	bf 02 00 00 00       	mov    $0x2,%edi
  8017b8:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  8017bf:	00 00 00 
  8017c2:	ff d0                	callq  *%rax
}
  8017c4:	c9                   	leaveq 
  8017c5:	c3                   	retq   

00000000008017c6 <sys_yield>:

void
sys_yield(void)
{
  8017c6:	55                   	push   %rbp
  8017c7:	48 89 e5             	mov    %rsp,%rbp
  8017ca:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017d5:	00 
  8017d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ec:	be 00 00 00 00       	mov    $0x0,%esi
  8017f1:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017f6:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  8017fd:	00 00 00 
  801800:	ff d0                	callq  *%rax
}
  801802:	c9                   	leaveq 
  801803:	c3                   	retq   

0000000000801804 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801804:	55                   	push   %rbp
  801805:	48 89 e5             	mov    %rsp,%rbp
  801808:	48 83 ec 20          	sub    $0x20,%rsp
  80180c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80180f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801813:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801816:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801819:	48 63 c8             	movslq %eax,%rcx
  80181c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801820:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801823:	48 98                	cltq   
  801825:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80182c:	00 
  80182d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801833:	49 89 c8             	mov    %rcx,%r8
  801836:	48 89 d1             	mov    %rdx,%rcx
  801839:	48 89 c2             	mov    %rax,%rdx
  80183c:	be 01 00 00 00       	mov    $0x1,%esi
  801841:	bf 04 00 00 00       	mov    $0x4,%edi
  801846:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  80184d:	00 00 00 
  801850:	ff d0                	callq  *%rax
}
  801852:	c9                   	leaveq 
  801853:	c3                   	retq   

0000000000801854 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801854:	55                   	push   %rbp
  801855:	48 89 e5             	mov    %rsp,%rbp
  801858:	48 83 ec 30          	sub    $0x30,%rsp
  80185c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80185f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801863:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801866:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80186a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80186e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801871:	48 63 c8             	movslq %eax,%rcx
  801874:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801878:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80187b:	48 63 f0             	movslq %eax,%rsi
  80187e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801882:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801885:	48 98                	cltq   
  801887:	48 89 0c 24          	mov    %rcx,(%rsp)
  80188b:	49 89 f9             	mov    %rdi,%r9
  80188e:	49 89 f0             	mov    %rsi,%r8
  801891:	48 89 d1             	mov    %rdx,%rcx
  801894:	48 89 c2             	mov    %rax,%rdx
  801897:	be 01 00 00 00       	mov    $0x1,%esi
  80189c:	bf 05 00 00 00       	mov    $0x5,%edi
  8018a1:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  8018a8:	00 00 00 
  8018ab:	ff d0                	callq  *%rax
}
  8018ad:	c9                   	leaveq 
  8018ae:	c3                   	retq   

00000000008018af <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018af:	55                   	push   %rbp
  8018b0:	48 89 e5             	mov    %rsp,%rbp
  8018b3:	48 83 ec 20          	sub    $0x20,%rsp
  8018b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c5:	48 98                	cltq   
  8018c7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ce:	00 
  8018cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018db:	48 89 d1             	mov    %rdx,%rcx
  8018de:	48 89 c2             	mov    %rax,%rdx
  8018e1:	be 01 00 00 00       	mov    $0x1,%esi
  8018e6:	bf 06 00 00 00       	mov    $0x6,%edi
  8018eb:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  8018f2:	00 00 00 
  8018f5:	ff d0                	callq  *%rax
}
  8018f7:	c9                   	leaveq 
  8018f8:	c3                   	retq   

00000000008018f9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018f9:	55                   	push   %rbp
  8018fa:	48 89 e5             	mov    %rsp,%rbp
  8018fd:	48 83 ec 10          	sub    $0x10,%rsp
  801901:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801904:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801907:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80190a:	48 63 d0             	movslq %eax,%rdx
  80190d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801910:	48 98                	cltq   
  801912:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801919:	00 
  80191a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801920:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801926:	48 89 d1             	mov    %rdx,%rcx
  801929:	48 89 c2             	mov    %rax,%rdx
  80192c:	be 01 00 00 00       	mov    $0x1,%esi
  801931:	bf 08 00 00 00       	mov    $0x8,%edi
  801936:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  80193d:	00 00 00 
  801940:	ff d0                	callq  *%rax
}
  801942:	c9                   	leaveq 
  801943:	c3                   	retq   

0000000000801944 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801944:	55                   	push   %rbp
  801945:	48 89 e5             	mov    %rsp,%rbp
  801948:	48 83 ec 20          	sub    $0x20,%rsp
  80194c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80194f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801953:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80195a:	48 98                	cltq   
  80195c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801963:	00 
  801964:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80196a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801970:	48 89 d1             	mov    %rdx,%rcx
  801973:	48 89 c2             	mov    %rax,%rdx
  801976:	be 01 00 00 00       	mov    $0x1,%esi
  80197b:	bf 09 00 00 00       	mov    $0x9,%edi
  801980:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  801987:	00 00 00 
  80198a:	ff d0                	callq  *%rax
}
  80198c:	c9                   	leaveq 
  80198d:	c3                   	retq   

000000000080198e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80198e:	55                   	push   %rbp
  80198f:	48 89 e5             	mov    %rsp,%rbp
  801992:	48 83 ec 20          	sub    $0x20,%rsp
  801996:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801999:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80199d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a4:	48 98                	cltq   
  8019a6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ad:	00 
  8019ae:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019ba:	48 89 d1             	mov    %rdx,%rcx
  8019bd:	48 89 c2             	mov    %rax,%rdx
  8019c0:	be 01 00 00 00       	mov    $0x1,%esi
  8019c5:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019ca:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  8019d1:	00 00 00 
  8019d4:	ff d0                	callq  *%rax
}
  8019d6:	c9                   	leaveq 
  8019d7:	c3                   	retq   

00000000008019d8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019d8:	55                   	push   %rbp
  8019d9:	48 89 e5             	mov    %rsp,%rbp
  8019dc:	48 83 ec 20          	sub    $0x20,%rsp
  8019e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019eb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019f1:	48 63 f0             	movslq %eax,%rsi
  8019f4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fb:	48 98                	cltq   
  8019fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a01:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a08:	00 
  801a09:	49 89 f1             	mov    %rsi,%r9
  801a0c:	49 89 c8             	mov    %rcx,%r8
  801a0f:	48 89 d1             	mov    %rdx,%rcx
  801a12:	48 89 c2             	mov    %rax,%rdx
  801a15:	be 00 00 00 00       	mov    $0x0,%esi
  801a1a:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a1f:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  801a26:	00 00 00 
  801a29:	ff d0                	callq  *%rax
}
  801a2b:	c9                   	leaveq 
  801a2c:	c3                   	retq   

0000000000801a2d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a2d:	55                   	push   %rbp
  801a2e:	48 89 e5             	mov    %rsp,%rbp
  801a31:	48 83 ec 10          	sub    $0x10,%rsp
  801a35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a3d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a44:	00 
  801a45:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a51:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a56:	48 89 c2             	mov    %rax,%rdx
  801a59:	be 01 00 00 00       	mov    $0x1,%esi
  801a5e:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a63:	48 b8 2e 16 80 00 00 	movabs $0x80162e,%rax
  801a6a:	00 00 00 
  801a6d:	ff d0                	callq  *%rax
}
  801a6f:	c9                   	leaveq 
  801a70:	c3                   	retq   

0000000000801a71 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a71:	55                   	push   %rbp
  801a72:	48 89 e5             	mov    %rsp,%rbp
  801a75:	53                   	push   %rbx
  801a76:	48 83 ec 48          	sub    $0x48,%rsp
  801a7a:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a7e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a82:	48 8b 00             	mov    (%rax),%rax
  801a85:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801a89:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a8d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801a91:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801a94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a98:	48 c1 e8 0c          	shr    $0xc,%rax
  801a9c:	48 89 c2             	mov    %rax,%rdx
  801a9f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801aa6:	01 00 00 
  801aa9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801aad:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801ab1:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801ab8:	00 00 00 
  801abb:	ff d0                	callq  *%rax
  801abd:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801ac0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ac4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801ac8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801acc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801ad2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801ad6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ad9:	83 e0 02             	and    $0x2,%eax
  801adc:	85 c0                	test   %eax,%eax
  801ade:	0f 84 8d 00 00 00    	je     801b71 <pgfault+0x100>
  801ae4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae8:	25 00 08 00 00       	and    $0x800,%eax
  801aed:	48 85 c0             	test   %rax,%rax
  801af0:	74 7f                	je     801b71 <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801af2:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801af5:	ba 07 00 00 00       	mov    $0x7,%edx
  801afa:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801aff:	89 c7                	mov    %eax,%edi
  801b01:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801b08:	00 00 00 
  801b0b:	ff d0                	callq  *%rax
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	75 60                	jne    801b71 <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801b11:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801b15:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b1a:	48 89 c6             	mov    %rax,%rsi
  801b1d:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b22:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  801b29:	00 00 00 
  801b2c:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801b2e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801b32:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801b35:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b38:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b3e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b43:	89 c7                	mov    %eax,%edi
  801b45:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801b4c:	00 00 00 
  801b4f:	ff d0                	callq  *%rax
  801b51:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801b53:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b56:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b5b:	89 c7                	mov    %eax,%edi
  801b5d:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  801b64:	00 00 00 
  801b67:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801b69:	09 d8                	or     %ebx,%eax
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	75 02                	jne    801b71 <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801b6f:	eb 2a                	jmp    801b9b <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801b71:	48 ba f3 41 80 00 00 	movabs $0x8041f3,%rdx
  801b78:	00 00 00 
  801b7b:	be 26 00 00 00       	mov    $0x26,%esi
  801b80:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  801b87:	00 00 00 
  801b8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8f:	48 b9 89 37 80 00 00 	movabs $0x803789,%rcx
  801b96:	00 00 00 
  801b99:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801b9b:	48 83 c4 48          	add    $0x48,%rsp
  801b9f:	5b                   	pop    %rbx
  801ba0:	5d                   	pop    %rbp
  801ba1:	c3                   	retq   

0000000000801ba2 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ba2:	55                   	push   %rbp
  801ba3:	48 89 e5             	mov    %rsp,%rbp
  801ba6:	53                   	push   %rbx
  801ba7:	48 83 ec 38          	sub    $0x38,%rsp
  801bab:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801bae:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801bb1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bb8:	01 00 00 
  801bbb:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801bbe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bc2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801bc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bca:	25 07 0e 00 00       	and    $0xe07,%eax
  801bcf:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801bd2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801bd5:	48 c1 e0 0c          	shl    $0xc,%rax
  801bd9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801bdd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801be0:	25 00 04 00 00       	and    $0x400,%eax
  801be5:	85 c0                	test   %eax,%eax
  801be7:	74 30                	je     801c19 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801be9:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801bec:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801bf0:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801bf3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bf7:	41 89 f0             	mov    %esi,%r8d
  801bfa:	48 89 c6             	mov    %rax,%rsi
  801bfd:	bf 00 00 00 00       	mov    $0x0,%edi
  801c02:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801c09:	00 00 00 
  801c0c:	ff d0                	callq  *%rax
  801c0e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801c11:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c14:	e9 a4 00 00 00       	jmpq   801cbd <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801c19:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c1c:	83 e0 02             	and    $0x2,%eax
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	75 0c                	jne    801c2f <duppage+0x8d>
  801c23:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c26:	25 00 08 00 00       	and    $0x800,%eax
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	74 63                	je     801c92 <duppage+0xf0>
		perm &= ~PTE_W;
  801c2f:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  801c33:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  801c3a:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801c3d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c41:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801c44:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c48:	41 89 f0             	mov    %esi,%r8d
  801c4b:	48 89 c6             	mov    %rax,%rsi
  801c4e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c53:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801c5a:	00 00 00 
  801c5d:	ff d0                	callq  *%rax
  801c5f:	89 c3                	mov    %eax,%ebx
  801c61:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801c64:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801c68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c6c:	41 89 c8             	mov    %ecx,%r8d
  801c6f:	48 89 d1             	mov    %rdx,%rcx
  801c72:	ba 00 00 00 00       	mov    $0x0,%edx
  801c77:	48 89 c6             	mov    %rax,%rsi
  801c7a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c7f:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801c86:	00 00 00 
  801c89:	ff d0                	callq  *%rax
  801c8b:	09 d8                	or     %ebx,%eax
  801c8d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c90:	eb 28                	jmp    801cba <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  801c92:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801c95:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c99:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801c9c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ca0:	41 89 f0             	mov    %esi,%r8d
  801ca3:	48 89 c6             	mov    %rax,%rsi
  801ca6:	bf 00 00 00 00       	mov    $0x0,%edi
  801cab:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  801cb2:	00 00 00 
  801cb5:	ff d0                	callq  *%rax
  801cb7:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  801cba:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801cbd:	48 83 c4 38          	add    $0x38,%rsp
  801cc1:	5b                   	pop    %rbx
  801cc2:	5d                   	pop    %rbp
  801cc3:	c3                   	retq   

0000000000801cc4 <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  801cc4:	55                   	push   %rbp
  801cc5:	48 89 e5             	mov    %rsp,%rbp
  801cc8:	53                   	push   %rbx
  801cc9:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801ccd:	48 bf 71 1a 80 00 00 	movabs $0x801a71,%rdi
  801cd4:	00 00 00 
  801cd7:	48 b8 9d 38 80 00 00 	movabs $0x80389d,%rax
  801cde:	00 00 00 
  801ce1:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801ce3:	b8 07 00 00 00       	mov    $0x7,%eax
  801ce8:	cd 30                	int    $0x30
  801cea:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801ced:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  801cf0:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  801cf3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cf7:	79 30                	jns    801d29 <fork+0x65>
  801cf9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801cfc:	89 c1                	mov    %eax,%ecx
  801cfe:	48 ba 1a 42 80 00 00 	movabs $0x80421a,%rdx
  801d05:	00 00 00 
  801d08:	be 72 00 00 00       	mov    $0x72,%esi
  801d0d:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  801d14:	00 00 00 
  801d17:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1c:	49 b8 89 37 80 00 00 	movabs $0x803789,%r8
  801d23:	00 00 00 
  801d26:	41 ff d0             	callq  *%r8
	if(cid == 0){
  801d29:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d2d:	75 46                	jne    801d75 <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  801d2f:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  801d36:	00 00 00 
  801d39:	ff d0                	callq  *%rax
  801d3b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d40:	48 63 d0             	movslq %eax,%rdx
  801d43:	48 89 d0             	mov    %rdx,%rax
  801d46:	48 c1 e0 03          	shl    $0x3,%rax
  801d4a:	48 01 d0             	add    %rdx,%rax
  801d4d:	48 c1 e0 05          	shl    $0x5,%rax
  801d51:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801d58:	00 00 00 
  801d5b:	48 01 c2             	add    %rax,%rdx
  801d5e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801d65:	00 00 00 
  801d68:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d70:	e9 12 02 00 00       	jmpq   801f87 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801d75:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d78:	ba 07 00 00 00       	mov    $0x7,%edx
  801d7d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801d82:	89 c7                	mov    %eax,%edi
  801d84:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  801d8b:	00 00 00 
  801d8e:	ff d0                	callq  *%rax
  801d90:	89 45 c8             	mov    %eax,-0x38(%rbp)
  801d93:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  801d97:	79 30                	jns    801dc9 <fork+0x105>
		panic("fork failed: %e\n", result);
  801d99:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d9c:	89 c1                	mov    %eax,%ecx
  801d9e:	48 ba 1a 42 80 00 00 	movabs $0x80421a,%rdx
  801da5:	00 00 00 
  801da8:	be 79 00 00 00       	mov    $0x79,%esi
  801dad:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  801db4:	00 00 00 
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	49 b8 89 37 80 00 00 	movabs $0x803789,%r8
  801dc3:	00 00 00 
  801dc6:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  801dc9:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801dd0:	00 
  801dd1:	e9 40 01 00 00       	jmpq   801f16 <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  801dd6:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801ddd:	01 00 00 
  801de0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801de4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de8:	83 e0 01             	and    $0x1,%eax
  801deb:	48 85 c0             	test   %rax,%rax
  801dee:	0f 84 1d 01 00 00    	je     801f11 <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  801df4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df8:	48 c1 e0 09          	shl    $0x9,%rax
  801dfc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  801e00:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  801e07:	00 
  801e08:	e9 f6 00 00 00       	jmpq   801f03 <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  801e0d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e11:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801e15:	48 01 c2             	add    %rax,%rdx
  801e18:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801e1f:	01 00 00 
  801e22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e26:	83 e0 01             	and    $0x1,%eax
  801e29:	48 85 c0             	test   %rax,%rax
  801e2c:	0f 84 cc 00 00 00    	je     801efe <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  801e32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e36:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801e3a:	48 01 d0             	add    %rdx,%rax
  801e3d:	48 c1 e0 09          	shl    $0x9,%rax
  801e41:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  801e45:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  801e4c:	00 
  801e4d:	e9 9e 00 00 00       	jmpq   801ef0 <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  801e52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e56:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801e5a:	48 01 c2             	add    %rax,%rdx
  801e5d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e64:	01 00 00 
  801e67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6b:	83 e0 01             	and    $0x1,%eax
  801e6e:	48 85 c0             	test   %rax,%rax
  801e71:	74 78                	je     801eeb <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  801e73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e77:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801e7b:	48 01 d0             	add    %rdx,%rax
  801e7e:	48 c1 e0 09          	shl    $0x9,%rax
  801e82:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  801e86:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  801e8d:	00 
  801e8e:	eb 51                	jmp    801ee1 <fork+0x21d>
								entry = base_pde + pte;
  801e90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e94:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801e98:	48 01 d0             	add    %rdx,%rax
  801e9b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  801e9f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ea6:	01 00 00 
  801ea9:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801ead:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb1:	83 e0 01             	and    $0x1,%eax
  801eb4:	48 85 c0             	test   %rax,%rax
  801eb7:	74 23                	je     801edc <fork+0x218>
  801eb9:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  801ec0:	00 
  801ec1:	74 19                	je     801edc <fork+0x218>
									duppage(cid, entry);
  801ec3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ec7:	89 c2                	mov    %eax,%edx
  801ec9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ecc:	89 d6                	mov    %edx,%esi
  801ece:	89 c7                	mov    %eax,%edi
  801ed0:	48 b8 a2 1b 80 00 00 	movabs $0x801ba2,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  801edc:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  801ee1:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  801ee8:	00 
  801ee9:	76 a5                	jbe    801e90 <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  801eeb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801ef0:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  801ef7:	00 
  801ef8:	0f 86 54 ff ff ff    	jbe    801e52 <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  801efe:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801f03:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  801f0a:	00 
  801f0b:	0f 86 fc fe ff ff    	jbe    801e0d <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  801f11:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801f16:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801f1b:	0f 84 b5 fe ff ff    	je     801dd6 <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  801f21:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f24:	48 be 32 39 80 00 00 	movabs $0x803932,%rsi
  801f2b:	00 00 00 
  801f2e:	89 c7                	mov    %eax,%edi
  801f30:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  801f37:	00 00 00 
  801f3a:	ff d0                	callq  *%rax
  801f3c:	89 c3                	mov    %eax,%ebx
  801f3e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f41:	be 02 00 00 00       	mov    $0x2,%esi
  801f46:	89 c7                	mov    %eax,%edi
  801f48:	48 b8 f9 18 80 00 00 	movabs $0x8018f9,%rax
  801f4f:	00 00 00 
  801f52:	ff d0                	callq  *%rax
  801f54:	09 d8                	or     %ebx,%eax
  801f56:	85 c0                	test   %eax,%eax
  801f58:	74 2a                	je     801f84 <fork+0x2c0>
		panic("fork failed\n");
  801f5a:	48 ba 2b 42 80 00 00 	movabs $0x80422b,%rdx
  801f61:	00 00 00 
  801f64:	be 92 00 00 00       	mov    $0x92,%esi
  801f69:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  801f70:	00 00 00 
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
  801f78:	48 b9 89 37 80 00 00 	movabs $0x803789,%rcx
  801f7f:	00 00 00 
  801f82:	ff d1                	callq  *%rcx
	return cid;
  801f84:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  801f87:	48 83 c4 58          	add    $0x58,%rsp
  801f8b:	5b                   	pop    %rbx
  801f8c:	5d                   	pop    %rbp
  801f8d:	c3                   	retq   

0000000000801f8e <sfork>:


// Challenge!
int
sfork(void)
{
  801f8e:	55                   	push   %rbp
  801f8f:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  801f92:	48 ba 38 42 80 00 00 	movabs $0x804238,%rdx
  801f99:	00 00 00 
  801f9c:	be 9c 00 00 00       	mov    $0x9c,%esi
  801fa1:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  801fa8:	00 00 00 
  801fab:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb0:	48 b9 89 37 80 00 00 	movabs $0x803789,%rcx
  801fb7:	00 00 00 
  801fba:	ff d1                	callq  *%rcx

0000000000801fbc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801fbc:	55                   	push   %rbp
  801fbd:	48 89 e5             	mov    %rsp,%rbp
  801fc0:	48 83 ec 08          	sub    $0x8,%rsp
  801fc4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fc8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fcc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801fd3:	ff ff ff 
  801fd6:	48 01 d0             	add    %rdx,%rax
  801fd9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801fdd:	c9                   	leaveq 
  801fde:	c3                   	retq   

0000000000801fdf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801fdf:	55                   	push   %rbp
  801fe0:	48 89 e5             	mov    %rsp,%rbp
  801fe3:	48 83 ec 08          	sub    $0x8,%rsp
  801fe7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801feb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fef:	48 89 c7             	mov    %rax,%rdi
  801ff2:	48 b8 bc 1f 80 00 00 	movabs $0x801fbc,%rax
  801ff9:	00 00 00 
  801ffc:	ff d0                	callq  *%rax
  801ffe:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802004:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802008:	c9                   	leaveq 
  802009:	c3                   	retq   

000000000080200a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80200a:	55                   	push   %rbp
  80200b:	48 89 e5             	mov    %rsp,%rbp
  80200e:	48 83 ec 18          	sub    $0x18,%rsp
  802012:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802016:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80201d:	eb 6b                	jmp    80208a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80201f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802022:	48 98                	cltq   
  802024:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80202a:	48 c1 e0 0c          	shl    $0xc,%rax
  80202e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802032:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802036:	48 c1 e8 15          	shr    $0x15,%rax
  80203a:	48 89 c2             	mov    %rax,%rdx
  80203d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802044:	01 00 00 
  802047:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80204b:	83 e0 01             	and    $0x1,%eax
  80204e:	48 85 c0             	test   %rax,%rax
  802051:	74 21                	je     802074 <fd_alloc+0x6a>
  802053:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802057:	48 c1 e8 0c          	shr    $0xc,%rax
  80205b:	48 89 c2             	mov    %rax,%rdx
  80205e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802065:	01 00 00 
  802068:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80206c:	83 e0 01             	and    $0x1,%eax
  80206f:	48 85 c0             	test   %rax,%rax
  802072:	75 12                	jne    802086 <fd_alloc+0x7c>
			*fd_store = fd;
  802074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802078:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80207c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	eb 1a                	jmp    8020a0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802086:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80208a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80208e:	7e 8f                	jle    80201f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802090:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802094:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80209b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8020a0:	c9                   	leaveq 
  8020a1:	c3                   	retq   

00000000008020a2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8020a2:	55                   	push   %rbp
  8020a3:	48 89 e5             	mov    %rsp,%rbp
  8020a6:	48 83 ec 20          	sub    $0x20,%rsp
  8020aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8020b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020b5:	78 06                	js     8020bd <fd_lookup+0x1b>
  8020b7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8020bb:	7e 07                	jle    8020c4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8020bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020c2:	eb 6c                	jmp    802130 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8020c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020c7:	48 98                	cltq   
  8020c9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020cf:	48 c1 e0 0c          	shl    $0xc,%rax
  8020d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8020d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020db:	48 c1 e8 15          	shr    $0x15,%rax
  8020df:	48 89 c2             	mov    %rax,%rdx
  8020e2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020e9:	01 00 00 
  8020ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020f0:	83 e0 01             	and    $0x1,%eax
  8020f3:	48 85 c0             	test   %rax,%rax
  8020f6:	74 21                	je     802119 <fd_lookup+0x77>
  8020f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020fc:	48 c1 e8 0c          	shr    $0xc,%rax
  802100:	48 89 c2             	mov    %rax,%rdx
  802103:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80210a:	01 00 00 
  80210d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802111:	83 e0 01             	and    $0x1,%eax
  802114:	48 85 c0             	test   %rax,%rax
  802117:	75 07                	jne    802120 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802119:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80211e:	eb 10                	jmp    802130 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802124:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802128:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80212b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802130:	c9                   	leaveq 
  802131:	c3                   	retq   

0000000000802132 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802132:	55                   	push   %rbp
  802133:	48 89 e5             	mov    %rsp,%rbp
  802136:	48 83 ec 30          	sub    $0x30,%rsp
  80213a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80213e:	89 f0                	mov    %esi,%eax
  802140:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802143:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802147:	48 89 c7             	mov    %rax,%rdi
  80214a:	48 b8 bc 1f 80 00 00 	movabs $0x801fbc,%rax
  802151:	00 00 00 
  802154:	ff d0                	callq  *%rax
  802156:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80215a:	48 89 d6             	mov    %rdx,%rsi
  80215d:	89 c7                	mov    %eax,%edi
  80215f:	48 b8 a2 20 80 00 00 	movabs $0x8020a2,%rax
  802166:	00 00 00 
  802169:	ff d0                	callq  *%rax
  80216b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80216e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802172:	78 0a                	js     80217e <fd_close+0x4c>
	    || fd != fd2)
  802174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802178:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80217c:	74 12                	je     802190 <fd_close+0x5e>
		return (must_exist ? r : 0);
  80217e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802182:	74 05                	je     802189 <fd_close+0x57>
  802184:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802187:	eb 05                	jmp    80218e <fd_close+0x5c>
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
  80218e:	eb 69                	jmp    8021f9 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802190:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802194:	8b 00                	mov    (%rax),%eax
  802196:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80219a:	48 89 d6             	mov    %rdx,%rsi
  80219d:	89 c7                	mov    %eax,%edi
  80219f:	48 b8 fb 21 80 00 00 	movabs $0x8021fb,%rax
  8021a6:	00 00 00 
  8021a9:	ff d0                	callq  *%rax
  8021ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b2:	78 2a                	js     8021de <fd_close+0xac>
		if (dev->dev_close)
  8021b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021bc:	48 85 c0             	test   %rax,%rax
  8021bf:	74 16                	je     8021d7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8021c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021c9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021cd:	48 89 d7             	mov    %rdx,%rdi
  8021d0:	ff d0                	callq  *%rax
  8021d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d5:	eb 07                	jmp    8021de <fd_close+0xac>
		else
			r = 0;
  8021d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8021de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021e2:	48 89 c6             	mov    %rax,%rsi
  8021e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ea:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  8021f1:	00 00 00 
  8021f4:	ff d0                	callq  *%rax
	return r;
  8021f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021f9:	c9                   	leaveq 
  8021fa:	c3                   	retq   

00000000008021fb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8021fb:	55                   	push   %rbp
  8021fc:	48 89 e5             	mov    %rsp,%rbp
  8021ff:	48 83 ec 20          	sub    $0x20,%rsp
  802203:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802206:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80220a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802211:	eb 41                	jmp    802254 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802213:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80221a:	00 00 00 
  80221d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802220:	48 63 d2             	movslq %edx,%rdx
  802223:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802227:	8b 00                	mov    (%rax),%eax
  802229:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80222c:	75 22                	jne    802250 <dev_lookup+0x55>
			*dev = devtab[i];
  80222e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802235:	00 00 00 
  802238:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80223b:	48 63 d2             	movslq %edx,%rdx
  80223e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802242:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802246:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802249:	b8 00 00 00 00       	mov    $0x0,%eax
  80224e:	eb 60                	jmp    8022b0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802250:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802254:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80225b:	00 00 00 
  80225e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802261:	48 63 d2             	movslq %edx,%rdx
  802264:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802268:	48 85 c0             	test   %rax,%rax
  80226b:	75 a6                	jne    802213 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80226d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802274:	00 00 00 
  802277:	48 8b 00             	mov    (%rax),%rax
  80227a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802280:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802283:	89 c6                	mov    %eax,%esi
  802285:	48 bf 50 42 80 00 00 	movabs $0x804250,%rdi
  80228c:	00 00 00 
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
  802294:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  80229b:	00 00 00 
  80229e:	ff d1                	callq  *%rcx
	*dev = 0;
  8022a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8022ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8022b0:	c9                   	leaveq 
  8022b1:	c3                   	retq   

00000000008022b2 <close>:

int
close(int fdnum)
{
  8022b2:	55                   	push   %rbp
  8022b3:	48 89 e5             	mov    %rsp,%rbp
  8022b6:	48 83 ec 20          	sub    $0x20,%rsp
  8022ba:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022c4:	48 89 d6             	mov    %rdx,%rsi
  8022c7:	89 c7                	mov    %eax,%edi
  8022c9:	48 b8 a2 20 80 00 00 	movabs $0x8020a2,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	callq  *%rax
  8022d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022dc:	79 05                	jns    8022e3 <close+0x31>
		return r;
  8022de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e1:	eb 18                	jmp    8022fb <close+0x49>
	else
		return fd_close(fd, 1);
  8022e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e7:	be 01 00 00 00       	mov    $0x1,%esi
  8022ec:	48 89 c7             	mov    %rax,%rdi
  8022ef:	48 b8 32 21 80 00 00 	movabs $0x802132,%rax
  8022f6:	00 00 00 
  8022f9:	ff d0                	callq  *%rax
}
  8022fb:	c9                   	leaveq 
  8022fc:	c3                   	retq   

00000000008022fd <close_all>:

void
close_all(void)
{
  8022fd:	55                   	push   %rbp
  8022fe:	48 89 e5             	mov    %rsp,%rbp
  802301:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80230c:	eb 15                	jmp    802323 <close_all+0x26>
		close(i);
  80230e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802311:	89 c7                	mov    %eax,%edi
  802313:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  80231a:	00 00 00 
  80231d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80231f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802323:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802327:	7e e5                	jle    80230e <close_all+0x11>
		close(i);
}
  802329:	c9                   	leaveq 
  80232a:	c3                   	retq   

000000000080232b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80232b:	55                   	push   %rbp
  80232c:	48 89 e5             	mov    %rsp,%rbp
  80232f:	48 83 ec 40          	sub    $0x40,%rsp
  802333:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802336:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802339:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80233d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802340:	48 89 d6             	mov    %rdx,%rsi
  802343:	89 c7                	mov    %eax,%edi
  802345:	48 b8 a2 20 80 00 00 	movabs $0x8020a2,%rax
  80234c:	00 00 00 
  80234f:	ff d0                	callq  *%rax
  802351:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802354:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802358:	79 08                	jns    802362 <dup+0x37>
		return r;
  80235a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80235d:	e9 70 01 00 00       	jmpq   8024d2 <dup+0x1a7>
	close(newfdnum);
  802362:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802365:	89 c7                	mov    %eax,%edi
  802367:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  80236e:	00 00 00 
  802371:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802373:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802376:	48 98                	cltq   
  802378:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80237e:	48 c1 e0 0c          	shl    $0xc,%rax
  802382:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802386:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80238a:	48 89 c7             	mov    %rax,%rdi
  80238d:	48 b8 df 1f 80 00 00 	movabs $0x801fdf,%rax
  802394:	00 00 00 
  802397:	ff d0                	callq  *%rax
  802399:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80239d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a1:	48 89 c7             	mov    %rax,%rdi
  8023a4:	48 b8 df 1f 80 00 00 	movabs $0x801fdf,%rax
  8023ab:	00 00 00 
  8023ae:	ff d0                	callq  *%rax
  8023b0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8023b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023b8:	48 c1 e8 15          	shr    $0x15,%rax
  8023bc:	48 89 c2             	mov    %rax,%rdx
  8023bf:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023c6:	01 00 00 
  8023c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023cd:	83 e0 01             	and    $0x1,%eax
  8023d0:	48 85 c0             	test   %rax,%rax
  8023d3:	74 73                	je     802448 <dup+0x11d>
  8023d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d9:	48 c1 e8 0c          	shr    $0xc,%rax
  8023dd:	48 89 c2             	mov    %rax,%rdx
  8023e0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023e7:	01 00 00 
  8023ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ee:	83 e0 01             	and    $0x1,%eax
  8023f1:	48 85 c0             	test   %rax,%rax
  8023f4:	74 52                	je     802448 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8023f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023fa:	48 c1 e8 0c          	shr    $0xc,%rax
  8023fe:	48 89 c2             	mov    %rax,%rdx
  802401:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802408:	01 00 00 
  80240b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80240f:	25 07 0e 00 00       	and    $0xe07,%eax
  802414:	89 c1                	mov    %eax,%ecx
  802416:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80241a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80241e:	41 89 c8             	mov    %ecx,%r8d
  802421:	48 89 d1             	mov    %rdx,%rcx
  802424:	ba 00 00 00 00       	mov    $0x0,%edx
  802429:	48 89 c6             	mov    %rax,%rsi
  80242c:	bf 00 00 00 00       	mov    $0x0,%edi
  802431:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  802438:	00 00 00 
  80243b:	ff d0                	callq  *%rax
  80243d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802440:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802444:	79 02                	jns    802448 <dup+0x11d>
			goto err;
  802446:	eb 57                	jmp    80249f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80244c:	48 c1 e8 0c          	shr    $0xc,%rax
  802450:	48 89 c2             	mov    %rax,%rdx
  802453:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80245a:	01 00 00 
  80245d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802461:	25 07 0e 00 00       	and    $0xe07,%eax
  802466:	89 c1                	mov    %eax,%ecx
  802468:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80246c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802470:	41 89 c8             	mov    %ecx,%r8d
  802473:	48 89 d1             	mov    %rdx,%rcx
  802476:	ba 00 00 00 00       	mov    $0x0,%edx
  80247b:	48 89 c6             	mov    %rax,%rsi
  80247e:	bf 00 00 00 00       	mov    $0x0,%edi
  802483:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  80248a:	00 00 00 
  80248d:	ff d0                	callq  *%rax
  80248f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802492:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802496:	79 02                	jns    80249a <dup+0x16f>
		goto err;
  802498:	eb 05                	jmp    80249f <dup+0x174>

	return newfdnum;
  80249a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80249d:	eb 33                	jmp    8024d2 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80249f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a3:	48 89 c6             	mov    %rax,%rsi
  8024a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ab:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  8024b2:	00 00 00 
  8024b5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8024b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024bb:	48 89 c6             	mov    %rax,%rsi
  8024be:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c3:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  8024ca:	00 00 00 
  8024cd:	ff d0                	callq  *%rax
	return r;
  8024cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024d2:	c9                   	leaveq 
  8024d3:	c3                   	retq   

00000000008024d4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8024d4:	55                   	push   %rbp
  8024d5:	48 89 e5             	mov    %rsp,%rbp
  8024d8:	48 83 ec 40          	sub    $0x40,%rsp
  8024dc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8024e3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024e7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024eb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024ee:	48 89 d6             	mov    %rdx,%rsi
  8024f1:	89 c7                	mov    %eax,%edi
  8024f3:	48 b8 a2 20 80 00 00 	movabs $0x8020a2,%rax
  8024fa:	00 00 00 
  8024fd:	ff d0                	callq  *%rax
  8024ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802502:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802506:	78 24                	js     80252c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802508:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80250c:	8b 00                	mov    (%rax),%eax
  80250e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802512:	48 89 d6             	mov    %rdx,%rsi
  802515:	89 c7                	mov    %eax,%edi
  802517:	48 b8 fb 21 80 00 00 	movabs $0x8021fb,%rax
  80251e:	00 00 00 
  802521:	ff d0                	callq  *%rax
  802523:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802526:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80252a:	79 05                	jns    802531 <read+0x5d>
		return r;
  80252c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80252f:	eb 76                	jmp    8025a7 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802531:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802535:	8b 40 08             	mov    0x8(%rax),%eax
  802538:	83 e0 03             	and    $0x3,%eax
  80253b:	83 f8 01             	cmp    $0x1,%eax
  80253e:	75 3a                	jne    80257a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802540:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802547:	00 00 00 
  80254a:	48 8b 00             	mov    (%rax),%rax
  80254d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802553:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802556:	89 c6                	mov    %eax,%esi
  802558:	48 bf 6f 42 80 00 00 	movabs $0x80426f,%rdi
  80255f:	00 00 00 
  802562:	b8 00 00 00 00       	mov    $0x0,%eax
  802567:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  80256e:	00 00 00 
  802571:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802573:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802578:	eb 2d                	jmp    8025a7 <read+0xd3>
	}
	if (!dev->dev_read)
  80257a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802582:	48 85 c0             	test   %rax,%rax
  802585:	75 07                	jne    80258e <read+0xba>
		return -E_NOT_SUPP;
  802587:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80258c:	eb 19                	jmp    8025a7 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80258e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802592:	48 8b 40 10          	mov    0x10(%rax),%rax
  802596:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80259a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80259e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025a2:	48 89 cf             	mov    %rcx,%rdi
  8025a5:	ff d0                	callq  *%rax
}
  8025a7:	c9                   	leaveq 
  8025a8:	c3                   	retq   

00000000008025a9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8025a9:	55                   	push   %rbp
  8025aa:	48 89 e5             	mov    %rsp,%rbp
  8025ad:	48 83 ec 30          	sub    $0x30,%rsp
  8025b1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8025bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025c3:	eb 49                	jmp    80260e <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8025c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c8:	48 98                	cltq   
  8025ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025ce:	48 29 c2             	sub    %rax,%rdx
  8025d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d4:	48 63 c8             	movslq %eax,%rcx
  8025d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025db:	48 01 c1             	add    %rax,%rcx
  8025de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025e1:	48 89 ce             	mov    %rcx,%rsi
  8025e4:	89 c7                	mov    %eax,%edi
  8025e6:	48 b8 d4 24 80 00 00 	movabs $0x8024d4,%rax
  8025ed:	00 00 00 
  8025f0:	ff d0                	callq  *%rax
  8025f2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8025f5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8025f9:	79 05                	jns    802600 <readn+0x57>
			return m;
  8025fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025fe:	eb 1c                	jmp    80261c <readn+0x73>
		if (m == 0)
  802600:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802604:	75 02                	jne    802608 <readn+0x5f>
			break;
  802606:	eb 11                	jmp    802619 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802608:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80260b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80260e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802611:	48 98                	cltq   
  802613:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802617:	72 ac                	jb     8025c5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802619:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80261c:	c9                   	leaveq 
  80261d:	c3                   	retq   

000000000080261e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80261e:	55                   	push   %rbp
  80261f:	48 89 e5             	mov    %rsp,%rbp
  802622:	48 83 ec 40          	sub    $0x40,%rsp
  802626:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802629:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80262d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802631:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802635:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802638:	48 89 d6             	mov    %rdx,%rsi
  80263b:	89 c7                	mov    %eax,%edi
  80263d:	48 b8 a2 20 80 00 00 	movabs $0x8020a2,%rax
  802644:	00 00 00 
  802647:	ff d0                	callq  *%rax
  802649:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802650:	78 24                	js     802676 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802656:	8b 00                	mov    (%rax),%eax
  802658:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80265c:	48 89 d6             	mov    %rdx,%rsi
  80265f:	89 c7                	mov    %eax,%edi
  802661:	48 b8 fb 21 80 00 00 	movabs $0x8021fb,%rax
  802668:	00 00 00 
  80266b:	ff d0                	callq  *%rax
  80266d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802670:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802674:	79 05                	jns    80267b <write+0x5d>
		return r;
  802676:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802679:	eb 75                	jmp    8026f0 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80267b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80267f:	8b 40 08             	mov    0x8(%rax),%eax
  802682:	83 e0 03             	and    $0x3,%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	75 3a                	jne    8026c3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802689:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802690:	00 00 00 
  802693:	48 8b 00             	mov    (%rax),%rax
  802696:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80269c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80269f:	89 c6                	mov    %eax,%esi
  8026a1:	48 bf 8b 42 80 00 00 	movabs $0x80428b,%rdi
  8026a8:	00 00 00 
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  8026b7:	00 00 00 
  8026ba:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026c1:	eb 2d                	jmp    8026f0 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8026c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026cb:	48 85 c0             	test   %rax,%rax
  8026ce:	75 07                	jne    8026d7 <write+0xb9>
		return -E_NOT_SUPP;
  8026d0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026d5:	eb 19                	jmp    8026f0 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8026d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026db:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026df:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026e3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8026e7:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8026eb:	48 89 cf             	mov    %rcx,%rdi
  8026ee:	ff d0                	callq  *%rax
}
  8026f0:	c9                   	leaveq 
  8026f1:	c3                   	retq   

00000000008026f2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8026f2:	55                   	push   %rbp
  8026f3:	48 89 e5             	mov    %rsp,%rbp
  8026f6:	48 83 ec 18          	sub    $0x18,%rsp
  8026fa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026fd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802700:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802704:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802707:	48 89 d6             	mov    %rdx,%rsi
  80270a:	89 c7                	mov    %eax,%edi
  80270c:	48 b8 a2 20 80 00 00 	movabs $0x8020a2,%rax
  802713:	00 00 00 
  802716:	ff d0                	callq  *%rax
  802718:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80271b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271f:	79 05                	jns    802726 <seek+0x34>
		return r;
  802721:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802724:	eb 0f                	jmp    802735 <seek+0x43>
	fd->fd_offset = offset;
  802726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80272d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802730:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802735:	c9                   	leaveq 
  802736:	c3                   	retq   

0000000000802737 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802737:	55                   	push   %rbp
  802738:	48 89 e5             	mov    %rsp,%rbp
  80273b:	48 83 ec 30          	sub    $0x30,%rsp
  80273f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802742:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802745:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802749:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80274c:	48 89 d6             	mov    %rdx,%rsi
  80274f:	89 c7                	mov    %eax,%edi
  802751:	48 b8 a2 20 80 00 00 	movabs $0x8020a2,%rax
  802758:	00 00 00 
  80275b:	ff d0                	callq  *%rax
  80275d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802760:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802764:	78 24                	js     80278a <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802766:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276a:	8b 00                	mov    (%rax),%eax
  80276c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802770:	48 89 d6             	mov    %rdx,%rsi
  802773:	89 c7                	mov    %eax,%edi
  802775:	48 b8 fb 21 80 00 00 	movabs $0x8021fb,%rax
  80277c:	00 00 00 
  80277f:	ff d0                	callq  *%rax
  802781:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802784:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802788:	79 05                	jns    80278f <ftruncate+0x58>
		return r;
  80278a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278d:	eb 72                	jmp    802801 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80278f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802793:	8b 40 08             	mov    0x8(%rax),%eax
  802796:	83 e0 03             	and    $0x3,%eax
  802799:	85 c0                	test   %eax,%eax
  80279b:	75 3a                	jne    8027d7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80279d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027a4:	00 00 00 
  8027a7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8027aa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027b0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027b3:	89 c6                	mov    %eax,%esi
  8027b5:	48 bf a8 42 80 00 00 	movabs $0x8042a8,%rdi
  8027bc:	00 00 00 
  8027bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c4:	48 b9 20 03 80 00 00 	movabs $0x800320,%rcx
  8027cb:	00 00 00 
  8027ce:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8027d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027d5:	eb 2a                	jmp    802801 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8027d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027db:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027df:	48 85 c0             	test   %rax,%rax
  8027e2:	75 07                	jne    8027eb <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8027e4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8027e9:	eb 16                	jmp    802801 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8027eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027ef:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027f7:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8027fa:	89 ce                	mov    %ecx,%esi
  8027fc:	48 89 d7             	mov    %rdx,%rdi
  8027ff:	ff d0                	callq  *%rax
}
  802801:	c9                   	leaveq 
  802802:	c3                   	retq   

0000000000802803 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802803:	55                   	push   %rbp
  802804:	48 89 e5             	mov    %rsp,%rbp
  802807:	48 83 ec 30          	sub    $0x30,%rsp
  80280b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80280e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802812:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802816:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802819:	48 89 d6             	mov    %rdx,%rsi
  80281c:	89 c7                	mov    %eax,%edi
  80281e:	48 b8 a2 20 80 00 00 	movabs $0x8020a2,%rax
  802825:	00 00 00 
  802828:	ff d0                	callq  *%rax
  80282a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802831:	78 24                	js     802857 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802833:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802837:	8b 00                	mov    (%rax),%eax
  802839:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80283d:	48 89 d6             	mov    %rdx,%rsi
  802840:	89 c7                	mov    %eax,%edi
  802842:	48 b8 fb 21 80 00 00 	movabs $0x8021fb,%rax
  802849:	00 00 00 
  80284c:	ff d0                	callq  *%rax
  80284e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802851:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802855:	79 05                	jns    80285c <fstat+0x59>
		return r;
  802857:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285a:	eb 5e                	jmp    8028ba <fstat+0xb7>
	if (!dev->dev_stat)
  80285c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802860:	48 8b 40 28          	mov    0x28(%rax),%rax
  802864:	48 85 c0             	test   %rax,%rax
  802867:	75 07                	jne    802870 <fstat+0x6d>
		return -E_NOT_SUPP;
  802869:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80286e:	eb 4a                	jmp    8028ba <fstat+0xb7>
	stat->st_name[0] = 0;
  802870:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802874:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802877:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80287b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802882:	00 00 00 
	stat->st_isdir = 0;
  802885:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802889:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802890:	00 00 00 
	stat->st_dev = dev;
  802893:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802897:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80289b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8028a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028a6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028ae:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028b2:	48 89 ce             	mov    %rcx,%rsi
  8028b5:	48 89 d7             	mov    %rdx,%rdi
  8028b8:	ff d0                	callq  *%rax
}
  8028ba:	c9                   	leaveq 
  8028bb:	c3                   	retq   

00000000008028bc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8028bc:	55                   	push   %rbp
  8028bd:	48 89 e5             	mov    %rsp,%rbp
  8028c0:	48 83 ec 20          	sub    $0x20,%rsp
  8028c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8028cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d0:	be 00 00 00 00       	mov    $0x0,%esi
  8028d5:	48 89 c7             	mov    %rax,%rdi
  8028d8:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  8028df:	00 00 00 
  8028e2:	ff d0                	callq  *%rax
  8028e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028eb:	79 05                	jns    8028f2 <stat+0x36>
		return fd;
  8028ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f0:	eb 2f                	jmp    802921 <stat+0x65>
	r = fstat(fd, stat);
  8028f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f9:	48 89 d6             	mov    %rdx,%rsi
  8028fc:	89 c7                	mov    %eax,%edi
  8028fe:	48 b8 03 28 80 00 00 	movabs $0x802803,%rax
  802905:	00 00 00 
  802908:	ff d0                	callq  *%rax
  80290a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80290d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802910:	89 c7                	mov    %eax,%edi
  802912:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  802919:	00 00 00 
  80291c:	ff d0                	callq  *%rax
	return r;
  80291e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802921:	c9                   	leaveq 
  802922:	c3                   	retq   

0000000000802923 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802923:	55                   	push   %rbp
  802924:	48 89 e5             	mov    %rsp,%rbp
  802927:	48 83 ec 10          	sub    $0x10,%rsp
  80292b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80292e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802932:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802939:	00 00 00 
  80293c:	8b 00                	mov    (%rax),%eax
  80293e:	85 c0                	test   %eax,%eax
  802940:	75 1d                	jne    80295f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802942:	bf 01 00 00 00       	mov    $0x1,%edi
  802947:	48 b8 1f 3b 80 00 00 	movabs $0x803b1f,%rax
  80294e:	00 00 00 
  802951:	ff d0                	callq  *%rax
  802953:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80295a:	00 00 00 
  80295d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80295f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802966:	00 00 00 
  802969:	8b 00                	mov    (%rax),%eax
  80296b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80296e:	b9 07 00 00 00       	mov    $0x7,%ecx
  802973:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  80297a:	00 00 00 
  80297d:	89 c7                	mov    %eax,%edi
  80297f:	48 b8 82 3a 80 00 00 	movabs $0x803a82,%rax
  802986:	00 00 00 
  802989:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80298b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80298f:	ba 00 00 00 00       	mov    $0x0,%edx
  802994:	48 89 c6             	mov    %rax,%rsi
  802997:	bf 00 00 00 00       	mov    $0x0,%edi
  80299c:	48 b8 bc 39 80 00 00 	movabs $0x8039bc,%rax
  8029a3:	00 00 00 
  8029a6:	ff d0                	callq  *%rax
}
  8029a8:	c9                   	leaveq 
  8029a9:	c3                   	retq   

00000000008029aa <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8029aa:	55                   	push   %rbp
  8029ab:	48 89 e5             	mov    %rsp,%rbp
  8029ae:	48 83 ec 20          	sub    $0x20,%rsp
  8029b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029b6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  8029b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029bd:	48 89 c7             	mov    %rax,%rdi
  8029c0:	48 b8 69 0e 80 00 00 	movabs $0x800e69,%rax
  8029c7:	00 00 00 
  8029ca:	ff d0                	callq  *%rax
  8029cc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029d1:	7e 0a                	jle    8029dd <open+0x33>
  8029d3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029d8:	e9 a5 00 00 00       	jmpq   802a82 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8029dd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8029e1:	48 89 c7             	mov    %rax,%rdi
  8029e4:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  8029eb:	00 00 00 
  8029ee:	ff d0                	callq  *%rax
  8029f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f7:	79 08                	jns    802a01 <open+0x57>
		return r;
  8029f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fc:	e9 81 00 00 00       	jmpq   802a82 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802a01:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a08:	00 00 00 
  802a0b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802a0e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802a14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a18:	48 89 c6             	mov    %rax,%rsi
  802a1b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a22:	00 00 00 
  802a25:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  802a2c:	00 00 00 
  802a2f:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802a31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a35:	48 89 c6             	mov    %rax,%rsi
  802a38:	bf 01 00 00 00       	mov    $0x1,%edi
  802a3d:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802a44:	00 00 00 
  802a47:	ff d0                	callq  *%rax
  802a49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a50:	79 1d                	jns    802a6f <open+0xc5>
		fd_close(fd, 0);
  802a52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a56:	be 00 00 00 00       	mov    $0x0,%esi
  802a5b:	48 89 c7             	mov    %rax,%rdi
  802a5e:	48 b8 32 21 80 00 00 	movabs $0x802132,%rax
  802a65:	00 00 00 
  802a68:	ff d0                	callq  *%rax
		return r;
  802a6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a6d:	eb 13                	jmp    802a82 <open+0xd8>
	}
	return fd2num(fd);
  802a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a73:	48 89 c7             	mov    %rax,%rdi
  802a76:	48 b8 bc 1f 80 00 00 	movabs $0x801fbc,%rax
  802a7d:	00 00 00 
  802a80:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802a82:	c9                   	leaveq 
  802a83:	c3                   	retq   

0000000000802a84 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802a84:	55                   	push   %rbp
  802a85:	48 89 e5             	mov    %rsp,%rbp
  802a88:	48 83 ec 10          	sub    $0x10,%rsp
  802a8c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802a90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a94:	8b 50 0c             	mov    0xc(%rax),%edx
  802a97:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a9e:	00 00 00 
  802aa1:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802aa3:	be 00 00 00 00       	mov    $0x0,%esi
  802aa8:	bf 06 00 00 00       	mov    $0x6,%edi
  802aad:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802ab4:	00 00 00 
  802ab7:	ff d0                	callq  *%rax
}
  802ab9:	c9                   	leaveq 
  802aba:	c3                   	retq   

0000000000802abb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802abb:	55                   	push   %rbp
  802abc:	48 89 e5             	mov    %rsp,%rbp
  802abf:	48 83 ec 30          	sub    $0x30,%rsp
  802ac3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ac7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802acb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802acf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad3:	8b 50 0c             	mov    0xc(%rax),%edx
  802ad6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802add:	00 00 00 
  802ae0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ae2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ae9:	00 00 00 
  802aec:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802af0:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802af4:	be 00 00 00 00       	mov    $0x0,%esi
  802af9:	bf 03 00 00 00       	mov    $0x3,%edi
  802afe:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802b05:	00 00 00 
  802b08:	ff d0                	callq  *%rax
  802b0a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b0d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b11:	79 05                	jns    802b18 <devfile_read+0x5d>
		return r;
  802b13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b16:	eb 26                	jmp    802b3e <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802b18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b1b:	48 63 d0             	movslq %eax,%rdx
  802b1e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b22:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b29:	00 00 00 
  802b2c:	48 89 c7             	mov    %rax,%rdi
  802b2f:	48 b8 10 13 80 00 00 	movabs $0x801310,%rax
  802b36:	00 00 00 
  802b39:	ff d0                	callq  *%rax
	return r;
  802b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802b3e:	c9                   	leaveq 
  802b3f:	c3                   	retq   

0000000000802b40 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b40:	55                   	push   %rbp
  802b41:	48 89 e5             	mov    %rsp,%rbp
  802b44:	48 83 ec 30          	sub    $0x30,%rsp
  802b48:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b4c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b50:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802b54:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802b5b:	00 
	n = n > max ? max : n;
  802b5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b60:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802b64:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802b69:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802b6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b71:	8b 50 0c             	mov    0xc(%rax),%edx
  802b74:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b7b:	00 00 00 
  802b7e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802b80:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b87:	00 00 00 
  802b8a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b8e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802b92:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b9a:	48 89 c6             	mov    %rax,%rsi
  802b9d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ba4:	00 00 00 
  802ba7:	48 b8 10 13 80 00 00 	movabs $0x801310,%rax
  802bae:	00 00 00 
  802bb1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802bb3:	be 00 00 00 00       	mov    $0x0,%esi
  802bb8:	bf 04 00 00 00       	mov    $0x4,%edi
  802bbd:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802bc4:	00 00 00 
  802bc7:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802bc9:	c9                   	leaveq 
  802bca:	c3                   	retq   

0000000000802bcb <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802bcb:	55                   	push   %rbp
  802bcc:	48 89 e5             	mov    %rsp,%rbp
  802bcf:	48 83 ec 20          	sub    $0x20,%rsp
  802bd3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bd7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdf:	8b 50 0c             	mov    0xc(%rax),%edx
  802be2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802be9:	00 00 00 
  802bec:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802bee:	be 00 00 00 00       	mov    $0x0,%esi
  802bf3:	bf 05 00 00 00       	mov    $0x5,%edi
  802bf8:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802bff:	00 00 00 
  802c02:	ff d0                	callq  *%rax
  802c04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c0b:	79 05                	jns    802c12 <devfile_stat+0x47>
		return r;
  802c0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c10:	eb 56                	jmp    802c68 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802c12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c16:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c1d:	00 00 00 
  802c20:	48 89 c7             	mov    %rax,%rdi
  802c23:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  802c2a:	00 00 00 
  802c2d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c2f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c36:	00 00 00 
  802c39:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c3f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c43:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c49:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c50:	00 00 00 
  802c53:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c59:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c5d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c68:	c9                   	leaveq 
  802c69:	c3                   	retq   

0000000000802c6a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c6a:	55                   	push   %rbp
  802c6b:	48 89 e5             	mov    %rsp,%rbp
  802c6e:	48 83 ec 10          	sub    $0x10,%rsp
  802c72:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c76:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c7d:	8b 50 0c             	mov    0xc(%rax),%edx
  802c80:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c87:	00 00 00 
  802c8a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802c8c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c93:	00 00 00 
  802c96:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802c99:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802c9c:	be 00 00 00 00       	mov    $0x0,%esi
  802ca1:	bf 02 00 00 00       	mov    $0x2,%edi
  802ca6:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802cad:	00 00 00 
  802cb0:	ff d0                	callq  *%rax
}
  802cb2:	c9                   	leaveq 
  802cb3:	c3                   	retq   

0000000000802cb4 <remove>:

// Delete a file
int
remove(const char *path)
{
  802cb4:	55                   	push   %rbp
  802cb5:	48 89 e5             	mov    %rsp,%rbp
  802cb8:	48 83 ec 10          	sub    $0x10,%rsp
  802cbc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802cc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cc4:	48 89 c7             	mov    %rax,%rdi
  802cc7:	48 b8 69 0e 80 00 00 	movabs $0x800e69,%rax
  802cce:	00 00 00 
  802cd1:	ff d0                	callq  *%rax
  802cd3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cd8:	7e 07                	jle    802ce1 <remove+0x2d>
		return -E_BAD_PATH;
  802cda:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802cdf:	eb 33                	jmp    802d14 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ce1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce5:	48 89 c6             	mov    %rax,%rsi
  802ce8:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802cef:	00 00 00 
  802cf2:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  802cf9:	00 00 00 
  802cfc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802cfe:	be 00 00 00 00       	mov    $0x0,%esi
  802d03:	bf 07 00 00 00       	mov    $0x7,%edi
  802d08:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802d0f:	00 00 00 
  802d12:	ff d0                	callq  *%rax
}
  802d14:	c9                   	leaveq 
  802d15:	c3                   	retq   

0000000000802d16 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802d16:	55                   	push   %rbp
  802d17:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d1a:	be 00 00 00 00       	mov    $0x0,%esi
  802d1f:	bf 08 00 00 00       	mov    $0x8,%edi
  802d24:	48 b8 23 29 80 00 00 	movabs $0x802923,%rax
  802d2b:	00 00 00 
  802d2e:	ff d0                	callq  *%rax
}
  802d30:	5d                   	pop    %rbp
  802d31:	c3                   	retq   

0000000000802d32 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802d32:	55                   	push   %rbp
  802d33:	48 89 e5             	mov    %rsp,%rbp
  802d36:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d3d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d44:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d4b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d52:	be 00 00 00 00       	mov    $0x0,%esi
  802d57:	48 89 c7             	mov    %rax,%rdi
  802d5a:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802d61:	00 00 00 
  802d64:	ff d0                	callq  *%rax
  802d66:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802d69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d6d:	79 28                	jns    802d97 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802d6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d72:	89 c6                	mov    %eax,%esi
  802d74:	48 bf ce 42 80 00 00 	movabs $0x8042ce,%rdi
  802d7b:	00 00 00 
  802d7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d83:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  802d8a:	00 00 00 
  802d8d:	ff d2                	callq  *%rdx
		return fd_src;
  802d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d92:	e9 74 01 00 00       	jmpq   802f0b <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802d97:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802d9e:	be 01 01 00 00       	mov    $0x101,%esi
  802da3:	48 89 c7             	mov    %rax,%rdi
  802da6:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802dad:	00 00 00 
  802db0:	ff d0                	callq  *%rax
  802db2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802db5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802db9:	79 39                	jns    802df4 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802dbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dbe:	89 c6                	mov    %eax,%esi
  802dc0:	48 bf e4 42 80 00 00 	movabs $0x8042e4,%rdi
  802dc7:	00 00 00 
  802dca:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcf:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  802dd6:	00 00 00 
  802dd9:	ff d2                	callq  *%rdx
		close(fd_src);
  802ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dde:	89 c7                	mov    %eax,%edi
  802de0:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  802de7:	00 00 00 
  802dea:	ff d0                	callq  *%rax
		return fd_dest;
  802dec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802def:	e9 17 01 00 00       	jmpq   802f0b <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802df4:	eb 74                	jmp    802e6a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802df6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802df9:	48 63 d0             	movslq %eax,%rdx
  802dfc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e06:	48 89 ce             	mov    %rcx,%rsi
  802e09:	89 c7                	mov    %eax,%edi
  802e0b:	48 b8 1e 26 80 00 00 	movabs $0x80261e,%rax
  802e12:	00 00 00 
  802e15:	ff d0                	callq  *%rax
  802e17:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802e1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802e1e:	79 4a                	jns    802e6a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802e20:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e23:	89 c6                	mov    %eax,%esi
  802e25:	48 bf fe 42 80 00 00 	movabs $0x8042fe,%rdi
  802e2c:	00 00 00 
  802e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e34:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  802e3b:	00 00 00 
  802e3e:	ff d2                	callq  *%rdx
			close(fd_src);
  802e40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e43:	89 c7                	mov    %eax,%edi
  802e45:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  802e4c:	00 00 00 
  802e4f:	ff d0                	callq  *%rax
			close(fd_dest);
  802e51:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e54:	89 c7                	mov    %eax,%edi
  802e56:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  802e5d:	00 00 00 
  802e60:	ff d0                	callq  *%rax
			return write_size;
  802e62:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e65:	e9 a1 00 00 00       	jmpq   802f0b <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e6a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e74:	ba 00 02 00 00       	mov    $0x200,%edx
  802e79:	48 89 ce             	mov    %rcx,%rsi
  802e7c:	89 c7                	mov    %eax,%edi
  802e7e:	48 b8 d4 24 80 00 00 	movabs $0x8024d4,%rax
  802e85:	00 00 00 
  802e88:	ff d0                	callq  *%rax
  802e8a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e91:	0f 8f 5f ff ff ff    	jg     802df6 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802e97:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802e9b:	79 47                	jns    802ee4 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802e9d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ea0:	89 c6                	mov    %eax,%esi
  802ea2:	48 bf 11 43 80 00 00 	movabs $0x804311,%rdi
  802ea9:	00 00 00 
  802eac:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb1:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  802eb8:	00 00 00 
  802ebb:	ff d2                	callq  *%rdx
		close(fd_src);
  802ebd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec0:	89 c7                	mov    %eax,%edi
  802ec2:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  802ec9:	00 00 00 
  802ecc:	ff d0                	callq  *%rax
		close(fd_dest);
  802ece:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ed1:	89 c7                	mov    %eax,%edi
  802ed3:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  802eda:	00 00 00 
  802edd:	ff d0                	callq  *%rax
		return read_size;
  802edf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ee2:	eb 27                	jmp    802f0b <copy+0x1d9>
	}
	close(fd_src);
  802ee4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee7:	89 c7                	mov    %eax,%edi
  802ee9:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  802ef0:	00 00 00 
  802ef3:	ff d0                	callq  *%rax
	close(fd_dest);
  802ef5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ef8:	89 c7                	mov    %eax,%edi
  802efa:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  802f01:	00 00 00 
  802f04:	ff d0                	callq  *%rax
	return 0;
  802f06:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802f0b:	c9                   	leaveq 
  802f0c:	c3                   	retq   

0000000000802f0d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802f0d:	55                   	push   %rbp
  802f0e:	48 89 e5             	mov    %rsp,%rbp
  802f11:	53                   	push   %rbx
  802f12:	48 83 ec 38          	sub    $0x38,%rsp
  802f16:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f1a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802f1e:	48 89 c7             	mov    %rax,%rdi
  802f21:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  802f28:	00 00 00 
  802f2b:	ff d0                	callq  *%rax
  802f2d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f30:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f34:	0f 88 bf 01 00 00    	js     8030f9 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f3e:	ba 07 04 00 00       	mov    $0x407,%edx
  802f43:	48 89 c6             	mov    %rax,%rsi
  802f46:	bf 00 00 00 00       	mov    $0x0,%edi
  802f4b:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
  802f57:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f5e:	0f 88 95 01 00 00    	js     8030f9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802f64:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802f68:	48 89 c7             	mov    %rax,%rdi
  802f6b:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  802f72:	00 00 00 
  802f75:	ff d0                	callq  *%rax
  802f77:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f7e:	0f 88 5d 01 00 00    	js     8030e1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f88:	ba 07 04 00 00       	mov    $0x407,%edx
  802f8d:	48 89 c6             	mov    %rax,%rsi
  802f90:	bf 00 00 00 00       	mov    $0x0,%edi
  802f95:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  802f9c:	00 00 00 
  802f9f:	ff d0                	callq  *%rax
  802fa1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fa4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fa8:	0f 88 33 01 00 00    	js     8030e1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802fae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fb2:	48 89 c7             	mov    %rax,%rdi
  802fb5:	48 b8 df 1f 80 00 00 	movabs $0x801fdf,%rax
  802fbc:	00 00 00 
  802fbf:	ff d0                	callq  *%rax
  802fc1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc9:	ba 07 04 00 00       	mov    $0x407,%edx
  802fce:	48 89 c6             	mov    %rax,%rsi
  802fd1:	bf 00 00 00 00       	mov    $0x0,%edi
  802fd6:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  802fdd:	00 00 00 
  802fe0:	ff d0                	callq  *%rax
  802fe2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fe5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fe9:	79 05                	jns    802ff0 <pipe+0xe3>
		goto err2;
  802feb:	e9 d9 00 00 00       	jmpq   8030c9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ff0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ff4:	48 89 c7             	mov    %rax,%rdi
  802ff7:	48 b8 df 1f 80 00 00 	movabs $0x801fdf,%rax
  802ffe:	00 00 00 
  803001:	ff d0                	callq  *%rax
  803003:	48 89 c2             	mov    %rax,%rdx
  803006:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80300a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803010:	48 89 d1             	mov    %rdx,%rcx
  803013:	ba 00 00 00 00       	mov    $0x0,%edx
  803018:	48 89 c6             	mov    %rax,%rsi
  80301b:	bf 00 00 00 00       	mov    $0x0,%edi
  803020:	48 b8 54 18 80 00 00 	movabs $0x801854,%rax
  803027:	00 00 00 
  80302a:	ff d0                	callq  *%rax
  80302c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80302f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803033:	79 1b                	jns    803050 <pipe+0x143>
		goto err3;
  803035:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803036:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80303a:	48 89 c6             	mov    %rax,%rsi
  80303d:	bf 00 00 00 00       	mov    $0x0,%edi
  803042:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  803049:	00 00 00 
  80304c:	ff d0                	callq  *%rax
  80304e:	eb 79                	jmp    8030c9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803050:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803054:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  80305b:	00 00 00 
  80305e:	8b 12                	mov    (%rdx),%edx
  803060:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803062:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803066:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80306d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803071:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803078:	00 00 00 
  80307b:	8b 12                	mov    (%rdx),%edx
  80307d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80307f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803083:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80308a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80308e:	48 89 c7             	mov    %rax,%rdi
  803091:	48 b8 bc 1f 80 00 00 	movabs $0x801fbc,%rax
  803098:	00 00 00 
  80309b:	ff d0                	callq  *%rax
  80309d:	89 c2                	mov    %eax,%edx
  80309f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030a3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8030a5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030a9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8030ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030b1:	48 89 c7             	mov    %rax,%rdi
  8030b4:	48 b8 bc 1f 80 00 00 	movabs $0x801fbc,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
  8030c0:	89 03                	mov    %eax,(%rbx)
	return 0;
  8030c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c7:	eb 33                	jmp    8030fc <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8030c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030cd:	48 89 c6             	mov    %rax,%rsi
  8030d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8030d5:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  8030dc:	00 00 00 
  8030df:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8030e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030e5:	48 89 c6             	mov    %rax,%rsi
  8030e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8030ed:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  8030f4:	00 00 00 
  8030f7:	ff d0                	callq  *%rax
err:
	return r;
  8030f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8030fc:	48 83 c4 38          	add    $0x38,%rsp
  803100:	5b                   	pop    %rbx
  803101:	5d                   	pop    %rbp
  803102:	c3                   	retq   

0000000000803103 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803103:	55                   	push   %rbp
  803104:	48 89 e5             	mov    %rsp,%rbp
  803107:	53                   	push   %rbx
  803108:	48 83 ec 28          	sub    $0x28,%rsp
  80310c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803110:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803114:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80311b:	00 00 00 
  80311e:	48 8b 00             	mov    (%rax),%rax
  803121:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803127:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80312a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80312e:	48 89 c7             	mov    %rax,%rdi
  803131:	48 b8 a1 3b 80 00 00 	movabs $0x803ba1,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
  80313d:	89 c3                	mov    %eax,%ebx
  80313f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803143:	48 89 c7             	mov    %rax,%rdi
  803146:	48 b8 a1 3b 80 00 00 	movabs $0x803ba1,%rax
  80314d:	00 00 00 
  803150:	ff d0                	callq  *%rax
  803152:	39 c3                	cmp    %eax,%ebx
  803154:	0f 94 c0             	sete   %al
  803157:	0f b6 c0             	movzbl %al,%eax
  80315a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80315d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803164:	00 00 00 
  803167:	48 8b 00             	mov    (%rax),%rax
  80316a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803170:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803173:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803176:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803179:	75 05                	jne    803180 <_pipeisclosed+0x7d>
			return ret;
  80317b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80317e:	eb 4f                	jmp    8031cf <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803180:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803183:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803186:	74 42                	je     8031ca <_pipeisclosed+0xc7>
  803188:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80318c:	75 3c                	jne    8031ca <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80318e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803195:	00 00 00 
  803198:	48 8b 00             	mov    (%rax),%rax
  80319b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8031a1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8031a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031a7:	89 c6                	mov    %eax,%esi
  8031a9:	48 bf 2c 43 80 00 00 	movabs $0x80432c,%rdi
  8031b0:	00 00 00 
  8031b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b8:	49 b8 20 03 80 00 00 	movabs $0x800320,%r8
  8031bf:	00 00 00 
  8031c2:	41 ff d0             	callq  *%r8
	}
  8031c5:	e9 4a ff ff ff       	jmpq   803114 <_pipeisclosed+0x11>
  8031ca:	e9 45 ff ff ff       	jmpq   803114 <_pipeisclosed+0x11>
}
  8031cf:	48 83 c4 28          	add    $0x28,%rsp
  8031d3:	5b                   	pop    %rbx
  8031d4:	5d                   	pop    %rbp
  8031d5:	c3                   	retq   

00000000008031d6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8031d6:	55                   	push   %rbp
  8031d7:	48 89 e5             	mov    %rsp,%rbp
  8031da:	48 83 ec 30          	sub    $0x30,%rsp
  8031de:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031e1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031e5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031e8:	48 89 d6             	mov    %rdx,%rsi
  8031eb:	89 c7                	mov    %eax,%edi
  8031ed:	48 b8 a2 20 80 00 00 	movabs $0x8020a2,%rax
  8031f4:	00 00 00 
  8031f7:	ff d0                	callq  *%rax
  8031f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803200:	79 05                	jns    803207 <pipeisclosed+0x31>
		return r;
  803202:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803205:	eb 31                	jmp    803238 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803207:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80320b:	48 89 c7             	mov    %rax,%rdi
  80320e:	48 b8 df 1f 80 00 00 	movabs $0x801fdf,%rax
  803215:	00 00 00 
  803218:	ff d0                	callq  *%rax
  80321a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80321e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803222:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803226:	48 89 d6             	mov    %rdx,%rsi
  803229:	48 89 c7             	mov    %rax,%rdi
  80322c:	48 b8 03 31 80 00 00 	movabs $0x803103,%rax
  803233:	00 00 00 
  803236:	ff d0                	callq  *%rax
}
  803238:	c9                   	leaveq 
  803239:	c3                   	retq   

000000000080323a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80323a:	55                   	push   %rbp
  80323b:	48 89 e5             	mov    %rsp,%rbp
  80323e:	48 83 ec 40          	sub    $0x40,%rsp
  803242:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803246:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80324a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80324e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803252:	48 89 c7             	mov    %rax,%rdi
  803255:	48 b8 df 1f 80 00 00 	movabs $0x801fdf,%rax
  80325c:	00 00 00 
  80325f:	ff d0                	callq  *%rax
  803261:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803265:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803269:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80326d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803274:	00 
  803275:	e9 92 00 00 00       	jmpq   80330c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80327a:	eb 41                	jmp    8032bd <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80327c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803281:	74 09                	je     80328c <devpipe_read+0x52>
				return i;
  803283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803287:	e9 92 00 00 00       	jmpq   80331e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80328c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803290:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803294:	48 89 d6             	mov    %rdx,%rsi
  803297:	48 89 c7             	mov    %rax,%rdi
  80329a:	48 b8 03 31 80 00 00 	movabs $0x803103,%rax
  8032a1:	00 00 00 
  8032a4:	ff d0                	callq  *%rax
  8032a6:	85 c0                	test   %eax,%eax
  8032a8:	74 07                	je     8032b1 <devpipe_read+0x77>
				return 0;
  8032aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8032af:	eb 6d                	jmp    80331e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8032b1:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  8032b8:	00 00 00 
  8032bb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8032bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c1:	8b 10                	mov    (%rax),%edx
  8032c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c7:	8b 40 04             	mov    0x4(%rax),%eax
  8032ca:	39 c2                	cmp    %eax,%edx
  8032cc:	74 ae                	je     80327c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8032ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032d6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8032da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032de:	8b 00                	mov    (%rax),%eax
  8032e0:	99                   	cltd   
  8032e1:	c1 ea 1b             	shr    $0x1b,%edx
  8032e4:	01 d0                	add    %edx,%eax
  8032e6:	83 e0 1f             	and    $0x1f,%eax
  8032e9:	29 d0                	sub    %edx,%eax
  8032eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032ef:	48 98                	cltq   
  8032f1:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8032f6:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8032f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032fc:	8b 00                	mov    (%rax),%eax
  8032fe:	8d 50 01             	lea    0x1(%rax),%edx
  803301:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803305:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803307:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80330c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803310:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803314:	0f 82 60 ff ff ff    	jb     80327a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80331a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80331e:	c9                   	leaveq 
  80331f:	c3                   	retq   

0000000000803320 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803320:	55                   	push   %rbp
  803321:	48 89 e5             	mov    %rsp,%rbp
  803324:	48 83 ec 40          	sub    $0x40,%rsp
  803328:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80332c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803330:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803334:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803338:	48 89 c7             	mov    %rax,%rdi
  80333b:	48 b8 df 1f 80 00 00 	movabs $0x801fdf,%rax
  803342:	00 00 00 
  803345:	ff d0                	callq  *%rax
  803347:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80334b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80334f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803353:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80335a:	00 
  80335b:	e9 8e 00 00 00       	jmpq   8033ee <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803360:	eb 31                	jmp    803393 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803362:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80336a:	48 89 d6             	mov    %rdx,%rsi
  80336d:	48 89 c7             	mov    %rax,%rdi
  803370:	48 b8 03 31 80 00 00 	movabs $0x803103,%rax
  803377:	00 00 00 
  80337a:	ff d0                	callq  *%rax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	74 07                	je     803387 <devpipe_write+0x67>
				return 0;
  803380:	b8 00 00 00 00       	mov    $0x0,%eax
  803385:	eb 79                	jmp    803400 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803387:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  80338e:	00 00 00 
  803391:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803393:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803397:	8b 40 04             	mov    0x4(%rax),%eax
  80339a:	48 63 d0             	movslq %eax,%rdx
  80339d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033a1:	8b 00                	mov    (%rax),%eax
  8033a3:	48 98                	cltq   
  8033a5:	48 83 c0 20          	add    $0x20,%rax
  8033a9:	48 39 c2             	cmp    %rax,%rdx
  8033ac:	73 b4                	jae    803362 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8033ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b2:	8b 40 04             	mov    0x4(%rax),%eax
  8033b5:	99                   	cltd   
  8033b6:	c1 ea 1b             	shr    $0x1b,%edx
  8033b9:	01 d0                	add    %edx,%eax
  8033bb:	83 e0 1f             	and    $0x1f,%eax
  8033be:	29 d0                	sub    %edx,%eax
  8033c0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033c4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8033c8:	48 01 ca             	add    %rcx,%rdx
  8033cb:	0f b6 0a             	movzbl (%rdx),%ecx
  8033ce:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033d2:	48 98                	cltq   
  8033d4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8033d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033dc:	8b 40 04             	mov    0x4(%rax),%eax
  8033df:	8d 50 01             	lea    0x1(%rax),%edx
  8033e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033e6:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8033e9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033f2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8033f6:	0f 82 64 ff ff ff    	jb     803360 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8033fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803400:	c9                   	leaveq 
  803401:	c3                   	retq   

0000000000803402 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803402:	55                   	push   %rbp
  803403:	48 89 e5             	mov    %rsp,%rbp
  803406:	48 83 ec 20          	sub    $0x20,%rsp
  80340a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80340e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803412:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803416:	48 89 c7             	mov    %rax,%rdi
  803419:	48 b8 df 1f 80 00 00 	movabs $0x801fdf,%rax
  803420:	00 00 00 
  803423:	ff d0                	callq  *%rax
  803425:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803429:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80342d:	48 be 3f 43 80 00 00 	movabs $0x80433f,%rsi
  803434:	00 00 00 
  803437:	48 89 c7             	mov    %rax,%rdi
  80343a:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  803441:	00 00 00 
  803444:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803446:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80344a:	8b 50 04             	mov    0x4(%rax),%edx
  80344d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803451:	8b 00                	mov    (%rax),%eax
  803453:	29 c2                	sub    %eax,%edx
  803455:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803459:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80345f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803463:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80346a:	00 00 00 
	stat->st_dev = &devpipe;
  80346d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803471:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803478:	00 00 00 
  80347b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803487:	c9                   	leaveq 
  803488:	c3                   	retq   

0000000000803489 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803489:	55                   	push   %rbp
  80348a:	48 89 e5             	mov    %rsp,%rbp
  80348d:	48 83 ec 10          	sub    $0x10,%rsp
  803491:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803499:	48 89 c6             	mov    %rax,%rsi
  80349c:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a1:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  8034a8:	00 00 00 
  8034ab:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8034ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b1:	48 89 c7             	mov    %rax,%rdi
  8034b4:	48 b8 df 1f 80 00 00 	movabs $0x801fdf,%rax
  8034bb:	00 00 00 
  8034be:	ff d0                	callq  *%rax
  8034c0:	48 89 c6             	mov    %rax,%rsi
  8034c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8034c8:	48 b8 af 18 80 00 00 	movabs $0x8018af,%rax
  8034cf:	00 00 00 
  8034d2:	ff d0                	callq  *%rax
}
  8034d4:	c9                   	leaveq 
  8034d5:	c3                   	retq   

00000000008034d6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8034d6:	55                   	push   %rbp
  8034d7:	48 89 e5             	mov    %rsp,%rbp
  8034da:	48 83 ec 20          	sub    $0x20,%rsp
  8034de:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8034e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034e4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8034e7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8034eb:	be 01 00 00 00       	mov    $0x1,%esi
  8034f0:	48 89 c7             	mov    %rax,%rdi
  8034f3:	48 b8 bc 16 80 00 00 	movabs $0x8016bc,%rax
  8034fa:	00 00 00 
  8034fd:	ff d0                	callq  *%rax
}
  8034ff:	c9                   	leaveq 
  803500:	c3                   	retq   

0000000000803501 <getchar>:

int
getchar(void)
{
  803501:	55                   	push   %rbp
  803502:	48 89 e5             	mov    %rsp,%rbp
  803505:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803509:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80350d:	ba 01 00 00 00       	mov    $0x1,%edx
  803512:	48 89 c6             	mov    %rax,%rsi
  803515:	bf 00 00 00 00       	mov    $0x0,%edi
  80351a:	48 b8 d4 24 80 00 00 	movabs $0x8024d4,%rax
  803521:	00 00 00 
  803524:	ff d0                	callq  *%rax
  803526:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803529:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80352d:	79 05                	jns    803534 <getchar+0x33>
		return r;
  80352f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803532:	eb 14                	jmp    803548 <getchar+0x47>
	if (r < 1)
  803534:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803538:	7f 07                	jg     803541 <getchar+0x40>
		return -E_EOF;
  80353a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80353f:	eb 07                	jmp    803548 <getchar+0x47>
	return c;
  803541:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803545:	0f b6 c0             	movzbl %al,%eax
}
  803548:	c9                   	leaveq 
  803549:	c3                   	retq   

000000000080354a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80354a:	55                   	push   %rbp
  80354b:	48 89 e5             	mov    %rsp,%rbp
  80354e:	48 83 ec 20          	sub    $0x20,%rsp
  803552:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803555:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803559:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80355c:	48 89 d6             	mov    %rdx,%rsi
  80355f:	89 c7                	mov    %eax,%edi
  803561:	48 b8 a2 20 80 00 00 	movabs $0x8020a2,%rax
  803568:	00 00 00 
  80356b:	ff d0                	callq  *%rax
  80356d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803570:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803574:	79 05                	jns    80357b <iscons+0x31>
		return r;
  803576:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803579:	eb 1a                	jmp    803595 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80357b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357f:	8b 10                	mov    (%rax),%edx
  803581:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803588:	00 00 00 
  80358b:	8b 00                	mov    (%rax),%eax
  80358d:	39 c2                	cmp    %eax,%edx
  80358f:	0f 94 c0             	sete   %al
  803592:	0f b6 c0             	movzbl %al,%eax
}
  803595:	c9                   	leaveq 
  803596:	c3                   	retq   

0000000000803597 <opencons>:

int
opencons(void)
{
  803597:	55                   	push   %rbp
  803598:	48 89 e5             	mov    %rsp,%rbp
  80359b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80359f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8035a3:	48 89 c7             	mov    %rax,%rdi
  8035a6:	48 b8 0a 20 80 00 00 	movabs $0x80200a,%rax
  8035ad:	00 00 00 
  8035b0:	ff d0                	callq  *%rax
  8035b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b9:	79 05                	jns    8035c0 <opencons+0x29>
		return r;
  8035bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035be:	eb 5b                	jmp    80361b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8035c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c4:	ba 07 04 00 00       	mov    $0x407,%edx
  8035c9:	48 89 c6             	mov    %rax,%rsi
  8035cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8035d1:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  8035d8:	00 00 00 
  8035db:	ff d0                	callq  *%rax
  8035dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035e4:	79 05                	jns    8035eb <opencons+0x54>
		return r;
  8035e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e9:	eb 30                	jmp    80361b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8035eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ef:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  8035f6:	00 00 00 
  8035f9:	8b 12                	mov    (%rdx),%edx
  8035fb:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8035fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803601:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360c:	48 89 c7             	mov    %rax,%rdi
  80360f:	48 b8 bc 1f 80 00 00 	movabs $0x801fbc,%rax
  803616:	00 00 00 
  803619:	ff d0                	callq  *%rax
}
  80361b:	c9                   	leaveq 
  80361c:	c3                   	retq   

000000000080361d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80361d:	55                   	push   %rbp
  80361e:	48 89 e5             	mov    %rsp,%rbp
  803621:	48 83 ec 30          	sub    $0x30,%rsp
  803625:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803629:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80362d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803631:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803636:	75 07                	jne    80363f <devcons_read+0x22>
		return 0;
  803638:	b8 00 00 00 00       	mov    $0x0,%eax
  80363d:	eb 4b                	jmp    80368a <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80363f:	eb 0c                	jmp    80364d <devcons_read+0x30>
		sys_yield();
  803641:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  803648:	00 00 00 
  80364b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80364d:	48 b8 06 17 80 00 00 	movabs $0x801706,%rax
  803654:	00 00 00 
  803657:	ff d0                	callq  *%rax
  803659:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80365c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803660:	74 df                	je     803641 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803662:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803666:	79 05                	jns    80366d <devcons_read+0x50>
		return c;
  803668:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366b:	eb 1d                	jmp    80368a <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80366d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803671:	75 07                	jne    80367a <devcons_read+0x5d>
		return 0;
  803673:	b8 00 00 00 00       	mov    $0x0,%eax
  803678:	eb 10                	jmp    80368a <devcons_read+0x6d>
	*(char*)vbuf = c;
  80367a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80367d:	89 c2                	mov    %eax,%edx
  80367f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803683:	88 10                	mov    %dl,(%rax)
	return 1;
  803685:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80368a:	c9                   	leaveq 
  80368b:	c3                   	retq   

000000000080368c <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80368c:	55                   	push   %rbp
  80368d:	48 89 e5             	mov    %rsp,%rbp
  803690:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803697:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80369e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8036a5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8036ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036b3:	eb 76                	jmp    80372b <devcons_write+0x9f>
		m = n - tot;
  8036b5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8036bc:	89 c2                	mov    %eax,%edx
  8036be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c1:	29 c2                	sub    %eax,%edx
  8036c3:	89 d0                	mov    %edx,%eax
  8036c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8036c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036cb:	83 f8 7f             	cmp    $0x7f,%eax
  8036ce:	76 07                	jbe    8036d7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8036d0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8036d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036da:	48 63 d0             	movslq %eax,%rdx
  8036dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e0:	48 63 c8             	movslq %eax,%rcx
  8036e3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8036ea:	48 01 c1             	add    %rax,%rcx
  8036ed:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8036f4:	48 89 ce             	mov    %rcx,%rsi
  8036f7:	48 89 c7             	mov    %rax,%rdi
  8036fa:	48 b8 f9 11 80 00 00 	movabs $0x8011f9,%rax
  803701:	00 00 00 
  803704:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803706:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803709:	48 63 d0             	movslq %eax,%rdx
  80370c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803713:	48 89 d6             	mov    %rdx,%rsi
  803716:	48 89 c7             	mov    %rax,%rdi
  803719:	48 b8 bc 16 80 00 00 	movabs $0x8016bc,%rax
  803720:	00 00 00 
  803723:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803725:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803728:	01 45 fc             	add    %eax,-0x4(%rbp)
  80372b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80372e:	48 98                	cltq   
  803730:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803737:	0f 82 78 ff ff ff    	jb     8036b5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80373d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803740:	c9                   	leaveq 
  803741:	c3                   	retq   

0000000000803742 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803742:	55                   	push   %rbp
  803743:	48 89 e5             	mov    %rsp,%rbp
  803746:	48 83 ec 08          	sub    $0x8,%rsp
  80374a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80374e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803753:	c9                   	leaveq 
  803754:	c3                   	retq   

0000000000803755 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803755:	55                   	push   %rbp
  803756:	48 89 e5             	mov    %rsp,%rbp
  803759:	48 83 ec 10          	sub    $0x10,%rsp
  80375d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803761:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803765:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803769:	48 be 4b 43 80 00 00 	movabs $0x80434b,%rsi
  803770:	00 00 00 
  803773:	48 89 c7             	mov    %rax,%rdi
  803776:	48 b8 d5 0e 80 00 00 	movabs $0x800ed5,%rax
  80377d:	00 00 00 
  803780:	ff d0                	callq  *%rax
	return 0;
  803782:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803787:	c9                   	leaveq 
  803788:	c3                   	retq   

0000000000803789 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803789:	55                   	push   %rbp
  80378a:	48 89 e5             	mov    %rsp,%rbp
  80378d:	53                   	push   %rbx
  80378e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803795:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80379c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8037a2:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8037a9:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8037b0:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8037b7:	84 c0                	test   %al,%al
  8037b9:	74 23                	je     8037de <_panic+0x55>
  8037bb:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8037c2:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8037c6:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8037ca:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8037ce:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8037d2:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8037d6:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8037da:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8037de:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8037e5:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8037ec:	00 00 00 
  8037ef:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8037f6:	00 00 00 
  8037f9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8037fd:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803804:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80380b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803812:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803819:	00 00 00 
  80381c:	48 8b 18             	mov    (%rax),%rbx
  80381f:	48 b8 88 17 80 00 00 	movabs $0x801788,%rax
  803826:	00 00 00 
  803829:	ff d0                	callq  *%rax
  80382b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803831:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803838:	41 89 c8             	mov    %ecx,%r8d
  80383b:	48 89 d1             	mov    %rdx,%rcx
  80383e:	48 89 da             	mov    %rbx,%rdx
  803841:	89 c6                	mov    %eax,%esi
  803843:	48 bf 58 43 80 00 00 	movabs $0x804358,%rdi
  80384a:	00 00 00 
  80384d:	b8 00 00 00 00       	mov    $0x0,%eax
  803852:	49 b9 20 03 80 00 00 	movabs $0x800320,%r9
  803859:	00 00 00 
  80385c:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80385f:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803866:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80386d:	48 89 d6             	mov    %rdx,%rsi
  803870:	48 89 c7             	mov    %rax,%rdi
  803873:	48 b8 74 02 80 00 00 	movabs $0x800274,%rax
  80387a:	00 00 00 
  80387d:	ff d0                	callq  *%rax
	cprintf("\n");
  80387f:	48 bf 7b 43 80 00 00 	movabs $0x80437b,%rdi
  803886:	00 00 00 
  803889:	b8 00 00 00 00       	mov    $0x0,%eax
  80388e:	48 ba 20 03 80 00 00 	movabs $0x800320,%rdx
  803895:	00 00 00 
  803898:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80389a:	cc                   	int3   
  80389b:	eb fd                	jmp    80389a <_panic+0x111>

000000000080389d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80389d:	55                   	push   %rbp
  80389e:	48 89 e5             	mov    %rsp,%rbp
  8038a1:	48 83 ec 10          	sub    $0x10,%rsp
  8038a5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8038a9:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8038b0:	00 00 00 
  8038b3:	48 8b 00             	mov    (%rax),%rax
  8038b6:	48 85 c0             	test   %rax,%rax
  8038b9:	75 64                	jne    80391f <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  8038bb:	ba 07 00 00 00       	mov    $0x7,%edx
  8038c0:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8038c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8038ca:	48 b8 04 18 80 00 00 	movabs $0x801804,%rax
  8038d1:	00 00 00 
  8038d4:	ff d0                	callq  *%rax
  8038d6:	85 c0                	test   %eax,%eax
  8038d8:	74 2a                	je     803904 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  8038da:	48 ba 80 43 80 00 00 	movabs $0x804380,%rdx
  8038e1:	00 00 00 
  8038e4:	be 22 00 00 00       	mov    $0x22,%esi
  8038e9:	48 bf a8 43 80 00 00 	movabs $0x8043a8,%rdi
  8038f0:	00 00 00 
  8038f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038f8:	48 b9 89 37 80 00 00 	movabs $0x803789,%rcx
  8038ff:	00 00 00 
  803902:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803904:	48 be 32 39 80 00 00 	movabs $0x803932,%rsi
  80390b:	00 00 00 
  80390e:	bf 00 00 00 00       	mov    $0x0,%edi
  803913:	48 b8 8e 19 80 00 00 	movabs $0x80198e,%rax
  80391a:	00 00 00 
  80391d:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80391f:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803926:	00 00 00 
  803929:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80392d:	48 89 10             	mov    %rdx,(%rax)
}
  803930:	c9                   	leaveq 
  803931:	c3                   	retq   

0000000000803932 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  803932:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803935:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  80393c:	00 00 00 
call *%rax
  80393f:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  803941:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  803948:	00 
mov 136(%rsp), %r9
  803949:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  803950:	00 
sub $8, %r8
  803951:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  803955:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  803958:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  80395f:	00 
add $16, %rsp
  803960:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  803964:	4c 8b 3c 24          	mov    (%rsp),%r15
  803968:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80396d:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803972:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803977:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80397c:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803981:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803986:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80398b:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803990:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803995:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80399a:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80399f:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8039a4:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8039a9:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8039ae:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  8039b2:	48 83 c4 08          	add    $0x8,%rsp
popf
  8039b6:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  8039b7:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  8039bb:	c3                   	retq   

00000000008039bc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8039bc:	55                   	push   %rbp
  8039bd:	48 89 e5             	mov    %rsp,%rbp
  8039c0:	48 83 ec 30          	sub    $0x30,%rsp
  8039c4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039cc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  8039d0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8039d5:	74 18                	je     8039ef <ipc_recv+0x33>
  8039d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039db:	48 89 c7             	mov    %rax,%rdi
  8039de:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  8039e5:	00 00 00 
  8039e8:	ff d0                	callq  *%rax
  8039ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039ed:	eb 19                	jmp    803a08 <ipc_recv+0x4c>
  8039ef:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8039f6:	00 00 00 
  8039f9:	48 b8 2d 1a 80 00 00 	movabs $0x801a2d,%rax
  803a00:	00 00 00 
  803a03:	ff d0                	callq  *%rax
  803a05:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803a08:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a0d:	74 26                	je     803a35 <ipc_recv+0x79>
  803a0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a13:	75 15                	jne    803a2a <ipc_recv+0x6e>
  803a15:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a1c:	00 00 00 
  803a1f:	48 8b 00             	mov    (%rax),%rax
  803a22:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803a28:	eb 05                	jmp    803a2f <ipc_recv+0x73>
  803a2a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a33:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803a35:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a3a:	74 26                	je     803a62 <ipc_recv+0xa6>
  803a3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a40:	75 15                	jne    803a57 <ipc_recv+0x9b>
  803a42:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a49:	00 00 00 
  803a4c:	48 8b 00             	mov    (%rax),%rax
  803a4f:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803a55:	eb 05                	jmp    803a5c <ipc_recv+0xa0>
  803a57:	b8 00 00 00 00       	mov    $0x0,%eax
  803a5c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a60:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803a62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a66:	75 15                	jne    803a7d <ipc_recv+0xc1>
  803a68:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a6f:	00 00 00 
  803a72:	48 8b 00             	mov    (%rax),%rax
  803a75:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803a7b:	eb 03                	jmp    803a80 <ipc_recv+0xc4>
  803a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a80:	c9                   	leaveq 
  803a81:	c3                   	retq   

0000000000803a82 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a82:	55                   	push   %rbp
  803a83:	48 89 e5             	mov    %rsp,%rbp
  803a86:	48 83 ec 30          	sub    $0x30,%rsp
  803a8a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a8d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a90:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803a94:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803a97:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803a9e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803aa3:	75 10                	jne    803ab5 <ipc_send+0x33>
  803aa5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803aac:	00 00 00 
  803aaf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803ab3:	eb 62                	jmp    803b17 <ipc_send+0x95>
  803ab5:	eb 60                	jmp    803b17 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803ab7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803abb:	74 30                	je     803aed <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac0:	89 c1                	mov    %eax,%ecx
  803ac2:	48 ba b6 43 80 00 00 	movabs $0x8043b6,%rdx
  803ac9:	00 00 00 
  803acc:	be 33 00 00 00       	mov    $0x33,%esi
  803ad1:	48 bf d2 43 80 00 00 	movabs $0x8043d2,%rdi
  803ad8:	00 00 00 
  803adb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ae0:	49 b8 89 37 80 00 00 	movabs $0x803789,%r8
  803ae7:	00 00 00 
  803aea:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803aed:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803af0:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803af3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803af7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803afa:	89 c7                	mov    %eax,%edi
  803afc:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  803b03:	00 00 00 
  803b06:	ff d0                	callq  *%rax
  803b08:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803b0b:	48 b8 c6 17 80 00 00 	movabs $0x8017c6,%rax
  803b12:	00 00 00 
  803b15:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803b17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b1b:	75 9a                	jne    803ab7 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803b1d:	c9                   	leaveq 
  803b1e:	c3                   	retq   

0000000000803b1f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b1f:	55                   	push   %rbp
  803b20:	48 89 e5             	mov    %rsp,%rbp
  803b23:	48 83 ec 14          	sub    $0x14,%rsp
  803b27:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803b2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b31:	eb 5e                	jmp    803b91 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803b33:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b3a:	00 00 00 
  803b3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b40:	48 63 d0             	movslq %eax,%rdx
  803b43:	48 89 d0             	mov    %rdx,%rax
  803b46:	48 c1 e0 03          	shl    $0x3,%rax
  803b4a:	48 01 d0             	add    %rdx,%rax
  803b4d:	48 c1 e0 05          	shl    $0x5,%rax
  803b51:	48 01 c8             	add    %rcx,%rax
  803b54:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b5a:	8b 00                	mov    (%rax),%eax
  803b5c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b5f:	75 2c                	jne    803b8d <ipc_find_env+0x6e>
			return envs[i].env_id;
  803b61:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b68:	00 00 00 
  803b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b6e:	48 63 d0             	movslq %eax,%rdx
  803b71:	48 89 d0             	mov    %rdx,%rax
  803b74:	48 c1 e0 03          	shl    $0x3,%rax
  803b78:	48 01 d0             	add    %rdx,%rax
  803b7b:	48 c1 e0 05          	shl    $0x5,%rax
  803b7f:	48 01 c8             	add    %rcx,%rax
  803b82:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803b88:	8b 40 08             	mov    0x8(%rax),%eax
  803b8b:	eb 12                	jmp    803b9f <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803b8d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b91:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803b98:	7e 99                	jle    803b33 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803b9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b9f:	c9                   	leaveq 
  803ba0:	c3                   	retq   

0000000000803ba1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ba1:	55                   	push   %rbp
  803ba2:	48 89 e5             	mov    %rsp,%rbp
  803ba5:	48 83 ec 18          	sub    $0x18,%rsp
  803ba9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bb1:	48 c1 e8 15          	shr    $0x15,%rax
  803bb5:	48 89 c2             	mov    %rax,%rdx
  803bb8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bbf:	01 00 00 
  803bc2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bc6:	83 e0 01             	and    $0x1,%eax
  803bc9:	48 85 c0             	test   %rax,%rax
  803bcc:	75 07                	jne    803bd5 <pageref+0x34>
		return 0;
  803bce:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd3:	eb 53                	jmp    803c28 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803bd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bd9:	48 c1 e8 0c          	shr    $0xc,%rax
  803bdd:	48 89 c2             	mov    %rax,%rdx
  803be0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803be7:	01 00 00 
  803bea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803bf2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bf6:	83 e0 01             	and    $0x1,%eax
  803bf9:	48 85 c0             	test   %rax,%rax
  803bfc:	75 07                	jne    803c05 <pageref+0x64>
		return 0;
  803bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  803c03:	eb 23                	jmp    803c28 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c09:	48 c1 e8 0c          	shr    $0xc,%rax
  803c0d:	48 89 c2             	mov    %rax,%rdx
  803c10:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c17:	00 00 00 
  803c1a:	48 c1 e2 04          	shl    $0x4,%rdx
  803c1e:	48 01 d0             	add    %rdx,%rax
  803c21:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c25:	0f b7 c0             	movzwl %ax,%eax
}
  803c28:	c9                   	leaveq 
  803c29:	c3                   	retq   
