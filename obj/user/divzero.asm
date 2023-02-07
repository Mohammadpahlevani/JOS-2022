
obj/user/divzero:     file format elf64-x86-64


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
  80003c:	e8 54 00 00 00       	callq  800095 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	zero = 0;
  800052:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800059:	00 00 00 
  80005c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	cprintf("1/0 is %08x!\n", 1/zero);
  800062:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800069:	00 00 00 
  80006c:	8b 08                	mov    (%rax),%ecx
  80006e:	b8 01 00 00 00       	mov    $0x1,%eax
  800073:	99                   	cltd   
  800074:	f7 f9                	idiv   %ecx
  800076:	89 c6                	mov    %eax,%esi
  800078:	48 bf a0 1a 80 00 00 	movabs $0x801aa0,%rdi
  80007f:	00 00 00 
  800082:	b8 00 00 00 00       	mov    $0x0,%eax
  800087:	48 ba 75 02 80 00 00 	movabs $0x800275,%rdx
  80008e:	00 00 00 
  800091:	ff d2                	callq  *%rdx
}
  800093:	c9                   	leaveq 
  800094:	c3                   	retq   

0000000000800095 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800095:	55                   	push   %rbp
  800096:	48 89 e5             	mov    %rsp,%rbp
  800099:	48 83 ec 20          	sub    $0x20,%rsp
  80009d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8000a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000a4:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8000ab:	00 00 00 
  8000ae:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  8000b5:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  8000bc:	00 00 00 
  8000bf:	ff d0                	callq  *%rax
  8000c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  8000c4:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  8000cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000ce:	48 63 d0             	movslq %eax,%rdx
  8000d1:	48 89 d0             	mov    %rdx,%rax
  8000d4:	48 c1 e0 03          	shl    $0x3,%rax
  8000d8:	48 01 d0             	add    %rdx,%rax
  8000db:	48 c1 e0 05          	shl    $0x5,%rax
  8000df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8000e6:	00 00 00 
  8000e9:	48 01 c2             	add    %rax,%rdx
  8000ec:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8000f3:	00 00 00 
  8000f6:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000fd:	7e 14                	jle    800113 <libmain+0x7e>
		binaryname = argv[0];
  8000ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800103:	48 8b 10             	mov    (%rax),%rdx
  800106:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80010d:	00 00 00 
  800110:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800113:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800117:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80011a:	48 89 d6             	mov    %rdx,%rsi
  80011d:	89 c7                	mov    %eax,%edi
  80011f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800126:	00 00 00 
  800129:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  80012b:	48 b8 39 01 80 00 00 	movabs $0x800139,%rax
  800132:	00 00 00 
  800135:	ff d0                	callq  *%rax
}
  800137:	c9                   	leaveq 
  800138:	c3                   	retq   

0000000000800139 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800139:	55                   	push   %rbp
  80013a:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80013d:	bf 00 00 00 00       	mov    $0x0,%edi
  800142:	48 b8 99 16 80 00 00 	movabs $0x801699,%rax
  800149:	00 00 00 
  80014c:	ff d0                	callq  *%rax
}
  80014e:	5d                   	pop    %rbp
  80014f:	c3                   	retq   

0000000000800150 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800150:	55                   	push   %rbp
  800151:	48 89 e5             	mov    %rsp,%rbp
  800154:	48 83 ec 10          	sub    $0x10,%rsp
  800158:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  80015f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800163:	8b 00                	mov    (%rax),%eax
  800165:	8d 48 01             	lea    0x1(%rax),%ecx
  800168:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016c:	89 0a                	mov    %ecx,(%rdx)
  80016e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800171:	89 d1                	mov    %edx,%ecx
  800173:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800177:	48 98                	cltq   
  800179:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80017d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800181:	8b 00                	mov    (%rax),%eax
  800183:	3d ff 00 00 00       	cmp    $0xff,%eax
  800188:	75 2c                	jne    8001b6 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80018a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018e:	8b 00                	mov    (%rax),%eax
  800190:	48 98                	cltq   
  800192:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800196:	48 83 c2 08          	add    $0x8,%rdx
  80019a:	48 89 c6             	mov    %rax,%rsi
  80019d:	48 89 d7             	mov    %rdx,%rdi
  8001a0:	48 b8 11 16 80 00 00 	movabs $0x801611,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
		b->idx = 0;
  8001ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  8001b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ba:	8b 40 04             	mov    0x4(%rax),%eax
  8001bd:	8d 50 01             	lea    0x1(%rax),%edx
  8001c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c4:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001c7:	c9                   	leaveq 
  8001c8:	c3                   	retq   

00000000008001c9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c9:	55                   	push   %rbp
  8001ca:	48 89 e5             	mov    %rsp,%rbp
  8001cd:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001d4:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001db:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8001e2:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001e9:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001f0:	48 8b 0a             	mov    (%rdx),%rcx
  8001f3:	48 89 08             	mov    %rcx,(%rax)
  8001f6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001fa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001fe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800202:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  800206:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80020d:	00 00 00 
	b.cnt = 0;
  800210:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800217:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  80021a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800221:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800228:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80022f:	48 89 c6             	mov    %rax,%rsi
  800232:	48 bf 50 01 80 00 00 	movabs $0x800150,%rdi
  800239:	00 00 00 
  80023c:	48 b8 28 06 80 00 00 	movabs $0x800628,%rax
  800243:	00 00 00 
  800246:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  800248:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80024e:	48 98                	cltq   
  800250:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800257:	48 83 c2 08          	add    $0x8,%rdx
  80025b:	48 89 c6             	mov    %rax,%rsi
  80025e:	48 89 d7             	mov    %rdx,%rdi
  800261:	48 b8 11 16 80 00 00 	movabs $0x801611,%rax
  800268:	00 00 00 
  80026b:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80026d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800273:	c9                   	leaveq 
  800274:	c3                   	retq   

0000000000800275 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800275:	55                   	push   %rbp
  800276:	48 89 e5             	mov    %rsp,%rbp
  800279:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800280:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800287:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80028e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800295:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80029c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002a3:	84 c0                	test   %al,%al
  8002a5:	74 20                	je     8002c7 <cprintf+0x52>
  8002a7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002ab:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002af:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002b3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002b7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002bb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002bf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002c3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002c7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8002ce:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002d5:	00 00 00 
  8002d8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002df:	00 00 00 
  8002e2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002ed:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002f4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8002fb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800302:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800309:	48 8b 0a             	mov    (%rdx),%rcx
  80030c:	48 89 08             	mov    %rcx,(%rax)
  80030f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800313:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800317:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80031b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  80031f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800326:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80032d:	48 89 d6             	mov    %rdx,%rsi
  800330:	48 89 c7             	mov    %rax,%rdi
  800333:	48 b8 c9 01 80 00 00 	movabs $0x8001c9,%rax
  80033a:	00 00 00 
  80033d:	ff d0                	callq  *%rax
  80033f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  800345:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80034b:	c9                   	leaveq 
  80034c:	c3                   	retq   

000000000080034d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034d:	55                   	push   %rbp
  80034e:	48 89 e5             	mov    %rsp,%rbp
  800351:	53                   	push   %rbx
  800352:	48 83 ec 38          	sub    $0x38,%rsp
  800356:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80035a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80035e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800362:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800365:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800369:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80036d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800370:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800374:	77 3b                	ja     8003b1 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800376:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800379:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80037d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800380:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800384:	ba 00 00 00 00       	mov    $0x0,%edx
  800389:	48 f7 f3             	div    %rbx
  80038c:	48 89 c2             	mov    %rax,%rdx
  80038f:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800392:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800395:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800399:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80039d:	41 89 f9             	mov    %edi,%r9d
  8003a0:	48 89 c7             	mov    %rax,%rdi
  8003a3:	48 b8 4d 03 80 00 00 	movabs $0x80034d,%rax
  8003aa:	00 00 00 
  8003ad:	ff d0                	callq  *%rax
  8003af:	eb 1e                	jmp    8003cf <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b1:	eb 12                	jmp    8003c5 <printnum+0x78>
			putch(padc, putdat);
  8003b3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003b7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003be:	48 89 ce             	mov    %rcx,%rsi
  8003c1:	89 d7                	mov    %edx,%edi
  8003c3:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c5:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003c9:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003cd:	7f e4                	jg     8003b3 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cf:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003db:	48 f7 f1             	div    %rcx
  8003de:	48 89 d0             	mov    %rdx,%rax
  8003e1:	48 ba b0 1b 80 00 00 	movabs $0x801bb0,%rdx
  8003e8:	00 00 00 
  8003eb:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003ef:	0f be d0             	movsbl %al,%edx
  8003f2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fa:	48 89 ce             	mov    %rcx,%rsi
  8003fd:	89 d7                	mov    %edx,%edi
  8003ff:	ff d0                	callq  *%rax
}
  800401:	48 83 c4 38          	add    $0x38,%rsp
  800405:	5b                   	pop    %rbx
  800406:	5d                   	pop    %rbp
  800407:	c3                   	retq   

0000000000800408 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800408:	55                   	push   %rbp
  800409:	48 89 e5             	mov    %rsp,%rbp
  80040c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800410:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800414:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800417:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80041b:	7e 52                	jle    80046f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80041d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800421:	8b 00                	mov    (%rax),%eax
  800423:	83 f8 30             	cmp    $0x30,%eax
  800426:	73 24                	jae    80044c <getuint+0x44>
  800428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800434:	8b 00                	mov    (%rax),%eax
  800436:	89 c0                	mov    %eax,%eax
  800438:	48 01 d0             	add    %rdx,%rax
  80043b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80043f:	8b 12                	mov    (%rdx),%edx
  800441:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800444:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800448:	89 0a                	mov    %ecx,(%rdx)
  80044a:	eb 17                	jmp    800463 <getuint+0x5b>
  80044c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800450:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800454:	48 89 d0             	mov    %rdx,%rax
  800457:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80045b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80045f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800463:	48 8b 00             	mov    (%rax),%rax
  800466:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80046a:	e9 a3 00 00 00       	jmpq   800512 <getuint+0x10a>
	else if (lflag)
  80046f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800473:	74 4f                	je     8004c4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800475:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800479:	8b 00                	mov    (%rax),%eax
  80047b:	83 f8 30             	cmp    $0x30,%eax
  80047e:	73 24                	jae    8004a4 <getuint+0x9c>
  800480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800484:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800488:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048c:	8b 00                	mov    (%rax),%eax
  80048e:	89 c0                	mov    %eax,%eax
  800490:	48 01 d0             	add    %rdx,%rax
  800493:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800497:	8b 12                	mov    (%rdx),%edx
  800499:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80049c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a0:	89 0a                	mov    %ecx,(%rdx)
  8004a2:	eb 17                	jmp    8004bb <getuint+0xb3>
  8004a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004ac:	48 89 d0             	mov    %rdx,%rax
  8004af:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004bb:	48 8b 00             	mov    (%rax),%rax
  8004be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004c2:	eb 4e                	jmp    800512 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c8:	8b 00                	mov    (%rax),%eax
  8004ca:	83 f8 30             	cmp    $0x30,%eax
  8004cd:	73 24                	jae    8004f3 <getuint+0xeb>
  8004cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004db:	8b 00                	mov    (%rax),%eax
  8004dd:	89 c0                	mov    %eax,%eax
  8004df:	48 01 d0             	add    %rdx,%rax
  8004e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e6:	8b 12                	mov    (%rdx),%edx
  8004e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ef:	89 0a                	mov    %ecx,(%rdx)
  8004f1:	eb 17                	jmp    80050a <getuint+0x102>
  8004f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004fb:	48 89 d0             	mov    %rdx,%rax
  8004fe:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800502:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800506:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80050a:	8b 00                	mov    (%rax),%eax
  80050c:	89 c0                	mov    %eax,%eax
  80050e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800516:	c9                   	leaveq 
  800517:	c3                   	retq   

0000000000800518 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800518:	55                   	push   %rbp
  800519:	48 89 e5             	mov    %rsp,%rbp
  80051c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800520:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800524:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800527:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80052b:	7e 52                	jle    80057f <getint+0x67>
		x=va_arg(*ap, long long);
  80052d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800531:	8b 00                	mov    (%rax),%eax
  800533:	83 f8 30             	cmp    $0x30,%eax
  800536:	73 24                	jae    80055c <getint+0x44>
  800538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800544:	8b 00                	mov    (%rax),%eax
  800546:	89 c0                	mov    %eax,%eax
  800548:	48 01 d0             	add    %rdx,%rax
  80054b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054f:	8b 12                	mov    (%rdx),%edx
  800551:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800554:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800558:	89 0a                	mov    %ecx,(%rdx)
  80055a:	eb 17                	jmp    800573 <getint+0x5b>
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800564:	48 89 d0             	mov    %rdx,%rax
  800567:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80056b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800573:	48 8b 00             	mov    (%rax),%rax
  800576:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80057a:	e9 a3 00 00 00       	jmpq   800622 <getint+0x10a>
	else if (lflag)
  80057f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800583:	74 4f                	je     8005d4 <getint+0xbc>
		x=va_arg(*ap, long);
  800585:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800589:	8b 00                	mov    (%rax),%eax
  80058b:	83 f8 30             	cmp    $0x30,%eax
  80058e:	73 24                	jae    8005b4 <getint+0x9c>
  800590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800594:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059c:	8b 00                	mov    (%rax),%eax
  80059e:	89 c0                	mov    %eax,%eax
  8005a0:	48 01 d0             	add    %rdx,%rax
  8005a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a7:	8b 12                	mov    (%rdx),%edx
  8005a9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b0:	89 0a                	mov    %ecx,(%rdx)
  8005b2:	eb 17                	jmp    8005cb <getint+0xb3>
  8005b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005bc:	48 89 d0             	mov    %rdx,%rax
  8005bf:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005cb:	48 8b 00             	mov    (%rax),%rax
  8005ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005d2:	eb 4e                	jmp    800622 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d8:	8b 00                	mov    (%rax),%eax
  8005da:	83 f8 30             	cmp    $0x30,%eax
  8005dd:	73 24                	jae    800603 <getint+0xeb>
  8005df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005eb:	8b 00                	mov    (%rax),%eax
  8005ed:	89 c0                	mov    %eax,%eax
  8005ef:	48 01 d0             	add    %rdx,%rax
  8005f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f6:	8b 12                	mov    (%rdx),%edx
  8005f8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ff:	89 0a                	mov    %ecx,(%rdx)
  800601:	eb 17                	jmp    80061a <getint+0x102>
  800603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800607:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060b:	48 89 d0             	mov    %rdx,%rax
  80060e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800612:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800616:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061a:	8b 00                	mov    (%rax),%eax
  80061c:	48 98                	cltq   
  80061e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800622:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800626:	c9                   	leaveq 
  800627:	c3                   	retq   

0000000000800628 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800628:	55                   	push   %rbp
  800629:	48 89 e5             	mov    %rsp,%rbp
  80062c:	41 54                	push   %r12
  80062e:	53                   	push   %rbx
  80062f:	48 83 ec 60          	sub    $0x60,%rsp
  800633:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800637:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80063b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80063f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800643:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800647:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80064b:	48 8b 0a             	mov    (%rdx),%rcx
  80064e:	48 89 08             	mov    %rcx,(%rax)
  800651:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800655:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800659:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80065d:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800661:	eb 17                	jmp    80067a <vprintfmt+0x52>
			if (ch == '\0')
  800663:	85 db                	test   %ebx,%ebx
  800665:	0f 84 cc 04 00 00    	je     800b37 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  80066b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80066f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800673:	48 89 d6             	mov    %rdx,%rsi
  800676:	89 df                	mov    %ebx,%edi
  800678:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80067a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80067e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800682:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800686:	0f b6 00             	movzbl (%rax),%eax
  800689:	0f b6 d8             	movzbl %al,%ebx
  80068c:	83 fb 25             	cmp    $0x25,%ebx
  80068f:	75 d2                	jne    800663 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800691:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800695:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80069c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006a3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006aa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006b9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006bd:	0f b6 00             	movzbl (%rax),%eax
  8006c0:	0f b6 d8             	movzbl %al,%ebx
  8006c3:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006c6:	83 f8 55             	cmp    $0x55,%eax
  8006c9:	0f 87 34 04 00 00    	ja     800b03 <vprintfmt+0x4db>
  8006cf:	89 c0                	mov    %eax,%eax
  8006d1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006d8:	00 
  8006d9:	48 b8 d8 1b 80 00 00 	movabs $0x801bd8,%rax
  8006e0:	00 00 00 
  8006e3:	48 01 d0             	add    %rdx,%rax
  8006e6:	48 8b 00             	mov    (%rax),%rax
  8006e9:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006eb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006ef:	eb c0                	jmp    8006b1 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006f1:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006f5:	eb ba                	jmp    8006b1 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006fe:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800701:	89 d0                	mov    %edx,%eax
  800703:	c1 e0 02             	shl    $0x2,%eax
  800706:	01 d0                	add    %edx,%eax
  800708:	01 c0                	add    %eax,%eax
  80070a:	01 d8                	add    %ebx,%eax
  80070c:	83 e8 30             	sub    $0x30,%eax
  80070f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800712:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800716:	0f b6 00             	movzbl (%rax),%eax
  800719:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80071c:	83 fb 2f             	cmp    $0x2f,%ebx
  80071f:	7e 0c                	jle    80072d <vprintfmt+0x105>
  800721:	83 fb 39             	cmp    $0x39,%ebx
  800724:	7f 07                	jg     80072d <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800726:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80072b:	eb d1                	jmp    8006fe <vprintfmt+0xd6>
			goto process_precision;
  80072d:	eb 58                	jmp    800787 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80072f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800732:	83 f8 30             	cmp    $0x30,%eax
  800735:	73 17                	jae    80074e <vprintfmt+0x126>
  800737:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80073b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80073e:	89 c0                	mov    %eax,%eax
  800740:	48 01 d0             	add    %rdx,%rax
  800743:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800746:	83 c2 08             	add    $0x8,%edx
  800749:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80074c:	eb 0f                	jmp    80075d <vprintfmt+0x135>
  80074e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800752:	48 89 d0             	mov    %rdx,%rax
  800755:	48 83 c2 08          	add    $0x8,%rdx
  800759:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80075d:	8b 00                	mov    (%rax),%eax
  80075f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800762:	eb 23                	jmp    800787 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800764:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800768:	79 0c                	jns    800776 <vprintfmt+0x14e>
				width = 0;
  80076a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800771:	e9 3b ff ff ff       	jmpq   8006b1 <vprintfmt+0x89>
  800776:	e9 36 ff ff ff       	jmpq   8006b1 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80077b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800782:	e9 2a ff ff ff       	jmpq   8006b1 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800787:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80078b:	79 12                	jns    80079f <vprintfmt+0x177>
				width = precision, precision = -1;
  80078d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800790:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800793:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80079a:	e9 12 ff ff ff       	jmpq   8006b1 <vprintfmt+0x89>
  80079f:	e9 0d ff ff ff       	jmpq   8006b1 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007a4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007a8:	e9 04 ff ff ff       	jmpq   8006b1 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  8007ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b0:	83 f8 30             	cmp    $0x30,%eax
  8007b3:	73 17                	jae    8007cc <vprintfmt+0x1a4>
  8007b5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007bc:	89 c0                	mov    %eax,%eax
  8007be:	48 01 d0             	add    %rdx,%rax
  8007c1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c4:	83 c2 08             	add    $0x8,%edx
  8007c7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ca:	eb 0f                	jmp    8007db <vprintfmt+0x1b3>
  8007cc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d0:	48 89 d0             	mov    %rdx,%rax
  8007d3:	48 83 c2 08          	add    $0x8,%rdx
  8007d7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007db:	8b 10                	mov    (%rax),%edx
  8007dd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007e1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007e5:	48 89 ce             	mov    %rcx,%rsi
  8007e8:	89 d7                	mov    %edx,%edi
  8007ea:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  8007ec:	e9 40 03 00 00       	jmpq   800b31 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8007f1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f4:	83 f8 30             	cmp    $0x30,%eax
  8007f7:	73 17                	jae    800810 <vprintfmt+0x1e8>
  8007f9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800800:	89 c0                	mov    %eax,%eax
  800802:	48 01 d0             	add    %rdx,%rax
  800805:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800808:	83 c2 08             	add    $0x8,%edx
  80080b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80080e:	eb 0f                	jmp    80081f <vprintfmt+0x1f7>
  800810:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800814:	48 89 d0             	mov    %rdx,%rax
  800817:	48 83 c2 08          	add    $0x8,%rdx
  80081b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80081f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800821:	85 db                	test   %ebx,%ebx
  800823:	79 02                	jns    800827 <vprintfmt+0x1ff>
				err = -err;
  800825:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800827:	83 fb 09             	cmp    $0x9,%ebx
  80082a:	7f 16                	jg     800842 <vprintfmt+0x21a>
  80082c:	48 b8 60 1b 80 00 00 	movabs $0x801b60,%rax
  800833:	00 00 00 
  800836:	48 63 d3             	movslq %ebx,%rdx
  800839:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80083d:	4d 85 e4             	test   %r12,%r12
  800840:	75 2e                	jne    800870 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800842:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800846:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80084a:	89 d9                	mov    %ebx,%ecx
  80084c:	48 ba c1 1b 80 00 00 	movabs $0x801bc1,%rdx
  800853:	00 00 00 
  800856:	48 89 c7             	mov    %rax,%rdi
  800859:	b8 00 00 00 00       	mov    $0x0,%eax
  80085e:	49 b8 40 0b 80 00 00 	movabs $0x800b40,%r8
  800865:	00 00 00 
  800868:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086b:	e9 c1 02 00 00       	jmpq   800b31 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800870:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800874:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800878:	4c 89 e1             	mov    %r12,%rcx
  80087b:	48 ba ca 1b 80 00 00 	movabs $0x801bca,%rdx
  800882:	00 00 00 
  800885:	48 89 c7             	mov    %rax,%rdi
  800888:	b8 00 00 00 00       	mov    $0x0,%eax
  80088d:	49 b8 40 0b 80 00 00 	movabs $0x800b40,%r8
  800894:	00 00 00 
  800897:	41 ff d0             	callq  *%r8
			break;
  80089a:	e9 92 02 00 00       	jmpq   800b31 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  80089f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a2:	83 f8 30             	cmp    $0x30,%eax
  8008a5:	73 17                	jae    8008be <vprintfmt+0x296>
  8008a7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008ab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ae:	89 c0                	mov    %eax,%eax
  8008b0:	48 01 d0             	add    %rdx,%rax
  8008b3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008b6:	83 c2 08             	add    $0x8,%edx
  8008b9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008bc:	eb 0f                	jmp    8008cd <vprintfmt+0x2a5>
  8008be:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c2:	48 89 d0             	mov    %rdx,%rax
  8008c5:	48 83 c2 08          	add    $0x8,%rdx
  8008c9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008cd:	4c 8b 20             	mov    (%rax),%r12
  8008d0:	4d 85 e4             	test   %r12,%r12
  8008d3:	75 0a                	jne    8008df <vprintfmt+0x2b7>
				p = "(null)";
  8008d5:	49 bc cd 1b 80 00 00 	movabs $0x801bcd,%r12
  8008dc:	00 00 00 
			if (width > 0 && padc != '-')
  8008df:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e3:	7e 3f                	jle    800924 <vprintfmt+0x2fc>
  8008e5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008e9:	74 39                	je     800924 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008eb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008ee:	48 98                	cltq   
  8008f0:	48 89 c6             	mov    %rax,%rsi
  8008f3:	4c 89 e7             	mov    %r12,%rdi
  8008f6:	48 b8 ec 0d 80 00 00 	movabs $0x800dec,%rax
  8008fd:	00 00 00 
  800900:	ff d0                	callq  *%rax
  800902:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800905:	eb 17                	jmp    80091e <vprintfmt+0x2f6>
					putch(padc, putdat);
  800907:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80090b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80090f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800913:	48 89 ce             	mov    %rcx,%rsi
  800916:	89 d7                	mov    %edx,%edi
  800918:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80091e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800922:	7f e3                	jg     800907 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800924:	eb 37                	jmp    80095d <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800926:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80092a:	74 1e                	je     80094a <vprintfmt+0x322>
  80092c:	83 fb 1f             	cmp    $0x1f,%ebx
  80092f:	7e 05                	jle    800936 <vprintfmt+0x30e>
  800931:	83 fb 7e             	cmp    $0x7e,%ebx
  800934:	7e 14                	jle    80094a <vprintfmt+0x322>
					putch('?', putdat);
  800936:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80093a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80093e:	48 89 d6             	mov    %rdx,%rsi
  800941:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800946:	ff d0                	callq  *%rax
  800948:	eb 0f                	jmp    800959 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80094a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80094e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800952:	48 89 d6             	mov    %rdx,%rsi
  800955:	89 df                	mov    %ebx,%edi
  800957:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800959:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80095d:	4c 89 e0             	mov    %r12,%rax
  800960:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800964:	0f b6 00             	movzbl (%rax),%eax
  800967:	0f be d8             	movsbl %al,%ebx
  80096a:	85 db                	test   %ebx,%ebx
  80096c:	74 10                	je     80097e <vprintfmt+0x356>
  80096e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800972:	78 b2                	js     800926 <vprintfmt+0x2fe>
  800974:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800978:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80097c:	79 a8                	jns    800926 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097e:	eb 16                	jmp    800996 <vprintfmt+0x36e>
				putch(' ', putdat);
  800980:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800984:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800988:	48 89 d6             	mov    %rdx,%rsi
  80098b:	bf 20 00 00 00       	mov    $0x20,%edi
  800990:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800992:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800996:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099a:	7f e4                	jg     800980 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  80099c:	e9 90 01 00 00       	jmpq   800b31 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  8009a1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009a5:	be 03 00 00 00       	mov    $0x3,%esi
  8009aa:	48 89 c7             	mov    %rax,%rdi
  8009ad:	48 b8 18 05 80 00 00 	movabs $0x800518,%rax
  8009b4:	00 00 00 
  8009b7:	ff d0                	callq  *%rax
  8009b9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c1:	48 85 c0             	test   %rax,%rax
  8009c4:	79 1d                	jns    8009e3 <vprintfmt+0x3bb>
				putch('-', putdat);
  8009c6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ca:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ce:	48 89 d6             	mov    %rdx,%rsi
  8009d1:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009d6:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dc:	48 f7 d8             	neg    %rax
  8009df:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009e3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009ea:	e9 d5 00 00 00       	jmpq   800ac4 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  8009ef:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f3:	be 03 00 00 00       	mov    $0x3,%esi
  8009f8:	48 89 c7             	mov    %rax,%rdi
  8009fb:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800a02:	00 00 00 
  800a05:	ff d0                	callq  *%rax
  800a07:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a0b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a12:	e9 ad 00 00 00       	jmpq   800ac4 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800a17:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a1b:	be 03 00 00 00       	mov    $0x3,%esi
  800a20:	48 89 c7             	mov    %rax,%rdi
  800a23:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800a2a:	00 00 00 
  800a2d:	ff d0                	callq  *%rax
  800a2f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800a33:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800a3a:	e9 85 00 00 00       	jmpq   800ac4 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800a3f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a43:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a47:	48 89 d6             	mov    %rdx,%rsi
  800a4a:	bf 30 00 00 00       	mov    $0x30,%edi
  800a4f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a59:	48 89 d6             	mov    %rdx,%rsi
  800a5c:	bf 78 00 00 00       	mov    $0x78,%edi
  800a61:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a66:	83 f8 30             	cmp    $0x30,%eax
  800a69:	73 17                	jae    800a82 <vprintfmt+0x45a>
  800a6b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a72:	89 c0                	mov    %eax,%eax
  800a74:	48 01 d0             	add    %rdx,%rax
  800a77:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7a:	83 c2 08             	add    $0x8,%edx
  800a7d:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a80:	eb 0f                	jmp    800a91 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800a82:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a86:	48 89 d0             	mov    %rdx,%rax
  800a89:	48 83 c2 08          	add    $0x8,%rdx
  800a8d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a91:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a98:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a9f:	eb 23                	jmp    800ac4 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800aa1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aa5:	be 03 00 00 00       	mov    $0x3,%esi
  800aaa:	48 89 c7             	mov    %rax,%rdi
  800aad:	48 b8 08 04 80 00 00 	movabs $0x800408,%rax
  800ab4:	00 00 00 
  800ab7:	ff d0                	callq  *%rax
  800ab9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800abd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800ac4:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ac9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800acc:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800acf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ad7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adb:	45 89 c1             	mov    %r8d,%r9d
  800ade:	41 89 f8             	mov    %edi,%r8d
  800ae1:	48 89 c7             	mov    %rax,%rdi
  800ae4:	48 b8 4d 03 80 00 00 	movabs $0x80034d,%rax
  800aeb:	00 00 00 
  800aee:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800af0:	eb 3f                	jmp    800b31 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800af2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afa:	48 89 d6             	mov    %rdx,%rsi
  800afd:	89 df                	mov    %ebx,%edi
  800aff:	ff d0                	callq  *%rax
			break;
  800b01:	eb 2e                	jmp    800b31 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0b:	48 89 d6             	mov    %rdx,%rsi
  800b0e:	bf 25 00 00 00       	mov    $0x25,%edi
  800b13:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800b15:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b1a:	eb 05                	jmp    800b21 <vprintfmt+0x4f9>
  800b1c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b21:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b25:	48 83 e8 01          	sub    $0x1,%rax
  800b29:	0f b6 00             	movzbl (%rax),%eax
  800b2c:	3c 25                	cmp    $0x25,%al
  800b2e:	75 ec                	jne    800b1c <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b30:	90                   	nop
		}
	}
  800b31:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b32:	e9 43 fb ff ff       	jmpq   80067a <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  800b37:	48 83 c4 60          	add    $0x60,%rsp
  800b3b:	5b                   	pop    %rbx
  800b3c:	41 5c                	pop    %r12
  800b3e:	5d                   	pop    %rbp
  800b3f:	c3                   	retq   

0000000000800b40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b40:	55                   	push   %rbp
  800b41:	48 89 e5             	mov    %rsp,%rbp
  800b44:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b4b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b52:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b59:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b60:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b67:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b6e:	84 c0                	test   %al,%al
  800b70:	74 20                	je     800b92 <printfmt+0x52>
  800b72:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b76:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b7a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b7e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b82:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b86:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b8a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b8e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b92:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b99:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ba0:	00 00 00 
  800ba3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800baa:	00 00 00 
  800bad:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bb1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bb8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bbf:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc6:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bcd:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bd4:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bdb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800be2:	48 89 c7             	mov    %rax,%rdi
  800be5:	48 b8 28 06 80 00 00 	movabs $0x800628,%rax
  800bec:	00 00 00 
  800bef:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bf1:	c9                   	leaveq 
  800bf2:	c3                   	retq   

0000000000800bf3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf3:	55                   	push   %rbp
  800bf4:	48 89 e5             	mov    %rsp,%rbp
  800bf7:	48 83 ec 10          	sub    $0x10,%rsp
  800bfb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bfe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c06:	8b 40 10             	mov    0x10(%rax),%eax
  800c09:	8d 50 01             	lea    0x1(%rax),%edx
  800c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c10:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c17:	48 8b 10             	mov    (%rax),%rdx
  800c1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c22:	48 39 c2             	cmp    %rax,%rdx
  800c25:	73 17                	jae    800c3e <sprintputch+0x4b>
		*b->buf++ = ch;
  800c27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2b:	48 8b 00             	mov    (%rax),%rax
  800c2e:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c36:	48 89 0a             	mov    %rcx,(%rdx)
  800c39:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c3c:	88 10                	mov    %dl,(%rax)
}
  800c3e:	c9                   	leaveq 
  800c3f:	c3                   	retq   

0000000000800c40 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c40:	55                   	push   %rbp
  800c41:	48 89 e5             	mov    %rsp,%rbp
  800c44:	48 83 ec 50          	sub    $0x50,%rsp
  800c48:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c4c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c4f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c53:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c57:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c5b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c5f:	48 8b 0a             	mov    (%rdx),%rcx
  800c62:	48 89 08             	mov    %rcx,(%rax)
  800c65:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c69:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c6d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c71:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c75:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c79:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c7d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c80:	48 98                	cltq   
  800c82:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c86:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c8a:	48 01 d0             	add    %rdx,%rax
  800c8d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c98:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c9d:	74 06                	je     800ca5 <vsnprintf+0x65>
  800c9f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ca3:	7f 07                	jg     800cac <vsnprintf+0x6c>
		return -E_INVAL;
  800ca5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800caa:	eb 2f                	jmp    800cdb <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800cac:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cb0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cb4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cb8:	48 89 c6             	mov    %rax,%rsi
  800cbb:	48 bf f3 0b 80 00 00 	movabs $0x800bf3,%rdi
  800cc2:	00 00 00 
  800cc5:	48 b8 28 06 80 00 00 	movabs $0x800628,%rax
  800ccc:	00 00 00 
  800ccf:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cd1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cd5:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cd8:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cdb:	c9                   	leaveq 
  800cdc:	c3                   	retq   

0000000000800cdd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cdd:	55                   	push   %rbp
  800cde:	48 89 e5             	mov    %rsp,%rbp
  800ce1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ce8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cef:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cf5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cfc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d03:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d0a:	84 c0                	test   %al,%al
  800d0c:	74 20                	je     800d2e <snprintf+0x51>
  800d0e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d12:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d16:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d1a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d1e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d22:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d26:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d2a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d2e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d35:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d3c:	00 00 00 
  800d3f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d46:	00 00 00 
  800d49:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d4d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d54:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d5b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d62:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d69:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d70:	48 8b 0a             	mov    (%rdx),%rcx
  800d73:	48 89 08             	mov    %rcx,(%rax)
  800d76:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d7a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d7e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d82:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d86:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d8d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d94:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d9a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800da1:	48 89 c7             	mov    %rax,%rdi
  800da4:	48 b8 40 0c 80 00 00 	movabs $0x800c40,%rax
  800dab:	00 00 00 
  800dae:	ff d0                	callq  *%rax
  800db0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800db6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800dbc:	c9                   	leaveq 
  800dbd:	c3                   	retq   

0000000000800dbe <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dbe:	55                   	push   %rbp
  800dbf:	48 89 e5             	mov    %rsp,%rbp
  800dc2:	48 83 ec 18          	sub    $0x18,%rsp
  800dc6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dd1:	eb 09                	jmp    800ddc <strlen+0x1e>
		n++;
  800dd3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ddc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de0:	0f b6 00             	movzbl (%rax),%eax
  800de3:	84 c0                	test   %al,%al
  800de5:	75 ec                	jne    800dd3 <strlen+0x15>
		n++;
	return n;
  800de7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dea:	c9                   	leaveq 
  800deb:	c3                   	retq   

0000000000800dec <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dec:	55                   	push   %rbp
  800ded:	48 89 e5             	mov    %rsp,%rbp
  800df0:	48 83 ec 20          	sub    $0x20,%rsp
  800df4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800df8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e03:	eb 0e                	jmp    800e13 <strnlen+0x27>
		n++;
  800e05:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e09:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e0e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e13:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e18:	74 0b                	je     800e25 <strnlen+0x39>
  800e1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1e:	0f b6 00             	movzbl (%rax),%eax
  800e21:	84 c0                	test   %al,%al
  800e23:	75 e0                	jne    800e05 <strnlen+0x19>
		n++;
	return n;
  800e25:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e28:	c9                   	leaveq 
  800e29:	c3                   	retq   

0000000000800e2a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2a:	55                   	push   %rbp
  800e2b:	48 89 e5             	mov    %rsp,%rbp
  800e2e:	48 83 ec 20          	sub    $0x20,%rsp
  800e32:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e36:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e42:	90                   	nop
  800e43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e47:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e4b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e4f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e53:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e57:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e5b:	0f b6 12             	movzbl (%rdx),%edx
  800e5e:	88 10                	mov    %dl,(%rax)
  800e60:	0f b6 00             	movzbl (%rax),%eax
  800e63:	84 c0                	test   %al,%al
  800e65:	75 dc                	jne    800e43 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e6b:	c9                   	leaveq 
  800e6c:	c3                   	retq   

0000000000800e6d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e6d:	55                   	push   %rbp
  800e6e:	48 89 e5             	mov    %rsp,%rbp
  800e71:	48 83 ec 20          	sub    $0x20,%rsp
  800e75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e81:	48 89 c7             	mov    %rax,%rdi
  800e84:	48 b8 be 0d 80 00 00 	movabs $0x800dbe,%rax
  800e8b:	00 00 00 
  800e8e:	ff d0                	callq  *%rax
  800e90:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e93:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e96:	48 63 d0             	movslq %eax,%rdx
  800e99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9d:	48 01 c2             	add    %rax,%rdx
  800ea0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ea4:	48 89 c6             	mov    %rax,%rsi
  800ea7:	48 89 d7             	mov    %rdx,%rdi
  800eaa:	48 b8 2a 0e 80 00 00 	movabs $0x800e2a,%rax
  800eb1:	00 00 00 
  800eb4:	ff d0                	callq  *%rax
	return dst;
  800eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800eba:	c9                   	leaveq 
  800ebb:	c3                   	retq   

0000000000800ebc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ebc:	55                   	push   %rbp
  800ebd:	48 89 e5             	mov    %rsp,%rbp
  800ec0:	48 83 ec 28          	sub    $0x28,%rsp
  800ec4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ecc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ed0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ed8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800edf:	00 
  800ee0:	eb 2a                	jmp    800f0c <strncpy+0x50>
		*dst++ = *src;
  800ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eea:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800eee:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ef2:	0f b6 12             	movzbl (%rdx),%edx
  800ef5:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800efb:	0f b6 00             	movzbl (%rax),%eax
  800efe:	84 c0                	test   %al,%al
  800f00:	74 05                	je     800f07 <strncpy+0x4b>
			src++;
  800f02:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f07:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f10:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f14:	72 cc                	jb     800ee2 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f1a:	c9                   	leaveq 
  800f1b:	c3                   	retq   

0000000000800f1c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f1c:	55                   	push   %rbp
  800f1d:	48 89 e5             	mov    %rsp,%rbp
  800f20:	48 83 ec 28          	sub    $0x28,%rsp
  800f24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f2c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f34:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f38:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f3d:	74 3d                	je     800f7c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f3f:	eb 1d                	jmp    800f5e <strlcpy+0x42>
			*dst++ = *src++;
  800f41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f45:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f49:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f4d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f51:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f55:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f59:	0f b6 12             	movzbl (%rdx),%edx
  800f5c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f5e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f63:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f68:	74 0b                	je     800f75 <strlcpy+0x59>
  800f6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f6e:	0f b6 00             	movzbl (%rax),%eax
  800f71:	84 c0                	test   %al,%al
  800f73:	75 cc                	jne    800f41 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f79:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f7c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f80:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f84:	48 29 c2             	sub    %rax,%rdx
  800f87:	48 89 d0             	mov    %rdx,%rax
}
  800f8a:	c9                   	leaveq 
  800f8b:	c3                   	retq   

0000000000800f8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f8c:	55                   	push   %rbp
  800f8d:	48 89 e5             	mov    %rsp,%rbp
  800f90:	48 83 ec 10          	sub    $0x10,%rsp
  800f94:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f98:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f9c:	eb 0a                	jmp    800fa8 <strcmp+0x1c>
		p++, q++;
  800f9e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fa3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fac:	0f b6 00             	movzbl (%rax),%eax
  800faf:	84 c0                	test   %al,%al
  800fb1:	74 12                	je     800fc5 <strcmp+0x39>
  800fb3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb7:	0f b6 10             	movzbl (%rax),%edx
  800fba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fbe:	0f b6 00             	movzbl (%rax),%eax
  800fc1:	38 c2                	cmp    %al,%dl
  800fc3:	74 d9                	je     800f9e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc9:	0f b6 00             	movzbl (%rax),%eax
  800fcc:	0f b6 d0             	movzbl %al,%edx
  800fcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd3:	0f b6 00             	movzbl (%rax),%eax
  800fd6:	0f b6 c0             	movzbl %al,%eax
  800fd9:	29 c2                	sub    %eax,%edx
  800fdb:	89 d0                	mov    %edx,%eax
}
  800fdd:	c9                   	leaveq 
  800fde:	c3                   	retq   

0000000000800fdf <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fdf:	55                   	push   %rbp
  800fe0:	48 89 e5             	mov    %rsp,%rbp
  800fe3:	48 83 ec 18          	sub    $0x18,%rsp
  800fe7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800feb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800ff3:	eb 0f                	jmp    801004 <strncmp+0x25>
		n--, p++, q++;
  800ff5:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800ffa:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fff:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801004:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801009:	74 1d                	je     801028 <strncmp+0x49>
  80100b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80100f:	0f b6 00             	movzbl (%rax),%eax
  801012:	84 c0                	test   %al,%al
  801014:	74 12                	je     801028 <strncmp+0x49>
  801016:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101a:	0f b6 10             	movzbl (%rax),%edx
  80101d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801021:	0f b6 00             	movzbl (%rax),%eax
  801024:	38 c2                	cmp    %al,%dl
  801026:	74 cd                	je     800ff5 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801028:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80102d:	75 07                	jne    801036 <strncmp+0x57>
		return 0;
  80102f:	b8 00 00 00 00       	mov    $0x0,%eax
  801034:	eb 18                	jmp    80104e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801036:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80103a:	0f b6 00             	movzbl (%rax),%eax
  80103d:	0f b6 d0             	movzbl %al,%edx
  801040:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801044:	0f b6 00             	movzbl (%rax),%eax
  801047:	0f b6 c0             	movzbl %al,%eax
  80104a:	29 c2                	sub    %eax,%edx
  80104c:	89 d0                	mov    %edx,%eax
}
  80104e:	c9                   	leaveq 
  80104f:	c3                   	retq   

0000000000801050 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801050:	55                   	push   %rbp
  801051:	48 89 e5             	mov    %rsp,%rbp
  801054:	48 83 ec 0c          	sub    $0xc,%rsp
  801058:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80105c:	89 f0                	mov    %esi,%eax
  80105e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801061:	eb 17                	jmp    80107a <strchr+0x2a>
		if (*s == c)
  801063:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801067:	0f b6 00             	movzbl (%rax),%eax
  80106a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80106d:	75 06                	jne    801075 <strchr+0x25>
			return (char *) s;
  80106f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801073:	eb 15                	jmp    80108a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801075:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80107a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107e:	0f b6 00             	movzbl (%rax),%eax
  801081:	84 c0                	test   %al,%al
  801083:	75 de                	jne    801063 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801085:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108a:	c9                   	leaveq 
  80108b:	c3                   	retq   

000000000080108c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80108c:	55                   	push   %rbp
  80108d:	48 89 e5             	mov    %rsp,%rbp
  801090:	48 83 ec 0c          	sub    $0xc,%rsp
  801094:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801098:	89 f0                	mov    %esi,%eax
  80109a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80109d:	eb 13                	jmp    8010b2 <strfind+0x26>
		if (*s == c)
  80109f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a3:	0f b6 00             	movzbl (%rax),%eax
  8010a6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010a9:	75 02                	jne    8010ad <strfind+0x21>
			break;
  8010ab:	eb 10                	jmp    8010bd <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b6:	0f b6 00             	movzbl (%rax),%eax
  8010b9:	84 c0                	test   %al,%al
  8010bb:	75 e2                	jne    80109f <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010c1:	c9                   	leaveq 
  8010c2:	c3                   	retq   

00000000008010c3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010c3:	55                   	push   %rbp
  8010c4:	48 89 e5             	mov    %rsp,%rbp
  8010c7:	48 83 ec 18          	sub    $0x18,%rsp
  8010cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010cf:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010d2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010d6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010db:	75 06                	jne    8010e3 <memset+0x20>
		return v;
  8010dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e1:	eb 69                	jmp    80114c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e7:	83 e0 03             	and    $0x3,%eax
  8010ea:	48 85 c0             	test   %rax,%rax
  8010ed:	75 48                	jne    801137 <memset+0x74>
  8010ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f3:	83 e0 03             	and    $0x3,%eax
  8010f6:	48 85 c0             	test   %rax,%rax
  8010f9:	75 3c                	jne    801137 <memset+0x74>
		c &= 0xFF;
  8010fb:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801102:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801105:	c1 e0 18             	shl    $0x18,%eax
  801108:	89 c2                	mov    %eax,%edx
  80110a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80110d:	c1 e0 10             	shl    $0x10,%eax
  801110:	09 c2                	or     %eax,%edx
  801112:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801115:	c1 e0 08             	shl    $0x8,%eax
  801118:	09 d0                	or     %edx,%eax
  80111a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80111d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801121:	48 c1 e8 02          	shr    $0x2,%rax
  801125:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801128:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80112c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80112f:	48 89 d7             	mov    %rdx,%rdi
  801132:	fc                   	cld    
  801133:	f3 ab                	rep stos %eax,%es:(%rdi)
  801135:	eb 11                	jmp    801148 <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801137:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80113b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80113e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801142:	48 89 d7             	mov    %rdx,%rdi
  801145:	fc                   	cld    
  801146:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  801148:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80114c:	c9                   	leaveq 
  80114d:	c3                   	retq   

000000000080114e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80114e:	55                   	push   %rbp
  80114f:	48 89 e5             	mov    %rsp,%rbp
  801152:	48 83 ec 28          	sub    $0x28,%rsp
  801156:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80115e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801162:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801166:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80116a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801172:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801176:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80117a:	0f 83 88 00 00 00    	jae    801208 <memmove+0xba>
  801180:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801184:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801188:	48 01 d0             	add    %rdx,%rax
  80118b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80118f:	76 77                	jbe    801208 <memmove+0xba>
		s += n;
  801191:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801195:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801199:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80119d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a5:	83 e0 03             	and    $0x3,%eax
  8011a8:	48 85 c0             	test   %rax,%rax
  8011ab:	75 3b                	jne    8011e8 <memmove+0x9a>
  8011ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b1:	83 e0 03             	and    $0x3,%eax
  8011b4:	48 85 c0             	test   %rax,%rax
  8011b7:	75 2f                	jne    8011e8 <memmove+0x9a>
  8011b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011bd:	83 e0 03             	and    $0x3,%eax
  8011c0:	48 85 c0             	test   %rax,%rax
  8011c3:	75 23                	jne    8011e8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c9:	48 83 e8 04          	sub    $0x4,%rax
  8011cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d1:	48 83 ea 04          	sub    $0x4,%rdx
  8011d5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011d9:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011dd:	48 89 c7             	mov    %rax,%rdi
  8011e0:	48 89 d6             	mov    %rdx,%rsi
  8011e3:	fd                   	std    
  8011e4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011e6:	eb 1d                	jmp    801205 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ec:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011fc:	48 89 d7             	mov    %rdx,%rdi
  8011ff:	48 89 c1             	mov    %rax,%rcx
  801202:	fd                   	std    
  801203:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801205:	fc                   	cld    
  801206:	eb 57                	jmp    80125f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801208:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120c:	83 e0 03             	and    $0x3,%eax
  80120f:	48 85 c0             	test   %rax,%rax
  801212:	75 36                	jne    80124a <memmove+0xfc>
  801214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801218:	83 e0 03             	and    $0x3,%eax
  80121b:	48 85 c0             	test   %rax,%rax
  80121e:	75 2a                	jne    80124a <memmove+0xfc>
  801220:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801224:	83 e0 03             	and    $0x3,%eax
  801227:	48 85 c0             	test   %rax,%rax
  80122a:	75 1e                	jne    80124a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80122c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801230:	48 c1 e8 02          	shr    $0x2,%rax
  801234:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123f:	48 89 c7             	mov    %rax,%rdi
  801242:	48 89 d6             	mov    %rdx,%rsi
  801245:	fc                   	cld    
  801246:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801248:	eb 15                	jmp    80125f <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80124a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801252:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801256:	48 89 c7             	mov    %rax,%rdi
  801259:	48 89 d6             	mov    %rdx,%rsi
  80125c:	fc                   	cld    
  80125d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80125f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801263:	c9                   	leaveq 
  801264:	c3                   	retq   

0000000000801265 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801265:	55                   	push   %rbp
  801266:	48 89 e5             	mov    %rsp,%rbp
  801269:	48 83 ec 18          	sub    $0x18,%rsp
  80126d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801271:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801275:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801279:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80127d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801281:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801285:	48 89 ce             	mov    %rcx,%rsi
  801288:	48 89 c7             	mov    %rax,%rdi
  80128b:	48 b8 4e 11 80 00 00 	movabs $0x80114e,%rax
  801292:	00 00 00 
  801295:	ff d0                	callq  *%rax
}
  801297:	c9                   	leaveq 
  801298:	c3                   	retq   

0000000000801299 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801299:	55                   	push   %rbp
  80129a:	48 89 e5             	mov    %rsp,%rbp
  80129d:	48 83 ec 28          	sub    $0x28,%rsp
  8012a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012bd:	eb 36                	jmp    8012f5 <memcmp+0x5c>
		if (*s1 != *s2)
  8012bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c3:	0f b6 10             	movzbl (%rax),%edx
  8012c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	38 c2                	cmp    %al,%dl
  8012cf:	74 1a                	je     8012eb <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d5:	0f b6 00             	movzbl (%rax),%eax
  8012d8:	0f b6 d0             	movzbl %al,%edx
  8012db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012df:	0f b6 00             	movzbl (%rax),%eax
  8012e2:	0f b6 c0             	movzbl %al,%eax
  8012e5:	29 c2                	sub    %eax,%edx
  8012e7:	89 d0                	mov    %edx,%eax
  8012e9:	eb 20                	jmp    80130b <memcmp+0x72>
		s1++, s2++;
  8012eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801301:	48 85 c0             	test   %rax,%rax
  801304:	75 b9                	jne    8012bf <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801306:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130b:	c9                   	leaveq 
  80130c:	c3                   	retq   

000000000080130d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80130d:	55                   	push   %rbp
  80130e:	48 89 e5             	mov    %rsp,%rbp
  801311:	48 83 ec 28          	sub    $0x28,%rsp
  801315:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801319:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80131c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801320:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801324:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801328:	48 01 d0             	add    %rdx,%rax
  80132b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80132f:	eb 15                	jmp    801346 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801335:	0f b6 10             	movzbl (%rax),%edx
  801338:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80133b:	38 c2                	cmp    %al,%dl
  80133d:	75 02                	jne    801341 <memfind+0x34>
			break;
  80133f:	eb 0f                	jmp    801350 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801341:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801346:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80134e:	72 e1                	jb     801331 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801354:	c9                   	leaveq 
  801355:	c3                   	retq   

0000000000801356 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801356:	55                   	push   %rbp
  801357:	48 89 e5             	mov    %rsp,%rbp
  80135a:	48 83 ec 34          	sub    $0x34,%rsp
  80135e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801362:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801366:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801369:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801370:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801377:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801378:	eb 05                	jmp    80137f <strtol+0x29>
		s++;
  80137a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801383:	0f b6 00             	movzbl (%rax),%eax
  801386:	3c 20                	cmp    $0x20,%al
  801388:	74 f0                	je     80137a <strtol+0x24>
  80138a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138e:	0f b6 00             	movzbl (%rax),%eax
  801391:	3c 09                	cmp    $0x9,%al
  801393:	74 e5                	je     80137a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801395:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801399:	0f b6 00             	movzbl (%rax),%eax
  80139c:	3c 2b                	cmp    $0x2b,%al
  80139e:	75 07                	jne    8013a7 <strtol+0x51>
		s++;
  8013a0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013a5:	eb 17                	jmp    8013be <strtol+0x68>
	else if (*s == '-')
  8013a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ab:	0f b6 00             	movzbl (%rax),%eax
  8013ae:	3c 2d                	cmp    $0x2d,%al
  8013b0:	75 0c                	jne    8013be <strtol+0x68>
		s++, neg = 1;
  8013b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013be:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013c2:	74 06                	je     8013ca <strtol+0x74>
  8013c4:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013c8:	75 28                	jne    8013f2 <strtol+0x9c>
  8013ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ce:	0f b6 00             	movzbl (%rax),%eax
  8013d1:	3c 30                	cmp    $0x30,%al
  8013d3:	75 1d                	jne    8013f2 <strtol+0x9c>
  8013d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d9:	48 83 c0 01          	add    $0x1,%rax
  8013dd:	0f b6 00             	movzbl (%rax),%eax
  8013e0:	3c 78                	cmp    $0x78,%al
  8013e2:	75 0e                	jne    8013f2 <strtol+0x9c>
		s += 2, base = 16;
  8013e4:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013e9:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013f0:	eb 2c                	jmp    80141e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013f6:	75 19                	jne    801411 <strtol+0xbb>
  8013f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fc:	0f b6 00             	movzbl (%rax),%eax
  8013ff:	3c 30                	cmp    $0x30,%al
  801401:	75 0e                	jne    801411 <strtol+0xbb>
		s++, base = 8;
  801403:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801408:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80140f:	eb 0d                	jmp    80141e <strtol+0xc8>
	else if (base == 0)
  801411:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801415:	75 07                	jne    80141e <strtol+0xc8>
		base = 10;
  801417:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80141e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801422:	0f b6 00             	movzbl (%rax),%eax
  801425:	3c 2f                	cmp    $0x2f,%al
  801427:	7e 1d                	jle    801446 <strtol+0xf0>
  801429:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	3c 39                	cmp    $0x39,%al
  801432:	7f 12                	jg     801446 <strtol+0xf0>
			dig = *s - '0';
  801434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801438:	0f b6 00             	movzbl (%rax),%eax
  80143b:	0f be c0             	movsbl %al,%eax
  80143e:	83 e8 30             	sub    $0x30,%eax
  801441:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801444:	eb 4e                	jmp    801494 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801446:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144a:	0f b6 00             	movzbl (%rax),%eax
  80144d:	3c 60                	cmp    $0x60,%al
  80144f:	7e 1d                	jle    80146e <strtol+0x118>
  801451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	3c 7a                	cmp    $0x7a,%al
  80145a:	7f 12                	jg     80146e <strtol+0x118>
			dig = *s - 'a' + 10;
  80145c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801460:	0f b6 00             	movzbl (%rax),%eax
  801463:	0f be c0             	movsbl %al,%eax
  801466:	83 e8 57             	sub    $0x57,%eax
  801469:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80146c:	eb 26                	jmp    801494 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80146e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801472:	0f b6 00             	movzbl (%rax),%eax
  801475:	3c 40                	cmp    $0x40,%al
  801477:	7e 48                	jle    8014c1 <strtol+0x16b>
  801479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147d:	0f b6 00             	movzbl (%rax),%eax
  801480:	3c 5a                	cmp    $0x5a,%al
  801482:	7f 3d                	jg     8014c1 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801484:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801488:	0f b6 00             	movzbl (%rax),%eax
  80148b:	0f be c0             	movsbl %al,%eax
  80148e:	83 e8 37             	sub    $0x37,%eax
  801491:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801494:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801497:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80149a:	7c 02                	jl     80149e <strtol+0x148>
			break;
  80149c:	eb 23                	jmp    8014c1 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80149e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014a3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014a6:	48 98                	cltq   
  8014a8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014ad:	48 89 c2             	mov    %rax,%rdx
  8014b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014b3:	48 98                	cltq   
  8014b5:	48 01 d0             	add    %rdx,%rax
  8014b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014bc:	e9 5d ff ff ff       	jmpq   80141e <strtol+0xc8>

	if (endptr)
  8014c1:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014c6:	74 0b                	je     8014d3 <strtol+0x17d>
		*endptr = (char *) s;
  8014c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014cc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014d0:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014d7:	74 09                	je     8014e2 <strtol+0x18c>
  8014d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014dd:	48 f7 d8             	neg    %rax
  8014e0:	eb 04                	jmp    8014e6 <strtol+0x190>
  8014e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014e6:	c9                   	leaveq 
  8014e7:	c3                   	retq   

00000000008014e8 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014e8:	55                   	push   %rbp
  8014e9:	48 89 e5             	mov    %rsp,%rbp
  8014ec:	48 83 ec 30          	sub    $0x30,%rsp
  8014f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8014f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014fc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801500:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801504:	0f b6 00             	movzbl (%rax),%eax
  801507:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  80150a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80150e:	75 06                	jne    801516 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  801510:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801514:	eb 6b                	jmp    801581 <strstr+0x99>

    len = strlen(str);
  801516:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80151a:	48 89 c7             	mov    %rax,%rdi
  80151d:	48 b8 be 0d 80 00 00 	movabs $0x800dbe,%rax
  801524:	00 00 00 
  801527:	ff d0                	callq  *%rax
  801529:	48 98                	cltq   
  80152b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  80152f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801533:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801537:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80153b:	0f b6 00             	movzbl (%rax),%eax
  80153e:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801541:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801545:	75 07                	jne    80154e <strstr+0x66>
                return (char *) 0;
  801547:	b8 00 00 00 00       	mov    $0x0,%eax
  80154c:	eb 33                	jmp    801581 <strstr+0x99>
        } while (sc != c);
  80154e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801552:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801555:	75 d8                	jne    80152f <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801557:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80155b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80155f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801563:	48 89 ce             	mov    %rcx,%rsi
  801566:	48 89 c7             	mov    %rax,%rdi
  801569:	48 b8 df 0f 80 00 00 	movabs $0x800fdf,%rax
  801570:	00 00 00 
  801573:	ff d0                	callq  *%rax
  801575:	85 c0                	test   %eax,%eax
  801577:	75 b6                	jne    80152f <strstr+0x47>

    return (char *) (in - 1);
  801579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157d:	48 83 e8 01          	sub    $0x1,%rax
}
  801581:	c9                   	leaveq 
  801582:	c3                   	retq   

0000000000801583 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801583:	55                   	push   %rbp
  801584:	48 89 e5             	mov    %rsp,%rbp
  801587:	53                   	push   %rbx
  801588:	48 83 ec 48          	sub    $0x48,%rsp
  80158c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80158f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801592:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801596:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80159a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80159e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015a2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015a5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015a9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015ad:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015b1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015b5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015b9:	4c 89 c3             	mov    %r8,%rbx
  8015bc:	cd 30                	int    $0x30
  8015be:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015c2:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015c6:	74 3e                	je     801606 <syscall+0x83>
  8015c8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015cd:	7e 37                	jle    801606 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015d3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015d6:	49 89 d0             	mov    %rdx,%r8
  8015d9:	89 c1                	mov    %eax,%ecx
  8015db:	48 ba 88 1e 80 00 00 	movabs $0x801e88,%rdx
  8015e2:	00 00 00 
  8015e5:	be 23 00 00 00       	mov    $0x23,%esi
  8015ea:	48 bf a5 1e 80 00 00 	movabs $0x801ea5,%rdi
  8015f1:	00 00 00 
  8015f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f9:	49 b9 7c 19 80 00 00 	movabs $0x80197c,%r9
  801600:	00 00 00 
  801603:	41 ff d1             	callq  *%r9

	return ret;
  801606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80160a:	48 83 c4 48          	add    $0x48,%rsp
  80160e:	5b                   	pop    %rbx
  80160f:	5d                   	pop    %rbp
  801610:	c3                   	retq   

0000000000801611 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801611:	55                   	push   %rbp
  801612:	48 89 e5             	mov    %rsp,%rbp
  801615:	48 83 ec 20          	sub    $0x20,%rsp
  801619:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80161d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801621:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801625:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801629:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801630:	00 
  801631:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801637:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80163d:	48 89 d1             	mov    %rdx,%rcx
  801640:	48 89 c2             	mov    %rax,%rdx
  801643:	be 00 00 00 00       	mov    $0x0,%esi
  801648:	bf 00 00 00 00       	mov    $0x0,%edi
  80164d:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  801654:	00 00 00 
  801657:	ff d0                	callq  *%rax
}
  801659:	c9                   	leaveq 
  80165a:	c3                   	retq   

000000000080165b <sys_cgetc>:

int
sys_cgetc(void)
{
  80165b:	55                   	push   %rbp
  80165c:	48 89 e5             	mov    %rsp,%rbp
  80165f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801663:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80166a:	00 
  80166b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801671:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801677:	b9 00 00 00 00       	mov    $0x0,%ecx
  80167c:	ba 00 00 00 00       	mov    $0x0,%edx
  801681:	be 00 00 00 00       	mov    $0x0,%esi
  801686:	bf 01 00 00 00       	mov    $0x1,%edi
  80168b:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  801692:	00 00 00 
  801695:	ff d0                	callq  *%rax
}
  801697:	c9                   	leaveq 
  801698:	c3                   	retq   

0000000000801699 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801699:	55                   	push   %rbp
  80169a:	48 89 e5             	mov    %rsp,%rbp
  80169d:	48 83 ec 10          	sub    $0x10,%rsp
  8016a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a7:	48 98                	cltq   
  8016a9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016b0:	00 
  8016b1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016bd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016c2:	48 89 c2             	mov    %rax,%rdx
  8016c5:	be 01 00 00 00       	mov    $0x1,%esi
  8016ca:	bf 03 00 00 00       	mov    $0x3,%edi
  8016cf:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  8016d6:	00 00 00 
  8016d9:	ff d0                	callq  *%rax
}
  8016db:	c9                   	leaveq 
  8016dc:	c3                   	retq   

00000000008016dd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016dd:	55                   	push   %rbp
  8016de:	48 89 e5             	mov    %rsp,%rbp
  8016e1:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016e5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ec:	00 
  8016ed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801703:	be 00 00 00 00       	mov    $0x0,%esi
  801708:	bf 02 00 00 00       	mov    $0x2,%edi
  80170d:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  801714:	00 00 00 
  801717:	ff d0                	callq  *%rax
}
  801719:	c9                   	leaveq 
  80171a:	c3                   	retq   

000000000080171b <sys_yield>:

void
sys_yield(void)
{
  80171b:	55                   	push   %rbp
  80171c:	48 89 e5             	mov    %rsp,%rbp
  80171f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801723:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80172a:	00 
  80172b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801731:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801737:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173c:	ba 00 00 00 00       	mov    $0x0,%edx
  801741:	be 00 00 00 00       	mov    $0x0,%esi
  801746:	bf 0a 00 00 00       	mov    $0xa,%edi
  80174b:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  801752:	00 00 00 
  801755:	ff d0                	callq  *%rax
}
  801757:	c9                   	leaveq 
  801758:	c3                   	retq   

0000000000801759 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801759:	55                   	push   %rbp
  80175a:	48 89 e5             	mov    %rsp,%rbp
  80175d:	48 83 ec 20          	sub    $0x20,%rsp
  801761:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801764:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801768:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80176b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80176e:	48 63 c8             	movslq %eax,%rcx
  801771:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801775:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801778:	48 98                	cltq   
  80177a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801781:	00 
  801782:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801788:	49 89 c8             	mov    %rcx,%r8
  80178b:	48 89 d1             	mov    %rdx,%rcx
  80178e:	48 89 c2             	mov    %rax,%rdx
  801791:	be 01 00 00 00       	mov    $0x1,%esi
  801796:	bf 04 00 00 00       	mov    $0x4,%edi
  80179b:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  8017a2:	00 00 00 
  8017a5:	ff d0                	callq  *%rax
}
  8017a7:	c9                   	leaveq 
  8017a8:	c3                   	retq   

00000000008017a9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017a9:	55                   	push   %rbp
  8017aa:	48 89 e5             	mov    %rsp,%rbp
  8017ad:	48 83 ec 30          	sub    $0x30,%rsp
  8017b1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017b4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017b8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017bb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017bf:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017c3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017c6:	48 63 c8             	movslq %eax,%rcx
  8017c9:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017d0:	48 63 f0             	movslq %eax,%rsi
  8017d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017da:	48 98                	cltq   
  8017dc:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017e0:	49 89 f9             	mov    %rdi,%r9
  8017e3:	49 89 f0             	mov    %rsi,%r8
  8017e6:	48 89 d1             	mov    %rdx,%rcx
  8017e9:	48 89 c2             	mov    %rax,%rdx
  8017ec:	be 01 00 00 00       	mov    $0x1,%esi
  8017f1:	bf 05 00 00 00       	mov    $0x5,%edi
  8017f6:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  8017fd:	00 00 00 
  801800:	ff d0                	callq  *%rax
}
  801802:	c9                   	leaveq 
  801803:	c3                   	retq   

0000000000801804 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801804:	55                   	push   %rbp
  801805:	48 89 e5             	mov    %rsp,%rbp
  801808:	48 83 ec 20          	sub    $0x20,%rsp
  80180c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80180f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801813:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801817:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181a:	48 98                	cltq   
  80181c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801823:	00 
  801824:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801830:	48 89 d1             	mov    %rdx,%rcx
  801833:	48 89 c2             	mov    %rax,%rdx
  801836:	be 01 00 00 00       	mov    $0x1,%esi
  80183b:	bf 06 00 00 00       	mov    $0x6,%edi
  801840:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  801847:	00 00 00 
  80184a:	ff d0                	callq  *%rax
}
  80184c:	c9                   	leaveq 
  80184d:	c3                   	retq   

000000000080184e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80184e:	55                   	push   %rbp
  80184f:	48 89 e5             	mov    %rsp,%rbp
  801852:	48 83 ec 10          	sub    $0x10,%rsp
  801856:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801859:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80185c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80185f:	48 63 d0             	movslq %eax,%rdx
  801862:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801865:	48 98                	cltq   
  801867:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80186e:	00 
  80186f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801875:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80187b:	48 89 d1             	mov    %rdx,%rcx
  80187e:	48 89 c2             	mov    %rax,%rdx
  801881:	be 01 00 00 00       	mov    $0x1,%esi
  801886:	bf 08 00 00 00       	mov    $0x8,%edi
  80188b:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  801892:	00 00 00 
  801895:	ff d0                	callq  *%rax
}
  801897:	c9                   	leaveq 
  801898:	c3                   	retq   

0000000000801899 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801899:	55                   	push   %rbp
  80189a:	48 89 e5             	mov    %rsp,%rbp
  80189d:	48 83 ec 20          	sub    $0x20,%rsp
  8018a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018af:	48 98                	cltq   
  8018b1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b8:	00 
  8018b9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018bf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c5:	48 89 d1             	mov    %rdx,%rcx
  8018c8:	48 89 c2             	mov    %rax,%rdx
  8018cb:	be 01 00 00 00       	mov    $0x1,%esi
  8018d0:	bf 09 00 00 00       	mov    $0x9,%edi
  8018d5:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  8018dc:	00 00 00 
  8018df:	ff d0                	callq  *%rax
}
  8018e1:	c9                   	leaveq 
  8018e2:	c3                   	retq   

00000000008018e3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8018e3:	55                   	push   %rbp
  8018e4:	48 89 e5             	mov    %rsp,%rbp
  8018e7:	48 83 ec 20          	sub    $0x20,%rsp
  8018eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018f2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018f6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8018f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018fc:	48 63 f0             	movslq %eax,%rsi
  8018ff:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801903:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801906:	48 98                	cltq   
  801908:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80190c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801913:	00 
  801914:	49 89 f1             	mov    %rsi,%r9
  801917:	49 89 c8             	mov    %rcx,%r8
  80191a:	48 89 d1             	mov    %rdx,%rcx
  80191d:	48 89 c2             	mov    %rax,%rdx
  801920:	be 00 00 00 00       	mov    $0x0,%esi
  801925:	bf 0b 00 00 00       	mov    $0xb,%edi
  80192a:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  801931:	00 00 00 
  801934:	ff d0                	callq  *%rax
}
  801936:	c9                   	leaveq 
  801937:	c3                   	retq   

0000000000801938 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801938:	55                   	push   %rbp
  801939:	48 89 e5             	mov    %rsp,%rbp
  80193c:	48 83 ec 10          	sub    $0x10,%rsp
  801940:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801944:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801948:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194f:	00 
  801950:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801956:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801961:	48 89 c2             	mov    %rax,%rdx
  801964:	be 01 00 00 00       	mov    $0x1,%esi
  801969:	bf 0c 00 00 00       	mov    $0xc,%edi
  80196e:	48 b8 83 15 80 00 00 	movabs $0x801583,%rax
  801975:	00 00 00 
  801978:	ff d0                	callq  *%rax
}
  80197a:	c9                   	leaveq 
  80197b:	c3                   	retq   

000000000080197c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80197c:	55                   	push   %rbp
  80197d:	48 89 e5             	mov    %rsp,%rbp
  801980:	53                   	push   %rbx
  801981:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801988:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80198f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801995:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80199c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8019a3:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8019aa:	84 c0                	test   %al,%al
  8019ac:	74 23                	je     8019d1 <_panic+0x55>
  8019ae:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8019b5:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8019b9:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8019bd:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8019c1:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8019c5:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8019c9:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8019cd:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8019d1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8019d8:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8019df:	00 00 00 
  8019e2:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8019e9:	00 00 00 
  8019ec:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8019f0:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8019f7:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8019fe:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a05:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801a0c:	00 00 00 
  801a0f:	48 8b 18             	mov    (%rax),%rbx
  801a12:	48 b8 dd 16 80 00 00 	movabs $0x8016dd,%rax
  801a19:	00 00 00 
  801a1c:	ff d0                	callq  *%rax
  801a1e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  801a24:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801a2b:	41 89 c8             	mov    %ecx,%r8d
  801a2e:	48 89 d1             	mov    %rdx,%rcx
  801a31:	48 89 da             	mov    %rbx,%rdx
  801a34:	89 c6                	mov    %eax,%esi
  801a36:	48 bf b8 1e 80 00 00 	movabs $0x801eb8,%rdi
  801a3d:	00 00 00 
  801a40:	b8 00 00 00 00       	mov    $0x0,%eax
  801a45:	49 b9 75 02 80 00 00 	movabs $0x800275,%r9
  801a4c:	00 00 00 
  801a4f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a52:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801a59:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801a60:	48 89 d6             	mov    %rdx,%rsi
  801a63:	48 89 c7             	mov    %rax,%rdi
  801a66:	48 b8 c9 01 80 00 00 	movabs $0x8001c9,%rax
  801a6d:	00 00 00 
  801a70:	ff d0                	callq  *%rax
	cprintf("\n");
  801a72:	48 bf db 1e 80 00 00 	movabs $0x801edb,%rdi
  801a79:	00 00 00 
  801a7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a81:	48 ba 75 02 80 00 00 	movabs $0x800275,%rdx
  801a88:	00 00 00 
  801a8b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a8d:	cc                   	int3   
  801a8e:	eb fd                	jmp    801a8d <_panic+0x111>
