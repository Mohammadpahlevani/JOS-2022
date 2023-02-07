
obj/user/forktree:     file format elf64-x86-64


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
  80003c:	e8 24 01 00 00       	callq  800165 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 f0                	mov    %esi,%eax
  800051:	88 45 e4             	mov    %al,-0x1c(%rbp)
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800054:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800058:	48 89 c7             	mov    %rax,%rdi
  80005b:	48 b8 86 0e 80 00 00 	movabs $0x800e86,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
  800067:	83 f8 02             	cmp    $0x2,%eax
  80006a:	7f 65                	jg     8000d1 <forkchild+0x8e>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80006c:	0f be 4d e4          	movsbl -0x1c(%rbp),%ecx
  800070:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800078:	41 89 c8             	mov    %ecx,%r8d
  80007b:	48 89 d1             	mov    %rdx,%rcx
  80007e:	48 ba 60 3c 80 00 00 	movabs $0x803c60,%rdx
  800085:	00 00 00 
  800088:	be 04 00 00 00       	mov    $0x4,%esi
  80008d:	48 89 c7             	mov    %rax,%rdi
  800090:	b8 00 00 00 00       	mov    $0x0,%eax
  800095:	49 b9 a5 0d 80 00 00 	movabs $0x800da5,%r9
  80009c:	00 00 00 
  80009f:	41 ff d1             	callq  *%r9
	if (fork() == 0) {
  8000a2:	48 b8 e1 1c 80 00 00 	movabs $0x801ce1,%rax
  8000a9:	00 00 00 
  8000ac:	ff d0                	callq  *%rax
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 1f                	jne    8000d1 <forkchild+0x8e>
		forktree(nxt);
  8000b2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8000b6:	48 89 c7             	mov    %rax,%rdi
  8000b9:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  8000c0:	00 00 00 
  8000c3:	ff d0                	callq  *%rax
		exit();
  8000c5:	48 b8 f5 01 80 00 00 	movabs $0x8001f5,%rax
  8000cc:	00 00 00 
  8000cf:	ff d0                	callq  *%rax
	}
}
  8000d1:	c9                   	leaveq 
  8000d2:	c3                   	retq   

00000000008000d3 <forktree>:

void
forktree(const char *cur)
{
  8000d3:	55                   	push   %rbp
  8000d4:	48 89 e5             	mov    %rsp,%rbp
  8000d7:	48 83 ec 10          	sub    $0x10,%rsp
  8000db:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  8000df:	48 b8 a5 17 80 00 00 	movabs $0x8017a5,%rax
  8000e6:	00 00 00 
  8000e9:	ff d0                	callq  *%rax
  8000eb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	48 bf 65 3c 80 00 00 	movabs $0x803c65,%rdi
  8000f8:	00 00 00 
  8000fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800100:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  800107:	00 00 00 
  80010a:	ff d1                	callq  *%rcx

	forkchild(cur, '0');
  80010c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800110:	be 30 00 00 00       	mov    $0x30,%esi
  800115:	48 89 c7             	mov    %rax,%rdi
  800118:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
	forkchild(cur, '1');
  800124:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800128:	be 31 00 00 00       	mov    $0x31,%esi
  80012d:	48 89 c7             	mov    %rax,%rdi
  800130:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800137:	00 00 00 
  80013a:	ff d0                	callq  *%rax
}
  80013c:	c9                   	leaveq 
  80013d:	c3                   	retq   

000000000080013e <umain>:

void
umain(int argc, char **argv)
{
  80013e:	55                   	push   %rbp
  80013f:	48 89 e5             	mov    %rsp,%rbp
  800142:	48 83 ec 10          	sub    $0x10,%rsp
  800146:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800149:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	forktree("");
  80014d:	48 bf 76 3c 80 00 00 	movabs $0x803c76,%rdi
  800154:	00 00 00 
  800157:	48 b8 d3 00 80 00 00 	movabs $0x8000d3,%rax
  80015e:	00 00 00 
  800161:	ff d0                	callq  *%rax
}
  800163:	c9                   	leaveq 
  800164:	c3                   	retq   

0000000000800165 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800165:	55                   	push   %rbp
  800166:	48 89 e5             	mov    %rsp,%rbp
  800169:	48 83 ec 10          	sub    $0x10,%rsp
  80016d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800170:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800174:	48 b8 a5 17 80 00 00 	movabs $0x8017a5,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	48 98                	cltq   
  800182:	25 ff 03 00 00       	and    $0x3ff,%eax
  800187:	48 89 c2             	mov    %rax,%rdx
  80018a:	48 89 d0             	mov    %rdx,%rax
  80018d:	48 c1 e0 03          	shl    $0x3,%rax
  800191:	48 01 d0             	add    %rdx,%rax
  800194:	48 c1 e0 05          	shl    $0x5,%rax
  800198:	48 89 c2             	mov    %rax,%rdx
  80019b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001a2:	00 00 00 
  8001a5:	48 01 c2             	add    %rax,%rdx
  8001a8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8001af:	00 00 00 
  8001b2:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001b9:	7e 14                	jle    8001cf <libmain+0x6a>
		binaryname = argv[0];
  8001bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001bf:	48 8b 10             	mov    (%rax),%rdx
  8001c2:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001c9:	00 00 00 
  8001cc:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001d6:	48 89 d6             	mov    %rdx,%rsi
  8001d9:	89 c7                	mov    %eax,%edi
  8001db:	48 b8 3e 01 80 00 00 	movabs $0x80013e,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001e7:	48 b8 f5 01 80 00 00 	movabs $0x8001f5,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	callq  *%rax
}
  8001f3:	c9                   	leaveq 
  8001f4:	c3                   	retq   

00000000008001f5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f5:	55                   	push   %rbp
  8001f6:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001f9:	48 b8 1a 23 80 00 00 	movabs $0x80231a,%rax
  800200:	00 00 00 
  800203:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800205:	bf 00 00 00 00       	mov    $0x0,%edi
  80020a:	48 b8 61 17 80 00 00 	movabs $0x801761,%rax
  800211:	00 00 00 
  800214:	ff d0                	callq  *%rax
}
  800216:	5d                   	pop    %rbp
  800217:	c3                   	retq   

0000000000800218 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800218:	55                   	push   %rbp
  800219:	48 89 e5             	mov    %rsp,%rbp
  80021c:	48 83 ec 10          	sub    $0x10,%rsp
  800220:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800223:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022b:	8b 00                	mov    (%rax),%eax
  80022d:	8d 48 01             	lea    0x1(%rax),%ecx
  800230:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800234:	89 0a                	mov    %ecx,(%rdx)
  800236:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800239:	89 d1                	mov    %edx,%ecx
  80023b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80023f:	48 98                	cltq   
  800241:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800245:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800249:	8b 00                	mov    (%rax),%eax
  80024b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800250:	75 2c                	jne    80027e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800256:	8b 00                	mov    (%rax),%eax
  800258:	48 98                	cltq   
  80025a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80025e:	48 83 c2 08          	add    $0x8,%rdx
  800262:	48 89 c6             	mov    %rax,%rsi
  800265:	48 89 d7             	mov    %rdx,%rdi
  800268:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  80026f:	00 00 00 
  800272:	ff d0                	callq  *%rax
        b->idx = 0;
  800274:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800278:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80027e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800282:	8b 40 04             	mov    0x4(%rax),%eax
  800285:	8d 50 01             	lea    0x1(%rax),%edx
  800288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80028c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80028f:	c9                   	leaveq 
  800290:	c3                   	retq   

0000000000800291 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800291:	55                   	push   %rbp
  800292:	48 89 e5             	mov    %rsp,%rbp
  800295:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80029c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002a3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002aa:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8002b1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8002b8:	48 8b 0a             	mov    (%rdx),%rcx
  8002bb:	48 89 08             	mov    %rcx,(%rax)
  8002be:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8002c2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8002c6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8002ca:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8002ce:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8002d5:	00 00 00 
    b.cnt = 0;
  8002d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8002df:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8002e2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8002e9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8002f0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8002f7:	48 89 c6             	mov    %rax,%rsi
  8002fa:	48 bf 18 02 80 00 00 	movabs $0x800218,%rdi
  800301:	00 00 00 
  800304:	48 b8 f0 06 80 00 00 	movabs $0x8006f0,%rax
  80030b:	00 00 00 
  80030e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800310:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800316:	48 98                	cltq   
  800318:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80031f:	48 83 c2 08          	add    $0x8,%rdx
  800323:	48 89 c6             	mov    %rax,%rsi
  800326:	48 89 d7             	mov    %rdx,%rdi
  800329:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  800330:	00 00 00 
  800333:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800335:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80033b:	c9                   	leaveq 
  80033c:	c3                   	retq   

000000000080033d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80033d:	55                   	push   %rbp
  80033e:	48 89 e5             	mov    %rsp,%rbp
  800341:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800348:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80034f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800356:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80035d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800364:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80036b:	84 c0                	test   %al,%al
  80036d:	74 20                	je     80038f <cprintf+0x52>
  80036f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800373:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800377:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80037b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80037f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800383:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800387:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80038b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80038f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800396:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80039d:	00 00 00 
  8003a0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003a7:	00 00 00 
  8003aa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003ae:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8003b5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8003bc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8003c3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8003ca:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8003d1:	48 8b 0a             	mov    (%rdx),%rcx
  8003d4:	48 89 08             	mov    %rcx,(%rax)
  8003d7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003db:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003df:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003e3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8003e7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8003ee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003f5:	48 89 d6             	mov    %rdx,%rsi
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 91 02 80 00 00 	movabs $0x800291,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
  800407:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80040d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800413:	c9                   	leaveq 
  800414:	c3                   	retq   

0000000000800415 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800415:	55                   	push   %rbp
  800416:	48 89 e5             	mov    %rsp,%rbp
  800419:	53                   	push   %rbx
  80041a:	48 83 ec 38          	sub    $0x38,%rsp
  80041e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800422:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800426:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80042a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80042d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800431:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800435:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800438:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80043c:	77 3b                	ja     800479 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80043e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800441:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800445:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800448:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80044c:	ba 00 00 00 00       	mov    $0x0,%edx
  800451:	48 f7 f3             	div    %rbx
  800454:	48 89 c2             	mov    %rax,%rdx
  800457:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80045a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80045d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800465:	41 89 f9             	mov    %edi,%r9d
  800468:	48 89 c7             	mov    %rax,%rdi
  80046b:	48 b8 15 04 80 00 00 	movabs $0x800415,%rax
  800472:	00 00 00 
  800475:	ff d0                	callq  *%rax
  800477:	eb 1e                	jmp    800497 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800479:	eb 12                	jmp    80048d <printnum+0x78>
			putch(padc, putdat);
  80047b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80047f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800486:	48 89 ce             	mov    %rcx,%rsi
  800489:	89 d7                	mov    %edx,%edi
  80048b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80048d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800491:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800495:	7f e4                	jg     80047b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800497:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80049a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	48 f7 f1             	div    %rcx
  8004a6:	48 89 d0             	mov    %rdx,%rax
  8004a9:	48 ba 90 3e 80 00 00 	movabs $0x803e90,%rdx
  8004b0:	00 00 00 
  8004b3:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8004b7:	0f be d0             	movsbl %al,%edx
  8004ba:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8004be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004c2:	48 89 ce             	mov    %rcx,%rsi
  8004c5:	89 d7                	mov    %edx,%edi
  8004c7:	ff d0                	callq  *%rax
}
  8004c9:	48 83 c4 38          	add    $0x38,%rsp
  8004cd:	5b                   	pop    %rbx
  8004ce:	5d                   	pop    %rbp
  8004cf:	c3                   	retq   

00000000008004d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004d0:	55                   	push   %rbp
  8004d1:	48 89 e5             	mov    %rsp,%rbp
  8004d4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8004d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004dc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8004df:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8004e3:	7e 52                	jle    800537 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8004e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004e9:	8b 00                	mov    (%rax),%eax
  8004eb:	83 f8 30             	cmp    $0x30,%eax
  8004ee:	73 24                	jae    800514 <getuint+0x44>
  8004f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8004f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fc:	8b 00                	mov    (%rax),%eax
  8004fe:	89 c0                	mov    %eax,%eax
  800500:	48 01 d0             	add    %rdx,%rax
  800503:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800507:	8b 12                	mov    (%rdx),%edx
  800509:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80050c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800510:	89 0a                	mov    %ecx,(%rdx)
  800512:	eb 17                	jmp    80052b <getuint+0x5b>
  800514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800518:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80051c:	48 89 d0             	mov    %rdx,%rax
  80051f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800523:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800527:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80052b:	48 8b 00             	mov    (%rax),%rax
  80052e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800532:	e9 a3 00 00 00       	jmpq   8005da <getuint+0x10a>
	else if (lflag)
  800537:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80053b:	74 4f                	je     80058c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80053d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800541:	8b 00                	mov    (%rax),%eax
  800543:	83 f8 30             	cmp    $0x30,%eax
  800546:	73 24                	jae    80056c <getuint+0x9c>
  800548:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800554:	8b 00                	mov    (%rax),%eax
  800556:	89 c0                	mov    %eax,%eax
  800558:	48 01 d0             	add    %rdx,%rax
  80055b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80055f:	8b 12                	mov    (%rdx),%edx
  800561:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800564:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800568:	89 0a                	mov    %ecx,(%rdx)
  80056a:	eb 17                	jmp    800583 <getuint+0xb3>
  80056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800570:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800574:	48 89 d0             	mov    %rdx,%rax
  800577:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80057b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80057f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800583:	48 8b 00             	mov    (%rax),%rax
  800586:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80058a:	eb 4e                	jmp    8005da <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80058c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800590:	8b 00                	mov    (%rax),%eax
  800592:	83 f8 30             	cmp    $0x30,%eax
  800595:	73 24                	jae    8005bb <getuint+0xeb>
  800597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a3:	8b 00                	mov    (%rax),%eax
  8005a5:	89 c0                	mov    %eax,%eax
  8005a7:	48 01 d0             	add    %rdx,%rax
  8005aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ae:	8b 12                	mov    (%rdx),%edx
  8005b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b7:	89 0a                	mov    %ecx,(%rdx)
  8005b9:	eb 17                	jmp    8005d2 <getuint+0x102>
  8005bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005c3:	48 89 d0             	mov    %rdx,%rax
  8005c6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ce:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005d2:	8b 00                	mov    (%rax),%eax
  8005d4:	89 c0                	mov    %eax,%eax
  8005d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8005da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8005de:	c9                   	leaveq 
  8005df:	c3                   	retq   

00000000008005e0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005e0:	55                   	push   %rbp
  8005e1:	48 89 e5             	mov    %rsp,%rbp
  8005e4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005ec:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8005ef:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005f3:	7e 52                	jle    800647 <getint+0x67>
		x=va_arg(*ap, long long);
  8005f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f9:	8b 00                	mov    (%rax),%eax
  8005fb:	83 f8 30             	cmp    $0x30,%eax
  8005fe:	73 24                	jae    800624 <getint+0x44>
  800600:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800604:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800608:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060c:	8b 00                	mov    (%rax),%eax
  80060e:	89 c0                	mov    %eax,%eax
  800610:	48 01 d0             	add    %rdx,%rax
  800613:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800617:	8b 12                	mov    (%rdx),%edx
  800619:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80061c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800620:	89 0a                	mov    %ecx,(%rdx)
  800622:	eb 17                	jmp    80063b <getint+0x5b>
  800624:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800628:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80062c:	48 89 d0             	mov    %rdx,%rax
  80062f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800633:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800637:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80063b:	48 8b 00             	mov    (%rax),%rax
  80063e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800642:	e9 a3 00 00 00       	jmpq   8006ea <getint+0x10a>
	else if (lflag)
  800647:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80064b:	74 4f                	je     80069c <getint+0xbc>
		x=va_arg(*ap, long);
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	8b 00                	mov    (%rax),%eax
  800653:	83 f8 30             	cmp    $0x30,%eax
  800656:	73 24                	jae    80067c <getint+0x9c>
  800658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	8b 00                	mov    (%rax),%eax
  800666:	89 c0                	mov    %eax,%eax
  800668:	48 01 d0             	add    %rdx,%rax
  80066b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066f:	8b 12                	mov    (%rdx),%edx
  800671:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800674:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800678:	89 0a                	mov    %ecx,(%rdx)
  80067a:	eb 17                	jmp    800693 <getint+0xb3>
  80067c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800680:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800684:	48 89 d0             	mov    %rdx,%rax
  800687:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80068b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800693:	48 8b 00             	mov    (%rax),%rax
  800696:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80069a:	eb 4e                	jmp    8006ea <getint+0x10a>
	else
		x=va_arg(*ap, int);
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	8b 00                	mov    (%rax),%eax
  8006a2:	83 f8 30             	cmp    $0x30,%eax
  8006a5:	73 24                	jae    8006cb <getint+0xeb>
  8006a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ab:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b3:	8b 00                	mov    (%rax),%eax
  8006b5:	89 c0                	mov    %eax,%eax
  8006b7:	48 01 d0             	add    %rdx,%rax
  8006ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006be:	8b 12                	mov    (%rdx),%edx
  8006c0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c7:	89 0a                	mov    %ecx,(%rdx)
  8006c9:	eb 17                	jmp    8006e2 <getint+0x102>
  8006cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d3:	48 89 d0             	mov    %rdx,%rax
  8006d6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006e2:	8b 00                	mov    (%rax),%eax
  8006e4:	48 98                	cltq   
  8006e6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006ee:	c9                   	leaveq 
  8006ef:	c3                   	retq   

00000000008006f0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006f0:	55                   	push   %rbp
  8006f1:	48 89 e5             	mov    %rsp,%rbp
  8006f4:	41 54                	push   %r12
  8006f6:	53                   	push   %rbx
  8006f7:	48 83 ec 60          	sub    $0x60,%rsp
  8006fb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8006ff:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800703:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800707:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80070b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80070f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800713:	48 8b 0a             	mov    (%rdx),%rcx
  800716:	48 89 08             	mov    %rcx,(%rax)
  800719:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80071d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800721:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800725:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800729:	eb 17                	jmp    800742 <vprintfmt+0x52>
			if (ch == '\0')
  80072b:	85 db                	test   %ebx,%ebx
  80072d:	0f 84 cc 04 00 00    	je     800bff <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800733:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800737:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80073b:	48 89 d6             	mov    %rdx,%rsi
  80073e:	89 df                	mov    %ebx,%edi
  800740:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800742:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800746:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80074a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80074e:	0f b6 00             	movzbl (%rax),%eax
  800751:	0f b6 d8             	movzbl %al,%ebx
  800754:	83 fb 25             	cmp    $0x25,%ebx
  800757:	75 d2                	jne    80072b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800759:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80075d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800764:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80076b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800772:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800779:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80077d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800781:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800785:	0f b6 00             	movzbl (%rax),%eax
  800788:	0f b6 d8             	movzbl %al,%ebx
  80078b:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80078e:	83 f8 55             	cmp    $0x55,%eax
  800791:	0f 87 34 04 00 00    	ja     800bcb <vprintfmt+0x4db>
  800797:	89 c0                	mov    %eax,%eax
  800799:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007a0:	00 
  8007a1:	48 b8 b8 3e 80 00 00 	movabs $0x803eb8,%rax
  8007a8:	00 00 00 
  8007ab:	48 01 d0             	add    %rdx,%rax
  8007ae:	48 8b 00             	mov    (%rax),%rax
  8007b1:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8007b3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007b7:	eb c0                	jmp    800779 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007b9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007bd:	eb ba                	jmp    800779 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8007c6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8007c9:	89 d0                	mov    %edx,%eax
  8007cb:	c1 e0 02             	shl    $0x2,%eax
  8007ce:	01 d0                	add    %edx,%eax
  8007d0:	01 c0                	add    %eax,%eax
  8007d2:	01 d8                	add    %ebx,%eax
  8007d4:	83 e8 30             	sub    $0x30,%eax
  8007d7:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8007da:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007de:	0f b6 00             	movzbl (%rax),%eax
  8007e1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e7:	7e 0c                	jle    8007f5 <vprintfmt+0x105>
  8007e9:	83 fb 39             	cmp    $0x39,%ebx
  8007ec:	7f 07                	jg     8007f5 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ee:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f3:	eb d1                	jmp    8007c6 <vprintfmt+0xd6>
			goto process_precision;
  8007f5:	eb 58                	jmp    80084f <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8007f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8007fa:	83 f8 30             	cmp    $0x30,%eax
  8007fd:	73 17                	jae    800816 <vprintfmt+0x126>
  8007ff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800803:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800806:	89 c0                	mov    %eax,%eax
  800808:	48 01 d0             	add    %rdx,%rax
  80080b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80080e:	83 c2 08             	add    $0x8,%edx
  800811:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800814:	eb 0f                	jmp    800825 <vprintfmt+0x135>
  800816:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80081a:	48 89 d0             	mov    %rdx,%rax
  80081d:	48 83 c2 08          	add    $0x8,%rdx
  800821:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800825:	8b 00                	mov    (%rax),%eax
  800827:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80082a:	eb 23                	jmp    80084f <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80082c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800830:	79 0c                	jns    80083e <vprintfmt+0x14e>
				width = 0;
  800832:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800839:	e9 3b ff ff ff       	jmpq   800779 <vprintfmt+0x89>
  80083e:	e9 36 ff ff ff       	jmpq   800779 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800843:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80084a:	e9 2a ff ff ff       	jmpq   800779 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80084f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800853:	79 12                	jns    800867 <vprintfmt+0x177>
				width = precision, precision = -1;
  800855:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800858:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80085b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800862:	e9 12 ff ff ff       	jmpq   800779 <vprintfmt+0x89>
  800867:	e9 0d ff ff ff       	jmpq   800779 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80086c:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800870:	e9 04 ff ff ff       	jmpq   800779 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800875:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800878:	83 f8 30             	cmp    $0x30,%eax
  80087b:	73 17                	jae    800894 <vprintfmt+0x1a4>
  80087d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800881:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800884:	89 c0                	mov    %eax,%eax
  800886:	48 01 d0             	add    %rdx,%rax
  800889:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80088c:	83 c2 08             	add    $0x8,%edx
  80088f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800892:	eb 0f                	jmp    8008a3 <vprintfmt+0x1b3>
  800894:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800898:	48 89 d0             	mov    %rdx,%rax
  80089b:	48 83 c2 08          	add    $0x8,%rdx
  80089f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008a3:	8b 10                	mov    (%rax),%edx
  8008a5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008a9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008ad:	48 89 ce             	mov    %rcx,%rsi
  8008b0:	89 d7                	mov    %edx,%edi
  8008b2:	ff d0                	callq  *%rax
			break;
  8008b4:	e9 40 03 00 00       	jmpq   800bf9 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8008b9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008bc:	83 f8 30             	cmp    $0x30,%eax
  8008bf:	73 17                	jae    8008d8 <vprintfmt+0x1e8>
  8008c1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8008c5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008c8:	89 c0                	mov    %eax,%eax
  8008ca:	48 01 d0             	add    %rdx,%rax
  8008cd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008d0:	83 c2 08             	add    $0x8,%edx
  8008d3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008d6:	eb 0f                	jmp    8008e7 <vprintfmt+0x1f7>
  8008d8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008dc:	48 89 d0             	mov    %rdx,%rax
  8008df:	48 83 c2 08          	add    $0x8,%rdx
  8008e3:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008e7:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8008e9:	85 db                	test   %ebx,%ebx
  8008eb:	79 02                	jns    8008ef <vprintfmt+0x1ff>
				err = -err;
  8008ed:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008ef:	83 fb 15             	cmp    $0x15,%ebx
  8008f2:	7f 16                	jg     80090a <vprintfmt+0x21a>
  8008f4:	48 b8 e0 3d 80 00 00 	movabs $0x803de0,%rax
  8008fb:	00 00 00 
  8008fe:	48 63 d3             	movslq %ebx,%rdx
  800901:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800905:	4d 85 e4             	test   %r12,%r12
  800908:	75 2e                	jne    800938 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  80090a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80090e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800912:	89 d9                	mov    %ebx,%ecx
  800914:	48 ba a1 3e 80 00 00 	movabs $0x803ea1,%rdx
  80091b:	00 00 00 
  80091e:	48 89 c7             	mov    %rax,%rdi
  800921:	b8 00 00 00 00       	mov    $0x0,%eax
  800926:	49 b8 08 0c 80 00 00 	movabs $0x800c08,%r8
  80092d:	00 00 00 
  800930:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800933:	e9 c1 02 00 00       	jmpq   800bf9 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800938:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80093c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800940:	4c 89 e1             	mov    %r12,%rcx
  800943:	48 ba aa 3e 80 00 00 	movabs $0x803eaa,%rdx
  80094a:	00 00 00 
  80094d:	48 89 c7             	mov    %rax,%rdi
  800950:	b8 00 00 00 00       	mov    $0x0,%eax
  800955:	49 b8 08 0c 80 00 00 	movabs $0x800c08,%r8
  80095c:	00 00 00 
  80095f:	41 ff d0             	callq  *%r8
			break;
  800962:	e9 92 02 00 00       	jmpq   800bf9 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800967:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80096a:	83 f8 30             	cmp    $0x30,%eax
  80096d:	73 17                	jae    800986 <vprintfmt+0x296>
  80096f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800973:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800976:	89 c0                	mov    %eax,%eax
  800978:	48 01 d0             	add    %rdx,%rax
  80097b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80097e:	83 c2 08             	add    $0x8,%edx
  800981:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800984:	eb 0f                	jmp    800995 <vprintfmt+0x2a5>
  800986:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80098a:	48 89 d0             	mov    %rdx,%rax
  80098d:	48 83 c2 08          	add    $0x8,%rdx
  800991:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800995:	4c 8b 20             	mov    (%rax),%r12
  800998:	4d 85 e4             	test   %r12,%r12
  80099b:	75 0a                	jne    8009a7 <vprintfmt+0x2b7>
				p = "(null)";
  80099d:	49 bc ad 3e 80 00 00 	movabs $0x803ead,%r12
  8009a4:	00 00 00 
			if (width > 0 && padc != '-')
  8009a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ab:	7e 3f                	jle    8009ec <vprintfmt+0x2fc>
  8009ad:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009b1:	74 39                	je     8009ec <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009b6:	48 98                	cltq   
  8009b8:	48 89 c6             	mov    %rax,%rsi
  8009bb:	4c 89 e7             	mov    %r12,%rdi
  8009be:	48 b8 b4 0e 80 00 00 	movabs $0x800eb4,%rax
  8009c5:	00 00 00 
  8009c8:	ff d0                	callq  *%rax
  8009ca:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009cd:	eb 17                	jmp    8009e6 <vprintfmt+0x2f6>
					putch(padc, putdat);
  8009cf:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8009d3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009d7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009db:	48 89 ce             	mov    %rcx,%rsi
  8009de:	89 d7                	mov    %edx,%edi
  8009e0:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e2:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8009e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009ea:	7f e3                	jg     8009cf <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ec:	eb 37                	jmp    800a25 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  8009ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8009f2:	74 1e                	je     800a12 <vprintfmt+0x322>
  8009f4:	83 fb 1f             	cmp    $0x1f,%ebx
  8009f7:	7e 05                	jle    8009fe <vprintfmt+0x30e>
  8009f9:	83 fb 7e             	cmp    $0x7e,%ebx
  8009fc:	7e 14                	jle    800a12 <vprintfmt+0x322>
					putch('?', putdat);
  8009fe:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a02:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a06:	48 89 d6             	mov    %rdx,%rsi
  800a09:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a0e:	ff d0                	callq  *%rax
  800a10:	eb 0f                	jmp    800a21 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800a12:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1a:	48 89 d6             	mov    %rdx,%rsi
  800a1d:	89 df                	mov    %ebx,%edi
  800a1f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a21:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a25:	4c 89 e0             	mov    %r12,%rax
  800a28:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a2c:	0f b6 00             	movzbl (%rax),%eax
  800a2f:	0f be d8             	movsbl %al,%ebx
  800a32:	85 db                	test   %ebx,%ebx
  800a34:	74 10                	je     800a46 <vprintfmt+0x356>
  800a36:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a3a:	78 b2                	js     8009ee <vprintfmt+0x2fe>
  800a3c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a40:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a44:	79 a8                	jns    8009ee <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a46:	eb 16                	jmp    800a5e <vprintfmt+0x36e>
				putch(' ', putdat);
  800a48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a50:	48 89 d6             	mov    %rdx,%rsi
  800a53:	bf 20 00 00 00       	mov    $0x20,%edi
  800a58:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a5a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a62:	7f e4                	jg     800a48 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800a64:	e9 90 01 00 00       	jmpq   800bf9 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a69:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a6d:	be 03 00 00 00       	mov    $0x3,%esi
  800a72:	48 89 c7             	mov    %rax,%rdi
  800a75:	48 b8 e0 05 80 00 00 	movabs $0x8005e0,%rax
  800a7c:	00 00 00 
  800a7f:	ff d0                	callq  *%rax
  800a81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800a85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a89:	48 85 c0             	test   %rax,%rax
  800a8c:	79 1d                	jns    800aab <vprintfmt+0x3bb>
				putch('-', putdat);
  800a8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a92:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a96:	48 89 d6             	mov    %rdx,%rsi
  800a99:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800a9e:	ff d0                	callq  *%rax
				num = -(long long) num;
  800aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa4:	48 f7 d8             	neg    %rax
  800aa7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800aab:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ab2:	e9 d5 00 00 00       	jmpq   800b8c <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ab7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800abb:	be 03 00 00 00       	mov    $0x3,%esi
  800ac0:	48 89 c7             	mov    %rax,%rdi
  800ac3:	48 b8 d0 04 80 00 00 	movabs $0x8004d0,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ad3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ada:	e9 ad 00 00 00       	jmpq   800b8c <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800adf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ae3:	be 03 00 00 00       	mov    $0x3,%esi
  800ae8:	48 89 c7             	mov    %rax,%rdi
  800aeb:	48 b8 d0 04 80 00 00 	movabs $0x8004d0,%rax
  800af2:	00 00 00 
  800af5:	ff d0                	callq  *%rax
  800af7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800afb:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800b02:	e9 85 00 00 00       	jmpq   800b8c <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800b07:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0f:	48 89 d6             	mov    %rdx,%rsi
  800b12:	bf 30 00 00 00       	mov    $0x30,%edi
  800b17:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b21:	48 89 d6             	mov    %rdx,%rsi
  800b24:	bf 78 00 00 00       	mov    $0x78,%edi
  800b29:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b2b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b2e:	83 f8 30             	cmp    $0x30,%eax
  800b31:	73 17                	jae    800b4a <vprintfmt+0x45a>
  800b33:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b37:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b3a:	89 c0                	mov    %eax,%eax
  800b3c:	48 01 d0             	add    %rdx,%rax
  800b3f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b42:	83 c2 08             	add    $0x8,%edx
  800b45:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b48:	eb 0f                	jmp    800b59 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800b4a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b4e:	48 89 d0             	mov    %rdx,%rax
  800b51:	48 83 c2 08          	add    $0x8,%rdx
  800b55:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b59:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b5c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b60:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b67:	eb 23                	jmp    800b8c <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b69:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b6d:	be 03 00 00 00       	mov    $0x3,%esi
  800b72:	48 89 c7             	mov    %rax,%rdi
  800b75:	48 b8 d0 04 80 00 00 	movabs $0x8004d0,%rax
  800b7c:	00 00 00 
  800b7f:	ff d0                	callq  *%rax
  800b81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800b85:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b8c:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800b91:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800b94:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800b97:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b9b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba3:	45 89 c1             	mov    %r8d,%r9d
  800ba6:	41 89 f8             	mov    %edi,%r8d
  800ba9:	48 89 c7             	mov    %rax,%rdi
  800bac:	48 b8 15 04 80 00 00 	movabs $0x800415,%rax
  800bb3:	00 00 00 
  800bb6:	ff d0                	callq  *%rax
			break;
  800bb8:	eb 3f                	jmp    800bf9 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bba:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bbe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc2:	48 89 d6             	mov    %rdx,%rsi
  800bc5:	89 df                	mov    %ebx,%edi
  800bc7:	ff d0                	callq  *%rax
			break;
  800bc9:	eb 2e                	jmp    800bf9 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bcb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bcf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd3:	48 89 d6             	mov    %rdx,%rsi
  800bd6:	bf 25 00 00 00       	mov    $0x25,%edi
  800bdb:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bdd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800be2:	eb 05                	jmp    800be9 <vprintfmt+0x4f9>
  800be4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800be9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bed:	48 83 e8 01          	sub    $0x1,%rax
  800bf1:	0f b6 00             	movzbl (%rax),%eax
  800bf4:	3c 25                	cmp    $0x25,%al
  800bf6:	75 ec                	jne    800be4 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800bf8:	90                   	nop
		}
	}
  800bf9:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bfa:	e9 43 fb ff ff       	jmpq   800742 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800bff:	48 83 c4 60          	add    $0x60,%rsp
  800c03:	5b                   	pop    %rbx
  800c04:	41 5c                	pop    %r12
  800c06:	5d                   	pop    %rbp
  800c07:	c3                   	retq   

0000000000800c08 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c08:	55                   	push   %rbp
  800c09:	48 89 e5             	mov    %rsp,%rbp
  800c0c:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c13:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c1a:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c21:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c28:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c2f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c36:	84 c0                	test   %al,%al
  800c38:	74 20                	je     800c5a <printfmt+0x52>
  800c3a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c3e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c42:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c46:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c4a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c4e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c52:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c56:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800c5a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c61:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c68:	00 00 00 
  800c6b:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800c72:	00 00 00 
  800c75:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c79:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800c80:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800c87:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800c8e:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800c95:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800c9c:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800ca3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800caa:	48 89 c7             	mov    %rax,%rdi
  800cad:	48 b8 f0 06 80 00 00 	movabs $0x8006f0,%rax
  800cb4:	00 00 00 
  800cb7:	ff d0                	callq  *%rax
	va_end(ap);
}
  800cb9:	c9                   	leaveq 
  800cba:	c3                   	retq   

0000000000800cbb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cbb:	55                   	push   %rbp
  800cbc:	48 89 e5             	mov    %rsp,%rbp
  800cbf:	48 83 ec 10          	sub    $0x10,%rsp
  800cc3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cce:	8b 40 10             	mov    0x10(%rax),%eax
  800cd1:	8d 50 01             	lea    0x1(%rax),%edx
  800cd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd8:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800cdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cdf:	48 8b 10             	mov    (%rax),%rdx
  800ce2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ce6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800cea:	48 39 c2             	cmp    %rax,%rdx
  800ced:	73 17                	jae    800d06 <sprintputch+0x4b>
		*b->buf++ = ch;
  800cef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cf3:	48 8b 00             	mov    (%rax),%rax
  800cf6:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800cfa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cfe:	48 89 0a             	mov    %rcx,(%rdx)
  800d01:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d04:	88 10                	mov    %dl,(%rax)
}
  800d06:	c9                   	leaveq 
  800d07:	c3                   	retq   

0000000000800d08 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d08:	55                   	push   %rbp
  800d09:	48 89 e5             	mov    %rsp,%rbp
  800d0c:	48 83 ec 50          	sub    $0x50,%rsp
  800d10:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d14:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d17:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d1b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d1f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d23:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d27:	48 8b 0a             	mov    (%rdx),%rcx
  800d2a:	48 89 08             	mov    %rcx,(%rax)
  800d2d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d31:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d35:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d39:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d3d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d41:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d45:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d48:	48 98                	cltq   
  800d4a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d52:	48 01 d0             	add    %rdx,%rax
  800d55:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d59:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d60:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d65:	74 06                	je     800d6d <vsnprintf+0x65>
  800d67:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d6b:	7f 07                	jg     800d74 <vsnprintf+0x6c>
		return -E_INVAL;
  800d6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d72:	eb 2f                	jmp    800da3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800d74:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800d78:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800d7c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800d80:	48 89 c6             	mov    %rax,%rsi
  800d83:	48 bf bb 0c 80 00 00 	movabs $0x800cbb,%rdi
  800d8a:	00 00 00 
  800d8d:	48 b8 f0 06 80 00 00 	movabs $0x8006f0,%rax
  800d94:	00 00 00 
  800d97:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800d99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800d9d:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800da0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800da3:	c9                   	leaveq 
  800da4:	c3                   	retq   

0000000000800da5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da5:	55                   	push   %rbp
  800da6:	48 89 e5             	mov    %rsp,%rbp
  800da9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800db0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800db7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800dbd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dc4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800dcb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800dd2:	84 c0                	test   %al,%al
  800dd4:	74 20                	je     800df6 <snprintf+0x51>
  800dd6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800dda:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800dde:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800de2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800de6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dea:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800dee:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800df2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800df6:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800dfd:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e04:	00 00 00 
  800e07:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e0e:	00 00 00 
  800e11:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e15:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e1c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e23:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e2a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e31:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e38:	48 8b 0a             	mov    (%rdx),%rcx
  800e3b:	48 89 08             	mov    %rcx,(%rax)
  800e3e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e42:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e46:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e4a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e4e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e55:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e5c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e62:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e69:	48 89 c7             	mov    %rax,%rdi
  800e6c:	48 b8 08 0d 80 00 00 	movabs $0x800d08,%rax
  800e73:	00 00 00 
  800e76:	ff d0                	callq  *%rax
  800e78:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800e7e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e84:	c9                   	leaveq 
  800e85:	c3                   	retq   

0000000000800e86 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e86:	55                   	push   %rbp
  800e87:	48 89 e5             	mov    %rsp,%rbp
  800e8a:	48 83 ec 18          	sub    $0x18,%rsp
  800e8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800e92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e99:	eb 09                	jmp    800ea4 <strlen+0x1e>
		n++;
  800e9b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ea4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea8:	0f b6 00             	movzbl (%rax),%eax
  800eab:	84 c0                	test   %al,%al
  800ead:	75 ec                	jne    800e9b <strlen+0x15>
		n++;
	return n;
  800eaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800eb2:	c9                   	leaveq 
  800eb3:	c3                   	retq   

0000000000800eb4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800eb4:	55                   	push   %rbp
  800eb5:	48 89 e5             	mov    %rsp,%rbp
  800eb8:	48 83 ec 20          	sub    $0x20,%rsp
  800ebc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ec0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ecb:	eb 0e                	jmp    800edb <strnlen+0x27>
		n++;
  800ecd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ed1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ed6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800edb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800ee0:	74 0b                	je     800eed <strnlen+0x39>
  800ee2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee6:	0f b6 00             	movzbl (%rax),%eax
  800ee9:	84 c0                	test   %al,%al
  800eeb:	75 e0                	jne    800ecd <strnlen+0x19>
		n++;
	return n;
  800eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ef0:	c9                   	leaveq 
  800ef1:	c3                   	retq   

0000000000800ef2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ef2:	55                   	push   %rbp
  800ef3:	48 89 e5             	mov    %rsp,%rbp
  800ef6:	48 83 ec 20          	sub    $0x20,%rsp
  800efa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800efe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f0a:	90                   	nop
  800f0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f13:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f17:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f1b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f1f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f23:	0f b6 12             	movzbl (%rdx),%edx
  800f26:	88 10                	mov    %dl,(%rax)
  800f28:	0f b6 00             	movzbl (%rax),%eax
  800f2b:	84 c0                	test   %al,%al
  800f2d:	75 dc                	jne    800f0b <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f33:	c9                   	leaveq 
  800f34:	c3                   	retq   

0000000000800f35 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f35:	55                   	push   %rbp
  800f36:	48 89 e5             	mov    %rsp,%rbp
  800f39:	48 83 ec 20          	sub    $0x20,%rsp
  800f3d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f41:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f45:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f49:	48 89 c7             	mov    %rax,%rdi
  800f4c:	48 b8 86 0e 80 00 00 	movabs $0x800e86,%rax
  800f53:	00 00 00 
  800f56:	ff d0                	callq  *%rax
  800f58:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f5e:	48 63 d0             	movslq %eax,%rdx
  800f61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f65:	48 01 c2             	add    %rax,%rdx
  800f68:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f6c:	48 89 c6             	mov    %rax,%rsi
  800f6f:	48 89 d7             	mov    %rdx,%rdi
  800f72:	48 b8 f2 0e 80 00 00 	movabs $0x800ef2,%rax
  800f79:	00 00 00 
  800f7c:	ff d0                	callq  *%rax
	return dst;
  800f7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800f82:	c9                   	leaveq 
  800f83:	c3                   	retq   

0000000000800f84 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f84:	55                   	push   %rbp
  800f85:	48 89 e5             	mov    %rsp,%rbp
  800f88:	48 83 ec 28          	sub    $0x28,%rsp
  800f8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800f94:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800fa0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800fa7:	00 
  800fa8:	eb 2a                	jmp    800fd4 <strncpy+0x50>
		*dst++ = *src;
  800faa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fae:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fb2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fb6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fba:	0f b6 12             	movzbl (%rdx),%edx
  800fbd:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fbf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800fc3:	0f b6 00             	movzbl (%rax),%eax
  800fc6:	84 c0                	test   %al,%al
  800fc8:	74 05                	je     800fcf <strncpy+0x4b>
			src++;
  800fca:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fcf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800fd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fd8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800fdc:	72 cc                	jb     800faa <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800fe2:	c9                   	leaveq 
  800fe3:	c3                   	retq   

0000000000800fe4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fe4:	55                   	push   %rbp
  800fe5:	48 89 e5             	mov    %rsp,%rbp
  800fe8:	48 83 ec 28          	sub    $0x28,%rsp
  800fec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ff0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800ff4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  800ff8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801000:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801005:	74 3d                	je     801044 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801007:	eb 1d                	jmp    801026 <strlcpy+0x42>
			*dst++ = *src++;
  801009:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801011:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801015:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801019:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80101d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801021:	0f b6 12             	movzbl (%rdx),%edx
  801024:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801026:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80102b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801030:	74 0b                	je     80103d <strlcpy+0x59>
  801032:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801036:	0f b6 00             	movzbl (%rax),%eax
  801039:	84 c0                	test   %al,%al
  80103b:	75 cc                	jne    801009 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80103d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801041:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801044:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80104c:	48 29 c2             	sub    %rax,%rdx
  80104f:	48 89 d0             	mov    %rdx,%rax
}
  801052:	c9                   	leaveq 
  801053:	c3                   	retq   

0000000000801054 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801054:	55                   	push   %rbp
  801055:	48 89 e5             	mov    %rsp,%rbp
  801058:	48 83 ec 10          	sub    $0x10,%rsp
  80105c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801060:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801064:	eb 0a                	jmp    801070 <strcmp+0x1c>
		p++, q++;
  801066:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80106b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801070:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801074:	0f b6 00             	movzbl (%rax),%eax
  801077:	84 c0                	test   %al,%al
  801079:	74 12                	je     80108d <strcmp+0x39>
  80107b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107f:	0f b6 10             	movzbl (%rax),%edx
  801082:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801086:	0f b6 00             	movzbl (%rax),%eax
  801089:	38 c2                	cmp    %al,%dl
  80108b:	74 d9                	je     801066 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80108d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801091:	0f b6 00             	movzbl (%rax),%eax
  801094:	0f b6 d0             	movzbl %al,%edx
  801097:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80109b:	0f b6 00             	movzbl (%rax),%eax
  80109e:	0f b6 c0             	movzbl %al,%eax
  8010a1:	29 c2                	sub    %eax,%edx
  8010a3:	89 d0                	mov    %edx,%eax
}
  8010a5:	c9                   	leaveq 
  8010a6:	c3                   	retq   

00000000008010a7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010a7:	55                   	push   %rbp
  8010a8:	48 89 e5             	mov    %rsp,%rbp
  8010ab:	48 83 ec 18          	sub    $0x18,%rsp
  8010af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010bb:	eb 0f                	jmp    8010cc <strncmp+0x25>
		n--, p++, q++;
  8010bd:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010c2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010c7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010cc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010d1:	74 1d                	je     8010f0 <strncmp+0x49>
  8010d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010d7:	0f b6 00             	movzbl (%rax),%eax
  8010da:	84 c0                	test   %al,%al
  8010dc:	74 12                	je     8010f0 <strncmp+0x49>
  8010de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e2:	0f b6 10             	movzbl (%rax),%edx
  8010e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e9:	0f b6 00             	movzbl (%rax),%eax
  8010ec:	38 c2                	cmp    %al,%dl
  8010ee:	74 cd                	je     8010bd <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8010f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8010f5:	75 07                	jne    8010fe <strncmp+0x57>
		return 0;
  8010f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fc:	eb 18                	jmp    801116 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801102:	0f b6 00             	movzbl (%rax),%eax
  801105:	0f b6 d0             	movzbl %al,%edx
  801108:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110c:	0f b6 00             	movzbl (%rax),%eax
  80110f:	0f b6 c0             	movzbl %al,%eax
  801112:	29 c2                	sub    %eax,%edx
  801114:	89 d0                	mov    %edx,%eax
}
  801116:	c9                   	leaveq 
  801117:	c3                   	retq   

0000000000801118 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801118:	55                   	push   %rbp
  801119:	48 89 e5             	mov    %rsp,%rbp
  80111c:	48 83 ec 0c          	sub    $0xc,%rsp
  801120:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801124:	89 f0                	mov    %esi,%eax
  801126:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801129:	eb 17                	jmp    801142 <strchr+0x2a>
		if (*s == c)
  80112b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80112f:	0f b6 00             	movzbl (%rax),%eax
  801132:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801135:	75 06                	jne    80113d <strchr+0x25>
			return (char *) s;
  801137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80113b:	eb 15                	jmp    801152 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80113d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801142:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801146:	0f b6 00             	movzbl (%rax),%eax
  801149:	84 c0                	test   %al,%al
  80114b:	75 de                	jne    80112b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80114d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801152:	c9                   	leaveq 
  801153:	c3                   	retq   

0000000000801154 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801154:	55                   	push   %rbp
  801155:	48 89 e5             	mov    %rsp,%rbp
  801158:	48 83 ec 0c          	sub    $0xc,%rsp
  80115c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801160:	89 f0                	mov    %esi,%eax
  801162:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801165:	eb 13                	jmp    80117a <strfind+0x26>
		if (*s == c)
  801167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116b:	0f b6 00             	movzbl (%rax),%eax
  80116e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801171:	75 02                	jne    801175 <strfind+0x21>
			break;
  801173:	eb 10                	jmp    801185 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801175:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80117a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117e:	0f b6 00             	movzbl (%rax),%eax
  801181:	84 c0                	test   %al,%al
  801183:	75 e2                	jne    801167 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801185:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801189:	c9                   	leaveq 
  80118a:	c3                   	retq   

000000000080118b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80118b:	55                   	push   %rbp
  80118c:	48 89 e5             	mov    %rsp,%rbp
  80118f:	48 83 ec 18          	sub    $0x18,%rsp
  801193:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801197:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80119a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80119e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011a3:	75 06                	jne    8011ab <memset+0x20>
		return v;
  8011a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a9:	eb 69                	jmp    801214 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011af:	83 e0 03             	and    $0x3,%eax
  8011b2:	48 85 c0             	test   %rax,%rax
  8011b5:	75 48                	jne    8011ff <memset+0x74>
  8011b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bb:	83 e0 03             	and    $0x3,%eax
  8011be:	48 85 c0             	test   %rax,%rax
  8011c1:	75 3c                	jne    8011ff <memset+0x74>
		c &= 0xFF;
  8011c3:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011cd:	c1 e0 18             	shl    $0x18,%eax
  8011d0:	89 c2                	mov    %eax,%edx
  8011d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011d5:	c1 e0 10             	shl    $0x10,%eax
  8011d8:	09 c2                	or     %eax,%edx
  8011da:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011dd:	c1 e0 08             	shl    $0x8,%eax
  8011e0:	09 d0                	or     %edx,%eax
  8011e2:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8011e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e9:	48 c1 e8 02          	shr    $0x2,%rax
  8011ed:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011f0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8011f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011f7:	48 89 d7             	mov    %rdx,%rdi
  8011fa:	fc                   	cld    
  8011fb:	f3 ab                	rep stos %eax,%es:(%rdi)
  8011fd:	eb 11                	jmp    801210 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011ff:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801203:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801206:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80120a:	48 89 d7             	mov    %rdx,%rdi
  80120d:	fc                   	cld    
  80120e:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801214:	c9                   	leaveq 
  801215:	c3                   	retq   

0000000000801216 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801216:	55                   	push   %rbp
  801217:	48 89 e5             	mov    %rsp,%rbp
  80121a:	48 83 ec 28          	sub    $0x28,%rsp
  80121e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801222:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801226:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80122a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80122e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801232:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801236:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80123a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801242:	0f 83 88 00 00 00    	jae    8012d0 <memmove+0xba>
  801248:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80124c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801250:	48 01 d0             	add    %rdx,%rax
  801253:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801257:	76 77                	jbe    8012d0 <memmove+0xba>
		s += n;
  801259:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80125d:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801261:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801265:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126d:	83 e0 03             	and    $0x3,%eax
  801270:	48 85 c0             	test   %rax,%rax
  801273:	75 3b                	jne    8012b0 <memmove+0x9a>
  801275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801279:	83 e0 03             	and    $0x3,%eax
  80127c:	48 85 c0             	test   %rax,%rax
  80127f:	75 2f                	jne    8012b0 <memmove+0x9a>
  801281:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801285:	83 e0 03             	and    $0x3,%eax
  801288:	48 85 c0             	test   %rax,%rax
  80128b:	75 23                	jne    8012b0 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80128d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801291:	48 83 e8 04          	sub    $0x4,%rax
  801295:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801299:	48 83 ea 04          	sub    $0x4,%rdx
  80129d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012a1:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012a5:	48 89 c7             	mov    %rax,%rdi
  8012a8:	48 89 d6             	mov    %rdx,%rsi
  8012ab:	fd                   	std    
  8012ac:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012ae:	eb 1d                	jmp    8012cd <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012b4:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bc:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c4:	48 89 d7             	mov    %rdx,%rdi
  8012c7:	48 89 c1             	mov    %rax,%rcx
  8012ca:	fd                   	std    
  8012cb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012cd:	fc                   	cld    
  8012ce:	eb 57                	jmp    801327 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d4:	83 e0 03             	and    $0x3,%eax
  8012d7:	48 85 c0             	test   %rax,%rax
  8012da:	75 36                	jne    801312 <memmove+0xfc>
  8012dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e0:	83 e0 03             	and    $0x3,%eax
  8012e3:	48 85 c0             	test   %rax,%rax
  8012e6:	75 2a                	jne    801312 <memmove+0xfc>
  8012e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012ec:	83 e0 03             	and    $0x3,%eax
  8012ef:	48 85 c0             	test   %rax,%rax
  8012f2:	75 1e                	jne    801312 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8012f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f8:	48 c1 e8 02          	shr    $0x2,%rax
  8012fc:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8012ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801303:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801307:	48 89 c7             	mov    %rax,%rdi
  80130a:	48 89 d6             	mov    %rdx,%rsi
  80130d:	fc                   	cld    
  80130e:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801310:	eb 15                	jmp    801327 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801312:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801316:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80131a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80131e:	48 89 c7             	mov    %rax,%rdi
  801321:	48 89 d6             	mov    %rdx,%rsi
  801324:	fc                   	cld    
  801325:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80132b:	c9                   	leaveq 
  80132c:	c3                   	retq   

000000000080132d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80132d:	55                   	push   %rbp
  80132e:	48 89 e5             	mov    %rsp,%rbp
  801331:	48 83 ec 18          	sub    $0x18,%rsp
  801335:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801339:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80133d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801341:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801345:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134d:	48 89 ce             	mov    %rcx,%rsi
  801350:	48 89 c7             	mov    %rax,%rdi
  801353:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  80135a:	00 00 00 
  80135d:	ff d0                	callq  *%rax
}
  80135f:	c9                   	leaveq 
  801360:	c3                   	retq   

0000000000801361 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801361:	55                   	push   %rbp
  801362:	48 89 e5             	mov    %rsp,%rbp
  801365:	48 83 ec 28          	sub    $0x28,%rsp
  801369:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80136d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801371:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801379:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80137d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801381:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801385:	eb 36                	jmp    8013bd <memcmp+0x5c>
		if (*s1 != *s2)
  801387:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80138b:	0f b6 10             	movzbl (%rax),%edx
  80138e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801392:	0f b6 00             	movzbl (%rax),%eax
  801395:	38 c2                	cmp    %al,%dl
  801397:	74 1a                	je     8013b3 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	0f b6 00             	movzbl (%rax),%eax
  8013a0:	0f b6 d0             	movzbl %al,%edx
  8013a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a7:	0f b6 00             	movzbl (%rax),%eax
  8013aa:	0f b6 c0             	movzbl %al,%eax
  8013ad:	29 c2                	sub    %eax,%edx
  8013af:	89 d0                	mov    %edx,%eax
  8013b1:	eb 20                	jmp    8013d3 <memcmp+0x72>
		s1++, s2++;
  8013b3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013b8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013c5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013c9:	48 85 c0             	test   %rax,%rax
  8013cc:	75 b9                	jne    801387 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d3:	c9                   	leaveq 
  8013d4:	c3                   	retq   

00000000008013d5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8013d5:	55                   	push   %rbp
  8013d6:	48 89 e5             	mov    %rsp,%rbp
  8013d9:	48 83 ec 28          	sub    $0x28,%rsp
  8013dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8013e4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8013e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013f0:	48 01 d0             	add    %rdx,%rax
  8013f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8013f7:	eb 15                	jmp    80140e <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013fd:	0f b6 10             	movzbl (%rax),%edx
  801400:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801403:	38 c2                	cmp    %al,%dl
  801405:	75 02                	jne    801409 <memfind+0x34>
			break;
  801407:	eb 0f                	jmp    801418 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801409:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80140e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801412:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801416:	72 e1                	jb     8013f9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801418:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80141c:	c9                   	leaveq 
  80141d:	c3                   	retq   

000000000080141e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80141e:	55                   	push   %rbp
  80141f:	48 89 e5             	mov    %rsp,%rbp
  801422:	48 83 ec 34          	sub    $0x34,%rsp
  801426:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80142a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80142e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801431:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801438:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80143f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801440:	eb 05                	jmp    801447 <strtol+0x29>
		s++;
  801442:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144b:	0f b6 00             	movzbl (%rax),%eax
  80144e:	3c 20                	cmp    $0x20,%al
  801450:	74 f0                	je     801442 <strtol+0x24>
  801452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801456:	0f b6 00             	movzbl (%rax),%eax
  801459:	3c 09                	cmp    $0x9,%al
  80145b:	74 e5                	je     801442 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80145d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801461:	0f b6 00             	movzbl (%rax),%eax
  801464:	3c 2b                	cmp    $0x2b,%al
  801466:	75 07                	jne    80146f <strtol+0x51>
		s++;
  801468:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80146d:	eb 17                	jmp    801486 <strtol+0x68>
	else if (*s == '-')
  80146f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801473:	0f b6 00             	movzbl (%rax),%eax
  801476:	3c 2d                	cmp    $0x2d,%al
  801478:	75 0c                	jne    801486 <strtol+0x68>
		s++, neg = 1;
  80147a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80147f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801486:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80148a:	74 06                	je     801492 <strtol+0x74>
  80148c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801490:	75 28                	jne    8014ba <strtol+0x9c>
  801492:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801496:	0f b6 00             	movzbl (%rax),%eax
  801499:	3c 30                	cmp    $0x30,%al
  80149b:	75 1d                	jne    8014ba <strtol+0x9c>
  80149d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a1:	48 83 c0 01          	add    $0x1,%rax
  8014a5:	0f b6 00             	movzbl (%rax),%eax
  8014a8:	3c 78                	cmp    $0x78,%al
  8014aa:	75 0e                	jne    8014ba <strtol+0x9c>
		s += 2, base = 16;
  8014ac:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014b1:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014b8:	eb 2c                	jmp    8014e6 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014ba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014be:	75 19                	jne    8014d9 <strtol+0xbb>
  8014c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c4:	0f b6 00             	movzbl (%rax),%eax
  8014c7:	3c 30                	cmp    $0x30,%al
  8014c9:	75 0e                	jne    8014d9 <strtol+0xbb>
		s++, base = 8;
  8014cb:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014d0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8014d7:	eb 0d                	jmp    8014e6 <strtol+0xc8>
	else if (base == 0)
  8014d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014dd:	75 07                	jne    8014e6 <strtol+0xc8>
		base = 10;
  8014df:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ea:	0f b6 00             	movzbl (%rax),%eax
  8014ed:	3c 2f                	cmp    $0x2f,%al
  8014ef:	7e 1d                	jle    80150e <strtol+0xf0>
  8014f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f5:	0f b6 00             	movzbl (%rax),%eax
  8014f8:	3c 39                	cmp    $0x39,%al
  8014fa:	7f 12                	jg     80150e <strtol+0xf0>
			dig = *s - '0';
  8014fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801500:	0f b6 00             	movzbl (%rax),%eax
  801503:	0f be c0             	movsbl %al,%eax
  801506:	83 e8 30             	sub    $0x30,%eax
  801509:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80150c:	eb 4e                	jmp    80155c <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80150e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801512:	0f b6 00             	movzbl (%rax),%eax
  801515:	3c 60                	cmp    $0x60,%al
  801517:	7e 1d                	jle    801536 <strtol+0x118>
  801519:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151d:	0f b6 00             	movzbl (%rax),%eax
  801520:	3c 7a                	cmp    $0x7a,%al
  801522:	7f 12                	jg     801536 <strtol+0x118>
			dig = *s - 'a' + 10;
  801524:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801528:	0f b6 00             	movzbl (%rax),%eax
  80152b:	0f be c0             	movsbl %al,%eax
  80152e:	83 e8 57             	sub    $0x57,%eax
  801531:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801534:	eb 26                	jmp    80155c <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801536:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80153a:	0f b6 00             	movzbl (%rax),%eax
  80153d:	3c 40                	cmp    $0x40,%al
  80153f:	7e 48                	jle    801589 <strtol+0x16b>
  801541:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801545:	0f b6 00             	movzbl (%rax),%eax
  801548:	3c 5a                	cmp    $0x5a,%al
  80154a:	7f 3d                	jg     801589 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80154c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801550:	0f b6 00             	movzbl (%rax),%eax
  801553:	0f be c0             	movsbl %al,%eax
  801556:	83 e8 37             	sub    $0x37,%eax
  801559:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80155c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80155f:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801562:	7c 02                	jl     801566 <strtol+0x148>
			break;
  801564:	eb 23                	jmp    801589 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801566:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80156b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80156e:	48 98                	cltq   
  801570:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801575:	48 89 c2             	mov    %rax,%rdx
  801578:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80157b:	48 98                	cltq   
  80157d:	48 01 d0             	add    %rdx,%rax
  801580:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801584:	e9 5d ff ff ff       	jmpq   8014e6 <strtol+0xc8>

	if (endptr)
  801589:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80158e:	74 0b                	je     80159b <strtol+0x17d>
		*endptr = (char *) s;
  801590:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801594:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801598:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80159b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80159f:	74 09                	je     8015aa <strtol+0x18c>
  8015a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a5:	48 f7 d8             	neg    %rax
  8015a8:	eb 04                	jmp    8015ae <strtol+0x190>
  8015aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015ae:	c9                   	leaveq 
  8015af:	c3                   	retq   

00000000008015b0 <strstr>:

char * strstr(const char *in, const char *str)
{
  8015b0:	55                   	push   %rbp
  8015b1:	48 89 e5             	mov    %rsp,%rbp
  8015b4:	48 83 ec 30          	sub    $0x30,%rsp
  8015b8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015bc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015c0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015c4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015c8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8015cc:	0f b6 00             	movzbl (%rax),%eax
  8015cf:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8015d2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8015d6:	75 06                	jne    8015de <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8015d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015dc:	eb 6b                	jmp    801649 <strstr+0x99>

	len = strlen(str);
  8015de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015e2:	48 89 c7             	mov    %rax,%rdi
  8015e5:	48 b8 86 0e 80 00 00 	movabs $0x800e86,%rax
  8015ec:	00 00 00 
  8015ef:	ff d0                	callq  *%rax
  8015f1:	48 98                	cltq   
  8015f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8015f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015ff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801603:	0f b6 00             	movzbl (%rax),%eax
  801606:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801609:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80160d:	75 07                	jne    801616 <strstr+0x66>
				return (char *) 0;
  80160f:	b8 00 00 00 00       	mov    $0x0,%eax
  801614:	eb 33                	jmp    801649 <strstr+0x99>
		} while (sc != c);
  801616:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80161a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80161d:	75 d8                	jne    8015f7 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80161f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801623:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801627:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162b:	48 89 ce             	mov    %rcx,%rsi
  80162e:	48 89 c7             	mov    %rax,%rdi
  801631:	48 b8 a7 10 80 00 00 	movabs $0x8010a7,%rax
  801638:	00 00 00 
  80163b:	ff d0                	callq  *%rax
  80163d:	85 c0                	test   %eax,%eax
  80163f:	75 b6                	jne    8015f7 <strstr+0x47>

	return (char *) (in - 1);
  801641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801645:	48 83 e8 01          	sub    $0x1,%rax
}
  801649:	c9                   	leaveq 
  80164a:	c3                   	retq   

000000000080164b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80164b:	55                   	push   %rbp
  80164c:	48 89 e5             	mov    %rsp,%rbp
  80164f:	53                   	push   %rbx
  801650:	48 83 ec 48          	sub    $0x48,%rsp
  801654:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801657:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80165a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80165e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801662:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801666:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  80166a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80166d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801671:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801675:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801679:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80167d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801681:	4c 89 c3             	mov    %r8,%rbx
  801684:	cd 30                	int    $0x30
  801686:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  80168a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80168e:	74 3e                	je     8016ce <syscall+0x83>
  801690:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801695:	7e 37                	jle    8016ce <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801697:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80169b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80169e:	49 89 d0             	mov    %rdx,%r8
  8016a1:	89 c1                	mov    %eax,%ecx
  8016a3:	48 ba 68 41 80 00 00 	movabs $0x804168,%rdx
  8016aa:	00 00 00 
  8016ad:	be 4a 00 00 00       	mov    $0x4a,%esi
  8016b2:	48 bf 85 41 80 00 00 	movabs $0x804185,%rdi
  8016b9:	00 00 00 
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c1:	49 b9 a6 37 80 00 00 	movabs $0x8037a6,%r9
  8016c8:	00 00 00 
  8016cb:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8016ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016d2:	48 83 c4 48          	add    $0x48,%rsp
  8016d6:	5b                   	pop    %rbx
  8016d7:	5d                   	pop    %rbp
  8016d8:	c3                   	retq   

00000000008016d9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8016d9:	55                   	push   %rbp
  8016da:	48 89 e5             	mov    %rsp,%rbp
  8016dd:	48 83 ec 20          	sub    $0x20,%rsp
  8016e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8016e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8016f8:	00 
  8016f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8016ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801705:	48 89 d1             	mov    %rdx,%rcx
  801708:	48 89 c2             	mov    %rax,%rdx
  80170b:	be 00 00 00 00       	mov    $0x0,%esi
  801710:	bf 00 00 00 00       	mov    $0x0,%edi
  801715:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  80171c:	00 00 00 
  80171f:	ff d0                	callq  *%rax
}
  801721:	c9                   	leaveq 
  801722:	c3                   	retq   

0000000000801723 <sys_cgetc>:

int
sys_cgetc(void)
{
  801723:	55                   	push   %rbp
  801724:	48 89 e5             	mov    %rsp,%rbp
  801727:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80172b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801732:	00 
  801733:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801739:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80173f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801744:	ba 00 00 00 00       	mov    $0x0,%edx
  801749:	be 00 00 00 00       	mov    $0x0,%esi
  80174e:	bf 01 00 00 00       	mov    $0x1,%edi
  801753:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  80175a:	00 00 00 
  80175d:	ff d0                	callq  *%rax
}
  80175f:	c9                   	leaveq 
  801760:	c3                   	retq   

0000000000801761 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801761:	55                   	push   %rbp
  801762:	48 89 e5             	mov    %rsp,%rbp
  801765:	48 83 ec 10          	sub    $0x10,%rsp
  801769:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80176c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80176f:	48 98                	cltq   
  801771:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801778:	00 
  801779:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80177f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801785:	b9 00 00 00 00       	mov    $0x0,%ecx
  80178a:	48 89 c2             	mov    %rax,%rdx
  80178d:	be 01 00 00 00       	mov    $0x1,%esi
  801792:	bf 03 00 00 00       	mov    $0x3,%edi
  801797:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  80179e:	00 00 00 
  8017a1:	ff d0                	callq  *%rax
}
  8017a3:	c9                   	leaveq 
  8017a4:	c3                   	retq   

00000000008017a5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017a5:	55                   	push   %rbp
  8017a6:	48 89 e5             	mov    %rsp,%rbp
  8017a9:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017ad:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017b4:	00 
  8017b5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017bb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cb:	be 00 00 00 00       	mov    $0x0,%esi
  8017d0:	bf 02 00 00 00       	mov    $0x2,%edi
  8017d5:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  8017dc:	00 00 00 
  8017df:	ff d0                	callq  *%rax
}
  8017e1:	c9                   	leaveq 
  8017e2:	c3                   	retq   

00000000008017e3 <sys_yield>:

void
sys_yield(void)
{
  8017e3:	55                   	push   %rbp
  8017e4:	48 89 e5             	mov    %rsp,%rbp
  8017e7:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8017eb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017f2:	00 
  8017f3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017f9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801804:	ba 00 00 00 00       	mov    $0x0,%edx
  801809:	be 00 00 00 00       	mov    $0x0,%esi
  80180e:	bf 0b 00 00 00       	mov    $0xb,%edi
  801813:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  80181a:	00 00 00 
  80181d:	ff d0                	callq  *%rax
}
  80181f:	c9                   	leaveq 
  801820:	c3                   	retq   

0000000000801821 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801821:	55                   	push   %rbp
  801822:	48 89 e5             	mov    %rsp,%rbp
  801825:	48 83 ec 20          	sub    $0x20,%rsp
  801829:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80182c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801830:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801833:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801836:	48 63 c8             	movslq %eax,%rcx
  801839:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80183d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801840:	48 98                	cltq   
  801842:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801849:	00 
  80184a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801850:	49 89 c8             	mov    %rcx,%r8
  801853:	48 89 d1             	mov    %rdx,%rcx
  801856:	48 89 c2             	mov    %rax,%rdx
  801859:	be 01 00 00 00       	mov    $0x1,%esi
  80185e:	bf 04 00 00 00       	mov    $0x4,%edi
  801863:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  80186a:	00 00 00 
  80186d:	ff d0                	callq  *%rax
}
  80186f:	c9                   	leaveq 
  801870:	c3                   	retq   

0000000000801871 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801871:	55                   	push   %rbp
  801872:	48 89 e5             	mov    %rsp,%rbp
  801875:	48 83 ec 30          	sub    $0x30,%rsp
  801879:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80187c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801880:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801883:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801887:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80188b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80188e:	48 63 c8             	movslq %eax,%rcx
  801891:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801895:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801898:	48 63 f0             	movslq %eax,%rsi
  80189b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80189f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018a2:	48 98                	cltq   
  8018a4:	48 89 0c 24          	mov    %rcx,(%rsp)
  8018a8:	49 89 f9             	mov    %rdi,%r9
  8018ab:	49 89 f0             	mov    %rsi,%r8
  8018ae:	48 89 d1             	mov    %rdx,%rcx
  8018b1:	48 89 c2             	mov    %rax,%rdx
  8018b4:	be 01 00 00 00       	mov    $0x1,%esi
  8018b9:	bf 05 00 00 00       	mov    $0x5,%edi
  8018be:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  8018c5:	00 00 00 
  8018c8:	ff d0                	callq  *%rax
}
  8018ca:	c9                   	leaveq 
  8018cb:	c3                   	retq   

00000000008018cc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8018cc:	55                   	push   %rbp
  8018cd:	48 89 e5             	mov    %rsp,%rbp
  8018d0:	48 83 ec 20          	sub    $0x20,%rsp
  8018d4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018d7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8018db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018e2:	48 98                	cltq   
  8018e4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018eb:	00 
  8018ec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f8:	48 89 d1             	mov    %rdx,%rcx
  8018fb:	48 89 c2             	mov    %rax,%rdx
  8018fe:	be 01 00 00 00       	mov    $0x1,%esi
  801903:	bf 06 00 00 00       	mov    $0x6,%edi
  801908:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  80190f:	00 00 00 
  801912:	ff d0                	callq  *%rax
}
  801914:	c9                   	leaveq 
  801915:	c3                   	retq   

0000000000801916 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801916:	55                   	push   %rbp
  801917:	48 89 e5             	mov    %rsp,%rbp
  80191a:	48 83 ec 10          	sub    $0x10,%rsp
  80191e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801921:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801924:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801927:	48 63 d0             	movslq %eax,%rdx
  80192a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192d:	48 98                	cltq   
  80192f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801936:	00 
  801937:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80193d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801943:	48 89 d1             	mov    %rdx,%rcx
  801946:	48 89 c2             	mov    %rax,%rdx
  801949:	be 01 00 00 00       	mov    $0x1,%esi
  80194e:	bf 08 00 00 00       	mov    $0x8,%edi
  801953:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  80195a:	00 00 00 
  80195d:	ff d0                	callq  *%rax
}
  80195f:	c9                   	leaveq 
  801960:	c3                   	retq   

0000000000801961 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801961:	55                   	push   %rbp
  801962:	48 89 e5             	mov    %rsp,%rbp
  801965:	48 83 ec 20          	sub    $0x20,%rsp
  801969:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80196c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801970:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801974:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801977:	48 98                	cltq   
  801979:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801980:	00 
  801981:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801987:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198d:	48 89 d1             	mov    %rdx,%rcx
  801990:	48 89 c2             	mov    %rax,%rdx
  801993:	be 01 00 00 00       	mov    $0x1,%esi
  801998:	bf 09 00 00 00       	mov    $0x9,%edi
  80199d:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  8019a4:	00 00 00 
  8019a7:	ff d0                	callq  *%rax
}
  8019a9:	c9                   	leaveq 
  8019aa:	c3                   	retq   

00000000008019ab <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019ab:	55                   	push   %rbp
  8019ac:	48 89 e5             	mov    %rsp,%rbp
  8019af:	48 83 ec 20          	sub    $0x20,%rsp
  8019b3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019ba:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c1:	48 98                	cltq   
  8019c3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ca:	00 
  8019cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d7:	48 89 d1             	mov    %rdx,%rcx
  8019da:	48 89 c2             	mov    %rax,%rdx
  8019dd:	be 01 00 00 00       	mov    $0x1,%esi
  8019e2:	bf 0a 00 00 00       	mov    $0xa,%edi
  8019e7:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  8019ee:	00 00 00 
  8019f1:	ff d0                	callq  *%rax
}
  8019f3:	c9                   	leaveq 
  8019f4:	c3                   	retq   

00000000008019f5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8019f5:	55                   	push   %rbp
  8019f6:	48 89 e5             	mov    %rsp,%rbp
  8019f9:	48 83 ec 20          	sub    $0x20,%rsp
  8019fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a04:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a08:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a0b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a0e:	48 63 f0             	movslq %eax,%rsi
  801a11:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a18:	48 98                	cltq   
  801a1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a1e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a25:	00 
  801a26:	49 89 f1             	mov    %rsi,%r9
  801a29:	49 89 c8             	mov    %rcx,%r8
  801a2c:	48 89 d1             	mov    %rdx,%rcx
  801a2f:	48 89 c2             	mov    %rax,%rdx
  801a32:	be 00 00 00 00       	mov    $0x0,%esi
  801a37:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a3c:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  801a43:	00 00 00 
  801a46:	ff d0                	callq  *%rax
}
  801a48:	c9                   	leaveq 
  801a49:	c3                   	retq   

0000000000801a4a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a4a:	55                   	push   %rbp
  801a4b:	48 89 e5             	mov    %rsp,%rbp
  801a4e:	48 83 ec 10          	sub    $0x10,%rsp
  801a52:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a5a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a61:	00 
  801a62:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a68:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a73:	48 89 c2             	mov    %rax,%rdx
  801a76:	be 01 00 00 00       	mov    $0x1,%esi
  801a7b:	bf 0d 00 00 00       	mov    $0xd,%edi
  801a80:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  801a87:	00 00 00 
  801a8a:	ff d0                	callq  *%rax
}
  801a8c:	c9                   	leaveq 
  801a8d:	c3                   	retq   

0000000000801a8e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a8e:	55                   	push   %rbp
  801a8f:	48 89 e5             	mov    %rsp,%rbp
  801a92:	53                   	push   %rbx
  801a93:	48 83 ec 48          	sub    $0x48,%rsp
  801a97:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801a9b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a9f:	48 8b 00             	mov    (%rax),%rax
  801aa2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801aa6:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801aaa:	48 8b 40 08          	mov    0x8(%rax),%rax
  801aae:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801ab1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ab5:	48 c1 e8 0c          	shr    $0xc,%rax
  801ab9:	48 89 c2             	mov    %rax,%rdx
  801abc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ac3:	01 00 00 
  801ac6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801aca:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801ace:	48 b8 a5 17 80 00 00 	movabs $0x8017a5,%rax
  801ad5:	00 00 00 
  801ad8:	ff d0                	callq  *%rax
  801ada:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801add:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801ae5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ae9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801aef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801af3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801af6:	83 e0 02             	and    $0x2,%eax
  801af9:	85 c0                	test   %eax,%eax
  801afb:	0f 84 8d 00 00 00    	je     801b8e <pgfault+0x100>
  801b01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b05:	25 00 08 00 00       	and    $0x800,%eax
  801b0a:	48 85 c0             	test   %rax,%rax
  801b0d:	74 7f                	je     801b8e <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801b0f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b12:	ba 07 00 00 00       	mov    $0x7,%edx
  801b17:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b1c:	89 c7                	mov    %eax,%edi
  801b1e:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801b25:	00 00 00 
  801b28:	ff d0                	callq  *%rax
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	75 60                	jne    801b8e <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801b2e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801b32:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b37:	48 89 c6             	mov    %rax,%rsi
  801b3a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801b3f:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  801b46:	00 00 00 
  801b49:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801b4b:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801b4f:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801b52:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b55:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801b5b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b60:	89 c7                	mov    %eax,%edi
  801b62:	48 b8 71 18 80 00 00 	movabs $0x801871,%rax
  801b69:	00 00 00 
  801b6c:	ff d0                	callq  *%rax
  801b6e:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801b70:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801b73:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801b78:	89 c7                	mov    %eax,%edi
  801b7a:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  801b81:	00 00 00 
  801b84:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801b86:	09 d8                	or     %ebx,%eax
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	75 02                	jne    801b8e <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801b8c:	eb 2a                	jmp    801bb8 <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801b8e:	48 ba 93 41 80 00 00 	movabs $0x804193,%rdx
  801b95:	00 00 00 
  801b98:	be 26 00 00 00       	mov    $0x26,%esi
  801b9d:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  801ba4:	00 00 00 
  801ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bac:	48 b9 a6 37 80 00 00 	movabs $0x8037a6,%rcx
  801bb3:	00 00 00 
  801bb6:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801bb8:	48 83 c4 48          	add    $0x48,%rsp
  801bbc:	5b                   	pop    %rbx
  801bbd:	5d                   	pop    %rbp
  801bbe:	c3                   	retq   

0000000000801bbf <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801bbf:	55                   	push   %rbp
  801bc0:	48 89 e5             	mov    %rsp,%rbp
  801bc3:	53                   	push   %rbx
  801bc4:	48 83 ec 38          	sub    $0x38,%rsp
  801bc8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801bcb:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801bce:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bd5:	01 00 00 
  801bd8:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801bdb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bdf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801be3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801be7:	25 07 0e 00 00       	and    $0xe07,%eax
  801bec:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801bef:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801bf2:	48 c1 e0 0c          	shl    $0xc,%rax
  801bf6:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801bfa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bfd:	25 00 04 00 00       	and    $0x400,%eax
  801c02:	85 c0                	test   %eax,%eax
  801c04:	74 30                	je     801c36 <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801c06:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801c09:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c0d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801c10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c14:	41 89 f0             	mov    %esi,%r8d
  801c17:	48 89 c6             	mov    %rax,%rsi
  801c1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c1f:	48 b8 71 18 80 00 00 	movabs $0x801871,%rax
  801c26:	00 00 00 
  801c29:	ff d0                	callq  *%rax
  801c2b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801c2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c31:	e9 a4 00 00 00       	jmpq   801cda <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801c36:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c39:	83 e0 02             	and    $0x2,%eax
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	75 0c                	jne    801c4c <duppage+0x8d>
  801c40:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c43:	25 00 08 00 00       	and    $0x800,%eax
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	74 63                	je     801caf <duppage+0xf0>
		perm &= ~PTE_W;
  801c4c:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  801c50:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  801c57:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801c5a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801c5e:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801c61:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c65:	41 89 f0             	mov    %esi,%r8d
  801c68:	48 89 c6             	mov    %rax,%rsi
  801c6b:	bf 00 00 00 00       	mov    $0x0,%edi
  801c70:	48 b8 71 18 80 00 00 	movabs $0x801871,%rax
  801c77:	00 00 00 
  801c7a:	ff d0                	callq  *%rax
  801c7c:	89 c3                	mov    %eax,%ebx
  801c7e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801c81:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801c85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801c89:	41 89 c8             	mov    %ecx,%r8d
  801c8c:	48 89 d1             	mov    %rdx,%rcx
  801c8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c94:	48 89 c6             	mov    %rax,%rsi
  801c97:	bf 00 00 00 00       	mov    $0x0,%edi
  801c9c:	48 b8 71 18 80 00 00 	movabs $0x801871,%rax
  801ca3:	00 00 00 
  801ca6:	ff d0                	callq  *%rax
  801ca8:	09 d8                	or     %ebx,%eax
  801caa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801cad:	eb 28                	jmp    801cd7 <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  801caf:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801cb2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801cb6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801cb9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801cbd:	41 89 f0             	mov    %esi,%r8d
  801cc0:	48 89 c6             	mov    %rax,%rsi
  801cc3:	bf 00 00 00 00       	mov    $0x0,%edi
  801cc8:	48 b8 71 18 80 00 00 	movabs $0x801871,%rax
  801ccf:	00 00 00 
  801cd2:	ff d0                	callq  *%rax
  801cd4:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  801cd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801cda:	48 83 c4 38          	add    $0x38,%rsp
  801cde:	5b                   	pop    %rbx
  801cdf:	5d                   	pop    %rbp
  801ce0:	c3                   	retq   

0000000000801ce1 <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  801ce1:	55                   	push   %rbp
  801ce2:	48 89 e5             	mov    %rsp,%rbp
  801ce5:	53                   	push   %rbx
  801ce6:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801cea:	48 bf 8e 1a 80 00 00 	movabs $0x801a8e,%rdi
  801cf1:	00 00 00 
  801cf4:	48 b8 ba 38 80 00 00 	movabs $0x8038ba,%rax
  801cfb:	00 00 00 
  801cfe:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801d00:	b8 07 00 00 00       	mov    $0x7,%eax
  801d05:	cd 30                	int    $0x30
  801d07:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801d0a:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  801d0d:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  801d10:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d14:	79 30                	jns    801d46 <fork+0x65>
  801d16:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d19:	89 c1                	mov    %eax,%ecx
  801d1b:	48 ba ba 41 80 00 00 	movabs $0x8041ba,%rdx
  801d22:	00 00 00 
  801d25:	be 72 00 00 00       	mov    $0x72,%esi
  801d2a:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  801d31:	00 00 00 
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
  801d39:	49 b8 a6 37 80 00 00 	movabs $0x8037a6,%r8
  801d40:	00 00 00 
  801d43:	41 ff d0             	callq  *%r8
	if(cid == 0){
  801d46:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801d4a:	75 46                	jne    801d92 <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  801d4c:	48 b8 a5 17 80 00 00 	movabs $0x8017a5,%rax
  801d53:	00 00 00 
  801d56:	ff d0                	callq  *%rax
  801d58:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d5d:	48 63 d0             	movslq %eax,%rdx
  801d60:	48 89 d0             	mov    %rdx,%rax
  801d63:	48 c1 e0 03          	shl    $0x3,%rax
  801d67:	48 01 d0             	add    %rdx,%rax
  801d6a:	48 c1 e0 05          	shl    $0x5,%rax
  801d6e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801d75:	00 00 00 
  801d78:	48 01 c2             	add    %rax,%rdx
  801d7b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801d82:	00 00 00 
  801d85:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8d:	e9 12 02 00 00       	jmpq   801fa4 <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801d92:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801d95:	ba 07 00 00 00       	mov    $0x7,%edx
  801d9a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801d9f:	89 c7                	mov    %eax,%edi
  801da1:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  801da8:	00 00 00 
  801dab:	ff d0                	callq  *%rax
  801dad:	89 45 c8             	mov    %eax,-0x38(%rbp)
  801db0:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  801db4:	79 30                	jns    801de6 <fork+0x105>
		panic("fork failed: %e\n", result);
  801db6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801db9:	89 c1                	mov    %eax,%ecx
  801dbb:	48 ba ba 41 80 00 00 	movabs $0x8041ba,%rdx
  801dc2:	00 00 00 
  801dc5:	be 79 00 00 00       	mov    $0x79,%esi
  801dca:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  801dd1:	00 00 00 
  801dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd9:	49 b8 a6 37 80 00 00 	movabs $0x8037a6,%r8
  801de0:	00 00 00 
  801de3:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  801de6:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  801ded:	00 
  801dee:	e9 40 01 00 00       	jmpq   801f33 <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  801df3:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  801dfa:	01 00 00 
  801dfd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e05:	83 e0 01             	and    $0x1,%eax
  801e08:	48 85 c0             	test   %rax,%rax
  801e0b:	0f 84 1d 01 00 00    	je     801f2e <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  801e11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e15:	48 c1 e0 09          	shl    $0x9,%rax
  801e19:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  801e1d:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  801e24:	00 
  801e25:	e9 f6 00 00 00       	jmpq   801f20 <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  801e2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e2e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801e32:	48 01 c2             	add    %rax,%rdx
  801e35:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  801e3c:	01 00 00 
  801e3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e43:	83 e0 01             	and    $0x1,%eax
  801e46:	48 85 c0             	test   %rax,%rax
  801e49:	0f 84 cc 00 00 00    	je     801f1b <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  801e4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e53:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801e57:	48 01 d0             	add    %rdx,%rax
  801e5a:	48 c1 e0 09          	shl    $0x9,%rax
  801e5e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  801e62:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  801e69:	00 
  801e6a:	e9 9e 00 00 00       	jmpq   801f0d <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  801e6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e73:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801e77:	48 01 c2             	add    %rax,%rdx
  801e7a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e81:	01 00 00 
  801e84:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e88:	83 e0 01             	and    $0x1,%eax
  801e8b:	48 85 c0             	test   %rax,%rax
  801e8e:	74 78                	je     801f08 <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  801e90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e94:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801e98:	48 01 d0             	add    %rdx,%rax
  801e9b:	48 c1 e0 09          	shl    $0x9,%rax
  801e9f:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  801ea3:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  801eaa:	00 
  801eab:	eb 51                	jmp    801efe <fork+0x21d>
								entry = base_pde + pte;
  801ead:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801eb1:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801eb5:	48 01 d0             	add    %rdx,%rax
  801eb8:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  801ebc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801ec3:	01 00 00 
  801ec6:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801eca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ece:	83 e0 01             	and    $0x1,%eax
  801ed1:	48 85 c0             	test   %rax,%rax
  801ed4:	74 23                	je     801ef9 <fork+0x218>
  801ed6:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  801edd:	00 
  801ede:	74 19                	je     801ef9 <fork+0x218>
									duppage(cid, entry);
  801ee0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ee4:	89 c2                	mov    %eax,%edx
  801ee6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ee9:	89 d6                	mov    %edx,%esi
  801eeb:	89 c7                	mov    %eax,%edi
  801eed:	48 b8 bf 1b 80 00 00 	movabs $0x801bbf,%rax
  801ef4:	00 00 00 
  801ef7:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  801ef9:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  801efe:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  801f05:	00 
  801f06:	76 a5                	jbe    801ead <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  801f08:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f0d:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  801f14:	00 
  801f15:	0f 86 54 ff ff ff    	jbe    801e6f <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  801f1b:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  801f20:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  801f27:	00 
  801f28:	0f 86 fc fe ff ff    	jbe    801e2a <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  801f2e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801f33:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801f38:	0f 84 b5 fe ff ff    	je     801df3 <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  801f3e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f41:	48 be 4f 39 80 00 00 	movabs $0x80394f,%rsi
  801f48:	00 00 00 
  801f4b:	89 c7                	mov    %eax,%edi
  801f4d:	48 b8 ab 19 80 00 00 	movabs $0x8019ab,%rax
  801f54:	00 00 00 
  801f57:	ff d0                	callq  *%rax
  801f59:	89 c3                	mov    %eax,%ebx
  801f5b:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f5e:	be 02 00 00 00       	mov    $0x2,%esi
  801f63:	89 c7                	mov    %eax,%edi
  801f65:	48 b8 16 19 80 00 00 	movabs $0x801916,%rax
  801f6c:	00 00 00 
  801f6f:	ff d0                	callq  *%rax
  801f71:	09 d8                	or     %ebx,%eax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	74 2a                	je     801fa1 <fork+0x2c0>
		panic("fork failed\n");
  801f77:	48 ba cb 41 80 00 00 	movabs $0x8041cb,%rdx
  801f7e:	00 00 00 
  801f81:	be 92 00 00 00       	mov    $0x92,%esi
  801f86:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  801f8d:	00 00 00 
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
  801f95:	48 b9 a6 37 80 00 00 	movabs $0x8037a6,%rcx
  801f9c:	00 00 00 
  801f9f:	ff d1                	callq  *%rcx
	return cid;
  801fa1:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  801fa4:	48 83 c4 58          	add    $0x58,%rsp
  801fa8:	5b                   	pop    %rbx
  801fa9:	5d                   	pop    %rbp
  801faa:	c3                   	retq   

0000000000801fab <sfork>:


// Challenge!
int
sfork(void)
{
  801fab:	55                   	push   %rbp
  801fac:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  801faf:	48 ba d8 41 80 00 00 	movabs $0x8041d8,%rdx
  801fb6:	00 00 00 
  801fb9:	be 9c 00 00 00       	mov    $0x9c,%esi
  801fbe:	48 bf af 41 80 00 00 	movabs $0x8041af,%rdi
  801fc5:	00 00 00 
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcd:	48 b9 a6 37 80 00 00 	movabs $0x8037a6,%rcx
  801fd4:	00 00 00 
  801fd7:	ff d1                	callq  *%rcx

0000000000801fd9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801fd9:	55                   	push   %rbp
  801fda:	48 89 e5             	mov    %rsp,%rbp
  801fdd:	48 83 ec 08          	sub    $0x8,%rsp
  801fe1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801fe5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801fe9:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801ff0:	ff ff ff 
  801ff3:	48 01 d0             	add    %rdx,%rax
  801ff6:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ffa:	c9                   	leaveq 
  801ffb:	c3                   	retq   

0000000000801ffc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ffc:	55                   	push   %rbp
  801ffd:	48 89 e5             	mov    %rsp,%rbp
  802000:	48 83 ec 08          	sub    $0x8,%rsp
  802004:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802008:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80200c:	48 89 c7             	mov    %rax,%rdi
  80200f:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  802016:	00 00 00 
  802019:	ff d0                	callq  *%rax
  80201b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802021:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802025:	c9                   	leaveq 
  802026:	c3                   	retq   

0000000000802027 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802027:	55                   	push   %rbp
  802028:	48 89 e5             	mov    %rsp,%rbp
  80202b:	48 83 ec 18          	sub    $0x18,%rsp
  80202f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802033:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80203a:	eb 6b                	jmp    8020a7 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80203c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80203f:	48 98                	cltq   
  802041:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802047:	48 c1 e0 0c          	shl    $0xc,%rax
  80204b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80204f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802053:	48 c1 e8 15          	shr    $0x15,%rax
  802057:	48 89 c2             	mov    %rax,%rdx
  80205a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802061:	01 00 00 
  802064:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802068:	83 e0 01             	and    $0x1,%eax
  80206b:	48 85 c0             	test   %rax,%rax
  80206e:	74 21                	je     802091 <fd_alloc+0x6a>
  802070:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802074:	48 c1 e8 0c          	shr    $0xc,%rax
  802078:	48 89 c2             	mov    %rax,%rdx
  80207b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802082:	01 00 00 
  802085:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802089:	83 e0 01             	and    $0x1,%eax
  80208c:	48 85 c0             	test   %rax,%rax
  80208f:	75 12                	jne    8020a3 <fd_alloc+0x7c>
			*fd_store = fd;
  802091:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802095:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802099:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80209c:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a1:	eb 1a                	jmp    8020bd <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8020a3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020a7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8020ab:	7e 8f                	jle    80203c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8020ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020b1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8020b8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8020bd:	c9                   	leaveq 
  8020be:	c3                   	retq   

00000000008020bf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8020bf:	55                   	push   %rbp
  8020c0:	48 89 e5             	mov    %rsp,%rbp
  8020c3:	48 83 ec 20          	sub    $0x20,%rsp
  8020c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8020ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020d2:	78 06                	js     8020da <fd_lookup+0x1b>
  8020d4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8020d8:	7e 07                	jle    8020e1 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8020da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020df:	eb 6c                	jmp    80214d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8020e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020e4:	48 98                	cltq   
  8020e6:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8020ec:	48 c1 e0 0c          	shl    $0xc,%rax
  8020f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8020f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020f8:	48 c1 e8 15          	shr    $0x15,%rax
  8020fc:	48 89 c2             	mov    %rax,%rdx
  8020ff:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802106:	01 00 00 
  802109:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80210d:	83 e0 01             	and    $0x1,%eax
  802110:	48 85 c0             	test   %rax,%rax
  802113:	74 21                	je     802136 <fd_lookup+0x77>
  802115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802119:	48 c1 e8 0c          	shr    $0xc,%rax
  80211d:	48 89 c2             	mov    %rax,%rdx
  802120:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802127:	01 00 00 
  80212a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212e:	83 e0 01             	and    $0x1,%eax
  802131:	48 85 c0             	test   %rax,%rax
  802134:	75 07                	jne    80213d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802136:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80213b:	eb 10                	jmp    80214d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80213d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802141:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802145:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802148:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80214d:	c9                   	leaveq 
  80214e:	c3                   	retq   

000000000080214f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80214f:	55                   	push   %rbp
  802150:	48 89 e5             	mov    %rsp,%rbp
  802153:	48 83 ec 30          	sub    $0x30,%rsp
  802157:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80215b:	89 f0                	mov    %esi,%eax
  80215d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802160:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802164:	48 89 c7             	mov    %rax,%rdi
  802167:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  80216e:	00 00 00 
  802171:	ff d0                	callq  *%rax
  802173:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802177:	48 89 d6             	mov    %rdx,%rsi
  80217a:	89 c7                	mov    %eax,%edi
  80217c:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  802183:	00 00 00 
  802186:	ff d0                	callq  *%rax
  802188:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80218b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80218f:	78 0a                	js     80219b <fd_close+0x4c>
	    || fd != fd2)
  802191:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802195:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802199:	74 12                	je     8021ad <fd_close+0x5e>
		return (must_exist ? r : 0);
  80219b:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80219f:	74 05                	je     8021a6 <fd_close+0x57>
  8021a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021a4:	eb 05                	jmp    8021ab <fd_close+0x5c>
  8021a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ab:	eb 69                	jmp    802216 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8021ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b1:	8b 00                	mov    (%rax),%eax
  8021b3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021b7:	48 89 d6             	mov    %rdx,%rsi
  8021ba:	89 c7                	mov    %eax,%edi
  8021bc:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  8021c3:	00 00 00 
  8021c6:	ff d0                	callq  *%rax
  8021c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021cf:	78 2a                	js     8021fb <fd_close+0xac>
		if (dev->dev_close)
  8021d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d5:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021d9:	48 85 c0             	test   %rax,%rax
  8021dc:	74 16                	je     8021f4 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  8021de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8021e6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021ea:	48 89 d7             	mov    %rdx,%rdi
  8021ed:	ff d0                	callq  *%rax
  8021ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f2:	eb 07                	jmp    8021fb <fd_close+0xac>
		else
			r = 0;
  8021f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8021fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ff:	48 89 c6             	mov    %rax,%rsi
  802202:	bf 00 00 00 00       	mov    $0x0,%edi
  802207:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  80220e:	00 00 00 
  802211:	ff d0                	callq  *%rax
	return r;
  802213:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802216:	c9                   	leaveq 
  802217:	c3                   	retq   

0000000000802218 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802218:	55                   	push   %rbp
  802219:	48 89 e5             	mov    %rsp,%rbp
  80221c:	48 83 ec 20          	sub    $0x20,%rsp
  802220:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802223:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802227:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80222e:	eb 41                	jmp    802271 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802230:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802237:	00 00 00 
  80223a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80223d:	48 63 d2             	movslq %edx,%rdx
  802240:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802244:	8b 00                	mov    (%rax),%eax
  802246:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802249:	75 22                	jne    80226d <dev_lookup+0x55>
			*dev = devtab[i];
  80224b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802252:	00 00 00 
  802255:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802258:	48 63 d2             	movslq %edx,%rdx
  80225b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80225f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802263:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802266:	b8 00 00 00 00       	mov    $0x0,%eax
  80226b:	eb 60                	jmp    8022cd <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80226d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802271:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802278:	00 00 00 
  80227b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80227e:	48 63 d2             	movslq %edx,%rdx
  802281:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802285:	48 85 c0             	test   %rax,%rax
  802288:	75 a6                	jne    802230 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80228a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802291:	00 00 00 
  802294:	48 8b 00             	mov    (%rax),%rax
  802297:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80229d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022a0:	89 c6                	mov    %eax,%esi
  8022a2:	48 bf f0 41 80 00 00 	movabs $0x8041f0,%rdi
  8022a9:	00 00 00 
  8022ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b1:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  8022b8:	00 00 00 
  8022bb:	ff d1                	callq  *%rcx
	*dev = 0;
  8022bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022c1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8022c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8022cd:	c9                   	leaveq 
  8022ce:	c3                   	retq   

00000000008022cf <close>:

int
close(int fdnum)
{
  8022cf:	55                   	push   %rbp
  8022d0:	48 89 e5             	mov    %rsp,%rbp
  8022d3:	48 83 ec 20          	sub    $0x20,%rsp
  8022d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022da:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022e1:	48 89 d6             	mov    %rdx,%rsi
  8022e4:	89 c7                	mov    %eax,%edi
  8022e6:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  8022ed:	00 00 00 
  8022f0:	ff d0                	callq  *%rax
  8022f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f9:	79 05                	jns    802300 <close+0x31>
		return r;
  8022fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022fe:	eb 18                	jmp    802318 <close+0x49>
	else
		return fd_close(fd, 1);
  802300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802304:	be 01 00 00 00       	mov    $0x1,%esi
  802309:	48 89 c7             	mov    %rax,%rdi
  80230c:	48 b8 4f 21 80 00 00 	movabs $0x80214f,%rax
  802313:	00 00 00 
  802316:	ff d0                	callq  *%rax
}
  802318:	c9                   	leaveq 
  802319:	c3                   	retq   

000000000080231a <close_all>:

void
close_all(void)
{
  80231a:	55                   	push   %rbp
  80231b:	48 89 e5             	mov    %rsp,%rbp
  80231e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802322:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802329:	eb 15                	jmp    802340 <close_all+0x26>
		close(i);
  80232b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232e:	89 c7                	mov    %eax,%edi
  802330:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  802337:	00 00 00 
  80233a:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80233c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802340:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802344:	7e e5                	jle    80232b <close_all+0x11>
		close(i);
}
  802346:	c9                   	leaveq 
  802347:	c3                   	retq   

0000000000802348 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802348:	55                   	push   %rbp
  802349:	48 89 e5             	mov    %rsp,%rbp
  80234c:	48 83 ec 40          	sub    $0x40,%rsp
  802350:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802353:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802356:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80235a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80235d:	48 89 d6             	mov    %rdx,%rsi
  802360:	89 c7                	mov    %eax,%edi
  802362:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  802369:	00 00 00 
  80236c:	ff d0                	callq  *%rax
  80236e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802371:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802375:	79 08                	jns    80237f <dup+0x37>
		return r;
  802377:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237a:	e9 70 01 00 00       	jmpq   8024ef <dup+0x1a7>
	close(newfdnum);
  80237f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802382:	89 c7                	mov    %eax,%edi
  802384:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  80238b:	00 00 00 
  80238e:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802390:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802393:	48 98                	cltq   
  802395:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80239b:	48 c1 e0 0c          	shl    $0xc,%rax
  80239f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8023a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023a7:	48 89 c7             	mov    %rax,%rdi
  8023aa:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  8023b1:	00 00 00 
  8023b4:	ff d0                	callq  *%rax
  8023b6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8023ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023be:	48 89 c7             	mov    %rax,%rdi
  8023c1:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  8023c8:	00 00 00 
  8023cb:	ff d0                	callq  *%rax
  8023cd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8023d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023d5:	48 c1 e8 15          	shr    $0x15,%rax
  8023d9:	48 89 c2             	mov    %rax,%rdx
  8023dc:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8023e3:	01 00 00 
  8023e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ea:	83 e0 01             	and    $0x1,%eax
  8023ed:	48 85 c0             	test   %rax,%rax
  8023f0:	74 73                	je     802465 <dup+0x11d>
  8023f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023f6:	48 c1 e8 0c          	shr    $0xc,%rax
  8023fa:	48 89 c2             	mov    %rax,%rdx
  8023fd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802404:	01 00 00 
  802407:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80240b:	83 e0 01             	and    $0x1,%eax
  80240e:	48 85 c0             	test   %rax,%rax
  802411:	74 52                	je     802465 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802413:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802417:	48 c1 e8 0c          	shr    $0xc,%rax
  80241b:	48 89 c2             	mov    %rax,%rdx
  80241e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802425:	01 00 00 
  802428:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242c:	25 07 0e 00 00       	and    $0xe07,%eax
  802431:	89 c1                	mov    %eax,%ecx
  802433:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802437:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80243b:	41 89 c8             	mov    %ecx,%r8d
  80243e:	48 89 d1             	mov    %rdx,%rcx
  802441:	ba 00 00 00 00       	mov    $0x0,%edx
  802446:	48 89 c6             	mov    %rax,%rsi
  802449:	bf 00 00 00 00       	mov    $0x0,%edi
  80244e:	48 b8 71 18 80 00 00 	movabs $0x801871,%rax
  802455:	00 00 00 
  802458:	ff d0                	callq  *%rax
  80245a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80245d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802461:	79 02                	jns    802465 <dup+0x11d>
			goto err;
  802463:	eb 57                	jmp    8024bc <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802465:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802469:	48 c1 e8 0c          	shr    $0xc,%rax
  80246d:	48 89 c2             	mov    %rax,%rdx
  802470:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802477:	01 00 00 
  80247a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80247e:	25 07 0e 00 00       	and    $0xe07,%eax
  802483:	89 c1                	mov    %eax,%ecx
  802485:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802489:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80248d:	41 89 c8             	mov    %ecx,%r8d
  802490:	48 89 d1             	mov    %rdx,%rcx
  802493:	ba 00 00 00 00       	mov    $0x0,%edx
  802498:	48 89 c6             	mov    %rax,%rsi
  80249b:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a0:	48 b8 71 18 80 00 00 	movabs $0x801871,%rax
  8024a7:	00 00 00 
  8024aa:	ff d0                	callq  *%rax
  8024ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024b3:	79 02                	jns    8024b7 <dup+0x16f>
		goto err;
  8024b5:	eb 05                	jmp    8024bc <dup+0x174>

	return newfdnum;
  8024b7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8024ba:	eb 33                	jmp    8024ef <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8024bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c0:	48 89 c6             	mov    %rax,%rsi
  8024c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8024c8:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  8024cf:	00 00 00 
  8024d2:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8024d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024d8:	48 89 c6             	mov    %rax,%rsi
  8024db:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e0:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  8024e7:	00 00 00 
  8024ea:	ff d0                	callq  *%rax
	return r;
  8024ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8024ef:	c9                   	leaveq 
  8024f0:	c3                   	retq   

00000000008024f1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8024f1:	55                   	push   %rbp
  8024f2:	48 89 e5             	mov    %rsp,%rbp
  8024f5:	48 83 ec 40          	sub    $0x40,%rsp
  8024f9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024fc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802500:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802504:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802508:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80250b:	48 89 d6             	mov    %rdx,%rsi
  80250e:	89 c7                	mov    %eax,%edi
  802510:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  802517:	00 00 00 
  80251a:	ff d0                	callq  *%rax
  80251c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802523:	78 24                	js     802549 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802529:	8b 00                	mov    (%rax),%eax
  80252b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80252f:	48 89 d6             	mov    %rdx,%rsi
  802532:	89 c7                	mov    %eax,%edi
  802534:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  80253b:	00 00 00 
  80253e:	ff d0                	callq  *%rax
  802540:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802543:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802547:	79 05                	jns    80254e <read+0x5d>
		return r;
  802549:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80254c:	eb 76                	jmp    8025c4 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80254e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802552:	8b 40 08             	mov    0x8(%rax),%eax
  802555:	83 e0 03             	and    $0x3,%eax
  802558:	83 f8 01             	cmp    $0x1,%eax
  80255b:	75 3a                	jne    802597 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80255d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802564:	00 00 00 
  802567:	48 8b 00             	mov    (%rax),%rax
  80256a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802570:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802573:	89 c6                	mov    %eax,%esi
  802575:	48 bf 0f 42 80 00 00 	movabs $0x80420f,%rdi
  80257c:	00 00 00 
  80257f:	b8 00 00 00 00       	mov    $0x0,%eax
  802584:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  80258b:	00 00 00 
  80258e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802590:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802595:	eb 2d                	jmp    8025c4 <read+0xd3>
	}
	if (!dev->dev_read)
  802597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259b:	48 8b 40 10          	mov    0x10(%rax),%rax
  80259f:	48 85 c0             	test   %rax,%rax
  8025a2:	75 07                	jne    8025ab <read+0xba>
		return -E_NOT_SUPP;
  8025a4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025a9:	eb 19                	jmp    8025c4 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8025ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025af:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025b3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8025b7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8025bb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8025bf:	48 89 cf             	mov    %rcx,%rdi
  8025c2:	ff d0                	callq  *%rax
}
  8025c4:	c9                   	leaveq 
  8025c5:	c3                   	retq   

00000000008025c6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8025c6:	55                   	push   %rbp
  8025c7:	48 89 e5             	mov    %rsp,%rbp
  8025ca:	48 83 ec 30          	sub    $0x30,%rsp
  8025ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8025d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025e0:	eb 49                	jmp    80262b <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8025e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e5:	48 98                	cltq   
  8025e7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025eb:	48 29 c2             	sub    %rax,%rdx
  8025ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f1:	48 63 c8             	movslq %eax,%rcx
  8025f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025f8:	48 01 c1             	add    %rax,%rcx
  8025fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025fe:	48 89 ce             	mov    %rcx,%rsi
  802601:	89 c7                	mov    %eax,%edi
  802603:	48 b8 f1 24 80 00 00 	movabs $0x8024f1,%rax
  80260a:	00 00 00 
  80260d:	ff d0                	callq  *%rax
  80260f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802612:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802616:	79 05                	jns    80261d <readn+0x57>
			return m;
  802618:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80261b:	eb 1c                	jmp    802639 <readn+0x73>
		if (m == 0)
  80261d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802621:	75 02                	jne    802625 <readn+0x5f>
			break;
  802623:	eb 11                	jmp    802636 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802625:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802628:	01 45 fc             	add    %eax,-0x4(%rbp)
  80262b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80262e:	48 98                	cltq   
  802630:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802634:	72 ac                	jb     8025e2 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802636:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802639:	c9                   	leaveq 
  80263a:	c3                   	retq   

000000000080263b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80263b:	55                   	push   %rbp
  80263c:	48 89 e5             	mov    %rsp,%rbp
  80263f:	48 83 ec 40          	sub    $0x40,%rsp
  802643:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802646:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80264a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80264e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802652:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802655:	48 89 d6             	mov    %rdx,%rsi
  802658:	89 c7                	mov    %eax,%edi
  80265a:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  802661:	00 00 00 
  802664:	ff d0                	callq  *%rax
  802666:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802669:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80266d:	78 24                	js     802693 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80266f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802673:	8b 00                	mov    (%rax),%eax
  802675:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802679:	48 89 d6             	mov    %rdx,%rsi
  80267c:	89 c7                	mov    %eax,%edi
  80267e:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  802685:	00 00 00 
  802688:	ff d0                	callq  *%rax
  80268a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80268d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802691:	79 05                	jns    802698 <write+0x5d>
		return r;
  802693:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802696:	eb 75                	jmp    80270d <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80269c:	8b 40 08             	mov    0x8(%rax),%eax
  80269f:	83 e0 03             	and    $0x3,%eax
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	75 3a                	jne    8026e0 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8026a6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8026ad:	00 00 00 
  8026b0:	48 8b 00             	mov    (%rax),%rax
  8026b3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026b9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026bc:	89 c6                	mov    %eax,%esi
  8026be:	48 bf 2b 42 80 00 00 	movabs $0x80422b,%rdi
  8026c5:	00 00 00 
  8026c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cd:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  8026d4:	00 00 00 
  8026d7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8026d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026de:	eb 2d                	jmp    80270d <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8026e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026e4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026e8:	48 85 c0             	test   %rax,%rax
  8026eb:	75 07                	jne    8026f4 <write+0xb9>
		return -E_NOT_SUPP;
  8026ed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8026f2:	eb 19                	jmp    80270d <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8026f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026f8:	48 8b 40 18          	mov    0x18(%rax),%rax
  8026fc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802700:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802704:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802708:	48 89 cf             	mov    %rcx,%rdi
  80270b:	ff d0                	callq  *%rax
}
  80270d:	c9                   	leaveq 
  80270e:	c3                   	retq   

000000000080270f <seek>:

int
seek(int fdnum, off_t offset)
{
  80270f:	55                   	push   %rbp
  802710:	48 89 e5             	mov    %rsp,%rbp
  802713:	48 83 ec 18          	sub    $0x18,%rsp
  802717:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80271a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80271d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802721:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802724:	48 89 d6             	mov    %rdx,%rsi
  802727:	89 c7                	mov    %eax,%edi
  802729:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  802730:	00 00 00 
  802733:	ff d0                	callq  *%rax
  802735:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802738:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273c:	79 05                	jns    802743 <seek+0x34>
		return r;
  80273e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802741:	eb 0f                	jmp    802752 <seek+0x43>
	fd->fd_offset = offset;
  802743:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802747:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80274a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80274d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802752:	c9                   	leaveq 
  802753:	c3                   	retq   

0000000000802754 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802754:	55                   	push   %rbp
  802755:	48 89 e5             	mov    %rsp,%rbp
  802758:	48 83 ec 30          	sub    $0x30,%rsp
  80275c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80275f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802762:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802766:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802769:	48 89 d6             	mov    %rdx,%rsi
  80276c:	89 c7                	mov    %eax,%edi
  80276e:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  802775:	00 00 00 
  802778:	ff d0                	callq  *%rax
  80277a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80277d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802781:	78 24                	js     8027a7 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802783:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802787:	8b 00                	mov    (%rax),%eax
  802789:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80278d:	48 89 d6             	mov    %rdx,%rsi
  802790:	89 c7                	mov    %eax,%edi
  802792:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  802799:	00 00 00 
  80279c:	ff d0                	callq  *%rax
  80279e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027a5:	79 05                	jns    8027ac <ftruncate+0x58>
		return r;
  8027a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027aa:	eb 72                	jmp    80281e <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8027ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027b0:	8b 40 08             	mov    0x8(%rax),%eax
  8027b3:	83 e0 03             	and    $0x3,%eax
  8027b6:	85 c0                	test   %eax,%eax
  8027b8:	75 3a                	jne    8027f4 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8027ba:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8027c1:	00 00 00 
  8027c4:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8027c7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027cd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027d0:	89 c6                	mov    %eax,%esi
  8027d2:	48 bf 48 42 80 00 00 	movabs $0x804248,%rdi
  8027d9:	00 00 00 
  8027dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e1:	48 b9 3d 03 80 00 00 	movabs $0x80033d,%rcx
  8027e8:	00 00 00 
  8027eb:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8027ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027f2:	eb 2a                	jmp    80281e <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8027f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f8:	48 8b 40 30          	mov    0x30(%rax),%rax
  8027fc:	48 85 c0             	test   %rax,%rax
  8027ff:	75 07                	jne    802808 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802801:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802806:	eb 16                	jmp    80281e <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802808:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80280c:	48 8b 40 30          	mov    0x30(%rax),%rax
  802810:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802814:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802817:	89 ce                	mov    %ecx,%esi
  802819:	48 89 d7             	mov    %rdx,%rdi
  80281c:	ff d0                	callq  *%rax
}
  80281e:	c9                   	leaveq 
  80281f:	c3                   	retq   

0000000000802820 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802820:	55                   	push   %rbp
  802821:	48 89 e5             	mov    %rsp,%rbp
  802824:	48 83 ec 30          	sub    $0x30,%rsp
  802828:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80282b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80282f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802833:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802836:	48 89 d6             	mov    %rdx,%rsi
  802839:	89 c7                	mov    %eax,%edi
  80283b:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  802842:	00 00 00 
  802845:	ff d0                	callq  *%rax
  802847:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80284e:	78 24                	js     802874 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802854:	8b 00                	mov    (%rax),%eax
  802856:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80285a:	48 89 d6             	mov    %rdx,%rsi
  80285d:	89 c7                	mov    %eax,%edi
  80285f:	48 b8 18 22 80 00 00 	movabs $0x802218,%rax
  802866:	00 00 00 
  802869:	ff d0                	callq  *%rax
  80286b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80286e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802872:	79 05                	jns    802879 <fstat+0x59>
		return r;
  802874:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802877:	eb 5e                	jmp    8028d7 <fstat+0xb7>
	if (!dev->dev_stat)
  802879:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802881:	48 85 c0             	test   %rax,%rax
  802884:	75 07                	jne    80288d <fstat+0x6d>
		return -E_NOT_SUPP;
  802886:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80288b:	eb 4a                	jmp    8028d7 <fstat+0xb7>
	stat->st_name[0] = 0;
  80288d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802891:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802894:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802898:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80289f:	00 00 00 
	stat->st_isdir = 0;
  8028a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028a6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8028ad:	00 00 00 
	stat->st_dev = dev;
  8028b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028b8:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8028bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028c3:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8028cb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8028cf:	48 89 ce             	mov    %rcx,%rsi
  8028d2:	48 89 d7             	mov    %rdx,%rdi
  8028d5:	ff d0                	callq  *%rax
}
  8028d7:	c9                   	leaveq 
  8028d8:	c3                   	retq   

00000000008028d9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8028d9:	55                   	push   %rbp
  8028da:	48 89 e5             	mov    %rsp,%rbp
  8028dd:	48 83 ec 20          	sub    $0x20,%rsp
  8028e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8028e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ed:	be 00 00 00 00       	mov    $0x0,%esi
  8028f2:	48 89 c7             	mov    %rax,%rdi
  8028f5:	48 b8 c7 29 80 00 00 	movabs $0x8029c7,%rax
  8028fc:	00 00 00 
  8028ff:	ff d0                	callq  *%rax
  802901:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802904:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802908:	79 05                	jns    80290f <stat+0x36>
		return fd;
  80290a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80290d:	eb 2f                	jmp    80293e <stat+0x65>
	r = fstat(fd, stat);
  80290f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802913:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802916:	48 89 d6             	mov    %rdx,%rsi
  802919:	89 c7                	mov    %eax,%edi
  80291b:	48 b8 20 28 80 00 00 	movabs $0x802820,%rax
  802922:	00 00 00 
  802925:	ff d0                	callq  *%rax
  802927:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80292a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292d:	89 c7                	mov    %eax,%edi
  80292f:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  802936:	00 00 00 
  802939:	ff d0                	callq  *%rax
	return r;
  80293b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80293e:	c9                   	leaveq 
  80293f:	c3                   	retq   

0000000000802940 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802940:	55                   	push   %rbp
  802941:	48 89 e5             	mov    %rsp,%rbp
  802944:	48 83 ec 10          	sub    $0x10,%rsp
  802948:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80294b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80294f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802956:	00 00 00 
  802959:	8b 00                	mov    (%rax),%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	75 1d                	jne    80297c <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80295f:	bf 01 00 00 00       	mov    $0x1,%edi
  802964:	48 b8 3c 3b 80 00 00 	movabs $0x803b3c,%rax
  80296b:	00 00 00 
  80296e:	ff d0                	callq  *%rax
  802970:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802977:	00 00 00 
  80297a:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80297c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802983:	00 00 00 
  802986:	8b 00                	mov    (%rax),%eax
  802988:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80298b:	b9 07 00 00 00       	mov    $0x7,%ecx
  802990:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802997:	00 00 00 
  80299a:	89 c7                	mov    %eax,%edi
  80299c:	48 b8 9f 3a 80 00 00 	movabs $0x803a9f,%rax
  8029a3:	00 00 00 
  8029a6:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8029a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b1:	48 89 c6             	mov    %rax,%rsi
  8029b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b9:	48 b8 d9 39 80 00 00 	movabs $0x8039d9,%rax
  8029c0:	00 00 00 
  8029c3:	ff d0                	callq  *%rax
}
  8029c5:	c9                   	leaveq 
  8029c6:	c3                   	retq   

00000000008029c7 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8029c7:	55                   	push   %rbp
  8029c8:	48 89 e5             	mov    %rsp,%rbp
  8029cb:	48 83 ec 20          	sub    $0x20,%rsp
  8029cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8029d3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  8029d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029da:	48 89 c7             	mov    %rax,%rdi
  8029dd:	48 b8 86 0e 80 00 00 	movabs $0x800e86,%rax
  8029e4:	00 00 00 
  8029e7:	ff d0                	callq  *%rax
  8029e9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029ee:	7e 0a                	jle    8029fa <open+0x33>
  8029f0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029f5:	e9 a5 00 00 00       	jmpq   802a9f <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8029fa:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8029fe:	48 89 c7             	mov    %rax,%rdi
  802a01:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  802a08:	00 00 00 
  802a0b:	ff d0                	callq  *%rax
  802a0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a14:	79 08                	jns    802a1e <open+0x57>
		return r;
  802a16:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a19:	e9 81 00 00 00       	jmpq   802a9f <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802a1e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a25:	00 00 00 
  802a28:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802a2b:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a35:	48 89 c6             	mov    %rax,%rsi
  802a38:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a3f:	00 00 00 
  802a42:	48 b8 f2 0e 80 00 00 	movabs $0x800ef2,%rax
  802a49:	00 00 00 
  802a4c:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802a4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a52:	48 89 c6             	mov    %rax,%rsi
  802a55:	bf 01 00 00 00       	mov    $0x1,%edi
  802a5a:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  802a61:	00 00 00 
  802a64:	ff d0                	callq  *%rax
  802a66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6d:	79 1d                	jns    802a8c <open+0xc5>
		fd_close(fd, 0);
  802a6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a73:	be 00 00 00 00       	mov    $0x0,%esi
  802a78:	48 89 c7             	mov    %rax,%rdi
  802a7b:	48 b8 4f 21 80 00 00 	movabs $0x80214f,%rax
  802a82:	00 00 00 
  802a85:	ff d0                	callq  *%rax
		return r;
  802a87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a8a:	eb 13                	jmp    802a9f <open+0xd8>
	}
	return fd2num(fd);
  802a8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a90:	48 89 c7             	mov    %rax,%rdi
  802a93:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  802a9a:	00 00 00 
  802a9d:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802a9f:	c9                   	leaveq 
  802aa0:	c3                   	retq   

0000000000802aa1 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802aa1:	55                   	push   %rbp
  802aa2:	48 89 e5             	mov    %rsp,%rbp
  802aa5:	48 83 ec 10          	sub    $0x10,%rsp
  802aa9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802aad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ab1:	8b 50 0c             	mov    0xc(%rax),%edx
  802ab4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802abb:	00 00 00 
  802abe:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802ac0:	be 00 00 00 00       	mov    $0x0,%esi
  802ac5:	bf 06 00 00 00       	mov    $0x6,%edi
  802aca:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  802ad1:	00 00 00 
  802ad4:	ff d0                	callq  *%rax
}
  802ad6:	c9                   	leaveq 
  802ad7:	c3                   	retq   

0000000000802ad8 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802ad8:	55                   	push   %rbp
  802ad9:	48 89 e5             	mov    %rsp,%rbp
  802adc:	48 83 ec 30          	sub    $0x30,%rsp
  802ae0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ae4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ae8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802aec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af0:	8b 50 0c             	mov    0xc(%rax),%edx
  802af3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802afa:	00 00 00 
  802afd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802aff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b06:	00 00 00 
  802b09:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b0d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802b11:	be 00 00 00 00       	mov    $0x0,%esi
  802b16:	bf 03 00 00 00       	mov    $0x3,%edi
  802b1b:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  802b22:	00 00 00 
  802b25:	ff d0                	callq  *%rax
  802b27:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b2e:	79 05                	jns    802b35 <devfile_read+0x5d>
		return r;
  802b30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b33:	eb 26                	jmp    802b5b <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802b35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b38:	48 63 d0             	movslq %eax,%rdx
  802b3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b3f:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802b46:	00 00 00 
  802b49:	48 89 c7             	mov    %rax,%rdi
  802b4c:	48 b8 2d 13 80 00 00 	movabs $0x80132d,%rax
  802b53:	00 00 00 
  802b56:	ff d0                	callq  *%rax
	return r;
  802b58:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802b5b:	c9                   	leaveq 
  802b5c:	c3                   	retq   

0000000000802b5d <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802b5d:	55                   	push   %rbp
  802b5e:	48 89 e5             	mov    %rsp,%rbp
  802b61:	48 83 ec 30          	sub    $0x30,%rsp
  802b65:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b69:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b6d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802b71:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802b78:	00 
	n = n > max ? max : n;
  802b79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b7d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802b81:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802b86:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802b8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b8e:	8b 50 0c             	mov    0xc(%rax),%edx
  802b91:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b98:	00 00 00 
  802b9b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802b9d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ba4:	00 00 00 
  802ba7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bab:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802baf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802bb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bb7:	48 89 c6             	mov    %rax,%rsi
  802bba:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802bc1:	00 00 00 
  802bc4:	48 b8 2d 13 80 00 00 	movabs $0x80132d,%rax
  802bcb:	00 00 00 
  802bce:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802bd0:	be 00 00 00 00       	mov    $0x0,%esi
  802bd5:	bf 04 00 00 00       	mov    $0x4,%edi
  802bda:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  802be1:	00 00 00 
  802be4:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802be6:	c9                   	leaveq 
  802be7:	c3                   	retq   

0000000000802be8 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802be8:	55                   	push   %rbp
  802be9:	48 89 e5             	mov    %rsp,%rbp
  802bec:	48 83 ec 20          	sub    $0x20,%rsp
  802bf0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802bf4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfc:	8b 50 0c             	mov    0xc(%rax),%edx
  802bff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c06:	00 00 00 
  802c09:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802c0b:	be 00 00 00 00       	mov    $0x0,%esi
  802c10:	bf 05 00 00 00       	mov    $0x5,%edi
  802c15:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  802c1c:	00 00 00 
  802c1f:	ff d0                	callq  *%rax
  802c21:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c28:	79 05                	jns    802c2f <devfile_stat+0x47>
		return r;
  802c2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2d:	eb 56                	jmp    802c85 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802c2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c33:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c3a:	00 00 00 
  802c3d:	48 89 c7             	mov    %rax,%rdi
  802c40:	48 b8 f2 0e 80 00 00 	movabs $0x800ef2,%rax
  802c47:	00 00 00 
  802c4a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802c4c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c53:	00 00 00 
  802c56:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802c5c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c60:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802c66:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c6d:	00 00 00 
  802c70:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802c76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c7a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c85:	c9                   	leaveq 
  802c86:	c3                   	retq   

0000000000802c87 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802c87:	55                   	push   %rbp
  802c88:	48 89 e5             	mov    %rsp,%rbp
  802c8b:	48 83 ec 10          	sub    $0x10,%rsp
  802c8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802c93:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802c96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c9a:	8b 50 0c             	mov    0xc(%rax),%edx
  802c9d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802ca4:	00 00 00 
  802ca7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ca9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802cb0:	00 00 00 
  802cb3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802cb6:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802cb9:	be 00 00 00 00       	mov    $0x0,%esi
  802cbe:	bf 02 00 00 00       	mov    $0x2,%edi
  802cc3:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  802cca:	00 00 00 
  802ccd:	ff d0                	callq  *%rax
}
  802ccf:	c9                   	leaveq 
  802cd0:	c3                   	retq   

0000000000802cd1 <remove>:

// Delete a file
int
remove(const char *path)
{
  802cd1:	55                   	push   %rbp
  802cd2:	48 89 e5             	mov    %rsp,%rbp
  802cd5:	48 83 ec 10          	sub    $0x10,%rsp
  802cd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802cdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ce1:	48 89 c7             	mov    %rax,%rdi
  802ce4:	48 b8 86 0e 80 00 00 	movabs $0x800e86,%rax
  802ceb:	00 00 00 
  802cee:	ff d0                	callq  *%rax
  802cf0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802cf5:	7e 07                	jle    802cfe <remove+0x2d>
		return -E_BAD_PATH;
  802cf7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802cfc:	eb 33                	jmp    802d31 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802cfe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d02:	48 89 c6             	mov    %rax,%rsi
  802d05:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802d0c:	00 00 00 
  802d0f:	48 b8 f2 0e 80 00 00 	movabs $0x800ef2,%rax
  802d16:	00 00 00 
  802d19:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802d1b:	be 00 00 00 00       	mov    $0x0,%esi
  802d20:	bf 07 00 00 00       	mov    $0x7,%edi
  802d25:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  802d2c:	00 00 00 
  802d2f:	ff d0                	callq  *%rax
}
  802d31:	c9                   	leaveq 
  802d32:	c3                   	retq   

0000000000802d33 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802d33:	55                   	push   %rbp
  802d34:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802d37:	be 00 00 00 00       	mov    $0x0,%esi
  802d3c:	bf 08 00 00 00       	mov    $0x8,%edi
  802d41:	48 b8 40 29 80 00 00 	movabs $0x802940,%rax
  802d48:	00 00 00 
  802d4b:	ff d0                	callq  *%rax
}
  802d4d:	5d                   	pop    %rbp
  802d4e:	c3                   	retq   

0000000000802d4f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802d4f:	55                   	push   %rbp
  802d50:	48 89 e5             	mov    %rsp,%rbp
  802d53:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802d5a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802d61:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802d68:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802d6f:	be 00 00 00 00       	mov    $0x0,%esi
  802d74:	48 89 c7             	mov    %rax,%rdi
  802d77:	48 b8 c7 29 80 00 00 	movabs $0x8029c7,%rax
  802d7e:	00 00 00 
  802d81:	ff d0                	callq  *%rax
  802d83:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802d86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8a:	79 28                	jns    802db4 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802d8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8f:	89 c6                	mov    %eax,%esi
  802d91:	48 bf 6e 42 80 00 00 	movabs $0x80426e,%rdi
  802d98:	00 00 00 
  802d9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802da0:	48 ba 3d 03 80 00 00 	movabs $0x80033d,%rdx
  802da7:	00 00 00 
  802daa:	ff d2                	callq  *%rdx
		return fd_src;
  802dac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802daf:	e9 74 01 00 00       	jmpq   802f28 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802db4:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802dbb:	be 01 01 00 00       	mov    $0x101,%esi
  802dc0:	48 89 c7             	mov    %rax,%rdi
  802dc3:	48 b8 c7 29 80 00 00 	movabs $0x8029c7,%rax
  802dca:	00 00 00 
  802dcd:	ff d0                	callq  *%rax
  802dcf:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802dd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dd6:	79 39                	jns    802e11 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802dd8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ddb:	89 c6                	mov    %eax,%esi
  802ddd:	48 bf 84 42 80 00 00 	movabs $0x804284,%rdi
  802de4:	00 00 00 
  802de7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dec:	48 ba 3d 03 80 00 00 	movabs $0x80033d,%rdx
  802df3:	00 00 00 
  802df6:	ff d2                	callq  *%rdx
		close(fd_src);
  802df8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfb:	89 c7                	mov    %eax,%edi
  802dfd:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  802e04:	00 00 00 
  802e07:	ff d0                	callq  *%rax
		return fd_dest;
  802e09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e0c:	e9 17 01 00 00       	jmpq   802f28 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e11:	eb 74                	jmp    802e87 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802e13:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802e16:	48 63 d0             	movslq %eax,%rdx
  802e19:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e20:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e23:	48 89 ce             	mov    %rcx,%rsi
  802e26:	89 c7                	mov    %eax,%edi
  802e28:	48 b8 3b 26 80 00 00 	movabs $0x80263b,%rax
  802e2f:	00 00 00 
  802e32:	ff d0                	callq  *%rax
  802e34:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802e37:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802e3b:	79 4a                	jns    802e87 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802e3d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e40:	89 c6                	mov    %eax,%esi
  802e42:	48 bf 9e 42 80 00 00 	movabs $0x80429e,%rdi
  802e49:	00 00 00 
  802e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e51:	48 ba 3d 03 80 00 00 	movabs $0x80033d,%rdx
  802e58:	00 00 00 
  802e5b:	ff d2                	callq  *%rdx
			close(fd_src);
  802e5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e60:	89 c7                	mov    %eax,%edi
  802e62:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  802e69:	00 00 00 
  802e6c:	ff d0                	callq  *%rax
			close(fd_dest);
  802e6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e71:	89 c7                	mov    %eax,%edi
  802e73:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  802e7a:	00 00 00 
  802e7d:	ff d0                	callq  *%rax
			return write_size;
  802e7f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802e82:	e9 a1 00 00 00       	jmpq   802f28 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802e87:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802e8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e91:	ba 00 02 00 00       	mov    $0x200,%edx
  802e96:	48 89 ce             	mov    %rcx,%rsi
  802e99:	89 c7                	mov    %eax,%edi
  802e9b:	48 b8 f1 24 80 00 00 	movabs $0x8024f1,%rax
  802ea2:	00 00 00 
  802ea5:	ff d0                	callq  *%rax
  802ea7:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802eaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802eae:	0f 8f 5f ff ff ff    	jg     802e13 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802eb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802eb8:	79 47                	jns    802f01 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802eba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ebd:	89 c6                	mov    %eax,%esi
  802ebf:	48 bf b1 42 80 00 00 	movabs $0x8042b1,%rdi
  802ec6:	00 00 00 
  802ec9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ece:	48 ba 3d 03 80 00 00 	movabs $0x80033d,%rdx
  802ed5:	00 00 00 
  802ed8:	ff d2                	callq  *%rdx
		close(fd_src);
  802eda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802edd:	89 c7                	mov    %eax,%edi
  802edf:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  802ee6:	00 00 00 
  802ee9:	ff d0                	callq  *%rax
		close(fd_dest);
  802eeb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802eee:	89 c7                	mov    %eax,%edi
  802ef0:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  802ef7:	00 00 00 
  802efa:	ff d0                	callq  *%rax
		return read_size;
  802efc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802eff:	eb 27                	jmp    802f28 <copy+0x1d9>
	}
	close(fd_src);
  802f01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f04:	89 c7                	mov    %eax,%edi
  802f06:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  802f0d:	00 00 00 
  802f10:	ff d0                	callq  *%rax
	close(fd_dest);
  802f12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f15:	89 c7                	mov    %eax,%edi
  802f17:	48 b8 cf 22 80 00 00 	movabs $0x8022cf,%rax
  802f1e:	00 00 00 
  802f21:	ff d0                	callq  *%rax
	return 0;
  802f23:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802f28:	c9                   	leaveq 
  802f29:	c3                   	retq   

0000000000802f2a <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802f2a:	55                   	push   %rbp
  802f2b:	48 89 e5             	mov    %rsp,%rbp
  802f2e:	53                   	push   %rbx
  802f2f:	48 83 ec 38          	sub    $0x38,%rsp
  802f33:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802f37:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802f3b:	48 89 c7             	mov    %rax,%rdi
  802f3e:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  802f45:	00 00 00 
  802f48:	ff d0                	callq  *%rax
  802f4a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f51:	0f 88 bf 01 00 00    	js     803116 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f5b:	ba 07 04 00 00       	mov    $0x407,%edx
  802f60:	48 89 c6             	mov    %rax,%rsi
  802f63:	bf 00 00 00 00       	mov    $0x0,%edi
  802f68:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  802f6f:	00 00 00 
  802f72:	ff d0                	callq  *%rax
  802f74:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f77:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f7b:	0f 88 95 01 00 00    	js     803116 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802f81:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802f85:	48 89 c7             	mov    %rax,%rdi
  802f88:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  802f8f:	00 00 00 
  802f92:	ff d0                	callq  *%rax
  802f94:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f97:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f9b:	0f 88 5d 01 00 00    	js     8030fe <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fa1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fa5:	ba 07 04 00 00       	mov    $0x407,%edx
  802faa:	48 89 c6             	mov    %rax,%rsi
  802fad:	bf 00 00 00 00       	mov    $0x0,%edi
  802fb2:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  802fb9:	00 00 00 
  802fbc:	ff d0                	callq  *%rax
  802fbe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fc5:	0f 88 33 01 00 00    	js     8030fe <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802fcb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fcf:	48 89 c7             	mov    %rax,%rdi
  802fd2:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  802fd9:	00 00 00 
  802fdc:	ff d0                	callq  *%rax
  802fde:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fe2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fe6:	ba 07 04 00 00       	mov    $0x407,%edx
  802feb:	48 89 c6             	mov    %rax,%rsi
  802fee:	bf 00 00 00 00       	mov    $0x0,%edi
  802ff3:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  802ffa:	00 00 00 
  802ffd:	ff d0                	callq  *%rax
  802fff:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803002:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803006:	79 05                	jns    80300d <pipe+0xe3>
		goto err2;
  803008:	e9 d9 00 00 00       	jmpq   8030e6 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80300d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803011:	48 89 c7             	mov    %rax,%rdi
  803014:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  80301b:	00 00 00 
  80301e:	ff d0                	callq  *%rax
  803020:	48 89 c2             	mov    %rax,%rdx
  803023:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803027:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80302d:	48 89 d1             	mov    %rdx,%rcx
  803030:	ba 00 00 00 00       	mov    $0x0,%edx
  803035:	48 89 c6             	mov    %rax,%rsi
  803038:	bf 00 00 00 00       	mov    $0x0,%edi
  80303d:	48 b8 71 18 80 00 00 	movabs $0x801871,%rax
  803044:	00 00 00 
  803047:	ff d0                	callq  *%rax
  803049:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80304c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803050:	79 1b                	jns    80306d <pipe+0x143>
		goto err3;
  803052:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803053:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803057:	48 89 c6             	mov    %rax,%rsi
  80305a:	bf 00 00 00 00       	mov    $0x0,%edi
  80305f:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  803066:	00 00 00 
  803069:	ff d0                	callq  *%rax
  80306b:	eb 79                	jmp    8030e6 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80306d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803071:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803078:	00 00 00 
  80307b:	8b 12                	mov    (%rdx),%edx
  80307d:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80307f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803083:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80308a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80308e:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  803095:	00 00 00 
  803098:	8b 12                	mov    (%rdx),%edx
  80309a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80309c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030a0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8030a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030ab:	48 89 c7             	mov    %rax,%rdi
  8030ae:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  8030b5:	00 00 00 
  8030b8:	ff d0                	callq  *%rax
  8030ba:	89 c2                	mov    %eax,%edx
  8030bc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030c0:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8030c2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030c6:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8030ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030ce:	48 89 c7             	mov    %rax,%rdi
  8030d1:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  8030d8:	00 00 00 
  8030db:	ff d0                	callq  *%rax
  8030dd:	89 03                	mov    %eax,(%rbx)
	return 0;
  8030df:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e4:	eb 33                	jmp    803119 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8030e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030ea:	48 89 c6             	mov    %rax,%rsi
  8030ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8030f2:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  8030f9:	00 00 00 
  8030fc:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8030fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803102:	48 89 c6             	mov    %rax,%rsi
  803105:	bf 00 00 00 00       	mov    $0x0,%edi
  80310a:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  803111:	00 00 00 
  803114:	ff d0                	callq  *%rax
err:
	return r;
  803116:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803119:	48 83 c4 38          	add    $0x38,%rsp
  80311d:	5b                   	pop    %rbx
  80311e:	5d                   	pop    %rbp
  80311f:	c3                   	retq   

0000000000803120 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803120:	55                   	push   %rbp
  803121:	48 89 e5             	mov    %rsp,%rbp
  803124:	53                   	push   %rbx
  803125:	48 83 ec 28          	sub    $0x28,%rsp
  803129:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80312d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803131:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803138:	00 00 00 
  80313b:	48 8b 00             	mov    (%rax),%rax
  80313e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803144:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803147:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80314b:	48 89 c7             	mov    %rax,%rdi
  80314e:	48 b8 be 3b 80 00 00 	movabs $0x803bbe,%rax
  803155:	00 00 00 
  803158:	ff d0                	callq  *%rax
  80315a:	89 c3                	mov    %eax,%ebx
  80315c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803160:	48 89 c7             	mov    %rax,%rdi
  803163:	48 b8 be 3b 80 00 00 	movabs $0x803bbe,%rax
  80316a:	00 00 00 
  80316d:	ff d0                	callq  *%rax
  80316f:	39 c3                	cmp    %eax,%ebx
  803171:	0f 94 c0             	sete   %al
  803174:	0f b6 c0             	movzbl %al,%eax
  803177:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80317a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803181:	00 00 00 
  803184:	48 8b 00             	mov    (%rax),%rax
  803187:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80318d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803190:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803193:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803196:	75 05                	jne    80319d <_pipeisclosed+0x7d>
			return ret;
  803198:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80319b:	eb 4f                	jmp    8031ec <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80319d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031a0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8031a3:	74 42                	je     8031e7 <_pipeisclosed+0xc7>
  8031a5:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8031a9:	75 3c                	jne    8031e7 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8031ab:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8031b2:	00 00 00 
  8031b5:	48 8b 00             	mov    (%rax),%rax
  8031b8:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8031be:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8031c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031c4:	89 c6                	mov    %eax,%esi
  8031c6:	48 bf cc 42 80 00 00 	movabs $0x8042cc,%rdi
  8031cd:	00 00 00 
  8031d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d5:	49 b8 3d 03 80 00 00 	movabs $0x80033d,%r8
  8031dc:	00 00 00 
  8031df:	41 ff d0             	callq  *%r8
	}
  8031e2:	e9 4a ff ff ff       	jmpq   803131 <_pipeisclosed+0x11>
  8031e7:	e9 45 ff ff ff       	jmpq   803131 <_pipeisclosed+0x11>
}
  8031ec:	48 83 c4 28          	add    $0x28,%rsp
  8031f0:	5b                   	pop    %rbx
  8031f1:	5d                   	pop    %rbp
  8031f2:	c3                   	retq   

00000000008031f3 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8031f3:	55                   	push   %rbp
  8031f4:	48 89 e5             	mov    %rsp,%rbp
  8031f7:	48 83 ec 30          	sub    $0x30,%rsp
  8031fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031fe:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803202:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803205:	48 89 d6             	mov    %rdx,%rsi
  803208:	89 c7                	mov    %eax,%edi
  80320a:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  803211:	00 00 00 
  803214:	ff d0                	callq  *%rax
  803216:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803219:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321d:	79 05                	jns    803224 <pipeisclosed+0x31>
		return r;
  80321f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803222:	eb 31                	jmp    803255 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803228:	48 89 c7             	mov    %rax,%rdi
  80322b:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  803232:	00 00 00 
  803235:	ff d0                	callq  *%rax
  803237:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80323b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80323f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803243:	48 89 d6             	mov    %rdx,%rsi
  803246:	48 89 c7             	mov    %rax,%rdi
  803249:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  803250:	00 00 00 
  803253:	ff d0                	callq  *%rax
}
  803255:	c9                   	leaveq 
  803256:	c3                   	retq   

0000000000803257 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803257:	55                   	push   %rbp
  803258:	48 89 e5             	mov    %rsp,%rbp
  80325b:	48 83 ec 40          	sub    $0x40,%rsp
  80325f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803263:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803267:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80326b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80326f:	48 89 c7             	mov    %rax,%rdi
  803272:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  803279:	00 00 00 
  80327c:	ff d0                	callq  *%rax
  80327e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803282:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803286:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80328a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803291:	00 
  803292:	e9 92 00 00 00       	jmpq   803329 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803297:	eb 41                	jmp    8032da <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803299:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80329e:	74 09                	je     8032a9 <devpipe_read+0x52>
				return i;
  8032a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032a4:	e9 92 00 00 00       	jmpq   80333b <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8032a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b1:	48 89 d6             	mov    %rdx,%rsi
  8032b4:	48 89 c7             	mov    %rax,%rdi
  8032b7:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  8032be:	00 00 00 
  8032c1:	ff d0                	callq  *%rax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	74 07                	je     8032ce <devpipe_read+0x77>
				return 0;
  8032c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cc:	eb 6d                	jmp    80333b <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8032ce:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  8032d5:	00 00 00 
  8032d8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8032da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032de:	8b 10                	mov    (%rax),%edx
  8032e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e4:	8b 40 04             	mov    0x4(%rax),%eax
  8032e7:	39 c2                	cmp    %eax,%edx
  8032e9:	74 ae                	je     803299 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8032eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032f3:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8032f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032fb:	8b 00                	mov    (%rax),%eax
  8032fd:	99                   	cltd   
  8032fe:	c1 ea 1b             	shr    $0x1b,%edx
  803301:	01 d0                	add    %edx,%eax
  803303:	83 e0 1f             	and    $0x1f,%eax
  803306:	29 d0                	sub    %edx,%eax
  803308:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80330c:	48 98                	cltq   
  80330e:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803313:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803319:	8b 00                	mov    (%rax),%eax
  80331b:	8d 50 01             	lea    0x1(%rax),%edx
  80331e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803322:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803324:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80332d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803331:	0f 82 60 ff ff ff    	jb     803297 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803337:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80333b:	c9                   	leaveq 
  80333c:	c3                   	retq   

000000000080333d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80333d:	55                   	push   %rbp
  80333e:	48 89 e5             	mov    %rsp,%rbp
  803341:	48 83 ec 40          	sub    $0x40,%rsp
  803345:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803349:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80334d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803351:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803355:	48 89 c7             	mov    %rax,%rdi
  803358:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  80335f:	00 00 00 
  803362:	ff d0                	callq  *%rax
  803364:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803368:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80336c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803370:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803377:	00 
  803378:	e9 8e 00 00 00       	jmpq   80340b <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80337d:	eb 31                	jmp    8033b0 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80337f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803387:	48 89 d6             	mov    %rdx,%rsi
  80338a:	48 89 c7             	mov    %rax,%rdi
  80338d:	48 b8 20 31 80 00 00 	movabs $0x803120,%rax
  803394:	00 00 00 
  803397:	ff d0                	callq  *%rax
  803399:	85 c0                	test   %eax,%eax
  80339b:	74 07                	je     8033a4 <devpipe_write+0x67>
				return 0;
  80339d:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a2:	eb 79                	jmp    80341d <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8033a4:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  8033ab:	00 00 00 
  8033ae:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8033b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b4:	8b 40 04             	mov    0x4(%rax),%eax
  8033b7:	48 63 d0             	movslq %eax,%rdx
  8033ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033be:	8b 00                	mov    (%rax),%eax
  8033c0:	48 98                	cltq   
  8033c2:	48 83 c0 20          	add    $0x20,%rax
  8033c6:	48 39 c2             	cmp    %rax,%rdx
  8033c9:	73 b4                	jae    80337f <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8033cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033cf:	8b 40 04             	mov    0x4(%rax),%eax
  8033d2:	99                   	cltd   
  8033d3:	c1 ea 1b             	shr    $0x1b,%edx
  8033d6:	01 d0                	add    %edx,%eax
  8033d8:	83 e0 1f             	and    $0x1f,%eax
  8033db:	29 d0                	sub    %edx,%eax
  8033dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033e1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8033e5:	48 01 ca             	add    %rcx,%rdx
  8033e8:	0f b6 0a             	movzbl (%rdx),%ecx
  8033eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033ef:	48 98                	cltq   
  8033f1:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8033f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f9:	8b 40 04             	mov    0x4(%rax),%eax
  8033fc:	8d 50 01             	lea    0x1(%rax),%edx
  8033ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803403:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803406:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80340b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80340f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803413:	0f 82 64 ff ff ff    	jb     80337d <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803419:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80341d:	c9                   	leaveq 
  80341e:	c3                   	retq   

000000000080341f <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80341f:	55                   	push   %rbp
  803420:	48 89 e5             	mov    %rsp,%rbp
  803423:	48 83 ec 20          	sub    $0x20,%rsp
  803427:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80342b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80342f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803433:	48 89 c7             	mov    %rax,%rdi
  803436:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  80343d:	00 00 00 
  803440:	ff d0                	callq  *%rax
  803442:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803446:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80344a:	48 be df 42 80 00 00 	movabs $0x8042df,%rsi
  803451:	00 00 00 
  803454:	48 89 c7             	mov    %rax,%rdi
  803457:	48 b8 f2 0e 80 00 00 	movabs $0x800ef2,%rax
  80345e:	00 00 00 
  803461:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803463:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803467:	8b 50 04             	mov    0x4(%rax),%edx
  80346a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80346e:	8b 00                	mov    (%rax),%eax
  803470:	29 c2                	sub    %eax,%edx
  803472:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803476:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80347c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803480:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803487:	00 00 00 
	stat->st_dev = &devpipe;
  80348a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80348e:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803495:	00 00 00 
  803498:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80349f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034a4:	c9                   	leaveq 
  8034a5:	c3                   	retq   

00000000008034a6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8034a6:	55                   	push   %rbp
  8034a7:	48 89 e5             	mov    %rsp,%rbp
  8034aa:	48 83 ec 10          	sub    $0x10,%rsp
  8034ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8034b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b6:	48 89 c6             	mov    %rax,%rsi
  8034b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8034be:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  8034c5:	00 00 00 
  8034c8:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8034ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ce:	48 89 c7             	mov    %rax,%rdi
  8034d1:	48 b8 fc 1f 80 00 00 	movabs $0x801ffc,%rax
  8034d8:	00 00 00 
  8034db:	ff d0                	callq  *%rax
  8034dd:	48 89 c6             	mov    %rax,%rsi
  8034e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e5:	48 b8 cc 18 80 00 00 	movabs $0x8018cc,%rax
  8034ec:	00 00 00 
  8034ef:	ff d0                	callq  *%rax
}
  8034f1:	c9                   	leaveq 
  8034f2:	c3                   	retq   

00000000008034f3 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8034f3:	55                   	push   %rbp
  8034f4:	48 89 e5             	mov    %rsp,%rbp
  8034f7:	48 83 ec 20          	sub    $0x20,%rsp
  8034fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8034fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803501:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803504:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803508:	be 01 00 00 00       	mov    $0x1,%esi
  80350d:	48 89 c7             	mov    %rax,%rdi
  803510:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  803517:	00 00 00 
  80351a:	ff d0                	callq  *%rax
}
  80351c:	c9                   	leaveq 
  80351d:	c3                   	retq   

000000000080351e <getchar>:

int
getchar(void)
{
  80351e:	55                   	push   %rbp
  80351f:	48 89 e5             	mov    %rsp,%rbp
  803522:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803526:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80352a:	ba 01 00 00 00       	mov    $0x1,%edx
  80352f:	48 89 c6             	mov    %rax,%rsi
  803532:	bf 00 00 00 00       	mov    $0x0,%edi
  803537:	48 b8 f1 24 80 00 00 	movabs $0x8024f1,%rax
  80353e:	00 00 00 
  803541:	ff d0                	callq  *%rax
  803543:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803546:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80354a:	79 05                	jns    803551 <getchar+0x33>
		return r;
  80354c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354f:	eb 14                	jmp    803565 <getchar+0x47>
	if (r < 1)
  803551:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803555:	7f 07                	jg     80355e <getchar+0x40>
		return -E_EOF;
  803557:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80355c:	eb 07                	jmp    803565 <getchar+0x47>
	return c;
  80355e:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803562:	0f b6 c0             	movzbl %al,%eax
}
  803565:	c9                   	leaveq 
  803566:	c3                   	retq   

0000000000803567 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803567:	55                   	push   %rbp
  803568:	48 89 e5             	mov    %rsp,%rbp
  80356b:	48 83 ec 20          	sub    $0x20,%rsp
  80356f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803572:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803576:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803579:	48 89 d6             	mov    %rdx,%rsi
  80357c:	89 c7                	mov    %eax,%edi
  80357e:	48 b8 bf 20 80 00 00 	movabs $0x8020bf,%rax
  803585:	00 00 00 
  803588:	ff d0                	callq  *%rax
  80358a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803591:	79 05                	jns    803598 <iscons+0x31>
		return r;
  803593:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803596:	eb 1a                	jmp    8035b2 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803598:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80359c:	8b 10                	mov    (%rax),%edx
  80359e:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  8035a5:	00 00 00 
  8035a8:	8b 00                	mov    (%rax),%eax
  8035aa:	39 c2                	cmp    %eax,%edx
  8035ac:	0f 94 c0             	sete   %al
  8035af:	0f b6 c0             	movzbl %al,%eax
}
  8035b2:	c9                   	leaveq 
  8035b3:	c3                   	retq   

00000000008035b4 <opencons>:

int
opencons(void)
{
  8035b4:	55                   	push   %rbp
  8035b5:	48 89 e5             	mov    %rsp,%rbp
  8035b8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8035bc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8035c0:	48 89 c7             	mov    %rax,%rdi
  8035c3:	48 b8 27 20 80 00 00 	movabs $0x802027,%rax
  8035ca:	00 00 00 
  8035cd:	ff d0                	callq  *%rax
  8035cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035d6:	79 05                	jns    8035dd <opencons+0x29>
		return r;
  8035d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035db:	eb 5b                	jmp    803638 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8035dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e1:	ba 07 04 00 00       	mov    $0x407,%edx
  8035e6:	48 89 c6             	mov    %rax,%rsi
  8035e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ee:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  8035f5:	00 00 00 
  8035f8:	ff d0                	callq  *%rax
  8035fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803601:	79 05                	jns    803608 <opencons+0x54>
		return r;
  803603:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803606:	eb 30                	jmp    803638 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803608:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360c:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803613:	00 00 00 
  803616:	8b 12                	mov    (%rdx),%edx
  803618:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80361a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80361e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803625:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803629:	48 89 c7             	mov    %rax,%rdi
  80362c:	48 b8 d9 1f 80 00 00 	movabs $0x801fd9,%rax
  803633:	00 00 00 
  803636:	ff d0                	callq  *%rax
}
  803638:	c9                   	leaveq 
  803639:	c3                   	retq   

000000000080363a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80363a:	55                   	push   %rbp
  80363b:	48 89 e5             	mov    %rsp,%rbp
  80363e:	48 83 ec 30          	sub    $0x30,%rsp
  803642:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803646:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80364a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80364e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803653:	75 07                	jne    80365c <devcons_read+0x22>
		return 0;
  803655:	b8 00 00 00 00       	mov    $0x0,%eax
  80365a:	eb 4b                	jmp    8036a7 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80365c:	eb 0c                	jmp    80366a <devcons_read+0x30>
		sys_yield();
  80365e:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  803665:	00 00 00 
  803668:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80366a:	48 b8 23 17 80 00 00 	movabs $0x801723,%rax
  803671:	00 00 00 
  803674:	ff d0                	callq  *%rax
  803676:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803679:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80367d:	74 df                	je     80365e <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80367f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803683:	79 05                	jns    80368a <devcons_read+0x50>
		return c;
  803685:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803688:	eb 1d                	jmp    8036a7 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80368a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80368e:	75 07                	jne    803697 <devcons_read+0x5d>
		return 0;
  803690:	b8 00 00 00 00       	mov    $0x0,%eax
  803695:	eb 10                	jmp    8036a7 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803697:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80369a:	89 c2                	mov    %eax,%edx
  80369c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036a0:	88 10                	mov    %dl,(%rax)
	return 1;
  8036a2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8036a7:	c9                   	leaveq 
  8036a8:	c3                   	retq   

00000000008036a9 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8036a9:	55                   	push   %rbp
  8036aa:	48 89 e5             	mov    %rsp,%rbp
  8036ad:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8036b4:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8036bb:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8036c2:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8036c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8036d0:	eb 76                	jmp    803748 <devcons_write+0x9f>
		m = n - tot;
  8036d2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8036d9:	89 c2                	mov    %eax,%edx
  8036db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036de:	29 c2                	sub    %eax,%edx
  8036e0:	89 d0                	mov    %edx,%eax
  8036e2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8036e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036e8:	83 f8 7f             	cmp    $0x7f,%eax
  8036eb:	76 07                	jbe    8036f4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8036ed:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8036f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036f7:	48 63 d0             	movslq %eax,%rdx
  8036fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fd:	48 63 c8             	movslq %eax,%rcx
  803700:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803707:	48 01 c1             	add    %rax,%rcx
  80370a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803711:	48 89 ce             	mov    %rcx,%rsi
  803714:	48 89 c7             	mov    %rax,%rdi
  803717:	48 b8 16 12 80 00 00 	movabs $0x801216,%rax
  80371e:	00 00 00 
  803721:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803723:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803726:	48 63 d0             	movslq %eax,%rdx
  803729:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803730:	48 89 d6             	mov    %rdx,%rsi
  803733:	48 89 c7             	mov    %rax,%rdi
  803736:	48 b8 d9 16 80 00 00 	movabs $0x8016d9,%rax
  80373d:	00 00 00 
  803740:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803742:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803745:	01 45 fc             	add    %eax,-0x4(%rbp)
  803748:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80374b:	48 98                	cltq   
  80374d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803754:	0f 82 78 ff ff ff    	jb     8036d2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80375a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80375d:	c9                   	leaveq 
  80375e:	c3                   	retq   

000000000080375f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80375f:	55                   	push   %rbp
  803760:	48 89 e5             	mov    %rsp,%rbp
  803763:	48 83 ec 08          	sub    $0x8,%rsp
  803767:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80376b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803770:	c9                   	leaveq 
  803771:	c3                   	retq   

0000000000803772 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803772:	55                   	push   %rbp
  803773:	48 89 e5             	mov    %rsp,%rbp
  803776:	48 83 ec 10          	sub    $0x10,%rsp
  80377a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80377e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803782:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803786:	48 be eb 42 80 00 00 	movabs $0x8042eb,%rsi
  80378d:	00 00 00 
  803790:	48 89 c7             	mov    %rax,%rdi
  803793:	48 b8 f2 0e 80 00 00 	movabs $0x800ef2,%rax
  80379a:	00 00 00 
  80379d:	ff d0                	callq  *%rax
	return 0;
  80379f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037a4:	c9                   	leaveq 
  8037a5:	c3                   	retq   

00000000008037a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8037a6:	55                   	push   %rbp
  8037a7:	48 89 e5             	mov    %rsp,%rbp
  8037aa:	53                   	push   %rbx
  8037ab:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8037b2:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8037b9:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8037bf:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8037c6:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8037cd:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8037d4:	84 c0                	test   %al,%al
  8037d6:	74 23                	je     8037fb <_panic+0x55>
  8037d8:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8037df:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8037e3:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8037e7:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8037eb:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8037ef:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8037f3:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8037f7:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8037fb:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803802:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803809:	00 00 00 
  80380c:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803813:	00 00 00 
  803816:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80381a:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803821:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803828:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80382f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  803836:	00 00 00 
  803839:	48 8b 18             	mov    (%rax),%rbx
  80383c:	48 b8 a5 17 80 00 00 	movabs $0x8017a5,%rax
  803843:	00 00 00 
  803846:	ff d0                	callq  *%rax
  803848:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80384e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803855:	41 89 c8             	mov    %ecx,%r8d
  803858:	48 89 d1             	mov    %rdx,%rcx
  80385b:	48 89 da             	mov    %rbx,%rdx
  80385e:	89 c6                	mov    %eax,%esi
  803860:	48 bf f8 42 80 00 00 	movabs $0x8042f8,%rdi
  803867:	00 00 00 
  80386a:	b8 00 00 00 00       	mov    $0x0,%eax
  80386f:	49 b9 3d 03 80 00 00 	movabs $0x80033d,%r9
  803876:	00 00 00 
  803879:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80387c:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803883:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80388a:	48 89 d6             	mov    %rdx,%rsi
  80388d:	48 89 c7             	mov    %rax,%rdi
  803890:	48 b8 91 02 80 00 00 	movabs $0x800291,%rax
  803897:	00 00 00 
  80389a:	ff d0                	callq  *%rax
	cprintf("\n");
  80389c:	48 bf 1b 43 80 00 00 	movabs $0x80431b,%rdi
  8038a3:	00 00 00 
  8038a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ab:	48 ba 3d 03 80 00 00 	movabs $0x80033d,%rdx
  8038b2:	00 00 00 
  8038b5:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8038b7:	cc                   	int3   
  8038b8:	eb fd                	jmp    8038b7 <_panic+0x111>

00000000008038ba <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8038ba:	55                   	push   %rbp
  8038bb:	48 89 e5             	mov    %rsp,%rbp
  8038be:	48 83 ec 10          	sub    $0x10,%rsp
  8038c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8038c6:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8038cd:	00 00 00 
  8038d0:	48 8b 00             	mov    (%rax),%rax
  8038d3:	48 85 c0             	test   %rax,%rax
  8038d6:	75 64                	jne    80393c <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  8038d8:	ba 07 00 00 00       	mov    $0x7,%edx
  8038dd:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8038e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8038e7:	48 b8 21 18 80 00 00 	movabs $0x801821,%rax
  8038ee:	00 00 00 
  8038f1:	ff d0                	callq  *%rax
  8038f3:	85 c0                	test   %eax,%eax
  8038f5:	74 2a                	je     803921 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  8038f7:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  8038fe:	00 00 00 
  803901:	be 22 00 00 00       	mov    $0x22,%esi
  803906:	48 bf 48 43 80 00 00 	movabs $0x804348,%rdi
  80390d:	00 00 00 
  803910:	b8 00 00 00 00       	mov    $0x0,%eax
  803915:	48 b9 a6 37 80 00 00 	movabs $0x8037a6,%rcx
  80391c:	00 00 00 
  80391f:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803921:	48 be 4f 39 80 00 00 	movabs $0x80394f,%rsi
  803928:	00 00 00 
  80392b:	bf 00 00 00 00       	mov    $0x0,%edi
  803930:	48 b8 ab 19 80 00 00 	movabs $0x8019ab,%rax
  803937:	00 00 00 
  80393a:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80393c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803943:	00 00 00 
  803946:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80394a:	48 89 10             	mov    %rdx,(%rax)
}
  80394d:	c9                   	leaveq 
  80394e:	c3                   	retq   

000000000080394f <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  80394f:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  803952:	48 a1 08 90 80 00 00 	movabs 0x809008,%rax
  803959:	00 00 00 
call *%rax
  80395c:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  80395e:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  803965:	00 
mov 136(%rsp), %r9
  803966:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  80396d:	00 
sub $8, %r8
  80396e:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  803972:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  803975:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  80397c:	00 
add $16, %rsp
  80397d:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  803981:	4c 8b 3c 24          	mov    (%rsp),%r15
  803985:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80398a:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80398f:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  803994:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  803999:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80399e:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8039a3:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8039a8:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8039ad:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8039b2:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8039b7:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8039bc:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8039c1:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8039c6:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8039cb:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  8039cf:	48 83 c4 08          	add    $0x8,%rsp
popf
  8039d3:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  8039d4:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  8039d8:	c3                   	retq   

00000000008039d9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8039d9:	55                   	push   %rbp
  8039da:	48 89 e5             	mov    %rsp,%rbp
  8039dd:	48 83 ec 30          	sub    $0x30,%rsp
  8039e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  8039ed:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8039f2:	74 18                	je     803a0c <ipc_recv+0x33>
  8039f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039f8:	48 89 c7             	mov    %rax,%rdi
  8039fb:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  803a02:	00 00 00 
  803a05:	ff d0                	callq  *%rax
  803a07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a0a:	eb 19                	jmp    803a25 <ipc_recv+0x4c>
  803a0c:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803a13:	00 00 00 
  803a16:	48 b8 4a 1a 80 00 00 	movabs $0x801a4a,%rax
  803a1d:	00 00 00 
  803a20:	ff d0                	callq  *%rax
  803a22:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803a25:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803a2a:	74 26                	je     803a52 <ipc_recv+0x79>
  803a2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a30:	75 15                	jne    803a47 <ipc_recv+0x6e>
  803a32:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a39:	00 00 00 
  803a3c:	48 8b 00             	mov    (%rax),%rax
  803a3f:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803a45:	eb 05                	jmp    803a4c <ipc_recv+0x73>
  803a47:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a50:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803a52:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a57:	74 26                	je     803a7f <ipc_recv+0xa6>
  803a59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a5d:	75 15                	jne    803a74 <ipc_recv+0x9b>
  803a5f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a66:	00 00 00 
  803a69:	48 8b 00             	mov    (%rax),%rax
  803a6c:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803a72:	eb 05                	jmp    803a79 <ipc_recv+0xa0>
  803a74:	b8 00 00 00 00       	mov    $0x0,%eax
  803a79:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a7d:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803a7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a83:	75 15                	jne    803a9a <ipc_recv+0xc1>
  803a85:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803a8c:	00 00 00 
  803a8f:	48 8b 00             	mov    (%rax),%rax
  803a92:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803a98:	eb 03                	jmp    803a9d <ipc_recv+0xc4>
  803a9a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a9d:	c9                   	leaveq 
  803a9e:	c3                   	retq   

0000000000803a9f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a9f:	55                   	push   %rbp
  803aa0:	48 89 e5             	mov    %rsp,%rbp
  803aa3:	48 83 ec 30          	sub    $0x30,%rsp
  803aa7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803aaa:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803aad:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803ab1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803ab4:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803abb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ac0:	75 10                	jne    803ad2 <ipc_send+0x33>
  803ac2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ac9:	00 00 00 
  803acc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803ad0:	eb 62                	jmp    803b34 <ipc_send+0x95>
  803ad2:	eb 60                	jmp    803b34 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803ad4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ad8:	74 30                	je     803b0a <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803add:	89 c1                	mov    %eax,%ecx
  803adf:	48 ba 56 43 80 00 00 	movabs $0x804356,%rdx
  803ae6:	00 00 00 
  803ae9:	be 33 00 00 00       	mov    $0x33,%esi
  803aee:	48 bf 72 43 80 00 00 	movabs $0x804372,%rdi
  803af5:	00 00 00 
  803af8:	b8 00 00 00 00       	mov    $0x0,%eax
  803afd:	49 b8 a6 37 80 00 00 	movabs $0x8037a6,%r8
  803b04:	00 00 00 
  803b07:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803b0a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803b0d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803b10:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803b14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b17:	89 c7                	mov    %eax,%edi
  803b19:	48 b8 f5 19 80 00 00 	movabs $0x8019f5,%rax
  803b20:	00 00 00 
  803b23:	ff d0                	callq  *%rax
  803b25:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  803b28:	48 b8 e3 17 80 00 00 	movabs $0x8017e3,%rax
  803b2f:	00 00 00 
  803b32:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803b34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b38:	75 9a                	jne    803ad4 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  803b3a:	c9                   	leaveq 
  803b3b:	c3                   	retq   

0000000000803b3c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b3c:	55                   	push   %rbp
  803b3d:	48 89 e5             	mov    %rsp,%rbp
  803b40:	48 83 ec 14          	sub    $0x14,%rsp
  803b44:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803b47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b4e:	eb 5e                	jmp    803bae <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803b50:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b57:	00 00 00 
  803b5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b5d:	48 63 d0             	movslq %eax,%rdx
  803b60:	48 89 d0             	mov    %rdx,%rax
  803b63:	48 c1 e0 03          	shl    $0x3,%rax
  803b67:	48 01 d0             	add    %rdx,%rax
  803b6a:	48 c1 e0 05          	shl    $0x5,%rax
  803b6e:	48 01 c8             	add    %rcx,%rax
  803b71:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b77:	8b 00                	mov    (%rax),%eax
  803b79:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b7c:	75 2c                	jne    803baa <ipc_find_env+0x6e>
			return envs[i].env_id;
  803b7e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803b85:	00 00 00 
  803b88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b8b:	48 63 d0             	movslq %eax,%rdx
  803b8e:	48 89 d0             	mov    %rdx,%rax
  803b91:	48 c1 e0 03          	shl    $0x3,%rax
  803b95:	48 01 d0             	add    %rdx,%rax
  803b98:	48 c1 e0 05          	shl    $0x5,%rax
  803b9c:	48 01 c8             	add    %rcx,%rax
  803b9f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803ba5:	8b 40 08             	mov    0x8(%rax),%eax
  803ba8:	eb 12                	jmp    803bbc <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803baa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803bae:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803bb5:	7e 99                	jle    803b50 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803bb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bbc:	c9                   	leaveq 
  803bbd:	c3                   	retq   

0000000000803bbe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803bbe:	55                   	push   %rbp
  803bbf:	48 89 e5             	mov    %rsp,%rbp
  803bc2:	48 83 ec 18          	sub    $0x18,%rsp
  803bc6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803bca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bce:	48 c1 e8 15          	shr    $0x15,%rax
  803bd2:	48 89 c2             	mov    %rax,%rdx
  803bd5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bdc:	01 00 00 
  803bdf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803be3:	83 e0 01             	and    $0x1,%eax
  803be6:	48 85 c0             	test   %rax,%rax
  803be9:	75 07                	jne    803bf2 <pageref+0x34>
		return 0;
  803beb:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf0:	eb 53                	jmp    803c45 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf6:	48 c1 e8 0c          	shr    $0xc,%rax
  803bfa:	48 89 c2             	mov    %rax,%rdx
  803bfd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803c04:	01 00 00 
  803c07:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c0b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c13:	83 e0 01             	and    $0x1,%eax
  803c16:	48 85 c0             	test   %rax,%rax
  803c19:	75 07                	jne    803c22 <pageref+0x64>
		return 0;
  803c1b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c20:	eb 23                	jmp    803c45 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c26:	48 c1 e8 0c          	shr    $0xc,%rax
  803c2a:	48 89 c2             	mov    %rax,%rdx
  803c2d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c34:	00 00 00 
  803c37:	48 c1 e2 04          	shl    $0x4,%rdx
  803c3b:	48 01 d0             	add    %rdx,%rax
  803c3e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c42:	0f b7 c0             	movzwl %ax,%eax
}
  803c45:	c9                   	leaveq 
  803c46:	c3                   	retq   
