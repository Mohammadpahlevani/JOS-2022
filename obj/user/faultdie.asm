
obj/user/faultdie:     file format elf64-x86-64


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
  80003c:	e8 9c 00 00 00       	callq  8000dd <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  80005a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80005e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800062:	89 45 f4             	mov    %eax,-0xc(%rbp)
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800065:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800068:	83 e0 07             	and    $0x7,%eax
  80006b:	89 c2                	mov    %eax,%edx
  80006d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800071:	48 89 c6             	mov    %rax,%rsi
  800074:	48 bf 80 36 80 00 00 	movabs $0x803680,%rdi
  80007b:	00 00 00 
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	48 b9 b5 02 80 00 00 	movabs $0x8002b5,%rcx
  80008a:	00 00 00 
  80008d:	ff d1                	callq  *%rcx
	sys_env_destroy(sys_getenvid());
  80008f:	48 b8 1d 17 80 00 00 	movabs $0x80171d,%rax
  800096:	00 00 00 
  800099:	ff d0                	callq  *%rax
  80009b:	89 c7                	mov    %eax,%edi
  80009d:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  8000a4:	00 00 00 
  8000a7:	ff d0                	callq  *%rax
}
  8000a9:	c9                   	leaveq 
  8000aa:	c3                   	retq   

00000000008000ab <umain>:

void
umain(int argc, char **argv)
{
  8000ab:	55                   	push   %rbp
  8000ac:	48 89 e5             	mov    %rsp,%rbp
  8000af:	48 83 ec 10          	sub    $0x10,%rsp
  8000b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  8000ba:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  8000c1:	00 00 00 
  8000c4:	48 b8 06 1a 80 00 00 	movabs $0x801a06,%rax
  8000cb:	00 00 00 
  8000ce:	ff d0                	callq  *%rax
	*(int*)0xDeadBeef = 0;
  8000d0:	b8 ef be ad de       	mov    $0xdeadbeef,%eax
  8000d5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
  8000db:	c9                   	leaveq 
  8000dc:	c3                   	retq   

00000000008000dd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dd:	55                   	push   %rbp
  8000de:	48 89 e5             	mov    %rsp,%rbp
  8000e1:	48 83 ec 10          	sub    $0x10,%rsp
  8000e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  8000ec:	48 b8 1d 17 80 00 00 	movabs $0x80171d,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax
  8000f8:	48 98                	cltq   
  8000fa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ff:	48 89 c2             	mov    %rax,%rdx
  800102:	48 89 d0             	mov    %rdx,%rax
  800105:	48 c1 e0 03          	shl    $0x3,%rax
  800109:	48 01 d0             	add    %rdx,%rax
  80010c:	48 c1 e0 05          	shl    $0x5,%rax
  800110:	48 89 c2             	mov    %rax,%rdx
  800113:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80011a:	00 00 00 
  80011d:	48 01 c2             	add    %rax,%rdx
  800120:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800127:	00 00 00 
  80012a:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800131:	7e 14                	jle    800147 <libmain+0x6a>
		binaryname = argv[0];
  800133:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800137:	48 8b 10             	mov    (%rax),%rdx
  80013a:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800141:	00 00 00 
  800144:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800147:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80014b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80014e:	48 89 d6             	mov    %rdx,%rsi
  800151:	89 c7                	mov    %eax,%edi
  800153:	48 b8 ab 00 80 00 00 	movabs $0x8000ab,%rax
  80015a:	00 00 00 
  80015d:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80015f:	48 b8 6d 01 80 00 00 	movabs $0x80016d,%rax
  800166:	00 00 00 
  800169:	ff d0                	callq  *%rax
}
  80016b:	c9                   	leaveq 
  80016c:	c3                   	retq   

000000000080016d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016d:	55                   	push   %rbp
  80016e:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800171:	48 b8 66 1e 80 00 00 	movabs $0x801e66,%rax
  800178:	00 00 00 
  80017b:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  80017d:	bf 00 00 00 00       	mov    $0x0,%edi
  800182:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  800189:	00 00 00 
  80018c:	ff d0                	callq  *%rax
}
  80018e:	5d                   	pop    %rbp
  80018f:	c3                   	retq   

0000000000800190 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800190:	55                   	push   %rbp
  800191:	48 89 e5             	mov    %rsp,%rbp
  800194:	48 83 ec 10          	sub    $0x10,%rsp
  800198:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80019b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80019f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a3:	8b 00                	mov    (%rax),%eax
  8001a5:	8d 48 01             	lea    0x1(%rax),%ecx
  8001a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ac:	89 0a                	mov    %ecx,(%rdx)
  8001ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001b1:	89 d1                	mov    %edx,%ecx
  8001b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b7:	48 98                	cltq   
  8001b9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c1:	8b 00                	mov    (%rax),%eax
  8001c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c8:	75 2c                	jne    8001f6 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8001ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ce:	8b 00                	mov    (%rax),%eax
  8001d0:	48 98                	cltq   
  8001d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d6:	48 83 c2 08          	add    $0x8,%rdx
  8001da:	48 89 c6             	mov    %rax,%rsi
  8001dd:	48 89 d7             	mov    %rdx,%rdi
  8001e0:	48 b8 51 16 80 00 00 	movabs $0x801651,%rax
  8001e7:	00 00 00 
  8001ea:	ff d0                	callq  *%rax
        b->idx = 0;
  8001ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8001f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001fa:	8b 40 04             	mov    0x4(%rax),%eax
  8001fd:	8d 50 01             	lea    0x1(%rax),%edx
  800200:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800204:	89 50 04             	mov    %edx,0x4(%rax)
}
  800207:	c9                   	leaveq 
  800208:	c3                   	retq   

0000000000800209 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800209:	55                   	push   %rbp
  80020a:	48 89 e5             	mov    %rsp,%rbp
  80020d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800214:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80021b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800222:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800229:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800230:	48 8b 0a             	mov    (%rdx),%rcx
  800233:	48 89 08             	mov    %rcx,(%rax)
  800236:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80023a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80023e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800242:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800246:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80024d:	00 00 00 
    b.cnt = 0;
  800250:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800257:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80025a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800261:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800268:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80026f:	48 89 c6             	mov    %rax,%rsi
  800272:	48 bf 90 01 80 00 00 	movabs $0x800190,%rdi
  800279:	00 00 00 
  80027c:	48 b8 68 06 80 00 00 	movabs $0x800668,%rax
  800283:	00 00 00 
  800286:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800288:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80028e:	48 98                	cltq   
  800290:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800297:	48 83 c2 08          	add    $0x8,%rdx
  80029b:	48 89 c6             	mov    %rax,%rsi
  80029e:	48 89 d7             	mov    %rdx,%rdi
  8002a1:	48 b8 51 16 80 00 00 	movabs $0x801651,%rax
  8002a8:	00 00 00 
  8002ab:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002b3:	c9                   	leaveq 
  8002b4:	c3                   	retq   

00000000008002b5 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002b5:	55                   	push   %rbp
  8002b6:	48 89 e5             	mov    %rsp,%rbp
  8002b9:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002c0:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002c7:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002ce:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002d5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8002dc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8002e3:	84 c0                	test   %al,%al
  8002e5:	74 20                	je     800307 <cprintf+0x52>
  8002e7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8002eb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8002ef:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8002f3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8002f7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8002fb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8002ff:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800303:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800307:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80030e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800315:	00 00 00 
  800318:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80031f:	00 00 00 
  800322:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800326:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80032d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800334:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80033b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800342:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800349:	48 8b 0a             	mov    (%rdx),%rcx
  80034c:	48 89 08             	mov    %rcx,(%rax)
  80034f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800353:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800357:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80035b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80035f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800366:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80036d:	48 89 d6             	mov    %rdx,%rsi
  800370:	48 89 c7             	mov    %rax,%rdi
  800373:	48 b8 09 02 80 00 00 	movabs $0x800209,%rax
  80037a:	00 00 00 
  80037d:	ff d0                	callq  *%rax
  80037f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800385:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80038b:	c9                   	leaveq 
  80038c:	c3                   	retq   

000000000080038d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80038d:	55                   	push   %rbp
  80038e:	48 89 e5             	mov    %rsp,%rbp
  800391:	53                   	push   %rbx
  800392:	48 83 ec 38          	sub    $0x38,%rsp
  800396:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80039a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80039e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003a2:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003a5:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003a9:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ad:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003b0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003b4:	77 3b                	ja     8003f1 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b6:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003b9:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003bd:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c9:	48 f7 f3             	div    %rbx
  8003cc:	48 89 c2             	mov    %rax,%rdx
  8003cf:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003d2:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003d5:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8003d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003dd:	41 89 f9             	mov    %edi,%r9d
  8003e0:	48 89 c7             	mov    %rax,%rdi
  8003e3:	48 b8 8d 03 80 00 00 	movabs $0x80038d,%rax
  8003ea:	00 00 00 
  8003ed:	ff d0                	callq  *%rax
  8003ef:	eb 1e                	jmp    80040f <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003f1:	eb 12                	jmp    800405 <printnum+0x78>
			putch(padc, putdat);
  8003f3:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003f7:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8003fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fe:	48 89 ce             	mov    %rcx,%rsi
  800401:	89 d7                	mov    %edx,%edi
  800403:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800405:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800409:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80040d:	7f e4                	jg     8003f3 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80040f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800416:	ba 00 00 00 00       	mov    $0x0,%edx
  80041b:	48 f7 f1             	div    %rcx
  80041e:	48 89 d0             	mov    %rdx,%rax
  800421:	48 ba b0 38 80 00 00 	movabs $0x8038b0,%rdx
  800428:	00 00 00 
  80042b:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80042f:	0f be d0             	movsbl %al,%edx
  800432:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800436:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043a:	48 89 ce             	mov    %rcx,%rsi
  80043d:	89 d7                	mov    %edx,%edi
  80043f:	ff d0                	callq  *%rax
}
  800441:	48 83 c4 38          	add    $0x38,%rsp
  800445:	5b                   	pop    %rbx
  800446:	5d                   	pop    %rbp
  800447:	c3                   	retq   

0000000000800448 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800448:	55                   	push   %rbp
  800449:	48 89 e5             	mov    %rsp,%rbp
  80044c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800450:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800454:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800457:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80045b:	7e 52                	jle    8004af <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80045d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800461:	8b 00                	mov    (%rax),%eax
  800463:	83 f8 30             	cmp    $0x30,%eax
  800466:	73 24                	jae    80048c <getuint+0x44>
  800468:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80046c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800470:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800474:	8b 00                	mov    (%rax),%eax
  800476:	89 c0                	mov    %eax,%eax
  800478:	48 01 d0             	add    %rdx,%rax
  80047b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80047f:	8b 12                	mov    (%rdx),%edx
  800481:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800484:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800488:	89 0a                	mov    %ecx,(%rdx)
  80048a:	eb 17                	jmp    8004a3 <getuint+0x5b>
  80048c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800490:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800494:	48 89 d0             	mov    %rdx,%rax
  800497:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80049b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80049f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004a3:	48 8b 00             	mov    (%rax),%rax
  8004a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004aa:	e9 a3 00 00 00       	jmpq   800552 <getuint+0x10a>
	else if (lflag)
  8004af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004b3:	74 4f                	je     800504 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b9:	8b 00                	mov    (%rax),%eax
  8004bb:	83 f8 30             	cmp    $0x30,%eax
  8004be:	73 24                	jae    8004e4 <getuint+0x9c>
  8004c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cc:	8b 00                	mov    (%rax),%eax
  8004ce:	89 c0                	mov    %eax,%eax
  8004d0:	48 01 d0             	add    %rdx,%rax
  8004d3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d7:	8b 12                	mov    (%rdx),%edx
  8004d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e0:	89 0a                	mov    %ecx,(%rdx)
  8004e2:	eb 17                	jmp    8004fb <getuint+0xb3>
  8004e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004ec:	48 89 d0             	mov    %rdx,%rax
  8004ef:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004fb:	48 8b 00             	mov    (%rax),%rax
  8004fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800502:	eb 4e                	jmp    800552 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800504:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800508:	8b 00                	mov    (%rax),%eax
  80050a:	83 f8 30             	cmp    $0x30,%eax
  80050d:	73 24                	jae    800533 <getuint+0xeb>
  80050f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800513:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051b:	8b 00                	mov    (%rax),%eax
  80051d:	89 c0                	mov    %eax,%eax
  80051f:	48 01 d0             	add    %rdx,%rax
  800522:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800526:	8b 12                	mov    (%rdx),%edx
  800528:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80052b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80052f:	89 0a                	mov    %ecx,(%rdx)
  800531:	eb 17                	jmp    80054a <getuint+0x102>
  800533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800537:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80053b:	48 89 d0             	mov    %rdx,%rax
  80053e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800542:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800546:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80054a:	8b 00                	mov    (%rax),%eax
  80054c:	89 c0                	mov    %eax,%eax
  80054e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800556:	c9                   	leaveq 
  800557:	c3                   	retq   

0000000000800558 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800558:	55                   	push   %rbp
  800559:	48 89 e5             	mov    %rsp,%rbp
  80055c:	48 83 ec 1c          	sub    $0x1c,%rsp
  800560:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800564:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800567:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80056b:	7e 52                	jle    8005bf <getint+0x67>
		x=va_arg(*ap, long long);
  80056d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800571:	8b 00                	mov    (%rax),%eax
  800573:	83 f8 30             	cmp    $0x30,%eax
  800576:	73 24                	jae    80059c <getint+0x44>
  800578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800584:	8b 00                	mov    (%rax),%eax
  800586:	89 c0                	mov    %eax,%eax
  800588:	48 01 d0             	add    %rdx,%rax
  80058b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80058f:	8b 12                	mov    (%rdx),%edx
  800591:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800594:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800598:	89 0a                	mov    %ecx,(%rdx)
  80059a:	eb 17                	jmp    8005b3 <getint+0x5b>
  80059c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a4:	48 89 d0             	mov    %rdx,%rax
  8005a7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b3:	48 8b 00             	mov    (%rax),%rax
  8005b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005ba:	e9 a3 00 00 00       	jmpq   800662 <getint+0x10a>
	else if (lflag)
  8005bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005c3:	74 4f                	je     800614 <getint+0xbc>
		x=va_arg(*ap, long);
  8005c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c9:	8b 00                	mov    (%rax),%eax
  8005cb:	83 f8 30             	cmp    $0x30,%eax
  8005ce:	73 24                	jae    8005f4 <getint+0x9c>
  8005d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dc:	8b 00                	mov    (%rax),%eax
  8005de:	89 c0                	mov    %eax,%eax
  8005e0:	48 01 d0             	add    %rdx,%rax
  8005e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e7:	8b 12                	mov    (%rdx),%edx
  8005e9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f0:	89 0a                	mov    %ecx,(%rdx)
  8005f2:	eb 17                	jmp    80060b <getint+0xb3>
  8005f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005fc:	48 89 d0             	mov    %rdx,%rax
  8005ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800603:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800607:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80060b:	48 8b 00             	mov    (%rax),%rax
  80060e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800612:	eb 4e                	jmp    800662 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	8b 00                	mov    (%rax),%eax
  80061a:	83 f8 30             	cmp    $0x30,%eax
  80061d:	73 24                	jae    800643 <getint+0xeb>
  80061f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800623:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80062b:	8b 00                	mov    (%rax),%eax
  80062d:	89 c0                	mov    %eax,%eax
  80062f:	48 01 d0             	add    %rdx,%rax
  800632:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800636:	8b 12                	mov    (%rdx),%edx
  800638:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80063b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80063f:	89 0a                	mov    %ecx,(%rdx)
  800641:	eb 17                	jmp    80065a <getint+0x102>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80064b:	48 89 d0             	mov    %rdx,%rax
  80064e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800656:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065a:	8b 00                	mov    (%rax),%eax
  80065c:	48 98                	cltq   
  80065e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800666:	c9                   	leaveq 
  800667:	c3                   	retq   

0000000000800668 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800668:	55                   	push   %rbp
  800669:	48 89 e5             	mov    %rsp,%rbp
  80066c:	41 54                	push   %r12
  80066e:	53                   	push   %rbx
  80066f:	48 83 ec 60          	sub    $0x60,%rsp
  800673:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800677:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80067b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80067f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800683:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800687:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80068b:	48 8b 0a             	mov    (%rdx),%rcx
  80068e:	48 89 08             	mov    %rcx,(%rax)
  800691:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800695:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800699:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80069d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a1:	eb 17                	jmp    8006ba <vprintfmt+0x52>
			if (ch == '\0')
  8006a3:	85 db                	test   %ebx,%ebx
  8006a5:	0f 84 cc 04 00 00    	je     800b77 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8006ab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006b3:	48 89 d6             	mov    %rdx,%rsi
  8006b6:	89 df                	mov    %ebx,%edi
  8006b8:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ba:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006be:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006c2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c6:	0f b6 00             	movzbl (%rax),%eax
  8006c9:	0f b6 d8             	movzbl %al,%ebx
  8006cc:	83 fb 25             	cmp    $0x25,%ebx
  8006cf:	75 d2                	jne    8006a3 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006d1:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006d5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8006dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8006e3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8006ea:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006f1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006f5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006f9:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006fd:	0f b6 00             	movzbl (%rax),%eax
  800700:	0f b6 d8             	movzbl %al,%ebx
  800703:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800706:	83 f8 55             	cmp    $0x55,%eax
  800709:	0f 87 34 04 00 00    	ja     800b43 <vprintfmt+0x4db>
  80070f:	89 c0                	mov    %eax,%eax
  800711:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800718:	00 
  800719:	48 b8 d8 38 80 00 00 	movabs $0x8038d8,%rax
  800720:	00 00 00 
  800723:	48 01 d0             	add    %rdx,%rax
  800726:	48 8b 00             	mov    (%rax),%rax
  800729:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80072b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80072f:	eb c0                	jmp    8006f1 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800731:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800735:	eb ba                	jmp    8006f1 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800737:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80073e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800741:	89 d0                	mov    %edx,%eax
  800743:	c1 e0 02             	shl    $0x2,%eax
  800746:	01 d0                	add    %edx,%eax
  800748:	01 c0                	add    %eax,%eax
  80074a:	01 d8                	add    %ebx,%eax
  80074c:	83 e8 30             	sub    $0x30,%eax
  80074f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800752:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800756:	0f b6 00             	movzbl (%rax),%eax
  800759:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80075c:	83 fb 2f             	cmp    $0x2f,%ebx
  80075f:	7e 0c                	jle    80076d <vprintfmt+0x105>
  800761:	83 fb 39             	cmp    $0x39,%ebx
  800764:	7f 07                	jg     80076d <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800766:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80076b:	eb d1                	jmp    80073e <vprintfmt+0xd6>
			goto process_precision;
  80076d:	eb 58                	jmp    8007c7 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80076f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800772:	83 f8 30             	cmp    $0x30,%eax
  800775:	73 17                	jae    80078e <vprintfmt+0x126>
  800777:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80077b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80077e:	89 c0                	mov    %eax,%eax
  800780:	48 01 d0             	add    %rdx,%rax
  800783:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800786:	83 c2 08             	add    $0x8,%edx
  800789:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80078c:	eb 0f                	jmp    80079d <vprintfmt+0x135>
  80078e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800792:	48 89 d0             	mov    %rdx,%rax
  800795:	48 83 c2 08          	add    $0x8,%rdx
  800799:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80079d:	8b 00                	mov    (%rax),%eax
  80079f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007a2:	eb 23                	jmp    8007c7 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007a4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007a8:	79 0c                	jns    8007b6 <vprintfmt+0x14e>
				width = 0;
  8007aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007b1:	e9 3b ff ff ff       	jmpq   8006f1 <vprintfmt+0x89>
  8007b6:	e9 36 ff ff ff       	jmpq   8006f1 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007bb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007c2:	e9 2a ff ff ff       	jmpq   8006f1 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8007c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007cb:	79 12                	jns    8007df <vprintfmt+0x177>
				width = precision, precision = -1;
  8007cd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007d0:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8007da:	e9 12 ff ff ff       	jmpq   8006f1 <vprintfmt+0x89>
  8007df:	e9 0d ff ff ff       	jmpq   8006f1 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007e4:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8007e8:	e9 04 ff ff ff       	jmpq   8006f1 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8007ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f0:	83 f8 30             	cmp    $0x30,%eax
  8007f3:	73 17                	jae    80080c <vprintfmt+0x1a4>
  8007f5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007f9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fc:	89 c0                	mov    %eax,%eax
  8007fe:	48 01 d0             	add    %rdx,%rax
  800801:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800804:	83 c2 08             	add    $0x8,%edx
  800807:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80080a:	eb 0f                	jmp    80081b <vprintfmt+0x1b3>
  80080c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800810:	48 89 d0             	mov    %rdx,%rax
  800813:	48 83 c2 08          	add    $0x8,%rdx
  800817:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80081b:	8b 10                	mov    (%rax),%edx
  80081d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800821:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800825:	48 89 ce             	mov    %rcx,%rsi
  800828:	89 d7                	mov    %edx,%edi
  80082a:	ff d0                	callq  *%rax
			break;
  80082c:	e9 40 03 00 00       	jmpq   800b71 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800831:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800834:	83 f8 30             	cmp    $0x30,%eax
  800837:	73 17                	jae    800850 <vprintfmt+0x1e8>
  800839:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80083d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800840:	89 c0                	mov    %eax,%eax
  800842:	48 01 d0             	add    %rdx,%rax
  800845:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800848:	83 c2 08             	add    $0x8,%edx
  80084b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80084e:	eb 0f                	jmp    80085f <vprintfmt+0x1f7>
  800850:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800854:	48 89 d0             	mov    %rdx,%rax
  800857:	48 83 c2 08          	add    $0x8,%rdx
  80085b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80085f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800861:	85 db                	test   %ebx,%ebx
  800863:	79 02                	jns    800867 <vprintfmt+0x1ff>
				err = -err;
  800865:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800867:	83 fb 15             	cmp    $0x15,%ebx
  80086a:	7f 16                	jg     800882 <vprintfmt+0x21a>
  80086c:	48 b8 00 38 80 00 00 	movabs $0x803800,%rax
  800873:	00 00 00 
  800876:	48 63 d3             	movslq %ebx,%rdx
  800879:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80087d:	4d 85 e4             	test   %r12,%r12
  800880:	75 2e                	jne    8008b0 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800882:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800886:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088a:	89 d9                	mov    %ebx,%ecx
  80088c:	48 ba c1 38 80 00 00 	movabs $0x8038c1,%rdx
  800893:	00 00 00 
  800896:	48 89 c7             	mov    %rax,%rdi
  800899:	b8 00 00 00 00       	mov    $0x0,%eax
  80089e:	49 b8 80 0b 80 00 00 	movabs $0x800b80,%r8
  8008a5:	00 00 00 
  8008a8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ab:	e9 c1 02 00 00       	jmpq   800b71 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b8:	4c 89 e1             	mov    %r12,%rcx
  8008bb:	48 ba ca 38 80 00 00 	movabs $0x8038ca,%rdx
  8008c2:	00 00 00 
  8008c5:	48 89 c7             	mov    %rax,%rdi
  8008c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cd:	49 b8 80 0b 80 00 00 	movabs $0x800b80,%r8
  8008d4:	00 00 00 
  8008d7:	41 ff d0             	callq  *%r8
			break;
  8008da:	e9 92 02 00 00       	jmpq   800b71 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8008df:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008e2:	83 f8 30             	cmp    $0x30,%eax
  8008e5:	73 17                	jae    8008fe <vprintfmt+0x296>
  8008e7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008eb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ee:	89 c0                	mov    %eax,%eax
  8008f0:	48 01 d0             	add    %rdx,%rax
  8008f3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008f6:	83 c2 08             	add    $0x8,%edx
  8008f9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008fc:	eb 0f                	jmp    80090d <vprintfmt+0x2a5>
  8008fe:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800902:	48 89 d0             	mov    %rdx,%rax
  800905:	48 83 c2 08          	add    $0x8,%rdx
  800909:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80090d:	4c 8b 20             	mov    (%rax),%r12
  800910:	4d 85 e4             	test   %r12,%r12
  800913:	75 0a                	jne    80091f <vprintfmt+0x2b7>
				p = "(null)";
  800915:	49 bc cd 38 80 00 00 	movabs $0x8038cd,%r12
  80091c:	00 00 00 
			if (width > 0 && padc != '-')
  80091f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800923:	7e 3f                	jle    800964 <vprintfmt+0x2fc>
  800925:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800929:	74 39                	je     800964 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80092b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80092e:	48 98                	cltq   
  800930:	48 89 c6             	mov    %rax,%rsi
  800933:	4c 89 e7             	mov    %r12,%rdi
  800936:	48 b8 2c 0e 80 00 00 	movabs $0x800e2c,%rax
  80093d:	00 00 00 
  800940:	ff d0                	callq  *%rax
  800942:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800945:	eb 17                	jmp    80095e <vprintfmt+0x2f6>
					putch(padc, putdat);
  800947:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80094b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80094f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800953:	48 89 ce             	mov    %rcx,%rsi
  800956:	89 d7                	mov    %edx,%edi
  800958:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80095a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80095e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800962:	7f e3                	jg     800947 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800964:	eb 37                	jmp    80099d <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800966:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80096a:	74 1e                	je     80098a <vprintfmt+0x322>
  80096c:	83 fb 1f             	cmp    $0x1f,%ebx
  80096f:	7e 05                	jle    800976 <vprintfmt+0x30e>
  800971:	83 fb 7e             	cmp    $0x7e,%ebx
  800974:	7e 14                	jle    80098a <vprintfmt+0x322>
					putch('?', putdat);
  800976:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80097a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80097e:	48 89 d6             	mov    %rdx,%rsi
  800981:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800986:	ff d0                	callq  *%rax
  800988:	eb 0f                	jmp    800999 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  80098a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80098e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800992:	48 89 d6             	mov    %rdx,%rsi
  800995:	89 df                	mov    %ebx,%edi
  800997:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800999:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80099d:	4c 89 e0             	mov    %r12,%rax
  8009a0:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009a4:	0f b6 00             	movzbl (%rax),%eax
  8009a7:	0f be d8             	movsbl %al,%ebx
  8009aa:	85 db                	test   %ebx,%ebx
  8009ac:	74 10                	je     8009be <vprintfmt+0x356>
  8009ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009b2:	78 b2                	js     800966 <vprintfmt+0x2fe>
  8009b4:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009b8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009bc:	79 a8                	jns    800966 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009be:	eb 16                	jmp    8009d6 <vprintfmt+0x36e>
				putch(' ', putdat);
  8009c0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009c4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c8:	48 89 d6             	mov    %rdx,%rsi
  8009cb:	bf 20 00 00 00       	mov    $0x20,%edi
  8009d0:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009da:	7f e4                	jg     8009c0 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  8009dc:	e9 90 01 00 00       	jmpq   800b71 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8009e1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009e5:	be 03 00 00 00       	mov    $0x3,%esi
  8009ea:	48 89 c7             	mov    %rax,%rdi
  8009ed:	48 b8 58 05 80 00 00 	movabs $0x800558,%rax
  8009f4:	00 00 00 
  8009f7:	ff d0                	callq  *%rax
  8009f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8009fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a01:	48 85 c0             	test   %rax,%rax
  800a04:	79 1d                	jns    800a23 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a06:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0e:	48 89 d6             	mov    %rdx,%rsi
  800a11:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a16:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a1c:	48 f7 d8             	neg    %rax
  800a1f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a23:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a2a:	e9 d5 00 00 00       	jmpq   800b04 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a2f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a33:	be 03 00 00 00       	mov    $0x3,%esi
  800a38:	48 89 c7             	mov    %rax,%rdi
  800a3b:	48 b8 48 04 80 00 00 	movabs $0x800448,%rax
  800a42:	00 00 00 
  800a45:	ff d0                	callq  *%rax
  800a47:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a4b:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a52:	e9 ad 00 00 00       	jmpq   800b04 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800a57:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a5b:	be 03 00 00 00       	mov    $0x3,%esi
  800a60:	48 89 c7             	mov    %rax,%rdi
  800a63:	48 b8 48 04 80 00 00 	movabs $0x800448,%rax
  800a6a:	00 00 00 
  800a6d:	ff d0                	callq  *%rax
  800a6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800a73:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800a7a:	e9 85 00 00 00       	jmpq   800b04 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a87:	48 89 d6             	mov    %rdx,%rsi
  800a8a:	bf 30 00 00 00       	mov    $0x30,%edi
  800a8f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a91:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a95:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a99:	48 89 d6             	mov    %rdx,%rsi
  800a9c:	bf 78 00 00 00       	mov    $0x78,%edi
  800aa1:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800aa3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa6:	83 f8 30             	cmp    $0x30,%eax
  800aa9:	73 17                	jae    800ac2 <vprintfmt+0x45a>
  800aab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aaf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab2:	89 c0                	mov    %eax,%eax
  800ab4:	48 01 d0             	add    %rdx,%rax
  800ab7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aba:	83 c2 08             	add    $0x8,%edx
  800abd:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ac0:	eb 0f                	jmp    800ad1 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800ac2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ac6:	48 89 d0             	mov    %rdx,%rax
  800ac9:	48 83 c2 08          	add    $0x8,%rdx
  800acd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ad1:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ad8:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800adf:	eb 23                	jmp    800b04 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800ae1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ae5:	be 03 00 00 00       	mov    $0x3,%esi
  800aea:	48 89 c7             	mov    %rax,%rdi
  800aed:	48 b8 48 04 80 00 00 	movabs $0x800448,%rax
  800af4:	00 00 00 
  800af7:	ff d0                	callq  *%rax
  800af9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800afd:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b04:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b09:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b0c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b13:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1b:	45 89 c1             	mov    %r8d,%r9d
  800b1e:	41 89 f8             	mov    %edi,%r8d
  800b21:	48 89 c7             	mov    %rax,%rdi
  800b24:	48 b8 8d 03 80 00 00 	movabs $0x80038d,%rax
  800b2b:	00 00 00 
  800b2e:	ff d0                	callq  *%rax
			break;
  800b30:	eb 3f                	jmp    800b71 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b3a:	48 89 d6             	mov    %rdx,%rsi
  800b3d:	89 df                	mov    %ebx,%edi
  800b3f:	ff d0                	callq  *%rax
			break;
  800b41:	eb 2e                	jmp    800b71 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b4b:	48 89 d6             	mov    %rdx,%rsi
  800b4e:	bf 25 00 00 00       	mov    $0x25,%edi
  800b53:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b55:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b5a:	eb 05                	jmp    800b61 <vprintfmt+0x4f9>
  800b5c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b61:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b65:	48 83 e8 01          	sub    $0x1,%rax
  800b69:	0f b6 00             	movzbl (%rax),%eax
  800b6c:	3c 25                	cmp    $0x25,%al
  800b6e:	75 ec                	jne    800b5c <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b70:	90                   	nop
		}
	}
  800b71:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b72:	e9 43 fb ff ff       	jmpq   8006ba <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b77:	48 83 c4 60          	add    $0x60,%rsp
  800b7b:	5b                   	pop    %rbx
  800b7c:	41 5c                	pop    %r12
  800b7e:	5d                   	pop    %rbp
  800b7f:	c3                   	retq   

0000000000800b80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b80:	55                   	push   %rbp
  800b81:	48 89 e5             	mov    %rsp,%rbp
  800b84:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b8b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b92:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b99:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ba0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ba7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bae:	84 c0                	test   %al,%al
  800bb0:	74 20                	je     800bd2 <printfmt+0x52>
  800bb2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bb6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bba:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bbe:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800bc2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bc6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bca:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bce:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bd2:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800bd9:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800be0:	00 00 00 
  800be3:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800bea:	00 00 00 
  800bed:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800bf1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800bf8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800bff:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c06:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c0d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c14:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c1b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c22:	48 89 c7             	mov    %rax,%rdi
  800c25:	48 b8 68 06 80 00 00 	movabs $0x800668,%rax
  800c2c:	00 00 00 
  800c2f:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c31:	c9                   	leaveq 
  800c32:	c3                   	retq   

0000000000800c33 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c33:	55                   	push   %rbp
  800c34:	48 89 e5             	mov    %rsp,%rbp
  800c37:	48 83 ec 10          	sub    $0x10,%rsp
  800c3b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c3e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c46:	8b 40 10             	mov    0x10(%rax),%eax
  800c49:	8d 50 01             	lea    0x1(%rax),%edx
  800c4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c50:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c57:	48 8b 10             	mov    (%rax),%rdx
  800c5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c5e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c62:	48 39 c2             	cmp    %rax,%rdx
  800c65:	73 17                	jae    800c7e <sprintputch+0x4b>
		*b->buf++ = ch;
  800c67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6b:	48 8b 00             	mov    (%rax),%rax
  800c6e:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c72:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c76:	48 89 0a             	mov    %rcx,(%rdx)
  800c79:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c7c:	88 10                	mov    %dl,(%rax)
}
  800c7e:	c9                   	leaveq 
  800c7f:	c3                   	retq   

0000000000800c80 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c80:	55                   	push   %rbp
  800c81:	48 89 e5             	mov    %rsp,%rbp
  800c84:	48 83 ec 50          	sub    $0x50,%rsp
  800c88:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c8c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c8f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c93:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c97:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c9b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c9f:	48 8b 0a             	mov    (%rdx),%rcx
  800ca2:	48 89 08             	mov    %rcx,(%rax)
  800ca5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ca9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cad:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cb1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cb9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cbd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800cc0:	48 98                	cltq   
  800cc2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cc6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cca:	48 01 d0             	add    %rdx,%rax
  800ccd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800cd1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800cd8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800cdd:	74 06                	je     800ce5 <vsnprintf+0x65>
  800cdf:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800ce3:	7f 07                	jg     800cec <vsnprintf+0x6c>
		return -E_INVAL;
  800ce5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cea:	eb 2f                	jmp    800d1b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800cec:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800cf0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800cf4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800cf8:	48 89 c6             	mov    %rax,%rsi
  800cfb:	48 bf 33 0c 80 00 00 	movabs $0x800c33,%rdi
  800d02:	00 00 00 
  800d05:	48 b8 68 06 80 00 00 	movabs $0x800668,%rax
  800d0c:	00 00 00 
  800d0f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d11:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d15:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d18:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d1b:	c9                   	leaveq 
  800d1c:	c3                   	retq   

0000000000800d1d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d1d:	55                   	push   %rbp
  800d1e:	48 89 e5             	mov    %rsp,%rbp
  800d21:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d28:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d2f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d35:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d3c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d43:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d4a:	84 c0                	test   %al,%al
  800d4c:	74 20                	je     800d6e <snprintf+0x51>
  800d4e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d52:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d56:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d5a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d5e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d62:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d66:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d6a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d6e:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d75:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d7c:	00 00 00 
  800d7f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d86:	00 00 00 
  800d89:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d8d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d94:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d9b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800da2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800da9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800db0:	48 8b 0a             	mov    (%rdx),%rcx
  800db3:	48 89 08             	mov    %rcx,(%rax)
  800db6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dba:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dbe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dc2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800dc6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800dcd:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800dd4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800dda:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800de1:	48 89 c7             	mov    %rax,%rdi
  800de4:	48 b8 80 0c 80 00 00 	movabs $0x800c80,%rax
  800deb:	00 00 00 
  800dee:	ff d0                	callq  *%rax
  800df0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800df6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800dfc:	c9                   	leaveq 
  800dfd:	c3                   	retq   

0000000000800dfe <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800dfe:	55                   	push   %rbp
  800dff:	48 89 e5             	mov    %rsp,%rbp
  800e02:	48 83 ec 18          	sub    $0x18,%rsp
  800e06:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e11:	eb 09                	jmp    800e1c <strlen+0x1e>
		n++;
  800e13:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e17:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e20:	0f b6 00             	movzbl (%rax),%eax
  800e23:	84 c0                	test   %al,%al
  800e25:	75 ec                	jne    800e13 <strlen+0x15>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e2a:	c9                   	leaveq 
  800e2b:	c3                   	retq   

0000000000800e2c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e2c:	55                   	push   %rbp
  800e2d:	48 89 e5             	mov    %rsp,%rbp
  800e30:	48 83 ec 20          	sub    $0x20,%rsp
  800e34:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e38:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e43:	eb 0e                	jmp    800e53 <strnlen+0x27>
		n++;
  800e45:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e49:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e4e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e53:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e58:	74 0b                	je     800e65 <strnlen+0x39>
  800e5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5e:	0f b6 00             	movzbl (%rax),%eax
  800e61:	84 c0                	test   %al,%al
  800e63:	75 e0                	jne    800e45 <strnlen+0x19>
		n++;
	return n;
  800e65:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e68:	c9                   	leaveq 
  800e69:	c3                   	retq   

0000000000800e6a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e6a:	55                   	push   %rbp
  800e6b:	48 89 e5             	mov    %rsp,%rbp
  800e6e:	48 83 ec 20          	sub    $0x20,%rsp
  800e72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e82:	90                   	nop
  800e83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e87:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e8b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e8f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e93:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e97:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e9b:	0f b6 12             	movzbl (%rdx),%edx
  800e9e:	88 10                	mov    %dl,(%rax)
  800ea0:	0f b6 00             	movzbl (%rax),%eax
  800ea3:	84 c0                	test   %al,%al
  800ea5:	75 dc                	jne    800e83 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ea7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800eab:	c9                   	leaveq 
  800eac:	c3                   	retq   

0000000000800ead <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ead:	55                   	push   %rbp
  800eae:	48 89 e5             	mov    %rsp,%rbp
  800eb1:	48 83 ec 20          	sub    $0x20,%rsp
  800eb5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ebd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec1:	48 89 c7             	mov    %rax,%rdi
  800ec4:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  800ecb:	00 00 00 
  800ece:	ff d0                	callq  *%rax
  800ed0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ed3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ed6:	48 63 d0             	movslq %eax,%rdx
  800ed9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800edd:	48 01 c2             	add    %rax,%rdx
  800ee0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ee4:	48 89 c6             	mov    %rax,%rsi
  800ee7:	48 89 d7             	mov    %rdx,%rdi
  800eea:	48 b8 6a 0e 80 00 00 	movabs $0x800e6a,%rax
  800ef1:	00 00 00 
  800ef4:	ff d0                	callq  *%rax
	return dst;
  800ef6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800efa:	c9                   	leaveq 
  800efb:	c3                   	retq   

0000000000800efc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800efc:	55                   	push   %rbp
  800efd:	48 89 e5             	mov    %rsp,%rbp
  800f00:	48 83 ec 28          	sub    $0x28,%rsp
  800f04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f0c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f14:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f18:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f1f:	00 
  800f20:	eb 2a                	jmp    800f4c <strncpy+0x50>
		*dst++ = *src;
  800f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f26:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f2a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f2e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f32:	0f b6 12             	movzbl (%rdx),%edx
  800f35:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f37:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f3b:	0f b6 00             	movzbl (%rax),%eax
  800f3e:	84 c0                	test   %al,%al
  800f40:	74 05                	je     800f47 <strncpy+0x4b>
			src++;
  800f42:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f47:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f50:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f54:	72 cc                	jb     800f22 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f5a:	c9                   	leaveq 
  800f5b:	c3                   	retq   

0000000000800f5c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f5c:	55                   	push   %rbp
  800f5d:	48 89 e5             	mov    %rsp,%rbp
  800f60:	48 83 ec 28          	sub    $0x28,%rsp
  800f64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f6c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f78:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f7d:	74 3d                	je     800fbc <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f7f:	eb 1d                	jmp    800f9e <strlcpy+0x42>
			*dst++ = *src++;
  800f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f85:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f89:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f8d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f91:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f95:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f99:	0f b6 12             	movzbl (%rdx),%edx
  800f9c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f9e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fa3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fa8:	74 0b                	je     800fb5 <strlcpy+0x59>
  800faa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fae:	0f b6 00             	movzbl (%rax),%eax
  800fb1:	84 c0                	test   %al,%al
  800fb3:	75 cc                	jne    800f81 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fbc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc4:	48 29 c2             	sub    %rax,%rdx
  800fc7:	48 89 d0             	mov    %rdx,%rax
}
  800fca:	c9                   	leaveq 
  800fcb:	c3                   	retq   

0000000000800fcc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fcc:	55                   	push   %rbp
  800fcd:	48 89 e5             	mov    %rsp,%rbp
  800fd0:	48 83 ec 10          	sub    $0x10,%rsp
  800fd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fd8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800fdc:	eb 0a                	jmp    800fe8 <strcmp+0x1c>
		p++, q++;
  800fde:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fe3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fe8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fec:	0f b6 00             	movzbl (%rax),%eax
  800fef:	84 c0                	test   %al,%al
  800ff1:	74 12                	je     801005 <strcmp+0x39>
  800ff3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff7:	0f b6 10             	movzbl (%rax),%edx
  800ffa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffe:	0f b6 00             	movzbl (%rax),%eax
  801001:	38 c2                	cmp    %al,%dl
  801003:	74 d9                	je     800fde <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801005:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801009:	0f b6 00             	movzbl (%rax),%eax
  80100c:	0f b6 d0             	movzbl %al,%edx
  80100f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801013:	0f b6 00             	movzbl (%rax),%eax
  801016:	0f b6 c0             	movzbl %al,%eax
  801019:	29 c2                	sub    %eax,%edx
  80101b:	89 d0                	mov    %edx,%eax
}
  80101d:	c9                   	leaveq 
  80101e:	c3                   	retq   

000000000080101f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80101f:	55                   	push   %rbp
  801020:	48 89 e5             	mov    %rsp,%rbp
  801023:	48 83 ec 18          	sub    $0x18,%rsp
  801027:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80102b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80102f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801033:	eb 0f                	jmp    801044 <strncmp+0x25>
		n--, p++, q++;
  801035:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80103a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80103f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801044:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801049:	74 1d                	je     801068 <strncmp+0x49>
  80104b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104f:	0f b6 00             	movzbl (%rax),%eax
  801052:	84 c0                	test   %al,%al
  801054:	74 12                	je     801068 <strncmp+0x49>
  801056:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105a:	0f b6 10             	movzbl (%rax),%edx
  80105d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801061:	0f b6 00             	movzbl (%rax),%eax
  801064:	38 c2                	cmp    %al,%dl
  801066:	74 cd                	je     801035 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801068:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80106d:	75 07                	jne    801076 <strncmp+0x57>
		return 0;
  80106f:	b8 00 00 00 00       	mov    $0x0,%eax
  801074:	eb 18                	jmp    80108e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801076:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107a:	0f b6 00             	movzbl (%rax),%eax
  80107d:	0f b6 d0             	movzbl %al,%edx
  801080:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801084:	0f b6 00             	movzbl (%rax),%eax
  801087:	0f b6 c0             	movzbl %al,%eax
  80108a:	29 c2                	sub    %eax,%edx
  80108c:	89 d0                	mov    %edx,%eax
}
  80108e:	c9                   	leaveq 
  80108f:	c3                   	retq   

0000000000801090 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801090:	55                   	push   %rbp
  801091:	48 89 e5             	mov    %rsp,%rbp
  801094:	48 83 ec 0c          	sub    $0xc,%rsp
  801098:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80109c:	89 f0                	mov    %esi,%eax
  80109e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010a1:	eb 17                	jmp    8010ba <strchr+0x2a>
		if (*s == c)
  8010a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a7:	0f b6 00             	movzbl (%rax),%eax
  8010aa:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010ad:	75 06                	jne    8010b5 <strchr+0x25>
			return (char *) s;
  8010af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b3:	eb 15                	jmp    8010ca <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010b5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010be:	0f b6 00             	movzbl (%rax),%eax
  8010c1:	84 c0                	test   %al,%al
  8010c3:	75 de                	jne    8010a3 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ca:	c9                   	leaveq 
  8010cb:	c3                   	retq   

00000000008010cc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010cc:	55                   	push   %rbp
  8010cd:	48 89 e5             	mov    %rsp,%rbp
  8010d0:	48 83 ec 0c          	sub    $0xc,%rsp
  8010d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010d8:	89 f0                	mov    %esi,%eax
  8010da:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010dd:	eb 13                	jmp    8010f2 <strfind+0x26>
		if (*s == c)
  8010df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e3:	0f b6 00             	movzbl (%rax),%eax
  8010e6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010e9:	75 02                	jne    8010ed <strfind+0x21>
			break;
  8010eb:	eb 10                	jmp    8010fd <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f6:	0f b6 00             	movzbl (%rax),%eax
  8010f9:	84 c0                	test   %al,%al
  8010fb:	75 e2                	jne    8010df <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8010fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801101:	c9                   	leaveq 
  801102:	c3                   	retq   

0000000000801103 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801103:	55                   	push   %rbp
  801104:	48 89 e5             	mov    %rsp,%rbp
  801107:	48 83 ec 18          	sub    $0x18,%rsp
  80110b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80110f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801112:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801116:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80111b:	75 06                	jne    801123 <memset+0x20>
		return v;
  80111d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801121:	eb 69                	jmp    80118c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801123:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801127:	83 e0 03             	and    $0x3,%eax
  80112a:	48 85 c0             	test   %rax,%rax
  80112d:	75 48                	jne    801177 <memset+0x74>
  80112f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801133:	83 e0 03             	and    $0x3,%eax
  801136:	48 85 c0             	test   %rax,%rax
  801139:	75 3c                	jne    801177 <memset+0x74>
		c &= 0xFF;
  80113b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801142:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801145:	c1 e0 18             	shl    $0x18,%eax
  801148:	89 c2                	mov    %eax,%edx
  80114a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80114d:	c1 e0 10             	shl    $0x10,%eax
  801150:	09 c2                	or     %eax,%edx
  801152:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801155:	c1 e0 08             	shl    $0x8,%eax
  801158:	09 d0                	or     %edx,%eax
  80115a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80115d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801161:	48 c1 e8 02          	shr    $0x2,%rax
  801165:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801168:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80116c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80116f:	48 89 d7             	mov    %rdx,%rdi
  801172:	fc                   	cld    
  801173:	f3 ab                	rep stos %eax,%es:(%rdi)
  801175:	eb 11                	jmp    801188 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801177:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80117b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80117e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801182:	48 89 d7             	mov    %rdx,%rdi
  801185:	fc                   	cld    
  801186:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801188:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80118c:	c9                   	leaveq 
  80118d:	c3                   	retq   

000000000080118e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80118e:	55                   	push   %rbp
  80118f:	48 89 e5             	mov    %rsp,%rbp
  801192:	48 83 ec 28          	sub    $0x28,%rsp
  801196:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80119a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80119e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011ba:	0f 83 88 00 00 00    	jae    801248 <memmove+0xba>
  8011c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011c8:	48 01 d0             	add    %rdx,%rax
  8011cb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011cf:	76 77                	jbe    801248 <memmove+0xba>
		s += n;
  8011d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011d5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8011d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011dd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e5:	83 e0 03             	and    $0x3,%eax
  8011e8:	48 85 c0             	test   %rax,%rax
  8011eb:	75 3b                	jne    801228 <memmove+0x9a>
  8011ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f1:	83 e0 03             	and    $0x3,%eax
  8011f4:	48 85 c0             	test   %rax,%rax
  8011f7:	75 2f                	jne    801228 <memmove+0x9a>
  8011f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011fd:	83 e0 03             	and    $0x3,%eax
  801200:	48 85 c0             	test   %rax,%rax
  801203:	75 23                	jne    801228 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801205:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801209:	48 83 e8 04          	sub    $0x4,%rax
  80120d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801211:	48 83 ea 04          	sub    $0x4,%rdx
  801215:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801219:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80121d:	48 89 c7             	mov    %rax,%rdi
  801220:	48 89 d6             	mov    %rdx,%rsi
  801223:	fd                   	std    
  801224:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801226:	eb 1d                	jmp    801245 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801228:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801230:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801234:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801238:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123c:	48 89 d7             	mov    %rdx,%rdi
  80123f:	48 89 c1             	mov    %rax,%rcx
  801242:	fd                   	std    
  801243:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801245:	fc                   	cld    
  801246:	eb 57                	jmp    80129f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801248:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124c:	83 e0 03             	and    $0x3,%eax
  80124f:	48 85 c0             	test   %rax,%rax
  801252:	75 36                	jne    80128a <memmove+0xfc>
  801254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801258:	83 e0 03             	and    $0x3,%eax
  80125b:	48 85 c0             	test   %rax,%rax
  80125e:	75 2a                	jne    80128a <memmove+0xfc>
  801260:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801264:	83 e0 03             	and    $0x3,%eax
  801267:	48 85 c0             	test   %rax,%rax
  80126a:	75 1e                	jne    80128a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80126c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801270:	48 c1 e8 02          	shr    $0x2,%rax
  801274:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801277:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80127f:	48 89 c7             	mov    %rax,%rdi
  801282:	48 89 d6             	mov    %rdx,%rsi
  801285:	fc                   	cld    
  801286:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801288:	eb 15                	jmp    80129f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80128a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801292:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801296:	48 89 c7             	mov    %rax,%rdi
  801299:	48 89 d6             	mov    %rdx,%rsi
  80129c:	fc                   	cld    
  80129d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80129f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012a3:	c9                   	leaveq 
  8012a4:	c3                   	retq   

00000000008012a5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012a5:	55                   	push   %rbp
  8012a6:	48 89 e5             	mov    %rsp,%rbp
  8012a9:	48 83 ec 18          	sub    $0x18,%rsp
  8012ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012bd:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012c5:	48 89 ce             	mov    %rcx,%rsi
  8012c8:	48 89 c7             	mov    %rax,%rdi
  8012cb:	48 b8 8e 11 80 00 00 	movabs $0x80118e,%rax
  8012d2:	00 00 00 
  8012d5:	ff d0                	callq  *%rax
}
  8012d7:	c9                   	leaveq 
  8012d8:	c3                   	retq   

00000000008012d9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8012d9:	55                   	push   %rbp
  8012da:	48 89 e5             	mov    %rsp,%rbp
  8012dd:	48 83 ec 28          	sub    $0x28,%rsp
  8012e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8012ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8012f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8012fd:	eb 36                	jmp    801335 <memcmp+0x5c>
		if (*s1 != *s2)
  8012ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801303:	0f b6 10             	movzbl (%rax),%edx
  801306:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130a:	0f b6 00             	movzbl (%rax),%eax
  80130d:	38 c2                	cmp    %al,%dl
  80130f:	74 1a                	je     80132b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801311:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801315:	0f b6 00             	movzbl (%rax),%eax
  801318:	0f b6 d0             	movzbl %al,%edx
  80131b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80131f:	0f b6 00             	movzbl (%rax),%eax
  801322:	0f b6 c0             	movzbl %al,%eax
  801325:	29 c2                	sub    %eax,%edx
  801327:	89 d0                	mov    %edx,%eax
  801329:	eb 20                	jmp    80134b <memcmp+0x72>
		s1++, s2++;
  80132b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801330:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801335:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801339:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80133d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801341:	48 85 c0             	test   %rax,%rax
  801344:	75 b9                	jne    8012ff <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801346:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134b:	c9                   	leaveq 
  80134c:	c3                   	retq   

000000000080134d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80134d:	55                   	push   %rbp
  80134e:	48 89 e5             	mov    %rsp,%rbp
  801351:	48 83 ec 28          	sub    $0x28,%rsp
  801355:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801359:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80135c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801360:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801364:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801368:	48 01 d0             	add    %rdx,%rax
  80136b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80136f:	eb 15                	jmp    801386 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801371:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801375:	0f b6 10             	movzbl (%rax),%edx
  801378:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80137b:	38 c2                	cmp    %al,%dl
  80137d:	75 02                	jne    801381 <memfind+0x34>
			break;
  80137f:	eb 0f                	jmp    801390 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801381:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801386:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80138e:	72 e1                	jb     801371 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801394:	c9                   	leaveq 
  801395:	c3                   	retq   

0000000000801396 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801396:	55                   	push   %rbp
  801397:	48 89 e5             	mov    %rsp,%rbp
  80139a:	48 83 ec 34          	sub    $0x34,%rsp
  80139e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013a2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013a6:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013b0:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013b7:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013b8:	eb 05                	jmp    8013bf <strtol+0x29>
		s++;
  8013ba:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c3:	0f b6 00             	movzbl (%rax),%eax
  8013c6:	3c 20                	cmp    $0x20,%al
  8013c8:	74 f0                	je     8013ba <strtol+0x24>
  8013ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ce:	0f b6 00             	movzbl (%rax),%eax
  8013d1:	3c 09                	cmp    $0x9,%al
  8013d3:	74 e5                	je     8013ba <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d9:	0f b6 00             	movzbl (%rax),%eax
  8013dc:	3c 2b                	cmp    $0x2b,%al
  8013de:	75 07                	jne    8013e7 <strtol+0x51>
		s++;
  8013e0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013e5:	eb 17                	jmp    8013fe <strtol+0x68>
	else if (*s == '-')
  8013e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013eb:	0f b6 00             	movzbl (%rax),%eax
  8013ee:	3c 2d                	cmp    $0x2d,%al
  8013f0:	75 0c                	jne    8013fe <strtol+0x68>
		s++, neg = 1;
  8013f2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013f7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801402:	74 06                	je     80140a <strtol+0x74>
  801404:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801408:	75 28                	jne    801432 <strtol+0x9c>
  80140a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140e:	0f b6 00             	movzbl (%rax),%eax
  801411:	3c 30                	cmp    $0x30,%al
  801413:	75 1d                	jne    801432 <strtol+0x9c>
  801415:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801419:	48 83 c0 01          	add    $0x1,%rax
  80141d:	0f b6 00             	movzbl (%rax),%eax
  801420:	3c 78                	cmp    $0x78,%al
  801422:	75 0e                	jne    801432 <strtol+0x9c>
		s += 2, base = 16;
  801424:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801429:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801430:	eb 2c                	jmp    80145e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801432:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801436:	75 19                	jne    801451 <strtol+0xbb>
  801438:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80143c:	0f b6 00             	movzbl (%rax),%eax
  80143f:	3c 30                	cmp    $0x30,%al
  801441:	75 0e                	jne    801451 <strtol+0xbb>
		s++, base = 8;
  801443:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801448:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80144f:	eb 0d                	jmp    80145e <strtol+0xc8>
	else if (base == 0)
  801451:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801455:	75 07                	jne    80145e <strtol+0xc8>
		base = 10;
  801457:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80145e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801462:	0f b6 00             	movzbl (%rax),%eax
  801465:	3c 2f                	cmp    $0x2f,%al
  801467:	7e 1d                	jle    801486 <strtol+0xf0>
  801469:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80146d:	0f b6 00             	movzbl (%rax),%eax
  801470:	3c 39                	cmp    $0x39,%al
  801472:	7f 12                	jg     801486 <strtol+0xf0>
			dig = *s - '0';
  801474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801478:	0f b6 00             	movzbl (%rax),%eax
  80147b:	0f be c0             	movsbl %al,%eax
  80147e:	83 e8 30             	sub    $0x30,%eax
  801481:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801484:	eb 4e                	jmp    8014d4 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801486:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148a:	0f b6 00             	movzbl (%rax),%eax
  80148d:	3c 60                	cmp    $0x60,%al
  80148f:	7e 1d                	jle    8014ae <strtol+0x118>
  801491:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801495:	0f b6 00             	movzbl (%rax),%eax
  801498:	3c 7a                	cmp    $0x7a,%al
  80149a:	7f 12                	jg     8014ae <strtol+0x118>
			dig = *s - 'a' + 10;
  80149c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a0:	0f b6 00             	movzbl (%rax),%eax
  8014a3:	0f be c0             	movsbl %al,%eax
  8014a6:	83 e8 57             	sub    $0x57,%eax
  8014a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ac:	eb 26                	jmp    8014d4 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b2:	0f b6 00             	movzbl (%rax),%eax
  8014b5:	3c 40                	cmp    $0x40,%al
  8014b7:	7e 48                	jle    801501 <strtol+0x16b>
  8014b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bd:	0f b6 00             	movzbl (%rax),%eax
  8014c0:	3c 5a                	cmp    $0x5a,%al
  8014c2:	7f 3d                	jg     801501 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8014c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c8:	0f b6 00             	movzbl (%rax),%eax
  8014cb:	0f be c0             	movsbl %al,%eax
  8014ce:	83 e8 37             	sub    $0x37,%eax
  8014d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014d7:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8014da:	7c 02                	jl     8014de <strtol+0x148>
			break;
  8014dc:	eb 23                	jmp    801501 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8014de:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014e3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8014e6:	48 98                	cltq   
  8014e8:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8014ed:	48 89 c2             	mov    %rax,%rdx
  8014f0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8014f3:	48 98                	cltq   
  8014f5:	48 01 d0             	add    %rdx,%rax
  8014f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8014fc:	e9 5d ff ff ff       	jmpq   80145e <strtol+0xc8>

	if (endptr)
  801501:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801506:	74 0b                	je     801513 <strtol+0x17d>
		*endptr = (char *) s;
  801508:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80150c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801510:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801513:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801517:	74 09                	je     801522 <strtol+0x18c>
  801519:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151d:	48 f7 d8             	neg    %rax
  801520:	eb 04                	jmp    801526 <strtol+0x190>
  801522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801526:	c9                   	leaveq 
  801527:	c3                   	retq   

0000000000801528 <strstr>:

char * strstr(const char *in, const char *str)
{
  801528:	55                   	push   %rbp
  801529:	48 89 e5             	mov    %rsp,%rbp
  80152c:	48 83 ec 30          	sub    $0x30,%rsp
  801530:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801534:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801538:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80153c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801540:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801544:	0f b6 00             	movzbl (%rax),%eax
  801547:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80154a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80154e:	75 06                	jne    801556 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801550:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801554:	eb 6b                	jmp    8015c1 <strstr+0x99>

	len = strlen(str);
  801556:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80155a:	48 89 c7             	mov    %rax,%rdi
  80155d:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  801564:	00 00 00 
  801567:	ff d0                	callq  *%rax
  801569:	48 98                	cltq   
  80156b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80156f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801573:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801577:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80157b:	0f b6 00             	movzbl (%rax),%eax
  80157e:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801581:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801585:	75 07                	jne    80158e <strstr+0x66>
				return (char *) 0;
  801587:	b8 00 00 00 00       	mov    $0x0,%eax
  80158c:	eb 33                	jmp    8015c1 <strstr+0x99>
		} while (sc != c);
  80158e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801592:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801595:	75 d8                	jne    80156f <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801597:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80159b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	48 89 ce             	mov    %rcx,%rsi
  8015a6:	48 89 c7             	mov    %rax,%rdi
  8015a9:	48 b8 1f 10 80 00 00 	movabs $0x80101f,%rax
  8015b0:	00 00 00 
  8015b3:	ff d0                	callq  *%rax
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	75 b6                	jne    80156f <strstr+0x47>

	return (char *) (in - 1);
  8015b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015bd:	48 83 e8 01          	sub    $0x1,%rax
}
  8015c1:	c9                   	leaveq 
  8015c2:	c3                   	retq   

00000000008015c3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015c3:	55                   	push   %rbp
  8015c4:	48 89 e5             	mov    %rsp,%rbp
  8015c7:	53                   	push   %rbx
  8015c8:	48 83 ec 48          	sub    $0x48,%rsp
  8015cc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015cf:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015d2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015d6:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8015da:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8015de:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8015e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015e5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8015e9:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8015ed:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8015f1:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8015f5:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8015f9:	4c 89 c3             	mov    %r8,%rbx
  8015fc:	cd 30                	int    $0x30
  8015fe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801602:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801606:	74 3e                	je     801646 <syscall+0x83>
  801608:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80160d:	7e 37                	jle    801646 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80160f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801613:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801616:	49 89 d0             	mov    %rdx,%r8
  801619:	89 c1                	mov    %eax,%ecx
  80161b:	48 ba 88 3b 80 00 00 	movabs $0x803b88,%rdx
  801622:	00 00 00 
  801625:	be 4a 00 00 00       	mov    $0x4a,%esi
  80162a:	48 bf a5 3b 80 00 00 	movabs $0x803ba5,%rdi
  801631:	00 00 00 
  801634:	b8 00 00 00 00       	mov    $0x0,%eax
  801639:	49 b9 f2 32 80 00 00 	movabs $0x8032f2,%r9
  801640:	00 00 00 
  801643:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801646:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80164a:	48 83 c4 48          	add    $0x48,%rsp
  80164e:	5b                   	pop    %rbx
  80164f:	5d                   	pop    %rbp
  801650:	c3                   	retq   

0000000000801651 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801651:	55                   	push   %rbp
  801652:	48 89 e5             	mov    %rsp,%rbp
  801655:	48 83 ec 20          	sub    $0x20,%rsp
  801659:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80165d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801661:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801665:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801669:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801670:	00 
  801671:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801677:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80167d:	48 89 d1             	mov    %rdx,%rcx
  801680:	48 89 c2             	mov    %rax,%rdx
  801683:	be 00 00 00 00       	mov    $0x0,%esi
  801688:	bf 00 00 00 00       	mov    $0x0,%edi
  80168d:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  801694:	00 00 00 
  801697:	ff d0                	callq  *%rax
}
  801699:	c9                   	leaveq 
  80169a:	c3                   	retq   

000000000080169b <sys_cgetc>:

int
sys_cgetc(void)
{
  80169b:	55                   	push   %rbp
  80169c:	48 89 e5             	mov    %rsp,%rbp
  80169f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016a3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016aa:	00 
  8016ab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c1:	be 00 00 00 00       	mov    $0x0,%esi
  8016c6:	bf 01 00 00 00       	mov    $0x1,%edi
  8016cb:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  8016d2:	00 00 00 
  8016d5:	ff d0                	callq  *%rax
}
  8016d7:	c9                   	leaveq 
  8016d8:	c3                   	retq   

00000000008016d9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8016d9:	55                   	push   %rbp
  8016da:	48 89 e5             	mov    %rsp,%rbp
  8016dd:	48 83 ec 10          	sub    $0x10,%rsp
  8016e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8016e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016e7:	48 98                	cltq   
  8016e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016f0:	00 
  8016f1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801702:	48 89 c2             	mov    %rax,%rdx
  801705:	be 01 00 00 00       	mov    $0x1,%esi
  80170a:	bf 03 00 00 00       	mov    $0x3,%edi
  80170f:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  801716:	00 00 00 
  801719:	ff d0                	callq  *%rax
}
  80171b:	c9                   	leaveq 
  80171c:	c3                   	retq   

000000000080171d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80171d:	55                   	push   %rbp
  80171e:	48 89 e5             	mov    %rsp,%rbp
  801721:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801725:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80172c:	00 
  80172d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801733:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801739:	b9 00 00 00 00       	mov    $0x0,%ecx
  80173e:	ba 00 00 00 00       	mov    $0x0,%edx
  801743:	be 00 00 00 00       	mov    $0x0,%esi
  801748:	bf 02 00 00 00       	mov    $0x2,%edi
  80174d:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  801754:	00 00 00 
  801757:	ff d0                	callq  *%rax
}
  801759:	c9                   	leaveq 
  80175a:	c3                   	retq   

000000000080175b <sys_yield>:

void
sys_yield(void)
{
  80175b:	55                   	push   %rbp
  80175c:	48 89 e5             	mov    %rsp,%rbp
  80175f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801763:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80176a:	00 
  80176b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801771:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801777:	b9 00 00 00 00       	mov    $0x0,%ecx
  80177c:	ba 00 00 00 00       	mov    $0x0,%edx
  801781:	be 00 00 00 00       	mov    $0x0,%esi
  801786:	bf 0b 00 00 00       	mov    $0xb,%edi
  80178b:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  801792:	00 00 00 
  801795:	ff d0                	callq  *%rax
}
  801797:	c9                   	leaveq 
  801798:	c3                   	retq   

0000000000801799 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801799:	55                   	push   %rbp
  80179a:	48 89 e5             	mov    %rsp,%rbp
  80179d:	48 83 ec 20          	sub    $0x20,%rsp
  8017a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017a4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017a8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017ae:	48 63 c8             	movslq %eax,%rcx
  8017b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017b8:	48 98                	cltq   
  8017ba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017c1:	00 
  8017c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017c8:	49 89 c8             	mov    %rcx,%r8
  8017cb:	48 89 d1             	mov    %rdx,%rcx
  8017ce:	48 89 c2             	mov    %rax,%rdx
  8017d1:	be 01 00 00 00       	mov    $0x1,%esi
  8017d6:	bf 04 00 00 00       	mov    $0x4,%edi
  8017db:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  8017e2:	00 00 00 
  8017e5:	ff d0                	callq  *%rax
}
  8017e7:	c9                   	leaveq 
  8017e8:	c3                   	retq   

00000000008017e9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8017e9:	55                   	push   %rbp
  8017ea:	48 89 e5             	mov    %rsp,%rbp
  8017ed:	48 83 ec 30          	sub    $0x30,%rsp
  8017f1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017f4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017f8:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8017fb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8017ff:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801803:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801806:	48 63 c8             	movslq %eax,%rcx
  801809:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80180d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801810:	48 63 f0             	movslq %eax,%rsi
  801813:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801817:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80181a:	48 98                	cltq   
  80181c:	48 89 0c 24          	mov    %rcx,(%rsp)
  801820:	49 89 f9             	mov    %rdi,%r9
  801823:	49 89 f0             	mov    %rsi,%r8
  801826:	48 89 d1             	mov    %rdx,%rcx
  801829:	48 89 c2             	mov    %rax,%rdx
  80182c:	be 01 00 00 00       	mov    $0x1,%esi
  801831:	bf 05 00 00 00       	mov    $0x5,%edi
  801836:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  80183d:	00 00 00 
  801840:	ff d0                	callq  *%rax
}
  801842:	c9                   	leaveq 
  801843:	c3                   	retq   

0000000000801844 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801844:	55                   	push   %rbp
  801845:	48 89 e5             	mov    %rsp,%rbp
  801848:	48 83 ec 20          	sub    $0x20,%rsp
  80184c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80184f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801853:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801857:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80185a:	48 98                	cltq   
  80185c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801863:	00 
  801864:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80186a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801870:	48 89 d1             	mov    %rdx,%rcx
  801873:	48 89 c2             	mov    %rax,%rdx
  801876:	be 01 00 00 00       	mov    $0x1,%esi
  80187b:	bf 06 00 00 00       	mov    $0x6,%edi
  801880:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  801887:	00 00 00 
  80188a:	ff d0                	callq  *%rax
}
  80188c:	c9                   	leaveq 
  80188d:	c3                   	retq   

000000000080188e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80188e:	55                   	push   %rbp
  80188f:	48 89 e5             	mov    %rsp,%rbp
  801892:	48 83 ec 10          	sub    $0x10,%rsp
  801896:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801899:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80189c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80189f:	48 63 d0             	movslq %eax,%rdx
  8018a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a5:	48 98                	cltq   
  8018a7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ae:	00 
  8018af:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018bb:	48 89 d1             	mov    %rdx,%rcx
  8018be:	48 89 c2             	mov    %rax,%rdx
  8018c1:	be 01 00 00 00       	mov    $0x1,%esi
  8018c6:	bf 08 00 00 00       	mov    $0x8,%edi
  8018cb:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  8018d2:	00 00 00 
  8018d5:	ff d0                	callq  *%rax
}
  8018d7:	c9                   	leaveq 
  8018d8:	c3                   	retq   

00000000008018d9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8018d9:	55                   	push   %rbp
  8018da:	48 89 e5             	mov    %rsp,%rbp
  8018dd:	48 83 ec 20          	sub    $0x20,%rsp
  8018e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8018e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ef:	48 98                	cltq   
  8018f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f8:	00 
  8018f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801905:	48 89 d1             	mov    %rdx,%rcx
  801908:	48 89 c2             	mov    %rax,%rdx
  80190b:	be 01 00 00 00       	mov    $0x1,%esi
  801910:	bf 09 00 00 00       	mov    $0x9,%edi
  801915:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  80191c:	00 00 00 
  80191f:	ff d0                	callq  *%rax
}
  801921:	c9                   	leaveq 
  801922:	c3                   	retq   

0000000000801923 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801923:	55                   	push   %rbp
  801924:	48 89 e5             	mov    %rsp,%rbp
  801927:	48 83 ec 20          	sub    $0x20,%rsp
  80192b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80192e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801932:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801936:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801939:	48 98                	cltq   
  80193b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801942:	00 
  801943:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801949:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80194f:	48 89 d1             	mov    %rdx,%rcx
  801952:	48 89 c2             	mov    %rax,%rdx
  801955:	be 01 00 00 00       	mov    $0x1,%esi
  80195a:	bf 0a 00 00 00       	mov    $0xa,%edi
  80195f:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  801966:	00 00 00 
  801969:	ff d0                	callq  *%rax
}
  80196b:	c9                   	leaveq 
  80196c:	c3                   	retq   

000000000080196d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80196d:	55                   	push   %rbp
  80196e:	48 89 e5             	mov    %rsp,%rbp
  801971:	48 83 ec 20          	sub    $0x20,%rsp
  801975:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801978:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80197c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801980:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801983:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801986:	48 63 f0             	movslq %eax,%rsi
  801989:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80198d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801990:	48 98                	cltq   
  801992:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801996:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80199d:	00 
  80199e:	49 89 f1             	mov    %rsi,%r9
  8019a1:	49 89 c8             	mov    %rcx,%r8
  8019a4:	48 89 d1             	mov    %rdx,%rcx
  8019a7:	48 89 c2             	mov    %rax,%rdx
  8019aa:	be 00 00 00 00       	mov    $0x0,%esi
  8019af:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019b4:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  8019bb:	00 00 00 
  8019be:	ff d0                	callq  *%rax
}
  8019c0:	c9                   	leaveq 
  8019c1:	c3                   	retq   

00000000008019c2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019c2:	55                   	push   %rbp
  8019c3:	48 89 e5             	mov    %rsp,%rbp
  8019c6:	48 83 ec 10          	sub    $0x10,%rsp
  8019ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019d2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019d9:	00 
  8019da:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019e0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019eb:	48 89 c2             	mov    %rax,%rdx
  8019ee:	be 01 00 00 00       	mov    $0x1,%esi
  8019f3:	bf 0d 00 00 00       	mov    $0xd,%edi
  8019f8:	48 b8 c3 15 80 00 00 	movabs $0x8015c3,%rax
  8019ff:	00 00 00 
  801a02:	ff d0                	callq  *%rax
}
  801a04:	c9                   	leaveq 
  801a05:	c3                   	retq   

0000000000801a06 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801a06:	55                   	push   %rbp
  801a07:	48 89 e5             	mov    %rsp,%rbp
  801a0a:	48 83 ec 10          	sub    $0x10,%rsp
  801a0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  801a12:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801a19:	00 00 00 
  801a1c:	48 8b 00             	mov    (%rax),%rax
  801a1f:	48 85 c0             	test   %rax,%rax
  801a22:	75 64                	jne    801a88 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  801a24:	ba 07 00 00 00       	mov    $0x7,%edx
  801a29:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801a2e:	bf 00 00 00 00       	mov    $0x0,%edi
  801a33:	48 b8 99 17 80 00 00 	movabs $0x801799,%rax
  801a3a:	00 00 00 
  801a3d:	ff d0                	callq  *%rax
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	74 2a                	je     801a6d <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  801a43:	48 ba b8 3b 80 00 00 	movabs $0x803bb8,%rdx
  801a4a:	00 00 00 
  801a4d:	be 22 00 00 00       	mov    $0x22,%esi
  801a52:	48 bf e0 3b 80 00 00 	movabs $0x803be0,%rdi
  801a59:	00 00 00 
  801a5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a61:	48 b9 f2 32 80 00 00 	movabs $0x8032f2,%rcx
  801a68:	00 00 00 
  801a6b:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801a6d:	48 be 9b 1a 80 00 00 	movabs $0x801a9b,%rsi
  801a74:	00 00 00 
  801a77:	bf 00 00 00 00       	mov    $0x0,%edi
  801a7c:	48 b8 23 19 80 00 00 	movabs $0x801923,%rax
  801a83:	00 00 00 
  801a86:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801a88:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801a8f:	00 00 00 
  801a92:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a96:	48 89 10             	mov    %rdx,(%rax)
}
  801a99:	c9                   	leaveq 
  801a9a:	c3                   	retq   

0000000000801a9b <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  801a9b:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801a9e:	48 a1 10 60 80 00 00 	movabs 0x806010,%rax
  801aa5:	00 00 00 
call *%rax
  801aa8:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  801aaa:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  801ab1:	00 
mov 136(%rsp), %r9
  801ab2:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  801ab9:	00 
sub $8, %r8
  801aba:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  801abe:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  801ac1:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  801ac8:	00 
add $16, %rsp
  801ac9:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  801acd:	4c 8b 3c 24          	mov    (%rsp),%r15
  801ad1:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801ad6:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801adb:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801ae0:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801ae5:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801aea:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801aef:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801af4:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801af9:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801afe:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801b03:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801b08:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801b0d:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801b12:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801b17:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  801b1b:	48 83 c4 08          	add    $0x8,%rsp
popf
  801b1f:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  801b20:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  801b24:	c3                   	retq   

0000000000801b25 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801b25:	55                   	push   %rbp
  801b26:	48 89 e5             	mov    %rsp,%rbp
  801b29:	48 83 ec 08          	sub    $0x8,%rsp
  801b2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b31:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b35:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b3c:	ff ff ff 
  801b3f:	48 01 d0             	add    %rdx,%rax
  801b42:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b46:	c9                   	leaveq 
  801b47:	c3                   	retq   

0000000000801b48 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801b48:	55                   	push   %rbp
  801b49:	48 89 e5             	mov    %rsp,%rbp
  801b4c:	48 83 ec 08          	sub    $0x8,%rsp
  801b50:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801b54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b58:	48 89 c7             	mov    %rax,%rdi
  801b5b:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  801b62:	00 00 00 
  801b65:	ff d0                	callq  *%rax
  801b67:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b6d:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b71:	c9                   	leaveq 
  801b72:	c3                   	retq   

0000000000801b73 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b73:	55                   	push   %rbp
  801b74:	48 89 e5             	mov    %rsp,%rbp
  801b77:	48 83 ec 18          	sub    $0x18,%rsp
  801b7b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b86:	eb 6b                	jmp    801bf3 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801b88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8b:	48 98                	cltq   
  801b8d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b93:	48 c1 e0 0c          	shl    $0xc,%rax
  801b97:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801b9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b9f:	48 c1 e8 15          	shr    $0x15,%rax
  801ba3:	48 89 c2             	mov    %rax,%rdx
  801ba6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801bad:	01 00 00 
  801bb0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bb4:	83 e0 01             	and    $0x1,%eax
  801bb7:	48 85 c0             	test   %rax,%rax
  801bba:	74 21                	je     801bdd <fd_alloc+0x6a>
  801bbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bc0:	48 c1 e8 0c          	shr    $0xc,%rax
  801bc4:	48 89 c2             	mov    %rax,%rdx
  801bc7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bce:	01 00 00 
  801bd1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bd5:	83 e0 01             	and    $0x1,%eax
  801bd8:	48 85 c0             	test   %rax,%rax
  801bdb:	75 12                	jne    801bef <fd_alloc+0x7c>
			*fd_store = fd;
  801bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801be8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bed:	eb 1a                	jmp    801c09 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801bef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801bf3:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801bf7:	7e 8f                	jle    801b88 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801bf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bfd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801c04:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c09:	c9                   	leaveq 
  801c0a:	c3                   	retq   

0000000000801c0b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c0b:	55                   	push   %rbp
  801c0c:	48 89 e5             	mov    %rsp,%rbp
  801c0f:	48 83 ec 20          	sub    $0x20,%rsp
  801c13:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c16:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c1e:	78 06                	js     801c26 <fd_lookup+0x1b>
  801c20:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801c24:	7e 07                	jle    801c2d <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c2b:	eb 6c                	jmp    801c99 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801c2d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c30:	48 98                	cltq   
  801c32:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c38:	48 c1 e0 0c          	shl    $0xc,%rax
  801c3c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c44:	48 c1 e8 15          	shr    $0x15,%rax
  801c48:	48 89 c2             	mov    %rax,%rdx
  801c4b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c52:	01 00 00 
  801c55:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c59:	83 e0 01             	and    $0x1,%eax
  801c5c:	48 85 c0             	test   %rax,%rax
  801c5f:	74 21                	je     801c82 <fd_lookup+0x77>
  801c61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c65:	48 c1 e8 0c          	shr    $0xc,%rax
  801c69:	48 89 c2             	mov    %rax,%rdx
  801c6c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c73:	01 00 00 
  801c76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c7a:	83 e0 01             	and    $0x1,%eax
  801c7d:	48 85 c0             	test   %rax,%rax
  801c80:	75 07                	jne    801c89 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c87:	eb 10                	jmp    801c99 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801c89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c8d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c91:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c99:	c9                   	leaveq 
  801c9a:	c3                   	retq   

0000000000801c9b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801c9b:	55                   	push   %rbp
  801c9c:	48 89 e5             	mov    %rsp,%rbp
  801c9f:	48 83 ec 30          	sub    $0x30,%rsp
  801ca3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ca7:	89 f0                	mov    %esi,%eax
  801ca9:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cb0:	48 89 c7             	mov    %rax,%rdi
  801cb3:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  801cba:	00 00 00 
  801cbd:	ff d0                	callq  *%rax
  801cbf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cc3:	48 89 d6             	mov    %rdx,%rsi
  801cc6:	89 c7                	mov    %eax,%edi
  801cc8:	48 b8 0b 1c 80 00 00 	movabs $0x801c0b,%rax
  801ccf:	00 00 00 
  801cd2:	ff d0                	callq  *%rax
  801cd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cdb:	78 0a                	js     801ce7 <fd_close+0x4c>
	    || fd != fd2)
  801cdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce1:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ce5:	74 12                	je     801cf9 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801ce7:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ceb:	74 05                	je     801cf2 <fd_close+0x57>
  801ced:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cf0:	eb 05                	jmp    801cf7 <fd_close+0x5c>
  801cf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf7:	eb 69                	jmp    801d62 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801cf9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cfd:	8b 00                	mov    (%rax),%eax
  801cff:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d03:	48 89 d6             	mov    %rdx,%rsi
  801d06:	89 c7                	mov    %eax,%edi
  801d08:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  801d0f:	00 00 00 
  801d12:	ff d0                	callq  *%rax
  801d14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d1b:	78 2a                	js     801d47 <fd_close+0xac>
		if (dev->dev_close)
  801d1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d21:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d25:	48 85 c0             	test   %rax,%rax
  801d28:	74 16                	je     801d40 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801d2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2e:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d32:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d36:	48 89 d7             	mov    %rdx,%rdi
  801d39:	ff d0                	callq  *%rax
  801d3b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d3e:	eb 07                	jmp    801d47 <fd_close+0xac>
		else
			r = 0;
  801d40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d4b:	48 89 c6             	mov    %rax,%rsi
  801d4e:	bf 00 00 00 00       	mov    $0x0,%edi
  801d53:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  801d5a:	00 00 00 
  801d5d:	ff d0                	callq  *%rax
	return r;
  801d5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d62:	c9                   	leaveq 
  801d63:	c3                   	retq   

0000000000801d64 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d64:	55                   	push   %rbp
  801d65:	48 89 e5             	mov    %rsp,%rbp
  801d68:	48 83 ec 20          	sub    $0x20,%rsp
  801d6c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d6f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801d73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d7a:	eb 41                	jmp    801dbd <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801d7c:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801d83:	00 00 00 
  801d86:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d89:	48 63 d2             	movslq %edx,%rdx
  801d8c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d90:	8b 00                	mov    (%rax),%eax
  801d92:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801d95:	75 22                	jne    801db9 <dev_lookup+0x55>
			*dev = devtab[i];
  801d97:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801d9e:	00 00 00 
  801da1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801da4:	48 63 d2             	movslq %edx,%rdx
  801da7:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801dab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801daf:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801db2:	b8 00 00 00 00       	mov    $0x0,%eax
  801db7:	eb 60                	jmp    801e19 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801db9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dbd:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801dc4:	00 00 00 
  801dc7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801dca:	48 63 d2             	movslq %edx,%rdx
  801dcd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd1:	48 85 c0             	test   %rax,%rax
  801dd4:	75 a6                	jne    801d7c <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801dd6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801ddd:	00 00 00 
  801de0:	48 8b 00             	mov    (%rax),%rax
  801de3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801de9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801dec:	89 c6                	mov    %eax,%esi
  801dee:	48 bf f0 3b 80 00 00 	movabs $0x803bf0,%rdi
  801df5:	00 00 00 
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfd:	48 b9 b5 02 80 00 00 	movabs $0x8002b5,%rcx
  801e04:	00 00 00 
  801e07:	ff d1                	callq  *%rcx
	*dev = 0;
  801e09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e0d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801e14:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e19:	c9                   	leaveq 
  801e1a:	c3                   	retq   

0000000000801e1b <close>:

int
close(int fdnum)
{
  801e1b:	55                   	push   %rbp
  801e1c:	48 89 e5             	mov    %rsp,%rbp
  801e1f:	48 83 ec 20          	sub    $0x20,%rsp
  801e23:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e26:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e2a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e2d:	48 89 d6             	mov    %rdx,%rsi
  801e30:	89 c7                	mov    %eax,%edi
  801e32:	48 b8 0b 1c 80 00 00 	movabs $0x801c0b,%rax
  801e39:	00 00 00 
  801e3c:	ff d0                	callq  *%rax
  801e3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e45:	79 05                	jns    801e4c <close+0x31>
		return r;
  801e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4a:	eb 18                	jmp    801e64 <close+0x49>
	else
		return fd_close(fd, 1);
  801e4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e50:	be 01 00 00 00       	mov    $0x1,%esi
  801e55:	48 89 c7             	mov    %rax,%rdi
  801e58:	48 b8 9b 1c 80 00 00 	movabs $0x801c9b,%rax
  801e5f:	00 00 00 
  801e62:	ff d0                	callq  *%rax
}
  801e64:	c9                   	leaveq 
  801e65:	c3                   	retq   

0000000000801e66 <close_all>:

void
close_all(void)
{
  801e66:	55                   	push   %rbp
  801e67:	48 89 e5             	mov    %rsp,%rbp
  801e6a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e75:	eb 15                	jmp    801e8c <close_all+0x26>
		close(i);
  801e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e7a:	89 c7                	mov    %eax,%edi
  801e7c:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  801e83:	00 00 00 
  801e86:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e88:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e8c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e90:	7e e5                	jle    801e77 <close_all+0x11>
		close(i);
}
  801e92:	c9                   	leaveq 
  801e93:	c3                   	retq   

0000000000801e94 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e94:	55                   	push   %rbp
  801e95:	48 89 e5             	mov    %rsp,%rbp
  801e98:	48 83 ec 40          	sub    $0x40,%rsp
  801e9c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801e9f:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ea2:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801ea6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ea9:	48 89 d6             	mov    %rdx,%rsi
  801eac:	89 c7                	mov    %eax,%edi
  801eae:	48 b8 0b 1c 80 00 00 	movabs $0x801c0b,%rax
  801eb5:	00 00 00 
  801eb8:	ff d0                	callq  *%rax
  801eba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ebd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ec1:	79 08                	jns    801ecb <dup+0x37>
		return r;
  801ec3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec6:	e9 70 01 00 00       	jmpq   80203b <dup+0x1a7>
	close(newfdnum);
  801ecb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ece:	89 c7                	mov    %eax,%edi
  801ed0:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  801ed7:	00 00 00 
  801eda:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801edc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801edf:	48 98                	cltq   
  801ee1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee7:	48 c1 e0 0c          	shl    $0xc,%rax
  801eeb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801eef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef3:	48 89 c7             	mov    %rax,%rdi
  801ef6:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  801efd:	00 00 00 
  801f00:	ff d0                	callq  *%rax
  801f02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801f06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f0a:	48 89 c7             	mov    %rax,%rdi
  801f0d:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  801f14:	00 00 00 
  801f17:	ff d0                	callq  *%rax
  801f19:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f21:	48 c1 e8 15          	shr    $0x15,%rax
  801f25:	48 89 c2             	mov    %rax,%rdx
  801f28:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f2f:	01 00 00 
  801f32:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f36:	83 e0 01             	and    $0x1,%eax
  801f39:	48 85 c0             	test   %rax,%rax
  801f3c:	74 73                	je     801fb1 <dup+0x11d>
  801f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f42:	48 c1 e8 0c          	shr    $0xc,%rax
  801f46:	48 89 c2             	mov    %rax,%rdx
  801f49:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f50:	01 00 00 
  801f53:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f57:	83 e0 01             	and    $0x1,%eax
  801f5a:	48 85 c0             	test   %rax,%rax
  801f5d:	74 52                	je     801fb1 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f63:	48 c1 e8 0c          	shr    $0xc,%rax
  801f67:	48 89 c2             	mov    %rax,%rdx
  801f6a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f71:	01 00 00 
  801f74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f78:	25 07 0e 00 00       	and    $0xe07,%eax
  801f7d:	89 c1                	mov    %eax,%ecx
  801f7f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f87:	41 89 c8             	mov    %ecx,%r8d
  801f8a:	48 89 d1             	mov    %rdx,%rcx
  801f8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f92:	48 89 c6             	mov    %rax,%rsi
  801f95:	bf 00 00 00 00       	mov    $0x0,%edi
  801f9a:	48 b8 e9 17 80 00 00 	movabs $0x8017e9,%rax
  801fa1:	00 00 00 
  801fa4:	ff d0                	callq  *%rax
  801fa6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fad:	79 02                	jns    801fb1 <dup+0x11d>
			goto err;
  801faf:	eb 57                	jmp    802008 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb5:	48 c1 e8 0c          	shr    $0xc,%rax
  801fb9:	48 89 c2             	mov    %rax,%rdx
  801fbc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc3:	01 00 00 
  801fc6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fca:	25 07 0e 00 00       	and    $0xe07,%eax
  801fcf:	89 c1                	mov    %eax,%ecx
  801fd1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fd9:	41 89 c8             	mov    %ecx,%r8d
  801fdc:	48 89 d1             	mov    %rdx,%rcx
  801fdf:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe4:	48 89 c6             	mov    %rax,%rsi
  801fe7:	bf 00 00 00 00       	mov    $0x0,%edi
  801fec:	48 b8 e9 17 80 00 00 	movabs $0x8017e9,%rax
  801ff3:	00 00 00 
  801ff6:	ff d0                	callq  *%rax
  801ff8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ffb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fff:	79 02                	jns    802003 <dup+0x16f>
		goto err;
  802001:	eb 05                	jmp    802008 <dup+0x174>

	return newfdnum;
  802003:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802006:	eb 33                	jmp    80203b <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802008:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80200c:	48 89 c6             	mov    %rax,%rsi
  80200f:	bf 00 00 00 00       	mov    $0x0,%edi
  802014:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  80201b:	00 00 00 
  80201e:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802020:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802024:	48 89 c6             	mov    %rax,%rsi
  802027:	bf 00 00 00 00       	mov    $0x0,%edi
  80202c:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  802033:	00 00 00 
  802036:	ff d0                	callq  *%rax
	return r;
  802038:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80203b:	c9                   	leaveq 
  80203c:	c3                   	retq   

000000000080203d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80203d:	55                   	push   %rbp
  80203e:	48 89 e5             	mov    %rsp,%rbp
  802041:	48 83 ec 40          	sub    $0x40,%rsp
  802045:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802048:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80204c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802050:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802054:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802057:	48 89 d6             	mov    %rdx,%rsi
  80205a:	89 c7                	mov    %eax,%edi
  80205c:	48 b8 0b 1c 80 00 00 	movabs $0x801c0b,%rax
  802063:	00 00 00 
  802066:	ff d0                	callq  *%rax
  802068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80206f:	78 24                	js     802095 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802071:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802075:	8b 00                	mov    (%rax),%eax
  802077:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80207b:	48 89 d6             	mov    %rdx,%rsi
  80207e:	89 c7                	mov    %eax,%edi
  802080:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  802087:	00 00 00 
  80208a:	ff d0                	callq  *%rax
  80208c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80208f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802093:	79 05                	jns    80209a <read+0x5d>
		return r;
  802095:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802098:	eb 76                	jmp    802110 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80209a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209e:	8b 40 08             	mov    0x8(%rax),%eax
  8020a1:	83 e0 03             	and    $0x3,%eax
  8020a4:	83 f8 01             	cmp    $0x1,%eax
  8020a7:	75 3a                	jne    8020e3 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8020b0:	00 00 00 
  8020b3:	48 8b 00             	mov    (%rax),%rax
  8020b6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020bc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020bf:	89 c6                	mov    %eax,%esi
  8020c1:	48 bf 0f 3c 80 00 00 	movabs $0x803c0f,%rdi
  8020c8:	00 00 00 
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d0:	48 b9 b5 02 80 00 00 	movabs $0x8002b5,%rcx
  8020d7:	00 00 00 
  8020da:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020e1:	eb 2d                	jmp    802110 <read+0xd3>
	}
	if (!dev->dev_read)
  8020e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020eb:	48 85 c0             	test   %rax,%rax
  8020ee:	75 07                	jne    8020f7 <read+0xba>
		return -E_NOT_SUPP;
  8020f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020f5:	eb 19                	jmp    802110 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8020f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fb:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020ff:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802103:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802107:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80210b:	48 89 cf             	mov    %rcx,%rdi
  80210e:	ff d0                	callq  *%rax
}
  802110:	c9                   	leaveq 
  802111:	c3                   	retq   

0000000000802112 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802112:	55                   	push   %rbp
  802113:	48 89 e5             	mov    %rsp,%rbp
  802116:	48 83 ec 30          	sub    $0x30,%rsp
  80211a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80211d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802121:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80212c:	eb 49                	jmp    802177 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80212e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802131:	48 98                	cltq   
  802133:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802137:	48 29 c2             	sub    %rax,%rdx
  80213a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213d:	48 63 c8             	movslq %eax,%rcx
  802140:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802144:	48 01 c1             	add    %rax,%rcx
  802147:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80214a:	48 89 ce             	mov    %rcx,%rsi
  80214d:	89 c7                	mov    %eax,%edi
  80214f:	48 b8 3d 20 80 00 00 	movabs $0x80203d,%rax
  802156:	00 00 00 
  802159:	ff d0                	callq  *%rax
  80215b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80215e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802162:	79 05                	jns    802169 <readn+0x57>
			return m;
  802164:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802167:	eb 1c                	jmp    802185 <readn+0x73>
		if (m == 0)
  802169:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80216d:	75 02                	jne    802171 <readn+0x5f>
			break;
  80216f:	eb 11                	jmp    802182 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802171:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802174:	01 45 fc             	add    %eax,-0x4(%rbp)
  802177:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80217a:	48 98                	cltq   
  80217c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802180:	72 ac                	jb     80212e <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802182:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802185:	c9                   	leaveq 
  802186:	c3                   	retq   

0000000000802187 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802187:	55                   	push   %rbp
  802188:	48 89 e5             	mov    %rsp,%rbp
  80218b:	48 83 ec 40          	sub    $0x40,%rsp
  80218f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802192:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802196:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80219a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80219e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021a1:	48 89 d6             	mov    %rdx,%rsi
  8021a4:	89 c7                	mov    %eax,%edi
  8021a6:	48 b8 0b 1c 80 00 00 	movabs $0x801c0b,%rax
  8021ad:	00 00 00 
  8021b0:	ff d0                	callq  *%rax
  8021b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b9:	78 24                	js     8021df <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021bf:	8b 00                	mov    (%rax),%eax
  8021c1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021c5:	48 89 d6             	mov    %rdx,%rsi
  8021c8:	89 c7                	mov    %eax,%edi
  8021ca:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  8021d1:	00 00 00 
  8021d4:	ff d0                	callq  *%rax
  8021d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021dd:	79 05                	jns    8021e4 <write+0x5d>
		return r;
  8021df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e2:	eb 75                	jmp    802259 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e8:	8b 40 08             	mov    0x8(%rax),%eax
  8021eb:	83 e0 03             	and    $0x3,%eax
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	75 3a                	jne    80222c <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8021f2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021f9:	00 00 00 
  8021fc:	48 8b 00             	mov    (%rax),%rax
  8021ff:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802205:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802208:	89 c6                	mov    %eax,%esi
  80220a:	48 bf 2b 3c 80 00 00 	movabs $0x803c2b,%rdi
  802211:	00 00 00 
  802214:	b8 00 00 00 00       	mov    $0x0,%eax
  802219:	48 b9 b5 02 80 00 00 	movabs $0x8002b5,%rcx
  802220:	00 00 00 
  802223:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802225:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80222a:	eb 2d                	jmp    802259 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80222c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802230:	48 8b 40 18          	mov    0x18(%rax),%rax
  802234:	48 85 c0             	test   %rax,%rax
  802237:	75 07                	jne    802240 <write+0xb9>
		return -E_NOT_SUPP;
  802239:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80223e:	eb 19                	jmp    802259 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802240:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802244:	48 8b 40 18          	mov    0x18(%rax),%rax
  802248:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80224c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802250:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802254:	48 89 cf             	mov    %rcx,%rdi
  802257:	ff d0                	callq  *%rax
}
  802259:	c9                   	leaveq 
  80225a:	c3                   	retq   

000000000080225b <seek>:

int
seek(int fdnum, off_t offset)
{
  80225b:	55                   	push   %rbp
  80225c:	48 89 e5             	mov    %rsp,%rbp
  80225f:	48 83 ec 18          	sub    $0x18,%rsp
  802263:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802266:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802269:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80226d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802270:	48 89 d6             	mov    %rdx,%rsi
  802273:	89 c7                	mov    %eax,%edi
  802275:	48 b8 0b 1c 80 00 00 	movabs $0x801c0b,%rax
  80227c:	00 00 00 
  80227f:	ff d0                	callq  *%rax
  802281:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802284:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802288:	79 05                	jns    80228f <seek+0x34>
		return r;
  80228a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228d:	eb 0f                	jmp    80229e <seek+0x43>
	fd->fd_offset = offset;
  80228f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802293:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802296:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802299:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229e:	c9                   	leaveq 
  80229f:	c3                   	retq   

00000000008022a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8022a0:	55                   	push   %rbp
  8022a1:	48 89 e5             	mov    %rsp,%rbp
  8022a4:	48 83 ec 30          	sub    $0x30,%rsp
  8022a8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022ab:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022ae:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022b2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022b5:	48 89 d6             	mov    %rdx,%rsi
  8022b8:	89 c7                	mov    %eax,%edi
  8022ba:	48 b8 0b 1c 80 00 00 	movabs $0x801c0b,%rax
  8022c1:	00 00 00 
  8022c4:	ff d0                	callq  *%rax
  8022c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022cd:	78 24                	js     8022f3 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d3:	8b 00                	mov    (%rax),%eax
  8022d5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022d9:	48 89 d6             	mov    %rdx,%rsi
  8022dc:	89 c7                	mov    %eax,%edi
  8022de:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  8022e5:	00 00 00 
  8022e8:	ff d0                	callq  *%rax
  8022ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f1:	79 05                	jns    8022f8 <ftruncate+0x58>
		return r;
  8022f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f6:	eb 72                	jmp    80236a <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022fc:	8b 40 08             	mov    0x8(%rax),%eax
  8022ff:	83 e0 03             	and    $0x3,%eax
  802302:	85 c0                	test   %eax,%eax
  802304:	75 3a                	jne    802340 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802306:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80230d:	00 00 00 
  802310:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802313:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802319:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80231c:	89 c6                	mov    %eax,%esi
  80231e:	48 bf 48 3c 80 00 00 	movabs $0x803c48,%rdi
  802325:	00 00 00 
  802328:	b8 00 00 00 00       	mov    $0x0,%eax
  80232d:	48 b9 b5 02 80 00 00 	movabs $0x8002b5,%rcx
  802334:	00 00 00 
  802337:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802339:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80233e:	eb 2a                	jmp    80236a <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802340:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802344:	48 8b 40 30          	mov    0x30(%rax),%rax
  802348:	48 85 c0             	test   %rax,%rax
  80234b:	75 07                	jne    802354 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80234d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802352:	eb 16                	jmp    80236a <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802354:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802358:	48 8b 40 30          	mov    0x30(%rax),%rax
  80235c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802360:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802363:	89 ce                	mov    %ecx,%esi
  802365:	48 89 d7             	mov    %rdx,%rdi
  802368:	ff d0                	callq  *%rax
}
  80236a:	c9                   	leaveq 
  80236b:	c3                   	retq   

000000000080236c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80236c:	55                   	push   %rbp
  80236d:	48 89 e5             	mov    %rsp,%rbp
  802370:	48 83 ec 30          	sub    $0x30,%rsp
  802374:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802377:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80237b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80237f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802382:	48 89 d6             	mov    %rdx,%rsi
  802385:	89 c7                	mov    %eax,%edi
  802387:	48 b8 0b 1c 80 00 00 	movabs $0x801c0b,%rax
  80238e:	00 00 00 
  802391:	ff d0                	callq  *%rax
  802393:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802396:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80239a:	78 24                	js     8023c0 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80239c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a0:	8b 00                	mov    (%rax),%eax
  8023a2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023a6:	48 89 d6             	mov    %rdx,%rsi
  8023a9:	89 c7                	mov    %eax,%edi
  8023ab:	48 b8 64 1d 80 00 00 	movabs $0x801d64,%rax
  8023b2:	00 00 00 
  8023b5:	ff d0                	callq  *%rax
  8023b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023be:	79 05                	jns    8023c5 <fstat+0x59>
		return r;
  8023c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c3:	eb 5e                	jmp    802423 <fstat+0xb7>
	if (!dev->dev_stat)
  8023c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c9:	48 8b 40 28          	mov    0x28(%rax),%rax
  8023cd:	48 85 c0             	test   %rax,%rax
  8023d0:	75 07                	jne    8023d9 <fstat+0x6d>
		return -E_NOT_SUPP;
  8023d2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023d7:	eb 4a                	jmp    802423 <fstat+0xb7>
	stat->st_name[0] = 0;
  8023d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023dd:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8023e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023e4:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8023eb:	00 00 00 
	stat->st_isdir = 0;
  8023ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023f2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023f9:	00 00 00 
	stat->st_dev = dev;
  8023fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802400:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802404:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80240b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80240f:	48 8b 40 28          	mov    0x28(%rax),%rax
  802413:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802417:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80241b:	48 89 ce             	mov    %rcx,%rsi
  80241e:	48 89 d7             	mov    %rdx,%rdi
  802421:	ff d0                	callq  *%rax
}
  802423:	c9                   	leaveq 
  802424:	c3                   	retq   

0000000000802425 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802425:	55                   	push   %rbp
  802426:	48 89 e5             	mov    %rsp,%rbp
  802429:	48 83 ec 20          	sub    $0x20,%rsp
  80242d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802431:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802435:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802439:	be 00 00 00 00       	mov    $0x0,%esi
  80243e:	48 89 c7             	mov    %rax,%rdi
  802441:	48 b8 13 25 80 00 00 	movabs $0x802513,%rax
  802448:	00 00 00 
  80244b:	ff d0                	callq  *%rax
  80244d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802450:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802454:	79 05                	jns    80245b <stat+0x36>
		return fd;
  802456:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802459:	eb 2f                	jmp    80248a <stat+0x65>
	r = fstat(fd, stat);
  80245b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80245f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802462:	48 89 d6             	mov    %rdx,%rsi
  802465:	89 c7                	mov    %eax,%edi
  802467:	48 b8 6c 23 80 00 00 	movabs $0x80236c,%rax
  80246e:	00 00 00 
  802471:	ff d0                	callq  *%rax
  802473:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802476:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802479:	89 c7                	mov    %eax,%edi
  80247b:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  802482:	00 00 00 
  802485:	ff d0                	callq  *%rax
	return r;
  802487:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80248a:	c9                   	leaveq 
  80248b:	c3                   	retq   

000000000080248c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80248c:	55                   	push   %rbp
  80248d:	48 89 e5             	mov    %rsp,%rbp
  802490:	48 83 ec 10          	sub    $0x10,%rsp
  802494:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802497:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80249b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8024a2:	00 00 00 
  8024a5:	8b 00                	mov    (%rax),%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	75 1d                	jne    8024c8 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8024ab:	bf 01 00 00 00       	mov    $0x1,%edi
  8024b0:	48 b8 69 35 80 00 00 	movabs $0x803569,%rax
  8024b7:	00 00 00 
  8024ba:	ff d0                	callq  *%rax
  8024bc:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8024c3:	00 00 00 
  8024c6:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8024c8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8024cf:	00 00 00 
  8024d2:	8b 00                	mov    (%rax),%eax
  8024d4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024d7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8024dc:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8024e3:	00 00 00 
  8024e6:	89 c7                	mov    %eax,%edi
  8024e8:	48 b8 cc 34 80 00 00 	movabs $0x8034cc,%rax
  8024ef:	00 00 00 
  8024f2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8024f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fd:	48 89 c6             	mov    %rax,%rsi
  802500:	bf 00 00 00 00       	mov    $0x0,%edi
  802505:	48 b8 06 34 80 00 00 	movabs $0x803406,%rax
  80250c:	00 00 00 
  80250f:	ff d0                	callq  *%rax
}
  802511:	c9                   	leaveq 
  802512:	c3                   	retq   

0000000000802513 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802513:	55                   	push   %rbp
  802514:	48 89 e5             	mov    %rsp,%rbp
  802517:	48 83 ec 20          	sub    $0x20,%rsp
  80251b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80251f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802526:	48 89 c7             	mov    %rax,%rdi
  802529:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  802530:	00 00 00 
  802533:	ff d0                	callq  *%rax
  802535:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80253a:	7e 0a                	jle    802546 <open+0x33>
  80253c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802541:	e9 a5 00 00 00       	jmpq   8025eb <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802546:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80254a:	48 89 c7             	mov    %rax,%rdi
  80254d:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  802554:	00 00 00 
  802557:	ff d0                	callq  *%rax
  802559:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802560:	79 08                	jns    80256a <open+0x57>
		return r;
  802562:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802565:	e9 81 00 00 00       	jmpq   8025eb <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  80256a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802571:	00 00 00 
  802574:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802577:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80257d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802581:	48 89 c6             	mov    %rax,%rsi
  802584:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80258b:	00 00 00 
  80258e:	48 b8 6a 0e 80 00 00 	movabs $0x800e6a,%rax
  802595:	00 00 00 
  802598:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  80259a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259e:	48 89 c6             	mov    %rax,%rsi
  8025a1:	bf 01 00 00 00       	mov    $0x1,%edi
  8025a6:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  8025ad:	00 00 00 
  8025b0:	ff d0                	callq  *%rax
  8025b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b9:	79 1d                	jns    8025d8 <open+0xc5>
		fd_close(fd, 0);
  8025bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025bf:	be 00 00 00 00       	mov    $0x0,%esi
  8025c4:	48 89 c7             	mov    %rax,%rdi
  8025c7:	48 b8 9b 1c 80 00 00 	movabs $0x801c9b,%rax
  8025ce:	00 00 00 
  8025d1:	ff d0                	callq  *%rax
		return r;
  8025d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d6:	eb 13                	jmp    8025eb <open+0xd8>
	}
	return fd2num(fd);
  8025d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025dc:	48 89 c7             	mov    %rax,%rdi
  8025df:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  8025e6:	00 00 00 
  8025e9:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  8025eb:	c9                   	leaveq 
  8025ec:	c3                   	retq   

00000000008025ed <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025ed:	55                   	push   %rbp
  8025ee:	48 89 e5             	mov    %rsp,%rbp
  8025f1:	48 83 ec 10          	sub    $0x10,%rsp
  8025f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025fd:	8b 50 0c             	mov    0xc(%rax),%edx
  802600:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802607:	00 00 00 
  80260a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80260c:	be 00 00 00 00       	mov    $0x0,%esi
  802611:	bf 06 00 00 00       	mov    $0x6,%edi
  802616:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  80261d:	00 00 00 
  802620:	ff d0                	callq  *%rax
}
  802622:	c9                   	leaveq 
  802623:	c3                   	retq   

0000000000802624 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802624:	55                   	push   %rbp
  802625:	48 89 e5             	mov    %rsp,%rbp
  802628:	48 83 ec 30          	sub    $0x30,%rsp
  80262c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802630:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802634:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802638:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263c:	8b 50 0c             	mov    0xc(%rax),%edx
  80263f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802646:	00 00 00 
  802649:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80264b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802652:	00 00 00 
  802655:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802659:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  80265d:	be 00 00 00 00       	mov    $0x0,%esi
  802662:	bf 03 00 00 00       	mov    $0x3,%edi
  802667:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  80266e:	00 00 00 
  802671:	ff d0                	callq  *%rax
  802673:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802676:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267a:	79 05                	jns    802681 <devfile_read+0x5d>
		return r;
  80267c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267f:	eb 26                	jmp    8026a7 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802681:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802684:	48 63 d0             	movslq %eax,%rdx
  802687:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80268b:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802692:	00 00 00 
  802695:	48 89 c7             	mov    %rax,%rdi
  802698:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  80269f:	00 00 00 
  8026a2:	ff d0                	callq  *%rax
	return r;
  8026a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8026a7:	c9                   	leaveq 
  8026a8:	c3                   	retq   

00000000008026a9 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8026a9:	55                   	push   %rbp
  8026aa:	48 89 e5             	mov    %rsp,%rbp
  8026ad:	48 83 ec 30          	sub    $0x30,%rsp
  8026b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  8026bd:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  8026c4:	00 
	n = n > max ? max : n;
  8026c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026c9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026cd:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8026d2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8026d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026da:	8b 50 0c             	mov    0xc(%rax),%edx
  8026dd:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026e4:	00 00 00 
  8026e7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8026e9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026f0:	00 00 00 
  8026f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026f7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8026fb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802703:	48 89 c6             	mov    %rax,%rsi
  802706:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  80270d:	00 00 00 
  802710:	48 b8 a5 12 80 00 00 	movabs $0x8012a5,%rax
  802717:	00 00 00 
  80271a:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  80271c:	be 00 00 00 00       	mov    $0x0,%esi
  802721:	bf 04 00 00 00       	mov    $0x4,%edi
  802726:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  80272d:	00 00 00 
  802730:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802732:	c9                   	leaveq 
  802733:	c3                   	retq   

0000000000802734 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802734:	55                   	push   %rbp
  802735:	48 89 e5             	mov    %rsp,%rbp
  802738:	48 83 ec 20          	sub    $0x20,%rsp
  80273c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802740:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802744:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802748:	8b 50 0c             	mov    0xc(%rax),%edx
  80274b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802752:	00 00 00 
  802755:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802757:	be 00 00 00 00       	mov    $0x0,%esi
  80275c:	bf 05 00 00 00       	mov    $0x5,%edi
  802761:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  802768:	00 00 00 
  80276b:	ff d0                	callq  *%rax
  80276d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802770:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802774:	79 05                	jns    80277b <devfile_stat+0x47>
		return r;
  802776:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802779:	eb 56                	jmp    8027d1 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80277b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80277f:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802786:	00 00 00 
  802789:	48 89 c7             	mov    %rax,%rdi
  80278c:	48 b8 6a 0e 80 00 00 	movabs $0x800e6a,%rax
  802793:	00 00 00 
  802796:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802798:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80279f:	00 00 00 
  8027a2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8027a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ac:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8027b2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027b9:	00 00 00 
  8027bc:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8027c2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c6:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8027cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d1:	c9                   	leaveq 
  8027d2:	c3                   	retq   

00000000008027d3 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8027d3:	55                   	push   %rbp
  8027d4:	48 89 e5             	mov    %rsp,%rbp
  8027d7:	48 83 ec 10          	sub    $0x10,%rsp
  8027db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027df:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8027e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027e6:	8b 50 0c             	mov    0xc(%rax),%edx
  8027e9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027f0:	00 00 00 
  8027f3:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8027f5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027fc:	00 00 00 
  8027ff:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802802:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802805:	be 00 00 00 00       	mov    $0x0,%esi
  80280a:	bf 02 00 00 00       	mov    $0x2,%edi
  80280f:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  802816:	00 00 00 
  802819:	ff d0                	callq  *%rax
}
  80281b:	c9                   	leaveq 
  80281c:	c3                   	retq   

000000000080281d <remove>:

// Delete a file
int
remove(const char *path)
{
  80281d:	55                   	push   %rbp
  80281e:	48 89 e5             	mov    %rsp,%rbp
  802821:	48 83 ec 10          	sub    $0x10,%rsp
  802825:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802829:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80282d:	48 89 c7             	mov    %rax,%rdi
  802830:	48 b8 fe 0d 80 00 00 	movabs $0x800dfe,%rax
  802837:	00 00 00 
  80283a:	ff d0                	callq  *%rax
  80283c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802841:	7e 07                	jle    80284a <remove+0x2d>
		return -E_BAD_PATH;
  802843:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802848:	eb 33                	jmp    80287d <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80284a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80284e:	48 89 c6             	mov    %rax,%rsi
  802851:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802858:	00 00 00 
  80285b:	48 b8 6a 0e 80 00 00 	movabs $0x800e6a,%rax
  802862:	00 00 00 
  802865:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802867:	be 00 00 00 00       	mov    $0x0,%esi
  80286c:	bf 07 00 00 00       	mov    $0x7,%edi
  802871:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  802878:	00 00 00 
  80287b:	ff d0                	callq  *%rax
}
  80287d:	c9                   	leaveq 
  80287e:	c3                   	retq   

000000000080287f <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80287f:	55                   	push   %rbp
  802880:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802883:	be 00 00 00 00       	mov    $0x0,%esi
  802888:	bf 08 00 00 00       	mov    $0x8,%edi
  80288d:	48 b8 8c 24 80 00 00 	movabs $0x80248c,%rax
  802894:	00 00 00 
  802897:	ff d0                	callq  *%rax
}
  802899:	5d                   	pop    %rbp
  80289a:	c3                   	retq   

000000000080289b <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80289b:	55                   	push   %rbp
  80289c:	48 89 e5             	mov    %rsp,%rbp
  80289f:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8028a6:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8028ad:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8028b4:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8028bb:	be 00 00 00 00       	mov    $0x0,%esi
  8028c0:	48 89 c7             	mov    %rax,%rdi
  8028c3:	48 b8 13 25 80 00 00 	movabs $0x802513,%rax
  8028ca:	00 00 00 
  8028cd:	ff d0                	callq  *%rax
  8028cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8028d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d6:	79 28                	jns    802900 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8028d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028db:	89 c6                	mov    %eax,%esi
  8028dd:	48 bf 6e 3c 80 00 00 	movabs $0x803c6e,%rdi
  8028e4:	00 00 00 
  8028e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ec:	48 ba b5 02 80 00 00 	movabs $0x8002b5,%rdx
  8028f3:	00 00 00 
  8028f6:	ff d2                	callq  *%rdx
		return fd_src;
  8028f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fb:	e9 74 01 00 00       	jmpq   802a74 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802900:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802907:	be 01 01 00 00       	mov    $0x101,%esi
  80290c:	48 89 c7             	mov    %rax,%rdi
  80290f:	48 b8 13 25 80 00 00 	movabs $0x802513,%rax
  802916:	00 00 00 
  802919:	ff d0                	callq  *%rax
  80291b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80291e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802922:	79 39                	jns    80295d <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802924:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802927:	89 c6                	mov    %eax,%esi
  802929:	48 bf 84 3c 80 00 00 	movabs $0x803c84,%rdi
  802930:	00 00 00 
  802933:	b8 00 00 00 00       	mov    $0x0,%eax
  802938:	48 ba b5 02 80 00 00 	movabs $0x8002b5,%rdx
  80293f:	00 00 00 
  802942:	ff d2                	callq  *%rdx
		close(fd_src);
  802944:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802947:	89 c7                	mov    %eax,%edi
  802949:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  802950:	00 00 00 
  802953:	ff d0                	callq  *%rax
		return fd_dest;
  802955:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802958:	e9 17 01 00 00       	jmpq   802a74 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80295d:	eb 74                	jmp    8029d3 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80295f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802962:	48 63 d0             	movslq %eax,%rdx
  802965:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80296c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80296f:	48 89 ce             	mov    %rcx,%rsi
  802972:	89 c7                	mov    %eax,%edi
  802974:	48 b8 87 21 80 00 00 	movabs $0x802187,%rax
  80297b:	00 00 00 
  80297e:	ff d0                	callq  *%rax
  802980:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802983:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802987:	79 4a                	jns    8029d3 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802989:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80298c:	89 c6                	mov    %eax,%esi
  80298e:	48 bf 9e 3c 80 00 00 	movabs $0x803c9e,%rdi
  802995:	00 00 00 
  802998:	b8 00 00 00 00       	mov    $0x0,%eax
  80299d:	48 ba b5 02 80 00 00 	movabs $0x8002b5,%rdx
  8029a4:	00 00 00 
  8029a7:	ff d2                	callq  *%rdx
			close(fd_src);
  8029a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ac:	89 c7                	mov    %eax,%edi
  8029ae:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  8029b5:	00 00 00 
  8029b8:	ff d0                	callq  *%rax
			close(fd_dest);
  8029ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029bd:	89 c7                	mov    %eax,%edi
  8029bf:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  8029c6:	00 00 00 
  8029c9:	ff d0                	callq  *%rax
			return write_size;
  8029cb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029ce:	e9 a1 00 00 00       	jmpq   802a74 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8029d3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8029da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029dd:	ba 00 02 00 00       	mov    $0x200,%edx
  8029e2:	48 89 ce             	mov    %rcx,%rsi
  8029e5:	89 c7                	mov    %eax,%edi
  8029e7:	48 b8 3d 20 80 00 00 	movabs $0x80203d,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
  8029f3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8029f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029fa:	0f 8f 5f ff ff ff    	jg     80295f <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802a00:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a04:	79 47                	jns    802a4d <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802a06:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a09:	89 c6                	mov    %eax,%esi
  802a0b:	48 bf b1 3c 80 00 00 	movabs $0x803cb1,%rdi
  802a12:	00 00 00 
  802a15:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1a:	48 ba b5 02 80 00 00 	movabs $0x8002b5,%rdx
  802a21:	00 00 00 
  802a24:	ff d2                	callq  *%rdx
		close(fd_src);
  802a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a29:	89 c7                	mov    %eax,%edi
  802a2b:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  802a32:	00 00 00 
  802a35:	ff d0                	callq  *%rax
		close(fd_dest);
  802a37:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a3a:	89 c7                	mov    %eax,%edi
  802a3c:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  802a43:	00 00 00 
  802a46:	ff d0                	callq  *%rax
		return read_size;
  802a48:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a4b:	eb 27                	jmp    802a74 <copy+0x1d9>
	}
	close(fd_src);
  802a4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a50:	89 c7                	mov    %eax,%edi
  802a52:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
	close(fd_dest);
  802a5e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a61:	89 c7                	mov    %eax,%edi
  802a63:	48 b8 1b 1e 80 00 00 	movabs $0x801e1b,%rax
  802a6a:	00 00 00 
  802a6d:	ff d0                	callq  *%rax
	return 0;
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802a74:	c9                   	leaveq 
  802a75:	c3                   	retq   

0000000000802a76 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a76:	55                   	push   %rbp
  802a77:	48 89 e5             	mov    %rsp,%rbp
  802a7a:	53                   	push   %rbx
  802a7b:	48 83 ec 38          	sub    $0x38,%rsp
  802a7f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a83:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802a87:	48 89 c7             	mov    %rax,%rdi
  802a8a:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  802a91:	00 00 00 
  802a94:	ff d0                	callq  *%rax
  802a96:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a99:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a9d:	0f 88 bf 01 00 00    	js     802c62 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802aa3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa7:	ba 07 04 00 00       	mov    $0x407,%edx
  802aac:	48 89 c6             	mov    %rax,%rsi
  802aaf:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab4:	48 b8 99 17 80 00 00 	movabs $0x801799,%rax
  802abb:	00 00 00 
  802abe:	ff d0                	callq  *%rax
  802ac0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ac3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ac7:	0f 88 95 01 00 00    	js     802c62 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802acd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802ad1:	48 89 c7             	mov    %rax,%rdi
  802ad4:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  802adb:	00 00 00 
  802ade:	ff d0                	callq  *%rax
  802ae0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ae3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ae7:	0f 88 5d 01 00 00    	js     802c4a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802aed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802af1:	ba 07 04 00 00       	mov    $0x407,%edx
  802af6:	48 89 c6             	mov    %rax,%rsi
  802af9:	bf 00 00 00 00       	mov    $0x0,%edi
  802afe:	48 b8 99 17 80 00 00 	movabs $0x801799,%rax
  802b05:	00 00 00 
  802b08:	ff d0                	callq  *%rax
  802b0a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b11:	0f 88 33 01 00 00    	js     802c4a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802b17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b1b:	48 89 c7             	mov    %rax,%rdi
  802b1e:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  802b25:	00 00 00 
  802b28:	ff d0                	callq  *%rax
  802b2a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b32:	ba 07 04 00 00       	mov    $0x407,%edx
  802b37:	48 89 c6             	mov    %rax,%rsi
  802b3a:	bf 00 00 00 00       	mov    $0x0,%edi
  802b3f:	48 b8 99 17 80 00 00 	movabs $0x801799,%rax
  802b46:	00 00 00 
  802b49:	ff d0                	callq  *%rax
  802b4b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b52:	79 05                	jns    802b59 <pipe+0xe3>
		goto err2;
  802b54:	e9 d9 00 00 00       	jmpq   802c32 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b5d:	48 89 c7             	mov    %rax,%rdi
  802b60:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  802b67:	00 00 00 
  802b6a:	ff d0                	callq  *%rax
  802b6c:	48 89 c2             	mov    %rax,%rdx
  802b6f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b73:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802b79:	48 89 d1             	mov    %rdx,%rcx
  802b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b81:	48 89 c6             	mov    %rax,%rsi
  802b84:	bf 00 00 00 00       	mov    $0x0,%edi
  802b89:	48 b8 e9 17 80 00 00 	movabs $0x8017e9,%rax
  802b90:	00 00 00 
  802b93:	ff d0                	callq  *%rax
  802b95:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802b98:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b9c:	79 1b                	jns    802bb9 <pipe+0x143>
		goto err3;
  802b9e:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802b9f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ba3:	48 89 c6             	mov    %rax,%rsi
  802ba6:	bf 00 00 00 00       	mov    $0x0,%edi
  802bab:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  802bb2:	00 00 00 
  802bb5:	ff d0                	callq  *%rax
  802bb7:	eb 79                	jmp    802c32 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802bb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bbd:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802bc4:	00 00 00 
  802bc7:	8b 12                	mov    (%rdx),%edx
  802bc9:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802bcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bcf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802bd6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bda:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802be1:	00 00 00 
  802be4:	8b 12                	mov    (%rdx),%edx
  802be6:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802be8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802bf3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bf7:	48 89 c7             	mov    %rax,%rdi
  802bfa:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  802c01:	00 00 00 
  802c04:	ff d0                	callq  *%rax
  802c06:	89 c2                	mov    %eax,%edx
  802c08:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c0c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802c0e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c12:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802c16:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c1a:	48 89 c7             	mov    %rax,%rdi
  802c1d:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  802c24:	00 00 00 
  802c27:	ff d0                	callq  *%rax
  802c29:	89 03                	mov    %eax,(%rbx)
	return 0;
  802c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c30:	eb 33                	jmp    802c65 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802c32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c36:	48 89 c6             	mov    %rax,%rsi
  802c39:	bf 00 00 00 00       	mov    $0x0,%edi
  802c3e:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  802c45:	00 00 00 
  802c48:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802c4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c4e:	48 89 c6             	mov    %rax,%rsi
  802c51:	bf 00 00 00 00       	mov    $0x0,%edi
  802c56:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  802c5d:	00 00 00 
  802c60:	ff d0                	callq  *%rax
err:
	return r;
  802c62:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802c65:	48 83 c4 38          	add    $0x38,%rsp
  802c69:	5b                   	pop    %rbx
  802c6a:	5d                   	pop    %rbp
  802c6b:	c3                   	retq   

0000000000802c6c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802c6c:	55                   	push   %rbp
  802c6d:	48 89 e5             	mov    %rsp,%rbp
  802c70:	53                   	push   %rbx
  802c71:	48 83 ec 28          	sub    $0x28,%rsp
  802c75:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c79:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c7d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c84:	00 00 00 
  802c87:	48 8b 00             	mov    (%rax),%rax
  802c8a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802c90:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802c93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c97:	48 89 c7             	mov    %rax,%rdi
  802c9a:	48 b8 eb 35 80 00 00 	movabs $0x8035eb,%rax
  802ca1:	00 00 00 
  802ca4:	ff d0                	callq  *%rax
  802ca6:	89 c3                	mov    %eax,%ebx
  802ca8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cac:	48 89 c7             	mov    %rax,%rdi
  802caf:	48 b8 eb 35 80 00 00 	movabs $0x8035eb,%rax
  802cb6:	00 00 00 
  802cb9:	ff d0                	callq  *%rax
  802cbb:	39 c3                	cmp    %eax,%ebx
  802cbd:	0f 94 c0             	sete   %al
  802cc0:	0f b6 c0             	movzbl %al,%eax
  802cc3:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802cc6:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802ccd:	00 00 00 
  802cd0:	48 8b 00             	mov    (%rax),%rax
  802cd3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802cd9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802cdc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cdf:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802ce2:	75 05                	jne    802ce9 <_pipeisclosed+0x7d>
			return ret;
  802ce4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ce7:	eb 4f                	jmp    802d38 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802ce9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cec:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802cef:	74 42                	je     802d33 <_pipeisclosed+0xc7>
  802cf1:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802cf5:	75 3c                	jne    802d33 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802cf7:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802cfe:	00 00 00 
  802d01:	48 8b 00             	mov    (%rax),%rax
  802d04:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802d0a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802d0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d10:	89 c6                	mov    %eax,%esi
  802d12:	48 bf cc 3c 80 00 00 	movabs $0x803ccc,%rdi
  802d19:	00 00 00 
  802d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d21:	49 b8 b5 02 80 00 00 	movabs $0x8002b5,%r8
  802d28:	00 00 00 
  802d2b:	41 ff d0             	callq  *%r8
	}
  802d2e:	e9 4a ff ff ff       	jmpq   802c7d <_pipeisclosed+0x11>
  802d33:	e9 45 ff ff ff       	jmpq   802c7d <_pipeisclosed+0x11>
}
  802d38:	48 83 c4 28          	add    $0x28,%rsp
  802d3c:	5b                   	pop    %rbx
  802d3d:	5d                   	pop    %rbp
  802d3e:	c3                   	retq   

0000000000802d3f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802d3f:	55                   	push   %rbp
  802d40:	48 89 e5             	mov    %rsp,%rbp
  802d43:	48 83 ec 30          	sub    $0x30,%rsp
  802d47:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d4a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d4e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d51:	48 89 d6             	mov    %rdx,%rsi
  802d54:	89 c7                	mov    %eax,%edi
  802d56:	48 b8 0b 1c 80 00 00 	movabs $0x801c0b,%rax
  802d5d:	00 00 00 
  802d60:	ff d0                	callq  *%rax
  802d62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d69:	79 05                	jns    802d70 <pipeisclosed+0x31>
		return r;
  802d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d6e:	eb 31                	jmp    802da1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802d70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d74:	48 89 c7             	mov    %rax,%rdi
  802d77:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  802d7e:	00 00 00 
  802d81:	ff d0                	callq  *%rax
  802d83:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802d87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d8b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d8f:	48 89 d6             	mov    %rdx,%rsi
  802d92:	48 89 c7             	mov    %rax,%rdi
  802d95:	48 b8 6c 2c 80 00 00 	movabs $0x802c6c,%rax
  802d9c:	00 00 00 
  802d9f:	ff d0                	callq  *%rax
}
  802da1:	c9                   	leaveq 
  802da2:	c3                   	retq   

0000000000802da3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802da3:	55                   	push   %rbp
  802da4:	48 89 e5             	mov    %rsp,%rbp
  802da7:	48 83 ec 40          	sub    $0x40,%rsp
  802dab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802daf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802db3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802db7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dbb:	48 89 c7             	mov    %rax,%rdi
  802dbe:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  802dc5:	00 00 00 
  802dc8:	ff d0                	callq  *%rax
  802dca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802dce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802dd6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ddd:	00 
  802dde:	e9 92 00 00 00       	jmpq   802e75 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802de3:	eb 41                	jmp    802e26 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802de5:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802dea:	74 09                	je     802df5 <devpipe_read+0x52>
				return i;
  802dec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802df0:	e9 92 00 00 00       	jmpq   802e87 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802df5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802df9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dfd:	48 89 d6             	mov    %rdx,%rsi
  802e00:	48 89 c7             	mov    %rax,%rdi
  802e03:	48 b8 6c 2c 80 00 00 	movabs $0x802c6c,%rax
  802e0a:	00 00 00 
  802e0d:	ff d0                	callq  *%rax
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	74 07                	je     802e1a <devpipe_read+0x77>
				return 0;
  802e13:	b8 00 00 00 00       	mov    $0x0,%eax
  802e18:	eb 6d                	jmp    802e87 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802e1a:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  802e21:	00 00 00 
  802e24:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802e26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e2a:	8b 10                	mov    (%rax),%edx
  802e2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e30:	8b 40 04             	mov    0x4(%rax),%eax
  802e33:	39 c2                	cmp    %eax,%edx
  802e35:	74 ae                	je     802de5 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e3b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e3f:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e47:	8b 00                	mov    (%rax),%eax
  802e49:	99                   	cltd   
  802e4a:	c1 ea 1b             	shr    $0x1b,%edx
  802e4d:	01 d0                	add    %edx,%eax
  802e4f:	83 e0 1f             	and    $0x1f,%eax
  802e52:	29 d0                	sub    %edx,%eax
  802e54:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e58:	48 98                	cltq   
  802e5a:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802e5f:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e65:	8b 00                	mov    (%rax),%eax
  802e67:	8d 50 01             	lea    0x1(%rax),%edx
  802e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e6e:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e70:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e79:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e7d:	0f 82 60 ff ff ff    	jb     802de3 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802e83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e87:	c9                   	leaveq 
  802e88:	c3                   	retq   

0000000000802e89 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e89:	55                   	push   %rbp
  802e8a:	48 89 e5             	mov    %rsp,%rbp
  802e8d:	48 83 ec 40          	sub    $0x40,%rsp
  802e91:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e95:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e99:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802e9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ea1:	48 89 c7             	mov    %rax,%rdi
  802ea4:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  802eab:	00 00 00 
  802eae:	ff d0                	callq  *%rax
  802eb0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802eb4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802ebc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ec3:	00 
  802ec4:	e9 8e 00 00 00       	jmpq   802f57 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ec9:	eb 31                	jmp    802efc <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802ecb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ecf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ed3:	48 89 d6             	mov    %rdx,%rsi
  802ed6:	48 89 c7             	mov    %rax,%rdi
  802ed9:	48 b8 6c 2c 80 00 00 	movabs $0x802c6c,%rax
  802ee0:	00 00 00 
  802ee3:	ff d0                	callq  *%rax
  802ee5:	85 c0                	test   %eax,%eax
  802ee7:	74 07                	je     802ef0 <devpipe_write+0x67>
				return 0;
  802ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  802eee:	eb 79                	jmp    802f69 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802ef0:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802efc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f00:	8b 40 04             	mov    0x4(%rax),%eax
  802f03:	48 63 d0             	movslq %eax,%rdx
  802f06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0a:	8b 00                	mov    (%rax),%eax
  802f0c:	48 98                	cltq   
  802f0e:	48 83 c0 20          	add    $0x20,%rax
  802f12:	48 39 c2             	cmp    %rax,%rdx
  802f15:	73 b4                	jae    802ecb <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1b:	8b 40 04             	mov    0x4(%rax),%eax
  802f1e:	99                   	cltd   
  802f1f:	c1 ea 1b             	shr    $0x1b,%edx
  802f22:	01 d0                	add    %edx,%eax
  802f24:	83 e0 1f             	and    $0x1f,%eax
  802f27:	29 d0                	sub    %edx,%eax
  802f29:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f2d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f31:	48 01 ca             	add    %rcx,%rdx
  802f34:	0f b6 0a             	movzbl (%rdx),%ecx
  802f37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f3b:	48 98                	cltq   
  802f3d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802f41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f45:	8b 40 04             	mov    0x4(%rax),%eax
  802f48:	8d 50 01             	lea    0x1(%rax),%edx
  802f4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f52:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f5b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f5f:	0f 82 64 ff ff ff    	jb     802ec9 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802f65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f69:	c9                   	leaveq 
  802f6a:	c3                   	retq   

0000000000802f6b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f6b:	55                   	push   %rbp
  802f6c:	48 89 e5             	mov    %rsp,%rbp
  802f6f:	48 83 ec 20          	sub    $0x20,%rsp
  802f73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802f77:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f7f:	48 89 c7             	mov    %rax,%rdi
  802f82:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  802f89:	00 00 00 
  802f8c:	ff d0                	callq  *%rax
  802f8e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802f92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f96:	48 be df 3c 80 00 00 	movabs $0x803cdf,%rsi
  802f9d:	00 00 00 
  802fa0:	48 89 c7             	mov    %rax,%rdi
  802fa3:	48 b8 6a 0e 80 00 00 	movabs $0x800e6a,%rax
  802faa:	00 00 00 
  802fad:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802faf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fb3:	8b 50 04             	mov    0x4(%rax),%edx
  802fb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fba:	8b 00                	mov    (%rax),%eax
  802fbc:	29 c2                	sub    %eax,%edx
  802fbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802fc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fcc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802fd3:	00 00 00 
	stat->st_dev = &devpipe;
  802fd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fda:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802fe1:	00 00 00 
  802fe4:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802feb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff0:	c9                   	leaveq 
  802ff1:	c3                   	retq   

0000000000802ff2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802ff2:	55                   	push   %rbp
  802ff3:	48 89 e5             	mov    %rsp,%rbp
  802ff6:	48 83 ec 10          	sub    $0x10,%rsp
  802ffa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802ffe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803002:	48 89 c6             	mov    %rax,%rsi
  803005:	bf 00 00 00 00       	mov    $0x0,%edi
  80300a:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  803011:	00 00 00 
  803014:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803016:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80301a:	48 89 c7             	mov    %rax,%rdi
  80301d:	48 b8 48 1b 80 00 00 	movabs $0x801b48,%rax
  803024:	00 00 00 
  803027:	ff d0                	callq  *%rax
  803029:	48 89 c6             	mov    %rax,%rsi
  80302c:	bf 00 00 00 00       	mov    $0x0,%edi
  803031:	48 b8 44 18 80 00 00 	movabs $0x801844,%rax
  803038:	00 00 00 
  80303b:	ff d0                	callq  *%rax
}
  80303d:	c9                   	leaveq 
  80303e:	c3                   	retq   

000000000080303f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80303f:	55                   	push   %rbp
  803040:	48 89 e5             	mov    %rsp,%rbp
  803043:	48 83 ec 20          	sub    $0x20,%rsp
  803047:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80304a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80304d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803050:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803054:	be 01 00 00 00       	mov    $0x1,%esi
  803059:	48 89 c7             	mov    %rax,%rdi
  80305c:	48 b8 51 16 80 00 00 	movabs $0x801651,%rax
  803063:	00 00 00 
  803066:	ff d0                	callq  *%rax
}
  803068:	c9                   	leaveq 
  803069:	c3                   	retq   

000000000080306a <getchar>:

int
getchar(void)
{
  80306a:	55                   	push   %rbp
  80306b:	48 89 e5             	mov    %rsp,%rbp
  80306e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803072:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803076:	ba 01 00 00 00       	mov    $0x1,%edx
  80307b:	48 89 c6             	mov    %rax,%rsi
  80307e:	bf 00 00 00 00       	mov    $0x0,%edi
  803083:	48 b8 3d 20 80 00 00 	movabs $0x80203d,%rax
  80308a:	00 00 00 
  80308d:	ff d0                	callq  *%rax
  80308f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803092:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803096:	79 05                	jns    80309d <getchar+0x33>
		return r;
  803098:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309b:	eb 14                	jmp    8030b1 <getchar+0x47>
	if (r < 1)
  80309d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a1:	7f 07                	jg     8030aa <getchar+0x40>
		return -E_EOF;
  8030a3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8030a8:	eb 07                	jmp    8030b1 <getchar+0x47>
	return c;
  8030aa:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8030ae:	0f b6 c0             	movzbl %al,%eax
}
  8030b1:	c9                   	leaveq 
  8030b2:	c3                   	retq   

00000000008030b3 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8030b3:	55                   	push   %rbp
  8030b4:	48 89 e5             	mov    %rsp,%rbp
  8030b7:	48 83 ec 20          	sub    $0x20,%rsp
  8030bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8030be:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030c5:	48 89 d6             	mov    %rdx,%rsi
  8030c8:	89 c7                	mov    %eax,%edi
  8030ca:	48 b8 0b 1c 80 00 00 	movabs $0x801c0b,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
  8030d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030dd:	79 05                	jns    8030e4 <iscons+0x31>
		return r;
  8030df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e2:	eb 1a                	jmp    8030fe <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8030e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030e8:	8b 10                	mov    (%rax),%edx
  8030ea:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8030f1:	00 00 00 
  8030f4:	8b 00                	mov    (%rax),%eax
  8030f6:	39 c2                	cmp    %eax,%edx
  8030f8:	0f 94 c0             	sete   %al
  8030fb:	0f b6 c0             	movzbl %al,%eax
}
  8030fe:	c9                   	leaveq 
  8030ff:	c3                   	retq   

0000000000803100 <opencons>:

int
opencons(void)
{
  803100:	55                   	push   %rbp
  803101:	48 89 e5             	mov    %rsp,%rbp
  803104:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803108:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80310c:	48 89 c7             	mov    %rax,%rdi
  80310f:	48 b8 73 1b 80 00 00 	movabs $0x801b73,%rax
  803116:	00 00 00 
  803119:	ff d0                	callq  *%rax
  80311b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80311e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803122:	79 05                	jns    803129 <opencons+0x29>
		return r;
  803124:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803127:	eb 5b                	jmp    803184 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803129:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80312d:	ba 07 04 00 00       	mov    $0x407,%edx
  803132:	48 89 c6             	mov    %rax,%rsi
  803135:	bf 00 00 00 00       	mov    $0x0,%edi
  80313a:	48 b8 99 17 80 00 00 	movabs $0x801799,%rax
  803141:	00 00 00 
  803144:	ff d0                	callq  *%rax
  803146:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803149:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314d:	79 05                	jns    803154 <opencons+0x54>
		return r;
  80314f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803152:	eb 30                	jmp    803184 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803154:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803158:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  80315f:	00 00 00 
  803162:	8b 12                	mov    (%rdx),%edx
  803164:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803166:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80316a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803171:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803175:	48 89 c7             	mov    %rax,%rdi
  803178:	48 b8 25 1b 80 00 00 	movabs $0x801b25,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
}
  803184:	c9                   	leaveq 
  803185:	c3                   	retq   

0000000000803186 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803186:	55                   	push   %rbp
  803187:	48 89 e5             	mov    %rsp,%rbp
  80318a:	48 83 ec 30          	sub    $0x30,%rsp
  80318e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803192:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803196:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80319a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80319f:	75 07                	jne    8031a8 <devcons_read+0x22>
		return 0;
  8031a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a6:	eb 4b                	jmp    8031f3 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8031a8:	eb 0c                	jmp    8031b6 <devcons_read+0x30>
		sys_yield();
  8031aa:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  8031b1:	00 00 00 
  8031b4:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8031b6:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  8031bd:	00 00 00 
  8031c0:	ff d0                	callq  *%rax
  8031c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c9:	74 df                	je     8031aa <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8031cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031cf:	79 05                	jns    8031d6 <devcons_read+0x50>
		return c;
  8031d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d4:	eb 1d                	jmp    8031f3 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8031d6:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8031da:	75 07                	jne    8031e3 <devcons_read+0x5d>
		return 0;
  8031dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e1:	eb 10                	jmp    8031f3 <devcons_read+0x6d>
	*(char*)vbuf = c;
  8031e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e6:	89 c2                	mov    %eax,%edx
  8031e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ec:	88 10                	mov    %dl,(%rax)
	return 1;
  8031ee:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8031f3:	c9                   	leaveq 
  8031f4:	c3                   	retq   

00000000008031f5 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8031f5:	55                   	push   %rbp
  8031f6:	48 89 e5             	mov    %rsp,%rbp
  8031f9:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803200:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803207:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80320e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803215:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80321c:	eb 76                	jmp    803294 <devcons_write+0x9f>
		m = n - tot;
  80321e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803225:	89 c2                	mov    %eax,%edx
  803227:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322a:	29 c2                	sub    %eax,%edx
  80322c:	89 d0                	mov    %edx,%eax
  80322e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803231:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803234:	83 f8 7f             	cmp    $0x7f,%eax
  803237:	76 07                	jbe    803240 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803239:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803240:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803243:	48 63 d0             	movslq %eax,%rdx
  803246:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803249:	48 63 c8             	movslq %eax,%rcx
  80324c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803253:	48 01 c1             	add    %rax,%rcx
  803256:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80325d:	48 89 ce             	mov    %rcx,%rsi
  803260:	48 89 c7             	mov    %rax,%rdi
  803263:	48 b8 8e 11 80 00 00 	movabs $0x80118e,%rax
  80326a:	00 00 00 
  80326d:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80326f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803272:	48 63 d0             	movslq %eax,%rdx
  803275:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80327c:	48 89 d6             	mov    %rdx,%rsi
  80327f:	48 89 c7             	mov    %rax,%rdi
  803282:	48 b8 51 16 80 00 00 	movabs $0x801651,%rax
  803289:	00 00 00 
  80328c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80328e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803291:	01 45 fc             	add    %eax,-0x4(%rbp)
  803294:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803297:	48 98                	cltq   
  803299:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8032a0:	0f 82 78 ff ff ff    	jb     80321e <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8032a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032a9:	c9                   	leaveq 
  8032aa:	c3                   	retq   

00000000008032ab <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8032ab:	55                   	push   %rbp
  8032ac:	48 89 e5             	mov    %rsp,%rbp
  8032af:	48 83 ec 08          	sub    $0x8,%rsp
  8032b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8032b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032bc:	c9                   	leaveq 
  8032bd:	c3                   	retq   

00000000008032be <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8032be:	55                   	push   %rbp
  8032bf:	48 89 e5             	mov    %rsp,%rbp
  8032c2:	48 83 ec 10          	sub    $0x10,%rsp
  8032c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8032ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8032ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d2:	48 be eb 3c 80 00 00 	movabs $0x803ceb,%rsi
  8032d9:	00 00 00 
  8032dc:	48 89 c7             	mov    %rax,%rdi
  8032df:	48 b8 6a 0e 80 00 00 	movabs $0x800e6a,%rax
  8032e6:	00 00 00 
  8032e9:	ff d0                	callq  *%rax
	return 0;
  8032eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032f0:	c9                   	leaveq 
  8032f1:	c3                   	retq   

00000000008032f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8032f2:	55                   	push   %rbp
  8032f3:	48 89 e5             	mov    %rsp,%rbp
  8032f6:	53                   	push   %rbx
  8032f7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8032fe:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803305:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80330b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803312:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803319:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803320:	84 c0                	test   %al,%al
  803322:	74 23                	je     803347 <_panic+0x55>
  803324:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80332b:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80332f:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803333:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803337:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80333b:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80333f:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803343:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803347:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80334e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803355:	00 00 00 
  803358:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80335f:	00 00 00 
  803362:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803366:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80336d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803374:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80337b:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803382:	00 00 00 
  803385:	48 8b 18             	mov    (%rax),%rbx
  803388:	48 b8 1d 17 80 00 00 	movabs $0x80171d,%rax
  80338f:	00 00 00 
  803392:	ff d0                	callq  *%rax
  803394:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80339a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8033a1:	41 89 c8             	mov    %ecx,%r8d
  8033a4:	48 89 d1             	mov    %rdx,%rcx
  8033a7:	48 89 da             	mov    %rbx,%rdx
  8033aa:	89 c6                	mov    %eax,%esi
  8033ac:	48 bf f8 3c 80 00 00 	movabs $0x803cf8,%rdi
  8033b3:	00 00 00 
  8033b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033bb:	49 b9 b5 02 80 00 00 	movabs $0x8002b5,%r9
  8033c2:	00 00 00 
  8033c5:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8033c8:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8033cf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8033d6:	48 89 d6             	mov    %rdx,%rsi
  8033d9:	48 89 c7             	mov    %rax,%rdi
  8033dc:	48 b8 09 02 80 00 00 	movabs $0x800209,%rax
  8033e3:	00 00 00 
  8033e6:	ff d0                	callq  *%rax
	cprintf("\n");
  8033e8:	48 bf 1b 3d 80 00 00 	movabs $0x803d1b,%rdi
  8033ef:	00 00 00 
  8033f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f7:	48 ba b5 02 80 00 00 	movabs $0x8002b5,%rdx
  8033fe:	00 00 00 
  803401:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803403:	cc                   	int3   
  803404:	eb fd                	jmp    803403 <_panic+0x111>

0000000000803406 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803406:	55                   	push   %rbp
  803407:	48 89 e5             	mov    %rsp,%rbp
  80340a:	48 83 ec 30          	sub    $0x30,%rsp
  80340e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803412:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803416:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  80341a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80341f:	74 18                	je     803439 <ipc_recv+0x33>
  803421:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803425:	48 89 c7             	mov    %rax,%rdi
  803428:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  80342f:	00 00 00 
  803432:	ff d0                	callq  *%rax
  803434:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803437:	eb 19                	jmp    803452 <ipc_recv+0x4c>
  803439:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803440:	00 00 00 
  803443:	48 b8 c2 19 80 00 00 	movabs $0x8019c2,%rax
  80344a:	00 00 00 
  80344d:	ff d0                	callq  *%rax
  80344f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803452:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803457:	74 26                	je     80347f <ipc_recv+0x79>
  803459:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80345d:	75 15                	jne    803474 <ipc_recv+0x6e>
  80345f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803466:	00 00 00 
  803469:	48 8b 00             	mov    (%rax),%rax
  80346c:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803472:	eb 05                	jmp    803479 <ipc_recv+0x73>
  803474:	b8 00 00 00 00       	mov    $0x0,%eax
  803479:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80347d:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  80347f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803484:	74 26                	je     8034ac <ipc_recv+0xa6>
  803486:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80348a:	75 15                	jne    8034a1 <ipc_recv+0x9b>
  80348c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803493:	00 00 00 
  803496:	48 8b 00             	mov    (%rax),%rax
  803499:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80349f:	eb 05                	jmp    8034a6 <ipc_recv+0xa0>
  8034a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034aa:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  8034ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b0:	75 15                	jne    8034c7 <ipc_recv+0xc1>
  8034b2:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034b9:	00 00 00 
  8034bc:	48 8b 00             	mov    (%rax),%rax
  8034bf:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8034c5:	eb 03                	jmp    8034ca <ipc_recv+0xc4>
  8034c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8034ca:	c9                   	leaveq 
  8034cb:	c3                   	retq   

00000000008034cc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8034cc:	55                   	push   %rbp
  8034cd:	48 89 e5             	mov    %rsp,%rbp
  8034d0:	48 83 ec 30          	sub    $0x30,%rsp
  8034d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034d7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8034da:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8034de:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  8034e1:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  8034e8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034ed:	75 10                	jne    8034ff <ipc_send+0x33>
  8034ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8034f6:	00 00 00 
  8034f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  8034fd:	eb 62                	jmp    803561 <ipc_send+0x95>
  8034ff:	eb 60                	jmp    803561 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803501:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803505:	74 30                	je     803537 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803507:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80350a:	89 c1                	mov    %eax,%ecx
  80350c:	48 ba 1d 3d 80 00 00 	movabs $0x803d1d,%rdx
  803513:	00 00 00 
  803516:	be 33 00 00 00       	mov    $0x33,%esi
  80351b:	48 bf 39 3d 80 00 00 	movabs $0x803d39,%rdi
  803522:	00 00 00 
  803525:	b8 00 00 00 00       	mov    $0x0,%eax
  80352a:	49 b8 f2 32 80 00 00 	movabs $0x8032f2,%r8
  803531:	00 00 00 
  803534:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803537:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80353a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80353d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803541:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803544:	89 c7                	mov    %eax,%edi
  803546:	48 b8 6d 19 80 00 00 	movabs $0x80196d,%rax
  80354d:	00 00 00 
  803550:	ff d0                	callq  *%rax
  803552:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803555:	48 b8 5b 17 80 00 00 	movabs $0x80175b,%rax
  80355c:	00 00 00 
  80355f:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803561:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803565:	75 9a                	jne    803501 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803567:	c9                   	leaveq 
  803568:	c3                   	retq   

0000000000803569 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803569:	55                   	push   %rbp
  80356a:	48 89 e5             	mov    %rsp,%rbp
  80356d:	48 83 ec 14          	sub    $0x14,%rsp
  803571:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803574:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80357b:	eb 5e                	jmp    8035db <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80357d:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803584:	00 00 00 
  803587:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80358a:	48 63 d0             	movslq %eax,%rdx
  80358d:	48 89 d0             	mov    %rdx,%rax
  803590:	48 c1 e0 03          	shl    $0x3,%rax
  803594:	48 01 d0             	add    %rdx,%rax
  803597:	48 c1 e0 05          	shl    $0x5,%rax
  80359b:	48 01 c8             	add    %rcx,%rax
  80359e:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8035a4:	8b 00                	mov    (%rax),%eax
  8035a6:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8035a9:	75 2c                	jne    8035d7 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8035ab:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8035b2:	00 00 00 
  8035b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b8:	48 63 d0             	movslq %eax,%rdx
  8035bb:	48 89 d0             	mov    %rdx,%rax
  8035be:	48 c1 e0 03          	shl    $0x3,%rax
  8035c2:	48 01 d0             	add    %rdx,%rax
  8035c5:	48 c1 e0 05          	shl    $0x5,%rax
  8035c9:	48 01 c8             	add    %rcx,%rax
  8035cc:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8035d2:	8b 40 08             	mov    0x8(%rax),%eax
  8035d5:	eb 12                	jmp    8035e9 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8035d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8035db:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8035e2:	7e 99                	jle    80357d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8035e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035e9:	c9                   	leaveq 
  8035ea:	c3                   	retq   

00000000008035eb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8035eb:	55                   	push   %rbp
  8035ec:	48 89 e5             	mov    %rsp,%rbp
  8035ef:	48 83 ec 18          	sub    $0x18,%rsp
  8035f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8035f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fb:	48 c1 e8 15          	shr    $0x15,%rax
  8035ff:	48 89 c2             	mov    %rax,%rdx
  803602:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803609:	01 00 00 
  80360c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803610:	83 e0 01             	and    $0x1,%eax
  803613:	48 85 c0             	test   %rax,%rax
  803616:	75 07                	jne    80361f <pageref+0x34>
		return 0;
  803618:	b8 00 00 00 00       	mov    $0x0,%eax
  80361d:	eb 53                	jmp    803672 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  80361f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803623:	48 c1 e8 0c          	shr    $0xc,%rax
  803627:	48 89 c2             	mov    %rax,%rdx
  80362a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803631:	01 00 00 
  803634:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803638:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80363c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803640:	83 e0 01             	and    $0x1,%eax
  803643:	48 85 c0             	test   %rax,%rax
  803646:	75 07                	jne    80364f <pageref+0x64>
		return 0;
  803648:	b8 00 00 00 00       	mov    $0x0,%eax
  80364d:	eb 23                	jmp    803672 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80364f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803653:	48 c1 e8 0c          	shr    $0xc,%rax
  803657:	48 89 c2             	mov    %rax,%rdx
  80365a:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803661:	00 00 00 
  803664:	48 c1 e2 04          	shl    $0x4,%rdx
  803668:	48 01 d0             	add    %rdx,%rax
  80366b:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80366f:	0f b7 c0             	movzwl %ax,%eax
}
  803672:	c9                   	leaveq 
  803673:	c3                   	retq   
