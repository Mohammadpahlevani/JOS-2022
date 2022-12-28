
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
  80005b:	48 bf 20 18 80 00 00 	movabs $0x801820,%rdi
  800062:	00 00 00 
  800065:	b8 00 00 00 00       	mov    $0x0,%eax
  80006a:	48 ba 3e 02 80 00 00 	movabs $0x80023e,%rdx
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
  80007c:	48 83 ec 10          	sub    $0x10,%rsp
  800080:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800083:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  800087:	48 b8 b9 16 80 00 00 	movabs $0x8016b9,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	25 ff 03 00 00       	and    $0x3ff,%eax
  800098:	48 98                	cltq   
  80009a:	48 c1 e0 03          	shl    $0x3,%rax
  80009e:	48 89 c2             	mov    %rax,%rdx
  8000a1:	48 c1 e2 05          	shl    $0x5,%rdx
  8000a5:	48 29 c2             	sub    %rax,%rdx
  8000a8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000af:	00 00 00 
  8000b2:	48 01 c2             	add    %rax,%rdx
  8000b5:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000bc:	00 00 00 
  8000bf:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c6:	7e 14                	jle    8000dc <libmain+0x64>
		binaryname = argv[0];
  8000c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000cc:	48 8b 10             	mov    (%rax),%rdx
  8000cf:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000d6:	00 00 00 
  8000d9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e3:	48 89 d6             	mov    %rdx,%rsi
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000ef:	00 00 00 
  8000f2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f4:	48 b8 02 01 80 00 00 	movabs $0x800102,%rax
  8000fb:	00 00 00 
  8000fe:	ff d0                	callq  *%rax
}
  800100:	c9                   	leaveq 
  800101:	c3                   	retq   

0000000000800102 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800102:	55                   	push   %rbp
  800103:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  800106:	bf 00 00 00 00       	mov    $0x0,%edi
  80010b:	48 b8 75 16 80 00 00 	movabs $0x801675,%rax
  800112:	00 00 00 
  800115:	ff d0                	callq  *%rax
}
  800117:	5d                   	pop    %rbp
  800118:	c3                   	retq   

0000000000800119 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800119:	55                   	push   %rbp
  80011a:	48 89 e5             	mov    %rsp,%rbp
  80011d:	48 83 ec 10          	sub    $0x10,%rsp
  800121:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800124:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800128:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80012c:	8b 00                	mov    (%rax),%eax
  80012e:	8d 48 01             	lea    0x1(%rax),%ecx
  800131:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800135:	89 0a                	mov    %ecx,(%rdx)
  800137:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80013a:	89 d1                	mov    %edx,%ecx
  80013c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800140:	48 98                	cltq   
  800142:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80014a:	8b 00                	mov    (%rax),%eax
  80014c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800151:	75 2c                	jne    80017f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800153:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800157:	8b 00                	mov    (%rax),%eax
  800159:	48 98                	cltq   
  80015b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80015f:	48 83 c2 08          	add    $0x8,%rdx
  800163:	48 89 c6             	mov    %rax,%rsi
  800166:	48 89 d7             	mov    %rdx,%rdi
  800169:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  800170:	00 00 00 
  800173:	ff d0                	callq  *%rax
        b->idx = 0;
  800175:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800179:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80017f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800183:	8b 40 04             	mov    0x4(%rax),%eax
  800186:	8d 50 01             	lea    0x1(%rax),%edx
  800189:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800190:	c9                   	leaveq 
  800191:	c3                   	retq   

0000000000800192 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800192:	55                   	push   %rbp
  800193:	48 89 e5             	mov    %rsp,%rbp
  800196:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80019d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001a4:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001ab:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001b2:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001b9:	48 8b 0a             	mov    (%rdx),%rcx
  8001bc:	48 89 08             	mov    %rcx,(%rax)
  8001bf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001c3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001c7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001cb:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001d6:	00 00 00 
    b.cnt = 0;
  8001d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001e0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001e3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8001ea:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8001f1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001f8:	48 89 c6             	mov    %rax,%rsi
  8001fb:	48 bf 19 01 80 00 00 	movabs $0x800119,%rdi
  800202:	00 00 00 
  800205:	48 b8 f1 05 80 00 00 	movabs $0x8005f1,%rax
  80020c:	00 00 00 
  80020f:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800211:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800217:	48 98                	cltq   
  800219:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800220:	48 83 c2 08          	add    $0x8,%rdx
  800224:	48 89 c6             	mov    %rax,%rsi
  800227:	48 89 d7             	mov    %rdx,%rdi
  80022a:	48 b8 ed 15 80 00 00 	movabs $0x8015ed,%rax
  800231:	00 00 00 
  800234:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800236:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80023c:	c9                   	leaveq 
  80023d:	c3                   	retq   

000000000080023e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80023e:	55                   	push   %rbp
  80023f:	48 89 e5             	mov    %rsp,%rbp
  800242:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800249:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800250:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800257:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80025e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800265:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80026c:	84 c0                	test   %al,%al
  80026e:	74 20                	je     800290 <cprintf+0x52>
  800270:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800274:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800278:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80027c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800280:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800284:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800288:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80028c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800290:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800297:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80029e:	00 00 00 
  8002a1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002a8:	00 00 00 
  8002ab:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002af:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002b6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002bd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002c4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002cb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002d2:	48 8b 0a             	mov    (%rdx),%rcx
  8002d5:	48 89 08             	mov    %rcx,(%rax)
  8002d8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002dc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002e0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002e4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8002e8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8002ef:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002f6:	48 89 d6             	mov    %rdx,%rsi
  8002f9:	48 89 c7             	mov    %rax,%rdi
  8002fc:	48 b8 92 01 80 00 00 	movabs $0x800192,%rax
  800303:	00 00 00 
  800306:	ff d0                	callq  *%rax
  800308:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80030e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800314:	c9                   	leaveq 
  800315:	c3                   	retq   

0000000000800316 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800316:	55                   	push   %rbp
  800317:	48 89 e5             	mov    %rsp,%rbp
  80031a:	53                   	push   %rbx
  80031b:	48 83 ec 38          	sub    $0x38,%rsp
  80031f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800323:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800327:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80032b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80032e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800332:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800336:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800339:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80033d:	77 3b                	ja     80037a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80033f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800342:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800346:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800349:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80034d:	ba 00 00 00 00       	mov    $0x0,%edx
  800352:	48 f7 f3             	div    %rbx
  800355:	48 89 c2             	mov    %rax,%rdx
  800358:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80035b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80035e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800362:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800366:	41 89 f9             	mov    %edi,%r9d
  800369:	48 89 c7             	mov    %rax,%rdi
  80036c:	48 b8 16 03 80 00 00 	movabs $0x800316,%rax
  800373:	00 00 00 
  800376:	ff d0                	callq  *%rax
  800378:	eb 1e                	jmp    800398 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80037a:	eb 12                	jmp    80038e <printnum+0x78>
			putch(padc, putdat);
  80037c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800380:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800383:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800387:	48 89 ce             	mov    %rcx,%rsi
  80038a:	89 d7                	mov    %edx,%edi
  80038c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80038e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800392:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800396:	7f e4                	jg     80037c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800398:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80039b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80039f:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a4:	48 f7 f1             	div    %rcx
  8003a7:	48 89 d0             	mov    %rdx,%rax
  8003aa:	48 ba 90 19 80 00 00 	movabs $0x801990,%rdx
  8003b1:	00 00 00 
  8003b4:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003b8:	0f be d0             	movsbl %al,%edx
  8003bb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c3:	48 89 ce             	mov    %rcx,%rsi
  8003c6:	89 d7                	mov    %edx,%edi
  8003c8:	ff d0                	callq  *%rax
}
  8003ca:	48 83 c4 38          	add    $0x38,%rsp
  8003ce:	5b                   	pop    %rbx
  8003cf:	5d                   	pop    %rbp
  8003d0:	c3                   	retq   

00000000008003d1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d1:	55                   	push   %rbp
  8003d2:	48 89 e5             	mov    %rsp,%rbp
  8003d5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003dd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003e0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003e4:	7e 52                	jle    800438 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8003e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ea:	8b 00                	mov    (%rax),%eax
  8003ec:	83 f8 30             	cmp    $0x30,%eax
  8003ef:	73 24                	jae    800415 <getuint+0x44>
  8003f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8003f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fd:	8b 00                	mov    (%rax),%eax
  8003ff:	89 c0                	mov    %eax,%eax
  800401:	48 01 d0             	add    %rdx,%rax
  800404:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800408:	8b 12                	mov    (%rdx),%edx
  80040a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80040d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800411:	89 0a                	mov    %ecx,(%rdx)
  800413:	eb 17                	jmp    80042c <getuint+0x5b>
  800415:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800419:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80041d:	48 89 d0             	mov    %rdx,%rax
  800420:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800424:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800428:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80042c:	48 8b 00             	mov    (%rax),%rax
  80042f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800433:	e9 a3 00 00 00       	jmpq   8004db <getuint+0x10a>
	else if (lflag)
  800438:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80043c:	74 4f                	je     80048d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80043e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800442:	8b 00                	mov    (%rax),%eax
  800444:	83 f8 30             	cmp    $0x30,%eax
  800447:	73 24                	jae    80046d <getuint+0x9c>
  800449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800451:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800455:	8b 00                	mov    (%rax),%eax
  800457:	89 c0                	mov    %eax,%eax
  800459:	48 01 d0             	add    %rdx,%rax
  80045c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800460:	8b 12                	mov    (%rdx),%edx
  800462:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800465:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800469:	89 0a                	mov    %ecx,(%rdx)
  80046b:	eb 17                	jmp    800484 <getuint+0xb3>
  80046d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800471:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800475:	48 89 d0             	mov    %rdx,%rax
  800478:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80047c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800480:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800484:	48 8b 00             	mov    (%rax),%rax
  800487:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80048b:	eb 4e                	jmp    8004db <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80048d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800491:	8b 00                	mov    (%rax),%eax
  800493:	83 f8 30             	cmp    $0x30,%eax
  800496:	73 24                	jae    8004bc <getuint+0xeb>
  800498:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a4:	8b 00                	mov    (%rax),%eax
  8004a6:	89 c0                	mov    %eax,%eax
  8004a8:	48 01 d0             	add    %rdx,%rax
  8004ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004af:	8b 12                	mov    (%rdx),%edx
  8004b1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b8:	89 0a                	mov    %ecx,(%rdx)
  8004ba:	eb 17                	jmp    8004d3 <getuint+0x102>
  8004bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004c4:	48 89 d0             	mov    %rdx,%rax
  8004c7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004cf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004d3:	8b 00                	mov    (%rax),%eax
  8004d5:	89 c0                	mov    %eax,%eax
  8004d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004df:	c9                   	leaveq 
  8004e0:	c3                   	retq   

00000000008004e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004e1:	55                   	push   %rbp
  8004e2:	48 89 e5             	mov    %rsp,%rbp
  8004e5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004ed:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8004f0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004f4:	7e 52                	jle    800548 <getint+0x67>
		x=va_arg(*ap, long long);
  8004f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fa:	8b 00                	mov    (%rax),%eax
  8004fc:	83 f8 30             	cmp    $0x30,%eax
  8004ff:	73 24                	jae    800525 <getint+0x44>
  800501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800505:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050d:	8b 00                	mov    (%rax),%eax
  80050f:	89 c0                	mov    %eax,%eax
  800511:	48 01 d0             	add    %rdx,%rax
  800514:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800518:	8b 12                	mov    (%rdx),%edx
  80051a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80051d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800521:	89 0a                	mov    %ecx,(%rdx)
  800523:	eb 17                	jmp    80053c <getint+0x5b>
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80052d:	48 89 d0             	mov    %rdx,%rax
  800530:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800534:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800538:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80053c:	48 8b 00             	mov    (%rax),%rax
  80053f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800543:	e9 a3 00 00 00       	jmpq   8005eb <getint+0x10a>
	else if (lflag)
  800548:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80054c:	74 4f                	je     80059d <getint+0xbc>
		x=va_arg(*ap, long);
  80054e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800552:	8b 00                	mov    (%rax),%eax
  800554:	83 f8 30             	cmp    $0x30,%eax
  800557:	73 24                	jae    80057d <getint+0x9c>
  800559:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800565:	8b 00                	mov    (%rax),%eax
  800567:	89 c0                	mov    %eax,%eax
  800569:	48 01 d0             	add    %rdx,%rax
  80056c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800570:	8b 12                	mov    (%rdx),%edx
  800572:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800575:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800579:	89 0a                	mov    %ecx,(%rdx)
  80057b:	eb 17                	jmp    800594 <getint+0xb3>
  80057d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800581:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800585:	48 89 d0             	mov    %rdx,%rax
  800588:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80058c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800590:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800594:	48 8b 00             	mov    (%rax),%rax
  800597:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80059b:	eb 4e                	jmp    8005eb <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80059d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a1:	8b 00                	mov    (%rax),%eax
  8005a3:	83 f8 30             	cmp    $0x30,%eax
  8005a6:	73 24                	jae    8005cc <getint+0xeb>
  8005a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b4:	8b 00                	mov    (%rax),%eax
  8005b6:	89 c0                	mov    %eax,%eax
  8005b8:	48 01 d0             	add    %rdx,%rax
  8005bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bf:	8b 12                	mov    (%rdx),%edx
  8005c1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c8:	89 0a                	mov    %ecx,(%rdx)
  8005ca:	eb 17                	jmp    8005e3 <getint+0x102>
  8005cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005d4:	48 89 d0             	mov    %rdx,%rax
  8005d7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005db:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005df:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005e3:	8b 00                	mov    (%rax),%eax
  8005e5:	48 98                	cltq   
  8005e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005ef:	c9                   	leaveq 
  8005f0:	c3                   	retq   

00000000008005f1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005f1:	55                   	push   %rbp
  8005f2:	48 89 e5             	mov    %rsp,%rbp
  8005f5:	41 54                	push   %r12
  8005f7:	53                   	push   %rbx
  8005f8:	48 83 ec 60          	sub    $0x60,%rsp
  8005fc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800600:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800604:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800608:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80060c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800610:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800614:	48 8b 0a             	mov    (%rdx),%rcx
  800617:	48 89 08             	mov    %rcx,(%rax)
  80061a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80061e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800622:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800626:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80062a:	eb 17                	jmp    800643 <vprintfmt+0x52>
			if (ch == '\0')
  80062c:	85 db                	test   %ebx,%ebx
  80062e:	0f 84 df 04 00 00    	je     800b13 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800634:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800638:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80063c:	48 89 d6             	mov    %rdx,%rsi
  80063f:	89 df                	mov    %ebx,%edi
  800641:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800643:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800647:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80064b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80064f:	0f b6 00             	movzbl (%rax),%eax
  800652:	0f b6 d8             	movzbl %al,%ebx
  800655:	83 fb 25             	cmp    $0x25,%ebx
  800658:	75 d2                	jne    80062c <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80065a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80065e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800665:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80066c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800673:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80067e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800682:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800686:	0f b6 00             	movzbl (%rax),%eax
  800689:	0f b6 d8             	movzbl %al,%ebx
  80068c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80068f:	83 f8 55             	cmp    $0x55,%eax
  800692:	0f 87 47 04 00 00    	ja     800adf <vprintfmt+0x4ee>
  800698:	89 c0                	mov    %eax,%eax
  80069a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006a1:	00 
  8006a2:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  8006a9:	00 00 00 
  8006ac:	48 01 d0             	add    %rdx,%rax
  8006af:	48 8b 00             	mov    (%rax),%rax
  8006b2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006b4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006b8:	eb c0                	jmp    80067a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ba:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006be:	eb ba                	jmp    80067a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006c7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006ca:	89 d0                	mov    %edx,%eax
  8006cc:	c1 e0 02             	shl    $0x2,%eax
  8006cf:	01 d0                	add    %edx,%eax
  8006d1:	01 c0                	add    %eax,%eax
  8006d3:	01 d8                	add    %ebx,%eax
  8006d5:	83 e8 30             	sub    $0x30,%eax
  8006d8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006db:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006df:	0f b6 00             	movzbl (%rax),%eax
  8006e2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e5:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e8:	7e 0c                	jle    8006f6 <vprintfmt+0x105>
  8006ea:	83 fb 39             	cmp    $0x39,%ebx
  8006ed:	7f 07                	jg     8006f6 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ef:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f4:	eb d1                	jmp    8006c7 <vprintfmt+0xd6>
			goto process_precision;
  8006f6:	eb 58                	jmp    800750 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8006f8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8006fb:	83 f8 30             	cmp    $0x30,%eax
  8006fe:	73 17                	jae    800717 <vprintfmt+0x126>
  800700:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800704:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800707:	89 c0                	mov    %eax,%eax
  800709:	48 01 d0             	add    %rdx,%rax
  80070c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80070f:	83 c2 08             	add    $0x8,%edx
  800712:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800715:	eb 0f                	jmp    800726 <vprintfmt+0x135>
  800717:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80071b:	48 89 d0             	mov    %rdx,%rax
  80071e:	48 83 c2 08          	add    $0x8,%rdx
  800722:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800726:	8b 00                	mov    (%rax),%eax
  800728:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80072b:	eb 23                	jmp    800750 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80072d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800731:	79 0c                	jns    80073f <vprintfmt+0x14e>
				width = 0;
  800733:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80073a:	e9 3b ff ff ff       	jmpq   80067a <vprintfmt+0x89>
  80073f:	e9 36 ff ff ff       	jmpq   80067a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800744:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80074b:	e9 2a ff ff ff       	jmpq   80067a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800750:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800754:	79 12                	jns    800768 <vprintfmt+0x177>
				width = precision, precision = -1;
  800756:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800759:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80075c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800763:	e9 12 ff ff ff       	jmpq   80067a <vprintfmt+0x89>
  800768:	e9 0d ff ff ff       	jmpq   80067a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80076d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800771:	e9 04 ff ff ff       	jmpq   80067a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800776:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800779:	83 f8 30             	cmp    $0x30,%eax
  80077c:	73 17                	jae    800795 <vprintfmt+0x1a4>
  80077e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800782:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800785:	89 c0                	mov    %eax,%eax
  800787:	48 01 d0             	add    %rdx,%rax
  80078a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80078d:	83 c2 08             	add    $0x8,%edx
  800790:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800793:	eb 0f                	jmp    8007a4 <vprintfmt+0x1b3>
  800795:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800799:	48 89 d0             	mov    %rdx,%rax
  80079c:	48 83 c2 08          	add    $0x8,%rdx
  8007a0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007a4:	8b 10                	mov    (%rax),%edx
  8007a6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007aa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007ae:	48 89 ce             	mov    %rcx,%rsi
  8007b1:	89 d7                	mov    %edx,%edi
  8007b3:	ff d0                	callq  *%rax
			break;
  8007b5:	e9 53 03 00 00       	jmpq   800b0d <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007ba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007bd:	83 f8 30             	cmp    $0x30,%eax
  8007c0:	73 17                	jae    8007d9 <vprintfmt+0x1e8>
  8007c2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c9:	89 c0                	mov    %eax,%eax
  8007cb:	48 01 d0             	add    %rdx,%rax
  8007ce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007d1:	83 c2 08             	add    $0x8,%edx
  8007d4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007d7:	eb 0f                	jmp    8007e8 <vprintfmt+0x1f7>
  8007d9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007dd:	48 89 d0             	mov    %rdx,%rax
  8007e0:	48 83 c2 08          	add    $0x8,%rdx
  8007e4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007e8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007ea:	85 db                	test   %ebx,%ebx
  8007ec:	79 02                	jns    8007f0 <vprintfmt+0x1ff>
				err = -err;
  8007ee:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007f0:	83 fb 15             	cmp    $0x15,%ebx
  8007f3:	7f 16                	jg     80080b <vprintfmt+0x21a>
  8007f5:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8007fc:	00 00 00 
  8007ff:	48 63 d3             	movslq %ebx,%rdx
  800802:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800806:	4d 85 e4             	test   %r12,%r12
  800809:	75 2e                	jne    800839 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80080b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80080f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800813:	89 d9                	mov    %ebx,%ecx
  800815:	48 ba a1 19 80 00 00 	movabs $0x8019a1,%rdx
  80081c:	00 00 00 
  80081f:	48 89 c7             	mov    %rax,%rdi
  800822:	b8 00 00 00 00       	mov    $0x0,%eax
  800827:	49 b8 1c 0b 80 00 00 	movabs $0x800b1c,%r8
  80082e:	00 00 00 
  800831:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800834:	e9 d4 02 00 00       	jmpq   800b0d <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800839:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80083d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800841:	4c 89 e1             	mov    %r12,%rcx
  800844:	48 ba aa 19 80 00 00 	movabs $0x8019aa,%rdx
  80084b:	00 00 00 
  80084e:	48 89 c7             	mov    %rax,%rdi
  800851:	b8 00 00 00 00       	mov    $0x0,%eax
  800856:	49 b8 1c 0b 80 00 00 	movabs $0x800b1c,%r8
  80085d:	00 00 00 
  800860:	41 ff d0             	callq  *%r8
			break;
  800863:	e9 a5 02 00 00       	jmpq   800b0d <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800868:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086b:	83 f8 30             	cmp    $0x30,%eax
  80086e:	73 17                	jae    800887 <vprintfmt+0x296>
  800870:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800874:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800877:	89 c0                	mov    %eax,%eax
  800879:	48 01 d0             	add    %rdx,%rax
  80087c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80087f:	83 c2 08             	add    $0x8,%edx
  800882:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800885:	eb 0f                	jmp    800896 <vprintfmt+0x2a5>
  800887:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80088b:	48 89 d0             	mov    %rdx,%rax
  80088e:	48 83 c2 08          	add    $0x8,%rdx
  800892:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800896:	4c 8b 20             	mov    (%rax),%r12
  800899:	4d 85 e4             	test   %r12,%r12
  80089c:	75 0a                	jne    8008a8 <vprintfmt+0x2b7>
				p = "(null)";
  80089e:	49 bc ad 19 80 00 00 	movabs $0x8019ad,%r12
  8008a5:	00 00 00 
			if (width > 0 && padc != '-')
  8008a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008ac:	7e 3f                	jle    8008ed <vprintfmt+0x2fc>
  8008ae:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008b2:	74 39                	je     8008ed <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008b7:	48 98                	cltq   
  8008b9:	48 89 c6             	mov    %rax,%rsi
  8008bc:	4c 89 e7             	mov    %r12,%rdi
  8008bf:	48 b8 c8 0d 80 00 00 	movabs $0x800dc8,%rax
  8008c6:	00 00 00 
  8008c9:	ff d0                	callq  *%rax
  8008cb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008ce:	eb 17                	jmp    8008e7 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008d0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008d4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008dc:	48 89 ce             	mov    %rcx,%rsi
  8008df:	89 d7                	mov    %edx,%edi
  8008e1:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008eb:	7f e3                	jg     8008d0 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ed:	eb 37                	jmp    800926 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008f3:	74 1e                	je     800913 <vprintfmt+0x322>
  8008f5:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f8:	7e 05                	jle    8008ff <vprintfmt+0x30e>
  8008fa:	83 fb 7e             	cmp    $0x7e,%ebx
  8008fd:	7e 14                	jle    800913 <vprintfmt+0x322>
					putch('?', putdat);
  8008ff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800903:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800907:	48 89 d6             	mov    %rdx,%rsi
  80090a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80090f:	ff d0                	callq  *%rax
  800911:	eb 0f                	jmp    800922 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800913:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800917:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80091b:	48 89 d6             	mov    %rdx,%rsi
  80091e:	89 df                	mov    %ebx,%edi
  800920:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800922:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800926:	4c 89 e0             	mov    %r12,%rax
  800929:	4c 8d 60 01          	lea    0x1(%rax),%r12
  80092d:	0f b6 00             	movzbl (%rax),%eax
  800930:	0f be d8             	movsbl %al,%ebx
  800933:	85 db                	test   %ebx,%ebx
  800935:	74 10                	je     800947 <vprintfmt+0x356>
  800937:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80093b:	78 b2                	js     8008ef <vprintfmt+0x2fe>
  80093d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800941:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800945:	79 a8                	jns    8008ef <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800947:	eb 16                	jmp    80095f <vprintfmt+0x36e>
				putch(' ', putdat);
  800949:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80094d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800951:	48 89 d6             	mov    %rdx,%rsi
  800954:	bf 20 00 00 00       	mov    $0x20,%edi
  800959:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80095b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80095f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800963:	7f e4                	jg     800949 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800965:	e9 a3 01 00 00       	jmpq   800b0d <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80096a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80096e:	be 03 00 00 00       	mov    $0x3,%esi
  800973:	48 89 c7             	mov    %rax,%rdi
  800976:	48 b8 e1 04 80 00 00 	movabs $0x8004e1,%rax
  80097d:	00 00 00 
  800980:	ff d0                	callq  *%rax
  800982:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800986:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098a:	48 85 c0             	test   %rax,%rax
  80098d:	79 1d                	jns    8009ac <vprintfmt+0x3bb>
				putch('-', putdat);
  80098f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800993:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800997:	48 89 d6             	mov    %rdx,%rsi
  80099a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80099f:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a5:	48 f7 d8             	neg    %rax
  8009a8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009ac:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009b3:	e9 e8 00 00 00       	jmpq   800aa0 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009b8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009bc:	be 03 00 00 00       	mov    $0x3,%esi
  8009c1:	48 89 c7             	mov    %rax,%rdi
  8009c4:	48 b8 d1 03 80 00 00 	movabs $0x8003d1,%rax
  8009cb:	00 00 00 
  8009ce:	ff d0                	callq  *%rax
  8009d0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009d4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009db:	e9 c0 00 00 00       	jmpq   800aa0 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e8:	48 89 d6             	mov    %rdx,%rsi
  8009eb:	bf 58 00 00 00       	mov    $0x58,%edi
  8009f0:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009f2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009fa:	48 89 d6             	mov    %rdx,%rsi
  8009fd:	bf 58 00 00 00       	mov    $0x58,%edi
  800a02:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0c:	48 89 d6             	mov    %rdx,%rsi
  800a0f:	bf 58 00 00 00       	mov    $0x58,%edi
  800a14:	ff d0                	callq  *%rax
			break;
  800a16:	e9 f2 00 00 00       	jmpq   800b0d <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a1b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a1f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a23:	48 89 d6             	mov    %rdx,%rsi
  800a26:	bf 30 00 00 00       	mov    $0x30,%edi
  800a2b:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a35:	48 89 d6             	mov    %rdx,%rsi
  800a38:	bf 78 00 00 00       	mov    $0x78,%edi
  800a3d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a3f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a42:	83 f8 30             	cmp    $0x30,%eax
  800a45:	73 17                	jae    800a5e <vprintfmt+0x46d>
  800a47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a4e:	89 c0                	mov    %eax,%eax
  800a50:	48 01 d0             	add    %rdx,%rax
  800a53:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a56:	83 c2 08             	add    $0x8,%edx
  800a59:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a5c:	eb 0f                	jmp    800a6d <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a5e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a62:	48 89 d0             	mov    %rdx,%rax
  800a65:	48 83 c2 08          	add    $0x8,%rdx
  800a69:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a6d:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a74:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a7b:	eb 23                	jmp    800aa0 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a7d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a81:	be 03 00 00 00       	mov    $0x3,%esi
  800a86:	48 89 c7             	mov    %rax,%rdi
  800a89:	48 b8 d1 03 80 00 00 	movabs $0x8003d1,%rax
  800a90:	00 00 00 
  800a93:	ff d0                	callq  *%rax
  800a95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a99:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa0:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800aa5:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800aa8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800aab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aaf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab7:	45 89 c1             	mov    %r8d,%r9d
  800aba:	41 89 f8             	mov    %edi,%r8d
  800abd:	48 89 c7             	mov    %rax,%rdi
  800ac0:	48 b8 16 03 80 00 00 	movabs $0x800316,%rax
  800ac7:	00 00 00 
  800aca:	ff d0                	callq  *%rax
			break;
  800acc:	eb 3f                	jmp    800b0d <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ace:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ad6:	48 89 d6             	mov    %rdx,%rsi
  800ad9:	89 df                	mov    %ebx,%edi
  800adb:	ff d0                	callq  *%rax
			break;
  800add:	eb 2e                	jmp    800b0d <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800adf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae7:	48 89 d6             	mov    %rdx,%rsi
  800aea:	bf 25 00 00 00       	mov    $0x25,%edi
  800aef:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800af6:	eb 05                	jmp    800afd <vprintfmt+0x50c>
  800af8:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800afd:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b01:	48 83 e8 01          	sub    $0x1,%rax
  800b05:	0f b6 00             	movzbl (%rax),%eax
  800b08:	3c 25                	cmp    $0x25,%al
  800b0a:	75 ec                	jne    800af8 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b0c:	90                   	nop
		}
	}
  800b0d:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b0e:	e9 30 fb ff ff       	jmpq   800643 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b13:	48 83 c4 60          	add    $0x60,%rsp
  800b17:	5b                   	pop    %rbx
  800b18:	41 5c                	pop    %r12
  800b1a:	5d                   	pop    %rbp
  800b1b:	c3                   	retq   

0000000000800b1c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b1c:	55                   	push   %rbp
  800b1d:	48 89 e5             	mov    %rsp,%rbp
  800b20:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b27:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b2e:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b35:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b3c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b43:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b4a:	84 c0                	test   %al,%al
  800b4c:	74 20                	je     800b6e <printfmt+0x52>
  800b4e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b52:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b56:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b5a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b5e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b62:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b66:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b6a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b6e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b75:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b7c:	00 00 00 
  800b7f:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b86:	00 00 00 
  800b89:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b8d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b94:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800b9b:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ba2:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800ba9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bb0:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bb7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bbe:	48 89 c7             	mov    %rax,%rdi
  800bc1:	48 b8 f1 05 80 00 00 	movabs $0x8005f1,%rax
  800bc8:	00 00 00 
  800bcb:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bcd:	c9                   	leaveq 
  800bce:	c3                   	retq   

0000000000800bcf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bcf:	55                   	push   %rbp
  800bd0:	48 89 e5             	mov    %rsp,%rbp
  800bd3:	48 83 ec 10          	sub    $0x10,%rsp
  800bd7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bda:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800bde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800be2:	8b 40 10             	mov    0x10(%rax),%eax
  800be5:	8d 50 01             	lea    0x1(%rax),%edx
  800be8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bec:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf3:	48 8b 10             	mov    (%rax),%rdx
  800bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bfa:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bfe:	48 39 c2             	cmp    %rax,%rdx
  800c01:	73 17                	jae    800c1a <sprintputch+0x4b>
		*b->buf++ = ch;
  800c03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c07:	48 8b 00             	mov    (%rax),%rax
  800c0a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c12:	48 89 0a             	mov    %rcx,(%rdx)
  800c15:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c18:	88 10                	mov    %dl,(%rax)
}
  800c1a:	c9                   	leaveq 
  800c1b:	c3                   	retq   

0000000000800c1c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c1c:	55                   	push   %rbp
  800c1d:	48 89 e5             	mov    %rsp,%rbp
  800c20:	48 83 ec 50          	sub    $0x50,%rsp
  800c24:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c28:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c2b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c2f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c33:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c37:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c3b:	48 8b 0a             	mov    (%rdx),%rcx
  800c3e:	48 89 08             	mov    %rcx,(%rax)
  800c41:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c45:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c49:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c4d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c51:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c55:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c59:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c5c:	48 98                	cltq   
  800c5e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c62:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c66:	48 01 d0             	add    %rdx,%rax
  800c69:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c6d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c74:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c79:	74 06                	je     800c81 <vsnprintf+0x65>
  800c7b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c7f:	7f 07                	jg     800c88 <vsnprintf+0x6c>
		return -E_INVAL;
  800c81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c86:	eb 2f                	jmp    800cb7 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c88:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c8c:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c90:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c94:	48 89 c6             	mov    %rax,%rsi
  800c97:	48 bf cf 0b 80 00 00 	movabs $0x800bcf,%rdi
  800c9e:	00 00 00 
  800ca1:	48 b8 f1 05 80 00 00 	movabs $0x8005f1,%rax
  800ca8:	00 00 00 
  800cab:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cb1:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cb4:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cb7:	c9                   	leaveq 
  800cb8:	c3                   	retq   

0000000000800cb9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cb9:	55                   	push   %rbp
  800cba:	48 89 e5             	mov    %rsp,%rbp
  800cbd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cc4:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ccb:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cd1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cd8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cdf:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ce6:	84 c0                	test   %al,%al
  800ce8:	74 20                	je     800d0a <snprintf+0x51>
  800cea:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cee:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cf2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cf6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cfa:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800cfe:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d02:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d06:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d0a:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d11:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d18:	00 00 00 
  800d1b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d22:	00 00 00 
  800d25:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d29:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d30:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d37:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d3e:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d45:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d4c:	48 8b 0a             	mov    (%rdx),%rcx
  800d4f:	48 89 08             	mov    %rcx,(%rax)
  800d52:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d56:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d5a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d5e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d62:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d69:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d70:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d76:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d7d:	48 89 c7             	mov    %rax,%rdi
  800d80:	48 b8 1c 0c 80 00 00 	movabs $0x800c1c,%rax
  800d87:	00 00 00 
  800d8a:	ff d0                	callq  *%rax
  800d8c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d92:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d98:	c9                   	leaveq 
  800d99:	c3                   	retq   

0000000000800d9a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d9a:	55                   	push   %rbp
  800d9b:	48 89 e5             	mov    %rsp,%rbp
  800d9e:	48 83 ec 18          	sub    $0x18,%rsp
  800da2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800da6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dad:	eb 09                	jmp    800db8 <strlen+0x1e>
		n++;
  800daf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800db3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800db8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dbc:	0f b6 00             	movzbl (%rax),%eax
  800dbf:	84 c0                	test   %al,%al
  800dc1:	75 ec                	jne    800daf <strlen+0x15>
		n++;
	return n;
  800dc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dc6:	c9                   	leaveq 
  800dc7:	c3                   	retq   

0000000000800dc8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dc8:	55                   	push   %rbp
  800dc9:	48 89 e5             	mov    %rsp,%rbp
  800dcc:	48 83 ec 20          	sub    $0x20,%rsp
  800dd0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dd4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ddf:	eb 0e                	jmp    800def <strnlen+0x27>
		n++;
  800de1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de5:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dea:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800def:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800df4:	74 0b                	je     800e01 <strnlen+0x39>
  800df6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dfa:	0f b6 00             	movzbl (%rax),%eax
  800dfd:	84 c0                	test   %al,%al
  800dff:	75 e0                	jne    800de1 <strnlen+0x19>
		n++;
	return n;
  800e01:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e04:	c9                   	leaveq 
  800e05:	c3                   	retq   

0000000000800e06 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e06:	55                   	push   %rbp
  800e07:	48 89 e5             	mov    %rsp,%rbp
  800e0a:	48 83 ec 20          	sub    $0x20,%rsp
  800e0e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e1e:	90                   	nop
  800e1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e23:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e27:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e2b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e2f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e33:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e37:	0f b6 12             	movzbl (%rdx),%edx
  800e3a:	88 10                	mov    %dl,(%rax)
  800e3c:	0f b6 00             	movzbl (%rax),%eax
  800e3f:	84 c0                	test   %al,%al
  800e41:	75 dc                	jne    800e1f <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e47:	c9                   	leaveq 
  800e48:	c3                   	retq   

0000000000800e49 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e49:	55                   	push   %rbp
  800e4a:	48 89 e5             	mov    %rsp,%rbp
  800e4d:	48 83 ec 20          	sub    $0x20,%rsp
  800e51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5d:	48 89 c7             	mov    %rax,%rdi
  800e60:	48 b8 9a 0d 80 00 00 	movabs $0x800d9a,%rax
  800e67:	00 00 00 
  800e6a:	ff d0                	callq  *%rax
  800e6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e72:	48 63 d0             	movslq %eax,%rdx
  800e75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e79:	48 01 c2             	add    %rax,%rdx
  800e7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e80:	48 89 c6             	mov    %rax,%rsi
  800e83:	48 89 d7             	mov    %rdx,%rdi
  800e86:	48 b8 06 0e 80 00 00 	movabs $0x800e06,%rax
  800e8d:	00 00 00 
  800e90:	ff d0                	callq  *%rax
	return dst;
  800e92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e96:	c9                   	leaveq 
  800e97:	c3                   	retq   

0000000000800e98 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e98:	55                   	push   %rbp
  800e99:	48 89 e5             	mov    %rsp,%rbp
  800e9c:	48 83 ec 28          	sub    $0x28,%rsp
  800ea0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ea4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ea8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800eac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800eb4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ebb:	00 
  800ebc:	eb 2a                	jmp    800ee8 <strncpy+0x50>
		*dst++ = *src;
  800ebe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ec6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800eca:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ece:	0f b6 12             	movzbl (%rdx),%edx
  800ed1:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ed7:	0f b6 00             	movzbl (%rax),%eax
  800eda:	84 c0                	test   %al,%al
  800edc:	74 05                	je     800ee3 <strncpy+0x4b>
			src++;
  800ede:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ee3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800ee8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800eec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ef0:	72 cc                	jb     800ebe <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800ef6:	c9                   	leaveq 
  800ef7:	c3                   	retq   

0000000000800ef8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ef8:	55                   	push   %rbp
  800ef9:	48 89 e5             	mov    %rsp,%rbp
  800efc:	48 83 ec 28          	sub    $0x28,%rsp
  800f00:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f04:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f08:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f10:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f14:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f19:	74 3d                	je     800f58 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f1b:	eb 1d                	jmp    800f3a <strlcpy+0x42>
			*dst++ = *src++;
  800f1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f21:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f25:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f29:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f2d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f31:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f35:	0f b6 12             	movzbl (%rdx),%edx
  800f38:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f3a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f3f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f44:	74 0b                	je     800f51 <strlcpy+0x59>
  800f46:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f4a:	0f b6 00             	movzbl (%rax),%eax
  800f4d:	84 c0                	test   %al,%al
  800f4f:	75 cc                	jne    800f1d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f55:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f58:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f60:	48 29 c2             	sub    %rax,%rdx
  800f63:	48 89 d0             	mov    %rdx,%rax
}
  800f66:	c9                   	leaveq 
  800f67:	c3                   	retq   

0000000000800f68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f68:	55                   	push   %rbp
  800f69:	48 89 e5             	mov    %rsp,%rbp
  800f6c:	48 83 ec 10          	sub    $0x10,%rsp
  800f70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f74:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f78:	eb 0a                	jmp    800f84 <strcmp+0x1c>
		p++, q++;
  800f7a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f7f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f88:	0f b6 00             	movzbl (%rax),%eax
  800f8b:	84 c0                	test   %al,%al
  800f8d:	74 12                	je     800fa1 <strcmp+0x39>
  800f8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f93:	0f b6 10             	movzbl (%rax),%edx
  800f96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f9a:	0f b6 00             	movzbl (%rax),%eax
  800f9d:	38 c2                	cmp    %al,%dl
  800f9f:	74 d9                	je     800f7a <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fa5:	0f b6 00             	movzbl (%rax),%eax
  800fa8:	0f b6 d0             	movzbl %al,%edx
  800fab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800faf:	0f b6 00             	movzbl (%rax),%eax
  800fb2:	0f b6 c0             	movzbl %al,%eax
  800fb5:	29 c2                	sub    %eax,%edx
  800fb7:	89 d0                	mov    %edx,%eax
}
  800fb9:	c9                   	leaveq 
  800fba:	c3                   	retq   

0000000000800fbb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fbb:	55                   	push   %rbp
  800fbc:	48 89 e5             	mov    %rsp,%rbp
  800fbf:	48 83 ec 18          	sub    $0x18,%rsp
  800fc3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fc7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fcb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fcf:	eb 0f                	jmp    800fe0 <strncmp+0x25>
		n--, p++, q++;
  800fd1:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fd6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fdb:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fe0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fe5:	74 1d                	je     801004 <strncmp+0x49>
  800fe7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800feb:	0f b6 00             	movzbl (%rax),%eax
  800fee:	84 c0                	test   %al,%al
  800ff0:	74 12                	je     801004 <strncmp+0x49>
  800ff2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff6:	0f b6 10             	movzbl (%rax),%edx
  800ff9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffd:	0f b6 00             	movzbl (%rax),%eax
  801000:	38 c2                	cmp    %al,%dl
  801002:	74 cd                	je     800fd1 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801004:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801009:	75 07                	jne    801012 <strncmp+0x57>
		return 0;
  80100b:	b8 00 00 00 00       	mov    $0x0,%eax
  801010:	eb 18                	jmp    80102a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801012:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801016:	0f b6 00             	movzbl (%rax),%eax
  801019:	0f b6 d0             	movzbl %al,%edx
  80101c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801020:	0f b6 00             	movzbl (%rax),%eax
  801023:	0f b6 c0             	movzbl %al,%eax
  801026:	29 c2                	sub    %eax,%edx
  801028:	89 d0                	mov    %edx,%eax
}
  80102a:	c9                   	leaveq 
  80102b:	c3                   	retq   

000000000080102c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80102c:	55                   	push   %rbp
  80102d:	48 89 e5             	mov    %rsp,%rbp
  801030:	48 83 ec 0c          	sub    $0xc,%rsp
  801034:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801038:	89 f0                	mov    %esi,%eax
  80103a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80103d:	eb 17                	jmp    801056 <strchr+0x2a>
		if (*s == c)
  80103f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801043:	0f b6 00             	movzbl (%rax),%eax
  801046:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801049:	75 06                	jne    801051 <strchr+0x25>
			return (char *) s;
  80104b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104f:	eb 15                	jmp    801066 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801051:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801056:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105a:	0f b6 00             	movzbl (%rax),%eax
  80105d:	84 c0                	test   %al,%al
  80105f:	75 de                	jne    80103f <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801061:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801066:	c9                   	leaveq 
  801067:	c3                   	retq   

0000000000801068 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801068:	55                   	push   %rbp
  801069:	48 89 e5             	mov    %rsp,%rbp
  80106c:	48 83 ec 0c          	sub    $0xc,%rsp
  801070:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801074:	89 f0                	mov    %esi,%eax
  801076:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801079:	eb 13                	jmp    80108e <strfind+0x26>
		if (*s == c)
  80107b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107f:	0f b6 00             	movzbl (%rax),%eax
  801082:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801085:	75 02                	jne    801089 <strfind+0x21>
			break;
  801087:	eb 10                	jmp    801099 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801089:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80108e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801092:	0f b6 00             	movzbl (%rax),%eax
  801095:	84 c0                	test   %al,%al
  801097:	75 e2                	jne    80107b <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801099:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80109d:	c9                   	leaveq 
  80109e:	c3                   	retq   

000000000080109f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80109f:	55                   	push   %rbp
  8010a0:	48 89 e5             	mov    %rsp,%rbp
  8010a3:	48 83 ec 18          	sub    $0x18,%rsp
  8010a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010ab:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010ae:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010b2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010b7:	75 06                	jne    8010bf <memset+0x20>
		return v;
  8010b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bd:	eb 69                	jmp    801128 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c3:	83 e0 03             	and    $0x3,%eax
  8010c6:	48 85 c0             	test   %rax,%rax
  8010c9:	75 48                	jne    801113 <memset+0x74>
  8010cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cf:	83 e0 03             	and    $0x3,%eax
  8010d2:	48 85 c0             	test   %rax,%rax
  8010d5:	75 3c                	jne    801113 <memset+0x74>
		c &= 0xFF;
  8010d7:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e1:	c1 e0 18             	shl    $0x18,%eax
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e9:	c1 e0 10             	shl    $0x10,%eax
  8010ec:	09 c2                	or     %eax,%edx
  8010ee:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f1:	c1 e0 08             	shl    $0x8,%eax
  8010f4:	09 d0                	or     %edx,%eax
  8010f6:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fd:	48 c1 e8 02          	shr    $0x2,%rax
  801101:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801104:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801108:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80110b:	48 89 d7             	mov    %rdx,%rdi
  80110e:	fc                   	cld    
  80110f:	f3 ab                	rep stos %eax,%es:(%rdi)
  801111:	eb 11                	jmp    801124 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801113:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801117:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80111a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80111e:	48 89 d7             	mov    %rdx,%rdi
  801121:	fc                   	cld    
  801122:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801128:	c9                   	leaveq 
  801129:	c3                   	retq   

000000000080112a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80112a:	55                   	push   %rbp
  80112b:	48 89 e5             	mov    %rsp,%rbp
  80112e:	48 83 ec 28          	sub    $0x28,%rsp
  801132:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801136:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80113a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80113e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801142:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801146:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80114e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801152:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801156:	0f 83 88 00 00 00    	jae    8011e4 <memmove+0xba>
  80115c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801160:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801164:	48 01 d0             	add    %rdx,%rax
  801167:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80116b:	76 77                	jbe    8011e4 <memmove+0xba>
		s += n;
  80116d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801171:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801175:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801179:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80117d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801181:	83 e0 03             	and    $0x3,%eax
  801184:	48 85 c0             	test   %rax,%rax
  801187:	75 3b                	jne    8011c4 <memmove+0x9a>
  801189:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80118d:	83 e0 03             	and    $0x3,%eax
  801190:	48 85 c0             	test   %rax,%rax
  801193:	75 2f                	jne    8011c4 <memmove+0x9a>
  801195:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801199:	83 e0 03             	and    $0x3,%eax
  80119c:	48 85 c0             	test   %rax,%rax
  80119f:	75 23                	jne    8011c4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a5:	48 83 e8 04          	sub    $0x4,%rax
  8011a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ad:	48 83 ea 04          	sub    $0x4,%rdx
  8011b1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011b5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011b9:	48 89 c7             	mov    %rax,%rdi
  8011bc:	48 89 d6             	mov    %rdx,%rsi
  8011bf:	fd                   	std    
  8011c0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011c2:	eb 1d                	jmp    8011e1 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d0:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d8:	48 89 d7             	mov    %rdx,%rdi
  8011db:	48 89 c1             	mov    %rax,%rcx
  8011de:	fd                   	std    
  8011df:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011e1:	fc                   	cld    
  8011e2:	eb 57                	jmp    80123b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e8:	83 e0 03             	and    $0x3,%eax
  8011eb:	48 85 c0             	test   %rax,%rax
  8011ee:	75 36                	jne    801226 <memmove+0xfc>
  8011f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f4:	83 e0 03             	and    $0x3,%eax
  8011f7:	48 85 c0             	test   %rax,%rax
  8011fa:	75 2a                	jne    801226 <memmove+0xfc>
  8011fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801200:	83 e0 03             	and    $0x3,%eax
  801203:	48 85 c0             	test   %rax,%rax
  801206:	75 1e                	jne    801226 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801208:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80120c:	48 c1 e8 02          	shr    $0x2,%rax
  801210:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801213:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801217:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80121b:	48 89 c7             	mov    %rax,%rdi
  80121e:	48 89 d6             	mov    %rdx,%rsi
  801221:	fc                   	cld    
  801222:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801224:	eb 15                	jmp    80123b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801226:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80122e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801232:	48 89 c7             	mov    %rax,%rdi
  801235:	48 89 d6             	mov    %rdx,%rsi
  801238:	fc                   	cld    
  801239:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80123b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80123f:	c9                   	leaveq 
  801240:	c3                   	retq   

0000000000801241 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801241:	55                   	push   %rbp
  801242:	48 89 e5             	mov    %rsp,%rbp
  801245:	48 83 ec 18          	sub    $0x18,%rsp
  801249:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80124d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801251:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801255:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801259:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80125d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801261:	48 89 ce             	mov    %rcx,%rsi
  801264:	48 89 c7             	mov    %rax,%rdi
  801267:	48 b8 2a 11 80 00 00 	movabs $0x80112a,%rax
  80126e:	00 00 00 
  801271:	ff d0                	callq  *%rax
}
  801273:	c9                   	leaveq 
  801274:	c3                   	retq   

0000000000801275 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801275:	55                   	push   %rbp
  801276:	48 89 e5             	mov    %rsp,%rbp
  801279:	48 83 ec 28          	sub    $0x28,%rsp
  80127d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801281:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801285:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801289:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80128d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801291:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801295:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801299:	eb 36                	jmp    8012d1 <memcmp+0x5c>
		if (*s1 != *s2)
  80129b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129f:	0f b6 10             	movzbl (%rax),%edx
  8012a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a6:	0f b6 00             	movzbl (%rax),%eax
  8012a9:	38 c2                	cmp    %al,%dl
  8012ab:	74 1a                	je     8012c7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b1:	0f b6 00             	movzbl (%rax),%eax
  8012b4:	0f b6 d0             	movzbl %al,%edx
  8012b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bb:	0f b6 00             	movzbl (%rax),%eax
  8012be:	0f b6 c0             	movzbl %al,%eax
  8012c1:	29 c2                	sub    %eax,%edx
  8012c3:	89 d0                	mov    %edx,%eax
  8012c5:	eb 20                	jmp    8012e7 <memcmp+0x72>
		s1++, s2++;
  8012c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012cc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012dd:	48 85 c0             	test   %rax,%rax
  8012e0:	75 b9                	jne    80129b <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e7:	c9                   	leaveq 
  8012e8:	c3                   	retq   

00000000008012e9 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012e9:	55                   	push   %rbp
  8012ea:	48 89 e5             	mov    %rsp,%rbp
  8012ed:	48 83 ec 28          	sub    $0x28,%rsp
  8012f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012f5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8012fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801300:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801304:	48 01 d0             	add    %rdx,%rax
  801307:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80130b:	eb 15                	jmp    801322 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80130d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801311:	0f b6 10             	movzbl (%rax),%edx
  801314:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801317:	38 c2                	cmp    %al,%dl
  801319:	75 02                	jne    80131d <memfind+0x34>
			break;
  80131b:	eb 0f                	jmp    80132c <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80131d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801322:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801326:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80132a:	72 e1                	jb     80130d <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80132c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801330:	c9                   	leaveq 
  801331:	c3                   	retq   

0000000000801332 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801332:	55                   	push   %rbp
  801333:	48 89 e5             	mov    %rsp,%rbp
  801336:	48 83 ec 34          	sub    $0x34,%rsp
  80133a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80133e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801342:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80134c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801353:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801354:	eb 05                	jmp    80135b <strtol+0x29>
		s++;
  801356:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135f:	0f b6 00             	movzbl (%rax),%eax
  801362:	3c 20                	cmp    $0x20,%al
  801364:	74 f0                	je     801356 <strtol+0x24>
  801366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136a:	0f b6 00             	movzbl (%rax),%eax
  80136d:	3c 09                	cmp    $0x9,%al
  80136f:	74 e5                	je     801356 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801371:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801375:	0f b6 00             	movzbl (%rax),%eax
  801378:	3c 2b                	cmp    $0x2b,%al
  80137a:	75 07                	jne    801383 <strtol+0x51>
		s++;
  80137c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801381:	eb 17                	jmp    80139a <strtol+0x68>
	else if (*s == '-')
  801383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801387:	0f b6 00             	movzbl (%rax),%eax
  80138a:	3c 2d                	cmp    $0x2d,%al
  80138c:	75 0c                	jne    80139a <strtol+0x68>
		s++, neg = 1;
  80138e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801393:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80139a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80139e:	74 06                	je     8013a6 <strtol+0x74>
  8013a0:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013a4:	75 28                	jne    8013ce <strtol+0x9c>
  8013a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013aa:	0f b6 00             	movzbl (%rax),%eax
  8013ad:	3c 30                	cmp    $0x30,%al
  8013af:	75 1d                	jne    8013ce <strtol+0x9c>
  8013b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b5:	48 83 c0 01          	add    $0x1,%rax
  8013b9:	0f b6 00             	movzbl (%rax),%eax
  8013bc:	3c 78                	cmp    $0x78,%al
  8013be:	75 0e                	jne    8013ce <strtol+0x9c>
		s += 2, base = 16;
  8013c0:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013c5:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013cc:	eb 2c                	jmp    8013fa <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013ce:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013d2:	75 19                	jne    8013ed <strtol+0xbb>
  8013d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d8:	0f b6 00             	movzbl (%rax),%eax
  8013db:	3c 30                	cmp    $0x30,%al
  8013dd:	75 0e                	jne    8013ed <strtol+0xbb>
		s++, base = 8;
  8013df:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013e4:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013eb:	eb 0d                	jmp    8013fa <strtol+0xc8>
	else if (base == 0)
  8013ed:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013f1:	75 07                	jne    8013fa <strtol+0xc8>
		base = 10;
  8013f3:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fe:	0f b6 00             	movzbl (%rax),%eax
  801401:	3c 2f                	cmp    $0x2f,%al
  801403:	7e 1d                	jle    801422 <strtol+0xf0>
  801405:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801409:	0f b6 00             	movzbl (%rax),%eax
  80140c:	3c 39                	cmp    $0x39,%al
  80140e:	7f 12                	jg     801422 <strtol+0xf0>
			dig = *s - '0';
  801410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801414:	0f b6 00             	movzbl (%rax),%eax
  801417:	0f be c0             	movsbl %al,%eax
  80141a:	83 e8 30             	sub    $0x30,%eax
  80141d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801420:	eb 4e                	jmp    801470 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801422:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801426:	0f b6 00             	movzbl (%rax),%eax
  801429:	3c 60                	cmp    $0x60,%al
  80142b:	7e 1d                	jle    80144a <strtol+0x118>
  80142d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801431:	0f b6 00             	movzbl (%rax),%eax
  801434:	3c 7a                	cmp    $0x7a,%al
  801436:	7f 12                	jg     80144a <strtol+0x118>
			dig = *s - 'a' + 10;
  801438:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143c:	0f b6 00             	movzbl (%rax),%eax
  80143f:	0f be c0             	movsbl %al,%eax
  801442:	83 e8 57             	sub    $0x57,%eax
  801445:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801448:	eb 26                	jmp    801470 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80144a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144e:	0f b6 00             	movzbl (%rax),%eax
  801451:	3c 40                	cmp    $0x40,%al
  801453:	7e 48                	jle    80149d <strtol+0x16b>
  801455:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801459:	0f b6 00             	movzbl (%rax),%eax
  80145c:	3c 5a                	cmp    $0x5a,%al
  80145e:	7f 3d                	jg     80149d <strtol+0x16b>
			dig = *s - 'A' + 10;
  801460:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801464:	0f b6 00             	movzbl (%rax),%eax
  801467:	0f be c0             	movsbl %al,%eax
  80146a:	83 e8 37             	sub    $0x37,%eax
  80146d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801470:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801473:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801476:	7c 02                	jl     80147a <strtol+0x148>
			break;
  801478:	eb 23                	jmp    80149d <strtol+0x16b>
		s++, val = (val * base) + dig;
  80147a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80147f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801482:	48 98                	cltq   
  801484:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801489:	48 89 c2             	mov    %rax,%rdx
  80148c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80148f:	48 98                	cltq   
  801491:	48 01 d0             	add    %rdx,%rax
  801494:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801498:	e9 5d ff ff ff       	jmpq   8013fa <strtol+0xc8>

	if (endptr)
  80149d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014a2:	74 0b                	je     8014af <strtol+0x17d>
		*endptr = (char *) s;
  8014a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014a8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014ac:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014b3:	74 09                	je     8014be <strtol+0x18c>
  8014b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b9:	48 f7 d8             	neg    %rax
  8014bc:	eb 04                	jmp    8014c2 <strtol+0x190>
  8014be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014c2:	c9                   	leaveq 
  8014c3:	c3                   	retq   

00000000008014c4 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014c4:	55                   	push   %rbp
  8014c5:	48 89 e5             	mov    %rsp,%rbp
  8014c8:	48 83 ec 30          	sub    $0x30,%rsp
  8014cc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014d0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014dc:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014e0:	0f b6 00             	movzbl (%rax),%eax
  8014e3:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014e6:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014ea:	75 06                	jne    8014f2 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	eb 6b                	jmp    80155d <strstr+0x99>

	len = strlen(str);
  8014f2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014f6:	48 89 c7             	mov    %rax,%rdi
  8014f9:	48 b8 9a 0d 80 00 00 	movabs $0x800d9a,%rax
  801500:	00 00 00 
  801503:	ff d0                	callq  *%rax
  801505:	48 98                	cltq   
  801507:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80150b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801513:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801517:	0f b6 00             	movzbl (%rax),%eax
  80151a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80151d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801521:	75 07                	jne    80152a <strstr+0x66>
				return (char *) 0;
  801523:	b8 00 00 00 00       	mov    $0x0,%eax
  801528:	eb 33                	jmp    80155d <strstr+0x99>
		} while (sc != c);
  80152a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80152e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801531:	75 d8                	jne    80150b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801533:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801537:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80153b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153f:	48 89 ce             	mov    %rcx,%rsi
  801542:	48 89 c7             	mov    %rax,%rdi
  801545:	48 b8 bb 0f 80 00 00 	movabs $0x800fbb,%rax
  80154c:	00 00 00 
  80154f:	ff d0                	callq  *%rax
  801551:	85 c0                	test   %eax,%eax
  801553:	75 b6                	jne    80150b <strstr+0x47>

	return (char *) (in - 1);
  801555:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801559:	48 83 e8 01          	sub    $0x1,%rax
}
  80155d:	c9                   	leaveq 
  80155e:	c3                   	retq   

000000000080155f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80155f:	55                   	push   %rbp
  801560:	48 89 e5             	mov    %rsp,%rbp
  801563:	53                   	push   %rbx
  801564:	48 83 ec 48          	sub    $0x48,%rsp
  801568:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80156b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80156e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801572:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801576:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80157a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80157e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801581:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801585:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801589:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80158d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801591:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801595:	4c 89 c3             	mov    %r8,%rbx
  801598:	cd 30                	int    $0x30
  80159a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80159e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015a2:	74 3e                	je     8015e2 <syscall+0x83>
  8015a4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015a9:	7e 37                	jle    8015e2 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015af:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015b2:	49 89 d0             	mov    %rdx,%r8
  8015b5:	89 c1                	mov    %eax,%ecx
  8015b7:	48 ba 68 1c 80 00 00 	movabs $0x801c68,%rdx
  8015be:	00 00 00 
  8015c1:	be 23 00 00 00       	mov    $0x23,%esi
  8015c6:	48 bf 85 1c 80 00 00 	movabs $0x801c85,%rdi
  8015cd:	00 00 00 
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d5:	49 b9 f7 16 80 00 00 	movabs $0x8016f7,%r9
  8015dc:	00 00 00 
  8015df:	41 ff d1             	callq  *%r9

	return ret;
  8015e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015e6:	48 83 c4 48          	add    $0x48,%rsp
  8015ea:	5b                   	pop    %rbx
  8015eb:	5d                   	pop    %rbp
  8015ec:	c3                   	retq   

00000000008015ed <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015ed:	55                   	push   %rbp
  8015ee:	48 89 e5             	mov    %rsp,%rbp
  8015f1:	48 83 ec 20          	sub    $0x20,%rsp
  8015f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015f9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8015fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801601:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801605:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80160c:	00 
  80160d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801613:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801619:	48 89 d1             	mov    %rdx,%rcx
  80161c:	48 89 c2             	mov    %rax,%rdx
  80161f:	be 00 00 00 00       	mov    $0x0,%esi
  801624:	bf 00 00 00 00       	mov    $0x0,%edi
  801629:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  801630:	00 00 00 
  801633:	ff d0                	callq  *%rax
}
  801635:	c9                   	leaveq 
  801636:	c3                   	retq   

0000000000801637 <sys_cgetc>:

int
sys_cgetc(void)
{
  801637:	55                   	push   %rbp
  801638:	48 89 e5             	mov    %rsp,%rbp
  80163b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80163f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801646:	00 
  801647:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80164d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801653:	b9 00 00 00 00       	mov    $0x0,%ecx
  801658:	ba 00 00 00 00       	mov    $0x0,%edx
  80165d:	be 00 00 00 00       	mov    $0x0,%esi
  801662:	bf 01 00 00 00       	mov    $0x1,%edi
  801667:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  80166e:	00 00 00 
  801671:	ff d0                	callq  *%rax
}
  801673:	c9                   	leaveq 
  801674:	c3                   	retq   

0000000000801675 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801675:	55                   	push   %rbp
  801676:	48 89 e5             	mov    %rsp,%rbp
  801679:	48 83 ec 10          	sub    $0x10,%rsp
  80167d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801680:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801683:	48 98                	cltq   
  801685:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80168c:	00 
  80168d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801693:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801699:	b9 00 00 00 00       	mov    $0x0,%ecx
  80169e:	48 89 c2             	mov    %rax,%rdx
  8016a1:	be 01 00 00 00       	mov    $0x1,%esi
  8016a6:	bf 03 00 00 00       	mov    $0x3,%edi
  8016ab:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  8016b2:	00 00 00 
  8016b5:	ff d0                	callq  *%rax
}
  8016b7:	c9                   	leaveq 
  8016b8:	c3                   	retq   

00000000008016b9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016b9:	55                   	push   %rbp
  8016ba:	48 89 e5             	mov    %rsp,%rbp
  8016bd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016c8:	00 
  8016c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016da:	ba 00 00 00 00       	mov    $0x0,%edx
  8016df:	be 00 00 00 00       	mov    $0x0,%esi
  8016e4:	bf 02 00 00 00       	mov    $0x2,%edi
  8016e9:	48 b8 5f 15 80 00 00 	movabs $0x80155f,%rax
  8016f0:	00 00 00 
  8016f3:	ff d0                	callq  *%rax
}
  8016f5:	c9                   	leaveq 
  8016f6:	c3                   	retq   

00000000008016f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8016f7:	55                   	push   %rbp
  8016f8:	48 89 e5             	mov    %rsp,%rbp
  8016fb:	53                   	push   %rbx
  8016fc:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801703:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80170a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801710:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801717:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80171e:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801725:	84 c0                	test   %al,%al
  801727:	74 23                	je     80174c <_panic+0x55>
  801729:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801730:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801734:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  801738:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80173c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801740:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801744:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  801748:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80174c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801753:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80175a:	00 00 00 
  80175d:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801764:	00 00 00 
  801767:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80176b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801772:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  801779:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801780:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  801787:	00 00 00 
  80178a:	48 8b 18             	mov    (%rax),%rbx
  80178d:	48 b8 b9 16 80 00 00 	movabs $0x8016b9,%rax
  801794:	00 00 00 
  801797:	ff d0                	callq  *%rax
  801799:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80179f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8017a6:	41 89 c8             	mov    %ecx,%r8d
  8017a9:	48 89 d1             	mov    %rdx,%rcx
  8017ac:	48 89 da             	mov    %rbx,%rdx
  8017af:	89 c6                	mov    %eax,%esi
  8017b1:	48 bf 98 1c 80 00 00 	movabs $0x801c98,%rdi
  8017b8:	00 00 00 
  8017bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c0:	49 b9 3e 02 80 00 00 	movabs $0x80023e,%r9
  8017c7:	00 00 00 
  8017ca:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017cd:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8017d4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8017db:	48 89 d6             	mov    %rdx,%rsi
  8017de:	48 89 c7             	mov    %rax,%rdi
  8017e1:	48 b8 92 01 80 00 00 	movabs $0x800192,%rax
  8017e8:	00 00 00 
  8017eb:	ff d0                	callq  *%rax
	cprintf("\n");
  8017ed:	48 bf bb 1c 80 00 00 	movabs $0x801cbb,%rdi
  8017f4:	00 00 00 
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fc:	48 ba 3e 02 80 00 00 	movabs $0x80023e,%rdx
  801803:	00 00 00 
  801806:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801808:	cc                   	int3   
  801809:	eb fd                	jmp    801808 <_panic+0x111>
