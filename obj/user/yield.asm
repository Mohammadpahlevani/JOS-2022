
obj/user/yield:     file format elf64-x86-64


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
  80003c:	e8 c5 00 00 00       	callq  800106 <libmain>
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
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  800052:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf 80 35 80 00 00 	movabs $0x803580,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba de 02 80 00 00 	movabs $0x8002de,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	for (i = 0; i < 5; i++) {
  800082:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800089:	eb 43                	jmp    8000ce <umain+0x8b>
		sys_yield();
  80008b:	48 b8 84 17 80 00 00 	movabs $0x801784,%rax
  800092:	00 00 00 
  800095:	ff d0                	callq  *%rax
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  800097:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80009e:	00 00 00 
  8000a1:	48 8b 00             	mov    (%rax),%rax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  8000a4:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000aa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8000ad:	89 c6                	mov    %eax,%esi
  8000af:	48 bf a0 35 80 00 00 	movabs $0x8035a0,%rdi
  8000b6:	00 00 00 
  8000b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000be:	48 b9 de 02 80 00 00 	movabs $0x8002de,%rcx
  8000c5:	00 00 00 
  8000c8:	ff d1                	callq  *%rcx
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  8000ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000ce:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8000d2:	7e b7                	jle    80008b <umain+0x48>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  8000d4:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8000db:	00 00 00 
  8000de:	48 8b 00             	mov    (%rax),%rax
  8000e1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8000e7:	89 c6                	mov    %eax,%esi
  8000e9:	48 bf d0 35 80 00 00 	movabs $0x8035d0,%rdi
  8000f0:	00 00 00 
  8000f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f8:	48 ba de 02 80 00 00 	movabs $0x8002de,%rdx
  8000ff:	00 00 00 
  800102:	ff d2                	callq  *%rdx
}
  800104:	c9                   	leaveq 
  800105:	c3                   	retq   

0000000000800106 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800106:	55                   	push   %rbp
  800107:	48 89 e5             	mov    %rsp,%rbp
  80010a:	48 83 ec 10          	sub    $0x10,%rsp
  80010e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800111:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800115:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	48 98                	cltq   
  800123:	25 ff 03 00 00       	and    $0x3ff,%eax
  800128:	48 89 c2             	mov    %rax,%rdx
  80012b:	48 89 d0             	mov    %rdx,%rax
  80012e:	48 c1 e0 03          	shl    $0x3,%rax
  800132:	48 01 d0             	add    %rdx,%rax
  800135:	48 c1 e0 05          	shl    $0x5,%rax
  800139:	48 89 c2             	mov    %rax,%rdx
  80013c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800143:	00 00 00 
  800146:	48 01 c2             	add    %rax,%rdx
  800149:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800150:	00 00 00 
  800153:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800156:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80015a:	7e 14                	jle    800170 <libmain+0x6a>
		binaryname = argv[0];
  80015c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800160:	48 8b 10             	mov    (%rax),%rdx
  800163:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80016a:	00 00 00 
  80016d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800170:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800174:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800177:	48 89 d6             	mov    %rdx,%rsi
  80017a:	89 c7                	mov    %eax,%edi
  80017c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800183:	00 00 00 
  800186:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800188:	48 b8 96 01 80 00 00 	movabs $0x800196,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
}
  800194:	c9                   	leaveq 
  800195:	c3                   	retq   

0000000000800196 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800196:	55                   	push   %rbp
  800197:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80019a:	48 b8 70 1d 80 00 00 	movabs $0x801d70,%rax
  8001a1:	00 00 00 
  8001a4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ab:	48 b8 02 17 80 00 00 	movabs $0x801702,%rax
  8001b2:	00 00 00 
  8001b5:	ff d0                	callq  *%rax
}
  8001b7:	5d                   	pop    %rbp
  8001b8:	c3                   	retq   

00000000008001b9 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001b9:	55                   	push   %rbp
  8001ba:	48 89 e5             	mov    %rsp,%rbp
  8001bd:	48 83 ec 10          	sub    $0x10,%rsp
  8001c1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001c4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001cc:	8b 00                	mov    (%rax),%eax
  8001ce:	8d 48 01             	lea    0x1(%rax),%ecx
  8001d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d5:	89 0a                	mov    %ecx,(%rdx)
  8001d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001e0:	48 98                	cltq   
  8001e2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001ea:	8b 00                	mov    (%rax),%eax
  8001ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f1:	75 2c                	jne    80021f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8001f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001f7:	8b 00                	mov    (%rax),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ff:	48 83 c2 08          	add    $0x8,%rdx
  800203:	48 89 c6             	mov    %rax,%rsi
  800206:	48 89 d7             	mov    %rdx,%rdi
  800209:	48 b8 7a 16 80 00 00 	movabs $0x80167a,%rax
  800210:	00 00 00 
  800213:	ff d0                	callq  *%rax
        b->idx = 0;
  800215:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800219:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80021f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800223:	8b 40 04             	mov    0x4(%rax),%eax
  800226:	8d 50 01             	lea    0x1(%rax),%edx
  800229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800230:	c9                   	leaveq 
  800231:	c3                   	retq   

0000000000800232 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800232:	55                   	push   %rbp
  800233:	48 89 e5             	mov    %rsp,%rbp
  800236:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80023d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800244:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80024b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800252:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800259:	48 8b 0a             	mov    (%rdx),%rcx
  80025c:	48 89 08             	mov    %rcx,(%rax)
  80025f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800263:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800267:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80026b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80026f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800276:	00 00 00 
    b.cnt = 0;
  800279:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800280:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800283:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80028a:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800291:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800298:	48 89 c6             	mov    %rax,%rsi
  80029b:	48 bf b9 01 80 00 00 	movabs $0x8001b9,%rdi
  8002a2:	00 00 00 
  8002a5:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  8002ac:	00 00 00 
  8002af:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002b1:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002b7:	48 98                	cltq   
  8002b9:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002c0:	48 83 c2 08          	add    $0x8,%rdx
  8002c4:	48 89 c6             	mov    %rax,%rsi
  8002c7:	48 89 d7             	mov    %rdx,%rdi
  8002ca:	48 b8 7a 16 80 00 00 	movabs $0x80167a,%rax
  8002d1:	00 00 00 
  8002d4:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002d6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002dc:	c9                   	leaveq 
  8002dd:	c3                   	retq   

00000000008002de <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002de:	55                   	push   %rbp
  8002df:	48 89 e5             	mov    %rsp,%rbp
  8002e2:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8002e9:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8002f0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8002f7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8002fe:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800305:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80030c:	84 c0                	test   %al,%al
  80030e:	74 20                	je     800330 <cprintf+0x52>
  800310:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800314:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800318:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80031c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800320:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800324:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800328:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80032c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800330:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800337:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80033e:	00 00 00 
  800341:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800348:	00 00 00 
  80034b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80034f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800356:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80035d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800364:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80036b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800372:	48 8b 0a             	mov    (%rdx),%rcx
  800375:	48 89 08             	mov    %rcx,(%rax)
  800378:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80037c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800380:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800384:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800388:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80038f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800396:	48 89 d6             	mov    %rdx,%rsi
  800399:	48 89 c7             	mov    %rax,%rdi
  80039c:	48 b8 32 02 80 00 00 	movabs $0x800232,%rax
  8003a3:	00 00 00 
  8003a6:	ff d0                	callq  *%rax
  8003a8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003ae:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003b4:	c9                   	leaveq 
  8003b5:	c3                   	retq   

00000000008003b6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b6:	55                   	push   %rbp
  8003b7:	48 89 e5             	mov    %rsp,%rbp
  8003ba:	53                   	push   %rbx
  8003bb:	48 83 ec 38          	sub    $0x38,%rsp
  8003bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003cb:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003ce:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003d2:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003d9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003dd:	77 3b                	ja     80041a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003df:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003e2:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003e6:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8003e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8003ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f2:	48 f7 f3             	div    %rbx
  8003f5:	48 89 c2             	mov    %rax,%rdx
  8003f8:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8003fb:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8003fe:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800406:	41 89 f9             	mov    %edi,%r9d
  800409:	48 89 c7             	mov    %rax,%rdi
  80040c:	48 b8 b6 03 80 00 00 	movabs $0x8003b6,%rax
  800413:	00 00 00 
  800416:	ff d0                	callq  *%rax
  800418:	eb 1e                	jmp    800438 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041a:	eb 12                	jmp    80042e <printnum+0x78>
			putch(padc, putdat);
  80041c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800420:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800423:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800427:	48 89 ce             	mov    %rcx,%rsi
  80042a:	89 d7                	mov    %edx,%edi
  80042c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800432:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800436:	7f e4                	jg     80041c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800438:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80043b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80043f:	ba 00 00 00 00       	mov    $0x0,%edx
  800444:	48 f7 f1             	div    %rcx
  800447:	48 89 d0             	mov    %rdx,%rax
  80044a:	48 ba f0 37 80 00 00 	movabs $0x8037f0,%rdx
  800451:	00 00 00 
  800454:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800458:	0f be d0             	movsbl %al,%edx
  80045b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80045f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800463:	48 89 ce             	mov    %rcx,%rsi
  800466:	89 d7                	mov    %edx,%edi
  800468:	ff d0                	callq  *%rax
}
  80046a:	48 83 c4 38          	add    $0x38,%rsp
  80046e:	5b                   	pop    %rbx
  80046f:	5d                   	pop    %rbp
  800470:	c3                   	retq   

0000000000800471 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800471:	55                   	push   %rbp
  800472:	48 89 e5             	mov    %rsp,%rbp
  800475:	48 83 ec 1c          	sub    $0x1c,%rsp
  800479:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80047d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800480:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800484:	7e 52                	jle    8004d8 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80048a:	8b 00                	mov    (%rax),%eax
  80048c:	83 f8 30             	cmp    $0x30,%eax
  80048f:	73 24                	jae    8004b5 <getuint+0x44>
  800491:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800495:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800499:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049d:	8b 00                	mov    (%rax),%eax
  80049f:	89 c0                	mov    %eax,%eax
  8004a1:	48 01 d0             	add    %rdx,%rax
  8004a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004a8:	8b 12                	mov    (%rdx),%edx
  8004aa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004b1:	89 0a                	mov    %ecx,(%rdx)
  8004b3:	eb 17                	jmp    8004cc <getuint+0x5b>
  8004b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004bd:	48 89 d0             	mov    %rdx,%rax
  8004c0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004cc:	48 8b 00             	mov    (%rax),%rax
  8004cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004d3:	e9 a3 00 00 00       	jmpq   80057b <getuint+0x10a>
	else if (lflag)
  8004d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004dc:	74 4f                	je     80052d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e2:	8b 00                	mov    (%rax),%eax
  8004e4:	83 f8 30             	cmp    $0x30,%eax
  8004e7:	73 24                	jae    80050d <getuint+0x9c>
  8004e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ed:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f5:	8b 00                	mov    (%rax),%eax
  8004f7:	89 c0                	mov    %eax,%eax
  8004f9:	48 01 d0             	add    %rdx,%rax
  8004fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800500:	8b 12                	mov    (%rdx),%edx
  800502:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800505:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800509:	89 0a                	mov    %ecx,(%rdx)
  80050b:	eb 17                	jmp    800524 <getuint+0xb3>
  80050d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800511:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800515:	48 89 d0             	mov    %rdx,%rax
  800518:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80051c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800520:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800524:	48 8b 00             	mov    (%rax),%rax
  800527:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80052b:	eb 4e                	jmp    80057b <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80052d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800531:	8b 00                	mov    (%rax),%eax
  800533:	83 f8 30             	cmp    $0x30,%eax
  800536:	73 24                	jae    80055c <getuint+0xeb>
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
  80055a:	eb 17                	jmp    800573 <getuint+0x102>
  80055c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800560:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800564:	48 89 d0             	mov    %rdx,%rax
  800567:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80056b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80056f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800573:	8b 00                	mov    (%rax),%eax
  800575:	89 c0                	mov    %eax,%eax
  800577:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80057b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80057f:	c9                   	leaveq 
  800580:	c3                   	retq   

0000000000800581 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800581:	55                   	push   %rbp
  800582:	48 89 e5             	mov    %rsp,%rbp
  800585:	48 83 ec 1c          	sub    $0x1c,%rsp
  800589:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80058d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800590:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800594:	7e 52                	jle    8005e8 <getint+0x67>
		x=va_arg(*ap, long long);
  800596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059a:	8b 00                	mov    (%rax),%eax
  80059c:	83 f8 30             	cmp    $0x30,%eax
  80059f:	73 24                	jae    8005c5 <getint+0x44>
  8005a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ad:	8b 00                	mov    (%rax),%eax
  8005af:	89 c0                	mov    %eax,%eax
  8005b1:	48 01 d0             	add    %rdx,%rax
  8005b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b8:	8b 12                	mov    (%rdx),%edx
  8005ba:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005c1:	89 0a                	mov    %ecx,(%rdx)
  8005c3:	eb 17                	jmp    8005dc <getint+0x5b>
  8005c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005cd:	48 89 d0             	mov    %rdx,%rax
  8005d0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005d4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005dc:	48 8b 00             	mov    (%rax),%rax
  8005df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005e3:	e9 a3 00 00 00       	jmpq   80068b <getint+0x10a>
	else if (lflag)
  8005e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005ec:	74 4f                	je     80063d <getint+0xbc>
		x=va_arg(*ap, long);
  8005ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f2:	8b 00                	mov    (%rax),%eax
  8005f4:	83 f8 30             	cmp    $0x30,%eax
  8005f7:	73 24                	jae    80061d <getint+0x9c>
  8005f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005fd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800601:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800605:	8b 00                	mov    (%rax),%eax
  800607:	89 c0                	mov    %eax,%eax
  800609:	48 01 d0             	add    %rdx,%rax
  80060c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800610:	8b 12                	mov    (%rdx),%edx
  800612:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800615:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800619:	89 0a                	mov    %ecx,(%rdx)
  80061b:	eb 17                	jmp    800634 <getint+0xb3>
  80061d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800621:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800625:	48 89 d0             	mov    %rdx,%rax
  800628:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80062c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800630:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800634:	48 8b 00             	mov    (%rax),%rax
  800637:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80063b:	eb 4e                	jmp    80068b <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80063d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800641:	8b 00                	mov    (%rax),%eax
  800643:	83 f8 30             	cmp    $0x30,%eax
  800646:	73 24                	jae    80066c <getint+0xeb>
  800648:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800654:	8b 00                	mov    (%rax),%eax
  800656:	89 c0                	mov    %eax,%eax
  800658:	48 01 d0             	add    %rdx,%rax
  80065b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065f:	8b 12                	mov    (%rdx),%edx
  800661:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800664:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800668:	89 0a                	mov    %ecx,(%rdx)
  80066a:	eb 17                	jmp    800683 <getint+0x102>
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800674:	48 89 d0             	mov    %rdx,%rax
  800677:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80067b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800683:	8b 00                	mov    (%rax),%eax
  800685:	48 98                	cltq   
  800687:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80068b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80068f:	c9                   	leaveq 
  800690:	c3                   	retq   

0000000000800691 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800691:	55                   	push   %rbp
  800692:	48 89 e5             	mov    %rsp,%rbp
  800695:	41 54                	push   %r12
  800697:	53                   	push   %rbx
  800698:	48 83 ec 60          	sub    $0x60,%rsp
  80069c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006a0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006a4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006a8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006ac:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006b0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006b4:	48 8b 0a             	mov    (%rdx),%rcx
  8006b7:	48 89 08             	mov    %rcx,(%rax)
  8006ba:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006be:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006c2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006c6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ca:	eb 17                	jmp    8006e3 <vprintfmt+0x52>
			if (ch == '\0')
  8006cc:	85 db                	test   %ebx,%ebx
  8006ce:	0f 84 cc 04 00 00    	je     800ba0 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8006d4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006dc:	48 89 d6             	mov    %rdx,%rsi
  8006df:	89 df                	mov    %ebx,%edi
  8006e1:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006e7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8006eb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006ef:	0f b6 00             	movzbl (%rax),%eax
  8006f2:	0f b6 d8             	movzbl %al,%ebx
  8006f5:	83 fb 25             	cmp    $0x25,%ebx
  8006f8:	75 d2                	jne    8006cc <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8006fa:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8006fe:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800705:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80070c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800713:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80071e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800722:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800726:	0f b6 00             	movzbl (%rax),%eax
  800729:	0f b6 d8             	movzbl %al,%ebx
  80072c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80072f:	83 f8 55             	cmp    $0x55,%eax
  800732:	0f 87 34 04 00 00    	ja     800b6c <vprintfmt+0x4db>
  800738:	89 c0                	mov    %eax,%eax
  80073a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800741:	00 
  800742:	48 b8 18 38 80 00 00 	movabs $0x803818,%rax
  800749:	00 00 00 
  80074c:	48 01 d0             	add    %rdx,%rax
  80074f:	48 8b 00             	mov    (%rax),%rax
  800752:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800754:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800758:	eb c0                	jmp    80071a <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80075a:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80075e:	eb ba                	jmp    80071a <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800760:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800767:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80076a:	89 d0                	mov    %edx,%eax
  80076c:	c1 e0 02             	shl    $0x2,%eax
  80076f:	01 d0                	add    %edx,%eax
  800771:	01 c0                	add    %eax,%eax
  800773:	01 d8                	add    %ebx,%eax
  800775:	83 e8 30             	sub    $0x30,%eax
  800778:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80077b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80077f:	0f b6 00             	movzbl (%rax),%eax
  800782:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800785:	83 fb 2f             	cmp    $0x2f,%ebx
  800788:	7e 0c                	jle    800796 <vprintfmt+0x105>
  80078a:	83 fb 39             	cmp    $0x39,%ebx
  80078d:	7f 07                	jg     800796 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078f:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800794:	eb d1                	jmp    800767 <vprintfmt+0xd6>
			goto process_precision;
  800796:	eb 58                	jmp    8007f0 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800798:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80079b:	83 f8 30             	cmp    $0x30,%eax
  80079e:	73 17                	jae    8007b7 <vprintfmt+0x126>
  8007a0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007a7:	89 c0                	mov    %eax,%eax
  8007a9:	48 01 d0             	add    %rdx,%rax
  8007ac:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007af:	83 c2 08             	add    $0x8,%edx
  8007b2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007b5:	eb 0f                	jmp    8007c6 <vprintfmt+0x135>
  8007b7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007bb:	48 89 d0             	mov    %rdx,%rax
  8007be:	48 83 c2 08          	add    $0x8,%rdx
  8007c2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007c6:	8b 00                	mov    (%rax),%eax
  8007c8:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007cb:	eb 23                	jmp    8007f0 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007cd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007d1:	79 0c                	jns    8007df <vprintfmt+0x14e>
				width = 0;
  8007d3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007da:	e9 3b ff ff ff       	jmpq   80071a <vprintfmt+0x89>
  8007df:	e9 36 ff ff ff       	jmpq   80071a <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007e4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8007eb:	e9 2a ff ff ff       	jmpq   80071a <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8007f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007f4:	79 12                	jns    800808 <vprintfmt+0x177>
				width = precision, precision = -1;
  8007f6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8007f9:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8007fc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800803:	e9 12 ff ff ff       	jmpq   80071a <vprintfmt+0x89>
  800808:	e9 0d ff ff ff       	jmpq   80071a <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800811:	e9 04 ff ff ff       	jmpq   80071a <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800816:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800819:	83 f8 30             	cmp    $0x30,%eax
  80081c:	73 17                	jae    800835 <vprintfmt+0x1a4>
  80081e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800822:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800825:	89 c0                	mov    %eax,%eax
  800827:	48 01 d0             	add    %rdx,%rax
  80082a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80082d:	83 c2 08             	add    $0x8,%edx
  800830:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800833:	eb 0f                	jmp    800844 <vprintfmt+0x1b3>
  800835:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800839:	48 89 d0             	mov    %rdx,%rax
  80083c:	48 83 c2 08          	add    $0x8,%rdx
  800840:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800844:	8b 10                	mov    (%rax),%edx
  800846:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80084a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80084e:	48 89 ce             	mov    %rcx,%rsi
  800851:	89 d7                	mov    %edx,%edi
  800853:	ff d0                	callq  *%rax
			break;
  800855:	e9 40 03 00 00       	jmpq   800b9a <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80085a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085d:	83 f8 30             	cmp    $0x30,%eax
  800860:	73 17                	jae    800879 <vprintfmt+0x1e8>
  800862:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800866:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800869:	89 c0                	mov    %eax,%eax
  80086b:	48 01 d0             	add    %rdx,%rax
  80086e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800871:	83 c2 08             	add    $0x8,%edx
  800874:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800877:	eb 0f                	jmp    800888 <vprintfmt+0x1f7>
  800879:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80087d:	48 89 d0             	mov    %rdx,%rax
  800880:	48 83 c2 08          	add    $0x8,%rdx
  800884:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800888:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80088a:	85 db                	test   %ebx,%ebx
  80088c:	79 02                	jns    800890 <vprintfmt+0x1ff>
				err = -err;
  80088e:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800890:	83 fb 15             	cmp    $0x15,%ebx
  800893:	7f 16                	jg     8008ab <vprintfmt+0x21a>
  800895:	48 b8 40 37 80 00 00 	movabs $0x803740,%rax
  80089c:	00 00 00 
  80089f:	48 63 d3             	movslq %ebx,%rdx
  8008a2:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008a6:	4d 85 e4             	test   %r12,%r12
  8008a9:	75 2e                	jne    8008d9 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008ab:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008af:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008b3:	89 d9                	mov    %ebx,%ecx
  8008b5:	48 ba 01 38 80 00 00 	movabs $0x803801,%rdx
  8008bc:	00 00 00 
  8008bf:	48 89 c7             	mov    %rax,%rdi
  8008c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c7:	49 b8 a9 0b 80 00 00 	movabs $0x800ba9,%r8
  8008ce:	00 00 00 
  8008d1:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008d4:	e9 c1 02 00 00       	jmpq   800b9a <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008dd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e1:	4c 89 e1             	mov    %r12,%rcx
  8008e4:	48 ba 0a 38 80 00 00 	movabs $0x80380a,%rdx
  8008eb:	00 00 00 
  8008ee:	48 89 c7             	mov    %rax,%rdi
  8008f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f6:	49 b8 a9 0b 80 00 00 	movabs $0x800ba9,%r8
  8008fd:	00 00 00 
  800900:	41 ff d0             	callq  *%r8
			break;
  800903:	e9 92 02 00 00       	jmpq   800b9a <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800908:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090b:	83 f8 30             	cmp    $0x30,%eax
  80090e:	73 17                	jae    800927 <vprintfmt+0x296>
  800910:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800914:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800917:	89 c0                	mov    %eax,%eax
  800919:	48 01 d0             	add    %rdx,%rax
  80091c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80091f:	83 c2 08             	add    $0x8,%edx
  800922:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800925:	eb 0f                	jmp    800936 <vprintfmt+0x2a5>
  800927:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80092b:	48 89 d0             	mov    %rdx,%rax
  80092e:	48 83 c2 08          	add    $0x8,%rdx
  800932:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800936:	4c 8b 20             	mov    (%rax),%r12
  800939:	4d 85 e4             	test   %r12,%r12
  80093c:	75 0a                	jne    800948 <vprintfmt+0x2b7>
				p = "(null)";
  80093e:	49 bc 0d 38 80 00 00 	movabs $0x80380d,%r12
  800945:	00 00 00 
			if (width > 0 && padc != '-')
  800948:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80094c:	7e 3f                	jle    80098d <vprintfmt+0x2fc>
  80094e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800952:	74 39                	je     80098d <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800954:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800957:	48 98                	cltq   
  800959:	48 89 c6             	mov    %rax,%rsi
  80095c:	4c 89 e7             	mov    %r12,%rdi
  80095f:	48 b8 55 0e 80 00 00 	movabs $0x800e55,%rax
  800966:	00 00 00 
  800969:	ff d0                	callq  *%rax
  80096b:	29 45 dc             	sub    %eax,-0x24(%rbp)
  80096e:	eb 17                	jmp    800987 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800970:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800974:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800978:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80097c:	48 89 ce             	mov    %rcx,%rsi
  80097f:	89 d7                	mov    %edx,%edi
  800981:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800983:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800987:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098b:	7f e3                	jg     800970 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098d:	eb 37                	jmp    8009c6 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  80098f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800993:	74 1e                	je     8009b3 <vprintfmt+0x322>
  800995:	83 fb 1f             	cmp    $0x1f,%ebx
  800998:	7e 05                	jle    80099f <vprintfmt+0x30e>
  80099a:	83 fb 7e             	cmp    $0x7e,%ebx
  80099d:	7e 14                	jle    8009b3 <vprintfmt+0x322>
					putch('?', putdat);
  80099f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009a3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a7:	48 89 d6             	mov    %rdx,%rsi
  8009aa:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009af:	ff d0                	callq  *%rax
  8009b1:	eb 0f                	jmp    8009c2 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009b3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009b7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009bb:	48 89 d6             	mov    %rdx,%rsi
  8009be:	89 df                	mov    %ebx,%edi
  8009c0:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c6:	4c 89 e0             	mov    %r12,%rax
  8009c9:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009cd:	0f b6 00             	movzbl (%rax),%eax
  8009d0:	0f be d8             	movsbl %al,%ebx
  8009d3:	85 db                	test   %ebx,%ebx
  8009d5:	74 10                	je     8009e7 <vprintfmt+0x356>
  8009d7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009db:	78 b2                	js     80098f <vprintfmt+0x2fe>
  8009dd:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009e5:	79 a8                	jns    80098f <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e7:	eb 16                	jmp    8009ff <vprintfmt+0x36e>
				putch(' ', putdat);
  8009e9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f1:	48 89 d6             	mov    %rdx,%rsi
  8009f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8009f9:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a03:	7f e4                	jg     8009e9 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a05:	e9 90 01 00 00       	jmpq   800b9a <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a0a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a0e:	be 03 00 00 00       	mov    $0x3,%esi
  800a13:	48 89 c7             	mov    %rax,%rdi
  800a16:	48 b8 81 05 80 00 00 	movabs $0x800581,%rax
  800a1d:	00 00 00 
  800a20:	ff d0                	callq  *%rax
  800a22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2a:	48 85 c0             	test   %rax,%rax
  800a2d:	79 1d                	jns    800a4c <vprintfmt+0x3bb>
				putch('-', putdat);
  800a2f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a37:	48 89 d6             	mov    %rdx,%rsi
  800a3a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a3f:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a45:	48 f7 d8             	neg    %rax
  800a48:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a4c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a53:	e9 d5 00 00 00       	jmpq   800b2d <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a58:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a5c:	be 03 00 00 00       	mov    $0x3,%esi
  800a61:	48 89 c7             	mov    %rax,%rdi
  800a64:	48 b8 71 04 80 00 00 	movabs $0x800471,%rax
  800a6b:	00 00 00 
  800a6e:	ff d0                	callq  *%rax
  800a70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a74:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a7b:	e9 ad 00 00 00       	jmpq   800b2d <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800a80:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a84:	be 03 00 00 00       	mov    $0x3,%esi
  800a89:	48 89 c7             	mov    %rax,%rdi
  800a8c:	48 b8 71 04 80 00 00 	movabs $0x800471,%rax
  800a93:	00 00 00 
  800a96:	ff d0                	callq  *%rax
  800a98:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800a9c:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800aa3:	e9 85 00 00 00       	jmpq   800b2d <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800aa8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab0:	48 89 d6             	mov    %rdx,%rsi
  800ab3:	bf 30 00 00 00       	mov    $0x30,%edi
  800ab8:	ff d0                	callq  *%rax
			putch('x', putdat);
  800aba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800abe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac2:	48 89 d6             	mov    %rdx,%rsi
  800ac5:	bf 78 00 00 00       	mov    $0x78,%edi
  800aca:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800acc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acf:	83 f8 30             	cmp    $0x30,%eax
  800ad2:	73 17                	jae    800aeb <vprintfmt+0x45a>
  800ad4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adb:	89 c0                	mov    %eax,%eax
  800add:	48 01 d0             	add    %rdx,%rax
  800ae0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae3:	83 c2 08             	add    $0x8,%edx
  800ae6:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae9:	eb 0f                	jmp    800afa <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800aeb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aef:	48 89 d0             	mov    %rdx,%rax
  800af2:	48 83 c2 08          	add    $0x8,%rdx
  800af6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800afa:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800afd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b01:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b08:	eb 23                	jmp    800b2d <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b0a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b0e:	be 03 00 00 00       	mov    $0x3,%esi
  800b13:	48 89 c7             	mov    %rax,%rdi
  800b16:	48 b8 71 04 80 00 00 	movabs $0x800471,%rax
  800b1d:	00 00 00 
  800b20:	ff d0                	callq  *%rax
  800b22:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b26:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b2d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b32:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b35:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b38:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b3c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b40:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b44:	45 89 c1             	mov    %r8d,%r9d
  800b47:	41 89 f8             	mov    %edi,%r8d
  800b4a:	48 89 c7             	mov    %rax,%rdi
  800b4d:	48 b8 b6 03 80 00 00 	movabs $0x8003b6,%rax
  800b54:	00 00 00 
  800b57:	ff d0                	callq  *%rax
			break;
  800b59:	eb 3f                	jmp    800b9a <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b5b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b63:	48 89 d6             	mov    %rdx,%rsi
  800b66:	89 df                	mov    %ebx,%edi
  800b68:	ff d0                	callq  *%rax
			break;
  800b6a:	eb 2e                	jmp    800b9a <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b6c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b74:	48 89 d6             	mov    %rdx,%rsi
  800b77:	bf 25 00 00 00       	mov    $0x25,%edi
  800b7c:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b7e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b83:	eb 05                	jmp    800b8a <vprintfmt+0x4f9>
  800b85:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b8a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b8e:	48 83 e8 01          	sub    $0x1,%rax
  800b92:	0f b6 00             	movzbl (%rax),%eax
  800b95:	3c 25                	cmp    $0x25,%al
  800b97:	75 ec                	jne    800b85 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800b99:	90                   	nop
		}
	}
  800b9a:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b9b:	e9 43 fb ff ff       	jmpq   8006e3 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800ba0:	48 83 c4 60          	add    $0x60,%rsp
  800ba4:	5b                   	pop    %rbx
  800ba5:	41 5c                	pop    %r12
  800ba7:	5d                   	pop    %rbp
  800ba8:	c3                   	retq   

0000000000800ba9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ba9:	55                   	push   %rbp
  800baa:	48 89 e5             	mov    %rsp,%rbp
  800bad:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bb4:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bbb:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bc2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800bc9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800bd0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bd7:	84 c0                	test   %al,%al
  800bd9:	74 20                	je     800bfb <printfmt+0x52>
  800bdb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bdf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800be3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800be7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800beb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800bef:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800bf3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800bf7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800bfb:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c02:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c09:	00 00 00 
  800c0c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c13:	00 00 00 
  800c16:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c1a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c21:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c28:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c2f:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c36:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c3d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c44:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c4b:	48 89 c7             	mov    %rax,%rdi
  800c4e:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  800c55:	00 00 00 
  800c58:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c5a:	c9                   	leaveq 
  800c5b:	c3                   	retq   

0000000000800c5c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c5c:	55                   	push   %rbp
  800c5d:	48 89 e5             	mov    %rsp,%rbp
  800c60:	48 83 ec 10          	sub    $0x10,%rsp
  800c64:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c67:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c6f:	8b 40 10             	mov    0x10(%rax),%eax
  800c72:	8d 50 01             	lea    0x1(%rax),%edx
  800c75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c79:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c80:	48 8b 10             	mov    (%rax),%rdx
  800c83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c87:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c8b:	48 39 c2             	cmp    %rax,%rdx
  800c8e:	73 17                	jae    800ca7 <sprintputch+0x4b>
		*b->buf++ = ch;
  800c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c94:	48 8b 00             	mov    (%rax),%rax
  800c97:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800c9b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c9f:	48 89 0a             	mov    %rcx,(%rdx)
  800ca2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ca5:	88 10                	mov    %dl,(%rax)
}
  800ca7:	c9                   	leaveq 
  800ca8:	c3                   	retq   

0000000000800ca9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca9:	55                   	push   %rbp
  800caa:	48 89 e5             	mov    %rsp,%rbp
  800cad:	48 83 ec 50          	sub    $0x50,%rsp
  800cb1:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cb5:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cb8:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cbc:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cc0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cc4:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800cc8:	48 8b 0a             	mov    (%rdx),%rcx
  800ccb:	48 89 08             	mov    %rcx,(%rax)
  800cce:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cd2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cd6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cda:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cde:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ce2:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ce6:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ce9:	48 98                	cltq   
  800ceb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800cef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cf3:	48 01 d0             	add    %rdx,%rax
  800cf6:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800cfa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d01:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d06:	74 06                	je     800d0e <vsnprintf+0x65>
  800d08:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d0c:	7f 07                	jg     800d15 <vsnprintf+0x6c>
		return -E_INVAL;
  800d0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d13:	eb 2f                	jmp    800d44 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d15:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d19:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d1d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d21:	48 89 c6             	mov    %rax,%rsi
  800d24:	48 bf 5c 0c 80 00 00 	movabs $0x800c5c,%rdi
  800d2b:	00 00 00 
  800d2e:	48 b8 91 06 80 00 00 	movabs $0x800691,%rax
  800d35:	00 00 00 
  800d38:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d3e:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d41:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d44:	c9                   	leaveq 
  800d45:	c3                   	retq   

0000000000800d46 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d46:	55                   	push   %rbp
  800d47:	48 89 e5             	mov    %rsp,%rbp
  800d4a:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d51:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d58:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d5e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d65:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d6c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d73:	84 c0                	test   %al,%al
  800d75:	74 20                	je     800d97 <snprintf+0x51>
  800d77:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d7b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d7f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d83:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d87:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d8b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d8f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d93:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d97:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800d9e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800da5:	00 00 00 
  800da8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800daf:	00 00 00 
  800db2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800db6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dbd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dc4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800dcb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dd2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dd9:	48 8b 0a             	mov    (%rdx),%rcx
  800ddc:	48 89 08             	mov    %rcx,(%rax)
  800ddf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800de3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800de7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800deb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800def:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800df6:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800dfd:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e03:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e0a:	48 89 c7             	mov    %rax,%rdi
  800e0d:	48 b8 a9 0c 80 00 00 	movabs $0x800ca9,%rax
  800e14:	00 00 00 
  800e17:	ff d0                	callq  *%rax
  800e19:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e1f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e25:	c9                   	leaveq 
  800e26:	c3                   	retq   

0000000000800e27 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e27:	55                   	push   %rbp
  800e28:	48 89 e5             	mov    %rsp,%rbp
  800e2b:	48 83 ec 18          	sub    $0x18,%rsp
  800e2f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e3a:	eb 09                	jmp    800e45 <strlen+0x1e>
		n++;
  800e3c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e40:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e49:	0f b6 00             	movzbl (%rax),%eax
  800e4c:	84 c0                	test   %al,%al
  800e4e:	75 ec                	jne    800e3c <strlen+0x15>
		n++;
	return n;
  800e50:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e53:	c9                   	leaveq 
  800e54:	c3                   	retq   

0000000000800e55 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e55:	55                   	push   %rbp
  800e56:	48 89 e5             	mov    %rsp,%rbp
  800e59:	48 83 ec 20          	sub    $0x20,%rsp
  800e5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e61:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e6c:	eb 0e                	jmp    800e7c <strnlen+0x27>
		n++;
  800e6e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e72:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e77:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e7c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e81:	74 0b                	je     800e8e <strnlen+0x39>
  800e83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e87:	0f b6 00             	movzbl (%rax),%eax
  800e8a:	84 c0                	test   %al,%al
  800e8c:	75 e0                	jne    800e6e <strnlen+0x19>
		n++;
	return n;
  800e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e91:	c9                   	leaveq 
  800e92:	c3                   	retq   

0000000000800e93 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e93:	55                   	push   %rbp
  800e94:	48 89 e5             	mov    %rsp,%rbp
  800e97:	48 83 ec 20          	sub    $0x20,%rsp
  800e9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e9f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800eab:	90                   	nop
  800eac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800eb4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800eb8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ebc:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ec0:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800ec4:	0f b6 12             	movzbl (%rdx),%edx
  800ec7:	88 10                	mov    %dl,(%rax)
  800ec9:	0f b6 00             	movzbl (%rax),%eax
  800ecc:	84 c0                	test   %al,%al
  800ece:	75 dc                	jne    800eac <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ed0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800ed4:	c9                   	leaveq 
  800ed5:	c3                   	retq   

0000000000800ed6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ed6:	55                   	push   %rbp
  800ed7:	48 89 e5             	mov    %rsp,%rbp
  800eda:	48 83 ec 20          	sub    $0x20,%rsp
  800ede:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ee2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eea:	48 89 c7             	mov    %rax,%rdi
  800eed:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  800ef4:	00 00 00 
  800ef7:	ff d0                	callq  *%rax
  800ef9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800efc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eff:	48 63 d0             	movslq %eax,%rdx
  800f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f06:	48 01 c2             	add    %rax,%rdx
  800f09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f0d:	48 89 c6             	mov    %rax,%rsi
  800f10:	48 89 d7             	mov    %rdx,%rdi
  800f13:	48 b8 93 0e 80 00 00 	movabs $0x800e93,%rax
  800f1a:	00 00 00 
  800f1d:	ff d0                	callq  *%rax
	return dst;
  800f1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f23:	c9                   	leaveq 
  800f24:	c3                   	retq   

0000000000800f25 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f25:	55                   	push   %rbp
  800f26:	48 89 e5             	mov    %rsp,%rbp
  800f29:	48 83 ec 28          	sub    $0x28,%rsp
  800f2d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f35:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f41:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f48:	00 
  800f49:	eb 2a                	jmp    800f75 <strncpy+0x50>
		*dst++ = *src;
  800f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f53:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f57:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f5b:	0f b6 12             	movzbl (%rdx),%edx
  800f5e:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f64:	0f b6 00             	movzbl (%rax),%eax
  800f67:	84 c0                	test   %al,%al
  800f69:	74 05                	je     800f70 <strncpy+0x4b>
			src++;
  800f6b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f70:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f79:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f7d:	72 cc                	jb     800f4b <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f83:	c9                   	leaveq 
  800f84:	c3                   	retq   

0000000000800f85 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f85:	55                   	push   %rbp
  800f86:	48 89 e5             	mov    %rsp,%rbp
  800f89:	48 83 ec 28          	sub    $0x28,%rsp
  800f8d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f91:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f95:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800f99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fa1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fa6:	74 3d                	je     800fe5 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fa8:	eb 1d                	jmp    800fc7 <strlcpy+0x42>
			*dst++ = *src++;
  800faa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fb2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fb6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fba:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fbe:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fc2:	0f b6 12             	movzbl (%rdx),%edx
  800fc5:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fc7:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fcc:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fd1:	74 0b                	je     800fde <strlcpy+0x59>
  800fd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fd7:	0f b6 00             	movzbl (%rax),%eax
  800fda:	84 c0                	test   %al,%al
  800fdc:	75 cc                	jne    800faa <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800fde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe2:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800fe5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fe9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fed:	48 29 c2             	sub    %rax,%rdx
  800ff0:	48 89 d0             	mov    %rdx,%rax
}
  800ff3:	c9                   	leaveq 
  800ff4:	c3                   	retq   

0000000000800ff5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff5:	55                   	push   %rbp
  800ff6:	48 89 e5             	mov    %rsp,%rbp
  800ff9:	48 83 ec 10          	sub    $0x10,%rsp
  800ffd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801001:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801005:	eb 0a                	jmp    801011 <strcmp+0x1c>
		p++, q++;
  801007:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80100c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801011:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801015:	0f b6 00             	movzbl (%rax),%eax
  801018:	84 c0                	test   %al,%al
  80101a:	74 12                	je     80102e <strcmp+0x39>
  80101c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801020:	0f b6 10             	movzbl (%rax),%edx
  801023:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801027:	0f b6 00             	movzbl (%rax),%eax
  80102a:	38 c2                	cmp    %al,%dl
  80102c:	74 d9                	je     801007 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80102e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801032:	0f b6 00             	movzbl (%rax),%eax
  801035:	0f b6 d0             	movzbl %al,%edx
  801038:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103c:	0f b6 00             	movzbl (%rax),%eax
  80103f:	0f b6 c0             	movzbl %al,%eax
  801042:	29 c2                	sub    %eax,%edx
  801044:	89 d0                	mov    %edx,%eax
}
  801046:	c9                   	leaveq 
  801047:	c3                   	retq   

0000000000801048 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801048:	55                   	push   %rbp
  801049:	48 89 e5             	mov    %rsp,%rbp
  80104c:	48 83 ec 18          	sub    $0x18,%rsp
  801050:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801054:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801058:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80105c:	eb 0f                	jmp    80106d <strncmp+0x25>
		n--, p++, q++;
  80105e:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801063:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801068:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80106d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801072:	74 1d                	je     801091 <strncmp+0x49>
  801074:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801078:	0f b6 00             	movzbl (%rax),%eax
  80107b:	84 c0                	test   %al,%al
  80107d:	74 12                	je     801091 <strncmp+0x49>
  80107f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801083:	0f b6 10             	movzbl (%rax),%edx
  801086:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108a:	0f b6 00             	movzbl (%rax),%eax
  80108d:	38 c2                	cmp    %al,%dl
  80108f:	74 cd                	je     80105e <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801091:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801096:	75 07                	jne    80109f <strncmp+0x57>
		return 0;
  801098:	b8 00 00 00 00       	mov    $0x0,%eax
  80109d:	eb 18                	jmp    8010b7 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80109f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a3:	0f b6 00             	movzbl (%rax),%eax
  8010a6:	0f b6 d0             	movzbl %al,%edx
  8010a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ad:	0f b6 00             	movzbl (%rax),%eax
  8010b0:	0f b6 c0             	movzbl %al,%eax
  8010b3:	29 c2                	sub    %eax,%edx
  8010b5:	89 d0                	mov    %edx,%eax
}
  8010b7:	c9                   	leaveq 
  8010b8:	c3                   	retq   

00000000008010b9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010b9:	55                   	push   %rbp
  8010ba:	48 89 e5             	mov    %rsp,%rbp
  8010bd:	48 83 ec 0c          	sub    $0xc,%rsp
  8010c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010c5:	89 f0                	mov    %esi,%eax
  8010c7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010ca:	eb 17                	jmp    8010e3 <strchr+0x2a>
		if (*s == c)
  8010cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d0:	0f b6 00             	movzbl (%rax),%eax
  8010d3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010d6:	75 06                	jne    8010de <strchr+0x25>
			return (char *) s;
  8010d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dc:	eb 15                	jmp    8010f3 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010de:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e7:	0f b6 00             	movzbl (%rax),%eax
  8010ea:	84 c0                	test   %al,%al
  8010ec:	75 de                	jne    8010cc <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8010ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f3:	c9                   	leaveq 
  8010f4:	c3                   	retq   

00000000008010f5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010f5:	55                   	push   %rbp
  8010f6:	48 89 e5             	mov    %rsp,%rbp
  8010f9:	48 83 ec 0c          	sub    $0xc,%rsp
  8010fd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801101:	89 f0                	mov    %esi,%eax
  801103:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801106:	eb 13                	jmp    80111b <strfind+0x26>
		if (*s == c)
  801108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110c:	0f b6 00             	movzbl (%rax),%eax
  80110f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801112:	75 02                	jne    801116 <strfind+0x21>
			break;
  801114:	eb 10                	jmp    801126 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801116:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80111b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111f:	0f b6 00             	movzbl (%rax),%eax
  801122:	84 c0                	test   %al,%al
  801124:	75 e2                	jne    801108 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801126:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80112a:	c9                   	leaveq 
  80112b:	c3                   	retq   

000000000080112c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80112c:	55                   	push   %rbp
  80112d:	48 89 e5             	mov    %rsp,%rbp
  801130:	48 83 ec 18          	sub    $0x18,%rsp
  801134:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801138:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80113b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80113f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801144:	75 06                	jne    80114c <memset+0x20>
		return v;
  801146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114a:	eb 69                	jmp    8011b5 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80114c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801150:	83 e0 03             	and    $0x3,%eax
  801153:	48 85 c0             	test   %rax,%rax
  801156:	75 48                	jne    8011a0 <memset+0x74>
  801158:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115c:	83 e0 03             	and    $0x3,%eax
  80115f:	48 85 c0             	test   %rax,%rax
  801162:	75 3c                	jne    8011a0 <memset+0x74>
		c &= 0xFF;
  801164:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80116b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80116e:	c1 e0 18             	shl    $0x18,%eax
  801171:	89 c2                	mov    %eax,%edx
  801173:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801176:	c1 e0 10             	shl    $0x10,%eax
  801179:	09 c2                	or     %eax,%edx
  80117b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80117e:	c1 e0 08             	shl    $0x8,%eax
  801181:	09 d0                	or     %edx,%eax
  801183:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801186:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118a:	48 c1 e8 02          	shr    $0x2,%rax
  80118e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801191:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801195:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801198:	48 89 d7             	mov    %rdx,%rdi
  80119b:	fc                   	cld    
  80119c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80119e:	eb 11                	jmp    8011b1 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011a7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011ab:	48 89 d7             	mov    %rdx,%rdi
  8011ae:	fc                   	cld    
  8011af:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011b5:	c9                   	leaveq 
  8011b6:	c3                   	retq   

00000000008011b7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011b7:	55                   	push   %rbp
  8011b8:	48 89 e5             	mov    %rsp,%rbp
  8011bb:	48 83 ec 28          	sub    $0x28,%rsp
  8011bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011c3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011c7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011df:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011e3:	0f 83 88 00 00 00    	jae    801271 <memmove+0xba>
  8011e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011f1:	48 01 d0             	add    %rdx,%rax
  8011f4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011f8:	76 77                	jbe    801271 <memmove+0xba>
		s += n;
  8011fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8011fe:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801202:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801206:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80120a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120e:	83 e0 03             	and    $0x3,%eax
  801211:	48 85 c0             	test   %rax,%rax
  801214:	75 3b                	jne    801251 <memmove+0x9a>
  801216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121a:	83 e0 03             	and    $0x3,%eax
  80121d:	48 85 c0             	test   %rax,%rax
  801220:	75 2f                	jne    801251 <memmove+0x9a>
  801222:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801226:	83 e0 03             	and    $0x3,%eax
  801229:	48 85 c0             	test   %rax,%rax
  80122c:	75 23                	jne    801251 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80122e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801232:	48 83 e8 04          	sub    $0x4,%rax
  801236:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123a:	48 83 ea 04          	sub    $0x4,%rdx
  80123e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801242:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801246:	48 89 c7             	mov    %rax,%rdi
  801249:	48 89 d6             	mov    %rdx,%rsi
  80124c:	fd                   	std    
  80124d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80124f:	eb 1d                	jmp    80126e <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801251:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801255:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801259:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125d:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801261:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801265:	48 89 d7             	mov    %rdx,%rdi
  801268:	48 89 c1             	mov    %rax,%rcx
  80126b:	fd                   	std    
  80126c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80126e:	fc                   	cld    
  80126f:	eb 57                	jmp    8012c8 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801275:	83 e0 03             	and    $0x3,%eax
  801278:	48 85 c0             	test   %rax,%rax
  80127b:	75 36                	jne    8012b3 <memmove+0xfc>
  80127d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801281:	83 e0 03             	and    $0x3,%eax
  801284:	48 85 c0             	test   %rax,%rax
  801287:	75 2a                	jne    8012b3 <memmove+0xfc>
  801289:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80128d:	83 e0 03             	and    $0x3,%eax
  801290:	48 85 c0             	test   %rax,%rax
  801293:	75 1e                	jne    8012b3 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801295:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801299:	48 c1 e8 02          	shr    $0x2,%rax
  80129d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012a8:	48 89 c7             	mov    %rax,%rdi
  8012ab:	48 89 d6             	mov    %rdx,%rsi
  8012ae:	fc                   	cld    
  8012af:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012b1:	eb 15                	jmp    8012c8 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012bb:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012bf:	48 89 c7             	mov    %rax,%rdi
  8012c2:	48 89 d6             	mov    %rdx,%rsi
  8012c5:	fc                   	cld    
  8012c6:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012cc:	c9                   	leaveq 
  8012cd:	c3                   	retq   

00000000008012ce <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012ce:	55                   	push   %rbp
  8012cf:	48 89 e5             	mov    %rsp,%rbp
  8012d2:	48 83 ec 18          	sub    $0x18,%rsp
  8012d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8012ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ee:	48 89 ce             	mov    %rcx,%rsi
  8012f1:	48 89 c7             	mov    %rax,%rdi
  8012f4:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  8012fb:	00 00 00 
  8012fe:	ff d0                	callq  *%rax
}
  801300:	c9                   	leaveq 
  801301:	c3                   	retq   

0000000000801302 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801302:	55                   	push   %rbp
  801303:	48 89 e5             	mov    %rsp,%rbp
  801306:	48 83 ec 28          	sub    $0x28,%rsp
  80130a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80130e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801312:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80131e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801322:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801326:	eb 36                	jmp    80135e <memcmp+0x5c>
		if (*s1 != *s2)
  801328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132c:	0f b6 10             	movzbl (%rax),%edx
  80132f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801333:	0f b6 00             	movzbl (%rax),%eax
  801336:	38 c2                	cmp    %al,%dl
  801338:	74 1a                	je     801354 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80133a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133e:	0f b6 00             	movzbl (%rax),%eax
  801341:	0f b6 d0             	movzbl %al,%edx
  801344:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801348:	0f b6 00             	movzbl (%rax),%eax
  80134b:	0f b6 c0             	movzbl %al,%eax
  80134e:	29 c2                	sub    %eax,%edx
  801350:	89 d0                	mov    %edx,%eax
  801352:	eb 20                	jmp    801374 <memcmp+0x72>
		s1++, s2++;
  801354:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801359:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80135e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801362:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801366:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80136a:	48 85 c0             	test   %rax,%rax
  80136d:	75 b9                	jne    801328 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80136f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801374:	c9                   	leaveq 
  801375:	c3                   	retq   

0000000000801376 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801376:	55                   	push   %rbp
  801377:	48 89 e5             	mov    %rsp,%rbp
  80137a:	48 83 ec 28          	sub    $0x28,%rsp
  80137e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801382:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801385:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801389:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801391:	48 01 d0             	add    %rdx,%rax
  801394:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801398:	eb 15                	jmp    8013af <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80139a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80139e:	0f b6 10             	movzbl (%rax),%edx
  8013a1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013a4:	38 c2                	cmp    %al,%dl
  8013a6:	75 02                	jne    8013aa <memfind+0x34>
			break;
  8013a8:	eb 0f                	jmp    8013b9 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013aa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013b7:	72 e1                	jb     80139a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013bd:	c9                   	leaveq 
  8013be:	c3                   	retq   

00000000008013bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013bf:	55                   	push   %rbp
  8013c0:	48 89 e5             	mov    %rsp,%rbp
  8013c3:	48 83 ec 34          	sub    $0x34,%rsp
  8013c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013cf:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013d9:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013e0:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013e1:	eb 05                	jmp    8013e8 <strtol+0x29>
		s++;
  8013e3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ec:	0f b6 00             	movzbl (%rax),%eax
  8013ef:	3c 20                	cmp    $0x20,%al
  8013f1:	74 f0                	je     8013e3 <strtol+0x24>
  8013f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f7:	0f b6 00             	movzbl (%rax),%eax
  8013fa:	3c 09                	cmp    $0x9,%al
  8013fc:	74 e5                	je     8013e3 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801402:	0f b6 00             	movzbl (%rax),%eax
  801405:	3c 2b                	cmp    $0x2b,%al
  801407:	75 07                	jne    801410 <strtol+0x51>
		s++;
  801409:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80140e:	eb 17                	jmp    801427 <strtol+0x68>
	else if (*s == '-')
  801410:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801414:	0f b6 00             	movzbl (%rax),%eax
  801417:	3c 2d                	cmp    $0x2d,%al
  801419:	75 0c                	jne    801427 <strtol+0x68>
		s++, neg = 1;
  80141b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801420:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801427:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80142b:	74 06                	je     801433 <strtol+0x74>
  80142d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801431:	75 28                	jne    80145b <strtol+0x9c>
  801433:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801437:	0f b6 00             	movzbl (%rax),%eax
  80143a:	3c 30                	cmp    $0x30,%al
  80143c:	75 1d                	jne    80145b <strtol+0x9c>
  80143e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801442:	48 83 c0 01          	add    $0x1,%rax
  801446:	0f b6 00             	movzbl (%rax),%eax
  801449:	3c 78                	cmp    $0x78,%al
  80144b:	75 0e                	jne    80145b <strtol+0x9c>
		s += 2, base = 16;
  80144d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801452:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801459:	eb 2c                	jmp    801487 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80145b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80145f:	75 19                	jne    80147a <strtol+0xbb>
  801461:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801465:	0f b6 00             	movzbl (%rax),%eax
  801468:	3c 30                	cmp    $0x30,%al
  80146a:	75 0e                	jne    80147a <strtol+0xbb>
		s++, base = 8;
  80146c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801471:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801478:	eb 0d                	jmp    801487 <strtol+0xc8>
	else if (base == 0)
  80147a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80147e:	75 07                	jne    801487 <strtol+0xc8>
		base = 10;
  801480:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801487:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148b:	0f b6 00             	movzbl (%rax),%eax
  80148e:	3c 2f                	cmp    $0x2f,%al
  801490:	7e 1d                	jle    8014af <strtol+0xf0>
  801492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801496:	0f b6 00             	movzbl (%rax),%eax
  801499:	3c 39                	cmp    $0x39,%al
  80149b:	7f 12                	jg     8014af <strtol+0xf0>
			dig = *s - '0';
  80149d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a1:	0f b6 00             	movzbl (%rax),%eax
  8014a4:	0f be c0             	movsbl %al,%eax
  8014a7:	83 e8 30             	sub    $0x30,%eax
  8014aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ad:	eb 4e                	jmp    8014fd <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b3:	0f b6 00             	movzbl (%rax),%eax
  8014b6:	3c 60                	cmp    $0x60,%al
  8014b8:	7e 1d                	jle    8014d7 <strtol+0x118>
  8014ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014be:	0f b6 00             	movzbl (%rax),%eax
  8014c1:	3c 7a                	cmp    $0x7a,%al
  8014c3:	7f 12                	jg     8014d7 <strtol+0x118>
			dig = *s - 'a' + 10;
  8014c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c9:	0f b6 00             	movzbl (%rax),%eax
  8014cc:	0f be c0             	movsbl %al,%eax
  8014cf:	83 e8 57             	sub    $0x57,%eax
  8014d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014d5:	eb 26                	jmp    8014fd <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014db:	0f b6 00             	movzbl (%rax),%eax
  8014de:	3c 40                	cmp    $0x40,%al
  8014e0:	7e 48                	jle    80152a <strtol+0x16b>
  8014e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e6:	0f b6 00             	movzbl (%rax),%eax
  8014e9:	3c 5a                	cmp    $0x5a,%al
  8014eb:	7f 3d                	jg     80152a <strtol+0x16b>
			dig = *s - 'A' + 10;
  8014ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	0f be c0             	movsbl %al,%eax
  8014f7:	83 e8 37             	sub    $0x37,%eax
  8014fa:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8014fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801500:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801503:	7c 02                	jl     801507 <strtol+0x148>
			break;
  801505:	eb 23                	jmp    80152a <strtol+0x16b>
		s++, val = (val * base) + dig;
  801507:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80150c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80150f:	48 98                	cltq   
  801511:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801516:	48 89 c2             	mov    %rax,%rdx
  801519:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80151c:	48 98                	cltq   
  80151e:	48 01 d0             	add    %rdx,%rax
  801521:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801525:	e9 5d ff ff ff       	jmpq   801487 <strtol+0xc8>

	if (endptr)
  80152a:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80152f:	74 0b                	je     80153c <strtol+0x17d>
		*endptr = (char *) s;
  801531:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801535:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801539:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80153c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801540:	74 09                	je     80154b <strtol+0x18c>
  801542:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801546:	48 f7 d8             	neg    %rax
  801549:	eb 04                	jmp    80154f <strtol+0x190>
  80154b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80154f:	c9                   	leaveq 
  801550:	c3                   	retq   

0000000000801551 <strstr>:

char * strstr(const char *in, const char *str)
{
  801551:	55                   	push   %rbp
  801552:	48 89 e5             	mov    %rsp,%rbp
  801555:	48 83 ec 30          	sub    $0x30,%rsp
  801559:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80155d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801561:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801565:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801569:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80156d:	0f b6 00             	movzbl (%rax),%eax
  801570:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801573:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801577:	75 06                	jne    80157f <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157d:	eb 6b                	jmp    8015ea <strstr+0x99>

	len = strlen(str);
  80157f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801583:	48 89 c7             	mov    %rax,%rdi
  801586:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  80158d:	00 00 00 
  801590:	ff d0                	callq  *%rax
  801592:	48 98                	cltq   
  801594:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801598:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015a4:	0f b6 00             	movzbl (%rax),%eax
  8015a7:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015aa:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015ae:	75 07                	jne    8015b7 <strstr+0x66>
				return (char *) 0;
  8015b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b5:	eb 33                	jmp    8015ea <strstr+0x99>
		} while (sc != c);
  8015b7:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015bb:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015be:	75 d8                	jne    801598 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015c4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015cc:	48 89 ce             	mov    %rcx,%rsi
  8015cf:	48 89 c7             	mov    %rax,%rdi
  8015d2:	48 b8 48 10 80 00 00 	movabs $0x801048,%rax
  8015d9:	00 00 00 
  8015dc:	ff d0                	callq  *%rax
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	75 b6                	jne    801598 <strstr+0x47>

	return (char *) (in - 1);
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	48 83 e8 01          	sub    $0x1,%rax
}
  8015ea:	c9                   	leaveq 
  8015eb:	c3                   	retq   

00000000008015ec <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8015ec:	55                   	push   %rbp
  8015ed:	48 89 e5             	mov    %rsp,%rbp
  8015f0:	53                   	push   %rbx
  8015f1:	48 83 ec 48          	sub    $0x48,%rsp
  8015f5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015f8:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8015fb:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015ff:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801603:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801607:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  80160b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80160e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801612:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801616:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80161a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80161e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801622:	4c 89 c3             	mov    %r8,%rbx
  801625:	cd 30                	int    $0x30
  801627:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  80162b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80162f:	74 3e                	je     80166f <syscall+0x83>
  801631:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801636:	7e 37                	jle    80166f <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801638:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80163c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80163f:	49 89 d0             	mov    %rdx,%r8
  801642:	89 c1                	mov    %eax,%ecx
  801644:	48 ba c8 3a 80 00 00 	movabs $0x803ac8,%rdx
  80164b:	00 00 00 
  80164e:	be 4a 00 00 00       	mov    $0x4a,%esi
  801653:	48 bf e5 3a 80 00 00 	movabs $0x803ae5,%rdi
  80165a:	00 00 00 
  80165d:	b8 00 00 00 00       	mov    $0x0,%eax
  801662:	49 b9 fc 31 80 00 00 	movabs $0x8031fc,%r9
  801669:	00 00 00 
  80166c:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  80166f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801673:	48 83 c4 48          	add    $0x48,%rsp
  801677:	5b                   	pop    %rbx
  801678:	5d                   	pop    %rbp
  801679:	c3                   	retq   

000000000080167a <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80167a:	55                   	push   %rbp
  80167b:	48 89 e5             	mov    %rsp,%rbp
  80167e:	48 83 ec 20          	sub    $0x20,%rsp
  801682:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801686:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80168a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801692:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801699:	00 
  80169a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016a0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016a6:	48 89 d1             	mov    %rdx,%rcx
  8016a9:	48 89 c2             	mov    %rax,%rdx
  8016ac:	be 00 00 00 00       	mov    $0x0,%esi
  8016b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8016b6:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  8016bd:	00 00 00 
  8016c0:	ff d0                	callq  *%rax
}
  8016c2:	c9                   	leaveq 
  8016c3:	c3                   	retq   

00000000008016c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016c4:	55                   	push   %rbp
  8016c5:	48 89 e5             	mov    %rsp,%rbp
  8016c8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016cc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016d3:	00 
  8016d4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016da:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ea:	be 00 00 00 00       	mov    $0x0,%esi
  8016ef:	bf 01 00 00 00       	mov    $0x1,%edi
  8016f4:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  8016fb:	00 00 00 
  8016fe:	ff d0                	callq  *%rax
}
  801700:	c9                   	leaveq 
  801701:	c3                   	retq   

0000000000801702 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801702:	55                   	push   %rbp
  801703:	48 89 e5             	mov    %rsp,%rbp
  801706:	48 83 ec 10          	sub    $0x10,%rsp
  80170a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80170d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801710:	48 98                	cltq   
  801712:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801719:	00 
  80171a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801720:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801726:	b9 00 00 00 00       	mov    $0x0,%ecx
  80172b:	48 89 c2             	mov    %rax,%rdx
  80172e:	be 01 00 00 00       	mov    $0x1,%esi
  801733:	bf 03 00 00 00       	mov    $0x3,%edi
  801738:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  80173f:	00 00 00 
  801742:	ff d0                	callq  *%rax
}
  801744:	c9                   	leaveq 
  801745:	c3                   	retq   

0000000000801746 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801746:	55                   	push   %rbp
  801747:	48 89 e5             	mov    %rsp,%rbp
  80174a:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80174e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801755:	00 
  801756:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80175c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801762:	b9 00 00 00 00       	mov    $0x0,%ecx
  801767:	ba 00 00 00 00       	mov    $0x0,%edx
  80176c:	be 00 00 00 00       	mov    $0x0,%esi
  801771:	bf 02 00 00 00       	mov    $0x2,%edi
  801776:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  80177d:	00 00 00 
  801780:	ff d0                	callq  *%rax
}
  801782:	c9                   	leaveq 
  801783:	c3                   	retq   

0000000000801784 <sys_yield>:

void
sys_yield(void)
{
  801784:	55                   	push   %rbp
  801785:	48 89 e5             	mov    %rsp,%rbp
  801788:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80178c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801793:	00 
  801794:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80179a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017aa:	be 00 00 00 00       	mov    $0x0,%esi
  8017af:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017b4:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  8017bb:	00 00 00 
  8017be:	ff d0                	callq  *%rax
}
  8017c0:	c9                   	leaveq 
  8017c1:	c3                   	retq   

00000000008017c2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017c2:	55                   	push   %rbp
  8017c3:	48 89 e5             	mov    %rsp,%rbp
  8017c6:	48 83 ec 20          	sub    $0x20,%rsp
  8017ca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017cd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017d1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017d7:	48 63 c8             	movslq %eax,%rcx
  8017da:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017e1:	48 98                	cltq   
  8017e3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017ea:	00 
  8017eb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017f1:	49 89 c8             	mov    %rcx,%r8
  8017f4:	48 89 d1             	mov    %rdx,%rcx
  8017f7:	48 89 c2             	mov    %rax,%rdx
  8017fa:	be 01 00 00 00       	mov    $0x1,%esi
  8017ff:	bf 04 00 00 00       	mov    $0x4,%edi
  801804:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  80180b:	00 00 00 
  80180e:	ff d0                	callq  *%rax
}
  801810:	c9                   	leaveq 
  801811:	c3                   	retq   

0000000000801812 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801812:	55                   	push   %rbp
  801813:	48 89 e5             	mov    %rsp,%rbp
  801816:	48 83 ec 30          	sub    $0x30,%rsp
  80181a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80181d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801821:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801824:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801828:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80182c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80182f:	48 63 c8             	movslq %eax,%rcx
  801832:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801836:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801839:	48 63 f0             	movslq %eax,%rsi
  80183c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801840:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801843:	48 98                	cltq   
  801845:	48 89 0c 24          	mov    %rcx,(%rsp)
  801849:	49 89 f9             	mov    %rdi,%r9
  80184c:	49 89 f0             	mov    %rsi,%r8
  80184f:	48 89 d1             	mov    %rdx,%rcx
  801852:	48 89 c2             	mov    %rax,%rdx
  801855:	be 01 00 00 00       	mov    $0x1,%esi
  80185a:	bf 05 00 00 00       	mov    $0x5,%edi
  80185f:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  801866:	00 00 00 
  801869:	ff d0                	callq  *%rax
}
  80186b:	c9                   	leaveq 
  80186c:	c3                   	retq   

000000000080186d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80186d:	55                   	push   %rbp
  80186e:	48 89 e5             	mov    %rsp,%rbp
  801871:	48 83 ec 20          	sub    $0x20,%rsp
  801875:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801878:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  80187c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801880:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801883:	48 98                	cltq   
  801885:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80188c:	00 
  80188d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801893:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801899:	48 89 d1             	mov    %rdx,%rcx
  80189c:	48 89 c2             	mov    %rax,%rdx
  80189f:	be 01 00 00 00       	mov    $0x1,%esi
  8018a4:	bf 06 00 00 00       	mov    $0x6,%edi
  8018a9:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  8018b0:	00 00 00 
  8018b3:	ff d0                	callq  *%rax
}
  8018b5:	c9                   	leaveq 
  8018b6:	c3                   	retq   

00000000008018b7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018b7:	55                   	push   %rbp
  8018b8:	48 89 e5             	mov    %rsp,%rbp
  8018bb:	48 83 ec 10          	sub    $0x10,%rsp
  8018bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c2:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018c8:	48 63 d0             	movslq %eax,%rdx
  8018cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ce:	48 98                	cltq   
  8018d0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d7:	00 
  8018d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e4:	48 89 d1             	mov    %rdx,%rcx
  8018e7:	48 89 c2             	mov    %rax,%rdx
  8018ea:	be 01 00 00 00       	mov    $0x1,%esi
  8018ef:	bf 08 00 00 00       	mov    $0x8,%edi
  8018f4:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  8018fb:	00 00 00 
  8018fe:	ff d0                	callq  *%rax
}
  801900:	c9                   	leaveq 
  801901:	c3                   	retq   

0000000000801902 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801902:	55                   	push   %rbp
  801903:	48 89 e5             	mov    %rsp,%rbp
  801906:	48 83 ec 20          	sub    $0x20,%rsp
  80190a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80190d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801911:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801915:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801918:	48 98                	cltq   
  80191a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801921:	00 
  801922:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801928:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192e:	48 89 d1             	mov    %rdx,%rcx
  801931:	48 89 c2             	mov    %rax,%rdx
  801934:	be 01 00 00 00       	mov    $0x1,%esi
  801939:	bf 09 00 00 00       	mov    $0x9,%edi
  80193e:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
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
  801983:	bf 0a 00 00 00       	mov    $0xa,%edi
  801988:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
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
  8019d8:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019dd:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
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
  801a1c:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a21:	48 b8 ec 15 80 00 00 	movabs $0x8015ec,%rax
  801a28:	00 00 00 
  801a2b:	ff d0                	callq  *%rax
}
  801a2d:	c9                   	leaveq 
  801a2e:	c3                   	retq   

0000000000801a2f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801a2f:	55                   	push   %rbp
  801a30:	48 89 e5             	mov    %rsp,%rbp
  801a33:	48 83 ec 08          	sub    $0x8,%rsp
  801a37:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801a3b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801a3f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801a46:	ff ff ff 
  801a49:	48 01 d0             	add    %rdx,%rax
  801a4c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801a50:	c9                   	leaveq 
  801a51:	c3                   	retq   

0000000000801a52 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801a52:	55                   	push   %rbp
  801a53:	48 89 e5             	mov    %rsp,%rbp
  801a56:	48 83 ec 08          	sub    $0x8,%rsp
  801a5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801a5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a62:	48 89 c7             	mov    %rax,%rdi
  801a65:	48 b8 2f 1a 80 00 00 	movabs $0x801a2f,%rax
  801a6c:	00 00 00 
  801a6f:	ff d0                	callq  *%rax
  801a71:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801a77:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801a7b:	c9                   	leaveq 
  801a7c:	c3                   	retq   

0000000000801a7d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a7d:	55                   	push   %rbp
  801a7e:	48 89 e5             	mov    %rsp,%rbp
  801a81:	48 83 ec 18          	sub    $0x18,%rsp
  801a85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801a90:	eb 6b                	jmp    801afd <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801a92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a95:	48 98                	cltq   
  801a97:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801a9d:	48 c1 e0 0c          	shl    $0xc,%rax
  801aa1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801aa5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aa9:	48 c1 e8 15          	shr    $0x15,%rax
  801aad:	48 89 c2             	mov    %rax,%rdx
  801ab0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ab7:	01 00 00 
  801aba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801abe:	83 e0 01             	and    $0x1,%eax
  801ac1:	48 85 c0             	test   %rax,%rax
  801ac4:	74 21                	je     801ae7 <fd_alloc+0x6a>
  801ac6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801aca:	48 c1 e8 0c          	shr    $0xc,%rax
  801ace:	48 89 c2             	mov    %rax,%rdx
  801ad1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ad8:	01 00 00 
  801adb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801adf:	83 e0 01             	and    $0x1,%eax
  801ae2:	48 85 c0             	test   %rax,%rax
  801ae5:	75 12                	jne    801af9 <fd_alloc+0x7c>
			*fd_store = fd;
  801ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801aeb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aef:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801af2:	b8 00 00 00 00       	mov    $0x0,%eax
  801af7:	eb 1a                	jmp    801b13 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801af9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801afd:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801b01:	7e 8f                	jle    801a92 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801b03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b07:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801b0e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801b13:	c9                   	leaveq 
  801b14:	c3                   	retq   

0000000000801b15 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801b15:	55                   	push   %rbp
  801b16:	48 89 e5             	mov    %rsp,%rbp
  801b19:	48 83 ec 20          	sub    $0x20,%rsp
  801b1d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801b20:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801b24:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801b28:	78 06                	js     801b30 <fd_lookup+0x1b>
  801b2a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801b2e:	7e 07                	jle    801b37 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b35:	eb 6c                	jmp    801ba3 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801b37:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b3a:	48 98                	cltq   
  801b3c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b42:	48 c1 e0 0c          	shl    $0xc,%rax
  801b46:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801b4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b4e:	48 c1 e8 15          	shr    $0x15,%rax
  801b52:	48 89 c2             	mov    %rax,%rdx
  801b55:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801b5c:	01 00 00 
  801b5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b63:	83 e0 01             	and    $0x1,%eax
  801b66:	48 85 c0             	test   %rax,%rax
  801b69:	74 21                	je     801b8c <fd_lookup+0x77>
  801b6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b6f:	48 c1 e8 0c          	shr    $0xc,%rax
  801b73:	48 89 c2             	mov    %rax,%rdx
  801b76:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801b7d:	01 00 00 
  801b80:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801b84:	83 e0 01             	and    $0x1,%eax
  801b87:	48 85 c0             	test   %rax,%rax
  801b8a:	75 07                	jne    801b93 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801b8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b91:	eb 10                	jmp    801ba3 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801b93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b97:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b9b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801b9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba3:	c9                   	leaveq 
  801ba4:	c3                   	retq   

0000000000801ba5 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ba5:	55                   	push   %rbp
  801ba6:	48 89 e5             	mov    %rsp,%rbp
  801ba9:	48 83 ec 30          	sub    $0x30,%rsp
  801bad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801bb1:	89 f0                	mov    %esi,%eax
  801bb3:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801bb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bba:	48 89 c7             	mov    %rax,%rdi
  801bbd:	48 b8 2f 1a 80 00 00 	movabs $0x801a2f,%rax
  801bc4:	00 00 00 
  801bc7:	ff d0                	callq  *%rax
  801bc9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801bcd:	48 89 d6             	mov    %rdx,%rsi
  801bd0:	89 c7                	mov    %eax,%edi
  801bd2:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	callq  *%rax
  801bde:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801be1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801be5:	78 0a                	js     801bf1 <fd_close+0x4c>
	    || fd != fd2)
  801be7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801beb:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801bef:	74 12                	je     801c03 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801bf1:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801bf5:	74 05                	je     801bfc <fd_close+0x57>
  801bf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfa:	eb 05                	jmp    801c01 <fd_close+0x5c>
  801bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801c01:	eb 69                	jmp    801c6c <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c07:	8b 00                	mov    (%rax),%eax
  801c09:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801c0d:	48 89 d6             	mov    %rdx,%rsi
  801c10:	89 c7                	mov    %eax,%edi
  801c12:	48 b8 6e 1c 80 00 00 	movabs $0x801c6e,%rax
  801c19:	00 00 00 
  801c1c:	ff d0                	callq  *%rax
  801c1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c25:	78 2a                	js     801c51 <fd_close+0xac>
		if (dev->dev_close)
  801c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c2b:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c2f:	48 85 c0             	test   %rax,%rax
  801c32:	74 16                	je     801c4a <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801c34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c38:	48 8b 40 20          	mov    0x20(%rax),%rax
  801c3c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801c40:	48 89 d7             	mov    %rdx,%rdi
  801c43:	ff d0                	callq  *%rax
  801c45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c48:	eb 07                	jmp    801c51 <fd_close+0xac>
		else
			r = 0;
  801c4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801c51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c55:	48 89 c6             	mov    %rax,%rsi
  801c58:	bf 00 00 00 00       	mov    $0x0,%edi
  801c5d:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  801c64:	00 00 00 
  801c67:	ff d0                	callq  *%rax
	return r;
  801c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801c6c:	c9                   	leaveq 
  801c6d:	c3                   	retq   

0000000000801c6e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c6e:	55                   	push   %rbp
  801c6f:	48 89 e5             	mov    %rsp,%rbp
  801c72:	48 83 ec 20          	sub    $0x20,%rsp
  801c76:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801c7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c84:	eb 41                	jmp    801cc7 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801c86:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801c8d:	00 00 00 
  801c90:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c93:	48 63 d2             	movslq %edx,%rdx
  801c96:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c9a:	8b 00                	mov    (%rax),%eax
  801c9c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801c9f:	75 22                	jne    801cc3 <dev_lookup+0x55>
			*dev = devtab[i];
  801ca1:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ca8:	00 00 00 
  801cab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801cae:	48 63 d2             	movslq %edx,%rdx
  801cb1:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801cb5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cb9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc1:	eb 60                	jmp    801d23 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801cc3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cc7:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801cce:	00 00 00 
  801cd1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801cd4:	48 63 d2             	movslq %edx,%rdx
  801cd7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cdb:	48 85 c0             	test   %rax,%rax
  801cde:	75 a6                	jne    801c86 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ce0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801ce7:	00 00 00 
  801cea:	48 8b 00             	mov    (%rax),%rax
  801ced:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801cf3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801cf6:	89 c6                	mov    %eax,%esi
  801cf8:	48 bf f8 3a 80 00 00 	movabs $0x803af8,%rdi
  801cff:	00 00 00 
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
  801d07:	48 b9 de 02 80 00 00 	movabs $0x8002de,%rcx
  801d0e:	00 00 00 
  801d11:	ff d1                	callq  *%rcx
	*dev = 0;
  801d13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d17:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801d1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801d23:	c9                   	leaveq 
  801d24:	c3                   	retq   

0000000000801d25 <close>:

int
close(int fdnum)
{
  801d25:	55                   	push   %rbp
  801d26:	48 89 e5             	mov    %rsp,%rbp
  801d29:	48 83 ec 20          	sub    $0x20,%rsp
  801d2d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d30:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d37:	48 89 d6             	mov    %rdx,%rsi
  801d3a:	89 c7                	mov    %eax,%edi
  801d3c:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801d43:	00 00 00 
  801d46:	ff d0                	callq  *%rax
  801d48:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d4b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d4f:	79 05                	jns    801d56 <close+0x31>
		return r;
  801d51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d54:	eb 18                	jmp    801d6e <close+0x49>
	else
		return fd_close(fd, 1);
  801d56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d5a:	be 01 00 00 00       	mov    $0x1,%esi
  801d5f:	48 89 c7             	mov    %rax,%rdi
  801d62:	48 b8 a5 1b 80 00 00 	movabs $0x801ba5,%rax
  801d69:	00 00 00 
  801d6c:	ff d0                	callq  *%rax
}
  801d6e:	c9                   	leaveq 
  801d6f:	c3                   	retq   

0000000000801d70 <close_all>:

void
close_all(void)
{
  801d70:	55                   	push   %rbp
  801d71:	48 89 e5             	mov    %rsp,%rbp
  801d74:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801d78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d7f:	eb 15                	jmp    801d96 <close_all+0x26>
		close(i);
  801d81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d84:	89 c7                	mov    %eax,%edi
  801d86:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  801d8d:	00 00 00 
  801d90:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801d92:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d96:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d9a:	7e e5                	jle    801d81 <close_all+0x11>
		close(i);
}
  801d9c:	c9                   	leaveq 
  801d9d:	c3                   	retq   

0000000000801d9e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d9e:	55                   	push   %rbp
  801d9f:	48 89 e5             	mov    %rsp,%rbp
  801da2:	48 83 ec 40          	sub    $0x40,%rsp
  801da6:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801da9:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801dac:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801db0:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801db3:	48 89 d6             	mov    %rdx,%rsi
  801db6:	89 c7                	mov    %eax,%edi
  801db8:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801dbf:	00 00 00 
  801dc2:	ff d0                	callq  *%rax
  801dc4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dcb:	79 08                	jns    801dd5 <dup+0x37>
		return r;
  801dcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd0:	e9 70 01 00 00       	jmpq   801f45 <dup+0x1a7>
	close(newfdnum);
  801dd5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801dd8:	89 c7                	mov    %eax,%edi
  801dda:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  801de1:	00 00 00 
  801de4:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801de6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801de9:	48 98                	cltq   
  801deb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801df1:	48 c1 e0 0c          	shl    $0xc,%rax
  801df5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801df9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dfd:	48 89 c7             	mov    %rax,%rdi
  801e00:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  801e07:	00 00 00 
  801e0a:	ff d0                	callq  *%rax
  801e0c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e14:	48 89 c7             	mov    %rax,%rdi
  801e17:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  801e1e:	00 00 00 
  801e21:	ff d0                	callq  *%rax
  801e23:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801e27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2b:	48 c1 e8 15          	shr    $0x15,%rax
  801e2f:	48 89 c2             	mov    %rax,%rdx
  801e32:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e39:	01 00 00 
  801e3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e40:	83 e0 01             	and    $0x1,%eax
  801e43:	48 85 c0             	test   %rax,%rax
  801e46:	74 73                	je     801ebb <dup+0x11d>
  801e48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e4c:	48 c1 e8 0c          	shr    $0xc,%rax
  801e50:	48 89 c2             	mov    %rax,%rdx
  801e53:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e5a:	01 00 00 
  801e5d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e61:	83 e0 01             	and    $0x1,%eax
  801e64:	48 85 c0             	test   %rax,%rax
  801e67:	74 52                	je     801ebb <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801e69:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e6d:	48 c1 e8 0c          	shr    $0xc,%rax
  801e71:	48 89 c2             	mov    %rax,%rdx
  801e74:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e7b:	01 00 00 
  801e7e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e82:	25 07 0e 00 00       	and    $0xe07,%eax
  801e87:	89 c1                	mov    %eax,%ecx
  801e89:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801e8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e91:	41 89 c8             	mov    %ecx,%r8d
  801e94:	48 89 d1             	mov    %rdx,%rcx
  801e97:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9c:	48 89 c6             	mov    %rax,%rsi
  801e9f:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea4:	48 b8 12 18 80 00 00 	movabs $0x801812,%rax
  801eab:	00 00 00 
  801eae:	ff d0                	callq  *%rax
  801eb0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eb7:	79 02                	jns    801ebb <dup+0x11d>
			goto err;
  801eb9:	eb 57                	jmp    801f12 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ebb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ebf:	48 c1 e8 0c          	shr    $0xc,%rax
  801ec3:	48 89 c2             	mov    %rax,%rdx
  801ec6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ecd:	01 00 00 
  801ed0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed4:	25 07 0e 00 00       	and    $0xe07,%eax
  801ed9:	89 c1                	mov    %eax,%ecx
  801edb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801edf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ee3:	41 89 c8             	mov    %ecx,%r8d
  801ee6:	48 89 d1             	mov    %rdx,%rcx
  801ee9:	ba 00 00 00 00       	mov    $0x0,%edx
  801eee:	48 89 c6             	mov    %rax,%rsi
  801ef1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef6:	48 b8 12 18 80 00 00 	movabs $0x801812,%rax
  801efd:	00 00 00 
  801f00:	ff d0                	callq  *%rax
  801f02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f09:	79 02                	jns    801f0d <dup+0x16f>
		goto err;
  801f0b:	eb 05                	jmp    801f12 <dup+0x174>

	return newfdnum;
  801f0d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801f10:	eb 33                	jmp    801f45 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  801f12:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f16:	48 89 c6             	mov    %rax,%rsi
  801f19:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1e:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  801f25:	00 00 00 
  801f28:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801f2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f2e:	48 89 c6             	mov    %rax,%rsi
  801f31:	bf 00 00 00 00       	mov    $0x0,%edi
  801f36:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  801f3d:	00 00 00 
  801f40:	ff d0                	callq  *%rax
	return r;
  801f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f45:	c9                   	leaveq 
  801f46:	c3                   	retq   

0000000000801f47 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801f47:	55                   	push   %rbp
  801f48:	48 89 e5             	mov    %rsp,%rbp
  801f4b:	48 83 ec 40          	sub    $0x40,%rsp
  801f4f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801f52:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f56:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f5a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801f5e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801f61:	48 89 d6             	mov    %rdx,%rsi
  801f64:	89 c7                	mov    %eax,%edi
  801f66:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  801f6d:	00 00 00 
  801f70:	ff d0                	callq  *%rax
  801f72:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f75:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f79:	78 24                	js     801f9f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f7f:	8b 00                	mov    (%rax),%eax
  801f81:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f85:	48 89 d6             	mov    %rdx,%rsi
  801f88:	89 c7                	mov    %eax,%edi
  801f8a:	48 b8 6e 1c 80 00 00 	movabs $0x801c6e,%rax
  801f91:	00 00 00 
  801f94:	ff d0                	callq  *%rax
  801f96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f9d:	79 05                	jns    801fa4 <read+0x5d>
		return r;
  801f9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fa2:	eb 76                	jmp    80201a <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801fa4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fa8:	8b 40 08             	mov    0x8(%rax),%eax
  801fab:	83 e0 03             	and    $0x3,%eax
  801fae:	83 f8 01             	cmp    $0x1,%eax
  801fb1:	75 3a                	jne    801fed <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801fb3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801fba:	00 00 00 
  801fbd:	48 8b 00             	mov    (%rax),%rax
  801fc0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fc6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801fc9:	89 c6                	mov    %eax,%esi
  801fcb:	48 bf 17 3b 80 00 00 	movabs $0x803b17,%rdi
  801fd2:	00 00 00 
  801fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fda:	48 b9 de 02 80 00 00 	movabs $0x8002de,%rcx
  801fe1:	00 00 00 
  801fe4:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801fe6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801feb:	eb 2d                	jmp    80201a <read+0xd3>
	}
	if (!dev->dev_read)
  801fed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ff1:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ff5:	48 85 c0             	test   %rax,%rax
  801ff8:	75 07                	jne    802001 <read+0xba>
		return -E_NOT_SUPP;
  801ffa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801fff:	eb 19                	jmp    80201a <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802001:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802005:	48 8b 40 10          	mov    0x10(%rax),%rax
  802009:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80200d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802011:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802015:	48 89 cf             	mov    %rcx,%rdi
  802018:	ff d0                	callq  *%rax
}
  80201a:	c9                   	leaveq 
  80201b:	c3                   	retq   

000000000080201c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80201c:	55                   	push   %rbp
  80201d:	48 89 e5             	mov    %rsp,%rbp
  802020:	48 83 ec 30          	sub    $0x30,%rsp
  802024:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802027:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80202b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80202f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802036:	eb 49                	jmp    802081 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802038:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80203b:	48 98                	cltq   
  80203d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802041:	48 29 c2             	sub    %rax,%rdx
  802044:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802047:	48 63 c8             	movslq %eax,%rcx
  80204a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80204e:	48 01 c1             	add    %rax,%rcx
  802051:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802054:	48 89 ce             	mov    %rcx,%rsi
  802057:	89 c7                	mov    %eax,%edi
  802059:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  802060:	00 00 00 
  802063:	ff d0                	callq  *%rax
  802065:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802068:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80206c:	79 05                	jns    802073 <readn+0x57>
			return m;
  80206e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802071:	eb 1c                	jmp    80208f <readn+0x73>
		if (m == 0)
  802073:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802077:	75 02                	jne    80207b <readn+0x5f>
			break;
  802079:	eb 11                	jmp    80208c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80207b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80207e:	01 45 fc             	add    %eax,-0x4(%rbp)
  802081:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802084:	48 98                	cltq   
  802086:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80208a:	72 ac                	jb     802038 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80208c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80208f:	c9                   	leaveq 
  802090:	c3                   	retq   

0000000000802091 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802091:	55                   	push   %rbp
  802092:	48 89 e5             	mov    %rsp,%rbp
  802095:	48 83 ec 40          	sub    $0x40,%rsp
  802099:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80209c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8020a0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020a4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8020a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8020ab:	48 89 d6             	mov    %rdx,%rsi
  8020ae:	89 c7                	mov    %eax,%edi
  8020b0:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  8020b7:	00 00 00 
  8020ba:	ff d0                	callq  *%rax
  8020bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020c3:	78 24                	js     8020e9 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c9:	8b 00                	mov    (%rax),%eax
  8020cb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020cf:	48 89 d6             	mov    %rdx,%rsi
  8020d2:	89 c7                	mov    %eax,%edi
  8020d4:	48 b8 6e 1c 80 00 00 	movabs $0x801c6e,%rax
  8020db:	00 00 00 
  8020de:	ff d0                	callq  *%rax
  8020e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020e7:	79 05                	jns    8020ee <write+0x5d>
		return r;
  8020e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020ec:	eb 75                	jmp    802163 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f2:	8b 40 08             	mov    0x8(%rax),%eax
  8020f5:	83 e0 03             	and    $0x3,%eax
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	75 3a                	jne    802136 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8020fc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802103:	00 00 00 
  802106:	48 8b 00             	mov    (%rax),%rax
  802109:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80210f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802112:	89 c6                	mov    %eax,%esi
  802114:	48 bf 33 3b 80 00 00 	movabs $0x803b33,%rdi
  80211b:	00 00 00 
  80211e:	b8 00 00 00 00       	mov    $0x0,%eax
  802123:	48 b9 de 02 80 00 00 	movabs $0x8002de,%rcx
  80212a:	00 00 00 
  80212d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80212f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802134:	eb 2d                	jmp    802163 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802136:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80213a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80213e:	48 85 c0             	test   %rax,%rax
  802141:	75 07                	jne    80214a <write+0xb9>
		return -E_NOT_SUPP;
  802143:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802148:	eb 19                	jmp    802163 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80214a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802152:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802156:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80215a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80215e:	48 89 cf             	mov    %rcx,%rdi
  802161:	ff d0                	callq  *%rax
}
  802163:	c9                   	leaveq 
  802164:	c3                   	retq   

0000000000802165 <seek>:

int
seek(int fdnum, off_t offset)
{
  802165:	55                   	push   %rbp
  802166:	48 89 e5             	mov    %rsp,%rbp
  802169:	48 83 ec 18          	sub    $0x18,%rsp
  80216d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802170:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802173:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802177:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80217a:	48 89 d6             	mov    %rdx,%rsi
  80217d:	89 c7                	mov    %eax,%edi
  80217f:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  802186:	00 00 00 
  802189:	ff d0                	callq  *%rax
  80218b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802192:	79 05                	jns    802199 <seek+0x34>
		return r;
  802194:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802197:	eb 0f                	jmp    8021a8 <seek+0x43>
	fd->fd_offset = offset;
  802199:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80219d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8021a0:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a8:	c9                   	leaveq 
  8021a9:	c3                   	retq   

00000000008021aa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8021aa:	55                   	push   %rbp
  8021ab:	48 89 e5             	mov    %rsp,%rbp
  8021ae:	48 83 ec 30          	sub    $0x30,%rsp
  8021b2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021b5:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021b8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021bf:	48 89 d6             	mov    %rdx,%rsi
  8021c2:	89 c7                	mov    %eax,%edi
  8021c4:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  8021cb:	00 00 00 
  8021ce:	ff d0                	callq  *%rax
  8021d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d7:	78 24                	js     8021fd <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021dd:	8b 00                	mov    (%rax),%eax
  8021df:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021e3:	48 89 d6             	mov    %rdx,%rsi
  8021e6:	89 c7                	mov    %eax,%edi
  8021e8:	48 b8 6e 1c 80 00 00 	movabs $0x801c6e,%rax
  8021ef:	00 00 00 
  8021f2:	ff d0                	callq  *%rax
  8021f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021fb:	79 05                	jns    802202 <ftruncate+0x58>
		return r;
  8021fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802200:	eb 72                	jmp    802274 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802202:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802206:	8b 40 08             	mov    0x8(%rax),%eax
  802209:	83 e0 03             	and    $0x3,%eax
  80220c:	85 c0                	test   %eax,%eax
  80220e:	75 3a                	jne    80224a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802210:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802217:	00 00 00 
  80221a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80221d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802223:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802226:	89 c6                	mov    %eax,%esi
  802228:	48 bf 50 3b 80 00 00 	movabs $0x803b50,%rdi
  80222f:	00 00 00 
  802232:	b8 00 00 00 00       	mov    $0x0,%eax
  802237:	48 b9 de 02 80 00 00 	movabs $0x8002de,%rcx
  80223e:	00 00 00 
  802241:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802243:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802248:	eb 2a                	jmp    802274 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80224a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80224e:	48 8b 40 30          	mov    0x30(%rax),%rax
  802252:	48 85 c0             	test   %rax,%rax
  802255:	75 07                	jne    80225e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802257:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80225c:	eb 16                	jmp    802274 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80225e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802262:	48 8b 40 30          	mov    0x30(%rax),%rax
  802266:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80226a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80226d:	89 ce                	mov    %ecx,%esi
  80226f:	48 89 d7             	mov    %rdx,%rdi
  802272:	ff d0                	callq  *%rax
}
  802274:	c9                   	leaveq 
  802275:	c3                   	retq   

0000000000802276 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802276:	55                   	push   %rbp
  802277:	48 89 e5             	mov    %rsp,%rbp
  80227a:	48 83 ec 30          	sub    $0x30,%rsp
  80227e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802281:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802285:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802289:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80228c:	48 89 d6             	mov    %rdx,%rsi
  80228f:	89 c7                	mov    %eax,%edi
  802291:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  802298:	00 00 00 
  80229b:	ff d0                	callq  *%rax
  80229d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a4:	78 24                	js     8022ca <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022aa:	8b 00                	mov    (%rax),%eax
  8022ac:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022b0:	48 89 d6             	mov    %rdx,%rsi
  8022b3:	89 c7                	mov    %eax,%edi
  8022b5:	48 b8 6e 1c 80 00 00 	movabs $0x801c6e,%rax
  8022bc:	00 00 00 
  8022bf:	ff d0                	callq  *%rax
  8022c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c8:	79 05                	jns    8022cf <fstat+0x59>
		return r;
  8022ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022cd:	eb 5e                	jmp    80232d <fstat+0xb7>
	if (!dev->dev_stat)
  8022cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022d3:	48 8b 40 28          	mov    0x28(%rax),%rax
  8022d7:	48 85 c0             	test   %rax,%rax
  8022da:	75 07                	jne    8022e3 <fstat+0x6d>
		return -E_NOT_SUPP;
  8022dc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022e1:	eb 4a                	jmp    80232d <fstat+0xb7>
	stat->st_name[0] = 0;
  8022e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022e7:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8022ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022ee:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8022f5:	00 00 00 
	stat->st_isdir = 0;
  8022f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8022fc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802303:	00 00 00 
	stat->st_dev = dev;
  802306:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80230a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80230e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802319:	48 8b 40 28          	mov    0x28(%rax),%rax
  80231d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802321:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802325:	48 89 ce             	mov    %rcx,%rsi
  802328:	48 89 d7             	mov    %rdx,%rdi
  80232b:	ff d0                	callq  *%rax
}
  80232d:	c9                   	leaveq 
  80232e:	c3                   	retq   

000000000080232f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80232f:	55                   	push   %rbp
  802330:	48 89 e5             	mov    %rsp,%rbp
  802333:	48 83 ec 20          	sub    $0x20,%rsp
  802337:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80233b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80233f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802343:	be 00 00 00 00       	mov    $0x0,%esi
  802348:	48 89 c7             	mov    %rax,%rdi
  80234b:	48 b8 1d 24 80 00 00 	movabs $0x80241d,%rax
  802352:	00 00 00 
  802355:	ff d0                	callq  *%rax
  802357:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80235a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80235e:	79 05                	jns    802365 <stat+0x36>
		return fd;
  802360:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802363:	eb 2f                	jmp    802394 <stat+0x65>
	r = fstat(fd, stat);
  802365:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236c:	48 89 d6             	mov    %rdx,%rsi
  80236f:	89 c7                	mov    %eax,%edi
  802371:	48 b8 76 22 80 00 00 	movabs $0x802276,%rax
  802378:	00 00 00 
  80237b:	ff d0                	callq  *%rax
  80237d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802383:	89 c7                	mov    %eax,%edi
  802385:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  80238c:	00 00 00 
  80238f:	ff d0                	callq  *%rax
	return r;
  802391:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802394:	c9                   	leaveq 
  802395:	c3                   	retq   

0000000000802396 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802396:	55                   	push   %rbp
  802397:	48 89 e5             	mov    %rsp,%rbp
  80239a:	48 83 ec 10          	sub    $0x10,%rsp
  80239e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8023a5:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8023ac:	00 00 00 
  8023af:	8b 00                	mov    (%rax),%eax
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	75 1d                	jne    8023d2 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8023ba:	48 b8 73 34 80 00 00 	movabs $0x803473,%rax
  8023c1:	00 00 00 
  8023c4:	ff d0                	callq  *%rax
  8023c6:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8023cd:	00 00 00 
  8023d0:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8023d2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8023d9:	00 00 00 
  8023dc:	8b 00                	mov    (%rax),%eax
  8023de:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8023e1:	b9 07 00 00 00       	mov    $0x7,%ecx
  8023e6:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8023ed:	00 00 00 
  8023f0:	89 c7                	mov    %eax,%edi
  8023f2:	48 b8 d6 33 80 00 00 	movabs $0x8033d6,%rax
  8023f9:	00 00 00 
  8023fc:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8023fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802402:	ba 00 00 00 00       	mov    $0x0,%edx
  802407:	48 89 c6             	mov    %rax,%rsi
  80240a:	bf 00 00 00 00       	mov    $0x0,%edi
  80240f:	48 b8 10 33 80 00 00 	movabs $0x803310,%rax
  802416:	00 00 00 
  802419:	ff d0                	callq  *%rax
}
  80241b:	c9                   	leaveq 
  80241c:	c3                   	retq   

000000000080241d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80241d:	55                   	push   %rbp
  80241e:	48 89 e5             	mov    %rsp,%rbp
  802421:	48 83 ec 20          	sub    $0x20,%rsp
  802425:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802429:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  80242c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802430:	48 89 c7             	mov    %rax,%rdi
  802433:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  80243a:	00 00 00 
  80243d:	ff d0                	callq  *%rax
  80243f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802444:	7e 0a                	jle    802450 <open+0x33>
  802446:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80244b:	e9 a5 00 00 00       	jmpq   8024f5 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802450:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802454:	48 89 c7             	mov    %rax,%rdi
  802457:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  80245e:	00 00 00 
  802461:	ff d0                	callq  *%rax
  802463:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802466:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246a:	79 08                	jns    802474 <open+0x57>
		return r;
  80246c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80246f:	e9 81 00 00 00       	jmpq   8024f5 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802474:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80247b:	00 00 00 
  80247e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802481:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802487:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248b:	48 89 c6             	mov    %rax,%rsi
  80248e:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802495:	00 00 00 
  802498:	48 b8 93 0e 80 00 00 	movabs $0x800e93,%rax
  80249f:	00 00 00 
  8024a2:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  8024a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a8:	48 89 c6             	mov    %rax,%rsi
  8024ab:	bf 01 00 00 00       	mov    $0x1,%edi
  8024b0:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  8024b7:	00 00 00 
  8024ba:	ff d0                	callq  *%rax
  8024bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c3:	79 1d                	jns    8024e2 <open+0xc5>
		fd_close(fd, 0);
  8024c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c9:	be 00 00 00 00       	mov    $0x0,%esi
  8024ce:	48 89 c7             	mov    %rax,%rdi
  8024d1:	48 b8 a5 1b 80 00 00 	movabs $0x801ba5,%rax
  8024d8:	00 00 00 
  8024db:	ff d0                	callq  *%rax
		return r;
  8024dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e0:	eb 13                	jmp    8024f5 <open+0xd8>
	}
	return fd2num(fd);
  8024e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e6:	48 89 c7             	mov    %rax,%rdi
  8024e9:	48 b8 2f 1a 80 00 00 	movabs $0x801a2f,%rax
  8024f0:	00 00 00 
  8024f3:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  8024f5:	c9                   	leaveq 
  8024f6:	c3                   	retq   

00000000008024f7 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8024f7:	55                   	push   %rbp
  8024f8:	48 89 e5             	mov    %rsp,%rbp
  8024fb:	48 83 ec 10          	sub    $0x10,%rsp
  8024ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802507:	8b 50 0c             	mov    0xc(%rax),%edx
  80250a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802511:	00 00 00 
  802514:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802516:	be 00 00 00 00       	mov    $0x0,%esi
  80251b:	bf 06 00 00 00       	mov    $0x6,%edi
  802520:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  802527:	00 00 00 
  80252a:	ff d0                	callq  *%rax
}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 30          	sub    $0x30,%rsp
  802536:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80253a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80253e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802546:	8b 50 0c             	mov    0xc(%rax),%edx
  802549:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802550:	00 00 00 
  802553:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802555:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80255c:	00 00 00 
  80255f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802563:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802567:	be 00 00 00 00       	mov    $0x0,%esi
  80256c:	bf 03 00 00 00       	mov    $0x3,%edi
  802571:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  802578:	00 00 00 
  80257b:	ff d0                	callq  *%rax
  80257d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802580:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802584:	79 05                	jns    80258b <devfile_read+0x5d>
		return r;
  802586:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802589:	eb 26                	jmp    8025b1 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  80258b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258e:	48 63 d0             	movslq %eax,%rdx
  802591:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802595:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80259c:	00 00 00 
  80259f:	48 89 c7             	mov    %rax,%rdi
  8025a2:	48 b8 ce 12 80 00 00 	movabs $0x8012ce,%rax
  8025a9:	00 00 00 
  8025ac:	ff d0                	callq  *%rax
	return r;
  8025ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8025b1:	c9                   	leaveq 
  8025b2:	c3                   	retq   

00000000008025b3 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8025b3:	55                   	push   %rbp
  8025b4:	48 89 e5             	mov    %rsp,%rbp
  8025b7:	48 83 ec 30          	sub    $0x30,%rsp
  8025bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  8025c7:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  8025ce:	00 
	n = n > max ? max : n;
  8025cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025d3:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8025d7:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8025dc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8025e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025e4:	8b 50 0c             	mov    0xc(%rax),%edx
  8025e7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025ee:	00 00 00 
  8025f1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8025f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8025fa:	00 00 00 
  8025fd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802601:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802605:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802609:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80260d:	48 89 c6             	mov    %rax,%rsi
  802610:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802617:	00 00 00 
  80261a:	48 b8 ce 12 80 00 00 	movabs $0x8012ce,%rax
  802621:	00 00 00 
  802624:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802626:	be 00 00 00 00       	mov    $0x0,%esi
  80262b:	bf 04 00 00 00       	mov    $0x4,%edi
  802630:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  802637:	00 00 00 
  80263a:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  80263c:	c9                   	leaveq 
  80263d:	c3                   	retq   

000000000080263e <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80263e:	55                   	push   %rbp
  80263f:	48 89 e5             	mov    %rsp,%rbp
  802642:	48 83 ec 20          	sub    $0x20,%rsp
  802646:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80264a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80264e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802652:	8b 50 0c             	mov    0xc(%rax),%edx
  802655:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80265c:	00 00 00 
  80265f:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802661:	be 00 00 00 00       	mov    $0x0,%esi
  802666:	bf 05 00 00 00       	mov    $0x5,%edi
  80266b:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  802672:	00 00 00 
  802675:	ff d0                	callq  *%rax
  802677:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80267a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267e:	79 05                	jns    802685 <devfile_stat+0x47>
		return r;
  802680:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802683:	eb 56                	jmp    8026db <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802685:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802689:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802690:	00 00 00 
  802693:	48 89 c7             	mov    %rax,%rdi
  802696:	48 b8 93 0e 80 00 00 	movabs $0x800e93,%rax
  80269d:	00 00 00 
  8026a0:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8026a2:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026a9:	00 00 00 
  8026ac:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8026b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026b6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8026bc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026c3:	00 00 00 
  8026c6:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8026cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026d0:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8026d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026db:	c9                   	leaveq 
  8026dc:	c3                   	retq   

00000000008026dd <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8026dd:	55                   	push   %rbp
  8026de:	48 89 e5             	mov    %rsp,%rbp
  8026e1:	48 83 ec 10          	sub    $0x10,%rsp
  8026e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026e9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8026ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f0:	8b 50 0c             	mov    0xc(%rax),%edx
  8026f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026fa:	00 00 00 
  8026fd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8026ff:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802706:	00 00 00 
  802709:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80270c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80270f:	be 00 00 00 00       	mov    $0x0,%esi
  802714:	bf 02 00 00 00       	mov    $0x2,%edi
  802719:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  802720:	00 00 00 
  802723:	ff d0                	callq  *%rax
}
  802725:	c9                   	leaveq 
  802726:	c3                   	retq   

0000000000802727 <remove>:

// Delete a file
int
remove(const char *path)
{
  802727:	55                   	push   %rbp
  802728:	48 89 e5             	mov    %rsp,%rbp
  80272b:	48 83 ec 10          	sub    $0x10,%rsp
  80272f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802733:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802737:	48 89 c7             	mov    %rax,%rdi
  80273a:	48 b8 27 0e 80 00 00 	movabs $0x800e27,%rax
  802741:	00 00 00 
  802744:	ff d0                	callq  *%rax
  802746:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80274b:	7e 07                	jle    802754 <remove+0x2d>
		return -E_BAD_PATH;
  80274d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802752:	eb 33                	jmp    802787 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802758:	48 89 c6             	mov    %rax,%rsi
  80275b:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802762:	00 00 00 
  802765:	48 b8 93 0e 80 00 00 	movabs $0x800e93,%rax
  80276c:	00 00 00 
  80276f:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802771:	be 00 00 00 00       	mov    $0x0,%esi
  802776:	bf 07 00 00 00       	mov    $0x7,%edi
  80277b:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  802782:	00 00 00 
  802785:	ff d0                	callq  *%rax
}
  802787:	c9                   	leaveq 
  802788:	c3                   	retq   

0000000000802789 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802789:	55                   	push   %rbp
  80278a:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80278d:	be 00 00 00 00       	mov    $0x0,%esi
  802792:	bf 08 00 00 00       	mov    $0x8,%edi
  802797:	48 b8 96 23 80 00 00 	movabs $0x802396,%rax
  80279e:	00 00 00 
  8027a1:	ff d0                	callq  *%rax
}
  8027a3:	5d                   	pop    %rbp
  8027a4:	c3                   	retq   

00000000008027a5 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8027a5:	55                   	push   %rbp
  8027a6:	48 89 e5             	mov    %rsp,%rbp
  8027a9:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8027b0:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8027b7:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8027be:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8027c5:	be 00 00 00 00       	mov    $0x0,%esi
  8027ca:	48 89 c7             	mov    %rax,%rdi
  8027cd:	48 b8 1d 24 80 00 00 	movabs $0x80241d,%rax
  8027d4:	00 00 00 
  8027d7:	ff d0                	callq  *%rax
  8027d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8027dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027e0:	79 28                	jns    80280a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8027e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e5:	89 c6                	mov    %eax,%esi
  8027e7:	48 bf 76 3b 80 00 00 	movabs $0x803b76,%rdi
  8027ee:	00 00 00 
  8027f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f6:	48 ba de 02 80 00 00 	movabs $0x8002de,%rdx
  8027fd:	00 00 00 
  802800:	ff d2                	callq  *%rdx
		return fd_src;
  802802:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802805:	e9 74 01 00 00       	jmpq   80297e <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80280a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802811:	be 01 01 00 00       	mov    $0x101,%esi
  802816:	48 89 c7             	mov    %rax,%rdi
  802819:	48 b8 1d 24 80 00 00 	movabs $0x80241d,%rax
  802820:	00 00 00 
  802823:	ff d0                	callq  *%rax
  802825:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802828:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80282c:	79 39                	jns    802867 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80282e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802831:	89 c6                	mov    %eax,%esi
  802833:	48 bf 8c 3b 80 00 00 	movabs $0x803b8c,%rdi
  80283a:	00 00 00 
  80283d:	b8 00 00 00 00       	mov    $0x0,%eax
  802842:	48 ba de 02 80 00 00 	movabs $0x8002de,%rdx
  802849:	00 00 00 
  80284c:	ff d2                	callq  *%rdx
		close(fd_src);
  80284e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802851:	89 c7                	mov    %eax,%edi
  802853:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  80285a:	00 00 00 
  80285d:	ff d0                	callq  *%rax
		return fd_dest;
  80285f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802862:	e9 17 01 00 00       	jmpq   80297e <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802867:	eb 74                	jmp    8028dd <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802869:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80286c:	48 63 d0             	movslq %eax,%rdx
  80286f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802876:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802879:	48 89 ce             	mov    %rcx,%rsi
  80287c:	89 c7                	mov    %eax,%edi
  80287e:	48 b8 91 20 80 00 00 	movabs $0x802091,%rax
  802885:	00 00 00 
  802888:	ff d0                	callq  *%rax
  80288a:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80288d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802891:	79 4a                	jns    8028dd <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802893:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802896:	89 c6                	mov    %eax,%esi
  802898:	48 bf a6 3b 80 00 00 	movabs $0x803ba6,%rdi
  80289f:	00 00 00 
  8028a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a7:	48 ba de 02 80 00 00 	movabs $0x8002de,%rdx
  8028ae:	00 00 00 
  8028b1:	ff d2                	callq  *%rdx
			close(fd_src);
  8028b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028b6:	89 c7                	mov    %eax,%edi
  8028b8:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  8028bf:	00 00 00 
  8028c2:	ff d0                	callq  *%rax
			close(fd_dest);
  8028c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028c7:	89 c7                	mov    %eax,%edi
  8028c9:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  8028d0:	00 00 00 
  8028d3:	ff d0                	callq  *%rax
			return write_size;
  8028d5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8028d8:	e9 a1 00 00 00       	jmpq   80297e <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8028dd:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8028e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028e7:	ba 00 02 00 00       	mov    $0x200,%edx
  8028ec:	48 89 ce             	mov    %rcx,%rsi
  8028ef:	89 c7                	mov    %eax,%edi
  8028f1:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	callq  *%rax
  8028fd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802900:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802904:	0f 8f 5f ff ff ff    	jg     802869 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80290a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80290e:	79 47                	jns    802957 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802910:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802913:	89 c6                	mov    %eax,%esi
  802915:	48 bf b9 3b 80 00 00 	movabs $0x803bb9,%rdi
  80291c:	00 00 00 
  80291f:	b8 00 00 00 00       	mov    $0x0,%eax
  802924:	48 ba de 02 80 00 00 	movabs $0x8002de,%rdx
  80292b:	00 00 00 
  80292e:	ff d2                	callq  *%rdx
		close(fd_src);
  802930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802933:	89 c7                	mov    %eax,%edi
  802935:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  80293c:	00 00 00 
  80293f:	ff d0                	callq  *%rax
		close(fd_dest);
  802941:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802944:	89 c7                	mov    %eax,%edi
  802946:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  80294d:	00 00 00 
  802950:	ff d0                	callq  *%rax
		return read_size;
  802952:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802955:	eb 27                	jmp    80297e <copy+0x1d9>
	}
	close(fd_src);
  802957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80295a:	89 c7                	mov    %eax,%edi
  80295c:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  802963:	00 00 00 
  802966:	ff d0                	callq  *%rax
	close(fd_dest);
  802968:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80296b:	89 c7                	mov    %eax,%edi
  80296d:	48 b8 25 1d 80 00 00 	movabs $0x801d25,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
	return 0;
  802979:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80297e:	c9                   	leaveq 
  80297f:	c3                   	retq   

0000000000802980 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802980:	55                   	push   %rbp
  802981:	48 89 e5             	mov    %rsp,%rbp
  802984:	53                   	push   %rbx
  802985:	48 83 ec 38          	sub    $0x38,%rsp
  802989:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80298d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802991:	48 89 c7             	mov    %rax,%rdi
  802994:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  80299b:	00 00 00 
  80299e:	ff d0                	callq  *%rax
  8029a0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029a7:	0f 88 bf 01 00 00    	js     802b6c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029b1:	ba 07 04 00 00       	mov    $0x407,%edx
  8029b6:	48 89 c6             	mov    %rax,%rsi
  8029b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8029be:	48 b8 c2 17 80 00 00 	movabs $0x8017c2,%rax
  8029c5:	00 00 00 
  8029c8:	ff d0                	callq  *%rax
  8029ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029d1:	0f 88 95 01 00 00    	js     802b6c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8029d7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8029db:	48 89 c7             	mov    %rax,%rdi
  8029de:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  8029e5:	00 00 00 
  8029e8:	ff d0                	callq  *%rax
  8029ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029f1:	0f 88 5d 01 00 00    	js     802b54 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029fb:	ba 07 04 00 00       	mov    $0x407,%edx
  802a00:	48 89 c6             	mov    %rax,%rsi
  802a03:	bf 00 00 00 00       	mov    $0x0,%edi
  802a08:	48 b8 c2 17 80 00 00 	movabs $0x8017c2,%rax
  802a0f:	00 00 00 
  802a12:	ff d0                	callq  *%rax
  802a14:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a17:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a1b:	0f 88 33 01 00 00    	js     802b54 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802a21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a25:	48 89 c7             	mov    %rax,%rdi
  802a28:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  802a2f:	00 00 00 
  802a32:	ff d0                	callq  *%rax
  802a34:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a3c:	ba 07 04 00 00       	mov    $0x407,%edx
  802a41:	48 89 c6             	mov    %rax,%rsi
  802a44:	bf 00 00 00 00       	mov    $0x0,%edi
  802a49:	48 b8 c2 17 80 00 00 	movabs $0x8017c2,%rax
  802a50:	00 00 00 
  802a53:	ff d0                	callq  *%rax
  802a55:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a58:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a5c:	79 05                	jns    802a63 <pipe+0xe3>
		goto err2;
  802a5e:	e9 d9 00 00 00       	jmpq   802b3c <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a67:	48 89 c7             	mov    %rax,%rdi
  802a6a:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  802a71:	00 00 00 
  802a74:	ff d0                	callq  *%rax
  802a76:	48 89 c2             	mov    %rax,%rdx
  802a79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802a83:	48 89 d1             	mov    %rdx,%rcx
  802a86:	ba 00 00 00 00       	mov    $0x0,%edx
  802a8b:	48 89 c6             	mov    %rax,%rsi
  802a8e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a93:	48 b8 12 18 80 00 00 	movabs $0x801812,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
  802a9f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802aa2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802aa6:	79 1b                	jns    802ac3 <pipe+0x143>
		goto err3;
  802aa8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802aa9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aad:	48 89 c6             	mov    %rax,%rsi
  802ab0:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab5:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  802abc:	00 00 00 
  802abf:	ff d0                	callq  *%rax
  802ac1:	eb 79                	jmp    802b3c <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802ac3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ac7:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802ace:	00 00 00 
  802ad1:	8b 12                	mov    (%rdx),%edx
  802ad3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802ad5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ad9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802ae0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ae4:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802aeb:	00 00 00 
  802aee:	8b 12                	mov    (%rdx),%edx
  802af0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802af2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802af6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802afd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b01:	48 89 c7             	mov    %rax,%rdi
  802b04:	48 b8 2f 1a 80 00 00 	movabs $0x801a2f,%rax
  802b0b:	00 00 00 
  802b0e:	ff d0                	callq  *%rax
  802b10:	89 c2                	mov    %eax,%edx
  802b12:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b16:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802b18:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802b1c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802b20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b24:	48 89 c7             	mov    %rax,%rdi
  802b27:	48 b8 2f 1a 80 00 00 	movabs $0x801a2f,%rax
  802b2e:	00 00 00 
  802b31:	ff d0                	callq  *%rax
  802b33:	89 03                	mov    %eax,(%rbx)
	return 0;
  802b35:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3a:	eb 33                	jmp    802b6f <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802b3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b40:	48 89 c6             	mov    %rax,%rsi
  802b43:	bf 00 00 00 00       	mov    $0x0,%edi
  802b48:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802b54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b58:	48 89 c6             	mov    %rax,%rsi
  802b5b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b60:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  802b67:	00 00 00 
  802b6a:	ff d0                	callq  *%rax
err:
	return r;
  802b6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802b6f:	48 83 c4 38          	add    $0x38,%rsp
  802b73:	5b                   	pop    %rbx
  802b74:	5d                   	pop    %rbp
  802b75:	c3                   	retq   

0000000000802b76 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802b76:	55                   	push   %rbp
  802b77:	48 89 e5             	mov    %rsp,%rbp
  802b7a:	53                   	push   %rbx
  802b7b:	48 83 ec 28          	sub    $0x28,%rsp
  802b7f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b83:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802b87:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802b8e:	00 00 00 
  802b91:	48 8b 00             	mov    (%rax),%rax
  802b94:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802b9a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802b9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ba1:	48 89 c7             	mov    %rax,%rdi
  802ba4:	48 b8 f5 34 80 00 00 	movabs $0x8034f5,%rax
  802bab:	00 00 00 
  802bae:	ff d0                	callq  *%rax
  802bb0:	89 c3                	mov    %eax,%ebx
  802bb2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bb6:	48 89 c7             	mov    %rax,%rdi
  802bb9:	48 b8 f5 34 80 00 00 	movabs $0x8034f5,%rax
  802bc0:	00 00 00 
  802bc3:	ff d0                	callq  *%rax
  802bc5:	39 c3                	cmp    %eax,%ebx
  802bc7:	0f 94 c0             	sete   %al
  802bca:	0f b6 c0             	movzbl %al,%eax
  802bcd:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802bd0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802bd7:	00 00 00 
  802bda:	48 8b 00             	mov    (%rax),%rax
  802bdd:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802be3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802be6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802be9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802bec:	75 05                	jne    802bf3 <_pipeisclosed+0x7d>
			return ret;
  802bee:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802bf1:	eb 4f                	jmp    802c42 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802bf3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bf6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802bf9:	74 42                	je     802c3d <_pipeisclosed+0xc7>
  802bfb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802bff:	75 3c                	jne    802c3d <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c01:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802c08:	00 00 00 
  802c0b:	48 8b 00             	mov    (%rax),%rax
  802c0e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802c14:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802c17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802c1a:	89 c6                	mov    %eax,%esi
  802c1c:	48 bf d4 3b 80 00 00 	movabs $0x803bd4,%rdi
  802c23:	00 00 00 
  802c26:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2b:	49 b8 de 02 80 00 00 	movabs $0x8002de,%r8
  802c32:	00 00 00 
  802c35:	41 ff d0             	callq  *%r8
	}
  802c38:	e9 4a ff ff ff       	jmpq   802b87 <_pipeisclosed+0x11>
  802c3d:	e9 45 ff ff ff       	jmpq   802b87 <_pipeisclosed+0x11>
}
  802c42:	48 83 c4 28          	add    $0x28,%rsp
  802c46:	5b                   	pop    %rbx
  802c47:	5d                   	pop    %rbp
  802c48:	c3                   	retq   

0000000000802c49 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802c49:	55                   	push   %rbp
  802c4a:	48 89 e5             	mov    %rsp,%rbp
  802c4d:	48 83 ec 30          	sub    $0x30,%rsp
  802c51:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c54:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c58:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c5b:	48 89 d6             	mov    %rdx,%rsi
  802c5e:	89 c7                	mov    %eax,%edi
  802c60:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  802c67:	00 00 00 
  802c6a:	ff d0                	callq  *%rax
  802c6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c73:	79 05                	jns    802c7a <pipeisclosed+0x31>
		return r;
  802c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c78:	eb 31                	jmp    802cab <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7e:	48 89 c7             	mov    %rax,%rdi
  802c81:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  802c88:	00 00 00 
  802c8b:	ff d0                	callq  *%rax
  802c8d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802c91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c99:	48 89 d6             	mov    %rdx,%rsi
  802c9c:	48 89 c7             	mov    %rax,%rdi
  802c9f:	48 b8 76 2b 80 00 00 	movabs $0x802b76,%rax
  802ca6:	00 00 00 
  802ca9:	ff d0                	callq  *%rax
}
  802cab:	c9                   	leaveq 
  802cac:	c3                   	retq   

0000000000802cad <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802cad:	55                   	push   %rbp
  802cae:	48 89 e5             	mov    %rsp,%rbp
  802cb1:	48 83 ec 40          	sub    $0x40,%rsp
  802cb5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802cb9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cbd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802cc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cc5:	48 89 c7             	mov    %rax,%rdi
  802cc8:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  802ccf:	00 00 00 
  802cd2:	ff d0                	callq  *%rax
  802cd4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802cd8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cdc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802ce0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ce7:	00 
  802ce8:	e9 92 00 00 00       	jmpq   802d7f <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802ced:	eb 41                	jmp    802d30 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802cef:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802cf4:	74 09                	je     802cff <devpipe_read+0x52>
				return i;
  802cf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cfa:	e9 92 00 00 00       	jmpq   802d91 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802cff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d07:	48 89 d6             	mov    %rdx,%rsi
  802d0a:	48 89 c7             	mov    %rax,%rdi
  802d0d:	48 b8 76 2b 80 00 00 	movabs $0x802b76,%rax
  802d14:	00 00 00 
  802d17:	ff d0                	callq  *%rax
  802d19:	85 c0                	test   %eax,%eax
  802d1b:	74 07                	je     802d24 <devpipe_read+0x77>
				return 0;
  802d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d22:	eb 6d                	jmp    802d91 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802d24:	48 b8 84 17 80 00 00 	movabs $0x801784,%rax
  802d2b:	00 00 00 
  802d2e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802d30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d34:	8b 10                	mov    (%rax),%edx
  802d36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d3a:	8b 40 04             	mov    0x4(%rax),%eax
  802d3d:	39 c2                	cmp    %eax,%edx
  802d3f:	74 ae                	je     802cef <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d49:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802d4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d51:	8b 00                	mov    (%rax),%eax
  802d53:	99                   	cltd   
  802d54:	c1 ea 1b             	shr    $0x1b,%edx
  802d57:	01 d0                	add    %edx,%eax
  802d59:	83 e0 1f             	and    $0x1f,%eax
  802d5c:	29 d0                	sub    %edx,%eax
  802d5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d62:	48 98                	cltq   
  802d64:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802d69:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802d6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6f:	8b 00                	mov    (%rax),%eax
  802d71:	8d 50 01             	lea    0x1(%rax),%edx
  802d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d78:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d7a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802d7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d83:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802d87:	0f 82 60 ff ff ff    	jb     802ced <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d91:	c9                   	leaveq 
  802d92:	c3                   	retq   

0000000000802d93 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802d93:	55                   	push   %rbp
  802d94:	48 89 e5             	mov    %rsp,%rbp
  802d97:	48 83 ec 40          	sub    $0x40,%rsp
  802d9b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d9f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802da3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802da7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dab:	48 89 c7             	mov    %rax,%rdi
  802dae:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  802db5:	00 00 00 
  802db8:	ff d0                	callq  *%rax
  802dba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802dbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802dc6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802dcd:	00 
  802dce:	e9 8e 00 00 00       	jmpq   802e61 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802dd3:	eb 31                	jmp    802e06 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802dd5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802dd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ddd:	48 89 d6             	mov    %rdx,%rsi
  802de0:	48 89 c7             	mov    %rax,%rdi
  802de3:	48 b8 76 2b 80 00 00 	movabs $0x802b76,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
  802def:	85 c0                	test   %eax,%eax
  802df1:	74 07                	je     802dfa <devpipe_write+0x67>
				return 0;
  802df3:	b8 00 00 00 00       	mov    $0x0,%eax
  802df8:	eb 79                	jmp    802e73 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802dfa:	48 b8 84 17 80 00 00 	movabs $0x801784,%rax
  802e01:	00 00 00 
  802e04:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802e06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0a:	8b 40 04             	mov    0x4(%rax),%eax
  802e0d:	48 63 d0             	movslq %eax,%rdx
  802e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e14:	8b 00                	mov    (%rax),%eax
  802e16:	48 98                	cltq   
  802e18:	48 83 c0 20          	add    $0x20,%rax
  802e1c:	48 39 c2             	cmp    %rax,%rdx
  802e1f:	73 b4                	jae    802dd5 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802e21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e25:	8b 40 04             	mov    0x4(%rax),%eax
  802e28:	99                   	cltd   
  802e29:	c1 ea 1b             	shr    $0x1b,%edx
  802e2c:	01 d0                	add    %edx,%eax
  802e2e:	83 e0 1f             	and    $0x1f,%eax
  802e31:	29 d0                	sub    %edx,%eax
  802e33:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802e37:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802e3b:	48 01 ca             	add    %rcx,%rdx
  802e3e:	0f b6 0a             	movzbl (%rdx),%ecx
  802e41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e45:	48 98                	cltq   
  802e47:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e4f:	8b 40 04             	mov    0x4(%rax),%eax
  802e52:	8d 50 01             	lea    0x1(%rax),%edx
  802e55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e59:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e5c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802e61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e65:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802e69:	0f 82 64 ff ff ff    	jb     802dd3 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802e6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e73:	c9                   	leaveq 
  802e74:	c3                   	retq   

0000000000802e75 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802e75:	55                   	push   %rbp
  802e76:	48 89 e5             	mov    %rsp,%rbp
  802e79:	48 83 ec 20          	sub    $0x20,%rsp
  802e7d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e89:	48 89 c7             	mov    %rax,%rdi
  802e8c:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  802e93:	00 00 00 
  802e96:	ff d0                	callq  *%rax
  802e98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802e9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ea0:	48 be e7 3b 80 00 00 	movabs $0x803be7,%rsi
  802ea7:	00 00 00 
  802eaa:	48 89 c7             	mov    %rax,%rdi
  802ead:	48 b8 93 0e 80 00 00 	movabs $0x800e93,%rax
  802eb4:	00 00 00 
  802eb7:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802eb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ebd:	8b 50 04             	mov    0x4(%rax),%edx
  802ec0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec4:	8b 00                	mov    (%rax),%eax
  802ec6:	29 c2                	sub    %eax,%edx
  802ec8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ecc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802ed2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802edd:	00 00 00 
	stat->st_dev = &devpipe;
  802ee0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ee4:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  802eeb:	00 00 00 
  802eee:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802efa:	c9                   	leaveq 
  802efb:	c3                   	retq   

0000000000802efc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802efc:	55                   	push   %rbp
  802efd:	48 89 e5             	mov    %rsp,%rbp
  802f00:	48 83 ec 10          	sub    $0x10,%rsp
  802f04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  802f08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f0c:	48 89 c6             	mov    %rax,%rsi
  802f0f:	bf 00 00 00 00       	mov    $0x0,%edi
  802f14:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  802f1b:	00 00 00 
  802f1e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  802f20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f24:	48 89 c7             	mov    %rax,%rdi
  802f27:	48 b8 52 1a 80 00 00 	movabs $0x801a52,%rax
  802f2e:	00 00 00 
  802f31:	ff d0                	callq  *%rax
  802f33:	48 89 c6             	mov    %rax,%rsi
  802f36:	bf 00 00 00 00       	mov    $0x0,%edi
  802f3b:	48 b8 6d 18 80 00 00 	movabs $0x80186d,%rax
  802f42:	00 00 00 
  802f45:	ff d0                	callq  *%rax
}
  802f47:	c9                   	leaveq 
  802f48:	c3                   	retq   

0000000000802f49 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802f49:	55                   	push   %rbp
  802f4a:	48 89 e5             	mov    %rsp,%rbp
  802f4d:	48 83 ec 20          	sub    $0x20,%rsp
  802f51:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802f54:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f57:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802f5a:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802f5e:	be 01 00 00 00       	mov    $0x1,%esi
  802f63:	48 89 c7             	mov    %rax,%rdi
  802f66:	48 b8 7a 16 80 00 00 	movabs $0x80167a,%rax
  802f6d:	00 00 00 
  802f70:	ff d0                	callq  *%rax
}
  802f72:	c9                   	leaveq 
  802f73:	c3                   	retq   

0000000000802f74 <getchar>:

int
getchar(void)
{
  802f74:	55                   	push   %rbp
  802f75:	48 89 e5             	mov    %rsp,%rbp
  802f78:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802f7c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802f80:	ba 01 00 00 00       	mov    $0x1,%edx
  802f85:	48 89 c6             	mov    %rax,%rsi
  802f88:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8d:	48 b8 47 1f 80 00 00 	movabs $0x801f47,%rax
  802f94:	00 00 00 
  802f97:	ff d0                	callq  *%rax
  802f99:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802f9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa0:	79 05                	jns    802fa7 <getchar+0x33>
		return r;
  802fa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa5:	eb 14                	jmp    802fbb <getchar+0x47>
	if (r < 1)
  802fa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fab:	7f 07                	jg     802fb4 <getchar+0x40>
		return -E_EOF;
  802fad:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802fb2:	eb 07                	jmp    802fbb <getchar+0x47>
	return c;
  802fb4:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802fb8:	0f b6 c0             	movzbl %al,%eax
}
  802fbb:	c9                   	leaveq 
  802fbc:	c3                   	retq   

0000000000802fbd <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802fbd:	55                   	push   %rbp
  802fbe:	48 89 e5             	mov    %rsp,%rbp
  802fc1:	48 83 ec 20          	sub    $0x20,%rsp
  802fc5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fcc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fcf:	48 89 d6             	mov    %rdx,%rsi
  802fd2:	89 c7                	mov    %eax,%edi
  802fd4:	48 b8 15 1b 80 00 00 	movabs $0x801b15,%rax
  802fdb:	00 00 00 
  802fde:	ff d0                	callq  *%rax
  802fe0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe7:	79 05                	jns    802fee <iscons+0x31>
		return r;
  802fe9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fec:	eb 1a                	jmp    803008 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802fee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff2:	8b 10                	mov    (%rax),%edx
  802ff4:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  802ffb:	00 00 00 
  802ffe:	8b 00                	mov    (%rax),%eax
  803000:	39 c2                	cmp    %eax,%edx
  803002:	0f 94 c0             	sete   %al
  803005:	0f b6 c0             	movzbl %al,%eax
}
  803008:	c9                   	leaveq 
  803009:	c3                   	retq   

000000000080300a <opencons>:

int
opencons(void)
{
  80300a:	55                   	push   %rbp
  80300b:	48 89 e5             	mov    %rsp,%rbp
  80300e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803012:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803016:	48 89 c7             	mov    %rax,%rdi
  803019:	48 b8 7d 1a 80 00 00 	movabs $0x801a7d,%rax
  803020:	00 00 00 
  803023:	ff d0                	callq  *%rax
  803025:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803028:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80302c:	79 05                	jns    803033 <opencons+0x29>
		return r;
  80302e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803031:	eb 5b                	jmp    80308e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803037:	ba 07 04 00 00       	mov    $0x407,%edx
  80303c:	48 89 c6             	mov    %rax,%rsi
  80303f:	bf 00 00 00 00       	mov    $0x0,%edi
  803044:	48 b8 c2 17 80 00 00 	movabs $0x8017c2,%rax
  80304b:	00 00 00 
  80304e:	ff d0                	callq  *%rax
  803050:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803053:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803057:	79 05                	jns    80305e <opencons+0x54>
		return r;
  803059:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305c:	eb 30                	jmp    80308e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80305e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803062:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803069:	00 00 00 
  80306c:	8b 12                	mov    (%rdx),%edx
  80306e:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803070:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803074:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80307b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80307f:	48 89 c7             	mov    %rax,%rdi
  803082:	48 b8 2f 1a 80 00 00 	movabs $0x801a2f,%rax
  803089:	00 00 00 
  80308c:	ff d0                	callq  *%rax
}
  80308e:	c9                   	leaveq 
  80308f:	c3                   	retq   

0000000000803090 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803090:	55                   	push   %rbp
  803091:	48 89 e5             	mov    %rsp,%rbp
  803094:	48 83 ec 30          	sub    $0x30,%rsp
  803098:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80309c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8030a4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8030a9:	75 07                	jne    8030b2 <devcons_read+0x22>
		return 0;
  8030ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b0:	eb 4b                	jmp    8030fd <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8030b2:	eb 0c                	jmp    8030c0 <devcons_read+0x30>
		sys_yield();
  8030b4:	48 b8 84 17 80 00 00 	movabs $0x801784,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8030c0:	48 b8 c4 16 80 00 00 	movabs $0x8016c4,%rax
  8030c7:	00 00 00 
  8030ca:	ff d0                	callq  *%rax
  8030cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d3:	74 df                	je     8030b4 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8030d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d9:	79 05                	jns    8030e0 <devcons_read+0x50>
		return c;
  8030db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030de:	eb 1d                	jmp    8030fd <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8030e0:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8030e4:	75 07                	jne    8030ed <devcons_read+0x5d>
		return 0;
  8030e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030eb:	eb 10                	jmp    8030fd <devcons_read+0x6d>
	*(char*)vbuf = c;
  8030ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f0:	89 c2                	mov    %eax,%edx
  8030f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f6:	88 10                	mov    %dl,(%rax)
	return 1;
  8030f8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8030fd:	c9                   	leaveq 
  8030fe:	c3                   	retq   

00000000008030ff <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8030ff:	55                   	push   %rbp
  803100:	48 89 e5             	mov    %rsp,%rbp
  803103:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80310a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803111:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803118:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80311f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803126:	eb 76                	jmp    80319e <devcons_write+0x9f>
		m = n - tot;
  803128:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80312f:	89 c2                	mov    %eax,%edx
  803131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803134:	29 c2                	sub    %eax,%edx
  803136:	89 d0                	mov    %edx,%eax
  803138:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80313b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80313e:	83 f8 7f             	cmp    $0x7f,%eax
  803141:	76 07                	jbe    80314a <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803143:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80314a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80314d:	48 63 d0             	movslq %eax,%rdx
  803150:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803153:	48 63 c8             	movslq %eax,%rcx
  803156:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80315d:	48 01 c1             	add    %rax,%rcx
  803160:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803167:	48 89 ce             	mov    %rcx,%rsi
  80316a:	48 89 c7             	mov    %rax,%rdi
  80316d:	48 b8 b7 11 80 00 00 	movabs $0x8011b7,%rax
  803174:	00 00 00 
  803177:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803179:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80317c:	48 63 d0             	movslq %eax,%rdx
  80317f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803186:	48 89 d6             	mov    %rdx,%rsi
  803189:	48 89 c7             	mov    %rax,%rdi
  80318c:	48 b8 7a 16 80 00 00 	movabs $0x80167a,%rax
  803193:	00 00 00 
  803196:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803198:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80319b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80319e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a1:	48 98                	cltq   
  8031a3:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8031aa:	0f 82 78 ff ff ff    	jb     803128 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8031b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8031b3:	c9                   	leaveq 
  8031b4:	c3                   	retq   

00000000008031b5 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8031b5:	55                   	push   %rbp
  8031b6:	48 89 e5             	mov    %rsp,%rbp
  8031b9:	48 83 ec 08          	sub    $0x8,%rsp
  8031bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8031c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031c6:	c9                   	leaveq 
  8031c7:	c3                   	retq   

00000000008031c8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8031c8:	55                   	push   %rbp
  8031c9:	48 89 e5             	mov    %rsp,%rbp
  8031cc:	48 83 ec 10          	sub    $0x10,%rsp
  8031d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8031d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8031d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031dc:	48 be f3 3b 80 00 00 	movabs $0x803bf3,%rsi
  8031e3:	00 00 00 
  8031e6:	48 89 c7             	mov    %rax,%rdi
  8031e9:	48 b8 93 0e 80 00 00 	movabs $0x800e93,%rax
  8031f0:	00 00 00 
  8031f3:	ff d0                	callq  *%rax
	return 0;
  8031f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031fa:	c9                   	leaveq 
  8031fb:	c3                   	retq   

00000000008031fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8031fc:	55                   	push   %rbp
  8031fd:	48 89 e5             	mov    %rsp,%rbp
  803200:	53                   	push   %rbx
  803201:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803208:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80320f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803215:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80321c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803223:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80322a:	84 c0                	test   %al,%al
  80322c:	74 23                	je     803251 <_panic+0x55>
  80322e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803235:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803239:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80323d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803241:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803245:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803249:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80324d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803251:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803258:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80325f:	00 00 00 
  803262:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803269:	00 00 00 
  80326c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803270:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803277:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80327e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803285:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80328c:	00 00 00 
  80328f:	48 8b 18             	mov    (%rax),%rbx
  803292:	48 b8 46 17 80 00 00 	movabs $0x801746,%rax
  803299:	00 00 00 
  80329c:	ff d0                	callq  *%rax
  80329e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8032a4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8032ab:	41 89 c8             	mov    %ecx,%r8d
  8032ae:	48 89 d1             	mov    %rdx,%rcx
  8032b1:	48 89 da             	mov    %rbx,%rdx
  8032b4:	89 c6                	mov    %eax,%esi
  8032b6:	48 bf 00 3c 80 00 00 	movabs $0x803c00,%rdi
  8032bd:	00 00 00 
  8032c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c5:	49 b9 de 02 80 00 00 	movabs $0x8002de,%r9
  8032cc:	00 00 00 
  8032cf:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8032d2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8032d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8032e0:	48 89 d6             	mov    %rdx,%rsi
  8032e3:	48 89 c7             	mov    %rax,%rdi
  8032e6:	48 b8 32 02 80 00 00 	movabs $0x800232,%rax
  8032ed:	00 00 00 
  8032f0:	ff d0                	callq  *%rax
	cprintf("\n");
  8032f2:	48 bf 23 3c 80 00 00 	movabs $0x803c23,%rdi
  8032f9:	00 00 00 
  8032fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803301:	48 ba de 02 80 00 00 	movabs $0x8002de,%rdx
  803308:	00 00 00 
  80330b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80330d:	cc                   	int3   
  80330e:	eb fd                	jmp    80330d <_panic+0x111>

0000000000803310 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803310:	55                   	push   %rbp
  803311:	48 89 e5             	mov    %rsp,%rbp
  803314:	48 83 ec 30          	sub    $0x30,%rsp
  803318:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80331c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803320:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803324:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803329:	74 18                	je     803343 <ipc_recv+0x33>
  80332b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80332f:	48 89 c7             	mov    %rax,%rdi
  803332:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  803339:	00 00 00 
  80333c:	ff d0                	callq  *%rax
  80333e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803341:	eb 19                	jmp    80335c <ipc_recv+0x4c>
  803343:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  80334a:	00 00 00 
  80334d:	48 b8 eb 19 80 00 00 	movabs $0x8019eb,%rax
  803354:	00 00 00 
  803357:	ff d0                	callq  *%rax
  803359:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  80335c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803361:	74 26                	je     803389 <ipc_recv+0x79>
  803363:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803367:	75 15                	jne    80337e <ipc_recv+0x6e>
  803369:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803370:	00 00 00 
  803373:	48 8b 00             	mov    (%rax),%rax
  803376:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  80337c:	eb 05                	jmp    803383 <ipc_recv+0x73>
  80337e:	b8 00 00 00 00       	mov    $0x0,%eax
  803383:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803387:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803389:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80338e:	74 26                	je     8033b6 <ipc_recv+0xa6>
  803390:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803394:	75 15                	jne    8033ab <ipc_recv+0x9b>
  803396:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80339d:	00 00 00 
  8033a0:	48 8b 00             	mov    (%rax),%rax
  8033a3:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  8033a9:	eb 05                	jmp    8033b0 <ipc_recv+0xa0>
  8033ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8033b4:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  8033b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ba:	75 15                	jne    8033d1 <ipc_recv+0xc1>
  8033bc:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8033c3:	00 00 00 
  8033c6:	48 8b 00             	mov    (%rax),%rax
  8033c9:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8033cf:	eb 03                	jmp    8033d4 <ipc_recv+0xc4>
  8033d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033d4:	c9                   	leaveq 
  8033d5:	c3                   	retq   

00000000008033d6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8033d6:	55                   	push   %rbp
  8033d7:	48 89 e5             	mov    %rsp,%rbp
  8033da:	48 83 ec 30          	sub    $0x30,%rsp
  8033de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8033e1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8033e4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8033e8:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  8033eb:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  8033f2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8033f7:	75 10                	jne    803409 <ipc_send+0x33>
  8033f9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803400:	00 00 00 
  803403:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803407:	eb 62                	jmp    80346b <ipc_send+0x95>
  803409:	eb 60                	jmp    80346b <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  80340b:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80340f:	74 30                	je     803441 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803411:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803414:	89 c1                	mov    %eax,%ecx
  803416:	48 ba 25 3c 80 00 00 	movabs $0x803c25,%rdx
  80341d:	00 00 00 
  803420:	be 33 00 00 00       	mov    $0x33,%esi
  803425:	48 bf 41 3c 80 00 00 	movabs $0x803c41,%rdi
  80342c:	00 00 00 
  80342f:	b8 00 00 00 00       	mov    $0x0,%eax
  803434:	49 b8 fc 31 80 00 00 	movabs $0x8031fc,%r8
  80343b:	00 00 00 
  80343e:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803441:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803444:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803447:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80344b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80344e:	89 c7                	mov    %eax,%edi
  803450:	48 b8 96 19 80 00 00 	movabs $0x801996,%rax
  803457:	00 00 00 
  80345a:	ff d0                	callq  *%rax
  80345c:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  80345f:	48 b8 84 17 80 00 00 	movabs $0x801784,%rax
  803466:	00 00 00 
  803469:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  80346b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80346f:	75 9a                	jne    80340b <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803471:	c9                   	leaveq 
  803472:	c3                   	retq   

0000000000803473 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803473:	55                   	push   %rbp
  803474:	48 89 e5             	mov    %rsp,%rbp
  803477:	48 83 ec 14          	sub    $0x14,%rsp
  80347b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  80347e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803485:	eb 5e                	jmp    8034e5 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803487:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80348e:	00 00 00 
  803491:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803494:	48 63 d0             	movslq %eax,%rdx
  803497:	48 89 d0             	mov    %rdx,%rax
  80349a:	48 c1 e0 03          	shl    $0x3,%rax
  80349e:	48 01 d0             	add    %rdx,%rax
  8034a1:	48 c1 e0 05          	shl    $0x5,%rax
  8034a5:	48 01 c8             	add    %rcx,%rax
  8034a8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8034ae:	8b 00                	mov    (%rax),%eax
  8034b0:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8034b3:	75 2c                	jne    8034e1 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8034b5:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8034bc:	00 00 00 
  8034bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c2:	48 63 d0             	movslq %eax,%rdx
  8034c5:	48 89 d0             	mov    %rdx,%rax
  8034c8:	48 c1 e0 03          	shl    $0x3,%rax
  8034cc:	48 01 d0             	add    %rdx,%rax
  8034cf:	48 c1 e0 05          	shl    $0x5,%rax
  8034d3:	48 01 c8             	add    %rcx,%rax
  8034d6:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8034dc:	8b 40 08             	mov    0x8(%rax),%eax
  8034df:	eb 12                	jmp    8034f3 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8034e1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8034e5:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8034ec:	7e 99                	jle    803487 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8034ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034f3:	c9                   	leaveq 
  8034f4:	c3                   	retq   

00000000008034f5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8034f5:	55                   	push   %rbp
  8034f6:	48 89 e5             	mov    %rsp,%rbp
  8034f9:	48 83 ec 18          	sub    $0x18,%rsp
  8034fd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803501:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803505:	48 c1 e8 15          	shr    $0x15,%rax
  803509:	48 89 c2             	mov    %rax,%rdx
  80350c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803513:	01 00 00 
  803516:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80351a:	83 e0 01             	and    $0x1,%eax
  80351d:	48 85 c0             	test   %rax,%rax
  803520:	75 07                	jne    803529 <pageref+0x34>
		return 0;
  803522:	b8 00 00 00 00       	mov    $0x0,%eax
  803527:	eb 53                	jmp    80357c <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803529:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352d:	48 c1 e8 0c          	shr    $0xc,%rax
  803531:	48 89 c2             	mov    %rax,%rdx
  803534:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80353b:	01 00 00 
  80353e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803542:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803546:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80354a:	83 e0 01             	and    $0x1,%eax
  80354d:	48 85 c0             	test   %rax,%rax
  803550:	75 07                	jne    803559 <pageref+0x64>
		return 0;
  803552:	b8 00 00 00 00       	mov    $0x0,%eax
  803557:	eb 23                	jmp    80357c <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355d:	48 c1 e8 0c          	shr    $0xc,%rax
  803561:	48 89 c2             	mov    %rax,%rdx
  803564:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80356b:	00 00 00 
  80356e:	48 c1 e2 04          	shl    $0x4,%rdx
  803572:	48 01 d0             	add    %rdx,%rax
  803575:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803579:	0f b7 c0             	movzwl %ax,%eax
}
  80357c:	c9                   	leaveq 
  80357d:	c3                   	retq   
