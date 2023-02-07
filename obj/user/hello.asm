
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
  800052:	48 bf 20 35 80 00 00 	movabs $0x803520,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	cprintf("i am environment %08x\n", thisenv->env_id);
  80006d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800074:	00 00 00 
  800077:	48 8b 00             	mov    (%rax),%rax
  80007a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800080:	89 c6                	mov    %eax,%esi
  800082:	48 bf 2e 35 80 00 00 	movabs $0x80352e,%rdi
  800089:	00 00 00 
  80008c:	b8 00 00 00 00       	mov    $0x0,%eax
  800091:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
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
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  8000ae:	48 b8 df 16 80 00 00 	movabs $0x8016df,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
  8000ba:	48 98                	cltq   
  8000bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000c1:	48 89 c2             	mov    %rax,%rdx
  8000c4:	48 89 d0             	mov    %rdx,%rax
  8000c7:	48 c1 e0 03          	shl    $0x3,%rax
  8000cb:	48 01 d0             	add    %rdx,%rax
  8000ce:	48 c1 e0 05          	shl    $0x5,%rax
  8000d2:	48 89 c2             	mov    %rax,%rdx
  8000d5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000dc:	00 00 00 
  8000df:	48 01 c2             	add    %rax,%rdx
  8000e2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000e9:	00 00 00 
  8000ec:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f3:	7e 14                	jle    800109 <libmain+0x6a>
		binaryname = argv[0];
  8000f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000f9:	48 8b 10             	mov    (%rax),%rdx
  8000fc:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800103:	00 00 00 
  800106:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800109:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80010d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800110:	48 89 d6             	mov    %rdx,%rsi
  800113:	89 c7                	mov    %eax,%edi
  800115:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800121:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  800128:	00 00 00 
  80012b:	ff d0                	callq  *%rax
}
  80012d:	c9                   	leaveq 
  80012e:	c3                   	retq   

000000000080012f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800133:	48 b8 09 1d 80 00 00 	movabs $0x801d09,%rax
  80013a:	00 00 00 
  80013d:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80013f:	bf 00 00 00 00       	mov    $0x0,%edi
  800144:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
}
  800150:	5d                   	pop    %rbp
  800151:	c3                   	retq   

0000000000800152 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800152:	55                   	push   %rbp
  800153:	48 89 e5             	mov    %rsp,%rbp
  800156:	48 83 ec 10          	sub    $0x10,%rsp
  80015a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800161:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800165:	8b 00                	mov    (%rax),%eax
  800167:	8d 48 01             	lea    0x1(%rax),%ecx
  80016a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80016e:	89 0a                	mov    %ecx,(%rdx)
  800170:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800173:	89 d1                	mov    %edx,%ecx
  800175:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800179:	48 98                	cltq   
  80017b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80017f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800183:	8b 00                	mov    (%rax),%eax
  800185:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018a:	75 2c                	jne    8001b8 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80018c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800190:	8b 00                	mov    (%rax),%eax
  800192:	48 98                	cltq   
  800194:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800198:	48 83 c2 08          	add    $0x8,%rdx
  80019c:	48 89 c6             	mov    %rax,%rsi
  80019f:	48 89 d7             	mov    %rdx,%rdi
  8001a2:	48 b8 13 16 80 00 00 	movabs $0x801613,%rax
  8001a9:	00 00 00 
  8001ac:	ff d0                	callq  *%rax
        b->idx = 0;
  8001ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bc:	8b 40 04             	mov    0x4(%rax),%eax
  8001bf:	8d 50 01             	lea    0x1(%rax),%edx
  8001c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c6:	89 50 04             	mov    %edx,0x4(%rax)
}
  8001c9:	c9                   	leaveq 
  8001ca:	c3                   	retq   

00000000008001cb <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8001cb:	55                   	push   %rbp
  8001cc:	48 89 e5             	mov    %rsp,%rbp
  8001cf:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001d6:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001dd:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001e4:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001eb:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001f2:	48 8b 0a             	mov    (%rdx),%rcx
  8001f5:	48 89 08             	mov    %rcx,(%rax)
  8001f8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001fc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800200:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800204:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800208:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80020f:	00 00 00 
    b.cnt = 0;
  800212:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800219:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80021c:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800223:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80022a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800231:	48 89 c6             	mov    %rax,%rsi
  800234:	48 bf 52 01 80 00 00 	movabs $0x800152,%rdi
  80023b:	00 00 00 
  80023e:	48 b8 2a 06 80 00 00 	movabs $0x80062a,%rax
  800245:	00 00 00 
  800248:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80024a:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800250:	48 98                	cltq   
  800252:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800259:	48 83 c2 08          	add    $0x8,%rdx
  80025d:	48 89 c6             	mov    %rax,%rsi
  800260:	48 89 d7             	mov    %rdx,%rdi
  800263:	48 b8 13 16 80 00 00 	movabs $0x801613,%rax
  80026a:	00 00 00 
  80026d:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80026f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800275:	c9                   	leaveq 
  800276:	c3                   	retq   

0000000000800277 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800277:	55                   	push   %rbp
  800278:	48 89 e5             	mov    %rsp,%rbp
  80027b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800282:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800289:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800290:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800297:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80029e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002a5:	84 c0                	test   %al,%al
  8002a7:	74 20                	je     8002c9 <cprintf+0x52>
  8002a9:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002ad:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002b1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002b5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002b9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002bd:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002c1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8002c5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8002c9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8002d0:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002d7:	00 00 00 
  8002da:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002e1:	00 00 00 
  8002e4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002e8:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002ef:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002f6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002fd:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800304:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80030b:	48 8b 0a             	mov    (%rdx),%rcx
  80030e:	48 89 08             	mov    %rcx,(%rax)
  800311:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800315:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800319:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80031d:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800321:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800328:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80032f:	48 89 d6             	mov    %rdx,%rsi
  800332:	48 89 c7             	mov    %rax,%rdi
  800335:	48 b8 cb 01 80 00 00 	movabs $0x8001cb,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
  800341:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800347:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80034d:	c9                   	leaveq 
  80034e:	c3                   	retq   

000000000080034f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034f:	55                   	push   %rbp
  800350:	48 89 e5             	mov    %rsp,%rbp
  800353:	53                   	push   %rbx
  800354:	48 83 ec 38          	sub    $0x38,%rsp
  800358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80035c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800360:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800364:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800367:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80036b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80036f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800372:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800376:	77 3b                	ja     8003b3 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800378:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80037b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80037f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800382:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800386:	ba 00 00 00 00       	mov    $0x0,%edx
  80038b:	48 f7 f3             	div    %rbx
  80038e:	48 89 c2             	mov    %rax,%rdx
  800391:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800394:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800397:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80039b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80039f:	41 89 f9             	mov    %edi,%r9d
  8003a2:	48 89 c7             	mov    %rax,%rdi
  8003a5:	48 b8 4f 03 80 00 00 	movabs $0x80034f,%rax
  8003ac:	00 00 00 
  8003af:	ff d0                	callq  *%rax
  8003b1:	eb 1e                	jmp    8003d1 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b3:	eb 12                	jmp    8003c7 <printnum+0x78>
			putch(padc, putdat);
  8003b5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003b9:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c0:	48 89 ce             	mov    %rcx,%rsi
  8003c3:	89 d7                	mov    %edx,%edi
  8003c5:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c7:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8003cb:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8003cf:	7f e4                	jg     8003b5 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	48 f7 f1             	div    %rcx
  8003e0:	48 89 d0             	mov    %rdx,%rax
  8003e3:	48 ba 50 37 80 00 00 	movabs $0x803750,%rdx
  8003ea:	00 00 00 
  8003ed:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003f1:	0f be d0             	movsbl %al,%edx
  8003f4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fc:	48 89 ce             	mov    %rcx,%rsi
  8003ff:	89 d7                	mov    %edx,%edi
  800401:	ff d0                	callq  *%rax
}
  800403:	48 83 c4 38          	add    $0x38,%rsp
  800407:	5b                   	pop    %rbx
  800408:	5d                   	pop    %rbp
  800409:	c3                   	retq   

000000000080040a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80040a:	55                   	push   %rbp
  80040b:	48 89 e5             	mov    %rsp,%rbp
  80040e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800412:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800416:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800419:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80041d:	7e 52                	jle    800471 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80041f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800423:	8b 00                	mov    (%rax),%eax
  800425:	83 f8 30             	cmp    $0x30,%eax
  800428:	73 24                	jae    80044e <getuint+0x44>
  80042a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80042e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800432:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800436:	8b 00                	mov    (%rax),%eax
  800438:	89 c0                	mov    %eax,%eax
  80043a:	48 01 d0             	add    %rdx,%rax
  80043d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800441:	8b 12                	mov    (%rdx),%edx
  800443:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800446:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80044a:	89 0a                	mov    %ecx,(%rdx)
  80044c:	eb 17                	jmp    800465 <getuint+0x5b>
  80044e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800452:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800456:	48 89 d0             	mov    %rdx,%rax
  800459:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80045d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800461:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800465:	48 8b 00             	mov    (%rax),%rax
  800468:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80046c:	e9 a3 00 00 00       	jmpq   800514 <getuint+0x10a>
	else if (lflag)
  800471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800475:	74 4f                	je     8004c6 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047b:	8b 00                	mov    (%rax),%eax
  80047d:	83 f8 30             	cmp    $0x30,%eax
  800480:	73 24                	jae    8004a6 <getuint+0x9c>
  800482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800486:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80048a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048e:	8b 00                	mov    (%rax),%eax
  800490:	89 c0                	mov    %eax,%eax
  800492:	48 01 d0             	add    %rdx,%rax
  800495:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800499:	8b 12                	mov    (%rdx),%edx
  80049b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80049e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a2:	89 0a                	mov    %ecx,(%rdx)
  8004a4:	eb 17                	jmp    8004bd <getuint+0xb3>
  8004a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004aa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004ae:	48 89 d0             	mov    %rdx,%rax
  8004b1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004bd:	48 8b 00             	mov    (%rax),%rax
  8004c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004c4:	eb 4e                	jmp    800514 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8004c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ca:	8b 00                	mov    (%rax),%eax
  8004cc:	83 f8 30             	cmp    $0x30,%eax
  8004cf:	73 24                	jae    8004f5 <getuint+0xeb>
  8004d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004dd:	8b 00                	mov    (%rax),%eax
  8004df:	89 c0                	mov    %eax,%eax
  8004e1:	48 01 d0             	add    %rdx,%rax
  8004e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e8:	8b 12                	mov    (%rdx),%edx
  8004ea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f1:	89 0a                	mov    %ecx,(%rdx)
  8004f3:	eb 17                	jmp    80050c <getuint+0x102>
  8004f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004fd:	48 89 d0             	mov    %rdx,%rax
  800500:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800504:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800508:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80050c:	8b 00                	mov    (%rax),%eax
  80050e:	89 c0                	mov    %eax,%eax
  800510:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800518:	c9                   	leaveq 
  800519:	c3                   	retq   

000000000080051a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80051a:	55                   	push   %rbp
  80051b:	48 89 e5             	mov    %rsp,%rbp
  80051e:	48 83 ec 1c          	sub    $0x1c,%rsp
  800522:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800526:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800529:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80052d:	7e 52                	jle    800581 <getint+0x67>
		x=va_arg(*ap, long long);
  80052f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800533:	8b 00                	mov    (%rax),%eax
  800535:	83 f8 30             	cmp    $0x30,%eax
  800538:	73 24                	jae    80055e <getint+0x44>
  80053a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800546:	8b 00                	mov    (%rax),%eax
  800548:	89 c0                	mov    %eax,%eax
  80054a:	48 01 d0             	add    %rdx,%rax
  80054d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800551:	8b 12                	mov    (%rdx),%edx
  800553:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800556:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055a:	89 0a                	mov    %ecx,(%rdx)
  80055c:	eb 17                	jmp    800575 <getint+0x5b>
  80055e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800562:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800566:	48 89 d0             	mov    %rdx,%rax
  800569:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80056d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800571:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800575:	48 8b 00             	mov    (%rax),%rax
  800578:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80057c:	e9 a3 00 00 00       	jmpq   800624 <getint+0x10a>
	else if (lflag)
  800581:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800585:	74 4f                	je     8005d6 <getint+0xbc>
		x=va_arg(*ap, long);
  800587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058b:	8b 00                	mov    (%rax),%eax
  80058d:	83 f8 30             	cmp    $0x30,%eax
  800590:	73 24                	jae    8005b6 <getint+0x9c>
  800592:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800596:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059e:	8b 00                	mov    (%rax),%eax
  8005a0:	89 c0                	mov    %eax,%eax
  8005a2:	48 01 d0             	add    %rdx,%rax
  8005a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a9:	8b 12                	mov    (%rdx),%edx
  8005ab:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b2:	89 0a                	mov    %ecx,(%rdx)
  8005b4:	eb 17                	jmp    8005cd <getint+0xb3>
  8005b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ba:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005be:	48 89 d0             	mov    %rdx,%rax
  8005c1:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005cd:	48 8b 00             	mov    (%rax),%rax
  8005d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005d4:	eb 4e                	jmp    800624 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005da:	8b 00                	mov    (%rax),%eax
  8005dc:	83 f8 30             	cmp    $0x30,%eax
  8005df:	73 24                	jae    800605 <getint+0xeb>
  8005e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ed:	8b 00                	mov    (%rax),%eax
  8005ef:	89 c0                	mov    %eax,%eax
  8005f1:	48 01 d0             	add    %rdx,%rax
  8005f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f8:	8b 12                	mov    (%rdx),%edx
  8005fa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800601:	89 0a                	mov    %ecx,(%rdx)
  800603:	eb 17                	jmp    80061c <getint+0x102>
  800605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800609:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060d:	48 89 d0             	mov    %rdx,%rax
  800610:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800614:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800618:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061c:	8b 00                	mov    (%rax),%eax
  80061e:	48 98                	cltq   
  800620:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800628:	c9                   	leaveq 
  800629:	c3                   	retq   

000000000080062a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80062a:	55                   	push   %rbp
  80062b:	48 89 e5             	mov    %rsp,%rbp
  80062e:	41 54                	push   %r12
  800630:	53                   	push   %rbx
  800631:	48 83 ec 60          	sub    $0x60,%rsp
  800635:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800639:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80063d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800641:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800645:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800649:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80064d:	48 8b 0a             	mov    (%rdx),%rcx
  800650:	48 89 08             	mov    %rcx,(%rax)
  800653:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800657:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80065b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80065f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800663:	eb 17                	jmp    80067c <vprintfmt+0x52>
			if (ch == '\0')
  800665:	85 db                	test   %ebx,%ebx
  800667:	0f 84 cc 04 00 00    	je     800b39 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80066d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800671:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800675:	48 89 d6             	mov    %rdx,%rsi
  800678:	89 df                	mov    %ebx,%edi
  80067a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80067c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800680:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800684:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800688:	0f b6 00             	movzbl (%rax),%eax
  80068b:	0f b6 d8             	movzbl %al,%ebx
  80068e:	83 fb 25             	cmp    $0x25,%ebx
  800691:	75 d2                	jne    800665 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800693:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800697:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80069e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006ac:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006b7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006bb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006bf:	0f b6 00             	movzbl (%rax),%eax
  8006c2:	0f b6 d8             	movzbl %al,%ebx
  8006c5:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8006c8:	83 f8 55             	cmp    $0x55,%eax
  8006cb:	0f 87 34 04 00 00    	ja     800b05 <vprintfmt+0x4db>
  8006d1:	89 c0                	mov    %eax,%eax
  8006d3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006da:	00 
  8006db:	48 b8 78 37 80 00 00 	movabs $0x803778,%rax
  8006e2:	00 00 00 
  8006e5:	48 01 d0             	add    %rdx,%rax
  8006e8:	48 8b 00             	mov    (%rax),%rax
  8006eb:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006ed:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006f1:	eb c0                	jmp    8006b3 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006f3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006f7:	eb ba                	jmp    8006b3 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800700:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800703:	89 d0                	mov    %edx,%eax
  800705:	c1 e0 02             	shl    $0x2,%eax
  800708:	01 d0                	add    %edx,%eax
  80070a:	01 c0                	add    %eax,%eax
  80070c:	01 d8                	add    %ebx,%eax
  80070e:	83 e8 30             	sub    $0x30,%eax
  800711:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800714:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800718:	0f b6 00             	movzbl (%rax),%eax
  80071b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80071e:	83 fb 2f             	cmp    $0x2f,%ebx
  800721:	7e 0c                	jle    80072f <vprintfmt+0x105>
  800723:	83 fb 39             	cmp    $0x39,%ebx
  800726:	7f 07                	jg     80072f <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800728:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80072d:	eb d1                	jmp    800700 <vprintfmt+0xd6>
			goto process_precision;
  80072f:	eb 58                	jmp    800789 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800731:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800734:	83 f8 30             	cmp    $0x30,%eax
  800737:	73 17                	jae    800750 <vprintfmt+0x126>
  800739:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80073d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800740:	89 c0                	mov    %eax,%eax
  800742:	48 01 d0             	add    %rdx,%rax
  800745:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800748:	83 c2 08             	add    $0x8,%edx
  80074b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80074e:	eb 0f                	jmp    80075f <vprintfmt+0x135>
  800750:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800754:	48 89 d0             	mov    %rdx,%rax
  800757:	48 83 c2 08          	add    $0x8,%rdx
  80075b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80075f:	8b 00                	mov    (%rax),%eax
  800761:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800764:	eb 23                	jmp    800789 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800766:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80076a:	79 0c                	jns    800778 <vprintfmt+0x14e>
				width = 0;
  80076c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800773:	e9 3b ff ff ff       	jmpq   8006b3 <vprintfmt+0x89>
  800778:	e9 36 ff ff ff       	jmpq   8006b3 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80077d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800784:	e9 2a ff ff ff       	jmpq   8006b3 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800789:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80078d:	79 12                	jns    8007a1 <vprintfmt+0x177>
				width = precision, precision = -1;
  80078f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800792:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800795:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80079c:	e9 12 ff ff ff       	jmpq   8006b3 <vprintfmt+0x89>
  8007a1:	e9 0d ff ff ff       	jmpq   8006b3 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007a6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007aa:	e9 04 ff ff ff       	jmpq   8006b3 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007af:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b2:	83 f8 30             	cmp    $0x30,%eax
  8007b5:	73 17                	jae    8007ce <vprintfmt+0x1a4>
  8007b7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007bb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007be:	89 c0                	mov    %eax,%eax
  8007c0:	48 01 d0             	add    %rdx,%rax
  8007c3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c6:	83 c2 08             	add    $0x8,%edx
  8007c9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007cc:	eb 0f                	jmp    8007dd <vprintfmt+0x1b3>
  8007ce:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d2:	48 89 d0             	mov    %rdx,%rax
  8007d5:	48 83 c2 08          	add    $0x8,%rdx
  8007d9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007dd:	8b 10                	mov    (%rax),%edx
  8007df:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007e3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007e7:	48 89 ce             	mov    %rcx,%rsi
  8007ea:	89 d7                	mov    %edx,%edi
  8007ec:	ff d0                	callq  *%rax
			break;
  8007ee:	e9 40 03 00 00       	jmpq   800b33 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007f3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f6:	83 f8 30             	cmp    $0x30,%eax
  8007f9:	73 17                	jae    800812 <vprintfmt+0x1e8>
  8007fb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800802:	89 c0                	mov    %eax,%eax
  800804:	48 01 d0             	add    %rdx,%rax
  800807:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80080a:	83 c2 08             	add    $0x8,%edx
  80080d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800810:	eb 0f                	jmp    800821 <vprintfmt+0x1f7>
  800812:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800816:	48 89 d0             	mov    %rdx,%rax
  800819:	48 83 c2 08          	add    $0x8,%rdx
  80081d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800821:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800823:	85 db                	test   %ebx,%ebx
  800825:	79 02                	jns    800829 <vprintfmt+0x1ff>
				err = -err;
  800827:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800829:	83 fb 15             	cmp    $0x15,%ebx
  80082c:	7f 16                	jg     800844 <vprintfmt+0x21a>
  80082e:	48 b8 a0 36 80 00 00 	movabs $0x8036a0,%rax
  800835:	00 00 00 
  800838:	48 63 d3             	movslq %ebx,%rdx
  80083b:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80083f:	4d 85 e4             	test   %r12,%r12
  800842:	75 2e                	jne    800872 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800844:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800848:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80084c:	89 d9                	mov    %ebx,%ecx
  80084e:	48 ba 61 37 80 00 00 	movabs $0x803761,%rdx
  800855:	00 00 00 
  800858:	48 89 c7             	mov    %rax,%rdi
  80085b:	b8 00 00 00 00       	mov    $0x0,%eax
  800860:	49 b8 42 0b 80 00 00 	movabs $0x800b42,%r8
  800867:	00 00 00 
  80086a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086d:	e9 c1 02 00 00       	jmpq   800b33 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800872:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800876:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80087a:	4c 89 e1             	mov    %r12,%rcx
  80087d:	48 ba 6a 37 80 00 00 	movabs $0x80376a,%rdx
  800884:	00 00 00 
  800887:	48 89 c7             	mov    %rax,%rdi
  80088a:	b8 00 00 00 00       	mov    $0x0,%eax
  80088f:	49 b8 42 0b 80 00 00 	movabs $0x800b42,%r8
  800896:	00 00 00 
  800899:	41 ff d0             	callq  *%r8
			break;
  80089c:	e9 92 02 00 00       	jmpq   800b33 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008a1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a4:	83 f8 30             	cmp    $0x30,%eax
  8008a7:	73 17                	jae    8008c0 <vprintfmt+0x296>
  8008a9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008ad:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b0:	89 c0                	mov    %eax,%eax
  8008b2:	48 01 d0             	add    %rdx,%rax
  8008b5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008b8:	83 c2 08             	add    $0x8,%edx
  8008bb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008be:	eb 0f                	jmp    8008cf <vprintfmt+0x2a5>
  8008c0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c4:	48 89 d0             	mov    %rdx,%rax
  8008c7:	48 83 c2 08          	add    $0x8,%rdx
  8008cb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008cf:	4c 8b 20             	mov    (%rax),%r12
  8008d2:	4d 85 e4             	test   %r12,%r12
  8008d5:	75 0a                	jne    8008e1 <vprintfmt+0x2b7>
				p = "(null)";
  8008d7:	49 bc 6d 37 80 00 00 	movabs $0x80376d,%r12
  8008de:	00 00 00 
			if (width > 0 && padc != '-')
  8008e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e5:	7e 3f                	jle    800926 <vprintfmt+0x2fc>
  8008e7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008eb:	74 39                	je     800926 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ed:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008f0:	48 98                	cltq   
  8008f2:	48 89 c6             	mov    %rax,%rsi
  8008f5:	4c 89 e7             	mov    %r12,%rdi
  8008f8:	48 b8 ee 0d 80 00 00 	movabs $0x800dee,%rax
  8008ff:	00 00 00 
  800902:	ff d0                	callq  *%rax
  800904:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800907:	eb 17                	jmp    800920 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800909:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80090d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800911:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800915:	48 89 ce             	mov    %rcx,%rsi
  800918:	89 d7                	mov    %edx,%edi
  80091a:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800920:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800924:	7f e3                	jg     800909 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	eb 37                	jmp    80095f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800928:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80092c:	74 1e                	je     80094c <vprintfmt+0x322>
  80092e:	83 fb 1f             	cmp    $0x1f,%ebx
  800931:	7e 05                	jle    800938 <vprintfmt+0x30e>
  800933:	83 fb 7e             	cmp    $0x7e,%ebx
  800936:	7e 14                	jle    80094c <vprintfmt+0x322>
					putch('?', putdat);
  800938:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80093c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800940:	48 89 d6             	mov    %rdx,%rsi
  800943:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800948:	ff d0                	callq  *%rax
  80094a:	eb 0f                	jmp    80095b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80094c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800950:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800954:	48 89 d6             	mov    %rdx,%rsi
  800957:	89 df                	mov    %ebx,%edi
  800959:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80095f:	4c 89 e0             	mov    %r12,%rax
  800962:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800966:	0f b6 00             	movzbl (%rax),%eax
  800969:	0f be d8             	movsbl %al,%ebx
  80096c:	85 db                	test   %ebx,%ebx
  80096e:	74 10                	je     800980 <vprintfmt+0x356>
  800970:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800974:	78 b2                	js     800928 <vprintfmt+0x2fe>
  800976:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80097a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80097e:	79 a8                	jns    800928 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800980:	eb 16                	jmp    800998 <vprintfmt+0x36e>
				putch(' ', putdat);
  800982:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800986:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80098a:	48 89 d6             	mov    %rdx,%rsi
  80098d:	bf 20 00 00 00       	mov    $0x20,%edi
  800992:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800994:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800998:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099c:	7f e4                	jg     800982 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80099e:	e9 90 01 00 00       	jmpq   800b33 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009a3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009a7:	be 03 00 00 00       	mov    $0x3,%esi
  8009ac:	48 89 c7             	mov    %rax,%rdi
  8009af:	48 b8 1a 05 80 00 00 	movabs $0x80051a,%rax
  8009b6:	00 00 00 
  8009b9:	ff d0                	callq  *%rax
  8009bb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c3:	48 85 c0             	test   %rax,%rax
  8009c6:	79 1d                	jns    8009e5 <vprintfmt+0x3bb>
				putch('-', putdat);
  8009c8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009cc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d0:	48 89 d6             	mov    %rdx,%rsi
  8009d3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009d8:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009de:	48 f7 d8             	neg    %rax
  8009e1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009e5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009ec:	e9 d5 00 00 00       	jmpq   800ac6 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009f1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009f5:	be 03 00 00 00       	mov    $0x3,%esi
  8009fa:	48 89 c7             	mov    %rax,%rdi
  8009fd:	48 b8 0a 04 80 00 00 	movabs $0x80040a,%rax
  800a04:	00 00 00 
  800a07:	ff d0                	callq  *%rax
  800a09:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a0d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a14:	e9 ad 00 00 00       	jmpq   800ac6 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800a19:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a1d:	be 03 00 00 00       	mov    $0x3,%esi
  800a22:	48 89 c7             	mov    %rax,%rdi
  800a25:	48 b8 0a 04 80 00 00 	movabs $0x80040a,%rax
  800a2c:	00 00 00 
  800a2f:	ff d0                	callq  *%rax
  800a31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800a35:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800a3c:	e9 85 00 00 00       	jmpq   800ac6 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a41:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a49:	48 89 d6             	mov    %rdx,%rsi
  800a4c:	bf 30 00 00 00       	mov    $0x30,%edi
  800a51:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a53:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a57:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5b:	48 89 d6             	mov    %rdx,%rsi
  800a5e:	bf 78 00 00 00       	mov    $0x78,%edi
  800a63:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a68:	83 f8 30             	cmp    $0x30,%eax
  800a6b:	73 17                	jae    800a84 <vprintfmt+0x45a>
  800a6d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a71:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a74:	89 c0                	mov    %eax,%eax
  800a76:	48 01 d0             	add    %rdx,%rax
  800a79:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a7c:	83 c2 08             	add    $0x8,%edx
  800a7f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a82:	eb 0f                	jmp    800a93 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800a84:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a88:	48 89 d0             	mov    %rdx,%rax
  800a8b:	48 83 c2 08          	add    $0x8,%rdx
  800a8f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a93:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a96:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a9a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800aa1:	eb 23                	jmp    800ac6 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800aa3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aa7:	be 03 00 00 00       	mov    $0x3,%esi
  800aac:	48 89 c7             	mov    %rax,%rdi
  800aaf:	48 b8 0a 04 80 00 00 	movabs $0x80040a,%rax
  800ab6:	00 00 00 
  800ab9:	ff d0                	callq  *%rax
  800abb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800abf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac6:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800acb:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ace:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ad1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad5:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ad9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800add:	45 89 c1             	mov    %r8d,%r9d
  800ae0:	41 89 f8             	mov    %edi,%r8d
  800ae3:	48 89 c7             	mov    %rax,%rdi
  800ae6:	48 b8 4f 03 80 00 00 	movabs $0x80034f,%rax
  800aed:	00 00 00 
  800af0:	ff d0                	callq  *%rax
			break;
  800af2:	eb 3f                	jmp    800b33 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800af4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800afc:	48 89 d6             	mov    %rdx,%rsi
  800aff:	89 df                	mov    %ebx,%edi
  800b01:	ff d0                	callq  *%rax
			break;
  800b03:	eb 2e                	jmp    800b33 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b05:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b09:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0d:	48 89 d6             	mov    %rdx,%rsi
  800b10:	bf 25 00 00 00       	mov    $0x25,%edi
  800b15:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b17:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b1c:	eb 05                	jmp    800b23 <vprintfmt+0x4f9>
  800b1e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b23:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b27:	48 83 e8 01          	sub    $0x1,%rax
  800b2b:	0f b6 00             	movzbl (%rax),%eax
  800b2e:	3c 25                	cmp    $0x25,%al
  800b30:	75 ec                	jne    800b1e <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b32:	90                   	nop
		}
	}
  800b33:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b34:	e9 43 fb ff ff       	jmpq   80067c <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b39:	48 83 c4 60          	add    $0x60,%rsp
  800b3d:	5b                   	pop    %rbx
  800b3e:	41 5c                	pop    %r12
  800b40:	5d                   	pop    %rbp
  800b41:	c3                   	retq   

0000000000800b42 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b42:	55                   	push   %rbp
  800b43:	48 89 e5             	mov    %rsp,%rbp
  800b46:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b4d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b54:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b5b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b62:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b69:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b70:	84 c0                	test   %al,%al
  800b72:	74 20                	je     800b94 <printfmt+0x52>
  800b74:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b78:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b7c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b80:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b84:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b88:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b8c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b90:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b94:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b9b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ba2:	00 00 00 
  800ba5:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bac:	00 00 00 
  800baf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bb3:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bba:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bc1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800bc8:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bcf:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bd6:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bdd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800be4:	48 89 c7             	mov    %rax,%rdi
  800be7:	48 b8 2a 06 80 00 00 	movabs $0x80062a,%rax
  800bee:	00 00 00 
  800bf1:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bf3:	c9                   	leaveq 
  800bf4:	c3                   	retq   

0000000000800bf5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf5:	55                   	push   %rbp
  800bf6:	48 89 e5             	mov    %rsp,%rbp
  800bf9:	48 83 ec 10          	sub    $0x10,%rsp
  800bfd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c08:	8b 40 10             	mov    0x10(%rax),%eax
  800c0b:	8d 50 01             	lea    0x1(%rax),%edx
  800c0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c12:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c19:	48 8b 10             	mov    (%rax),%rdx
  800c1c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c20:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c24:	48 39 c2             	cmp    %rax,%rdx
  800c27:	73 17                	jae    800c40 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c2d:	48 8b 00             	mov    (%rax),%rax
  800c30:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c34:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c38:	48 89 0a             	mov    %rcx,(%rdx)
  800c3b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c3e:	88 10                	mov    %dl,(%rax)
}
  800c40:	c9                   	leaveq 
  800c41:	c3                   	retq   

0000000000800c42 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c42:	55                   	push   %rbp
  800c43:	48 89 e5             	mov    %rsp,%rbp
  800c46:	48 83 ec 50          	sub    $0x50,%rsp
  800c4a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c4e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c51:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c55:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c59:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c5d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c61:	48 8b 0a             	mov    (%rdx),%rcx
  800c64:	48 89 08             	mov    %rcx,(%rax)
  800c67:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c6b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c6f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c73:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c77:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c7b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c7f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c82:	48 98                	cltq   
  800c84:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c88:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c8c:	48 01 d0             	add    %rdx,%rax
  800c8f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c93:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c9a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c9f:	74 06                	je     800ca7 <vsnprintf+0x65>
  800ca1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ca5:	7f 07                	jg     800cae <vsnprintf+0x6c>
		return -E_INVAL;
  800ca7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cac:	eb 2f                	jmp    800cdd <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800cae:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cb2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cb6:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cba:	48 89 c6             	mov    %rax,%rsi
  800cbd:	48 bf f5 0b 80 00 00 	movabs $0x800bf5,%rdi
  800cc4:	00 00 00 
  800cc7:	48 b8 2a 06 80 00 00 	movabs $0x80062a,%rax
  800cce:	00 00 00 
  800cd1:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cd3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cd7:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cda:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cdd:	c9                   	leaveq 
  800cde:	c3                   	retq   

0000000000800cdf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cdf:	55                   	push   %rbp
  800ce0:	48 89 e5             	mov    %rsp,%rbp
  800ce3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cea:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cf1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cf7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cfe:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d05:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d0c:	84 c0                	test   %al,%al
  800d0e:	74 20                	je     800d30 <snprintf+0x51>
  800d10:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d14:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d18:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d1c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d20:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d24:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d28:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d2c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d30:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d37:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d3e:	00 00 00 
  800d41:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d48:	00 00 00 
  800d4b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d4f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d56:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d5d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d64:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d6b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d72:	48 8b 0a             	mov    (%rdx),%rcx
  800d75:	48 89 08             	mov    %rcx,(%rax)
  800d78:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d7c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d80:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d84:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d88:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d8f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d96:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d9c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800da3:	48 89 c7             	mov    %rax,%rdi
  800da6:	48 b8 42 0c 80 00 00 	movabs $0x800c42,%rax
  800dad:	00 00 00 
  800db0:	ff d0                	callq  *%rax
  800db2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800db8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800dbe:	c9                   	leaveq 
  800dbf:	c3                   	retq   

0000000000800dc0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dc0:	55                   	push   %rbp
  800dc1:	48 89 e5             	mov    %rsp,%rbp
  800dc4:	48 83 ec 18          	sub    $0x18,%rsp
  800dc8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800dd3:	eb 09                	jmp    800dde <strlen+0x1e>
		n++;
  800dd5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800de2:	0f b6 00             	movzbl (%rax),%eax
  800de5:	84 c0                	test   %al,%al
  800de7:	75 ec                	jne    800dd5 <strlen+0x15>
		n++;
	return n;
  800de9:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dec:	c9                   	leaveq 
  800ded:	c3                   	retq   

0000000000800dee <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dee:	55                   	push   %rbp
  800def:	48 89 e5             	mov    %rsp,%rbp
  800df2:	48 83 ec 20          	sub    $0x20,%rsp
  800df6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dfa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e05:	eb 0e                	jmp    800e15 <strnlen+0x27>
		n++;
  800e07:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e0b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e10:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e15:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e1a:	74 0b                	je     800e27 <strnlen+0x39>
  800e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e20:	0f b6 00             	movzbl (%rax),%eax
  800e23:	84 c0                	test   %al,%al
  800e25:	75 e0                	jne    800e07 <strnlen+0x19>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e2a:	c9                   	leaveq 
  800e2b:	c3                   	retq   

0000000000800e2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2c:	55                   	push   %rbp
  800e2d:	48 89 e5             	mov    %rsp,%rbp
  800e30:	48 83 ec 20          	sub    $0x20,%rsp
  800e34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e40:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e44:	90                   	nop
  800e45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e49:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e4d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e51:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e55:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e59:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e5d:	0f b6 12             	movzbl (%rdx),%edx
  800e60:	88 10                	mov    %dl,(%rax)
  800e62:	0f b6 00             	movzbl (%rax),%eax
  800e65:	84 c0                	test   %al,%al
  800e67:	75 dc                	jne    800e45 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e6d:	c9                   	leaveq 
  800e6e:	c3                   	retq   

0000000000800e6f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e6f:	55                   	push   %rbp
  800e70:	48 89 e5             	mov    %rsp,%rbp
  800e73:	48 83 ec 20          	sub    $0x20,%rsp
  800e77:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e83:	48 89 c7             	mov    %rax,%rdi
  800e86:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  800e8d:	00 00 00 
  800e90:	ff d0                	callq  *%rax
  800e92:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e98:	48 63 d0             	movslq %eax,%rdx
  800e9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9f:	48 01 c2             	add    %rax,%rdx
  800ea2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ea6:	48 89 c6             	mov    %rax,%rsi
  800ea9:	48 89 d7             	mov    %rdx,%rdi
  800eac:	48 b8 2c 0e 80 00 00 	movabs $0x800e2c,%rax
  800eb3:	00 00 00 
  800eb6:	ff d0                	callq  *%rax
	return dst;
  800eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800ebc:	c9                   	leaveq 
  800ebd:	c3                   	retq   

0000000000800ebe <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ebe:	55                   	push   %rbp
  800ebf:	48 89 e5             	mov    %rsp,%rbp
  800ec2:	48 83 ec 28          	sub    $0x28,%rsp
  800ec6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ece:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800ed2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800eda:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ee1:	00 
  800ee2:	eb 2a                	jmp    800f0e <strncpy+0x50>
		*dst++ = *src;
  800ee4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ef0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ef4:	0f b6 12             	movzbl (%rdx),%edx
  800ef7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800efd:	0f b6 00             	movzbl (%rax),%eax
  800f00:	84 c0                	test   %al,%al
  800f02:	74 05                	je     800f09 <strncpy+0x4b>
			src++;
  800f04:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f09:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f12:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f16:	72 cc                	jb     800ee4 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f1c:	c9                   	leaveq 
  800f1d:	c3                   	retq   

0000000000800f1e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f1e:	55                   	push   %rbp
  800f1f:	48 89 e5             	mov    %rsp,%rbp
  800f22:	48 83 ec 28          	sub    $0x28,%rsp
  800f26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f2a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f2e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f3a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f3f:	74 3d                	je     800f7e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f41:	eb 1d                	jmp    800f60 <strlcpy+0x42>
			*dst++ = *src++;
  800f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f47:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f4b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f4f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f53:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f57:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f5b:	0f b6 12             	movzbl (%rdx),%edx
  800f5e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f60:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f65:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f6a:	74 0b                	je     800f77 <strlcpy+0x59>
  800f6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f70:	0f b6 00             	movzbl (%rax),%eax
  800f73:	84 c0                	test   %al,%al
  800f75:	75 cc                	jne    800f43 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f86:	48 29 c2             	sub    %rax,%rdx
  800f89:	48 89 d0             	mov    %rdx,%rax
}
  800f8c:	c9                   	leaveq 
  800f8d:	c3                   	retq   

0000000000800f8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f8e:	55                   	push   %rbp
  800f8f:	48 89 e5             	mov    %rsp,%rbp
  800f92:	48 83 ec 10          	sub    $0x10,%rsp
  800f96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f9e:	eb 0a                	jmp    800faa <strcmp+0x1c>
		p++, q++;
  800fa0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fa5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800faa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fae:	0f b6 00             	movzbl (%rax),%eax
  800fb1:	84 c0                	test   %al,%al
  800fb3:	74 12                	je     800fc7 <strcmp+0x39>
  800fb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb9:	0f b6 10             	movzbl (%rax),%edx
  800fbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fc0:	0f b6 00             	movzbl (%rax),%eax
  800fc3:	38 c2                	cmp    %al,%dl
  800fc5:	74 d9                	je     800fa0 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fcb:	0f b6 00             	movzbl (%rax),%eax
  800fce:	0f b6 d0             	movzbl %al,%edx
  800fd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fd5:	0f b6 00             	movzbl (%rax),%eax
  800fd8:	0f b6 c0             	movzbl %al,%eax
  800fdb:	29 c2                	sub    %eax,%edx
  800fdd:	89 d0                	mov    %edx,%eax
}
  800fdf:	c9                   	leaveq 
  800fe0:	c3                   	retq   

0000000000800fe1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fe1:	55                   	push   %rbp
  800fe2:	48 89 e5             	mov    %rsp,%rbp
  800fe5:	48 83 ec 18          	sub    $0x18,%rsp
  800fe9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800ff1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800ff5:	eb 0f                	jmp    801006 <strncmp+0x25>
		n--, p++, q++;
  800ff7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800ffc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801001:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801006:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80100b:	74 1d                	je     80102a <strncmp+0x49>
  80100d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801011:	0f b6 00             	movzbl (%rax),%eax
  801014:	84 c0                	test   %al,%al
  801016:	74 12                	je     80102a <strncmp+0x49>
  801018:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101c:	0f b6 10             	movzbl (%rax),%edx
  80101f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801023:	0f b6 00             	movzbl (%rax),%eax
  801026:	38 c2                	cmp    %al,%dl
  801028:	74 cd                	je     800ff7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80102a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80102f:	75 07                	jne    801038 <strncmp+0x57>
		return 0;
  801031:	b8 00 00 00 00       	mov    $0x0,%eax
  801036:	eb 18                	jmp    801050 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801038:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80103c:	0f b6 00             	movzbl (%rax),%eax
  80103f:	0f b6 d0             	movzbl %al,%edx
  801042:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801046:	0f b6 00             	movzbl (%rax),%eax
  801049:	0f b6 c0             	movzbl %al,%eax
  80104c:	29 c2                	sub    %eax,%edx
  80104e:	89 d0                	mov    %edx,%eax
}
  801050:	c9                   	leaveq 
  801051:	c3                   	retq   

0000000000801052 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801052:	55                   	push   %rbp
  801053:	48 89 e5             	mov    %rsp,%rbp
  801056:	48 83 ec 0c          	sub    $0xc,%rsp
  80105a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80105e:	89 f0                	mov    %esi,%eax
  801060:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801063:	eb 17                	jmp    80107c <strchr+0x2a>
		if (*s == c)
  801065:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801069:	0f b6 00             	movzbl (%rax),%eax
  80106c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80106f:	75 06                	jne    801077 <strchr+0x25>
			return (char *) s;
  801071:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801075:	eb 15                	jmp    80108c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801077:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80107c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801080:	0f b6 00             	movzbl (%rax),%eax
  801083:	84 c0                	test   %al,%al
  801085:	75 de                	jne    801065 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801087:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108c:	c9                   	leaveq 
  80108d:	c3                   	retq   

000000000080108e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80108e:	55                   	push   %rbp
  80108f:	48 89 e5             	mov    %rsp,%rbp
  801092:	48 83 ec 0c          	sub    $0xc,%rsp
  801096:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80109a:	89 f0                	mov    %esi,%eax
  80109c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80109f:	eb 13                	jmp    8010b4 <strfind+0x26>
		if (*s == c)
  8010a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a5:	0f b6 00             	movzbl (%rax),%eax
  8010a8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010ab:	75 02                	jne    8010af <strfind+0x21>
			break;
  8010ad:	eb 10                	jmp    8010bf <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010af:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b8:	0f b6 00             	movzbl (%rax),%eax
  8010bb:	84 c0                	test   %al,%al
  8010bd:	75 e2                	jne    8010a1 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010c3:	c9                   	leaveq 
  8010c4:	c3                   	retq   

00000000008010c5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010c5:	55                   	push   %rbp
  8010c6:	48 89 e5             	mov    %rsp,%rbp
  8010c9:	48 83 ec 18          	sub    $0x18,%rsp
  8010cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010d8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010dd:	75 06                	jne    8010e5 <memset+0x20>
		return v;
  8010df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e3:	eb 69                	jmp    80114e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e9:	83 e0 03             	and    $0x3,%eax
  8010ec:	48 85 c0             	test   %rax,%rax
  8010ef:	75 48                	jne    801139 <memset+0x74>
  8010f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f5:	83 e0 03             	and    $0x3,%eax
  8010f8:	48 85 c0             	test   %rax,%rax
  8010fb:	75 3c                	jne    801139 <memset+0x74>
		c &= 0xFF;
  8010fd:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801104:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801107:	c1 e0 18             	shl    $0x18,%eax
  80110a:	89 c2                	mov    %eax,%edx
  80110c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80110f:	c1 e0 10             	shl    $0x10,%eax
  801112:	09 c2                	or     %eax,%edx
  801114:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801117:	c1 e0 08             	shl    $0x8,%eax
  80111a:	09 d0                	or     %edx,%eax
  80111c:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80111f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801123:	48 c1 e8 02          	shr    $0x2,%rax
  801127:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80112a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80112e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801131:	48 89 d7             	mov    %rdx,%rdi
  801134:	fc                   	cld    
  801135:	f3 ab                	rep stos %eax,%es:(%rdi)
  801137:	eb 11                	jmp    80114a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801139:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80113d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801140:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801144:	48 89 d7             	mov    %rdx,%rdi
  801147:	fc                   	cld    
  801148:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80114a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80114e:	c9                   	leaveq 
  80114f:	c3                   	retq   

0000000000801150 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801150:	55                   	push   %rbp
  801151:	48 89 e5             	mov    %rsp,%rbp
  801154:	48 83 ec 28          	sub    $0x28,%rsp
  801158:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80115c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801160:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801164:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801168:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80116c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801170:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801178:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80117c:	0f 83 88 00 00 00    	jae    80120a <memmove+0xba>
  801182:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801186:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80118a:	48 01 d0             	add    %rdx,%rax
  80118d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801191:	76 77                	jbe    80120a <memmove+0xba>
		s += n;
  801193:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801197:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80119b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80119f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a7:	83 e0 03             	and    $0x3,%eax
  8011aa:	48 85 c0             	test   %rax,%rax
  8011ad:	75 3b                	jne    8011ea <memmove+0x9a>
  8011af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b3:	83 e0 03             	and    $0x3,%eax
  8011b6:	48 85 c0             	test   %rax,%rax
  8011b9:	75 2f                	jne    8011ea <memmove+0x9a>
  8011bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011bf:	83 e0 03             	and    $0x3,%eax
  8011c2:	48 85 c0             	test   %rax,%rax
  8011c5:	75 23                	jne    8011ea <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cb:	48 83 e8 04          	sub    $0x4,%rax
  8011cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d3:	48 83 ea 04          	sub    $0x4,%rdx
  8011d7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011db:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011df:	48 89 c7             	mov    %rax,%rdi
  8011e2:	48 89 d6             	mov    %rdx,%rsi
  8011e5:	fd                   	std    
  8011e6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011e8:	eb 1d                	jmp    801207 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ee:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011fe:	48 89 d7             	mov    %rdx,%rdi
  801201:	48 89 c1             	mov    %rax,%rcx
  801204:	fd                   	std    
  801205:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801207:	fc                   	cld    
  801208:	eb 57                	jmp    801261 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80120a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120e:	83 e0 03             	and    $0x3,%eax
  801211:	48 85 c0             	test   %rax,%rax
  801214:	75 36                	jne    80124c <memmove+0xfc>
  801216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121a:	83 e0 03             	and    $0x3,%eax
  80121d:	48 85 c0             	test   %rax,%rax
  801220:	75 2a                	jne    80124c <memmove+0xfc>
  801222:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801226:	83 e0 03             	and    $0x3,%eax
  801229:	48 85 c0             	test   %rax,%rax
  80122c:	75 1e                	jne    80124c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80122e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801232:	48 c1 e8 02          	shr    $0x2,%rax
  801236:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801239:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801241:	48 89 c7             	mov    %rax,%rdi
  801244:	48 89 d6             	mov    %rdx,%rsi
  801247:	fc                   	cld    
  801248:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80124a:	eb 15                	jmp    801261 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80124c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801250:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801254:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801258:	48 89 c7             	mov    %rax,%rdi
  80125b:	48 89 d6             	mov    %rdx,%rsi
  80125e:	fc                   	cld    
  80125f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801261:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801265:	c9                   	leaveq 
  801266:	c3                   	retq   

0000000000801267 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801267:	55                   	push   %rbp
  801268:	48 89 e5             	mov    %rsp,%rbp
  80126b:	48 83 ec 18          	sub    $0x18,%rsp
  80126f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801273:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801277:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80127b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80127f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801283:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801287:	48 89 ce             	mov    %rcx,%rsi
  80128a:	48 89 c7             	mov    %rax,%rdi
  80128d:	48 b8 50 11 80 00 00 	movabs $0x801150,%rax
  801294:	00 00 00 
  801297:	ff d0                	callq  *%rax
}
  801299:	c9                   	leaveq 
  80129a:	c3                   	retq   

000000000080129b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80129b:	55                   	push   %rbp
  80129c:	48 89 e5             	mov    %rsp,%rbp
  80129f:	48 83 ec 28          	sub    $0x28,%rsp
  8012a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012bf:	eb 36                	jmp    8012f7 <memcmp+0x5c>
		if (*s1 != *s2)
  8012c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c5:	0f b6 10             	movzbl (%rax),%edx
  8012c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012cc:	0f b6 00             	movzbl (%rax),%eax
  8012cf:	38 c2                	cmp    %al,%dl
  8012d1:	74 1a                	je     8012ed <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d7:	0f b6 00             	movzbl (%rax),%eax
  8012da:	0f b6 d0             	movzbl %al,%edx
  8012dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e1:	0f b6 00             	movzbl (%rax),%eax
  8012e4:	0f b6 c0             	movzbl %al,%eax
  8012e7:	29 c2                	sub    %eax,%edx
  8012e9:	89 d0                	mov    %edx,%eax
  8012eb:	eb 20                	jmp    80130d <memcmp+0x72>
		s1++, s2++;
  8012ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012fb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801303:	48 85 c0             	test   %rax,%rax
  801306:	75 b9                	jne    8012c1 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801308:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130d:	c9                   	leaveq 
  80130e:	c3                   	retq   

000000000080130f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80130f:	55                   	push   %rbp
  801310:	48 89 e5             	mov    %rsp,%rbp
  801313:	48 83 ec 28          	sub    $0x28,%rsp
  801317:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80131b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80131e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801322:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801326:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80132a:	48 01 d0             	add    %rdx,%rax
  80132d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801331:	eb 15                	jmp    801348 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801333:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801337:	0f b6 10             	movzbl (%rax),%edx
  80133a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80133d:	38 c2                	cmp    %al,%dl
  80133f:	75 02                	jne    801343 <memfind+0x34>
			break;
  801341:	eb 0f                	jmp    801352 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801343:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801348:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80134c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801350:	72 e1                	jb     801333 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801352:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801356:	c9                   	leaveq 
  801357:	c3                   	retq   

0000000000801358 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801358:	55                   	push   %rbp
  801359:	48 89 e5             	mov    %rsp,%rbp
  80135c:	48 83 ec 34          	sub    $0x34,%rsp
  801360:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801364:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801368:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80136b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801372:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801379:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137a:	eb 05                	jmp    801381 <strtol+0x29>
		s++;
  80137c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801381:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801385:	0f b6 00             	movzbl (%rax),%eax
  801388:	3c 20                	cmp    $0x20,%al
  80138a:	74 f0                	je     80137c <strtol+0x24>
  80138c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801390:	0f b6 00             	movzbl (%rax),%eax
  801393:	3c 09                	cmp    $0x9,%al
  801395:	74 e5                	je     80137c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801397:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80139b:	0f b6 00             	movzbl (%rax),%eax
  80139e:	3c 2b                	cmp    $0x2b,%al
  8013a0:	75 07                	jne    8013a9 <strtol+0x51>
		s++;
  8013a2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013a7:	eb 17                	jmp    8013c0 <strtol+0x68>
	else if (*s == '-')
  8013a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ad:	0f b6 00             	movzbl (%rax),%eax
  8013b0:	3c 2d                	cmp    $0x2d,%al
  8013b2:	75 0c                	jne    8013c0 <strtol+0x68>
		s++, neg = 1;
  8013b4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013b9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c0:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013c4:	74 06                	je     8013cc <strtol+0x74>
  8013c6:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013ca:	75 28                	jne    8013f4 <strtol+0x9c>
  8013cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d0:	0f b6 00             	movzbl (%rax),%eax
  8013d3:	3c 30                	cmp    $0x30,%al
  8013d5:	75 1d                	jne    8013f4 <strtol+0x9c>
  8013d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013db:	48 83 c0 01          	add    $0x1,%rax
  8013df:	0f b6 00             	movzbl (%rax),%eax
  8013e2:	3c 78                	cmp    $0x78,%al
  8013e4:	75 0e                	jne    8013f4 <strtol+0x9c>
		s += 2, base = 16;
  8013e6:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013eb:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013f2:	eb 2c                	jmp    801420 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013f4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013f8:	75 19                	jne    801413 <strtol+0xbb>
  8013fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fe:	0f b6 00             	movzbl (%rax),%eax
  801401:	3c 30                	cmp    $0x30,%al
  801403:	75 0e                	jne    801413 <strtol+0xbb>
		s++, base = 8;
  801405:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80140a:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801411:	eb 0d                	jmp    801420 <strtol+0xc8>
	else if (base == 0)
  801413:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801417:	75 07                	jne    801420 <strtol+0xc8>
		base = 10;
  801419:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801420:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801424:	0f b6 00             	movzbl (%rax),%eax
  801427:	3c 2f                	cmp    $0x2f,%al
  801429:	7e 1d                	jle    801448 <strtol+0xf0>
  80142b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142f:	0f b6 00             	movzbl (%rax),%eax
  801432:	3c 39                	cmp    $0x39,%al
  801434:	7f 12                	jg     801448 <strtol+0xf0>
			dig = *s - '0';
  801436:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143a:	0f b6 00             	movzbl (%rax),%eax
  80143d:	0f be c0             	movsbl %al,%eax
  801440:	83 e8 30             	sub    $0x30,%eax
  801443:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801446:	eb 4e                	jmp    801496 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144c:	0f b6 00             	movzbl (%rax),%eax
  80144f:	3c 60                	cmp    $0x60,%al
  801451:	7e 1d                	jle    801470 <strtol+0x118>
  801453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801457:	0f b6 00             	movzbl (%rax),%eax
  80145a:	3c 7a                	cmp    $0x7a,%al
  80145c:	7f 12                	jg     801470 <strtol+0x118>
			dig = *s - 'a' + 10;
  80145e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801462:	0f b6 00             	movzbl (%rax),%eax
  801465:	0f be c0             	movsbl %al,%eax
  801468:	83 e8 57             	sub    $0x57,%eax
  80146b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80146e:	eb 26                	jmp    801496 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801470:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801474:	0f b6 00             	movzbl (%rax),%eax
  801477:	3c 40                	cmp    $0x40,%al
  801479:	7e 48                	jle    8014c3 <strtol+0x16b>
  80147b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147f:	0f b6 00             	movzbl (%rax),%eax
  801482:	3c 5a                	cmp    $0x5a,%al
  801484:	7f 3d                	jg     8014c3 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801486:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148a:	0f b6 00             	movzbl (%rax),%eax
  80148d:	0f be c0             	movsbl %al,%eax
  801490:	83 e8 37             	sub    $0x37,%eax
  801493:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801496:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801499:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80149c:	7c 02                	jl     8014a0 <strtol+0x148>
			break;
  80149e:	eb 23                	jmp    8014c3 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014a0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014a5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014a8:	48 98                	cltq   
  8014aa:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014af:	48 89 c2             	mov    %rax,%rdx
  8014b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014b5:	48 98                	cltq   
  8014b7:	48 01 d0             	add    %rdx,%rax
  8014ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014be:	e9 5d ff ff ff       	jmpq   801420 <strtol+0xc8>

	if (endptr)
  8014c3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014c8:	74 0b                	je     8014d5 <strtol+0x17d>
		*endptr = (char *) s;
  8014ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014ce:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014d2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014d9:	74 09                	je     8014e4 <strtol+0x18c>
  8014db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014df:	48 f7 d8             	neg    %rax
  8014e2:	eb 04                	jmp    8014e8 <strtol+0x190>
  8014e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014e8:	c9                   	leaveq 
  8014e9:	c3                   	retq   

00000000008014ea <strstr>:

char * strstr(const char *in, const char *str)
{
  8014ea:	55                   	push   %rbp
  8014eb:	48 89 e5             	mov    %rsp,%rbp
  8014ee:	48 83 ec 30          	sub    $0x30,%rsp
  8014f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014fe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801502:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80150c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801510:	75 06                	jne    801518 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801512:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801516:	eb 6b                	jmp    801583 <strstr+0x99>

	len = strlen(str);
  801518:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80151c:	48 89 c7             	mov    %rax,%rdi
  80151f:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  801526:	00 00 00 
  801529:	ff d0                	callq  *%rax
  80152b:	48 98                	cltq   
  80152d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801531:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801535:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801539:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80153d:	0f b6 00             	movzbl (%rax),%eax
  801540:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801543:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801547:	75 07                	jne    801550 <strstr+0x66>
				return (char *) 0;
  801549:	b8 00 00 00 00       	mov    $0x0,%eax
  80154e:	eb 33                	jmp    801583 <strstr+0x99>
		} while (sc != c);
  801550:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801554:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801557:	75 d8                	jne    801531 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801559:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80155d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801561:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801565:	48 89 ce             	mov    %rcx,%rsi
  801568:	48 89 c7             	mov    %rax,%rdi
  80156b:	48 b8 e1 0f 80 00 00 	movabs $0x800fe1,%rax
  801572:	00 00 00 
  801575:	ff d0                	callq  *%rax
  801577:	85 c0                	test   %eax,%eax
  801579:	75 b6                	jne    801531 <strstr+0x47>

	return (char *) (in - 1);
  80157b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157f:	48 83 e8 01          	sub    $0x1,%rax
}
  801583:	c9                   	leaveq 
  801584:	c3                   	retq   

0000000000801585 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801585:	55                   	push   %rbp
  801586:	48 89 e5             	mov    %rsp,%rbp
  801589:	53                   	push   %rbx
  80158a:	48 83 ec 48          	sub    $0x48,%rsp
  80158e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801591:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801594:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801598:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80159c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015a0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8015a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015a7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015ab:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015af:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015b3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015b7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015bb:	4c 89 c3             	mov    %r8,%rbx
  8015be:	cd 30                	int    $0x30
  8015c0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  8015c4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015c8:	74 3e                	je     801608 <syscall+0x83>
  8015ca:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015cf:	7e 37                	jle    801608 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015d1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015d5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015d8:	49 89 d0             	mov    %rdx,%r8
  8015db:	89 c1                	mov    %eax,%ecx
  8015dd:	48 ba 28 3a 80 00 00 	movabs $0x803a28,%rdx
  8015e4:	00 00 00 
  8015e7:	be 4a 00 00 00       	mov    $0x4a,%esi
  8015ec:	48 bf 45 3a 80 00 00 	movabs $0x803a45,%rdi
  8015f3:	00 00 00 
  8015f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fb:	49 b9 95 31 80 00 00 	movabs $0x803195,%r9
  801602:	00 00 00 
  801605:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80160c:	48 83 c4 48          	add    $0x48,%rsp
  801610:	5b                   	pop    %rbx
  801611:	5d                   	pop    %rbp
  801612:	c3                   	retq   

0000000000801613 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801613:	55                   	push   %rbp
  801614:	48 89 e5             	mov    %rsp,%rbp
  801617:	48 83 ec 20          	sub    $0x20,%rsp
  80161b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80161f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801627:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80162b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801632:	00 
  801633:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801639:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80163f:	48 89 d1             	mov    %rdx,%rcx
  801642:	48 89 c2             	mov    %rax,%rdx
  801645:	be 00 00 00 00       	mov    $0x0,%esi
  80164a:	bf 00 00 00 00       	mov    $0x0,%edi
  80164f:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  801656:	00 00 00 
  801659:	ff d0                	callq  *%rax
}
  80165b:	c9                   	leaveq 
  80165c:	c3                   	retq   

000000000080165d <sys_cgetc>:

int
sys_cgetc(void)
{
  80165d:	55                   	push   %rbp
  80165e:	48 89 e5             	mov    %rsp,%rbp
  801661:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801665:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80166c:	00 
  80166d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801673:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801679:	b9 00 00 00 00       	mov    $0x0,%ecx
  80167e:	ba 00 00 00 00       	mov    $0x0,%edx
  801683:	be 00 00 00 00       	mov    $0x0,%esi
  801688:	bf 01 00 00 00       	mov    $0x1,%edi
  80168d:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  801694:	00 00 00 
  801697:	ff d0                	callq  *%rax
}
  801699:	c9                   	leaveq 
  80169a:	c3                   	retq   

000000000080169b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80169b:	55                   	push   %rbp
  80169c:	48 89 e5             	mov    %rsp,%rbp
  80169f:	48 83 ec 10          	sub    $0x10,%rsp
  8016a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a9:	48 98                	cltq   
  8016ab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016b2:	00 
  8016b3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016c4:	48 89 c2             	mov    %rax,%rdx
  8016c7:	be 01 00 00 00       	mov    $0x1,%esi
  8016cc:	bf 03 00 00 00       	mov    $0x3,%edi
  8016d1:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  8016d8:	00 00 00 
  8016db:	ff d0                	callq  *%rax
}
  8016dd:	c9                   	leaveq 
  8016de:	c3                   	retq   

00000000008016df <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016df:	55                   	push   %rbp
  8016e0:	48 89 e5             	mov    %rsp,%rbp
  8016e3:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016e7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016ee:	00 
  8016ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801700:	ba 00 00 00 00       	mov    $0x0,%edx
  801705:	be 00 00 00 00       	mov    $0x0,%esi
  80170a:	bf 02 00 00 00       	mov    $0x2,%edi
  80170f:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  801716:	00 00 00 
  801719:	ff d0                	callq  *%rax
}
  80171b:	c9                   	leaveq 
  80171c:	c3                   	retq   

000000000080171d <sys_yield>:

void
sys_yield(void)
{
  80171d:	55                   	push   %rbp
  80171e:	48 89 e5             	mov    %rsp,%rbp
  801721:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801725:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80172c:	00 
  80172d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801733:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801739:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173e:	ba 00 00 00 00       	mov    $0x0,%edx
  801743:	be 00 00 00 00       	mov    $0x0,%esi
  801748:	bf 0b 00 00 00       	mov    $0xb,%edi
  80174d:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  801754:	00 00 00 
  801757:	ff d0                	callq  *%rax
}
  801759:	c9                   	leaveq 
  80175a:	c3                   	retq   

000000000080175b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80175b:	55                   	push   %rbp
  80175c:	48 89 e5             	mov    %rsp,%rbp
  80175f:	48 83 ec 20          	sub    $0x20,%rsp
  801763:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801766:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80176a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80176d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801770:	48 63 c8             	movslq %eax,%rcx
  801773:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801777:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80177a:	48 98                	cltq   
  80177c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801783:	00 
  801784:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80178a:	49 89 c8             	mov    %rcx,%r8
  80178d:	48 89 d1             	mov    %rdx,%rcx
  801790:	48 89 c2             	mov    %rax,%rdx
  801793:	be 01 00 00 00       	mov    $0x1,%esi
  801798:	bf 04 00 00 00       	mov    $0x4,%edi
  80179d:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  8017a4:	00 00 00 
  8017a7:	ff d0                	callq  *%rax
}
  8017a9:	c9                   	leaveq 
  8017aa:	c3                   	retq   

00000000008017ab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017ab:	55                   	push   %rbp
  8017ac:	48 89 e5             	mov    %rsp,%rbp
  8017af:	48 83 ec 30          	sub    $0x30,%rsp
  8017b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017ba:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017bd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017c1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8017c5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8017c8:	48 63 c8             	movslq %eax,%rcx
  8017cb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8017cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017d2:	48 63 f0             	movslq %eax,%rsi
  8017d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017dc:	48 98                	cltq   
  8017de:	48 89 0c 24          	mov    %rcx,(%rsp)
  8017e2:	49 89 f9             	mov    %rdi,%r9
  8017e5:	49 89 f0             	mov    %rsi,%r8
  8017e8:	48 89 d1             	mov    %rdx,%rcx
  8017eb:	48 89 c2             	mov    %rax,%rdx
  8017ee:	be 01 00 00 00       	mov    $0x1,%esi
  8017f3:	bf 05 00 00 00       	mov    $0x5,%edi
  8017f8:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  8017ff:	00 00 00 
  801802:	ff d0                	callq  *%rax
}
  801804:	c9                   	leaveq 
  801805:	c3                   	retq   

0000000000801806 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801806:	55                   	push   %rbp
  801807:	48 89 e5             	mov    %rsp,%rbp
  80180a:	48 83 ec 20          	sub    $0x20,%rsp
  80180e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801811:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801815:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801819:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181c:	48 98                	cltq   
  80181e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801825:	00 
  801826:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801832:	48 89 d1             	mov    %rdx,%rcx
  801835:	48 89 c2             	mov    %rax,%rdx
  801838:	be 01 00 00 00       	mov    $0x1,%esi
  80183d:	bf 06 00 00 00       	mov    $0x6,%edi
  801842:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  801849:	00 00 00 
  80184c:	ff d0                	callq  *%rax
}
  80184e:	c9                   	leaveq 
  80184f:	c3                   	retq   

0000000000801850 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801850:	55                   	push   %rbp
  801851:	48 89 e5             	mov    %rsp,%rbp
  801854:	48 83 ec 10          	sub    $0x10,%rsp
  801858:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80185b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80185e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801861:	48 63 d0             	movslq %eax,%rdx
  801864:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801867:	48 98                	cltq   
  801869:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801870:	00 
  801871:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801877:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80187d:	48 89 d1             	mov    %rdx,%rcx
  801880:	48 89 c2             	mov    %rax,%rdx
  801883:	be 01 00 00 00       	mov    $0x1,%esi
  801888:	bf 08 00 00 00       	mov    $0x8,%edi
  80188d:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  801894:	00 00 00 
  801897:	ff d0                	callq  *%rax
}
  801899:	c9                   	leaveq 
  80189a:	c3                   	retq   

000000000080189b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80189b:	55                   	push   %rbp
  80189c:	48 89 e5             	mov    %rsp,%rbp
  80189f:	48 83 ec 20          	sub    $0x20,%rsp
  8018a3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018a6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018b1:	48 98                	cltq   
  8018b3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ba:	00 
  8018bb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c7:	48 89 d1             	mov    %rdx,%rcx
  8018ca:	48 89 c2             	mov    %rax,%rdx
  8018cd:	be 01 00 00 00       	mov    $0x1,%esi
  8018d2:	bf 09 00 00 00       	mov    $0x9,%edi
  8018d7:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  8018de:	00 00 00 
  8018e1:	ff d0                	callq  *%rax
}
  8018e3:	c9                   	leaveq 
  8018e4:	c3                   	retq   

00000000008018e5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8018e5:	55                   	push   %rbp
  8018e6:	48 89 e5             	mov    %rsp,%rbp
  8018e9:	48 83 ec 20          	sub    $0x20,%rsp
  8018ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018f0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8018f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018fb:	48 98                	cltq   
  8018fd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801904:	00 
  801905:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80190b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801911:	48 89 d1             	mov    %rdx,%rcx
  801914:	48 89 c2             	mov    %rax,%rdx
  801917:	be 01 00 00 00       	mov    $0x1,%esi
  80191c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801921:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  801928:	00 00 00 
  80192b:	ff d0                	callq  *%rax
}
  80192d:	c9                   	leaveq 
  80192e:	c3                   	retq   

000000000080192f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80192f:	55                   	push   %rbp
  801930:	48 89 e5             	mov    %rsp,%rbp
  801933:	48 83 ec 20          	sub    $0x20,%rsp
  801937:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80193a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80193e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801942:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801945:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801948:	48 63 f0             	movslq %eax,%rsi
  80194b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80194f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801952:	48 98                	cltq   
  801954:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801958:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80195f:	00 
  801960:	49 89 f1             	mov    %rsi,%r9
  801963:	49 89 c8             	mov    %rcx,%r8
  801966:	48 89 d1             	mov    %rdx,%rcx
  801969:	48 89 c2             	mov    %rax,%rdx
  80196c:	be 00 00 00 00       	mov    $0x0,%esi
  801971:	bf 0c 00 00 00       	mov    $0xc,%edi
  801976:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  80197d:	00 00 00 
  801980:	ff d0                	callq  *%rax
}
  801982:	c9                   	leaveq 
  801983:	c3                   	retq   

0000000000801984 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801984:	55                   	push   %rbp
  801985:	48 89 e5             	mov    %rsp,%rbp
  801988:	48 83 ec 10          	sub    $0x10,%rsp
  80198c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801990:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801994:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80199b:	00 
  80199c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019a2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019ad:	48 89 c2             	mov    %rax,%rdx
  8019b0:	be 01 00 00 00       	mov    $0x1,%esi
  8019b5:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019ba:	48 b8 85 15 80 00 00 	movabs $0x801585,%rax
  8019c1:	00 00 00 
  8019c4:	ff d0                	callq  *%rax
}
  8019c6:	c9                   	leaveq 
  8019c7:	c3                   	retq   

00000000008019c8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8019c8:	55                   	push   %rbp
  8019c9:	48 89 e5             	mov    %rsp,%rbp
  8019cc:	48 83 ec 08          	sub    $0x8,%rsp
  8019d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8019d8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8019df:	ff ff ff 
  8019e2:	48 01 d0             	add    %rdx,%rax
  8019e5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8019e9:	c9                   	leaveq 
  8019ea:	c3                   	retq   

00000000008019eb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8019eb:	55                   	push   %rbp
  8019ec:	48 89 e5             	mov    %rsp,%rbp
  8019ef:	48 83 ec 08          	sub    $0x8,%rsp
  8019f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8019f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fb:	48 89 c7             	mov    %rax,%rdi
  8019fe:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  801a05:	00 00 00 
  801a08:	ff d0                	callq  *%rax
  801a0a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a10:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a14:	c9                   	leaveq 
  801a15:	c3                   	retq   

0000000000801a16 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a16:	55                   	push   %rbp
  801a17:	48 89 e5             	mov    %rsp,%rbp
  801a1a:	48 83 ec 18          	sub    $0x18,%rsp
  801a1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a29:	eb 6b                	jmp    801a96 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801a2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a2e:	48 98                	cltq   
  801a30:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801a36:	48 c1 e0 0c          	shl    $0xc,%rax
  801a3a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801a3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a42:	48 c1 e8 15          	shr    $0x15,%rax
  801a46:	48 89 c2             	mov    %rax,%rdx
  801a49:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801a50:	01 00 00 
  801a53:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a57:	83 e0 01             	and    $0x1,%eax
  801a5a:	48 85 c0             	test   %rax,%rax
  801a5d:	74 21                	je     801a80 <fd_alloc+0x6a>
  801a5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a63:	48 c1 e8 0c          	shr    $0xc,%rax
  801a67:	48 89 c2             	mov    %rax,%rdx
  801a6a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801a71:	01 00 00 
  801a74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801a78:	83 e0 01             	and    $0x1,%eax
  801a7b:	48 85 c0             	test   %rax,%rax
  801a7e:	75 12                	jne    801a92 <fd_alloc+0x7c>
			*fd_store = fd;
  801a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a84:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a88:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801a8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a90:	eb 1a                	jmp    801aac <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a92:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801a96:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801a9a:	7e 8f                	jle    801a2b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801a9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aa0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801aa7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801aac:	c9                   	leaveq 
  801aad:	c3                   	retq   

0000000000801aae <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801aae:	55                   	push   %rbp
  801aaf:	48 89 e5             	mov    %rsp,%rbp
  801ab2:	48 83 ec 20          	sub    $0x20,%rsp
  801ab6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ab9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801abd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ac1:	78 06                	js     801ac9 <fd_lookup+0x1b>
  801ac3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ac7:	7e 07                	jle    801ad0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ac9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ace:	eb 6c                	jmp    801b3c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ad0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ad3:	48 98                	cltq   
  801ad5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801adb:	48 c1 e0 0c          	shl    $0xc,%rax
  801adf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ae3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ae7:	48 c1 e8 15          	shr    $0x15,%rax
  801aeb:	48 89 c2             	mov    %rax,%rdx
  801aee:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801af5:	01 00 00 
  801af8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801afc:	83 e0 01             	and    $0x1,%eax
  801aff:	48 85 c0             	test   %rax,%rax
  801b02:	74 21                	je     801b25 <fd_lookup+0x77>
  801b04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b08:	48 c1 e8 0c          	shr    $0xc,%rax
  801b0c:	48 89 c2             	mov    %rax,%rdx
  801b0f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b16:	01 00 00 
  801b19:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b1d:	83 e0 01             	and    $0x1,%eax
  801b20:	48 85 c0             	test   %rax,%rax
  801b23:	75 07                	jne    801b2c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b2a:	eb 10                	jmp    801b3c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801b2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b30:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b34:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801b37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3c:	c9                   	leaveq 
  801b3d:	c3                   	retq   

0000000000801b3e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801b3e:	55                   	push   %rbp
  801b3f:	48 89 e5             	mov    %rsp,%rbp
  801b42:	48 83 ec 30          	sub    $0x30,%rsp
  801b46:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b4a:	89 f0                	mov    %esi,%eax
  801b4c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b4f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b53:	48 89 c7             	mov    %rax,%rdi
  801b56:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  801b5d:	00 00 00 
  801b60:	ff d0                	callq  *%rax
  801b62:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b66:	48 89 d6             	mov    %rdx,%rsi
  801b69:	89 c7                	mov    %eax,%edi
  801b6b:	48 b8 ae 1a 80 00 00 	movabs $0x801aae,%rax
  801b72:	00 00 00 
  801b75:	ff d0                	callq  *%rax
  801b77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b7e:	78 0a                	js     801b8a <fd_close+0x4c>
	    || fd != fd2)
  801b80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b84:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801b88:	74 12                	je     801b9c <fd_close+0x5e>
		return (must_exist ? r : 0);
  801b8a:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801b8e:	74 05                	je     801b95 <fd_close+0x57>
  801b90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b93:	eb 05                	jmp    801b9a <fd_close+0x5c>
  801b95:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9a:	eb 69                	jmp    801c05 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba0:	8b 00                	mov    (%rax),%eax
  801ba2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ba6:	48 89 d6             	mov    %rdx,%rsi
  801ba9:	89 c7                	mov    %eax,%edi
  801bab:	48 b8 07 1c 80 00 00 	movabs $0x801c07,%rax
  801bb2:	00 00 00 
  801bb5:	ff d0                	callq  *%rax
  801bb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bbe:	78 2a                	js     801bea <fd_close+0xac>
		if (dev->dev_close)
  801bc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc4:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bc8:	48 85 c0             	test   %rax,%rax
  801bcb:	74 16                	je     801be3 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801bcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bd1:	48 8b 40 20          	mov    0x20(%rax),%rax
  801bd5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bd9:	48 89 d7             	mov    %rdx,%rdi
  801bdc:	ff d0                	callq  *%rax
  801bde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801be1:	eb 07                	jmp    801bea <fd_close+0xac>
		else
			r = 0;
  801be3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801bea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bee:	48 89 c6             	mov    %rax,%rsi
  801bf1:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf6:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  801bfd:	00 00 00 
  801c00:	ff d0                	callq  *%rax
	return r;
  801c02:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801c05:	c9                   	leaveq 
  801c06:	c3                   	retq   

0000000000801c07 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c07:	55                   	push   %rbp
  801c08:	48 89 e5             	mov    %rsp,%rbp
  801c0b:	48 83 ec 20          	sub    $0x20,%rsp
  801c0f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801c16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c1d:	eb 41                	jmp    801c60 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801c1f:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c26:	00 00 00 
  801c29:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c2c:	48 63 d2             	movslq %edx,%rdx
  801c2f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c33:	8b 00                	mov    (%rax),%eax
  801c35:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801c38:	75 22                	jne    801c5c <dev_lookup+0x55>
			*dev = devtab[i];
  801c3a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c41:	00 00 00 
  801c44:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c47:	48 63 d2             	movslq %edx,%rdx
  801c4a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801c4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c52:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5a:	eb 60                	jmp    801cbc <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c5c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c60:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c67:	00 00 00 
  801c6a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c6d:	48 63 d2             	movslq %edx,%rdx
  801c70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c74:	48 85 c0             	test   %rax,%rax
  801c77:	75 a6                	jne    801c1f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c79:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801c80:	00 00 00 
  801c83:	48 8b 00             	mov    (%rax),%rax
  801c86:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801c8c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c8f:	89 c6                	mov    %eax,%esi
  801c91:	48 bf 58 3a 80 00 00 	movabs $0x803a58,%rdi
  801c98:	00 00 00 
  801c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca0:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  801ca7:	00 00 00 
  801caa:	ff d1                	callq  *%rcx
	*dev = 0;
  801cac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cb0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801cb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801cbc:	c9                   	leaveq 
  801cbd:	c3                   	retq   

0000000000801cbe <close>:

int
close(int fdnum)
{
  801cbe:	55                   	push   %rbp
  801cbf:	48 89 e5             	mov    %rsp,%rbp
  801cc2:	48 83 ec 20          	sub    $0x20,%rsp
  801cc6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cc9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801ccd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cd0:	48 89 d6             	mov    %rdx,%rsi
  801cd3:	89 c7                	mov    %eax,%edi
  801cd5:	48 b8 ae 1a 80 00 00 	movabs $0x801aae,%rax
  801cdc:	00 00 00 
  801cdf:	ff d0                	callq  *%rax
  801ce1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ce4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ce8:	79 05                	jns    801cef <close+0x31>
		return r;
  801cea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ced:	eb 18                	jmp    801d07 <close+0x49>
	else
		return fd_close(fd, 1);
  801cef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf3:	be 01 00 00 00       	mov    $0x1,%esi
  801cf8:	48 89 c7             	mov    %rax,%rdi
  801cfb:	48 b8 3e 1b 80 00 00 	movabs $0x801b3e,%rax
  801d02:	00 00 00 
  801d05:	ff d0                	callq  *%rax
}
  801d07:	c9                   	leaveq 
  801d08:	c3                   	retq   

0000000000801d09 <close_all>:

void
close_all(void)
{
  801d09:	55                   	push   %rbp
  801d0a:	48 89 e5             	mov    %rsp,%rbp
  801d0d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801d11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d18:	eb 15                	jmp    801d2f <close_all+0x26>
		close(i);
  801d1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d1d:	89 c7                	mov    %eax,%edi
  801d1f:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  801d26:	00 00 00 
  801d29:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801d2b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d2f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d33:	7e e5                	jle    801d1a <close_all+0x11>
		close(i);
}
  801d35:	c9                   	leaveq 
  801d36:	c3                   	retq   

0000000000801d37 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d37:	55                   	push   %rbp
  801d38:	48 89 e5             	mov    %rsp,%rbp
  801d3b:	48 83 ec 40          	sub    $0x40,%rsp
  801d3f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801d42:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801d45:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801d49:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d4c:	48 89 d6             	mov    %rdx,%rsi
  801d4f:	89 c7                	mov    %eax,%edi
  801d51:	48 b8 ae 1a 80 00 00 	movabs $0x801aae,%rax
  801d58:	00 00 00 
  801d5b:	ff d0                	callq  *%rax
  801d5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d64:	79 08                	jns    801d6e <dup+0x37>
		return r;
  801d66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d69:	e9 70 01 00 00       	jmpq   801ede <dup+0x1a7>
	close(newfdnum);
  801d6e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d71:	89 c7                	mov    %eax,%edi
  801d73:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  801d7a:	00 00 00 
  801d7d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801d7f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d82:	48 98                	cltq   
  801d84:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d8a:	48 c1 e0 0c          	shl    $0xc,%rax
  801d8e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801d92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d96:	48 89 c7             	mov    %rax,%rdi
  801d99:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  801da0:	00 00 00 
  801da3:	ff d0                	callq  *%rax
  801da5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801da9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dad:	48 89 c7             	mov    %rax,%rdi
  801db0:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  801db7:	00 00 00 
  801dba:	ff d0                	callq  *%rax
  801dbc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801dc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc4:	48 c1 e8 15          	shr    $0x15,%rax
  801dc8:	48 89 c2             	mov    %rax,%rdx
  801dcb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801dd2:	01 00 00 
  801dd5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd9:	83 e0 01             	and    $0x1,%eax
  801ddc:	48 85 c0             	test   %rax,%rax
  801ddf:	74 73                	je     801e54 <dup+0x11d>
  801de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de5:	48 c1 e8 0c          	shr    $0xc,%rax
  801de9:	48 89 c2             	mov    %rax,%rdx
  801dec:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801df3:	01 00 00 
  801df6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dfa:	83 e0 01             	and    $0x1,%eax
  801dfd:	48 85 c0             	test   %rax,%rax
  801e00:	74 52                	je     801e54 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801e02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e06:	48 c1 e8 0c          	shr    $0xc,%rax
  801e0a:	48 89 c2             	mov    %rax,%rdx
  801e0d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e14:	01 00 00 
  801e17:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e1b:	25 07 0e 00 00       	and    $0xe07,%eax
  801e20:	89 c1                	mov    %eax,%ecx
  801e22:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2a:	41 89 c8             	mov    %ecx,%r8d
  801e2d:	48 89 d1             	mov    %rdx,%rcx
  801e30:	ba 00 00 00 00       	mov    $0x0,%edx
  801e35:	48 89 c6             	mov    %rax,%rsi
  801e38:	bf 00 00 00 00       	mov    $0x0,%edi
  801e3d:	48 b8 ab 17 80 00 00 	movabs $0x8017ab,%rax
  801e44:	00 00 00 
  801e47:	ff d0                	callq  *%rax
  801e49:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e4c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e50:	79 02                	jns    801e54 <dup+0x11d>
			goto err;
  801e52:	eb 57                	jmp    801eab <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801e54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e58:	48 c1 e8 0c          	shr    $0xc,%rax
  801e5c:	48 89 c2             	mov    %rax,%rdx
  801e5f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e66:	01 00 00 
  801e69:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6d:	25 07 0e 00 00       	and    $0xe07,%eax
  801e72:	89 c1                	mov    %eax,%ecx
  801e74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e7c:	41 89 c8             	mov    %ecx,%r8d
  801e7f:	48 89 d1             	mov    %rdx,%rcx
  801e82:	ba 00 00 00 00       	mov    $0x0,%edx
  801e87:	48 89 c6             	mov    %rax,%rsi
  801e8a:	bf 00 00 00 00       	mov    $0x0,%edi
  801e8f:	48 b8 ab 17 80 00 00 	movabs $0x8017ab,%rax
  801e96:	00 00 00 
  801e99:	ff d0                	callq  *%rax
  801e9b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ea2:	79 02                	jns    801ea6 <dup+0x16f>
		goto err;
  801ea4:	eb 05                	jmp    801eab <dup+0x174>

	return newfdnum;
  801ea6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ea9:	eb 33                	jmp    801ede <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801eab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eaf:	48 89 c6             	mov    %rax,%rsi
  801eb2:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb7:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  801ebe:	00 00 00 
  801ec1:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801ec3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ec7:	48 89 c6             	mov    %rax,%rsi
  801eca:	bf 00 00 00 00       	mov    $0x0,%edi
  801ecf:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  801ed6:	00 00 00 
  801ed9:	ff d0                	callq  *%rax
	return r;
  801edb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ede:	c9                   	leaveq 
  801edf:	c3                   	retq   

0000000000801ee0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ee0:	55                   	push   %rbp
  801ee1:	48 89 e5             	mov    %rsp,%rbp
  801ee4:	48 83 ec 40          	sub    $0x40,%rsp
  801ee8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801eeb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801eef:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ef3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801ef7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801efa:	48 89 d6             	mov    %rdx,%rsi
  801efd:	89 c7                	mov    %eax,%edi
  801eff:	48 b8 ae 1a 80 00 00 	movabs $0x801aae,%rax
  801f06:	00 00 00 
  801f09:	ff d0                	callq  *%rax
  801f0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f12:	78 24                	js     801f38 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f18:	8b 00                	mov    (%rax),%eax
  801f1a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f1e:	48 89 d6             	mov    %rdx,%rsi
  801f21:	89 c7                	mov    %eax,%edi
  801f23:	48 b8 07 1c 80 00 00 	movabs $0x801c07,%rax
  801f2a:	00 00 00 
  801f2d:	ff d0                	callq  *%rax
  801f2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f36:	79 05                	jns    801f3d <read+0x5d>
		return r;
  801f38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f3b:	eb 76                	jmp    801fb3 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f41:	8b 40 08             	mov    0x8(%rax),%eax
  801f44:	83 e0 03             	and    $0x3,%eax
  801f47:	83 f8 01             	cmp    $0x1,%eax
  801f4a:	75 3a                	jne    801f86 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801f4c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f53:	00 00 00 
  801f56:	48 8b 00             	mov    (%rax),%rax
  801f59:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f5f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801f62:	89 c6                	mov    %eax,%esi
  801f64:	48 bf 77 3a 80 00 00 	movabs $0x803a77,%rdi
  801f6b:	00 00 00 
  801f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f73:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  801f7a:	00 00 00 
  801f7d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801f7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f84:	eb 2d                	jmp    801fb3 <read+0xd3>
	}
	if (!dev->dev_read)
  801f86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8a:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f8e:	48 85 c0             	test   %rax,%rax
  801f91:	75 07                	jne    801f9a <read+0xba>
		return -E_NOT_SUPP;
  801f93:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801f98:	eb 19                	jmp    801fb3 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  801f9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f9e:	48 8b 40 10          	mov    0x10(%rax),%rax
  801fa2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801fa6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801faa:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  801fae:	48 89 cf             	mov    %rcx,%rdi
  801fb1:	ff d0                	callq  *%rax
}
  801fb3:	c9                   	leaveq 
  801fb4:	c3                   	retq   

0000000000801fb5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801fb5:	55                   	push   %rbp
  801fb6:	48 89 e5             	mov    %rsp,%rbp
  801fb9:	48 83 ec 30          	sub    $0x30,%rsp
  801fbd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801fc0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fc4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801fc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fcf:	eb 49                	jmp    80201a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd4:	48 98                	cltq   
  801fd6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fda:	48 29 c2             	sub    %rax,%rdx
  801fdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe0:	48 63 c8             	movslq %eax,%rcx
  801fe3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fe7:	48 01 c1             	add    %rax,%rcx
  801fea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fed:	48 89 ce             	mov    %rcx,%rsi
  801ff0:	89 c7                	mov    %eax,%edi
  801ff2:	48 b8 e0 1e 80 00 00 	movabs $0x801ee0,%rax
  801ff9:	00 00 00 
  801ffc:	ff d0                	callq  *%rax
  801ffe:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802001:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802005:	79 05                	jns    80200c <readn+0x57>
			return m;
  802007:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80200a:	eb 1c                	jmp    802028 <readn+0x73>
		if (m == 0)
  80200c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802010:	75 02                	jne    802014 <readn+0x5f>
			break;
  802012:	eb 11                	jmp    802025 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802014:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802017:	01 45 fc             	add    %eax,-0x4(%rbp)
  80201a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80201d:	48 98                	cltq   
  80201f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802023:	72 ac                	jb     801fd1 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802025:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802028:	c9                   	leaveq 
  802029:	c3                   	retq   

000000000080202a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80202a:	55                   	push   %rbp
  80202b:	48 89 e5             	mov    %rsp,%rbp
  80202e:	48 83 ec 40          	sub    $0x40,%rsp
  802032:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802035:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802039:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80203d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802041:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802044:	48 89 d6             	mov    %rdx,%rsi
  802047:	89 c7                	mov    %eax,%edi
  802049:	48 b8 ae 1a 80 00 00 	movabs $0x801aae,%rax
  802050:	00 00 00 
  802053:	ff d0                	callq  *%rax
  802055:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802058:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80205c:	78 24                	js     802082 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80205e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802062:	8b 00                	mov    (%rax),%eax
  802064:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802068:	48 89 d6             	mov    %rdx,%rsi
  80206b:	89 c7                	mov    %eax,%edi
  80206d:	48 b8 07 1c 80 00 00 	movabs $0x801c07,%rax
  802074:	00 00 00 
  802077:	ff d0                	callq  *%rax
  802079:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80207c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802080:	79 05                	jns    802087 <write+0x5d>
		return r;
  802082:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802085:	eb 75                	jmp    8020fc <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802087:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208b:	8b 40 08             	mov    0x8(%rax),%eax
  80208e:	83 e0 03             	and    $0x3,%eax
  802091:	85 c0                	test   %eax,%eax
  802093:	75 3a                	jne    8020cf <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802095:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80209c:	00 00 00 
  80209f:	48 8b 00             	mov    (%rax),%rax
  8020a2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020a8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020ab:	89 c6                	mov    %eax,%esi
  8020ad:	48 bf 93 3a 80 00 00 	movabs $0x803a93,%rdi
  8020b4:	00 00 00 
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bc:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  8020c3:	00 00 00 
  8020c6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020cd:	eb 2d                	jmp    8020fc <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020d3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020d7:	48 85 c0             	test   %rax,%rax
  8020da:	75 07                	jne    8020e3 <write+0xb9>
		return -E_NOT_SUPP;
  8020dc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020e1:	eb 19                	jmp    8020fc <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8020e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8020eb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8020ef:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8020f3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8020f7:	48 89 cf             	mov    %rcx,%rdi
  8020fa:	ff d0                	callq  *%rax
}
  8020fc:	c9                   	leaveq 
  8020fd:	c3                   	retq   

00000000008020fe <seek>:

int
seek(int fdnum, off_t offset)
{
  8020fe:	55                   	push   %rbp
  8020ff:	48 89 e5             	mov    %rsp,%rbp
  802102:	48 83 ec 18          	sub    $0x18,%rsp
  802106:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802109:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80210c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802110:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802113:	48 89 d6             	mov    %rdx,%rsi
  802116:	89 c7                	mov    %eax,%edi
  802118:	48 b8 ae 1a 80 00 00 	movabs $0x801aae,%rax
  80211f:	00 00 00 
  802122:	ff d0                	callq  *%rax
  802124:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802127:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80212b:	79 05                	jns    802132 <seek+0x34>
		return r;
  80212d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802130:	eb 0f                	jmp    802141 <seek+0x43>
	fd->fd_offset = offset;
  802132:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802136:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802139:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802141:	c9                   	leaveq 
  802142:	c3                   	retq   

0000000000802143 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802143:	55                   	push   %rbp
  802144:	48 89 e5             	mov    %rsp,%rbp
  802147:	48 83 ec 30          	sub    $0x30,%rsp
  80214b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80214e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802151:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802155:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802158:	48 89 d6             	mov    %rdx,%rsi
  80215b:	89 c7                	mov    %eax,%edi
  80215d:	48 b8 ae 1a 80 00 00 	movabs $0x801aae,%rax
  802164:	00 00 00 
  802167:	ff d0                	callq  *%rax
  802169:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80216c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802170:	78 24                	js     802196 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802172:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802176:	8b 00                	mov    (%rax),%eax
  802178:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80217c:	48 89 d6             	mov    %rdx,%rsi
  80217f:	89 c7                	mov    %eax,%edi
  802181:	48 b8 07 1c 80 00 00 	movabs $0x801c07,%rax
  802188:	00 00 00 
  80218b:	ff d0                	callq  *%rax
  80218d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802190:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802194:	79 05                	jns    80219b <ftruncate+0x58>
		return r;
  802196:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802199:	eb 72                	jmp    80220d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80219b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80219f:	8b 40 08             	mov    0x8(%rax),%eax
  8021a2:	83 e0 03             	and    $0x3,%eax
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	75 3a                	jne    8021e3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8021a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021b0:	00 00 00 
  8021b3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021b6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021bc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021bf:	89 c6                	mov    %eax,%esi
  8021c1:	48 bf b0 3a 80 00 00 	movabs $0x803ab0,%rdi
  8021c8:	00 00 00 
  8021cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d0:	48 b9 77 02 80 00 00 	movabs $0x800277,%rcx
  8021d7:	00 00 00 
  8021da:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8021dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021e1:	eb 2a                	jmp    80220d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8021e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8021eb:	48 85 c0             	test   %rax,%rax
  8021ee:	75 07                	jne    8021f7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8021f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021f5:	eb 16                	jmp    80220d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8021f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021fb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8021ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802203:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802206:	89 ce                	mov    %ecx,%esi
  802208:	48 89 d7             	mov    %rdx,%rdi
  80220b:	ff d0                	callq  *%rax
}
  80220d:	c9                   	leaveq 
  80220e:	c3                   	retq   

000000000080220f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80220f:	55                   	push   %rbp
  802210:	48 89 e5             	mov    %rsp,%rbp
  802213:	48 83 ec 30          	sub    $0x30,%rsp
  802217:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80221a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80221e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802222:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802225:	48 89 d6             	mov    %rdx,%rsi
  802228:	89 c7                	mov    %eax,%edi
  80222a:	48 b8 ae 1a 80 00 00 	movabs $0x801aae,%rax
  802231:	00 00 00 
  802234:	ff d0                	callq  *%rax
  802236:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802239:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80223d:	78 24                	js     802263 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80223f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802243:	8b 00                	mov    (%rax),%eax
  802245:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802249:	48 89 d6             	mov    %rdx,%rsi
  80224c:	89 c7                	mov    %eax,%edi
  80224e:	48 b8 07 1c 80 00 00 	movabs $0x801c07,%rax
  802255:	00 00 00 
  802258:	ff d0                	callq  *%rax
  80225a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80225d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802261:	79 05                	jns    802268 <fstat+0x59>
		return r;
  802263:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802266:	eb 5e                	jmp    8022c6 <fstat+0xb7>
	if (!dev->dev_stat)
  802268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80226c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802270:	48 85 c0             	test   %rax,%rax
  802273:	75 07                	jne    80227c <fstat+0x6d>
		return -E_NOT_SUPP;
  802275:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80227a:	eb 4a                	jmp    8022c6 <fstat+0xb7>
	stat->st_name[0] = 0;
  80227c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802280:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802283:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802287:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80228e:	00 00 00 
	stat->st_isdir = 0;
  802291:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802295:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80229c:	00 00 00 
	stat->st_dev = dev;
  80229f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022a7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8022ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b2:	48 8b 40 28          	mov    0x28(%rax),%rax
  8022b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022ba:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8022be:	48 89 ce             	mov    %rcx,%rsi
  8022c1:	48 89 d7             	mov    %rdx,%rdi
  8022c4:	ff d0                	callq  *%rax
}
  8022c6:	c9                   	leaveq 
  8022c7:	c3                   	retq   

00000000008022c8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8022c8:	55                   	push   %rbp
  8022c9:	48 89 e5             	mov    %rsp,%rbp
  8022cc:	48 83 ec 20          	sub    $0x20,%rsp
  8022d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8022d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022dc:	be 00 00 00 00       	mov    $0x0,%esi
  8022e1:	48 89 c7             	mov    %rax,%rdi
  8022e4:	48 b8 b6 23 80 00 00 	movabs $0x8023b6,%rax
  8022eb:	00 00 00 
  8022ee:	ff d0                	callq  *%rax
  8022f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f7:	79 05                	jns    8022fe <stat+0x36>
		return fd;
  8022f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fc:	eb 2f                	jmp    80232d <stat+0x65>
	r = fstat(fd, stat);
  8022fe:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802302:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802305:	48 89 d6             	mov    %rdx,%rsi
  802308:	89 c7                	mov    %eax,%edi
  80230a:	48 b8 0f 22 80 00 00 	movabs $0x80220f,%rax
  802311:	00 00 00 
  802314:	ff d0                	callq  *%rax
  802316:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80231c:	89 c7                	mov    %eax,%edi
  80231e:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  802325:	00 00 00 
  802328:	ff d0                	callq  *%rax
	return r;
  80232a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80232d:	c9                   	leaveq 
  80232e:	c3                   	retq   

000000000080232f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80232f:	55                   	push   %rbp
  802330:	48 89 e5             	mov    %rsp,%rbp
  802333:	48 83 ec 10          	sub    $0x10,%rsp
  802337:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80233a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80233e:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802345:	00 00 00 
  802348:	8b 00                	mov    (%rax),%eax
  80234a:	85 c0                	test   %eax,%eax
  80234c:	75 1d                	jne    80236b <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80234e:	bf 01 00 00 00       	mov    $0x1,%edi
  802353:	48 b8 0c 34 80 00 00 	movabs $0x80340c,%rax
  80235a:	00 00 00 
  80235d:	ff d0                	callq  *%rax
  80235f:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802366:	00 00 00 
  802369:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80236b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802372:	00 00 00 
  802375:	8b 00                	mov    (%rax),%eax
  802377:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80237a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80237f:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802386:	00 00 00 
  802389:	89 c7                	mov    %eax,%edi
  80238b:	48 b8 6f 33 80 00 00 	movabs $0x80336f,%rax
  802392:	00 00 00 
  802395:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239b:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a0:	48 89 c6             	mov    %rax,%rsi
  8023a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8023a8:	48 b8 a9 32 80 00 00 	movabs $0x8032a9,%rax
  8023af:	00 00 00 
  8023b2:	ff d0                	callq  *%rax
}
  8023b4:	c9                   	leaveq 
  8023b5:	c3                   	retq   

00000000008023b6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8023b6:	55                   	push   %rbp
  8023b7:	48 89 e5             	mov    %rsp,%rbp
  8023ba:	48 83 ec 20          	sub    $0x20,%rsp
  8023be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8023c2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  8023c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023c9:	48 89 c7             	mov    %rax,%rdi
  8023cc:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  8023d3:	00 00 00 
  8023d6:	ff d0                	callq  *%rax
  8023d8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8023dd:	7e 0a                	jle    8023e9 <open+0x33>
  8023df:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8023e4:	e9 a5 00 00 00       	jmpq   80248e <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8023e9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8023ed:	48 89 c7             	mov    %rax,%rdi
  8023f0:	48 b8 16 1a 80 00 00 	movabs $0x801a16,%rax
  8023f7:	00 00 00 
  8023fa:	ff d0                	callq  *%rax
  8023fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802403:	79 08                	jns    80240d <open+0x57>
		return r;
  802405:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802408:	e9 81 00 00 00       	jmpq   80248e <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  80240d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802414:	00 00 00 
  802417:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80241a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802420:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802424:	48 89 c6             	mov    %rax,%rsi
  802427:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80242e:	00 00 00 
  802431:	48 b8 2c 0e 80 00 00 	movabs $0x800e2c,%rax
  802438:	00 00 00 
  80243b:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  80243d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802441:	48 89 c6             	mov    %rax,%rsi
  802444:	bf 01 00 00 00       	mov    $0x1,%edi
  802449:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  802450:	00 00 00 
  802453:	ff d0                	callq  *%rax
  802455:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802458:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245c:	79 1d                	jns    80247b <open+0xc5>
		fd_close(fd, 0);
  80245e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802462:	be 00 00 00 00       	mov    $0x0,%esi
  802467:	48 89 c7             	mov    %rax,%rdi
  80246a:	48 b8 3e 1b 80 00 00 	movabs $0x801b3e,%rax
  802471:	00 00 00 
  802474:	ff d0                	callq  *%rax
		return r;
  802476:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802479:	eb 13                	jmp    80248e <open+0xd8>
	}
	return fd2num(fd);
  80247b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80247f:	48 89 c7             	mov    %rax,%rdi
  802482:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  802489:	00 00 00 
  80248c:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  80248e:	c9                   	leaveq 
  80248f:	c3                   	retq   

0000000000802490 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802490:	55                   	push   %rbp
  802491:	48 89 e5             	mov    %rsp,%rbp
  802494:	48 83 ec 10          	sub    $0x10,%rsp
  802498:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80249c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a0:	8b 50 0c             	mov    0xc(%rax),%edx
  8024a3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024aa:	00 00 00 
  8024ad:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8024af:	be 00 00 00 00       	mov    $0x0,%esi
  8024b4:	bf 06 00 00 00       	mov    $0x6,%edi
  8024b9:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  8024c0:	00 00 00 
  8024c3:	ff d0                	callq  *%rax
}
  8024c5:	c9                   	leaveq 
  8024c6:	c3                   	retq   

00000000008024c7 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8024c7:	55                   	push   %rbp
  8024c8:	48 89 e5             	mov    %rsp,%rbp
  8024cb:	48 83 ec 30          	sub    $0x30,%rsp
  8024cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8024d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8024d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024df:	8b 50 0c             	mov    0xc(%rax),%edx
  8024e2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024e9:	00 00 00 
  8024ec:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8024ee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024f5:	00 00 00 
  8024f8:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8024fc:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802500:	be 00 00 00 00       	mov    $0x0,%esi
  802505:	bf 03 00 00 00       	mov    $0x3,%edi
  80250a:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  802511:	00 00 00 
  802514:	ff d0                	callq  *%rax
  802516:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802519:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80251d:	79 05                	jns    802524 <devfile_read+0x5d>
		return r;
  80251f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802522:	eb 26                	jmp    80254a <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802524:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802527:	48 63 d0             	movslq %eax,%rdx
  80252a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80252e:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802535:	00 00 00 
  802538:	48 89 c7             	mov    %rax,%rdi
  80253b:	48 b8 67 12 80 00 00 	movabs $0x801267,%rax
  802542:	00 00 00 
  802545:	ff d0                	callq  *%rax
	return r;
  802547:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80254a:	c9                   	leaveq 
  80254b:	c3                   	retq   

000000000080254c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80254c:	55                   	push   %rbp
  80254d:	48 89 e5             	mov    %rsp,%rbp
  802550:	48 83 ec 30          	sub    $0x30,%rsp
  802554:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802558:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80255c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802560:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802567:	00 
	n = n > max ? max : n;
  802568:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80256c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802570:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802575:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80257d:	8b 50 0c             	mov    0xc(%rax),%edx
  802580:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802587:	00 00 00 
  80258a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80258c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802593:	00 00 00 
  802596:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80259a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80259e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025a6:	48 89 c6             	mov    %rax,%rsi
  8025a9:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8025b0:	00 00 00 
  8025b3:	48 b8 67 12 80 00 00 	movabs $0x801267,%rax
  8025ba:	00 00 00 
  8025bd:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  8025bf:	be 00 00 00 00       	mov    $0x0,%esi
  8025c4:	bf 04 00 00 00       	mov    $0x4,%edi
  8025c9:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  8025d0:	00 00 00 
  8025d3:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  8025d5:	c9                   	leaveq 
  8025d6:	c3                   	retq   

00000000008025d7 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8025d7:	55                   	push   %rbp
  8025d8:	48 89 e5             	mov    %rsp,%rbp
  8025db:	48 83 ec 20          	sub    $0x20,%rsp
  8025df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8025e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025eb:	8b 50 0c             	mov    0xc(%rax),%edx
  8025ee:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025f5:	00 00 00 
  8025f8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8025fa:	be 00 00 00 00       	mov    $0x0,%esi
  8025ff:	bf 05 00 00 00       	mov    $0x5,%edi
  802604:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  80260b:	00 00 00 
  80260e:	ff d0                	callq  *%rax
  802610:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802613:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802617:	79 05                	jns    80261e <devfile_stat+0x47>
		return r;
  802619:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261c:	eb 56                	jmp    802674 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80261e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802622:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802629:	00 00 00 
  80262c:	48 89 c7             	mov    %rax,%rdi
  80262f:	48 b8 2c 0e 80 00 00 	movabs $0x800e2c,%rax
  802636:	00 00 00 
  802639:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80263b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802642:	00 00 00 
  802645:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80264b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80264f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802655:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80265c:	00 00 00 
  80265f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802665:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802669:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80266f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802674:	c9                   	leaveq 
  802675:	c3                   	retq   

0000000000802676 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802676:	55                   	push   %rbp
  802677:	48 89 e5             	mov    %rsp,%rbp
  80267a:	48 83 ec 10          	sub    $0x10,%rsp
  80267e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802682:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802689:	8b 50 0c             	mov    0xc(%rax),%edx
  80268c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802693:	00 00 00 
  802696:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802698:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80269f:	00 00 00 
  8026a2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8026a5:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8026a8:	be 00 00 00 00       	mov    $0x0,%esi
  8026ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8026b2:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  8026b9:	00 00 00 
  8026bc:	ff d0                	callq  *%rax
}
  8026be:	c9                   	leaveq 
  8026bf:	c3                   	retq   

00000000008026c0 <remove>:

// Delete a file
int
remove(const char *path)
{
  8026c0:	55                   	push   %rbp
  8026c1:	48 89 e5             	mov    %rsp,%rbp
  8026c4:	48 83 ec 10          	sub    $0x10,%rsp
  8026c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8026cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026d0:	48 89 c7             	mov    %rax,%rdi
  8026d3:	48 b8 c0 0d 80 00 00 	movabs $0x800dc0,%rax
  8026da:	00 00 00 
  8026dd:	ff d0                	callq  *%rax
  8026df:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8026e4:	7e 07                	jle    8026ed <remove+0x2d>
		return -E_BAD_PATH;
  8026e6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026eb:	eb 33                	jmp    802720 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8026ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f1:	48 89 c6             	mov    %rax,%rsi
  8026f4:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8026fb:	00 00 00 
  8026fe:	48 b8 2c 0e 80 00 00 	movabs $0x800e2c,%rax
  802705:	00 00 00 
  802708:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80270a:	be 00 00 00 00       	mov    $0x0,%esi
  80270f:	bf 07 00 00 00       	mov    $0x7,%edi
  802714:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  80271b:	00 00 00 
  80271e:	ff d0                	callq  *%rax
}
  802720:	c9                   	leaveq 
  802721:	c3                   	retq   

0000000000802722 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802722:	55                   	push   %rbp
  802723:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802726:	be 00 00 00 00       	mov    $0x0,%esi
  80272b:	bf 08 00 00 00       	mov    $0x8,%edi
  802730:	48 b8 2f 23 80 00 00 	movabs $0x80232f,%rax
  802737:	00 00 00 
  80273a:	ff d0                	callq  *%rax
}
  80273c:	5d                   	pop    %rbp
  80273d:	c3                   	retq   

000000000080273e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80273e:	55                   	push   %rbp
  80273f:	48 89 e5             	mov    %rsp,%rbp
  802742:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802749:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802750:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802757:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80275e:	be 00 00 00 00       	mov    $0x0,%esi
  802763:	48 89 c7             	mov    %rax,%rdi
  802766:	48 b8 b6 23 80 00 00 	movabs $0x8023b6,%rax
  80276d:	00 00 00 
  802770:	ff d0                	callq  *%rax
  802772:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802775:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802779:	79 28                	jns    8027a3 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80277b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277e:	89 c6                	mov    %eax,%esi
  802780:	48 bf d6 3a 80 00 00 	movabs $0x803ad6,%rdi
  802787:	00 00 00 
  80278a:	b8 00 00 00 00       	mov    $0x0,%eax
  80278f:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
  802796:	00 00 00 
  802799:	ff d2                	callq  *%rdx
		return fd_src;
  80279b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279e:	e9 74 01 00 00       	jmpq   802917 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8027a3:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8027aa:	be 01 01 00 00       	mov    $0x101,%esi
  8027af:	48 89 c7             	mov    %rax,%rdi
  8027b2:	48 b8 b6 23 80 00 00 	movabs $0x8023b6,%rax
  8027b9:	00 00 00 
  8027bc:	ff d0                	callq  *%rax
  8027be:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8027c1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027c5:	79 39                	jns    802800 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8027c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027ca:	89 c6                	mov    %eax,%esi
  8027cc:	48 bf ec 3a 80 00 00 	movabs $0x803aec,%rdi
  8027d3:	00 00 00 
  8027d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027db:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
  8027e2:	00 00 00 
  8027e5:	ff d2                	callq  *%rdx
		close(fd_src);
  8027e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ea:	89 c7                	mov    %eax,%edi
  8027ec:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  8027f3:	00 00 00 
  8027f6:	ff d0                	callq  *%rax
		return fd_dest;
  8027f8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027fb:	e9 17 01 00 00       	jmpq   802917 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802800:	eb 74                	jmp    802876 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802802:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802805:	48 63 d0             	movslq %eax,%rdx
  802808:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80280f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802812:	48 89 ce             	mov    %rcx,%rsi
  802815:	89 c7                	mov    %eax,%edi
  802817:	48 b8 2a 20 80 00 00 	movabs $0x80202a,%rax
  80281e:	00 00 00 
  802821:	ff d0                	callq  *%rax
  802823:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802826:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80282a:	79 4a                	jns    802876 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80282c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80282f:	89 c6                	mov    %eax,%esi
  802831:	48 bf 06 3b 80 00 00 	movabs $0x803b06,%rdi
  802838:	00 00 00 
  80283b:	b8 00 00 00 00       	mov    $0x0,%eax
  802840:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
  802847:	00 00 00 
  80284a:	ff d2                	callq  *%rdx
			close(fd_src);
  80284c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80284f:	89 c7                	mov    %eax,%edi
  802851:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  802858:	00 00 00 
  80285b:	ff d0                	callq  *%rax
			close(fd_dest);
  80285d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802860:	89 c7                	mov    %eax,%edi
  802862:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  802869:	00 00 00 
  80286c:	ff d0                	callq  *%rax
			return write_size;
  80286e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802871:	e9 a1 00 00 00       	jmpq   802917 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802876:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80287d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802880:	ba 00 02 00 00       	mov    $0x200,%edx
  802885:	48 89 ce             	mov    %rcx,%rsi
  802888:	89 c7                	mov    %eax,%edi
  80288a:	48 b8 e0 1e 80 00 00 	movabs $0x801ee0,%rax
  802891:	00 00 00 
  802894:	ff d0                	callq  *%rax
  802896:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802899:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80289d:	0f 8f 5f ff ff ff    	jg     802802 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8028a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8028a7:	79 47                	jns    8028f0 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  8028a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028ac:	89 c6                	mov    %eax,%esi
  8028ae:	48 bf 19 3b 80 00 00 	movabs $0x803b19,%rdi
  8028b5:	00 00 00 
  8028b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028bd:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
  8028c4:	00 00 00 
  8028c7:	ff d2                	callq  *%rdx
		close(fd_src);
  8028c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cc:	89 c7                	mov    %eax,%edi
  8028ce:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  8028d5:	00 00 00 
  8028d8:	ff d0                	callq  *%rax
		close(fd_dest);
  8028da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028dd:	89 c7                	mov    %eax,%edi
  8028df:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  8028e6:	00 00 00 
  8028e9:	ff d0                	callq  *%rax
		return read_size;
  8028eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8028ee:	eb 27                	jmp    802917 <copy+0x1d9>
	}
	close(fd_src);
  8028f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028f3:	89 c7                	mov    %eax,%edi
  8028f5:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  8028fc:	00 00 00 
  8028ff:	ff d0                	callq  *%rax
	close(fd_dest);
  802901:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802904:	89 c7                	mov    %eax,%edi
  802906:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  80290d:	00 00 00 
  802910:	ff d0                	callq  *%rax
	return 0;
  802912:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802917:	c9                   	leaveq 
  802918:	c3                   	retq   

0000000000802919 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802919:	55                   	push   %rbp
  80291a:	48 89 e5             	mov    %rsp,%rbp
  80291d:	53                   	push   %rbx
  80291e:	48 83 ec 38          	sub    $0x38,%rsp
  802922:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802926:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80292a:	48 89 c7             	mov    %rax,%rdi
  80292d:	48 b8 16 1a 80 00 00 	movabs $0x801a16,%rax
  802934:	00 00 00 
  802937:	ff d0                	callq  *%rax
  802939:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80293c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802940:	0f 88 bf 01 00 00    	js     802b05 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802946:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80294a:	ba 07 04 00 00       	mov    $0x407,%edx
  80294f:	48 89 c6             	mov    %rax,%rsi
  802952:	bf 00 00 00 00       	mov    $0x0,%edi
  802957:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  80295e:	00 00 00 
  802961:	ff d0                	callq  *%rax
  802963:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802966:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80296a:	0f 88 95 01 00 00    	js     802b05 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802970:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802974:	48 89 c7             	mov    %rax,%rdi
  802977:	48 b8 16 1a 80 00 00 	movabs $0x801a16,%rax
  80297e:	00 00 00 
  802981:	ff d0                	callq  *%rax
  802983:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802986:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80298a:	0f 88 5d 01 00 00    	js     802aed <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802990:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802994:	ba 07 04 00 00       	mov    $0x407,%edx
  802999:	48 89 c6             	mov    %rax,%rsi
  80299c:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a1:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  8029a8:	00 00 00 
  8029ab:	ff d0                	callq  *%rax
  8029ad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029b4:	0f 88 33 01 00 00    	js     802aed <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8029ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029be:	48 89 c7             	mov    %rax,%rdi
  8029c1:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  8029c8:	00 00 00 
  8029cb:	ff d0                	callq  *%rax
  8029cd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029d5:	ba 07 04 00 00       	mov    $0x407,%edx
  8029da:	48 89 c6             	mov    %rax,%rsi
  8029dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8029e2:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  8029e9:	00 00 00 
  8029ec:	ff d0                	callq  *%rax
  8029ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029f5:	79 05                	jns    8029fc <pipe+0xe3>
		goto err2;
  8029f7:	e9 d9 00 00 00       	jmpq   802ad5 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a00:	48 89 c7             	mov    %rax,%rdi
  802a03:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  802a0a:	00 00 00 
  802a0d:	ff d0                	callq  *%rax
  802a0f:	48 89 c2             	mov    %rax,%rdx
  802a12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a16:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802a1c:	48 89 d1             	mov    %rdx,%rcx
  802a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a24:	48 89 c6             	mov    %rax,%rsi
  802a27:	bf 00 00 00 00       	mov    $0x0,%edi
  802a2c:	48 b8 ab 17 80 00 00 	movabs $0x8017ab,%rax
  802a33:	00 00 00 
  802a36:	ff d0                	callq  *%rax
  802a38:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a3f:	79 1b                	jns    802a5c <pipe+0x143>
		goto err3;
  802a41:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802a42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a46:	48 89 c6             	mov    %rax,%rsi
  802a49:	bf 00 00 00 00       	mov    $0x0,%edi
  802a4e:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  802a55:	00 00 00 
  802a58:	ff d0                	callq  *%rax
  802a5a:	eb 79                	jmp    802ad5 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802a5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a60:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802a67:	00 00 00 
  802a6a:	8b 12                	mov    (%rdx),%edx
  802a6c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802a6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802a79:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a7d:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802a84:	00 00 00 
  802a87:	8b 12                	mov    (%rdx),%edx
  802a89:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802a8b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a8f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802a96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a9a:	48 89 c7             	mov    %rax,%rdi
  802a9d:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  802aa4:	00 00 00 
  802aa7:	ff d0                	callq  *%rax
  802aa9:	89 c2                	mov    %eax,%edx
  802aab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802aaf:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802ab1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ab5:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802ab9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802abd:	48 89 c7             	mov    %rax,%rdi
  802ac0:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  802ac7:	00 00 00 
  802aca:	ff d0                	callq  *%rax
  802acc:	89 03                	mov    %eax,(%rbx)
	return 0;
  802ace:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad3:	eb 33                	jmp    802b08 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802ad5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ad9:	48 89 c6             	mov    %rax,%rsi
  802adc:	bf 00 00 00 00       	mov    $0x0,%edi
  802ae1:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  802ae8:	00 00 00 
  802aeb:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802aed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802af1:	48 89 c6             	mov    %rax,%rsi
  802af4:	bf 00 00 00 00       	mov    $0x0,%edi
  802af9:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  802b00:	00 00 00 
  802b03:	ff d0                	callq  *%rax
err:
	return r;
  802b05:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802b08:	48 83 c4 38          	add    $0x38,%rsp
  802b0c:	5b                   	pop    %rbx
  802b0d:	5d                   	pop    %rbp
  802b0e:	c3                   	retq   

0000000000802b0f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802b0f:	55                   	push   %rbp
  802b10:	48 89 e5             	mov    %rsp,%rbp
  802b13:	53                   	push   %rbx
  802b14:	48 83 ec 28          	sub    $0x28,%rsp
  802b18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b1c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802b20:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802b27:	00 00 00 
  802b2a:	48 8b 00             	mov    (%rax),%rax
  802b2d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802b33:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802b36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b3a:	48 89 c7             	mov    %rax,%rdi
  802b3d:	48 b8 8e 34 80 00 00 	movabs $0x80348e,%rax
  802b44:	00 00 00 
  802b47:	ff d0                	callq  *%rax
  802b49:	89 c3                	mov    %eax,%ebx
  802b4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b4f:	48 89 c7             	mov    %rax,%rdi
  802b52:	48 b8 8e 34 80 00 00 	movabs $0x80348e,%rax
  802b59:	00 00 00 
  802b5c:	ff d0                	callq  *%rax
  802b5e:	39 c3                	cmp    %eax,%ebx
  802b60:	0f 94 c0             	sete   %al
  802b63:	0f b6 c0             	movzbl %al,%eax
  802b66:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802b69:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802b70:	00 00 00 
  802b73:	48 8b 00             	mov    (%rax),%rax
  802b76:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802b7c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802b7f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b82:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802b85:	75 05                	jne    802b8c <_pipeisclosed+0x7d>
			return ret;
  802b87:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b8a:	eb 4f                	jmp    802bdb <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802b8c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b8f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802b92:	74 42                	je     802bd6 <_pipeisclosed+0xc7>
  802b94:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802b98:	75 3c                	jne    802bd6 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802b9a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802ba1:	00 00 00 
  802ba4:	48 8b 00             	mov    (%rax),%rax
  802ba7:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802bad:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802bb0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bb3:	89 c6                	mov    %eax,%esi
  802bb5:	48 bf 34 3b 80 00 00 	movabs $0x803b34,%rdi
  802bbc:	00 00 00 
  802bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc4:	49 b8 77 02 80 00 00 	movabs $0x800277,%r8
  802bcb:	00 00 00 
  802bce:	41 ff d0             	callq  *%r8
	}
  802bd1:	e9 4a ff ff ff       	jmpq   802b20 <_pipeisclosed+0x11>
  802bd6:	e9 45 ff ff ff       	jmpq   802b20 <_pipeisclosed+0x11>
}
  802bdb:	48 83 c4 28          	add    $0x28,%rsp
  802bdf:	5b                   	pop    %rbx
  802be0:	5d                   	pop    %rbp
  802be1:	c3                   	retq   

0000000000802be2 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802be2:	55                   	push   %rbp
  802be3:	48 89 e5             	mov    %rsp,%rbp
  802be6:	48 83 ec 30          	sub    $0x30,%rsp
  802bea:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bf1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bf4:	48 89 d6             	mov    %rdx,%rsi
  802bf7:	89 c7                	mov    %eax,%edi
  802bf9:	48 b8 ae 1a 80 00 00 	movabs $0x801aae,%rax
  802c00:	00 00 00 
  802c03:	ff d0                	callq  *%rax
  802c05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c0c:	79 05                	jns    802c13 <pipeisclosed+0x31>
		return r;
  802c0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c11:	eb 31                	jmp    802c44 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802c13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c17:	48 89 c7             	mov    %rax,%rdi
  802c1a:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax
  802c26:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802c2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c32:	48 89 d6             	mov    %rdx,%rsi
  802c35:	48 89 c7             	mov    %rax,%rdi
  802c38:	48 b8 0f 2b 80 00 00 	movabs $0x802b0f,%rax
  802c3f:	00 00 00 
  802c42:	ff d0                	callq  *%rax
}
  802c44:	c9                   	leaveq 
  802c45:	c3                   	retq   

0000000000802c46 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802c46:	55                   	push   %rbp
  802c47:	48 89 e5             	mov    %rsp,%rbp
  802c4a:	48 83 ec 40          	sub    $0x40,%rsp
  802c4e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c52:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c56:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c5e:	48 89 c7             	mov    %rax,%rdi
  802c61:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  802c68:	00 00 00 
  802c6b:	ff d0                	callq  *%rax
  802c6d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802c71:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802c79:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802c80:	00 
  802c81:	e9 92 00 00 00       	jmpq   802d18 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802c86:	eb 41                	jmp    802cc9 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802c88:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802c8d:	74 09                	je     802c98 <devpipe_read+0x52>
				return i;
  802c8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c93:	e9 92 00 00 00       	jmpq   802d2a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802c98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c9c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ca0:	48 89 d6             	mov    %rdx,%rsi
  802ca3:	48 89 c7             	mov    %rax,%rdi
  802ca6:	48 b8 0f 2b 80 00 00 	movabs $0x802b0f,%rax
  802cad:	00 00 00 
  802cb0:	ff d0                	callq  *%rax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	74 07                	je     802cbd <devpipe_read+0x77>
				return 0;
  802cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbb:	eb 6d                	jmp    802d2a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802cbd:	48 b8 1d 17 80 00 00 	movabs $0x80171d,%rax
  802cc4:	00 00 00 
  802cc7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802cc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ccd:	8b 10                	mov    (%rax),%edx
  802ccf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd3:	8b 40 04             	mov    0x4(%rax),%eax
  802cd6:	39 c2                	cmp    %eax,%edx
  802cd8:	74 ae                	je     802c88 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802cda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cde:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ce2:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802ce6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cea:	8b 00                	mov    (%rax),%eax
  802cec:	99                   	cltd   
  802ced:	c1 ea 1b             	shr    $0x1b,%edx
  802cf0:	01 d0                	add    %edx,%eax
  802cf2:	83 e0 1f             	and    $0x1f,%eax
  802cf5:	29 d0                	sub    %edx,%eax
  802cf7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cfb:	48 98                	cltq   
  802cfd:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802d02:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d08:	8b 00                	mov    (%rax),%eax
  802d0a:	8d 50 01             	lea    0x1(%rax),%edx
  802d0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d11:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d13:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d1c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802d20:	0f 82 60 ff ff ff    	jb     802c86 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802d26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d2a:	c9                   	leaveq 
  802d2b:	c3                   	retq   

0000000000802d2c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802d2c:	55                   	push   %rbp
  802d2d:	48 89 e5             	mov    %rsp,%rbp
  802d30:	48 83 ec 40          	sub    $0x40,%rsp
  802d34:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d38:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d3c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802d40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d44:	48 89 c7             	mov    %rax,%rdi
  802d47:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  802d4e:	00 00 00 
  802d51:	ff d0                	callq  *%rax
  802d53:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802d57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d5b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802d5f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d66:	00 
  802d67:	e9 8e 00 00 00       	jmpq   802dfa <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802d6c:	eb 31                	jmp    802d9f <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802d6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d76:	48 89 d6             	mov    %rdx,%rsi
  802d79:	48 89 c7             	mov    %rax,%rdi
  802d7c:	48 b8 0f 2b 80 00 00 	movabs $0x802b0f,%rax
  802d83:	00 00 00 
  802d86:	ff d0                	callq  *%rax
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	74 07                	je     802d93 <devpipe_write+0x67>
				return 0;
  802d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d91:	eb 79                	jmp    802e0c <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802d93:	48 b8 1d 17 80 00 00 	movabs $0x80171d,%rax
  802d9a:	00 00 00 
  802d9d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802d9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da3:	8b 40 04             	mov    0x4(%rax),%eax
  802da6:	48 63 d0             	movslq %eax,%rdx
  802da9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dad:	8b 00                	mov    (%rax),%eax
  802daf:	48 98                	cltq   
  802db1:	48 83 c0 20          	add    $0x20,%rax
  802db5:	48 39 c2             	cmp    %rax,%rdx
  802db8:	73 b4                	jae    802d6e <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802dba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dbe:	8b 40 04             	mov    0x4(%rax),%eax
  802dc1:	99                   	cltd   
  802dc2:	c1 ea 1b             	shr    $0x1b,%edx
  802dc5:	01 d0                	add    %edx,%eax
  802dc7:	83 e0 1f             	and    $0x1f,%eax
  802dca:	29 d0                	sub    %edx,%eax
  802dcc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802dd0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802dd4:	48 01 ca             	add    %rcx,%rdx
  802dd7:	0f b6 0a             	movzbl (%rdx),%ecx
  802dda:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dde:	48 98                	cltq   
  802de0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802de4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de8:	8b 40 04             	mov    0x4(%rax),%eax
  802deb:	8d 50 01             	lea    0x1(%rax),%edx
  802dee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df2:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802df5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802dfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dfe:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e02:	0f 82 64 ff ff ff    	jb     802d6c <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e0c:	c9                   	leaveq 
  802e0d:	c3                   	retq   

0000000000802e0e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802e0e:	55                   	push   %rbp
  802e0f:	48 89 e5             	mov    %rsp,%rbp
  802e12:	48 83 ec 20          	sub    $0x20,%rsp
  802e16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802e1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e22:	48 89 c7             	mov    %rax,%rdi
  802e25:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  802e2c:	00 00 00 
  802e2f:	ff d0                	callq  *%rax
  802e31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802e35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e39:	48 be 47 3b 80 00 00 	movabs $0x803b47,%rsi
  802e40:	00 00 00 
  802e43:	48 89 c7             	mov    %rax,%rdi
  802e46:	48 b8 2c 0e 80 00 00 	movabs $0x800e2c,%rax
  802e4d:	00 00 00 
  802e50:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802e52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e56:	8b 50 04             	mov    0x4(%rax),%edx
  802e59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e5d:	8b 00                	mov    (%rax),%eax
  802e5f:	29 c2                	sub    %eax,%edx
  802e61:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e65:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802e6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e6f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e76:	00 00 00 
	stat->st_dev = &devpipe;
  802e79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e7d:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802e84:	00 00 00 
  802e87:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e93:	c9                   	leaveq 
  802e94:	c3                   	retq   

0000000000802e95 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802e95:	55                   	push   %rbp
  802e96:	48 89 e5             	mov    %rsp,%rbp
  802e99:	48 83 ec 10          	sub    $0x10,%rsp
  802e9d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802ea1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea5:	48 89 c6             	mov    %rax,%rsi
  802ea8:	bf 00 00 00 00       	mov    $0x0,%edi
  802ead:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  802eb4:	00 00 00 
  802eb7:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802eb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ebd:	48 89 c7             	mov    %rax,%rdi
  802ec0:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  802ec7:	00 00 00 
  802eca:	ff d0                	callq  *%rax
  802ecc:	48 89 c6             	mov    %rax,%rsi
  802ecf:	bf 00 00 00 00       	mov    $0x0,%edi
  802ed4:	48 b8 06 18 80 00 00 	movabs $0x801806,%rax
  802edb:	00 00 00 
  802ede:	ff d0                	callq  *%rax
}
  802ee0:	c9                   	leaveq 
  802ee1:	c3                   	retq   

0000000000802ee2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802ee2:	55                   	push   %rbp
  802ee3:	48 89 e5             	mov    %rsp,%rbp
  802ee6:	48 83 ec 20          	sub    $0x20,%rsp
  802eea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802eed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ef0:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802ef3:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802ef7:	be 01 00 00 00       	mov    $0x1,%esi
  802efc:	48 89 c7             	mov    %rax,%rdi
  802eff:	48 b8 13 16 80 00 00 	movabs $0x801613,%rax
  802f06:	00 00 00 
  802f09:	ff d0                	callq  *%rax
}
  802f0b:	c9                   	leaveq 
  802f0c:	c3                   	retq   

0000000000802f0d <getchar>:

int
getchar(void)
{
  802f0d:	55                   	push   %rbp
  802f0e:	48 89 e5             	mov    %rsp,%rbp
  802f11:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802f15:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802f19:	ba 01 00 00 00       	mov    $0x1,%edx
  802f1e:	48 89 c6             	mov    %rax,%rsi
  802f21:	bf 00 00 00 00       	mov    $0x0,%edi
  802f26:	48 b8 e0 1e 80 00 00 	movabs $0x801ee0,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax
  802f32:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802f35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f39:	79 05                	jns    802f40 <getchar+0x33>
		return r;
  802f3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3e:	eb 14                	jmp    802f54 <getchar+0x47>
	if (r < 1)
  802f40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f44:	7f 07                	jg     802f4d <getchar+0x40>
		return -E_EOF;
  802f46:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802f4b:	eb 07                	jmp    802f54 <getchar+0x47>
	return c;
  802f4d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802f51:	0f b6 c0             	movzbl %al,%eax
}
  802f54:	c9                   	leaveq 
  802f55:	c3                   	retq   

0000000000802f56 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802f56:	55                   	push   %rbp
  802f57:	48 89 e5             	mov    %rsp,%rbp
  802f5a:	48 83 ec 20          	sub    $0x20,%rsp
  802f5e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f61:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f65:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f68:	48 89 d6             	mov    %rdx,%rsi
  802f6b:	89 c7                	mov    %eax,%edi
  802f6d:	48 b8 ae 1a 80 00 00 	movabs $0x801aae,%rax
  802f74:	00 00 00 
  802f77:	ff d0                	callq  *%rax
  802f79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f80:	79 05                	jns    802f87 <iscons+0x31>
		return r;
  802f82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f85:	eb 1a                	jmp    802fa1 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802f87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f8b:	8b 10                	mov    (%rax),%edx
  802f8d:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  802f94:	00 00 00 
  802f97:	8b 00                	mov    (%rax),%eax
  802f99:	39 c2                	cmp    %eax,%edx
  802f9b:	0f 94 c0             	sete   %al
  802f9e:	0f b6 c0             	movzbl %al,%eax
}
  802fa1:	c9                   	leaveq 
  802fa2:	c3                   	retq   

0000000000802fa3 <opencons>:

int
opencons(void)
{
  802fa3:	55                   	push   %rbp
  802fa4:	48 89 e5             	mov    %rsp,%rbp
  802fa7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802fab:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802faf:	48 89 c7             	mov    %rax,%rdi
  802fb2:	48 b8 16 1a 80 00 00 	movabs $0x801a16,%rax
  802fb9:	00 00 00 
  802fbc:	ff d0                	callq  *%rax
  802fbe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc5:	79 05                	jns    802fcc <opencons+0x29>
		return r;
  802fc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fca:	eb 5b                	jmp    803027 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802fcc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd0:	ba 07 04 00 00       	mov    $0x407,%edx
  802fd5:	48 89 c6             	mov    %rax,%rsi
  802fd8:	bf 00 00 00 00       	mov    $0x0,%edi
  802fdd:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  802fe4:	00 00 00 
  802fe7:	ff d0                	callq  *%rax
  802fe9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff0:	79 05                	jns    802ff7 <opencons+0x54>
		return r;
  802ff2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff5:	eb 30                	jmp    803027 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802ff7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffb:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803002:	00 00 00 
  803005:	8b 12                	mov    (%rdx),%edx
  803007:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803009:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803014:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803018:	48 89 c7             	mov    %rax,%rdi
  80301b:	48 b8 c8 19 80 00 00 	movabs $0x8019c8,%rax
  803022:	00 00 00 
  803025:	ff d0                	callq  *%rax
}
  803027:	c9                   	leaveq 
  803028:	c3                   	retq   

0000000000803029 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803029:	55                   	push   %rbp
  80302a:	48 89 e5             	mov    %rsp,%rbp
  80302d:	48 83 ec 30          	sub    $0x30,%rsp
  803031:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803035:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803039:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80303d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803042:	75 07                	jne    80304b <devcons_read+0x22>
		return 0;
  803044:	b8 00 00 00 00       	mov    $0x0,%eax
  803049:	eb 4b                	jmp    803096 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80304b:	eb 0c                	jmp    803059 <devcons_read+0x30>
		sys_yield();
  80304d:	48 b8 1d 17 80 00 00 	movabs $0x80171d,%rax
  803054:	00 00 00 
  803057:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803059:	48 b8 5d 16 80 00 00 	movabs $0x80165d,%rax
  803060:	00 00 00 
  803063:	ff d0                	callq  *%rax
  803065:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803068:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80306c:	74 df                	je     80304d <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80306e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803072:	79 05                	jns    803079 <devcons_read+0x50>
		return c;
  803074:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803077:	eb 1d                	jmp    803096 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803079:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80307d:	75 07                	jne    803086 <devcons_read+0x5d>
		return 0;
  80307f:	b8 00 00 00 00       	mov    $0x0,%eax
  803084:	eb 10                	jmp    803096 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803086:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803089:	89 c2                	mov    %eax,%edx
  80308b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80308f:	88 10                	mov    %dl,(%rax)
	return 1;
  803091:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803096:	c9                   	leaveq 
  803097:	c3                   	retq   

0000000000803098 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803098:	55                   	push   %rbp
  803099:	48 89 e5             	mov    %rsp,%rbp
  80309c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8030a3:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8030aa:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8030b1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8030b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8030bf:	eb 76                	jmp    803137 <devcons_write+0x9f>
		m = n - tot;
  8030c1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8030c8:	89 c2                	mov    %eax,%edx
  8030ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cd:	29 c2                	sub    %eax,%edx
  8030cf:	89 d0                	mov    %edx,%eax
  8030d1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8030d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030d7:	83 f8 7f             	cmp    $0x7f,%eax
  8030da:	76 07                	jbe    8030e3 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8030dc:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8030e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030e6:	48 63 d0             	movslq %eax,%rdx
  8030e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ec:	48 63 c8             	movslq %eax,%rcx
  8030ef:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8030f6:	48 01 c1             	add    %rax,%rcx
  8030f9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803100:	48 89 ce             	mov    %rcx,%rsi
  803103:	48 89 c7             	mov    %rax,%rdi
  803106:	48 b8 50 11 80 00 00 	movabs $0x801150,%rax
  80310d:	00 00 00 
  803110:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803112:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803115:	48 63 d0             	movslq %eax,%rdx
  803118:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80311f:	48 89 d6             	mov    %rdx,%rsi
  803122:	48 89 c7             	mov    %rax,%rdi
  803125:	48 b8 13 16 80 00 00 	movabs $0x801613,%rax
  80312c:	00 00 00 
  80312f:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803131:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803134:	01 45 fc             	add    %eax,-0x4(%rbp)
  803137:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313a:	48 98                	cltq   
  80313c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803143:	0f 82 78 ff ff ff    	jb     8030c1 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803149:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80314c:	c9                   	leaveq 
  80314d:	c3                   	retq   

000000000080314e <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80314e:	55                   	push   %rbp
  80314f:	48 89 e5             	mov    %rsp,%rbp
  803152:	48 83 ec 08          	sub    $0x8,%rsp
  803156:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80315a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80315f:	c9                   	leaveq 
  803160:	c3                   	retq   

0000000000803161 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803161:	55                   	push   %rbp
  803162:	48 89 e5             	mov    %rsp,%rbp
  803165:	48 83 ec 10          	sub    $0x10,%rsp
  803169:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80316d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803171:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803175:	48 be 53 3b 80 00 00 	movabs $0x803b53,%rsi
  80317c:	00 00 00 
  80317f:	48 89 c7             	mov    %rax,%rdi
  803182:	48 b8 2c 0e 80 00 00 	movabs $0x800e2c,%rax
  803189:	00 00 00 
  80318c:	ff d0                	callq  *%rax
	return 0;
  80318e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803193:	c9                   	leaveq 
  803194:	c3                   	retq   

0000000000803195 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803195:	55                   	push   %rbp
  803196:	48 89 e5             	mov    %rsp,%rbp
  803199:	53                   	push   %rbx
  80319a:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8031a1:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8031a8:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8031ae:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8031b5:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8031bc:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8031c3:	84 c0                	test   %al,%al
  8031c5:	74 23                	je     8031ea <_panic+0x55>
  8031c7:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8031ce:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8031d2:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8031d6:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8031da:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8031de:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8031e2:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8031e6:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8031ea:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8031f1:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8031f8:	00 00 00 
  8031fb:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803202:	00 00 00 
  803205:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803209:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803210:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803217:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80321e:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803225:	00 00 00 
  803228:	48 8b 18             	mov    (%rax),%rbx
  80322b:	48 b8 df 16 80 00 00 	movabs $0x8016df,%rax
  803232:	00 00 00 
  803235:	ff d0                	callq  *%rax
  803237:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80323d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803244:	41 89 c8             	mov    %ecx,%r8d
  803247:	48 89 d1             	mov    %rdx,%rcx
  80324a:	48 89 da             	mov    %rbx,%rdx
  80324d:	89 c6                	mov    %eax,%esi
  80324f:	48 bf 60 3b 80 00 00 	movabs $0x803b60,%rdi
  803256:	00 00 00 
  803259:	b8 00 00 00 00       	mov    $0x0,%eax
  80325e:	49 b9 77 02 80 00 00 	movabs $0x800277,%r9
  803265:	00 00 00 
  803268:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80326b:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803272:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803279:	48 89 d6             	mov    %rdx,%rsi
  80327c:	48 89 c7             	mov    %rax,%rdi
  80327f:	48 b8 cb 01 80 00 00 	movabs $0x8001cb,%rax
  803286:	00 00 00 
  803289:	ff d0                	callq  *%rax
	cprintf("\n");
  80328b:	48 bf 83 3b 80 00 00 	movabs $0x803b83,%rdi
  803292:	00 00 00 
  803295:	b8 00 00 00 00       	mov    $0x0,%eax
  80329a:	48 ba 77 02 80 00 00 	movabs $0x800277,%rdx
  8032a1:	00 00 00 
  8032a4:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8032a6:	cc                   	int3   
  8032a7:	eb fd                	jmp    8032a6 <_panic+0x111>

00000000008032a9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8032a9:	55                   	push   %rbp
  8032aa:	48 89 e5             	mov    %rsp,%rbp
  8032ad:	48 83 ec 30          	sub    $0x30,%rsp
  8032b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  8032bd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8032c2:	74 18                	je     8032dc <ipc_recv+0x33>
  8032c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032c8:	48 89 c7             	mov    %rax,%rdi
  8032cb:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  8032d2:	00 00 00 
  8032d5:	ff d0                	callq  *%rax
  8032d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032da:	eb 19                	jmp    8032f5 <ipc_recv+0x4c>
  8032dc:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8032e3:	00 00 00 
  8032e6:	48 b8 84 19 80 00 00 	movabs $0x801984,%rax
  8032ed:	00 00 00 
  8032f0:	ff d0                	callq  *%rax
  8032f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8032f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8032fa:	74 26                	je     803322 <ipc_recv+0x79>
  8032fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803300:	75 15                	jne    803317 <ipc_recv+0x6e>
  803302:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803309:	00 00 00 
  80330c:	48 8b 00             	mov    (%rax),%rax
  80330f:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803315:	eb 05                	jmp    80331c <ipc_recv+0x73>
  803317:	b8 00 00 00 00       	mov    $0x0,%eax
  80331c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803320:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803322:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803327:	74 26                	je     80334f <ipc_recv+0xa6>
  803329:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332d:	75 15                	jne    803344 <ipc_recv+0x9b>
  80332f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803336:	00 00 00 
  803339:	48 8b 00             	mov    (%rax),%rax
  80333c:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803342:	eb 05                	jmp    803349 <ipc_recv+0xa0>
  803344:	b8 00 00 00 00       	mov    $0x0,%eax
  803349:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80334d:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  80334f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803353:	75 15                	jne    80336a <ipc_recv+0xc1>
  803355:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80335c:	00 00 00 
  80335f:	48 8b 00             	mov    (%rax),%rax
  803362:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803368:	eb 03                	jmp    80336d <ipc_recv+0xc4>
  80336a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80336d:	c9                   	leaveq 
  80336e:	c3                   	retq   

000000000080336f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80336f:	55                   	push   %rbp
  803370:	48 89 e5             	mov    %rsp,%rbp
  803373:	48 83 ec 30          	sub    $0x30,%rsp
  803377:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80337a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80337d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803381:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803384:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  80338b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803390:	75 10                	jne    8033a2 <ipc_send+0x33>
  803392:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803399:	00 00 00 
  80339c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  8033a0:	eb 62                	jmp    803404 <ipc_send+0x95>
  8033a2:	eb 60                	jmp    803404 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  8033a4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8033a8:	74 30                	je     8033da <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  8033aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ad:	89 c1                	mov    %eax,%ecx
  8033af:	48 ba 85 3b 80 00 00 	movabs $0x803b85,%rdx
  8033b6:	00 00 00 
  8033b9:	be 33 00 00 00       	mov    $0x33,%esi
  8033be:	48 bf a1 3b 80 00 00 	movabs $0x803ba1,%rdi
  8033c5:	00 00 00 
  8033c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033cd:	49 b8 95 31 80 00 00 	movabs $0x803195,%r8
  8033d4:	00 00 00 
  8033d7:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  8033da:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8033dd:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8033e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033e7:	89 c7                	mov    %eax,%edi
  8033e9:	48 b8 2f 19 80 00 00 	movabs $0x80192f,%rax
  8033f0:	00 00 00 
  8033f3:	ff d0                	callq  *%rax
  8033f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8033f8:	48 b8 1d 17 80 00 00 	movabs $0x80171d,%rax
  8033ff:	00 00 00 
  803402:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803404:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803408:	75 9a                	jne    8033a4 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  80340a:	c9                   	leaveq 
  80340b:	c3                   	retq   

000000000080340c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80340c:	55                   	push   %rbp
  80340d:	48 89 e5             	mov    %rsp,%rbp
  803410:	48 83 ec 14          	sub    $0x14,%rsp
  803414:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803417:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80341e:	eb 5e                	jmp    80347e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803420:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803427:	00 00 00 
  80342a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80342d:	48 63 d0             	movslq %eax,%rdx
  803430:	48 89 d0             	mov    %rdx,%rax
  803433:	48 c1 e0 03          	shl    $0x3,%rax
  803437:	48 01 d0             	add    %rdx,%rax
  80343a:	48 c1 e0 05          	shl    $0x5,%rax
  80343e:	48 01 c8             	add    %rcx,%rax
  803441:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803447:	8b 00                	mov    (%rax),%eax
  803449:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80344c:	75 2c                	jne    80347a <ipc_find_env+0x6e>
			return envs[i].env_id;
  80344e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803455:	00 00 00 
  803458:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345b:	48 63 d0             	movslq %eax,%rdx
  80345e:	48 89 d0             	mov    %rdx,%rax
  803461:	48 c1 e0 03          	shl    $0x3,%rax
  803465:	48 01 d0             	add    %rdx,%rax
  803468:	48 c1 e0 05          	shl    $0x5,%rax
  80346c:	48 01 c8             	add    %rcx,%rax
  80346f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803475:	8b 40 08             	mov    0x8(%rax),%eax
  803478:	eb 12                	jmp    80348c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80347a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80347e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803485:	7e 99                	jle    803420 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803487:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80348c:	c9                   	leaveq 
  80348d:	c3                   	retq   

000000000080348e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80348e:	55                   	push   %rbp
  80348f:	48 89 e5             	mov    %rsp,%rbp
  803492:	48 83 ec 18          	sub    $0x18,%rsp
  803496:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80349a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80349e:	48 c1 e8 15          	shr    $0x15,%rax
  8034a2:	48 89 c2             	mov    %rax,%rdx
  8034a5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8034ac:	01 00 00 
  8034af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034b3:	83 e0 01             	and    $0x1,%eax
  8034b6:	48 85 c0             	test   %rax,%rax
  8034b9:	75 07                	jne    8034c2 <pageref+0x34>
		return 0;
  8034bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c0:	eb 53                	jmp    803515 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8034c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034c6:	48 c1 e8 0c          	shr    $0xc,%rax
  8034ca:	48 89 c2             	mov    %rax,%rdx
  8034cd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8034d4:	01 00 00 
  8034d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8034df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034e3:	83 e0 01             	and    $0x1,%eax
  8034e6:	48 85 c0             	test   %rax,%rax
  8034e9:	75 07                	jne    8034f2 <pageref+0x64>
		return 0;
  8034eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f0:	eb 23                	jmp    803515 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8034f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f6:	48 c1 e8 0c          	shr    $0xc,%rax
  8034fa:	48 89 c2             	mov    %rax,%rdx
  8034fd:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803504:	00 00 00 
  803507:	48 c1 e2 04          	shl    $0x4,%rdx
  80350b:	48 01 d0             	add    %rdx,%rax
  80350e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803512:	0f b7 c0             	movzwl %ax,%eax
}
  803515:	c9                   	leaveq 
  803516:	c3                   	retq   
