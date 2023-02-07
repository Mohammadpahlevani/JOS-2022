
obj/user/fairness:     file format elf64-x86-64


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
  80003c:	e8 dd 00 00 00       	callq  80011e <libmain>
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
	envid_t who, id;

	id = sys_getenvid();
  800052:	48 b8 5e 17 80 00 00 	movabs $0x80175e,%rax
  800059:	00 00 00 
  80005c:	ff d0                	callq  *%rax
  80005e:	89 45 fc             	mov    %eax,-0x4(%rbp)

	if (thisenv == &envs[1]) {
  800061:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800068:	00 00 00 
  80006b:	48 8b 10             	mov    (%rax),%rdx
  80006e:	48 b8 20 01 80 00 80 	movabs $0x8000800120,%rax
  800075:	00 00 00 
  800078:	48 39 c2             	cmp    %rax,%rdx
  80007b:	75 42                	jne    8000bf <umain+0x7c>
		while (1) {
			ipc_recv(&who, 0, 0);
  80007d:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
  800081:	ba 00 00 00 00       	mov    $0x0,%edx
  800086:	be 00 00 00 00       	mov    $0x0,%esi
  80008b:	48 89 c7             	mov    %rax,%rdi
  80008e:	48 b8 47 1a 80 00 00 	movabs $0x801a47,%rax
  800095:	00 00 00 
  800098:	ff d0                	callq  *%rax
			cprintf("%x recv from %x\n", id, who);
  80009a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80009d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a0:	89 c6                	mov    %eax,%esi
  8000a2:	48 bf a0 35 80 00 00 	movabs $0x8035a0,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  8000b8:	00 00 00 
  8000bb:	ff d1                	callq  *%rcx
		}
  8000bd:	eb be                	jmp    80007d <umain+0x3a>
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  8000bf:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000c6:	00 00 00 
  8000c9:	8b 90 e8 01 00 00    	mov    0x1e8(%rax),%edx
  8000cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d2:	89 c6                	mov    %eax,%esi
  8000d4:	48 bf b1 35 80 00 00 	movabs $0x8035b1,%rdi
  8000db:	00 00 00 
  8000de:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e3:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  8000ea:	00 00 00 
  8000ed:	ff d1                	callq  *%rcx
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  8000ef:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000f6:	00 00 00 
  8000f9:	8b 80 e8 01 00 00    	mov    0x1e8(%rax),%eax
  8000ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800104:	ba 00 00 00 00       	mov    $0x0,%edx
  800109:	be 00 00 00 00       	mov    $0x0,%esi
  80010e:	89 c7                	mov    %eax,%edi
  800110:	48 b8 0d 1b 80 00 00 	movabs $0x801b0d,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
  80011c:	eb d1                	jmp    8000ef <umain+0xac>

000000000080011e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80011e:	55                   	push   %rbp
  80011f:	48 89 e5             	mov    %rsp,%rbp
  800122:	48 83 ec 10          	sub    $0x10,%rsp
  800126:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800129:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  80012d:	48 b8 5e 17 80 00 00 	movabs $0x80175e,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	48 98                	cltq   
  80013b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800140:	48 89 c2             	mov    %rax,%rdx
  800143:	48 89 d0             	mov    %rdx,%rax
  800146:	48 c1 e0 03          	shl    $0x3,%rax
  80014a:	48 01 d0             	add    %rdx,%rax
  80014d:	48 c1 e0 05          	shl    $0x5,%rax
  800151:	48 89 c2             	mov    %rax,%rdx
  800154:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80015b:	00 00 00 
  80015e:	48 01 c2             	add    %rax,%rdx
  800161:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800168:	00 00 00 
  80016b:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800172:	7e 14                	jle    800188 <libmain+0x6a>
		binaryname = argv[0];
  800174:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800178:	48 8b 10             	mov    (%rax),%rdx
  80017b:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800182:	00 00 00 
  800185:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800188:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80018c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018f:	48 89 d6             	mov    %rdx,%rsi
  800192:	89 c7                	mov    %eax,%edi
  800194:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80019b:	00 00 00 
  80019e:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001a0:	48 b8 ae 01 80 00 00 	movabs $0x8001ae,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
}
  8001ac:	c9                   	leaveq 
  8001ad:	c3                   	retq   

00000000008001ae <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ae:	55                   	push   %rbp
  8001af:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001b2:	48 b8 6d 1f 80 00 00 	movabs $0x801f6d,%rax
  8001b9:	00 00 00 
  8001bc:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001be:	bf 00 00 00 00       	mov    $0x0,%edi
  8001c3:	48 b8 1a 17 80 00 00 	movabs $0x80171a,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
}
  8001cf:	5d                   	pop    %rbp
  8001d0:	c3                   	retq   

00000000008001d1 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001d1:	55                   	push   %rbp
  8001d2:	48 89 e5             	mov    %rsp,%rbp
  8001d5:	48 83 ec 10          	sub    $0x10,%rsp
  8001d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8001e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e4:	8b 00                	mov    (%rax),%eax
  8001e6:	8d 48 01             	lea    0x1(%rax),%ecx
  8001e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ed:	89 0a                	mov    %ecx,(%rdx)
  8001ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8001f2:	89 d1                	mov    %edx,%ecx
  8001f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001f8:	48 98                	cltq   
  8001fa:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8001fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800202:	8b 00                	mov    (%rax),%eax
  800204:	3d ff 00 00 00       	cmp    $0xff,%eax
  800209:	75 2c                	jne    800237 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80020b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020f:	8b 00                	mov    (%rax),%eax
  800211:	48 98                	cltq   
  800213:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800217:	48 83 c2 08          	add    $0x8,%rdx
  80021b:	48 89 c6             	mov    %rax,%rsi
  80021e:	48 89 d7             	mov    %rdx,%rdi
  800221:	48 b8 92 16 80 00 00 	movabs $0x801692,%rax
  800228:	00 00 00 
  80022b:	ff d0                	callq  *%rax
        b->idx = 0;
  80022d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800231:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80023b:	8b 40 04             	mov    0x4(%rax),%eax
  80023e:	8d 50 01             	lea    0x1(%rax),%edx
  800241:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800245:	89 50 04             	mov    %edx,0x4(%rax)
}
  800248:	c9                   	leaveq 
  800249:	c3                   	retq   

000000000080024a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80024a:	55                   	push   %rbp
  80024b:	48 89 e5             	mov    %rsp,%rbp
  80024e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800255:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80025c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800263:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80026a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800271:	48 8b 0a             	mov    (%rdx),%rcx
  800274:	48 89 08             	mov    %rcx,(%rax)
  800277:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80027b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80027f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800283:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800287:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80028e:	00 00 00 
    b.cnt = 0;
  800291:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800298:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80029b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002a2:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002a9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002b0:	48 89 c6             	mov    %rax,%rsi
  8002b3:	48 bf d1 01 80 00 00 	movabs $0x8001d1,%rdi
  8002ba:	00 00 00 
  8002bd:	48 b8 a9 06 80 00 00 	movabs $0x8006a9,%rax
  8002c4:	00 00 00 
  8002c7:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002c9:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002cf:	48 98                	cltq   
  8002d1:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8002d8:	48 83 c2 08          	add    $0x8,%rdx
  8002dc:	48 89 c6             	mov    %rax,%rsi
  8002df:	48 89 d7             	mov    %rdx,%rdi
  8002e2:	48 b8 92 16 80 00 00 	movabs $0x801692,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8002ee:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8002f4:	c9                   	leaveq 
  8002f5:	c3                   	retq   

00000000008002f6 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8002f6:	55                   	push   %rbp
  8002f7:	48 89 e5             	mov    %rsp,%rbp
  8002fa:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800301:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800308:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80030f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800316:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80031d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800324:	84 c0                	test   %al,%al
  800326:	74 20                	je     800348 <cprintf+0x52>
  800328:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80032c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800330:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800334:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800338:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80033c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800340:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800344:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800348:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80034f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800356:	00 00 00 
  800359:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800360:	00 00 00 
  800363:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800367:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80036e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800375:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80037c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800383:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80038a:	48 8b 0a             	mov    (%rdx),%rcx
  80038d:	48 89 08             	mov    %rcx,(%rax)
  800390:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800394:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800398:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80039c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003a0:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003a7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003ae:	48 89 d6             	mov    %rdx,%rsi
  8003b1:	48 89 c7             	mov    %rax,%rdi
  8003b4:	48 b8 4a 02 80 00 00 	movabs $0x80024a,%rax
  8003bb:	00 00 00 
  8003be:	ff d0                	callq  *%rax
  8003c0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003c6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003cc:	c9                   	leaveq 
  8003cd:	c3                   	retq   

00000000008003ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ce:	55                   	push   %rbp
  8003cf:	48 89 e5             	mov    %rsp,%rbp
  8003d2:	53                   	push   %rbx
  8003d3:	48 83 ec 38          	sub    $0x38,%rsp
  8003d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8003db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8003df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8003e3:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8003e6:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8003ea:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ee:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8003f1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8003f5:	77 3b                	ja     800432 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f7:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8003fa:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8003fe:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800401:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800405:	ba 00 00 00 00       	mov    $0x0,%edx
  80040a:	48 f7 f3             	div    %rbx
  80040d:	48 89 c2             	mov    %rax,%rdx
  800410:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800413:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800416:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80041a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80041e:	41 89 f9             	mov    %edi,%r9d
  800421:	48 89 c7             	mov    %rax,%rdi
  800424:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  80042b:	00 00 00 
  80042e:	ff d0                	callq  *%rax
  800430:	eb 1e                	jmp    800450 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800432:	eb 12                	jmp    800446 <printnum+0x78>
			putch(padc, putdat);
  800434:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800438:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80043b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80043f:	48 89 ce             	mov    %rcx,%rsi
  800442:	89 d7                	mov    %edx,%edi
  800444:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800446:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80044a:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80044e:	7f e4                	jg     800434 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800450:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800457:	ba 00 00 00 00       	mov    $0x0,%edx
  80045c:	48 f7 f1             	div    %rcx
  80045f:	48 89 d0             	mov    %rdx,%rax
  800462:	48 ba d0 37 80 00 00 	movabs $0x8037d0,%rdx
  800469:	00 00 00 
  80046c:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800470:	0f be d0             	movsbl %al,%edx
  800473:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800477:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80047b:	48 89 ce             	mov    %rcx,%rsi
  80047e:	89 d7                	mov    %edx,%edi
  800480:	ff d0                	callq  *%rax
}
  800482:	48 83 c4 38          	add    $0x38,%rsp
  800486:	5b                   	pop    %rbx
  800487:	5d                   	pop    %rbp
  800488:	c3                   	retq   

0000000000800489 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800489:	55                   	push   %rbp
  80048a:	48 89 e5             	mov    %rsp,%rbp
  80048d:	48 83 ec 1c          	sub    $0x1c,%rsp
  800491:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800495:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800498:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80049c:	7e 52                	jle    8004f0 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80049e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a2:	8b 00                	mov    (%rax),%eax
  8004a4:	83 f8 30             	cmp    $0x30,%eax
  8004a7:	73 24                	jae    8004cd <getuint+0x44>
  8004a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ad:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004b5:	8b 00                	mov    (%rax),%eax
  8004b7:	89 c0                	mov    %eax,%eax
  8004b9:	48 01 d0             	add    %rdx,%rax
  8004bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c0:	8b 12                	mov    (%rdx),%edx
  8004c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004c5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004c9:	89 0a                	mov    %ecx,(%rdx)
  8004cb:	eb 17                	jmp    8004e4 <getuint+0x5b>
  8004cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004d5:	48 89 d0             	mov    %rdx,%rax
  8004d8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8004dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8004e4:	48 8b 00             	mov    (%rax),%rax
  8004e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8004eb:	e9 a3 00 00 00       	jmpq   800593 <getuint+0x10a>
	else if (lflag)
  8004f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8004f4:	74 4f                	je     800545 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8004f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fa:	8b 00                	mov    (%rax),%eax
  8004fc:	83 f8 30             	cmp    $0x30,%eax
  8004ff:	73 24                	jae    800525 <getuint+0x9c>
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
  800523:	eb 17                	jmp    80053c <getuint+0xb3>
  800525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800529:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80052d:	48 89 d0             	mov    %rdx,%rax
  800530:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800534:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800538:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80053c:	48 8b 00             	mov    (%rax),%rax
  80053f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800543:	eb 4e                	jmp    800593 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800549:	8b 00                	mov    (%rax),%eax
  80054b:	83 f8 30             	cmp    $0x30,%eax
  80054e:	73 24                	jae    800574 <getuint+0xeb>
  800550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800554:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055c:	8b 00                	mov    (%rax),%eax
  80055e:	89 c0                	mov    %eax,%eax
  800560:	48 01 d0             	add    %rdx,%rax
  800563:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800567:	8b 12                	mov    (%rdx),%edx
  800569:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80056c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800570:	89 0a                	mov    %ecx,(%rdx)
  800572:	eb 17                	jmp    80058b <getuint+0x102>
  800574:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800578:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80057c:	48 89 d0             	mov    %rdx,%rax
  80057f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800583:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800587:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80058b:	8b 00                	mov    (%rax),%eax
  80058d:	89 c0                	mov    %eax,%eax
  80058f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800597:	c9                   	leaveq 
  800598:	c3                   	retq   

0000000000800599 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800599:	55                   	push   %rbp
  80059a:	48 89 e5             	mov    %rsp,%rbp
  80059d:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005a5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005a8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005ac:	7e 52                	jle    800600 <getint+0x67>
		x=va_arg(*ap, long long);
  8005ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b2:	8b 00                	mov    (%rax),%eax
  8005b4:	83 f8 30             	cmp    $0x30,%eax
  8005b7:	73 24                	jae    8005dd <getint+0x44>
  8005b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c5:	8b 00                	mov    (%rax),%eax
  8005c7:	89 c0                	mov    %eax,%eax
  8005c9:	48 01 d0             	add    %rdx,%rax
  8005cc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d0:	8b 12                	mov    (%rdx),%edx
  8005d2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005d9:	89 0a                	mov    %ecx,(%rdx)
  8005db:	eb 17                	jmp    8005f4 <getint+0x5b>
  8005dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005e5:	48 89 d0             	mov    %rdx,%rax
  8005e8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005f4:	48 8b 00             	mov    (%rax),%rax
  8005f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005fb:	e9 a3 00 00 00       	jmpq   8006a3 <getint+0x10a>
	else if (lflag)
  800600:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800604:	74 4f                	je     800655 <getint+0xbc>
		x=va_arg(*ap, long);
  800606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060a:	8b 00                	mov    (%rax),%eax
  80060c:	83 f8 30             	cmp    $0x30,%eax
  80060f:	73 24                	jae    800635 <getint+0x9c>
  800611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800615:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061d:	8b 00                	mov    (%rax),%eax
  80061f:	89 c0                	mov    %eax,%eax
  800621:	48 01 d0             	add    %rdx,%rax
  800624:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800628:	8b 12                	mov    (%rdx),%edx
  80062a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80062d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800631:	89 0a                	mov    %ecx,(%rdx)
  800633:	eb 17                	jmp    80064c <getint+0xb3>
  800635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800639:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80063d:	48 89 d0             	mov    %rdx,%rax
  800640:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800644:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800648:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80064c:	48 8b 00             	mov    (%rax),%rax
  80064f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800653:	eb 4e                	jmp    8006a3 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	8b 00                	mov    (%rax),%eax
  80065b:	83 f8 30             	cmp    $0x30,%eax
  80065e:	73 24                	jae    800684 <getint+0xeb>
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800668:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066c:	8b 00                	mov    (%rax),%eax
  80066e:	89 c0                	mov    %eax,%eax
  800670:	48 01 d0             	add    %rdx,%rax
  800673:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800677:	8b 12                	mov    (%rdx),%edx
  800679:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80067c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800680:	89 0a                	mov    %ecx,(%rdx)
  800682:	eb 17                	jmp    80069b <getint+0x102>
  800684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800688:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80068c:	48 89 d0             	mov    %rdx,%rax
  80068f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800697:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80069b:	8b 00                	mov    (%rax),%eax
  80069d:	48 98                	cltq   
  80069f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006a7:	c9                   	leaveq 
  8006a8:	c3                   	retq   

00000000008006a9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006a9:	55                   	push   %rbp
  8006aa:	48 89 e5             	mov    %rsp,%rbp
  8006ad:	41 54                	push   %r12
  8006af:	53                   	push   %rbx
  8006b0:	48 83 ec 60          	sub    $0x60,%rsp
  8006b4:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006b8:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006bc:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006c0:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006c4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006c8:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006cc:	48 8b 0a             	mov    (%rdx),%rcx
  8006cf:	48 89 08             	mov    %rcx,(%rax)
  8006d2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006d6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006da:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006de:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e2:	eb 17                	jmp    8006fb <vprintfmt+0x52>
			if (ch == '\0')
  8006e4:	85 db                	test   %ebx,%ebx
  8006e6:	0f 84 cc 04 00 00    	je     800bb8 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8006ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8006f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8006f4:	48 89 d6             	mov    %rdx,%rsi
  8006f7:	89 df                	mov    %ebx,%edi
  8006f9:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8006ff:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800703:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800707:	0f b6 00             	movzbl (%rax),%eax
  80070a:	0f b6 d8             	movzbl %al,%ebx
  80070d:	83 fb 25             	cmp    $0x25,%ebx
  800710:	75 d2                	jne    8006e4 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800712:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800716:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80071d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800724:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80072b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800732:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800736:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80073a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80073e:	0f b6 00             	movzbl (%rax),%eax
  800741:	0f b6 d8             	movzbl %al,%ebx
  800744:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800747:	83 f8 55             	cmp    $0x55,%eax
  80074a:	0f 87 34 04 00 00    	ja     800b84 <vprintfmt+0x4db>
  800750:	89 c0                	mov    %eax,%eax
  800752:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800759:	00 
  80075a:	48 b8 f8 37 80 00 00 	movabs $0x8037f8,%rax
  800761:	00 00 00 
  800764:	48 01 d0             	add    %rdx,%rax
  800767:	48 8b 00             	mov    (%rax),%rax
  80076a:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80076c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800770:	eb c0                	jmp    800732 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800772:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800776:	eb ba                	jmp    800732 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800778:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80077f:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800782:	89 d0                	mov    %edx,%eax
  800784:	c1 e0 02             	shl    $0x2,%eax
  800787:	01 d0                	add    %edx,%eax
  800789:	01 c0                	add    %eax,%eax
  80078b:	01 d8                	add    %ebx,%eax
  80078d:	83 e8 30             	sub    $0x30,%eax
  800790:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800793:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800797:	0f b6 00             	movzbl (%rax),%eax
  80079a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80079d:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a0:	7e 0c                	jle    8007ae <vprintfmt+0x105>
  8007a2:	83 fb 39             	cmp    $0x39,%ebx
  8007a5:	7f 07                	jg     8007ae <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a7:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ac:	eb d1                	jmp    80077f <vprintfmt+0xd6>
			goto process_precision;
  8007ae:	eb 58                	jmp    800808 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007b3:	83 f8 30             	cmp    $0x30,%eax
  8007b6:	73 17                	jae    8007cf <vprintfmt+0x126>
  8007b8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007bc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007bf:	89 c0                	mov    %eax,%eax
  8007c1:	48 01 d0             	add    %rdx,%rax
  8007c4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007c7:	83 c2 08             	add    $0x8,%edx
  8007ca:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007cd:	eb 0f                	jmp    8007de <vprintfmt+0x135>
  8007cf:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007d3:	48 89 d0             	mov    %rdx,%rax
  8007d6:	48 83 c2 08          	add    $0x8,%rdx
  8007da:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8007de:	8b 00                	mov    (%rax),%eax
  8007e0:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8007e3:	eb 23                	jmp    800808 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8007e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8007e9:	79 0c                	jns    8007f7 <vprintfmt+0x14e>
				width = 0;
  8007eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8007f2:	e9 3b ff ff ff       	jmpq   800732 <vprintfmt+0x89>
  8007f7:	e9 36 ff ff ff       	jmpq   800732 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8007fc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800803:	e9 2a ff ff ff       	jmpq   800732 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800808:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80080c:	79 12                	jns    800820 <vprintfmt+0x177>
				width = precision, precision = -1;
  80080e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800811:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800814:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80081b:	e9 12 ff ff ff       	jmpq   800732 <vprintfmt+0x89>
  800820:	e9 0d ff ff ff       	jmpq   800732 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800825:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800829:	e9 04 ff ff ff       	jmpq   800732 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80082e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800831:	83 f8 30             	cmp    $0x30,%eax
  800834:	73 17                	jae    80084d <vprintfmt+0x1a4>
  800836:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80083a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80083d:	89 c0                	mov    %eax,%eax
  80083f:	48 01 d0             	add    %rdx,%rax
  800842:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800845:	83 c2 08             	add    $0x8,%edx
  800848:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80084b:	eb 0f                	jmp    80085c <vprintfmt+0x1b3>
  80084d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800851:	48 89 d0             	mov    %rdx,%rax
  800854:	48 83 c2 08          	add    $0x8,%rdx
  800858:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80085c:	8b 10                	mov    (%rax),%edx
  80085e:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800862:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800866:	48 89 ce             	mov    %rcx,%rsi
  800869:	89 d7                	mov    %edx,%edi
  80086b:	ff d0                	callq  *%rax
			break;
  80086d:	e9 40 03 00 00       	jmpq   800bb2 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800872:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800875:	83 f8 30             	cmp    $0x30,%eax
  800878:	73 17                	jae    800891 <vprintfmt+0x1e8>
  80087a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80087e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800881:	89 c0                	mov    %eax,%eax
  800883:	48 01 d0             	add    %rdx,%rax
  800886:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800889:	83 c2 08             	add    $0x8,%edx
  80088c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80088f:	eb 0f                	jmp    8008a0 <vprintfmt+0x1f7>
  800891:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800895:	48 89 d0             	mov    %rdx,%rax
  800898:	48 83 c2 08          	add    $0x8,%rdx
  80089c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008a0:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008a2:	85 db                	test   %ebx,%ebx
  8008a4:	79 02                	jns    8008a8 <vprintfmt+0x1ff>
				err = -err;
  8008a6:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008a8:	83 fb 15             	cmp    $0x15,%ebx
  8008ab:	7f 16                	jg     8008c3 <vprintfmt+0x21a>
  8008ad:	48 b8 20 37 80 00 00 	movabs $0x803720,%rax
  8008b4:	00 00 00 
  8008b7:	48 63 d3             	movslq %ebx,%rdx
  8008ba:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008be:	4d 85 e4             	test   %r12,%r12
  8008c1:	75 2e                	jne    8008f1 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008c3:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008cb:	89 d9                	mov    %ebx,%ecx
  8008cd:	48 ba e1 37 80 00 00 	movabs $0x8037e1,%rdx
  8008d4:	00 00 00 
  8008d7:	48 89 c7             	mov    %rax,%rdi
  8008da:	b8 00 00 00 00       	mov    $0x0,%eax
  8008df:	49 b8 c1 0b 80 00 00 	movabs $0x800bc1,%r8
  8008e6:	00 00 00 
  8008e9:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ec:	e9 c1 02 00 00       	jmpq   800bb2 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008f1:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f9:	4c 89 e1             	mov    %r12,%rcx
  8008fc:	48 ba ea 37 80 00 00 	movabs $0x8037ea,%rdx
  800903:	00 00 00 
  800906:	48 89 c7             	mov    %rax,%rdi
  800909:	b8 00 00 00 00       	mov    $0x0,%eax
  80090e:	49 b8 c1 0b 80 00 00 	movabs $0x800bc1,%r8
  800915:	00 00 00 
  800918:	41 ff d0             	callq  *%r8
			break;
  80091b:	e9 92 02 00 00       	jmpq   800bb2 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800920:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800923:	83 f8 30             	cmp    $0x30,%eax
  800926:	73 17                	jae    80093f <vprintfmt+0x296>
  800928:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80092c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80092f:	89 c0                	mov    %eax,%eax
  800931:	48 01 d0             	add    %rdx,%rax
  800934:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800937:	83 c2 08             	add    $0x8,%edx
  80093a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80093d:	eb 0f                	jmp    80094e <vprintfmt+0x2a5>
  80093f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800943:	48 89 d0             	mov    %rdx,%rax
  800946:	48 83 c2 08          	add    $0x8,%rdx
  80094a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80094e:	4c 8b 20             	mov    (%rax),%r12
  800951:	4d 85 e4             	test   %r12,%r12
  800954:	75 0a                	jne    800960 <vprintfmt+0x2b7>
				p = "(null)";
  800956:	49 bc ed 37 80 00 00 	movabs $0x8037ed,%r12
  80095d:	00 00 00 
			if (width > 0 && padc != '-')
  800960:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800964:	7e 3f                	jle    8009a5 <vprintfmt+0x2fc>
  800966:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80096a:	74 39                	je     8009a5 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80096c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80096f:	48 98                	cltq   
  800971:	48 89 c6             	mov    %rax,%rsi
  800974:	4c 89 e7             	mov    %r12,%rdi
  800977:	48 b8 6d 0e 80 00 00 	movabs $0x800e6d,%rax
  80097e:	00 00 00 
  800981:	ff d0                	callq  *%rax
  800983:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800986:	eb 17                	jmp    80099f <vprintfmt+0x2f6>
					putch(padc, putdat);
  800988:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80098c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800990:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800994:	48 89 ce             	mov    %rcx,%rsi
  800997:	89 d7                	mov    %edx,%edi
  800999:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80099f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009a3:	7f e3                	jg     800988 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a5:	eb 37                	jmp    8009de <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009ab:	74 1e                	je     8009cb <vprintfmt+0x322>
  8009ad:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b0:	7e 05                	jle    8009b7 <vprintfmt+0x30e>
  8009b2:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b5:	7e 14                	jle    8009cb <vprintfmt+0x322>
					putch('?', putdat);
  8009b7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009bb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009bf:	48 89 d6             	mov    %rdx,%rsi
  8009c2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009c7:	ff d0                	callq  *%rax
  8009c9:	eb 0f                	jmp    8009da <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009cb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d3:	48 89 d6             	mov    %rdx,%rsi
  8009d6:	89 df                	mov    %ebx,%edi
  8009d8:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009da:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009de:	4c 89 e0             	mov    %r12,%rax
  8009e1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8009e5:	0f b6 00             	movzbl (%rax),%eax
  8009e8:	0f be d8             	movsbl %al,%ebx
  8009eb:	85 db                	test   %ebx,%ebx
  8009ed:	74 10                	je     8009ff <vprintfmt+0x356>
  8009ef:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009f3:	78 b2                	js     8009a7 <vprintfmt+0x2fe>
  8009f5:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8009f9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8009fd:	79 a8                	jns    8009a7 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ff:	eb 16                	jmp    800a17 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a01:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a05:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a09:	48 89 d6             	mov    %rdx,%rsi
  800a0c:	bf 20 00 00 00       	mov    $0x20,%edi
  800a11:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a13:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a17:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a1b:	7f e4                	jg     800a01 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a1d:	e9 90 01 00 00       	jmpq   800bb2 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a22:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a26:	be 03 00 00 00       	mov    $0x3,%esi
  800a2b:	48 89 c7             	mov    %rax,%rdi
  800a2e:	48 b8 99 05 80 00 00 	movabs $0x800599,%rax
  800a35:	00 00 00 
  800a38:	ff d0                	callq  *%rax
  800a3a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a42:	48 85 c0             	test   %rax,%rax
  800a45:	79 1d                	jns    800a64 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a47:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4f:	48 89 d6             	mov    %rdx,%rsi
  800a52:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a57:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5d:	48 f7 d8             	neg    %rax
  800a60:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a64:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a6b:	e9 d5 00 00 00       	jmpq   800b45 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a74:	be 03 00 00 00       	mov    $0x3,%esi
  800a79:	48 89 c7             	mov    %rax,%rdi
  800a7c:	48 b8 89 04 80 00 00 	movabs $0x800489,%rax
  800a83:	00 00 00 
  800a86:	ff d0                	callq  *%rax
  800a88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800a8c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a93:	e9 ad 00 00 00       	jmpq   800b45 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800a98:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a9c:	be 03 00 00 00       	mov    $0x3,%esi
  800aa1:	48 89 c7             	mov    %rax,%rdi
  800aa4:	48 b8 89 04 80 00 00 	movabs $0x800489,%rax
  800aab:	00 00 00 
  800aae:	ff d0                	callq  *%rax
  800ab0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800ab4:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800abb:	e9 85 00 00 00       	jmpq   800b45 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800ac0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac8:	48 89 d6             	mov    %rdx,%rsi
  800acb:	bf 30 00 00 00       	mov    $0x30,%edi
  800ad0:	ff d0                	callq  *%rax
			putch('x', putdat);
  800ad2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ad6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ada:	48 89 d6             	mov    %rdx,%rsi
  800add:	bf 78 00 00 00       	mov    $0x78,%edi
  800ae2:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ae4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae7:	83 f8 30             	cmp    $0x30,%eax
  800aea:	73 17                	jae    800b03 <vprintfmt+0x45a>
  800aec:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800af0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af3:	89 c0                	mov    %eax,%eax
  800af5:	48 01 d0             	add    %rdx,%rax
  800af8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800afb:	83 c2 08             	add    $0x8,%edx
  800afe:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b01:	eb 0f                	jmp    800b12 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b03:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b07:	48 89 d0             	mov    %rdx,%rax
  800b0a:	48 83 c2 08          	add    $0x8,%rdx
  800b0e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b12:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b15:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b19:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b20:	eb 23                	jmp    800b45 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b22:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b26:	be 03 00 00 00       	mov    $0x3,%esi
  800b2b:	48 89 c7             	mov    %rax,%rdi
  800b2e:	48 b8 89 04 80 00 00 	movabs $0x800489,%rax
  800b35:	00 00 00 
  800b38:	ff d0                	callq  *%rax
  800b3a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b3e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b45:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b4a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b4d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b50:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b54:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b58:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5c:	45 89 c1             	mov    %r8d,%r9d
  800b5f:	41 89 f8             	mov    %edi,%r8d
  800b62:	48 89 c7             	mov    %rax,%rdi
  800b65:	48 b8 ce 03 80 00 00 	movabs $0x8003ce,%rax
  800b6c:	00 00 00 
  800b6f:	ff d0                	callq  *%rax
			break;
  800b71:	eb 3f                	jmp    800bb2 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b73:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b77:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7b:	48 89 d6             	mov    %rdx,%rsi
  800b7e:	89 df                	mov    %ebx,%edi
  800b80:	ff d0                	callq  *%rax
			break;
  800b82:	eb 2e                	jmp    800bb2 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b84:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8c:	48 89 d6             	mov    %rdx,%rsi
  800b8f:	bf 25 00 00 00       	mov    $0x25,%edi
  800b94:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b96:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800b9b:	eb 05                	jmp    800ba2 <vprintfmt+0x4f9>
  800b9d:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ba2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800ba6:	48 83 e8 01          	sub    $0x1,%rax
  800baa:	0f b6 00             	movzbl (%rax),%eax
  800bad:	3c 25                	cmp    $0x25,%al
  800baf:	75 ec                	jne    800b9d <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bb1:	90                   	nop
		}
	}
  800bb2:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb3:	e9 43 fb ff ff       	jmpq   8006fb <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bb8:	48 83 c4 60          	add    $0x60,%rsp
  800bbc:	5b                   	pop    %rbx
  800bbd:	41 5c                	pop    %r12
  800bbf:	5d                   	pop    %rbp
  800bc0:	c3                   	retq   

0000000000800bc1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc1:	55                   	push   %rbp
  800bc2:	48 89 e5             	mov    %rsp,%rbp
  800bc5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bcc:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bd3:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800bda:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800be1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800be8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800bef:	84 c0                	test   %al,%al
  800bf1:	74 20                	je     800c13 <printfmt+0x52>
  800bf3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800bf7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800bfb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800bff:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c03:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c07:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c0b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c0f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c13:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c1a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c21:	00 00 00 
  800c24:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c2b:	00 00 00 
  800c2e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c32:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c39:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c40:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c47:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c4e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c55:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c5c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c63:	48 89 c7             	mov    %rax,%rdi
  800c66:	48 b8 a9 06 80 00 00 	movabs $0x8006a9,%rax
  800c6d:	00 00 00 
  800c70:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c72:	c9                   	leaveq 
  800c73:	c3                   	retq   

0000000000800c74 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c74:	55                   	push   %rbp
  800c75:	48 89 e5             	mov    %rsp,%rbp
  800c78:	48 83 ec 10          	sub    $0x10,%rsp
  800c7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800c83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c87:	8b 40 10             	mov    0x10(%rax),%eax
  800c8a:	8d 50 01             	lea    0x1(%rax),%edx
  800c8d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c91:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800c94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c98:	48 8b 10             	mov    (%rax),%rdx
  800c9b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c9f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ca3:	48 39 c2             	cmp    %rax,%rdx
  800ca6:	73 17                	jae    800cbf <sprintputch+0x4b>
		*b->buf++ = ch;
  800ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cac:	48 8b 00             	mov    (%rax),%rax
  800caf:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cb3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cb7:	48 89 0a             	mov    %rcx,(%rdx)
  800cba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cbd:	88 10                	mov    %dl,(%rax)
}
  800cbf:	c9                   	leaveq 
  800cc0:	c3                   	retq   

0000000000800cc1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc1:	55                   	push   %rbp
  800cc2:	48 89 e5             	mov    %rsp,%rbp
  800cc5:	48 83 ec 50          	sub    $0x50,%rsp
  800cc9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800ccd:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cd0:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cd4:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800cd8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800cdc:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800ce0:	48 8b 0a             	mov    (%rdx),%rcx
  800ce3:	48 89 08             	mov    %rcx,(%rax)
  800ce6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cea:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cee:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cf2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cf6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cfa:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800cfe:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d01:	48 98                	cltq   
  800d03:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d07:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d0b:	48 01 d0             	add    %rdx,%rax
  800d0e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d19:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d1e:	74 06                	je     800d26 <vsnprintf+0x65>
  800d20:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d24:	7f 07                	jg     800d2d <vsnprintf+0x6c>
		return -E_INVAL;
  800d26:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d2b:	eb 2f                	jmp    800d5c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d2d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d31:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d35:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d39:	48 89 c6             	mov    %rax,%rsi
  800d3c:	48 bf 74 0c 80 00 00 	movabs $0x800c74,%rdi
  800d43:	00 00 00 
  800d46:	48 b8 a9 06 80 00 00 	movabs $0x8006a9,%rax
  800d4d:	00 00 00 
  800d50:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d56:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d59:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d5c:	c9                   	leaveq 
  800d5d:	c3                   	retq   

0000000000800d5e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d5e:	55                   	push   %rbp
  800d5f:	48 89 e5             	mov    %rsp,%rbp
  800d62:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d69:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d70:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d76:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d7d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d84:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d8b:	84 c0                	test   %al,%al
  800d8d:	74 20                	je     800daf <snprintf+0x51>
  800d8f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d93:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d97:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d9b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d9f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800da3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800da7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dab:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800daf:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800db6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800dbd:	00 00 00 
  800dc0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800dc7:	00 00 00 
  800dca:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dce:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dd5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ddc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800de3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dea:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800df1:	48 8b 0a             	mov    (%rdx),%rcx
  800df4:	48 89 08             	mov    %rcx,(%rax)
  800df7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dfb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dff:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e03:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e07:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e0e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e15:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e1b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e22:	48 89 c7             	mov    %rax,%rdi
  800e25:	48 b8 c1 0c 80 00 00 	movabs $0x800cc1,%rax
  800e2c:	00 00 00 
  800e2f:	ff d0                	callq  *%rax
  800e31:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e37:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e3d:	c9                   	leaveq 
  800e3e:	c3                   	retq   

0000000000800e3f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e3f:	55                   	push   %rbp
  800e40:	48 89 e5             	mov    %rsp,%rbp
  800e43:	48 83 ec 18          	sub    $0x18,%rsp
  800e47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e52:	eb 09                	jmp    800e5d <strlen+0x1e>
		n++;
  800e54:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e58:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e61:	0f b6 00             	movzbl (%rax),%eax
  800e64:	84 c0                	test   %al,%al
  800e66:	75 ec                	jne    800e54 <strlen+0x15>
		n++;
	return n;
  800e68:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e6b:	c9                   	leaveq 
  800e6c:	c3                   	retq   

0000000000800e6d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e6d:	55                   	push   %rbp
  800e6e:	48 89 e5             	mov    %rsp,%rbp
  800e71:	48 83 ec 20          	sub    $0x20,%rsp
  800e75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800e79:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e84:	eb 0e                	jmp    800e94 <strnlen+0x27>
		n++;
  800e86:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e8a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e8f:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800e94:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800e99:	74 0b                	je     800ea6 <strnlen+0x39>
  800e9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9f:	0f b6 00             	movzbl (%rax),%eax
  800ea2:	84 c0                	test   %al,%al
  800ea4:	75 e0                	jne    800e86 <strnlen+0x19>
		n++;
	return n;
  800ea6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ea9:	c9                   	leaveq 
  800eaa:	c3                   	retq   

0000000000800eab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eab:	55                   	push   %rbp
  800eac:	48 89 e5             	mov    %rsp,%rbp
  800eaf:	48 83 ec 20          	sub    $0x20,%rsp
  800eb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eb7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ebb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ec3:	90                   	nop
  800ec4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ecc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ed0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ed4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800ed8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800edc:	0f b6 12             	movzbl (%rdx),%edx
  800edf:	88 10                	mov    %dl,(%rax)
  800ee1:	0f b6 00             	movzbl (%rax),%eax
  800ee4:	84 c0                	test   %al,%al
  800ee6:	75 dc                	jne    800ec4 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800ee8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800eec:	c9                   	leaveq 
  800eed:	c3                   	retq   

0000000000800eee <strcat>:

char *
strcat(char *dst, const char *src)
{
  800eee:	55                   	push   %rbp
  800eef:	48 89 e5             	mov    %rsp,%rbp
  800ef2:	48 83 ec 20          	sub    $0x20,%rsp
  800ef6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800efa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800efe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f02:	48 89 c7             	mov    %rax,%rdi
  800f05:	48 b8 3f 0e 80 00 00 	movabs $0x800e3f,%rax
  800f0c:	00 00 00 
  800f0f:	ff d0                	callq  *%rax
  800f11:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f17:	48 63 d0             	movslq %eax,%rdx
  800f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f1e:	48 01 c2             	add    %rax,%rdx
  800f21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f25:	48 89 c6             	mov    %rax,%rsi
  800f28:	48 89 d7             	mov    %rdx,%rdi
  800f2b:	48 b8 ab 0e 80 00 00 	movabs $0x800eab,%rax
  800f32:	00 00 00 
  800f35:	ff d0                	callq  *%rax
	return dst;
  800f37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f3b:	c9                   	leaveq 
  800f3c:	c3                   	retq   

0000000000800f3d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f3d:	55                   	push   %rbp
  800f3e:	48 89 e5             	mov    %rsp,%rbp
  800f41:	48 83 ec 28          	sub    $0x28,%rsp
  800f45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f4d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f55:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f59:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f60:	00 
  800f61:	eb 2a                	jmp    800f8d <strncpy+0x50>
		*dst++ = *src;
  800f63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f67:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f6b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f6f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f73:	0f b6 12             	movzbl (%rdx),%edx
  800f76:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f7c:	0f b6 00             	movzbl (%rax),%eax
  800f7f:	84 c0                	test   %al,%al
  800f81:	74 05                	je     800f88 <strncpy+0x4b>
			src++;
  800f83:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f88:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800f8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f91:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800f95:	72 cc                	jb     800f63 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800f9b:	c9                   	leaveq 
  800f9c:	c3                   	retq   

0000000000800f9d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f9d:	55                   	push   %rbp
  800f9e:	48 89 e5             	mov    %rsp,%rbp
  800fa1:	48 83 ec 28          	sub    $0x28,%rsp
  800fa5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fa9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fb9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fbe:	74 3d                	je     800ffd <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fc0:	eb 1d                	jmp    800fdf <strlcpy+0x42>
			*dst++ = *src++;
  800fc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fca:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fce:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fd2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fd6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fda:	0f b6 12             	movzbl (%rdx),%edx
  800fdd:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fdf:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  800fe4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe9:	74 0b                	je     800ff6 <strlcpy+0x59>
  800feb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fef:	0f b6 00             	movzbl (%rax),%eax
  800ff2:	84 c0                	test   %al,%al
  800ff4:	75 cc                	jne    800fc2 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  800ff6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffa:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  800ffd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801001:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801005:	48 29 c2             	sub    %rax,%rdx
  801008:	48 89 d0             	mov    %rdx,%rax
}
  80100b:	c9                   	leaveq 
  80100c:	c3                   	retq   

000000000080100d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80100d:	55                   	push   %rbp
  80100e:	48 89 e5             	mov    %rsp,%rbp
  801011:	48 83 ec 10          	sub    $0x10,%rsp
  801015:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801019:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80101d:	eb 0a                	jmp    801029 <strcmp+0x1c>
		p++, q++;
  80101f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801024:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801029:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102d:	0f b6 00             	movzbl (%rax),%eax
  801030:	84 c0                	test   %al,%al
  801032:	74 12                	je     801046 <strcmp+0x39>
  801034:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801038:	0f b6 10             	movzbl (%rax),%edx
  80103b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80103f:	0f b6 00             	movzbl (%rax),%eax
  801042:	38 c2                	cmp    %al,%dl
  801044:	74 d9                	je     80101f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801046:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104a:	0f b6 00             	movzbl (%rax),%eax
  80104d:	0f b6 d0             	movzbl %al,%edx
  801050:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801054:	0f b6 00             	movzbl (%rax),%eax
  801057:	0f b6 c0             	movzbl %al,%eax
  80105a:	29 c2                	sub    %eax,%edx
  80105c:	89 d0                	mov    %edx,%eax
}
  80105e:	c9                   	leaveq 
  80105f:	c3                   	retq   

0000000000801060 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801060:	55                   	push   %rbp
  801061:	48 89 e5             	mov    %rsp,%rbp
  801064:	48 83 ec 18          	sub    $0x18,%rsp
  801068:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80106c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801070:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801074:	eb 0f                	jmp    801085 <strncmp+0x25>
		n--, p++, q++;
  801076:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80107b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801080:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801085:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80108a:	74 1d                	je     8010a9 <strncmp+0x49>
  80108c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801090:	0f b6 00             	movzbl (%rax),%eax
  801093:	84 c0                	test   %al,%al
  801095:	74 12                	je     8010a9 <strncmp+0x49>
  801097:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80109b:	0f b6 10             	movzbl (%rax),%edx
  80109e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010a2:	0f b6 00             	movzbl (%rax),%eax
  8010a5:	38 c2                	cmp    %al,%dl
  8010a7:	74 cd                	je     801076 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010a9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010ae:	75 07                	jne    8010b7 <strncmp+0x57>
		return 0;
  8010b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b5:	eb 18                	jmp    8010cf <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010bb:	0f b6 00             	movzbl (%rax),%eax
  8010be:	0f b6 d0             	movzbl %al,%edx
  8010c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010c5:	0f b6 00             	movzbl (%rax),%eax
  8010c8:	0f b6 c0             	movzbl %al,%eax
  8010cb:	29 c2                	sub    %eax,%edx
  8010cd:	89 d0                	mov    %edx,%eax
}
  8010cf:	c9                   	leaveq 
  8010d0:	c3                   	retq   

00000000008010d1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010d1:	55                   	push   %rbp
  8010d2:	48 89 e5             	mov    %rsp,%rbp
  8010d5:	48 83 ec 0c          	sub    $0xc,%rsp
  8010d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010dd:	89 f0                	mov    %esi,%eax
  8010df:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8010e2:	eb 17                	jmp    8010fb <strchr+0x2a>
		if (*s == c)
  8010e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e8:	0f b6 00             	movzbl (%rax),%eax
  8010eb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8010ee:	75 06                	jne    8010f6 <strchr+0x25>
			return (char *) s;
  8010f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010f4:	eb 15                	jmp    80110b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010f6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ff:	0f b6 00             	movzbl (%rax),%eax
  801102:	84 c0                	test   %al,%al
  801104:	75 de                	jne    8010e4 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801106:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80110b:	c9                   	leaveq 
  80110c:	c3                   	retq   

000000000080110d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80110d:	55                   	push   %rbp
  80110e:	48 89 e5             	mov    %rsp,%rbp
  801111:	48 83 ec 0c          	sub    $0xc,%rsp
  801115:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801119:	89 f0                	mov    %esi,%eax
  80111b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80111e:	eb 13                	jmp    801133 <strfind+0x26>
		if (*s == c)
  801120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801124:	0f b6 00             	movzbl (%rax),%eax
  801127:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80112a:	75 02                	jne    80112e <strfind+0x21>
			break;
  80112c:	eb 10                	jmp    80113e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80112e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801137:	0f b6 00             	movzbl (%rax),%eax
  80113a:	84 c0                	test   %al,%al
  80113c:	75 e2                	jne    801120 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80113e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801142:	c9                   	leaveq 
  801143:	c3                   	retq   

0000000000801144 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801144:	55                   	push   %rbp
  801145:	48 89 e5             	mov    %rsp,%rbp
  801148:	48 83 ec 18          	sub    $0x18,%rsp
  80114c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801150:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801153:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801157:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80115c:	75 06                	jne    801164 <memset+0x20>
		return v;
  80115e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801162:	eb 69                	jmp    8011cd <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801164:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801168:	83 e0 03             	and    $0x3,%eax
  80116b:	48 85 c0             	test   %rax,%rax
  80116e:	75 48                	jne    8011b8 <memset+0x74>
  801170:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801174:	83 e0 03             	and    $0x3,%eax
  801177:	48 85 c0             	test   %rax,%rax
  80117a:	75 3c                	jne    8011b8 <memset+0x74>
		c &= 0xFF;
  80117c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801183:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801186:	c1 e0 18             	shl    $0x18,%eax
  801189:	89 c2                	mov    %eax,%edx
  80118b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80118e:	c1 e0 10             	shl    $0x10,%eax
  801191:	09 c2                	or     %eax,%edx
  801193:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801196:	c1 e0 08             	shl    $0x8,%eax
  801199:	09 d0                	or     %edx,%eax
  80119b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80119e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a2:	48 c1 e8 02          	shr    $0x2,%rax
  8011a6:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b0:	48 89 d7             	mov    %rdx,%rdi
  8011b3:	fc                   	cld    
  8011b4:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011b6:	eb 11                	jmp    8011c9 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011b8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011bf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011c3:	48 89 d7             	mov    %rdx,%rdi
  8011c6:	fc                   	cld    
  8011c7:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011cd:	c9                   	leaveq 
  8011ce:	c3                   	retq   

00000000008011cf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011cf:	55                   	push   %rbp
  8011d0:	48 89 e5             	mov    %rsp,%rbp
  8011d3:	48 83 ec 28          	sub    $0x28,%rsp
  8011d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8011e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8011eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8011f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8011fb:	0f 83 88 00 00 00    	jae    801289 <memmove+0xba>
  801201:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801205:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801209:	48 01 d0             	add    %rdx,%rax
  80120c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801210:	76 77                	jbe    801289 <memmove+0xba>
		s += n;
  801212:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801216:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80121a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80121e:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801222:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801226:	83 e0 03             	and    $0x3,%eax
  801229:	48 85 c0             	test   %rax,%rax
  80122c:	75 3b                	jne    801269 <memmove+0x9a>
  80122e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801232:	83 e0 03             	and    $0x3,%eax
  801235:	48 85 c0             	test   %rax,%rax
  801238:	75 2f                	jne    801269 <memmove+0x9a>
  80123a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123e:	83 e0 03             	and    $0x3,%eax
  801241:	48 85 c0             	test   %rax,%rax
  801244:	75 23                	jne    801269 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801246:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80124a:	48 83 e8 04          	sub    $0x4,%rax
  80124e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801252:	48 83 ea 04          	sub    $0x4,%rdx
  801256:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80125a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80125e:	48 89 c7             	mov    %rax,%rdi
  801261:	48 89 d6             	mov    %rdx,%rsi
  801264:	fd                   	std    
  801265:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801267:	eb 1d                	jmp    801286 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801275:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801279:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80127d:	48 89 d7             	mov    %rdx,%rdi
  801280:	48 89 c1             	mov    %rax,%rcx
  801283:	fd                   	std    
  801284:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801286:	fc                   	cld    
  801287:	eb 57                	jmp    8012e0 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801289:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128d:	83 e0 03             	and    $0x3,%eax
  801290:	48 85 c0             	test   %rax,%rax
  801293:	75 36                	jne    8012cb <memmove+0xfc>
  801295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801299:	83 e0 03             	and    $0x3,%eax
  80129c:	48 85 c0             	test   %rax,%rax
  80129f:	75 2a                	jne    8012cb <memmove+0xfc>
  8012a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a5:	83 e0 03             	and    $0x3,%eax
  8012a8:	48 85 c0             	test   %rax,%rax
  8012ab:	75 1e                	jne    8012cb <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b1:	48 c1 e8 02          	shr    $0x2,%rax
  8012b5:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012c0:	48 89 c7             	mov    %rax,%rdi
  8012c3:	48 89 d6             	mov    %rdx,%rsi
  8012c6:	fc                   	cld    
  8012c7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012c9:	eb 15                	jmp    8012e0 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012cf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012d3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012d7:	48 89 c7             	mov    %rax,%rdi
  8012da:	48 89 d6             	mov    %rdx,%rsi
  8012dd:	fc                   	cld    
  8012de:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8012e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012e4:	c9                   	leaveq 
  8012e5:	c3                   	retq   

00000000008012e6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8012e6:	55                   	push   %rbp
  8012e7:	48 89 e5             	mov    %rsp,%rbp
  8012ea:	48 83 ec 18          	sub    $0x18,%rsp
  8012ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012f6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8012fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012fe:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801306:	48 89 ce             	mov    %rcx,%rsi
  801309:	48 89 c7             	mov    %rax,%rdi
  80130c:	48 b8 cf 11 80 00 00 	movabs $0x8011cf,%rax
  801313:	00 00 00 
  801316:	ff d0                	callq  *%rax
}
  801318:	c9                   	leaveq 
  801319:	c3                   	retq   

000000000080131a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80131a:	55                   	push   %rbp
  80131b:	48 89 e5             	mov    %rsp,%rbp
  80131e:	48 83 ec 28          	sub    $0x28,%rsp
  801322:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801326:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80132a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80132e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801332:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801336:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80133e:	eb 36                	jmp    801376 <memcmp+0x5c>
		if (*s1 != *s2)
  801340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801344:	0f b6 10             	movzbl (%rax),%edx
  801347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134b:	0f b6 00             	movzbl (%rax),%eax
  80134e:	38 c2                	cmp    %al,%dl
  801350:	74 1a                	je     80136c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801356:	0f b6 00             	movzbl (%rax),%eax
  801359:	0f b6 d0             	movzbl %al,%edx
  80135c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801360:	0f b6 00             	movzbl (%rax),%eax
  801363:	0f b6 c0             	movzbl %al,%eax
  801366:	29 c2                	sub    %eax,%edx
  801368:	89 d0                	mov    %edx,%eax
  80136a:	eb 20                	jmp    80138c <memcmp+0x72>
		s1++, s2++;
  80136c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801371:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801376:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80137e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801382:	48 85 c0             	test   %rax,%rax
  801385:	75 b9                	jne    801340 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801387:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138c:	c9                   	leaveq 
  80138d:	c3                   	retq   

000000000080138e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80138e:	55                   	push   %rbp
  80138f:	48 89 e5             	mov    %rsp,%rbp
  801392:	48 83 ec 28          	sub    $0x28,%rsp
  801396:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80139d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013a9:	48 01 d0             	add    %rdx,%rax
  8013ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013b0:	eb 15                	jmp    8013c7 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b6:	0f b6 10             	movzbl (%rax),%edx
  8013b9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013bc:	38 c2                	cmp    %al,%dl
  8013be:	75 02                	jne    8013c2 <memfind+0x34>
			break;
  8013c0:	eb 0f                	jmp    8013d1 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013c2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cb:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013cf:	72 e1                	jb     8013b2 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013d5:	c9                   	leaveq 
  8013d6:	c3                   	retq   

00000000008013d7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013d7:	55                   	push   %rbp
  8013d8:	48 89 e5             	mov    %rsp,%rbp
  8013db:	48 83 ec 34          	sub    $0x34,%rsp
  8013df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8013e7:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8013ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8013f1:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8013f8:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013f9:	eb 05                	jmp    801400 <strtol+0x29>
		s++;
  8013fb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801400:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801404:	0f b6 00             	movzbl (%rax),%eax
  801407:	3c 20                	cmp    $0x20,%al
  801409:	74 f0                	je     8013fb <strtol+0x24>
  80140b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80140f:	0f b6 00             	movzbl (%rax),%eax
  801412:	3c 09                	cmp    $0x9,%al
  801414:	74 e5                	je     8013fb <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801416:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141a:	0f b6 00             	movzbl (%rax),%eax
  80141d:	3c 2b                	cmp    $0x2b,%al
  80141f:	75 07                	jne    801428 <strtol+0x51>
		s++;
  801421:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801426:	eb 17                	jmp    80143f <strtol+0x68>
	else if (*s == '-')
  801428:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142c:	0f b6 00             	movzbl (%rax),%eax
  80142f:	3c 2d                	cmp    $0x2d,%al
  801431:	75 0c                	jne    80143f <strtol+0x68>
		s++, neg = 1;
  801433:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801438:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801443:	74 06                	je     80144b <strtol+0x74>
  801445:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801449:	75 28                	jne    801473 <strtol+0x9c>
  80144b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144f:	0f b6 00             	movzbl (%rax),%eax
  801452:	3c 30                	cmp    $0x30,%al
  801454:	75 1d                	jne    801473 <strtol+0x9c>
  801456:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145a:	48 83 c0 01          	add    $0x1,%rax
  80145e:	0f b6 00             	movzbl (%rax),%eax
  801461:	3c 78                	cmp    $0x78,%al
  801463:	75 0e                	jne    801473 <strtol+0x9c>
		s += 2, base = 16;
  801465:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80146a:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801471:	eb 2c                	jmp    80149f <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801473:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801477:	75 19                	jne    801492 <strtol+0xbb>
  801479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147d:	0f b6 00             	movzbl (%rax),%eax
  801480:	3c 30                	cmp    $0x30,%al
  801482:	75 0e                	jne    801492 <strtol+0xbb>
		s++, base = 8;
  801484:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801489:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801490:	eb 0d                	jmp    80149f <strtol+0xc8>
	else if (base == 0)
  801492:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801496:	75 07                	jne    80149f <strtol+0xc8>
		base = 10;
  801498:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80149f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a3:	0f b6 00             	movzbl (%rax),%eax
  8014a6:	3c 2f                	cmp    $0x2f,%al
  8014a8:	7e 1d                	jle    8014c7 <strtol+0xf0>
  8014aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ae:	0f b6 00             	movzbl (%rax),%eax
  8014b1:	3c 39                	cmp    $0x39,%al
  8014b3:	7f 12                	jg     8014c7 <strtol+0xf0>
			dig = *s - '0';
  8014b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b9:	0f b6 00             	movzbl (%rax),%eax
  8014bc:	0f be c0             	movsbl %al,%eax
  8014bf:	83 e8 30             	sub    $0x30,%eax
  8014c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014c5:	eb 4e                	jmp    801515 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cb:	0f b6 00             	movzbl (%rax),%eax
  8014ce:	3c 60                	cmp    $0x60,%al
  8014d0:	7e 1d                	jle    8014ef <strtol+0x118>
  8014d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d6:	0f b6 00             	movzbl (%rax),%eax
  8014d9:	3c 7a                	cmp    $0x7a,%al
  8014db:	7f 12                	jg     8014ef <strtol+0x118>
			dig = *s - 'a' + 10;
  8014dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e1:	0f b6 00             	movzbl (%rax),%eax
  8014e4:	0f be c0             	movsbl %al,%eax
  8014e7:	83 e8 57             	sub    $0x57,%eax
  8014ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ed:	eb 26                	jmp    801515 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8014ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f3:	0f b6 00             	movzbl (%rax),%eax
  8014f6:	3c 40                	cmp    $0x40,%al
  8014f8:	7e 48                	jle    801542 <strtol+0x16b>
  8014fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fe:	0f b6 00             	movzbl (%rax),%eax
  801501:	3c 5a                	cmp    $0x5a,%al
  801503:	7f 3d                	jg     801542 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801505:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801509:	0f b6 00             	movzbl (%rax),%eax
  80150c:	0f be c0             	movsbl %al,%eax
  80150f:	83 e8 37             	sub    $0x37,%eax
  801512:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801515:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801518:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80151b:	7c 02                	jl     80151f <strtol+0x148>
			break;
  80151d:	eb 23                	jmp    801542 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80151f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801524:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801527:	48 98                	cltq   
  801529:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80152e:	48 89 c2             	mov    %rax,%rdx
  801531:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801534:	48 98                	cltq   
  801536:	48 01 d0             	add    %rdx,%rax
  801539:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80153d:	e9 5d ff ff ff       	jmpq   80149f <strtol+0xc8>

	if (endptr)
  801542:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801547:	74 0b                	je     801554 <strtol+0x17d>
		*endptr = (char *) s;
  801549:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80154d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801551:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801554:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801558:	74 09                	je     801563 <strtol+0x18c>
  80155a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80155e:	48 f7 d8             	neg    %rax
  801561:	eb 04                	jmp    801567 <strtol+0x190>
  801563:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801567:	c9                   	leaveq 
  801568:	c3                   	retq   

0000000000801569 <strstr>:

char * strstr(const char *in, const char *str)
{
  801569:	55                   	push   %rbp
  80156a:	48 89 e5             	mov    %rsp,%rbp
  80156d:	48 83 ec 30          	sub    $0x30,%rsp
  801571:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801575:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801579:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80157d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801581:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80158b:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80158f:	75 06                	jne    801597 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801591:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801595:	eb 6b                	jmp    801602 <strstr+0x99>

	len = strlen(str);
  801597:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80159b:	48 89 c7             	mov    %rax,%rdi
  80159e:	48 b8 3f 0e 80 00 00 	movabs $0x800e3f,%rax
  8015a5:	00 00 00 
  8015a8:	ff d0                	callq  *%rax
  8015aa:	48 98                	cltq   
  8015ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015bc:	0f b6 00             	movzbl (%rax),%eax
  8015bf:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015c2:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015c6:	75 07                	jne    8015cf <strstr+0x66>
				return (char *) 0;
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cd:	eb 33                	jmp    801602 <strstr+0x99>
		} while (sc != c);
  8015cf:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015d3:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015d6:	75 d8                	jne    8015b0 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8015d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8015dc:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8015e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e4:	48 89 ce             	mov    %rcx,%rsi
  8015e7:	48 89 c7             	mov    %rax,%rdi
  8015ea:	48 b8 60 10 80 00 00 	movabs $0x801060,%rax
  8015f1:	00 00 00 
  8015f4:	ff d0                	callq  *%rax
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	75 b6                	jne    8015b0 <strstr+0x47>

	return (char *) (in - 1);
  8015fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fe:	48 83 e8 01          	sub    $0x1,%rax
}
  801602:	c9                   	leaveq 
  801603:	c3                   	retq   

0000000000801604 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801604:	55                   	push   %rbp
  801605:	48 89 e5             	mov    %rsp,%rbp
  801608:	53                   	push   %rbx
  801609:	48 83 ec 48          	sub    $0x48,%rsp
  80160d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801610:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801613:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801617:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80161b:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80161f:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801623:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801626:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80162a:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80162e:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801632:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801636:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80163a:	4c 89 c3             	mov    %r8,%rbx
  80163d:	cd 30                	int    $0x30
  80163f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801643:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801647:	74 3e                	je     801687 <syscall+0x83>
  801649:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80164e:	7e 37                	jle    801687 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801650:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801654:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801657:	49 89 d0             	mov    %rdx,%r8
  80165a:	89 c1                	mov    %eax,%ecx
  80165c:	48 ba a8 3a 80 00 00 	movabs $0x803aa8,%rdx
  801663:	00 00 00 
  801666:	be 4a 00 00 00       	mov    $0x4a,%esi
  80166b:	48 bf c5 3a 80 00 00 	movabs $0x803ac5,%rdi
  801672:	00 00 00 
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
  80167a:	49 b9 f9 33 80 00 00 	movabs $0x8033f9,%r9
  801681:	00 00 00 
  801684:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801687:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80168b:	48 83 c4 48          	add    $0x48,%rsp
  80168f:	5b                   	pop    %rbx
  801690:	5d                   	pop    %rbp
  801691:	c3                   	retq   

0000000000801692 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801692:	55                   	push   %rbp
  801693:	48 89 e5             	mov    %rsp,%rbp
  801696:	48 83 ec 20          	sub    $0x20,%rsp
  80169a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80169e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016aa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016b1:	00 
  8016b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016be:	48 89 d1             	mov    %rdx,%rcx
  8016c1:	48 89 c2             	mov    %rax,%rdx
  8016c4:	be 00 00 00 00       	mov    $0x0,%esi
  8016c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ce:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  8016d5:	00 00 00 
  8016d8:	ff d0                	callq  *%rax
}
  8016da:	c9                   	leaveq 
  8016db:	c3                   	retq   

00000000008016dc <sys_cgetc>:

int
sys_cgetc(void)
{
  8016dc:	55                   	push   %rbp
  8016dd:	48 89 e5             	mov    %rsp,%rbp
  8016e0:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8016e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016eb:	00 
  8016ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801702:	be 00 00 00 00       	mov    $0x0,%esi
  801707:	bf 01 00 00 00       	mov    $0x1,%edi
  80170c:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  801713:	00 00 00 
  801716:	ff d0                	callq  *%rax
}
  801718:	c9                   	leaveq 
  801719:	c3                   	retq   

000000000080171a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80171a:	55                   	push   %rbp
  80171b:	48 89 e5             	mov    %rsp,%rbp
  80171e:	48 83 ec 10          	sub    $0x10,%rsp
  801722:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801725:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801728:	48 98                	cltq   
  80172a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801731:	00 
  801732:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801738:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80173e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801743:	48 89 c2             	mov    %rax,%rdx
  801746:	be 01 00 00 00       	mov    $0x1,%esi
  80174b:	bf 03 00 00 00       	mov    $0x3,%edi
  801750:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  801757:	00 00 00 
  80175a:	ff d0                	callq  *%rax
}
  80175c:	c9                   	leaveq 
  80175d:	c3                   	retq   

000000000080175e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80175e:	55                   	push   %rbp
  80175f:	48 89 e5             	mov    %rsp,%rbp
  801762:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801766:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80176d:	00 
  80176e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801774:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80177a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80177f:	ba 00 00 00 00       	mov    $0x0,%edx
  801784:	be 00 00 00 00       	mov    $0x0,%esi
  801789:	bf 02 00 00 00       	mov    $0x2,%edi
  80178e:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  801795:	00 00 00 
  801798:	ff d0                	callq  *%rax
}
  80179a:	c9                   	leaveq 
  80179b:	c3                   	retq   

000000000080179c <sys_yield>:

void
sys_yield(void)
{
  80179c:	55                   	push   %rbp
  80179d:	48 89 e5             	mov    %rsp,%rbp
  8017a0:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017a4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017ab:	00 
  8017ac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017b2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c2:	be 00 00 00 00       	mov    $0x0,%esi
  8017c7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017cc:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  8017d3:	00 00 00 
  8017d6:	ff d0                	callq  *%rax
}
  8017d8:	c9                   	leaveq 
  8017d9:	c3                   	retq   

00000000008017da <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017da:	55                   	push   %rbp
  8017db:	48 89 e5             	mov    %rsp,%rbp
  8017de:	48 83 ec 20          	sub    $0x20,%rsp
  8017e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8017e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017e9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8017ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017ef:	48 63 c8             	movslq %eax,%rcx
  8017f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017f9:	48 98                	cltq   
  8017fb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801802:	00 
  801803:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801809:	49 89 c8             	mov    %rcx,%r8
  80180c:	48 89 d1             	mov    %rdx,%rcx
  80180f:	48 89 c2             	mov    %rax,%rdx
  801812:	be 01 00 00 00       	mov    $0x1,%esi
  801817:	bf 04 00 00 00       	mov    $0x4,%edi
  80181c:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  801823:	00 00 00 
  801826:	ff d0                	callq  *%rax
}
  801828:	c9                   	leaveq 
  801829:	c3                   	retq   

000000000080182a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80182a:	55                   	push   %rbp
  80182b:	48 89 e5             	mov    %rsp,%rbp
  80182e:	48 83 ec 30          	sub    $0x30,%rsp
  801832:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801835:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801839:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80183c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801840:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801844:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801847:	48 63 c8             	movslq %eax,%rcx
  80184a:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80184e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801851:	48 63 f0             	movslq %eax,%rsi
  801854:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801858:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80185b:	48 98                	cltq   
  80185d:	48 89 0c 24          	mov    %rcx,(%rsp)
  801861:	49 89 f9             	mov    %rdi,%r9
  801864:	49 89 f0             	mov    %rsi,%r8
  801867:	48 89 d1             	mov    %rdx,%rcx
  80186a:	48 89 c2             	mov    %rax,%rdx
  80186d:	be 01 00 00 00       	mov    $0x1,%esi
  801872:	bf 05 00 00 00       	mov    $0x5,%edi
  801877:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  80187e:	00 00 00 
  801881:	ff d0                	callq  *%rax
}
  801883:	c9                   	leaveq 
  801884:	c3                   	retq   

0000000000801885 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801885:	55                   	push   %rbp
  801886:	48 89 e5             	mov    %rsp,%rbp
  801889:	48 83 ec 20          	sub    $0x20,%rsp
  80188d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801890:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801894:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801898:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189b:	48 98                	cltq   
  80189d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a4:	00 
  8018a5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ab:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b1:	48 89 d1             	mov    %rdx,%rcx
  8018b4:	48 89 c2             	mov    %rax,%rdx
  8018b7:	be 01 00 00 00       	mov    $0x1,%esi
  8018bc:	bf 06 00 00 00       	mov    $0x6,%edi
  8018c1:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  8018c8:	00 00 00 
  8018cb:	ff d0                	callq  *%rax
}
  8018cd:	c9                   	leaveq 
  8018ce:	c3                   	retq   

00000000008018cf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018cf:	55                   	push   %rbp
  8018d0:	48 89 e5             	mov    %rsp,%rbp
  8018d3:	48 83 ec 10          	sub    $0x10,%rsp
  8018d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018da:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8018dd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018e0:	48 63 d0             	movslq %eax,%rdx
  8018e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e6:	48 98                	cltq   
  8018e8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ef:	00 
  8018f0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018fc:	48 89 d1             	mov    %rdx,%rcx
  8018ff:	48 89 c2             	mov    %rax,%rdx
  801902:	be 01 00 00 00       	mov    $0x1,%esi
  801907:	bf 08 00 00 00       	mov    $0x8,%edi
  80190c:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  801913:	00 00 00 
  801916:	ff d0                	callq  *%rax
}
  801918:	c9                   	leaveq 
  801919:	c3                   	retq   

000000000080191a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80191a:	55                   	push   %rbp
  80191b:	48 89 e5             	mov    %rsp,%rbp
  80191e:	48 83 ec 20          	sub    $0x20,%rsp
  801922:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801925:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801929:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80192d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801930:	48 98                	cltq   
  801932:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801939:	00 
  80193a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801940:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801946:	48 89 d1             	mov    %rdx,%rcx
  801949:	48 89 c2             	mov    %rax,%rdx
  80194c:	be 01 00 00 00       	mov    $0x1,%esi
  801951:	bf 09 00 00 00       	mov    $0x9,%edi
  801956:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  80195d:	00 00 00 
  801960:	ff d0                	callq  *%rax
}
  801962:	c9                   	leaveq 
  801963:	c3                   	retq   

0000000000801964 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801964:	55                   	push   %rbp
  801965:	48 89 e5             	mov    %rsp,%rbp
  801968:	48 83 ec 20          	sub    $0x20,%rsp
  80196c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80196f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801973:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801977:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197a:	48 98                	cltq   
  80197c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801983:	00 
  801984:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80198a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801990:	48 89 d1             	mov    %rdx,%rcx
  801993:	48 89 c2             	mov    %rax,%rdx
  801996:	be 01 00 00 00       	mov    $0x1,%esi
  80199b:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019a0:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  8019a7:	00 00 00 
  8019aa:	ff d0                	callq  *%rax
}
  8019ac:	c9                   	leaveq 
  8019ad:	c3                   	retq   

00000000008019ae <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019ae:	55                   	push   %rbp
  8019af:	48 89 e5             	mov    %rsp,%rbp
  8019b2:	48 83 ec 20          	sub    $0x20,%rsp
  8019b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019bd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019c1:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c7:	48 63 f0             	movslq %eax,%rsi
  8019ca:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d1:	48 98                	cltq   
  8019d3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019d7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019de:	00 
  8019df:	49 89 f1             	mov    %rsi,%r9
  8019e2:	49 89 c8             	mov    %rcx,%r8
  8019e5:	48 89 d1             	mov    %rdx,%rcx
  8019e8:	48 89 c2             	mov    %rax,%rdx
  8019eb:	be 00 00 00 00       	mov    $0x0,%esi
  8019f0:	bf 0c 00 00 00       	mov    $0xc,%edi
  8019f5:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  8019fc:	00 00 00 
  8019ff:	ff d0                	callq  *%rax
}
  801a01:	c9                   	leaveq 
  801a02:	c3                   	retq   

0000000000801a03 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a03:	55                   	push   %rbp
  801a04:	48 89 e5             	mov    %rsp,%rbp
  801a07:	48 83 ec 10          	sub    $0x10,%rsp
  801a0b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1a:	00 
  801a1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a27:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a2c:	48 89 c2             	mov    %rax,%rdx
  801a2f:	be 01 00 00 00       	mov    $0x1,%esi
  801a34:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a39:	48 b8 04 16 80 00 00 	movabs $0x801604,%rax
  801a40:	00 00 00 
  801a43:	ff d0                	callq  *%rax
}
  801a45:	c9                   	leaveq 
  801a46:	c3                   	retq   

0000000000801a47 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a47:	55                   	push   %rbp
  801a48:	48 89 e5             	mov    %rsp,%rbp
  801a4b:	48 83 ec 30          	sub    $0x30,%rsp
  801a4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a57:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  801a5b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801a60:	74 18                	je     801a7a <ipc_recv+0x33>
  801a62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a66:	48 89 c7             	mov    %rax,%rdi
  801a69:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  801a70:	00 00 00 
  801a73:	ff d0                	callq  *%rax
  801a75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a78:	eb 19                	jmp    801a93 <ipc_recv+0x4c>
  801a7a:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  801a81:	00 00 00 
  801a84:	48 b8 03 1a 80 00 00 	movabs $0x801a03,%rax
  801a8b:	00 00 00 
  801a8e:	ff d0                	callq  *%rax
  801a90:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  801a93:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a98:	74 26                	je     801ac0 <ipc_recv+0x79>
  801a9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a9e:	75 15                	jne    801ab5 <ipc_recv+0x6e>
  801aa0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801aa7:	00 00 00 
  801aaa:	48 8b 00             	mov    (%rax),%rax
  801aad:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  801ab3:	eb 05                	jmp    801aba <ipc_recv+0x73>
  801ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801abe:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  801ac0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801ac5:	74 26                	je     801aed <ipc_recv+0xa6>
  801ac7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801acb:	75 15                	jne    801ae2 <ipc_recv+0x9b>
  801acd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801ad4:	00 00 00 
  801ad7:	48 8b 00             	mov    (%rax),%rax
  801ada:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  801ae0:	eb 05                	jmp    801ae7 <ipc_recv+0xa0>
  801ae2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801aeb:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  801aed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801af1:	75 15                	jne    801b08 <ipc_recv+0xc1>
  801af3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801afa:	00 00 00 
  801afd:	48 8b 00             	mov    (%rax),%rax
  801b00:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  801b06:	eb 03                	jmp    801b0b <ipc_recv+0xc4>
  801b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b0b:	c9                   	leaveq 
  801b0c:	c3                   	retq   

0000000000801b0d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
  801b11:	48 83 ec 30          	sub    $0x30,%rsp
  801b15:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801b18:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801b1b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  801b1f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  801b22:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  801b29:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b2e:	75 10                	jne    801b40 <ipc_send+0x33>
  801b30:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  801b37:	00 00 00 
  801b3a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  801b3e:	eb 62                	jmp    801ba2 <ipc_send+0x95>
  801b40:	eb 60                	jmp    801ba2 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  801b42:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  801b46:	74 30                	je     801b78 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  801b48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4b:	89 c1                	mov    %eax,%ecx
  801b4d:	48 ba d3 3a 80 00 00 	movabs $0x803ad3,%rdx
  801b54:	00 00 00 
  801b57:	be 33 00 00 00       	mov    $0x33,%esi
  801b5c:	48 bf ef 3a 80 00 00 	movabs $0x803aef,%rdi
  801b63:	00 00 00 
  801b66:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6b:	49 b8 f9 33 80 00 00 	movabs $0x8033f9,%r8
  801b72:	00 00 00 
  801b75:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  801b78:	8b 75 e8             	mov    -0x18(%rbp),%esi
  801b7b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801b7e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b85:	89 c7                	mov    %eax,%edi
  801b87:	48 b8 ae 19 80 00 00 	movabs $0x8019ae,%rax
  801b8e:	00 00 00 
  801b91:	ff d0                	callq  *%rax
  801b93:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  801b96:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  801b9d:	00 00 00 
  801ba0:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  801ba2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ba6:	75 9a                	jne    801b42 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  801ba8:	c9                   	leaveq 
  801ba9:	c3                   	retq   

0000000000801baa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801baa:	55                   	push   %rbp
  801bab:	48 89 e5             	mov    %rsp,%rbp
  801bae:	48 83 ec 14          	sub    $0x14,%rsp
  801bb2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  801bb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801bbc:	eb 5e                	jmp    801c1c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  801bbe:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801bc5:	00 00 00 
  801bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcb:	48 63 d0             	movslq %eax,%rdx
  801bce:	48 89 d0             	mov    %rdx,%rax
  801bd1:	48 c1 e0 03          	shl    $0x3,%rax
  801bd5:	48 01 d0             	add    %rdx,%rax
  801bd8:	48 c1 e0 05          	shl    $0x5,%rax
  801bdc:	48 01 c8             	add    %rcx,%rax
  801bdf:	48 05 d0 00 00 00    	add    $0xd0,%rax
  801be5:	8b 00                	mov    (%rax),%eax
  801be7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801bea:	75 2c                	jne    801c18 <ipc_find_env+0x6e>
			return envs[i].env_id;
  801bec:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  801bf3:	00 00 00 
  801bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf9:	48 63 d0             	movslq %eax,%rdx
  801bfc:	48 89 d0             	mov    %rdx,%rax
  801bff:	48 c1 e0 03          	shl    $0x3,%rax
  801c03:	48 01 d0             	add    %rdx,%rax
  801c06:	48 c1 e0 05          	shl    $0x5,%rax
  801c0a:	48 01 c8             	add    %rcx,%rax
  801c0d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  801c13:	8b 40 08             	mov    0x8(%rax),%eax
  801c16:	eb 12                	jmp    801c2a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  801c18:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c1c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801c23:	7e 99                	jle    801bbe <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  801c25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2a:	c9                   	leaveq 
  801c2b:	c3                   	retq   

0000000000801c2c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c2c:	55                   	push   %rbp
  801c2d:	48 89 e5             	mov    %rsp,%rbp
  801c30:	48 83 ec 08          	sub    $0x8,%rsp
  801c34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c38:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c3c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c43:	ff ff ff 
  801c46:	48 01 d0             	add    %rdx,%rax
  801c49:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801c4d:	c9                   	leaveq 
  801c4e:	c3                   	retq   

0000000000801c4f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c4f:	55                   	push   %rbp
  801c50:	48 89 e5             	mov    %rsp,%rbp
  801c53:	48 83 ec 08          	sub    $0x8,%rsp
  801c57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801c5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c5f:	48 89 c7             	mov    %rax,%rdi
  801c62:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801c69:	00 00 00 
  801c6c:	ff d0                	callq  *%rax
  801c6e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801c74:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801c78:	c9                   	leaveq 
  801c79:	c3                   	retq   

0000000000801c7a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c7a:	55                   	push   %rbp
  801c7b:	48 89 e5             	mov    %rsp,%rbp
  801c7e:	48 83 ec 18          	sub    $0x18,%rsp
  801c82:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801c8d:	eb 6b                	jmp    801cfa <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801c8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c92:	48 98                	cltq   
  801c94:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c9a:	48 c1 e0 0c          	shl    $0xc,%rax
  801c9e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ca6:	48 c1 e8 15          	shr    $0x15,%rax
  801caa:	48 89 c2             	mov    %rax,%rdx
  801cad:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801cb4:	01 00 00 
  801cb7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cbb:	83 e0 01             	and    $0x1,%eax
  801cbe:	48 85 c0             	test   %rax,%rax
  801cc1:	74 21                	je     801ce4 <fd_alloc+0x6a>
  801cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc7:	48 c1 e8 0c          	shr    $0xc,%rax
  801ccb:	48 89 c2             	mov    %rax,%rdx
  801cce:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801cd5:	01 00 00 
  801cd8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801cdc:	83 e0 01             	and    $0x1,%eax
  801cdf:	48 85 c0             	test   %rax,%rax
  801ce2:	75 12                	jne    801cf6 <fd_alloc+0x7c>
			*fd_store = fd;
  801ce4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cec:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf4:	eb 1a                	jmp    801d10 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cf6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cfa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801cfe:	7e 8f                	jle    801c8f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d04:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d0b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d10:	c9                   	leaveq 
  801d11:	c3                   	retq   

0000000000801d12 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d12:	55                   	push   %rbp
  801d13:	48 89 e5             	mov    %rsp,%rbp
  801d16:	48 83 ec 20          	sub    $0x20,%rsp
  801d1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d21:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d25:	78 06                	js     801d2d <fd_lookup+0x1b>
  801d27:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d2b:	7e 07                	jle    801d34 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d32:	eb 6c                	jmp    801da0 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d37:	48 98                	cltq   
  801d39:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d3f:	48 c1 e0 0c          	shl    $0xc,%rax
  801d43:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d4b:	48 c1 e8 15          	shr    $0x15,%rax
  801d4f:	48 89 c2             	mov    %rax,%rdx
  801d52:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d59:	01 00 00 
  801d5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d60:	83 e0 01             	and    $0x1,%eax
  801d63:	48 85 c0             	test   %rax,%rax
  801d66:	74 21                	je     801d89 <fd_lookup+0x77>
  801d68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6c:	48 c1 e8 0c          	shr    $0xc,%rax
  801d70:	48 89 c2             	mov    %rax,%rdx
  801d73:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d7a:	01 00 00 
  801d7d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d81:	83 e0 01             	and    $0x1,%eax
  801d84:	48 85 c0             	test   %rax,%rax
  801d87:	75 07                	jne    801d90 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d8e:	eb 10                	jmp    801da0 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801d90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d94:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d98:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leaveq 
  801da1:	c3                   	retq   

0000000000801da2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801da2:	55                   	push   %rbp
  801da3:	48 89 e5             	mov    %rsp,%rbp
  801da6:	48 83 ec 30          	sub    $0x30,%rsp
  801daa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801dae:	89 f0                	mov    %esi,%eax
  801db0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801db3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db7:	48 89 c7             	mov    %rax,%rdi
  801dba:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  801dc1:	00 00 00 
  801dc4:	ff d0                	callq  *%rax
  801dc6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801dca:	48 89 d6             	mov    %rdx,%rsi
  801dcd:	89 c7                	mov    %eax,%edi
  801dcf:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801dd6:	00 00 00 
  801dd9:	ff d0                	callq  *%rax
  801ddb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dde:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801de2:	78 0a                	js     801dee <fd_close+0x4c>
	    || fd != fd2)
  801de4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801dec:	74 12                	je     801e00 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801dee:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801df2:	74 05                	je     801df9 <fd_close+0x57>
  801df4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801df7:	eb 05                	jmp    801dfe <fd_close+0x5c>
  801df9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfe:	eb 69                	jmp    801e69 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e04:	8b 00                	mov    (%rax),%eax
  801e06:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e0a:	48 89 d6             	mov    %rdx,%rsi
  801e0d:	89 c7                	mov    %eax,%edi
  801e0f:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  801e16:	00 00 00 
  801e19:	ff d0                	callq  *%rax
  801e1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e22:	78 2a                	js     801e4e <fd_close+0xac>
		if (dev->dev_close)
  801e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e28:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e2c:	48 85 c0             	test   %rax,%rax
  801e2f:	74 16                	je     801e47 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e35:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e39:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e3d:	48 89 d7             	mov    %rdx,%rdi
  801e40:	ff d0                	callq  *%rax
  801e42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e45:	eb 07                	jmp    801e4e <fd_close+0xac>
		else
			r = 0;
  801e47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e52:	48 89 c6             	mov    %rax,%rsi
  801e55:	bf 00 00 00 00       	mov    $0x0,%edi
  801e5a:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  801e61:	00 00 00 
  801e64:	ff d0                	callq  *%rax
	return r;
  801e66:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801e69:	c9                   	leaveq 
  801e6a:	c3                   	retq   

0000000000801e6b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e6b:	55                   	push   %rbp
  801e6c:	48 89 e5             	mov    %rsp,%rbp
  801e6f:	48 83 ec 20          	sub    $0x20,%rsp
  801e73:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e76:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801e7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e81:	eb 41                	jmp    801ec4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801e83:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801e8a:	00 00 00 
  801e8d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e90:	48 63 d2             	movslq %edx,%rdx
  801e93:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e97:	8b 00                	mov    (%rax),%eax
  801e99:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801e9c:	75 22                	jne    801ec0 <dev_lookup+0x55>
			*dev = devtab[i];
  801e9e:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ea5:	00 00 00 
  801ea8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801eab:	48 63 d2             	movslq %edx,%rdx
  801eae:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801eb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801eb6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebe:	eb 60                	jmp    801f20 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ec0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ec4:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ecb:	00 00 00 
  801ece:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ed1:	48 63 d2             	movslq %edx,%rdx
  801ed4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ed8:	48 85 c0             	test   %rax,%rax
  801edb:	75 a6                	jne    801e83 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801edd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801ee4:	00 00 00 
  801ee7:	48 8b 00             	mov    (%rax),%rax
  801eea:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801ef0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801ef3:	89 c6                	mov    %eax,%esi
  801ef5:	48 bf 00 3b 80 00 00 	movabs $0x803b00,%rdi
  801efc:	00 00 00 
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  801f0b:	00 00 00 
  801f0e:	ff d1                	callq  *%rcx
	*dev = 0;
  801f10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f14:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f1b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f20:	c9                   	leaveq 
  801f21:	c3                   	retq   

0000000000801f22 <close>:

int
close(int fdnum)
{
  801f22:	55                   	push   %rbp
  801f23:	48 89 e5             	mov    %rsp,%rbp
  801f26:	48 83 ec 20          	sub    $0x20,%rsp
  801f2a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f2d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f31:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f34:	48 89 d6             	mov    %rdx,%rsi
  801f37:	89 c7                	mov    %eax,%edi
  801f39:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801f40:	00 00 00 
  801f43:	ff d0                	callq  *%rax
  801f45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f4c:	79 05                	jns    801f53 <close+0x31>
		return r;
  801f4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f51:	eb 18                	jmp    801f6b <close+0x49>
	else
		return fd_close(fd, 1);
  801f53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f57:	be 01 00 00 00       	mov    $0x1,%esi
  801f5c:	48 89 c7             	mov    %rax,%rdi
  801f5f:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
}
  801f6b:	c9                   	leaveq 
  801f6c:	c3                   	retq   

0000000000801f6d <close_all>:

void
close_all(void)
{
  801f6d:	55                   	push   %rbp
  801f6e:	48 89 e5             	mov    %rsp,%rbp
  801f71:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f7c:	eb 15                	jmp    801f93 <close_all+0x26>
		close(i);
  801f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f81:	89 c7                	mov    %eax,%edi
  801f83:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  801f8a:	00 00 00 
  801f8d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f8f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f93:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801f97:	7e e5                	jle    801f7e <close_all+0x11>
		close(i);
}
  801f99:	c9                   	leaveq 
  801f9a:	c3                   	retq   

0000000000801f9b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f9b:	55                   	push   %rbp
  801f9c:	48 89 e5             	mov    %rsp,%rbp
  801f9f:	48 83 ec 40          	sub    $0x40,%rsp
  801fa3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801fa6:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fa9:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801fad:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fb0:	48 89 d6             	mov    %rdx,%rsi
  801fb3:	89 c7                	mov    %eax,%edi
  801fb5:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  801fbc:	00 00 00 
  801fbf:	ff d0                	callq  *%rax
  801fc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fc8:	79 08                	jns    801fd2 <dup+0x37>
		return r;
  801fca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fcd:	e9 70 01 00 00       	jmpq   802142 <dup+0x1a7>
	close(newfdnum);
  801fd2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fd5:	89 c7                	mov    %eax,%edi
  801fd7:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  801fde:	00 00 00 
  801fe1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801fe3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801fe6:	48 98                	cltq   
  801fe8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801fee:	48 c1 e0 0c          	shl    $0xc,%rax
  801ff2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801ff6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ffa:	48 89 c7             	mov    %rax,%rdi
  801ffd:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802004:	00 00 00 
  802007:	ff d0                	callq  *%rax
  802009:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80200d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802011:	48 89 c7             	mov    %rax,%rdi
  802014:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  80201b:	00 00 00 
  80201e:	ff d0                	callq  *%rax
  802020:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802024:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802028:	48 c1 e8 15          	shr    $0x15,%rax
  80202c:	48 89 c2             	mov    %rax,%rdx
  80202f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802036:	01 00 00 
  802039:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80203d:	83 e0 01             	and    $0x1,%eax
  802040:	48 85 c0             	test   %rax,%rax
  802043:	74 73                	je     8020b8 <dup+0x11d>
  802045:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802049:	48 c1 e8 0c          	shr    $0xc,%rax
  80204d:	48 89 c2             	mov    %rax,%rdx
  802050:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802057:	01 00 00 
  80205a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80205e:	83 e0 01             	and    $0x1,%eax
  802061:	48 85 c0             	test   %rax,%rax
  802064:	74 52                	je     8020b8 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206a:	48 c1 e8 0c          	shr    $0xc,%rax
  80206e:	48 89 c2             	mov    %rax,%rdx
  802071:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802078:	01 00 00 
  80207b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80207f:	25 07 0e 00 00       	and    $0xe07,%eax
  802084:	89 c1                	mov    %eax,%ecx
  802086:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80208a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80208e:	41 89 c8             	mov    %ecx,%r8d
  802091:	48 89 d1             	mov    %rdx,%rcx
  802094:	ba 00 00 00 00       	mov    $0x0,%edx
  802099:	48 89 c6             	mov    %rax,%rsi
  80209c:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a1:	48 b8 2a 18 80 00 00 	movabs $0x80182a,%rax
  8020a8:	00 00 00 
  8020ab:	ff d0                	callq  *%rax
  8020ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020b4:	79 02                	jns    8020b8 <dup+0x11d>
			goto err;
  8020b6:	eb 57                	jmp    80210f <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020bc:	48 c1 e8 0c          	shr    $0xc,%rax
  8020c0:	48 89 c2             	mov    %rax,%rdx
  8020c3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020ca:	01 00 00 
  8020cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d1:	25 07 0e 00 00       	and    $0xe07,%eax
  8020d6:	89 c1                	mov    %eax,%ecx
  8020d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020e0:	41 89 c8             	mov    %ecx,%r8d
  8020e3:	48 89 d1             	mov    %rdx,%rcx
  8020e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8020eb:	48 89 c6             	mov    %rax,%rsi
  8020ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f3:	48 b8 2a 18 80 00 00 	movabs $0x80182a,%rax
  8020fa:	00 00 00 
  8020fd:	ff d0                	callq  *%rax
  8020ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802102:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802106:	79 02                	jns    80210a <dup+0x16f>
		goto err;
  802108:	eb 05                	jmp    80210f <dup+0x174>

	return newfdnum;
  80210a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80210d:	eb 33                	jmp    802142 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  80210f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802113:	48 89 c6             	mov    %rax,%rsi
  802116:	bf 00 00 00 00       	mov    $0x0,%edi
  80211b:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  802122:	00 00 00 
  802125:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802127:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80212b:	48 89 c6             	mov    %rax,%rsi
  80212e:	bf 00 00 00 00       	mov    $0x0,%edi
  802133:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  80213a:	00 00 00 
  80213d:	ff d0                	callq  *%rax
	return r;
  80213f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802142:	c9                   	leaveq 
  802143:	c3                   	retq   

0000000000802144 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802144:	55                   	push   %rbp
  802145:	48 89 e5             	mov    %rsp,%rbp
  802148:	48 83 ec 40          	sub    $0x40,%rsp
  80214c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80214f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802153:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802157:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80215b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80215e:	48 89 d6             	mov    %rdx,%rsi
  802161:	89 c7                	mov    %eax,%edi
  802163:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  80216a:	00 00 00 
  80216d:	ff d0                	callq  *%rax
  80216f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802172:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802176:	78 24                	js     80219c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802178:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217c:	8b 00                	mov    (%rax),%eax
  80217e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802182:	48 89 d6             	mov    %rdx,%rsi
  802185:	89 c7                	mov    %eax,%edi
  802187:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  80218e:	00 00 00 
  802191:	ff d0                	callq  *%rax
  802193:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802196:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80219a:	79 05                	jns    8021a1 <read+0x5d>
		return r;
  80219c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219f:	eb 76                	jmp    802217 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021a5:	8b 40 08             	mov    0x8(%rax),%eax
  8021a8:	83 e0 03             	and    $0x3,%eax
  8021ab:	83 f8 01             	cmp    $0x1,%eax
  8021ae:	75 3a                	jne    8021ea <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8021b0:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8021b7:	00 00 00 
  8021ba:	48 8b 00             	mov    (%rax),%rax
  8021bd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8021c3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8021c6:	89 c6                	mov    %eax,%esi
  8021c8:	48 bf 1f 3b 80 00 00 	movabs $0x803b1f,%rdi
  8021cf:	00 00 00 
  8021d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d7:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  8021de:	00 00 00 
  8021e1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8021e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021e8:	eb 2d                	jmp    802217 <read+0xd3>
	}
	if (!dev->dev_read)
  8021ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ee:	48 8b 40 10          	mov    0x10(%rax),%rax
  8021f2:	48 85 c0             	test   %rax,%rax
  8021f5:	75 07                	jne    8021fe <read+0xba>
		return -E_NOT_SUPP;
  8021f7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8021fc:	eb 19                	jmp    802217 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8021fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802202:	48 8b 40 10          	mov    0x10(%rax),%rax
  802206:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80220a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80220e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802212:	48 89 cf             	mov    %rcx,%rdi
  802215:	ff d0                	callq  *%rax
}
  802217:	c9                   	leaveq 
  802218:	c3                   	retq   

0000000000802219 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802219:	55                   	push   %rbp
  80221a:	48 89 e5             	mov    %rsp,%rbp
  80221d:	48 83 ec 30          	sub    $0x30,%rsp
  802221:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802224:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802228:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80222c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802233:	eb 49                	jmp    80227e <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802235:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802238:	48 98                	cltq   
  80223a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80223e:	48 29 c2             	sub    %rax,%rdx
  802241:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802244:	48 63 c8             	movslq %eax,%rcx
  802247:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80224b:	48 01 c1             	add    %rax,%rcx
  80224e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802251:	48 89 ce             	mov    %rcx,%rsi
  802254:	89 c7                	mov    %eax,%edi
  802256:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  80225d:	00 00 00 
  802260:	ff d0                	callq  *%rax
  802262:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802265:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802269:	79 05                	jns    802270 <readn+0x57>
			return m;
  80226b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80226e:	eb 1c                	jmp    80228c <readn+0x73>
		if (m == 0)
  802270:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802274:	75 02                	jne    802278 <readn+0x5f>
			break;
  802276:	eb 11                	jmp    802289 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802278:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80227b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80227e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802281:	48 98                	cltq   
  802283:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802287:	72 ac                	jb     802235 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802289:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80228c:	c9                   	leaveq 
  80228d:	c3                   	retq   

000000000080228e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80228e:	55                   	push   %rbp
  80228f:	48 89 e5             	mov    %rsp,%rbp
  802292:	48 83 ec 40          	sub    $0x40,%rsp
  802296:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802299:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80229d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022a1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022a5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022a8:	48 89 d6             	mov    %rdx,%rsi
  8022ab:	89 c7                	mov    %eax,%edi
  8022ad:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  8022b4:	00 00 00 
  8022b7:	ff d0                	callq  *%rax
  8022b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022c0:	78 24                	js     8022e6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c6:	8b 00                	mov    (%rax),%eax
  8022c8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022cc:	48 89 d6             	mov    %rdx,%rsi
  8022cf:	89 c7                	mov    %eax,%edi
  8022d1:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  8022d8:	00 00 00 
  8022db:	ff d0                	callq  *%rax
  8022dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022e4:	79 05                	jns    8022eb <write+0x5d>
		return r;
  8022e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e9:	eb 75                	jmp    802360 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ef:	8b 40 08             	mov    0x8(%rax),%eax
  8022f2:	83 e0 03             	and    $0x3,%eax
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	75 3a                	jne    802333 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8022f9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802300:	00 00 00 
  802303:	48 8b 00             	mov    (%rax),%rax
  802306:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80230c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80230f:	89 c6                	mov    %eax,%esi
  802311:	48 bf 3b 3b 80 00 00 	movabs $0x803b3b,%rdi
  802318:	00 00 00 
  80231b:	b8 00 00 00 00       	mov    $0x0,%eax
  802320:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  802327:	00 00 00 
  80232a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80232c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802331:	eb 2d                	jmp    802360 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802333:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802337:	48 8b 40 18          	mov    0x18(%rax),%rax
  80233b:	48 85 c0             	test   %rax,%rax
  80233e:	75 07                	jne    802347 <write+0xb9>
		return -E_NOT_SUPP;
  802340:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802345:	eb 19                	jmp    802360 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802347:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80234b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80234f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802353:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802357:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80235b:	48 89 cf             	mov    %rcx,%rdi
  80235e:	ff d0                	callq  *%rax
}
  802360:	c9                   	leaveq 
  802361:	c3                   	retq   

0000000000802362 <seek>:

int
seek(int fdnum, off_t offset)
{
  802362:	55                   	push   %rbp
  802363:	48 89 e5             	mov    %rsp,%rbp
  802366:	48 83 ec 18          	sub    $0x18,%rsp
  80236a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80236d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802370:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802374:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802377:	48 89 d6             	mov    %rdx,%rsi
  80237a:	89 c7                	mov    %eax,%edi
  80237c:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  802383:	00 00 00 
  802386:	ff d0                	callq  *%rax
  802388:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80238b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80238f:	79 05                	jns    802396 <seek+0x34>
		return r;
  802391:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802394:	eb 0f                	jmp    8023a5 <seek+0x43>
	fd->fd_offset = offset;
  802396:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80239a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80239d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8023a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a5:	c9                   	leaveq 
  8023a6:	c3                   	retq   

00000000008023a7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023a7:	55                   	push   %rbp
  8023a8:	48 89 e5             	mov    %rsp,%rbp
  8023ab:	48 83 ec 30          	sub    $0x30,%rsp
  8023af:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023b2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023b5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8023b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8023bc:	48 89 d6             	mov    %rdx,%rsi
  8023bf:	89 c7                	mov    %eax,%edi
  8023c1:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  8023c8:	00 00 00 
  8023cb:	ff d0                	callq  *%rax
  8023cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023d4:	78 24                	js     8023fa <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023da:	8b 00                	mov    (%rax),%eax
  8023dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023e0:	48 89 d6             	mov    %rdx,%rsi
  8023e3:	89 c7                	mov    %eax,%edi
  8023e5:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  8023ec:	00 00 00 
  8023ef:	ff d0                	callq  *%rax
  8023f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023f8:	79 05                	jns    8023ff <ftruncate+0x58>
		return r;
  8023fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fd:	eb 72                	jmp    802471 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802403:	8b 40 08             	mov    0x8(%rax),%eax
  802406:	83 e0 03             	and    $0x3,%eax
  802409:	85 c0                	test   %eax,%eax
  80240b:	75 3a                	jne    802447 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80240d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802414:	00 00 00 
  802417:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80241a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802420:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802423:	89 c6                	mov    %eax,%esi
  802425:	48 bf 58 3b 80 00 00 	movabs $0x803b58,%rdi
  80242c:	00 00 00 
  80242f:	b8 00 00 00 00       	mov    $0x0,%eax
  802434:	48 b9 f6 02 80 00 00 	movabs $0x8002f6,%rcx
  80243b:	00 00 00 
  80243e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802440:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802445:	eb 2a                	jmp    802471 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80244f:	48 85 c0             	test   %rax,%rax
  802452:	75 07                	jne    80245b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802454:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802459:	eb 16                	jmp    802471 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80245b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80245f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802463:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802467:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80246a:	89 ce                	mov    %ecx,%esi
  80246c:	48 89 d7             	mov    %rdx,%rdi
  80246f:	ff d0                	callq  *%rax
}
  802471:	c9                   	leaveq 
  802472:	c3                   	retq   

0000000000802473 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802473:	55                   	push   %rbp
  802474:	48 89 e5             	mov    %rsp,%rbp
  802477:	48 83 ec 30          	sub    $0x30,%rsp
  80247b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80247e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802482:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802486:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802489:	48 89 d6             	mov    %rdx,%rsi
  80248c:	89 c7                	mov    %eax,%edi
  80248e:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  802495:	00 00 00 
  802498:	ff d0                	callq  *%rax
  80249a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80249d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a1:	78 24                	js     8024c7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024a7:	8b 00                	mov    (%rax),%eax
  8024a9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024ad:	48 89 d6             	mov    %rdx,%rsi
  8024b0:	89 c7                	mov    %eax,%edi
  8024b2:	48 b8 6b 1e 80 00 00 	movabs $0x801e6b,%rax
  8024b9:	00 00 00 
  8024bc:	ff d0                	callq  *%rax
  8024be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c5:	79 05                	jns    8024cc <fstat+0x59>
		return r;
  8024c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ca:	eb 5e                	jmp    80252a <fstat+0xb7>
	if (!dev->dev_stat)
  8024cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8024d4:	48 85 c0             	test   %rax,%rax
  8024d7:	75 07                	jne    8024e0 <fstat+0x6d>
		return -E_NOT_SUPP;
  8024d9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024de:	eb 4a                	jmp    80252a <fstat+0xb7>
	stat->st_name[0] = 0;
  8024e0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024e4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8024e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8024f2:	00 00 00 
	stat->st_isdir = 0;
  8024f5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024f9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802500:	00 00 00 
	stat->st_dev = dev;
  802503:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802507:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80250b:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802516:	48 8b 40 28          	mov    0x28(%rax),%rax
  80251a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80251e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802522:	48 89 ce             	mov    %rcx,%rsi
  802525:	48 89 d7             	mov    %rdx,%rdi
  802528:	ff d0                	callq  *%rax
}
  80252a:	c9                   	leaveq 
  80252b:	c3                   	retq   

000000000080252c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80252c:	55                   	push   %rbp
  80252d:	48 89 e5             	mov    %rsp,%rbp
  802530:	48 83 ec 20          	sub    $0x20,%rsp
  802534:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802538:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80253c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802540:	be 00 00 00 00       	mov    $0x0,%esi
  802545:	48 89 c7             	mov    %rax,%rdi
  802548:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  80254f:	00 00 00 
  802552:	ff d0                	callq  *%rax
  802554:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802557:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255b:	79 05                	jns    802562 <stat+0x36>
		return fd;
  80255d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802560:	eb 2f                	jmp    802591 <stat+0x65>
	r = fstat(fd, stat);
  802562:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802566:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802569:	48 89 d6             	mov    %rdx,%rsi
  80256c:	89 c7                	mov    %eax,%edi
  80256e:	48 b8 73 24 80 00 00 	movabs $0x802473,%rax
  802575:	00 00 00 
  802578:	ff d0                	callq  *%rax
  80257a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80257d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802580:	89 c7                	mov    %eax,%edi
  802582:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  802589:	00 00 00 
  80258c:	ff d0                	callq  *%rax
	return r;
  80258e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802591:	c9                   	leaveq 
  802592:	c3                   	retq   

0000000000802593 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802593:	55                   	push   %rbp
  802594:	48 89 e5             	mov    %rsp,%rbp
  802597:	48 83 ec 10          	sub    $0x10,%rsp
  80259b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80259e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8025a2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8025a9:	00 00 00 
  8025ac:	8b 00                	mov    (%rax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	75 1d                	jne    8025cf <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8025b2:	bf 01 00 00 00       	mov    $0x1,%edi
  8025b7:	48 b8 aa 1b 80 00 00 	movabs $0x801baa,%rax
  8025be:	00 00 00 
  8025c1:	ff d0                	callq  *%rax
  8025c3:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8025ca:	00 00 00 
  8025cd:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025cf:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8025d6:	00 00 00 
  8025d9:	8b 00                	mov    (%rax),%eax
  8025db:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8025de:	b9 07 00 00 00       	mov    $0x7,%ecx
  8025e3:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8025ea:	00 00 00 
  8025ed:	89 c7                	mov    %eax,%edi
  8025ef:	48 b8 0d 1b 80 00 00 	movabs $0x801b0d,%rax
  8025f6:	00 00 00 
  8025f9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8025fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802604:	48 89 c6             	mov    %rax,%rsi
  802607:	bf 00 00 00 00       	mov    $0x0,%edi
  80260c:	48 b8 47 1a 80 00 00 	movabs $0x801a47,%rax
  802613:	00 00 00 
  802616:	ff d0                	callq  *%rax
}
  802618:	c9                   	leaveq 
  802619:	c3                   	retq   

000000000080261a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80261a:	55                   	push   %rbp
  80261b:	48 89 e5             	mov    %rsp,%rbp
  80261e:	48 83 ec 20          	sub    $0x20,%rsp
  802622:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802626:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262d:	48 89 c7             	mov    %rax,%rdi
  802630:	48 b8 3f 0e 80 00 00 	movabs $0x800e3f,%rax
  802637:	00 00 00 
  80263a:	ff d0                	callq  *%rax
  80263c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802641:	7e 0a                	jle    80264d <open+0x33>
  802643:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802648:	e9 a5 00 00 00       	jmpq   8026f2 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  80264d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802651:	48 89 c7             	mov    %rax,%rdi
  802654:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  80265b:	00 00 00 
  80265e:	ff d0                	callq  *%rax
  802660:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802663:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802667:	79 08                	jns    802671 <open+0x57>
		return r;
  802669:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80266c:	e9 81 00 00 00       	jmpq   8026f2 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802671:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802678:	00 00 00 
  80267b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80267e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802684:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802688:	48 89 c6             	mov    %rax,%rsi
  80268b:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802692:	00 00 00 
  802695:	48 b8 ab 0e 80 00 00 	movabs $0x800eab,%rax
  80269c:	00 00 00 
  80269f:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  8026a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026a5:	48 89 c6             	mov    %rax,%rsi
  8026a8:	bf 01 00 00 00       	mov    $0x1,%edi
  8026ad:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  8026b4:	00 00 00 
  8026b7:	ff d0                	callq  *%rax
  8026b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c0:	79 1d                	jns    8026df <open+0xc5>
		fd_close(fd, 0);
  8026c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026c6:	be 00 00 00 00       	mov    $0x0,%esi
  8026cb:	48 89 c7             	mov    %rax,%rdi
  8026ce:	48 b8 a2 1d 80 00 00 	movabs $0x801da2,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	callq  *%rax
		return r;
  8026da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026dd:	eb 13                	jmp    8026f2 <open+0xd8>
	}
	return fd2num(fd);
  8026df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e3:	48 89 c7             	mov    %rax,%rdi
  8026e6:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  8026ed:	00 00 00 
  8026f0:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  8026f2:	c9                   	leaveq 
  8026f3:	c3                   	retq   

00000000008026f4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8026f4:	55                   	push   %rbp
  8026f5:	48 89 e5             	mov    %rsp,%rbp
  8026f8:	48 83 ec 10          	sub    $0x10,%rsp
  8026fc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802700:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802704:	8b 50 0c             	mov    0xc(%rax),%edx
  802707:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80270e:	00 00 00 
  802711:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802713:	be 00 00 00 00       	mov    $0x0,%esi
  802718:	bf 06 00 00 00       	mov    $0x6,%edi
  80271d:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  802724:	00 00 00 
  802727:	ff d0                	callq  *%rax
}
  802729:	c9                   	leaveq 
  80272a:	c3                   	retq   

000000000080272b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80272b:	55                   	push   %rbp
  80272c:	48 89 e5             	mov    %rsp,%rbp
  80272f:	48 83 ec 30          	sub    $0x30,%rsp
  802733:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802737:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80273b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80273f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802743:	8b 50 0c             	mov    0xc(%rax),%edx
  802746:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80274d:	00 00 00 
  802750:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802752:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802759:	00 00 00 
  80275c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802760:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802764:	be 00 00 00 00       	mov    $0x0,%esi
  802769:	bf 03 00 00 00       	mov    $0x3,%edi
  80276e:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  802775:	00 00 00 
  802778:	ff d0                	callq  *%rax
  80277a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802781:	79 05                	jns    802788 <devfile_read+0x5d>
		return r;
  802783:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802786:	eb 26                	jmp    8027ae <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802788:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278b:	48 63 d0             	movslq %eax,%rdx
  80278e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802792:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802799:	00 00 00 
  80279c:	48 89 c7             	mov    %rax,%rdi
  80279f:	48 b8 e6 12 80 00 00 	movabs $0x8012e6,%rax
  8027a6:	00 00 00 
  8027a9:	ff d0                	callq  *%rax
	return r;
  8027ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8027ae:	c9                   	leaveq 
  8027af:	c3                   	retq   

00000000008027b0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8027b0:	55                   	push   %rbp
  8027b1:	48 89 e5             	mov    %rsp,%rbp
  8027b4:	48 83 ec 30          	sub    $0x30,%rsp
  8027b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027bc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027c0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  8027c4:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  8027cb:	00 
	n = n > max ? max : n;
  8027cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027d0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8027d4:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8027d9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8027dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e1:	8b 50 0c             	mov    0xc(%rax),%edx
  8027e4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027eb:	00 00 00 
  8027ee:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8027f0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027f7:	00 00 00 
  8027fa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027fe:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802802:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802806:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80280a:	48 89 c6             	mov    %rax,%rsi
  80280d:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802814:	00 00 00 
  802817:	48 b8 e6 12 80 00 00 	movabs $0x8012e6,%rax
  80281e:	00 00 00 
  802821:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802823:	be 00 00 00 00       	mov    $0x0,%esi
  802828:	bf 04 00 00 00       	mov    $0x4,%edi
  80282d:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  802834:	00 00 00 
  802837:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802839:	c9                   	leaveq 
  80283a:	c3                   	retq   

000000000080283b <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80283b:	55                   	push   %rbp
  80283c:	48 89 e5             	mov    %rsp,%rbp
  80283f:	48 83 ec 20          	sub    $0x20,%rsp
  802843:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802847:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80284b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80284f:	8b 50 0c             	mov    0xc(%rax),%edx
  802852:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802859:	00 00 00 
  80285c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80285e:	be 00 00 00 00       	mov    $0x0,%esi
  802863:	bf 05 00 00 00       	mov    $0x5,%edi
  802868:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  80286f:	00 00 00 
  802872:	ff d0                	callq  *%rax
  802874:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802877:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287b:	79 05                	jns    802882 <devfile_stat+0x47>
		return r;
  80287d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802880:	eb 56                	jmp    8028d8 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802882:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802886:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80288d:	00 00 00 
  802890:	48 89 c7             	mov    %rax,%rdi
  802893:	48 b8 ab 0e 80 00 00 	movabs $0x800eab,%rax
  80289a:	00 00 00 
  80289d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80289f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028a6:	00 00 00 
  8028a9:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8028af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028b3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8028b9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028c0:	00 00 00 
  8028c3:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8028c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028cd:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8028d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d8:	c9                   	leaveq 
  8028d9:	c3                   	retq   

00000000008028da <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8028da:	55                   	push   %rbp
  8028db:	48 89 e5             	mov    %rsp,%rbp
  8028de:	48 83 ec 10          	sub    $0x10,%rsp
  8028e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8028e6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8028e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028ed:	8b 50 0c             	mov    0xc(%rax),%edx
  8028f0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028f7:	00 00 00 
  8028fa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8028fc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802903:	00 00 00 
  802906:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802909:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80290c:	be 00 00 00 00       	mov    $0x0,%esi
  802911:	bf 02 00 00 00       	mov    $0x2,%edi
  802916:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  80291d:	00 00 00 
  802920:	ff d0                	callq  *%rax
}
  802922:	c9                   	leaveq 
  802923:	c3                   	retq   

0000000000802924 <remove>:

// Delete a file
int
remove(const char *path)
{
  802924:	55                   	push   %rbp
  802925:	48 89 e5             	mov    %rsp,%rbp
  802928:	48 83 ec 10          	sub    $0x10,%rsp
  80292c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802930:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802934:	48 89 c7             	mov    %rax,%rdi
  802937:	48 b8 3f 0e 80 00 00 	movabs $0x800e3f,%rax
  80293e:	00 00 00 
  802941:	ff d0                	callq  *%rax
  802943:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802948:	7e 07                	jle    802951 <remove+0x2d>
		return -E_BAD_PATH;
  80294a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80294f:	eb 33                	jmp    802984 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802951:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802955:	48 89 c6             	mov    %rax,%rsi
  802958:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  80295f:	00 00 00 
  802962:	48 b8 ab 0e 80 00 00 	movabs $0x800eab,%rax
  802969:	00 00 00 
  80296c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80296e:	be 00 00 00 00       	mov    $0x0,%esi
  802973:	bf 07 00 00 00       	mov    $0x7,%edi
  802978:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  80297f:	00 00 00 
  802982:	ff d0                	callq  *%rax
}
  802984:	c9                   	leaveq 
  802985:	c3                   	retq   

0000000000802986 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802986:	55                   	push   %rbp
  802987:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80298a:	be 00 00 00 00       	mov    $0x0,%esi
  80298f:	bf 08 00 00 00       	mov    $0x8,%edi
  802994:	48 b8 93 25 80 00 00 	movabs $0x802593,%rax
  80299b:	00 00 00 
  80299e:	ff d0                	callq  *%rax
}
  8029a0:	5d                   	pop    %rbp
  8029a1:	c3                   	retq   

00000000008029a2 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8029a2:	55                   	push   %rbp
  8029a3:	48 89 e5             	mov    %rsp,%rbp
  8029a6:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8029ad:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8029b4:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8029bb:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8029c2:	be 00 00 00 00       	mov    $0x0,%esi
  8029c7:	48 89 c7             	mov    %rax,%rdi
  8029ca:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  8029d1:	00 00 00 
  8029d4:	ff d0                	callq  *%rax
  8029d6:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8029d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029dd:	79 28                	jns    802a07 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8029df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e2:	89 c6                	mov    %eax,%esi
  8029e4:	48 bf 7e 3b 80 00 00 	movabs $0x803b7e,%rdi
  8029eb:	00 00 00 
  8029ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f3:	48 ba f6 02 80 00 00 	movabs $0x8002f6,%rdx
  8029fa:	00 00 00 
  8029fd:	ff d2                	callq  *%rdx
		return fd_src;
  8029ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a02:	e9 74 01 00 00       	jmpq   802b7b <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802a07:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802a0e:	be 01 01 00 00       	mov    $0x101,%esi
  802a13:	48 89 c7             	mov    %rax,%rdi
  802a16:	48 b8 1a 26 80 00 00 	movabs $0x80261a,%rax
  802a1d:	00 00 00 
  802a20:	ff d0                	callq  *%rax
  802a22:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a25:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a29:	79 39                	jns    802a64 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a2e:	89 c6                	mov    %eax,%esi
  802a30:	48 bf 94 3b 80 00 00 	movabs $0x803b94,%rdi
  802a37:	00 00 00 
  802a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3f:	48 ba f6 02 80 00 00 	movabs $0x8002f6,%rdx
  802a46:	00 00 00 
  802a49:	ff d2                	callq  *%rdx
		close(fd_src);
  802a4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4e:	89 c7                	mov    %eax,%edi
  802a50:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  802a57:	00 00 00 
  802a5a:	ff d0                	callq  *%rax
		return fd_dest;
  802a5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a5f:	e9 17 01 00 00       	jmpq   802b7b <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802a64:	eb 74                	jmp    802ada <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802a66:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a69:	48 63 d0             	movslq %eax,%rdx
  802a6c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802a73:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a76:	48 89 ce             	mov    %rcx,%rsi
  802a79:	89 c7                	mov    %eax,%edi
  802a7b:	48 b8 8e 22 80 00 00 	movabs $0x80228e,%rax
  802a82:	00 00 00 
  802a85:	ff d0                	callq  *%rax
  802a87:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802a8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802a8e:	79 4a                	jns    802ada <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802a90:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802a93:	89 c6                	mov    %eax,%esi
  802a95:	48 bf ae 3b 80 00 00 	movabs $0x803bae,%rdi
  802a9c:	00 00 00 
  802a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa4:	48 ba f6 02 80 00 00 	movabs $0x8002f6,%rdx
  802aab:	00 00 00 
  802aae:	ff d2                	callq  *%rdx
			close(fd_src);
  802ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab3:	89 c7                	mov    %eax,%edi
  802ab5:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  802abc:	00 00 00 
  802abf:	ff d0                	callq  *%rax
			close(fd_dest);
  802ac1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ac4:	89 c7                	mov    %eax,%edi
  802ac6:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  802acd:	00 00 00 
  802ad0:	ff d0                	callq  *%rax
			return write_size;
  802ad2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802ad5:	e9 a1 00 00 00       	jmpq   802b7b <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802ada:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802ae1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae4:	ba 00 02 00 00       	mov    $0x200,%edx
  802ae9:	48 89 ce             	mov    %rcx,%rsi
  802aec:	89 c7                	mov    %eax,%edi
  802aee:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  802af5:	00 00 00 
  802af8:	ff d0                	callq  *%rax
  802afa:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b01:	0f 8f 5f ff ff ff    	jg     802a66 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b0b:	79 47                	jns    802b54 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802b0d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b10:	89 c6                	mov    %eax,%esi
  802b12:	48 bf c1 3b 80 00 00 	movabs $0x803bc1,%rdi
  802b19:	00 00 00 
  802b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b21:	48 ba f6 02 80 00 00 	movabs $0x8002f6,%rdx
  802b28:	00 00 00 
  802b2b:	ff d2                	callq  *%rdx
		close(fd_src);
  802b2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b30:	89 c7                	mov    %eax,%edi
  802b32:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  802b39:	00 00 00 
  802b3c:	ff d0                	callq  *%rax
		close(fd_dest);
  802b3e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b41:	89 c7                	mov    %eax,%edi
  802b43:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  802b4a:	00 00 00 
  802b4d:	ff d0                	callq  *%rax
		return read_size;
  802b4f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b52:	eb 27                	jmp    802b7b <copy+0x1d9>
	}
	close(fd_src);
  802b54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b57:	89 c7                	mov    %eax,%edi
  802b59:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  802b60:	00 00 00 
  802b63:	ff d0                	callq  *%rax
	close(fd_dest);
  802b65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b68:	89 c7                	mov    %eax,%edi
  802b6a:	48 b8 22 1f 80 00 00 	movabs $0x801f22,%rax
  802b71:	00 00 00 
  802b74:	ff d0                	callq  *%rax
	return 0;
  802b76:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802b7b:	c9                   	leaveq 
  802b7c:	c3                   	retq   

0000000000802b7d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802b7d:	55                   	push   %rbp
  802b7e:	48 89 e5             	mov    %rsp,%rbp
  802b81:	53                   	push   %rbx
  802b82:	48 83 ec 38          	sub    $0x38,%rsp
  802b86:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b8a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802b8e:	48 89 c7             	mov    %rax,%rdi
  802b91:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  802b98:	00 00 00 
  802b9b:	ff d0                	callq  *%rax
  802b9d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ba0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ba4:	0f 88 bf 01 00 00    	js     802d69 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802baa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bae:	ba 07 04 00 00       	mov    $0x407,%edx
  802bb3:	48 89 c6             	mov    %rax,%rsi
  802bb6:	bf 00 00 00 00       	mov    $0x0,%edi
  802bbb:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  802bc2:	00 00 00 
  802bc5:	ff d0                	callq  *%rax
  802bc7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bca:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bce:	0f 88 95 01 00 00    	js     802d69 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802bd4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802bd8:	48 89 c7             	mov    %rax,%rdi
  802bdb:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	callq  *%rax
  802be7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802bea:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802bee:	0f 88 5d 01 00 00    	js     802d51 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bf4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802bf8:	ba 07 04 00 00       	mov    $0x407,%edx
  802bfd:	48 89 c6             	mov    %rax,%rsi
  802c00:	bf 00 00 00 00       	mov    $0x0,%edi
  802c05:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  802c0c:	00 00 00 
  802c0f:	ff d0                	callq  *%rax
  802c11:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c14:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c18:	0f 88 33 01 00 00    	js     802d51 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802c1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c22:	48 89 c7             	mov    %rax,%rdi
  802c25:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802c2c:	00 00 00 
  802c2f:	ff d0                	callq  *%rax
  802c31:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c35:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c39:	ba 07 04 00 00       	mov    $0x407,%edx
  802c3e:	48 89 c6             	mov    %rax,%rsi
  802c41:	bf 00 00 00 00       	mov    $0x0,%edi
  802c46:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  802c4d:	00 00 00 
  802c50:	ff d0                	callq  *%rax
  802c52:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c55:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c59:	79 05                	jns    802c60 <pipe+0xe3>
		goto err2;
  802c5b:	e9 d9 00 00 00       	jmpq   802d39 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c60:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c64:	48 89 c7             	mov    %rax,%rdi
  802c67:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802c6e:	00 00 00 
  802c71:	ff d0                	callq  *%rax
  802c73:	48 89 c2             	mov    %rax,%rdx
  802c76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c7a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802c80:	48 89 d1             	mov    %rdx,%rcx
  802c83:	ba 00 00 00 00       	mov    $0x0,%edx
  802c88:	48 89 c6             	mov    %rax,%rsi
  802c8b:	bf 00 00 00 00       	mov    $0x0,%edi
  802c90:	48 b8 2a 18 80 00 00 	movabs $0x80182a,%rax
  802c97:	00 00 00 
  802c9a:	ff d0                	callq  *%rax
  802c9c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ca3:	79 1b                	jns    802cc0 <pipe+0x143>
		goto err3;
  802ca5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802ca6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802caa:	48 89 c6             	mov    %rax,%rsi
  802cad:	bf 00 00 00 00       	mov    $0x0,%edi
  802cb2:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  802cb9:	00 00 00 
  802cbc:	ff d0                	callq  *%rax
  802cbe:	eb 79                	jmp    802d39 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802cc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cc4:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802ccb:	00 00 00 
  802cce:	8b 12                	mov    (%rdx),%edx
  802cd0:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802cd2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cd6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802cdd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ce1:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802ce8:	00 00 00 
  802ceb:	8b 12                	mov    (%rdx),%edx
  802ced:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802cef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cf3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802cfa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cfe:	48 89 c7             	mov    %rax,%rdi
  802d01:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  802d08:	00 00 00 
  802d0b:	ff d0                	callq  *%rax
  802d0d:	89 c2                	mov    %eax,%edx
  802d0f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d13:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802d15:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d19:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802d1d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d21:	48 89 c7             	mov    %rax,%rdi
  802d24:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  802d2b:	00 00 00 
  802d2e:	ff d0                	callq  *%rax
  802d30:	89 03                	mov    %eax,(%rbx)
	return 0;
  802d32:	b8 00 00 00 00       	mov    $0x0,%eax
  802d37:	eb 33                	jmp    802d6c <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802d39:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d3d:	48 89 c6             	mov    %rax,%rsi
  802d40:	bf 00 00 00 00       	mov    $0x0,%edi
  802d45:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  802d4c:	00 00 00 
  802d4f:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802d51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d55:	48 89 c6             	mov    %rax,%rsi
  802d58:	bf 00 00 00 00       	mov    $0x0,%edi
  802d5d:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  802d64:	00 00 00 
  802d67:	ff d0                	callq  *%rax
err:
	return r;
  802d69:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802d6c:	48 83 c4 38          	add    $0x38,%rsp
  802d70:	5b                   	pop    %rbx
  802d71:	5d                   	pop    %rbp
  802d72:	c3                   	retq   

0000000000802d73 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802d73:	55                   	push   %rbp
  802d74:	48 89 e5             	mov    %rsp,%rbp
  802d77:	53                   	push   %rbx
  802d78:	48 83 ec 28          	sub    $0x28,%rsp
  802d7c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802d80:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802d84:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802d8b:	00 00 00 
  802d8e:	48 8b 00             	mov    (%rax),%rax
  802d91:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802d97:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802d9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d9e:	48 89 c7             	mov    %rax,%rdi
  802da1:	48 b8 0d 35 80 00 00 	movabs $0x80350d,%rax
  802da8:	00 00 00 
  802dab:	ff d0                	callq  *%rax
  802dad:	89 c3                	mov    %eax,%ebx
  802daf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802db3:	48 89 c7             	mov    %rax,%rdi
  802db6:	48 b8 0d 35 80 00 00 	movabs $0x80350d,%rax
  802dbd:	00 00 00 
  802dc0:	ff d0                	callq  *%rax
  802dc2:	39 c3                	cmp    %eax,%ebx
  802dc4:	0f 94 c0             	sete   %al
  802dc7:	0f b6 c0             	movzbl %al,%eax
  802dca:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802dcd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802dd4:	00 00 00 
  802dd7:	48 8b 00             	mov    (%rax),%rax
  802dda:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802de0:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802de3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802de6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802de9:	75 05                	jne    802df0 <_pipeisclosed+0x7d>
			return ret;
  802deb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802dee:	eb 4f                	jmp    802e3f <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802df0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802df3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802df6:	74 42                	je     802e3a <_pipeisclosed+0xc7>
  802df8:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802dfc:	75 3c                	jne    802e3a <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802dfe:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e05:	00 00 00 
  802e08:	48 8b 00             	mov    (%rax),%rax
  802e0b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802e11:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e17:	89 c6                	mov    %eax,%esi
  802e19:	48 bf dc 3b 80 00 00 	movabs $0x803bdc,%rdi
  802e20:	00 00 00 
  802e23:	b8 00 00 00 00       	mov    $0x0,%eax
  802e28:	49 b8 f6 02 80 00 00 	movabs $0x8002f6,%r8
  802e2f:	00 00 00 
  802e32:	41 ff d0             	callq  *%r8
	}
  802e35:	e9 4a ff ff ff       	jmpq   802d84 <_pipeisclosed+0x11>
  802e3a:	e9 45 ff ff ff       	jmpq   802d84 <_pipeisclosed+0x11>
}
  802e3f:	48 83 c4 28          	add    $0x28,%rsp
  802e43:	5b                   	pop    %rbx
  802e44:	5d                   	pop    %rbp
  802e45:	c3                   	retq   

0000000000802e46 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802e46:	55                   	push   %rbp
  802e47:	48 89 e5             	mov    %rsp,%rbp
  802e4a:	48 83 ec 30          	sub    $0x30,%rsp
  802e4e:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e51:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e55:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e58:	48 89 d6             	mov    %rdx,%rsi
  802e5b:	89 c7                	mov    %eax,%edi
  802e5d:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  802e64:	00 00 00 
  802e67:	ff d0                	callq  *%rax
  802e69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e70:	79 05                	jns    802e77 <pipeisclosed+0x31>
		return r;
  802e72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e75:	eb 31                	jmp    802ea8 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802e77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7b:	48 89 c7             	mov    %rax,%rdi
  802e7e:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802e85:	00 00 00 
  802e88:	ff d0                	callq  *%rax
  802e8a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802e8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802e96:	48 89 d6             	mov    %rdx,%rsi
  802e99:	48 89 c7             	mov    %rax,%rdi
  802e9c:	48 b8 73 2d 80 00 00 	movabs $0x802d73,%rax
  802ea3:	00 00 00 
  802ea6:	ff d0                	callq  *%rax
}
  802ea8:	c9                   	leaveq 
  802ea9:	c3                   	retq   

0000000000802eaa <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802eaa:	55                   	push   %rbp
  802eab:	48 89 e5             	mov    %rsp,%rbp
  802eae:	48 83 ec 40          	sub    $0x40,%rsp
  802eb2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802eb6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802eba:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802ebe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ec2:	48 89 c7             	mov    %rax,%rdi
  802ec5:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802ecc:	00 00 00 
  802ecf:	ff d0                	callq  *%rax
  802ed1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802ed5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ed9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802edd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802ee4:	00 
  802ee5:	e9 92 00 00 00       	jmpq   802f7c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802eea:	eb 41                	jmp    802f2d <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802eec:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802ef1:	74 09                	je     802efc <devpipe_read+0x52>
				return i;
  802ef3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ef7:	e9 92 00 00 00       	jmpq   802f8e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802efc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f04:	48 89 d6             	mov    %rdx,%rsi
  802f07:	48 89 c7             	mov    %rax,%rdi
  802f0a:	48 b8 73 2d 80 00 00 	movabs $0x802d73,%rax
  802f11:	00 00 00 
  802f14:	ff d0                	callq  *%rax
  802f16:	85 c0                	test   %eax,%eax
  802f18:	74 07                	je     802f21 <devpipe_read+0x77>
				return 0;
  802f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1f:	eb 6d                	jmp    802f8e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802f21:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  802f28:	00 00 00 
  802f2b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802f2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f31:	8b 10                	mov    (%rax),%edx
  802f33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f37:	8b 40 04             	mov    0x4(%rax),%eax
  802f3a:	39 c2                	cmp    %eax,%edx
  802f3c:	74 ae                	je     802eec <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802f3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f42:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f46:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802f4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f4e:	8b 00                	mov    (%rax),%eax
  802f50:	99                   	cltd   
  802f51:	c1 ea 1b             	shr    $0x1b,%edx
  802f54:	01 d0                	add    %edx,%eax
  802f56:	83 e0 1f             	and    $0x1f,%eax
  802f59:	29 d0                	sub    %edx,%eax
  802f5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f5f:	48 98                	cltq   
  802f61:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802f66:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802f68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f6c:	8b 00                	mov    (%rax),%eax
  802f6e:	8d 50 01             	lea    0x1(%rax),%edx
  802f71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f75:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f77:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802f7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f80:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802f84:	0f 82 60 ff ff ff    	jb     802eea <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802f8a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802f8e:	c9                   	leaveq 
  802f8f:	c3                   	retq   

0000000000802f90 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802f90:	55                   	push   %rbp
  802f91:	48 89 e5             	mov    %rsp,%rbp
  802f94:	48 83 ec 40          	sub    $0x40,%rsp
  802f98:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f9c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fa0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802fa4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fa8:	48 89 c7             	mov    %rax,%rdi
  802fab:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  802fb2:	00 00 00 
  802fb5:	ff d0                	callq  *%rax
  802fb7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802fbb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fbf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802fc3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802fca:	00 
  802fcb:	e9 8e 00 00 00       	jmpq   80305e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802fd0:	eb 31                	jmp    803003 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802fd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fd6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fda:	48 89 d6             	mov    %rdx,%rsi
  802fdd:	48 89 c7             	mov    %rax,%rdi
  802fe0:	48 b8 73 2d 80 00 00 	movabs $0x802d73,%rax
  802fe7:	00 00 00 
  802fea:	ff d0                	callq  *%rax
  802fec:	85 c0                	test   %eax,%eax
  802fee:	74 07                	je     802ff7 <devpipe_write+0x67>
				return 0;
  802ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff5:	eb 79                	jmp    803070 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802ff7:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  802ffe:	00 00 00 
  803001:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803007:	8b 40 04             	mov    0x4(%rax),%eax
  80300a:	48 63 d0             	movslq %eax,%rdx
  80300d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803011:	8b 00                	mov    (%rax),%eax
  803013:	48 98                	cltq   
  803015:	48 83 c0 20          	add    $0x20,%rax
  803019:	48 39 c2             	cmp    %rax,%rdx
  80301c:	73 b4                	jae    802fd2 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80301e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803022:	8b 40 04             	mov    0x4(%rax),%eax
  803025:	99                   	cltd   
  803026:	c1 ea 1b             	shr    $0x1b,%edx
  803029:	01 d0                	add    %edx,%eax
  80302b:	83 e0 1f             	and    $0x1f,%eax
  80302e:	29 d0                	sub    %edx,%eax
  803030:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803034:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803038:	48 01 ca             	add    %rcx,%rdx
  80303b:	0f b6 0a             	movzbl (%rdx),%ecx
  80303e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803042:	48 98                	cltq   
  803044:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803048:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304c:	8b 40 04             	mov    0x4(%rax),%eax
  80304f:	8d 50 01             	lea    0x1(%rax),%edx
  803052:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803056:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803059:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80305e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803062:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803066:	0f 82 64 ff ff ff    	jb     802fd0 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80306c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803070:	c9                   	leaveq 
  803071:	c3                   	retq   

0000000000803072 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803072:	55                   	push   %rbp
  803073:	48 89 e5             	mov    %rsp,%rbp
  803076:	48 83 ec 20          	sub    $0x20,%rsp
  80307a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80307e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803082:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803086:	48 89 c7             	mov    %rax,%rdi
  803089:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  803090:	00 00 00 
  803093:	ff d0                	callq  *%rax
  803095:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803099:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80309d:	48 be ef 3b 80 00 00 	movabs $0x803bef,%rsi
  8030a4:	00 00 00 
  8030a7:	48 89 c7             	mov    %rax,%rdi
  8030aa:	48 b8 ab 0e 80 00 00 	movabs $0x800eab,%rax
  8030b1:	00 00 00 
  8030b4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8030b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ba:	8b 50 04             	mov    0x4(%rax),%edx
  8030bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030c1:	8b 00                	mov    (%rax),%eax
  8030c3:	29 c2                	sub    %eax,%edx
  8030c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030c9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8030cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8030da:	00 00 00 
	stat->st_dev = &devpipe;
  8030dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030e1:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  8030e8:	00 00 00 
  8030eb:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8030f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030f7:	c9                   	leaveq 
  8030f8:	c3                   	retq   

00000000008030f9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8030f9:	55                   	push   %rbp
  8030fa:	48 89 e5             	mov    %rsp,%rbp
  8030fd:	48 83 ec 10          	sub    $0x10,%rsp
  803101:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803105:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803109:	48 89 c6             	mov    %rax,%rsi
  80310c:	bf 00 00 00 00       	mov    $0x0,%edi
  803111:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  803118:	00 00 00 
  80311b:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80311d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803121:	48 89 c7             	mov    %rax,%rdi
  803124:	48 b8 4f 1c 80 00 00 	movabs $0x801c4f,%rax
  80312b:	00 00 00 
  80312e:	ff d0                	callq  *%rax
  803130:	48 89 c6             	mov    %rax,%rsi
  803133:	bf 00 00 00 00       	mov    $0x0,%edi
  803138:	48 b8 85 18 80 00 00 	movabs $0x801885,%rax
  80313f:	00 00 00 
  803142:	ff d0                	callq  *%rax
}
  803144:	c9                   	leaveq 
  803145:	c3                   	retq   

0000000000803146 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803146:	55                   	push   %rbp
  803147:	48 89 e5             	mov    %rsp,%rbp
  80314a:	48 83 ec 20          	sub    $0x20,%rsp
  80314e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803151:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803154:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803157:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80315b:	be 01 00 00 00       	mov    $0x1,%esi
  803160:	48 89 c7             	mov    %rax,%rdi
  803163:	48 b8 92 16 80 00 00 	movabs $0x801692,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
}
  80316f:	c9                   	leaveq 
  803170:	c3                   	retq   

0000000000803171 <getchar>:

int
getchar(void)
{
  803171:	55                   	push   %rbp
  803172:	48 89 e5             	mov    %rsp,%rbp
  803175:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803179:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80317d:	ba 01 00 00 00       	mov    $0x1,%edx
  803182:	48 89 c6             	mov    %rax,%rsi
  803185:	bf 00 00 00 00       	mov    $0x0,%edi
  80318a:	48 b8 44 21 80 00 00 	movabs $0x802144,%rax
  803191:	00 00 00 
  803194:	ff d0                	callq  *%rax
  803196:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803199:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80319d:	79 05                	jns    8031a4 <getchar+0x33>
		return r;
  80319f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a2:	eb 14                	jmp    8031b8 <getchar+0x47>
	if (r < 1)
  8031a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a8:	7f 07                	jg     8031b1 <getchar+0x40>
		return -E_EOF;
  8031aa:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8031af:	eb 07                	jmp    8031b8 <getchar+0x47>
	return c;
  8031b1:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8031b5:	0f b6 c0             	movzbl %al,%eax
}
  8031b8:	c9                   	leaveq 
  8031b9:	c3                   	retq   

00000000008031ba <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8031ba:	55                   	push   %rbp
  8031bb:	48 89 e5             	mov    %rsp,%rbp
  8031be:	48 83 ec 20          	sub    $0x20,%rsp
  8031c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031c5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031cc:	48 89 d6             	mov    %rdx,%rsi
  8031cf:	89 c7                	mov    %eax,%edi
  8031d1:	48 b8 12 1d 80 00 00 	movabs $0x801d12,%rax
  8031d8:	00 00 00 
  8031db:	ff d0                	callq  *%rax
  8031dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e4:	79 05                	jns    8031eb <iscons+0x31>
		return r;
  8031e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031e9:	eb 1a                	jmp    803205 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8031eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ef:	8b 10                	mov    (%rax),%edx
  8031f1:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8031f8:	00 00 00 
  8031fb:	8b 00                	mov    (%rax),%eax
  8031fd:	39 c2                	cmp    %eax,%edx
  8031ff:	0f 94 c0             	sete   %al
  803202:	0f b6 c0             	movzbl %al,%eax
}
  803205:	c9                   	leaveq 
  803206:	c3                   	retq   

0000000000803207 <opencons>:

int
opencons(void)
{
  803207:	55                   	push   %rbp
  803208:	48 89 e5             	mov    %rsp,%rbp
  80320b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80320f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803213:	48 89 c7             	mov    %rax,%rdi
  803216:	48 b8 7a 1c 80 00 00 	movabs $0x801c7a,%rax
  80321d:	00 00 00 
  803220:	ff d0                	callq  *%rax
  803222:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803225:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803229:	79 05                	jns    803230 <opencons+0x29>
		return r;
  80322b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322e:	eb 5b                	jmp    80328b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803234:	ba 07 04 00 00       	mov    $0x407,%edx
  803239:	48 89 c6             	mov    %rax,%rsi
  80323c:	bf 00 00 00 00       	mov    $0x0,%edi
  803241:	48 b8 da 17 80 00 00 	movabs $0x8017da,%rax
  803248:	00 00 00 
  80324b:	ff d0                	callq  *%rax
  80324d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803250:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803254:	79 05                	jns    80325b <opencons+0x54>
		return r;
  803256:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803259:	eb 30                	jmp    80328b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80325b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80325f:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803266:	00 00 00 
  803269:	8b 12                	mov    (%rdx),%edx
  80326b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80326d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803271:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803278:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80327c:	48 89 c7             	mov    %rax,%rdi
  80327f:	48 b8 2c 1c 80 00 00 	movabs $0x801c2c,%rax
  803286:	00 00 00 
  803289:	ff d0                	callq  *%rax
}
  80328b:	c9                   	leaveq 
  80328c:	c3                   	retq   

000000000080328d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80328d:	55                   	push   %rbp
  80328e:	48 89 e5             	mov    %rsp,%rbp
  803291:	48 83 ec 30          	sub    $0x30,%rsp
  803295:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803299:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80329d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8032a1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8032a6:	75 07                	jne    8032af <devcons_read+0x22>
		return 0;
  8032a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ad:	eb 4b                	jmp    8032fa <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8032af:	eb 0c                	jmp    8032bd <devcons_read+0x30>
		sys_yield();
  8032b1:	48 b8 9c 17 80 00 00 	movabs $0x80179c,%rax
  8032b8:	00 00 00 
  8032bb:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8032bd:	48 b8 dc 16 80 00 00 	movabs $0x8016dc,%rax
  8032c4:	00 00 00 
  8032c7:	ff d0                	callq  *%rax
  8032c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d0:	74 df                	je     8032b1 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8032d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d6:	79 05                	jns    8032dd <devcons_read+0x50>
		return c;
  8032d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032db:	eb 1d                	jmp    8032fa <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  8032dd:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8032e1:	75 07                	jne    8032ea <devcons_read+0x5d>
		return 0;
  8032e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e8:	eb 10                	jmp    8032fa <devcons_read+0x6d>
	*(char*)vbuf = c;
  8032ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ed:	89 c2                	mov    %eax,%edx
  8032ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032f3:	88 10                	mov    %dl,(%rax)
	return 1;
  8032f5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8032fa:	c9                   	leaveq 
  8032fb:	c3                   	retq   

00000000008032fc <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8032fc:	55                   	push   %rbp
  8032fd:	48 89 e5             	mov    %rsp,%rbp
  803300:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803307:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80330e:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803315:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80331c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803323:	eb 76                	jmp    80339b <devcons_write+0x9f>
		m = n - tot;
  803325:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80332c:	89 c2                	mov    %eax,%edx
  80332e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803331:	29 c2                	sub    %eax,%edx
  803333:	89 d0                	mov    %edx,%eax
  803335:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803338:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80333b:	83 f8 7f             	cmp    $0x7f,%eax
  80333e:	76 07                	jbe    803347 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803340:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803347:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80334a:	48 63 d0             	movslq %eax,%rdx
  80334d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803350:	48 63 c8             	movslq %eax,%rcx
  803353:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80335a:	48 01 c1             	add    %rax,%rcx
  80335d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803364:	48 89 ce             	mov    %rcx,%rsi
  803367:	48 89 c7             	mov    %rax,%rdi
  80336a:	48 b8 cf 11 80 00 00 	movabs $0x8011cf,%rax
  803371:	00 00 00 
  803374:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803376:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803379:	48 63 d0             	movslq %eax,%rdx
  80337c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803383:	48 89 d6             	mov    %rdx,%rsi
  803386:	48 89 c7             	mov    %rax,%rdi
  803389:	48 b8 92 16 80 00 00 	movabs $0x801692,%rax
  803390:	00 00 00 
  803393:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803395:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803398:	01 45 fc             	add    %eax,-0x4(%rbp)
  80339b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339e:	48 98                	cltq   
  8033a0:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8033a7:	0f 82 78 ff ff ff    	jb     803325 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8033ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033b0:	c9                   	leaveq 
  8033b1:	c3                   	retq   

00000000008033b2 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8033b2:	55                   	push   %rbp
  8033b3:	48 89 e5             	mov    %rsp,%rbp
  8033b6:	48 83 ec 08          	sub    $0x8,%rsp
  8033ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8033be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033c3:	c9                   	leaveq 
  8033c4:	c3                   	retq   

00000000008033c5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8033c5:	55                   	push   %rbp
  8033c6:	48 89 e5             	mov    %rsp,%rbp
  8033c9:	48 83 ec 10          	sub    $0x10,%rsp
  8033cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8033d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8033d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033d9:	48 be fb 3b 80 00 00 	movabs $0x803bfb,%rsi
  8033e0:	00 00 00 
  8033e3:	48 89 c7             	mov    %rax,%rdi
  8033e6:	48 b8 ab 0e 80 00 00 	movabs $0x800eab,%rax
  8033ed:	00 00 00 
  8033f0:	ff d0                	callq  *%rax
	return 0;
  8033f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033f7:	c9                   	leaveq 
  8033f8:	c3                   	retq   

00000000008033f9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8033f9:	55                   	push   %rbp
  8033fa:	48 89 e5             	mov    %rsp,%rbp
  8033fd:	53                   	push   %rbx
  8033fe:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803405:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80340c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803412:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803419:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803420:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803427:	84 c0                	test   %al,%al
  803429:	74 23                	je     80344e <_panic+0x55>
  80342b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803432:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803436:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80343a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80343e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803442:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803446:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80344a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80344e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803455:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80345c:	00 00 00 
  80345f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803466:	00 00 00 
  803469:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80346d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803474:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80347b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803482:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  803489:	00 00 00 
  80348c:	48 8b 18             	mov    (%rax),%rbx
  80348f:	48 b8 5e 17 80 00 00 	movabs $0x80175e,%rax
  803496:	00 00 00 
  803499:	ff d0                	callq  *%rax
  80349b:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8034a1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8034a8:	41 89 c8             	mov    %ecx,%r8d
  8034ab:	48 89 d1             	mov    %rdx,%rcx
  8034ae:	48 89 da             	mov    %rbx,%rdx
  8034b1:	89 c6                	mov    %eax,%esi
  8034b3:	48 bf 08 3c 80 00 00 	movabs $0x803c08,%rdi
  8034ba:	00 00 00 
  8034bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c2:	49 b9 f6 02 80 00 00 	movabs $0x8002f6,%r9
  8034c9:	00 00 00 
  8034cc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8034cf:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8034d6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8034dd:	48 89 d6             	mov    %rdx,%rsi
  8034e0:	48 89 c7             	mov    %rax,%rdi
  8034e3:	48 b8 4a 02 80 00 00 	movabs $0x80024a,%rax
  8034ea:	00 00 00 
  8034ed:	ff d0                	callq  *%rax
	cprintf("\n");
  8034ef:	48 bf 2b 3c 80 00 00 	movabs $0x803c2b,%rdi
  8034f6:	00 00 00 
  8034f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fe:	48 ba f6 02 80 00 00 	movabs $0x8002f6,%rdx
  803505:	00 00 00 
  803508:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80350a:	cc                   	int3   
  80350b:	eb fd                	jmp    80350a <_panic+0x111>

000000000080350d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80350d:	55                   	push   %rbp
  80350e:	48 89 e5             	mov    %rsp,%rbp
  803511:	48 83 ec 18          	sub    $0x18,%rsp
  803515:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803519:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80351d:	48 c1 e8 15          	shr    $0x15,%rax
  803521:	48 89 c2             	mov    %rax,%rdx
  803524:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80352b:	01 00 00 
  80352e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803532:	83 e0 01             	and    $0x1,%eax
  803535:	48 85 c0             	test   %rax,%rax
  803538:	75 07                	jne    803541 <pageref+0x34>
		return 0;
  80353a:	b8 00 00 00 00       	mov    $0x0,%eax
  80353f:	eb 53                	jmp    803594 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803541:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803545:	48 c1 e8 0c          	shr    $0xc,%rax
  803549:	48 89 c2             	mov    %rax,%rdx
  80354c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803553:	01 00 00 
  803556:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80355a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80355e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803562:	83 e0 01             	and    $0x1,%eax
  803565:	48 85 c0             	test   %rax,%rax
  803568:	75 07                	jne    803571 <pageref+0x64>
		return 0;
  80356a:	b8 00 00 00 00       	mov    $0x0,%eax
  80356f:	eb 23                	jmp    803594 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803575:	48 c1 e8 0c          	shr    $0xc,%rax
  803579:	48 89 c2             	mov    %rax,%rdx
  80357c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803583:	00 00 00 
  803586:	48 c1 e2 04          	shl    $0x4,%rdx
  80358a:	48 01 d0             	add    %rdx,%rax
  80358d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803591:	0f b7 c0             	movzwl %ax,%eax
}
  803594:	c9                   	leaveq 
  803595:	c3                   	retq   
