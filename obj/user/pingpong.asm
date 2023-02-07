
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
  800053:	48 b8 c3 1c 80 00 00 	movabs $0x801cc3,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  800062:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800065:	85 c0                	test   %eax,%eax
  800067:	74 4e                	je     8000b7 <umain+0x74>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800069:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  80006c:	48 b8 87 17 80 00 00 	movabs $0x801787,%rax
  800073:	00 00 00 
  800076:	ff d0                	callq  *%rax
  800078:	89 da                	mov    %ebx,%edx
  80007a:	89 c6                	mov    %eax,%esi
  80007c:	48 bf 40 3c 80 00 00 	movabs $0x803c40,%rdi
  800083:	00 00 00 
  800086:	b8 00 00 00 00       	mov    $0x0,%eax
  80008b:	48 b9 1f 03 80 00 00 	movabs $0x80031f,%rcx
  800092:	00 00 00 
  800095:	ff d1                	callq  *%rcx
		ipc_send(who, 0, 0, 0);
  800097:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80009a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	be 00 00 00 00       	mov    $0x0,%esi
  8000a9:	89 c7                	mov    %eax,%edi
  8000ab:	48 b8 81 20 80 00 00 	movabs $0x802081,%rax
  8000b2:	00 00 00 
  8000b5:	ff d0                	callq  *%rax
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  8000b7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 00 00 00       	mov    $0x0,%esi
  8000c5:	48 89 c7             	mov    %rax,%rdi
  8000c8:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax
  8000d4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000d7:	8b 5d e8             	mov    -0x18(%rbp),%ebx
  8000da:	48 b8 87 17 80 00 00 	movabs $0x801787,%rax
  8000e1:	00 00 00 
  8000e4:	ff d0                	callq  *%rax
  8000e6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000e9:	89 d9                	mov    %ebx,%ecx
  8000eb:	89 c6                	mov    %eax,%esi
  8000ed:	48 bf 56 3c 80 00 00 	movabs $0x803c56,%rdi
  8000f4:	00 00 00 
  8000f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fc:	49 b8 1f 03 80 00 00 	movabs $0x80031f,%r8
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
  800127:	48 b8 81 20 80 00 00 	movabs $0x802081,%rax
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
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800152:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800156:	48 b8 87 17 80 00 00 	movabs $0x801787,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	48 98                	cltq   
  800164:	25 ff 03 00 00       	and    $0x3ff,%eax
  800169:	48 89 c2             	mov    %rax,%rdx
  80016c:	48 89 d0             	mov    %rdx,%rax
  80016f:	48 c1 e0 03          	shl    $0x3,%rax
  800173:	48 01 d0             	add    %rdx,%rax
  800176:	48 c1 e0 05          	shl    $0x5,%rax
  80017a:	48 89 c2             	mov    %rax,%rdx
  80017d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800184:	00 00 00 
  800187:	48 01 c2             	add    %rax,%rdx
  80018a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800191:	00 00 00 
  800194:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800197:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80019b:	7e 14                	jle    8001b1 <libmain+0x6a>
		binaryname = argv[0];
  80019d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a1:	48 8b 10             	mov    (%rax),%rdx
  8001a4:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001ab:	00 00 00 
  8001ae:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b8:	48 89 d6             	mov    %rdx,%rsi
  8001bb:	89 c7                	mov    %eax,%edi
  8001bd:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c4:	00 00 00 
  8001c7:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001c9:	48 b8 d7 01 80 00 00 	movabs $0x8001d7,%rax
  8001d0:	00 00 00 
  8001d3:	ff d0                	callq  *%rax
}
  8001d5:	c9                   	leaveq 
  8001d6:	c3                   	retq   

00000000008001d7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d7:	55                   	push   %rbp
  8001d8:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001db:	48 b8 e1 24 80 00 00 	movabs $0x8024e1,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ec:	48 b8 43 17 80 00 00 	movabs $0x801743,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax
}
  8001f8:	5d                   	pop    %rbp
  8001f9:	c3                   	retq   

00000000008001fa <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8001fa:	55                   	push   %rbp
  8001fb:	48 89 e5             	mov    %rsp,%rbp
  8001fe:	48 83 ec 10          	sub    $0x10,%rsp
  800202:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800205:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800209:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020d:	8b 00                	mov    (%rax),%eax
  80020f:	8d 48 01             	lea    0x1(%rax),%ecx
  800212:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800216:	89 0a                	mov    %ecx,(%rdx)
  800218:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80021b:	89 d1                	mov    %edx,%ecx
  80021d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800221:	48 98                	cltq   
  800223:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022b:	8b 00                	mov    (%rax),%eax
  80022d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800232:	75 2c                	jne    800260 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800234:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800238:	8b 00                	mov    (%rax),%eax
  80023a:	48 98                	cltq   
  80023c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800240:	48 83 c2 08          	add    $0x8,%rdx
  800244:	48 89 c6             	mov    %rax,%rsi
  800247:	48 89 d7             	mov    %rdx,%rdi
  80024a:	48 b8 bb 16 80 00 00 	movabs $0x8016bb,%rax
  800251:	00 00 00 
  800254:	ff d0                	callq  *%rax
        b->idx = 0;
  800256:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80025a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800260:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800264:	8b 40 04             	mov    0x4(%rax),%eax
  800267:	8d 50 01             	lea    0x1(%rax),%edx
  80026a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80026e:	89 50 04             	mov    %edx,0x4(%rax)
}
  800271:	c9                   	leaveq 
  800272:	c3                   	retq   

0000000000800273 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800273:	55                   	push   %rbp
  800274:	48 89 e5             	mov    %rsp,%rbp
  800277:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80027e:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800285:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80028c:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800293:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80029a:	48 8b 0a             	mov    (%rdx),%rcx
  80029d:	48 89 08             	mov    %rcx,(%rax)
  8002a0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002a4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002a8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ac:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002b0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002b7:	00 00 00 
    b.cnt = 0;
  8002ba:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002c1:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002c4:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002cb:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002d2:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002d9:	48 89 c6             	mov    %rax,%rsi
  8002dc:	48 bf fa 01 80 00 00 	movabs $0x8001fa,%rdi
  8002e3:	00 00 00 
  8002e6:	48 b8 d2 06 80 00 00 	movabs $0x8006d2,%rax
  8002ed:	00 00 00 
  8002f0:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8002f2:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8002f8:	48 98                	cltq   
  8002fa:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800301:	48 83 c2 08          	add    $0x8,%rdx
  800305:	48 89 c6             	mov    %rax,%rsi
  800308:	48 89 d7             	mov    %rdx,%rdi
  80030b:	48 b8 bb 16 80 00 00 	movabs $0x8016bb,%rax
  800312:	00 00 00 
  800315:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800317:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80031d:	c9                   	leaveq 
  80031e:	c3                   	retq   

000000000080031f <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80031f:	55                   	push   %rbp
  800320:	48 89 e5             	mov    %rsp,%rbp
  800323:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80032a:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800331:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800338:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80033f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800346:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80034d:	84 c0                	test   %al,%al
  80034f:	74 20                	je     800371 <cprintf+0x52>
  800351:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800355:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800359:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80035d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800361:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800365:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800369:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80036d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800371:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800378:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80037f:	00 00 00 
  800382:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800389:	00 00 00 
  80038c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800390:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800397:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80039e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003a5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003ac:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003b3:	48 8b 0a             	mov    (%rdx),%rcx
  8003b6:	48 89 08             	mov    %rcx,(%rax)
  8003b9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003bd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003c1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003c5:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003c9:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003d0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003d7:	48 89 d6             	mov    %rdx,%rsi
  8003da:	48 89 c7             	mov    %rax,%rdi
  8003dd:	48 b8 73 02 80 00 00 	movabs $0x800273,%rax
  8003e4:	00 00 00 
  8003e7:	ff d0                	callq  *%rax
  8003e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8003ef:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8003f5:	c9                   	leaveq 
  8003f6:	c3                   	retq   

00000000008003f7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f7:	55                   	push   %rbp
  8003f8:	48 89 e5             	mov    %rsp,%rbp
  8003fb:	53                   	push   %rbx
  8003fc:	48 83 ec 38          	sub    $0x38,%rsp
  800400:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800404:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800408:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80040c:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80040f:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800413:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800417:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80041a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80041e:	77 3b                	ja     80045b <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800420:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800423:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800427:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80042a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80042e:	ba 00 00 00 00       	mov    $0x0,%edx
  800433:	48 f7 f3             	div    %rbx
  800436:	48 89 c2             	mov    %rax,%rdx
  800439:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80043c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80043f:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800447:	41 89 f9             	mov    %edi,%r9d
  80044a:	48 89 c7             	mov    %rax,%rdi
  80044d:	48 b8 f7 03 80 00 00 	movabs $0x8003f7,%rax
  800454:	00 00 00 
  800457:	ff d0                	callq  *%rax
  800459:	eb 1e                	jmp    800479 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80045b:	eb 12                	jmp    80046f <printnum+0x78>
			putch(padc, putdat);
  80045d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800461:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800464:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800468:	48 89 ce             	mov    %rcx,%rsi
  80046b:	89 d7                	mov    %edx,%edi
  80046d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80046f:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800473:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800477:	7f e4                	jg     80045d <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800479:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80047c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800480:	ba 00 00 00 00       	mov    $0x0,%edx
  800485:	48 f7 f1             	div    %rcx
  800488:	48 89 d0             	mov    %rdx,%rax
  80048b:	48 ba 70 3e 80 00 00 	movabs $0x803e70,%rdx
  800492:	00 00 00 
  800495:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800499:	0f be d0             	movsbl %al,%edx
  80049c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004a4:	48 89 ce             	mov    %rcx,%rsi
  8004a7:	89 d7                	mov    %edx,%edi
  8004a9:	ff d0                	callq  *%rax
}
  8004ab:	48 83 c4 38          	add    $0x38,%rsp
  8004af:	5b                   	pop    %rbx
  8004b0:	5d                   	pop    %rbp
  8004b1:	c3                   	retq   

00000000008004b2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b2:	55                   	push   %rbp
  8004b3:	48 89 e5             	mov    %rsp,%rbp
  8004b6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004be:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004c1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004c5:	7e 52                	jle    800519 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004cb:	8b 00                	mov    (%rax),%eax
  8004cd:	83 f8 30             	cmp    $0x30,%eax
  8004d0:	73 24                	jae    8004f6 <getuint+0x44>
  8004d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004d6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004de:	8b 00                	mov    (%rax),%eax
  8004e0:	89 c0                	mov    %eax,%eax
  8004e2:	48 01 d0             	add    %rdx,%rax
  8004e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004e9:	8b 12                	mov    (%rdx),%edx
  8004eb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8004ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8004f2:	89 0a                	mov    %ecx,(%rdx)
  8004f4:	eb 17                	jmp    80050d <getuint+0x5b>
  8004f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fa:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8004fe:	48 89 d0             	mov    %rdx,%rax
  800501:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800505:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800509:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80050d:	48 8b 00             	mov    (%rax),%rax
  800510:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800514:	e9 a3 00 00 00       	jmpq   8005bc <getuint+0x10a>
	else if (lflag)
  800519:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80051d:	74 4f                	je     80056e <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80051f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800523:	8b 00                	mov    (%rax),%eax
  800525:	83 f8 30             	cmp    $0x30,%eax
  800528:	73 24                	jae    80054e <getuint+0x9c>
  80052a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80052e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800532:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800536:	8b 00                	mov    (%rax),%eax
  800538:	89 c0                	mov    %eax,%eax
  80053a:	48 01 d0             	add    %rdx,%rax
  80053d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800541:	8b 12                	mov    (%rdx),%edx
  800543:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800546:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80054a:	89 0a                	mov    %ecx,(%rdx)
  80054c:	eb 17                	jmp    800565 <getuint+0xb3>
  80054e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800552:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800556:	48 89 d0             	mov    %rdx,%rax
  800559:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80055d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800561:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800565:	48 8b 00             	mov    (%rax),%rax
  800568:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80056c:	eb 4e                	jmp    8005bc <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80056e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800572:	8b 00                	mov    (%rax),%eax
  800574:	83 f8 30             	cmp    $0x30,%eax
  800577:	73 24                	jae    80059d <getuint+0xeb>
  800579:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800581:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800585:	8b 00                	mov    (%rax),%eax
  800587:	89 c0                	mov    %eax,%eax
  800589:	48 01 d0             	add    %rdx,%rax
  80058c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800590:	8b 12                	mov    (%rdx),%edx
  800592:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800595:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800599:	89 0a                	mov    %ecx,(%rdx)
  80059b:	eb 17                	jmp    8005b4 <getuint+0x102>
  80059d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005a5:	48 89 d0             	mov    %rdx,%rax
  8005a8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ac:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005b4:	8b 00                	mov    (%rax),%eax
  8005b6:	89 c0                	mov    %eax,%eax
  8005b8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005c0:	c9                   	leaveq 
  8005c1:	c3                   	retq   

00000000008005c2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c2:	55                   	push   %rbp
  8005c3:	48 89 e5             	mov    %rsp,%rbp
  8005c6:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005ce:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005d1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005d5:	7e 52                	jle    800629 <getint+0x67>
		x=va_arg(*ap, long long);
  8005d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005db:	8b 00                	mov    (%rax),%eax
  8005dd:	83 f8 30             	cmp    $0x30,%eax
  8005e0:	73 24                	jae    800606 <getint+0x44>
  8005e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	89 c0                	mov    %eax,%eax
  8005f2:	48 01 d0             	add    %rdx,%rax
  8005f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f9:	8b 12                	mov    (%rdx),%edx
  8005fb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800602:	89 0a                	mov    %ecx,(%rdx)
  800604:	eb 17                	jmp    80061d <getint+0x5b>
  800606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060e:	48 89 d0             	mov    %rdx,%rax
  800611:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800615:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800619:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061d:	48 8b 00             	mov    (%rax),%rax
  800620:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800624:	e9 a3 00 00 00       	jmpq   8006cc <getint+0x10a>
	else if (lflag)
  800629:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80062d:	74 4f                	je     80067e <getint+0xbc>
		x=va_arg(*ap, long);
  80062f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800633:	8b 00                	mov    (%rax),%eax
  800635:	83 f8 30             	cmp    $0x30,%eax
  800638:	73 24                	jae    80065e <getint+0x9c>
  80063a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80063e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800646:	8b 00                	mov    (%rax),%eax
  800648:	89 c0                	mov    %eax,%eax
  80064a:	48 01 d0             	add    %rdx,%rax
  80064d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800651:	8b 12                	mov    (%rdx),%edx
  800653:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800656:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065a:	89 0a                	mov    %ecx,(%rdx)
  80065c:	eb 17                	jmp    800675 <getint+0xb3>
  80065e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800662:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800666:	48 89 d0             	mov    %rdx,%rax
  800669:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80066d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800671:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800675:	48 8b 00             	mov    (%rax),%rax
  800678:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067c:	eb 4e                	jmp    8006cc <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80067e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800682:	8b 00                	mov    (%rax),%eax
  800684:	83 f8 30             	cmp    $0x30,%eax
  800687:	73 24                	jae    8006ad <getint+0xeb>
  800689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	8b 00                	mov    (%rax),%eax
  800697:	89 c0                	mov    %eax,%eax
  800699:	48 01 d0             	add    %rdx,%rax
  80069c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a0:	8b 12                	mov    (%rdx),%edx
  8006a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006a9:	89 0a                	mov    %ecx,(%rdx)
  8006ab:	eb 17                	jmp    8006c4 <getint+0x102>
  8006ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006b5:	48 89 d0             	mov    %rdx,%rax
  8006b8:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006bc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006c4:	8b 00                	mov    (%rax),%eax
  8006c6:	48 98                	cltq   
  8006c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006d0:	c9                   	leaveq 
  8006d1:	c3                   	retq   

00000000008006d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006d2:	55                   	push   %rbp
  8006d3:	48 89 e5             	mov    %rsp,%rbp
  8006d6:	41 54                	push   %r12
  8006d8:	53                   	push   %rbx
  8006d9:	48 83 ec 60          	sub    $0x60,%rsp
  8006dd:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006e1:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8006e5:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8006e9:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8006ed:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8006f1:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8006f5:	48 8b 0a             	mov    (%rdx),%rcx
  8006f8:	48 89 08             	mov    %rcx,(%rax)
  8006fb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006ff:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800703:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800707:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070b:	eb 17                	jmp    800724 <vprintfmt+0x52>
			if (ch == '\0')
  80070d:	85 db                	test   %ebx,%ebx
  80070f:	0f 84 cc 04 00 00    	je     800be1 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800715:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800719:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80071d:	48 89 d6             	mov    %rdx,%rsi
  800720:	89 df                	mov    %ebx,%edi
  800722:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800724:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800728:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80072c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800730:	0f b6 00             	movzbl (%rax),%eax
  800733:	0f b6 d8             	movzbl %al,%ebx
  800736:	83 fb 25             	cmp    $0x25,%ebx
  800739:	75 d2                	jne    80070d <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80073b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80073f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800746:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80074d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800754:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80075f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800763:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800767:	0f b6 00             	movzbl (%rax),%eax
  80076a:	0f b6 d8             	movzbl %al,%ebx
  80076d:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800770:	83 f8 55             	cmp    $0x55,%eax
  800773:	0f 87 34 04 00 00    	ja     800bad <vprintfmt+0x4db>
  800779:	89 c0                	mov    %eax,%eax
  80077b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800782:	00 
  800783:	48 b8 98 3e 80 00 00 	movabs $0x803e98,%rax
  80078a:	00 00 00 
  80078d:	48 01 d0             	add    %rdx,%rax
  800790:	48 8b 00             	mov    (%rax),%rax
  800793:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800795:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800799:	eb c0                	jmp    80075b <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079b:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  80079f:	eb ba                	jmp    80075b <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007a8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007ab:	89 d0                	mov    %edx,%eax
  8007ad:	c1 e0 02             	shl    $0x2,%eax
  8007b0:	01 d0                	add    %edx,%eax
  8007b2:	01 c0                	add    %eax,%eax
  8007b4:	01 d8                	add    %ebx,%eax
  8007b6:	83 e8 30             	sub    $0x30,%eax
  8007b9:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007bc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007c0:	0f b6 00             	movzbl (%rax),%eax
  8007c3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c9:	7e 0c                	jle    8007d7 <vprintfmt+0x105>
  8007cb:	83 fb 39             	cmp    $0x39,%ebx
  8007ce:	7f 07                	jg     8007d7 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007d0:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d5:	eb d1                	jmp    8007a8 <vprintfmt+0xd6>
			goto process_precision;
  8007d7:	eb 58                	jmp    800831 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007d9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007dc:	83 f8 30             	cmp    $0x30,%eax
  8007df:	73 17                	jae    8007f8 <vprintfmt+0x126>
  8007e1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8007e5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007e8:	89 c0                	mov    %eax,%eax
  8007ea:	48 01 d0             	add    %rdx,%rax
  8007ed:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8007f0:	83 c2 08             	add    $0x8,%edx
  8007f3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8007f6:	eb 0f                	jmp    800807 <vprintfmt+0x135>
  8007f8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8007fc:	48 89 d0             	mov    %rdx,%rax
  8007ff:	48 83 c2 08          	add    $0x8,%rdx
  800803:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800807:	8b 00                	mov    (%rax),%eax
  800809:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80080c:	eb 23                	jmp    800831 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80080e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800812:	79 0c                	jns    800820 <vprintfmt+0x14e>
				width = 0;
  800814:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80081b:	e9 3b ff ff ff       	jmpq   80075b <vprintfmt+0x89>
  800820:	e9 36 ff ff ff       	jmpq   80075b <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800825:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80082c:	e9 2a ff ff ff       	jmpq   80075b <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800831:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800835:	79 12                	jns    800849 <vprintfmt+0x177>
				width = precision, precision = -1;
  800837:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80083a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80083d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800844:	e9 12 ff ff ff       	jmpq   80075b <vprintfmt+0x89>
  800849:	e9 0d ff ff ff       	jmpq   80075b <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800852:	e9 04 ff ff ff       	jmpq   80075b <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800857:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80085a:	83 f8 30             	cmp    $0x30,%eax
  80085d:	73 17                	jae    800876 <vprintfmt+0x1a4>
  80085f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800863:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800866:	89 c0                	mov    %eax,%eax
  800868:	48 01 d0             	add    %rdx,%rax
  80086b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80086e:	83 c2 08             	add    $0x8,%edx
  800871:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800874:	eb 0f                	jmp    800885 <vprintfmt+0x1b3>
  800876:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80087a:	48 89 d0             	mov    %rdx,%rax
  80087d:	48 83 c2 08          	add    $0x8,%rdx
  800881:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800885:	8b 10                	mov    (%rax),%edx
  800887:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80088b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80088f:	48 89 ce             	mov    %rcx,%rsi
  800892:	89 d7                	mov    %edx,%edi
  800894:	ff d0                	callq  *%rax
			break;
  800896:	e9 40 03 00 00       	jmpq   800bdb <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80089b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089e:	83 f8 30             	cmp    $0x30,%eax
  8008a1:	73 17                	jae    8008ba <vprintfmt+0x1e8>
  8008a3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008a7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008aa:	89 c0                	mov    %eax,%eax
  8008ac:	48 01 d0             	add    %rdx,%rax
  8008af:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008b2:	83 c2 08             	add    $0x8,%edx
  8008b5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008b8:	eb 0f                	jmp    8008c9 <vprintfmt+0x1f7>
  8008ba:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008be:	48 89 d0             	mov    %rdx,%rax
  8008c1:	48 83 c2 08          	add    $0x8,%rdx
  8008c5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008c9:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008cb:	85 db                	test   %ebx,%ebx
  8008cd:	79 02                	jns    8008d1 <vprintfmt+0x1ff>
				err = -err;
  8008cf:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008d1:	83 fb 15             	cmp    $0x15,%ebx
  8008d4:	7f 16                	jg     8008ec <vprintfmt+0x21a>
  8008d6:	48 b8 c0 3d 80 00 00 	movabs $0x803dc0,%rax
  8008dd:	00 00 00 
  8008e0:	48 63 d3             	movslq %ebx,%rdx
  8008e3:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8008e7:	4d 85 e4             	test   %r12,%r12
  8008ea:	75 2e                	jne    80091a <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8008ec:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8008f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008f4:	89 d9                	mov    %ebx,%ecx
  8008f6:	48 ba 81 3e 80 00 00 	movabs $0x803e81,%rdx
  8008fd:	00 00 00 
  800900:	48 89 c7             	mov    %rax,%rdi
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
  800908:	49 b8 ea 0b 80 00 00 	movabs $0x800bea,%r8
  80090f:	00 00 00 
  800912:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800915:	e9 c1 02 00 00       	jmpq   800bdb <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80091a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80091e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800922:	4c 89 e1             	mov    %r12,%rcx
  800925:	48 ba 8a 3e 80 00 00 	movabs $0x803e8a,%rdx
  80092c:	00 00 00 
  80092f:	48 89 c7             	mov    %rax,%rdi
  800932:	b8 00 00 00 00       	mov    $0x0,%eax
  800937:	49 b8 ea 0b 80 00 00 	movabs $0x800bea,%r8
  80093e:	00 00 00 
  800941:	41 ff d0             	callq  *%r8
			break;
  800944:	e9 92 02 00 00       	jmpq   800bdb <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800949:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80094c:	83 f8 30             	cmp    $0x30,%eax
  80094f:	73 17                	jae    800968 <vprintfmt+0x296>
  800951:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800955:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800958:	89 c0                	mov    %eax,%eax
  80095a:	48 01 d0             	add    %rdx,%rax
  80095d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800960:	83 c2 08             	add    $0x8,%edx
  800963:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800966:	eb 0f                	jmp    800977 <vprintfmt+0x2a5>
  800968:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80096c:	48 89 d0             	mov    %rdx,%rax
  80096f:	48 83 c2 08          	add    $0x8,%rdx
  800973:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800977:	4c 8b 20             	mov    (%rax),%r12
  80097a:	4d 85 e4             	test   %r12,%r12
  80097d:	75 0a                	jne    800989 <vprintfmt+0x2b7>
				p = "(null)";
  80097f:	49 bc 8d 3e 80 00 00 	movabs $0x803e8d,%r12
  800986:	00 00 00 
			if (width > 0 && padc != '-')
  800989:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80098d:	7e 3f                	jle    8009ce <vprintfmt+0x2fc>
  80098f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800993:	74 39                	je     8009ce <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800995:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800998:	48 98                	cltq   
  80099a:	48 89 c6             	mov    %rax,%rsi
  80099d:	4c 89 e7             	mov    %r12,%rdi
  8009a0:	48 b8 96 0e 80 00 00 	movabs $0x800e96,%rax
  8009a7:	00 00 00 
  8009aa:	ff d0                	callq  *%rax
  8009ac:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009af:	eb 17                	jmp    8009c8 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009b1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009b5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009b9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009bd:	48 89 ce             	mov    %rcx,%rsi
  8009c0:	89 d7                	mov    %edx,%edi
  8009c2:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009cc:	7f e3                	jg     8009b1 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ce:	eb 37                	jmp    800a07 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009d4:	74 1e                	je     8009f4 <vprintfmt+0x322>
  8009d6:	83 fb 1f             	cmp    $0x1f,%ebx
  8009d9:	7e 05                	jle    8009e0 <vprintfmt+0x30e>
  8009db:	83 fb 7e             	cmp    $0x7e,%ebx
  8009de:	7e 14                	jle    8009f4 <vprintfmt+0x322>
					putch('?', putdat);
  8009e0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009e8:	48 89 d6             	mov    %rdx,%rsi
  8009eb:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8009f0:	ff d0                	callq  *%rax
  8009f2:	eb 0f                	jmp    800a03 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  8009f4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8009f8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009fc:	48 89 d6             	mov    %rdx,%rsi
  8009ff:	89 df                	mov    %ebx,%edi
  800a01:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a03:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a07:	4c 89 e0             	mov    %r12,%rax
  800a0a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a0e:	0f b6 00             	movzbl (%rax),%eax
  800a11:	0f be d8             	movsbl %al,%ebx
  800a14:	85 db                	test   %ebx,%ebx
  800a16:	74 10                	je     800a28 <vprintfmt+0x356>
  800a18:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a1c:	78 b2                	js     8009d0 <vprintfmt+0x2fe>
  800a1e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a22:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a26:	79 a8                	jns    8009d0 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a28:	eb 16                	jmp    800a40 <vprintfmt+0x36e>
				putch(' ', putdat);
  800a2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a32:	48 89 d6             	mov    %rdx,%rsi
  800a35:	bf 20 00 00 00       	mov    $0x20,%edi
  800a3a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a44:	7f e4                	jg     800a2a <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a46:	e9 90 01 00 00       	jmpq   800bdb <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a4b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a4f:	be 03 00 00 00       	mov    $0x3,%esi
  800a54:	48 89 c7             	mov    %rax,%rdi
  800a57:	48 b8 c2 05 80 00 00 	movabs $0x8005c2,%rax
  800a5e:	00 00 00 
  800a61:	ff d0                	callq  *%rax
  800a63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a67:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a6b:	48 85 c0             	test   %rax,%rax
  800a6e:	79 1d                	jns    800a8d <vprintfmt+0x3bb>
				putch('-', putdat);
  800a70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a78:	48 89 d6             	mov    %rdx,%rsi
  800a7b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a80:	ff d0                	callq  *%rax
				num = -(long long) num;
  800a82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a86:	48 f7 d8             	neg    %rax
  800a89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800a8d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800a94:	e9 d5 00 00 00       	jmpq   800b6e <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800a99:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a9d:	be 03 00 00 00       	mov    $0x3,%esi
  800aa2:	48 89 c7             	mov    %rax,%rdi
  800aa5:	48 b8 b2 04 80 00 00 	movabs $0x8004b2,%rax
  800aac:	00 00 00 
  800aaf:	ff d0                	callq  *%rax
  800ab1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ab5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800abc:	e9 ad 00 00 00       	jmpq   800b6e <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800ac1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ac5:	be 03 00 00 00       	mov    $0x3,%esi
  800aca:	48 89 c7             	mov    %rax,%rdi
  800acd:	48 b8 b2 04 80 00 00 	movabs $0x8004b2,%rax
  800ad4:	00 00 00 
  800ad7:	ff d0                	callq  *%rax
  800ad9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800add:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800ae4:	e9 85 00 00 00       	jmpq   800b6e <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800ae9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800af1:	48 89 d6             	mov    %rdx,%rsi
  800af4:	bf 30 00 00 00       	mov    $0x30,%edi
  800af9:	ff d0                	callq  *%rax
			putch('x', putdat);
  800afb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b03:	48 89 d6             	mov    %rdx,%rsi
  800b06:	bf 78 00 00 00       	mov    $0x78,%edi
  800b0b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b0d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b10:	83 f8 30             	cmp    $0x30,%eax
  800b13:	73 17                	jae    800b2c <vprintfmt+0x45a>
  800b15:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1c:	89 c0                	mov    %eax,%eax
  800b1e:	48 01 d0             	add    %rdx,%rax
  800b21:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b24:	83 c2 08             	add    $0x8,%edx
  800b27:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2a:	eb 0f                	jmp    800b3b <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b2c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b30:	48 89 d0             	mov    %rdx,%rax
  800b33:	48 83 c2 08          	add    $0x8,%rdx
  800b37:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b3b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b42:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b49:	eb 23                	jmp    800b6e <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b4b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b4f:	be 03 00 00 00       	mov    $0x3,%esi
  800b54:	48 89 c7             	mov    %rax,%rdi
  800b57:	48 b8 b2 04 80 00 00 	movabs $0x8004b2,%rax
  800b5e:	00 00 00 
  800b61:	ff d0                	callq  *%rax
  800b63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b67:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b73:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b76:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b79:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b7d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b81:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b85:	45 89 c1             	mov    %r8d,%r9d
  800b88:	41 89 f8             	mov    %edi,%r8d
  800b8b:	48 89 c7             	mov    %rax,%rdi
  800b8e:	48 b8 f7 03 80 00 00 	movabs $0x8003f7,%rax
  800b95:	00 00 00 
  800b98:	ff d0                	callq  *%rax
			break;
  800b9a:	eb 3f                	jmp    800bdb <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b9c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba4:	48 89 d6             	mov    %rdx,%rsi
  800ba7:	89 df                	mov    %ebx,%edi
  800ba9:	ff d0                	callq  *%rax
			break;
  800bab:	eb 2e                	jmp    800bdb <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bad:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb5:	48 89 d6             	mov    %rdx,%rsi
  800bb8:	bf 25 00 00 00       	mov    $0x25,%edi
  800bbd:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bbf:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bc4:	eb 05                	jmp    800bcb <vprintfmt+0x4f9>
  800bc6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800bcb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bcf:	48 83 e8 01          	sub    $0x1,%rax
  800bd3:	0f b6 00             	movzbl (%rax),%eax
  800bd6:	3c 25                	cmp    $0x25,%al
  800bd8:	75 ec                	jne    800bc6 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bda:	90                   	nop
		}
	}
  800bdb:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bdc:	e9 43 fb ff ff       	jmpq   800724 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800be1:	48 83 c4 60          	add    $0x60,%rsp
  800be5:	5b                   	pop    %rbx
  800be6:	41 5c                	pop    %r12
  800be8:	5d                   	pop    %rbp
  800be9:	c3                   	retq   

0000000000800bea <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bea:	55                   	push   %rbp
  800beb:	48 89 e5             	mov    %rsp,%rbp
  800bee:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800bf5:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800bfc:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c03:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c0a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c11:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c18:	84 c0                	test   %al,%al
  800c1a:	74 20                	je     800c3c <printfmt+0x52>
  800c1c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c20:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c24:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c28:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c2c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c30:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c34:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c38:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c3c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c43:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c4a:	00 00 00 
  800c4d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c54:	00 00 00 
  800c57:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c5b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c62:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c69:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c70:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c77:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c7e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800c85:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800c8c:	48 89 c7             	mov    %rax,%rdi
  800c8f:	48 b8 d2 06 80 00 00 	movabs $0x8006d2,%rax
  800c96:	00 00 00 
  800c99:	ff d0                	callq  *%rax
	va_end(ap);
}
  800c9b:	c9                   	leaveq 
  800c9c:	c3                   	retq   

0000000000800c9d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c9d:	55                   	push   %rbp
  800c9e:	48 89 e5             	mov    %rsp,%rbp
  800ca1:	48 83 ec 10          	sub    $0x10,%rsp
  800ca5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cb0:	8b 40 10             	mov    0x10(%rax),%eax
  800cb3:	8d 50 01             	lea    0x1(%rax),%edx
  800cb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cba:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc1:	48 8b 10             	mov    (%rax),%rdx
  800cc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc8:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ccc:	48 39 c2             	cmp    %rax,%rdx
  800ccf:	73 17                	jae    800ce8 <sprintputch+0x4b>
		*b->buf++ = ch;
  800cd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd5:	48 8b 00             	mov    (%rax),%rax
  800cd8:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cdc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ce0:	48 89 0a             	mov    %rcx,(%rdx)
  800ce3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800ce6:	88 10                	mov    %dl,(%rax)
}
  800ce8:	c9                   	leaveq 
  800ce9:	c3                   	retq   

0000000000800cea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cea:	55                   	push   %rbp
  800ceb:	48 89 e5             	mov    %rsp,%rbp
  800cee:	48 83 ec 50          	sub    $0x50,%rsp
  800cf2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800cf6:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800cf9:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800cfd:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d01:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d05:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d09:	48 8b 0a             	mov    (%rdx),%rcx
  800d0c:	48 89 08             	mov    %rcx,(%rax)
  800d0f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d13:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d17:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d1b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d1f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d23:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d27:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d2a:	48 98                	cltq   
  800d2c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d30:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d34:	48 01 d0             	add    %rdx,%rax
  800d37:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d42:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d47:	74 06                	je     800d4f <vsnprintf+0x65>
  800d49:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d4d:	7f 07                	jg     800d56 <vsnprintf+0x6c>
		return -E_INVAL;
  800d4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d54:	eb 2f                	jmp    800d85 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d56:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d5a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d5e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d62:	48 89 c6             	mov    %rax,%rsi
  800d65:	48 bf 9d 0c 80 00 00 	movabs $0x800c9d,%rdi
  800d6c:	00 00 00 
  800d6f:	48 b8 d2 06 80 00 00 	movabs $0x8006d2,%rax
  800d76:	00 00 00 
  800d79:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d7f:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800d82:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800d85:	c9                   	leaveq 
  800d86:	c3                   	retq   

0000000000800d87 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d87:	55                   	push   %rbp
  800d88:	48 89 e5             	mov    %rsp,%rbp
  800d8b:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800d92:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d99:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800d9f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800da6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dad:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800db4:	84 c0                	test   %al,%al
  800db6:	74 20                	je     800dd8 <snprintf+0x51>
  800db8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dbc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dc0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800dc4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800dc8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dcc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dd0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800dd4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800dd8:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ddf:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800de6:	00 00 00 
  800de9:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800df0:	00 00 00 
  800df3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800df7:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800dfe:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e05:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e0c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e13:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e1a:	48 8b 0a             	mov    (%rdx),%rcx
  800e1d:	48 89 08             	mov    %rcx,(%rax)
  800e20:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e24:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e28:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e2c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e30:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e37:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e3e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e44:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e4b:	48 89 c7             	mov    %rax,%rdi
  800e4e:	48 b8 ea 0c 80 00 00 	movabs $0x800cea,%rax
  800e55:	00 00 00 
  800e58:	ff d0                	callq  *%rax
  800e5a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e60:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e66:	c9                   	leaveq 
  800e67:	c3                   	retq   

0000000000800e68 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e68:	55                   	push   %rbp
  800e69:	48 89 e5             	mov    %rsp,%rbp
  800e6c:	48 83 ec 18          	sub    $0x18,%rsp
  800e70:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e7b:	eb 09                	jmp    800e86 <strlen+0x1e>
		n++;
  800e7d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e81:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800e86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8a:	0f b6 00             	movzbl (%rax),%eax
  800e8d:	84 c0                	test   %al,%al
  800e8f:	75 ec                	jne    800e7d <strlen+0x15>
		n++;
	return n;
  800e91:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e94:	c9                   	leaveq 
  800e95:	c3                   	retq   

0000000000800e96 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e96:	55                   	push   %rbp
  800e97:	48 89 e5             	mov    %rsp,%rbp
  800e9a:	48 83 ec 20          	sub    $0x20,%rsp
  800e9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ea2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ead:	eb 0e                	jmp    800ebd <strnlen+0x27>
		n++;
  800eaf:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800eb8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800ebd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ec2:	74 0b                	je     800ecf <strnlen+0x39>
  800ec4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec8:	0f b6 00             	movzbl (%rax),%eax
  800ecb:	84 c0                	test   %al,%al
  800ecd:	75 e0                	jne    800eaf <strnlen+0x19>
		n++;
	return n;
  800ecf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ed2:	c9                   	leaveq 
  800ed3:	c3                   	retq   

0000000000800ed4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ed4:	55                   	push   %rbp
  800ed5:	48 89 e5             	mov    %rsp,%rbp
  800ed8:	48 83 ec 20          	sub    $0x20,%rsp
  800edc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ee0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800ee4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800eec:	90                   	nop
  800eed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ef5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ef9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800efd:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f01:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f05:	0f b6 12             	movzbl (%rdx),%edx
  800f08:	88 10                	mov    %dl,(%rax)
  800f0a:	0f b6 00             	movzbl (%rax),%eax
  800f0d:	84 c0                	test   %al,%al
  800f0f:	75 dc                	jne    800eed <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f15:	c9                   	leaveq 
  800f16:	c3                   	retq   

0000000000800f17 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f17:	55                   	push   %rbp
  800f18:	48 89 e5             	mov    %rsp,%rbp
  800f1b:	48 83 ec 20          	sub    $0x20,%rsp
  800f1f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f23:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f2b:	48 89 c7             	mov    %rax,%rdi
  800f2e:	48 b8 68 0e 80 00 00 	movabs $0x800e68,%rax
  800f35:	00 00 00 
  800f38:	ff d0                	callq  *%rax
  800f3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f40:	48 63 d0             	movslq %eax,%rdx
  800f43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f47:	48 01 c2             	add    %rax,%rdx
  800f4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f4e:	48 89 c6             	mov    %rax,%rsi
  800f51:	48 89 d7             	mov    %rdx,%rdi
  800f54:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  800f5b:	00 00 00 
  800f5e:	ff d0                	callq  *%rax
	return dst;
  800f60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f64:	c9                   	leaveq 
  800f65:	c3                   	retq   

0000000000800f66 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f66:	55                   	push   %rbp
  800f67:	48 89 e5             	mov    %rsp,%rbp
  800f6a:	48 83 ec 28          	sub    $0x28,%rsp
  800f6e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f72:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f76:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800f82:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800f89:	00 
  800f8a:	eb 2a                	jmp    800fb6 <strncpy+0x50>
		*dst++ = *src;
  800f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f90:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f94:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f98:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f9c:	0f b6 12             	movzbl (%rdx),%edx
  800f9f:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fa1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fa5:	0f b6 00             	movzbl (%rax),%eax
  800fa8:	84 c0                	test   %al,%al
  800faa:	74 05                	je     800fb1 <strncpy+0x4b>
			src++;
  800fac:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fb1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fba:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fbe:	72 cc                	jb     800f8c <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fc4:	c9                   	leaveq 
  800fc5:	c3                   	retq   

0000000000800fc6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fc6:	55                   	push   %rbp
  800fc7:	48 89 e5             	mov    %rsp,%rbp
  800fca:	48 83 ec 28          	sub    $0x28,%rsp
  800fce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fd6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fde:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800fe2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800fe7:	74 3d                	je     801026 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  800fe9:	eb 1d                	jmp    801008 <strlcpy+0x42>
			*dst++ = *src++;
  800feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fef:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800ff3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800ff7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800ffb:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fff:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801003:	0f b6 12             	movzbl (%rdx),%edx
  801006:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801008:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80100d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801012:	74 0b                	je     80101f <strlcpy+0x59>
  801014:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801018:	0f b6 00             	movzbl (%rax),%eax
  80101b:	84 c0                	test   %al,%al
  80101d:	75 cc                	jne    800feb <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80101f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801023:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801026:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80102a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80102e:	48 29 c2             	sub    %rax,%rdx
  801031:	48 89 d0             	mov    %rdx,%rax
}
  801034:	c9                   	leaveq 
  801035:	c3                   	retq   

0000000000801036 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801036:	55                   	push   %rbp
  801037:	48 89 e5             	mov    %rsp,%rbp
  80103a:	48 83 ec 10          	sub    $0x10,%rsp
  80103e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801042:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801046:	eb 0a                	jmp    801052 <strcmp+0x1c>
		p++, q++;
  801048:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80104d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801052:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801056:	0f b6 00             	movzbl (%rax),%eax
  801059:	84 c0                	test   %al,%al
  80105b:	74 12                	je     80106f <strcmp+0x39>
  80105d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801061:	0f b6 10             	movzbl (%rax),%edx
  801064:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801068:	0f b6 00             	movzbl (%rax),%eax
  80106b:	38 c2                	cmp    %al,%dl
  80106d:	74 d9                	je     801048 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80106f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801073:	0f b6 00             	movzbl (%rax),%eax
  801076:	0f b6 d0             	movzbl %al,%edx
  801079:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107d:	0f b6 00             	movzbl (%rax),%eax
  801080:	0f b6 c0             	movzbl %al,%eax
  801083:	29 c2                	sub    %eax,%edx
  801085:	89 d0                	mov    %edx,%eax
}
  801087:	c9                   	leaveq 
  801088:	c3                   	retq   

0000000000801089 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801089:	55                   	push   %rbp
  80108a:	48 89 e5             	mov    %rsp,%rbp
  80108d:	48 83 ec 18          	sub    $0x18,%rsp
  801091:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801095:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801099:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80109d:	eb 0f                	jmp    8010ae <strncmp+0x25>
		n--, p++, q++;
  80109f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010a9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010ae:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010b3:	74 1d                	je     8010d2 <strncmp+0x49>
  8010b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010b9:	0f b6 00             	movzbl (%rax),%eax
  8010bc:	84 c0                	test   %al,%al
  8010be:	74 12                	je     8010d2 <strncmp+0x49>
  8010c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c4:	0f b6 10             	movzbl (%rax),%edx
  8010c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cb:	0f b6 00             	movzbl (%rax),%eax
  8010ce:	38 c2                	cmp    %al,%dl
  8010d0:	74 cd                	je     80109f <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010d2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d7:	75 07                	jne    8010e0 <strncmp+0x57>
		return 0;
  8010d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010de:	eb 18                	jmp    8010f8 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e4:	0f b6 00             	movzbl (%rax),%eax
  8010e7:	0f b6 d0             	movzbl %al,%edx
  8010ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ee:	0f b6 00             	movzbl (%rax),%eax
  8010f1:	0f b6 c0             	movzbl %al,%eax
  8010f4:	29 c2                	sub    %eax,%edx
  8010f6:	89 d0                	mov    %edx,%eax
}
  8010f8:	c9                   	leaveq 
  8010f9:	c3                   	retq   

00000000008010fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010fa:	55                   	push   %rbp
  8010fb:	48 89 e5             	mov    %rsp,%rbp
  8010fe:	48 83 ec 0c          	sub    $0xc,%rsp
  801102:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801106:	89 f0                	mov    %esi,%eax
  801108:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80110b:	eb 17                	jmp    801124 <strchr+0x2a>
		if (*s == c)
  80110d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801111:	0f b6 00             	movzbl (%rax),%eax
  801114:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801117:	75 06                	jne    80111f <strchr+0x25>
			return (char *) s;
  801119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80111d:	eb 15                	jmp    801134 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80111f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801128:	0f b6 00             	movzbl (%rax),%eax
  80112b:	84 c0                	test   %al,%al
  80112d:	75 de                	jne    80110d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80112f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801134:	c9                   	leaveq 
  801135:	c3                   	retq   

0000000000801136 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801136:	55                   	push   %rbp
  801137:	48 89 e5             	mov    %rsp,%rbp
  80113a:	48 83 ec 0c          	sub    $0xc,%rsp
  80113e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801142:	89 f0                	mov    %esi,%eax
  801144:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801147:	eb 13                	jmp    80115c <strfind+0x26>
		if (*s == c)
  801149:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80114d:	0f b6 00             	movzbl (%rax),%eax
  801150:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801153:	75 02                	jne    801157 <strfind+0x21>
			break;
  801155:	eb 10                	jmp    801167 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801157:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80115c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801160:	0f b6 00             	movzbl (%rax),%eax
  801163:	84 c0                	test   %al,%al
  801165:	75 e2                	jne    801149 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80116b:	c9                   	leaveq 
  80116c:	c3                   	retq   

000000000080116d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80116d:	55                   	push   %rbp
  80116e:	48 89 e5             	mov    %rsp,%rbp
  801171:	48 83 ec 18          	sub    $0x18,%rsp
  801175:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801179:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80117c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801180:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801185:	75 06                	jne    80118d <memset+0x20>
		return v;
  801187:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118b:	eb 69                	jmp    8011f6 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80118d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801191:	83 e0 03             	and    $0x3,%eax
  801194:	48 85 c0             	test   %rax,%rax
  801197:	75 48                	jne    8011e1 <memset+0x74>
  801199:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80119d:	83 e0 03             	and    $0x3,%eax
  8011a0:	48 85 c0             	test   %rax,%rax
  8011a3:	75 3c                	jne    8011e1 <memset+0x74>
		c &= 0xFF;
  8011a5:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011ac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011af:	c1 e0 18             	shl    $0x18,%eax
  8011b2:	89 c2                	mov    %eax,%edx
  8011b4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011b7:	c1 e0 10             	shl    $0x10,%eax
  8011ba:	09 c2                	or     %eax,%edx
  8011bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011bf:	c1 e0 08             	shl    $0x8,%eax
  8011c2:	09 d0                	or     %edx,%eax
  8011c4:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011cb:	48 c1 e8 02          	shr    $0x2,%rax
  8011cf:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011d2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d9:	48 89 d7             	mov    %rdx,%rdi
  8011dc:	fc                   	cld    
  8011dd:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011df:	eb 11                	jmp    8011f2 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011e5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011e8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8011ec:	48 89 d7             	mov    %rdx,%rdi
  8011ef:	fc                   	cld    
  8011f0:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8011f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011f6:	c9                   	leaveq 
  8011f7:	c3                   	retq   

00000000008011f8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011f8:	55                   	push   %rbp
  8011f9:	48 89 e5             	mov    %rsp,%rbp
  8011fc:	48 83 ec 28          	sub    $0x28,%rsp
  801200:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801204:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801208:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80120c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801210:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801214:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801218:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80121c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801220:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801224:	0f 83 88 00 00 00    	jae    8012b2 <memmove+0xba>
  80122a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80122e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801232:	48 01 d0             	add    %rdx,%rax
  801235:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801239:	76 77                	jbe    8012b2 <memmove+0xba>
		s += n;
  80123b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80123f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801243:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801247:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80124b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124f:	83 e0 03             	and    $0x3,%eax
  801252:	48 85 c0             	test   %rax,%rax
  801255:	75 3b                	jne    801292 <memmove+0x9a>
  801257:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125b:	83 e0 03             	and    $0x3,%eax
  80125e:	48 85 c0             	test   %rax,%rax
  801261:	75 2f                	jne    801292 <memmove+0x9a>
  801263:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801267:	83 e0 03             	and    $0x3,%eax
  80126a:	48 85 c0             	test   %rax,%rax
  80126d:	75 23                	jne    801292 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80126f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801273:	48 83 e8 04          	sub    $0x4,%rax
  801277:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80127b:	48 83 ea 04          	sub    $0x4,%rdx
  80127f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801283:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801287:	48 89 c7             	mov    %rax,%rdi
  80128a:	48 89 d6             	mov    %rdx,%rsi
  80128d:	fd                   	std    
  80128e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801290:	eb 1d                	jmp    8012af <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801292:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801296:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80129a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129e:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012a6:	48 89 d7             	mov    %rdx,%rdi
  8012a9:	48 89 c1             	mov    %rax,%rcx
  8012ac:	fd                   	std    
  8012ad:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012af:	fc                   	cld    
  8012b0:	eb 57                	jmp    801309 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b6:	83 e0 03             	and    $0x3,%eax
  8012b9:	48 85 c0             	test   %rax,%rax
  8012bc:	75 36                	jne    8012f4 <memmove+0xfc>
  8012be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c2:	83 e0 03             	and    $0x3,%eax
  8012c5:	48 85 c0             	test   %rax,%rax
  8012c8:	75 2a                	jne    8012f4 <memmove+0xfc>
  8012ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ce:	83 e0 03             	and    $0x3,%eax
  8012d1:	48 85 c0             	test   %rax,%rax
  8012d4:	75 1e                	jne    8012f4 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012da:	48 c1 e8 02          	shr    $0x2,%rax
  8012de:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e9:	48 89 c7             	mov    %rax,%rdi
  8012ec:	48 89 d6             	mov    %rdx,%rsi
  8012ef:	fc                   	cld    
  8012f0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012f2:	eb 15                	jmp    801309 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8012f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012fc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801300:	48 89 c7             	mov    %rax,%rdi
  801303:	48 89 d6             	mov    %rdx,%rsi
  801306:	fc                   	cld    
  801307:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80130d:	c9                   	leaveq 
  80130e:	c3                   	retq   

000000000080130f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80130f:	55                   	push   %rbp
  801310:	48 89 e5             	mov    %rsp,%rbp
  801313:	48 83 ec 18          	sub    $0x18,%rsp
  801317:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80131f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801323:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801327:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80132b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132f:	48 89 ce             	mov    %rcx,%rsi
  801332:	48 89 c7             	mov    %rax,%rdi
  801335:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  80133c:	00 00 00 
  80133f:	ff d0                	callq  *%rax
}
  801341:	c9                   	leaveq 
  801342:	c3                   	retq   

0000000000801343 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801343:	55                   	push   %rbp
  801344:	48 89 e5             	mov    %rsp,%rbp
  801347:	48 83 ec 28          	sub    $0x28,%rsp
  80134b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80134f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801353:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801357:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80135f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801363:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801367:	eb 36                	jmp    80139f <memcmp+0x5c>
		if (*s1 != *s2)
  801369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136d:	0f b6 10             	movzbl (%rax),%edx
  801370:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801374:	0f b6 00             	movzbl (%rax),%eax
  801377:	38 c2                	cmp    %al,%dl
  801379:	74 1a                	je     801395 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80137b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137f:	0f b6 00             	movzbl (%rax),%eax
  801382:	0f b6 d0             	movzbl %al,%edx
  801385:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801389:	0f b6 00             	movzbl (%rax),%eax
  80138c:	0f b6 c0             	movzbl %al,%eax
  80138f:	29 c2                	sub    %eax,%edx
  801391:	89 d0                	mov    %edx,%eax
  801393:	eb 20                	jmp    8013b5 <memcmp+0x72>
		s1++, s2++;
  801395:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80139a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80139f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013a7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013ab:	48 85 c0             	test   %rax,%rax
  8013ae:	75 b9                	jne    801369 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b5:	c9                   	leaveq 
  8013b6:	c3                   	retq   

00000000008013b7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013b7:	55                   	push   %rbp
  8013b8:	48 89 e5             	mov    %rsp,%rbp
  8013bb:	48 83 ec 28          	sub    $0x28,%rsp
  8013bf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013c6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013d2:	48 01 d0             	add    %rdx,%rax
  8013d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013d9:	eb 15                	jmp    8013f0 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013df:	0f b6 10             	movzbl (%rax),%edx
  8013e2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8013e5:	38 c2                	cmp    %al,%dl
  8013e7:	75 02                	jne    8013eb <memfind+0x34>
			break;
  8013e9:	eb 0f                	jmp    8013fa <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013eb:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013f4:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8013f8:	72 e1                	jb     8013db <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8013fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013fe:	c9                   	leaveq 
  8013ff:	c3                   	retq   

0000000000801400 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801400:	55                   	push   %rbp
  801401:	48 89 e5             	mov    %rsp,%rbp
  801404:	48 83 ec 34          	sub    $0x34,%rsp
  801408:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80140c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801410:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801413:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80141a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801421:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801422:	eb 05                	jmp    801429 <strtol+0x29>
		s++;
  801424:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801429:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80142d:	0f b6 00             	movzbl (%rax),%eax
  801430:	3c 20                	cmp    $0x20,%al
  801432:	74 f0                	je     801424 <strtol+0x24>
  801434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801438:	0f b6 00             	movzbl (%rax),%eax
  80143b:	3c 09                	cmp    $0x9,%al
  80143d:	74 e5                	je     801424 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80143f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801443:	0f b6 00             	movzbl (%rax),%eax
  801446:	3c 2b                	cmp    $0x2b,%al
  801448:	75 07                	jne    801451 <strtol+0x51>
		s++;
  80144a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80144f:	eb 17                	jmp    801468 <strtol+0x68>
	else if (*s == '-')
  801451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801455:	0f b6 00             	movzbl (%rax),%eax
  801458:	3c 2d                	cmp    $0x2d,%al
  80145a:	75 0c                	jne    801468 <strtol+0x68>
		s++, neg = 1;
  80145c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801461:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801468:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80146c:	74 06                	je     801474 <strtol+0x74>
  80146e:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801472:	75 28                	jne    80149c <strtol+0x9c>
  801474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801478:	0f b6 00             	movzbl (%rax),%eax
  80147b:	3c 30                	cmp    $0x30,%al
  80147d:	75 1d                	jne    80149c <strtol+0x9c>
  80147f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801483:	48 83 c0 01          	add    $0x1,%rax
  801487:	0f b6 00             	movzbl (%rax),%eax
  80148a:	3c 78                	cmp    $0x78,%al
  80148c:	75 0e                	jne    80149c <strtol+0x9c>
		s += 2, base = 16;
  80148e:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801493:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80149a:	eb 2c                	jmp    8014c8 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80149c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014a0:	75 19                	jne    8014bb <strtol+0xbb>
  8014a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a6:	0f b6 00             	movzbl (%rax),%eax
  8014a9:	3c 30                	cmp    $0x30,%al
  8014ab:	75 0e                	jne    8014bb <strtol+0xbb>
		s++, base = 8;
  8014ad:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014b2:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014b9:	eb 0d                	jmp    8014c8 <strtol+0xc8>
	else if (base == 0)
  8014bb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014bf:	75 07                	jne    8014c8 <strtol+0xc8>
		base = 10;
  8014c1:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014cc:	0f b6 00             	movzbl (%rax),%eax
  8014cf:	3c 2f                	cmp    $0x2f,%al
  8014d1:	7e 1d                	jle    8014f0 <strtol+0xf0>
  8014d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d7:	0f b6 00             	movzbl (%rax),%eax
  8014da:	3c 39                	cmp    $0x39,%al
  8014dc:	7f 12                	jg     8014f0 <strtol+0xf0>
			dig = *s - '0';
  8014de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e2:	0f b6 00             	movzbl (%rax),%eax
  8014e5:	0f be c0             	movsbl %al,%eax
  8014e8:	83 e8 30             	sub    $0x30,%eax
  8014eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8014ee:	eb 4e                	jmp    80153e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8014f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f4:	0f b6 00             	movzbl (%rax),%eax
  8014f7:	3c 60                	cmp    $0x60,%al
  8014f9:	7e 1d                	jle    801518 <strtol+0x118>
  8014fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ff:	0f b6 00             	movzbl (%rax),%eax
  801502:	3c 7a                	cmp    $0x7a,%al
  801504:	7f 12                	jg     801518 <strtol+0x118>
			dig = *s - 'a' + 10;
  801506:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80150a:	0f b6 00             	movzbl (%rax),%eax
  80150d:	0f be c0             	movsbl %al,%eax
  801510:	83 e8 57             	sub    $0x57,%eax
  801513:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801516:	eb 26                	jmp    80153e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801518:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151c:	0f b6 00             	movzbl (%rax),%eax
  80151f:	3c 40                	cmp    $0x40,%al
  801521:	7e 48                	jle    80156b <strtol+0x16b>
  801523:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801527:	0f b6 00             	movzbl (%rax),%eax
  80152a:	3c 5a                	cmp    $0x5a,%al
  80152c:	7f 3d                	jg     80156b <strtol+0x16b>
			dig = *s - 'A' + 10;
  80152e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801532:	0f b6 00             	movzbl (%rax),%eax
  801535:	0f be c0             	movsbl %al,%eax
  801538:	83 e8 37             	sub    $0x37,%eax
  80153b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80153e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801541:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801544:	7c 02                	jl     801548 <strtol+0x148>
			break;
  801546:	eb 23                	jmp    80156b <strtol+0x16b>
		s++, val = (val * base) + dig;
  801548:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80154d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801550:	48 98                	cltq   
  801552:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801557:	48 89 c2             	mov    %rax,%rdx
  80155a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80155d:	48 98                	cltq   
  80155f:	48 01 d0             	add    %rdx,%rax
  801562:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801566:	e9 5d ff ff ff       	jmpq   8014c8 <strtol+0xc8>

	if (endptr)
  80156b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801570:	74 0b                	je     80157d <strtol+0x17d>
		*endptr = (char *) s;
  801572:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801576:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80157a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80157d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801581:	74 09                	je     80158c <strtol+0x18c>
  801583:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801587:	48 f7 d8             	neg    %rax
  80158a:	eb 04                	jmp    801590 <strtol+0x190>
  80158c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801590:	c9                   	leaveq 
  801591:	c3                   	retq   

0000000000801592 <strstr>:

char * strstr(const char *in, const char *str)
{
  801592:	55                   	push   %rbp
  801593:	48 89 e5             	mov    %rsp,%rbp
  801596:	48 83 ec 30          	sub    $0x30,%rsp
  80159a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80159e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015aa:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015ae:	0f b6 00             	movzbl (%rax),%eax
  8015b1:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015b4:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015b8:	75 06                	jne    8015c0 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015be:	eb 6b                	jmp    80162b <strstr+0x99>

	len = strlen(str);
  8015c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015c4:	48 89 c7             	mov    %rax,%rdi
  8015c7:	48 b8 68 0e 80 00 00 	movabs $0x800e68,%rax
  8015ce:	00 00 00 
  8015d1:	ff d0                	callq  *%rax
  8015d3:	48 98                	cltq   
  8015d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015e5:	0f b6 00             	movzbl (%rax),%eax
  8015e8:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8015eb:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8015ef:	75 07                	jne    8015f8 <strstr+0x66>
				return (char *) 0;
  8015f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f6:	eb 33                	jmp    80162b <strstr+0x99>
		} while (sc != c);
  8015f8:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8015fc:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8015ff:	75 d8                	jne    8015d9 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801601:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801605:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	48 89 ce             	mov    %rcx,%rsi
  801610:	48 89 c7             	mov    %rax,%rdi
  801613:	48 b8 89 10 80 00 00 	movabs $0x801089,%rax
  80161a:	00 00 00 
  80161d:	ff d0                	callq  *%rax
  80161f:	85 c0                	test   %eax,%eax
  801621:	75 b6                	jne    8015d9 <strstr+0x47>

	return (char *) (in - 1);
  801623:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801627:	48 83 e8 01          	sub    $0x1,%rax
}
  80162b:	c9                   	leaveq 
  80162c:	c3                   	retq   

000000000080162d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80162d:	55                   	push   %rbp
  80162e:	48 89 e5             	mov    %rsp,%rbp
  801631:	53                   	push   %rbx
  801632:	48 83 ec 48          	sub    $0x48,%rsp
  801636:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801639:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80163c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801640:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801644:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801648:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  80164c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80164f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801653:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801657:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80165b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80165f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801663:	4c 89 c3             	mov    %r8,%rbx
  801666:	cd 30                	int    $0x30
  801668:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  80166c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801670:	74 3e                	je     8016b0 <syscall+0x83>
  801672:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801677:	7e 37                	jle    8016b0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801679:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80167d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801680:	49 89 d0             	mov    %rdx,%r8
  801683:	89 c1                	mov    %eax,%ecx
  801685:	48 ba 48 41 80 00 00 	movabs $0x804148,%rdx
  80168c:	00 00 00 
  80168f:	be 4a 00 00 00       	mov    $0x4a,%esi
  801694:	48 bf 65 41 80 00 00 	movabs $0x804165,%rdi
  80169b:	00 00 00 
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	49 b9 6d 39 80 00 00 	movabs $0x80396d,%r9
  8016aa:	00 00 00 
  8016ad:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8016b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016b4:	48 83 c4 48          	add    $0x48,%rsp
  8016b8:	5b                   	pop    %rbx
  8016b9:	5d                   	pop    %rbp
  8016ba:	c3                   	retq   

00000000008016bb <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016bb:	55                   	push   %rbp
  8016bc:	48 89 e5             	mov    %rsp,%rbp
  8016bf:	48 83 ec 20          	sub    $0x20,%rsp
  8016c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016c7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016d3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016da:	00 
  8016db:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016e1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8016e7:	48 89 d1             	mov    %rdx,%rcx
  8016ea:	48 89 c2             	mov    %rax,%rdx
  8016ed:	be 00 00 00 00       	mov    $0x0,%esi
  8016f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f7:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8016fe:	00 00 00 
  801701:	ff d0                	callq  *%rax
}
  801703:	c9                   	leaveq 
  801704:	c3                   	retq   

0000000000801705 <sys_cgetc>:

int
sys_cgetc(void)
{
  801705:	55                   	push   %rbp
  801706:	48 89 e5             	mov    %rsp,%rbp
  801709:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80170d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801714:	00 
  801715:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80171b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801721:	b9 00 00 00 00       	mov    $0x0,%ecx
  801726:	ba 00 00 00 00       	mov    $0x0,%edx
  80172b:	be 00 00 00 00       	mov    $0x0,%esi
  801730:	bf 01 00 00 00       	mov    $0x1,%edi
  801735:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  80173c:	00 00 00 
  80173f:	ff d0                	callq  *%rax
}
  801741:	c9                   	leaveq 
  801742:	c3                   	retq   

0000000000801743 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801743:	55                   	push   %rbp
  801744:	48 89 e5             	mov    %rsp,%rbp
  801747:	48 83 ec 10          	sub    $0x10,%rsp
  80174b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80174e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801751:	48 98                	cltq   
  801753:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80175a:	00 
  80175b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801761:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801767:	b9 00 00 00 00       	mov    $0x0,%ecx
  80176c:	48 89 c2             	mov    %rax,%rdx
  80176f:	be 01 00 00 00       	mov    $0x1,%esi
  801774:	bf 03 00 00 00       	mov    $0x3,%edi
  801779:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801780:	00 00 00 
  801783:	ff d0                	callq  *%rax
}
  801785:	c9                   	leaveq 
  801786:	c3                   	retq   

0000000000801787 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801787:	55                   	push   %rbp
  801788:	48 89 e5             	mov    %rsp,%rbp
  80178b:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80178f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801796:	00 
  801797:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80179d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ad:	be 00 00 00 00       	mov    $0x0,%esi
  8017b2:	bf 02 00 00 00       	mov    $0x2,%edi
  8017b7:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8017be:	00 00 00 
  8017c1:	ff d0                	callq  *%rax
}
  8017c3:	c9                   	leaveq 
  8017c4:	c3                   	retq   

00000000008017c5 <sys_yield>:

void
sys_yield(void)
{
  8017c5:	55                   	push   %rbp
  8017c6:	48 89 e5             	mov    %rsp,%rbp
  8017c9:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017cd:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017d4:	00 
  8017d5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017db:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017eb:	be 00 00 00 00       	mov    $0x0,%esi
  8017f0:	bf 0b 00 00 00       	mov    $0xb,%edi
  8017f5:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8017fc:	00 00 00 
  8017ff:	ff d0                	callq  *%rax
}
  801801:	c9                   	leaveq 
  801802:	c3                   	retq   

0000000000801803 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801803:	55                   	push   %rbp
  801804:	48 89 e5             	mov    %rsp,%rbp
  801807:	48 83 ec 20          	sub    $0x20,%rsp
  80180b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80180e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801812:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801815:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801818:	48 63 c8             	movslq %eax,%rcx
  80181b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801822:	48 98                	cltq   
  801824:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80182b:	00 
  80182c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801832:	49 89 c8             	mov    %rcx,%r8
  801835:	48 89 d1             	mov    %rdx,%rcx
  801838:	48 89 c2             	mov    %rax,%rdx
  80183b:	be 01 00 00 00       	mov    $0x1,%esi
  801840:	bf 04 00 00 00       	mov    $0x4,%edi
  801845:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  80184c:	00 00 00 
  80184f:	ff d0                	callq  *%rax
}
  801851:	c9                   	leaveq 
  801852:	c3                   	retq   

0000000000801853 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801853:	55                   	push   %rbp
  801854:	48 89 e5             	mov    %rsp,%rbp
  801857:	48 83 ec 30          	sub    $0x30,%rsp
  80185b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80185e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801862:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801865:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801869:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80186d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801870:	48 63 c8             	movslq %eax,%rcx
  801873:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801877:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80187a:	48 63 f0             	movslq %eax,%rsi
  80187d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801884:	48 98                	cltq   
  801886:	48 89 0c 24          	mov    %rcx,(%rsp)
  80188a:	49 89 f9             	mov    %rdi,%r9
  80188d:	49 89 f0             	mov    %rsi,%r8
  801890:	48 89 d1             	mov    %rdx,%rcx
  801893:	48 89 c2             	mov    %rax,%rdx
  801896:	be 01 00 00 00       	mov    $0x1,%esi
  80189b:	bf 05 00 00 00       	mov    $0x5,%edi
  8018a0:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8018a7:	00 00 00 
  8018aa:	ff d0                	callq  *%rax
}
  8018ac:	c9                   	leaveq 
  8018ad:	c3                   	retq   

00000000008018ae <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018ae:	55                   	push   %rbp
  8018af:	48 89 e5             	mov    %rsp,%rbp
  8018b2:	48 83 ec 20          	sub    $0x20,%rsp
  8018b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018c4:	48 98                	cltq   
  8018c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018cd:	00 
  8018ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018da:	48 89 d1             	mov    %rdx,%rcx
  8018dd:	48 89 c2             	mov    %rax,%rdx
  8018e0:	be 01 00 00 00       	mov    $0x1,%esi
  8018e5:	bf 06 00 00 00       	mov    $0x6,%edi
  8018ea:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8018f1:	00 00 00 
  8018f4:	ff d0                	callq  *%rax
}
  8018f6:	c9                   	leaveq 
  8018f7:	c3                   	retq   

00000000008018f8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018f8:	55                   	push   %rbp
  8018f9:	48 89 e5             	mov    %rsp,%rbp
  8018fc:	48 83 ec 10          	sub    $0x10,%rsp
  801900:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801903:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801906:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801909:	48 63 d0             	movslq %eax,%rdx
  80190c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80190f:	48 98                	cltq   
  801911:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801918:	00 
  801919:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801925:	48 89 d1             	mov    %rdx,%rcx
  801928:	48 89 c2             	mov    %rax,%rdx
  80192b:	be 01 00 00 00       	mov    $0x1,%esi
  801930:	bf 08 00 00 00       	mov    $0x8,%edi
  801935:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  80193c:	00 00 00 
  80193f:	ff d0                	callq  *%rax
}
  801941:	c9                   	leaveq 
  801942:	c3                   	retq   

0000000000801943 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801943:	55                   	push   %rbp
  801944:	48 89 e5             	mov    %rsp,%rbp
  801947:	48 83 ec 20          	sub    $0x20,%rsp
  80194b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80194e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801952:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801956:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801959:	48 98                	cltq   
  80195b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801962:	00 
  801963:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801969:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80196f:	48 89 d1             	mov    %rdx,%rcx
  801972:	48 89 c2             	mov    %rax,%rdx
  801975:	be 01 00 00 00       	mov    $0x1,%esi
  80197a:	bf 09 00 00 00       	mov    $0x9,%edi
  80197f:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801986:	00 00 00 
  801989:	ff d0                	callq  *%rax
}
  80198b:	c9                   	leaveq 
  80198c:	c3                   	retq   

000000000080198d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80198d:	55                   	push   %rbp
  80198e:	48 89 e5             	mov    %rsp,%rbp
  801991:	48 83 ec 20          	sub    $0x20,%rsp
  801995:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801998:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80199c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a3:	48 98                	cltq   
  8019a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ac:	00 
  8019ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b9:	48 89 d1             	mov    %rdx,%rcx
  8019bc:	48 89 c2             	mov    %rax,%rdx
  8019bf:	be 01 00 00 00       	mov    $0x1,%esi
  8019c4:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019c9:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  8019d0:	00 00 00 
  8019d3:	ff d0                	callq  *%rax
}
  8019d5:	c9                   	leaveq 
  8019d6:	c3                   	retq   

00000000008019d7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019d7:	55                   	push   %rbp
  8019d8:	48 89 e5             	mov    %rsp,%rbp
  8019db:	48 83 ec 20          	sub    $0x20,%rsp
  8019df:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019ea:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8019ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019f0:	48 63 f0             	movslq %eax,%rsi
  8019f3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8019f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fa:	48 98                	cltq   
  8019fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a00:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a07:	00 
  801a08:	49 89 f1             	mov    %rsi,%r9
  801a0b:	49 89 c8             	mov    %rcx,%r8
  801a0e:	48 89 d1             	mov    %rdx,%rcx
  801a11:	48 89 c2             	mov    %rax,%rdx
  801a14:	be 00 00 00 00       	mov    $0x0,%esi
  801a19:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a1e:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801a25:	00 00 00 
  801a28:	ff d0                	callq  *%rax
}
  801a2a:	c9                   	leaveq 
  801a2b:	c3                   	retq   

0000000000801a2c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a2c:	55                   	push   %rbp
  801a2d:	48 89 e5             	mov    %rsp,%rbp
  801a30:	48 83 ec 10          	sub    $0x10,%rsp
  801a34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a3c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a43:	00 
  801a44:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a50:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a55:	48 89 c2             	mov    %rax,%rdx
  801a58:	be 01 00 00 00       	mov    $0x1,%esi
  801a5d:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a62:	48 b8 2d 16 80 00 00 	movabs $0x80162d,%rax
  801a69:	00 00 00 
  801a6c:	ff d0                	callq  *%rax
}
  801a6e:	c9                   	leaveq 
  801a6f:	c3                   	retq   

0000000000801a70 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a70:	55                   	push   %rbp
  801a71:	48 89 e5             	mov    %rsp,%rbp
  801a74:	53                   	push   %rbx
  801a75:	48 83 ec 48          	sub    $0x48,%rsp
  801a79:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a7d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a81:	48 8b 00             	mov    (%rax),%rax
  801a84:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801a88:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a8c:	48 8b 40 08          	mov    0x8(%rax),%rax
  801a90:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a97:	48 c1 e8 0c          	shr    $0xc,%rax
  801a9b:	48 89 c2             	mov    %rax,%rdx
  801a9e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801aa5:	01 00 00 
  801aa8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801aac:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801ab0:	48 b8 87 17 80 00 00 	movabs $0x801787,%rax
  801ab7:	00 00 00 
  801aba:	ff d0                	callq  *%rax
  801abc:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801abf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ac3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801ac7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801acb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801ad1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801ad5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ad8:	83 e0 02             	and    $0x2,%eax
  801adb:	85 c0                	test   %eax,%eax
  801add:	0f 84 8d 00 00 00    	je     801b70 <pgfault+0x100>
  801ae3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae7:	25 00 08 00 00       	and    $0x800,%eax
  801aec:	48 85 c0             	test   %rax,%rax
  801aef:	74 7f                	je     801b70 <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801af1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801af4:	ba 07 00 00 00       	mov    $0x7,%edx
  801af9:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801afe:	89 c7                	mov    %eax,%edi
  801b00:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  801b07:	00 00 00 
  801b0a:	ff d0                	callq  *%rax
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	75 60                	jne    801b70 <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801b10:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801b14:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b19:	48 89 c6             	mov    %rax,%rsi
  801b1c:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b21:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  801b28:	00 00 00 
  801b2b:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801b2d:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801b31:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801b34:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b37:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b3d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b42:	89 c7                	mov    %eax,%edi
  801b44:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  801b4b:	00 00 00 
  801b4e:	ff d0                	callq  *%rax
  801b50:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801b52:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b55:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b5a:	89 c7                	mov    %eax,%edi
  801b5c:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  801b63:	00 00 00 
  801b66:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801b68:	09 d8                	or     %ebx,%eax
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	75 02                	jne    801b70 <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801b6e:	eb 2a                	jmp    801b9a <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801b70:	48 ba 73 41 80 00 00 	movabs $0x804173,%rdx
  801b77:	00 00 00 
  801b7a:	be 26 00 00 00       	mov    $0x26,%esi
  801b7f:	48 bf 8f 41 80 00 00 	movabs $0x80418f,%rdi
  801b86:	00 00 00 
  801b89:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8e:	48 b9 6d 39 80 00 00 	movabs $0x80396d,%rcx
  801b95:	00 00 00 
  801b98:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801b9a:	48 83 c4 48          	add    $0x48,%rsp
  801b9e:	5b                   	pop    %rbx
  801b9f:	5d                   	pop    %rbp
  801ba0:	c3                   	retq   

0000000000801ba1 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801ba1:	55                   	push   %rbp
  801ba2:	48 89 e5             	mov    %rsp,%rbp
  801ba5:	53                   	push   %rbx
  801ba6:	48 83 ec 38          	sub    $0x38,%rsp
  801baa:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801bad:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801bb0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bb7:	01 00 00 
  801bba:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801bbd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bc1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801bc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bc9:	25 07 0e 00 00       	and    $0xe07,%eax
  801bce:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801bd1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801bd4:	48 c1 e0 0c          	shl    $0xc,%rax
  801bd8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801bdc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bdf:	25 00 04 00 00       	and    $0x400,%eax
  801be4:	85 c0                	test   %eax,%eax
  801be6:	74 30                	je     801c18 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801be8:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801beb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801bef:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801bf2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801bf6:	41 89 f0             	mov    %esi,%r8d
  801bf9:	48 89 c6             	mov    %rax,%rsi
  801bfc:	bf 00 00 00 00       	mov    $0x0,%edi
  801c01:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  801c08:	00 00 00 
  801c0b:	ff d0                	callq  *%rax
  801c0d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801c10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c13:	e9 a4 00 00 00       	jmpq   801cbc <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801c18:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c1b:	83 e0 02             	and    $0x2,%eax
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	75 0c                	jne    801c2e <duppage+0x8d>
  801c22:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c25:	25 00 08 00 00       	and    $0x800,%eax
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	74 63                	je     801c91 <duppage+0xf0>
		perm &= ~PTE_W;
  801c2e:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  801c32:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  801c39:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801c3c:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c40:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801c43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c47:	41 89 f0             	mov    %esi,%r8d
  801c4a:	48 89 c6             	mov    %rax,%rsi
  801c4d:	bf 00 00 00 00       	mov    $0x0,%edi
  801c52:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  801c59:	00 00 00 
  801c5c:	ff d0                	callq  *%rax
  801c5e:	89 c3                	mov    %eax,%ebx
  801c60:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801c63:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801c67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c6b:	41 89 c8             	mov    %ecx,%r8d
  801c6e:	48 89 d1             	mov    %rdx,%rcx
  801c71:	ba 00 00 00 00       	mov    $0x0,%edx
  801c76:	48 89 c6             	mov    %rax,%rsi
  801c79:	bf 00 00 00 00       	mov    $0x0,%edi
  801c7e:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  801c85:	00 00 00 
  801c88:	ff d0                	callq  *%rax
  801c8a:	09 d8                	or     %ebx,%eax
  801c8c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801c8f:	eb 28                	jmp    801cb9 <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  801c91:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801c94:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c98:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801c9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c9f:	41 89 f0             	mov    %esi,%r8d
  801ca2:	48 89 c6             	mov    %rax,%rsi
  801ca5:	bf 00 00 00 00       	mov    $0x0,%edi
  801caa:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  801cb1:	00 00 00 
  801cb4:	ff d0                	callq  *%rax
  801cb6:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  801cb9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801cbc:	48 83 c4 38          	add    $0x38,%rsp
  801cc0:	5b                   	pop    %rbx
  801cc1:	5d                   	pop    %rbp
  801cc2:	c3                   	retq   

0000000000801cc3 <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  801cc3:	55                   	push   %rbp
  801cc4:	48 89 e5             	mov    %rsp,%rbp
  801cc7:	53                   	push   %rbx
  801cc8:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801ccc:	48 bf 70 1a 80 00 00 	movabs $0x801a70,%rdi
  801cd3:	00 00 00 
  801cd6:	48 b8 81 3a 80 00 00 	movabs $0x803a81,%rax
  801cdd:	00 00 00 
  801ce0:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801ce2:	b8 07 00 00 00       	mov    $0x7,%eax
  801ce7:	cd 30                	int    $0x30
  801ce9:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801cec:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  801cef:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  801cf2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801cf6:	79 30                	jns    801d28 <fork+0x65>
  801cf8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801cfb:	89 c1                	mov    %eax,%ecx
  801cfd:	48 ba 9a 41 80 00 00 	movabs $0x80419a,%rdx
  801d04:	00 00 00 
  801d07:	be 72 00 00 00       	mov    $0x72,%esi
  801d0c:	48 bf 8f 41 80 00 00 	movabs $0x80418f,%rdi
  801d13:	00 00 00 
  801d16:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1b:	49 b8 6d 39 80 00 00 	movabs $0x80396d,%r8
  801d22:	00 00 00 
  801d25:	41 ff d0             	callq  *%r8
	if(cid == 0){
  801d28:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d2c:	75 46                	jne    801d74 <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  801d2e:	48 b8 87 17 80 00 00 	movabs $0x801787,%rax
  801d35:	00 00 00 
  801d38:	ff d0                	callq  *%rax
  801d3a:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d3f:	48 63 d0             	movslq %eax,%rdx
  801d42:	48 89 d0             	mov    %rdx,%rax
  801d45:	48 c1 e0 03          	shl    $0x3,%rax
  801d49:	48 01 d0             	add    %rdx,%rax
  801d4c:	48 c1 e0 05          	shl    $0x5,%rax
  801d50:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801d57:	00 00 00 
  801d5a:	48 01 c2             	add    %rax,%rdx
  801d5d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801d64:	00 00 00 
  801d67:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6f:	e9 12 02 00 00       	jmpq   801f86 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801d74:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d77:	ba 07 00 00 00       	mov    $0x7,%edx
  801d7c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801d81:	89 c7                	mov    %eax,%edi
  801d83:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  801d8a:	00 00 00 
  801d8d:	ff d0                	callq  *%rax
  801d8f:	89 45 c8             	mov    %eax,-0x38(%rbp)
  801d92:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  801d96:	79 30                	jns    801dc8 <fork+0x105>
		panic("fork failed: %e\n", result);
  801d98:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801d9b:	89 c1                	mov    %eax,%ecx
  801d9d:	48 ba 9a 41 80 00 00 	movabs $0x80419a,%rdx
  801da4:	00 00 00 
  801da7:	be 79 00 00 00       	mov    $0x79,%esi
  801dac:	48 bf 8f 41 80 00 00 	movabs $0x80418f,%rdi
  801db3:	00 00 00 
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbb:	49 b8 6d 39 80 00 00 	movabs $0x80396d,%r8
  801dc2:	00 00 00 
  801dc5:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  801dc8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801dcf:	00 
  801dd0:	e9 40 01 00 00       	jmpq   801f15 <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  801dd5:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801ddc:	01 00 00 
  801ddf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801de3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de7:	83 e0 01             	and    $0x1,%eax
  801dea:	48 85 c0             	test   %rax,%rax
  801ded:	0f 84 1d 01 00 00    	je     801f10 <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  801df3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df7:	48 c1 e0 09          	shl    $0x9,%rax
  801dfb:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  801dff:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  801e06:	00 
  801e07:	e9 f6 00 00 00       	jmpq   801f02 <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  801e0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e10:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801e14:	48 01 c2             	add    %rax,%rdx
  801e17:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801e1e:	01 00 00 
  801e21:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e25:	83 e0 01             	and    $0x1,%eax
  801e28:	48 85 c0             	test   %rax,%rax
  801e2b:	0f 84 cc 00 00 00    	je     801efd <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  801e31:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e35:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801e39:	48 01 d0             	add    %rdx,%rax
  801e3c:	48 c1 e0 09          	shl    $0x9,%rax
  801e40:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  801e44:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  801e4b:	00 
  801e4c:	e9 9e 00 00 00       	jmpq   801eef <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  801e51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e55:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801e59:	48 01 c2             	add    %rax,%rdx
  801e5c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e63:	01 00 00 
  801e66:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e6a:	83 e0 01             	and    $0x1,%eax
  801e6d:	48 85 c0             	test   %rax,%rax
  801e70:	74 78                	je     801eea <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  801e72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e76:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801e7a:	48 01 d0             	add    %rdx,%rax
  801e7d:	48 c1 e0 09          	shl    $0x9,%rax
  801e81:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  801e85:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  801e8c:	00 
  801e8d:	eb 51                	jmp    801ee0 <fork+0x21d>
								entry = base_pde + pte;
  801e8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e93:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801e97:	48 01 d0             	add    %rdx,%rax
  801e9a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  801e9e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ea5:	01 00 00 
  801ea8:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801eac:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801eb0:	83 e0 01             	and    $0x1,%eax
  801eb3:	48 85 c0             	test   %rax,%rax
  801eb6:	74 23                	je     801edb <fork+0x218>
  801eb8:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  801ebf:	00 
  801ec0:	74 19                	je     801edb <fork+0x218>
									duppage(cid, entry);
  801ec2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ec6:	89 c2                	mov    %eax,%edx
  801ec8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ecb:	89 d6                	mov    %edx,%esi
  801ecd:	89 c7                	mov    %eax,%edi
  801ecf:	48 b8 a1 1b 80 00 00 	movabs $0x801ba1,%rax
  801ed6:	00 00 00 
  801ed9:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  801edb:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  801ee0:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  801ee7:	00 
  801ee8:	76 a5                	jbe    801e8f <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  801eea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801eef:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  801ef6:	00 
  801ef7:	0f 86 54 ff ff ff    	jbe    801e51 <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  801efd:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801f02:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  801f09:	00 
  801f0a:	0f 86 fc fe ff ff    	jbe    801e0c <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  801f10:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801f15:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801f1a:	0f 84 b5 fe ff ff    	je     801dd5 <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  801f20:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f23:	48 be 16 3b 80 00 00 	movabs $0x803b16,%rsi
  801f2a:	00 00 00 
  801f2d:	89 c7                	mov    %eax,%edi
  801f2f:	48 b8 8d 19 80 00 00 	movabs $0x80198d,%rax
  801f36:	00 00 00 
  801f39:	ff d0                	callq  *%rax
  801f3b:	89 c3                	mov    %eax,%ebx
  801f3d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f40:	be 02 00 00 00       	mov    $0x2,%esi
  801f45:	89 c7                	mov    %eax,%edi
  801f47:	48 b8 f8 18 80 00 00 	movabs $0x8018f8,%rax
  801f4e:	00 00 00 
  801f51:	ff d0                	callq  *%rax
  801f53:	09 d8                	or     %ebx,%eax
  801f55:	85 c0                	test   %eax,%eax
  801f57:	74 2a                	je     801f83 <fork+0x2c0>
		panic("fork failed\n");
  801f59:	48 ba ab 41 80 00 00 	movabs $0x8041ab,%rdx
  801f60:	00 00 00 
  801f63:	be 92 00 00 00       	mov    $0x92,%esi
  801f68:	48 bf 8f 41 80 00 00 	movabs $0x80418f,%rdi
  801f6f:	00 00 00 
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
  801f77:	48 b9 6d 39 80 00 00 	movabs $0x80396d,%rcx
  801f7e:	00 00 00 
  801f81:	ff d1                	callq  *%rcx
	return cid;
  801f83:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  801f86:	48 83 c4 58          	add    $0x58,%rsp
  801f8a:	5b                   	pop    %rbx
  801f8b:	5d                   	pop    %rbp
  801f8c:	c3                   	retq   

0000000000801f8d <sfork>:


// Challenge!
int
sfork(void)
{
  801f8d:	55                   	push   %rbp
  801f8e:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  801f91:	48 ba b8 41 80 00 00 	movabs $0x8041b8,%rdx
  801f98:	00 00 00 
  801f9b:	be 9c 00 00 00       	mov    $0x9c,%esi
  801fa0:	48 bf 8f 41 80 00 00 	movabs $0x80418f,%rdi
  801fa7:	00 00 00 
  801faa:	b8 00 00 00 00       	mov    $0x0,%eax
  801faf:	48 b9 6d 39 80 00 00 	movabs $0x80396d,%rcx
  801fb6:	00 00 00 
  801fb9:	ff d1                	callq  *%rcx

0000000000801fbb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fbb:	55                   	push   %rbp
  801fbc:	48 89 e5             	mov    %rsp,%rbp
  801fbf:	48 83 ec 30          	sub    $0x30,%rsp
  801fc3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801fc7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fcb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  801fcf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801fd4:	74 18                	je     801fee <ipc_recv+0x33>
  801fd6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fda:	48 89 c7             	mov    %rax,%rdi
  801fdd:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  801fe4:	00 00 00 
  801fe7:	ff d0                	callq  *%rax
  801fe9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fec:	eb 19                	jmp    802007 <ipc_recv+0x4c>
  801fee:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  801ff5:	00 00 00 
  801ff8:	48 b8 2c 1a 80 00 00 	movabs $0x801a2c,%rax
  801fff:	00 00 00 
  802002:	ff d0                	callq  *%rax
  802004:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  802007:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80200c:	74 26                	je     802034 <ipc_recv+0x79>
  80200e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802012:	75 15                	jne    802029 <ipc_recv+0x6e>
  802014:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80201b:	00 00 00 
  80201e:	48 8b 00             	mov    (%rax),%rax
  802021:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  802027:	eb 05                	jmp    80202e <ipc_recv+0x73>
  802029:	b8 00 00 00 00       	mov    $0x0,%eax
  80202e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802032:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  802034:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802039:	74 26                	je     802061 <ipc_recv+0xa6>
  80203b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80203f:	75 15                	jne    802056 <ipc_recv+0x9b>
  802041:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802048:	00 00 00 
  80204b:	48 8b 00             	mov    (%rax),%rax
  80204e:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  802054:	eb 05                	jmp    80205b <ipc_recv+0xa0>
  802056:	b8 00 00 00 00       	mov    $0x0,%eax
  80205b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80205f:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  802061:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802065:	75 15                	jne    80207c <ipc_recv+0xc1>
  802067:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80206e:	00 00 00 
  802071:	48 8b 00             	mov    (%rax),%rax
  802074:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  80207a:	eb 03                	jmp    80207f <ipc_recv+0xc4>
  80207c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80207f:	c9                   	leaveq 
  802080:	c3                   	retq   

0000000000802081 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802081:	55                   	push   %rbp
  802082:	48 89 e5             	mov    %rsp,%rbp
  802085:	48 83 ec 30          	sub    $0x30,%rsp
  802089:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80208c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80208f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802093:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  802096:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  80209d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8020a2:	75 10                	jne    8020b4 <ipc_send+0x33>
  8020a4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8020ab:	00 00 00 
  8020ae:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  8020b2:	eb 62                	jmp    802116 <ipc_send+0x95>
  8020b4:	eb 60                	jmp    802116 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  8020b6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8020ba:	74 30                	je     8020ec <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  8020bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020bf:	89 c1                	mov    %eax,%ecx
  8020c1:	48 ba ce 41 80 00 00 	movabs $0x8041ce,%rdx
  8020c8:	00 00 00 
  8020cb:	be 33 00 00 00       	mov    $0x33,%esi
  8020d0:	48 bf ea 41 80 00 00 	movabs $0x8041ea,%rdi
  8020d7:	00 00 00 
  8020da:	b8 00 00 00 00       	mov    $0x0,%eax
  8020df:	49 b8 6d 39 80 00 00 	movabs $0x80396d,%r8
  8020e6:	00 00 00 
  8020e9:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  8020ec:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8020ef:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8020f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8020f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020f9:	89 c7                	mov    %eax,%edi
  8020fb:	48 b8 d7 19 80 00 00 	movabs $0x8019d7,%rax
  802102:	00 00 00 
  802105:	ff d0                	callq  *%rax
  802107:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  80210a:	48 b8 c5 17 80 00 00 	movabs $0x8017c5,%rax
  802111:	00 00 00 
  802114:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  802116:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80211a:	75 9a                	jne    8020b6 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  80211c:	c9                   	leaveq 
  80211d:	c3                   	retq   

000000000080211e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80211e:	55                   	push   %rbp
  80211f:	48 89 e5             	mov    %rsp,%rbp
  802122:	48 83 ec 14          	sub    $0x14,%rsp
  802126:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802130:	eb 5e                	jmp    802190 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  802132:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802139:	00 00 00 
  80213c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213f:	48 63 d0             	movslq %eax,%rdx
  802142:	48 89 d0             	mov    %rdx,%rax
  802145:	48 c1 e0 03          	shl    $0x3,%rax
  802149:	48 01 d0             	add    %rdx,%rax
  80214c:	48 c1 e0 05          	shl    $0x5,%rax
  802150:	48 01 c8             	add    %rcx,%rax
  802153:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802159:	8b 00                	mov    (%rax),%eax
  80215b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80215e:	75 2c                	jne    80218c <ipc_find_env+0x6e>
			return envs[i].env_id;
  802160:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802167:	00 00 00 
  80216a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80216d:	48 63 d0             	movslq %eax,%rdx
  802170:	48 89 d0             	mov    %rdx,%rax
  802173:	48 c1 e0 03          	shl    $0x3,%rax
  802177:	48 01 d0             	add    %rdx,%rax
  80217a:	48 c1 e0 05          	shl    $0x5,%rax
  80217e:	48 01 c8             	add    %rcx,%rax
  802181:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802187:	8b 40 08             	mov    0x8(%rax),%eax
  80218a:	eb 12                	jmp    80219e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80218c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802190:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802197:	7e 99                	jle    802132 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802199:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80219e:	c9                   	leaveq 
  80219f:	c3                   	retq   

00000000008021a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8021a0:	55                   	push   %rbp
  8021a1:	48 89 e5             	mov    %rsp,%rbp
  8021a4:	48 83 ec 08          	sub    $0x8,%rsp
  8021a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8021ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021b0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8021b7:	ff ff ff 
  8021ba:	48 01 d0             	add    %rdx,%rax
  8021bd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8021c1:	c9                   	leaveq 
  8021c2:	c3                   	retq   

00000000008021c3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8021c3:	55                   	push   %rbp
  8021c4:	48 89 e5             	mov    %rsp,%rbp
  8021c7:	48 83 ec 08          	sub    $0x8,%rsp
  8021cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8021cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021d3:	48 89 c7             	mov    %rax,%rdi
  8021d6:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  8021dd:	00 00 00 
  8021e0:	ff d0                	callq  *%rax
  8021e2:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8021e8:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8021ec:	c9                   	leaveq 
  8021ed:	c3                   	retq   

00000000008021ee <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021ee:	55                   	push   %rbp
  8021ef:	48 89 e5             	mov    %rsp,%rbp
  8021f2:	48 83 ec 18          	sub    $0x18,%rsp
  8021f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802201:	eb 6b                	jmp    80226e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802203:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802206:	48 98                	cltq   
  802208:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80220e:	48 c1 e0 0c          	shl    $0xc,%rax
  802212:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802216:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80221a:	48 c1 e8 15          	shr    $0x15,%rax
  80221e:	48 89 c2             	mov    %rax,%rdx
  802221:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802228:	01 00 00 
  80222b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80222f:	83 e0 01             	and    $0x1,%eax
  802232:	48 85 c0             	test   %rax,%rax
  802235:	74 21                	je     802258 <fd_alloc+0x6a>
  802237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80223b:	48 c1 e8 0c          	shr    $0xc,%rax
  80223f:	48 89 c2             	mov    %rax,%rdx
  802242:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802249:	01 00 00 
  80224c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802250:	83 e0 01             	and    $0x1,%eax
  802253:	48 85 c0             	test   %rax,%rax
  802256:	75 12                	jne    80226a <fd_alloc+0x7c>
			*fd_store = fd;
  802258:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802260:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
  802268:	eb 1a                	jmp    802284 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80226a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80226e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802272:	7e 8f                	jle    802203 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802278:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80227f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802284:	c9                   	leaveq 
  802285:	c3                   	retq   

0000000000802286 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802286:	55                   	push   %rbp
  802287:	48 89 e5             	mov    %rsp,%rbp
  80228a:	48 83 ec 20          	sub    $0x20,%rsp
  80228e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802291:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802295:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802299:	78 06                	js     8022a1 <fd_lookup+0x1b>
  80229b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80229f:	7e 07                	jle    8022a8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022a6:	eb 6c                	jmp    802314 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8022a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022ab:	48 98                	cltq   
  8022ad:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8022b3:	48 c1 e0 0c          	shl    $0xc,%rax
  8022b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8022bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022bf:	48 c1 e8 15          	shr    $0x15,%rax
  8022c3:	48 89 c2             	mov    %rax,%rdx
  8022c6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022cd:	01 00 00 
  8022d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d4:	83 e0 01             	and    $0x1,%eax
  8022d7:	48 85 c0             	test   %rax,%rax
  8022da:	74 21                	je     8022fd <fd_lookup+0x77>
  8022dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e0:	48 c1 e8 0c          	shr    $0xc,%rax
  8022e4:	48 89 c2             	mov    %rax,%rdx
  8022e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ee:	01 00 00 
  8022f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f5:	83 e0 01             	and    $0x1,%eax
  8022f8:	48 85 c0             	test   %rax,%rax
  8022fb:	75 07                	jne    802304 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802302:	eb 10                	jmp    802314 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802304:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802308:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80230c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80230f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802314:	c9                   	leaveq 
  802315:	c3                   	retq   

0000000000802316 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802316:	55                   	push   %rbp
  802317:	48 89 e5             	mov    %rsp,%rbp
  80231a:	48 83 ec 30          	sub    $0x30,%rsp
  80231e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802322:	89 f0                	mov    %esi,%eax
  802324:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802327:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80232b:	48 89 c7             	mov    %rax,%rdi
  80232e:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  802335:	00 00 00 
  802338:	ff d0                	callq  *%rax
  80233a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80233e:	48 89 d6             	mov    %rdx,%rsi
  802341:	89 c7                	mov    %eax,%edi
  802343:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  80234a:	00 00 00 
  80234d:	ff d0                	callq  *%rax
  80234f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802352:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802356:	78 0a                	js     802362 <fd_close+0x4c>
	    || fd != fd2)
  802358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802360:	74 12                	je     802374 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802362:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802366:	74 05                	je     80236d <fd_close+0x57>
  802368:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236b:	eb 05                	jmp    802372 <fd_close+0x5c>
  80236d:	b8 00 00 00 00       	mov    $0x0,%eax
  802372:	eb 69                	jmp    8023dd <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802374:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802378:	8b 00                	mov    (%rax),%eax
  80237a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80237e:	48 89 d6             	mov    %rdx,%rsi
  802381:	89 c7                	mov    %eax,%edi
  802383:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  80238a:	00 00 00 
  80238d:	ff d0                	callq  *%rax
  80238f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802392:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802396:	78 2a                	js     8023c2 <fd_close+0xac>
		if (dev->dev_close)
  802398:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239c:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023a0:	48 85 c0             	test   %rax,%rax
  8023a3:	74 16                	je     8023bb <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8023a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023a9:	48 8b 40 20          	mov    0x20(%rax),%rax
  8023ad:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023b1:	48 89 d7             	mov    %rdx,%rdi
  8023b4:	ff d0                	callq  *%rax
  8023b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b9:	eb 07                	jmp    8023c2 <fd_close+0xac>
		else
			r = 0;
  8023bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023c6:	48 89 c6             	mov    %rax,%rsi
  8023c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ce:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8023d5:	00 00 00 
  8023d8:	ff d0                	callq  *%rax
	return r;
  8023da:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023dd:	c9                   	leaveq 
  8023de:	c3                   	retq   

00000000008023df <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023df:	55                   	push   %rbp
  8023e0:	48 89 e5             	mov    %rsp,%rbp
  8023e3:	48 83 ec 20          	sub    $0x20,%rsp
  8023e7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8023ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023f5:	eb 41                	jmp    802438 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8023f7:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  8023fe:	00 00 00 
  802401:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802404:	48 63 d2             	movslq %edx,%rdx
  802407:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80240b:	8b 00                	mov    (%rax),%eax
  80240d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802410:	75 22                	jne    802434 <dev_lookup+0x55>
			*dev = devtab[i];
  802412:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  802419:	00 00 00 
  80241c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80241f:	48 63 d2             	movslq %edx,%rdx
  802422:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802426:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80242a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80242d:	b8 00 00 00 00       	mov    $0x0,%eax
  802432:	eb 60                	jmp    802494 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802434:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802438:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  80243f:	00 00 00 
  802442:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802445:	48 63 d2             	movslq %edx,%rdx
  802448:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244c:	48 85 c0             	test   %rax,%rax
  80244f:	75 a6                	jne    8023f7 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802451:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802458:	00 00 00 
  80245b:	48 8b 00             	mov    (%rax),%rax
  80245e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802464:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802467:	89 c6                	mov    %eax,%esi
  802469:	48 bf f8 41 80 00 00 	movabs $0x8041f8,%rdi
  802470:	00 00 00 
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
  802478:	48 b9 1f 03 80 00 00 	movabs $0x80031f,%rcx
  80247f:	00 00 00 
  802482:	ff d1                	callq  *%rcx
	*dev = 0;
  802484:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802488:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80248f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802494:	c9                   	leaveq 
  802495:	c3                   	retq   

0000000000802496 <close>:

int
close(int fdnum)
{
  802496:	55                   	push   %rbp
  802497:	48 89 e5             	mov    %rsp,%rbp
  80249a:	48 83 ec 20          	sub    $0x20,%rsp
  80249e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024a1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024a5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024a8:	48 89 d6             	mov    %rdx,%rsi
  8024ab:	89 c7                	mov    %eax,%edi
  8024ad:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  8024b4:	00 00 00 
  8024b7:	ff d0                	callq  *%rax
  8024b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024c0:	79 05                	jns    8024c7 <close+0x31>
		return r;
  8024c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024c5:	eb 18                	jmp    8024df <close+0x49>
	else
		return fd_close(fd, 1);
  8024c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024cb:	be 01 00 00 00       	mov    $0x1,%esi
  8024d0:	48 89 c7             	mov    %rax,%rdi
  8024d3:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  8024da:	00 00 00 
  8024dd:	ff d0                	callq  *%rax
}
  8024df:	c9                   	leaveq 
  8024e0:	c3                   	retq   

00000000008024e1 <close_all>:

void
close_all(void)
{
  8024e1:	55                   	push   %rbp
  8024e2:	48 89 e5             	mov    %rsp,%rbp
  8024e5:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8024e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024f0:	eb 15                	jmp    802507 <close_all+0x26>
		close(i);
  8024f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f5:	89 c7                	mov    %eax,%edi
  8024f7:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  8024fe:	00 00 00 
  802501:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802503:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802507:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80250b:	7e e5                	jle    8024f2 <close_all+0x11>
		close(i);
}
  80250d:	c9                   	leaveq 
  80250e:	c3                   	retq   

000000000080250f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80250f:	55                   	push   %rbp
  802510:	48 89 e5             	mov    %rsp,%rbp
  802513:	48 83 ec 40          	sub    $0x40,%rsp
  802517:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80251a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80251d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802521:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802524:	48 89 d6             	mov    %rdx,%rsi
  802527:	89 c7                	mov    %eax,%edi
  802529:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  802530:	00 00 00 
  802533:	ff d0                	callq  *%rax
  802535:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802538:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253c:	79 08                	jns    802546 <dup+0x37>
		return r;
  80253e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802541:	e9 70 01 00 00       	jmpq   8026b6 <dup+0x1a7>
	close(newfdnum);
  802546:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802549:	89 c7                	mov    %eax,%edi
  80254b:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  802552:	00 00 00 
  802555:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802557:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80255a:	48 98                	cltq   
  80255c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802562:	48 c1 e0 0c          	shl    $0xc,%rax
  802566:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80256a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80256e:	48 89 c7             	mov    %rax,%rdi
  802571:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  802578:	00 00 00 
  80257b:	ff d0                	callq  *%rax
  80257d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802585:	48 89 c7             	mov    %rax,%rdi
  802588:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  80258f:	00 00 00 
  802592:	ff d0                	callq  *%rax
  802594:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802598:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259c:	48 c1 e8 15          	shr    $0x15,%rax
  8025a0:	48 89 c2             	mov    %rax,%rdx
  8025a3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025aa:	01 00 00 
  8025ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025b1:	83 e0 01             	and    $0x1,%eax
  8025b4:	48 85 c0             	test   %rax,%rax
  8025b7:	74 73                	je     80262c <dup+0x11d>
  8025b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025bd:	48 c1 e8 0c          	shr    $0xc,%rax
  8025c1:	48 89 c2             	mov    %rax,%rdx
  8025c4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025cb:	01 00 00 
  8025ce:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025d2:	83 e0 01             	and    $0x1,%eax
  8025d5:	48 85 c0             	test   %rax,%rax
  8025d8:	74 52                	je     80262c <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8025da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025de:	48 c1 e8 0c          	shr    $0xc,%rax
  8025e2:	48 89 c2             	mov    %rax,%rdx
  8025e5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025ec:	01 00 00 
  8025ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f3:	25 07 0e 00 00       	and    $0xe07,%eax
  8025f8:	89 c1                	mov    %eax,%ecx
  8025fa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802602:	41 89 c8             	mov    %ecx,%r8d
  802605:	48 89 d1             	mov    %rdx,%rcx
  802608:	ba 00 00 00 00       	mov    $0x0,%edx
  80260d:	48 89 c6             	mov    %rax,%rsi
  802610:	bf 00 00 00 00       	mov    $0x0,%edi
  802615:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  80261c:	00 00 00 
  80261f:	ff d0                	callq  *%rax
  802621:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802624:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802628:	79 02                	jns    80262c <dup+0x11d>
			goto err;
  80262a:	eb 57                	jmp    802683 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80262c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802630:	48 c1 e8 0c          	shr    $0xc,%rax
  802634:	48 89 c2             	mov    %rax,%rdx
  802637:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80263e:	01 00 00 
  802641:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802645:	25 07 0e 00 00       	and    $0xe07,%eax
  80264a:	89 c1                	mov    %eax,%ecx
  80264c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802650:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802654:	41 89 c8             	mov    %ecx,%r8d
  802657:	48 89 d1             	mov    %rdx,%rcx
  80265a:	ba 00 00 00 00       	mov    $0x0,%edx
  80265f:	48 89 c6             	mov    %rax,%rsi
  802662:	bf 00 00 00 00       	mov    $0x0,%edi
  802667:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  80266e:	00 00 00 
  802671:	ff d0                	callq  *%rax
  802673:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802676:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80267a:	79 02                	jns    80267e <dup+0x16f>
		goto err;
  80267c:	eb 05                	jmp    802683 <dup+0x174>

	return newfdnum;
  80267e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802681:	eb 33                	jmp    8026b6 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802683:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802687:	48 89 c6             	mov    %rax,%rsi
  80268a:	bf 00 00 00 00       	mov    $0x0,%edi
  80268f:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  802696:	00 00 00 
  802699:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80269b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80269f:	48 89 c6             	mov    %rax,%rsi
  8026a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026a7:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8026ae:	00 00 00 
  8026b1:	ff d0                	callq  *%rax
	return r;
  8026b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026b6:	c9                   	leaveq 
  8026b7:	c3                   	retq   

00000000008026b8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8026b8:	55                   	push   %rbp
  8026b9:	48 89 e5             	mov    %rsp,%rbp
  8026bc:	48 83 ec 40          	sub    $0x40,%rsp
  8026c0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026c3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026c7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026cb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026cf:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026d2:	48 89 d6             	mov    %rdx,%rsi
  8026d5:	89 c7                	mov    %eax,%edi
  8026d7:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  8026de:	00 00 00 
  8026e1:	ff d0                	callq  *%rax
  8026e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ea:	78 24                	js     802710 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f0:	8b 00                	mov    (%rax),%eax
  8026f2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026f6:	48 89 d6             	mov    %rdx,%rsi
  8026f9:	89 c7                	mov    %eax,%edi
  8026fb:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  802702:	00 00 00 
  802705:	ff d0                	callq  *%rax
  802707:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80270a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270e:	79 05                	jns    802715 <read+0x5d>
		return r;
  802710:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802713:	eb 76                	jmp    80278b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802719:	8b 40 08             	mov    0x8(%rax),%eax
  80271c:	83 e0 03             	and    $0x3,%eax
  80271f:	83 f8 01             	cmp    $0x1,%eax
  802722:	75 3a                	jne    80275e <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802724:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80272b:	00 00 00 
  80272e:	48 8b 00             	mov    (%rax),%rax
  802731:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802737:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80273a:	89 c6                	mov    %eax,%esi
  80273c:	48 bf 17 42 80 00 00 	movabs $0x804217,%rdi
  802743:	00 00 00 
  802746:	b8 00 00 00 00       	mov    $0x0,%eax
  80274b:	48 b9 1f 03 80 00 00 	movabs $0x80031f,%rcx
  802752:	00 00 00 
  802755:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802757:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80275c:	eb 2d                	jmp    80278b <read+0xd3>
	}
	if (!dev->dev_read)
  80275e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802762:	48 8b 40 10          	mov    0x10(%rax),%rax
  802766:	48 85 c0             	test   %rax,%rax
  802769:	75 07                	jne    802772 <read+0xba>
		return -E_NOT_SUPP;
  80276b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802770:	eb 19                	jmp    80278b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802772:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802776:	48 8b 40 10          	mov    0x10(%rax),%rax
  80277a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80277e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802782:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802786:	48 89 cf             	mov    %rcx,%rdi
  802789:	ff d0                	callq  *%rax
}
  80278b:	c9                   	leaveq 
  80278c:	c3                   	retq   

000000000080278d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80278d:	55                   	push   %rbp
  80278e:	48 89 e5             	mov    %rsp,%rbp
  802791:	48 83 ec 30          	sub    $0x30,%rsp
  802795:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802798:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80279c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027a7:	eb 49                	jmp    8027f2 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8027a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027ac:	48 98                	cltq   
  8027ae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027b2:	48 29 c2             	sub    %rax,%rdx
  8027b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b8:	48 63 c8             	movslq %eax,%rcx
  8027bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027bf:	48 01 c1             	add    %rax,%rcx
  8027c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027c5:	48 89 ce             	mov    %rcx,%rsi
  8027c8:	89 c7                	mov    %eax,%edi
  8027ca:	48 b8 b8 26 80 00 00 	movabs $0x8026b8,%rax
  8027d1:	00 00 00 
  8027d4:	ff d0                	callq  *%rax
  8027d6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8027d9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027dd:	79 05                	jns    8027e4 <readn+0x57>
			return m;
  8027df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027e2:	eb 1c                	jmp    802800 <readn+0x73>
		if (m == 0)
  8027e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027e8:	75 02                	jne    8027ec <readn+0x5f>
			break;
  8027ea:	eb 11                	jmp    8027fd <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027ef:	01 45 fc             	add    %eax,-0x4(%rbp)
  8027f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f5:	48 98                	cltq   
  8027f7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8027fb:	72 ac                	jb     8027a9 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8027fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802800:	c9                   	leaveq 
  802801:	c3                   	retq   

0000000000802802 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802802:	55                   	push   %rbp
  802803:	48 89 e5             	mov    %rsp,%rbp
  802806:	48 83 ec 40          	sub    $0x40,%rsp
  80280a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80280d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802811:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802815:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802819:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80281c:	48 89 d6             	mov    %rdx,%rsi
  80281f:	89 c7                	mov    %eax,%edi
  802821:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  802828:	00 00 00 
  80282b:	ff d0                	callq  *%rax
  80282d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802830:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802834:	78 24                	js     80285a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802836:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283a:	8b 00                	mov    (%rax),%eax
  80283c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802840:	48 89 d6             	mov    %rdx,%rsi
  802843:	89 c7                	mov    %eax,%edi
  802845:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  80284c:	00 00 00 
  80284f:	ff d0                	callq  *%rax
  802851:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802854:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802858:	79 05                	jns    80285f <write+0x5d>
		return r;
  80285a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80285d:	eb 75                	jmp    8028d4 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80285f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802863:	8b 40 08             	mov    0x8(%rax),%eax
  802866:	83 e0 03             	and    $0x3,%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	75 3a                	jne    8028a7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80286d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802874:	00 00 00 
  802877:	48 8b 00             	mov    (%rax),%rax
  80287a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802880:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802883:	89 c6                	mov    %eax,%esi
  802885:	48 bf 33 42 80 00 00 	movabs $0x804233,%rdi
  80288c:	00 00 00 
  80288f:	b8 00 00 00 00       	mov    $0x0,%eax
  802894:	48 b9 1f 03 80 00 00 	movabs $0x80031f,%rcx
  80289b:	00 00 00 
  80289e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8028a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028a5:	eb 2d                	jmp    8028d4 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8028a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028ab:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028af:	48 85 c0             	test   %rax,%rax
  8028b2:	75 07                	jne    8028bb <write+0xb9>
		return -E_NOT_SUPP;
  8028b4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028b9:	eb 19                	jmp    8028d4 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8028bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028bf:	48 8b 40 18          	mov    0x18(%rax),%rax
  8028c3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8028c7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8028cb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8028cf:	48 89 cf             	mov    %rcx,%rdi
  8028d2:	ff d0                	callq  *%rax
}
  8028d4:	c9                   	leaveq 
  8028d5:	c3                   	retq   

00000000008028d6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8028d6:	55                   	push   %rbp
  8028d7:	48 89 e5             	mov    %rsp,%rbp
  8028da:	48 83 ec 18          	sub    $0x18,%rsp
  8028de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028e1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028e4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028eb:	48 89 d6             	mov    %rdx,%rsi
  8028ee:	89 c7                	mov    %eax,%edi
  8028f0:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  8028f7:	00 00 00 
  8028fa:	ff d0                	callq  *%rax
  8028fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802903:	79 05                	jns    80290a <seek+0x34>
		return r;
  802905:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802908:	eb 0f                	jmp    802919 <seek+0x43>
	fd->fd_offset = offset;
  80290a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802911:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802914:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802919:	c9                   	leaveq 
  80291a:	c3                   	retq   

000000000080291b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80291b:	55                   	push   %rbp
  80291c:	48 89 e5             	mov    %rsp,%rbp
  80291f:	48 83 ec 30          	sub    $0x30,%rsp
  802923:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802926:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802929:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80292d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802930:	48 89 d6             	mov    %rdx,%rsi
  802933:	89 c7                	mov    %eax,%edi
  802935:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  80293c:	00 00 00 
  80293f:	ff d0                	callq  *%rax
  802941:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802944:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802948:	78 24                	js     80296e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80294a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80294e:	8b 00                	mov    (%rax),%eax
  802950:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802954:	48 89 d6             	mov    %rdx,%rsi
  802957:	89 c7                	mov    %eax,%edi
  802959:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  802960:	00 00 00 
  802963:	ff d0                	callq  *%rax
  802965:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802968:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80296c:	79 05                	jns    802973 <ftruncate+0x58>
		return r;
  80296e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802971:	eb 72                	jmp    8029e5 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802973:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802977:	8b 40 08             	mov    0x8(%rax),%eax
  80297a:	83 e0 03             	and    $0x3,%eax
  80297d:	85 c0                	test   %eax,%eax
  80297f:	75 3a                	jne    8029bb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802981:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802988:	00 00 00 
  80298b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80298e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802994:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802997:	89 c6                	mov    %eax,%esi
  802999:	48 bf 50 42 80 00 00 	movabs $0x804250,%rdi
  8029a0:	00 00 00 
  8029a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a8:	48 b9 1f 03 80 00 00 	movabs $0x80031f,%rcx
  8029af:	00 00 00 
  8029b2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8029b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8029b9:	eb 2a                	jmp    8029e5 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8029bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bf:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029c3:	48 85 c0             	test   %rax,%rax
  8029c6:	75 07                	jne    8029cf <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8029c8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8029cd:	eb 16                	jmp    8029e5 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8029cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d3:	48 8b 40 30          	mov    0x30(%rax),%rax
  8029d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029db:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029de:	89 ce                	mov    %ecx,%esi
  8029e0:	48 89 d7             	mov    %rdx,%rdi
  8029e3:	ff d0                	callq  *%rax
}
  8029e5:	c9                   	leaveq 
  8029e6:	c3                   	retq   

00000000008029e7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8029e7:	55                   	push   %rbp
  8029e8:	48 89 e5             	mov    %rsp,%rbp
  8029eb:	48 83 ec 30          	sub    $0x30,%rsp
  8029ef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029f2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029f6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029fd:	48 89 d6             	mov    %rdx,%rsi
  802a00:	89 c7                	mov    %eax,%edi
  802a02:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  802a09:	00 00 00 
  802a0c:	ff d0                	callq  *%rax
  802a0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a15:	78 24                	js     802a3b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a1b:	8b 00                	mov    (%rax),%eax
  802a1d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a21:	48 89 d6             	mov    %rdx,%rsi
  802a24:	89 c7                	mov    %eax,%edi
  802a26:	48 b8 df 23 80 00 00 	movabs $0x8023df,%rax
  802a2d:	00 00 00 
  802a30:	ff d0                	callq  *%rax
  802a32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a39:	79 05                	jns    802a40 <fstat+0x59>
		return r;
  802a3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3e:	eb 5e                	jmp    802a9e <fstat+0xb7>
	if (!dev->dev_stat)
  802a40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a44:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a48:	48 85 c0             	test   %rax,%rax
  802a4b:	75 07                	jne    802a54 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a4d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a52:	eb 4a                	jmp    802a9e <fstat+0xb7>
	stat->st_name[0] = 0;
  802a54:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a58:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a5f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a66:	00 00 00 
	stat->st_isdir = 0;
  802a69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a6d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a74:	00 00 00 
	stat->st_dev = dev;
  802a77:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a7b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a7f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a8a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a92:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a96:	48 89 ce             	mov    %rcx,%rsi
  802a99:	48 89 d7             	mov    %rdx,%rdi
  802a9c:	ff d0                	callq  *%rax
}
  802a9e:	c9                   	leaveq 
  802a9f:	c3                   	retq   

0000000000802aa0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802aa0:	55                   	push   %rbp
  802aa1:	48 89 e5             	mov    %rsp,%rbp
  802aa4:	48 83 ec 20          	sub    $0x20,%rsp
  802aa8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802aac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ab0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ab4:	be 00 00 00 00       	mov    $0x0,%esi
  802ab9:	48 89 c7             	mov    %rax,%rdi
  802abc:	48 b8 8e 2b 80 00 00 	movabs $0x802b8e,%rax
  802ac3:	00 00 00 
  802ac6:	ff d0                	callq  *%rax
  802ac8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802acb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802acf:	79 05                	jns    802ad6 <stat+0x36>
		return fd;
  802ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad4:	eb 2f                	jmp    802b05 <stat+0x65>
	r = fstat(fd, stat);
  802ad6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802add:	48 89 d6             	mov    %rdx,%rsi
  802ae0:	89 c7                	mov    %eax,%edi
  802ae2:	48 b8 e7 29 80 00 00 	movabs $0x8029e7,%rax
  802ae9:	00 00 00 
  802aec:	ff d0                	callq  *%rax
  802aee:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af4:	89 c7                	mov    %eax,%edi
  802af6:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  802afd:	00 00 00 
  802b00:	ff d0                	callq  *%rax
	return r;
  802b02:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b05:	c9                   	leaveq 
  802b06:	c3                   	retq   

0000000000802b07 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b07:	55                   	push   %rbp
  802b08:	48 89 e5             	mov    %rsp,%rbp
  802b0b:	48 83 ec 10          	sub    $0x10,%rsp
  802b0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802b16:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802b1d:	00 00 00 
  802b20:	8b 00                	mov    (%rax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	75 1d                	jne    802b43 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802b26:	bf 01 00 00 00       	mov    $0x1,%edi
  802b2b:	48 b8 1e 21 80 00 00 	movabs $0x80211e,%rax
  802b32:	00 00 00 
  802b35:	ff d0                	callq  *%rax
  802b37:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802b3e:	00 00 00 
  802b41:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b43:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802b4a:	00 00 00 
  802b4d:	8b 00                	mov    (%rax),%eax
  802b4f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b52:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b57:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802b5e:	00 00 00 
  802b61:	89 c7                	mov    %eax,%edi
  802b63:	48 b8 81 20 80 00 00 	movabs $0x802081,%rax
  802b6a:	00 00 00 
  802b6d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b73:	ba 00 00 00 00       	mov    $0x0,%edx
  802b78:	48 89 c6             	mov    %rax,%rsi
  802b7b:	bf 00 00 00 00       	mov    $0x0,%edi
  802b80:	48 b8 bb 1f 80 00 00 	movabs $0x801fbb,%rax
  802b87:	00 00 00 
  802b8a:	ff d0                	callq  *%rax
}
  802b8c:	c9                   	leaveq 
  802b8d:	c3                   	retq   

0000000000802b8e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b8e:	55                   	push   %rbp
  802b8f:	48 89 e5             	mov    %rsp,%rbp
  802b92:	48 83 ec 20          	sub    $0x20,%rsp
  802b96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b9a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ba1:	48 89 c7             	mov    %rax,%rdi
  802ba4:	48 b8 68 0e 80 00 00 	movabs $0x800e68,%rax
  802bab:	00 00 00 
  802bae:	ff d0                	callq  *%rax
  802bb0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bb5:	7e 0a                	jle    802bc1 <open+0x33>
  802bb7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bbc:	e9 a5 00 00 00       	jmpq   802c66 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802bc1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802bc5:	48 89 c7             	mov    %rax,%rdi
  802bc8:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  802bcf:	00 00 00 
  802bd2:	ff d0                	callq  *%rax
  802bd4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bdb:	79 08                	jns    802be5 <open+0x57>
		return r;
  802bdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be0:	e9 81 00 00 00       	jmpq   802c66 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802be5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802bec:	00 00 00 
  802bef:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802bf2:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfc:	48 89 c6             	mov    %rax,%rsi
  802bff:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802c06:	00 00 00 
  802c09:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  802c10:	00 00 00 
  802c13:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802c15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c19:	48 89 c6             	mov    %rax,%rsi
  802c1c:	bf 01 00 00 00       	mov    $0x1,%edi
  802c21:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  802c28:	00 00 00 
  802c2b:	ff d0                	callq  *%rax
  802c2d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c30:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c34:	79 1d                	jns    802c53 <open+0xc5>
		fd_close(fd, 0);
  802c36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3a:	be 00 00 00 00       	mov    $0x0,%esi
  802c3f:	48 89 c7             	mov    %rax,%rdi
  802c42:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  802c49:	00 00 00 
  802c4c:	ff d0                	callq  *%rax
		return r;
  802c4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c51:	eb 13                	jmp    802c66 <open+0xd8>
	}
	return fd2num(fd);
  802c53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c57:	48 89 c7             	mov    %rax,%rdi
  802c5a:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  802c61:	00 00 00 
  802c64:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802c66:	c9                   	leaveq 
  802c67:	c3                   	retq   

0000000000802c68 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c68:	55                   	push   %rbp
  802c69:	48 89 e5             	mov    %rsp,%rbp
  802c6c:	48 83 ec 10          	sub    $0x10,%rsp
  802c70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c78:	8b 50 0c             	mov    0xc(%rax),%edx
  802c7b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802c82:	00 00 00 
  802c85:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c87:	be 00 00 00 00       	mov    $0x0,%esi
  802c8c:	bf 06 00 00 00       	mov    $0x6,%edi
  802c91:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
}
  802c9d:	c9                   	leaveq 
  802c9e:	c3                   	retq   

0000000000802c9f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c9f:	55                   	push   %rbp
  802ca0:	48 89 e5             	mov    %rsp,%rbp
  802ca3:	48 83 ec 30          	sub    $0x30,%rsp
  802ca7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802caf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802cb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb7:	8b 50 0c             	mov    0xc(%rax),%edx
  802cba:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802cc1:	00 00 00 
  802cc4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802cc6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802ccd:	00 00 00 
  802cd0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cd4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802cd8:	be 00 00 00 00       	mov    $0x0,%esi
  802cdd:	bf 03 00 00 00       	mov    $0x3,%edi
  802ce2:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  802ce9:	00 00 00 
  802cec:	ff d0                	callq  *%rax
  802cee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf5:	79 05                	jns    802cfc <devfile_read+0x5d>
		return r;
  802cf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cfa:	eb 26                	jmp    802d22 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802cfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cff:	48 63 d0             	movslq %eax,%rdx
  802d02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d06:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802d0d:	00 00 00 
  802d10:	48 89 c7             	mov    %rax,%rdi
  802d13:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  802d1a:	00 00 00 
  802d1d:	ff d0                	callq  *%rax
	return r;
  802d1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802d22:	c9                   	leaveq 
  802d23:	c3                   	retq   

0000000000802d24 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802d24:	55                   	push   %rbp
  802d25:	48 89 e5             	mov    %rsp,%rbp
  802d28:	48 83 ec 30          	sub    $0x30,%rsp
  802d2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d34:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802d38:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802d3f:	00 
	n = n > max ? max : n;
  802d40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d44:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802d48:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802d4d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802d51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d55:	8b 50 0c             	mov    0xc(%rax),%edx
  802d58:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d5f:	00 00 00 
  802d62:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802d64:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802d6b:	00 00 00 
  802d6e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d72:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802d76:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d7e:	48 89 c6             	mov    %rax,%rsi
  802d81:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  802d88:	00 00 00 
  802d8b:	48 b8 0f 13 80 00 00 	movabs $0x80130f,%rax
  802d92:	00 00 00 
  802d95:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802d97:	be 00 00 00 00       	mov    $0x0,%esi
  802d9c:	bf 04 00 00 00       	mov    $0x4,%edi
  802da1:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  802da8:	00 00 00 
  802dab:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802dad:	c9                   	leaveq 
  802dae:	c3                   	retq   

0000000000802daf <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802daf:	55                   	push   %rbp
  802db0:	48 89 e5             	mov    %rsp,%rbp
  802db3:	48 83 ec 20          	sub    $0x20,%rsp
  802db7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dbb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802dbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dc3:	8b 50 0c             	mov    0xc(%rax),%edx
  802dc6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802dcd:	00 00 00 
  802dd0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802dd2:	be 00 00 00 00       	mov    $0x0,%esi
  802dd7:	bf 05 00 00 00       	mov    $0x5,%edi
  802ddc:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  802de3:	00 00 00 
  802de6:	ff d0                	callq  *%rax
  802de8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802deb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802def:	79 05                	jns    802df6 <devfile_stat+0x47>
		return r;
  802df1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df4:	eb 56                	jmp    802e4c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802df6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dfa:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802e01:	00 00 00 
  802e04:	48 89 c7             	mov    %rax,%rdi
  802e07:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  802e0e:	00 00 00 
  802e11:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802e13:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e1a:	00 00 00 
  802e1d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802e23:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e27:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e2d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e34:	00 00 00 
  802e37:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e41:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e4c:	c9                   	leaveq 
  802e4d:	c3                   	retq   

0000000000802e4e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e4e:	55                   	push   %rbp
  802e4f:	48 89 e5             	mov    %rsp,%rbp
  802e52:	48 83 ec 10          	sub    $0x10,%rsp
  802e56:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e5a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e61:	8b 50 0c             	mov    0xc(%rax),%edx
  802e64:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e6b:	00 00 00 
  802e6e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e70:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802e77:	00 00 00 
  802e7a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e7d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e80:	be 00 00 00 00       	mov    $0x0,%esi
  802e85:	bf 02 00 00 00       	mov    $0x2,%edi
  802e8a:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  802e91:	00 00 00 
  802e94:	ff d0                	callq  *%rax
}
  802e96:	c9                   	leaveq 
  802e97:	c3                   	retq   

0000000000802e98 <remove>:

// Delete a file
int
remove(const char *path)
{
  802e98:	55                   	push   %rbp
  802e99:	48 89 e5             	mov    %rsp,%rbp
  802e9c:	48 83 ec 10          	sub    $0x10,%rsp
  802ea0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802ea4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea8:	48 89 c7             	mov    %rax,%rdi
  802eab:	48 b8 68 0e 80 00 00 	movabs $0x800e68,%rax
  802eb2:	00 00 00 
  802eb5:	ff d0                	callq  *%rax
  802eb7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ebc:	7e 07                	jle    802ec5 <remove+0x2d>
		return -E_BAD_PATH;
  802ebe:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ec3:	eb 33                	jmp    802ef8 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802ec5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec9:	48 89 c6             	mov    %rax,%rsi
  802ecc:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802ed3:	00 00 00 
  802ed6:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  802edd:	00 00 00 
  802ee0:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802ee2:	be 00 00 00 00       	mov    $0x0,%esi
  802ee7:	bf 07 00 00 00       	mov    $0x7,%edi
  802eec:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  802ef3:	00 00 00 
  802ef6:	ff d0                	callq  *%rax
}
  802ef8:	c9                   	leaveq 
  802ef9:	c3                   	retq   

0000000000802efa <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802efa:	55                   	push   %rbp
  802efb:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802efe:	be 00 00 00 00       	mov    $0x0,%esi
  802f03:	bf 08 00 00 00       	mov    $0x8,%edi
  802f08:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  802f0f:	00 00 00 
  802f12:	ff d0                	callq  *%rax
}
  802f14:	5d                   	pop    %rbp
  802f15:	c3                   	retq   

0000000000802f16 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802f16:	55                   	push   %rbp
  802f17:	48 89 e5             	mov    %rsp,%rbp
  802f1a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802f21:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802f28:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802f2f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802f36:	be 00 00 00 00       	mov    $0x0,%esi
  802f3b:	48 89 c7             	mov    %rax,%rdi
  802f3e:	48 b8 8e 2b 80 00 00 	movabs $0x802b8e,%rax
  802f45:	00 00 00 
  802f48:	ff d0                	callq  *%rax
  802f4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802f4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f51:	79 28                	jns    802f7b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802f53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f56:	89 c6                	mov    %eax,%esi
  802f58:	48 bf 76 42 80 00 00 	movabs $0x804276,%rdi
  802f5f:	00 00 00 
  802f62:	b8 00 00 00 00       	mov    $0x0,%eax
  802f67:	48 ba 1f 03 80 00 00 	movabs $0x80031f,%rdx
  802f6e:	00 00 00 
  802f71:	ff d2                	callq  *%rdx
		return fd_src;
  802f73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f76:	e9 74 01 00 00       	jmpq   8030ef <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802f7b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802f82:	be 01 01 00 00       	mov    $0x101,%esi
  802f87:	48 89 c7             	mov    %rax,%rdi
  802f8a:	48 b8 8e 2b 80 00 00 	movabs $0x802b8e,%rax
  802f91:	00 00 00 
  802f94:	ff d0                	callq  *%rax
  802f96:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802f99:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f9d:	79 39                	jns    802fd8 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802f9f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fa2:	89 c6                	mov    %eax,%esi
  802fa4:	48 bf 8c 42 80 00 00 	movabs $0x80428c,%rdi
  802fab:	00 00 00 
  802fae:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb3:	48 ba 1f 03 80 00 00 	movabs $0x80031f,%rdx
  802fba:	00 00 00 
  802fbd:	ff d2                	callq  *%rdx
		close(fd_src);
  802fbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc2:	89 c7                	mov    %eax,%edi
  802fc4:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  802fcb:	00 00 00 
  802fce:	ff d0                	callq  *%rax
		return fd_dest;
  802fd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fd3:	e9 17 01 00 00       	jmpq   8030ef <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802fd8:	eb 74                	jmp    80304e <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802fda:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fdd:	48 63 d0             	movslq %eax,%rdx
  802fe0:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802fe7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fea:	48 89 ce             	mov    %rcx,%rsi
  802fed:	89 c7                	mov    %eax,%edi
  802fef:	48 b8 02 28 80 00 00 	movabs $0x802802,%rax
  802ff6:	00 00 00 
  802ff9:	ff d0                	callq  *%rax
  802ffb:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802ffe:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803002:	79 4a                	jns    80304e <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803004:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803007:	89 c6                	mov    %eax,%esi
  803009:	48 bf a6 42 80 00 00 	movabs $0x8042a6,%rdi
  803010:	00 00 00 
  803013:	b8 00 00 00 00       	mov    $0x0,%eax
  803018:	48 ba 1f 03 80 00 00 	movabs $0x80031f,%rdx
  80301f:	00 00 00 
  803022:	ff d2                	callq  *%rdx
			close(fd_src);
  803024:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803027:	89 c7                	mov    %eax,%edi
  803029:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  803030:	00 00 00 
  803033:	ff d0                	callq  *%rax
			close(fd_dest);
  803035:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803038:	89 c7                	mov    %eax,%edi
  80303a:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  803041:	00 00 00 
  803044:	ff d0                	callq  *%rax
			return write_size;
  803046:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803049:	e9 a1 00 00 00       	jmpq   8030ef <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80304e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803055:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803058:	ba 00 02 00 00       	mov    $0x200,%edx
  80305d:	48 89 ce             	mov    %rcx,%rsi
  803060:	89 c7                	mov    %eax,%edi
  803062:	48 b8 b8 26 80 00 00 	movabs $0x8026b8,%rax
  803069:	00 00 00 
  80306c:	ff d0                	callq  *%rax
  80306e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803071:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803075:	0f 8f 5f ff ff ff    	jg     802fda <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80307b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80307f:	79 47                	jns    8030c8 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803081:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803084:	89 c6                	mov    %eax,%esi
  803086:	48 bf b9 42 80 00 00 	movabs $0x8042b9,%rdi
  80308d:	00 00 00 
  803090:	b8 00 00 00 00       	mov    $0x0,%eax
  803095:	48 ba 1f 03 80 00 00 	movabs $0x80031f,%rdx
  80309c:	00 00 00 
  80309f:	ff d2                	callq  *%rdx
		close(fd_src);
  8030a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a4:	89 c7                	mov    %eax,%edi
  8030a6:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  8030ad:	00 00 00 
  8030b0:	ff d0                	callq  *%rax
		close(fd_dest);
  8030b2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030b5:	89 c7                	mov    %eax,%edi
  8030b7:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  8030be:	00 00 00 
  8030c1:	ff d0                	callq  *%rax
		return read_size;
  8030c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8030c6:	eb 27                	jmp    8030ef <copy+0x1d9>
	}
	close(fd_src);
  8030c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030cb:	89 c7                	mov    %eax,%edi
  8030cd:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  8030d4:	00 00 00 
  8030d7:	ff d0                	callq  *%rax
	close(fd_dest);
  8030d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030dc:	89 c7                	mov    %eax,%edi
  8030de:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  8030e5:	00 00 00 
  8030e8:	ff d0                	callq  *%rax
	return 0;
  8030ea:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8030ef:	c9                   	leaveq 
  8030f0:	c3                   	retq   

00000000008030f1 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030f1:	55                   	push   %rbp
  8030f2:	48 89 e5             	mov    %rsp,%rbp
  8030f5:	53                   	push   %rbx
  8030f6:	48 83 ec 38          	sub    $0x38,%rsp
  8030fa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8030fe:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803102:	48 89 c7             	mov    %rax,%rdi
  803105:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  80310c:	00 00 00 
  80310f:	ff d0                	callq  *%rax
  803111:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803114:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803118:	0f 88 bf 01 00 00    	js     8032dd <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80311e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803122:	ba 07 04 00 00       	mov    $0x407,%edx
  803127:	48 89 c6             	mov    %rax,%rsi
  80312a:	bf 00 00 00 00       	mov    $0x0,%edi
  80312f:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  803136:	00 00 00 
  803139:	ff d0                	callq  *%rax
  80313b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80313e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803142:	0f 88 95 01 00 00    	js     8032dd <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803148:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80314c:	48 89 c7             	mov    %rax,%rdi
  80314f:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  803156:	00 00 00 
  803159:	ff d0                	callq  *%rax
  80315b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80315e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803162:	0f 88 5d 01 00 00    	js     8032c5 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803168:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80316c:	ba 07 04 00 00       	mov    $0x407,%edx
  803171:	48 89 c6             	mov    %rax,%rsi
  803174:	bf 00 00 00 00       	mov    $0x0,%edi
  803179:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  803180:	00 00 00 
  803183:	ff d0                	callq  *%rax
  803185:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803188:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80318c:	0f 88 33 01 00 00    	js     8032c5 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803192:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803196:	48 89 c7             	mov    %rax,%rdi
  803199:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  8031a0:	00 00 00 
  8031a3:	ff d0                	callq  *%rax
  8031a5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ad:	ba 07 04 00 00       	mov    $0x407,%edx
  8031b2:	48 89 c6             	mov    %rax,%rsi
  8031b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8031ba:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  8031c1:	00 00 00 
  8031c4:	ff d0                	callq  *%rax
  8031c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8031c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8031cd:	79 05                	jns    8031d4 <pipe+0xe3>
		goto err2;
  8031cf:	e9 d9 00 00 00       	jmpq   8032ad <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031d4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031d8:	48 89 c7             	mov    %rax,%rdi
  8031db:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  8031e2:	00 00 00 
  8031e5:	ff d0                	callq  *%rax
  8031e7:	48 89 c2             	mov    %rax,%rdx
  8031ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031ee:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8031f4:	48 89 d1             	mov    %rdx,%rcx
  8031f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8031fc:	48 89 c6             	mov    %rax,%rsi
  8031ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803204:	48 b8 53 18 80 00 00 	movabs $0x801853,%rax
  80320b:	00 00 00 
  80320e:	ff d0                	callq  *%rax
  803210:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803213:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803217:	79 1b                	jns    803234 <pipe+0x143>
		goto err3;
  803219:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80321a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80321e:	48 89 c6             	mov    %rax,%rsi
  803221:	bf 00 00 00 00       	mov    $0x0,%edi
  803226:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  80322d:	00 00 00 
  803230:	ff d0                	callq  *%rax
  803232:	eb 79                	jmp    8032ad <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803234:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803238:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80323f:	00 00 00 
  803242:	8b 12                	mov    (%rdx),%edx
  803244:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803246:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80324a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803251:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803255:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  80325c:	00 00 00 
  80325f:	8b 12                	mov    (%rdx),%edx
  803261:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803263:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803267:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80326e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803272:	48 89 c7             	mov    %rax,%rdi
  803275:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  80327c:	00 00 00 
  80327f:	ff d0                	callq  *%rax
  803281:	89 c2                	mov    %eax,%edx
  803283:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803287:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803289:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80328d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803291:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803295:	48 89 c7             	mov    %rax,%rdi
  803298:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  80329f:	00 00 00 
  8032a2:	ff d0                	callq  *%rax
  8032a4:	89 03                	mov    %eax,(%rbx)
	return 0;
  8032a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ab:	eb 33                	jmp    8032e0 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8032ad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032b1:	48 89 c6             	mov    %rax,%rsi
  8032b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8032b9:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8032c0:	00 00 00 
  8032c3:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8032c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032c9:	48 89 c6             	mov    %rax,%rsi
  8032cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d1:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8032d8:	00 00 00 
  8032db:	ff d0                	callq  *%rax
err:
	return r;
  8032dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8032e0:	48 83 c4 38          	add    $0x38,%rsp
  8032e4:	5b                   	pop    %rbx
  8032e5:	5d                   	pop    %rbp
  8032e6:	c3                   	retq   

00000000008032e7 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8032e7:	55                   	push   %rbp
  8032e8:	48 89 e5             	mov    %rsp,%rbp
  8032eb:	53                   	push   %rbx
  8032ec:	48 83 ec 28          	sub    $0x28,%rsp
  8032f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8032f8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8032ff:	00 00 00 
  803302:	48 8b 00             	mov    (%rax),%rax
  803305:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80330b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80330e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803312:	48 89 c7             	mov    %rax,%rdi
  803315:	48 b8 a0 3b 80 00 00 	movabs $0x803ba0,%rax
  80331c:	00 00 00 
  80331f:	ff d0                	callq  *%rax
  803321:	89 c3                	mov    %eax,%ebx
  803323:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803327:	48 89 c7             	mov    %rax,%rdi
  80332a:	48 b8 a0 3b 80 00 00 	movabs $0x803ba0,%rax
  803331:	00 00 00 
  803334:	ff d0                	callq  *%rax
  803336:	39 c3                	cmp    %eax,%ebx
  803338:	0f 94 c0             	sete   %al
  80333b:	0f b6 c0             	movzbl %al,%eax
  80333e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803341:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803348:	00 00 00 
  80334b:	48 8b 00             	mov    (%rax),%rax
  80334e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803354:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803357:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80335a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80335d:	75 05                	jne    803364 <_pipeisclosed+0x7d>
			return ret;
  80335f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803362:	eb 4f                	jmp    8033b3 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803364:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803367:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80336a:	74 42                	je     8033ae <_pipeisclosed+0xc7>
  80336c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803370:	75 3c                	jne    8033ae <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803372:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803379:	00 00 00 
  80337c:	48 8b 00             	mov    (%rax),%rax
  80337f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803385:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803388:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80338b:	89 c6                	mov    %eax,%esi
  80338d:	48 bf d4 42 80 00 00 	movabs $0x8042d4,%rdi
  803394:	00 00 00 
  803397:	b8 00 00 00 00       	mov    $0x0,%eax
  80339c:	49 b8 1f 03 80 00 00 	movabs $0x80031f,%r8
  8033a3:	00 00 00 
  8033a6:	41 ff d0             	callq  *%r8
	}
  8033a9:	e9 4a ff ff ff       	jmpq   8032f8 <_pipeisclosed+0x11>
  8033ae:	e9 45 ff ff ff       	jmpq   8032f8 <_pipeisclosed+0x11>
}
  8033b3:	48 83 c4 28          	add    $0x28,%rsp
  8033b7:	5b                   	pop    %rbx
  8033b8:	5d                   	pop    %rbp
  8033b9:	c3                   	retq   

00000000008033ba <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8033ba:	55                   	push   %rbp
  8033bb:	48 89 e5             	mov    %rsp,%rbp
  8033be:	48 83 ec 30          	sub    $0x30,%rsp
  8033c2:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8033c5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8033c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8033cc:	48 89 d6             	mov    %rdx,%rsi
  8033cf:	89 c7                	mov    %eax,%edi
  8033d1:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  8033d8:	00 00 00 
  8033db:	ff d0                	callq  *%rax
  8033dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e4:	79 05                	jns    8033eb <pipeisclosed+0x31>
		return r;
  8033e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e9:	eb 31                	jmp    80341c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8033eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ef:	48 89 c7             	mov    %rax,%rdi
  8033f2:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  8033f9:	00 00 00 
  8033fc:	ff d0                	callq  *%rax
  8033fe:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803406:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80340a:	48 89 d6             	mov    %rdx,%rsi
  80340d:	48 89 c7             	mov    %rax,%rdi
  803410:	48 b8 e7 32 80 00 00 	movabs $0x8032e7,%rax
  803417:	00 00 00 
  80341a:	ff d0                	callq  *%rax
}
  80341c:	c9                   	leaveq 
  80341d:	c3                   	retq   

000000000080341e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80341e:	55                   	push   %rbp
  80341f:	48 89 e5             	mov    %rsp,%rbp
  803422:	48 83 ec 40          	sub    $0x40,%rsp
  803426:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80342a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80342e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803432:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803436:	48 89 c7             	mov    %rax,%rdi
  803439:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  803440:	00 00 00 
  803443:	ff d0                	callq  *%rax
  803445:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803449:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80344d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803451:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803458:	00 
  803459:	e9 92 00 00 00       	jmpq   8034f0 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  80345e:	eb 41                	jmp    8034a1 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803460:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803465:	74 09                	je     803470 <devpipe_read+0x52>
				return i;
  803467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80346b:	e9 92 00 00 00       	jmpq   803502 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803470:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803474:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803478:	48 89 d6             	mov    %rdx,%rsi
  80347b:	48 89 c7             	mov    %rax,%rdi
  80347e:	48 b8 e7 32 80 00 00 	movabs $0x8032e7,%rax
  803485:	00 00 00 
  803488:	ff d0                	callq  *%rax
  80348a:	85 c0                	test   %eax,%eax
  80348c:	74 07                	je     803495 <devpipe_read+0x77>
				return 0;
  80348e:	b8 00 00 00 00       	mov    $0x0,%eax
  803493:	eb 6d                	jmp    803502 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803495:	48 b8 c5 17 80 00 00 	movabs $0x8017c5,%rax
  80349c:	00 00 00 
  80349f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8034a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034a5:	8b 10                	mov    (%rax),%edx
  8034a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034ab:	8b 40 04             	mov    0x4(%rax),%eax
  8034ae:	39 c2                	cmp    %eax,%edx
  8034b0:	74 ae                	je     803460 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8034b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034ba:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8034be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034c2:	8b 00                	mov    (%rax),%eax
  8034c4:	99                   	cltd   
  8034c5:	c1 ea 1b             	shr    $0x1b,%edx
  8034c8:	01 d0                	add    %edx,%eax
  8034ca:	83 e0 1f             	and    $0x1f,%eax
  8034cd:	29 d0                	sub    %edx,%eax
  8034cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8034d3:	48 98                	cltq   
  8034d5:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8034da:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8034dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e0:	8b 00                	mov    (%rax),%eax
  8034e2:	8d 50 01             	lea    0x1(%rax),%edx
  8034e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034e9:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8034eb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8034f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034f8:	0f 82 60 ff ff ff    	jb     80345e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8034fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803502:	c9                   	leaveq 
  803503:	c3                   	retq   

0000000000803504 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803504:	55                   	push   %rbp
  803505:	48 89 e5             	mov    %rsp,%rbp
  803508:	48 83 ec 40          	sub    $0x40,%rsp
  80350c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803510:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803514:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803518:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80351c:	48 89 c7             	mov    %rax,%rdi
  80351f:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  803526:	00 00 00 
  803529:	ff d0                	callq  *%rax
  80352b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80352f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803533:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803537:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80353e:	00 
  80353f:	e9 8e 00 00 00       	jmpq   8035d2 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803544:	eb 31                	jmp    803577 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803546:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80354a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80354e:	48 89 d6             	mov    %rdx,%rsi
  803551:	48 89 c7             	mov    %rax,%rdi
  803554:	48 b8 e7 32 80 00 00 	movabs $0x8032e7,%rax
  80355b:	00 00 00 
  80355e:	ff d0                	callq  *%rax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 07                	je     80356b <devpipe_write+0x67>
				return 0;
  803564:	b8 00 00 00 00       	mov    $0x0,%eax
  803569:	eb 79                	jmp    8035e4 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80356b:	48 b8 c5 17 80 00 00 	movabs $0x8017c5,%rax
  803572:	00 00 00 
  803575:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803577:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80357b:	8b 40 04             	mov    0x4(%rax),%eax
  80357e:	48 63 d0             	movslq %eax,%rdx
  803581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803585:	8b 00                	mov    (%rax),%eax
  803587:	48 98                	cltq   
  803589:	48 83 c0 20          	add    $0x20,%rax
  80358d:	48 39 c2             	cmp    %rax,%rdx
  803590:	73 b4                	jae    803546 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803592:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803596:	8b 40 04             	mov    0x4(%rax),%eax
  803599:	99                   	cltd   
  80359a:	c1 ea 1b             	shr    $0x1b,%edx
  80359d:	01 d0                	add    %edx,%eax
  80359f:	83 e0 1f             	and    $0x1f,%eax
  8035a2:	29 d0                	sub    %edx,%eax
  8035a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035a8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8035ac:	48 01 ca             	add    %rcx,%rdx
  8035af:	0f b6 0a             	movzbl (%rdx),%ecx
  8035b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035b6:	48 98                	cltq   
  8035b8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8035bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035c0:	8b 40 04             	mov    0x4(%rax),%eax
  8035c3:	8d 50 01             	lea    0x1(%rax),%edx
  8035c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035ca:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8035cd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8035d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8035da:	0f 82 64 ff ff ff    	jb     803544 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8035e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8035e4:	c9                   	leaveq 
  8035e5:	c3                   	retq   

00000000008035e6 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8035e6:	55                   	push   %rbp
  8035e7:	48 89 e5             	mov    %rsp,%rbp
  8035ea:	48 83 ec 20          	sub    $0x20,%rsp
  8035ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8035f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035fa:	48 89 c7             	mov    %rax,%rdi
  8035fd:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  803604:	00 00 00 
  803607:	ff d0                	callq  *%rax
  803609:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80360d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803611:	48 be e7 42 80 00 00 	movabs $0x8042e7,%rsi
  803618:	00 00 00 
  80361b:	48 89 c7             	mov    %rax,%rdi
  80361e:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  803625:	00 00 00 
  803628:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80362a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80362e:	8b 50 04             	mov    0x4(%rax),%edx
  803631:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803635:	8b 00                	mov    (%rax),%eax
  803637:	29 c2                	sub    %eax,%edx
  803639:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80363d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803643:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803647:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80364e:	00 00 00 
	stat->st_dev = &devpipe;
  803651:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803655:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  80365c:	00 00 00 
  80365f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803666:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80366b:	c9                   	leaveq 
  80366c:	c3                   	retq   

000000000080366d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80366d:	55                   	push   %rbp
  80366e:	48 89 e5             	mov    %rsp,%rbp
  803671:	48 83 ec 10          	sub    $0x10,%rsp
  803675:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803679:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80367d:	48 89 c6             	mov    %rax,%rsi
  803680:	bf 00 00 00 00       	mov    $0x0,%edi
  803685:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  80368c:	00 00 00 
  80368f:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803691:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803695:	48 89 c7             	mov    %rax,%rdi
  803698:	48 b8 c3 21 80 00 00 	movabs $0x8021c3,%rax
  80369f:	00 00 00 
  8036a2:	ff d0                	callq  *%rax
  8036a4:	48 89 c6             	mov    %rax,%rsi
  8036a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ac:	48 b8 ae 18 80 00 00 	movabs $0x8018ae,%rax
  8036b3:	00 00 00 
  8036b6:	ff d0                	callq  *%rax
}
  8036b8:	c9                   	leaveq 
  8036b9:	c3                   	retq   

00000000008036ba <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8036ba:	55                   	push   %rbp
  8036bb:	48 89 e5             	mov    %rsp,%rbp
  8036be:	48 83 ec 20          	sub    $0x20,%rsp
  8036c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8036c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036c8:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8036cb:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8036cf:	be 01 00 00 00       	mov    $0x1,%esi
  8036d4:	48 89 c7             	mov    %rax,%rdi
  8036d7:	48 b8 bb 16 80 00 00 	movabs $0x8016bb,%rax
  8036de:	00 00 00 
  8036e1:	ff d0                	callq  *%rax
}
  8036e3:	c9                   	leaveq 
  8036e4:	c3                   	retq   

00000000008036e5 <getchar>:

int
getchar(void)
{
  8036e5:	55                   	push   %rbp
  8036e6:	48 89 e5             	mov    %rsp,%rbp
  8036e9:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8036ed:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8036f1:	ba 01 00 00 00       	mov    $0x1,%edx
  8036f6:	48 89 c6             	mov    %rax,%rsi
  8036f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8036fe:	48 b8 b8 26 80 00 00 	movabs $0x8026b8,%rax
  803705:	00 00 00 
  803708:	ff d0                	callq  *%rax
  80370a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80370d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803711:	79 05                	jns    803718 <getchar+0x33>
		return r;
  803713:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803716:	eb 14                	jmp    80372c <getchar+0x47>
	if (r < 1)
  803718:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80371c:	7f 07                	jg     803725 <getchar+0x40>
		return -E_EOF;
  80371e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803723:	eb 07                	jmp    80372c <getchar+0x47>
	return c;
  803725:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803729:	0f b6 c0             	movzbl %al,%eax
}
  80372c:	c9                   	leaveq 
  80372d:	c3                   	retq   

000000000080372e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80372e:	55                   	push   %rbp
  80372f:	48 89 e5             	mov    %rsp,%rbp
  803732:	48 83 ec 20          	sub    $0x20,%rsp
  803736:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803739:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80373d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803740:	48 89 d6             	mov    %rdx,%rsi
  803743:	89 c7                	mov    %eax,%edi
  803745:	48 b8 86 22 80 00 00 	movabs $0x802286,%rax
  80374c:	00 00 00 
  80374f:	ff d0                	callq  *%rax
  803751:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803754:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803758:	79 05                	jns    80375f <iscons+0x31>
		return r;
  80375a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375d:	eb 1a                	jmp    803779 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80375f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803763:	8b 10                	mov    (%rax),%edx
  803765:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80376c:	00 00 00 
  80376f:	8b 00                	mov    (%rax),%eax
  803771:	39 c2                	cmp    %eax,%edx
  803773:	0f 94 c0             	sete   %al
  803776:	0f b6 c0             	movzbl %al,%eax
}
  803779:	c9                   	leaveq 
  80377a:	c3                   	retq   

000000000080377b <opencons>:

int
opencons(void)
{
  80377b:	55                   	push   %rbp
  80377c:	48 89 e5             	mov    %rsp,%rbp
  80377f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803783:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803787:	48 89 c7             	mov    %rax,%rdi
  80378a:	48 b8 ee 21 80 00 00 	movabs $0x8021ee,%rax
  803791:	00 00 00 
  803794:	ff d0                	callq  *%rax
  803796:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803799:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80379d:	79 05                	jns    8037a4 <opencons+0x29>
		return r;
  80379f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a2:	eb 5b                	jmp    8037ff <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8037a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a8:	ba 07 04 00 00       	mov    $0x407,%edx
  8037ad:	48 89 c6             	mov    %rax,%rsi
  8037b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8037b5:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  8037bc:	00 00 00 
  8037bf:	ff d0                	callq  *%rax
  8037c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c8:	79 05                	jns    8037cf <opencons+0x54>
		return r;
  8037ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037cd:	eb 30                	jmp    8037ff <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8037cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d3:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8037da:	00 00 00 
  8037dd:	8b 12                	mov    (%rdx),%edx
  8037df:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8037e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8037ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f0:	48 89 c7             	mov    %rax,%rdi
  8037f3:	48 b8 a0 21 80 00 00 	movabs $0x8021a0,%rax
  8037fa:	00 00 00 
  8037fd:	ff d0                	callq  *%rax
}
  8037ff:	c9                   	leaveq 
  803800:	c3                   	retq   

0000000000803801 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803801:	55                   	push   %rbp
  803802:	48 89 e5             	mov    %rsp,%rbp
  803805:	48 83 ec 30          	sub    $0x30,%rsp
  803809:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80380d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803811:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803815:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80381a:	75 07                	jne    803823 <devcons_read+0x22>
		return 0;
  80381c:	b8 00 00 00 00       	mov    $0x0,%eax
  803821:	eb 4b                	jmp    80386e <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803823:	eb 0c                	jmp    803831 <devcons_read+0x30>
		sys_yield();
  803825:	48 b8 c5 17 80 00 00 	movabs $0x8017c5,%rax
  80382c:	00 00 00 
  80382f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803831:	48 b8 05 17 80 00 00 	movabs $0x801705,%rax
  803838:	00 00 00 
  80383b:	ff d0                	callq  *%rax
  80383d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803840:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803844:	74 df                	je     803825 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803846:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384a:	79 05                	jns    803851 <devcons_read+0x50>
		return c;
  80384c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384f:	eb 1d                	jmp    80386e <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803851:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803855:	75 07                	jne    80385e <devcons_read+0x5d>
		return 0;
  803857:	b8 00 00 00 00       	mov    $0x0,%eax
  80385c:	eb 10                	jmp    80386e <devcons_read+0x6d>
	*(char*)vbuf = c;
  80385e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803861:	89 c2                	mov    %eax,%edx
  803863:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803867:	88 10                	mov    %dl,(%rax)
	return 1;
  803869:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80386e:	c9                   	leaveq 
  80386f:	c3                   	retq   

0000000000803870 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803870:	55                   	push   %rbp
  803871:	48 89 e5             	mov    %rsp,%rbp
  803874:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80387b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803882:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803889:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803890:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803897:	eb 76                	jmp    80390f <devcons_write+0x9f>
		m = n - tot;
  803899:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8038a0:	89 c2                	mov    %eax,%edx
  8038a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a5:	29 c2                	sub    %eax,%edx
  8038a7:	89 d0                	mov    %edx,%eax
  8038a9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8038ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038af:	83 f8 7f             	cmp    $0x7f,%eax
  8038b2:	76 07                	jbe    8038bb <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8038b4:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8038bb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038be:	48 63 d0             	movslq %eax,%rdx
  8038c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c4:	48 63 c8             	movslq %eax,%rcx
  8038c7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8038ce:	48 01 c1             	add    %rax,%rcx
  8038d1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038d8:	48 89 ce             	mov    %rcx,%rsi
  8038db:	48 89 c7             	mov    %rax,%rdi
  8038de:	48 b8 f8 11 80 00 00 	movabs $0x8011f8,%rax
  8038e5:	00 00 00 
  8038e8:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8038ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038ed:	48 63 d0             	movslq %eax,%rdx
  8038f0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8038f7:	48 89 d6             	mov    %rdx,%rsi
  8038fa:	48 89 c7             	mov    %rax,%rdi
  8038fd:	48 b8 bb 16 80 00 00 	movabs $0x8016bb,%rax
  803904:	00 00 00 
  803907:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803909:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80390c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80390f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803912:	48 98                	cltq   
  803914:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80391b:	0f 82 78 ff ff ff    	jb     803899 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803921:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803924:	c9                   	leaveq 
  803925:	c3                   	retq   

0000000000803926 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803926:	55                   	push   %rbp
  803927:	48 89 e5             	mov    %rsp,%rbp
  80392a:	48 83 ec 08          	sub    $0x8,%rsp
  80392e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803932:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803937:	c9                   	leaveq 
  803938:	c3                   	retq   

0000000000803939 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803939:	55                   	push   %rbp
  80393a:	48 89 e5             	mov    %rsp,%rbp
  80393d:	48 83 ec 10          	sub    $0x10,%rsp
  803941:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803945:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803949:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80394d:	48 be f3 42 80 00 00 	movabs $0x8042f3,%rsi
  803954:	00 00 00 
  803957:	48 89 c7             	mov    %rax,%rdi
  80395a:	48 b8 d4 0e 80 00 00 	movabs $0x800ed4,%rax
  803961:	00 00 00 
  803964:	ff d0                	callq  *%rax
	return 0;
  803966:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80396b:	c9                   	leaveq 
  80396c:	c3                   	retq   

000000000080396d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80396d:	55                   	push   %rbp
  80396e:	48 89 e5             	mov    %rsp,%rbp
  803971:	53                   	push   %rbx
  803972:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803979:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803980:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803986:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80398d:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803994:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80399b:	84 c0                	test   %al,%al
  80399d:	74 23                	je     8039c2 <_panic+0x55>
  80399f:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8039a6:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8039aa:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8039ae:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8039b2:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8039b6:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8039ba:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8039be:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8039c2:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8039c9:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8039d0:	00 00 00 
  8039d3:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8039da:	00 00 00 
  8039dd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8039e1:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8039e8:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8039ef:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8039f6:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8039fd:	00 00 00 
  803a00:	48 8b 18             	mov    (%rax),%rbx
  803a03:	48 b8 87 17 80 00 00 	movabs $0x801787,%rax
  803a0a:	00 00 00 
  803a0d:	ff d0                	callq  *%rax
  803a0f:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  803a15:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803a1c:	41 89 c8             	mov    %ecx,%r8d
  803a1f:	48 89 d1             	mov    %rdx,%rcx
  803a22:	48 89 da             	mov    %rbx,%rdx
  803a25:	89 c6                	mov    %eax,%esi
  803a27:	48 bf 00 43 80 00 00 	movabs $0x804300,%rdi
  803a2e:	00 00 00 
  803a31:	b8 00 00 00 00       	mov    $0x0,%eax
  803a36:	49 b9 1f 03 80 00 00 	movabs $0x80031f,%r9
  803a3d:	00 00 00 
  803a40:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803a43:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803a4a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803a51:	48 89 d6             	mov    %rdx,%rsi
  803a54:	48 89 c7             	mov    %rax,%rdi
  803a57:	48 b8 73 02 80 00 00 	movabs $0x800273,%rax
  803a5e:	00 00 00 
  803a61:	ff d0                	callq  *%rax
	cprintf("\n");
  803a63:	48 bf 23 43 80 00 00 	movabs $0x804323,%rdi
  803a6a:	00 00 00 
  803a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a72:	48 ba 1f 03 80 00 00 	movabs $0x80031f,%rdx
  803a79:	00 00 00 
  803a7c:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803a7e:	cc                   	int3   
  803a7f:	eb fd                	jmp    803a7e <_panic+0x111>

0000000000803a81 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803a81:	55                   	push   %rbp
  803a82:	48 89 e5             	mov    %rsp,%rbp
  803a85:	48 83 ec 10          	sub    $0x10,%rsp
  803a89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  803a8d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803a94:	00 00 00 
  803a97:	48 8b 00             	mov    (%rax),%rax
  803a9a:	48 85 c0             	test   %rax,%rax
  803a9d:	75 64                	jne    803b03 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  803a9f:	ba 07 00 00 00       	mov    $0x7,%edx
  803aa4:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  803aa9:	bf 00 00 00 00       	mov    $0x0,%edi
  803aae:	48 b8 03 18 80 00 00 	movabs $0x801803,%rax
  803ab5:	00 00 00 
  803ab8:	ff d0                	callq  *%rax
  803aba:	85 c0                	test   %eax,%eax
  803abc:	74 2a                	je     803ae8 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  803abe:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  803ac5:	00 00 00 
  803ac8:	be 22 00 00 00       	mov    $0x22,%esi
  803acd:	48 bf 50 43 80 00 00 	movabs $0x804350,%rdi
  803ad4:	00 00 00 
  803ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  803adc:	48 b9 6d 39 80 00 00 	movabs $0x80396d,%rcx
  803ae3:	00 00 00 
  803ae6:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803ae8:	48 be 16 3b 80 00 00 	movabs $0x803b16,%rsi
  803aef:	00 00 00 
  803af2:	bf 00 00 00 00       	mov    $0x0,%edi
  803af7:	48 b8 8d 19 80 00 00 	movabs $0x80198d,%rax
  803afe:	00 00 00 
  803b01:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803b03:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803b0a:	00 00 00 
  803b0d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b11:	48 89 10             	mov    %rdx,(%rax)
}
  803b14:	c9                   	leaveq 
  803b15:	c3                   	retq   

0000000000803b16 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  803b16:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803b19:	48 a1 08 80 80 00 00 	movabs 0x808008,%rax
  803b20:	00 00 00 
call *%rax
  803b23:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  803b25:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  803b2c:	00 
mov 136(%rsp), %r9
  803b2d:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  803b34:	00 
sub $8, %r8
  803b35:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  803b39:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  803b3c:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  803b43:	00 
add $16, %rsp
  803b44:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  803b48:	4c 8b 3c 24          	mov    (%rsp),%r15
  803b4c:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  803b51:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  803b56:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803b5b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803b60:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  803b65:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  803b6a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  803b6f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  803b74:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  803b79:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  803b7e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  803b83:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  803b88:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  803b8d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  803b92:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  803b96:	48 83 c4 08          	add    $0x8,%rsp
popf
  803b9a:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  803b9b:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  803b9f:	c3                   	retq   

0000000000803ba0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ba0:	55                   	push   %rbp
  803ba1:	48 89 e5             	mov    %rsp,%rbp
  803ba4:	48 83 ec 18          	sub    $0x18,%rsp
  803ba8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bb0:	48 c1 e8 15          	shr    $0x15,%rax
  803bb4:	48 89 c2             	mov    %rax,%rdx
  803bb7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bbe:	01 00 00 
  803bc1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bc5:	83 e0 01             	and    $0x1,%eax
  803bc8:	48 85 c0             	test   %rax,%rax
  803bcb:	75 07                	jne    803bd4 <pageref+0x34>
		return 0;
  803bcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd2:	eb 53                	jmp    803c27 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803bd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bd8:	48 c1 e8 0c          	shr    $0xc,%rax
  803bdc:	48 89 c2             	mov    %rax,%rdx
  803bdf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803be6:	01 00 00 
  803be9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803bf1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bf5:	83 e0 01             	and    $0x1,%eax
  803bf8:	48 85 c0             	test   %rax,%rax
  803bfb:	75 07                	jne    803c04 <pageref+0x64>
		return 0;
  803bfd:	b8 00 00 00 00       	mov    $0x0,%eax
  803c02:	eb 23                	jmp    803c27 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c08:	48 c1 e8 0c          	shr    $0xc,%rax
  803c0c:	48 89 c2             	mov    %rax,%rdx
  803c0f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c16:	00 00 00 
  803c19:	48 c1 e2 04          	shl    $0x4,%rdx
  803c1d:	48 01 d0             	add    %rdx,%rax
  803c20:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c24:	0f b7 c0             	movzwl %ax,%eax
}
  803c27:	c9                   	leaveq 
  803c28:	c3                   	retq   
