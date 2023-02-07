
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
  800052:	48 bf e0 22 80 00 00 	movabs $0x8022e0,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 28 03 80 00 00 	movabs $0x800328,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	if ((env = fork()) == 0) {
  80006d:	48 b8 cf 1d 80 00 00 	movabs $0x801dcf,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800080:	75 1d                	jne    80009f <umain+0x5c>
		cprintf("I am the child.  Spinning...\n");
  800082:	48 bf 08 23 80 00 00 	movabs $0x802308,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 28 03 80 00 00 	movabs $0x800328,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
		while (1)
			/* do nothing */;
  80009d:	eb fe                	jmp    80009d <umain+0x5a>
	}

	cprintf("I am the parent.  Running the child...\n");
  80009f:	48 bf 28 23 80 00 00 	movabs $0x802328,%rdi
  8000a6:	00 00 00 
  8000a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ae:	48 ba 28 03 80 00 00 	movabs $0x800328,%rdx
  8000b5:	00 00 00 
  8000b8:	ff d2                	callq  *%rdx
	sys_yield();
  8000ba:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
	sys_yield();
  8000c6:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000cd:	00 00 00 
  8000d0:	ff d0                	callq  *%rax
	sys_yield();
  8000d2:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000d9:	00 00 00 
  8000dc:	ff d0                	callq  *%rax
	sys_yield();
  8000de:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
	sys_yield();
  8000ea:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000f1:	00 00 00 
  8000f4:	ff d0                	callq  *%rax
	sys_yield();
  8000f6:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
	sys_yield();
  800102:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  800109:	00 00 00 
  80010c:	ff d0                	callq  *%rax
	sys_yield();
  80010e:	48 b8 ce 17 80 00 00 	movabs $0x8017ce,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax

	cprintf("I am the parent.  Killing the child...\n");
  80011a:	48 bf 50 23 80 00 00 	movabs $0x802350,%rdi
  800121:	00 00 00 
  800124:	b8 00 00 00 00       	mov    $0x0,%eax
  800129:	48 ba 28 03 80 00 00 	movabs $0x800328,%rdx
  800130:	00 00 00 
  800133:	ff d2                	callq  *%rdx
	sys_env_destroy(env);
  800135:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800138:	89 c7                	mov    %eax,%edi
  80013a:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
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
  80014c:	48 83 ec 20          	sub    $0x20,%rsp
  800150:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800153:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800157:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80015e:	00 00 00 
  800161:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  800168:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  80016f:	00 00 00 
  800172:	ff d0                	callq  *%rax
  800174:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  800177:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  80017e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800181:	48 63 d0             	movslq %eax,%rdx
  800184:	48 89 d0             	mov    %rdx,%rax
  800187:	48 c1 e0 03          	shl    $0x3,%rax
  80018b:	48 01 d0             	add    %rdx,%rax
  80018e:	48 c1 e0 05          	shl    $0x5,%rax
  800192:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800199:	00 00 00 
  80019c:	48 01 c2             	add    %rax,%rdx
  80019f:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8001a6:	00 00 00 
  8001a9:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001b0:	7e 14                	jle    8001c6 <libmain+0x7e>
		binaryname = argv[0];
  8001b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001b6:	48 8b 10             	mov    (%rax),%rdx
  8001b9:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8001c0:	00 00 00 
  8001c3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001c6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001ca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001cd:	48 89 d6             	mov    %rdx,%rsi
  8001d0:	89 c7                	mov    %eax,%edi
  8001d2:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001d9:	00 00 00 
  8001dc:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  8001de:	48 b8 ec 01 80 00 00 	movabs $0x8001ec,%rax
  8001e5:	00 00 00 
  8001e8:	ff d0                	callq  *%rax
}
  8001ea:	c9                   	leaveq 
  8001eb:	c3                   	retq   

00000000008001ec <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ec:	55                   	push   %rbp
  8001ed:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8001f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f5:	48 b8 4c 17 80 00 00 	movabs $0x80174c,%rax
  8001fc:	00 00 00 
  8001ff:	ff d0                	callq  *%rax
}
  800201:	5d                   	pop    %rbp
  800202:	c3                   	retq   

0000000000800203 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800203:	55                   	push   %rbp
  800204:	48 89 e5             	mov    %rsp,%rbp
  800207:	48 83 ec 10          	sub    $0x10,%rsp
  80020b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80020e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800212:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800216:	8b 00                	mov    (%rax),%eax
  800218:	8d 48 01             	lea    0x1(%rax),%ecx
  80021b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021f:	89 0a                	mov    %ecx,(%rdx)
  800221:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800224:	89 d1                	mov    %edx,%ecx
  800226:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80022a:	48 98                	cltq   
  80022c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800234:	8b 00                	mov    (%rax),%eax
  800236:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023b:	75 2c                	jne    800269 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80023d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800241:	8b 00                	mov    (%rax),%eax
  800243:	48 98                	cltq   
  800245:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800249:	48 83 c2 08          	add    $0x8,%rdx
  80024d:	48 89 c6             	mov    %rax,%rsi
  800250:	48 89 d7             	mov    %rdx,%rdi
  800253:	48 b8 c4 16 80 00 00 	movabs $0x8016c4,%rax
  80025a:	00 00 00 
  80025d:	ff d0                	callq  *%rax
		b->idx = 0;
  80025f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800263:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026d:	8b 40 04             	mov    0x4(%rax),%eax
  800270:	8d 50 01             	lea    0x1(%rax),%edx
  800273:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800277:	89 50 04             	mov    %edx,0x4(%rax)
}
  80027a:	c9                   	leaveq 
  80027b:	c3                   	retq   

000000000080027c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80027c:	55                   	push   %rbp
  80027d:	48 89 e5             	mov    %rsp,%rbp
  800280:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800287:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80028e:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800295:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80029c:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002a3:	48 8b 0a             	mov    (%rdx),%rcx
  8002a6:	48 89 08             	mov    %rcx,(%rax)
  8002a9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002ad:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002b1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002b5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8002b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002c0:	00 00 00 
	b.cnt = 0;
  8002c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002ca:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8002cd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002d4:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002db:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002e2:	48 89 c6             	mov    %rax,%rsi
  8002e5:	48 bf 03 02 80 00 00 	movabs $0x800203,%rdi
  8002ec:	00 00 00 
  8002ef:	48 b8 db 06 80 00 00 	movabs $0x8006db,%rax
  8002f6:	00 00 00 
  8002f9:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002fb:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800301:	48 98                	cltq   
  800303:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80030a:	48 83 c2 08          	add    $0x8,%rdx
  80030e:	48 89 c6             	mov    %rax,%rsi
  800311:	48 89 d7             	mov    %rdx,%rdi
  800314:	48 b8 c4 16 80 00 00 	movabs $0x8016c4,%rax
  80031b:	00 00 00 
  80031e:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800320:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800326:	c9                   	leaveq 
  800327:	c3                   	retq   

0000000000800328 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800328:	55                   	push   %rbp
  800329:	48 89 e5             	mov    %rsp,%rbp
  80032c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800333:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80033a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800341:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800348:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80034f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800356:	84 c0                	test   %al,%al
  800358:	74 20                	je     80037a <cprintf+0x52>
  80035a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80035e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800362:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800366:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80036a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80036e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800372:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800376:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80037a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800381:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800388:	00 00 00 
  80038b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800392:	00 00 00 
  800395:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800399:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003a0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003a7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8003ae:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003b5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003bc:	48 8b 0a             	mov    (%rdx),%rcx
  8003bf:	48 89 08             	mov    %rcx,(%rax)
  8003c2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003c6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003ca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003ce:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003d2:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003e0:	48 89 d6             	mov    %rdx,%rsi
  8003e3:	48 89 c7             	mov    %rax,%rdi
  8003e6:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  8003ed:	00 00 00 
  8003f0:	ff d0                	callq  *%rax
  8003f2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003f8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003fe:	c9                   	leaveq 
  8003ff:	c3                   	retq   

0000000000800400 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800400:	55                   	push   %rbp
  800401:	48 89 e5             	mov    %rsp,%rbp
  800404:	53                   	push   %rbx
  800405:	48 83 ec 38          	sub    $0x38,%rsp
  800409:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80040d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800411:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800415:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800418:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80041c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800420:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800423:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800427:	77 3b                	ja     800464 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800429:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80042c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800430:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800437:	ba 00 00 00 00       	mov    $0x0,%edx
  80043c:	48 f7 f3             	div    %rbx
  80043f:	48 89 c2             	mov    %rax,%rdx
  800442:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800445:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800448:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80044c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800450:	41 89 f9             	mov    %edi,%r9d
  800453:	48 89 c7             	mov    %rax,%rdi
  800456:	48 b8 00 04 80 00 00 	movabs $0x800400,%rax
  80045d:	00 00 00 
  800460:	ff d0                	callq  *%rax
  800462:	eb 1e                	jmp    800482 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800464:	eb 12                	jmp    800478 <printnum+0x78>
			putch(padc, putdat);
  800466:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80046a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80046d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800471:	48 89 ce             	mov    %rcx,%rsi
  800474:	89 d7                	mov    %edx,%edi
  800476:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800478:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80047c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800480:	7f e4                	jg     800466 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800482:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800489:	ba 00 00 00 00       	mov    $0x0,%edx
  80048e:	48 f7 f1             	div    %rcx
  800491:	48 89 d0             	mov    %rdx,%rax
  800494:	48 ba 90 24 80 00 00 	movabs $0x802490,%rdx
  80049b:	00 00 00 
  80049e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004a2:	0f be d0             	movsbl %al,%edx
  8004a5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ad:	48 89 ce             	mov    %rcx,%rsi
  8004b0:	89 d7                	mov    %edx,%edi
  8004b2:	ff d0                	callq  *%rax
}
  8004b4:	48 83 c4 38          	add    $0x38,%rsp
  8004b8:	5b                   	pop    %rbx
  8004b9:	5d                   	pop    %rbp
  8004ba:	c3                   	retq   

00000000008004bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004bb:	55                   	push   %rbp
  8004bc:	48 89 e5             	mov    %rsp,%rbp
  8004bf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004c3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004c7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004ca:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004ce:	7e 52                	jle    800522 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d4:	8b 00                	mov    (%rax),%eax
  8004d6:	83 f8 30             	cmp    $0x30,%eax
  8004d9:	73 24                	jae    8004ff <getuint+0x44>
  8004db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004df:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e7:	8b 00                	mov    (%rax),%eax
  8004e9:	89 c0                	mov    %eax,%eax
  8004eb:	48 01 d0             	add    %rdx,%rax
  8004ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f2:	8b 12                	mov    (%rdx),%edx
  8004f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fb:	89 0a                	mov    %ecx,(%rdx)
  8004fd:	eb 17                	jmp    800516 <getuint+0x5b>
  8004ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800503:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800507:	48 89 d0             	mov    %rdx,%rax
  80050a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80050e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800512:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800516:	48 8b 00             	mov    (%rax),%rax
  800519:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80051d:	e9 a3 00 00 00       	jmpq   8005c5 <getuint+0x10a>
	else if (lflag)
  800522:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800526:	74 4f                	je     800577 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052c:	8b 00                	mov    (%rax),%eax
  80052e:	83 f8 30             	cmp    $0x30,%eax
  800531:	73 24                	jae    800557 <getuint+0x9c>
  800533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800537:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80053b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053f:	8b 00                	mov    (%rax),%eax
  800541:	89 c0                	mov    %eax,%eax
  800543:	48 01 d0             	add    %rdx,%rax
  800546:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054a:	8b 12                	mov    (%rdx),%edx
  80054c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80054f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800553:	89 0a                	mov    %ecx,(%rdx)
  800555:	eb 17                	jmp    80056e <getuint+0xb3>
  800557:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80055f:	48 89 d0             	mov    %rdx,%rax
  800562:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800566:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80056e:	48 8b 00             	mov    (%rax),%rax
  800571:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800575:	eb 4e                	jmp    8005c5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057b:	8b 00                	mov    (%rax),%eax
  80057d:	83 f8 30             	cmp    $0x30,%eax
  800580:	73 24                	jae    8005a6 <getuint+0xeb>
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80058a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058e:	8b 00                	mov    (%rax),%eax
  800590:	89 c0                	mov    %eax,%eax
  800592:	48 01 d0             	add    %rdx,%rax
  800595:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800599:	8b 12                	mov    (%rdx),%edx
  80059b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80059e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a2:	89 0a                	mov    %ecx,(%rdx)
  8005a4:	eb 17                	jmp    8005bd <getuint+0x102>
  8005a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005ae:	48 89 d0             	mov    %rdx,%rax
  8005b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005bd:	8b 00                	mov    (%rax),%eax
  8005bf:	89 c0                	mov    %eax,%eax
  8005c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005c9:	c9                   	leaveq 
  8005ca:	c3                   	retq   

00000000008005cb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005cb:	55                   	push   %rbp
  8005cc:	48 89 e5             	mov    %rsp,%rbp
  8005cf:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005d7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005de:	7e 52                	jle    800632 <getint+0x67>
		x=va_arg(*ap, long long);
  8005e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e4:	8b 00                	mov    (%rax),%eax
  8005e6:	83 f8 30             	cmp    $0x30,%eax
  8005e9:	73 24                	jae    80060f <getint+0x44>
  8005eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f7:	8b 00                	mov    (%rax),%eax
  8005f9:	89 c0                	mov    %eax,%eax
  8005fb:	48 01 d0             	add    %rdx,%rax
  8005fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800602:	8b 12                	mov    (%rdx),%edx
  800604:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800607:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060b:	89 0a                	mov    %ecx,(%rdx)
  80060d:	eb 17                	jmp    800626 <getint+0x5b>
  80060f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800613:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800617:	48 89 d0             	mov    %rdx,%rax
  80061a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80061e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800622:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800626:	48 8b 00             	mov    (%rax),%rax
  800629:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80062d:	e9 a3 00 00 00       	jmpq   8006d5 <getint+0x10a>
	else if (lflag)
  800632:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800636:	74 4f                	je     800687 <getint+0xbc>
		x=va_arg(*ap, long);
  800638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063c:	8b 00                	mov    (%rax),%eax
  80063e:	83 f8 30             	cmp    $0x30,%eax
  800641:	73 24                	jae    800667 <getint+0x9c>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80064b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064f:	8b 00                	mov    (%rax),%eax
  800651:	89 c0                	mov    %eax,%eax
  800653:	48 01 d0             	add    %rdx,%rax
  800656:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065a:	8b 12                	mov    (%rdx),%edx
  80065c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80065f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800663:	89 0a                	mov    %ecx,(%rdx)
  800665:	eb 17                	jmp    80067e <getint+0xb3>
  800667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80066f:	48 89 d0             	mov    %rdx,%rax
  800672:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800676:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80067e:	48 8b 00             	mov    (%rax),%rax
  800681:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800685:	eb 4e                	jmp    8006d5 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068b:	8b 00                	mov    (%rax),%eax
  80068d:	83 f8 30             	cmp    $0x30,%eax
  800690:	73 24                	jae    8006b6 <getint+0xeb>
  800692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800696:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069e:	8b 00                	mov    (%rax),%eax
  8006a0:	89 c0                	mov    %eax,%eax
  8006a2:	48 01 d0             	add    %rdx,%rax
  8006a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a9:	8b 12                	mov    (%rdx),%edx
  8006ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b2:	89 0a                	mov    %ecx,(%rdx)
  8006b4:	eb 17                	jmp    8006cd <getint+0x102>
  8006b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006be:	48 89 d0             	mov    %rdx,%rax
  8006c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cd:	8b 00                	mov    (%rax),%eax
  8006cf:	48 98                	cltq   
  8006d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006d9:	c9                   	leaveq 
  8006da:	c3                   	retq   

00000000008006db <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006db:	55                   	push   %rbp
  8006dc:	48 89 e5             	mov    %rsp,%rbp
  8006df:	41 54                	push   %r12
  8006e1:	53                   	push   %rbx
  8006e2:	48 83 ec 60          	sub    $0x60,%rsp
  8006e6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006ea:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006ee:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006f2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006f6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006fa:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006fe:	48 8b 0a             	mov    (%rdx),%rcx
  800701:	48 89 08             	mov    %rcx,(%rax)
  800704:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800708:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80070c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800710:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800714:	eb 17                	jmp    80072d <vprintfmt+0x52>
			if (ch == '\0')
  800716:	85 db                	test   %ebx,%ebx
  800718:	0f 84 cc 04 00 00    	je     800bea <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  80071e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800722:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800726:	48 89 d6             	mov    %rdx,%rsi
  800729:	89 df                	mov    %ebx,%edi
  80072b:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800731:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800735:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800739:	0f b6 00             	movzbl (%rax),%eax
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	83 fb 25             	cmp    $0x25,%ebx
  800742:	75 d2                	jne    800716 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800744:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800748:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80074f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800756:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80075d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800764:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800768:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80076c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800770:	0f b6 00             	movzbl (%rax),%eax
  800773:	0f b6 d8             	movzbl %al,%ebx
  800776:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800779:	83 f8 55             	cmp    $0x55,%eax
  80077c:	0f 87 34 04 00 00    	ja     800bb6 <vprintfmt+0x4db>
  800782:	89 c0                	mov    %eax,%eax
  800784:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80078b:	00 
  80078c:	48 b8 b8 24 80 00 00 	movabs $0x8024b8,%rax
  800793:	00 00 00 
  800796:	48 01 d0             	add    %rdx,%rax
  800799:	48 8b 00             	mov    (%rax),%rax
  80079c:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80079e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007a2:	eb c0                	jmp    800764 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007a4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007a8:	eb ba                	jmp    800764 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007aa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007b1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007b4:	89 d0                	mov    %edx,%eax
  8007b6:	c1 e0 02             	shl    $0x2,%eax
  8007b9:	01 d0                	add    %edx,%eax
  8007bb:	01 c0                	add    %eax,%eax
  8007bd:	01 d8                	add    %ebx,%eax
  8007bf:	83 e8 30             	sub    $0x30,%eax
  8007c2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007c5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007c9:	0f b6 00             	movzbl (%rax),%eax
  8007cc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007cf:	83 fb 2f             	cmp    $0x2f,%ebx
  8007d2:	7e 0c                	jle    8007e0 <vprintfmt+0x105>
  8007d4:	83 fb 39             	cmp    $0x39,%ebx
  8007d7:	7f 07                	jg     8007e0 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007de:	eb d1                	jmp    8007b1 <vprintfmt+0xd6>
			goto process_precision;
  8007e0:	eb 58                	jmp    80083a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007e2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e5:	83 f8 30             	cmp    $0x30,%eax
  8007e8:	73 17                	jae    800801 <vprintfmt+0x126>
  8007ea:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007ee:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f1:	89 c0                	mov    %eax,%eax
  8007f3:	48 01 d0             	add    %rdx,%rax
  8007f6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007f9:	83 c2 08             	add    $0x8,%edx
  8007fc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ff:	eb 0f                	jmp    800810 <vprintfmt+0x135>
  800801:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800805:	48 89 d0             	mov    %rdx,%rax
  800808:	48 83 c2 08          	add    $0x8,%rdx
  80080c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800810:	8b 00                	mov    (%rax),%eax
  800812:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800815:	eb 23                	jmp    80083a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800817:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80081b:	79 0c                	jns    800829 <vprintfmt+0x14e>
				width = 0;
  80081d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800824:	e9 3b ff ff ff       	jmpq   800764 <vprintfmt+0x89>
  800829:	e9 36 ff ff ff       	jmpq   800764 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80082e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800835:	e9 2a ff ff ff       	jmpq   800764 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80083a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80083e:	79 12                	jns    800852 <vprintfmt+0x177>
				width = precision, precision = -1;
  800840:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800843:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800846:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80084d:	e9 12 ff ff ff       	jmpq   800764 <vprintfmt+0x89>
  800852:	e9 0d ff ff ff       	jmpq   800764 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800857:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80085b:	e9 04 ff ff ff       	jmpq   800764 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800860:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800863:	83 f8 30             	cmp    $0x30,%eax
  800866:	73 17                	jae    80087f <vprintfmt+0x1a4>
  800868:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80086c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086f:	89 c0                	mov    %eax,%eax
  800871:	48 01 d0             	add    %rdx,%rax
  800874:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800877:	83 c2 08             	add    $0x8,%edx
  80087a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80087d:	eb 0f                	jmp    80088e <vprintfmt+0x1b3>
  80087f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800883:	48 89 d0             	mov    %rdx,%rax
  800886:	48 83 c2 08          	add    $0x8,%rdx
  80088a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80088e:	8b 10                	mov    (%rax),%edx
  800890:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800894:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800898:	48 89 ce             	mov    %rcx,%rsi
  80089b:	89 d7                	mov    %edx,%edi
  80089d:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  80089f:	e9 40 03 00 00       	jmpq   800be4 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8008a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a7:	83 f8 30             	cmp    $0x30,%eax
  8008aa:	73 17                	jae    8008c3 <vprintfmt+0x1e8>
  8008ac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b3:	89 c0                	mov    %eax,%eax
  8008b5:	48 01 d0             	add    %rdx,%rax
  8008b8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008bb:	83 c2 08             	add    $0x8,%edx
  8008be:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008c1:	eb 0f                	jmp    8008d2 <vprintfmt+0x1f7>
  8008c3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c7:	48 89 d0             	mov    %rdx,%rax
  8008ca:	48 83 c2 08          	add    $0x8,%rdx
  8008ce:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008d2:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008d4:	85 db                	test   %ebx,%ebx
  8008d6:	79 02                	jns    8008da <vprintfmt+0x1ff>
				err = -err;
  8008d8:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008da:	83 fb 09             	cmp    $0x9,%ebx
  8008dd:	7f 16                	jg     8008f5 <vprintfmt+0x21a>
  8008df:	48 b8 40 24 80 00 00 	movabs $0x802440,%rax
  8008e6:	00 00 00 
  8008e9:	48 63 d3             	movslq %ebx,%rdx
  8008ec:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008f0:	4d 85 e4             	test   %r12,%r12
  8008f3:	75 2e                	jne    800923 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008f5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008fd:	89 d9                	mov    %ebx,%ecx
  8008ff:	48 ba a1 24 80 00 00 	movabs $0x8024a1,%rdx
  800906:	00 00 00 
  800909:	48 89 c7             	mov    %rax,%rdi
  80090c:	b8 00 00 00 00       	mov    $0x0,%eax
  800911:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  800918:	00 00 00 
  80091b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80091e:	e9 c1 02 00 00       	jmpq   800be4 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800923:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800927:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80092b:	4c 89 e1             	mov    %r12,%rcx
  80092e:	48 ba aa 24 80 00 00 	movabs $0x8024aa,%rdx
  800935:	00 00 00 
  800938:	48 89 c7             	mov    %rax,%rdi
  80093b:	b8 00 00 00 00       	mov    $0x0,%eax
  800940:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  800947:	00 00 00 
  80094a:	41 ff d0             	callq  *%r8
			break;
  80094d:	e9 92 02 00 00       	jmpq   800be4 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800952:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800955:	83 f8 30             	cmp    $0x30,%eax
  800958:	73 17                	jae    800971 <vprintfmt+0x296>
  80095a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80095e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800961:	89 c0                	mov    %eax,%eax
  800963:	48 01 d0             	add    %rdx,%rax
  800966:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800969:	83 c2 08             	add    $0x8,%edx
  80096c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80096f:	eb 0f                	jmp    800980 <vprintfmt+0x2a5>
  800971:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800975:	48 89 d0             	mov    %rdx,%rax
  800978:	48 83 c2 08          	add    $0x8,%rdx
  80097c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800980:	4c 8b 20             	mov    (%rax),%r12
  800983:	4d 85 e4             	test   %r12,%r12
  800986:	75 0a                	jne    800992 <vprintfmt+0x2b7>
				p = "(null)";
  800988:	49 bc ad 24 80 00 00 	movabs $0x8024ad,%r12
  80098f:	00 00 00 
			if (width > 0 && padc != '-')
  800992:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800996:	7e 3f                	jle    8009d7 <vprintfmt+0x2fc>
  800998:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80099c:	74 39                	je     8009d7 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80099e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009a1:	48 98                	cltq   
  8009a3:	48 89 c6             	mov    %rax,%rsi
  8009a6:	4c 89 e7             	mov    %r12,%rdi
  8009a9:	48 b8 9f 0e 80 00 00 	movabs $0x800e9f,%rax
  8009b0:	00 00 00 
  8009b3:	ff d0                	callq  *%rax
  8009b5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009b8:	eb 17                	jmp    8009d1 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009ba:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009be:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009c2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c6:	48 89 ce             	mov    %rcx,%rsi
  8009c9:	89 d7                	mov    %edx,%edi
  8009cb:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d5:	7f e3                	jg     8009ba <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d7:	eb 37                	jmp    800a10 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009dd:	74 1e                	je     8009fd <vprintfmt+0x322>
  8009df:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e2:	7e 05                	jle    8009e9 <vprintfmt+0x30e>
  8009e4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e7:	7e 14                	jle    8009fd <vprintfmt+0x322>
					putch('?', putdat);
  8009e9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f1:	48 89 d6             	mov    %rdx,%rsi
  8009f4:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009f9:	ff d0                	callq  *%rax
  8009fb:	eb 0f                	jmp    800a0c <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009fd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a05:	48 89 d6             	mov    %rdx,%rsi
  800a08:	89 df                	mov    %ebx,%edi
  800a0a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a10:	4c 89 e0             	mov    %r12,%rax
  800a13:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a17:	0f b6 00             	movzbl (%rax),%eax
  800a1a:	0f be d8             	movsbl %al,%ebx
  800a1d:	85 db                	test   %ebx,%ebx
  800a1f:	74 10                	je     800a31 <vprintfmt+0x356>
  800a21:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a25:	78 b2                	js     8009d9 <vprintfmt+0x2fe>
  800a27:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a2b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a2f:	79 a8                	jns    8009d9 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a31:	eb 16                	jmp    800a49 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3b:	48 89 d6             	mov    %rdx,%rsi
  800a3e:	bf 20 00 00 00       	mov    $0x20,%edi
  800a43:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a45:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a49:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a4d:	7f e4                	jg     800a33 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800a4f:	e9 90 01 00 00       	jmpq   800be4 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800a54:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a58:	be 03 00 00 00       	mov    $0x3,%esi
  800a5d:	48 89 c7             	mov    %rax,%rdi
  800a60:	48 b8 cb 05 80 00 00 	movabs $0x8005cb,%rax
  800a67:	00 00 00 
  800a6a:	ff d0                	callq  *%rax
  800a6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a74:	48 85 c0             	test   %rax,%rax
  800a77:	79 1d                	jns    800a96 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a81:	48 89 d6             	mov    %rdx,%rsi
  800a84:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a89:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8f:	48 f7 d8             	neg    %rax
  800a92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a96:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a9d:	e9 d5 00 00 00       	jmpq   800b77 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800aa2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aa6:	be 03 00 00 00       	mov    $0x3,%esi
  800aab:	48 89 c7             	mov    %rax,%rdi
  800aae:	48 b8 bb 04 80 00 00 	movabs $0x8004bb,%rax
  800ab5:	00 00 00 
  800ab8:	ff d0                	callq  *%rax
  800aba:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800abe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ac5:	e9 ad 00 00 00       	jmpq   800b77 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800aca:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ace:	be 03 00 00 00       	mov    $0x3,%esi
  800ad3:	48 89 c7             	mov    %rax,%rdi
  800ad6:	48 b8 bb 04 80 00 00 	movabs $0x8004bb,%rax
  800add:	00 00 00 
  800ae0:	ff d0                	callq  *%rax
  800ae2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ae6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800aed:	e9 85 00 00 00       	jmpq   800b77 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800af2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afa:	48 89 d6             	mov    %rdx,%rsi
  800afd:	bf 30 00 00 00       	mov    $0x30,%edi
  800b02:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0c:	48 89 d6             	mov    %rdx,%rsi
  800b0f:	bf 78 00 00 00       	mov    $0x78,%edi
  800b14:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b16:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b19:	83 f8 30             	cmp    $0x30,%eax
  800b1c:	73 17                	jae    800b35 <vprintfmt+0x45a>
  800b1e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b22:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b25:	89 c0                	mov    %eax,%eax
  800b27:	48 01 d0             	add    %rdx,%rax
  800b2a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2d:	83 c2 08             	add    $0x8,%edx
  800b30:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b33:	eb 0f                	jmp    800b44 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b35:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b39:	48 89 d0             	mov    %rdx,%rax
  800b3c:	48 83 c2 08          	add    $0x8,%rdx
  800b40:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b44:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b4b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b52:	eb 23                	jmp    800b77 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800b54:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b58:	be 03 00 00 00       	mov    $0x3,%esi
  800b5d:	48 89 c7             	mov    %rax,%rdi
  800b60:	48 b8 bb 04 80 00 00 	movabs $0x8004bb,%rax
  800b67:	00 00 00 
  800b6a:	ff d0                	callq  *%rax
  800b6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b70:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800b77:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b7c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b7f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b86:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8e:	45 89 c1             	mov    %r8d,%r9d
  800b91:	41 89 f8             	mov    %edi,%r8d
  800b94:	48 89 c7             	mov    %rax,%rdi
  800b97:	48 b8 00 04 80 00 00 	movabs $0x800400,%rax
  800b9e:	00 00 00 
  800ba1:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800ba3:	eb 3f                	jmp    800be4 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bad:	48 89 d6             	mov    %rdx,%rsi
  800bb0:	89 df                	mov    %ebx,%edi
  800bb2:	ff d0                	callq  *%rax
			break;
  800bb4:	eb 2e                	jmp    800be4 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbe:	48 89 d6             	mov    %rdx,%rsi
  800bc1:	bf 25 00 00 00       	mov    $0x25,%edi
  800bc6:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bcd:	eb 05                	jmp    800bd4 <vprintfmt+0x4f9>
  800bcf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bd4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bd8:	48 83 e8 01          	sub    $0x1,%rax
  800bdc:	0f b6 00             	movzbl (%rax),%eax
  800bdf:	3c 25                	cmp    $0x25,%al
  800be1:	75 ec                	jne    800bcf <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800be3:	90                   	nop
		}
	}
  800be4:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be5:	e9 43 fb ff ff       	jmpq   80072d <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  800bea:	48 83 c4 60          	add    $0x60,%rsp
  800bee:	5b                   	pop    %rbx
  800bef:	41 5c                	pop    %r12
  800bf1:	5d                   	pop    %rbp
  800bf2:	c3                   	retq   

0000000000800bf3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf3:	55                   	push   %rbp
  800bf4:	48 89 e5             	mov    %rsp,%rbp
  800bf7:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bfe:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c05:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c0c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c13:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c1a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c21:	84 c0                	test   %al,%al
  800c23:	74 20                	je     800c45 <printfmt+0x52>
  800c25:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c29:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c2d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c31:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c35:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c39:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c3d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c41:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c45:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c4c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c53:	00 00 00 
  800c56:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c5d:	00 00 00 
  800c60:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c64:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c6b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c72:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c79:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c80:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c87:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c8e:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c95:	48 89 c7             	mov    %rax,%rdi
  800c98:	48 b8 db 06 80 00 00 	movabs $0x8006db,%rax
  800c9f:	00 00 00 
  800ca2:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ca4:	c9                   	leaveq 
  800ca5:	c3                   	retq   

0000000000800ca6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ca6:	55                   	push   %rbp
  800ca7:	48 89 e5             	mov    %rsp,%rbp
  800caa:	48 83 ec 10          	sub    $0x10,%rsp
  800cae:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cb1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cb5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb9:	8b 40 10             	mov    0x10(%rax),%eax
  800cbc:	8d 50 01             	lea    0x1(%rax),%edx
  800cbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cca:	48 8b 10             	mov    (%rax),%rdx
  800ccd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd1:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cd5:	48 39 c2             	cmp    %rax,%rdx
  800cd8:	73 17                	jae    800cf1 <sprintputch+0x4b>
		*b->buf++ = ch;
  800cda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cde:	48 8b 00             	mov    (%rax),%rax
  800ce1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ce5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ce9:	48 89 0a             	mov    %rcx,(%rdx)
  800cec:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cef:	88 10                	mov    %dl,(%rax)
}
  800cf1:	c9                   	leaveq 
  800cf2:	c3                   	retq   

0000000000800cf3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cf3:	55                   	push   %rbp
  800cf4:	48 89 e5             	mov    %rsp,%rbp
  800cf7:	48 83 ec 50          	sub    $0x50,%rsp
  800cfb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cff:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d02:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d06:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d0a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d0e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d12:	48 8b 0a             	mov    (%rdx),%rcx
  800d15:	48 89 08             	mov    %rcx,(%rax)
  800d18:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d1c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d20:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d24:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d28:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d2c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d30:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d33:	48 98                	cltq   
  800d35:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d39:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d3d:	48 01 d0             	add    %rdx,%rax
  800d40:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d44:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d4b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d50:	74 06                	je     800d58 <vsnprintf+0x65>
  800d52:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d56:	7f 07                	jg     800d5f <vsnprintf+0x6c>
		return -E_INVAL;
  800d58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d5d:	eb 2f                	jmp    800d8e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d5f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d63:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d67:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d6b:	48 89 c6             	mov    %rax,%rsi
  800d6e:	48 bf a6 0c 80 00 00 	movabs $0x800ca6,%rdi
  800d75:	00 00 00 
  800d78:	48 b8 db 06 80 00 00 	movabs $0x8006db,%rax
  800d7f:	00 00 00 
  800d82:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d88:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d8b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d8e:	c9                   	leaveq 
  800d8f:	c3                   	retq   

0000000000800d90 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d90:	55                   	push   %rbp
  800d91:	48 89 e5             	mov    %rsp,%rbp
  800d94:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d9b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800da2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800da8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800daf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800db6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dbd:	84 c0                	test   %al,%al
  800dbf:	74 20                	je     800de1 <snprintf+0x51>
  800dc1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dc5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dc9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dcd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dd1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dd5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dd9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ddd:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800de1:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800de8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800def:	00 00 00 
  800df2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800df9:	00 00 00 
  800dfc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e00:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e07:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e0e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e15:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e1c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e23:	48 8b 0a             	mov    (%rdx),%rcx
  800e26:	48 89 08             	mov    %rcx,(%rax)
  800e29:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e2d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e31:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e35:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e39:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e40:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e47:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e4d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e54:	48 89 c7             	mov    %rax,%rdi
  800e57:	48 b8 f3 0c 80 00 00 	movabs $0x800cf3,%rax
  800e5e:	00 00 00 
  800e61:	ff d0                	callq  *%rax
  800e63:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e69:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e6f:	c9                   	leaveq 
  800e70:	c3                   	retq   

0000000000800e71 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e71:	55                   	push   %rbp
  800e72:	48 89 e5             	mov    %rsp,%rbp
  800e75:	48 83 ec 18          	sub    $0x18,%rsp
  800e79:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e84:	eb 09                	jmp    800e8f <strlen+0x1e>
		n++;
  800e86:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e8a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e93:	0f b6 00             	movzbl (%rax),%eax
  800e96:	84 c0                	test   %al,%al
  800e98:	75 ec                	jne    800e86 <strlen+0x15>
		n++;
	return n;
  800e9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e9d:	c9                   	leaveq 
  800e9e:	c3                   	retq   

0000000000800e9f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e9f:	55                   	push   %rbp
  800ea0:	48 89 e5             	mov    %rsp,%rbp
  800ea3:	48 83 ec 20          	sub    $0x20,%rsp
  800ea7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eaf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800eb6:	eb 0e                	jmp    800ec6 <strnlen+0x27>
		n++;
  800eb8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ebc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ec1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ec6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ecb:	74 0b                	je     800ed8 <strnlen+0x39>
  800ecd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed1:	0f b6 00             	movzbl (%rax),%eax
  800ed4:	84 c0                	test   %al,%al
  800ed6:	75 e0                	jne    800eb8 <strnlen+0x19>
		n++;
	return n;
  800ed8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800edb:	c9                   	leaveq 
  800edc:	c3                   	retq   

0000000000800edd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800edd:	55                   	push   %rbp
  800ede:	48 89 e5             	mov    %rsp,%rbp
  800ee1:	48 83 ec 20          	sub    $0x20,%rsp
  800ee5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ee9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800eed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ef5:	90                   	nop
  800ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800efa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800efe:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f02:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f06:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f0a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f0e:	0f b6 12             	movzbl (%rdx),%edx
  800f11:	88 10                	mov    %dl,(%rax)
  800f13:	0f b6 00             	movzbl (%rax),%eax
  800f16:	84 c0                	test   %al,%al
  800f18:	75 dc                	jne    800ef6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f1e:	c9                   	leaveq 
  800f1f:	c3                   	retq   

0000000000800f20 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f20:	55                   	push   %rbp
  800f21:	48 89 e5             	mov    %rsp,%rbp
  800f24:	48 83 ec 20          	sub    $0x20,%rsp
  800f28:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f2c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f34:	48 89 c7             	mov    %rax,%rdi
  800f37:	48 b8 71 0e 80 00 00 	movabs $0x800e71,%rax
  800f3e:	00 00 00 
  800f41:	ff d0                	callq  *%rax
  800f43:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f49:	48 63 d0             	movslq %eax,%rdx
  800f4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f50:	48 01 c2             	add    %rax,%rdx
  800f53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f57:	48 89 c6             	mov    %rax,%rsi
  800f5a:	48 89 d7             	mov    %rdx,%rdi
  800f5d:	48 b8 dd 0e 80 00 00 	movabs $0x800edd,%rax
  800f64:	00 00 00 
  800f67:	ff d0                	callq  *%rax
	return dst;
  800f69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f6d:	c9                   	leaveq 
  800f6e:	c3                   	retq   

0000000000800f6f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f6f:	55                   	push   %rbp
  800f70:	48 89 e5             	mov    %rsp,%rbp
  800f73:	48 83 ec 28          	sub    $0x28,%rsp
  800f77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f7f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f87:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f8b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f92:	00 
  800f93:	eb 2a                	jmp    800fbf <strncpy+0x50>
		*dst++ = *src;
  800f95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f99:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f9d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fa5:	0f b6 12             	movzbl (%rdx),%edx
  800fa8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800faa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fae:	0f b6 00             	movzbl (%rax),%eax
  800fb1:	84 c0                	test   %al,%al
  800fb3:	74 05                	je     800fba <strncpy+0x4b>
			src++;
  800fb5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fc7:	72 cc                	jb     800f95 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fcd:	c9                   	leaveq 
  800fce:	c3                   	retq   

0000000000800fcf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fcf:	55                   	push   %rbp
  800fd0:	48 89 e5             	mov    %rsp,%rbp
  800fd3:	48 83 ec 28          	sub    $0x28,%rsp
  800fd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fdb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fdf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fe3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800feb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800ff0:	74 3d                	je     80102f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800ff2:	eb 1d                	jmp    801011 <strlcpy+0x42>
			*dst++ = *src++;
  800ff4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ffc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801000:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801004:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801008:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80100c:	0f b6 12             	movzbl (%rdx),%edx
  80100f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801011:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801016:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80101b:	74 0b                	je     801028 <strlcpy+0x59>
  80101d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801021:	0f b6 00             	movzbl (%rax),%eax
  801024:	84 c0                	test   %al,%al
  801026:	75 cc                	jne    800ff4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801028:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80102f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801033:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801037:	48 29 c2             	sub    %rax,%rdx
  80103a:	48 89 d0             	mov    %rdx,%rax
}
  80103d:	c9                   	leaveq 
  80103e:	c3                   	retq   

000000000080103f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80103f:	55                   	push   %rbp
  801040:	48 89 e5             	mov    %rsp,%rbp
  801043:	48 83 ec 10          	sub    $0x10,%rsp
  801047:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80104b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80104f:	eb 0a                	jmp    80105b <strcmp+0x1c>
		p++, q++;
  801051:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801056:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80105b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105f:	0f b6 00             	movzbl (%rax),%eax
  801062:	84 c0                	test   %al,%al
  801064:	74 12                	je     801078 <strcmp+0x39>
  801066:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106a:	0f b6 10             	movzbl (%rax),%edx
  80106d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801071:	0f b6 00             	movzbl (%rax),%eax
  801074:	38 c2                	cmp    %al,%dl
  801076:	74 d9                	je     801051 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107c:	0f b6 00             	movzbl (%rax),%eax
  80107f:	0f b6 d0             	movzbl %al,%edx
  801082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801086:	0f b6 00             	movzbl (%rax),%eax
  801089:	0f b6 c0             	movzbl %al,%eax
  80108c:	29 c2                	sub    %eax,%edx
  80108e:	89 d0                	mov    %edx,%eax
}
  801090:	c9                   	leaveq 
  801091:	c3                   	retq   

0000000000801092 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801092:	55                   	push   %rbp
  801093:	48 89 e5             	mov    %rsp,%rbp
  801096:	48 83 ec 18          	sub    $0x18,%rsp
  80109a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80109e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010a2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010a6:	eb 0f                	jmp    8010b7 <strncmp+0x25>
		n--, p++, q++;
  8010a8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010bc:	74 1d                	je     8010db <strncmp+0x49>
  8010be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c2:	0f b6 00             	movzbl (%rax),%eax
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 12                	je     8010db <strncmp+0x49>
  8010c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cd:	0f b6 10             	movzbl (%rax),%edx
  8010d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d4:	0f b6 00             	movzbl (%rax),%eax
  8010d7:	38 c2                	cmp    %al,%dl
  8010d9:	74 cd                	je     8010a8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010db:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010e0:	75 07                	jne    8010e9 <strncmp+0x57>
		return 0;
  8010e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e7:	eb 18                	jmp    801101 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ed:	0f b6 00             	movzbl (%rax),%eax
  8010f0:	0f b6 d0             	movzbl %al,%edx
  8010f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f7:	0f b6 00             	movzbl (%rax),%eax
  8010fa:	0f b6 c0             	movzbl %al,%eax
  8010fd:	29 c2                	sub    %eax,%edx
  8010ff:	89 d0                	mov    %edx,%eax
}
  801101:	c9                   	leaveq 
  801102:	c3                   	retq   

0000000000801103 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801103:	55                   	push   %rbp
  801104:	48 89 e5             	mov    %rsp,%rbp
  801107:	48 83 ec 0c          	sub    $0xc,%rsp
  80110b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80110f:	89 f0                	mov    %esi,%eax
  801111:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801114:	eb 17                	jmp    80112d <strchr+0x2a>
		if (*s == c)
  801116:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111a:	0f b6 00             	movzbl (%rax),%eax
  80111d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801120:	75 06                	jne    801128 <strchr+0x25>
			return (char *) s;
  801122:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801126:	eb 15                	jmp    80113d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801128:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80112d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801131:	0f b6 00             	movzbl (%rax),%eax
  801134:	84 c0                	test   %al,%al
  801136:	75 de                	jne    801116 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801138:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80113d:	c9                   	leaveq 
  80113e:	c3                   	retq   

000000000080113f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80113f:	55                   	push   %rbp
  801140:	48 89 e5             	mov    %rsp,%rbp
  801143:	48 83 ec 0c          	sub    $0xc,%rsp
  801147:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114b:	89 f0                	mov    %esi,%eax
  80114d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801150:	eb 13                	jmp    801165 <strfind+0x26>
		if (*s == c)
  801152:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801156:	0f b6 00             	movzbl (%rax),%eax
  801159:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80115c:	75 02                	jne    801160 <strfind+0x21>
			break;
  80115e:	eb 10                	jmp    801170 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801160:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801165:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801169:	0f b6 00             	movzbl (%rax),%eax
  80116c:	84 c0                	test   %al,%al
  80116e:	75 e2                	jne    801152 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801174:	c9                   	leaveq 
  801175:	c3                   	retq   

0000000000801176 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801176:	55                   	push   %rbp
  801177:	48 89 e5             	mov    %rsp,%rbp
  80117a:	48 83 ec 18          	sub    $0x18,%rsp
  80117e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801182:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801185:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801189:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80118e:	75 06                	jne    801196 <memset+0x20>
		return v;
  801190:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801194:	eb 69                	jmp    8011ff <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801196:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119a:	83 e0 03             	and    $0x3,%eax
  80119d:	48 85 c0             	test   %rax,%rax
  8011a0:	75 48                	jne    8011ea <memset+0x74>
  8011a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a6:	83 e0 03             	and    $0x3,%eax
  8011a9:	48 85 c0             	test   %rax,%rax
  8011ac:	75 3c                	jne    8011ea <memset+0x74>
		c &= 0xFF;
  8011ae:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b8:	c1 e0 18             	shl    $0x18,%eax
  8011bb:	89 c2                	mov    %eax,%edx
  8011bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c0:	c1 e0 10             	shl    $0x10,%eax
  8011c3:	09 c2                	or     %eax,%edx
  8011c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c8:	c1 e0 08             	shl    $0x8,%eax
  8011cb:	09 d0                	or     %edx,%eax
  8011cd:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d4:	48 c1 e8 02          	shr    $0x2,%rax
  8011d8:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e2:	48 89 d7             	mov    %rdx,%rdi
  8011e5:	fc                   	cld    
  8011e6:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011e8:	eb 11                	jmp    8011fb <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011ea:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011f1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011f5:	48 89 d7             	mov    %rdx,%rdi
  8011f8:	fc                   	cld    
  8011f9:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8011fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ff:	c9                   	leaveq 
  801200:	c3                   	retq   

0000000000801201 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801201:	55                   	push   %rbp
  801202:	48 89 e5             	mov    %rsp,%rbp
  801205:	48 83 ec 28          	sub    $0x28,%rsp
  801209:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80120d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801211:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801215:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801219:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80121d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801221:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801225:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801229:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80122d:	0f 83 88 00 00 00    	jae    8012bb <memmove+0xba>
  801233:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801237:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123b:	48 01 d0             	add    %rdx,%rax
  80123e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801242:	76 77                	jbe    8012bb <memmove+0xba>
		s += n;
  801244:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801248:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80124c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801250:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801258:	83 e0 03             	and    $0x3,%eax
  80125b:	48 85 c0             	test   %rax,%rax
  80125e:	75 3b                	jne    80129b <memmove+0x9a>
  801260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801264:	83 e0 03             	and    $0x3,%eax
  801267:	48 85 c0             	test   %rax,%rax
  80126a:	75 2f                	jne    80129b <memmove+0x9a>
  80126c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801270:	83 e0 03             	and    $0x3,%eax
  801273:	48 85 c0             	test   %rax,%rax
  801276:	75 23                	jne    80129b <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801278:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127c:	48 83 e8 04          	sub    $0x4,%rax
  801280:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801284:	48 83 ea 04          	sub    $0x4,%rdx
  801288:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80128c:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801290:	48 89 c7             	mov    %rax,%rdi
  801293:	48 89 d6             	mov    %rdx,%rsi
  801296:	fd                   	std    
  801297:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801299:	eb 1d                	jmp    8012b8 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80129b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012af:	48 89 d7             	mov    %rdx,%rdi
  8012b2:	48 89 c1             	mov    %rax,%rcx
  8012b5:	fd                   	std    
  8012b6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012b8:	fc                   	cld    
  8012b9:	eb 57                	jmp    801312 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bf:	83 e0 03             	and    $0x3,%eax
  8012c2:	48 85 c0             	test   %rax,%rax
  8012c5:	75 36                	jne    8012fd <memmove+0xfc>
  8012c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012cb:	83 e0 03             	and    $0x3,%eax
  8012ce:	48 85 c0             	test   %rax,%rax
  8012d1:	75 2a                	jne    8012fd <memmove+0xfc>
  8012d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d7:	83 e0 03             	and    $0x3,%eax
  8012da:	48 85 c0             	test   %rax,%rax
  8012dd:	75 1e                	jne    8012fd <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e3:	48 c1 e8 02          	shr    $0x2,%rax
  8012e7:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f2:	48 89 c7             	mov    %rax,%rdi
  8012f5:	48 89 d6             	mov    %rdx,%rsi
  8012f8:	fc                   	cld    
  8012f9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012fb:	eb 15                	jmp    801312 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801301:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801305:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801309:	48 89 c7             	mov    %rax,%rdi
  80130c:	48 89 d6             	mov    %rdx,%rsi
  80130f:	fc                   	cld    
  801310:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801316:	c9                   	leaveq 
  801317:	c3                   	retq   

0000000000801318 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801318:	55                   	push   %rbp
  801319:	48 89 e5             	mov    %rsp,%rbp
  80131c:	48 83 ec 18          	sub    $0x18,%rsp
  801320:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801324:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801328:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80132c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801330:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801334:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801338:	48 89 ce             	mov    %rcx,%rsi
  80133b:	48 89 c7             	mov    %rax,%rdi
  80133e:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  801345:	00 00 00 
  801348:	ff d0                	callq  *%rax
}
  80134a:	c9                   	leaveq 
  80134b:	c3                   	retq   

000000000080134c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80134c:	55                   	push   %rbp
  80134d:	48 89 e5             	mov    %rsp,%rbp
  801350:	48 83 ec 28          	sub    $0x28,%rsp
  801354:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801358:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80135c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801360:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801364:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801368:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801370:	eb 36                	jmp    8013a8 <memcmp+0x5c>
		if (*s1 != *s2)
  801372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801376:	0f b6 10             	movzbl (%rax),%edx
  801379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137d:	0f b6 00             	movzbl (%rax),%eax
  801380:	38 c2                	cmp    %al,%dl
  801382:	74 1a                	je     80139e <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801384:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801388:	0f b6 00             	movzbl (%rax),%eax
  80138b:	0f b6 d0             	movzbl %al,%edx
  80138e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801392:	0f b6 00             	movzbl (%rax),%eax
  801395:	0f b6 c0             	movzbl %al,%eax
  801398:	29 c2                	sub    %eax,%edx
  80139a:	89 d0                	mov    %edx,%eax
  80139c:	eb 20                	jmp    8013be <memcmp+0x72>
		s1++, s2++;
  80139e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ac:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013b4:	48 85 c0             	test   %rax,%rax
  8013b7:	75 b9                	jne    801372 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013be:	c9                   	leaveq 
  8013bf:	c3                   	retq   

00000000008013c0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013c0:	55                   	push   %rbp
  8013c1:	48 89 e5             	mov    %rsp,%rbp
  8013c4:	48 83 ec 28          	sub    $0x28,%rsp
  8013c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013cc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013db:	48 01 d0             	add    %rdx,%rax
  8013de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013e2:	eb 15                	jmp    8013f9 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e8:	0f b6 10             	movzbl (%rax),%edx
  8013eb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013ee:	38 c2                	cmp    %al,%dl
  8013f0:	75 02                	jne    8013f4 <memfind+0x34>
			break;
  8013f2:	eb 0f                	jmp    801403 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013f4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fd:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801401:	72 e1                	jb     8013e4 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801407:	c9                   	leaveq 
  801408:	c3                   	retq   

0000000000801409 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801409:	55                   	push   %rbp
  80140a:	48 89 e5             	mov    %rsp,%rbp
  80140d:	48 83 ec 34          	sub    $0x34,%rsp
  801411:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801415:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801419:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80141c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801423:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80142a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80142b:	eb 05                	jmp    801432 <strtol+0x29>
		s++;
  80142d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801432:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801436:	0f b6 00             	movzbl (%rax),%eax
  801439:	3c 20                	cmp    $0x20,%al
  80143b:	74 f0                	je     80142d <strtol+0x24>
  80143d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801441:	0f b6 00             	movzbl (%rax),%eax
  801444:	3c 09                	cmp    $0x9,%al
  801446:	74 e5                	je     80142d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144c:	0f b6 00             	movzbl (%rax),%eax
  80144f:	3c 2b                	cmp    $0x2b,%al
  801451:	75 07                	jne    80145a <strtol+0x51>
		s++;
  801453:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801458:	eb 17                	jmp    801471 <strtol+0x68>
	else if (*s == '-')
  80145a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145e:	0f b6 00             	movzbl (%rax),%eax
  801461:	3c 2d                	cmp    $0x2d,%al
  801463:	75 0c                	jne    801471 <strtol+0x68>
		s++, neg = 1;
  801465:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80146a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801471:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801475:	74 06                	je     80147d <strtol+0x74>
  801477:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80147b:	75 28                	jne    8014a5 <strtol+0x9c>
  80147d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801481:	0f b6 00             	movzbl (%rax),%eax
  801484:	3c 30                	cmp    $0x30,%al
  801486:	75 1d                	jne    8014a5 <strtol+0x9c>
  801488:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148c:	48 83 c0 01          	add    $0x1,%rax
  801490:	0f b6 00             	movzbl (%rax),%eax
  801493:	3c 78                	cmp    $0x78,%al
  801495:	75 0e                	jne    8014a5 <strtol+0x9c>
		s += 2, base = 16;
  801497:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80149c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014a3:	eb 2c                	jmp    8014d1 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014a9:	75 19                	jne    8014c4 <strtol+0xbb>
  8014ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014af:	0f b6 00             	movzbl (%rax),%eax
  8014b2:	3c 30                	cmp    $0x30,%al
  8014b4:	75 0e                	jne    8014c4 <strtol+0xbb>
		s++, base = 8;
  8014b6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014bb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014c2:	eb 0d                	jmp    8014d1 <strtol+0xc8>
	else if (base == 0)
  8014c4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014c8:	75 07                	jne    8014d1 <strtol+0xc8>
		base = 10;
  8014ca:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d5:	0f b6 00             	movzbl (%rax),%eax
  8014d8:	3c 2f                	cmp    $0x2f,%al
  8014da:	7e 1d                	jle    8014f9 <strtol+0xf0>
  8014dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e0:	0f b6 00             	movzbl (%rax),%eax
  8014e3:	3c 39                	cmp    $0x39,%al
  8014e5:	7f 12                	jg     8014f9 <strtol+0xf0>
			dig = *s - '0';
  8014e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014eb:	0f b6 00             	movzbl (%rax),%eax
  8014ee:	0f be c0             	movsbl %al,%eax
  8014f1:	83 e8 30             	sub    $0x30,%eax
  8014f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014f7:	eb 4e                	jmp    801547 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	3c 60                	cmp    $0x60,%al
  801502:	7e 1d                	jle    801521 <strtol+0x118>
  801504:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801508:	0f b6 00             	movzbl (%rax),%eax
  80150b:	3c 7a                	cmp    $0x7a,%al
  80150d:	7f 12                	jg     801521 <strtol+0x118>
			dig = *s - 'a' + 10;
  80150f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801513:	0f b6 00             	movzbl (%rax),%eax
  801516:	0f be c0             	movsbl %al,%eax
  801519:	83 e8 57             	sub    $0x57,%eax
  80151c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80151f:	eb 26                	jmp    801547 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801525:	0f b6 00             	movzbl (%rax),%eax
  801528:	3c 40                	cmp    $0x40,%al
  80152a:	7e 48                	jle    801574 <strtol+0x16b>
  80152c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801530:	0f b6 00             	movzbl (%rax),%eax
  801533:	3c 5a                	cmp    $0x5a,%al
  801535:	7f 3d                	jg     801574 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801537:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153b:	0f b6 00             	movzbl (%rax),%eax
  80153e:	0f be c0             	movsbl %al,%eax
  801541:	83 e8 37             	sub    $0x37,%eax
  801544:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801547:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80154a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80154d:	7c 02                	jl     801551 <strtol+0x148>
			break;
  80154f:	eb 23                	jmp    801574 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801551:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801556:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801559:	48 98                	cltq   
  80155b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801560:	48 89 c2             	mov    %rax,%rdx
  801563:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801566:	48 98                	cltq   
  801568:	48 01 d0             	add    %rdx,%rax
  80156b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80156f:	e9 5d ff ff ff       	jmpq   8014d1 <strtol+0xc8>

	if (endptr)
  801574:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801579:	74 0b                	je     801586 <strtol+0x17d>
		*endptr = (char *) s;
  80157b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80157f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801583:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80158a:	74 09                	je     801595 <strtol+0x18c>
  80158c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801590:	48 f7 d8             	neg    %rax
  801593:	eb 04                	jmp    801599 <strtol+0x190>
  801595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801599:	c9                   	leaveq 
  80159a:	c3                   	retq   

000000000080159b <strstr>:

char * strstr(const char *in, const char *str)
{
  80159b:	55                   	push   %rbp
  80159c:	48 89 e5             	mov    %rsp,%rbp
  80159f:	48 83 ec 30          	sub    $0x30,%rsp
  8015a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8015ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015af:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015b3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015b7:	0f b6 00             	movzbl (%rax),%eax
  8015ba:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8015bd:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015c1:	75 06                	jne    8015c9 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8015c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c7:	eb 6b                	jmp    801634 <strstr+0x99>

    len = strlen(str);
  8015c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015cd:	48 89 c7             	mov    %rax,%rdi
  8015d0:	48 b8 71 0e 80 00 00 	movabs $0x800e71,%rax
  8015d7:	00 00 00 
  8015da:	ff d0                	callq  *%rax
  8015dc:	48 98                	cltq   
  8015de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015ea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015ee:	0f b6 00             	movzbl (%rax),%eax
  8015f1:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8015f4:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015f8:	75 07                	jne    801601 <strstr+0x66>
                return (char *) 0;
  8015fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ff:	eb 33                	jmp    801634 <strstr+0x99>
        } while (sc != c);
  801601:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801605:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801608:	75 d8                	jne    8015e2 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80160a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80160e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801612:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801616:	48 89 ce             	mov    %rcx,%rsi
  801619:	48 89 c7             	mov    %rax,%rdi
  80161c:	48 b8 92 10 80 00 00 	movabs $0x801092,%rax
  801623:	00 00 00 
  801626:	ff d0                	callq  *%rax
  801628:	85 c0                	test   %eax,%eax
  80162a:	75 b6                	jne    8015e2 <strstr+0x47>

    return (char *) (in - 1);
  80162c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801630:	48 83 e8 01          	sub    $0x1,%rax
}
  801634:	c9                   	leaveq 
  801635:	c3                   	retq   

0000000000801636 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801636:	55                   	push   %rbp
  801637:	48 89 e5             	mov    %rsp,%rbp
  80163a:	53                   	push   %rbx
  80163b:	48 83 ec 48          	sub    $0x48,%rsp
  80163f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801642:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801645:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801649:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80164d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801651:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801655:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801658:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80165c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801660:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801664:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801668:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80166c:	4c 89 c3             	mov    %r8,%rbx
  80166f:	cd 30                	int    $0x30
  801671:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801675:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801679:	74 3e                	je     8016b9 <syscall+0x83>
  80167b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801680:	7e 37                	jle    8016b9 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801682:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801686:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801689:	49 89 d0             	mov    %rdx,%r8
  80168c:	89 c1                	mov    %eax,%ecx
  80168e:	48 ba 68 27 80 00 00 	movabs $0x802768,%rdx
  801695:	00 00 00 
  801698:	be 23 00 00 00       	mov    $0x23,%esi
  80169d:	48 bf 85 27 80 00 00 	movabs $0x802785,%rdi
  8016a4:	00 00 00 
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ac:	49 b9 4c 20 80 00 00 	movabs $0x80204c,%r9
  8016b3:	00 00 00 
  8016b6:	41 ff d1             	callq  *%r9

	return ret;
  8016b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016bd:	48 83 c4 48          	add    $0x48,%rsp
  8016c1:	5b                   	pop    %rbx
  8016c2:	5d                   	pop    %rbp
  8016c3:	c3                   	retq   

00000000008016c4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016c4:	55                   	push   %rbp
  8016c5:	48 89 e5             	mov    %rsp,%rbp
  8016c8:	48 83 ec 20          	sub    $0x20,%rsp
  8016cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e3:	00 
  8016e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f0:	48 89 d1             	mov    %rdx,%rcx
  8016f3:	48 89 c2             	mov    %rax,%rdx
  8016f6:	be 00 00 00 00       	mov    $0x0,%esi
  8016fb:	bf 00 00 00 00       	mov    $0x0,%edi
  801700:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801707:	00 00 00 
  80170a:	ff d0                	callq  *%rax
}
  80170c:	c9                   	leaveq 
  80170d:	c3                   	retq   

000000000080170e <sys_cgetc>:

int
sys_cgetc(void)
{
  80170e:	55                   	push   %rbp
  80170f:	48 89 e5             	mov    %rsp,%rbp
  801712:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801716:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80171d:	00 
  80171e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801724:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80172a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	be 00 00 00 00       	mov    $0x0,%esi
  801739:	bf 01 00 00 00       	mov    $0x1,%edi
  80173e:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801745:	00 00 00 
  801748:	ff d0                	callq  *%rax
}
  80174a:	c9                   	leaveq 
  80174b:	c3                   	retq   

000000000080174c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80174c:	55                   	push   %rbp
  80174d:	48 89 e5             	mov    %rsp,%rbp
  801750:	48 83 ec 10          	sub    $0x10,%rsp
  801754:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801757:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80175a:	48 98                	cltq   
  80175c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801763:	00 
  801764:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801770:	b9 00 00 00 00       	mov    $0x0,%ecx
  801775:	48 89 c2             	mov    %rax,%rdx
  801778:	be 01 00 00 00       	mov    $0x1,%esi
  80177d:	bf 03 00 00 00       	mov    $0x3,%edi
  801782:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801789:	00 00 00 
  80178c:	ff d0                	callq  *%rax
}
  80178e:	c9                   	leaveq 
  80178f:	c3                   	retq   

0000000000801790 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801790:	55                   	push   %rbp
  801791:	48 89 e5             	mov    %rsp,%rbp
  801794:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801798:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80179f:	00 
  8017a0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017a6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b6:	be 00 00 00 00       	mov    $0x0,%esi
  8017bb:	bf 02 00 00 00       	mov    $0x2,%edi
  8017c0:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  8017c7:	00 00 00 
  8017ca:	ff d0                	callq  *%rax
}
  8017cc:	c9                   	leaveq 
  8017cd:	c3                   	retq   

00000000008017ce <sys_yield>:

void
sys_yield(void)
{
  8017ce:	55                   	push   %rbp
  8017cf:	48 89 e5             	mov    %rsp,%rbp
  8017d2:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017dd:	00 
  8017de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f4:	be 00 00 00 00       	mov    $0x0,%esi
  8017f9:	bf 0a 00 00 00       	mov    $0xa,%edi
  8017fe:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801805:	00 00 00 
  801808:	ff d0                	callq  *%rax
}
  80180a:	c9                   	leaveq 
  80180b:	c3                   	retq   

000000000080180c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80180c:	55                   	push   %rbp
  80180d:	48 89 e5             	mov    %rsp,%rbp
  801810:	48 83 ec 20          	sub    $0x20,%rsp
  801814:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801817:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80181b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80181e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801821:	48 63 c8             	movslq %eax,%rcx
  801824:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80182b:	48 98                	cltq   
  80182d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801834:	00 
  801835:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80183b:	49 89 c8             	mov    %rcx,%r8
  80183e:	48 89 d1             	mov    %rdx,%rcx
  801841:	48 89 c2             	mov    %rax,%rdx
  801844:	be 01 00 00 00       	mov    $0x1,%esi
  801849:	bf 04 00 00 00       	mov    $0x4,%edi
  80184e:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801855:	00 00 00 
  801858:	ff d0                	callq  *%rax
}
  80185a:	c9                   	leaveq 
  80185b:	c3                   	retq   

000000000080185c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80185c:	55                   	push   %rbp
  80185d:	48 89 e5             	mov    %rsp,%rbp
  801860:	48 83 ec 30          	sub    $0x30,%rsp
  801864:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801867:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80186b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80186e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801872:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801876:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801879:	48 63 c8             	movslq %eax,%rcx
  80187c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801880:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801883:	48 63 f0             	movslq %eax,%rsi
  801886:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80188a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80188d:	48 98                	cltq   
  80188f:	48 89 0c 24          	mov    %rcx,(%rsp)
  801893:	49 89 f9             	mov    %rdi,%r9
  801896:	49 89 f0             	mov    %rsi,%r8
  801899:	48 89 d1             	mov    %rdx,%rcx
  80189c:	48 89 c2             	mov    %rax,%rdx
  80189f:	be 01 00 00 00       	mov    $0x1,%esi
  8018a4:	bf 05 00 00 00       	mov    $0x5,%edi
  8018a9:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  8018b0:	00 00 00 
  8018b3:	ff d0                	callq  *%rax
}
  8018b5:	c9                   	leaveq 
  8018b6:	c3                   	retq   

00000000008018b7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018b7:	55                   	push   %rbp
  8018b8:	48 89 e5             	mov    %rsp,%rbp
  8018bb:	48 83 ec 20          	sub    $0x20,%rsp
  8018bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018cd:	48 98                	cltq   
  8018cf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d6:	00 
  8018d7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e3:	48 89 d1             	mov    %rdx,%rcx
  8018e6:	48 89 c2             	mov    %rax,%rdx
  8018e9:	be 01 00 00 00       	mov    $0x1,%esi
  8018ee:	bf 06 00 00 00       	mov    $0x6,%edi
  8018f3:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  8018fa:	00 00 00 
  8018fd:	ff d0                	callq  *%rax
}
  8018ff:	c9                   	leaveq 
  801900:	c3                   	retq   

0000000000801901 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801901:	55                   	push   %rbp
  801902:	48 89 e5             	mov    %rsp,%rbp
  801905:	48 83 ec 10          	sub    $0x10,%rsp
  801909:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80190c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80190f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801912:	48 63 d0             	movslq %eax,%rdx
  801915:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801918:	48 98                	cltq   
  80191a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801921:	00 
  801922:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801928:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192e:	48 89 d1             	mov    %rdx,%rcx
  801931:	48 89 c2             	mov    %rax,%rdx
  801934:	be 01 00 00 00       	mov    $0x1,%esi
  801939:	bf 08 00 00 00       	mov    $0x8,%edi
  80193e:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801945:	00 00 00 
  801948:	ff d0                	callq  *%rax
}
  80194a:	c9                   	leaveq 
  80194b:	c3                   	retq   

000000000080194c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80194c:	55                   	push   %rbp
  80194d:	48 89 e5             	mov    %rsp,%rbp
  801950:	48 83 ec 20          	sub    $0x20,%rsp
  801954:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801957:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80195b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801962:	48 98                	cltq   
  801964:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196b:	00 
  80196c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801972:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801978:	48 89 d1             	mov    %rdx,%rcx
  80197b:	48 89 c2             	mov    %rax,%rdx
  80197e:	be 01 00 00 00       	mov    $0x1,%esi
  801983:	bf 09 00 00 00       	mov    $0x9,%edi
  801988:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  80198f:	00 00 00 
  801992:	ff d0                	callq  *%rax
}
  801994:	c9                   	leaveq 
  801995:	c3                   	retq   

0000000000801996 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801996:	55                   	push   %rbp
  801997:	48 89 e5             	mov    %rsp,%rbp
  80199a:	48 83 ec 20          	sub    $0x20,%rsp
  80199e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019a9:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019af:	48 63 f0             	movslq %eax,%rsi
  8019b2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b9:	48 98                	cltq   
  8019bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019bf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c6:	00 
  8019c7:	49 89 f1             	mov    %rsi,%r9
  8019ca:	49 89 c8             	mov    %rcx,%r8
  8019cd:	48 89 d1             	mov    %rdx,%rcx
  8019d0:	48 89 c2             	mov    %rax,%rdx
  8019d3:	be 00 00 00 00       	mov    $0x0,%esi
  8019d8:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019dd:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  8019e4:	00 00 00 
  8019e7:	ff d0                	callq  *%rax
}
  8019e9:	c9                   	leaveq 
  8019ea:	c3                   	retq   

00000000008019eb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019eb:	55                   	push   %rbp
  8019ec:	48 89 e5             	mov    %rsp,%rbp
  8019ef:	48 83 ec 10          	sub    $0x10,%rsp
  8019f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a02:	00 
  801a03:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a09:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a14:	48 89 c2             	mov    %rax,%rdx
  801a17:	be 01 00 00 00       	mov    $0x1,%esi
  801a1c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a21:	48 b8 36 16 80 00 00 	movabs $0x801636,%rax
  801a28:	00 00 00 
  801a2b:	ff d0                	callq  *%rax
}
  801a2d:	c9                   	leaveq 
  801a2e:	c3                   	retq   

0000000000801a2f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a2f:	55                   	push   %rbp
  801a30:	48 89 e5             	mov    %rsp,%rbp
  801a33:	48 83 ec 30          	sub    $0x30,%rsp
  801a37:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3f:	48 8b 00             	mov    (%rax),%rax
  801a42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4a:	48 8b 40 08          	mov    0x8(%rax),%rax
  801a4e:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801a51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a54:	83 e0 02             	and    $0x2,%eax
  801a57:	85 c0                	test   %eax,%eax
  801a59:	75 40                	jne    801a9b <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801a5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5f:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801a66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a6a:	49 89 d0             	mov    %rdx,%r8
  801a6d:	48 89 c1             	mov    %rax,%rcx
  801a70:	48 ba 98 27 80 00 00 	movabs $0x802798,%rdx
  801a77:	00 00 00 
  801a7a:	be 1a 00 00 00       	mov    $0x1a,%esi
  801a7f:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  801a86:	00 00 00 
  801a89:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8e:	49 b9 4c 20 80 00 00 	movabs $0x80204c,%r9
  801a95:	00 00 00 
  801a98:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801a9b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a9f:	48 c1 e8 0c          	shr    $0xc,%rax
  801aa3:	48 89 c2             	mov    %rax,%rdx
  801aa6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801aad:	01 00 00 
  801ab0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ab4:	25 07 08 00 00       	and    $0x807,%eax
  801ab9:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801abf:	74 4e                	je     801b0f <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801ac1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ac5:	48 c1 e8 0c          	shr    $0xc,%rax
  801ac9:	48 89 c2             	mov    %rax,%rdx
  801acc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ad3:	01 00 00 
  801ad6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ada:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ade:	49 89 d0             	mov    %rdx,%r8
  801ae1:	48 89 c1             	mov    %rax,%rcx
  801ae4:	48 ba c0 27 80 00 00 	movabs $0x8027c0,%rdx
  801aeb:	00 00 00 
  801aee:	be 1d 00 00 00       	mov    $0x1d,%esi
  801af3:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  801afa:	00 00 00 
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax
  801b02:	49 b9 4c 20 80 00 00 	movabs $0x80204c,%r9
  801b09:	00 00 00 
  801b0c:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b0f:	ba 07 00 00 00       	mov    $0x7,%edx
  801b14:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b19:	bf 00 00 00 00       	mov    $0x0,%edi
  801b1e:	48 b8 0c 18 80 00 00 	movabs $0x80180c,%rax
  801b25:	00 00 00 
  801b28:	ff d0                	callq  *%rax
  801b2a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801b2d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801b31:	79 30                	jns    801b63 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801b33:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b36:	89 c1                	mov    %eax,%ecx
  801b38:	48 ba eb 27 80 00 00 	movabs $0x8027eb,%rdx
  801b3f:	00 00 00 
  801b42:	be 23 00 00 00       	mov    $0x23,%esi
  801b47:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  801b4e:	00 00 00 
  801b51:	b8 00 00 00 00       	mov    $0x0,%eax
  801b56:	49 b8 4c 20 80 00 00 	movabs $0x80204c,%r8
  801b5d:	00 00 00 
  801b60:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801b63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b67:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801b6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b6f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b75:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b7a:	48 89 c6             	mov    %rax,%rsi
  801b7d:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b82:	48 b8 01 12 80 00 00 	movabs $0x801201,%rax
  801b89:	00 00 00 
  801b8c:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801b8e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b9a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801ba0:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801ba6:	48 89 c1             	mov    %rax,%rcx
  801ba9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bae:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bb3:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb8:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801bbf:	00 00 00 
  801bc2:	ff d0                	callq  *%rax
  801bc4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801bc7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801bcb:	79 30                	jns    801bfd <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  801bcd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bd0:	89 c1                	mov    %eax,%ecx
  801bd2:	48 ba fe 27 80 00 00 	movabs $0x8027fe,%rdx
  801bd9:	00 00 00 
  801bdc:	be 28 00 00 00       	mov    $0x28,%esi
  801be1:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  801be8:	00 00 00 
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf0:	49 b8 4c 20 80 00 00 	movabs $0x80204c,%r8
  801bf7:	00 00 00 
  801bfa:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  801bfd:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c02:	bf 00 00 00 00       	mov    $0x0,%edi
  801c07:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  801c0e:	00 00 00 
  801c11:	ff d0                	callq  *%rax
  801c13:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801c16:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801c1a:	79 30                	jns    801c4c <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  801c1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c1f:	89 c1                	mov    %eax,%ecx
  801c21:	48 ba 0f 28 80 00 00 	movabs $0x80280f,%rdx
  801c28:	00 00 00 
  801c2b:	be 2c 00 00 00       	mov    $0x2c,%esi
  801c30:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  801c37:	00 00 00 
  801c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3f:	49 b8 4c 20 80 00 00 	movabs $0x80204c,%r8
  801c46:	00 00 00 
  801c49:	41 ff d0             	callq  *%r8

}
  801c4c:	c9                   	leaveq 
  801c4d:	c3                   	retq   

0000000000801c4e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801c4e:	55                   	push   %rbp
  801c4f:	48 89 e5             	mov    %rsp,%rbp
  801c52:	48 83 ec 30          	sub    $0x30,%rsp
  801c56:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c59:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  801c5c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801c5f:	c1 e0 0c             	shl    $0xc,%eax
  801c62:	89 c0                	mov    %eax,%eax
  801c64:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  801c68:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c6f:	01 00 00 
  801c72:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801c75:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  801c7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c81:	25 02 08 00 00       	and    $0x802,%eax
  801c86:	48 85 c0             	test   %rax,%rax
  801c89:	74 0e                	je     801c99 <duppage+0x4b>
  801c8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c8f:	25 00 04 00 00       	and    $0x400,%eax
  801c94:	48 85 c0             	test   %rax,%rax
  801c97:	74 70                	je     801d09 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801c99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c9d:	25 07 0e 00 00       	and    $0xe07,%eax
  801ca2:	89 c6                	mov    %eax,%esi
  801ca4:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801ca8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801cab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801caf:	41 89 f0             	mov    %esi,%r8d
  801cb2:	48 89 c6             	mov    %rax,%rsi
  801cb5:	bf 00 00 00 00       	mov    $0x0,%edi
  801cba:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801cc1:	00 00 00 
  801cc4:	ff d0                	callq  *%rax
  801cc6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cc9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ccd:	79 30                	jns    801cff <duppage+0xb1>
			panic("sys_page_map: %e", r);
  801ccf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cd2:	89 c1                	mov    %eax,%ecx
  801cd4:	48 ba fe 27 80 00 00 	movabs $0x8027fe,%rdx
  801cdb:	00 00 00 
  801cde:	be 4b 00 00 00       	mov    $0x4b,%esi
  801ce3:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  801cea:	00 00 00 
  801ced:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf2:	49 b8 4c 20 80 00 00 	movabs $0x80204c,%r8
  801cf9:	00 00 00 
  801cfc:	41 ff d0             	callq  *%r8
		return 0;
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax
  801d04:	e9 c4 00 00 00       	jmpq   801dcd <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  801d09:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801d0d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801d10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d14:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801d1a:	48 89 c6             	mov    %rax,%rsi
  801d1d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d22:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801d29:	00 00 00 
  801d2c:	ff d0                	callq  *%rax
  801d2e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d31:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d35:	79 30                	jns    801d67 <duppage+0x119>
		panic("sys_page_map: %e", r);
  801d37:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d3a:	89 c1                	mov    %eax,%ecx
  801d3c:	48 ba fe 27 80 00 00 	movabs $0x8027fe,%rdx
  801d43:	00 00 00 
  801d46:	be 5f 00 00 00       	mov    $0x5f,%esi
  801d4b:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  801d52:	00 00 00 
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	49 b8 4c 20 80 00 00 	movabs $0x80204c,%r8
  801d61:	00 00 00 
  801d64:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  801d67:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6f:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801d75:	48 89 d1             	mov    %rdx,%rcx
  801d78:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7d:	48 89 c6             	mov    %rax,%rsi
  801d80:	bf 00 00 00 00       	mov    $0x0,%edi
  801d85:	48 b8 5c 18 80 00 00 	movabs $0x80185c,%rax
  801d8c:	00 00 00 
  801d8f:	ff d0                	callq  *%rax
  801d91:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d94:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d98:	79 30                	jns    801dca <duppage+0x17c>
		panic("sys_page_map: %e", r);
  801d9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d9d:	89 c1                	mov    %eax,%ecx
  801d9f:	48 ba fe 27 80 00 00 	movabs $0x8027fe,%rdx
  801da6:	00 00 00 
  801da9:	be 61 00 00 00       	mov    $0x61,%esi
  801dae:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  801db5:	00 00 00 
  801db8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbd:	49 b8 4c 20 80 00 00 	movabs $0x80204c,%r8
  801dc4:	00 00 00 
  801dc7:	41 ff d0             	callq  *%r8
	return r;
  801dca:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  801dcd:	c9                   	leaveq 
  801dce:	c3                   	retq   

0000000000801dcf <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801dcf:	55                   	push   %rbp
  801dd0:	48 89 e5             	mov    %rsp,%rbp
  801dd3:	48 83 ec 20          	sub    $0x20,%rsp
	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  801dd7:	48 bf 2f 1a 80 00 00 	movabs $0x801a2f,%rdi
  801dde:	00 00 00 
  801de1:	48 b8 60 21 80 00 00 	movabs $0x802160,%rax
  801de8:	00 00 00 
  801deb:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801ded:	b8 07 00 00 00       	mov    $0x7,%eax
  801df2:	cd 30                	int    $0x30
  801df4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801df7:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  801dfa:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  801dfd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801e01:	79 08                	jns    801e0b <fork+0x3c>
		return envid;
  801e03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e06:	e9 11 02 00 00       	jmpq   80201c <fork+0x24d>
	if (envid == 0) {
  801e0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801e0f:	75 46                	jne    801e57 <fork+0x88>
		thisenv = &envs[ENVX(sys_getenvid())];
  801e11:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  801e18:	00 00 00 
  801e1b:	ff d0                	callq  *%rax
  801e1d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e22:	48 63 d0             	movslq %eax,%rdx
  801e25:	48 89 d0             	mov    %rdx,%rax
  801e28:	48 c1 e0 03          	shl    $0x3,%rax
  801e2c:	48 01 d0             	add    %rdx,%rax
  801e2f:	48 c1 e0 05          	shl    $0x5,%rax
  801e33:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801e3a:	00 00 00 
  801e3d:	48 01 c2             	add    %rax,%rdx
  801e40:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801e47:	00 00 00 
  801e4a:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e52:	e9 c5 01 00 00       	jmpq   80201c <fork+0x24d>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  801e57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e5e:	e9 a4 00 00 00       	jmpq   801f07 <fork+0x138>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  801e63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e66:	c1 f8 12             	sar    $0x12,%eax
  801e69:	89 c2                	mov    %eax,%edx
  801e6b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801e72:	01 00 00 
  801e75:	48 63 d2             	movslq %edx,%rdx
  801e78:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e7c:	83 e0 01             	and    $0x1,%eax
  801e7f:	48 85 c0             	test   %rax,%rax
  801e82:	74 21                	je     801ea5 <fork+0xd6>
  801e84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e87:	c1 f8 09             	sar    $0x9,%eax
  801e8a:	89 c2                	mov    %eax,%edx
  801e8c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e93:	01 00 00 
  801e96:	48 63 d2             	movslq %edx,%rdx
  801e99:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e9d:	83 e0 01             	and    $0x1,%eax
  801ea0:	48 85 c0             	test   %rax,%rax
  801ea3:	75 09                	jne    801eae <fork+0xdf>
			pn += NPTENTRIES;
  801ea5:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  801eac:	eb 59                	jmp    801f07 <fork+0x138>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  801eae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb1:	05 00 02 00 00       	add    $0x200,%eax
  801eb6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801eb9:	eb 44                	jmp    801eff <fork+0x130>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  801ebb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec2:	01 00 00 
  801ec5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ec8:	48 63 d2             	movslq %edx,%rdx
  801ecb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ecf:	83 e0 05             	and    $0x5,%eax
  801ed2:	48 83 f8 05          	cmp    $0x5,%rax
  801ed6:	74 02                	je     801eda <fork+0x10b>
				continue;
  801ed8:	eb 21                	jmp    801efb <fork+0x12c>
			if (pn == PPN(UXSTACKTOP - 1))
  801eda:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  801ee1:	75 02                	jne    801ee5 <fork+0x116>
				continue;
  801ee3:	eb 16                	jmp    801efb <fork+0x12c>
			duppage(envid, pn);
  801ee5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ee8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eeb:	89 d6                	mov    %edx,%esi
  801eed:	89 c7                	mov    %eax,%edi
  801eef:	48 b8 4e 1c 80 00 00 	movabs $0x801c4e,%rax
  801ef6:	00 00 00 
  801ef9:	ff d0                	callq  *%rax
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  801efb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f02:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801f05:	7c b4                	jl     801ebb <fork+0xec>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  801f07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f0a:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  801f0f:	0f 86 4e ff ff ff    	jbe    801e63 <fork+0x94>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801f15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f18:	ba 07 00 00 00       	mov    $0x7,%edx
  801f1d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801f22:	89 c7                	mov    %eax,%edi
  801f24:	48 b8 0c 18 80 00 00 	movabs $0x80180c,%rax
  801f2b:	00 00 00 
  801f2e:	ff d0                	callq  *%rax
  801f30:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801f33:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f37:	79 30                	jns    801f69 <fork+0x19a>
		panic("allocating exception stack: %e", r);
  801f39:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801f3c:	89 c1                	mov    %eax,%ecx
  801f3e:	48 ba 28 28 80 00 00 	movabs $0x802828,%rdx
  801f45:	00 00 00 
  801f48:	be 98 00 00 00       	mov    $0x98,%esi
  801f4d:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  801f54:	00 00 00 
  801f57:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5c:	49 b8 4c 20 80 00 00 	movabs $0x80204c,%r8
  801f63:	00 00 00 
  801f66:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  801f69:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801f70:	00 00 00 
  801f73:	48 8b 00             	mov    (%rax),%rax
  801f76:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  801f7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f80:	48 89 d6             	mov    %rdx,%rsi
  801f83:	89 c7                	mov    %eax,%edi
  801f85:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  801f8c:	00 00 00 
  801f8f:	ff d0                	callq  *%rax
  801f91:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801f94:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f98:	79 30                	jns    801fca <fork+0x1fb>
		panic("sys_env_set_pgfault_upcall: %e", r);
  801f9a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801f9d:	89 c1                	mov    %eax,%ecx
  801f9f:	48 ba 48 28 80 00 00 	movabs $0x802848,%rdx
  801fa6:	00 00 00 
  801fa9:	be 9c 00 00 00       	mov    $0x9c,%esi
  801fae:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  801fb5:	00 00 00 
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbd:	49 b8 4c 20 80 00 00 	movabs $0x80204c,%r8
  801fc4:	00 00 00 
  801fc7:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801fca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fcd:	be 02 00 00 00       	mov    $0x2,%esi
  801fd2:	89 c7                	mov    %eax,%edi
  801fd4:	48 b8 01 19 80 00 00 	movabs $0x801901,%rax
  801fdb:	00 00 00 
  801fde:	ff d0                	callq  *%rax
  801fe0:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801fe3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801fe7:	79 30                	jns    802019 <fork+0x24a>
		panic("sys_env_set_status: %e", r);
  801fe9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801fec:	89 c1                	mov    %eax,%ecx
  801fee:	48 ba 67 28 80 00 00 	movabs $0x802867,%rdx
  801ff5:	00 00 00 
  801ff8:	be a1 00 00 00       	mov    $0xa1,%esi
  801ffd:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  802004:	00 00 00 
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
  80200c:	49 b8 4c 20 80 00 00 	movabs $0x80204c,%r8
  802013:	00 00 00 
  802016:	41 ff d0             	callq  *%r8

	return envid;
  802019:	8b 45 f8             	mov    -0x8(%rbp),%eax


}
  80201c:	c9                   	leaveq 
  80201d:	c3                   	retq   

000000000080201e <sfork>:

// Challenge!
int
sfork(void)
{
  80201e:	55                   	push   %rbp
  80201f:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802022:	48 ba 7e 28 80 00 00 	movabs $0x80287e,%rdx
  802029:	00 00 00 
  80202c:	be ac 00 00 00       	mov    $0xac,%esi
  802031:	48 bf b1 27 80 00 00 	movabs $0x8027b1,%rdi
  802038:	00 00 00 
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	48 b9 4c 20 80 00 00 	movabs $0x80204c,%rcx
  802047:	00 00 00 
  80204a:	ff d1                	callq  *%rcx

000000000080204c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80204c:	55                   	push   %rbp
  80204d:	48 89 e5             	mov    %rsp,%rbp
  802050:	53                   	push   %rbx
  802051:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802058:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80205f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802065:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80206c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802073:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80207a:	84 c0                	test   %al,%al
  80207c:	74 23                	je     8020a1 <_panic+0x55>
  80207e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802085:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  802089:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80208d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802091:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802095:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  802099:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80209d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8020a1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8020a8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8020af:	00 00 00 
  8020b2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8020b9:	00 00 00 
  8020bc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8020c0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8020c7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8020ce:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8020d5:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8020dc:	00 00 00 
  8020df:	48 8b 18             	mov    (%rax),%rbx
  8020e2:	48 b8 90 17 80 00 00 	movabs $0x801790,%rax
  8020e9:	00 00 00 
  8020ec:	ff d0                	callq  *%rax
  8020ee:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8020f4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8020fb:	41 89 c8             	mov    %ecx,%r8d
  8020fe:	48 89 d1             	mov    %rdx,%rcx
  802101:	48 89 da             	mov    %rbx,%rdx
  802104:	89 c6                	mov    %eax,%esi
  802106:	48 bf 98 28 80 00 00 	movabs $0x802898,%rdi
  80210d:	00 00 00 
  802110:	b8 00 00 00 00       	mov    $0x0,%eax
  802115:	49 b9 28 03 80 00 00 	movabs $0x800328,%r9
  80211c:	00 00 00 
  80211f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802122:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802129:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802130:	48 89 d6             	mov    %rdx,%rsi
  802133:	48 89 c7             	mov    %rax,%rdi
  802136:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  80213d:	00 00 00 
  802140:	ff d0                	callq  *%rax
	cprintf("\n");
  802142:	48 bf bb 28 80 00 00 	movabs $0x8028bb,%rdi
  802149:	00 00 00 
  80214c:	b8 00 00 00 00       	mov    $0x0,%eax
  802151:	48 ba 28 03 80 00 00 	movabs $0x800328,%rdx
  802158:	00 00 00 
  80215b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80215d:	cc                   	int3   
  80215e:	eb fd                	jmp    80215d <_panic+0x111>

0000000000802160 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802160:	55                   	push   %rbp
  802161:	48 89 e5             	mov    %rsp,%rbp
  802164:	48 83 ec 10          	sub    $0x10,%rsp
  802168:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;
	
	if (_pgfault_handler == 0) {
  80216c:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  802173:	00 00 00 
  802176:	48 8b 00             	mov    (%rax),%rax
  802179:	48 85 c0             	test   %rax,%rax
  80217c:	0f 85 b2 00 00 00    	jne    802234 <set_pgfault_handler+0xd4>
		// First time through!
		// LAB 4: Your code here.
		
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP-PGSIZE), PTE_P|PTE_U|PTE_W) != 0)
  802182:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  802189:	00 00 00 
  80218c:	48 8b 00             	mov    (%rax),%rax
  80218f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802195:	ba 07 00 00 00       	mov    $0x7,%edx
  80219a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80219f:	89 c7                	mov    %eax,%edi
  8021a1:	48 b8 0c 18 80 00 00 	movabs $0x80180c,%rax
  8021a8:	00 00 00 
  8021ab:	ff d0                	callq  *%rax
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	74 2a                	je     8021db <set_pgfault_handler+0x7b>
		  panic("\nproblem in page allocation lib/pgfault.c\n");
  8021b1:	48 ba c0 28 80 00 00 	movabs $0x8028c0,%rdx
  8021b8:	00 00 00 
  8021bb:	be 22 00 00 00       	mov    $0x22,%esi
  8021c0:	48 bf eb 28 80 00 00 	movabs $0x8028eb,%rdi
  8021c7:	00 00 00 
  8021ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cf:	48 b9 4c 20 80 00 00 	movabs $0x80204c,%rcx
  8021d6:	00 00 00 
  8021d9:	ff d1                	callq  *%rcx
		
	         if(sys_env_set_pgfault_upcall(thisenv->env_id, (void *)_pgfault_upcall) != 0)
  8021db:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8021e2:	00 00 00 
  8021e5:	48 8b 00             	mov    (%rax),%rax
  8021e8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021ee:	48 be 47 22 80 00 00 	movabs $0x802247,%rsi
  8021f5:	00 00 00 
  8021f8:	89 c7                	mov    %eax,%edi
  8021fa:	48 b8 4c 19 80 00 00 	movabs $0x80194c,%rax
  802201:	00 00 00 
  802204:	ff d0                	callq  *%rax
  802206:	85 c0                	test   %eax,%eax
  802208:	74 2a                	je     802234 <set_pgfault_handler+0xd4>
		   panic("set_pgfault_handler implemented but problems lib/pgfault.c");
  80220a:	48 ba 00 29 80 00 00 	movabs $0x802900,%rdx
  802211:	00 00 00 
  802214:	be 25 00 00 00       	mov    $0x25,%esi
  802219:	48 bf eb 28 80 00 00 	movabs $0x8028eb,%rdi
  802220:	00 00 00 
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
  802228:	48 b9 4c 20 80 00 00 	movabs $0x80204c,%rcx
  80222f:	00 00 00 
  802232:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802234:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  80223b:	00 00 00 
  80223e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802242:	48 89 10             	mov    %rdx,(%rax)
}
  802245:	c9                   	leaveq 
  802246:	c3                   	retq   

0000000000802247 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  802247:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  80224a:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  802251:	00 00 00 
	call *%rax
  802254:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.                
	movq %rsp, %rdi;	
  802256:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  802259:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802260:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  802261:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  802268:	00 
	pushq %rbx;
  802269:	53                   	push   %rbx
	movq %rsp, %rbx;	
  80226a:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  80226d:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  802270:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  802277:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  802278:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  80227c:	4c 8b 3c 24          	mov    (%rsp),%r15
  802280:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802285:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80228a:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80228f:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802294:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  802299:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80229e:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8022a3:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8022a8:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8022ad:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8022b2:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8022b7:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8022bc:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8022c1:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8022c6:	48 83 c4 78          	add    $0x78,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	add $8, %rsp; //Jump rip field  
  8022ca:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8022ce:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  8022cf:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  8022d0:	c3                   	retq   
