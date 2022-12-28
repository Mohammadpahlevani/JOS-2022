
obj/user/faultreadkernel:     file format elf64-x86-64


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
  80003c:	e8 3c 00 00 00       	callq  80007d <libmain>
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
	cprintf("I read %08x from location 0x8004000000!\n", *(unsigned*)0x8004000000);
  800052:	48 b8 00 00 00 04 80 	movabs $0x8004000000,%rax
  800059:	00 00 00 
  80005c:	8b 00                	mov    (%rax),%eax
  80005e:	89 c6                	mov    %eax,%esi
  800060:	48 bf 20 18 80 00 00 	movabs $0x801820,%rdi
  800067:	00 00 00 
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	48 ba 43 02 80 00 00 	movabs $0x800243,%rdx
  800076:	00 00 00 
  800079:	ff d2                	callq  *%rdx
}
  80007b:	c9                   	leaveq 
  80007c:	c3                   	retq   

000000000080007d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007d:	55                   	push   %rbp
  80007e:	48 89 e5             	mov    %rsp,%rbp
  800081:	48 83 ec 10          	sub    $0x10,%rsp
  800085:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800088:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  80008c:	48 b8 be 16 80 00 00 	movabs $0x8016be,%rax
  800093:	00 00 00 
  800096:	ff d0                	callq  *%rax
  800098:	25 ff 03 00 00       	and    $0x3ff,%eax
  80009d:	48 98                	cltq   
  80009f:	48 c1 e0 03          	shl    $0x3,%rax
  8000a3:	48 89 c2             	mov    %rax,%rdx
  8000a6:	48 c1 e2 05          	shl    $0x5,%rdx
  8000aa:	48 29 c2             	sub    %rax,%rdx
  8000ad:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000b4:	00 00 00 
  8000b7:	48 01 c2             	add    %rax,%rdx
  8000ba:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8000c1:	00 00 00 
  8000c4:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	7e 14                	jle    8000e1 <libmain+0x64>
		binaryname = argv[0];
  8000cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000d1:	48 8b 10             	mov    (%rax),%rdx
  8000d4:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8000db:	00 00 00 
  8000de:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000e8:	48 89 d6             	mov    %rdx,%rsi
  8000eb:	89 c7                	mov    %eax,%edi
  8000ed:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000f4:	00 00 00 
  8000f7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000f9:	48 b8 07 01 80 00 00 	movabs $0x800107,%rax
  800100:	00 00 00 
  800103:	ff d0                	callq  *%rax
}
  800105:	c9                   	leaveq 
  800106:	c3                   	retq   

0000000000800107 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800107:	55                   	push   %rbp
  800108:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80010b:	bf 00 00 00 00       	mov    $0x0,%edi
  800110:	48 b8 7a 16 80 00 00 	movabs $0x80167a,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
}
  80011c:	5d                   	pop    %rbp
  80011d:	c3                   	retq   

000000000080011e <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
  800122:	48 83 ec 10          	sub    $0x10,%rsp
  800126:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800129:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80012d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800131:	8b 00                	mov    (%rax),%eax
  800133:	8d 48 01             	lea    0x1(%rax),%ecx
  800136:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80013a:	89 0a                	mov    %ecx,(%rdx)
  80013c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80013f:	89 d1                	mov    %edx,%ecx
  800141:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800145:	48 98                	cltq   
  800147:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80014b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80014f:	8b 00                	mov    (%rax),%eax
  800151:	3d ff 00 00 00       	cmp    $0xff,%eax
  800156:	75 2c                	jne    800184 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80015c:	8b 00                	mov    (%rax),%eax
  80015e:	48 98                	cltq   
  800160:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800164:	48 83 c2 08          	add    $0x8,%rdx
  800168:	48 89 c6             	mov    %rax,%rsi
  80016b:	48 89 d7             	mov    %rdx,%rdi
  80016e:	48 b8 f2 15 80 00 00 	movabs $0x8015f2,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
        b->idx = 0;
  80017a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80017e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800184:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800188:	8b 40 04             	mov    0x4(%rax),%eax
  80018b:	8d 50 01             	lea    0x1(%rax),%edx
  80018e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800192:	89 50 04             	mov    %edx,0x4(%rax)
}
  800195:	c9                   	leaveq 
  800196:	c3                   	retq   

0000000000800197 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800197:	55                   	push   %rbp
  800198:	48 89 e5             	mov    %rsp,%rbp
  80019b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8001a2:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8001a9:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8001b0:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8001b7:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8001be:	48 8b 0a             	mov    (%rdx),%rcx
  8001c1:	48 89 08             	mov    %rcx,(%rax)
  8001c4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8001c8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8001cc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8001d0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8001d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8001db:	00 00 00 
    b.cnt = 0;
  8001de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8001e5:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8001e8:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8001ef:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8001f6:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8001fd:	48 89 c6             	mov    %rax,%rsi
  800200:	48 bf 1e 01 80 00 00 	movabs $0x80011e,%rdi
  800207:	00 00 00 
  80020a:	48 b8 f6 05 80 00 00 	movabs $0x8005f6,%rax
  800211:	00 00 00 
  800214:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800216:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80021c:	48 98                	cltq   
  80021e:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800225:	48 83 c2 08          	add    $0x8,%rdx
  800229:	48 89 c6             	mov    %rax,%rsi
  80022c:	48 89 d7             	mov    %rdx,%rdi
  80022f:	48 b8 f2 15 80 00 00 	movabs $0x8015f2,%rax
  800236:	00 00 00 
  800239:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80023b:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800241:	c9                   	leaveq 
  800242:	c3                   	retq   

0000000000800243 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800243:	55                   	push   %rbp
  800244:	48 89 e5             	mov    %rsp,%rbp
  800247:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80024e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800255:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80025c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800263:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80026a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800271:	84 c0                	test   %al,%al
  800273:	74 20                	je     800295 <cprintf+0x52>
  800275:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800279:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80027d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800281:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800285:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800289:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80028d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800291:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800295:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80029c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8002a3:	00 00 00 
  8002a6:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8002ad:	00 00 00 
  8002b0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002b4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8002bb:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8002c2:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8002c9:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8002d0:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8002d7:	48 8b 0a             	mov    (%rdx),%rcx
  8002da:	48 89 08             	mov    %rcx,(%rax)
  8002dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8002ed:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8002f4:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002fb:	48 89 d6             	mov    %rdx,%rsi
  8002fe:	48 89 c7             	mov    %rax,%rdi
  800301:	48 b8 97 01 80 00 00 	movabs $0x800197,%rax
  800308:	00 00 00 
  80030b:	ff d0                	callq  *%rax
  80030d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800313:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800319:	c9                   	leaveq 
  80031a:	c3                   	retq   

000000000080031b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031b:	55                   	push   %rbp
  80031c:	48 89 e5             	mov    %rsp,%rbp
  80031f:	53                   	push   %rbx
  800320:	48 83 ec 38          	sub    $0x38,%rsp
  800324:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800328:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80032c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800330:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800333:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800337:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80033e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800342:	77 3b                	ja     80037f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800344:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800347:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80034b:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80034e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800352:	ba 00 00 00 00       	mov    $0x0,%edx
  800357:	48 f7 f3             	div    %rbx
  80035a:	48 89 c2             	mov    %rax,%rdx
  80035d:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800360:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800363:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80036b:	41 89 f9             	mov    %edi,%r9d
  80036e:	48 89 c7             	mov    %rax,%rdi
  800371:	48 b8 1b 03 80 00 00 	movabs $0x80031b,%rax
  800378:	00 00 00 
  80037b:	ff d0                	callq  *%rax
  80037d:	eb 1e                	jmp    80039d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80037f:	eb 12                	jmp    800393 <printnum+0x78>
			putch(padc, putdat);
  800381:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800385:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800388:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80038c:	48 89 ce             	mov    %rcx,%rsi
  80038f:	89 d7                	mov    %edx,%edi
  800391:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800393:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800397:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80039b:	7f e4                	jg     800381 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a9:	48 f7 f1             	div    %rcx
  8003ac:	48 89 d0             	mov    %rdx,%rax
  8003af:	48 ba 90 19 80 00 00 	movabs $0x801990,%rdx
  8003b6:	00 00 00 
  8003b9:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8003bd:	0f be d0             	movsbl %al,%edx
  8003c0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8003c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003c8:	48 89 ce             	mov    %rcx,%rsi
  8003cb:	89 d7                	mov    %edx,%edi
  8003cd:	ff d0                	callq  *%rax
}
  8003cf:	48 83 c4 38          	add    $0x38,%rsp
  8003d3:	5b                   	pop    %rbx
  8003d4:	5d                   	pop    %rbp
  8003d5:	c3                   	retq   

00000000008003d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d6:	55                   	push   %rbp
  8003d7:	48 89 e5             	mov    %rsp,%rbp
  8003da:	48 83 ec 1c          	sub    $0x1c,%rsp
  8003de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003e2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8003e5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8003e9:	7e 52                	jle    80043d <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8003eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003ef:	8b 00                	mov    (%rax),%eax
  8003f1:	83 f8 30             	cmp    $0x30,%eax
  8003f4:	73 24                	jae    80041a <getuint+0x44>
  8003f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8003fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800402:	8b 00                	mov    (%rax),%eax
  800404:	89 c0                	mov    %eax,%eax
  800406:	48 01 d0             	add    %rdx,%rax
  800409:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80040d:	8b 12                	mov    (%rdx),%edx
  80040f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800412:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800416:	89 0a                	mov    %ecx,(%rdx)
  800418:	eb 17                	jmp    800431 <getuint+0x5b>
  80041a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800422:	48 89 d0             	mov    %rdx,%rax
  800425:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800429:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80042d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800431:	48 8b 00             	mov    (%rax),%rax
  800434:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800438:	e9 a3 00 00 00       	jmpq   8004e0 <getuint+0x10a>
	else if (lflag)
  80043d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800441:	74 4f                	je     800492 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800447:	8b 00                	mov    (%rax),%eax
  800449:	83 f8 30             	cmp    $0x30,%eax
  80044c:	73 24                	jae    800472 <getuint+0x9c>
  80044e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800452:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80045a:	8b 00                	mov    (%rax),%eax
  80045c:	89 c0                	mov    %eax,%eax
  80045e:	48 01 d0             	add    %rdx,%rax
  800461:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800465:	8b 12                	mov    (%rdx),%edx
  800467:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80046a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80046e:	89 0a                	mov    %ecx,(%rdx)
  800470:	eb 17                	jmp    800489 <getuint+0xb3>
  800472:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800476:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80047a:	48 89 d0             	mov    %rdx,%rax
  80047d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800481:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800485:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800489:	48 8b 00             	mov    (%rax),%rax
  80048c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800490:	eb 4e                	jmp    8004e0 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800492:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800496:	8b 00                	mov    (%rax),%eax
  800498:	83 f8 30             	cmp    $0x30,%eax
  80049b:	73 24                	jae    8004c1 <getuint+0xeb>
  80049d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a9:	8b 00                	mov    (%rax),%eax
  8004ab:	89 c0                	mov    %eax,%eax
  8004ad:	48 01 d0             	add    %rdx,%rax
  8004b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b4:	8b 12                	mov    (%rdx),%edx
  8004b6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004bd:	89 0a                	mov    %ecx,(%rdx)
  8004bf:	eb 17                	jmp    8004d8 <getuint+0x102>
  8004c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004c9:	48 89 d0             	mov    %rdx,%rax
  8004cc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004d4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004d8:	8b 00                	mov    (%rax),%eax
  8004da:	89 c0                	mov    %eax,%eax
  8004dc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8004e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004e4:	c9                   	leaveq 
  8004e5:	c3                   	retq   

00000000008004e6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004e6:	55                   	push   %rbp
  8004e7:	48 89 e5             	mov    %rsp,%rbp
  8004ea:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004f2:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8004f5:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004f9:	7e 52                	jle    80054d <getint+0x67>
		x=va_arg(*ap, long long);
  8004fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ff:	8b 00                	mov    (%rax),%eax
  800501:	83 f8 30             	cmp    $0x30,%eax
  800504:	73 24                	jae    80052a <getint+0x44>
  800506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80050a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80050e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800512:	8b 00                	mov    (%rax),%eax
  800514:	89 c0                	mov    %eax,%eax
  800516:	48 01 d0             	add    %rdx,%rax
  800519:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80051d:	8b 12                	mov    (%rdx),%edx
  80051f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800522:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800526:	89 0a                	mov    %ecx,(%rdx)
  800528:	eb 17                	jmp    800541 <getint+0x5b>
  80052a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800532:	48 89 d0             	mov    %rdx,%rax
  800535:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800539:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80053d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800541:	48 8b 00             	mov    (%rax),%rax
  800544:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800548:	e9 a3 00 00 00       	jmpq   8005f0 <getint+0x10a>
	else if (lflag)
  80054d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800551:	74 4f                	je     8005a2 <getint+0xbc>
		x=va_arg(*ap, long);
  800553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800557:	8b 00                	mov    (%rax),%eax
  800559:	83 f8 30             	cmp    $0x30,%eax
  80055c:	73 24                	jae    800582 <getint+0x9c>
  80055e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800562:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056a:	8b 00                	mov    (%rax),%eax
  80056c:	89 c0                	mov    %eax,%eax
  80056e:	48 01 d0             	add    %rdx,%rax
  800571:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800575:	8b 12                	mov    (%rdx),%edx
  800577:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80057a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057e:	89 0a                	mov    %ecx,(%rdx)
  800580:	eb 17                	jmp    800599 <getint+0xb3>
  800582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800586:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80058a:	48 89 d0             	mov    %rdx,%rax
  80058d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800591:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800595:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800599:	48 8b 00             	mov    (%rax),%rax
  80059c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005a0:	eb 4e                	jmp    8005f0 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8005a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a6:	8b 00                	mov    (%rax),%eax
  8005a8:	83 f8 30             	cmp    $0x30,%eax
  8005ab:	73 24                	jae    8005d1 <getint+0xeb>
  8005ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b9:	8b 00                	mov    (%rax),%eax
  8005bb:	89 c0                	mov    %eax,%eax
  8005bd:	48 01 d0             	add    %rdx,%rax
  8005c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c4:	8b 12                	mov    (%rdx),%edx
  8005c6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cd:	89 0a                	mov    %ecx,(%rdx)
  8005cf:	eb 17                	jmp    8005e8 <getint+0x102>
  8005d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005d9:	48 89 d0             	mov    %rdx,%rax
  8005dc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005e4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005e8:	8b 00                	mov    (%rax),%eax
  8005ea:	48 98                	cltq   
  8005ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005f4:	c9                   	leaveq 
  8005f5:	c3                   	retq   

00000000008005f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005f6:	55                   	push   %rbp
  8005f7:	48 89 e5             	mov    %rsp,%rbp
  8005fa:	41 54                	push   %r12
  8005fc:	53                   	push   %rbx
  8005fd:	48 83 ec 60          	sub    $0x60,%rsp
  800601:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800605:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800609:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80060d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800611:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800615:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800619:	48 8b 0a             	mov    (%rdx),%rcx
  80061c:	48 89 08             	mov    %rcx,(%rax)
  80061f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800623:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800627:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80062b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80062f:	eb 17                	jmp    800648 <vprintfmt+0x52>
			if (ch == '\0')
  800631:	85 db                	test   %ebx,%ebx
  800633:	0f 84 df 04 00 00    	je     800b18 <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  800639:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80063d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800641:	48 89 d6             	mov    %rdx,%rsi
  800644:	89 df                	mov    %ebx,%edi
  800646:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800648:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80064c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800650:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800654:	0f b6 00             	movzbl (%rax),%eax
  800657:	0f b6 d8             	movzbl %al,%ebx
  80065a:	83 fb 25             	cmp    $0x25,%ebx
  80065d:	75 d2                	jne    800631 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80065f:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800663:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80066a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800671:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800678:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800683:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800687:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80068b:	0f b6 00             	movzbl (%rax),%eax
  80068e:	0f b6 d8             	movzbl %al,%ebx
  800691:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800694:	83 f8 55             	cmp    $0x55,%eax
  800697:	0f 87 47 04 00 00    	ja     800ae4 <vprintfmt+0x4ee>
  80069d:	89 c0                	mov    %eax,%eax
  80069f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8006a6:	00 
  8006a7:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  8006ae:	00 00 00 
  8006b1:	48 01 d0             	add    %rdx,%rax
  8006b4:	48 8b 00             	mov    (%rax),%rax
  8006b7:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8006b9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8006bd:	eb c0                	jmp    80067f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006bf:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8006c3:	eb ba                	jmp    80067f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8006cc:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8006cf:	89 d0                	mov    %edx,%eax
  8006d1:	c1 e0 02             	shl    $0x2,%eax
  8006d4:	01 d0                	add    %edx,%eax
  8006d6:	01 c0                	add    %eax,%eax
  8006d8:	01 d8                	add    %ebx,%eax
  8006da:	83 e8 30             	sub    $0x30,%eax
  8006dd:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8006e0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006e4:	0f b6 00             	movzbl (%rax),%eax
  8006e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8006ed:	7e 0c                	jle    8006fb <vprintfmt+0x105>
  8006ef:	83 fb 39             	cmp    $0x39,%ebx
  8006f2:	7f 07                	jg     8006fb <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006f4:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f9:	eb d1                	jmp    8006cc <vprintfmt+0xd6>
			goto process_precision;
  8006fb:	eb 58                	jmp    800755 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8006fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800700:	83 f8 30             	cmp    $0x30,%eax
  800703:	73 17                	jae    80071c <vprintfmt+0x126>
  800705:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800709:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80070c:	89 c0                	mov    %eax,%eax
  80070e:	48 01 d0             	add    %rdx,%rax
  800711:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800714:	83 c2 08             	add    $0x8,%edx
  800717:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80071a:	eb 0f                	jmp    80072b <vprintfmt+0x135>
  80071c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800720:	48 89 d0             	mov    %rdx,%rax
  800723:	48 83 c2 08          	add    $0x8,%rdx
  800727:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80072b:	8b 00                	mov    (%rax),%eax
  80072d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800730:	eb 23                	jmp    800755 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800732:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800736:	79 0c                	jns    800744 <vprintfmt+0x14e>
				width = 0;
  800738:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80073f:	e9 3b ff ff ff       	jmpq   80067f <vprintfmt+0x89>
  800744:	e9 36 ff ff ff       	jmpq   80067f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800749:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800750:	e9 2a ff ff ff       	jmpq   80067f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800755:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800759:	79 12                	jns    80076d <vprintfmt+0x177>
				width = precision, precision = -1;
  80075b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80075e:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800761:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800768:	e9 12 ff ff ff       	jmpq   80067f <vprintfmt+0x89>
  80076d:	e9 0d ff ff ff       	jmpq   80067f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800772:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800776:	e9 04 ff ff ff       	jmpq   80067f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80077b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80077e:	83 f8 30             	cmp    $0x30,%eax
  800781:	73 17                	jae    80079a <vprintfmt+0x1a4>
  800783:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800787:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80078a:	89 c0                	mov    %eax,%eax
  80078c:	48 01 d0             	add    %rdx,%rax
  80078f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800792:	83 c2 08             	add    $0x8,%edx
  800795:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800798:	eb 0f                	jmp    8007a9 <vprintfmt+0x1b3>
  80079a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80079e:	48 89 d0             	mov    %rdx,%rax
  8007a1:	48 83 c2 08          	add    $0x8,%rdx
  8007a5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007a9:	8b 10                	mov    (%rax),%edx
  8007ab:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8007af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007b3:	48 89 ce             	mov    %rcx,%rsi
  8007b6:	89 d7                	mov    %edx,%edi
  8007b8:	ff d0                	callq  *%rax
			break;
  8007ba:	e9 53 03 00 00       	jmpq   800b12 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8007bf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007c2:	83 f8 30             	cmp    $0x30,%eax
  8007c5:	73 17                	jae    8007de <vprintfmt+0x1e8>
  8007c7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007cb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007ce:	89 c0                	mov    %eax,%eax
  8007d0:	48 01 d0             	add    %rdx,%rax
  8007d3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007d6:	83 c2 08             	add    $0x8,%edx
  8007d9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007dc:	eb 0f                	jmp    8007ed <vprintfmt+0x1f7>
  8007de:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007e2:	48 89 d0             	mov    %rdx,%rax
  8007e5:	48 83 c2 08          	add    $0x8,%rdx
  8007e9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007ed:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8007ef:	85 db                	test   %ebx,%ebx
  8007f1:	79 02                	jns    8007f5 <vprintfmt+0x1ff>
				err = -err;
  8007f3:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8007f5:	83 fb 15             	cmp    $0x15,%ebx
  8007f8:	7f 16                	jg     800810 <vprintfmt+0x21a>
  8007fa:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  800801:	00 00 00 
  800804:	48 63 d3             	movslq %ebx,%rdx
  800807:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80080b:	4d 85 e4             	test   %r12,%r12
  80080e:	75 2e                	jne    80083e <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800810:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800814:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800818:	89 d9                	mov    %ebx,%ecx
  80081a:	48 ba a1 19 80 00 00 	movabs $0x8019a1,%rdx
  800821:	00 00 00 
  800824:	48 89 c7             	mov    %rax,%rdi
  800827:	b8 00 00 00 00       	mov    $0x0,%eax
  80082c:	49 b8 21 0b 80 00 00 	movabs $0x800b21,%r8
  800833:	00 00 00 
  800836:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800839:	e9 d4 02 00 00       	jmpq   800b12 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80083e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800842:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800846:	4c 89 e1             	mov    %r12,%rcx
  800849:	48 ba aa 19 80 00 00 	movabs $0x8019aa,%rdx
  800850:	00 00 00 
  800853:	48 89 c7             	mov    %rax,%rdi
  800856:	b8 00 00 00 00       	mov    $0x0,%eax
  80085b:	49 b8 21 0b 80 00 00 	movabs $0x800b21,%r8
  800862:	00 00 00 
  800865:	41 ff d0             	callq  *%r8
			break;
  800868:	e9 a5 02 00 00       	jmpq   800b12 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80086d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800870:	83 f8 30             	cmp    $0x30,%eax
  800873:	73 17                	jae    80088c <vprintfmt+0x296>
  800875:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800879:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80087c:	89 c0                	mov    %eax,%eax
  80087e:	48 01 d0             	add    %rdx,%rax
  800881:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800884:	83 c2 08             	add    $0x8,%edx
  800887:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80088a:	eb 0f                	jmp    80089b <vprintfmt+0x2a5>
  80088c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800890:	48 89 d0             	mov    %rdx,%rax
  800893:	48 83 c2 08          	add    $0x8,%rdx
  800897:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80089b:	4c 8b 20             	mov    (%rax),%r12
  80089e:	4d 85 e4             	test   %r12,%r12
  8008a1:	75 0a                	jne    8008ad <vprintfmt+0x2b7>
				p = "(null)";
  8008a3:	49 bc ad 19 80 00 00 	movabs $0x8019ad,%r12
  8008aa:	00 00 00 
			if (width > 0 && padc != '-')
  8008ad:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008b1:	7e 3f                	jle    8008f2 <vprintfmt+0x2fc>
  8008b3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8008b7:	74 39                	je     8008f2 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008bc:	48 98                	cltq   
  8008be:	48 89 c6             	mov    %rax,%rsi
  8008c1:	4c 89 e7             	mov    %r12,%rdi
  8008c4:	48 b8 cd 0d 80 00 00 	movabs $0x800dcd,%rax
  8008cb:	00 00 00 
  8008ce:	ff d0                	callq  *%rax
  8008d0:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8008d3:	eb 17                	jmp    8008ec <vprintfmt+0x2f6>
					putch(padc, putdat);
  8008d5:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8008d9:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008dd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e1:	48 89 ce             	mov    %rcx,%rsi
  8008e4:	89 d7                	mov    %edx,%edi
  8008e6:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e8:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8008ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008f0:	7f e3                	jg     8008d5 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f2:	eb 37                	jmp    80092b <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8008f8:	74 1e                	je     800918 <vprintfmt+0x322>
  8008fa:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fd:	7e 05                	jle    800904 <vprintfmt+0x30e>
  8008ff:	83 fb 7e             	cmp    $0x7e,%ebx
  800902:	7e 14                	jle    800918 <vprintfmt+0x322>
					putch('?', putdat);
  800904:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800908:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80090c:	48 89 d6             	mov    %rdx,%rsi
  80090f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800914:	ff d0                	callq  *%rax
  800916:	eb 0f                	jmp    800927 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800918:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80091c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800920:	48 89 d6             	mov    %rdx,%rsi
  800923:	89 df                	mov    %ebx,%edi
  800925:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80092b:	4c 89 e0             	mov    %r12,%rax
  80092e:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800932:	0f b6 00             	movzbl (%rax),%eax
  800935:	0f be d8             	movsbl %al,%ebx
  800938:	85 db                	test   %ebx,%ebx
  80093a:	74 10                	je     80094c <vprintfmt+0x356>
  80093c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800940:	78 b2                	js     8008f4 <vprintfmt+0x2fe>
  800942:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800946:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80094a:	79 a8                	jns    8008f4 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094c:	eb 16                	jmp    800964 <vprintfmt+0x36e>
				putch(' ', putdat);
  80094e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800952:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800956:	48 89 d6             	mov    %rdx,%rsi
  800959:	bf 20 00 00 00       	mov    $0x20,%edi
  80095e:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800960:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800964:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800968:	7f e4                	jg     80094e <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  80096a:	e9 a3 01 00 00       	jmpq   800b12 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  80096f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800973:	be 03 00 00 00       	mov    $0x3,%esi
  800978:	48 89 c7             	mov    %rax,%rdi
  80097b:	48 b8 e6 04 80 00 00 	movabs $0x8004e6,%rax
  800982:	00 00 00 
  800985:	ff d0                	callq  *%rax
  800987:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80098b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098f:	48 85 c0             	test   %rax,%rax
  800992:	79 1d                	jns    8009b1 <vprintfmt+0x3bb>
				putch('-', putdat);
  800994:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800998:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80099c:	48 89 d6             	mov    %rdx,%rsi
  80099f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8009a4:	ff d0                	callq  *%rax
				num = -(long long) num;
  8009a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009aa:	48 f7 d8             	neg    %rax
  8009ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8009b1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009b8:	e9 e8 00 00 00       	jmpq   800aa5 <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8009bd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009c1:	be 03 00 00 00       	mov    $0x3,%esi
  8009c6:	48 89 c7             	mov    %rax,%rdi
  8009c9:	48 b8 d6 03 80 00 00 	movabs $0x8003d6,%rax
  8009d0:	00 00 00 
  8009d3:	ff d0                	callq  *%rax
  8009d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8009d9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8009e0:	e9 c0 00 00 00       	jmpq   800aa5 <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ed:	48 89 d6             	mov    %rdx,%rsi
  8009f0:	bf 58 00 00 00       	mov    $0x58,%edi
  8009f5:	ff d0                	callq  *%rax
			putch('X', putdat);
  8009f7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009fb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ff:	48 89 d6             	mov    %rdx,%rsi
  800a02:	bf 58 00 00 00       	mov    $0x58,%edi
  800a07:	ff d0                	callq  *%rax
			putch('X', putdat);
  800a09:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a11:	48 89 d6             	mov    %rdx,%rsi
  800a14:	bf 58 00 00 00       	mov    $0x58,%edi
  800a19:	ff d0                	callq  *%rax
			break;
  800a1b:	e9 f2 00 00 00       	jmpq   800b12 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800a20:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a24:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a28:	48 89 d6             	mov    %rdx,%rsi
  800a2b:	bf 30 00 00 00       	mov    $0x30,%edi
  800a30:	ff d0                	callq  *%rax
			putch('x', putdat);
  800a32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3a:	48 89 d6             	mov    %rdx,%rsi
  800a3d:	bf 78 00 00 00       	mov    $0x78,%edi
  800a42:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800a44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a47:	83 f8 30             	cmp    $0x30,%eax
  800a4a:	73 17                	jae    800a63 <vprintfmt+0x46d>
  800a4c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a50:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a53:	89 c0                	mov    %eax,%eax
  800a55:	48 01 d0             	add    %rdx,%rax
  800a58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a5b:	83 c2 08             	add    $0x8,%edx
  800a5e:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a61:	eb 0f                	jmp    800a72 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800a63:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a67:	48 89 d0             	mov    %rdx,%rax
  800a6a:	48 83 c2 08          	add    $0x8,%rdx
  800a6e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a72:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800a79:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800a80:	eb 23                	jmp    800aa5 <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800a82:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a86:	be 03 00 00 00       	mov    $0x3,%esi
  800a8b:	48 89 c7             	mov    %rax,%rdi
  800a8e:	48 b8 d6 03 80 00 00 	movabs $0x8003d6,%rax
  800a95:	00 00 00 
  800a98:	ff d0                	callq  *%rax
  800a9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800a9e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800aaa:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800aad:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ab0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ab8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abc:	45 89 c1             	mov    %r8d,%r9d
  800abf:	41 89 f8             	mov    %edi,%r8d
  800ac2:	48 89 c7             	mov    %rax,%rdi
  800ac5:	48 b8 1b 03 80 00 00 	movabs $0x80031b,%rax
  800acc:	00 00 00 
  800acf:	ff d0                	callq  *%rax
			break;
  800ad1:	eb 3f                	jmp    800b12 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800adb:	48 89 d6             	mov    %rdx,%rsi
  800ade:	89 df                	mov    %ebx,%edi
  800ae0:	ff d0                	callq  *%rax
			break;
  800ae2:	eb 2e                	jmp    800b12 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aec:	48 89 d6             	mov    %rdx,%rsi
  800aef:	bf 25 00 00 00       	mov    $0x25,%edi
  800af4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800afb:	eb 05                	jmp    800b02 <vprintfmt+0x50c>
  800afd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b02:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b06:	48 83 e8 01          	sub    $0x1,%rax
  800b0a:	0f b6 00             	movzbl (%rax),%eax
  800b0d:	3c 25                	cmp    $0x25,%al
  800b0f:	75 ec                	jne    800afd <vprintfmt+0x507>
				/* do nothing */;
			break;
  800b11:	90                   	nop
		}
	}
  800b12:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b13:	e9 30 fb ff ff       	jmpq   800648 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800b18:	48 83 c4 60          	add    $0x60,%rsp
  800b1c:	5b                   	pop    %rbx
  800b1d:	41 5c                	pop    %r12
  800b1f:	5d                   	pop    %rbp
  800b20:	c3                   	retq   

0000000000800b21 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b21:	55                   	push   %rbp
  800b22:	48 89 e5             	mov    %rsp,%rbp
  800b25:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800b2c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800b33:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800b3a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800b41:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800b48:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800b4f:	84 c0                	test   %al,%al
  800b51:	74 20                	je     800b73 <printfmt+0x52>
  800b53:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800b57:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800b5b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800b5f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800b63:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800b67:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800b6b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800b6f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800b73:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b7a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800b81:	00 00 00 
  800b84:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800b8b:	00 00 00 
  800b8e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b92:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800b99:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ba0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ba7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800bae:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800bb5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800bbc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800bc3:	48 89 c7             	mov    %rax,%rdi
  800bc6:	48 b8 f6 05 80 00 00 	movabs $0x8005f6,%rax
  800bcd:	00 00 00 
  800bd0:	ff d0                	callq  *%rax
	va_end(ap);
}
  800bd2:	c9                   	leaveq 
  800bd3:	c3                   	retq   

0000000000800bd4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bd4:	55                   	push   %rbp
  800bd5:	48 89 e5             	mov    %rsp,%rbp
  800bd8:	48 83 ec 10          	sub    $0x10,%rsp
  800bdc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bdf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800be3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800be7:	8b 40 10             	mov    0x10(%rax),%eax
  800bea:	8d 50 01             	lea    0x1(%rax),%edx
  800bed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800bf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bf8:	48 8b 10             	mov    (%rax),%rdx
  800bfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bff:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c03:	48 39 c2             	cmp    %rax,%rdx
  800c06:	73 17                	jae    800c1f <sprintputch+0x4b>
		*b->buf++ = ch;
  800c08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c0c:	48 8b 00             	mov    (%rax),%rax
  800c0f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c13:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c17:	48 89 0a             	mov    %rcx,(%rdx)
  800c1a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c1d:	88 10                	mov    %dl,(%rax)
}
  800c1f:	c9                   	leaveq 
  800c20:	c3                   	retq   

0000000000800c21 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c21:	55                   	push   %rbp
  800c22:	48 89 e5             	mov    %rsp,%rbp
  800c25:	48 83 ec 50          	sub    $0x50,%rsp
  800c29:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800c2d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800c30:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800c34:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800c38:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800c3c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800c40:	48 8b 0a             	mov    (%rdx),%rcx
  800c43:	48 89 08             	mov    %rcx,(%rax)
  800c46:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c4a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c4e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c52:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c56:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c5a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800c5e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800c61:	48 98                	cltq   
  800c63:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800c67:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c6b:	48 01 d0             	add    %rdx,%rax
  800c6e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800c72:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800c79:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800c7e:	74 06                	je     800c86 <vsnprintf+0x65>
  800c80:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800c84:	7f 07                	jg     800c8d <vsnprintf+0x6c>
		return -E_INVAL;
  800c86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c8b:	eb 2f                	jmp    800cbc <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800c8d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800c91:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800c95:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800c99:	48 89 c6             	mov    %rax,%rsi
  800c9c:	48 bf d4 0b 80 00 00 	movabs $0x800bd4,%rdi
  800ca3:	00 00 00 
  800ca6:	48 b8 f6 05 80 00 00 	movabs $0x8005f6,%rax
  800cad:	00 00 00 
  800cb0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800cb2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800cb6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800cb9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800cbc:	c9                   	leaveq 
  800cbd:	c3                   	retq   

0000000000800cbe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cbe:	55                   	push   %rbp
  800cbf:	48 89 e5             	mov    %rsp,%rbp
  800cc2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800cc9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800cd0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800cd6:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cdd:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ce4:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ceb:	84 c0                	test   %al,%al
  800ced:	74 20                	je     800d0f <snprintf+0x51>
  800cef:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cf3:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cf7:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cfb:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800cff:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d03:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d07:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d0b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d0f:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d16:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800d1d:	00 00 00 
  800d20:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800d27:	00 00 00 
  800d2a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d2e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800d35:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d3c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800d43:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800d4a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800d51:	48 8b 0a             	mov    (%rdx),%rcx
  800d54:	48 89 08             	mov    %rcx,(%rax)
  800d57:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d5b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d5f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d63:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800d67:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800d6e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800d75:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800d7b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800d82:	48 89 c7             	mov    %rax,%rdi
  800d85:	48 b8 21 0c 80 00 00 	movabs $0x800c21,%rax
  800d8c:	00 00 00 
  800d8f:	ff d0                	callq  *%rax
  800d91:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800d97:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800d9d:	c9                   	leaveq 
  800d9e:	c3                   	retq   

0000000000800d9f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d9f:	55                   	push   %rbp
  800da0:	48 89 e5             	mov    %rsp,%rbp
  800da3:	48 83 ec 18          	sub    $0x18,%rsp
  800da7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800dab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800db2:	eb 09                	jmp    800dbd <strlen+0x1e>
		n++;
  800db4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800db8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800dbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dc1:	0f b6 00             	movzbl (%rax),%eax
  800dc4:	84 c0                	test   %al,%al
  800dc6:	75 ec                	jne    800db4 <strlen+0x15>
		n++;
	return n;
  800dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800dcb:	c9                   	leaveq 
  800dcc:	c3                   	retq   

0000000000800dcd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dcd:	55                   	push   %rbp
  800dce:	48 89 e5             	mov    %rsp,%rbp
  800dd1:	48 83 ec 20          	sub    $0x20,%rsp
  800dd5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800dd9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ddd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800de4:	eb 0e                	jmp    800df4 <strnlen+0x27>
		n++;
  800de6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dea:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800def:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800df4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800df9:	74 0b                	je     800e06 <strnlen+0x39>
  800dfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800dff:	0f b6 00             	movzbl (%rax),%eax
  800e02:	84 c0                	test   %al,%al
  800e04:	75 e0                	jne    800de6 <strnlen+0x19>
		n++;
	return n;
  800e06:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e09:	c9                   	leaveq 
  800e0a:	c3                   	retq   

0000000000800e0b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e0b:	55                   	push   %rbp
  800e0c:	48 89 e5             	mov    %rsp,%rbp
  800e0f:	48 83 ec 20          	sub    $0x20,%rsp
  800e13:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e17:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800e1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e1f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800e23:	90                   	nop
  800e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e28:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800e2c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e30:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800e34:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800e38:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800e3c:	0f b6 12             	movzbl (%rdx),%edx
  800e3f:	88 10                	mov    %dl,(%rax)
  800e41:	0f b6 00             	movzbl (%rax),%eax
  800e44:	84 c0                	test   %al,%al
  800e46:	75 dc                	jne    800e24 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800e48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800e4c:	c9                   	leaveq 
  800e4d:	c3                   	retq   

0000000000800e4e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e4e:	55                   	push   %rbp
  800e4f:	48 89 e5             	mov    %rsp,%rbp
  800e52:	48 83 ec 20          	sub    $0x20,%rsp
  800e56:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e5a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800e5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e62:	48 89 c7             	mov    %rax,%rdi
  800e65:	48 b8 9f 0d 80 00 00 	movabs $0x800d9f,%rax
  800e6c:	00 00 00 
  800e6f:	ff d0                	callq  *%rax
  800e71:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800e74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e77:	48 63 d0             	movslq %eax,%rdx
  800e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e7e:	48 01 c2             	add    %rax,%rdx
  800e81:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e85:	48 89 c6             	mov    %rax,%rsi
  800e88:	48 89 d7             	mov    %rdx,%rdi
  800e8b:	48 b8 0b 0e 80 00 00 	movabs $0x800e0b,%rax
  800e92:	00 00 00 
  800e95:	ff d0                	callq  *%rax
	return dst;
  800e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800e9b:	c9                   	leaveq 
  800e9c:	c3                   	retq   

0000000000800e9d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e9d:	55                   	push   %rbp
  800e9e:	48 89 e5             	mov    %rsp,%rbp
  800ea1:	48 83 ec 28          	sub    $0x28,%rsp
  800ea5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ea9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ead:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800eb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800eb9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800ec0:	00 
  800ec1:	eb 2a                	jmp    800eed <strncpy+0x50>
		*dst++ = *src;
  800ec3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ecb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ecf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ed3:	0f b6 12             	movzbl (%rdx),%edx
  800ed6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800edc:	0f b6 00             	movzbl (%rax),%eax
  800edf:	84 c0                	test   %al,%al
  800ee1:	74 05                	je     800ee8 <strncpy+0x4b>
			src++;
  800ee3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ee8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800eed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ef1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800ef5:	72 cc                	jb     800ec3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800efb:	c9                   	leaveq 
  800efc:	c3                   	retq   

0000000000800efd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800efd:	55                   	push   %rbp
  800efe:	48 89 e5             	mov    %rsp,%rbp
  800f01:	48 83 ec 28          	sub    $0x28,%rsp
  800f05:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f09:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f0d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800f19:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f1e:	74 3d                	je     800f5d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800f20:	eb 1d                	jmp    800f3f <strlcpy+0x42>
			*dst++ = *src++;
  800f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f26:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f2a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f2e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f32:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f36:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f3a:	0f b6 12             	movzbl (%rdx),%edx
  800f3d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f3f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800f44:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800f49:	74 0b                	je     800f56 <strlcpy+0x59>
  800f4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f4f:	0f b6 00             	movzbl (%rax),%eax
  800f52:	84 c0                	test   %al,%al
  800f54:	75 cc                	jne    800f22 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800f56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f5a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800f5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f65:	48 29 c2             	sub    %rax,%rdx
  800f68:	48 89 d0             	mov    %rdx,%rax
}
  800f6b:	c9                   	leaveq 
  800f6c:	c3                   	retq   

0000000000800f6d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f6d:	55                   	push   %rbp
  800f6e:	48 89 e5             	mov    %rsp,%rbp
  800f71:	48 83 ec 10          	sub    $0x10,%rsp
  800f75:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f79:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  800f7d:	eb 0a                	jmp    800f89 <strcmp+0x1c>
		p++, q++;
  800f7f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f84:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f8d:	0f b6 00             	movzbl (%rax),%eax
  800f90:	84 c0                	test   %al,%al
  800f92:	74 12                	je     800fa6 <strcmp+0x39>
  800f94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f98:	0f b6 10             	movzbl (%rax),%edx
  800f9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f9f:	0f b6 00             	movzbl (%rax),%eax
  800fa2:	38 c2                	cmp    %al,%dl
  800fa4:	74 d9                	je     800f7f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800faa:	0f b6 00             	movzbl (%rax),%eax
  800fad:	0f b6 d0             	movzbl %al,%edx
  800fb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fb4:	0f b6 00             	movzbl (%rax),%eax
  800fb7:	0f b6 c0             	movzbl %al,%eax
  800fba:	29 c2                	sub    %eax,%edx
  800fbc:	89 d0                	mov    %edx,%eax
}
  800fbe:	c9                   	leaveq 
  800fbf:	c3                   	retq   

0000000000800fc0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fc0:	55                   	push   %rbp
  800fc1:	48 89 e5             	mov    %rsp,%rbp
  800fc4:	48 83 ec 18          	sub    $0x18,%rsp
  800fc8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800fcc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800fd0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800fd4:	eb 0f                	jmp    800fe5 <strncmp+0x25>
		n--, p++, q++;
  800fd6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800fdb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fe0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800fe5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800fea:	74 1d                	je     801009 <strncmp+0x49>
  800fec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ff0:	0f b6 00             	movzbl (%rax),%eax
  800ff3:	84 c0                	test   %al,%al
  800ff5:	74 12                	je     801009 <strncmp+0x49>
  800ff7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ffb:	0f b6 10             	movzbl (%rax),%edx
  800ffe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801002:	0f b6 00             	movzbl (%rax),%eax
  801005:	38 c2                	cmp    %al,%dl
  801007:	74 cd                	je     800fd6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801009:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80100e:	75 07                	jne    801017 <strncmp+0x57>
		return 0;
  801010:	b8 00 00 00 00       	mov    $0x0,%eax
  801015:	eb 18                	jmp    80102f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801017:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80101b:	0f b6 00             	movzbl (%rax),%eax
  80101e:	0f b6 d0             	movzbl %al,%edx
  801021:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801025:	0f b6 00             	movzbl (%rax),%eax
  801028:	0f b6 c0             	movzbl %al,%eax
  80102b:	29 c2                	sub    %eax,%edx
  80102d:	89 d0                	mov    %edx,%eax
}
  80102f:	c9                   	leaveq 
  801030:	c3                   	retq   

0000000000801031 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801031:	55                   	push   %rbp
  801032:	48 89 e5             	mov    %rsp,%rbp
  801035:	48 83 ec 0c          	sub    $0xc,%rsp
  801039:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80103d:	89 f0                	mov    %esi,%eax
  80103f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801042:	eb 17                	jmp    80105b <strchr+0x2a>
		if (*s == c)
  801044:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801048:	0f b6 00             	movzbl (%rax),%eax
  80104b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80104e:	75 06                	jne    801056 <strchr+0x25>
			return (char *) s;
  801050:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801054:	eb 15                	jmp    80106b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801056:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80105b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105f:	0f b6 00             	movzbl (%rax),%eax
  801062:	84 c0                	test   %al,%al
  801064:	75 de                	jne    801044 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801066:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106b:	c9                   	leaveq 
  80106c:	c3                   	retq   

000000000080106d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80106d:	55                   	push   %rbp
  80106e:	48 89 e5             	mov    %rsp,%rbp
  801071:	48 83 ec 0c          	sub    $0xc,%rsp
  801075:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801079:	89 f0                	mov    %esi,%eax
  80107b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80107e:	eb 13                	jmp    801093 <strfind+0x26>
		if (*s == c)
  801080:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801084:	0f b6 00             	movzbl (%rax),%eax
  801087:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80108a:	75 02                	jne    80108e <strfind+0x21>
			break;
  80108c:	eb 10                	jmp    80109e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80108e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801093:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801097:	0f b6 00             	movzbl (%rax),%eax
  80109a:	84 c0                	test   %al,%al
  80109c:	75 e2                	jne    801080 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80109e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010a2:	c9                   	leaveq 
  8010a3:	c3                   	retq   

00000000008010a4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010a4:	55                   	push   %rbp
  8010a5:	48 89 e5             	mov    %rsp,%rbp
  8010a8:	48 83 ec 18          	sub    $0x18,%rsp
  8010ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010b0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8010b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8010b7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010bc:	75 06                	jne    8010c4 <memset+0x20>
		return v;
  8010be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c2:	eb 69                	jmp    80112d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8010c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c8:	83 e0 03             	and    $0x3,%eax
  8010cb:	48 85 c0             	test   %rax,%rax
  8010ce:	75 48                	jne    801118 <memset+0x74>
  8010d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d4:	83 e0 03             	and    $0x3,%eax
  8010d7:	48 85 c0             	test   %rax,%rax
  8010da:	75 3c                	jne    801118 <memset+0x74>
		c &= 0xFF;
  8010dc:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010e3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010e6:	c1 e0 18             	shl    $0x18,%eax
  8010e9:	89 c2                	mov    %eax,%edx
  8010eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010ee:	c1 e0 10             	shl    $0x10,%eax
  8010f1:	09 c2                	or     %eax,%edx
  8010f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8010f6:	c1 e0 08             	shl    $0x8,%eax
  8010f9:	09 d0                	or     %edx,%eax
  8010fb:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8010fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801102:	48 c1 e8 02          	shr    $0x2,%rax
  801106:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801109:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80110d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801110:	48 89 d7             	mov    %rdx,%rdi
  801113:	fc                   	cld    
  801114:	f3 ab                	rep stos %eax,%es:(%rdi)
  801116:	eb 11                	jmp    801129 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801118:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80111c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80111f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801123:	48 89 d7             	mov    %rdx,%rdi
  801126:	fc                   	cld    
  801127:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801129:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80112d:	c9                   	leaveq 
  80112e:	c3                   	retq   

000000000080112f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80112f:	55                   	push   %rbp
  801130:	48 89 e5             	mov    %rsp,%rbp
  801133:	48 83 ec 28          	sub    $0x28,%rsp
  801137:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80113b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80113f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801143:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801147:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80114b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801153:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801157:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80115b:	0f 83 88 00 00 00    	jae    8011e9 <memmove+0xba>
  801161:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801165:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801169:	48 01 d0             	add    %rdx,%rax
  80116c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801170:	76 77                	jbe    8011e9 <memmove+0xba>
		s += n;
  801172:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801176:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80117a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80117e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801182:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801186:	83 e0 03             	and    $0x3,%eax
  801189:	48 85 c0             	test   %rax,%rax
  80118c:	75 3b                	jne    8011c9 <memmove+0x9a>
  80118e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801192:	83 e0 03             	and    $0x3,%eax
  801195:	48 85 c0             	test   %rax,%rax
  801198:	75 2f                	jne    8011c9 <memmove+0x9a>
  80119a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80119e:	83 e0 03             	and    $0x3,%eax
  8011a1:	48 85 c0             	test   %rax,%rax
  8011a4:	75 23                	jne    8011c9 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011aa:	48 83 e8 04          	sub    $0x4,%rax
  8011ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011b2:	48 83 ea 04          	sub    $0x4,%rdx
  8011b6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8011ba:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011be:	48 89 c7             	mov    %rax,%rdi
  8011c1:	48 89 d6             	mov    %rdx,%rsi
  8011c4:	fd                   	std    
  8011c5:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8011c7:	eb 1d                	jmp    8011e6 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011cd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d5:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011dd:	48 89 d7             	mov    %rdx,%rdi
  8011e0:	48 89 c1             	mov    %rax,%rcx
  8011e3:	fd                   	std    
  8011e4:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011e6:	fc                   	cld    
  8011e7:	eb 57                	jmp    801240 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8011e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ed:	83 e0 03             	and    $0x3,%eax
  8011f0:	48 85 c0             	test   %rax,%rax
  8011f3:	75 36                	jne    80122b <memmove+0xfc>
  8011f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f9:	83 e0 03             	and    $0x3,%eax
  8011fc:	48 85 c0             	test   %rax,%rax
  8011ff:	75 2a                	jne    80122b <memmove+0xfc>
  801201:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801205:	83 e0 03             	and    $0x3,%eax
  801208:	48 85 c0             	test   %rax,%rax
  80120b:	75 1e                	jne    80122b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80120d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801211:	48 c1 e8 02          	shr    $0x2,%rax
  801215:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801218:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801220:	48 89 c7             	mov    %rax,%rdi
  801223:	48 89 d6             	mov    %rdx,%rsi
  801226:	fc                   	cld    
  801227:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801229:	eb 15                	jmp    801240 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80122b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80122f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801233:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801237:	48 89 c7             	mov    %rax,%rdi
  80123a:	48 89 d6             	mov    %rdx,%rsi
  80123d:	fc                   	cld    
  80123e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801240:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801244:	c9                   	leaveq 
  801245:	c3                   	retq   

0000000000801246 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801246:	55                   	push   %rbp
  801247:	48 89 e5             	mov    %rsp,%rbp
  80124a:	48 83 ec 18          	sub    $0x18,%rsp
  80124e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801252:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801256:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80125a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80125e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801266:	48 89 ce             	mov    %rcx,%rsi
  801269:	48 89 c7             	mov    %rax,%rdi
  80126c:	48 b8 2f 11 80 00 00 	movabs $0x80112f,%rax
  801273:	00 00 00 
  801276:	ff d0                	callq  *%rax
}
  801278:	c9                   	leaveq 
  801279:	c3                   	retq   

000000000080127a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80127a:	55                   	push   %rbp
  80127b:	48 89 e5             	mov    %rsp,%rbp
  80127e:	48 83 ec 28          	sub    $0x28,%rsp
  801282:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801286:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80128a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80128e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801292:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801296:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80129a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80129e:	eb 36                	jmp    8012d6 <memcmp+0x5c>
		if (*s1 != *s2)
  8012a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a4:	0f b6 10             	movzbl (%rax),%edx
  8012a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ab:	0f b6 00             	movzbl (%rax),%eax
  8012ae:	38 c2                	cmp    %al,%dl
  8012b0:	74 1a                	je     8012cc <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8012b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b6:	0f b6 00             	movzbl (%rax),%eax
  8012b9:	0f b6 d0             	movzbl %al,%edx
  8012bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c0:	0f b6 00             	movzbl (%rax),%eax
  8012c3:	0f b6 c0             	movzbl %al,%eax
  8012c6:	29 c2                	sub    %eax,%edx
  8012c8:	89 d0                	mov    %edx,%eax
  8012ca:	eb 20                	jmp    8012ec <memcmp+0x72>
		s1++, s2++;
  8012cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8012d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012da:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012de:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8012e2:	48 85 c0             	test   %rax,%rax
  8012e5:	75 b9                	jne    8012a0 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ec:	c9                   	leaveq 
  8012ed:	c3                   	retq   

00000000008012ee <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8012ee:	55                   	push   %rbp
  8012ef:	48 89 e5             	mov    %rsp,%rbp
  8012f2:	48 83 ec 28          	sub    $0x28,%rsp
  8012f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012fa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8012fd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801301:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801305:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801309:	48 01 d0             	add    %rdx,%rax
  80130c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801310:	eb 15                	jmp    801327 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801312:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801316:	0f b6 10             	movzbl (%rax),%edx
  801319:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80131c:	38 c2                	cmp    %al,%dl
  80131e:	75 02                	jne    801322 <memfind+0x34>
			break;
  801320:	eb 0f                	jmp    801331 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801322:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80132f:	72 e1                	jb     801312 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801335:	c9                   	leaveq 
  801336:	c3                   	retq   

0000000000801337 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801337:	55                   	push   %rbp
  801338:	48 89 e5             	mov    %rsp,%rbp
  80133b:	48 83 ec 34          	sub    $0x34,%rsp
  80133f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801343:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801347:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80134a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801351:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801358:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801359:	eb 05                	jmp    801360 <strtol+0x29>
		s++;
  80135b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801360:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801364:	0f b6 00             	movzbl (%rax),%eax
  801367:	3c 20                	cmp    $0x20,%al
  801369:	74 f0                	je     80135b <strtol+0x24>
  80136b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136f:	0f b6 00             	movzbl (%rax),%eax
  801372:	3c 09                	cmp    $0x9,%al
  801374:	74 e5                	je     80135b <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801376:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137a:	0f b6 00             	movzbl (%rax),%eax
  80137d:	3c 2b                	cmp    $0x2b,%al
  80137f:	75 07                	jne    801388 <strtol+0x51>
		s++;
  801381:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801386:	eb 17                	jmp    80139f <strtol+0x68>
	else if (*s == '-')
  801388:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138c:	0f b6 00             	movzbl (%rax),%eax
  80138f:	3c 2d                	cmp    $0x2d,%al
  801391:	75 0c                	jne    80139f <strtol+0x68>
		s++, neg = 1;
  801393:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801398:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80139f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013a3:	74 06                	je     8013ab <strtol+0x74>
  8013a5:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8013a9:	75 28                	jne    8013d3 <strtol+0x9c>
  8013ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013af:	0f b6 00             	movzbl (%rax),%eax
  8013b2:	3c 30                	cmp    $0x30,%al
  8013b4:	75 1d                	jne    8013d3 <strtol+0x9c>
  8013b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ba:	48 83 c0 01          	add    $0x1,%rax
  8013be:	0f b6 00             	movzbl (%rax),%eax
  8013c1:	3c 78                	cmp    $0x78,%al
  8013c3:	75 0e                	jne    8013d3 <strtol+0x9c>
		s += 2, base = 16;
  8013c5:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8013ca:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8013d1:	eb 2c                	jmp    8013ff <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8013d3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013d7:	75 19                	jne    8013f2 <strtol+0xbb>
  8013d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013dd:	0f b6 00             	movzbl (%rax),%eax
  8013e0:	3c 30                	cmp    $0x30,%al
  8013e2:	75 0e                	jne    8013f2 <strtol+0xbb>
		s++, base = 8;
  8013e4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8013e9:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8013f0:	eb 0d                	jmp    8013ff <strtol+0xc8>
	else if (base == 0)
  8013f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8013f6:	75 07                	jne    8013ff <strtol+0xc8>
		base = 10;
  8013f8:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801403:	0f b6 00             	movzbl (%rax),%eax
  801406:	3c 2f                	cmp    $0x2f,%al
  801408:	7e 1d                	jle    801427 <strtol+0xf0>
  80140a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140e:	0f b6 00             	movzbl (%rax),%eax
  801411:	3c 39                	cmp    $0x39,%al
  801413:	7f 12                	jg     801427 <strtol+0xf0>
			dig = *s - '0';
  801415:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801419:	0f b6 00             	movzbl (%rax),%eax
  80141c:	0f be c0             	movsbl %al,%eax
  80141f:	83 e8 30             	sub    $0x30,%eax
  801422:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801425:	eb 4e                	jmp    801475 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801427:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142b:	0f b6 00             	movzbl (%rax),%eax
  80142e:	3c 60                	cmp    $0x60,%al
  801430:	7e 1d                	jle    80144f <strtol+0x118>
  801432:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801436:	0f b6 00             	movzbl (%rax),%eax
  801439:	3c 7a                	cmp    $0x7a,%al
  80143b:	7f 12                	jg     80144f <strtol+0x118>
			dig = *s - 'a' + 10;
  80143d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801441:	0f b6 00             	movzbl (%rax),%eax
  801444:	0f be c0             	movsbl %al,%eax
  801447:	83 e8 57             	sub    $0x57,%eax
  80144a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80144d:	eb 26                	jmp    801475 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80144f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801453:	0f b6 00             	movzbl (%rax),%eax
  801456:	3c 40                	cmp    $0x40,%al
  801458:	7e 48                	jle    8014a2 <strtol+0x16b>
  80145a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145e:	0f b6 00             	movzbl (%rax),%eax
  801461:	3c 5a                	cmp    $0x5a,%al
  801463:	7f 3d                	jg     8014a2 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801469:	0f b6 00             	movzbl (%rax),%eax
  80146c:	0f be c0             	movsbl %al,%eax
  80146f:	83 e8 37             	sub    $0x37,%eax
  801472:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801475:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801478:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80147b:	7c 02                	jl     80147f <strtol+0x148>
			break;
  80147d:	eb 23                	jmp    8014a2 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80147f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801484:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801487:	48 98                	cltq   
  801489:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80148e:	48 89 c2             	mov    %rax,%rdx
  801491:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801494:	48 98                	cltq   
  801496:	48 01 d0             	add    %rdx,%rax
  801499:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80149d:	e9 5d ff ff ff       	jmpq   8013ff <strtol+0xc8>

	if (endptr)
  8014a2:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8014a7:	74 0b                	je     8014b4 <strtol+0x17d>
		*endptr = (char *) s;
  8014a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014ad:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8014b1:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8014b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8014b8:	74 09                	je     8014c3 <strtol+0x18c>
  8014ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014be:	48 f7 d8             	neg    %rax
  8014c1:	eb 04                	jmp    8014c7 <strtol+0x190>
  8014c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8014c7:	c9                   	leaveq 
  8014c8:	c3                   	retq   

00000000008014c9 <strstr>:

char * strstr(const char *in, const char *str)
{
  8014c9:	55                   	push   %rbp
  8014ca:	48 89 e5             	mov    %rsp,%rbp
  8014cd:	48 83 ec 30          	sub    $0x30,%rsp
  8014d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8014d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014e1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8014e5:	0f b6 00             	movzbl (%rax),%eax
  8014e8:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8014eb:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8014ef:	75 06                	jne    8014f7 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8014f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f5:	eb 6b                	jmp    801562 <strstr+0x99>

	len = strlen(str);
  8014f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014fb:	48 89 c7             	mov    %rax,%rdi
  8014fe:	48 b8 9f 0d 80 00 00 	movabs $0x800d9f,%rax
  801505:	00 00 00 
  801508:	ff d0                	callq  *%rax
  80150a:	48 98                	cltq   
  80150c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801510:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801514:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801518:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80151c:	0f b6 00             	movzbl (%rax),%eax
  80151f:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801522:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801526:	75 07                	jne    80152f <strstr+0x66>
				return (char *) 0;
  801528:	b8 00 00 00 00       	mov    $0x0,%eax
  80152d:	eb 33                	jmp    801562 <strstr+0x99>
		} while (sc != c);
  80152f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801533:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801536:	75 d8                	jne    801510 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801538:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80153c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801540:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801544:	48 89 ce             	mov    %rcx,%rsi
  801547:	48 89 c7             	mov    %rax,%rdi
  80154a:	48 b8 c0 0f 80 00 00 	movabs $0x800fc0,%rax
  801551:	00 00 00 
  801554:	ff d0                	callq  *%rax
  801556:	85 c0                	test   %eax,%eax
  801558:	75 b6                	jne    801510 <strstr+0x47>

	return (char *) (in - 1);
  80155a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155e:	48 83 e8 01          	sub    $0x1,%rax
}
  801562:	c9                   	leaveq 
  801563:	c3                   	retq   

0000000000801564 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801564:	55                   	push   %rbp
  801565:	48 89 e5             	mov    %rsp,%rbp
  801568:	53                   	push   %rbx
  801569:	48 83 ec 48          	sub    $0x48,%rsp
  80156d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801570:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801573:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801577:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80157b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80157f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801583:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801586:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80158a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80158e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801592:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801596:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80159a:	4c 89 c3             	mov    %r8,%rbx
  80159d:	cd 30                	int    $0x30
  80159f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8015a7:	74 3e                	je     8015e7 <syscall+0x83>
  8015a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015ae:	7e 37                	jle    8015e7 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015b4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015b7:	49 89 d0             	mov    %rdx,%r8
  8015ba:	89 c1                	mov    %eax,%ecx
  8015bc:	48 ba 68 1c 80 00 00 	movabs $0x801c68,%rdx
  8015c3:	00 00 00 
  8015c6:	be 23 00 00 00       	mov    $0x23,%esi
  8015cb:	48 bf 85 1c 80 00 00 	movabs $0x801c85,%rdi
  8015d2:	00 00 00 
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015da:	49 b9 fc 16 80 00 00 	movabs $0x8016fc,%r9
  8015e1:	00 00 00 
  8015e4:	41 ff d1             	callq  *%r9

	return ret;
  8015e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8015eb:	48 83 c4 48          	add    $0x48,%rsp
  8015ef:	5b                   	pop    %rbx
  8015f0:	5d                   	pop    %rbp
  8015f1:	c3                   	retq   

00000000008015f2 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8015f2:	55                   	push   %rbp
  8015f3:	48 89 e5             	mov    %rsp,%rbp
  8015f6:	48 83 ec 20          	sub    $0x20,%rsp
  8015fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801602:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801606:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80160a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801611:	00 
  801612:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801618:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80161e:	48 89 d1             	mov    %rdx,%rcx
  801621:	48 89 c2             	mov    %rax,%rdx
  801624:	be 00 00 00 00       	mov    $0x0,%esi
  801629:	bf 00 00 00 00       	mov    $0x0,%edi
  80162e:	48 b8 64 15 80 00 00 	movabs $0x801564,%rax
  801635:	00 00 00 
  801638:	ff d0                	callq  *%rax
}
  80163a:	c9                   	leaveq 
  80163b:	c3                   	retq   

000000000080163c <sys_cgetc>:

int
sys_cgetc(void)
{
  80163c:	55                   	push   %rbp
  80163d:	48 89 e5             	mov    %rsp,%rbp
  801640:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801644:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80164b:	00 
  80164c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801652:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801658:	b9 00 00 00 00       	mov    $0x0,%ecx
  80165d:	ba 00 00 00 00       	mov    $0x0,%edx
  801662:	be 00 00 00 00       	mov    $0x0,%esi
  801667:	bf 01 00 00 00       	mov    $0x1,%edi
  80166c:	48 b8 64 15 80 00 00 	movabs $0x801564,%rax
  801673:	00 00 00 
  801676:	ff d0                	callq  *%rax
}
  801678:	c9                   	leaveq 
  801679:	c3                   	retq   

000000000080167a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80167a:	55                   	push   %rbp
  80167b:	48 89 e5             	mov    %rsp,%rbp
  80167e:	48 83 ec 10          	sub    $0x10,%rsp
  801682:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801685:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801688:	48 98                	cltq   
  80168a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801691:	00 
  801692:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801698:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80169e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016a3:	48 89 c2             	mov    %rax,%rdx
  8016a6:	be 01 00 00 00       	mov    $0x1,%esi
  8016ab:	bf 03 00 00 00       	mov    $0x3,%edi
  8016b0:	48 b8 64 15 80 00 00 	movabs $0x801564,%rax
  8016b7:	00 00 00 
  8016ba:	ff d0                	callq  *%rax
}
  8016bc:	c9                   	leaveq 
  8016bd:	c3                   	retq   

00000000008016be <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8016be:	55                   	push   %rbp
  8016bf:	48 89 e5             	mov    %rsp,%rbp
  8016c2:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8016c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016cd:	00 
  8016ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016df:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e4:	be 00 00 00 00       	mov    $0x0,%esi
  8016e9:	bf 02 00 00 00       	mov    $0x2,%edi
  8016ee:	48 b8 64 15 80 00 00 	movabs $0x801564,%rax
  8016f5:	00 00 00 
  8016f8:	ff d0                	callq  *%rax
}
  8016fa:	c9                   	leaveq 
  8016fb:	c3                   	retq   

00000000008016fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8016fc:	55                   	push   %rbp
  8016fd:	48 89 e5             	mov    %rsp,%rbp
  801700:	53                   	push   %rbx
  801701:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801708:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80170f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801715:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80171c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801723:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80172a:	84 c0                	test   %al,%al
  80172c:	74 23                	je     801751 <_panic+0x55>
  80172e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801735:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801739:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80173d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801741:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801745:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801749:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80174d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  801751:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801758:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80175f:	00 00 00 
  801762:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  801769:	00 00 00 
  80176c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801770:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  801777:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80177e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801785:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80178c:	00 00 00 
  80178f:	48 8b 18             	mov    (%rax),%rbx
  801792:	48 b8 be 16 80 00 00 	movabs $0x8016be,%rax
  801799:	00 00 00 
  80179c:	ff d0                	callq  *%rax
  80179e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8017a4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8017ab:	41 89 c8             	mov    %ecx,%r8d
  8017ae:	48 89 d1             	mov    %rdx,%rcx
  8017b1:	48 89 da             	mov    %rbx,%rdx
  8017b4:	89 c6                	mov    %eax,%esi
  8017b6:	48 bf 98 1c 80 00 00 	movabs $0x801c98,%rdi
  8017bd:	00 00 00 
  8017c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c5:	49 b9 43 02 80 00 00 	movabs $0x800243,%r9
  8017cc:	00 00 00 
  8017cf:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017d2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8017d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8017e0:	48 89 d6             	mov    %rdx,%rsi
  8017e3:	48 89 c7             	mov    %rax,%rdi
  8017e6:	48 b8 97 01 80 00 00 	movabs $0x800197,%rax
  8017ed:	00 00 00 
  8017f0:	ff d0                	callq  *%rax
	cprintf("\n");
  8017f2:	48 bf bb 1c 80 00 00 	movabs $0x801cbb,%rdi
  8017f9:	00 00 00 
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801801:	48 ba 43 02 80 00 00 	movabs $0x800243,%rdx
  801808:	00 00 00 
  80180b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80180d:	cc                   	int3   
  80180e:	eb fd                	jmp    80180d <_panic+0x111>
