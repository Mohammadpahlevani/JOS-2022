
obj/user/faultread:     file format elf64-x86-64


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
  80003c:	e8 37 00 00 00       	callq  800078 <libmain>
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
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
  800057:	8b 00                	mov    (%rax),%eax
  800059:	89 c6                	mov    %eax,%esi
  80005b:	48 bf 80 1a 80 00 00 	movabs $0x801a80,%rdi
  800062:	00 00 00 
  800065:	b8 00 00 00 00       	mov    $0x0,%eax
  80006a:	48 ba 58 02 80 00 00 	movabs $0x800258,%rdx
  800071:	00 00 00 
  800074:	ff d2                	callq  *%rdx
}
  800076:	c9                   	leaveq 
  800077:	c3                   	retq   

0000000000800078 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800078:	55                   	push   %rbp
  800079:	48 89 e5             	mov    %rsp,%rbp
  80007c:	48 83 ec 20          	sub    $0x20,%rsp
  800080:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800083:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800087:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80008e:	00 00 00 
  800091:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  800098:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  80009f:	00 00 00 
  8000a2:	ff d0                	callq  *%rax
  8000a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  8000a7:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  8000ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b1:	48 63 d0             	movslq %eax,%rdx
  8000b4:	48 89 d0             	mov    %rdx,%rax
  8000b7:	48 c1 e0 03          	shl    $0x3,%rax
  8000bb:	48 01 d0             	add    %rdx,%rax
  8000be:	48 c1 e0 05          	shl    $0x5,%rax
  8000c2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000c9:	00 00 00 
  8000cc:	48 01 c2             	add    %rax,%rdx
  8000cf:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000d6:	00 00 00 
  8000d9:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000e0:	7e 14                	jle    8000f6 <libmain+0x7e>
		binaryname = argv[0];
  8000e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000e6:	48 8b 10             	mov    (%rax),%rdx
  8000e9:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000f0:	00 00 00 
  8000f3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000f6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8000fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000fd:	48 89 d6             	mov    %rdx,%rsi
  800100:	89 c7                	mov    %eax,%edi
  800102:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800109:	00 00 00 
  80010c:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  80010e:	48 b8 1c 01 80 00 00 	movabs $0x80011c,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
}
  80011a:	c9                   	leaveq 
  80011b:	c3                   	retq   

000000000080011c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011c:	55                   	push   %rbp
  80011d:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800120:	bf 00 00 00 00       	mov    $0x0,%edi
  800125:	48 b8 7c 16 80 00 00 	movabs $0x80167c,%rax
  80012c:	00 00 00 
  80012f:	ff d0                	callq  *%rax
}
  800131:	5d                   	pop    %rbp
  800132:	c3                   	retq   

0000000000800133 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800133:	55                   	push   %rbp
  800134:	48 89 e5             	mov    %rsp,%rbp
  800137:	48 83 ec 10          	sub    $0x10,%rsp
  80013b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80013e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800142:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800146:	8b 00                	mov    (%rax),%eax
  800148:	8d 48 01             	lea    0x1(%rax),%ecx
  80014b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80014f:	89 0a                	mov    %ecx,(%rdx)
  800151:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800154:	89 d1                	mov    %edx,%ecx
  800156:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80015a:	48 98                	cltq   
  80015c:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800160:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800164:	8b 00                	mov    (%rax),%eax
  800166:	3d ff 00 00 00       	cmp    $0xff,%eax
  80016b:	75 2c                	jne    800199 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	8b 00                	mov    (%rax),%eax
  800173:	48 98                	cltq   
  800175:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800179:	48 83 c2 08          	add    $0x8,%rdx
  80017d:	48 89 c6             	mov    %rax,%rsi
  800180:	48 89 d7             	mov    %rdx,%rdi
  800183:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  80018a:	00 00 00 
  80018d:	ff d0                	callq  *%rax
		b->idx = 0;
  80018f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800193:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80019d:	8b 40 04             	mov    0x4(%rax),%eax
  8001a0:	8d 50 01             	lea    0x1(%rax),%edx
  8001a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a7:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001aa:	c9                   	leaveq 
  8001ab:	c3                   	retq   

00000000008001ac <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ac:	55                   	push   %rbp
  8001ad:	48 89 e5             	mov    %rsp,%rbp
  8001b0:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001b7:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001be:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8001c5:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001cc:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001d3:	48 8b 0a             	mov    (%rdx),%rcx
  8001d6:	48 89 08             	mov    %rcx,(%rax)
  8001d9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001dd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001e1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001e5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8001e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001f0:	00 00 00 
	b.cnt = 0;
  8001f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001fa:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8001fd:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800204:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80020b:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800212:	48 89 c6             	mov    %rax,%rsi
  800215:	48 bf 33 01 80 00 00 	movabs $0x800133,%rdi
  80021c:	00 00 00 
  80021f:	48 b8 0b 06 80 00 00 	movabs $0x80060b,%rax
  800226:	00 00 00 
  800229:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80022b:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800231:	48 98                	cltq   
  800233:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80023a:	48 83 c2 08          	add    $0x8,%rdx
  80023e:	48 89 c6             	mov    %rax,%rsi
  800241:	48 89 d7             	mov    %rdx,%rdi
  800244:	48 b8 f4 15 80 00 00 	movabs $0x8015f4,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800250:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800256:	c9                   	leaveq 
  800257:	c3                   	retq   

0000000000800258 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800258:	55                   	push   %rbp
  800259:	48 89 e5             	mov    %rsp,%rbp
  80025c:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800263:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80026a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800271:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800278:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80027f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800286:	84 c0                	test   %al,%al
  800288:	74 20                	je     8002aa <cprintf+0x52>
  80028a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80028e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800292:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800296:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80029a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80029e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002a2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002a6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002aa:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8002b1:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002b8:	00 00 00 
  8002bb:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002c2:	00 00 00 
  8002c5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002c9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002d0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002d7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8002de:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002e5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002ec:	48 8b 0a             	mov    (%rdx),%rcx
  8002ef:	48 89 08             	mov    %rcx,(%rax)
  8002f2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002f6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002fa:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002fe:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  800302:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800309:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800310:	48 89 d6             	mov    %rdx,%rsi
  800313:	48 89 c7             	mov    %rax,%rdi
  800316:	48 b8 ac 01 80 00 00 	movabs $0x8001ac,%rax
  80031d:	00 00 00 
  800320:	ff d0                	callq  *%rax
  800322:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800328:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80032e:	c9                   	leaveq 
  80032f:	c3                   	retq   

0000000000800330 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800330:	55                   	push   %rbp
  800331:	48 89 e5             	mov    %rsp,%rbp
  800334:	53                   	push   %rbx
  800335:	48 83 ec 38          	sub    $0x38,%rsp
  800339:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80033d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800341:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800345:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800348:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80034c:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800350:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800353:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800357:	77 3b                	ja     800394 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800359:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80035c:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800360:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800363:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800367:	ba 00 00 00 00       	mov    $0x0,%edx
  80036c:	48 f7 f3             	div    %rbx
  80036f:	48 89 c2             	mov    %rax,%rdx
  800372:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800375:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800378:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80037c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800380:	41 89 f9             	mov    %edi,%r9d
  800383:	48 89 c7             	mov    %rax,%rdi
  800386:	48 b8 30 03 80 00 00 	movabs $0x800330,%rax
  80038d:	00 00 00 
  800390:	ff d0                	callq  *%rax
  800392:	eb 1e                	jmp    8003b2 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800394:	eb 12                	jmp    8003a8 <printnum+0x78>
			putch(padc, putdat);
  800396:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80039a:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80039d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003a1:	48 89 ce             	mov    %rcx,%rsi
  8003a4:	89 d7                	mov    %edx,%edi
  8003a6:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a8:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003ac:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003b0:	7f e4                	jg     800396 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003be:	48 f7 f1             	div    %rcx
  8003c1:	48 89 d0             	mov    %rdx,%rax
  8003c4:	48 ba b0 1b 80 00 00 	movabs $0x801bb0,%rdx
  8003cb:	00 00 00 
  8003ce:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003d2:	0f be d0             	movsbl %al,%edx
  8003d5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003dd:	48 89 ce             	mov    %rcx,%rsi
  8003e0:	89 d7                	mov    %edx,%edi
  8003e2:	ff d0                	callq  *%rax
}
  8003e4:	48 83 c4 38          	add    $0x38,%rsp
  8003e8:	5b                   	pop    %rbx
  8003e9:	5d                   	pop    %rbp
  8003ea:	c3                   	retq   

00000000008003eb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003eb:	55                   	push   %rbp
  8003ec:	48 89 e5             	mov    %rsp,%rbp
  8003ef:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003f7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003fa:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003fe:	7e 52                	jle    800452 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800404:	8b 00                	mov    (%rax),%eax
  800406:	83 f8 30             	cmp    $0x30,%eax
  800409:	73 24                	jae    80042f <getuint+0x44>
  80040b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80040f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800417:	8b 00                	mov    (%rax),%eax
  800419:	89 c0                	mov    %eax,%eax
  80041b:	48 01 d0             	add    %rdx,%rax
  80041e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800422:	8b 12                	mov    (%rdx),%edx
  800424:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800427:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042b:	89 0a                	mov    %ecx,(%rdx)
  80042d:	eb 17                	jmp    800446 <getuint+0x5b>
  80042f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800433:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800437:	48 89 d0             	mov    %rdx,%rax
  80043a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80043e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800442:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800446:	48 8b 00             	mov    (%rax),%rax
  800449:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80044d:	e9 a3 00 00 00       	jmpq   8004f5 <getuint+0x10a>
	else if (lflag)
  800452:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800456:	74 4f                	je     8004a7 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800458:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045c:	8b 00                	mov    (%rax),%eax
  80045e:	83 f8 30             	cmp    $0x30,%eax
  800461:	73 24                	jae    800487 <getuint+0x9c>
  800463:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800467:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80046b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046f:	8b 00                	mov    (%rax),%eax
  800471:	89 c0                	mov    %eax,%eax
  800473:	48 01 d0             	add    %rdx,%rax
  800476:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047a:	8b 12                	mov    (%rdx),%edx
  80047c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80047f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800483:	89 0a                	mov    %ecx,(%rdx)
  800485:	eb 17                	jmp    80049e <getuint+0xb3>
  800487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80048f:	48 89 d0             	mov    %rdx,%rax
  800492:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800496:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80049a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80049e:	48 8b 00             	mov    (%rax),%rax
  8004a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004a5:	eb 4e                	jmp    8004f5 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ab:	8b 00                	mov    (%rax),%eax
  8004ad:	83 f8 30             	cmp    $0x30,%eax
  8004b0:	73 24                	jae    8004d6 <getuint+0xeb>
  8004b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004be:	8b 00                	mov    (%rax),%eax
  8004c0:	89 c0                	mov    %eax,%eax
  8004c2:	48 01 d0             	add    %rdx,%rax
  8004c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c9:	8b 12                	mov    (%rdx),%edx
  8004cb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d2:	89 0a                	mov    %ecx,(%rdx)
  8004d4:	eb 17                	jmp    8004ed <getuint+0x102>
  8004d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004da:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004de:	48 89 d0             	mov    %rdx,%rax
  8004e1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004ed:	8b 00                	mov    (%rax),%eax
  8004ef:	89 c0                	mov    %eax,%eax
  8004f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004f9:	c9                   	leaveq 
  8004fa:	c3                   	retq   

00000000008004fb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004fb:	55                   	push   %rbp
  8004fc:	48 89 e5             	mov    %rsp,%rbp
  8004ff:	48 83 ec 1c          	sub    $0x1c,%rsp
  800503:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800507:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80050a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80050e:	7e 52                	jle    800562 <getint+0x67>
		x=va_arg(*ap, long long);
  800510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800514:	8b 00                	mov    (%rax),%eax
  800516:	83 f8 30             	cmp    $0x30,%eax
  800519:	73 24                	jae    80053f <getint+0x44>
  80051b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800527:	8b 00                	mov    (%rax),%eax
  800529:	89 c0                	mov    %eax,%eax
  80052b:	48 01 d0             	add    %rdx,%rax
  80052e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800532:	8b 12                	mov    (%rdx),%edx
  800534:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800537:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053b:	89 0a                	mov    %ecx,(%rdx)
  80053d:	eb 17                	jmp    800556 <getint+0x5b>
  80053f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800543:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800547:	48 89 d0             	mov    %rdx,%rax
  80054a:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80054e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800552:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800556:	48 8b 00             	mov    (%rax),%rax
  800559:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80055d:	e9 a3 00 00 00       	jmpq   800605 <getint+0x10a>
	else if (lflag)
  800562:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800566:	74 4f                	je     8005b7 <getint+0xbc>
		x=va_arg(*ap, long);
  800568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056c:	8b 00                	mov    (%rax),%eax
  80056e:	83 f8 30             	cmp    $0x30,%eax
  800571:	73 24                	jae    800597 <getint+0x9c>
  800573:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800577:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80057b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057f:	8b 00                	mov    (%rax),%eax
  800581:	89 c0                	mov    %eax,%eax
  800583:	48 01 d0             	add    %rdx,%rax
  800586:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058a:	8b 12                	mov    (%rdx),%edx
  80058c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80058f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800593:	89 0a                	mov    %ecx,(%rdx)
  800595:	eb 17                	jmp    8005ae <getint+0xb3>
  800597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80059f:	48 89 d0             	mov    %rdx,%rax
  8005a2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005aa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005ae:	48 8b 00             	mov    (%rax),%rax
  8005b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005b5:	eb 4e                	jmp    800605 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bb:	8b 00                	mov    (%rax),%eax
  8005bd:	83 f8 30             	cmp    $0x30,%eax
  8005c0:	73 24                	jae    8005e6 <getint+0xeb>
  8005c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ce:	8b 00                	mov    (%rax),%eax
  8005d0:	89 c0                	mov    %eax,%eax
  8005d2:	48 01 d0             	add    %rdx,%rax
  8005d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d9:	8b 12                	mov    (%rdx),%edx
  8005db:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e2:	89 0a                	mov    %ecx,(%rdx)
  8005e4:	eb 17                	jmp    8005fd <getint+0x102>
  8005e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ea:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005ee:	48 89 d0             	mov    %rdx,%rax
  8005f1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005fd:	8b 00                	mov    (%rax),%eax
  8005ff:	48 98                	cltq   
  800601:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800605:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800609:	c9                   	leaveq 
  80060a:	c3                   	retq   

000000000080060b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80060b:	55                   	push   %rbp
  80060c:	48 89 e5             	mov    %rsp,%rbp
  80060f:	41 54                	push   %r12
  800611:	53                   	push   %rbx
  800612:	48 83 ec 60          	sub    $0x60,%rsp
  800616:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80061a:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80061e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800622:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800626:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80062a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80062e:	48 8b 0a             	mov    (%rdx),%rcx
  800631:	48 89 08             	mov    %rcx,(%rax)
  800634:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800638:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80063c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800640:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800644:	eb 17                	jmp    80065d <vprintfmt+0x52>
			if (ch == '\0')
  800646:	85 db                	test   %ebx,%ebx
  800648:	0f 84 cc 04 00 00    	je     800b1a <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  80064e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800652:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800656:	48 89 d6             	mov    %rdx,%rsi
  800659:	89 df                	mov    %ebx,%edi
  80065b:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800661:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800665:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800669:	0f b6 00             	movzbl (%rax),%eax
  80066c:	0f b6 d8             	movzbl %al,%ebx
  80066f:	83 fb 25             	cmp    $0x25,%ebx
  800672:	75 d2                	jne    800646 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800674:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800678:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80067f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800686:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80068d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800694:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800698:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80069c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006a0:	0f b6 00             	movzbl (%rax),%eax
  8006a3:	0f b6 d8             	movzbl %al,%ebx
  8006a6:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006a9:	83 f8 55             	cmp    $0x55,%eax
  8006ac:	0f 87 34 04 00 00    	ja     800ae6 <vprintfmt+0x4db>
  8006b2:	89 c0                	mov    %eax,%eax
  8006b4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006bb:	00 
  8006bc:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  8006c3:	00 00 00 
  8006c6:	48 01 d0             	add    %rdx,%rax
  8006c9:	48 8b 00             	mov    (%rax),%rax
  8006cc:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ce:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006d2:	eb c0                	jmp    800694 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006d4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006d8:	eb ba                	jmp    800694 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006da:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006e1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	c1 e0 02             	shl    $0x2,%eax
  8006e9:	01 d0                	add    %edx,%eax
  8006eb:	01 c0                	add    %eax,%eax
  8006ed:	01 d8                	add    %ebx,%eax
  8006ef:	83 e8 30             	sub    $0x30,%eax
  8006f2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006f5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006f9:	0f b6 00             	movzbl (%rax),%eax
  8006fc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006ff:	83 fb 2f             	cmp    $0x2f,%ebx
  800702:	7e 0c                	jle    800710 <vprintfmt+0x105>
  800704:	83 fb 39             	cmp    $0x39,%ebx
  800707:	7f 07                	jg     800710 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800709:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80070e:	eb d1                	jmp    8006e1 <vprintfmt+0xd6>
			goto process_precision;
  800710:	eb 58                	jmp    80076a <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800712:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800715:	83 f8 30             	cmp    $0x30,%eax
  800718:	73 17                	jae    800731 <vprintfmt+0x126>
  80071a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80071e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800721:	89 c0                	mov    %eax,%eax
  800723:	48 01 d0             	add    %rdx,%rax
  800726:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800729:	83 c2 08             	add    $0x8,%edx
  80072c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80072f:	eb 0f                	jmp    800740 <vprintfmt+0x135>
  800731:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800735:	48 89 d0             	mov    %rdx,%rax
  800738:	48 83 c2 08          	add    $0x8,%rdx
  80073c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800740:	8b 00                	mov    (%rax),%eax
  800742:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800745:	eb 23                	jmp    80076a <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800747:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80074b:	79 0c                	jns    800759 <vprintfmt+0x14e>
				width = 0;
  80074d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800754:	e9 3b ff ff ff       	jmpq   800694 <vprintfmt+0x89>
  800759:	e9 36 ff ff ff       	jmpq   800694 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80075e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800765:	e9 2a ff ff ff       	jmpq   800694 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80076a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80076e:	79 12                	jns    800782 <vprintfmt+0x177>
				width = precision, precision = -1;
  800770:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800773:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800776:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80077d:	e9 12 ff ff ff       	jmpq   800694 <vprintfmt+0x89>
  800782:	e9 0d ff ff ff       	jmpq   800694 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800787:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80078b:	e9 04 ff ff ff       	jmpq   800694 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800790:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800793:	83 f8 30             	cmp    $0x30,%eax
  800796:	73 17                	jae    8007af <vprintfmt+0x1a4>
  800798:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80079c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079f:	89 c0                	mov    %eax,%eax
  8007a1:	48 01 d0             	add    %rdx,%rax
  8007a4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007a7:	83 c2 08             	add    $0x8,%edx
  8007aa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ad:	eb 0f                	jmp    8007be <vprintfmt+0x1b3>
  8007af:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b3:	48 89 d0             	mov    %rdx,%rax
  8007b6:	48 83 c2 08          	add    $0x8,%rdx
  8007ba:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007be:	8b 10                	mov    (%rax),%edx
  8007c0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007c4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007c8:	48 89 ce             	mov    %rcx,%rsi
  8007cb:	89 d7                	mov    %edx,%edi
  8007cd:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  8007cf:	e9 40 03 00 00       	jmpq   800b14 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8007d4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007d7:	83 f8 30             	cmp    $0x30,%eax
  8007da:	73 17                	jae    8007f3 <vprintfmt+0x1e8>
  8007dc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007e0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e3:	89 c0                	mov    %eax,%eax
  8007e5:	48 01 d0             	add    %rdx,%rax
  8007e8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007eb:	83 c2 08             	add    $0x8,%edx
  8007ee:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f1:	eb 0f                	jmp    800802 <vprintfmt+0x1f7>
  8007f3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007f7:	48 89 d0             	mov    %rdx,%rax
  8007fa:	48 83 c2 08          	add    $0x8,%rdx
  8007fe:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800802:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800804:	85 db                	test   %ebx,%ebx
  800806:	79 02                	jns    80080a <vprintfmt+0x1ff>
				err = -err;
  800808:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80080a:	83 fb 09             	cmp    $0x9,%ebx
  80080d:	7f 16                	jg     800825 <vprintfmt+0x21a>
  80080f:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800816:	00 00 00 
  800819:	48 63 d3             	movslq %ebx,%rdx
  80081c:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800820:	4d 85 e4             	test   %r12,%r12
  800823:	75 2e                	jne    800853 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800825:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800829:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80082d:	89 d9                	mov    %ebx,%ecx
  80082f:	48 ba c1 1b 80 00 00 	movabs $0x801bc1,%rdx
  800836:	00 00 00 
  800839:	48 89 c7             	mov    %rax,%rdi
  80083c:	b8 00 00 00 00       	mov    $0x0,%eax
  800841:	49 b8 23 0b 80 00 00 	movabs $0x800b23,%r8
  800848:	00 00 00 
  80084b:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80084e:	e9 c1 02 00 00       	jmpq   800b14 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800853:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800857:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80085b:	4c 89 e1             	mov    %r12,%rcx
  80085e:	48 ba ca 1b 80 00 00 	movabs $0x801bca,%rdx
  800865:	00 00 00 
  800868:	48 89 c7             	mov    %rax,%rdi
  80086b:	b8 00 00 00 00       	mov    $0x0,%eax
  800870:	49 b8 23 0b 80 00 00 	movabs $0x800b23,%r8
  800877:	00 00 00 
  80087a:	41 ff d0             	callq  *%r8
			break;
  80087d:	e9 92 02 00 00       	jmpq   800b14 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800882:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800885:	83 f8 30             	cmp    $0x30,%eax
  800888:	73 17                	jae    8008a1 <vprintfmt+0x296>
  80088a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80088e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800891:	89 c0                	mov    %eax,%eax
  800893:	48 01 d0             	add    %rdx,%rax
  800896:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800899:	83 c2 08             	add    $0x8,%edx
  80089c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80089f:	eb 0f                	jmp    8008b0 <vprintfmt+0x2a5>
  8008a1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a5:	48 89 d0             	mov    %rdx,%rax
  8008a8:	48 83 c2 08          	add    $0x8,%rdx
  8008ac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008b0:	4c 8b 20             	mov    (%rax),%r12
  8008b3:	4d 85 e4             	test   %r12,%r12
  8008b6:	75 0a                	jne    8008c2 <vprintfmt+0x2b7>
				p = "(null)";
  8008b8:	49 bc cd 1b 80 00 00 	movabs $0x801bcd,%r12
  8008bf:	00 00 00 
			if (width > 0 && padc != '-')
  8008c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c6:	7e 3f                	jle    800907 <vprintfmt+0x2fc>
  8008c8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008cc:	74 39                	je     800907 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ce:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008d1:	48 98                	cltq   
  8008d3:	48 89 c6             	mov    %rax,%rsi
  8008d6:	4c 89 e7             	mov    %r12,%rdi
  8008d9:	48 b8 cf 0d 80 00 00 	movabs $0x800dcf,%rax
  8008e0:	00 00 00 
  8008e3:	ff d0                	callq  *%rax
  8008e5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008e8:	eb 17                	jmp    800901 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008ea:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008ee:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008f2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f6:	48 89 ce             	mov    %rcx,%rsi
  8008f9:	89 d7                	mov    %edx,%edi
  8008fb:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800901:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800905:	7f e3                	jg     8008ea <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800907:	eb 37                	jmp    800940 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800909:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80090d:	74 1e                	je     80092d <vprintfmt+0x322>
  80090f:	83 fb 1f             	cmp    $0x1f,%ebx
  800912:	7e 05                	jle    800919 <vprintfmt+0x30e>
  800914:	83 fb 7e             	cmp    $0x7e,%ebx
  800917:	7e 14                	jle    80092d <vprintfmt+0x322>
					putch('?', putdat);
  800919:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80091d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800921:	48 89 d6             	mov    %rdx,%rsi
  800924:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800929:	ff d0                	callq  *%rax
  80092b:	eb 0f                	jmp    80093c <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80092d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800931:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800935:	48 89 d6             	mov    %rdx,%rsi
  800938:	89 df                	mov    %ebx,%edi
  80093a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800940:	4c 89 e0             	mov    %r12,%rax
  800943:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800947:	0f b6 00             	movzbl (%rax),%eax
  80094a:	0f be d8             	movsbl %al,%ebx
  80094d:	85 db                	test   %ebx,%ebx
  80094f:	74 10                	je     800961 <vprintfmt+0x356>
  800951:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800955:	78 b2                	js     800909 <vprintfmt+0x2fe>
  800957:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80095b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80095f:	79 a8                	jns    800909 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800961:	eb 16                	jmp    800979 <vprintfmt+0x36e>
				putch(' ', putdat);
  800963:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800967:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80096b:	48 89 d6             	mov    %rdx,%rsi
  80096e:	bf 20 00 00 00       	mov    $0x20,%edi
  800973:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800975:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800979:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80097d:	7f e4                	jg     800963 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  80097f:	e9 90 01 00 00       	jmpq   800b14 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800984:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800988:	be 03 00 00 00       	mov    $0x3,%esi
  80098d:	48 89 c7             	mov    %rax,%rdi
  800990:	48 b8 fb 04 80 00 00 	movabs $0x8004fb,%rax
  800997:	00 00 00 
  80099a:	ff d0                	callq  *%rax
  80099c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a4:	48 85 c0             	test   %rax,%rax
  8009a7:	79 1d                	jns    8009c6 <vprintfmt+0x3bb>
				putch('-', putdat);
  8009a9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ad:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b1:	48 89 d6             	mov    %rdx,%rsi
  8009b4:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009b9:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bf:	48 f7 d8             	neg    %rax
  8009c2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009c6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009cd:	e9 d5 00 00 00       	jmpq   800aa7 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  8009d2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009d6:	be 03 00 00 00       	mov    $0x3,%esi
  8009db:	48 89 c7             	mov    %rax,%rdi
  8009de:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  8009e5:	00 00 00 
  8009e8:	ff d0                	callq  *%rax
  8009ea:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009ee:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009f5:	e9 ad 00 00 00       	jmpq   800aa7 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  8009fa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009fe:	be 03 00 00 00       	mov    $0x3,%esi
  800a03:	48 89 c7             	mov    %rax,%rdi
  800a06:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  800a0d:	00 00 00 
  800a10:	ff d0                	callq  *%rax
  800a12:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a16:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a1d:	e9 85 00 00 00       	jmpq   800aa7 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800a22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a2a:	48 89 d6             	mov    %rdx,%rsi
  800a2d:	bf 30 00 00 00       	mov    $0x30,%edi
  800a32:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a34:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a38:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3c:	48 89 d6             	mov    %rdx,%rsi
  800a3f:	bf 78 00 00 00       	mov    $0x78,%edi
  800a44:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a46:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a49:	83 f8 30             	cmp    $0x30,%eax
  800a4c:	73 17                	jae    800a65 <vprintfmt+0x45a>
  800a4e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a52:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a55:	89 c0                	mov    %eax,%eax
  800a57:	48 01 d0             	add    %rdx,%rax
  800a5a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a5d:	83 c2 08             	add    $0x8,%edx
  800a60:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a63:	eb 0f                	jmp    800a74 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800a65:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a69:	48 89 d0             	mov    %rdx,%rax
  800a6c:	48 83 c2 08          	add    $0x8,%rdx
  800a70:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a74:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a77:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a7b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a82:	eb 23                	jmp    800aa7 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800a84:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a88:	be 03 00 00 00       	mov    $0x3,%esi
  800a8d:	48 89 c7             	mov    %rax,%rdi
  800a90:	48 b8 eb 03 80 00 00 	movabs $0x8003eb,%rax
  800a97:	00 00 00 
  800a9a:	ff d0                	callq  *%rax
  800a9c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800aa0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800aa7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800aac:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800aaf:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ab2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abe:	45 89 c1             	mov    %r8d,%r9d
  800ac1:	41 89 f8             	mov    %edi,%r8d
  800ac4:	48 89 c7             	mov    %rax,%rdi
  800ac7:	48 b8 30 03 80 00 00 	movabs $0x800330,%rax
  800ace:	00 00 00 
  800ad1:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800ad3:	eb 3f                	jmp    800b14 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800add:	48 89 d6             	mov    %rdx,%rsi
  800ae0:	89 df                	mov    %ebx,%edi
  800ae2:	ff d0                	callq  *%rax
			break;
  800ae4:	eb 2e                	jmp    800b14 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aea:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aee:	48 89 d6             	mov    %rdx,%rsi
  800af1:	bf 25 00 00 00       	mov    $0x25,%edi
  800af6:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800af8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800afd:	eb 05                	jmp    800b04 <vprintfmt+0x4f9>
  800aff:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b04:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b08:	48 83 e8 01          	sub    $0x1,%rax
  800b0c:	0f b6 00             	movzbl (%rax),%eax
  800b0f:	3c 25                	cmp    $0x25,%al
  800b11:	75 ec                	jne    800aff <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b13:	90                   	nop
		}
	}
  800b14:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b15:	e9 43 fb ff ff       	jmpq   80065d <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  800b1a:	48 83 c4 60          	add    $0x60,%rsp
  800b1e:	5b                   	pop    %rbx
  800b1f:	41 5c                	pop    %r12
  800b21:	5d                   	pop    %rbp
  800b22:	c3                   	retq   

0000000000800b23 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b23:	55                   	push   %rbp
  800b24:	48 89 e5             	mov    %rsp,%rbp
  800b27:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b2e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b35:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b3c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b43:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b4a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b51:	84 c0                	test   %al,%al
  800b53:	74 20                	je     800b75 <printfmt+0x52>
  800b55:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b59:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b5d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b61:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b65:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b69:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b6d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b71:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b75:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b7c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b83:	00 00 00 
  800b86:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b8d:	00 00 00 
  800b90:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b94:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b9b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ba2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ba9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bb0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bb7:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bbe:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bc5:	48 89 c7             	mov    %rax,%rdi
  800bc8:	48 b8 0b 06 80 00 00 	movabs $0x80060b,%rax
  800bcf:	00 00 00 
  800bd2:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bd4:	c9                   	leaveq 
  800bd5:	c3                   	retq   

0000000000800bd6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd6:	55                   	push   %rbp
  800bd7:	48 89 e5             	mov    %rsp,%rbp
  800bda:	48 83 ec 10          	sub    $0x10,%rsp
  800bde:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800be1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800be5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800be9:	8b 40 10             	mov    0x10(%rax),%eax
  800bec:	8d 50 01             	lea    0x1(%rax),%edx
  800bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf3:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bfa:	48 8b 10             	mov    (%rax),%rdx
  800bfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c01:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c05:	48 39 c2             	cmp    %rax,%rdx
  800c08:	73 17                	jae    800c21 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0e:	48 8b 00             	mov    (%rax),%rax
  800c11:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c15:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c19:	48 89 0a             	mov    %rcx,(%rdx)
  800c1c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c1f:	88 10                	mov    %dl,(%rax)
}
  800c21:	c9                   	leaveq 
  800c22:	c3                   	retq   

0000000000800c23 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c23:	55                   	push   %rbp
  800c24:	48 89 e5             	mov    %rsp,%rbp
  800c27:	48 83 ec 50          	sub    $0x50,%rsp
  800c2b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c2f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c32:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c36:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c3a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c3e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c42:	48 8b 0a             	mov    (%rdx),%rcx
  800c45:	48 89 08             	mov    %rcx,(%rax)
  800c48:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c4c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c50:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c54:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c58:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c5c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c60:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c63:	48 98                	cltq   
  800c65:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c69:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c6d:	48 01 d0             	add    %rdx,%rax
  800c70:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c74:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c7b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c80:	74 06                	je     800c88 <vsnprintf+0x65>
  800c82:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c86:	7f 07                	jg     800c8f <vsnprintf+0x6c>
		return -E_INVAL;
  800c88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c8d:	eb 2f                	jmp    800cbe <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c8f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c93:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c97:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c9b:	48 89 c6             	mov    %rax,%rsi
  800c9e:	48 bf d6 0b 80 00 00 	movabs $0x800bd6,%rdi
  800ca5:	00 00 00 
  800ca8:	48 b8 0b 06 80 00 00 	movabs $0x80060b,%rax
  800caf:	00 00 00 
  800cb2:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cb8:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cbb:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cbe:	c9                   	leaveq 
  800cbf:	c3                   	retq   

0000000000800cc0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cc0:	55                   	push   %rbp
  800cc1:	48 89 e5             	mov    %rsp,%rbp
  800cc4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ccb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cd2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cd8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cdf:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ce6:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ced:	84 c0                	test   %al,%al
  800cef:	74 20                	je     800d11 <snprintf+0x51>
  800cf1:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cf5:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cf9:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cfd:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d01:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d05:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d09:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d0d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d11:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d18:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d1f:	00 00 00 
  800d22:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d29:	00 00 00 
  800d2c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d30:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d37:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d3e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d45:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d4c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d53:	48 8b 0a             	mov    (%rdx),%rcx
  800d56:	48 89 08             	mov    %rcx,(%rax)
  800d59:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d5d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d61:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d65:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d69:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d70:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d77:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d7d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d84:	48 89 c7             	mov    %rax,%rdi
  800d87:	48 b8 23 0c 80 00 00 	movabs $0x800c23,%rax
  800d8e:	00 00 00 
  800d91:	ff d0                	callq  *%rax
  800d93:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d99:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d9f:	c9                   	leaveq 
  800da0:	c3                   	retq   

0000000000800da1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800da1:	55                   	push   %rbp
  800da2:	48 89 e5             	mov    %rsp,%rbp
  800da5:	48 83 ec 18          	sub    $0x18,%rsp
  800da9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800db4:	eb 09                	jmp    800dbf <strlen+0x1e>
		n++;
  800db6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dba:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc3:	0f b6 00             	movzbl (%rax),%eax
  800dc6:	84 c0                	test   %al,%al
  800dc8:	75 ec                	jne    800db6 <strlen+0x15>
		n++;
	return n;
  800dca:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dcd:	c9                   	leaveq 
  800dce:	c3                   	retq   

0000000000800dcf <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dcf:	55                   	push   %rbp
  800dd0:	48 89 e5             	mov    %rsp,%rbp
  800dd3:	48 83 ec 20          	sub    $0x20,%rsp
  800dd7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ddb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ddf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800de6:	eb 0e                	jmp    800df6 <strnlen+0x27>
		n++;
  800de8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dec:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800df1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800df6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800dfb:	74 0b                	je     800e08 <strnlen+0x39>
  800dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e01:	0f b6 00             	movzbl (%rax),%eax
  800e04:	84 c0                	test   %al,%al
  800e06:	75 e0                	jne    800de8 <strnlen+0x19>
		n++;
	return n;
  800e08:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e0b:	c9                   	leaveq 
  800e0c:	c3                   	retq   

0000000000800e0d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e0d:	55                   	push   %rbp
  800e0e:	48 89 e5             	mov    %rsp,%rbp
  800e11:	48 83 ec 20          	sub    $0x20,%rsp
  800e15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e19:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e21:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e25:	90                   	nop
  800e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e2a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e2e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e32:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e36:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e3a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e3e:	0f b6 12             	movzbl (%rdx),%edx
  800e41:	88 10                	mov    %dl,(%rax)
  800e43:	0f b6 00             	movzbl (%rax),%eax
  800e46:	84 c0                	test   %al,%al
  800e48:	75 dc                	jne    800e26 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e4e:	c9                   	leaveq 
  800e4f:	c3                   	retq   

0000000000800e50 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e50:	55                   	push   %rbp
  800e51:	48 89 e5             	mov    %rsp,%rbp
  800e54:	48 83 ec 20          	sub    $0x20,%rsp
  800e58:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e5c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e64:	48 89 c7             	mov    %rax,%rdi
  800e67:	48 b8 a1 0d 80 00 00 	movabs $0x800da1,%rax
  800e6e:	00 00 00 
  800e71:	ff d0                	callq  *%rax
  800e73:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e79:	48 63 d0             	movslq %eax,%rdx
  800e7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e80:	48 01 c2             	add    %rax,%rdx
  800e83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e87:	48 89 c6             	mov    %rax,%rsi
  800e8a:	48 89 d7             	mov    %rdx,%rdi
  800e8d:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  800e94:	00 00 00 
  800e97:	ff d0                	callq  *%rax
	return dst;
  800e99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e9d:	c9                   	leaveq 
  800e9e:	c3                   	retq   

0000000000800e9f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e9f:	55                   	push   %rbp
  800ea0:	48 89 e5             	mov    %rsp,%rbp
  800ea3:	48 83 ec 28          	sub    $0x28,%rsp
  800ea7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800eaf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800eb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ebb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ec2:	00 
  800ec3:	eb 2a                	jmp    800eef <strncpy+0x50>
		*dst++ = *src;
  800ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ecd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ed1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ed5:	0f b6 12             	movzbl (%rdx),%edx
  800ed8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ede:	0f b6 00             	movzbl (%rax),%eax
  800ee1:	84 c0                	test   %al,%al
  800ee3:	74 05                	je     800eea <strncpy+0x4b>
			src++;
  800ee5:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eea:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800eef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ef3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ef7:	72 cc                	jb     800ec5 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800efd:	c9                   	leaveq 
  800efe:	c3                   	retq   

0000000000800eff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800eff:	55                   	push   %rbp
  800f00:	48 89 e5             	mov    %rsp,%rbp
  800f03:	48 83 ec 28          	sub    $0x28,%rsp
  800f07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f0f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f1b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f20:	74 3d                	je     800f5f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f22:	eb 1d                	jmp    800f41 <strlcpy+0x42>
			*dst++ = *src++;
  800f24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f28:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f2c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f30:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f34:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f38:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f3c:	0f b6 12             	movzbl (%rdx),%edx
  800f3f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f41:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f46:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f4b:	74 0b                	je     800f58 <strlcpy+0x59>
  800f4d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f51:	0f b6 00             	movzbl (%rax),%eax
  800f54:	84 c0                	test   %al,%al
  800f56:	75 cc                	jne    800f24 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f5f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f67:	48 29 c2             	sub    %rax,%rdx
  800f6a:	48 89 d0             	mov    %rdx,%rax
}
  800f6d:	c9                   	leaveq 
  800f6e:	c3                   	retq   

0000000000800f6f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f6f:	55                   	push   %rbp
  800f70:	48 89 e5             	mov    %rsp,%rbp
  800f73:	48 83 ec 10          	sub    $0x10,%rsp
  800f77:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f7b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f7f:	eb 0a                	jmp    800f8b <strcmp+0x1c>
		p++, q++;
  800f81:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f86:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f8f:	0f b6 00             	movzbl (%rax),%eax
  800f92:	84 c0                	test   %al,%al
  800f94:	74 12                	je     800fa8 <strcmp+0x39>
  800f96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f9a:	0f b6 10             	movzbl (%rax),%edx
  800f9d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fa1:	0f b6 00             	movzbl (%rax),%eax
  800fa4:	38 c2                	cmp    %al,%dl
  800fa6:	74 d9                	je     800f81 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fac:	0f b6 00             	movzbl (%rax),%eax
  800faf:	0f b6 d0             	movzbl %al,%edx
  800fb2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb6:	0f b6 00             	movzbl (%rax),%eax
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
}
  800fc0:	c9                   	leaveq 
  800fc1:	c3                   	retq   

0000000000800fc2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fc2:	55                   	push   %rbp
  800fc3:	48 89 e5             	mov    %rsp,%rbp
  800fc6:	48 83 ec 18          	sub    $0x18,%rsp
  800fca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fd2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fd6:	eb 0f                	jmp    800fe7 <strncmp+0x25>
		n--, p++, q++;
  800fd8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fdd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fe2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fe7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fec:	74 1d                	je     80100b <strncmp+0x49>
  800fee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff2:	0f b6 00             	movzbl (%rax),%eax
  800ff5:	84 c0                	test   %al,%al
  800ff7:	74 12                	je     80100b <strncmp+0x49>
  800ff9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ffd:	0f b6 10             	movzbl (%rax),%edx
  801000:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801004:	0f b6 00             	movzbl (%rax),%eax
  801007:	38 c2                	cmp    %al,%dl
  801009:	74 cd                	je     800fd8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80100b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801010:	75 07                	jne    801019 <strncmp+0x57>
		return 0;
  801012:	b8 00 00 00 00       	mov    $0x0,%eax
  801017:	eb 18                	jmp    801031 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801019:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101d:	0f b6 00             	movzbl (%rax),%eax
  801020:	0f b6 d0             	movzbl %al,%edx
  801023:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801027:	0f b6 00             	movzbl (%rax),%eax
  80102a:	0f b6 c0             	movzbl %al,%eax
  80102d:	29 c2                	sub    %eax,%edx
  80102f:	89 d0                	mov    %edx,%eax
}
  801031:	c9                   	leaveq 
  801032:	c3                   	retq   

0000000000801033 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801033:	55                   	push   %rbp
  801034:	48 89 e5             	mov    %rsp,%rbp
  801037:	48 83 ec 0c          	sub    $0xc,%rsp
  80103b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80103f:	89 f0                	mov    %esi,%eax
  801041:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801044:	eb 17                	jmp    80105d <strchr+0x2a>
		if (*s == c)
  801046:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104a:	0f b6 00             	movzbl (%rax),%eax
  80104d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801050:	75 06                	jne    801058 <strchr+0x25>
			return (char *) s;
  801052:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801056:	eb 15                	jmp    80106d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801058:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80105d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801061:	0f b6 00             	movzbl (%rax),%eax
  801064:	84 c0                	test   %al,%al
  801066:	75 de                	jne    801046 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801068:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106d:	c9                   	leaveq 
  80106e:	c3                   	retq   

000000000080106f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80106f:	55                   	push   %rbp
  801070:	48 89 e5             	mov    %rsp,%rbp
  801073:	48 83 ec 0c          	sub    $0xc,%rsp
  801077:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80107b:	89 f0                	mov    %esi,%eax
  80107d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801080:	eb 13                	jmp    801095 <strfind+0x26>
		if (*s == c)
  801082:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801086:	0f b6 00             	movzbl (%rax),%eax
  801089:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80108c:	75 02                	jne    801090 <strfind+0x21>
			break;
  80108e:	eb 10                	jmp    8010a0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801090:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801095:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801099:	0f b6 00             	movzbl (%rax),%eax
  80109c:	84 c0                	test   %al,%al
  80109e:	75 e2                	jne    801082 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010a4:	c9                   	leaveq 
  8010a5:	c3                   	retq   

00000000008010a6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010a6:	55                   	push   %rbp
  8010a7:	48 89 e5             	mov    %rsp,%rbp
  8010aa:	48 83 ec 18          	sub    $0x18,%rsp
  8010ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010b2:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010b9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010be:	75 06                	jne    8010c6 <memset+0x20>
		return v;
  8010c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c4:	eb 69                	jmp    80112f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ca:	83 e0 03             	and    $0x3,%eax
  8010cd:	48 85 c0             	test   %rax,%rax
  8010d0:	75 48                	jne    80111a <memset+0x74>
  8010d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d6:	83 e0 03             	and    $0x3,%eax
  8010d9:	48 85 c0             	test   %rax,%rax
  8010dc:	75 3c                	jne    80111a <memset+0x74>
		c &= 0xFF;
  8010de:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e8:	c1 e0 18             	shl    $0x18,%eax
  8010eb:	89 c2                	mov    %eax,%edx
  8010ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f0:	c1 e0 10             	shl    $0x10,%eax
  8010f3:	09 c2                	or     %eax,%edx
  8010f5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f8:	c1 e0 08             	shl    $0x8,%eax
  8010fb:	09 d0                	or     %edx,%eax
  8010fd:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801100:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801104:	48 c1 e8 02          	shr    $0x2,%rax
  801108:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80110b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80110f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801112:	48 89 d7             	mov    %rdx,%rdi
  801115:	fc                   	cld    
  801116:	f3 ab                	rep stos %eax,%es:(%rdi)
  801118:	eb 11                	jmp    80112b <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80111a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80111e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801121:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801125:	48 89 d7             	mov    %rdx,%rdi
  801128:	fc                   	cld    
  801129:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80112b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80112f:	c9                   	leaveq 
  801130:	c3                   	retq   

0000000000801131 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801131:	55                   	push   %rbp
  801132:	48 89 e5             	mov    %rsp,%rbp
  801135:	48 83 ec 28          	sub    $0x28,%rsp
  801139:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801141:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801145:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801149:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80114d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801151:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801155:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801159:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80115d:	0f 83 88 00 00 00    	jae    8011eb <memmove+0xba>
  801163:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801167:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80116b:	48 01 d0             	add    %rdx,%rax
  80116e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801172:	76 77                	jbe    8011eb <memmove+0xba>
		s += n;
  801174:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801178:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80117c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801180:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801184:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801188:	83 e0 03             	and    $0x3,%eax
  80118b:	48 85 c0             	test   %rax,%rax
  80118e:	75 3b                	jne    8011cb <memmove+0x9a>
  801190:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801194:	83 e0 03             	and    $0x3,%eax
  801197:	48 85 c0             	test   %rax,%rax
  80119a:	75 2f                	jne    8011cb <memmove+0x9a>
  80119c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a0:	83 e0 03             	and    $0x3,%eax
  8011a3:	48 85 c0             	test   %rax,%rax
  8011a6:	75 23                	jne    8011cb <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ac:	48 83 e8 04          	sub    $0x4,%rax
  8011b0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011b4:	48 83 ea 04          	sub    $0x4,%rdx
  8011b8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011bc:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011c0:	48 89 c7             	mov    %rax,%rdi
  8011c3:	48 89 d6             	mov    %rdx,%rsi
  8011c6:	fd                   	std    
  8011c7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011c9:	eb 1d                	jmp    8011e8 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cf:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011df:	48 89 d7             	mov    %rdx,%rdi
  8011e2:	48 89 c1             	mov    %rax,%rcx
  8011e5:	fd                   	std    
  8011e6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011e8:	fc                   	cld    
  8011e9:	eb 57                	jmp    801242 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ef:	83 e0 03             	and    $0x3,%eax
  8011f2:	48 85 c0             	test   %rax,%rax
  8011f5:	75 36                	jne    80122d <memmove+0xfc>
  8011f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fb:	83 e0 03             	and    $0x3,%eax
  8011fe:	48 85 c0             	test   %rax,%rax
  801201:	75 2a                	jne    80122d <memmove+0xfc>
  801203:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801207:	83 e0 03             	and    $0x3,%eax
  80120a:	48 85 c0             	test   %rax,%rax
  80120d:	75 1e                	jne    80122d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80120f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801213:	48 c1 e8 02          	shr    $0x2,%rax
  801217:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80121a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801222:	48 89 c7             	mov    %rax,%rdi
  801225:	48 89 d6             	mov    %rdx,%rsi
  801228:	fc                   	cld    
  801229:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80122b:	eb 15                	jmp    801242 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80122d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801231:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801235:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801239:	48 89 c7             	mov    %rax,%rdi
  80123c:	48 89 d6             	mov    %rdx,%rsi
  80123f:	fc                   	cld    
  801240:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801246:	c9                   	leaveq 
  801247:	c3                   	retq   

0000000000801248 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801248:	55                   	push   %rbp
  801249:	48 89 e5             	mov    %rsp,%rbp
  80124c:	48 83 ec 18          	sub    $0x18,%rsp
  801250:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801254:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801258:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80125c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801260:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801264:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801268:	48 89 ce             	mov    %rcx,%rsi
  80126b:	48 89 c7             	mov    %rax,%rdi
  80126e:	48 b8 31 11 80 00 00 	movabs $0x801131,%rax
  801275:	00 00 00 
  801278:	ff d0                	callq  *%rax
}
  80127a:	c9                   	leaveq 
  80127b:	c3                   	retq   

000000000080127c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80127c:	55                   	push   %rbp
  80127d:	48 89 e5             	mov    %rsp,%rbp
  801280:	48 83 ec 28          	sub    $0x28,%rsp
  801284:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801288:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80128c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801290:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801294:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801298:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80129c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012a0:	eb 36                	jmp    8012d8 <memcmp+0x5c>
		if (*s1 != *s2)
  8012a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a6:	0f b6 10             	movzbl (%rax),%edx
  8012a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ad:	0f b6 00             	movzbl (%rax),%eax
  8012b0:	38 c2                	cmp    %al,%dl
  8012b2:	74 1a                	je     8012ce <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b8:	0f b6 00             	movzbl (%rax),%eax
  8012bb:	0f b6 d0             	movzbl %al,%edx
  8012be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c2:	0f b6 00             	movzbl (%rax),%eax
  8012c5:	0f b6 c0             	movzbl %al,%eax
  8012c8:	29 c2                	sub    %eax,%edx
  8012ca:	89 d0                	mov    %edx,%eax
  8012cc:	eb 20                	jmp    8012ee <memcmp+0x72>
		s1++, s2++;
  8012ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012dc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012e0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012e4:	48 85 c0             	test   %rax,%rax
  8012e7:	75 b9                	jne    8012a2 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ee:	c9                   	leaveq 
  8012ef:	c3                   	retq   

00000000008012f0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012f0:	55                   	push   %rbp
  8012f1:	48 89 e5             	mov    %rsp,%rbp
  8012f4:	48 83 ec 28          	sub    $0x28,%rsp
  8012f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012fc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801303:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801307:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80130b:	48 01 d0             	add    %rdx,%rax
  80130e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801312:	eb 15                	jmp    801329 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801314:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801318:	0f b6 10             	movzbl (%rax),%edx
  80131b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80131e:	38 c2                	cmp    %al,%dl
  801320:	75 02                	jne    801324 <memfind+0x34>
			break;
  801322:	eb 0f                	jmp    801333 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801324:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801331:	72 e1                	jb     801314 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801333:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801337:	c9                   	leaveq 
  801338:	c3                   	retq   

0000000000801339 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801339:	55                   	push   %rbp
  80133a:	48 89 e5             	mov    %rsp,%rbp
  80133d:	48 83 ec 34          	sub    $0x34,%rsp
  801341:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801345:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801349:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80134c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801353:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80135a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135b:	eb 05                	jmp    801362 <strtol+0x29>
		s++;
  80135d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801362:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801366:	0f b6 00             	movzbl (%rax),%eax
  801369:	3c 20                	cmp    $0x20,%al
  80136b:	74 f0                	je     80135d <strtol+0x24>
  80136d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801371:	0f b6 00             	movzbl (%rax),%eax
  801374:	3c 09                	cmp    $0x9,%al
  801376:	74 e5                	je     80135d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801378:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137c:	0f b6 00             	movzbl (%rax),%eax
  80137f:	3c 2b                	cmp    $0x2b,%al
  801381:	75 07                	jne    80138a <strtol+0x51>
		s++;
  801383:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801388:	eb 17                	jmp    8013a1 <strtol+0x68>
	else if (*s == '-')
  80138a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138e:	0f b6 00             	movzbl (%rax),%eax
  801391:	3c 2d                	cmp    $0x2d,%al
  801393:	75 0c                	jne    8013a1 <strtol+0x68>
		s++, neg = 1;
  801395:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80139a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013a1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013a5:	74 06                	je     8013ad <strtol+0x74>
  8013a7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013ab:	75 28                	jne    8013d5 <strtol+0x9c>
  8013ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b1:	0f b6 00             	movzbl (%rax),%eax
  8013b4:	3c 30                	cmp    $0x30,%al
  8013b6:	75 1d                	jne    8013d5 <strtol+0x9c>
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	48 83 c0 01          	add    $0x1,%rax
  8013c0:	0f b6 00             	movzbl (%rax),%eax
  8013c3:	3c 78                	cmp    $0x78,%al
  8013c5:	75 0e                	jne    8013d5 <strtol+0x9c>
		s += 2, base = 16;
  8013c7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013cc:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013d3:	eb 2c                	jmp    801401 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013d5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013d9:	75 19                	jne    8013f4 <strtol+0xbb>
  8013db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013df:	0f b6 00             	movzbl (%rax),%eax
  8013e2:	3c 30                	cmp    $0x30,%al
  8013e4:	75 0e                	jne    8013f4 <strtol+0xbb>
		s++, base = 8;
  8013e6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013eb:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013f2:	eb 0d                	jmp    801401 <strtol+0xc8>
	else if (base == 0)
  8013f4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013f8:	75 07                	jne    801401 <strtol+0xc8>
		base = 10;
  8013fa:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801401:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801405:	0f b6 00             	movzbl (%rax),%eax
  801408:	3c 2f                	cmp    $0x2f,%al
  80140a:	7e 1d                	jle    801429 <strtol+0xf0>
  80140c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801410:	0f b6 00             	movzbl (%rax),%eax
  801413:	3c 39                	cmp    $0x39,%al
  801415:	7f 12                	jg     801429 <strtol+0xf0>
			dig = *s - '0';
  801417:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141b:	0f b6 00             	movzbl (%rax),%eax
  80141e:	0f be c0             	movsbl %al,%eax
  801421:	83 e8 30             	sub    $0x30,%eax
  801424:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801427:	eb 4e                	jmp    801477 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801429:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	3c 60                	cmp    $0x60,%al
  801432:	7e 1d                	jle    801451 <strtol+0x118>
  801434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801438:	0f b6 00             	movzbl (%rax),%eax
  80143b:	3c 7a                	cmp    $0x7a,%al
  80143d:	7f 12                	jg     801451 <strtol+0x118>
			dig = *s - 'a' + 10;
  80143f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801443:	0f b6 00             	movzbl (%rax),%eax
  801446:	0f be c0             	movsbl %al,%eax
  801449:	83 e8 57             	sub    $0x57,%eax
  80144c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80144f:	eb 26                	jmp    801477 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	3c 40                	cmp    $0x40,%al
  80145a:	7e 48                	jle    8014a4 <strtol+0x16b>
  80145c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801460:	0f b6 00             	movzbl (%rax),%eax
  801463:	3c 5a                	cmp    $0x5a,%al
  801465:	7f 3d                	jg     8014a4 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801467:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146b:	0f b6 00             	movzbl (%rax),%eax
  80146e:	0f be c0             	movsbl %al,%eax
  801471:	83 e8 37             	sub    $0x37,%eax
  801474:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801477:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80147a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80147d:	7c 02                	jl     801481 <strtol+0x148>
			break;
  80147f:	eb 23                	jmp    8014a4 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801481:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801486:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801489:	48 98                	cltq   
  80148b:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801490:	48 89 c2             	mov    %rax,%rdx
  801493:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801496:	48 98                	cltq   
  801498:	48 01 d0             	add    %rdx,%rax
  80149b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80149f:	e9 5d ff ff ff       	jmpq   801401 <strtol+0xc8>

	if (endptr)
  8014a4:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014a9:	74 0b                	je     8014b6 <strtol+0x17d>
		*endptr = (char *) s;
  8014ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014af:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014b3:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014ba:	74 09                	je     8014c5 <strtol+0x18c>
  8014bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c0:	48 f7 d8             	neg    %rax
  8014c3:	eb 04                	jmp    8014c9 <strtol+0x190>
  8014c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014c9:	c9                   	leaveq 
  8014ca:	c3                   	retq   

00000000008014cb <strstr>:

char * strstr(const char *in, const char *str)
{
  8014cb:	55                   	push   %rbp
  8014cc:	48 89 e5             	mov    %rsp,%rbp
  8014cf:	48 83 ec 30          	sub    $0x30,%rsp
  8014d3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014d7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8014db:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014df:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014e3:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014e7:	0f b6 00             	movzbl (%rax),%eax
  8014ea:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8014ed:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014f1:	75 06                	jne    8014f9 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8014f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f7:	eb 6b                	jmp    801564 <strstr+0x99>

    len = strlen(str);
  8014f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014fd:	48 89 c7             	mov    %rax,%rdi
  801500:	48 b8 a1 0d 80 00 00 	movabs $0x800da1,%rax
  801507:	00 00 00 
  80150a:	ff d0                	callq  *%rax
  80150c:	48 98                	cltq   
  80150e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801512:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801516:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80151a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80151e:	0f b6 00             	movzbl (%rax),%eax
  801521:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801524:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801528:	75 07                	jne    801531 <strstr+0x66>
                return (char *) 0;
  80152a:	b8 00 00 00 00       	mov    $0x0,%eax
  80152f:	eb 33                	jmp    801564 <strstr+0x99>
        } while (sc != c);
  801531:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801535:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801538:	75 d8                	jne    801512 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80153a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80153e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801546:	48 89 ce             	mov    %rcx,%rsi
  801549:	48 89 c7             	mov    %rax,%rdi
  80154c:	48 b8 c2 0f 80 00 00 	movabs $0x800fc2,%rax
  801553:	00 00 00 
  801556:	ff d0                	callq  *%rax
  801558:	85 c0                	test   %eax,%eax
  80155a:	75 b6                	jne    801512 <strstr+0x47>

    return (char *) (in - 1);
  80155c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801560:	48 83 e8 01          	sub    $0x1,%rax
}
  801564:	c9                   	leaveq 
  801565:	c3                   	retq   

0000000000801566 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801566:	55                   	push   %rbp
  801567:	48 89 e5             	mov    %rsp,%rbp
  80156a:	53                   	push   %rbx
  80156b:	48 83 ec 48          	sub    $0x48,%rsp
  80156f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801572:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801575:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801579:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80157d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801581:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801585:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801588:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80158c:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801590:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801594:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801598:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80159c:	4c 89 c3             	mov    %r8,%rbx
  80159f:	cd 30                	int    $0x30
  8015a1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015a9:	74 3e                	je     8015e9 <syscall+0x83>
  8015ab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015b0:	7e 37                	jle    8015e9 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015b9:	49 89 d0             	mov    %rdx,%r8
  8015bc:	89 c1                	mov    %eax,%ecx
  8015be:	48 ba 88 1e 80 00 00 	movabs $0x801e88,%rdx
  8015c5:	00 00 00 
  8015c8:	be 23 00 00 00       	mov    $0x23,%esi
  8015cd:	48 bf a5 1e 80 00 00 	movabs $0x801ea5,%rdi
  8015d4:	00 00 00 
  8015d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dc:	49 b9 5f 19 80 00 00 	movabs $0x80195f,%r9
  8015e3:	00 00 00 
  8015e6:	41 ff d1             	callq  *%r9

	return ret;
  8015e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015ed:	48 83 c4 48          	add    $0x48,%rsp
  8015f1:	5b                   	pop    %rbx
  8015f2:	5d                   	pop    %rbp
  8015f3:	c3                   	retq   

00000000008015f4 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015f4:	55                   	push   %rbp
  8015f5:	48 89 e5             	mov    %rsp,%rbp
  8015f8:	48 83 ec 20          	sub    $0x20,%rsp
  8015fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801600:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801604:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801608:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80160c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801613:	00 
  801614:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80161a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801620:	48 89 d1             	mov    %rdx,%rcx
  801623:	48 89 c2             	mov    %rax,%rdx
  801626:	be 00 00 00 00       	mov    $0x0,%esi
  80162b:	bf 00 00 00 00       	mov    $0x0,%edi
  801630:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  801637:	00 00 00 
  80163a:	ff d0                	callq  *%rax
}
  80163c:	c9                   	leaveq 
  80163d:	c3                   	retq   

000000000080163e <sys_cgetc>:

int
sys_cgetc(void)
{
  80163e:	55                   	push   %rbp
  80163f:	48 89 e5             	mov    %rsp,%rbp
  801642:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801646:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80164d:	00 
  80164e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801654:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80165a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80165f:	ba 00 00 00 00       	mov    $0x0,%edx
  801664:	be 00 00 00 00       	mov    $0x0,%esi
  801669:	bf 01 00 00 00       	mov    $0x1,%edi
  80166e:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  801675:	00 00 00 
  801678:	ff d0                	callq  *%rax
}
  80167a:	c9                   	leaveq 
  80167b:	c3                   	retq   

000000000080167c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80167c:	55                   	push   %rbp
  80167d:	48 89 e5             	mov    %rsp,%rbp
  801680:	48 83 ec 10          	sub    $0x10,%rsp
  801684:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801687:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80168a:	48 98                	cltq   
  80168c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801693:	00 
  801694:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80169a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016a5:	48 89 c2             	mov    %rax,%rdx
  8016a8:	be 01 00 00 00       	mov    $0x1,%esi
  8016ad:	bf 03 00 00 00       	mov    $0x3,%edi
  8016b2:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  8016b9:	00 00 00 
  8016bc:	ff d0                	callq  *%rax
}
  8016be:	c9                   	leaveq 
  8016bf:	c3                   	retq   

00000000008016c0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016c0:	55                   	push   %rbp
  8016c1:	48 89 e5             	mov    %rsp,%rbp
  8016c4:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016cf:	00 
  8016d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e6:	be 00 00 00 00       	mov    $0x0,%esi
  8016eb:	bf 02 00 00 00       	mov    $0x2,%edi
  8016f0:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  8016f7:	00 00 00 
  8016fa:	ff d0                	callq  *%rax
}
  8016fc:	c9                   	leaveq 
  8016fd:	c3                   	retq   

00000000008016fe <sys_yield>:

void
sys_yield(void)
{
  8016fe:	55                   	push   %rbp
  8016ff:	48 89 e5             	mov    %rsp,%rbp
  801702:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801706:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80170d:	00 
  80170e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801714:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80171a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80171f:	ba 00 00 00 00       	mov    $0x0,%edx
  801724:	be 00 00 00 00       	mov    $0x0,%esi
  801729:	bf 0a 00 00 00       	mov    $0xa,%edi
  80172e:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  801735:	00 00 00 
  801738:	ff d0                	callq  *%rax
}
  80173a:	c9                   	leaveq 
  80173b:	c3                   	retq   

000000000080173c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80173c:	55                   	push   %rbp
  80173d:	48 89 e5             	mov    %rsp,%rbp
  801740:	48 83 ec 20          	sub    $0x20,%rsp
  801744:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801747:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80174b:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80174e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801751:	48 63 c8             	movslq %eax,%rcx
  801754:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801758:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80175b:	48 98                	cltq   
  80175d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801764:	00 
  801765:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176b:	49 89 c8             	mov    %rcx,%r8
  80176e:	48 89 d1             	mov    %rdx,%rcx
  801771:	48 89 c2             	mov    %rax,%rdx
  801774:	be 01 00 00 00       	mov    $0x1,%esi
  801779:	bf 04 00 00 00       	mov    $0x4,%edi
  80177e:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  801785:	00 00 00 
  801788:	ff d0                	callq  *%rax
}
  80178a:	c9                   	leaveq 
  80178b:	c3                   	retq   

000000000080178c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80178c:	55                   	push   %rbp
  80178d:	48 89 e5             	mov    %rsp,%rbp
  801790:	48 83 ec 30          	sub    $0x30,%rsp
  801794:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801797:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80179b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80179e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017a2:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017a6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017a9:	48 63 c8             	movslq %eax,%rcx
  8017ac:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017b3:	48 63 f0             	movslq %eax,%rsi
  8017b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017bd:	48 98                	cltq   
  8017bf:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017c3:	49 89 f9             	mov    %rdi,%r9
  8017c6:	49 89 f0             	mov    %rsi,%r8
  8017c9:	48 89 d1             	mov    %rdx,%rcx
  8017cc:	48 89 c2             	mov    %rax,%rdx
  8017cf:	be 01 00 00 00       	mov    $0x1,%esi
  8017d4:	bf 05 00 00 00       	mov    $0x5,%edi
  8017d9:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  8017e0:	00 00 00 
  8017e3:	ff d0                	callq  *%rax
}
  8017e5:	c9                   	leaveq 
  8017e6:	c3                   	retq   

00000000008017e7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8017e7:	55                   	push   %rbp
  8017e8:	48 89 e5             	mov    %rsp,%rbp
  8017eb:	48 83 ec 20          	sub    $0x20,%rsp
  8017ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8017f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017fd:	48 98                	cltq   
  8017ff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801806:	00 
  801807:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80180d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801813:	48 89 d1             	mov    %rdx,%rcx
  801816:	48 89 c2             	mov    %rax,%rdx
  801819:	be 01 00 00 00       	mov    $0x1,%esi
  80181e:	bf 06 00 00 00       	mov    $0x6,%edi
  801823:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  80182a:	00 00 00 
  80182d:	ff d0                	callq  *%rax
}
  80182f:	c9                   	leaveq 
  801830:	c3                   	retq   

0000000000801831 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801831:	55                   	push   %rbp
  801832:	48 89 e5             	mov    %rsp,%rbp
  801835:	48 83 ec 10          	sub    $0x10,%rsp
  801839:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80183c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80183f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801842:	48 63 d0             	movslq %eax,%rdx
  801845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801848:	48 98                	cltq   
  80184a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801851:	00 
  801852:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801858:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80185e:	48 89 d1             	mov    %rdx,%rcx
  801861:	48 89 c2             	mov    %rax,%rdx
  801864:	be 01 00 00 00       	mov    $0x1,%esi
  801869:	bf 08 00 00 00       	mov    $0x8,%edi
  80186e:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  801875:	00 00 00 
  801878:	ff d0                	callq  *%rax
}
  80187a:	c9                   	leaveq 
  80187b:	c3                   	retq   

000000000080187c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80187c:	55                   	push   %rbp
  80187d:	48 89 e5             	mov    %rsp,%rbp
  801880:	48 83 ec 20          	sub    $0x20,%rsp
  801884:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801887:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80188b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80188f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801892:	48 98                	cltq   
  801894:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80189b:	00 
  80189c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018a8:	48 89 d1             	mov    %rdx,%rcx
  8018ab:	48 89 c2             	mov    %rax,%rdx
  8018ae:	be 01 00 00 00       	mov    $0x1,%esi
  8018b3:	bf 09 00 00 00       	mov    $0x9,%edi
  8018b8:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  8018bf:	00 00 00 
  8018c2:	ff d0                	callq  *%rax
}
  8018c4:	c9                   	leaveq 
  8018c5:	c3                   	retq   

00000000008018c6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8018c6:	55                   	push   %rbp
  8018c7:	48 89 e5             	mov    %rsp,%rbp
  8018ca:	48 83 ec 20          	sub    $0x20,%rsp
  8018ce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018d5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018d9:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8018dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018df:	48 63 f0             	movslq %eax,%rsi
  8018e2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8018e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e9:	48 98                	cltq   
  8018eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ef:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f6:	00 
  8018f7:	49 89 f1             	mov    %rsi,%r9
  8018fa:	49 89 c8             	mov    %rcx,%r8
  8018fd:	48 89 d1             	mov    %rdx,%rcx
  801900:	48 89 c2             	mov    %rax,%rdx
  801903:	be 00 00 00 00       	mov    $0x0,%esi
  801908:	bf 0b 00 00 00       	mov    $0xb,%edi
  80190d:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  801914:	00 00 00 
  801917:	ff d0                	callq  *%rax
}
  801919:	c9                   	leaveq 
  80191a:	c3                   	retq   

000000000080191b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80191b:	55                   	push   %rbp
  80191c:	48 89 e5             	mov    %rsp,%rbp
  80191f:	48 83 ec 10          	sub    $0x10,%rsp
  801923:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801927:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80192b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801932:	00 
  801933:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801939:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80193f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801944:	48 89 c2             	mov    %rax,%rdx
  801947:	be 01 00 00 00       	mov    $0x1,%esi
  80194c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801951:	48 b8 66 15 80 00 00 	movabs $0x801566,%rax
  801958:	00 00 00 
  80195b:	ff d0                	callq  *%rax
}
  80195d:	c9                   	leaveq 
  80195e:	c3                   	retq   

000000000080195f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80195f:	55                   	push   %rbp
  801960:	48 89 e5             	mov    %rsp,%rbp
  801963:	53                   	push   %rbx
  801964:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80196b:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801972:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801978:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80197f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801986:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80198d:	84 c0                	test   %al,%al
  80198f:	74 23                	je     8019b4 <_panic+0x55>
  801991:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801998:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80199c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8019a0:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8019a4:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8019a8:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8019ac:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8019b0:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8019b4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8019bb:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8019c2:	00 00 00 
  8019c5:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8019cc:	00 00 00 
  8019cf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019d3:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8019da:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8019e1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8019e8:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8019ef:	00 00 00 
  8019f2:	48 8b 18             	mov    (%rax),%rbx
  8019f5:	48 b8 c0 16 80 00 00 	movabs $0x8016c0,%rax
  8019fc:	00 00 00 
  8019ff:	ff d0                	callq  *%rax
  801a01:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801a07:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801a0e:	41 89 c8             	mov    %ecx,%r8d
  801a11:	48 89 d1             	mov    %rdx,%rcx
  801a14:	48 89 da             	mov    %rbx,%rdx
  801a17:	89 c6                	mov    %eax,%esi
  801a19:	48 bf b8 1e 80 00 00 	movabs $0x801eb8,%rdi
  801a20:	00 00 00 
  801a23:	b8 00 00 00 00       	mov    $0x0,%eax
  801a28:	49 b9 58 02 80 00 00 	movabs $0x800258,%r9
  801a2f:	00 00 00 
  801a32:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a35:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801a3c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a43:	48 89 d6             	mov    %rdx,%rsi
  801a46:	48 89 c7             	mov    %rax,%rdi
  801a49:	48 b8 ac 01 80 00 00 	movabs $0x8001ac,%rax
  801a50:	00 00 00 
  801a53:	ff d0                	callq  *%rax
	cprintf("\n");
  801a55:	48 bf db 1e 80 00 00 	movabs $0x801edb,%rdi
  801a5c:	00 00 00 
  801a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a64:	48 ba 58 02 80 00 00 	movabs $0x800258,%rdx
  801a6b:	00 00 00 
  801a6e:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a70:	cc                   	int3   
  801a71:	eb fd                	jmp    801a70 <_panic+0x111>
