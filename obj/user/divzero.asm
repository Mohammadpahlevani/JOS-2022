
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
  800078:	48 bf 40 18 80 00 00 	movabs $0x801840,%rdi
  80007f:	00 00 00 
  800082:	b8 00 00 00 00       	mov    $0x0,%eax
  800087:	48 ba 5b 02 80 00 00 	movabs $0x80025b,%rdx
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
  800099:	48 83 ec 10          	sub    $0x10,%rsp
  80009d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a4:	48 b8 d6 16 80 00 00 	movabs $0x8016d6,%rax
  8000ab:	00 00 00 
  8000ae:	ff d0                	callq  *%rax
  8000b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b5:	48 98                	cltq   
  8000b7:	48 c1 e0 03          	shl    $0x3,%rax
  8000bb:	48 89 c2             	mov    %rax,%rdx
  8000be:	48 c1 e2 05          	shl    $0x5,%rdx
  8000c2:	48 29 c2             	sub    %rax,%rdx
  8000c5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000cc:	00 00 00 
  8000cf:	48 01 c2             	add    %rax,%rdx
  8000d2:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  8000d9:	00 00 00 
  8000dc:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000e3:	7e 14                	jle    8000f9 <libmain+0x64>
		binaryname = argv[0];
  8000e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000e9:	48 8b 10             	mov    (%rax),%rdx
  8000ec:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000f3:	00 00 00 
  8000f6:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000f9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800100:	48 89 d6             	mov    %rdx,%rsi
  800103:	89 c7                	mov    %eax,%edi
  800105:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80010c:	00 00 00 
  80010f:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800111:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800118:	00 00 00 
  80011b:	ff d0                	callq  *%rax
}
  80011d:	c9                   	leaveq 
  80011e:	c3                   	retq   

000000000080011f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011f:	55                   	push   %rbp
  800120:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800123:	bf 00 00 00 00       	mov    $0x0,%edi
  800128:	48 b8 92 16 80 00 00 	movabs $0x801692,%rax
  80012f:	00 00 00 
  800132:	ff d0                	callq  *%rax
}
  800134:	5d                   	pop    %rbp
  800135:	c3                   	retq   

0000000000800136 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800136:	55                   	push   %rbp
  800137:	48 89 e5             	mov    %rsp,%rbp
  80013a:	48 83 ec 10          	sub    $0x10,%rsp
  80013e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800141:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800145:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800149:	8b 00                	mov    (%rax),%eax
  80014b:	8d 48 01             	lea    0x1(%rax),%ecx
  80014e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800152:	89 0a                	mov    %ecx,(%rdx)
  800154:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800157:	89 d1                	mov    %edx,%ecx
  800159:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80015d:	48 98                	cltq   
  80015f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800163:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800167:	8b 00                	mov    (%rax),%eax
  800169:	3d ff 00 00 00       	cmp    $0xff,%eax
  80016e:	75 2c                	jne    80019c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800170:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800174:	8b 00                	mov    (%rax),%eax
  800176:	48 98                	cltq   
  800178:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80017c:	48 83 c2 08          	add    $0x8,%rdx
  800180:	48 89 c6             	mov    %rax,%rsi
  800183:	48 89 d7             	mov    %rdx,%rdi
  800186:	48 b8 0a 16 80 00 00 	movabs $0x80160a,%rax
  80018d:	00 00 00 
  800190:	ff d0                	callq  *%rax
        b->idx = 0;
  800192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800196:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80019c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a0:	8b 40 04             	mov    0x4(%rax),%eax
  8001a3:	8d 50 01             	lea    0x1(%rax),%edx
  8001a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001aa:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001ad:	c9                   	leaveq 
  8001ae:	c3                   	retq   

00000000008001af <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001af:	55                   	push   %rbp
  8001b0:	48 89 e5             	mov    %rsp,%rbp
  8001b3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001ba:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001c1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001c8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001cf:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001d6:	48 8b 0a             	mov    (%rdx),%rcx
  8001d9:	48 89 08             	mov    %rcx,(%rax)
  8001dc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001e0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001e4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001e8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001f3:	00 00 00 
    b.cnt = 0;
  8001f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001fd:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800200:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800207:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80020e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800215:	48 89 c6             	mov    %rax,%rsi
  800218:	48 bf 36 01 80 00 00 	movabs $0x800136,%rdi
  80021f:	00 00 00 
  800222:	48 b8 0e 06 80 00 00 	movabs $0x80060e,%rax
  800229:	00 00 00 
  80022c:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80022e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800234:	48 98                	cltq   
  800236:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80023d:	48 83 c2 08          	add    $0x8,%rdx
  800241:	48 89 c6             	mov    %rax,%rsi
  800244:	48 89 d7             	mov    %rdx,%rdi
  800247:	48 b8 0a 16 80 00 00 	movabs $0x80160a,%rax
  80024e:	00 00 00 
  800251:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800253:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800259:	c9                   	leaveq 
  80025a:	c3                   	retq   

000000000080025b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80025b:	55                   	push   %rbp
  80025c:	48 89 e5             	mov    %rsp,%rbp
  80025f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800266:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80026d:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800274:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80027b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800282:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800289:	84 c0                	test   %al,%al
  80028b:	74 20                	je     8002ad <cprintf+0x52>
  80028d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800291:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800295:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800299:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80029d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002a1:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002a5:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002a9:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002ad:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002b4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002bb:	00 00 00 
  8002be:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002c5:	00 00 00 
  8002c8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002cc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002d3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002da:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002e1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002e8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002ef:	48 8b 0a             	mov    (%rdx),%rcx
  8002f2:	48 89 08             	mov    %rcx,(%rax)
  8002f5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002f9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002fd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800301:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800305:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80030c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800313:	48 89 d6             	mov    %rdx,%rsi
  800316:	48 89 c7             	mov    %rax,%rdi
  800319:	48 b8 af 01 80 00 00 	movabs $0x8001af,%rax
  800320:	00 00 00 
  800323:	ff d0                	callq  *%rax
  800325:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80032b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800331:	c9                   	leaveq 
  800332:	c3                   	retq   

0000000000800333 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800333:	55                   	push   %rbp
  800334:	48 89 e5             	mov    %rsp,%rbp
  800337:	53                   	push   %rbx
  800338:	48 83 ec 38          	sub    $0x38,%rsp
  80033c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800340:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800344:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800348:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80034b:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80034f:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800353:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800356:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80035a:	77 3b                	ja     800397 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80035c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80035f:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800363:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80036a:	ba 00 00 00 00       	mov    $0x0,%edx
  80036f:	48 f7 f3             	div    %rbx
  800372:	48 89 c2             	mov    %rax,%rdx
  800375:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800378:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80037b:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80037f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800383:	41 89 f9             	mov    %edi,%r9d
  800386:	48 89 c7             	mov    %rax,%rdi
  800389:	48 b8 33 03 80 00 00 	movabs $0x800333,%rax
  800390:	00 00 00 
  800393:	ff d0                	callq  *%rax
  800395:	eb 1e                	jmp    8003b5 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800397:	eb 12                	jmp    8003ab <printnum+0x78>
			putch(padc, putdat);
  800399:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80039d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003a4:	48 89 ce             	mov    %rcx,%rsi
  8003a7:	89 d7                	mov    %edx,%edi
  8003a9:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ab:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003af:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003b3:	7f e4                	jg     800399 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b5:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c1:	48 f7 f1             	div    %rcx
  8003c4:	48 89 d0             	mov    %rdx,%rax
  8003c7:	48 ba 90 19 80 00 00 	movabs $0x801990,%rdx
  8003ce:	00 00 00 
  8003d1:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003d5:	0f be d0             	movsbl %al,%edx
  8003d8:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003e0:	48 89 ce             	mov    %rcx,%rsi
  8003e3:	89 d7                	mov    %edx,%edi
  8003e5:	ff d0                	callq  *%rax
}
  8003e7:	48 83 c4 38          	add    $0x38,%rsp
  8003eb:	5b                   	pop    %rbx
  8003ec:	5d                   	pop    %rbp
  8003ed:	c3                   	retq   

00000000008003ee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ee:	55                   	push   %rbp
  8003ef:	48 89 e5             	mov    %rsp,%rbp
  8003f2:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003fa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800401:	7e 52                	jle    800455 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800407:	8b 00                	mov    (%rax),%eax
  800409:	83 f8 30             	cmp    $0x30,%eax
  80040c:	73 24                	jae    800432 <getuint+0x44>
  80040e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800412:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800416:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041a:	8b 00                	mov    (%rax),%eax
  80041c:	89 c0                	mov    %eax,%eax
  80041e:	48 01 d0             	add    %rdx,%rax
  800421:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800425:	8b 12                	mov    (%rdx),%edx
  800427:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80042a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042e:	89 0a                	mov    %ecx,(%rdx)
  800430:	eb 17                	jmp    800449 <getuint+0x5b>
  800432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800436:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80043a:	48 89 d0             	mov    %rdx,%rax
  80043d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800441:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800445:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800449:	48 8b 00             	mov    (%rax),%rax
  80044c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800450:	e9 a3 00 00 00       	jmpq   8004f8 <getuint+0x10a>
	else if (lflag)
  800455:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800459:	74 4f                	je     8004aa <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80045b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045f:	8b 00                	mov    (%rax),%eax
  800461:	83 f8 30             	cmp    $0x30,%eax
  800464:	73 24                	jae    80048a <getuint+0x9c>
  800466:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80046e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800472:	8b 00                	mov    (%rax),%eax
  800474:	89 c0                	mov    %eax,%eax
  800476:	48 01 d0             	add    %rdx,%rax
  800479:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047d:	8b 12                	mov    (%rdx),%edx
  80047f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800482:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800486:	89 0a                	mov    %ecx,(%rdx)
  800488:	eb 17                	jmp    8004a1 <getuint+0xb3>
  80048a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800492:	48 89 d0             	mov    %rdx,%rax
  800495:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800499:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80049d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004a1:	48 8b 00             	mov    (%rax),%rax
  8004a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004a8:	eb 4e                	jmp    8004f8 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ae:	8b 00                	mov    (%rax),%eax
  8004b0:	83 f8 30             	cmp    $0x30,%eax
  8004b3:	73 24                	jae    8004d9 <getuint+0xeb>
  8004b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c1:	8b 00                	mov    (%rax),%eax
  8004c3:	89 c0                	mov    %eax,%eax
  8004c5:	48 01 d0             	add    %rdx,%rax
  8004c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004cc:	8b 12                	mov    (%rdx),%edx
  8004ce:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d5:	89 0a                	mov    %ecx,(%rdx)
  8004d7:	eb 17                	jmp    8004f0 <getuint+0x102>
  8004d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004dd:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004e1:	48 89 d0             	mov    %rdx,%rax
  8004e4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004ec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004f0:	8b 00                	mov    (%rax),%eax
  8004f2:	89 c0                	mov    %eax,%eax
  8004f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004fc:	c9                   	leaveq 
  8004fd:	c3                   	retq   

00000000008004fe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004fe:	55                   	push   %rbp
  8004ff:	48 89 e5             	mov    %rsp,%rbp
  800502:	48 83 ec 1c          	sub    $0x1c,%rsp
  800506:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80050a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80050d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800511:	7e 52                	jle    800565 <getint+0x67>
		x=va_arg(*ap, long long);
  800513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800517:	8b 00                	mov    (%rax),%eax
  800519:	83 f8 30             	cmp    $0x30,%eax
  80051c:	73 24                	jae    800542 <getint+0x44>
  80051e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800522:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052a:	8b 00                	mov    (%rax),%eax
  80052c:	89 c0                	mov    %eax,%eax
  80052e:	48 01 d0             	add    %rdx,%rax
  800531:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800535:	8b 12                	mov    (%rdx),%edx
  800537:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80053a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053e:	89 0a                	mov    %ecx,(%rdx)
  800540:	eb 17                	jmp    800559 <getint+0x5b>
  800542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800546:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80054a:	48 89 d0             	mov    %rdx,%rax
  80054d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800551:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800555:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800559:	48 8b 00             	mov    (%rax),%rax
  80055c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800560:	e9 a3 00 00 00       	jmpq   800608 <getint+0x10a>
	else if (lflag)
  800565:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800569:	74 4f                	je     8005ba <getint+0xbc>
		x=va_arg(*ap, long);
  80056b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056f:	8b 00                	mov    (%rax),%eax
  800571:	83 f8 30             	cmp    $0x30,%eax
  800574:	73 24                	jae    80059a <getint+0x9c>
  800576:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80057e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800582:	8b 00                	mov    (%rax),%eax
  800584:	89 c0                	mov    %eax,%eax
  800586:	48 01 d0             	add    %rdx,%rax
  800589:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058d:	8b 12                	mov    (%rdx),%edx
  80058f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800592:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800596:	89 0a                	mov    %ecx,(%rdx)
  800598:	eb 17                	jmp    8005b1 <getint+0xb3>
  80059a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a2:	48 89 d0             	mov    %rdx,%rax
  8005a5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ad:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b1:	48 8b 00             	mov    (%rax),%rax
  8005b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005b8:	eb 4e                	jmp    800608 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005be:	8b 00                	mov    (%rax),%eax
  8005c0:	83 f8 30             	cmp    $0x30,%eax
  8005c3:	73 24                	jae    8005e9 <getint+0xeb>
  8005c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d1:	8b 00                	mov    (%rax),%eax
  8005d3:	89 c0                	mov    %eax,%eax
  8005d5:	48 01 d0             	add    %rdx,%rax
  8005d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005dc:	8b 12                	mov    (%rdx),%edx
  8005de:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e5:	89 0a                	mov    %ecx,(%rdx)
  8005e7:	eb 17                	jmp    800600 <getint+0x102>
  8005e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ed:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005f1:	48 89 d0             	mov    %rdx,%rax
  8005f4:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005f8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800600:	8b 00                	mov    (%rax),%eax
  800602:	48 98                	cltq   
  800604:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800608:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80060c:	c9                   	leaveq 
  80060d:	c3                   	retq   

000000000080060e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80060e:	55                   	push   %rbp
  80060f:	48 89 e5             	mov    %rsp,%rbp
  800612:	41 54                	push   %r12
  800614:	53                   	push   %rbx
  800615:	48 83 ec 60          	sub    $0x60,%rsp
  800619:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80061d:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800621:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800625:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800629:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80062d:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800631:	48 8b 0a             	mov    (%rdx),%rcx
  800634:	48 89 08             	mov    %rcx,(%rax)
  800637:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80063b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80063f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800643:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800647:	eb 17                	jmp    800660 <vprintfmt+0x52>
			if (ch == '\0')
  800649:	85 db                	test   %ebx,%ebx
  80064b:	0f 84 df 04 00 00    	je     800b30 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800651:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800655:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800659:	48 89 d6             	mov    %rdx,%rsi
  80065c:	89 df                	mov    %ebx,%edi
  80065e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800660:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800664:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800668:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80066c:	0f b6 00             	movzbl (%rax),%eax
  80066f:	0f b6 d8             	movzbl %al,%ebx
  800672:	83 fb 25             	cmp    $0x25,%ebx
  800675:	75 d2                	jne    800649 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800677:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80067b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800682:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800689:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800690:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800697:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80069b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80069f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006a3:	0f b6 00             	movzbl (%rax),%eax
  8006a6:	0f b6 d8             	movzbl %al,%ebx
  8006a9:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006ac:	83 f8 55             	cmp    $0x55,%eax
  8006af:	0f 87 47 04 00 00    	ja     800afc <vprintfmt+0x4ee>
  8006b5:	89 c0                	mov    %eax,%eax
  8006b7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006be:	00 
  8006bf:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  8006c6:	00 00 00 
  8006c9:	48 01 d0             	add    %rdx,%rax
  8006cc:	48 8b 00             	mov    (%rax),%rax
  8006cf:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006d1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006d5:	eb c0                	jmp    800697 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006d7:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006db:	eb ba                	jmp    800697 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006dd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006e4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006e7:	89 d0                	mov    %edx,%eax
  8006e9:	c1 e0 02             	shl    $0x2,%eax
  8006ec:	01 d0                	add    %edx,%eax
  8006ee:	01 c0                	add    %eax,%eax
  8006f0:	01 d8                	add    %ebx,%eax
  8006f2:	83 e8 30             	sub    $0x30,%eax
  8006f5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006f8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006fc:	0f b6 00             	movzbl (%rax),%eax
  8006ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800702:	83 fb 2f             	cmp    $0x2f,%ebx
  800705:	7e 0c                	jle    800713 <vprintfmt+0x105>
  800707:	83 fb 39             	cmp    $0x39,%ebx
  80070a:	7f 07                	jg     800713 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80070c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800711:	eb d1                	jmp    8006e4 <vprintfmt+0xd6>
			goto process_precision;
  800713:	eb 58                	jmp    80076d <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800715:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800718:	83 f8 30             	cmp    $0x30,%eax
  80071b:	73 17                	jae    800734 <vprintfmt+0x126>
  80071d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800721:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800724:	89 c0                	mov    %eax,%eax
  800726:	48 01 d0             	add    %rdx,%rax
  800729:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80072c:	83 c2 08             	add    $0x8,%edx
  80072f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800732:	eb 0f                	jmp    800743 <vprintfmt+0x135>
  800734:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800738:	48 89 d0             	mov    %rdx,%rax
  80073b:	48 83 c2 08          	add    $0x8,%rdx
  80073f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800743:	8b 00                	mov    (%rax),%eax
  800745:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800748:	eb 23                	jmp    80076d <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80074a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80074e:	79 0c                	jns    80075c <vprintfmt+0x14e>
				width = 0;
  800750:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800757:	e9 3b ff ff ff       	jmpq   800697 <vprintfmt+0x89>
  80075c:	e9 36 ff ff ff       	jmpq   800697 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800761:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800768:	e9 2a ff ff ff       	jmpq   800697 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80076d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800771:	79 12                	jns    800785 <vprintfmt+0x177>
				width = precision, precision = -1;
  800773:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800776:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800779:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800780:	e9 12 ff ff ff       	jmpq   800697 <vprintfmt+0x89>
  800785:	e9 0d ff ff ff       	jmpq   800697 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80078a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80078e:	e9 04 ff ff ff       	jmpq   800697 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800793:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800796:	83 f8 30             	cmp    $0x30,%eax
  800799:	73 17                	jae    8007b2 <vprintfmt+0x1a4>
  80079b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80079f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a2:	89 c0                	mov    %eax,%eax
  8007a4:	48 01 d0             	add    %rdx,%rax
  8007a7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007aa:	83 c2 08             	add    $0x8,%edx
  8007ad:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007b0:	eb 0f                	jmp    8007c1 <vprintfmt+0x1b3>
  8007b2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007b6:	48 89 d0             	mov    %rdx,%rax
  8007b9:	48 83 c2 08          	add    $0x8,%rdx
  8007bd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007c1:	8b 10                	mov    (%rax),%edx
  8007c3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007cb:	48 89 ce             	mov    %rcx,%rsi
  8007ce:	89 d7                	mov    %edx,%edi
  8007d0:	ff d0                	callq  *%rax
			break;
  8007d2:	e9 53 03 00 00       	jmpq   800b2a <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007d7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007da:	83 f8 30             	cmp    $0x30,%eax
  8007dd:	73 17                	jae    8007f6 <vprintfmt+0x1e8>
  8007df:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007e3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e6:	89 c0                	mov    %eax,%eax
  8007e8:	48 01 d0             	add    %rdx,%rax
  8007eb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007ee:	83 c2 08             	add    $0x8,%edx
  8007f1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f4:	eb 0f                	jmp    800805 <vprintfmt+0x1f7>
  8007f6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fa:	48 89 d0             	mov    %rdx,%rax
  8007fd:	48 83 c2 08          	add    $0x8,%rdx
  800801:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800805:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800807:	85 db                	test   %ebx,%ebx
  800809:	79 02                	jns    80080d <vprintfmt+0x1ff>
				err = -err;
  80080b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80080d:	83 fb 15             	cmp    $0x15,%ebx
  800810:	7f 16                	jg     800828 <vprintfmt+0x21a>
  800812:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  800819:	00 00 00 
  80081c:	48 63 d3             	movslq %ebx,%rdx
  80081f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800823:	4d 85 e4             	test   %r12,%r12
  800826:	75 2e                	jne    800856 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800828:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80082c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800830:	89 d9                	mov    %ebx,%ecx
  800832:	48 ba a1 19 80 00 00 	movabs $0x8019a1,%rdx
  800839:	00 00 00 
  80083c:	48 89 c7             	mov    %rax,%rdi
  80083f:	b8 00 00 00 00       	mov    $0x0,%eax
  800844:	49 b8 39 0b 80 00 00 	movabs $0x800b39,%r8
  80084b:	00 00 00 
  80084e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800851:	e9 d4 02 00 00       	jmpq   800b2a <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800856:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80085a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80085e:	4c 89 e1             	mov    %r12,%rcx
  800861:	48 ba aa 19 80 00 00 	movabs $0x8019aa,%rdx
  800868:	00 00 00 
  80086b:	48 89 c7             	mov    %rax,%rdi
  80086e:	b8 00 00 00 00       	mov    $0x0,%eax
  800873:	49 b8 39 0b 80 00 00 	movabs $0x800b39,%r8
  80087a:	00 00 00 
  80087d:	41 ff d0             	callq  *%r8
			break;
  800880:	e9 a5 02 00 00       	jmpq   800b2a <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800885:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800888:	83 f8 30             	cmp    $0x30,%eax
  80088b:	73 17                	jae    8008a4 <vprintfmt+0x296>
  80088d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800891:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800894:	89 c0                	mov    %eax,%eax
  800896:	48 01 d0             	add    %rdx,%rax
  800899:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80089c:	83 c2 08             	add    $0x8,%edx
  80089f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008a2:	eb 0f                	jmp    8008b3 <vprintfmt+0x2a5>
  8008a4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008a8:	48 89 d0             	mov    %rdx,%rax
  8008ab:	48 83 c2 08          	add    $0x8,%rdx
  8008af:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008b3:	4c 8b 20             	mov    (%rax),%r12
  8008b6:	4d 85 e4             	test   %r12,%r12
  8008b9:	75 0a                	jne    8008c5 <vprintfmt+0x2b7>
				p = "(null)";
  8008bb:	49 bc ad 19 80 00 00 	movabs $0x8019ad,%r12
  8008c2:	00 00 00 
			if (width > 0 && padc != '-')
  8008c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c9:	7e 3f                	jle    80090a <vprintfmt+0x2fc>
  8008cb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008cf:	74 39                	je     80090a <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008d4:	48 98                	cltq   
  8008d6:	48 89 c6             	mov    %rax,%rsi
  8008d9:	4c 89 e7             	mov    %r12,%rdi
  8008dc:	48 b8 e5 0d 80 00 00 	movabs $0x800de5,%rax
  8008e3:	00 00 00 
  8008e6:	ff d0                	callq  *%rax
  8008e8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008eb:	eb 17                	jmp    800904 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008ed:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008f1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f9:	48 89 ce             	mov    %rcx,%rsi
  8008fc:	89 d7                	mov    %edx,%edi
  8008fe:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800900:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800904:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800908:	7f e3                	jg     8008ed <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80090a:	eb 37                	jmp    800943 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80090c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800910:	74 1e                	je     800930 <vprintfmt+0x322>
  800912:	83 fb 1f             	cmp    $0x1f,%ebx
  800915:	7e 05                	jle    80091c <vprintfmt+0x30e>
  800917:	83 fb 7e             	cmp    $0x7e,%ebx
  80091a:	7e 14                	jle    800930 <vprintfmt+0x322>
					putch('?', putdat);
  80091c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800920:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800924:	48 89 d6             	mov    %rdx,%rsi
  800927:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80092c:	ff d0                	callq  *%rax
  80092e:	eb 0f                	jmp    80093f <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800930:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800934:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800938:	48 89 d6             	mov    %rdx,%rsi
  80093b:	89 df                	mov    %ebx,%edi
  80093d:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800943:	4c 89 e0             	mov    %r12,%rax
  800946:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80094a:	0f b6 00             	movzbl (%rax),%eax
  80094d:	0f be d8             	movsbl %al,%ebx
  800950:	85 db                	test   %ebx,%ebx
  800952:	74 10                	je     800964 <vprintfmt+0x356>
  800954:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800958:	78 b2                	js     80090c <vprintfmt+0x2fe>
  80095a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80095e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800962:	79 a8                	jns    80090c <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800964:	eb 16                	jmp    80097c <vprintfmt+0x36e>
				putch(' ', putdat);
  800966:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80096a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80096e:	48 89 d6             	mov    %rdx,%rsi
  800971:	bf 20 00 00 00       	mov    $0x20,%edi
  800976:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800978:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80097c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800980:	7f e4                	jg     800966 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800982:	e9 a3 01 00 00       	jmpq   800b2a <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800987:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80098b:	be 03 00 00 00       	mov    $0x3,%esi
  800990:	48 89 c7             	mov    %rax,%rdi
  800993:	48 b8 fe 04 80 00 00 	movabs $0x8004fe,%rax
  80099a:	00 00 00 
  80099d:	ff d0                	callq  *%rax
  80099f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a7:	48 85 c0             	test   %rax,%rax
  8009aa:	79 1d                	jns    8009c9 <vprintfmt+0x3bb>
				putch('-', putdat);
  8009ac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b4:	48 89 d6             	mov    %rdx,%rsi
  8009b7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009bc:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c2:	48 f7 d8             	neg    %rax
  8009c5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009c9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009d0:	e9 e8 00 00 00       	jmpq   800abd <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009d5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009d9:	be 03 00 00 00       	mov    $0x3,%esi
  8009de:	48 89 c7             	mov    %rax,%rdi
  8009e1:	48 b8 ee 03 80 00 00 	movabs $0x8003ee,%rax
  8009e8:	00 00 00 
  8009eb:	ff d0                	callq  *%rax
  8009ed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009f1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009f8:	e9 c0 00 00 00       	jmpq   800abd <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009fd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a01:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a05:	48 89 d6             	mov    %rdx,%rsi
  800a08:	bf 58 00 00 00       	mov    $0x58,%edi
  800a0d:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a0f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a17:	48 89 d6             	mov    %rdx,%rsi
  800a1a:	bf 58 00 00 00       	mov    $0x58,%edi
  800a1f:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a21:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a29:	48 89 d6             	mov    %rdx,%rsi
  800a2c:	bf 58 00 00 00       	mov    $0x58,%edi
  800a31:	ff d0                	callq  *%rax
			break;
  800a33:	e9 f2 00 00 00       	jmpq   800b2a <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a40:	48 89 d6             	mov    %rdx,%rsi
  800a43:	bf 30 00 00 00       	mov    $0x30,%edi
  800a48:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a52:	48 89 d6             	mov    %rdx,%rsi
  800a55:	bf 78 00 00 00       	mov    $0x78,%edi
  800a5a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5f:	83 f8 30             	cmp    $0x30,%eax
  800a62:	73 17                	jae    800a7b <vprintfmt+0x46d>
  800a64:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a68:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6b:	89 c0                	mov    %eax,%eax
  800a6d:	48 01 d0             	add    %rdx,%rax
  800a70:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a73:	83 c2 08             	add    $0x8,%edx
  800a76:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a79:	eb 0f                	jmp    800a8a <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a7b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a7f:	48 89 d0             	mov    %rdx,%rax
  800a82:	48 83 c2 08          	add    $0x8,%rdx
  800a86:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a8a:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a91:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a98:	eb 23                	jmp    800abd <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a9a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a9e:	be 03 00 00 00       	mov    $0x3,%esi
  800aa3:	48 89 c7             	mov    %rax,%rdi
  800aa6:	48 b8 ee 03 80 00 00 	movabs $0x8003ee,%rax
  800aad:	00 00 00 
  800ab0:	ff d0                	callq  *%rax
  800ab2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ab6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800abd:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800ac2:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ac5:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ac8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ad0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad4:	45 89 c1             	mov    %r8d,%r9d
  800ad7:	41 89 f8             	mov    %edi,%r8d
  800ada:	48 89 c7             	mov    %rax,%rdi
  800add:	48 b8 33 03 80 00 00 	movabs $0x800333,%rax
  800ae4:	00 00 00 
  800ae7:	ff d0                	callq  *%rax
			break;
  800ae9:	eb 3f                	jmp    800b2a <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aeb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aef:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af3:	48 89 d6             	mov    %rdx,%rsi
  800af6:	89 df                	mov    %ebx,%edi
  800af8:	ff d0                	callq  *%rax
			break;
  800afa:	eb 2e                	jmp    800b2a <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800afc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b04:	48 89 d6             	mov    %rdx,%rsi
  800b07:	bf 25 00 00 00       	mov    $0x25,%edi
  800b0c:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b0e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b13:	eb 05                	jmp    800b1a <vprintfmt+0x50c>
  800b15:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b1a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b1e:	48 83 e8 01          	sub    $0x1,%rax
  800b22:	0f b6 00             	movzbl (%rax),%eax
  800b25:	3c 25                	cmp    $0x25,%al
  800b27:	75 ec                	jne    800b15 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b29:	90                   	nop
		}
	}
  800b2a:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2b:	e9 30 fb ff ff       	jmpq   800660 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b30:	48 83 c4 60          	add    $0x60,%rsp
  800b34:	5b                   	pop    %rbx
  800b35:	41 5c                	pop    %r12
  800b37:	5d                   	pop    %rbp
  800b38:	c3                   	retq   

0000000000800b39 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b39:	55                   	push   %rbp
  800b3a:	48 89 e5             	mov    %rsp,%rbp
  800b3d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b44:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b4b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b52:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b59:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b60:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b67:	84 c0                	test   %al,%al
  800b69:	74 20                	je     800b8b <printfmt+0x52>
  800b6b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b6f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b73:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b77:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b7b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b7f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b83:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b87:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b8b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b92:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b99:	00 00 00 
  800b9c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ba3:	00 00 00 
  800ba6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800baa:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bb1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bb8:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bbf:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bc6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bcd:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bd4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bdb:	48 89 c7             	mov    %rax,%rdi
  800bde:	48 b8 0e 06 80 00 00 	movabs $0x80060e,%rax
  800be5:	00 00 00 
  800be8:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bea:	c9                   	leaveq 
  800beb:	c3                   	retq   

0000000000800bec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bec:	55                   	push   %rbp
  800bed:	48 89 e5             	mov    %rsp,%rbp
  800bf0:	48 83 ec 10          	sub    $0x10,%rsp
  800bf4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bf7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bff:	8b 40 10             	mov    0x10(%rax),%eax
  800c02:	8d 50 01             	lea    0x1(%rax),%edx
  800c05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c09:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c10:	48 8b 10             	mov    (%rax),%rdx
  800c13:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c17:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c1b:	48 39 c2             	cmp    %rax,%rdx
  800c1e:	73 17                	jae    800c37 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c24:	48 8b 00             	mov    (%rax),%rax
  800c27:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c2b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c2f:	48 89 0a             	mov    %rcx,(%rdx)
  800c32:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c35:	88 10                	mov    %dl,(%rax)
}
  800c37:	c9                   	leaveq 
  800c38:	c3                   	retq   

0000000000800c39 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c39:	55                   	push   %rbp
  800c3a:	48 89 e5             	mov    %rsp,%rbp
  800c3d:	48 83 ec 50          	sub    $0x50,%rsp
  800c41:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c45:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c48:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c4c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c50:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c54:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c58:	48 8b 0a             	mov    (%rdx),%rcx
  800c5b:	48 89 08             	mov    %rcx,(%rax)
  800c5e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c62:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c66:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c6a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c6e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c72:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c76:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c79:	48 98                	cltq   
  800c7b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c7f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c83:	48 01 d0             	add    %rdx,%rax
  800c86:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c8a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c91:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c96:	74 06                	je     800c9e <vsnprintf+0x65>
  800c98:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c9c:	7f 07                	jg     800ca5 <vsnprintf+0x6c>
		return -E_INVAL;
  800c9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ca3:	eb 2f                	jmp    800cd4 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ca5:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ca9:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cad:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cb1:	48 89 c6             	mov    %rax,%rsi
  800cb4:	48 bf ec 0b 80 00 00 	movabs $0x800bec,%rdi
  800cbb:	00 00 00 
  800cbe:	48 b8 0e 06 80 00 00 	movabs $0x80060e,%rax
  800cc5:	00 00 00 
  800cc8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cce:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cd1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cd4:	c9                   	leaveq 
  800cd5:	c3                   	retq   

0000000000800cd6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd6:	55                   	push   %rbp
  800cd7:	48 89 e5             	mov    %rsp,%rbp
  800cda:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ce1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ce8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cee:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cf5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cfc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d03:	84 c0                	test   %al,%al
  800d05:	74 20                	je     800d27 <snprintf+0x51>
  800d07:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d0b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d0f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d13:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d17:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d1b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d1f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d23:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d27:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d2e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d35:	00 00 00 
  800d38:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d3f:	00 00 00 
  800d42:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d46:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d4d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d54:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d5b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d62:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d69:	48 8b 0a             	mov    (%rdx),%rcx
  800d6c:	48 89 08             	mov    %rcx,(%rax)
  800d6f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d73:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d77:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d7b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d7f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d86:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d8d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d93:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d9a:	48 89 c7             	mov    %rax,%rdi
  800d9d:	48 b8 39 0c 80 00 00 	movabs $0x800c39,%rax
  800da4:	00 00 00 
  800da7:	ff d0                	callq  *%rax
  800da9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800daf:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800db5:	c9                   	leaveq 
  800db6:	c3                   	retq   

0000000000800db7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800db7:	55                   	push   %rbp
  800db8:	48 89 e5             	mov    %rsp,%rbp
  800dbb:	48 83 ec 18          	sub    $0x18,%rsp
  800dbf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dca:	eb 09                	jmp    800dd5 <strlen+0x1e>
		n++;
  800dcc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dd9:	0f b6 00             	movzbl (%rax),%eax
  800ddc:	84 c0                	test   %al,%al
  800dde:	75 ec                	jne    800dcc <strlen+0x15>
		n++;
	return n;
  800de0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800de3:	c9                   	leaveq 
  800de4:	c3                   	retq   

0000000000800de5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800de5:	55                   	push   %rbp
  800de6:	48 89 e5             	mov    %rsp,%rbp
  800de9:	48 83 ec 20          	sub    $0x20,%rsp
  800ded:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800df1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dfc:	eb 0e                	jmp    800e0c <strnlen+0x27>
		n++;
  800dfe:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e02:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e07:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e0c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e11:	74 0b                	je     800e1e <strnlen+0x39>
  800e13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e17:	0f b6 00             	movzbl (%rax),%eax
  800e1a:	84 c0                	test   %al,%al
  800e1c:	75 e0                	jne    800dfe <strnlen+0x19>
		n++;
	return n;
  800e1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e21:	c9                   	leaveq 
  800e22:	c3                   	retq   

0000000000800e23 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e23:	55                   	push   %rbp
  800e24:	48 89 e5             	mov    %rsp,%rbp
  800e27:	48 83 ec 20          	sub    $0x20,%rsp
  800e2b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e2f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e3b:	90                   	nop
  800e3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e40:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e44:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e48:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e4c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e50:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e54:	0f b6 12             	movzbl (%rdx),%edx
  800e57:	88 10                	mov    %dl,(%rax)
  800e59:	0f b6 00             	movzbl (%rax),%eax
  800e5c:	84 c0                	test   %al,%al
  800e5e:	75 dc                	jne    800e3c <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e64:	c9                   	leaveq 
  800e65:	c3                   	retq   

0000000000800e66 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e66:	55                   	push   %rbp
  800e67:	48 89 e5             	mov    %rsp,%rbp
  800e6a:	48 83 ec 20          	sub    $0x20,%rsp
  800e6e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7a:	48 89 c7             	mov    %rax,%rdi
  800e7d:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  800e84:	00 00 00 
  800e87:	ff d0                	callq  *%rax
  800e89:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e8f:	48 63 d0             	movslq %eax,%rdx
  800e92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e96:	48 01 c2             	add    %rax,%rdx
  800e99:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e9d:	48 89 c6             	mov    %rax,%rsi
  800ea0:	48 89 d7             	mov    %rdx,%rdi
  800ea3:	48 b8 23 0e 80 00 00 	movabs $0x800e23,%rax
  800eaa:	00 00 00 
  800ead:	ff d0                	callq  *%rax
	return dst;
  800eaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800eb3:	c9                   	leaveq 
  800eb4:	c3                   	retq   

0000000000800eb5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800eb5:	55                   	push   %rbp
  800eb6:	48 89 e5             	mov    %rsp,%rbp
  800eb9:	48 83 ec 28          	sub    $0x28,%rsp
  800ebd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ec5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ec9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ecd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800ed1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ed8:	00 
  800ed9:	eb 2a                	jmp    800f05 <strncpy+0x50>
		*dst++ = *src;
  800edb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ee3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ee7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800eeb:	0f b6 12             	movzbl (%rdx),%edx
  800eee:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ef4:	0f b6 00             	movzbl (%rax),%eax
  800ef7:	84 c0                	test   %al,%al
  800ef9:	74 05                	je     800f00 <strncpy+0x4b>
			src++;
  800efb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f00:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f09:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f0d:	72 cc                	jb     800edb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f13:	c9                   	leaveq 
  800f14:	c3                   	retq   

0000000000800f15 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f15:	55                   	push   %rbp
  800f16:	48 89 e5             	mov    %rsp,%rbp
  800f19:	48 83 ec 28          	sub    $0x28,%rsp
  800f1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f25:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f31:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f36:	74 3d                	je     800f75 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f38:	eb 1d                	jmp    800f57 <strlcpy+0x42>
			*dst++ = *src++;
  800f3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f42:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f46:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f4a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f4e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f52:	0f b6 12             	movzbl (%rdx),%edx
  800f55:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f57:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f5c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f61:	74 0b                	je     800f6e <strlcpy+0x59>
  800f63:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f67:	0f b6 00             	movzbl (%rax),%eax
  800f6a:	84 c0                	test   %al,%al
  800f6c:	75 cc                	jne    800f3a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f72:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f75:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f7d:	48 29 c2             	sub    %rax,%rdx
  800f80:	48 89 d0             	mov    %rdx,%rax
}
  800f83:	c9                   	leaveq 
  800f84:	c3                   	retq   

0000000000800f85 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f85:	55                   	push   %rbp
  800f86:	48 89 e5             	mov    %rsp,%rbp
  800f89:	48 83 ec 10          	sub    $0x10,%rsp
  800f8d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f91:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f95:	eb 0a                	jmp    800fa1 <strcmp+0x1c>
		p++, q++;
  800f97:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f9c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fa5:	0f b6 00             	movzbl (%rax),%eax
  800fa8:	84 c0                	test   %al,%al
  800faa:	74 12                	je     800fbe <strcmp+0x39>
  800fac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb0:	0f b6 10             	movzbl (%rax),%edx
  800fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb7:	0f b6 00             	movzbl (%rax),%eax
  800fba:	38 c2                	cmp    %al,%dl
  800fbc:	74 d9                	je     800f97 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc2:	0f b6 00             	movzbl (%rax),%eax
  800fc5:	0f b6 d0             	movzbl %al,%edx
  800fc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fcc:	0f b6 00             	movzbl (%rax),%eax
  800fcf:	0f b6 c0             	movzbl %al,%eax
  800fd2:	29 c2                	sub    %eax,%edx
  800fd4:	89 d0                	mov    %edx,%eax
}
  800fd6:	c9                   	leaveq 
  800fd7:	c3                   	retq   

0000000000800fd8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fd8:	55                   	push   %rbp
  800fd9:	48 89 e5             	mov    %rsp,%rbp
  800fdc:	48 83 ec 18          	sub    $0x18,%rsp
  800fe0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fe4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fe8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fec:	eb 0f                	jmp    800ffd <strncmp+0x25>
		n--, p++, q++;
  800fee:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800ff3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ff8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ffd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801002:	74 1d                	je     801021 <strncmp+0x49>
  801004:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801008:	0f b6 00             	movzbl (%rax),%eax
  80100b:	84 c0                	test   %al,%al
  80100d:	74 12                	je     801021 <strncmp+0x49>
  80100f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801013:	0f b6 10             	movzbl (%rax),%edx
  801016:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80101a:	0f b6 00             	movzbl (%rax),%eax
  80101d:	38 c2                	cmp    %al,%dl
  80101f:	74 cd                	je     800fee <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801021:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801026:	75 07                	jne    80102f <strncmp+0x57>
		return 0;
  801028:	b8 00 00 00 00       	mov    $0x0,%eax
  80102d:	eb 18                	jmp    801047 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80102f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801033:	0f b6 00             	movzbl (%rax),%eax
  801036:	0f b6 d0             	movzbl %al,%edx
  801039:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103d:	0f b6 00             	movzbl (%rax),%eax
  801040:	0f b6 c0             	movzbl %al,%eax
  801043:	29 c2                	sub    %eax,%edx
  801045:	89 d0                	mov    %edx,%eax
}
  801047:	c9                   	leaveq 
  801048:	c3                   	retq   

0000000000801049 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801049:	55                   	push   %rbp
  80104a:	48 89 e5             	mov    %rsp,%rbp
  80104d:	48 83 ec 0c          	sub    $0xc,%rsp
  801051:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801055:	89 f0                	mov    %esi,%eax
  801057:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80105a:	eb 17                	jmp    801073 <strchr+0x2a>
		if (*s == c)
  80105c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801060:	0f b6 00             	movzbl (%rax),%eax
  801063:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801066:	75 06                	jne    80106e <strchr+0x25>
			return (char *) s;
  801068:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106c:	eb 15                	jmp    801083 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80106e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801073:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801077:	0f b6 00             	movzbl (%rax),%eax
  80107a:	84 c0                	test   %al,%al
  80107c:	75 de                	jne    80105c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80107e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801083:	c9                   	leaveq 
  801084:	c3                   	retq   

0000000000801085 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801085:	55                   	push   %rbp
  801086:	48 89 e5             	mov    %rsp,%rbp
  801089:	48 83 ec 0c          	sub    $0xc,%rsp
  80108d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801091:	89 f0                	mov    %esi,%eax
  801093:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801096:	eb 13                	jmp    8010ab <strfind+0x26>
		if (*s == c)
  801098:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109c:	0f b6 00             	movzbl (%rax),%eax
  80109f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010a2:	75 02                	jne    8010a6 <strfind+0x21>
			break;
  8010a4:	eb 10                	jmp    8010b6 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010a6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010af:	0f b6 00             	movzbl (%rax),%eax
  8010b2:	84 c0                	test   %al,%al
  8010b4:	75 e2                	jne    801098 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010ba:	c9                   	leaveq 
  8010bb:	c3                   	retq   

00000000008010bc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010bc:	55                   	push   %rbp
  8010bd:	48 89 e5             	mov    %rsp,%rbp
  8010c0:	48 83 ec 18          	sub    $0x18,%rsp
  8010c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010c8:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010cf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d4:	75 06                	jne    8010dc <memset+0x20>
		return v;
  8010d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010da:	eb 69                	jmp    801145 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e0:	83 e0 03             	and    $0x3,%eax
  8010e3:	48 85 c0             	test   %rax,%rax
  8010e6:	75 48                	jne    801130 <memset+0x74>
  8010e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ec:	83 e0 03             	and    $0x3,%eax
  8010ef:	48 85 c0             	test   %rax,%rax
  8010f2:	75 3c                	jne    801130 <memset+0x74>
		c &= 0xFF;
  8010f4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010fe:	c1 e0 18             	shl    $0x18,%eax
  801101:	89 c2                	mov    %eax,%edx
  801103:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801106:	c1 e0 10             	shl    $0x10,%eax
  801109:	09 c2                	or     %eax,%edx
  80110b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80110e:	c1 e0 08             	shl    $0x8,%eax
  801111:	09 d0                	or     %edx,%eax
  801113:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111a:	48 c1 e8 02          	shr    $0x2,%rax
  80111e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801121:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801125:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801128:	48 89 d7             	mov    %rdx,%rdi
  80112b:	fc                   	cld    
  80112c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80112e:	eb 11                	jmp    801141 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801130:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801134:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801137:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80113b:	48 89 d7             	mov    %rdx,%rdi
  80113e:	fc                   	cld    
  80113f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801141:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801145:	c9                   	leaveq 
  801146:	c3                   	retq   

0000000000801147 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801147:	55                   	push   %rbp
  801148:	48 89 e5             	mov    %rsp,%rbp
  80114b:	48 83 ec 28          	sub    $0x28,%rsp
  80114f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801153:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801157:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80115b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80115f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801163:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801167:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80116b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801173:	0f 83 88 00 00 00    	jae    801201 <memmove+0xba>
  801179:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80117d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801181:	48 01 d0             	add    %rdx,%rax
  801184:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801188:	76 77                	jbe    801201 <memmove+0xba>
		s += n;
  80118a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80118e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801192:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801196:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80119a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119e:	83 e0 03             	and    $0x3,%eax
  8011a1:	48 85 c0             	test   %rax,%rax
  8011a4:	75 3b                	jne    8011e1 <memmove+0x9a>
  8011a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011aa:	83 e0 03             	and    $0x3,%eax
  8011ad:	48 85 c0             	test   %rax,%rax
  8011b0:	75 2f                	jne    8011e1 <memmove+0x9a>
  8011b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011b6:	83 e0 03             	and    $0x3,%eax
  8011b9:	48 85 c0             	test   %rax,%rax
  8011bc:	75 23                	jne    8011e1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c2:	48 83 e8 04          	sub    $0x4,%rax
  8011c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ca:	48 83 ea 04          	sub    $0x4,%rdx
  8011ce:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011d2:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011d6:	48 89 c7             	mov    %rax,%rdi
  8011d9:	48 89 d6             	mov    %rdx,%rsi
  8011dc:	fd                   	std    
  8011dd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011df:	eb 1d                	jmp    8011fe <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ed:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011f5:	48 89 d7             	mov    %rdx,%rdi
  8011f8:	48 89 c1             	mov    %rax,%rcx
  8011fb:	fd                   	std    
  8011fc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011fe:	fc                   	cld    
  8011ff:	eb 57                	jmp    801258 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801201:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801205:	83 e0 03             	and    $0x3,%eax
  801208:	48 85 c0             	test   %rax,%rax
  80120b:	75 36                	jne    801243 <memmove+0xfc>
  80120d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801211:	83 e0 03             	and    $0x3,%eax
  801214:	48 85 c0             	test   %rax,%rax
  801217:	75 2a                	jne    801243 <memmove+0xfc>
  801219:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80121d:	83 e0 03             	and    $0x3,%eax
  801220:	48 85 c0             	test   %rax,%rax
  801223:	75 1e                	jne    801243 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801225:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801229:	48 c1 e8 02          	shr    $0x2,%rax
  80122d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801234:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801238:	48 89 c7             	mov    %rax,%rdi
  80123b:	48 89 d6             	mov    %rdx,%rsi
  80123e:	fc                   	cld    
  80123f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801241:	eb 15                	jmp    801258 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801243:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801247:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80124b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80124f:	48 89 c7             	mov    %rax,%rdi
  801252:	48 89 d6             	mov    %rdx,%rsi
  801255:	fc                   	cld    
  801256:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80125c:	c9                   	leaveq 
  80125d:	c3                   	retq   

000000000080125e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80125e:	55                   	push   %rbp
  80125f:	48 89 e5             	mov    %rsp,%rbp
  801262:	48 83 ec 18          	sub    $0x18,%rsp
  801266:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80126e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801272:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801276:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80127a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80127e:	48 89 ce             	mov    %rcx,%rsi
  801281:	48 89 c7             	mov    %rax,%rdi
  801284:	48 b8 47 11 80 00 00 	movabs $0x801147,%rax
  80128b:	00 00 00 
  80128e:	ff d0                	callq  *%rax
}
  801290:	c9                   	leaveq 
  801291:	c3                   	retq   

0000000000801292 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801292:	55                   	push   %rbp
  801293:	48 89 e5             	mov    %rsp,%rbp
  801296:	48 83 ec 28          	sub    $0x28,%rsp
  80129a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80129e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012b6:	eb 36                	jmp    8012ee <memcmp+0x5c>
		if (*s1 != *s2)
  8012b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bc:	0f b6 10             	movzbl (%rax),%edx
  8012bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c3:	0f b6 00             	movzbl (%rax),%eax
  8012c6:	38 c2                	cmp    %al,%dl
  8012c8:	74 1a                	je     8012e4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ce:	0f b6 00             	movzbl (%rax),%eax
  8012d1:	0f b6 d0             	movzbl %al,%edx
  8012d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012d8:	0f b6 00             	movzbl (%rax),%eax
  8012db:	0f b6 c0             	movzbl %al,%eax
  8012de:	29 c2                	sub    %eax,%edx
  8012e0:	89 d0                	mov    %edx,%eax
  8012e2:	eb 20                	jmp    801304 <memcmp+0x72>
		s1++, s2++;
  8012e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012e9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012fa:	48 85 c0             	test   %rax,%rax
  8012fd:	75 b9                	jne    8012b8 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801304:	c9                   	leaveq 
  801305:	c3                   	retq   

0000000000801306 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801306:	55                   	push   %rbp
  801307:	48 89 e5             	mov    %rsp,%rbp
  80130a:	48 83 ec 28          	sub    $0x28,%rsp
  80130e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801312:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801315:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801319:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80131d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801321:	48 01 d0             	add    %rdx,%rax
  801324:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801328:	eb 15                	jmp    80133f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80132a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132e:	0f b6 10             	movzbl (%rax),%edx
  801331:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801334:	38 c2                	cmp    %al,%dl
  801336:	75 02                	jne    80133a <memfind+0x34>
			break;
  801338:	eb 0f                	jmp    801349 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80133a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80133f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801343:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801347:	72 e1                	jb     80132a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801349:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80134d:	c9                   	leaveq 
  80134e:	c3                   	retq   

000000000080134f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80134f:	55                   	push   %rbp
  801350:	48 89 e5             	mov    %rsp,%rbp
  801353:	48 83 ec 34          	sub    $0x34,%rsp
  801357:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80135b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80135f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801362:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801369:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801370:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801371:	eb 05                	jmp    801378 <strtol+0x29>
		s++;
  801373:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801378:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137c:	0f b6 00             	movzbl (%rax),%eax
  80137f:	3c 20                	cmp    $0x20,%al
  801381:	74 f0                	je     801373 <strtol+0x24>
  801383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801387:	0f b6 00             	movzbl (%rax),%eax
  80138a:	3c 09                	cmp    $0x9,%al
  80138c:	74 e5                	je     801373 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80138e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801392:	0f b6 00             	movzbl (%rax),%eax
  801395:	3c 2b                	cmp    $0x2b,%al
  801397:	75 07                	jne    8013a0 <strtol+0x51>
		s++;
  801399:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80139e:	eb 17                	jmp    8013b7 <strtol+0x68>
	else if (*s == '-')
  8013a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a4:	0f b6 00             	movzbl (%rax),%eax
  8013a7:	3c 2d                	cmp    $0x2d,%al
  8013a9:	75 0c                	jne    8013b7 <strtol+0x68>
		s++, neg = 1;
  8013ab:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013b0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013b7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013bb:	74 06                	je     8013c3 <strtol+0x74>
  8013bd:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013c1:	75 28                	jne    8013eb <strtol+0x9c>
  8013c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c7:	0f b6 00             	movzbl (%rax),%eax
  8013ca:	3c 30                	cmp    $0x30,%al
  8013cc:	75 1d                	jne    8013eb <strtol+0x9c>
  8013ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d2:	48 83 c0 01          	add    $0x1,%rax
  8013d6:	0f b6 00             	movzbl (%rax),%eax
  8013d9:	3c 78                	cmp    $0x78,%al
  8013db:	75 0e                	jne    8013eb <strtol+0x9c>
		s += 2, base = 16;
  8013dd:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013e2:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013e9:	eb 2c                	jmp    801417 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013eb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013ef:	75 19                	jne    80140a <strtol+0xbb>
  8013f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f5:	0f b6 00             	movzbl (%rax),%eax
  8013f8:	3c 30                	cmp    $0x30,%al
  8013fa:	75 0e                	jne    80140a <strtol+0xbb>
		s++, base = 8;
  8013fc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801401:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801408:	eb 0d                	jmp    801417 <strtol+0xc8>
	else if (base == 0)
  80140a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80140e:	75 07                	jne    801417 <strtol+0xc8>
		base = 10;
  801410:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801417:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141b:	0f b6 00             	movzbl (%rax),%eax
  80141e:	3c 2f                	cmp    $0x2f,%al
  801420:	7e 1d                	jle    80143f <strtol+0xf0>
  801422:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801426:	0f b6 00             	movzbl (%rax),%eax
  801429:	3c 39                	cmp    $0x39,%al
  80142b:	7f 12                	jg     80143f <strtol+0xf0>
			dig = *s - '0';
  80142d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801431:	0f b6 00             	movzbl (%rax),%eax
  801434:	0f be c0             	movsbl %al,%eax
  801437:	83 e8 30             	sub    $0x30,%eax
  80143a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80143d:	eb 4e                	jmp    80148d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80143f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801443:	0f b6 00             	movzbl (%rax),%eax
  801446:	3c 60                	cmp    $0x60,%al
  801448:	7e 1d                	jle    801467 <strtol+0x118>
  80144a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144e:	0f b6 00             	movzbl (%rax),%eax
  801451:	3c 7a                	cmp    $0x7a,%al
  801453:	7f 12                	jg     801467 <strtol+0x118>
			dig = *s - 'a' + 10;
  801455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	0f be c0             	movsbl %al,%eax
  80145f:	83 e8 57             	sub    $0x57,%eax
  801462:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801465:	eb 26                	jmp    80148d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801467:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146b:	0f b6 00             	movzbl (%rax),%eax
  80146e:	3c 40                	cmp    $0x40,%al
  801470:	7e 48                	jle    8014ba <strtol+0x16b>
  801472:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801476:	0f b6 00             	movzbl (%rax),%eax
  801479:	3c 5a                	cmp    $0x5a,%al
  80147b:	7f 3d                	jg     8014ba <strtol+0x16b>
			dig = *s - 'A' + 10;
  80147d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801481:	0f b6 00             	movzbl (%rax),%eax
  801484:	0f be c0             	movsbl %al,%eax
  801487:	83 e8 37             	sub    $0x37,%eax
  80148a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80148d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801490:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801493:	7c 02                	jl     801497 <strtol+0x148>
			break;
  801495:	eb 23                	jmp    8014ba <strtol+0x16b>
		s++, val = (val * base) + dig;
  801497:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80149c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80149f:	48 98                	cltq   
  8014a1:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014a6:	48 89 c2             	mov    %rax,%rdx
  8014a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014ac:	48 98                	cltq   
  8014ae:	48 01 d0             	add    %rdx,%rax
  8014b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014b5:	e9 5d ff ff ff       	jmpq   801417 <strtol+0xc8>

	if (endptr)
  8014ba:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014bf:	74 0b                	je     8014cc <strtol+0x17d>
		*endptr = (char *) s;
  8014c1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014c5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014c9:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014d0:	74 09                	je     8014db <strtol+0x18c>
  8014d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d6:	48 f7 d8             	neg    %rax
  8014d9:	eb 04                	jmp    8014df <strtol+0x190>
  8014db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014df:	c9                   	leaveq 
  8014e0:	c3                   	retq   

00000000008014e1 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014e1:	55                   	push   %rbp
  8014e2:	48 89 e5             	mov    %rsp,%rbp
  8014e5:	48 83 ec 30          	sub    $0x30,%rsp
  8014e9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014ed:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014f5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014f9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014fd:	0f b6 00             	movzbl (%rax),%eax
  801500:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801503:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801507:	75 06                	jne    80150f <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801509:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150d:	eb 6b                	jmp    80157a <strstr+0x99>

	len = strlen(str);
  80150f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801513:	48 89 c7             	mov    %rax,%rdi
  801516:	48 b8 b7 0d 80 00 00 	movabs $0x800db7,%rax
  80151d:	00 00 00 
  801520:	ff d0                	callq  *%rax
  801522:	48 98                	cltq   
  801524:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801528:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801530:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801534:	0f b6 00             	movzbl (%rax),%eax
  801537:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80153a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80153e:	75 07                	jne    801547 <strstr+0x66>
				return (char *) 0;
  801540:	b8 00 00 00 00       	mov    $0x0,%eax
  801545:	eb 33                	jmp    80157a <strstr+0x99>
		} while (sc != c);
  801547:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80154b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80154e:	75 d8                	jne    801528 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801550:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801554:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801558:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155c:	48 89 ce             	mov    %rcx,%rsi
  80155f:	48 89 c7             	mov    %rax,%rdi
  801562:	48 b8 d8 0f 80 00 00 	movabs $0x800fd8,%rax
  801569:	00 00 00 
  80156c:	ff d0                	callq  *%rax
  80156e:	85 c0                	test   %eax,%eax
  801570:	75 b6                	jne    801528 <strstr+0x47>

	return (char *) (in - 1);
  801572:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801576:	48 83 e8 01          	sub    $0x1,%rax
}
  80157a:	c9                   	leaveq 
  80157b:	c3                   	retq   

000000000080157c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80157c:	55                   	push   %rbp
  80157d:	48 89 e5             	mov    %rsp,%rbp
  801580:	53                   	push   %rbx
  801581:	48 83 ec 48          	sub    $0x48,%rsp
  801585:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801588:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80158b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80158f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801593:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801597:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80159b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80159e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015a2:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015a6:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015aa:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015ae:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015b2:	4c 89 c3             	mov    %r8,%rbx
  8015b5:	cd 30                	int    $0x30
  8015b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015bb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015bf:	74 3e                	je     8015ff <syscall+0x83>
  8015c1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015c6:	7e 37                	jle    8015ff <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015cc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015cf:	49 89 d0             	mov    %rdx,%r8
  8015d2:	89 c1                	mov    %eax,%ecx
  8015d4:	48 ba 68 1c 80 00 00 	movabs $0x801c68,%rdx
  8015db:	00 00 00 
  8015de:	be 23 00 00 00       	mov    $0x23,%esi
  8015e3:	48 bf 85 1c 80 00 00 	movabs $0x801c85,%rdi
  8015ea:	00 00 00 
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f2:	49 b9 14 17 80 00 00 	movabs $0x801714,%r9
  8015f9:	00 00 00 
  8015fc:	41 ff d1             	callq  *%r9

	return ret;
  8015ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801603:	48 83 c4 48          	add    $0x48,%rsp
  801607:	5b                   	pop    %rbx
  801608:	5d                   	pop    %rbp
  801609:	c3                   	retq   

000000000080160a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80160a:	55                   	push   %rbp
  80160b:	48 89 e5             	mov    %rsp,%rbp
  80160e:	48 83 ec 20          	sub    $0x20,%rsp
  801612:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801616:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80161a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801622:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801629:	00 
  80162a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801630:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801636:	48 89 d1             	mov    %rdx,%rcx
  801639:	48 89 c2             	mov    %rax,%rdx
  80163c:	be 00 00 00 00       	mov    $0x0,%esi
  801641:	bf 00 00 00 00       	mov    $0x0,%edi
  801646:	48 b8 7c 15 80 00 00 	movabs $0x80157c,%rax
  80164d:	00 00 00 
  801650:	ff d0                	callq  *%rax
}
  801652:	c9                   	leaveq 
  801653:	c3                   	retq   

0000000000801654 <sys_cgetc>:

int
sys_cgetc(void)
{
  801654:	55                   	push   %rbp
  801655:	48 89 e5             	mov    %rsp,%rbp
  801658:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80165c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801663:	00 
  801664:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80166a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801670:	b9 00 00 00 00       	mov    $0x0,%ecx
  801675:	ba 00 00 00 00       	mov    $0x0,%edx
  80167a:	be 00 00 00 00       	mov    $0x0,%esi
  80167f:	bf 01 00 00 00       	mov    $0x1,%edi
  801684:	48 b8 7c 15 80 00 00 	movabs $0x80157c,%rax
  80168b:	00 00 00 
  80168e:	ff d0                	callq  *%rax
}
  801690:	c9                   	leaveq 
  801691:	c3                   	retq   

0000000000801692 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801692:	55                   	push   %rbp
  801693:	48 89 e5             	mov    %rsp,%rbp
  801696:	48 83 ec 10          	sub    $0x10,%rsp
  80169a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80169d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a0:	48 98                	cltq   
  8016a2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016a9:	00 
  8016aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016bb:	48 89 c2             	mov    %rax,%rdx
  8016be:	be 01 00 00 00       	mov    $0x1,%esi
  8016c3:	bf 03 00 00 00       	mov    $0x3,%edi
  8016c8:	48 b8 7c 15 80 00 00 	movabs $0x80157c,%rax
  8016cf:	00 00 00 
  8016d2:	ff d0                	callq  *%rax
}
  8016d4:	c9                   	leaveq 
  8016d5:	c3                   	retq   

00000000008016d6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016d6:	55                   	push   %rbp
  8016d7:	48 89 e5             	mov    %rsp,%rbp
  8016da:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016de:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e5:	00 
  8016e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fc:	be 00 00 00 00       	mov    $0x0,%esi
  801701:	bf 02 00 00 00       	mov    $0x2,%edi
  801706:	48 b8 7c 15 80 00 00 	movabs $0x80157c,%rax
  80170d:	00 00 00 
  801710:	ff d0                	callq  *%rax
}
  801712:	c9                   	leaveq 
  801713:	c3                   	retq   

0000000000801714 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801714:	55                   	push   %rbp
  801715:	48 89 e5             	mov    %rsp,%rbp
  801718:	53                   	push   %rbx
  801719:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801720:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801727:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80172d:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801734:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80173b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801742:	84 c0                	test   %al,%al
  801744:	74 23                	je     801769 <_panic+0x55>
  801746:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80174d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801751:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801755:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801759:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80175d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801761:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801765:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801769:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801770:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801777:	00 00 00 
  80177a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801781:	00 00 00 
  801784:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801788:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80178f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801796:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80179d:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8017a4:	00 00 00 
  8017a7:	48 8b 18             	mov    (%rax),%rbx
  8017aa:	48 b8 d6 16 80 00 00 	movabs $0x8016d6,%rax
  8017b1:	00 00 00 
  8017b4:	ff d0                	callq  *%rax
  8017b6:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8017bc:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8017c3:	41 89 c8             	mov    %ecx,%r8d
  8017c6:	48 89 d1             	mov    %rdx,%rcx
  8017c9:	48 89 da             	mov    %rbx,%rdx
  8017cc:	89 c6                	mov    %eax,%esi
  8017ce:	48 bf 98 1c 80 00 00 	movabs $0x801c98,%rdi
  8017d5:	00 00 00 
  8017d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dd:	49 b9 5b 02 80 00 00 	movabs $0x80025b,%r9
  8017e4:	00 00 00 
  8017e7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017ea:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8017f1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8017f8:	48 89 d6             	mov    %rdx,%rsi
  8017fb:	48 89 c7             	mov    %rax,%rdi
  8017fe:	48 b8 af 01 80 00 00 	movabs $0x8001af,%rax
  801805:	00 00 00 
  801808:	ff d0                	callq  *%rax
	cprintf("\n");
  80180a:	48 bf bb 1c 80 00 00 	movabs $0x801cbb,%rdi
  801811:	00 00 00 
  801814:	b8 00 00 00 00       	mov    $0x0,%eax
  801819:	48 ba 5b 02 80 00 00 	movabs $0x80025b,%rdx
  801820:	00 00 00 
  801823:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801825:	cc                   	int3   
  801826:	eb fd                	jmp    801825 <_panic+0x111>
