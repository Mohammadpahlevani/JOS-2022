
obj/user/pingpong:     file format elf64-x86-64


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
  80003c:	e8 06 01 00 00       	callq  800147 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 28          	sub    $0x28,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	envid_t who;

	if ((who = fork()) != 0) {
  800053:	48 b8 ce 1d 80 00 00 	movabs $0x801dce,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800062:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800065:	85 c0                	test   %eax,%eax
  800067:	74 4e                	je     8000b7 <umain+0x74>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800069:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  80006c:	48 b8 8f 17 80 00 00 	movabs $0x80178f,%rax
  800073:	00 00 00 
  800076:	ff d0                	callq  *%rax
  800078:	89 da                	mov    %ebx,%edx
  80007a:	89 c6                	mov    %eax,%esi
  80007c:	48 bf 80 24 80 00 00 	movabs $0x802480,%rdi
  800083:	00 00 00 
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	48 b9 27 03 80 00 00 	movabs $0x800327,%rcx
  800092:	00 00 00 
  800095:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  800097:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80009a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	be 00 00 00 00       	mov    $0x0,%esi
  8000a9:	89 c7                	mov    %eax,%edi
  8000ab:	48 b8 0c 21 80 00 00 	movabs $0x80210c,%rax
  8000b2:	00 00 00 
  8000b5:	ff d0                	callq  *%rax
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  8000b7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 00 00 00       	mov    $0x0,%esi
  8000c5:	48 89 c7             	mov    %rax,%rdi
  8000c8:	48 b8 4b 20 80 00 00 	movabs $0x80204b,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax
  8000d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000d7:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  8000da:	48 b8 8f 17 80 00 00 	movabs $0x80178f,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	callq  *%rax
  8000e6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000e9:	89 d9                	mov    %ebx,%ecx
  8000eb:	89 c6                	mov    %eax,%esi
  8000ed:	48 bf 96 24 80 00 00 	movabs $0x802496,%rdi
  8000f4:	00 00 00 
  8000f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fc:	49 b8 27 03 80 00 00 	movabs $0x800327,%r8
  800103:	00 00 00 
  800106:	41 ff d0             	callq  *%r8
		if (i == 10)
  800109:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  80010d:	75 02                	jne    800111 <umain+0xce>
			return;
  80010f:	eb 2f                	jmp    800140 <umain+0xfd>
		i++;
  800111:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
		ipc_send(who, i, 0, 0);
  800115:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800118:	8b 75 ec             	mov    -0x14(%rbp),%esi
  80011b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800120:	ba 00 00 00 00       	mov    $0x0,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	48 b8 0c 21 80 00 00 	movabs $0x80210c,%rax
  80012e:	00 00 00 
  800131:	ff d0                	callq  *%rax
		if (i == 10)
  800133:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
  800137:	75 02                	jne    80013b <umain+0xf8>
			return;
  800139:	eb 05                	jmp    800140 <umain+0xfd>
	}
  80013b:	e9 77 ff ff ff       	jmpq   8000b7 <umain+0x74>

}
  800140:	48 83 c4 28          	add    $0x28,%rsp
  800144:	5b                   	pop    %rbx
  800145:	5d                   	pop    %rbp
  800146:	c3                   	retq   

0000000000800147 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 20          	sub    $0x20,%rsp
  80014f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800152:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800156:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80015d:	00 00 00 
  800160:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  800167:	48 b8 8f 17 80 00 00 	movabs $0x80178f,%rax
  80016e:	00 00 00 
  800171:	ff d0                	callq  *%rax
  800173:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  800176:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  80017d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800180:	48 63 d0             	movslq %eax,%rdx
  800183:	48 89 d0             	mov    %rdx,%rax
  800186:	48 c1 e0 03          	shl    $0x3,%rax
  80018a:	48 01 d0             	add    %rdx,%rax
  80018d:	48 c1 e0 05          	shl    $0x5,%rax
  800191:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  800198:	00 00 00 
  80019b:	48 01 c2             	add    %rax,%rdx
  80019e:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8001a5:	00 00 00 
  8001a8:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001af:	7e 14                	jle    8001c5 <libmain+0x7e>
		binaryname = argv[0];
  8001b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001b5:	48 8b 10             	mov    (%rax),%rdx
  8001b8:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  8001bf:	00 00 00 
  8001c2:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001cc:	48 89 d6             	mov    %rdx,%rsi
  8001cf:	89 c7                	mov    %eax,%edi
  8001d1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001d8:	00 00 00 
  8001db:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  8001dd:	48 b8 eb 01 80 00 00 	movabs $0x8001eb,%rax
  8001e4:	00 00 00 
  8001e7:	ff d0                	callq  *%rax
}
  8001e9:	c9                   	leaveq 
  8001ea:	c3                   	retq   

00000000008001eb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001eb:	55                   	push   %rbp
  8001ec:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8001ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f4:	48 b8 4b 17 80 00 00 	movabs $0x80174b,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
}
  800200:	5d                   	pop    %rbp
  800201:	c3                   	retq   

0000000000800202 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800202:	55                   	push   %rbp
  800203:	48 89 e5             	mov    %rsp,%rbp
  800206:	48 83 ec 10          	sub    $0x10,%rsp
  80020a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80020d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800215:	8b 00                	mov    (%rax),%eax
  800217:	8d 48 01             	lea    0x1(%rax),%ecx
  80021a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80021e:	89 0a                	mov    %ecx,(%rdx)
  800220:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800223:	89 d1                	mov    %edx,%ecx
  800225:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800229:	48 98                	cltq   
  80022b:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  80022f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800233:	8b 00                	mov    (%rax),%eax
  800235:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023a:	75 2c                	jne    800268 <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80023c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800240:	8b 00                	mov    (%rax),%eax
  800242:	48 98                	cltq   
  800244:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800248:	48 83 c2 08          	add    $0x8,%rdx
  80024c:	48 89 c6             	mov    %rax,%rsi
  80024f:	48 89 d7             	mov    %rdx,%rdi
  800252:	48 b8 c3 16 80 00 00 	movabs $0x8016c3,%rax
  800259:	00 00 00 
  80025c:	ff d0                	callq  *%rax
		b->idx = 0;
  80025e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800262:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  800268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026c:	8b 40 04             	mov    0x4(%rax),%eax
  80026f:	8d 50 01             	lea    0x1(%rax),%edx
  800272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800276:	89 50 04             	mov    %edx,0x4(%rax)
}
  800279:	c9                   	leaveq 
  80027a:	c3                   	retq   

000000000080027b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80027b:	55                   	push   %rbp
  80027c:	48 89 e5             	mov    %rsp,%rbp
  80027f:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800286:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80028d:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  800294:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80029b:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002a2:	48 8b 0a             	mov    (%rdx),%rcx
  8002a5:	48 89 08             	mov    %rcx,(%rax)
  8002a8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002ac:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002b0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002b4:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8002b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002bf:	00 00 00 
	b.cnt = 0;
  8002c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002c9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8002cc:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002d3:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002da:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002e1:	48 89 c6             	mov    %rax,%rsi
  8002e4:	48 bf 02 02 80 00 00 	movabs $0x800202,%rdi
  8002eb:	00 00 00 
  8002ee:	48 b8 da 06 80 00 00 	movabs $0x8006da,%rax
  8002f5:	00 00 00 
  8002f8:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  8002fa:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800300:	48 98                	cltq   
  800302:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800309:	48 83 c2 08          	add    $0x8,%rdx
  80030d:	48 89 c6             	mov    %rax,%rsi
  800310:	48 89 d7             	mov    %rdx,%rdi
  800313:	48 b8 c3 16 80 00 00 	movabs $0x8016c3,%rax
  80031a:	00 00 00 
  80031d:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  80031f:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800325:	c9                   	leaveq 
  800326:	c3                   	retq   

0000000000800327 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800327:	55                   	push   %rbp
  800328:	48 89 e5             	mov    %rsp,%rbp
  80032b:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800332:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800339:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800340:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800347:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80034e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800355:	84 c0                	test   %al,%al
  800357:	74 20                	je     800379 <cprintf+0x52>
  800359:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80035d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800361:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800365:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800369:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80036d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800371:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800375:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800379:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  800380:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800387:	00 00 00 
  80038a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800391:	00 00 00 
  800394:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800398:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80039f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003a6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8003ad:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003b4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003bb:	48 8b 0a             	mov    (%rdx),%rcx
  8003be:	48 89 08             	mov    %rcx,(%rax)
  8003c1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003c5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003c9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003cd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8003d1:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003d8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003df:	48 89 d6             	mov    %rdx,%rsi
  8003e2:	48 89 c7             	mov    %rax,%rdi
  8003e5:	48 b8 7b 02 80 00 00 	movabs $0x80027b,%rax
  8003ec:	00 00 00 
  8003ef:	ff d0                	callq  *%rax
  8003f1:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  8003f7:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003fd:	c9                   	leaveq 
  8003fe:	c3                   	retq   

00000000008003ff <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ff:	55                   	push   %rbp
  800400:	48 89 e5             	mov    %rsp,%rbp
  800403:	53                   	push   %rbx
  800404:	48 83 ec 38          	sub    $0x38,%rsp
  800408:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80040c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800410:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800414:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800417:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80041b:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80041f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800422:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800426:	77 3b                	ja     800463 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800428:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80042b:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80042f:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800432:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800436:	ba 00 00 00 00       	mov    $0x0,%edx
  80043b:	48 f7 f3             	div    %rbx
  80043e:	48 89 c2             	mov    %rax,%rdx
  800441:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800444:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800447:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80044b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80044f:	41 89 f9             	mov    %edi,%r9d
  800452:	48 89 c7             	mov    %rax,%rdi
  800455:	48 b8 ff 03 80 00 00 	movabs $0x8003ff,%rax
  80045c:	00 00 00 
  80045f:	ff d0                	callq  *%rax
  800461:	eb 1e                	jmp    800481 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800463:	eb 12                	jmp    800477 <printnum+0x78>
			putch(padc, putdat);
  800465:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800469:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80046c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800470:	48 89 ce             	mov    %rcx,%rsi
  800473:	89 d7                	mov    %edx,%edi
  800475:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800477:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80047b:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80047f:	7f e4                	jg     800465 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800481:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800484:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800488:	ba 00 00 00 00       	mov    $0x0,%edx
  80048d:	48 f7 f1             	div    %rcx
  800490:	48 89 d0             	mov    %rdx,%rax
  800493:	48 ba b0 25 80 00 00 	movabs $0x8025b0,%rdx
  80049a:	00 00 00 
  80049d:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004a1:	0f be d0             	movsbl %al,%edx
  8004a4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004ac:	48 89 ce             	mov    %rcx,%rsi
  8004af:	89 d7                	mov    %edx,%edi
  8004b1:	ff d0                	callq  *%rax
}
  8004b3:	48 83 c4 38          	add    $0x38,%rsp
  8004b7:	5b                   	pop    %rbx
  8004b8:	5d                   	pop    %rbp
  8004b9:	c3                   	retq   

00000000008004ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004ba:	55                   	push   %rbp
  8004bb:	48 89 e5             	mov    %rsp,%rbp
  8004be:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004c6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004c9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004cd:	7e 52                	jle    800521 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d3:	8b 00                	mov    (%rax),%eax
  8004d5:	83 f8 30             	cmp    $0x30,%eax
  8004d8:	73 24                	jae    8004fe <getuint+0x44>
  8004da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004de:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e6:	8b 00                	mov    (%rax),%eax
  8004e8:	89 c0                	mov    %eax,%eax
  8004ea:	48 01 d0             	add    %rdx,%rax
  8004ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f1:	8b 12                	mov    (%rdx),%edx
  8004f3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004fa:	89 0a                	mov    %ecx,(%rdx)
  8004fc:	eb 17                	jmp    800515 <getuint+0x5b>
  8004fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800502:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800506:	48 89 d0             	mov    %rdx,%rax
  800509:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80050d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800511:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800515:	48 8b 00             	mov    (%rax),%rax
  800518:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80051c:	e9 a3 00 00 00       	jmpq   8005c4 <getuint+0x10a>
	else if (lflag)
  800521:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800525:	74 4f                	je     800576 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800527:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052b:	8b 00                	mov    (%rax),%eax
  80052d:	83 f8 30             	cmp    $0x30,%eax
  800530:	73 24                	jae    800556 <getuint+0x9c>
  800532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800536:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80053a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053e:	8b 00                	mov    (%rax),%eax
  800540:	89 c0                	mov    %eax,%eax
  800542:	48 01 d0             	add    %rdx,%rax
  800545:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800549:	8b 12                	mov    (%rdx),%edx
  80054b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80054e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800552:	89 0a                	mov    %ecx,(%rdx)
  800554:	eb 17                	jmp    80056d <getuint+0xb3>
  800556:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80055e:	48 89 d0             	mov    %rdx,%rax
  800561:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800565:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800569:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80056d:	48 8b 00             	mov    (%rax),%rax
  800570:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800574:	eb 4e                	jmp    8005c4 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800576:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057a:	8b 00                	mov    (%rax),%eax
  80057c:	83 f8 30             	cmp    $0x30,%eax
  80057f:	73 24                	jae    8005a5 <getuint+0xeb>
  800581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800585:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800589:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058d:	8b 00                	mov    (%rax),%eax
  80058f:	89 c0                	mov    %eax,%eax
  800591:	48 01 d0             	add    %rdx,%rax
  800594:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800598:	8b 12                	mov    (%rdx),%edx
  80059a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80059d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a1:	89 0a                	mov    %ecx,(%rdx)
  8005a3:	eb 17                	jmp    8005bc <getuint+0x102>
  8005a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005ad:	48 89 d0             	mov    %rdx,%rax
  8005b0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005bc:	8b 00                	mov    (%rax),%eax
  8005be:	89 c0                	mov    %eax,%eax
  8005c0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005c8:	c9                   	leaveq 
  8005c9:	c3                   	retq   

00000000008005ca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005ca:	55                   	push   %rbp
  8005cb:	48 89 e5             	mov    %rsp,%rbp
  8005ce:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005d6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005d9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005dd:	7e 52                	jle    800631 <getint+0x67>
		x=va_arg(*ap, long long);
  8005df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e3:	8b 00                	mov    (%rax),%eax
  8005e5:	83 f8 30             	cmp    $0x30,%eax
  8005e8:	73 24                	jae    80060e <getint+0x44>
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f6:	8b 00                	mov    (%rax),%eax
  8005f8:	89 c0                	mov    %eax,%eax
  8005fa:	48 01 d0             	add    %rdx,%rax
  8005fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800601:	8b 12                	mov    (%rdx),%edx
  800603:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800606:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060a:	89 0a                	mov    %ecx,(%rdx)
  80060c:	eb 17                	jmp    800625 <getint+0x5b>
  80060e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800612:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800616:	48 89 d0             	mov    %rdx,%rax
  800619:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80061d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800621:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800625:	48 8b 00             	mov    (%rax),%rax
  800628:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80062c:	e9 a3 00 00 00       	jmpq   8006d4 <getint+0x10a>
	else if (lflag)
  800631:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800635:	74 4f                	je     800686 <getint+0xbc>
		x=va_arg(*ap, long);
  800637:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063b:	8b 00                	mov    (%rax),%eax
  80063d:	83 f8 30             	cmp    $0x30,%eax
  800640:	73 24                	jae    800666 <getint+0x9c>
  800642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800646:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80064a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064e:	8b 00                	mov    (%rax),%eax
  800650:	89 c0                	mov    %eax,%eax
  800652:	48 01 d0             	add    %rdx,%rax
  800655:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800659:	8b 12                	mov    (%rdx),%edx
  80065b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80065e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800662:	89 0a                	mov    %ecx,(%rdx)
  800664:	eb 17                	jmp    80067d <getint+0xb3>
  800666:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80066a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80066e:	48 89 d0             	mov    %rdx,%rax
  800671:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800675:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800679:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80067d:	48 8b 00             	mov    (%rax),%rax
  800680:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800684:	eb 4e                	jmp    8006d4 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068a:	8b 00                	mov    (%rax),%eax
  80068c:	83 f8 30             	cmp    $0x30,%eax
  80068f:	73 24                	jae    8006b5 <getint+0xeb>
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069d:	8b 00                	mov    (%rax),%eax
  80069f:	89 c0                	mov    %eax,%eax
  8006a1:	48 01 d0             	add    %rdx,%rax
  8006a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a8:	8b 12                	mov    (%rdx),%edx
  8006aa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ad:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b1:	89 0a                	mov    %ecx,(%rdx)
  8006b3:	eb 17                	jmp    8006cc <getint+0x102>
  8006b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006bd:	48 89 d0             	mov    %rdx,%rax
  8006c0:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cc:	8b 00                	mov    (%rax),%eax
  8006ce:	48 98                	cltq   
  8006d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006d8:	c9                   	leaveq 
  8006d9:	c3                   	retq   

00000000008006da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006da:	55                   	push   %rbp
  8006db:	48 89 e5             	mov    %rsp,%rbp
  8006de:	41 54                	push   %r12
  8006e0:	53                   	push   %rbx
  8006e1:	48 83 ec 60          	sub    $0x60,%rsp
  8006e5:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006e9:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006ed:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006f1:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006f5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006f9:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006fd:	48 8b 0a             	mov    (%rdx),%rcx
  800700:	48 89 08             	mov    %rcx,(%rax)
  800703:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800707:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80070b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80070f:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800713:	eb 17                	jmp    80072c <vprintfmt+0x52>
			if (ch == '\0')
  800715:	85 db                	test   %ebx,%ebx
  800717:	0f 84 cc 04 00 00    	je     800be9 <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  80071d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800721:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800725:	48 89 d6             	mov    %rdx,%rsi
  800728:	89 df                	mov    %ebx,%edi
  80072a:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800730:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800734:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800738:	0f b6 00             	movzbl (%rax),%eax
  80073b:	0f b6 d8             	movzbl %al,%ebx
  80073e:	83 fb 25             	cmp    $0x25,%ebx
  800741:	75 d2                	jne    800715 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800743:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800747:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80074e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800755:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80075c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800763:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800767:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80076b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80076f:	0f b6 00             	movzbl (%rax),%eax
  800772:	0f b6 d8             	movzbl %al,%ebx
  800775:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800778:	83 f8 55             	cmp    $0x55,%eax
  80077b:	0f 87 34 04 00 00    	ja     800bb5 <vprintfmt+0x4db>
  800781:	89 c0                	mov    %eax,%eax
  800783:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80078a:	00 
  80078b:	48 b8 d8 25 80 00 00 	movabs $0x8025d8,%rax
  800792:	00 00 00 
  800795:	48 01 d0             	add    %rdx,%rax
  800798:	48 8b 00             	mov    (%rax),%rax
  80079b:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  80079d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007a1:	eb c0                	jmp    800763 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007a3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007a7:	eb ba                	jmp    800763 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007b0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007b3:	89 d0                	mov    %edx,%eax
  8007b5:	c1 e0 02             	shl    $0x2,%eax
  8007b8:	01 d0                	add    %edx,%eax
  8007ba:	01 c0                	add    %eax,%eax
  8007bc:	01 d8                	add    %ebx,%eax
  8007be:	83 e8 30             	sub    $0x30,%eax
  8007c1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007c4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007c8:	0f b6 00             	movzbl (%rax),%eax
  8007cb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ce:	83 fb 2f             	cmp    $0x2f,%ebx
  8007d1:	7e 0c                	jle    8007df <vprintfmt+0x105>
  8007d3:	83 fb 39             	cmp    $0x39,%ebx
  8007d6:	7f 07                	jg     8007df <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007dd:	eb d1                	jmp    8007b0 <vprintfmt+0xd6>
			goto process_precision;
  8007df:	eb 58                	jmp    800839 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007e1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e4:	83 f8 30             	cmp    $0x30,%eax
  8007e7:	73 17                	jae    800800 <vprintfmt+0x126>
  8007e9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007ed:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007f0:	89 c0                	mov    %eax,%eax
  8007f2:	48 01 d0             	add    %rdx,%rax
  8007f5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007f8:	83 c2 08             	add    $0x8,%edx
  8007fb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007fe:	eb 0f                	jmp    80080f <vprintfmt+0x135>
  800800:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800804:	48 89 d0             	mov    %rdx,%rax
  800807:	48 83 c2 08          	add    $0x8,%rdx
  80080b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80080f:	8b 00                	mov    (%rax),%eax
  800811:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800814:	eb 23                	jmp    800839 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800816:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80081a:	79 0c                	jns    800828 <vprintfmt+0x14e>
				width = 0;
  80081c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800823:	e9 3b ff ff ff       	jmpq   800763 <vprintfmt+0x89>
  800828:	e9 36 ff ff ff       	jmpq   800763 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80082d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800834:	e9 2a ff ff ff       	jmpq   800763 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800839:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80083d:	79 12                	jns    800851 <vprintfmt+0x177>
				width = precision, precision = -1;
  80083f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800842:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800845:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80084c:	e9 12 ff ff ff       	jmpq   800763 <vprintfmt+0x89>
  800851:	e9 0d ff ff ff       	jmpq   800763 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800856:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80085a:	e9 04 ff ff ff       	jmpq   800763 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  80085f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800862:	83 f8 30             	cmp    $0x30,%eax
  800865:	73 17                	jae    80087e <vprintfmt+0x1a4>
  800867:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80086b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80086e:	89 c0                	mov    %eax,%eax
  800870:	48 01 d0             	add    %rdx,%rax
  800873:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800876:	83 c2 08             	add    $0x8,%edx
  800879:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80087c:	eb 0f                	jmp    80088d <vprintfmt+0x1b3>
  80087e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800882:	48 89 d0             	mov    %rdx,%rax
  800885:	48 83 c2 08          	add    $0x8,%rdx
  800889:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80088d:	8b 10                	mov    (%rax),%edx
  80088f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800893:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800897:	48 89 ce             	mov    %rcx,%rsi
  80089a:	89 d7                	mov    %edx,%edi
  80089c:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  80089e:	e9 40 03 00 00       	jmpq   800be3 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8008a3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008a6:	83 f8 30             	cmp    $0x30,%eax
  8008a9:	73 17                	jae    8008c2 <vprintfmt+0x1e8>
  8008ab:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008af:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b2:	89 c0                	mov    %eax,%eax
  8008b4:	48 01 d0             	add    %rdx,%rax
  8008b7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008ba:	83 c2 08             	add    $0x8,%edx
  8008bd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008c0:	eb 0f                	jmp    8008d1 <vprintfmt+0x1f7>
  8008c2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008c6:	48 89 d0             	mov    %rdx,%rax
  8008c9:	48 83 c2 08          	add    $0x8,%rdx
  8008cd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008d1:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008d3:	85 db                	test   %ebx,%ebx
  8008d5:	79 02                	jns    8008d9 <vprintfmt+0x1ff>
				err = -err;
  8008d7:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008d9:	83 fb 09             	cmp    $0x9,%ebx
  8008dc:	7f 16                	jg     8008f4 <vprintfmt+0x21a>
  8008de:	48 b8 60 25 80 00 00 	movabs $0x802560,%rax
  8008e5:	00 00 00 
  8008e8:	48 63 d3             	movslq %ebx,%rdx
  8008eb:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008ef:	4d 85 e4             	test   %r12,%r12
  8008f2:	75 2e                	jne    800922 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008f4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008fc:	89 d9                	mov    %ebx,%ecx
  8008fe:	48 ba c1 25 80 00 00 	movabs $0x8025c1,%rdx
  800905:	00 00 00 
  800908:	48 89 c7             	mov    %rax,%rdi
  80090b:	b8 00 00 00 00       	mov    $0x0,%eax
  800910:	49 b8 f2 0b 80 00 00 	movabs $0x800bf2,%r8
  800917:	00 00 00 
  80091a:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80091d:	e9 c1 02 00 00       	jmpq   800be3 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800922:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800926:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80092a:	4c 89 e1             	mov    %r12,%rcx
  80092d:	48 ba ca 25 80 00 00 	movabs $0x8025ca,%rdx
  800934:	00 00 00 
  800937:	48 89 c7             	mov    %rax,%rdi
  80093a:	b8 00 00 00 00       	mov    $0x0,%eax
  80093f:	49 b8 f2 0b 80 00 00 	movabs $0x800bf2,%r8
  800946:	00 00 00 
  800949:	41 ff d0             	callq  *%r8
			break;
  80094c:	e9 92 02 00 00       	jmpq   800be3 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800951:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800954:	83 f8 30             	cmp    $0x30,%eax
  800957:	73 17                	jae    800970 <vprintfmt+0x296>
  800959:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80095d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800960:	89 c0                	mov    %eax,%eax
  800962:	48 01 d0             	add    %rdx,%rax
  800965:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800968:	83 c2 08             	add    $0x8,%edx
  80096b:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80096e:	eb 0f                	jmp    80097f <vprintfmt+0x2a5>
  800970:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800974:	48 89 d0             	mov    %rdx,%rax
  800977:	48 83 c2 08          	add    $0x8,%rdx
  80097b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80097f:	4c 8b 20             	mov    (%rax),%r12
  800982:	4d 85 e4             	test   %r12,%r12
  800985:	75 0a                	jne    800991 <vprintfmt+0x2b7>
				p = "(null)";
  800987:	49 bc cd 25 80 00 00 	movabs $0x8025cd,%r12
  80098e:	00 00 00 
			if (width > 0 && padc != '-')
  800991:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800995:	7e 3f                	jle    8009d6 <vprintfmt+0x2fc>
  800997:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80099b:	74 39                	je     8009d6 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  80099d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009a0:	48 98                	cltq   
  8009a2:	48 89 c6             	mov    %rax,%rsi
  8009a5:	4c 89 e7             	mov    %r12,%rdi
  8009a8:	48 b8 9e 0e 80 00 00 	movabs $0x800e9e,%rax
  8009af:	00 00 00 
  8009b2:	ff d0                	callq  *%rax
  8009b4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009b7:	eb 17                	jmp    8009d0 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009b9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009bd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009c1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009c5:	48 89 ce             	mov    %rcx,%rsi
  8009c8:	89 d7                	mov    %edx,%edi
  8009ca:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009d4:	7f e3                	jg     8009b9 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d6:	eb 37                	jmp    800a0f <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009dc:	74 1e                	je     8009fc <vprintfmt+0x322>
  8009de:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e1:	7e 05                	jle    8009e8 <vprintfmt+0x30e>
  8009e3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e6:	7e 14                	jle    8009fc <vprintfmt+0x322>
					putch('?', putdat);
  8009e8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009ec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f0:	48 89 d6             	mov    %rdx,%rsi
  8009f3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009f8:	ff d0                	callq  *%rax
  8009fa:	eb 0f                	jmp    800a0b <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009fc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a04:	48 89 d6             	mov    %rdx,%rsi
  800a07:	89 df                	mov    %ebx,%edi
  800a09:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a0f:	4c 89 e0             	mov    %r12,%rax
  800a12:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a16:	0f b6 00             	movzbl (%rax),%eax
  800a19:	0f be d8             	movsbl %al,%ebx
  800a1c:	85 db                	test   %ebx,%ebx
  800a1e:	74 10                	je     800a30 <vprintfmt+0x356>
  800a20:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a24:	78 b2                	js     8009d8 <vprintfmt+0x2fe>
  800a26:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a2a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a2e:	79 a8                	jns    8009d8 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a30:	eb 16                	jmp    800a48 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a3a:	48 89 d6             	mov    %rdx,%rsi
  800a3d:	bf 20 00 00 00       	mov    $0x20,%edi
  800a42:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a44:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a48:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a4c:	7f e4                	jg     800a32 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800a4e:	e9 90 01 00 00       	jmpq   800be3 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800a53:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a57:	be 03 00 00 00       	mov    $0x3,%esi
  800a5c:	48 89 c7             	mov    %rax,%rdi
  800a5f:	48 b8 ca 05 80 00 00 	movabs $0x8005ca,%rax
  800a66:	00 00 00 
  800a69:	ff d0                	callq  *%rax
  800a6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a73:	48 85 c0             	test   %rax,%rax
  800a76:	79 1d                	jns    800a95 <vprintfmt+0x3bb>
				putch('-', putdat);
  800a78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a80:	48 89 d6             	mov    %rdx,%rsi
  800a83:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a88:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8e:	48 f7 d8             	neg    %rax
  800a91:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a95:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a9c:	e9 d5 00 00 00       	jmpq   800b76 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800aa1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aa5:	be 03 00 00 00       	mov    $0x3,%esi
  800aaa:	48 89 c7             	mov    %rax,%rdi
  800aad:	48 b8 ba 04 80 00 00 	movabs $0x8004ba,%rax
  800ab4:	00 00 00 
  800ab7:	ff d0                	callq  *%rax
  800ab9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800abd:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ac4:	e9 ad 00 00 00       	jmpq   800b76 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800ac9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800acd:	be 03 00 00 00       	mov    $0x3,%esi
  800ad2:	48 89 c7             	mov    %rax,%rdi
  800ad5:	48 b8 ba 04 80 00 00 	movabs $0x8004ba,%rax
  800adc:	00 00 00 
  800adf:	ff d0                	callq  *%rax
  800ae1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800ae5:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800aec:	e9 85 00 00 00       	jmpq   800b76 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800af1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800af5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af9:	48 89 d6             	mov    %rdx,%rsi
  800afc:	bf 30 00 00 00       	mov    $0x30,%edi
  800b01:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0b:	48 89 d6             	mov    %rdx,%rsi
  800b0e:	bf 78 00 00 00       	mov    $0x78,%edi
  800b13:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b18:	83 f8 30             	cmp    $0x30,%eax
  800b1b:	73 17                	jae    800b34 <vprintfmt+0x45a>
  800b1d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b24:	89 c0                	mov    %eax,%eax
  800b26:	48 01 d0             	add    %rdx,%rax
  800b29:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b2c:	83 c2 08             	add    $0x8,%edx
  800b2f:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b32:	eb 0f                	jmp    800b43 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b34:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b38:	48 89 d0             	mov    %rdx,%rax
  800b3b:	48 83 c2 08          	add    $0x8,%rdx
  800b3f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b43:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b46:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b4a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b51:	eb 23                	jmp    800b76 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800b53:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b57:	be 03 00 00 00       	mov    $0x3,%esi
  800b5c:	48 89 c7             	mov    %rax,%rdi
  800b5f:	48 b8 ba 04 80 00 00 	movabs $0x8004ba,%rax
  800b66:	00 00 00 
  800b69:	ff d0                	callq  *%rax
  800b6b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b6f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800b76:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b7b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b7e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b85:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b89:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b8d:	45 89 c1             	mov    %r8d,%r9d
  800b90:	41 89 f8             	mov    %edi,%r8d
  800b93:	48 89 c7             	mov    %rax,%rdi
  800b96:	48 b8 ff 03 80 00 00 	movabs $0x8003ff,%rax
  800b9d:	00 00 00 
  800ba0:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800ba2:	eb 3f                	jmp    800be3 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bac:	48 89 d6             	mov    %rdx,%rsi
  800baf:	89 df                	mov    %ebx,%edi
  800bb1:	ff d0                	callq  *%rax
			break;
  800bb3:	eb 2e                	jmp    800be3 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bbd:	48 89 d6             	mov    %rdx,%rsi
  800bc0:	bf 25 00 00 00       	mov    $0x25,%edi
  800bc5:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc7:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bcc:	eb 05                	jmp    800bd3 <vprintfmt+0x4f9>
  800bce:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bd3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bd7:	48 83 e8 01          	sub    $0x1,%rax
  800bdb:	0f b6 00             	movzbl (%rax),%eax
  800bde:	3c 25                	cmp    $0x25,%al
  800be0:	75 ec                	jne    800bce <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800be2:	90                   	nop
		}
	}
  800be3:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be4:	e9 43 fb ff ff       	jmpq   80072c <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  800be9:	48 83 c4 60          	add    $0x60,%rsp
  800bed:	5b                   	pop    %rbx
  800bee:	41 5c                	pop    %r12
  800bf0:	5d                   	pop    %rbp
  800bf1:	c3                   	retq   

0000000000800bf2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf2:	55                   	push   %rbp
  800bf3:	48 89 e5             	mov    %rsp,%rbp
  800bf6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bfd:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c04:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c0b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c12:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c19:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c20:	84 c0                	test   %al,%al
  800c22:	74 20                	je     800c44 <printfmt+0x52>
  800c24:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c28:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c2c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c30:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c34:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c38:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c3c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c40:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c44:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c4b:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c52:	00 00 00 
  800c55:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c5c:	00 00 00 
  800c5f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c63:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c6a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c71:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c78:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c7f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c86:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c8d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c94:	48 89 c7             	mov    %rax,%rdi
  800c97:	48 b8 da 06 80 00 00 	movabs $0x8006da,%rax
  800c9e:	00 00 00 
  800ca1:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ca3:	c9                   	leaveq 
  800ca4:	c3                   	retq   

0000000000800ca5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ca5:	55                   	push   %rbp
  800ca6:	48 89 e5             	mov    %rsp,%rbp
  800ca9:	48 83 ec 10          	sub    $0x10,%rsp
  800cad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb8:	8b 40 10             	mov    0x10(%rax),%eax
  800cbb:	8d 50 01             	lea    0x1(%rax),%edx
  800cbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc9:	48 8b 10             	mov    (%rax),%rdx
  800ccc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd0:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cd4:	48 39 c2             	cmp    %rax,%rdx
  800cd7:	73 17                	jae    800cf0 <sprintputch+0x4b>
		*b->buf++ = ch;
  800cd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cdd:	48 8b 00             	mov    (%rax),%rax
  800ce0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ce4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ce8:	48 89 0a             	mov    %rcx,(%rdx)
  800ceb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800cee:	88 10                	mov    %dl,(%rax)
}
  800cf0:	c9                   	leaveq 
  800cf1:	c3                   	retq   

0000000000800cf2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cf2:	55                   	push   %rbp
  800cf3:	48 89 e5             	mov    %rsp,%rbp
  800cf6:	48 83 ec 50          	sub    $0x50,%rsp
  800cfa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cfe:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d01:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d05:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d09:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d0d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d11:	48 8b 0a             	mov    (%rdx),%rcx
  800d14:	48 89 08             	mov    %rcx,(%rax)
  800d17:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d1b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d1f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d23:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d27:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d2b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d2f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d32:	48 98                	cltq   
  800d34:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d38:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d3c:	48 01 d0             	add    %rdx,%rax
  800d3f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d43:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d4a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d4f:	74 06                	je     800d57 <vsnprintf+0x65>
  800d51:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d55:	7f 07                	jg     800d5e <vsnprintf+0x6c>
		return -E_INVAL;
  800d57:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d5c:	eb 2f                	jmp    800d8d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d5e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d62:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d66:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d6a:	48 89 c6             	mov    %rax,%rsi
  800d6d:	48 bf a5 0c 80 00 00 	movabs $0x800ca5,%rdi
  800d74:	00 00 00 
  800d77:	48 b8 da 06 80 00 00 	movabs $0x8006da,%rax
  800d7e:	00 00 00 
  800d81:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d83:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d87:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d8a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d8d:	c9                   	leaveq 
  800d8e:	c3                   	retq   

0000000000800d8f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d8f:	55                   	push   %rbp
  800d90:	48 89 e5             	mov    %rsp,%rbp
  800d93:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d9a:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800da1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800da7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dae:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800db5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dbc:	84 c0                	test   %al,%al
  800dbe:	74 20                	je     800de0 <snprintf+0x51>
  800dc0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dc4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dc8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dcc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dd0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dd4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dd8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ddc:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800de0:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800de7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800dee:	00 00 00 
  800df1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800df8:	00 00 00 
  800dfb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dff:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e06:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e0d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e14:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e1b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e22:	48 8b 0a             	mov    (%rdx),%rcx
  800e25:	48 89 08             	mov    %rcx,(%rax)
  800e28:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e2c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e30:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e34:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e38:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e3f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e46:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e4c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e53:	48 89 c7             	mov    %rax,%rdi
  800e56:	48 b8 f2 0c 80 00 00 	movabs $0x800cf2,%rax
  800e5d:	00 00 00 
  800e60:	ff d0                	callq  *%rax
  800e62:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e68:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e6e:	c9                   	leaveq 
  800e6f:	c3                   	retq   

0000000000800e70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e70:	55                   	push   %rbp
  800e71:	48 89 e5             	mov    %rsp,%rbp
  800e74:	48 83 ec 18          	sub    $0x18,%rsp
  800e78:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e83:	eb 09                	jmp    800e8e <strlen+0x1e>
		n++;
  800e85:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e89:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e92:	0f b6 00             	movzbl (%rax),%eax
  800e95:	84 c0                	test   %al,%al
  800e97:	75 ec                	jne    800e85 <strlen+0x15>
		n++;
	return n;
  800e99:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e9c:	c9                   	leaveq 
  800e9d:	c3                   	retq   

0000000000800e9e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e9e:	55                   	push   %rbp
  800e9f:	48 89 e5             	mov    %rsp,%rbp
  800ea2:	48 83 ec 20          	sub    $0x20,%rsp
  800ea6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800eaa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800eb5:	eb 0e                	jmp    800ec5 <strnlen+0x27>
		n++;
  800eb7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ebb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ec0:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ec5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800eca:	74 0b                	je     800ed7 <strnlen+0x39>
  800ecc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed0:	0f b6 00             	movzbl (%rax),%eax
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 e0                	jne    800eb7 <strnlen+0x19>
		n++;
	return n;
  800ed7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800eda:	c9                   	leaveq 
  800edb:	c3                   	retq   

0000000000800edc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800edc:	55                   	push   %rbp
  800edd:	48 89 e5             	mov    %rsp,%rbp
  800ee0:	48 83 ec 20          	sub    $0x20,%rsp
  800ee4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ee8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800eec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800ef4:	90                   	nop
  800ef5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800efd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f01:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f05:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f09:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f0d:	0f b6 12             	movzbl (%rdx),%edx
  800f10:	88 10                	mov    %dl,(%rax)
  800f12:	0f b6 00             	movzbl (%rax),%eax
  800f15:	84 c0                	test   %al,%al
  800f17:	75 dc                	jne    800ef5 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f1d:	c9                   	leaveq 
  800f1e:	c3                   	retq   

0000000000800f1f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f1f:	55                   	push   %rbp
  800f20:	48 89 e5             	mov    %rsp,%rbp
  800f23:	48 83 ec 20          	sub    $0x20,%rsp
  800f27:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f2b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f33:	48 89 c7             	mov    %rax,%rdi
  800f36:	48 b8 70 0e 80 00 00 	movabs $0x800e70,%rax
  800f3d:	00 00 00 
  800f40:	ff d0                	callq  *%rax
  800f42:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f48:	48 63 d0             	movslq %eax,%rdx
  800f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4f:	48 01 c2             	add    %rax,%rdx
  800f52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f56:	48 89 c6             	mov    %rax,%rsi
  800f59:	48 89 d7             	mov    %rdx,%rdi
  800f5c:	48 b8 dc 0e 80 00 00 	movabs $0x800edc,%rax
  800f63:	00 00 00 
  800f66:	ff d0                	callq  *%rax
	return dst;
  800f68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f6c:	c9                   	leaveq 
  800f6d:	c3                   	retq   

0000000000800f6e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f6e:	55                   	push   %rbp
  800f6f:	48 89 e5             	mov    %rsp,%rbp
  800f72:	48 83 ec 28          	sub    $0x28,%rsp
  800f76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f7a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f7e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f86:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f8a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f91:	00 
  800f92:	eb 2a                	jmp    800fbe <strncpy+0x50>
		*dst++ = *src;
  800f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f98:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f9c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fa0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fa4:	0f b6 12             	movzbl (%rdx),%edx
  800fa7:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fa9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fad:	0f b6 00             	movzbl (%rax),%eax
  800fb0:	84 c0                	test   %al,%al
  800fb2:	74 05                	je     800fb9 <strncpy+0x4b>
			src++;
  800fb4:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fb9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fc2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fc6:	72 cc                	jb     800f94 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fcc:	c9                   	leaveq 
  800fcd:	c3                   	retq   

0000000000800fce <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fce:	55                   	push   %rbp
  800fcf:	48 89 e5             	mov    %rsp,%rbp
  800fd2:	48 83 ec 28          	sub    $0x28,%rsp
  800fd6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fda:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fde:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fe2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fea:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fef:	74 3d                	je     80102e <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800ff1:	eb 1d                	jmp    801010 <strlcpy+0x42>
			*dst++ = *src++;
  800ff3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ffb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fff:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801003:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801007:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80100b:	0f b6 12             	movzbl (%rdx),%edx
  80100e:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801010:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801015:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80101a:	74 0b                	je     801027 <strlcpy+0x59>
  80101c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801020:	0f b6 00             	movzbl (%rax),%eax
  801023:	84 c0                	test   %al,%al
  801025:	75 cc                	jne    800ff3 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801027:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102b:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80102e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801032:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801036:	48 29 c2             	sub    %rax,%rdx
  801039:	48 89 d0             	mov    %rdx,%rax
}
  80103c:	c9                   	leaveq 
  80103d:	c3                   	retq   

000000000080103e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80103e:	55                   	push   %rbp
  80103f:	48 89 e5             	mov    %rsp,%rbp
  801042:	48 83 ec 10          	sub    $0x10,%rsp
  801046:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80104a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80104e:	eb 0a                	jmp    80105a <strcmp+0x1c>
		p++, q++;
  801050:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801055:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80105a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80105e:	0f b6 00             	movzbl (%rax),%eax
  801061:	84 c0                	test   %al,%al
  801063:	74 12                	je     801077 <strcmp+0x39>
  801065:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801069:	0f b6 10             	movzbl (%rax),%edx
  80106c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801070:	0f b6 00             	movzbl (%rax),%eax
  801073:	38 c2                	cmp    %al,%dl
  801075:	74 d9                	je     801050 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801077:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107b:	0f b6 00             	movzbl (%rax),%eax
  80107e:	0f b6 d0             	movzbl %al,%edx
  801081:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801085:	0f b6 00             	movzbl (%rax),%eax
  801088:	0f b6 c0             	movzbl %al,%eax
  80108b:	29 c2                	sub    %eax,%edx
  80108d:	89 d0                	mov    %edx,%eax
}
  80108f:	c9                   	leaveq 
  801090:	c3                   	retq   

0000000000801091 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801091:	55                   	push   %rbp
  801092:	48 89 e5             	mov    %rsp,%rbp
  801095:	48 83 ec 18          	sub    $0x18,%rsp
  801099:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80109d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010a1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010a5:	eb 0f                	jmp    8010b6 <strncmp+0x25>
		n--, p++, q++;
  8010a7:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010ac:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010b1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010b6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010bb:	74 1d                	je     8010da <strncmp+0x49>
  8010bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c1:	0f b6 00             	movzbl (%rax),%eax
  8010c4:	84 c0                	test   %al,%al
  8010c6:	74 12                	je     8010da <strncmp+0x49>
  8010c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010cc:	0f b6 10             	movzbl (%rax),%edx
  8010cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010d3:	0f b6 00             	movzbl (%rax),%eax
  8010d6:	38 c2                	cmp    %al,%dl
  8010d8:	74 cd                	je     8010a7 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010da:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010df:	75 07                	jne    8010e8 <strncmp+0x57>
		return 0;
  8010e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e6:	eb 18                	jmp    801100 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010ec:	0f b6 00             	movzbl (%rax),%eax
  8010ef:	0f b6 d0             	movzbl %al,%edx
  8010f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f6:	0f b6 00             	movzbl (%rax),%eax
  8010f9:	0f b6 c0             	movzbl %al,%eax
  8010fc:	29 c2                	sub    %eax,%edx
  8010fe:	89 d0                	mov    %edx,%eax
}
  801100:	c9                   	leaveq 
  801101:	c3                   	retq   

0000000000801102 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801102:	55                   	push   %rbp
  801103:	48 89 e5             	mov    %rsp,%rbp
  801106:	48 83 ec 0c          	sub    $0xc,%rsp
  80110a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80110e:	89 f0                	mov    %esi,%eax
  801110:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801113:	eb 17                	jmp    80112c <strchr+0x2a>
		if (*s == c)
  801115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801119:	0f b6 00             	movzbl (%rax),%eax
  80111c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80111f:	75 06                	jne    801127 <strchr+0x25>
			return (char *) s;
  801121:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801125:	eb 15                	jmp    80113c <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801127:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80112c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801130:	0f b6 00             	movzbl (%rax),%eax
  801133:	84 c0                	test   %al,%al
  801135:	75 de                	jne    801115 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801137:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80113c:	c9                   	leaveq 
  80113d:	c3                   	retq   

000000000080113e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80113e:	55                   	push   %rbp
  80113f:	48 89 e5             	mov    %rsp,%rbp
  801142:	48 83 ec 0c          	sub    $0xc,%rsp
  801146:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80114a:	89 f0                	mov    %esi,%eax
  80114c:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80114f:	eb 13                	jmp    801164 <strfind+0x26>
		if (*s == c)
  801151:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801155:	0f b6 00             	movzbl (%rax),%eax
  801158:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80115b:	75 02                	jne    80115f <strfind+0x21>
			break;
  80115d:	eb 10                	jmp    80116f <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80115f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801164:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801168:	0f b6 00             	movzbl (%rax),%eax
  80116b:	84 c0                	test   %al,%al
  80116d:	75 e2                	jne    801151 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80116f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801173:	c9                   	leaveq 
  801174:	c3                   	retq   

0000000000801175 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801175:	55                   	push   %rbp
  801176:	48 89 e5             	mov    %rsp,%rbp
  801179:	48 83 ec 18          	sub    $0x18,%rsp
  80117d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801181:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801184:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801188:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80118d:	75 06                	jne    801195 <memset+0x20>
		return v;
  80118f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801193:	eb 69                	jmp    8011fe <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801195:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801199:	83 e0 03             	and    $0x3,%eax
  80119c:	48 85 c0             	test   %rax,%rax
  80119f:	75 48                	jne    8011e9 <memset+0x74>
  8011a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a5:	83 e0 03             	and    $0x3,%eax
  8011a8:	48 85 c0             	test   %rax,%rax
  8011ab:	75 3c                	jne    8011e9 <memset+0x74>
		c &= 0xFF;
  8011ad:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b7:	c1 e0 18             	shl    $0x18,%eax
  8011ba:	89 c2                	mov    %eax,%edx
  8011bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011bf:	c1 e0 10             	shl    $0x10,%eax
  8011c2:	09 c2                	or     %eax,%edx
  8011c4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c7:	c1 e0 08             	shl    $0x8,%eax
  8011ca:	09 d0                	or     %edx,%eax
  8011cc:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d3:	48 c1 e8 02          	shr    $0x2,%rax
  8011d7:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e1:	48 89 d7             	mov    %rdx,%rdi
  8011e4:	fc                   	cld    
  8011e5:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011e7:	eb 11                	jmp    8011fa <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011e9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011ed:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011f0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011f4:	48 89 d7             	mov    %rdx,%rdi
  8011f7:	fc                   	cld    
  8011f8:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8011fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011fe:	c9                   	leaveq 
  8011ff:	c3                   	retq   

0000000000801200 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801200:	55                   	push   %rbp
  801201:	48 89 e5             	mov    %rsp,%rbp
  801204:	48 83 ec 28          	sub    $0x28,%rsp
  801208:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80120c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801210:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801214:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801218:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80121c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801220:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801224:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801228:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80122c:	0f 83 88 00 00 00    	jae    8012ba <memmove+0xba>
  801232:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801236:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80123a:	48 01 d0             	add    %rdx,%rax
  80123d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801241:	76 77                	jbe    8012ba <memmove+0xba>
		s += n;
  801243:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801247:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80124b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80124f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801253:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801257:	83 e0 03             	and    $0x3,%eax
  80125a:	48 85 c0             	test   %rax,%rax
  80125d:	75 3b                	jne    80129a <memmove+0x9a>
  80125f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801263:	83 e0 03             	and    $0x3,%eax
  801266:	48 85 c0             	test   %rax,%rax
  801269:	75 2f                	jne    80129a <memmove+0x9a>
  80126b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80126f:	83 e0 03             	and    $0x3,%eax
  801272:	48 85 c0             	test   %rax,%rax
  801275:	75 23                	jne    80129a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801277:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127b:	48 83 e8 04          	sub    $0x4,%rax
  80127f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801283:	48 83 ea 04          	sub    $0x4,%rdx
  801287:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80128b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80128f:	48 89 c7             	mov    %rax,%rdi
  801292:	48 89 d6             	mov    %rdx,%rsi
  801295:	fd                   	std    
  801296:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801298:	eb 1d                	jmp    8012b7 <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80129a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80129e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ae:	48 89 d7             	mov    %rdx,%rdi
  8012b1:	48 89 c1             	mov    %rax,%rcx
  8012b4:	fd                   	std    
  8012b5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012b7:	fc                   	cld    
  8012b8:	eb 57                	jmp    801311 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012be:	83 e0 03             	and    $0x3,%eax
  8012c1:	48 85 c0             	test   %rax,%rax
  8012c4:	75 36                	jne    8012fc <memmove+0xfc>
  8012c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ca:	83 e0 03             	and    $0x3,%eax
  8012cd:	48 85 c0             	test   %rax,%rax
  8012d0:	75 2a                	jne    8012fc <memmove+0xfc>
  8012d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012d6:	83 e0 03             	and    $0x3,%eax
  8012d9:	48 85 c0             	test   %rax,%rax
  8012dc:	75 1e                	jne    8012fc <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e2:	48 c1 e8 02          	shr    $0x2,%rax
  8012e6:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f1:	48 89 c7             	mov    %rax,%rdi
  8012f4:	48 89 d6             	mov    %rdx,%rsi
  8012f7:	fc                   	cld    
  8012f8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012fa:	eb 15                	jmp    801311 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801300:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801304:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801308:	48 89 c7             	mov    %rax,%rdi
  80130b:	48 89 d6             	mov    %rdx,%rsi
  80130e:	fc                   	cld    
  80130f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801315:	c9                   	leaveq 
  801316:	c3                   	retq   

0000000000801317 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801317:	55                   	push   %rbp
  801318:	48 89 e5             	mov    %rsp,%rbp
  80131b:	48 83 ec 18          	sub    $0x18,%rsp
  80131f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801323:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801327:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80132b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80132f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801333:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801337:	48 89 ce             	mov    %rcx,%rsi
  80133a:	48 89 c7             	mov    %rax,%rdi
  80133d:	48 b8 00 12 80 00 00 	movabs $0x801200,%rax
  801344:	00 00 00 
  801347:	ff d0                	callq  *%rax
}
  801349:	c9                   	leaveq 
  80134a:	c3                   	retq   

000000000080134b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80134b:	55                   	push   %rbp
  80134c:	48 89 e5             	mov    %rsp,%rbp
  80134f:	48 83 ec 28          	sub    $0x28,%rsp
  801353:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801357:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80135b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80135f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801363:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801367:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80136b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80136f:	eb 36                	jmp    8013a7 <memcmp+0x5c>
		if (*s1 != *s2)
  801371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801375:	0f b6 10             	movzbl (%rax),%edx
  801378:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137c:	0f b6 00             	movzbl (%rax),%eax
  80137f:	38 c2                	cmp    %al,%dl
  801381:	74 1a                	je     80139d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801383:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801387:	0f b6 00             	movzbl (%rax),%eax
  80138a:	0f b6 d0             	movzbl %al,%edx
  80138d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801391:	0f b6 00             	movzbl (%rax),%eax
  801394:	0f b6 c0             	movzbl %al,%eax
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	eb 20                	jmp    8013bd <memcmp+0x72>
		s1++, s2++;
  80139d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013a2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ab:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013b3:	48 85 c0             	test   %rax,%rax
  8013b6:	75 b9                	jne    801371 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013bd:	c9                   	leaveq 
  8013be:	c3                   	retq   

00000000008013bf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013bf:	55                   	push   %rbp
  8013c0:	48 89 e5             	mov    %rsp,%rbp
  8013c3:	48 83 ec 28          	sub    $0x28,%rsp
  8013c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013cb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013da:	48 01 d0             	add    %rdx,%rax
  8013dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013e1:	eb 15                	jmp    8013f8 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e7:	0f b6 10             	movzbl (%rax),%edx
  8013ea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013ed:	38 c2                	cmp    %al,%dl
  8013ef:	75 02                	jne    8013f3 <memfind+0x34>
			break;
  8013f1:	eb 0f                	jmp    801402 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013f3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fc:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801400:	72 e1                	jb     8013e3 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801406:	c9                   	leaveq 
  801407:	c3                   	retq   

0000000000801408 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801408:	55                   	push   %rbp
  801409:	48 89 e5             	mov    %rsp,%rbp
  80140c:	48 83 ec 34          	sub    $0x34,%rsp
  801410:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801414:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801418:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80141b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801422:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801429:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80142a:	eb 05                	jmp    801431 <strtol+0x29>
		s++;
  80142c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801431:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801435:	0f b6 00             	movzbl (%rax),%eax
  801438:	3c 20                	cmp    $0x20,%al
  80143a:	74 f0                	je     80142c <strtol+0x24>
  80143c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801440:	0f b6 00             	movzbl (%rax),%eax
  801443:	3c 09                	cmp    $0x9,%al
  801445:	74 e5                	je     80142c <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144b:	0f b6 00             	movzbl (%rax),%eax
  80144e:	3c 2b                	cmp    $0x2b,%al
  801450:	75 07                	jne    801459 <strtol+0x51>
		s++;
  801452:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801457:	eb 17                	jmp    801470 <strtol+0x68>
	else if (*s == '-')
  801459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145d:	0f b6 00             	movzbl (%rax),%eax
  801460:	3c 2d                	cmp    $0x2d,%al
  801462:	75 0c                	jne    801470 <strtol+0x68>
		s++, neg = 1;
  801464:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801469:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801470:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801474:	74 06                	je     80147c <strtol+0x74>
  801476:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80147a:	75 28                	jne    8014a4 <strtol+0x9c>
  80147c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801480:	0f b6 00             	movzbl (%rax),%eax
  801483:	3c 30                	cmp    $0x30,%al
  801485:	75 1d                	jne    8014a4 <strtol+0x9c>
  801487:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148b:	48 83 c0 01          	add    $0x1,%rax
  80148f:	0f b6 00             	movzbl (%rax),%eax
  801492:	3c 78                	cmp    $0x78,%al
  801494:	75 0e                	jne    8014a4 <strtol+0x9c>
		s += 2, base = 16;
  801496:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80149b:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014a2:	eb 2c                	jmp    8014d0 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014a8:	75 19                	jne    8014c3 <strtol+0xbb>
  8014aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ae:	0f b6 00             	movzbl (%rax),%eax
  8014b1:	3c 30                	cmp    $0x30,%al
  8014b3:	75 0e                	jne    8014c3 <strtol+0xbb>
		s++, base = 8;
  8014b5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014ba:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014c1:	eb 0d                	jmp    8014d0 <strtol+0xc8>
	else if (base == 0)
  8014c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014c7:	75 07                	jne    8014d0 <strtol+0xc8>
		base = 10;
  8014c9:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d4:	0f b6 00             	movzbl (%rax),%eax
  8014d7:	3c 2f                	cmp    $0x2f,%al
  8014d9:	7e 1d                	jle    8014f8 <strtol+0xf0>
  8014db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014df:	0f b6 00             	movzbl (%rax),%eax
  8014e2:	3c 39                	cmp    $0x39,%al
  8014e4:	7f 12                	jg     8014f8 <strtol+0xf0>
			dig = *s - '0';
  8014e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ea:	0f b6 00             	movzbl (%rax),%eax
  8014ed:	0f be c0             	movsbl %al,%eax
  8014f0:	83 e8 30             	sub    $0x30,%eax
  8014f3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014f6:	eb 4e                	jmp    801546 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	3c 60                	cmp    $0x60,%al
  801501:	7e 1d                	jle    801520 <strtol+0x118>
  801503:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801507:	0f b6 00             	movzbl (%rax),%eax
  80150a:	3c 7a                	cmp    $0x7a,%al
  80150c:	7f 12                	jg     801520 <strtol+0x118>
			dig = *s - 'a' + 10;
  80150e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801512:	0f b6 00             	movzbl (%rax),%eax
  801515:	0f be c0             	movsbl %al,%eax
  801518:	83 e8 57             	sub    $0x57,%eax
  80151b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80151e:	eb 26                	jmp    801546 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801520:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801524:	0f b6 00             	movzbl (%rax),%eax
  801527:	3c 40                	cmp    $0x40,%al
  801529:	7e 48                	jle    801573 <strtol+0x16b>
  80152b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152f:	0f b6 00             	movzbl (%rax),%eax
  801532:	3c 5a                	cmp    $0x5a,%al
  801534:	7f 3d                	jg     801573 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801536:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153a:	0f b6 00             	movzbl (%rax),%eax
  80153d:	0f be c0             	movsbl %al,%eax
  801540:	83 e8 37             	sub    $0x37,%eax
  801543:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801546:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801549:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80154c:	7c 02                	jl     801550 <strtol+0x148>
			break;
  80154e:	eb 23                	jmp    801573 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801550:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801555:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801558:	48 98                	cltq   
  80155a:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80155f:	48 89 c2             	mov    %rax,%rdx
  801562:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801565:	48 98                	cltq   
  801567:	48 01 d0             	add    %rdx,%rax
  80156a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80156e:	e9 5d ff ff ff       	jmpq   8014d0 <strtol+0xc8>

	if (endptr)
  801573:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801578:	74 0b                	je     801585 <strtol+0x17d>
		*endptr = (char *) s;
  80157a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80157e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801582:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801585:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801589:	74 09                	je     801594 <strtol+0x18c>
  80158b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158f:	48 f7 d8             	neg    %rax
  801592:	eb 04                	jmp    801598 <strtol+0x190>
  801594:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801598:	c9                   	leaveq 
  801599:	c3                   	retq   

000000000080159a <strstr>:

char * strstr(const char *in, const char *str)
{
  80159a:	55                   	push   %rbp
  80159b:	48 89 e5             	mov    %rsp,%rbp
  80159e:	48 83 ec 30          	sub    $0x30,%rsp
  8015a2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015a6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8015aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015ae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015b2:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015b6:	0f b6 00             	movzbl (%rax),%eax
  8015b9:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8015bc:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015c0:	75 06                	jne    8015c8 <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8015c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c6:	eb 6b                	jmp    801633 <strstr+0x99>

    len = strlen(str);
  8015c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015cc:	48 89 c7             	mov    %rax,%rdi
  8015cf:	48 b8 70 0e 80 00 00 	movabs $0x800e70,%rax
  8015d6:	00 00 00 
  8015d9:	ff d0                	callq  *%rax
  8015db:	48 98                	cltq   
  8015dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  8015e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015ed:	0f b6 00             	movzbl (%rax),%eax
  8015f0:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  8015f3:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015f7:	75 07                	jne    801600 <strstr+0x66>
                return (char *) 0;
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fe:	eb 33                	jmp    801633 <strstr+0x99>
        } while (sc != c);
  801600:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801604:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801607:	75 d8                	jne    8015e1 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  801609:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80160d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801611:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801615:	48 89 ce             	mov    %rcx,%rsi
  801618:	48 89 c7             	mov    %rax,%rdi
  80161b:	48 b8 91 10 80 00 00 	movabs $0x801091,%rax
  801622:	00 00 00 
  801625:	ff d0                	callq  *%rax
  801627:	85 c0                	test   %eax,%eax
  801629:	75 b6                	jne    8015e1 <strstr+0x47>

    return (char *) (in - 1);
  80162b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162f:	48 83 e8 01          	sub    $0x1,%rax
}
  801633:	c9                   	leaveq 
  801634:	c3                   	retq   

0000000000801635 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801635:	55                   	push   %rbp
  801636:	48 89 e5             	mov    %rsp,%rbp
  801639:	53                   	push   %rbx
  80163a:	48 83 ec 48          	sub    $0x48,%rsp
  80163e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801641:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801644:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801648:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80164c:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801650:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801654:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801657:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80165b:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80165f:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801663:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801667:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80166b:	4c 89 c3             	mov    %r8,%rbx
  80166e:	cd 30                	int    $0x30
  801670:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801674:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801678:	74 3e                	je     8016b8 <syscall+0x83>
  80167a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80167f:	7e 37                	jle    8016b8 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801681:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801685:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801688:	49 89 d0             	mov    %rdx,%r8
  80168b:	89 c1                	mov    %eax,%ecx
  80168d:	48 ba 88 28 80 00 00 	movabs $0x802888,%rdx
  801694:	00 00 00 
  801697:	be 23 00 00 00       	mov    $0x23,%esi
  80169c:	48 bf a5 28 80 00 00 	movabs $0x8028a5,%rdi
  8016a3:	00 00 00 
  8016a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ab:	49 b9 ef 21 80 00 00 	movabs $0x8021ef,%r9
  8016b2:	00 00 00 
  8016b5:	41 ff d1             	callq  *%r9

	return ret;
  8016b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016bc:	48 83 c4 48          	add    $0x48,%rsp
  8016c0:	5b                   	pop    %rbx
  8016c1:	5d                   	pop    %rbp
  8016c2:	c3                   	retq   

00000000008016c3 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016c3:	55                   	push   %rbp
  8016c4:	48 89 e5             	mov    %rsp,%rbp
  8016c7:	48 83 ec 20          	sub    $0x20,%rsp
  8016cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016db:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016e2:	00 
  8016e3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016e9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016ef:	48 89 d1             	mov    %rdx,%rcx
  8016f2:	48 89 c2             	mov    %rax,%rdx
  8016f5:	be 00 00 00 00       	mov    $0x0,%esi
  8016fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ff:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  801706:	00 00 00 
  801709:	ff d0                	callq  *%rax
}
  80170b:	c9                   	leaveq 
  80170c:	c3                   	retq   

000000000080170d <sys_cgetc>:

int
sys_cgetc(void)
{
  80170d:	55                   	push   %rbp
  80170e:	48 89 e5             	mov    %rsp,%rbp
  801711:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801715:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80171c:	00 
  80171d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801723:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801729:	b9 00 00 00 00       	mov    $0x0,%ecx
  80172e:	ba 00 00 00 00       	mov    $0x0,%edx
  801733:	be 00 00 00 00       	mov    $0x0,%esi
  801738:	bf 01 00 00 00       	mov    $0x1,%edi
  80173d:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  801744:	00 00 00 
  801747:	ff d0                	callq  *%rax
}
  801749:	c9                   	leaveq 
  80174a:	c3                   	retq   

000000000080174b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80174b:	55                   	push   %rbp
  80174c:	48 89 e5             	mov    %rsp,%rbp
  80174f:	48 83 ec 10          	sub    $0x10,%rsp
  801753:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801756:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801759:	48 98                	cltq   
  80175b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801762:	00 
  801763:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801769:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80176f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801774:	48 89 c2             	mov    %rax,%rdx
  801777:	be 01 00 00 00       	mov    $0x1,%esi
  80177c:	bf 03 00 00 00       	mov    $0x3,%edi
  801781:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  801788:	00 00 00 
  80178b:	ff d0                	callq  *%rax
}
  80178d:	c9                   	leaveq 
  80178e:	c3                   	retq   

000000000080178f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80178f:	55                   	push   %rbp
  801790:	48 89 e5             	mov    %rsp,%rbp
  801793:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801797:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80179e:	00 
  80179f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017a5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b5:	be 00 00 00 00       	mov    $0x0,%esi
  8017ba:	bf 02 00 00 00       	mov    $0x2,%edi
  8017bf:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  8017c6:	00 00 00 
  8017c9:	ff d0                	callq  *%rax
}
  8017cb:	c9                   	leaveq 
  8017cc:	c3                   	retq   

00000000008017cd <sys_yield>:

void
sys_yield(void)
{
  8017cd:	55                   	push   %rbp
  8017ce:	48 89 e5             	mov    %rsp,%rbp
  8017d1:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017d5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017dc:	00 
  8017dd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017e3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f3:	be 00 00 00 00       	mov    $0x0,%esi
  8017f8:	bf 0a 00 00 00       	mov    $0xa,%edi
  8017fd:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  801804:	00 00 00 
  801807:	ff d0                	callq  *%rax
}
  801809:	c9                   	leaveq 
  80180a:	c3                   	retq   

000000000080180b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80180b:	55                   	push   %rbp
  80180c:	48 89 e5             	mov    %rsp,%rbp
  80180f:	48 83 ec 20          	sub    $0x20,%rsp
  801813:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801816:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80181a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80181d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801820:	48 63 c8             	movslq %eax,%rcx
  801823:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801827:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80182a:	48 98                	cltq   
  80182c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801833:	00 
  801834:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80183a:	49 89 c8             	mov    %rcx,%r8
  80183d:	48 89 d1             	mov    %rdx,%rcx
  801840:	48 89 c2             	mov    %rax,%rdx
  801843:	be 01 00 00 00       	mov    $0x1,%esi
  801848:	bf 04 00 00 00       	mov    $0x4,%edi
  80184d:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  801854:	00 00 00 
  801857:	ff d0                	callq  *%rax
}
  801859:	c9                   	leaveq 
  80185a:	c3                   	retq   

000000000080185b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80185b:	55                   	push   %rbp
  80185c:	48 89 e5             	mov    %rsp,%rbp
  80185f:	48 83 ec 30          	sub    $0x30,%rsp
  801863:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801866:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80186a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80186d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801871:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801875:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801878:	48 63 c8             	movslq %eax,%rcx
  80187b:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80187f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801882:	48 63 f0             	movslq %eax,%rsi
  801885:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801889:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80188c:	48 98                	cltq   
  80188e:	48 89 0c 24          	mov    %rcx,(%rsp)
  801892:	49 89 f9             	mov    %rdi,%r9
  801895:	49 89 f0             	mov    %rsi,%r8
  801898:	48 89 d1             	mov    %rdx,%rcx
  80189b:	48 89 c2             	mov    %rax,%rdx
  80189e:	be 01 00 00 00       	mov    $0x1,%esi
  8018a3:	bf 05 00 00 00       	mov    $0x5,%edi
  8018a8:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  8018af:	00 00 00 
  8018b2:	ff d0                	callq  *%rax
}
  8018b4:	c9                   	leaveq 
  8018b5:	c3                   	retq   

00000000008018b6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018b6:	55                   	push   %rbp
  8018b7:	48 89 e5             	mov    %rsp,%rbp
  8018ba:	48 83 ec 20          	sub    $0x20,%rsp
  8018be:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018cc:	48 98                	cltq   
  8018ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d5:	00 
  8018d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e2:	48 89 d1             	mov    %rdx,%rcx
  8018e5:	48 89 c2             	mov    %rax,%rdx
  8018e8:	be 01 00 00 00       	mov    $0x1,%esi
  8018ed:	bf 06 00 00 00       	mov    $0x6,%edi
  8018f2:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  8018f9:	00 00 00 
  8018fc:	ff d0                	callq  *%rax
}
  8018fe:	c9                   	leaveq 
  8018ff:	c3                   	retq   

0000000000801900 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801900:	55                   	push   %rbp
  801901:	48 89 e5             	mov    %rsp,%rbp
  801904:	48 83 ec 10          	sub    $0x10,%rsp
  801908:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80190b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80190e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801911:	48 63 d0             	movslq %eax,%rdx
  801914:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801917:	48 98                	cltq   
  801919:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801920:	00 
  801921:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801927:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192d:	48 89 d1             	mov    %rdx,%rcx
  801930:	48 89 c2             	mov    %rax,%rdx
  801933:	be 01 00 00 00       	mov    $0x1,%esi
  801938:	bf 08 00 00 00       	mov    $0x8,%edi
  80193d:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  801944:	00 00 00 
  801947:	ff d0                	callq  *%rax
}
  801949:	c9                   	leaveq 
  80194a:	c3                   	retq   

000000000080194b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80194b:	55                   	push   %rbp
  80194c:	48 89 e5             	mov    %rsp,%rbp
  80194f:	48 83 ec 20          	sub    $0x20,%rsp
  801953:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801956:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80195a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801961:	48 98                	cltq   
  801963:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80196a:	00 
  80196b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801971:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801977:	48 89 d1             	mov    %rdx,%rcx
  80197a:	48 89 c2             	mov    %rax,%rdx
  80197d:	be 01 00 00 00       	mov    $0x1,%esi
  801982:	bf 09 00 00 00       	mov    $0x9,%edi
  801987:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  80198e:	00 00 00 
  801991:	ff d0                	callq  *%rax
}
  801993:	c9                   	leaveq 
  801994:	c3                   	retq   

0000000000801995 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801995:	55                   	push   %rbp
  801996:	48 89 e5             	mov    %rsp,%rbp
  801999:	48 83 ec 20          	sub    $0x20,%rsp
  80199d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019a8:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019ab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019ae:	48 63 f0             	movslq %eax,%rsi
  8019b1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b8:	48 98                	cltq   
  8019ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019be:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019c5:	00 
  8019c6:	49 89 f1             	mov    %rsi,%r9
  8019c9:	49 89 c8             	mov    %rcx,%r8
  8019cc:	48 89 d1             	mov    %rdx,%rcx
  8019cf:	48 89 c2             	mov    %rax,%rdx
  8019d2:	be 00 00 00 00       	mov    $0x0,%esi
  8019d7:	bf 0b 00 00 00       	mov    $0xb,%edi
  8019dc:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  8019e3:	00 00 00 
  8019e6:	ff d0                	callq  *%rax
}
  8019e8:	c9                   	leaveq 
  8019e9:	c3                   	retq   

00000000008019ea <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019ea:	55                   	push   %rbp
  8019eb:	48 89 e5             	mov    %rsp,%rbp
  8019ee:	48 83 ec 10          	sub    $0x10,%rsp
  8019f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8019f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019fa:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a01:	00 
  801a02:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a08:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a13:	48 89 c2             	mov    %rax,%rdx
  801a16:	be 01 00 00 00       	mov    $0x1,%esi
  801a1b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a20:	48 b8 35 16 80 00 00 	movabs $0x801635,%rax
  801a27:	00 00 00 
  801a2a:	ff d0                	callq  *%rax
}
  801a2c:	c9                   	leaveq 
  801a2d:	c3                   	retq   

0000000000801a2e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a2e:	55                   	push   %rbp
  801a2f:	48 89 e5             	mov    %rsp,%rbp
  801a32:	48 83 ec 30          	sub    $0x30,%rsp
  801a36:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3e:	48 8b 00             	mov    (%rax),%rax
  801a41:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801a45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a49:	48 8b 40 08          	mov    0x8(%rax),%rax
  801a4d:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a53:	83 e0 02             	and    $0x2,%eax
  801a56:	85 c0                	test   %eax,%eax
  801a58:	75 40                	jne    801a9a <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801a5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5e:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801a65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a69:	49 89 d0             	mov    %rdx,%r8
  801a6c:	48 89 c1             	mov    %rax,%rcx
  801a6f:	48 ba b8 28 80 00 00 	movabs $0x8028b8,%rdx
  801a76:	00 00 00 
  801a79:	be 1a 00 00 00       	mov    $0x1a,%esi
  801a7e:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  801a85:	00 00 00 
  801a88:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8d:	49 b9 ef 21 80 00 00 	movabs $0x8021ef,%r9
  801a94:	00 00 00 
  801a97:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  801a9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a9e:	48 c1 e8 0c          	shr    $0xc,%rax
  801aa2:	48 89 c2             	mov    %rax,%rdx
  801aa5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801aac:	01 00 00 
  801aaf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ab3:	25 07 08 00 00       	and    $0x807,%eax
  801ab8:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  801abe:	74 4e                	je     801b0e <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  801ac0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ac4:	48 c1 e8 0c          	shr    $0xc,%rax
  801ac8:	48 89 c2             	mov    %rax,%rdx
  801acb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ad2:	01 00 00 
  801ad5:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801ad9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801add:	49 89 d0             	mov    %rdx,%r8
  801ae0:	48 89 c1             	mov    %rax,%rcx
  801ae3:	48 ba e0 28 80 00 00 	movabs $0x8028e0,%rdx
  801aea:	00 00 00 
  801aed:	be 1d 00 00 00       	mov    $0x1d,%esi
  801af2:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  801af9:	00 00 00 
  801afc:	b8 00 00 00 00       	mov    $0x0,%eax
  801b01:	49 b9 ef 21 80 00 00 	movabs $0x8021ef,%r9
  801b08:	00 00 00 
  801b0b:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b0e:	ba 07 00 00 00       	mov    $0x7,%edx
  801b13:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b18:	bf 00 00 00 00       	mov    $0x0,%edi
  801b1d:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  801b24:	00 00 00 
  801b27:	ff d0                	callq  *%rax
  801b29:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801b2c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801b30:	79 30                	jns    801b62 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  801b32:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b35:	89 c1                	mov    %eax,%ecx
  801b37:	48 ba 0b 29 80 00 00 	movabs $0x80290b,%rdx
  801b3e:	00 00 00 
  801b41:	be 23 00 00 00       	mov    $0x23,%esi
  801b46:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  801b4d:	00 00 00 
  801b50:	b8 00 00 00 00       	mov    $0x0,%eax
  801b55:	49 b8 ef 21 80 00 00 	movabs $0x8021ef,%r8
  801b5c:	00 00 00 
  801b5f:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  801b62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b66:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801b6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b6e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b74:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b79:	48 89 c6             	mov    %rax,%rsi
  801b7c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b81:	48 b8 00 12 80 00 00 	movabs $0x801200,%rax
  801b88:	00 00 00 
  801b8b:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801b8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b91:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b99:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801b9f:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801ba5:	48 89 c1             	mov    %rax,%rcx
  801ba8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bad:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801bb2:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb7:	48 b8 5b 18 80 00 00 	movabs $0x80185b,%rax
  801bbe:	00 00 00 
  801bc1:	ff d0                	callq  *%rax
  801bc3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801bc6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801bca:	79 30                	jns    801bfc <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  801bcc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bcf:	89 c1                	mov    %eax,%ecx
  801bd1:	48 ba 1e 29 80 00 00 	movabs $0x80291e,%rdx
  801bd8:	00 00 00 
  801bdb:	be 28 00 00 00       	mov    $0x28,%esi
  801be0:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  801be7:	00 00 00 
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
  801bef:	49 b8 ef 21 80 00 00 	movabs $0x8021ef,%r8
  801bf6:	00 00 00 
  801bf9:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  801bfc:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801c01:	bf 00 00 00 00       	mov    $0x0,%edi
  801c06:	48 b8 b6 18 80 00 00 	movabs $0x8018b6,%rax
  801c0d:	00 00 00 
  801c10:	ff d0                	callq  *%rax
  801c12:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801c15:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801c19:	79 30                	jns    801c4b <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  801c1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c1e:	89 c1                	mov    %eax,%ecx
  801c20:	48 ba 2f 29 80 00 00 	movabs $0x80292f,%rdx
  801c27:	00 00 00 
  801c2a:	be 2c 00 00 00       	mov    $0x2c,%esi
  801c2f:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  801c36:	00 00 00 
  801c39:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3e:	49 b8 ef 21 80 00 00 	movabs $0x8021ef,%r8
  801c45:	00 00 00 
  801c48:	41 ff d0             	callq  *%r8

}
  801c4b:	c9                   	leaveq 
  801c4c:	c3                   	retq   

0000000000801c4d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801c4d:	55                   	push   %rbp
  801c4e:	48 89 e5             	mov    %rsp,%rbp
  801c51:	48 83 ec 30          	sub    $0x30,%rsp
  801c55:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801c58:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  801c5b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801c5e:	c1 e0 0c             	shl    $0xc,%eax
  801c61:	89 c0                	mov    %eax,%eax
  801c63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  801c67:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c6e:	01 00 00 
  801c71:	8b 55 d8             	mov    -0x28(%rbp),%edx
  801c74:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c78:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  801c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c80:	25 02 08 00 00       	and    $0x802,%eax
  801c85:	48 85 c0             	test   %rax,%rax
  801c88:	74 0e                	je     801c98 <duppage+0x4b>
  801c8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c8e:	25 00 04 00 00       	and    $0x400,%eax
  801c93:	48 85 c0             	test   %rax,%rax
  801c96:	74 70                	je     801d08 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  801c98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c9c:	25 07 0e 00 00       	and    $0xe07,%eax
  801ca1:	89 c6                	mov    %eax,%esi
  801ca3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801ca7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801caa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cae:	41 89 f0             	mov    %esi,%r8d
  801cb1:	48 89 c6             	mov    %rax,%rsi
  801cb4:	bf 00 00 00 00       	mov    $0x0,%edi
  801cb9:	48 b8 5b 18 80 00 00 	movabs $0x80185b,%rax
  801cc0:	00 00 00 
  801cc3:	ff d0                	callq  *%rax
  801cc5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cc8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ccc:	79 30                	jns    801cfe <duppage+0xb1>
			panic("sys_page_map: %e", r);
  801cce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801cd1:	89 c1                	mov    %eax,%ecx
  801cd3:	48 ba 1e 29 80 00 00 	movabs $0x80291e,%rdx
  801cda:	00 00 00 
  801cdd:	be 4b 00 00 00       	mov    $0x4b,%esi
  801ce2:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  801ce9:	00 00 00 
  801cec:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf1:	49 b8 ef 21 80 00 00 	movabs $0x8021ef,%r8
  801cf8:	00 00 00 
  801cfb:	41 ff d0             	callq  *%r8
		return 0;
  801cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801d03:	e9 c4 00 00 00       	jmpq   801dcc <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  801d08:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  801d0c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801d0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d13:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801d19:	48 89 c6             	mov    %rax,%rsi
  801d1c:	bf 00 00 00 00       	mov    $0x0,%edi
  801d21:	48 b8 5b 18 80 00 00 	movabs $0x80185b,%rax
  801d28:	00 00 00 
  801d2b:	ff d0                	callq  *%rax
  801d2d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d30:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d34:	79 30                	jns    801d66 <duppage+0x119>
		panic("sys_page_map: %e", r);
  801d36:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d39:	89 c1                	mov    %eax,%ecx
  801d3b:	48 ba 1e 29 80 00 00 	movabs $0x80291e,%rdx
  801d42:	00 00 00 
  801d45:	be 5f 00 00 00       	mov    $0x5f,%esi
  801d4a:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  801d51:	00 00 00 
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
  801d59:	49 b8 ef 21 80 00 00 	movabs $0x8021ef,%r8
  801d60:	00 00 00 
  801d63:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  801d66:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d6e:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  801d74:	48 89 d1             	mov    %rdx,%rcx
  801d77:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7c:	48 89 c6             	mov    %rax,%rsi
  801d7f:	bf 00 00 00 00       	mov    $0x0,%edi
  801d84:	48 b8 5b 18 80 00 00 	movabs $0x80185b,%rax
  801d8b:	00 00 00 
  801d8e:	ff d0                	callq  *%rax
  801d90:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d93:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d97:	79 30                	jns    801dc9 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  801d99:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d9c:	89 c1                	mov    %eax,%ecx
  801d9e:	48 ba 1e 29 80 00 00 	movabs $0x80291e,%rdx
  801da5:	00 00 00 
  801da8:	be 61 00 00 00       	mov    $0x61,%esi
  801dad:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  801db4:	00 00 00 
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	49 b8 ef 21 80 00 00 	movabs $0x8021ef,%r8
  801dc3:	00 00 00 
  801dc6:	41 ff d0             	callq  *%r8
	return r;
  801dc9:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  801dcc:	c9                   	leaveq 
  801dcd:	c3                   	retq   

0000000000801dce <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801dce:	55                   	push   %rbp
  801dcf:	48 89 e5             	mov    %rsp,%rbp
  801dd2:	48 83 ec 20          	sub    $0x20,%rsp
	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  801dd6:	48 bf 2e 1a 80 00 00 	movabs $0x801a2e,%rdi
  801ddd:	00 00 00 
  801de0:	48 b8 03 23 80 00 00 	movabs $0x802303,%rax
  801de7:	00 00 00 
  801dea:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801dec:	b8 07 00 00 00       	mov    $0x7,%eax
  801df1:	cd 30                	int    $0x30
  801df3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801df6:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  801df9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  801dfc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801e00:	79 08                	jns    801e0a <fork+0x3c>
		return envid;
  801e02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e05:	e9 11 02 00 00       	jmpq   80201b <fork+0x24d>
	if (envid == 0) {
  801e0a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801e0e:	75 46                	jne    801e56 <fork+0x88>
		thisenv = &envs[ENVX(sys_getenvid())];
  801e10:	48 b8 8f 17 80 00 00 	movabs $0x80178f,%rax
  801e17:	00 00 00 
  801e1a:	ff d0                	callq  *%rax
  801e1c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e21:	48 63 d0             	movslq %eax,%rdx
  801e24:	48 89 d0             	mov    %rdx,%rax
  801e27:	48 c1 e0 03          	shl    $0x3,%rax
  801e2b:	48 01 d0             	add    %rdx,%rax
  801e2e:	48 c1 e0 05          	shl    $0x5,%rax
  801e32:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801e39:	00 00 00 
  801e3c:	48 01 c2             	add    %rax,%rdx
  801e3f:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  801e46:	00 00 00 
  801e49:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e51:	e9 c5 01 00 00       	jmpq   80201b <fork+0x24d>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  801e56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e5d:	e9 a4 00 00 00       	jmpq   801f06 <fork+0x138>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  801e62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e65:	c1 f8 12             	sar    $0x12,%eax
  801e68:	89 c2                	mov    %eax,%edx
  801e6a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801e71:	01 00 00 
  801e74:	48 63 d2             	movslq %edx,%rdx
  801e77:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e7b:	83 e0 01             	and    $0x1,%eax
  801e7e:	48 85 c0             	test   %rax,%rax
  801e81:	74 21                	je     801ea4 <fork+0xd6>
  801e83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e86:	c1 f8 09             	sar    $0x9,%eax
  801e89:	89 c2                	mov    %eax,%edx
  801e8b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e92:	01 00 00 
  801e95:	48 63 d2             	movslq %edx,%rdx
  801e98:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e9c:	83 e0 01             	and    $0x1,%eax
  801e9f:	48 85 c0             	test   %rax,%rax
  801ea2:	75 09                	jne    801ead <fork+0xdf>
			pn += NPTENTRIES;
  801ea4:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  801eab:	eb 59                	jmp    801f06 <fork+0x138>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  801ead:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb0:	05 00 02 00 00       	add    $0x200,%eax
  801eb5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801eb8:	eb 44                	jmp    801efe <fork+0x130>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  801eba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec1:	01 00 00 
  801ec4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ec7:	48 63 d2             	movslq %edx,%rdx
  801eca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ece:	83 e0 05             	and    $0x5,%eax
  801ed1:	48 83 f8 05          	cmp    $0x5,%rax
  801ed5:	74 02                	je     801ed9 <fork+0x10b>
				continue;
  801ed7:	eb 21                	jmp    801efa <fork+0x12c>
			if (pn == PPN(UXSTACKTOP - 1))
  801ed9:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  801ee0:	75 02                	jne    801ee4 <fork+0x116>
				continue;
  801ee2:	eb 16                	jmp    801efa <fork+0x12c>
			duppage(envid, pn);
  801ee4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ee7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801eea:	89 d6                	mov    %edx,%esi
  801eec:	89 c7                	mov    %eax,%edi
  801eee:	48 b8 4d 1c 80 00 00 	movabs $0x801c4d,%rax
  801ef5:	00 00 00 
  801ef8:	ff d0                	callq  *%rax
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  801efa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801efe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f01:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801f04:	7c b4                	jl     801eba <fork+0xec>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  801f06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f09:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  801f0e:	0f 86 4e ff ff ff    	jbe    801e62 <fork+0x94>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  801f14:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f17:	ba 07 00 00 00       	mov    $0x7,%edx
  801f1c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801f21:	89 c7                	mov    %eax,%edi
  801f23:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  801f2a:	00 00 00 
  801f2d:	ff d0                	callq  *%rax
  801f2f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801f32:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f36:	79 30                	jns    801f68 <fork+0x19a>
		panic("allocating exception stack: %e", r);
  801f38:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801f3b:	89 c1                	mov    %eax,%ecx
  801f3d:	48 ba 48 29 80 00 00 	movabs $0x802948,%rdx
  801f44:	00 00 00 
  801f47:	be 98 00 00 00       	mov    $0x98,%esi
  801f4c:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  801f53:	00 00 00 
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5b:	49 b8 ef 21 80 00 00 	movabs $0x8021ef,%r8
  801f62:	00 00 00 
  801f65:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  801f68:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  801f6f:	00 00 00 
  801f72:	48 8b 00             	mov    (%rax),%rax
  801f75:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  801f7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f7f:	48 89 d6             	mov    %rdx,%rsi
  801f82:	89 c7                	mov    %eax,%edi
  801f84:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  801f8b:	00 00 00 
  801f8e:	ff d0                	callq  *%rax
  801f90:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801f93:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801f97:	79 30                	jns    801fc9 <fork+0x1fb>
		panic("sys_env_set_pgfault_upcall: %e", r);
  801f99:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801f9c:	89 c1                	mov    %eax,%ecx
  801f9e:	48 ba 68 29 80 00 00 	movabs $0x802968,%rdx
  801fa5:	00 00 00 
  801fa8:	be 9c 00 00 00       	mov    $0x9c,%esi
  801fad:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  801fb4:	00 00 00 
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbc:	49 b8 ef 21 80 00 00 	movabs $0x8021ef,%r8
  801fc3:	00 00 00 
  801fc6:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801fc9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fcc:	be 02 00 00 00       	mov    $0x2,%esi
  801fd1:	89 c7                	mov    %eax,%edi
  801fd3:	48 b8 00 19 80 00 00 	movabs $0x801900,%rax
  801fda:	00 00 00 
  801fdd:	ff d0                	callq  *%rax
  801fdf:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801fe2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801fe6:	79 30                	jns    802018 <fork+0x24a>
		panic("sys_env_set_status: %e", r);
  801fe8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801feb:	89 c1                	mov    %eax,%ecx
  801fed:	48 ba 87 29 80 00 00 	movabs $0x802987,%rdx
  801ff4:	00 00 00 
  801ff7:	be a1 00 00 00       	mov    $0xa1,%esi
  801ffc:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  802003:	00 00 00 
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
  80200b:	49 b8 ef 21 80 00 00 	movabs $0x8021ef,%r8
  802012:	00 00 00 
  802015:	41 ff d0             	callq  *%r8

	return envid;
  802018:	8b 45 f8             	mov    -0x8(%rbp),%eax


}
  80201b:	c9                   	leaveq 
  80201c:	c3                   	retq   

000000000080201d <sfork>:

// Challenge!
int
sfork(void)
{
  80201d:	55                   	push   %rbp
  80201e:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802021:	48 ba 9e 29 80 00 00 	movabs $0x80299e,%rdx
  802028:	00 00 00 
  80202b:	be ac 00 00 00       	mov    $0xac,%esi
  802030:	48 bf d1 28 80 00 00 	movabs $0x8028d1,%rdi
  802037:	00 00 00 
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	48 b9 ef 21 80 00 00 	movabs $0x8021ef,%rcx
  802046:	00 00 00 
  802049:	ff d1                	callq  *%rcx

000000000080204b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80204b:	55                   	push   %rbp
  80204c:	48 89 e5             	mov    %rsp,%rbp
  80204f:	48 83 ec 30          	sub    $0x30,%rsp
  802053:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802057:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80205b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	
	if(pg == NULL)
  80205f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802064:	75 0e                	jne    802074 <ipc_recv+0x29>
	  pg = (void *)(UTOP); // We always check above and below UTOP
  802066:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80206d:	00 00 00 
  802070:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	 int retval = sys_ipc_recv(pg);
  802074:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802078:	48 89 c7             	mov    %rax,%rdi
  80207b:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  802082:	00 00 00 
  802085:	ff d0                	callq  *%rax
  802087:	89 45 fc             	mov    %eax,-0x4(%rbp)

	 if(retval == 0)
  80208a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80208e:	75 55                	jne    8020e5 <ipc_recv+0x9a>
	 {	
	    if(from_env_store != NULL)
  802090:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802095:	74 19                	je     8020b0 <ipc_recv+0x65>
               *from_env_store = thisenv->env_ipc_from;
  802097:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80209e:	00 00 00 
  8020a1:	48 8b 00             	mov    (%rax),%rax
  8020a4:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8020aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ae:	89 10                	mov    %edx,(%rax)

	    if(perm_store != NULL)
  8020b0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8020b5:	74 19                	je     8020d0 <ipc_recv+0x85>
               *perm_store = thisenv->env_ipc_perm;
  8020b7:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8020be:	00 00 00 
  8020c1:	48 8b 00             	mov    (%rax),%rax
  8020c4:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8020ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ce:	89 10                	mov    %edx,(%rax)

	   return thisenv->env_ipc_value;
  8020d0:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  8020d7:	00 00 00 
  8020da:	48 8b 00             	mov    (%rax),%rax
  8020dd:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8020e3:	eb 25                	jmp    80210a <ipc_recv+0xbf>

	 }
	 else
	 {
	      if(from_env_store)
  8020e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8020ea:	74 0a                	je     8020f6 <ipc_recv+0xab>
	         *from_env_store = 0;
  8020ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	      
	      if(perm_store)
  8020f6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8020fb:	74 0a                	je     802107 <ipc_recv+0xbc>
	       *perm_store = 0;
  8020fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802101:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	       
	       return retval;
  802107:	8b 45 fc             	mov    -0x4(%rbp),%eax
	 }
	
	panic("problem in ipc_recv lib/ipc.c");
	//return 0;
}
  80210a:	c9                   	leaveq 
  80210b:	c3                   	retq   

000000000080210c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80210c:	55                   	push   %rbp
  80210d:	48 89 e5             	mov    %rsp,%rbp
  802110:	48 83 ec 30          	sub    $0x30,%rsp
  802114:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802117:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80211a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80211e:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if(pg == NULL)
  802121:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802126:	75 0e                	jne    802136 <ipc_send+0x2a>
	   pg = (void *)(UTOP);
  802128:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80212f:	00 00 00 
  802132:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	int retval;
	while(1)
	{
	   retval = sys_ipc_try_send(to_env, val, pg, perm);
  802136:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802139:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80213c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802140:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802143:	89 c7                	mov    %eax,%edi
  802145:	48 b8 95 19 80 00 00 	movabs $0x801995,%rax
  80214c:	00 00 00 
  80214f:	ff d0                	callq  *%rax
  802151:	89 45 fc             	mov    %eax,-0x4(%rbp)
	   if(retval == 0)
  802154:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802158:	75 02                	jne    80215c <ipc_send+0x50>
	      break;
  80215a:	eb 0e                	jmp    80216a <ipc_send+0x5e>
	   
	   //if(retval < 0 && retval != -E_IPC_NOT_RECV)
	     //panic("receiver error other than NOT_RECV");

	   sys_yield(); 
  80215c:	48 b8 cd 17 80 00 00 	movabs $0x8017cd,%rax
  802163:	00 00 00 
  802166:	ff d0                	callq  *%rax
	 
	}
  802168:	eb cc                	jmp    802136 <ipc_send+0x2a>
	return;
  80216a:	90                   	nop
	//panic("ipc_send not implemented");
}
  80216b:	c9                   	leaveq 
  80216c:	c3                   	retq   

000000000080216d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80216d:	55                   	push   %rbp
  80216e:	48 89 e5             	mov    %rsp,%rbp
  802171:	48 83 ec 14          	sub    $0x14,%rsp
  802175:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++)
  802178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80217f:	eb 5e                	jmp    8021df <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802181:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802188:	00 00 00 
  80218b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80218e:	48 63 d0             	movslq %eax,%rdx
  802191:	48 89 d0             	mov    %rdx,%rax
  802194:	48 c1 e0 03          	shl    $0x3,%rax
  802198:	48 01 d0             	add    %rdx,%rax
  80219b:	48 c1 e0 05          	shl    $0x5,%rax
  80219f:	48 01 c8             	add    %rcx,%rax
  8021a2:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8021a8:	8b 00                	mov    (%rax),%eax
  8021aa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8021ad:	75 2c                	jne    8021db <ipc_find_env+0x6e>
			return envs[i].env_id;
  8021af:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8021b6:	00 00 00 
  8021b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021bc:	48 63 d0             	movslq %eax,%rdx
  8021bf:	48 89 d0             	mov    %rdx,%rax
  8021c2:	48 c1 e0 03          	shl    $0x3,%rax
  8021c6:	48 01 d0             	add    %rdx,%rax
  8021c9:	48 c1 e0 05          	shl    $0x5,%rax
  8021cd:	48 01 c8             	add    %rcx,%rax
  8021d0:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8021d6:	8b 40 08             	mov    0x8(%rax),%eax
  8021d9:	eb 12                	jmp    8021ed <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8021db:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8021df:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8021e6:	7e 99                	jle    802181 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8021e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ed:	c9                   	leaveq 
  8021ee:	c3                   	retq   

00000000008021ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021ef:	55                   	push   %rbp
  8021f0:	48 89 e5             	mov    %rsp,%rbp
  8021f3:	53                   	push   %rbx
  8021f4:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8021fb:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  802202:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  802208:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80220f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  802216:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80221d:	84 c0                	test   %al,%al
  80221f:	74 23                	je     802244 <_panic+0x55>
  802221:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  802228:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80222c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  802230:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  802234:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  802238:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80223c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  802240:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  802244:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80224b:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  802252:	00 00 00 
  802255:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80225c:	00 00 00 
  80225f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802263:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80226a:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  802271:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802278:	48 b8 00 40 80 00 00 	movabs $0x804000,%rax
  80227f:	00 00 00 
  802282:	48 8b 18             	mov    (%rax),%rbx
  802285:	48 b8 8f 17 80 00 00 	movabs $0x80178f,%rax
  80228c:	00 00 00 
  80228f:	ff d0                	callq  *%rax
  802291:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  802297:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80229e:	41 89 c8             	mov    %ecx,%r8d
  8022a1:	48 89 d1             	mov    %rdx,%rcx
  8022a4:	48 89 da             	mov    %rbx,%rdx
  8022a7:	89 c6                	mov    %eax,%esi
  8022a9:	48 bf b8 29 80 00 00 	movabs $0x8029b8,%rdi
  8022b0:	00 00 00 
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b8:	49 b9 27 03 80 00 00 	movabs $0x800327,%r9
  8022bf:	00 00 00 
  8022c2:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022c5:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8022cc:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8022d3:	48 89 d6             	mov    %rdx,%rsi
  8022d6:	48 89 c7             	mov    %rax,%rdi
  8022d9:	48 b8 7b 02 80 00 00 	movabs $0x80027b,%rax
  8022e0:	00 00 00 
  8022e3:	ff d0                	callq  *%rax
	cprintf("\n");
  8022e5:	48 bf db 29 80 00 00 	movabs $0x8029db,%rdi
  8022ec:	00 00 00 
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	48 ba 27 03 80 00 00 	movabs $0x800327,%rdx
  8022fb:	00 00 00 
  8022fe:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802300:	cc                   	int3   
  802301:	eb fd                	jmp    802300 <_panic+0x111>

0000000000802303 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802303:	55                   	push   %rbp
  802304:	48 89 e5             	mov    %rsp,%rbp
  802307:	48 83 ec 10          	sub    $0x10,%rsp
  80230b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;
	
	if (_pgfault_handler == 0) {
  80230f:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  802316:	00 00 00 
  802319:	48 8b 00             	mov    (%rax),%rax
  80231c:	48 85 c0             	test   %rax,%rax
  80231f:	0f 85 b2 00 00 00    	jne    8023d7 <set_pgfault_handler+0xd4>
		// First time through!
		// LAB 4: Your code here.
		
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP-PGSIZE), PTE_P|PTE_U|PTE_W) != 0)
  802325:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  80232c:	00 00 00 
  80232f:	48 8b 00             	mov    (%rax),%rax
  802332:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802338:	ba 07 00 00 00       	mov    $0x7,%edx
  80233d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802342:	89 c7                	mov    %eax,%edi
  802344:	48 b8 0b 18 80 00 00 	movabs $0x80180b,%rax
  80234b:	00 00 00 
  80234e:	ff d0                	callq  *%rax
  802350:	85 c0                	test   %eax,%eax
  802352:	74 2a                	je     80237e <set_pgfault_handler+0x7b>
		  panic("\nproblem in page allocation lib/pgfault.c\n");
  802354:	48 ba e0 29 80 00 00 	movabs $0x8029e0,%rdx
  80235b:	00 00 00 
  80235e:	be 22 00 00 00       	mov    $0x22,%esi
  802363:	48 bf 0b 2a 80 00 00 	movabs $0x802a0b,%rdi
  80236a:	00 00 00 
  80236d:	b8 00 00 00 00       	mov    $0x0,%eax
  802372:	48 b9 ef 21 80 00 00 	movabs $0x8021ef,%rcx
  802379:	00 00 00 
  80237c:	ff d1                	callq  *%rcx
		
	         if(sys_env_set_pgfault_upcall(thisenv->env_id, (void *)_pgfault_upcall) != 0)
  80237e:	48 b8 08 40 80 00 00 	movabs $0x804008,%rax
  802385:	00 00 00 
  802388:	48 8b 00             	mov    (%rax),%rax
  80238b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802391:	48 be ea 23 80 00 00 	movabs $0x8023ea,%rsi
  802398:	00 00 00 
  80239b:	89 c7                	mov    %eax,%edi
  80239d:	48 b8 4b 19 80 00 00 	movabs $0x80194b,%rax
  8023a4:	00 00 00 
  8023a7:	ff d0                	callq  *%rax
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	74 2a                	je     8023d7 <set_pgfault_handler+0xd4>
		   panic("set_pgfault_handler implemented but problems lib/pgfault.c");
  8023ad:	48 ba 20 2a 80 00 00 	movabs $0x802a20,%rdx
  8023b4:	00 00 00 
  8023b7:	be 25 00 00 00       	mov    $0x25,%esi
  8023bc:	48 bf 0b 2a 80 00 00 	movabs $0x802a0b,%rdi
  8023c3:	00 00 00 
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cb:	48 b9 ef 21 80 00 00 	movabs $0x8021ef,%rcx
  8023d2:	00 00 00 
  8023d5:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8023d7:	48 b8 10 40 80 00 00 	movabs $0x804010,%rax
  8023de:	00 00 00 
  8023e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023e5:	48 89 10             	mov    %rdx,(%rax)
}
  8023e8:	c9                   	leaveq 
  8023e9:	c3                   	retq   

00000000008023ea <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  8023ea:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  8023ed:	48 a1 10 40 80 00 00 	movabs 0x804010,%rax
  8023f4:	00 00 00 
	call *%rax
  8023f7:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.                
	movq %rsp, %rdi;	
  8023f9:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  8023fc:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  802403:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  802404:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  80240b:	00 
	pushq %rbx;
  80240c:	53                   	push   %rbx
	movq %rsp, %rbx;	
  80240d:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  802410:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  802413:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  80241a:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  80241b:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  80241f:	4c 8b 3c 24          	mov    (%rsp),%r15
  802423:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  802428:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80242d:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  802432:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  802437:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80243c:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  802441:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  802446:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80244b:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  802450:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  802455:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80245a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80245f:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  802464:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  802469:	48 83 c4 78          	add    $0x78,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	add $8, %rsp; //Jump rip field  
  80246d:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  802471:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  802472:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  802473:	c3                   	retq   
