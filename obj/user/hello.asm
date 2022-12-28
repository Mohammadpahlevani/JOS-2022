
obj/user/hello:     file format elf64-x86-64


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
  80003c:	e8 5e 00 00 00       	callq  80009f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	cprintf("hello, world\n");
  800052:	48 bf 40 18 80 00 00 	movabs $0x801840,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 65 02 80 00 00 	movabs $0x800265,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf 4e 18 80 00 00 	movabs $0x80184e,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 65 02 80 00 00 	movabs $0x800265,%rdx
  800098:	00 00 00 
  80009b:	ff d2                	callq  *%rdx
}
  80009d:	c9                   	leaveq 
  80009e:	c3                   	retq   

000000000080009f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009f:	55                   	push   %rbp
  8000a0:	48 89 e5             	mov    %rsp,%rbp
  8000a3:	48 83 ec 10          	sub    $0x10,%rsp
  8000a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ae:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
  8000ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000bf:	48 98                	cltq   
  8000c1:	48 c1 e0 03          	shl    $0x3,%rax
  8000c5:	48 89 c2             	mov    %rax,%rdx
  8000c8:	48 c1 e2 05          	shl    $0x5,%rdx
  8000cc:	48 29 c2             	sub    %rax,%rdx
  8000cf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000d6:	00 00 00 
  8000d9:	48 01 c2             	add    %rax,%rdx
  8000dc:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000e3:	00 00 00 
  8000e6:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000ed:	7e 14                	jle    800103 <libmain+0x64>
		binaryname = argv[0];
  8000ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000f3:	48 8b 10             	mov    (%rax),%rdx
  8000f6:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000fd:	00 00 00 
  800100:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800103:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800107:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80010a:	48 89 d6             	mov    %rdx,%rsi
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800116:	00 00 00 
  800119:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80011b:	48 b8 29 01 80 00 00 	movabs $0x800129,%rax
  800122:	00 00 00 
  800125:	ff d0                	callq  *%rax
}
  800127:	c9                   	leaveq 
  800128:	c3                   	retq   

0000000000800129 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800129:	55                   	push   %rbp
  80012a:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80012d:	bf 00 00 00 00       	mov    $0x0,%edi
  800132:	48 b8 9c 16 80 00 00 	movabs $0x80169c,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
}
  80013e:	5d                   	pop    %rbp
  80013f:	c3                   	retq   

0000000000800140 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800140:	55                   	push   %rbp
  800141:	48 89 e5             	mov    %rsp,%rbp
  800144:	48 83 ec 10          	sub    $0x10,%rsp
  800148:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80014b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80014f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800153:	8b 00                	mov    (%rax),%eax
  800155:	8d 48 01             	lea    0x1(%rax),%ecx
  800158:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80015c:	89 0a                	mov    %ecx,(%rdx)
  80015e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800161:	89 d1                	mov    %edx,%ecx
  800163:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800167:	48 98                	cltq   
  800169:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	8b 00                	mov    (%rax),%eax
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	75 2c                	jne    8001a6 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80017a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80017e:	8b 00                	mov    (%rax),%eax
  800180:	48 98                	cltq   
  800182:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800186:	48 83 c2 08          	add    $0x8,%rdx
  80018a:	48 89 c6             	mov    %rax,%rsi
  80018d:	48 89 d7             	mov    %rdx,%rdi
  800190:	48 b8 14 16 80 00 00 	movabs $0x801614,%rax
  800197:	00 00 00 
  80019a:	ff d0                	callq  *%rax
        b->idx = 0;
  80019c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001aa:	8b 40 04             	mov    0x4(%rax),%eax
  8001ad:	8d 50 01             	lea    0x1(%rax),%edx
  8001b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b4:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001b7:	c9                   	leaveq 
  8001b8:	c3                   	retq   

00000000008001b9 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001b9:	55                   	push   %rbp
  8001ba:	48 89 e5             	mov    %rsp,%rbp
  8001bd:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001c4:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001cb:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001d2:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001d9:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001e0:	48 8b 0a             	mov    (%rdx),%rcx
  8001e3:	48 89 08             	mov    %rcx,(%rax)
  8001e6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001ea:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001ee:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001f2:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001f6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001fd:	00 00 00 
    b.cnt = 0;
  800200:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800207:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80020a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800211:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800218:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80021f:	48 89 c6             	mov    %rax,%rsi
  800222:	48 bf 40 01 80 00 00 	movabs $0x800140,%rdi
  800229:	00 00 00 
  80022c:	48 b8 18 06 80 00 00 	movabs $0x800618,%rax
  800233:	00 00 00 
  800236:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800238:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80023e:	48 98                	cltq   
  800240:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800247:	48 83 c2 08          	add    $0x8,%rdx
  80024b:	48 89 c6             	mov    %rax,%rsi
  80024e:	48 89 d7             	mov    %rdx,%rdi
  800251:	48 b8 14 16 80 00 00 	movabs $0x801614,%rax
  800258:	00 00 00 
  80025b:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80025d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800263:	c9                   	leaveq 
  800264:	c3                   	retq   

0000000000800265 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800265:	55                   	push   %rbp
  800266:	48 89 e5             	mov    %rsp,%rbp
  800269:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800270:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800277:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80027e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800285:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80028c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800293:	84 c0                	test   %al,%al
  800295:	74 20                	je     8002b7 <cprintf+0x52>
  800297:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80029b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80029f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002a3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002a7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002ab:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002af:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002b3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002b7:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002be:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002c5:	00 00 00 
  8002c8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002cf:	00 00 00 
  8002d2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002d6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002dd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002e4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002eb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002f2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002f9:	48 8b 0a             	mov    (%rdx),%rcx
  8002fc:	48 89 08             	mov    %rcx,(%rax)
  8002ff:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800303:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800307:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80030b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80030f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800316:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80031d:	48 89 d6             	mov    %rdx,%rsi
  800320:	48 89 c7             	mov    %rax,%rdi
  800323:	48 b8 b9 01 80 00 00 	movabs $0x8001b9,%rax
  80032a:	00 00 00 
  80032d:	ff d0                	callq  *%rax
  80032f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800335:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80033b:	c9                   	leaveq 
  80033c:	c3                   	retq   

000000000080033d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80033d:	55                   	push   %rbp
  80033e:	48 89 e5             	mov    %rsp,%rbp
  800341:	53                   	push   %rbx
  800342:	48 83 ec 38          	sub    $0x38,%rsp
  800346:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80034a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80034e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800352:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800355:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800359:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80035d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800360:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800364:	77 3b                	ja     8003a1 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800366:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800369:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80036d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800370:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800374:	ba 00 00 00 00       	mov    $0x0,%edx
  800379:	48 f7 f3             	div    %rbx
  80037c:	48 89 c2             	mov    %rax,%rdx
  80037f:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800382:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800385:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800389:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80038d:	41 89 f9             	mov    %edi,%r9d
  800390:	48 89 c7             	mov    %rax,%rdi
  800393:	48 b8 3d 03 80 00 00 	movabs $0x80033d,%rax
  80039a:	00 00 00 
  80039d:	ff d0                	callq  *%rax
  80039f:	eb 1e                	jmp    8003bf <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a1:	eb 12                	jmp    8003b5 <printnum+0x78>
			putch(padc, putdat);
  8003a3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003a7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ae:	48 89 ce             	mov    %rcx,%rsi
  8003b1:	89 d7                	mov    %edx,%edi
  8003b3:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b5:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003b9:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003bd:	7f e4                	jg     8003a3 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003bf:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003cb:	48 f7 f1             	div    %rcx
  8003ce:	48 89 d0             	mov    %rdx,%rax
  8003d1:	48 ba b0 19 80 00 00 	movabs $0x8019b0,%rdx
  8003d8:	00 00 00 
  8003db:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003df:	0f be d0             	movsbl %al,%edx
  8003e2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ea:	48 89 ce             	mov    %rcx,%rsi
  8003ed:	89 d7                	mov    %edx,%edi
  8003ef:	ff d0                	callq  *%rax
}
  8003f1:	48 83 c4 38          	add    $0x38,%rsp
  8003f5:	5b                   	pop    %rbx
  8003f6:	5d                   	pop    %rbp
  8003f7:	c3                   	retq   

00000000008003f8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f8:	55                   	push   %rbp
  8003f9:	48 89 e5             	mov    %rsp,%rbp
  8003fc:	48 83 ec 1c          	sub    $0x1c,%rsp
  800400:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800404:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800407:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80040b:	7e 52                	jle    80045f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80040d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800411:	8b 00                	mov    (%rax),%eax
  800413:	83 f8 30             	cmp    $0x30,%eax
  800416:	73 24                	jae    80043c <getuint+0x44>
  800418:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800420:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800424:	8b 00                	mov    (%rax),%eax
  800426:	89 c0                	mov    %eax,%eax
  800428:	48 01 d0             	add    %rdx,%rax
  80042b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042f:	8b 12                	mov    (%rdx),%edx
  800431:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800434:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800438:	89 0a                	mov    %ecx,(%rdx)
  80043a:	eb 17                	jmp    800453 <getuint+0x5b>
  80043c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800440:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800444:	48 89 d0             	mov    %rdx,%rax
  800447:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80044b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80044f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800453:	48 8b 00             	mov    (%rax),%rax
  800456:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80045a:	e9 a3 00 00 00       	jmpq   800502 <getuint+0x10a>
	else if (lflag)
  80045f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800463:	74 4f                	je     8004b4 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800469:	8b 00                	mov    (%rax),%eax
  80046b:	83 f8 30             	cmp    $0x30,%eax
  80046e:	73 24                	jae    800494 <getuint+0x9c>
  800470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800474:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800478:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047c:	8b 00                	mov    (%rax),%eax
  80047e:	89 c0                	mov    %eax,%eax
  800480:	48 01 d0             	add    %rdx,%rax
  800483:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800487:	8b 12                	mov    (%rdx),%edx
  800489:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80048c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800490:	89 0a                	mov    %ecx,(%rdx)
  800492:	eb 17                	jmp    8004ab <getuint+0xb3>
  800494:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800498:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049c:	48 89 d0             	mov    %rdx,%rax
  80049f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004ab:	48 8b 00             	mov    (%rax),%rax
  8004ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004b2:	eb 4e                	jmp    800502 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b8:	8b 00                	mov    (%rax),%eax
  8004ba:	83 f8 30             	cmp    $0x30,%eax
  8004bd:	73 24                	jae    8004e3 <getuint+0xeb>
  8004bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cb:	8b 00                	mov    (%rax),%eax
  8004cd:	89 c0                	mov    %eax,%eax
  8004cf:	48 01 d0             	add    %rdx,%rax
  8004d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d6:	8b 12                	mov    (%rdx),%edx
  8004d8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004df:	89 0a                	mov    %ecx,(%rdx)
  8004e1:	eb 17                	jmp    8004fa <getuint+0x102>
  8004e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004eb:	48 89 d0             	mov    %rdx,%rax
  8004ee:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004fa:	8b 00                	mov    (%rax),%eax
  8004fc:	89 c0                	mov    %eax,%eax
  8004fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800502:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800506:	c9                   	leaveq 
  800507:	c3                   	retq   

0000000000800508 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800508:	55                   	push   %rbp
  800509:	48 89 e5             	mov    %rsp,%rbp
  80050c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800510:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800514:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800517:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80051b:	7e 52                	jle    80056f <getint+0x67>
		x=va_arg(*ap, long long);
  80051d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800521:	8b 00                	mov    (%rax),%eax
  800523:	83 f8 30             	cmp    $0x30,%eax
  800526:	73 24                	jae    80054c <getint+0x44>
  800528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800530:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800534:	8b 00                	mov    (%rax),%eax
  800536:	89 c0                	mov    %eax,%eax
  800538:	48 01 d0             	add    %rdx,%rax
  80053b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053f:	8b 12                	mov    (%rdx),%edx
  800541:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800544:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800548:	89 0a                	mov    %ecx,(%rdx)
  80054a:	eb 17                	jmp    800563 <getint+0x5b>
  80054c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800550:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800554:	48 89 d0             	mov    %rdx,%rax
  800557:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80055b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800563:	48 8b 00             	mov    (%rax),%rax
  800566:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80056a:	e9 a3 00 00 00       	jmpq   800612 <getint+0x10a>
	else if (lflag)
  80056f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800573:	74 4f                	je     8005c4 <getint+0xbc>
		x=va_arg(*ap, long);
  800575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800579:	8b 00                	mov    (%rax),%eax
  80057b:	83 f8 30             	cmp    $0x30,%eax
  80057e:	73 24                	jae    8005a4 <getint+0x9c>
  800580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800584:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800588:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058c:	8b 00                	mov    (%rax),%eax
  80058e:	89 c0                	mov    %eax,%eax
  800590:	48 01 d0             	add    %rdx,%rax
  800593:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800597:	8b 12                	mov    (%rdx),%edx
  800599:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80059c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a0:	89 0a                	mov    %ecx,(%rdx)
  8005a2:	eb 17                	jmp    8005bb <getint+0xb3>
  8005a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005ac:	48 89 d0             	mov    %rdx,%rax
  8005af:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005bb:	48 8b 00             	mov    (%rax),%rax
  8005be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c2:	eb 4e                	jmp    800612 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c8:	8b 00                	mov    (%rax),%eax
  8005ca:	83 f8 30             	cmp    $0x30,%eax
  8005cd:	73 24                	jae    8005f3 <getint+0xeb>
  8005cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005db:	8b 00                	mov    (%rax),%eax
  8005dd:	89 c0                	mov    %eax,%eax
  8005df:	48 01 d0             	add    %rdx,%rax
  8005e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e6:	8b 12                	mov    (%rdx),%edx
  8005e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ef:	89 0a                	mov    %ecx,(%rdx)
  8005f1:	eb 17                	jmp    80060a <getint+0x102>
  8005f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005fb:	48 89 d0             	mov    %rdx,%rax
  8005fe:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800602:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800606:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80060a:	8b 00                	mov    (%rax),%eax
  80060c:	48 98                	cltq   
  80060e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800612:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800616:	c9                   	leaveq 
  800617:	c3                   	retq   

0000000000800618 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800618:	55                   	push   %rbp
  800619:	48 89 e5             	mov    %rsp,%rbp
  80061c:	41 54                	push   %r12
  80061e:	53                   	push   %rbx
  80061f:	48 83 ec 60          	sub    $0x60,%rsp
  800623:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800627:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80062b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80062f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800633:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800637:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80063b:	48 8b 0a             	mov    (%rdx),%rcx
  80063e:	48 89 08             	mov    %rcx,(%rax)
  800641:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800645:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800649:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80064d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800651:	eb 17                	jmp    80066a <vprintfmt+0x52>
			if (ch == '\0')
  800653:	85 db                	test   %ebx,%ebx
  800655:	0f 84 df 04 00 00    	je     800b3a <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80065b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80065f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800663:	48 89 d6             	mov    %rdx,%rsi
  800666:	89 df                	mov    %ebx,%edi
  800668:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80066e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800672:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800676:	0f b6 00             	movzbl (%rax),%eax
  800679:	0f b6 d8             	movzbl %al,%ebx
  80067c:	83 fb 25             	cmp    $0x25,%ebx
  80067f:	75 d2                	jne    800653 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800681:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800685:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80068c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800693:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80069a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006a1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006a5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006a9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ad:	0f b6 00             	movzbl (%rax),%eax
  8006b0:	0f b6 d8             	movzbl %al,%ebx
  8006b3:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006b6:	83 f8 55             	cmp    $0x55,%eax
  8006b9:	0f 87 47 04 00 00    	ja     800b06 <vprintfmt+0x4ee>
  8006bf:	89 c0                	mov    %eax,%eax
  8006c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006c8:	00 
  8006c9:	48 b8 d8 19 80 00 00 	movabs $0x8019d8,%rax
  8006d0:	00 00 00 
  8006d3:	48 01 d0             	add    %rdx,%rax
  8006d6:	48 8b 00             	mov    (%rax),%rax
  8006d9:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006db:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006df:	eb c0                	jmp    8006a1 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006e1:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006e5:	eb ba                	jmp    8006a1 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006ee:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006f1:	89 d0                	mov    %edx,%eax
  8006f3:	c1 e0 02             	shl    $0x2,%eax
  8006f6:	01 d0                	add    %edx,%eax
  8006f8:	01 c0                	add    %eax,%eax
  8006fa:	01 d8                	add    %ebx,%eax
  8006fc:	83 e8 30             	sub    $0x30,%eax
  8006ff:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800702:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800706:	0f b6 00             	movzbl (%rax),%eax
  800709:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80070c:	83 fb 2f             	cmp    $0x2f,%ebx
  80070f:	7e 0c                	jle    80071d <vprintfmt+0x105>
  800711:	83 fb 39             	cmp    $0x39,%ebx
  800714:	7f 07                	jg     80071d <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800716:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80071b:	eb d1                	jmp    8006ee <vprintfmt+0xd6>
			goto process_precision;
  80071d:	eb 58                	jmp    800777 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80071f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800722:	83 f8 30             	cmp    $0x30,%eax
  800725:	73 17                	jae    80073e <vprintfmt+0x126>
  800727:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80072b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80072e:	89 c0                	mov    %eax,%eax
  800730:	48 01 d0             	add    %rdx,%rax
  800733:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800736:	83 c2 08             	add    $0x8,%edx
  800739:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80073c:	eb 0f                	jmp    80074d <vprintfmt+0x135>
  80073e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800742:	48 89 d0             	mov    %rdx,%rax
  800745:	48 83 c2 08          	add    $0x8,%rdx
  800749:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80074d:	8b 00                	mov    (%rax),%eax
  80074f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800752:	eb 23                	jmp    800777 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800754:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800758:	79 0c                	jns    800766 <vprintfmt+0x14e>
				width = 0;
  80075a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800761:	e9 3b ff ff ff       	jmpq   8006a1 <vprintfmt+0x89>
  800766:	e9 36 ff ff ff       	jmpq   8006a1 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80076b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800772:	e9 2a ff ff ff       	jmpq   8006a1 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800777:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80077b:	79 12                	jns    80078f <vprintfmt+0x177>
				width = precision, precision = -1;
  80077d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800780:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800783:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80078a:	e9 12 ff ff ff       	jmpq   8006a1 <vprintfmt+0x89>
  80078f:	e9 0d ff ff ff       	jmpq   8006a1 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800794:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800798:	e9 04 ff ff ff       	jmpq   8006a1 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80079d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a0:	83 f8 30             	cmp    $0x30,%eax
  8007a3:	73 17                	jae    8007bc <vprintfmt+0x1a4>
  8007a5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007a9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ac:	89 c0                	mov    %eax,%eax
  8007ae:	48 01 d0             	add    %rdx,%rax
  8007b1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007b4:	83 c2 08             	add    $0x8,%edx
  8007b7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007ba:	eb 0f                	jmp    8007cb <vprintfmt+0x1b3>
  8007bc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007c0:	48 89 d0             	mov    %rdx,%rax
  8007c3:	48 83 c2 08          	add    $0x8,%rdx
  8007c7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007cb:	8b 10                	mov    (%rax),%edx
  8007cd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007d1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007d5:	48 89 ce             	mov    %rcx,%rsi
  8007d8:	89 d7                	mov    %edx,%edi
  8007da:	ff d0                	callq  *%rax
			break;
  8007dc:	e9 53 03 00 00       	jmpq   800b34 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e4:	83 f8 30             	cmp    $0x30,%eax
  8007e7:	73 17                	jae    800800 <vprintfmt+0x1e8>
  8007e9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f0:	89 c0                	mov    %eax,%eax
  8007f2:	48 01 d0             	add    %rdx,%rax
  8007f5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007f8:	83 c2 08             	add    $0x8,%edx
  8007fb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007fe:	eb 0f                	jmp    80080f <vprintfmt+0x1f7>
  800800:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800804:	48 89 d0             	mov    %rdx,%rax
  800807:	48 83 c2 08          	add    $0x8,%rdx
  80080b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80080f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800811:	85 db                	test   %ebx,%ebx
  800813:	79 02                	jns    800817 <vprintfmt+0x1ff>
				err = -err;
  800815:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800817:	83 fb 15             	cmp    $0x15,%ebx
  80081a:	7f 16                	jg     800832 <vprintfmt+0x21a>
  80081c:	48 b8 00 19 80 00 00 	movabs $0x801900,%rax
  800823:	00 00 00 
  800826:	48 63 d3             	movslq %ebx,%rdx
  800829:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80082d:	4d 85 e4             	test   %r12,%r12
  800830:	75 2e                	jne    800860 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800832:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800836:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80083a:	89 d9                	mov    %ebx,%ecx
  80083c:	48 ba c1 19 80 00 00 	movabs $0x8019c1,%rdx
  800843:	00 00 00 
  800846:	48 89 c7             	mov    %rax,%rdi
  800849:	b8 00 00 00 00       	mov    $0x0,%eax
  80084e:	49 b8 43 0b 80 00 00 	movabs $0x800b43,%r8
  800855:	00 00 00 
  800858:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80085b:	e9 d4 02 00 00       	jmpq   800b34 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800860:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800864:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800868:	4c 89 e1             	mov    %r12,%rcx
  80086b:	48 ba ca 19 80 00 00 	movabs $0x8019ca,%rdx
  800872:	00 00 00 
  800875:	48 89 c7             	mov    %rax,%rdi
  800878:	b8 00 00 00 00       	mov    $0x0,%eax
  80087d:	49 b8 43 0b 80 00 00 	movabs $0x800b43,%r8
  800884:	00 00 00 
  800887:	41 ff d0             	callq  *%r8
			break;
  80088a:	e9 a5 02 00 00       	jmpq   800b34 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80088f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800892:	83 f8 30             	cmp    $0x30,%eax
  800895:	73 17                	jae    8008ae <vprintfmt+0x296>
  800897:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80089b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089e:	89 c0                	mov    %eax,%eax
  8008a0:	48 01 d0             	add    %rdx,%rax
  8008a3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008a6:	83 c2 08             	add    $0x8,%edx
  8008a9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008ac:	eb 0f                	jmp    8008bd <vprintfmt+0x2a5>
  8008ae:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b2:	48 89 d0             	mov    %rdx,%rax
  8008b5:	48 83 c2 08          	add    $0x8,%rdx
  8008b9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008bd:	4c 8b 20             	mov    (%rax),%r12
  8008c0:	4d 85 e4             	test   %r12,%r12
  8008c3:	75 0a                	jne    8008cf <vprintfmt+0x2b7>
				p = "(null)";
  8008c5:	49 bc cd 19 80 00 00 	movabs $0x8019cd,%r12
  8008cc:	00 00 00 
			if (width > 0 && padc != '-')
  8008cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008d3:	7e 3f                	jle    800914 <vprintfmt+0x2fc>
  8008d5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008d9:	74 39                	je     800914 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008db:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008de:	48 98                	cltq   
  8008e0:	48 89 c6             	mov    %rax,%rsi
  8008e3:	4c 89 e7             	mov    %r12,%rdi
  8008e6:	48 b8 ef 0d 80 00 00 	movabs $0x800def,%rax
  8008ed:	00 00 00 
  8008f0:	ff d0                	callq  *%rax
  8008f2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008f5:	eb 17                	jmp    80090e <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008f7:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008fb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008ff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800903:	48 89 ce             	mov    %rcx,%rsi
  800906:	89 d7                	mov    %edx,%edi
  800908:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80090a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80090e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800912:	7f e3                	jg     8008f7 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800914:	eb 37                	jmp    80094d <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800916:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80091a:	74 1e                	je     80093a <vprintfmt+0x322>
  80091c:	83 fb 1f             	cmp    $0x1f,%ebx
  80091f:	7e 05                	jle    800926 <vprintfmt+0x30e>
  800921:	83 fb 7e             	cmp    $0x7e,%ebx
  800924:	7e 14                	jle    80093a <vprintfmt+0x322>
					putch('?', putdat);
  800926:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80092a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80092e:	48 89 d6             	mov    %rdx,%rsi
  800931:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800936:	ff d0                	callq  *%rax
  800938:	eb 0f                	jmp    800949 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80093a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80093e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800942:	48 89 d6             	mov    %rdx,%rsi
  800945:	89 df                	mov    %ebx,%edi
  800947:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800949:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80094d:	4c 89 e0             	mov    %r12,%rax
  800950:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800954:	0f b6 00             	movzbl (%rax),%eax
  800957:	0f be d8             	movsbl %al,%ebx
  80095a:	85 db                	test   %ebx,%ebx
  80095c:	74 10                	je     80096e <vprintfmt+0x356>
  80095e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800962:	78 b2                	js     800916 <vprintfmt+0x2fe>
  800964:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800968:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80096c:	79 a8                	jns    800916 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80096e:	eb 16                	jmp    800986 <vprintfmt+0x36e>
				putch(' ', putdat);
  800970:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800974:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800978:	48 89 d6             	mov    %rdx,%rsi
  80097b:	bf 20 00 00 00       	mov    $0x20,%edi
  800980:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800982:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800986:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098a:	7f e4                	jg     800970 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80098c:	e9 a3 01 00 00       	jmpq   800b34 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800991:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800995:	be 03 00 00 00       	mov    $0x3,%esi
  80099a:	48 89 c7             	mov    %rax,%rdi
  80099d:	48 b8 08 05 80 00 00 	movabs $0x800508,%rax
  8009a4:	00 00 00 
  8009a7:	ff d0                	callq  *%rax
  8009a9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b1:	48 85 c0             	test   %rax,%rax
  8009b4:	79 1d                	jns    8009d3 <vprintfmt+0x3bb>
				putch('-', putdat);
  8009b6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009be:	48 89 d6             	mov    %rdx,%rsi
  8009c1:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009c6:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	48 f7 d8             	neg    %rax
  8009cf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009d3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009da:	e9 e8 00 00 00       	jmpq   800ac7 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009df:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009e3:	be 03 00 00 00       	mov    $0x3,%esi
  8009e8:	48 89 c7             	mov    %rax,%rdi
  8009eb:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  8009f2:	00 00 00 
  8009f5:	ff d0                	callq  *%rax
  8009f7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009fb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a02:	e9 c0 00 00 00       	jmpq   800ac7 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a07:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0f:	48 89 d6             	mov    %rdx,%rsi
  800a12:	bf 58 00 00 00       	mov    $0x58,%edi
  800a17:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a21:	48 89 d6             	mov    %rdx,%rsi
  800a24:	bf 58 00 00 00       	mov    $0x58,%edi
  800a29:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a2b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a33:	48 89 d6             	mov    %rdx,%rsi
  800a36:	bf 58 00 00 00       	mov    $0x58,%edi
  800a3b:	ff d0                	callq  *%rax
			break;
  800a3d:	e9 f2 00 00 00       	jmpq   800b34 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a42:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4a:	48 89 d6             	mov    %rdx,%rsi
  800a4d:	bf 30 00 00 00       	mov    $0x30,%edi
  800a52:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a54:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5c:	48 89 d6             	mov    %rdx,%rsi
  800a5f:	bf 78 00 00 00       	mov    $0x78,%edi
  800a64:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a69:	83 f8 30             	cmp    $0x30,%eax
  800a6c:	73 17                	jae    800a85 <vprintfmt+0x46d>
  800a6e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a72:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a75:	89 c0                	mov    %eax,%eax
  800a77:	48 01 d0             	add    %rdx,%rax
  800a7a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7d:	83 c2 08             	add    $0x8,%edx
  800a80:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a83:	eb 0f                	jmp    800a94 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a85:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a89:	48 89 d0             	mov    %rdx,%rax
  800a8c:	48 83 c2 08          	add    $0x8,%rdx
  800a90:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a94:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a97:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a9b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800aa2:	eb 23                	jmp    800ac7 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800aa4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aa8:	be 03 00 00 00       	mov    $0x3,%esi
  800aad:	48 89 c7             	mov    %rax,%rdi
  800ab0:	48 b8 f8 03 80 00 00 	movabs $0x8003f8,%rax
  800ab7:	00 00 00 
  800aba:	ff d0                	callq  *%rax
  800abc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ac0:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac7:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800acc:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800acf:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ad2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ada:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ade:	45 89 c1             	mov    %r8d,%r9d
  800ae1:	41 89 f8             	mov    %edi,%r8d
  800ae4:	48 89 c7             	mov    %rax,%rdi
  800ae7:	48 b8 3d 03 80 00 00 	movabs $0x80033d,%rax
  800aee:	00 00 00 
  800af1:	ff d0                	callq  *%rax
			break;
  800af3:	eb 3f                	jmp    800b34 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800af5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afd:	48 89 d6             	mov    %rdx,%rsi
  800b00:	89 df                	mov    %ebx,%edi
  800b02:	ff d0                	callq  *%rax
			break;
  800b04:	eb 2e                	jmp    800b34 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0e:	48 89 d6             	mov    %rdx,%rsi
  800b11:	bf 25 00 00 00       	mov    $0x25,%edi
  800b16:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b18:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b1d:	eb 05                	jmp    800b24 <vprintfmt+0x50c>
  800b1f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b24:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b28:	48 83 e8 01          	sub    $0x1,%rax
  800b2c:	0f b6 00             	movzbl (%rax),%eax
  800b2f:	3c 25                	cmp    $0x25,%al
  800b31:	75 ec                	jne    800b1f <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b33:	90                   	nop
		}
	}
  800b34:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b35:	e9 30 fb ff ff       	jmpq   80066a <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b3a:	48 83 c4 60          	add    $0x60,%rsp
  800b3e:	5b                   	pop    %rbx
  800b3f:	41 5c                	pop    %r12
  800b41:	5d                   	pop    %rbp
  800b42:	c3                   	retq   

0000000000800b43 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b43:	55                   	push   %rbp
  800b44:	48 89 e5             	mov    %rsp,%rbp
  800b47:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b4e:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b55:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b5c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b63:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b6a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b71:	84 c0                	test   %al,%al
  800b73:	74 20                	je     800b95 <printfmt+0x52>
  800b75:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b79:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b7d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b81:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b85:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b89:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b8d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b91:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b95:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b9c:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ba3:	00 00 00 
  800ba6:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bad:	00 00 00 
  800bb0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bb4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bbb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bc2:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc9:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bd0:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bd7:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bde:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800be5:	48 89 c7             	mov    %rax,%rdi
  800be8:	48 b8 18 06 80 00 00 	movabs $0x800618,%rax
  800bef:	00 00 00 
  800bf2:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bf4:	c9                   	leaveq 
  800bf5:	c3                   	retq   

0000000000800bf6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf6:	55                   	push   %rbp
  800bf7:	48 89 e5             	mov    %rsp,%rbp
  800bfa:	48 83 ec 10          	sub    $0x10,%rsp
  800bfe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c09:	8b 40 10             	mov    0x10(%rax),%eax
  800c0c:	8d 50 01             	lea    0x1(%rax),%edx
  800c0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c13:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c1a:	48 8b 10             	mov    (%rax),%rdx
  800c1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c21:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c25:	48 39 c2             	cmp    %rax,%rdx
  800c28:	73 17                	jae    800c41 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2e:	48 8b 00             	mov    (%rax),%rax
  800c31:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c35:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c39:	48 89 0a             	mov    %rcx,(%rdx)
  800c3c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c3f:	88 10                	mov    %dl,(%rax)
}
  800c41:	c9                   	leaveq 
  800c42:	c3                   	retq   

0000000000800c43 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c43:	55                   	push   %rbp
  800c44:	48 89 e5             	mov    %rsp,%rbp
  800c47:	48 83 ec 50          	sub    $0x50,%rsp
  800c4b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c4f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c52:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c56:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c5a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c5e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c62:	48 8b 0a             	mov    (%rdx),%rcx
  800c65:	48 89 08             	mov    %rcx,(%rax)
  800c68:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c6c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c70:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c74:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c78:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c7c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c80:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c83:	48 98                	cltq   
  800c85:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c89:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c8d:	48 01 d0             	add    %rdx,%rax
  800c90:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c94:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c9b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ca0:	74 06                	je     800ca8 <vsnprintf+0x65>
  800ca2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ca6:	7f 07                	jg     800caf <vsnprintf+0x6c>
		return -E_INVAL;
  800ca8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cad:	eb 2f                	jmp    800cde <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800caf:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cb3:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cb7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cbb:	48 89 c6             	mov    %rax,%rsi
  800cbe:	48 bf f6 0b 80 00 00 	movabs $0x800bf6,%rdi
  800cc5:	00 00 00 
  800cc8:	48 b8 18 06 80 00 00 	movabs $0x800618,%rax
  800ccf:	00 00 00 
  800cd2:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cd4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cd8:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cdb:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cde:	c9                   	leaveq 
  800cdf:	c3                   	retq   

0000000000800ce0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce0:	55                   	push   %rbp
  800ce1:	48 89 e5             	mov    %rsp,%rbp
  800ce4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ceb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cf2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cf8:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cff:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d06:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d0d:	84 c0                	test   %al,%al
  800d0f:	74 20                	je     800d31 <snprintf+0x51>
  800d11:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d15:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d19:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d1d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d21:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d25:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d29:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d2d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d31:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d38:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d3f:	00 00 00 
  800d42:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d49:	00 00 00 
  800d4c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d50:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d57:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d5e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d65:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d6c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d73:	48 8b 0a             	mov    (%rdx),%rcx
  800d76:	48 89 08             	mov    %rcx,(%rax)
  800d79:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d7d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d81:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d85:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d89:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d90:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d97:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d9d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800da4:	48 89 c7             	mov    %rax,%rdi
  800da7:	48 b8 43 0c 80 00 00 	movabs $0x800c43,%rax
  800dae:	00 00 00 
  800db1:	ff d0                	callq  *%rax
  800db3:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800db9:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800dbf:	c9                   	leaveq 
  800dc0:	c3                   	retq   

0000000000800dc1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dc1:	55                   	push   %rbp
  800dc2:	48 89 e5             	mov    %rsp,%rbp
  800dc5:	48 83 ec 18          	sub    $0x18,%rsp
  800dc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dd4:	eb 09                	jmp    800ddf <strlen+0x1e>
		n++;
  800dd6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dda:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ddf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de3:	0f b6 00             	movzbl (%rax),%eax
  800de6:	84 c0                	test   %al,%al
  800de8:	75 ec                	jne    800dd6 <strlen+0x15>
		n++;
	return n;
  800dea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ded:	c9                   	leaveq 
  800dee:	c3                   	retq   

0000000000800def <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800def:	55                   	push   %rbp
  800df0:	48 89 e5             	mov    %rsp,%rbp
  800df3:	48 83 ec 20          	sub    $0x20,%rsp
  800df7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dfb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e06:	eb 0e                	jmp    800e16 <strnlen+0x27>
		n++;
  800e08:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e0c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e11:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e16:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e1b:	74 0b                	je     800e28 <strnlen+0x39>
  800e1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e21:	0f b6 00             	movzbl (%rax),%eax
  800e24:	84 c0                	test   %al,%al
  800e26:	75 e0                	jne    800e08 <strnlen+0x19>
		n++;
	return n;
  800e28:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e2b:	c9                   	leaveq 
  800e2c:	c3                   	retq   

0000000000800e2d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2d:	55                   	push   %rbp
  800e2e:	48 89 e5             	mov    %rsp,%rbp
  800e31:	48 83 ec 20          	sub    $0x20,%rsp
  800e35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e41:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e45:	90                   	nop
  800e46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e4a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e4e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e52:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e56:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e5a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e5e:	0f b6 12             	movzbl (%rdx),%edx
  800e61:	88 10                	mov    %dl,(%rax)
  800e63:	0f b6 00             	movzbl (%rax),%eax
  800e66:	84 c0                	test   %al,%al
  800e68:	75 dc                	jne    800e46 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e6e:	c9                   	leaveq 
  800e6f:	c3                   	retq   

0000000000800e70 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e70:	55                   	push   %rbp
  800e71:	48 89 e5             	mov    %rsp,%rbp
  800e74:	48 83 ec 20          	sub    $0x20,%rsp
  800e78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e7c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e84:	48 89 c7             	mov    %rax,%rdi
  800e87:	48 b8 c1 0d 80 00 00 	movabs $0x800dc1,%rax
  800e8e:	00 00 00 
  800e91:	ff d0                	callq  *%rax
  800e93:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e99:	48 63 d0             	movslq %eax,%rdx
  800e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea0:	48 01 c2             	add    %rax,%rdx
  800ea3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ea7:	48 89 c6             	mov    %rax,%rsi
  800eaa:	48 89 d7             	mov    %rdx,%rdi
  800ead:	48 b8 2d 0e 80 00 00 	movabs $0x800e2d,%rax
  800eb4:	00 00 00 
  800eb7:	ff d0                	callq  *%rax
	return dst;
  800eb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ebd:	c9                   	leaveq 
  800ebe:	c3                   	retq   

0000000000800ebf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ebf:	55                   	push   %rbp
  800ec0:	48 89 e5             	mov    %rsp,%rbp
  800ec3:	48 83 ec 28          	sub    $0x28,%rsp
  800ec7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ecb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ecf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ed3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800edb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ee2:	00 
  800ee3:	eb 2a                	jmp    800f0f <strncpy+0x50>
		*dst++ = *src;
  800ee5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eed:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ef1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ef5:	0f b6 12             	movzbl (%rdx),%edx
  800ef8:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800efa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800efe:	0f b6 00             	movzbl (%rax),%eax
  800f01:	84 c0                	test   %al,%al
  800f03:	74 05                	je     800f0a <strncpy+0x4b>
			src++;
  800f05:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f0a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f13:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f17:	72 cc                	jb     800ee5 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f1d:	c9                   	leaveq 
  800f1e:	c3                   	retq   

0000000000800f1f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f1f:	55                   	push   %rbp
  800f20:	48 89 e5             	mov    %rsp,%rbp
  800f23:	48 83 ec 28          	sub    $0x28,%rsp
  800f27:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f2f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f37:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f3b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f40:	74 3d                	je     800f7f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f42:	eb 1d                	jmp    800f61 <strlcpy+0x42>
			*dst++ = *src++;
  800f44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f48:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f4c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f50:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f54:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f58:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f5c:	0f b6 12             	movzbl (%rdx),%edx
  800f5f:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f61:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f66:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f6b:	74 0b                	je     800f78 <strlcpy+0x59>
  800f6d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f71:	0f b6 00             	movzbl (%rax),%eax
  800f74:	84 c0                	test   %al,%al
  800f76:	75 cc                	jne    800f44 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f87:	48 29 c2             	sub    %rax,%rdx
  800f8a:	48 89 d0             	mov    %rdx,%rax
}
  800f8d:	c9                   	leaveq 
  800f8e:	c3                   	retq   

0000000000800f8f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f8f:	55                   	push   %rbp
  800f90:	48 89 e5             	mov    %rsp,%rbp
  800f93:	48 83 ec 10          	sub    $0x10,%rsp
  800f97:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f9f:	eb 0a                	jmp    800fab <strcmp+0x1c>
		p++, q++;
  800fa1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fa6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800faf:	0f b6 00             	movzbl (%rax),%eax
  800fb2:	84 c0                	test   %al,%al
  800fb4:	74 12                	je     800fc8 <strcmp+0x39>
  800fb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fba:	0f b6 10             	movzbl (%rax),%edx
  800fbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc1:	0f b6 00             	movzbl (%rax),%eax
  800fc4:	38 c2                	cmp    %al,%dl
  800fc6:	74 d9                	je     800fa1 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fcc:	0f b6 00             	movzbl (%rax),%eax
  800fcf:	0f b6 d0             	movzbl %al,%edx
  800fd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd6:	0f b6 00             	movzbl (%rax),%eax
  800fd9:	0f b6 c0             	movzbl %al,%eax
  800fdc:	29 c2                	sub    %eax,%edx
  800fde:	89 d0                	mov    %edx,%eax
}
  800fe0:	c9                   	leaveq 
  800fe1:	c3                   	retq   

0000000000800fe2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fe2:	55                   	push   %rbp
  800fe3:	48 89 e5             	mov    %rsp,%rbp
  800fe6:	48 83 ec 18          	sub    $0x18,%rsp
  800fea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800ff2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800ff6:	eb 0f                	jmp    801007 <strncmp+0x25>
		n--, p++, q++;
  800ff8:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800ffd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801002:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801007:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80100c:	74 1d                	je     80102b <strncmp+0x49>
  80100e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801012:	0f b6 00             	movzbl (%rax),%eax
  801015:	84 c0                	test   %al,%al
  801017:	74 12                	je     80102b <strncmp+0x49>
  801019:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101d:	0f b6 10             	movzbl (%rax),%edx
  801020:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801024:	0f b6 00             	movzbl (%rax),%eax
  801027:	38 c2                	cmp    %al,%dl
  801029:	74 cd                	je     800ff8 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80102b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801030:	75 07                	jne    801039 <strncmp+0x57>
		return 0;
  801032:	b8 00 00 00 00       	mov    $0x0,%eax
  801037:	eb 18                	jmp    801051 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801039:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80103d:	0f b6 00             	movzbl (%rax),%eax
  801040:	0f b6 d0             	movzbl %al,%edx
  801043:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801047:	0f b6 00             	movzbl (%rax),%eax
  80104a:	0f b6 c0             	movzbl %al,%eax
  80104d:	29 c2                	sub    %eax,%edx
  80104f:	89 d0                	mov    %edx,%eax
}
  801051:	c9                   	leaveq 
  801052:	c3                   	retq   

0000000000801053 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801053:	55                   	push   %rbp
  801054:	48 89 e5             	mov    %rsp,%rbp
  801057:	48 83 ec 0c          	sub    $0xc,%rsp
  80105b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80105f:	89 f0                	mov    %esi,%eax
  801061:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801064:	eb 17                	jmp    80107d <strchr+0x2a>
		if (*s == c)
  801066:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106a:	0f b6 00             	movzbl (%rax),%eax
  80106d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801070:	75 06                	jne    801078 <strchr+0x25>
			return (char *) s;
  801072:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801076:	eb 15                	jmp    80108d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801078:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80107d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801081:	0f b6 00             	movzbl (%rax),%eax
  801084:	84 c0                	test   %al,%al
  801086:	75 de                	jne    801066 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801088:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108d:	c9                   	leaveq 
  80108e:	c3                   	retq   

000000000080108f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80108f:	55                   	push   %rbp
  801090:	48 89 e5             	mov    %rsp,%rbp
  801093:	48 83 ec 0c          	sub    $0xc,%rsp
  801097:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80109b:	89 f0                	mov    %esi,%eax
  80109d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010a0:	eb 13                	jmp    8010b5 <strfind+0x26>
		if (*s == c)
  8010a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a6:	0f b6 00             	movzbl (%rax),%eax
  8010a9:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010ac:	75 02                	jne    8010b0 <strfind+0x21>
			break;
  8010ae:	eb 10                	jmp    8010c0 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b9:	0f b6 00             	movzbl (%rax),%eax
  8010bc:	84 c0                	test   %al,%al
  8010be:	75 e2                	jne    8010a2 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010c4:	c9                   	leaveq 
  8010c5:	c3                   	retq   

00000000008010c6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010c6:	55                   	push   %rbp
  8010c7:	48 89 e5             	mov    %rsp,%rbp
  8010ca:	48 83 ec 18          	sub    $0x18,%rsp
  8010ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d2:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010d5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010de:	75 06                	jne    8010e6 <memset+0x20>
		return v;
  8010e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e4:	eb 69                	jmp    80114f <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ea:	83 e0 03             	and    $0x3,%eax
  8010ed:	48 85 c0             	test   %rax,%rax
  8010f0:	75 48                	jne    80113a <memset+0x74>
  8010f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f6:	83 e0 03             	and    $0x3,%eax
  8010f9:	48 85 c0             	test   %rax,%rax
  8010fc:	75 3c                	jne    80113a <memset+0x74>
		c &= 0xFF;
  8010fe:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801105:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801108:	c1 e0 18             	shl    $0x18,%eax
  80110b:	89 c2                	mov    %eax,%edx
  80110d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801110:	c1 e0 10             	shl    $0x10,%eax
  801113:	09 c2                	or     %eax,%edx
  801115:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801118:	c1 e0 08             	shl    $0x8,%eax
  80111b:	09 d0                	or     %edx,%eax
  80111d:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801120:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801124:	48 c1 e8 02          	shr    $0x2,%rax
  801128:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80112b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80112f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801132:	48 89 d7             	mov    %rdx,%rdi
  801135:	fc                   	cld    
  801136:	f3 ab                	rep stos %eax,%es:(%rdi)
  801138:	eb 11                	jmp    80114b <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80113a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80113e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801141:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801145:	48 89 d7             	mov    %rdx,%rdi
  801148:	fc                   	cld    
  801149:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80114b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80114f:	c9                   	leaveq 
  801150:	c3                   	retq   

0000000000801151 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801151:	55                   	push   %rbp
  801152:	48 89 e5             	mov    %rsp,%rbp
  801155:	48 83 ec 28          	sub    $0x28,%rsp
  801159:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801161:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801165:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801169:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80116d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801171:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801175:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801179:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80117d:	0f 83 88 00 00 00    	jae    80120b <memmove+0xba>
  801183:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801187:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80118b:	48 01 d0             	add    %rdx,%rax
  80118e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801192:	76 77                	jbe    80120b <memmove+0xba>
		s += n;
  801194:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801198:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80119c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011a0:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a8:	83 e0 03             	and    $0x3,%eax
  8011ab:	48 85 c0             	test   %rax,%rax
  8011ae:	75 3b                	jne    8011eb <memmove+0x9a>
  8011b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b4:	83 e0 03             	and    $0x3,%eax
  8011b7:	48 85 c0             	test   %rax,%rax
  8011ba:	75 2f                	jne    8011eb <memmove+0x9a>
  8011bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011c0:	83 e0 03             	and    $0x3,%eax
  8011c3:	48 85 c0             	test   %rax,%rax
  8011c6:	75 23                	jne    8011eb <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cc:	48 83 e8 04          	sub    $0x4,%rax
  8011d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d4:	48 83 ea 04          	sub    $0x4,%rdx
  8011d8:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011dc:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011e0:	48 89 c7             	mov    %rax,%rdi
  8011e3:	48 89 d6             	mov    %rdx,%rsi
  8011e6:	fd                   	std    
  8011e7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011e9:	eb 1d                	jmp    801208 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ef:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f7:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ff:	48 89 d7             	mov    %rdx,%rdi
  801202:	48 89 c1             	mov    %rax,%rcx
  801205:	fd                   	std    
  801206:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801208:	fc                   	cld    
  801209:	eb 57                	jmp    801262 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120f:	83 e0 03             	and    $0x3,%eax
  801212:	48 85 c0             	test   %rax,%rax
  801215:	75 36                	jne    80124d <memmove+0xfc>
  801217:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121b:	83 e0 03             	and    $0x3,%eax
  80121e:	48 85 c0             	test   %rax,%rax
  801221:	75 2a                	jne    80124d <memmove+0xfc>
  801223:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801227:	83 e0 03             	and    $0x3,%eax
  80122a:	48 85 c0             	test   %rax,%rax
  80122d:	75 1e                	jne    80124d <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80122f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801233:	48 c1 e8 02          	shr    $0x2,%rax
  801237:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80123a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801242:	48 89 c7             	mov    %rax,%rdi
  801245:	48 89 d6             	mov    %rdx,%rsi
  801248:	fc                   	cld    
  801249:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80124b:	eb 15                	jmp    801262 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80124d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801251:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801255:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801259:	48 89 c7             	mov    %rax,%rdi
  80125c:	48 89 d6             	mov    %rdx,%rsi
  80125f:	fc                   	cld    
  801260:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801262:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801266:	c9                   	leaveq 
  801267:	c3                   	retq   

0000000000801268 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801268:	55                   	push   %rbp
  801269:	48 89 e5             	mov    %rsp,%rbp
  80126c:	48 83 ec 18          	sub    $0x18,%rsp
  801270:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801274:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801278:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80127c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801280:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801284:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801288:	48 89 ce             	mov    %rcx,%rsi
  80128b:	48 89 c7             	mov    %rax,%rdi
  80128e:	48 b8 51 11 80 00 00 	movabs $0x801151,%rax
  801295:	00 00 00 
  801298:	ff d0                	callq  *%rax
}
  80129a:	c9                   	leaveq 
  80129b:	c3                   	retq   

000000000080129c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80129c:	55                   	push   %rbp
  80129d:	48 89 e5             	mov    %rsp,%rbp
  8012a0:	48 83 ec 28          	sub    $0x28,%rsp
  8012a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012c0:	eb 36                	jmp    8012f8 <memcmp+0x5c>
		if (*s1 != *s2)
  8012c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c6:	0f b6 10             	movzbl (%rax),%edx
  8012c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012cd:	0f b6 00             	movzbl (%rax),%eax
  8012d0:	38 c2                	cmp    %al,%dl
  8012d2:	74 1a                	je     8012ee <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d8:	0f b6 00             	movzbl (%rax),%eax
  8012db:	0f b6 d0             	movzbl %al,%edx
  8012de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e2:	0f b6 00             	movzbl (%rax),%eax
  8012e5:	0f b6 c0             	movzbl %al,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
  8012ec:	eb 20                	jmp    80130e <memcmp+0x72>
		s1++, s2++;
  8012ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012fc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801300:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801304:	48 85 c0             	test   %rax,%rax
  801307:	75 b9                	jne    8012c2 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801309:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130e:	c9                   	leaveq 
  80130f:	c3                   	retq   

0000000000801310 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801310:	55                   	push   %rbp
  801311:	48 89 e5             	mov    %rsp,%rbp
  801314:	48 83 ec 28          	sub    $0x28,%rsp
  801318:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80131c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80131f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801323:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801327:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80132b:	48 01 d0             	add    %rdx,%rax
  80132e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801332:	eb 15                	jmp    801349 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801338:	0f b6 10             	movzbl (%rax),%edx
  80133b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80133e:	38 c2                	cmp    %al,%dl
  801340:	75 02                	jne    801344 <memfind+0x34>
			break;
  801342:	eb 0f                	jmp    801353 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801344:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801349:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134d:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801351:	72 e1                	jb     801334 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801357:	c9                   	leaveq 
  801358:	c3                   	retq   

0000000000801359 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801359:	55                   	push   %rbp
  80135a:	48 89 e5             	mov    %rsp,%rbp
  80135d:	48 83 ec 34          	sub    $0x34,%rsp
  801361:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801365:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801369:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80136c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801373:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80137a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137b:	eb 05                	jmp    801382 <strtol+0x29>
		s++;
  80137d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801382:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801386:	0f b6 00             	movzbl (%rax),%eax
  801389:	3c 20                	cmp    $0x20,%al
  80138b:	74 f0                	je     80137d <strtol+0x24>
  80138d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801391:	0f b6 00             	movzbl (%rax),%eax
  801394:	3c 09                	cmp    $0x9,%al
  801396:	74 e5                	je     80137d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801398:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139c:	0f b6 00             	movzbl (%rax),%eax
  80139f:	3c 2b                	cmp    $0x2b,%al
  8013a1:	75 07                	jne    8013aa <strtol+0x51>
		s++;
  8013a3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013a8:	eb 17                	jmp    8013c1 <strtol+0x68>
	else if (*s == '-')
  8013aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ae:	0f b6 00             	movzbl (%rax),%eax
  8013b1:	3c 2d                	cmp    $0x2d,%al
  8013b3:	75 0c                	jne    8013c1 <strtol+0x68>
		s++, neg = 1;
  8013b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013ba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013c5:	74 06                	je     8013cd <strtol+0x74>
  8013c7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013cb:	75 28                	jne    8013f5 <strtol+0x9c>
  8013cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d1:	0f b6 00             	movzbl (%rax),%eax
  8013d4:	3c 30                	cmp    $0x30,%al
  8013d6:	75 1d                	jne    8013f5 <strtol+0x9c>
  8013d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013dc:	48 83 c0 01          	add    $0x1,%rax
  8013e0:	0f b6 00             	movzbl (%rax),%eax
  8013e3:	3c 78                	cmp    $0x78,%al
  8013e5:	75 0e                	jne    8013f5 <strtol+0x9c>
		s += 2, base = 16;
  8013e7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013ec:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013f3:	eb 2c                	jmp    801421 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013f5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013f9:	75 19                	jne    801414 <strtol+0xbb>
  8013fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ff:	0f b6 00             	movzbl (%rax),%eax
  801402:	3c 30                	cmp    $0x30,%al
  801404:	75 0e                	jne    801414 <strtol+0xbb>
		s++, base = 8;
  801406:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80140b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801412:	eb 0d                	jmp    801421 <strtol+0xc8>
	else if (base == 0)
  801414:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801418:	75 07                	jne    801421 <strtol+0xc8>
		base = 10;
  80141a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801421:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801425:	0f b6 00             	movzbl (%rax),%eax
  801428:	3c 2f                	cmp    $0x2f,%al
  80142a:	7e 1d                	jle    801449 <strtol+0xf0>
  80142c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801430:	0f b6 00             	movzbl (%rax),%eax
  801433:	3c 39                	cmp    $0x39,%al
  801435:	7f 12                	jg     801449 <strtol+0xf0>
			dig = *s - '0';
  801437:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143b:	0f b6 00             	movzbl (%rax),%eax
  80143e:	0f be c0             	movsbl %al,%eax
  801441:	83 e8 30             	sub    $0x30,%eax
  801444:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801447:	eb 4e                	jmp    801497 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801449:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144d:	0f b6 00             	movzbl (%rax),%eax
  801450:	3c 60                	cmp    $0x60,%al
  801452:	7e 1d                	jle    801471 <strtol+0x118>
  801454:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801458:	0f b6 00             	movzbl (%rax),%eax
  80145b:	3c 7a                	cmp    $0x7a,%al
  80145d:	7f 12                	jg     801471 <strtol+0x118>
			dig = *s - 'a' + 10;
  80145f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801463:	0f b6 00             	movzbl (%rax),%eax
  801466:	0f be c0             	movsbl %al,%eax
  801469:	83 e8 57             	sub    $0x57,%eax
  80146c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80146f:	eb 26                	jmp    801497 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801471:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801475:	0f b6 00             	movzbl (%rax),%eax
  801478:	3c 40                	cmp    $0x40,%al
  80147a:	7e 48                	jle    8014c4 <strtol+0x16b>
  80147c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801480:	0f b6 00             	movzbl (%rax),%eax
  801483:	3c 5a                	cmp    $0x5a,%al
  801485:	7f 3d                	jg     8014c4 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801487:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148b:	0f b6 00             	movzbl (%rax),%eax
  80148e:	0f be c0             	movsbl %al,%eax
  801491:	83 e8 37             	sub    $0x37,%eax
  801494:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801497:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80149a:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80149d:	7c 02                	jl     8014a1 <strtol+0x148>
			break;
  80149f:	eb 23                	jmp    8014c4 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014a1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014a6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014a9:	48 98                	cltq   
  8014ab:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014b0:	48 89 c2             	mov    %rax,%rdx
  8014b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014b6:	48 98                	cltq   
  8014b8:	48 01 d0             	add    %rdx,%rax
  8014bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014bf:	e9 5d ff ff ff       	jmpq   801421 <strtol+0xc8>

	if (endptr)
  8014c4:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014c9:	74 0b                	je     8014d6 <strtol+0x17d>
		*endptr = (char *) s;
  8014cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014cf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014d3:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014da:	74 09                	je     8014e5 <strtol+0x18c>
  8014dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e0:	48 f7 d8             	neg    %rax
  8014e3:	eb 04                	jmp    8014e9 <strtol+0x190>
  8014e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014e9:	c9                   	leaveq 
  8014ea:	c3                   	retq   

00000000008014eb <strstr>:

char * strstr(const char *in, const char *str)
{
  8014eb:	55                   	push   %rbp
  8014ec:	48 89 e5             	mov    %rsp,%rbp
  8014ef:	48 83 ec 30          	sub    $0x30,%rsp
  8014f3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014f7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014ff:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801503:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801507:	0f b6 00             	movzbl (%rax),%eax
  80150a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80150d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801511:	75 06                	jne    801519 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801513:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801517:	eb 6b                	jmp    801584 <strstr+0x99>

	len = strlen(str);
  801519:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80151d:	48 89 c7             	mov    %rax,%rdi
  801520:	48 b8 c1 0d 80 00 00 	movabs $0x800dc1,%rax
  801527:	00 00 00 
  80152a:	ff d0                	callq  *%rax
  80152c:	48 98                	cltq   
  80152e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801532:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801536:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80153a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80153e:	0f b6 00             	movzbl (%rax),%eax
  801541:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801544:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801548:	75 07                	jne    801551 <strstr+0x66>
				return (char *) 0;
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
  80154f:	eb 33                	jmp    801584 <strstr+0x99>
		} while (sc != c);
  801551:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801555:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801558:	75 d8                	jne    801532 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80155a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80155e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801562:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801566:	48 89 ce             	mov    %rcx,%rsi
  801569:	48 89 c7             	mov    %rax,%rdi
  80156c:	48 b8 e2 0f 80 00 00 	movabs $0x800fe2,%rax
  801573:	00 00 00 
  801576:	ff d0                	callq  *%rax
  801578:	85 c0                	test   %eax,%eax
  80157a:	75 b6                	jne    801532 <strstr+0x47>

	return (char *) (in - 1);
  80157c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801580:	48 83 e8 01          	sub    $0x1,%rax
}
  801584:	c9                   	leaveq 
  801585:	c3                   	retq   

0000000000801586 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801586:	55                   	push   %rbp
  801587:	48 89 e5             	mov    %rsp,%rbp
  80158a:	53                   	push   %rbx
  80158b:	48 83 ec 48          	sub    $0x48,%rsp
  80158f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801592:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801595:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801599:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80159d:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015a1:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015a5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015a8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015ac:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015b0:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015b4:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015b8:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015bc:	4c 89 c3             	mov    %r8,%rbx
  8015bf:	cd 30                	int    $0x30
  8015c1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015c9:	74 3e                	je     801609 <syscall+0x83>
  8015cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015d0:	7e 37                	jle    801609 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015d6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015d9:	49 89 d0             	mov    %rdx,%r8
  8015dc:	89 c1                	mov    %eax,%ecx
  8015de:	48 ba 88 1c 80 00 00 	movabs $0x801c88,%rdx
  8015e5:	00 00 00 
  8015e8:	be 23 00 00 00       	mov    $0x23,%esi
  8015ed:	48 bf a5 1c 80 00 00 	movabs $0x801ca5,%rdi
  8015f4:	00 00 00 
  8015f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fc:	49 b9 1e 17 80 00 00 	movabs $0x80171e,%r9
  801603:	00 00 00 
  801606:	41 ff d1             	callq  *%r9

	return ret;
  801609:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80160d:	48 83 c4 48          	add    $0x48,%rsp
  801611:	5b                   	pop    %rbx
  801612:	5d                   	pop    %rbp
  801613:	c3                   	retq   

0000000000801614 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801614:	55                   	push   %rbp
  801615:	48 89 e5             	mov    %rsp,%rbp
  801618:	48 83 ec 20          	sub    $0x20,%rsp
  80161c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801620:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801628:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80162c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801633:	00 
  801634:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80163a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801640:	48 89 d1             	mov    %rdx,%rcx
  801643:	48 89 c2             	mov    %rax,%rdx
  801646:	be 00 00 00 00       	mov    $0x0,%esi
  80164b:	bf 00 00 00 00       	mov    $0x0,%edi
  801650:	48 b8 86 15 80 00 00 	movabs $0x801586,%rax
  801657:	00 00 00 
  80165a:	ff d0                	callq  *%rax
}
  80165c:	c9                   	leaveq 
  80165d:	c3                   	retq   

000000000080165e <sys_cgetc>:

int
sys_cgetc(void)
{
  80165e:	55                   	push   %rbp
  80165f:	48 89 e5             	mov    %rsp,%rbp
  801662:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801666:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80166d:	00 
  80166e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801674:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80167a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80167f:	ba 00 00 00 00       	mov    $0x0,%edx
  801684:	be 00 00 00 00       	mov    $0x0,%esi
  801689:	bf 01 00 00 00       	mov    $0x1,%edi
  80168e:	48 b8 86 15 80 00 00 	movabs $0x801586,%rax
  801695:	00 00 00 
  801698:	ff d0                	callq  *%rax
}
  80169a:	c9                   	leaveq 
  80169b:	c3                   	retq   

000000000080169c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80169c:	55                   	push   %rbp
  80169d:	48 89 e5             	mov    %rsp,%rbp
  8016a0:	48 83 ec 10          	sub    $0x10,%rsp
  8016a4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016aa:	48 98                	cltq   
  8016ac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016b3:	00 
  8016b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016c5:	48 89 c2             	mov    %rax,%rdx
  8016c8:	be 01 00 00 00       	mov    $0x1,%esi
  8016cd:	bf 03 00 00 00       	mov    $0x3,%edi
  8016d2:	48 b8 86 15 80 00 00 	movabs $0x801586,%rax
  8016d9:	00 00 00 
  8016dc:	ff d0                	callq  *%rax
}
  8016de:	c9                   	leaveq 
  8016df:	c3                   	retq   

00000000008016e0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016e0:	55                   	push   %rbp
  8016e1:	48 89 e5             	mov    %rsp,%rbp
  8016e4:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016e8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ef:	00 
  8016f0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801701:	ba 00 00 00 00       	mov    $0x0,%edx
  801706:	be 00 00 00 00       	mov    $0x0,%esi
  80170b:	bf 02 00 00 00       	mov    $0x2,%edi
  801710:	48 b8 86 15 80 00 00 	movabs $0x801586,%rax
  801717:	00 00 00 
  80171a:	ff d0                	callq  *%rax
}
  80171c:	c9                   	leaveq 
  80171d:	c3                   	retq   

000000000080171e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80171e:	55                   	push   %rbp
  80171f:	48 89 e5             	mov    %rsp,%rbp
  801722:	53                   	push   %rbx
  801723:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80172a:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801731:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801737:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80173e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801745:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80174c:	84 c0                	test   %al,%al
  80174e:	74 23                	je     801773 <_panic+0x55>
  801750:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801757:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80175b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80175f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801763:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801767:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80176b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80176f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801773:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80177a:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801781:	00 00 00 
  801784:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80178b:	00 00 00 
  80178e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801792:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801799:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8017a0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8017a7:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8017ae:	00 00 00 
  8017b1:	48 8b 18             	mov    (%rax),%rbx
  8017b4:	48 b8 e0 16 80 00 00 	movabs $0x8016e0,%rax
  8017bb:	00 00 00 
  8017be:	ff d0                	callq  *%rax
  8017c0:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8017c6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8017cd:	41 89 c8             	mov    %ecx,%r8d
  8017d0:	48 89 d1             	mov    %rdx,%rcx
  8017d3:	48 89 da             	mov    %rbx,%rdx
  8017d6:	89 c6                	mov    %eax,%esi
  8017d8:	48 bf b8 1c 80 00 00 	movabs $0x801cb8,%rdi
  8017df:	00 00 00 
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e7:	49 b9 65 02 80 00 00 	movabs $0x800265,%r9
  8017ee:	00 00 00 
  8017f1:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017f4:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8017fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801802:	48 89 d6             	mov    %rdx,%rsi
  801805:	48 89 c7             	mov    %rax,%rdi
  801808:	48 b8 b9 01 80 00 00 	movabs $0x8001b9,%rax
  80180f:	00 00 00 
  801812:	ff d0                	callq  *%rax
	cprintf("\n");
  801814:	48 bf db 1c 80 00 00 	movabs $0x801cdb,%rdi
  80181b:	00 00 00 
  80181e:	b8 00 00 00 00       	mov    $0x0,%eax
  801823:	48 ba 65 02 80 00 00 	movabs $0x800265,%rdx
  80182a:	00 00 00 
  80182d:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80182f:	cc                   	int3   
  801830:	eb fd                	jmp    80182f <_panic+0x111>
