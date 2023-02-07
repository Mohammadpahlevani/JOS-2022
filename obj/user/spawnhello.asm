
obj/user/spawnhello:     file format elf64-x86-64


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
  80003c:	e8 a6 00 00 00       	callq  8000e7 <libmain>
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
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800052:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800059:	00 00 00 
  80005c:	48 8b 00             	mov    (%rax),%rax
  80005f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800065:	89 c6                	mov    %eax,%esi
  800067:	48 bf 60 41 80 00 00 	movabs $0x804160,%rdi
  80006e:	00 00 00 
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	48 ba d3 03 80 00 00 	movabs $0x8003d3,%rdx
  80007d:	00 00 00 
  800080:	ff d2                	callq  *%rdx
	if ((r = spawnl("/bin/hello", "hello", 0)) < 0)
  800082:	ba 00 00 00 00       	mov    $0x0,%edx
  800087:	48 be 7e 41 80 00 00 	movabs $0x80417e,%rsi
  80008e:	00 00 00 
  800091:	48 bf 84 41 80 00 00 	movabs $0x804184,%rdi
  800098:	00 00 00 
  80009b:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a0:	48 b9 d0 2d 80 00 00 	movabs $0x802dd0,%rcx
  8000a7:	00 00 00 
  8000aa:	ff d1                	callq  *%rcx
  8000ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b3:	79 30                	jns    8000e5 <umain+0xa2>
		panic("spawn(hello) failed: %e", r);
  8000b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000b8:	89 c1                	mov    %eax,%ecx
  8000ba:	48 ba 8f 41 80 00 00 	movabs $0x80418f,%rdx
  8000c1:	00 00 00 
  8000c4:	be 09 00 00 00       	mov    $0x9,%esi
  8000c9:	48 bf a7 41 80 00 00 	movabs $0x8041a7,%rdi
  8000d0:	00 00 00 
  8000d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d8:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  8000df:	00 00 00 
  8000e2:	41 ff d0             	callq  *%r8
}
  8000e5:	c9                   	leaveq 
  8000e6:	c3                   	retq   

00000000008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	55                   	push   %rbp
  8000e8:	48 89 e5             	mov    %rsp,%rbp
  8000eb:	48 83 ec 10          	sub    $0x10,%rsp
  8000ef:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8000f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  8000f6:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  8000fd:	00 00 00 
  800100:	ff d0                	callq  *%rax
  800102:	48 98                	cltq   
  800104:	25 ff 03 00 00       	and    $0x3ff,%eax
  800109:	48 89 c2             	mov    %rax,%rdx
  80010c:	48 89 d0             	mov    %rdx,%rax
  80010f:	48 c1 e0 03          	shl    $0x3,%rax
  800113:	48 01 d0             	add    %rdx,%rax
  800116:	48 c1 e0 05          	shl    $0x5,%rax
  80011a:	48 89 c2             	mov    %rax,%rdx
  80011d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800124:	00 00 00 
  800127:	48 01 c2             	add    %rax,%rdx
  80012a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800131:	00 00 00 
  800134:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800137:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80013b:	7e 14                	jle    800151 <libmain+0x6a>
		binaryname = argv[0];
  80013d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800141:	48 8b 10             	mov    (%rax),%rdx
  800144:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80014b:	00 00 00 
  80014e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800151:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800155:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800158:	48 89 d6             	mov    %rdx,%rsi
  80015b:	89 c7                	mov    %eax,%edi
  80015d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800164:	00 00 00 
  800167:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800169:	48 b8 77 01 80 00 00 	movabs $0x800177,%rax
  800170:	00 00 00 
  800173:	ff d0                	callq  *%rax
}
  800175:	c9                   	leaveq 
  800176:	c3                   	retq   

0000000000800177 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800177:	55                   	push   %rbp
  800178:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80017b:	48 b8 65 1e 80 00 00 	movabs $0x801e65,%rax
  800182:	00 00 00 
  800185:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800187:	bf 00 00 00 00       	mov    $0x0,%edi
  80018c:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  800193:	00 00 00 
  800196:	ff d0                	callq  *%rax
}
  800198:	5d                   	pop    %rbp
  800199:	c3                   	retq   

000000000080019a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80019a:	55                   	push   %rbp
  80019b:	48 89 e5             	mov    %rsp,%rbp
  80019e:	53                   	push   %rbx
  80019f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8001a6:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8001ad:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8001b3:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8001ba:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8001c1:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8001c8:	84 c0                	test   %al,%al
  8001ca:	74 23                	je     8001ef <_panic+0x55>
  8001cc:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8001d3:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8001d7:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8001db:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8001df:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8001e3:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8001e7:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8001eb:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8001ef:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8001f6:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8001fd:	00 00 00 
  800200:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800207:	00 00 00 
  80020a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80020e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800215:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80021c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800223:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80022a:	00 00 00 
  80022d:	48 8b 18             	mov    (%rax),%rbx
  800230:	48 b8 3b 18 80 00 00 	movabs $0x80183b,%rax
  800237:	00 00 00 
  80023a:	ff d0                	callq  *%rax
  80023c:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800242:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800249:	41 89 c8             	mov    %ecx,%r8d
  80024c:	48 89 d1             	mov    %rdx,%rcx
  80024f:	48 89 da             	mov    %rbx,%rdx
  800252:	89 c6                	mov    %eax,%esi
  800254:	48 bf c8 41 80 00 00 	movabs $0x8041c8,%rdi
  80025b:	00 00 00 
  80025e:	b8 00 00 00 00       	mov    $0x0,%eax
  800263:	49 b9 d3 03 80 00 00 	movabs $0x8003d3,%r9
  80026a:	00 00 00 
  80026d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800270:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800277:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80027e:	48 89 d6             	mov    %rdx,%rsi
  800281:	48 89 c7             	mov    %rax,%rdi
  800284:	48 b8 27 03 80 00 00 	movabs $0x800327,%rax
  80028b:	00 00 00 
  80028e:	ff d0                	callq  *%rax
	cprintf("\n");
  800290:	48 bf eb 41 80 00 00 	movabs $0x8041eb,%rdi
  800297:	00 00 00 
  80029a:	b8 00 00 00 00       	mov    $0x0,%eax
  80029f:	48 ba d3 03 80 00 00 	movabs $0x8003d3,%rdx
  8002a6:	00 00 00 
  8002a9:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ab:	cc                   	int3   
  8002ac:	eb fd                	jmp    8002ab <_panic+0x111>

00000000008002ae <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8002ae:	55                   	push   %rbp
  8002af:	48 89 e5             	mov    %rsp,%rbp
  8002b2:	48 83 ec 10          	sub    $0x10,%rsp
  8002b6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8002bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002c1:	8b 00                	mov    (%rax),%eax
  8002c3:	8d 48 01             	lea    0x1(%rax),%ecx
  8002c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002ca:	89 0a                	mov    %ecx,(%rdx)
  8002cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002cf:	89 d1                	mov    %edx,%ecx
  8002d1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002d5:	48 98                	cltq   
  8002d7:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8002db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002df:	8b 00                	mov    (%rax),%eax
  8002e1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e6:	75 2c                	jne    800314 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ec:	8b 00                	mov    (%rax),%eax
  8002ee:	48 98                	cltq   
  8002f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002f4:	48 83 c2 08          	add    $0x8,%rdx
  8002f8:	48 89 c6             	mov    %rax,%rsi
  8002fb:	48 89 d7             	mov    %rdx,%rdi
  8002fe:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  800305:	00 00 00 
  800308:	ff d0                	callq  *%rax
        b->idx = 0;
  80030a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80030e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800318:	8b 40 04             	mov    0x4(%rax),%eax
  80031b:	8d 50 01             	lea    0x1(%rax),%edx
  80031e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800322:	89 50 04             	mov    %edx,0x4(%rax)
}
  800325:	c9                   	leaveq 
  800326:	c3                   	retq   

0000000000800327 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800327:	55                   	push   %rbp
  800328:	48 89 e5             	mov    %rsp,%rbp
  80032b:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800332:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800339:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800340:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800347:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80034e:	48 8b 0a             	mov    (%rdx),%rcx
  800351:	48 89 08             	mov    %rcx,(%rax)
  800354:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800358:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80035c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800360:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800364:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80036b:	00 00 00 
    b.cnt = 0;
  80036e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800375:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800378:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80037f:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800386:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80038d:	48 89 c6             	mov    %rax,%rsi
  800390:	48 bf ae 02 80 00 00 	movabs $0x8002ae,%rdi
  800397:	00 00 00 
  80039a:	48 b8 86 07 80 00 00 	movabs $0x800786,%rax
  8003a1:	00 00 00 
  8003a4:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8003a6:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8003ac:	48 98                	cltq   
  8003ae:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8003b5:	48 83 c2 08          	add    $0x8,%rdx
  8003b9:	48 89 c6             	mov    %rax,%rsi
  8003bc:	48 89 d7             	mov    %rdx,%rdi
  8003bf:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  8003c6:	00 00 00 
  8003c9:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8003cb:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8003d1:	c9                   	leaveq 
  8003d2:	c3                   	retq   

00000000008003d3 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8003d3:	55                   	push   %rbp
  8003d4:	48 89 e5             	mov    %rsp,%rbp
  8003d7:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8003de:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003e5:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003ec:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003f3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003fa:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800401:	84 c0                	test   %al,%al
  800403:	74 20                	je     800425 <cprintf+0x52>
  800405:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800409:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80040d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800411:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800415:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800419:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80041d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800421:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800425:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80042c:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800433:	00 00 00 
  800436:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80043d:	00 00 00 
  800440:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800444:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80044b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800452:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800459:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800460:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800467:	48 8b 0a             	mov    (%rdx),%rcx
  80046a:	48 89 08             	mov    %rcx,(%rax)
  80046d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800471:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800475:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800479:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80047d:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800484:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80048b:	48 89 d6             	mov    %rdx,%rsi
  80048e:	48 89 c7             	mov    %rax,%rdi
  800491:	48 b8 27 03 80 00 00 	movabs $0x800327,%rax
  800498:	00 00 00 
  80049b:	ff d0                	callq  *%rax
  80049d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8004a3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8004a9:	c9                   	leaveq 
  8004aa:	c3                   	retq   

00000000008004ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ab:	55                   	push   %rbp
  8004ac:	48 89 e5             	mov    %rsp,%rbp
  8004af:	53                   	push   %rbx
  8004b0:	48 83 ec 38          	sub    $0x38,%rsp
  8004b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8004b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8004bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8004c0:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  8004c3:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  8004c7:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004cb:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8004ce:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8004d2:	77 3b                	ja     80050f <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d4:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8004d7:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  8004db:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  8004de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e7:	48 f7 f3             	div    %rbx
  8004ea:	48 89 c2             	mov    %rax,%rdx
  8004ed:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8004f0:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8004f3:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8004f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004fb:	41 89 f9             	mov    %edi,%r9d
  8004fe:	48 89 c7             	mov    %rax,%rdi
  800501:	48 b8 ab 04 80 00 00 	movabs $0x8004ab,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
  80050d:	eb 1e                	jmp    80052d <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80050f:	eb 12                	jmp    800523 <printnum+0x78>
			putch(padc, putdat);
  800511:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800515:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80051c:	48 89 ce             	mov    %rcx,%rsi
  80051f:	89 d7                	mov    %edx,%edi
  800521:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800523:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800527:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80052b:	7f e4                	jg     800511 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80052d:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800530:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800534:	ba 00 00 00 00       	mov    $0x0,%edx
  800539:	48 f7 f1             	div    %rcx
  80053c:	48 89 d0             	mov    %rdx,%rax
  80053f:	48 ba f0 43 80 00 00 	movabs $0x8043f0,%rdx
  800546:	00 00 00 
  800549:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80054d:	0f be d0             	movsbl %al,%edx
  800550:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800554:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800558:	48 89 ce             	mov    %rcx,%rsi
  80055b:	89 d7                	mov    %edx,%edi
  80055d:	ff d0                	callq  *%rax
}
  80055f:	48 83 c4 38          	add    $0x38,%rsp
  800563:	5b                   	pop    %rbx
  800564:	5d                   	pop    %rbp
  800565:	c3                   	retq   

0000000000800566 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800566:	55                   	push   %rbp
  800567:	48 89 e5             	mov    %rsp,%rbp
  80056a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80056e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800572:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800575:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800579:	7e 52                	jle    8005cd <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80057b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80057f:	8b 00                	mov    (%rax),%eax
  800581:	83 f8 30             	cmp    $0x30,%eax
  800584:	73 24                	jae    8005aa <getuint+0x44>
  800586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80058e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800592:	8b 00                	mov    (%rax),%eax
  800594:	89 c0                	mov    %eax,%eax
  800596:	48 01 d0             	add    %rdx,%rax
  800599:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80059d:	8b 12                	mov    (%rdx),%edx
  80059f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005a6:	89 0a                	mov    %ecx,(%rdx)
  8005a8:	eb 17                	jmp    8005c1 <getuint+0x5b>
  8005aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ae:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8005b2:	48 89 d0             	mov    %rdx,%rax
  8005b5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8005b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005bd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005c1:	48 8b 00             	mov    (%rax),%rax
  8005c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005c8:	e9 a3 00 00 00       	jmpq   800670 <getuint+0x10a>
	else if (lflag)
  8005cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8005d1:	74 4f                	je     800622 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  8005d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d7:	8b 00                	mov    (%rax),%eax
  8005d9:	83 f8 30             	cmp    $0x30,%eax
  8005dc:	73 24                	jae    800602 <getuint+0x9c>
  8005de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ea:	8b 00                	mov    (%rax),%eax
  8005ec:	89 c0                	mov    %eax,%eax
  8005ee:	48 01 d0             	add    %rdx,%rax
  8005f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005f5:	8b 12                	mov    (%rdx),%edx
  8005f7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005fa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fe:	89 0a                	mov    %ecx,(%rdx)
  800600:	eb 17                	jmp    800619 <getuint+0xb3>
  800602:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800606:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80060a:	48 89 d0             	mov    %rdx,%rax
  80060d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800615:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800619:	48 8b 00             	mov    (%rax),%rax
  80061c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800620:	eb 4e                	jmp    800670 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800626:	8b 00                	mov    (%rax),%eax
  800628:	83 f8 30             	cmp    $0x30,%eax
  80062b:	73 24                	jae    800651 <getuint+0xeb>
  80062d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800631:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800635:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800639:	8b 00                	mov    (%rax),%eax
  80063b:	89 c0                	mov    %eax,%eax
  80063d:	48 01 d0             	add    %rdx,%rax
  800640:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800644:	8b 12                	mov    (%rdx),%edx
  800646:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800649:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80064d:	89 0a                	mov    %ecx,(%rdx)
  80064f:	eb 17                	jmp    800668 <getuint+0x102>
  800651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800655:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800659:	48 89 d0             	mov    %rdx,%rax
  80065c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800660:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800664:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800668:	8b 00                	mov    (%rax),%eax
  80066a:	89 c0                	mov    %eax,%eax
  80066c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800670:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800674:	c9                   	leaveq 
  800675:	c3                   	retq   

0000000000800676 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800676:	55                   	push   %rbp
  800677:	48 89 e5             	mov    %rsp,%rbp
  80067a:	48 83 ec 1c          	sub    $0x1c,%rsp
  80067e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800682:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800685:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800689:	7e 52                	jle    8006dd <getint+0x67>
		x=va_arg(*ap, long long);
  80068b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068f:	8b 00                	mov    (%rax),%eax
  800691:	83 f8 30             	cmp    $0x30,%eax
  800694:	73 24                	jae    8006ba <getint+0x44>
  800696:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a2:	8b 00                	mov    (%rax),%eax
  8006a4:	89 c0                	mov    %eax,%eax
  8006a6:	48 01 d0             	add    %rdx,%rax
  8006a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ad:	8b 12                	mov    (%rdx),%edx
  8006af:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b6:	89 0a                	mov    %ecx,(%rdx)
  8006b8:	eb 17                	jmp    8006d1 <getint+0x5b>
  8006ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006be:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c2:	48 89 d0             	mov    %rdx,%rax
  8006c5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d1:	48 8b 00             	mov    (%rax),%rax
  8006d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d8:	e9 a3 00 00 00       	jmpq   800780 <getint+0x10a>
	else if (lflag)
  8006dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8006e1:	74 4f                	je     800732 <getint+0xbc>
		x=va_arg(*ap, long);
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	8b 00                	mov    (%rax),%eax
  8006e9:	83 f8 30             	cmp    $0x30,%eax
  8006ec:	73 24                	jae    800712 <getint+0x9c>
  8006ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fa:	8b 00                	mov    (%rax),%eax
  8006fc:	89 c0                	mov    %eax,%eax
  8006fe:	48 01 d0             	add    %rdx,%rax
  800701:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800705:	8b 12                	mov    (%rdx),%edx
  800707:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80070a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070e:	89 0a                	mov    %ecx,(%rdx)
  800710:	eb 17                	jmp    800729 <getint+0xb3>
  800712:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800716:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80071a:	48 89 d0             	mov    %rdx,%rax
  80071d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800721:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800725:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800729:	48 8b 00             	mov    (%rax),%rax
  80072c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800730:	eb 4e                	jmp    800780 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800736:	8b 00                	mov    (%rax),%eax
  800738:	83 f8 30             	cmp    $0x30,%eax
  80073b:	73 24                	jae    800761 <getint+0xeb>
  80073d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800741:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800745:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800749:	8b 00                	mov    (%rax),%eax
  80074b:	89 c0                	mov    %eax,%eax
  80074d:	48 01 d0             	add    %rdx,%rax
  800750:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800754:	8b 12                	mov    (%rdx),%edx
  800756:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800759:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075d:	89 0a                	mov    %ecx,(%rdx)
  80075f:	eb 17                	jmp    800778 <getint+0x102>
  800761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800765:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800769:	48 89 d0             	mov    %rdx,%rax
  80076c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800770:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800774:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800778:	8b 00                	mov    (%rax),%eax
  80077a:	48 98                	cltq   
  80077c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800780:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800784:	c9                   	leaveq 
  800785:	c3                   	retq   

0000000000800786 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800786:	55                   	push   %rbp
  800787:	48 89 e5             	mov    %rsp,%rbp
  80078a:	41 54                	push   %r12
  80078c:	53                   	push   %rbx
  80078d:	48 83 ec 60          	sub    $0x60,%rsp
  800791:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800795:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800799:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80079d:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8007a1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8007a5:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8007a9:	48 8b 0a             	mov    (%rdx),%rcx
  8007ac:	48 89 08             	mov    %rcx,(%rax)
  8007af:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007b3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007b7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007bb:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bf:	eb 17                	jmp    8007d8 <vprintfmt+0x52>
			if (ch == '\0')
  8007c1:	85 db                	test   %ebx,%ebx
  8007c3:	0f 84 cc 04 00 00    	je     800c95 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  8007c9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8007cd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8007d1:	48 89 d6             	mov    %rdx,%rsi
  8007d4:	89 df                	mov    %ebx,%edi
  8007d6:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007dc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007e0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007e4:	0f b6 00             	movzbl (%rax),%eax
  8007e7:	0f b6 d8             	movzbl %al,%ebx
  8007ea:	83 fb 25             	cmp    $0x25,%ebx
  8007ed:	75 d2                	jne    8007c1 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ef:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8007f3:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007fa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800801:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800808:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800813:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800817:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80081b:	0f b6 00             	movzbl (%rax),%eax
  80081e:	0f b6 d8             	movzbl %al,%ebx
  800821:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800824:	83 f8 55             	cmp    $0x55,%eax
  800827:	0f 87 34 04 00 00    	ja     800c61 <vprintfmt+0x4db>
  80082d:	89 c0                	mov    %eax,%eax
  80082f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800836:	00 
  800837:	48 b8 18 44 80 00 00 	movabs $0x804418,%rax
  80083e:	00 00 00 
  800841:	48 01 d0             	add    %rdx,%rax
  800844:	48 8b 00             	mov    (%rax),%rax
  800847:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800849:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  80084d:	eb c0                	jmp    80080f <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80084f:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800853:	eb ba                	jmp    80080f <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800855:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  80085c:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80085f:	89 d0                	mov    %edx,%eax
  800861:	c1 e0 02             	shl    $0x2,%eax
  800864:	01 d0                	add    %edx,%eax
  800866:	01 c0                	add    %eax,%eax
  800868:	01 d8                	add    %ebx,%eax
  80086a:	83 e8 30             	sub    $0x30,%eax
  80086d:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800870:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800874:	0f b6 00             	movzbl (%rax),%eax
  800877:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80087a:	83 fb 2f             	cmp    $0x2f,%ebx
  80087d:	7e 0c                	jle    80088b <vprintfmt+0x105>
  80087f:	83 fb 39             	cmp    $0x39,%ebx
  800882:	7f 07                	jg     80088b <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800884:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800889:	eb d1                	jmp    80085c <vprintfmt+0xd6>
			goto process_precision;
  80088b:	eb 58                	jmp    8008e5 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  80088d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800890:	83 f8 30             	cmp    $0x30,%eax
  800893:	73 17                	jae    8008ac <vprintfmt+0x126>
  800895:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800899:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80089c:	89 c0                	mov    %eax,%eax
  80089e:	48 01 d0             	add    %rdx,%rax
  8008a1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008a4:	83 c2 08             	add    $0x8,%edx
  8008a7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008aa:	eb 0f                	jmp    8008bb <vprintfmt+0x135>
  8008ac:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8008b0:	48 89 d0             	mov    %rdx,%rax
  8008b3:	48 83 c2 08          	add    $0x8,%rdx
  8008b7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008bb:	8b 00                	mov    (%rax),%eax
  8008bd:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  8008c0:	eb 23                	jmp    8008e5 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  8008c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008c6:	79 0c                	jns    8008d4 <vprintfmt+0x14e>
				width = 0;
  8008c8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  8008cf:	e9 3b ff ff ff       	jmpq   80080f <vprintfmt+0x89>
  8008d4:	e9 36 ff ff ff       	jmpq   80080f <vprintfmt+0x89>

		case '#':
			altflag = 1;
  8008d9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  8008e0:	e9 2a ff ff ff       	jmpq   80080f <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  8008e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8008e9:	79 12                	jns    8008fd <vprintfmt+0x177>
				width = precision, precision = -1;
  8008eb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8008ee:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8008f1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008f8:	e9 12 ff ff ff       	jmpq   80080f <vprintfmt+0x89>
  8008fd:	e9 0d ff ff ff       	jmpq   80080f <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800902:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800906:	e9 04 ff ff ff       	jmpq   80080f <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80090b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090e:	83 f8 30             	cmp    $0x30,%eax
  800911:	73 17                	jae    80092a <vprintfmt+0x1a4>
  800913:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800917:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80091a:	89 c0                	mov    %eax,%eax
  80091c:	48 01 d0             	add    %rdx,%rax
  80091f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800922:	83 c2 08             	add    $0x8,%edx
  800925:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800928:	eb 0f                	jmp    800939 <vprintfmt+0x1b3>
  80092a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80092e:	48 89 d0             	mov    %rdx,%rax
  800931:	48 83 c2 08          	add    $0x8,%rdx
  800935:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800939:	8b 10                	mov    (%rax),%edx
  80093b:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80093f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800943:	48 89 ce             	mov    %rcx,%rsi
  800946:	89 d7                	mov    %edx,%edi
  800948:	ff d0                	callq  *%rax
			break;
  80094a:	e9 40 03 00 00       	jmpq   800c8f <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80094f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800952:	83 f8 30             	cmp    $0x30,%eax
  800955:	73 17                	jae    80096e <vprintfmt+0x1e8>
  800957:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80095b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80095e:	89 c0                	mov    %eax,%eax
  800960:	48 01 d0             	add    %rdx,%rax
  800963:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800966:	83 c2 08             	add    $0x8,%edx
  800969:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80096c:	eb 0f                	jmp    80097d <vprintfmt+0x1f7>
  80096e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800972:	48 89 d0             	mov    %rdx,%rax
  800975:	48 83 c2 08          	add    $0x8,%rdx
  800979:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80097d:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80097f:	85 db                	test   %ebx,%ebx
  800981:	79 02                	jns    800985 <vprintfmt+0x1ff>
				err = -err;
  800983:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800985:	83 fb 15             	cmp    $0x15,%ebx
  800988:	7f 16                	jg     8009a0 <vprintfmt+0x21a>
  80098a:	48 b8 40 43 80 00 00 	movabs $0x804340,%rax
  800991:	00 00 00 
  800994:	48 63 d3             	movslq %ebx,%rdx
  800997:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80099b:	4d 85 e4             	test   %r12,%r12
  80099e:	75 2e                	jne    8009ce <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  8009a0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009a4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009a8:	89 d9                	mov    %ebx,%ecx
  8009aa:	48 ba 01 44 80 00 00 	movabs $0x804401,%rdx
  8009b1:	00 00 00 
  8009b4:	48 89 c7             	mov    %rax,%rdi
  8009b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bc:	49 b8 9e 0c 80 00 00 	movabs $0x800c9e,%r8
  8009c3:	00 00 00 
  8009c6:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009c9:	e9 c1 02 00 00       	jmpq   800c8f <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009ce:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8009d2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009d6:	4c 89 e1             	mov    %r12,%rcx
  8009d9:	48 ba 0a 44 80 00 00 	movabs $0x80440a,%rdx
  8009e0:	00 00 00 
  8009e3:	48 89 c7             	mov    %rax,%rdi
  8009e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009eb:	49 b8 9e 0c 80 00 00 	movabs $0x800c9e,%r8
  8009f2:	00 00 00 
  8009f5:	41 ff d0             	callq  *%r8
			break;
  8009f8:	e9 92 02 00 00       	jmpq   800c8f <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8009fd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a00:	83 f8 30             	cmp    $0x30,%eax
  800a03:	73 17                	jae    800a1c <vprintfmt+0x296>
  800a05:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a09:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a0c:	89 c0                	mov    %eax,%eax
  800a0e:	48 01 d0             	add    %rdx,%rax
  800a11:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a14:	83 c2 08             	add    $0x8,%edx
  800a17:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a1a:	eb 0f                	jmp    800a2b <vprintfmt+0x2a5>
  800a1c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a20:	48 89 d0             	mov    %rdx,%rax
  800a23:	48 83 c2 08          	add    $0x8,%rdx
  800a27:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a2b:	4c 8b 20             	mov    (%rax),%r12
  800a2e:	4d 85 e4             	test   %r12,%r12
  800a31:	75 0a                	jne    800a3d <vprintfmt+0x2b7>
				p = "(null)";
  800a33:	49 bc 0d 44 80 00 00 	movabs $0x80440d,%r12
  800a3a:	00 00 00 
			if (width > 0 && padc != '-')
  800a3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a41:	7e 3f                	jle    800a82 <vprintfmt+0x2fc>
  800a43:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800a47:	74 39                	je     800a82 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a49:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a4c:	48 98                	cltq   
  800a4e:	48 89 c6             	mov    %rax,%rsi
  800a51:	4c 89 e7             	mov    %r12,%rdi
  800a54:	48 b8 4a 0f 80 00 00 	movabs $0x800f4a,%rax
  800a5b:	00 00 00 
  800a5e:	ff d0                	callq  *%rax
  800a60:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800a63:	eb 17                	jmp    800a7c <vprintfmt+0x2f6>
					putch(padc, putdat);
  800a65:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a69:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a71:	48 89 ce             	mov    %rcx,%rsi
  800a74:	89 d7                	mov    %edx,%edi
  800a76:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a78:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a80:	7f e3                	jg     800a65 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a82:	eb 37                	jmp    800abb <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800a84:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a88:	74 1e                	je     800aa8 <vprintfmt+0x322>
  800a8a:	83 fb 1f             	cmp    $0x1f,%ebx
  800a8d:	7e 05                	jle    800a94 <vprintfmt+0x30e>
  800a8f:	83 fb 7e             	cmp    $0x7e,%ebx
  800a92:	7e 14                	jle    800aa8 <vprintfmt+0x322>
					putch('?', putdat);
  800a94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a9c:	48 89 d6             	mov    %rdx,%rsi
  800a9f:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800aa4:	ff d0                	callq  *%rax
  800aa6:	eb 0f                	jmp    800ab7 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800aa8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800aac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ab0:	48 89 d6             	mov    %rdx,%rsi
  800ab3:	89 df                	mov    %ebx,%edi
  800ab5:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ab7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800abb:	4c 89 e0             	mov    %r12,%rax
  800abe:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ac2:	0f b6 00             	movzbl (%rax),%eax
  800ac5:	0f be d8             	movsbl %al,%ebx
  800ac8:	85 db                	test   %ebx,%ebx
  800aca:	74 10                	je     800adc <vprintfmt+0x356>
  800acc:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ad0:	78 b2                	js     800a84 <vprintfmt+0x2fe>
  800ad2:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ad6:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ada:	79 a8                	jns    800a84 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800adc:	eb 16                	jmp    800af4 <vprintfmt+0x36e>
				putch(' ', putdat);
  800ade:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ae2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae6:	48 89 d6             	mov    %rdx,%rsi
  800ae9:	bf 20 00 00 00       	mov    $0x20,%edi
  800aee:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800af4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af8:	7f e4                	jg     800ade <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800afa:	e9 90 01 00 00       	jmpq   800c8f <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800aff:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b03:	be 03 00 00 00       	mov    $0x3,%esi
  800b08:	48 89 c7             	mov    %rax,%rdi
  800b0b:	48 b8 76 06 80 00 00 	movabs $0x800676,%rax
  800b12:	00 00 00 
  800b15:	ff d0                	callq  *%rax
  800b17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1f:	48 85 c0             	test   %rax,%rax
  800b22:	79 1d                	jns    800b41 <vprintfmt+0x3bb>
				putch('-', putdat);
  800b24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b2c:	48 89 d6             	mov    %rdx,%rsi
  800b2f:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800b34:	ff d0                	callq  *%rax
				num = -(long long) num;
  800b36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3a:	48 f7 d8             	neg    %rax
  800b3d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800b41:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b48:	e9 d5 00 00 00       	jmpq   800c22 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800b4d:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b51:	be 03 00 00 00       	mov    $0x3,%esi
  800b56:	48 89 c7             	mov    %rax,%rdi
  800b59:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  800b60:	00 00 00 
  800b63:	ff d0                	callq  *%rax
  800b65:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b69:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b70:	e9 ad 00 00 00       	jmpq   800c22 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800b75:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b79:	be 03 00 00 00       	mov    $0x3,%esi
  800b7e:	48 89 c7             	mov    %rax,%rdi
  800b81:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  800b88:	00 00 00 
  800b8b:	ff d0                	callq  *%rax
  800b8d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800b91:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800b98:	e9 85 00 00 00       	jmpq   800c22 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800b9d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ba1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba5:	48 89 d6             	mov    %rdx,%rsi
  800ba8:	bf 30 00 00 00       	mov    $0x30,%edi
  800bad:	ff d0                	callq  *%rax
			putch('x', putdat);
  800baf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bb7:	48 89 d6             	mov    %rdx,%rsi
  800bba:	bf 78 00 00 00       	mov    $0x78,%edi
  800bbf:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800bc1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc4:	83 f8 30             	cmp    $0x30,%eax
  800bc7:	73 17                	jae    800be0 <vprintfmt+0x45a>
  800bc9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bcd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bd0:	89 c0                	mov    %eax,%eax
  800bd2:	48 01 d0             	add    %rdx,%rax
  800bd5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd8:	83 c2 08             	add    $0x8,%edx
  800bdb:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bde:	eb 0f                	jmp    800bef <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800be0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be4:	48 89 d0             	mov    %rdx,%rax
  800be7:	48 83 c2 08          	add    $0x8,%rdx
  800beb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bef:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bf2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800bf6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800bfd:	eb 23                	jmp    800c22 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800bff:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c03:	be 03 00 00 00       	mov    $0x3,%esi
  800c08:	48 89 c7             	mov    %rax,%rdi
  800c0b:	48 b8 66 05 80 00 00 	movabs $0x800566,%rax
  800c12:	00 00 00 
  800c15:	ff d0                	callq  *%rax
  800c17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c1b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c22:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c27:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c2a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c2d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c31:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c39:	45 89 c1             	mov    %r8d,%r9d
  800c3c:	41 89 f8             	mov    %edi,%r8d
  800c3f:	48 89 c7             	mov    %rax,%rdi
  800c42:	48 b8 ab 04 80 00 00 	movabs $0x8004ab,%rax
  800c49:	00 00 00 
  800c4c:	ff d0                	callq  *%rax
			break;
  800c4e:	eb 3f                	jmp    800c8f <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c58:	48 89 d6             	mov    %rdx,%rsi
  800c5b:	89 df                	mov    %ebx,%edi
  800c5d:	ff d0                	callq  *%rax
			break;
  800c5f:	eb 2e                	jmp    800c8f <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c61:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c69:	48 89 d6             	mov    %rdx,%rsi
  800c6c:	bf 25 00 00 00       	mov    $0x25,%edi
  800c71:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c73:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c78:	eb 05                	jmp    800c7f <vprintfmt+0x4f9>
  800c7a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c7f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c83:	48 83 e8 01          	sub    $0x1,%rax
  800c87:	0f b6 00             	movzbl (%rax),%eax
  800c8a:	3c 25                	cmp    $0x25,%al
  800c8c:	75 ec                	jne    800c7a <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800c8e:	90                   	nop
		}
	}
  800c8f:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c90:	e9 43 fb ff ff       	jmpq   8007d8 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c95:	48 83 c4 60          	add    $0x60,%rsp
  800c99:	5b                   	pop    %rbx
  800c9a:	41 5c                	pop    %r12
  800c9c:	5d                   	pop    %rbp
  800c9d:	c3                   	retq   

0000000000800c9e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c9e:	55                   	push   %rbp
  800c9f:	48 89 e5             	mov    %rsp,%rbp
  800ca2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800ca9:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800cb0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800cb7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800cbe:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800cc5:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ccc:	84 c0                	test   %al,%al
  800cce:	74 20                	je     800cf0 <printfmt+0x52>
  800cd0:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800cd4:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800cd8:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800cdc:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ce0:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ce4:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ce8:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800cec:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800cf0:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800cf7:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800cfe:	00 00 00 
  800d01:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d08:	00 00 00 
  800d0b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d0f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d16:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d1d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d24:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d2b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800d32:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800d39:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800d40:	48 89 c7             	mov    %rax,%rdi
  800d43:	48 b8 86 07 80 00 00 	movabs $0x800786,%rax
  800d4a:	00 00 00 
  800d4d:	ff d0                	callq  *%rax
	va_end(ap);
}
  800d4f:	c9                   	leaveq 
  800d50:	c3                   	retq   

0000000000800d51 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d51:	55                   	push   %rbp
  800d52:	48 89 e5             	mov    %rsp,%rbp
  800d55:	48 83 ec 10          	sub    $0x10,%rsp
  800d59:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800d60:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d64:	8b 40 10             	mov    0x10(%rax),%eax
  800d67:	8d 50 01             	lea    0x1(%rax),%edx
  800d6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d6e:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d75:	48 8b 10             	mov    (%rax),%rdx
  800d78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d7c:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d80:	48 39 c2             	cmp    %rax,%rdx
  800d83:	73 17                	jae    800d9c <sprintputch+0x4b>
		*b->buf++ = ch;
  800d85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d89:	48 8b 00             	mov    (%rax),%rax
  800d8c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d94:	48 89 0a             	mov    %rcx,(%rdx)
  800d97:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d9a:	88 10                	mov    %dl,(%rax)
}
  800d9c:	c9                   	leaveq 
  800d9d:	c3                   	retq   

0000000000800d9e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d9e:	55                   	push   %rbp
  800d9f:	48 89 e5             	mov    %rsp,%rbp
  800da2:	48 83 ec 50          	sub    $0x50,%rsp
  800da6:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800daa:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800dad:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800db1:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800db5:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800db9:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800dbd:	48 8b 0a             	mov    (%rdx),%rcx
  800dc0:	48 89 08             	mov    %rcx,(%rax)
  800dc3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dc7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800dcb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dcf:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dd7:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ddb:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800dde:	48 98                	cltq   
  800de0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800de4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800de8:	48 01 d0             	add    %rdx,%rax
  800deb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800def:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800df6:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800dfb:	74 06                	je     800e03 <vsnprintf+0x65>
  800dfd:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e01:	7f 07                	jg     800e0a <vsnprintf+0x6c>
		return -E_INVAL;
  800e03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e08:	eb 2f                	jmp    800e39 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e0a:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e0e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e12:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e16:	48 89 c6             	mov    %rax,%rsi
  800e19:	48 bf 51 0d 80 00 00 	movabs $0x800d51,%rdi
  800e20:	00 00 00 
  800e23:	48 b8 86 07 80 00 00 	movabs $0x800786,%rax
  800e2a:	00 00 00 
  800e2d:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800e33:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800e36:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800e39:	c9                   	leaveq 
  800e3a:	c3                   	retq   

0000000000800e3b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e3b:	55                   	push   %rbp
  800e3c:	48 89 e5             	mov    %rsp,%rbp
  800e3f:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800e46:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e4d:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800e53:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e5a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e61:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e68:	84 c0                	test   %al,%al
  800e6a:	74 20                	je     800e8c <snprintf+0x51>
  800e6c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e70:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e74:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e78:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e7c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e80:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e84:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e88:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e8c:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e93:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e9a:	00 00 00 
  800e9d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800ea4:	00 00 00 
  800ea7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800eab:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800eb2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eb9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800ec0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800ec7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ece:	48 8b 0a             	mov    (%rdx),%rcx
  800ed1:	48 89 08             	mov    %rcx,(%rax)
  800ed4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ed8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800edc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800ee4:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800eeb:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800ef2:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800ef8:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800eff:	48 89 c7             	mov    %rax,%rdi
  800f02:	48 b8 9e 0d 80 00 00 	movabs $0x800d9e,%rax
  800f09:	00 00 00 
  800f0c:	ff d0                	callq  *%rax
  800f0e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f14:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f1a:	c9                   	leaveq 
  800f1b:	c3                   	retq   

0000000000800f1c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f1c:	55                   	push   %rbp
  800f1d:	48 89 e5             	mov    %rsp,%rbp
  800f20:	48 83 ec 18          	sub    $0x18,%rsp
  800f24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f2f:	eb 09                	jmp    800f3a <strlen+0x1e>
		n++;
  800f31:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f35:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3e:	0f b6 00             	movzbl (%rax),%eax
  800f41:	84 c0                	test   %al,%al
  800f43:	75 ec                	jne    800f31 <strlen+0x15>
		n++;
	return n;
  800f45:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f48:	c9                   	leaveq 
  800f49:	c3                   	retq   

0000000000800f4a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f4a:	55                   	push   %rbp
  800f4b:	48 89 e5             	mov    %rsp,%rbp
  800f4e:	48 83 ec 20          	sub    $0x20,%rsp
  800f52:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f56:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f61:	eb 0e                	jmp    800f71 <strnlen+0x27>
		n++;
  800f63:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f67:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f6c:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f71:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f76:	74 0b                	je     800f83 <strnlen+0x39>
  800f78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7c:	0f b6 00             	movzbl (%rax),%eax
  800f7f:	84 c0                	test   %al,%al
  800f81:	75 e0                	jne    800f63 <strnlen+0x19>
		n++;
	return n;
  800f83:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f86:	c9                   	leaveq 
  800f87:	c3                   	retq   

0000000000800f88 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f88:	55                   	push   %rbp
  800f89:	48 89 e5             	mov    %rsp,%rbp
  800f8c:	48 83 ec 20          	sub    $0x20,%rsp
  800f90:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f94:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800fa0:	90                   	nop
  800fa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fa5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fa9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fb1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800fb5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800fb9:	0f b6 12             	movzbl (%rdx),%edx
  800fbc:	88 10                	mov    %dl,(%rax)
  800fbe:	0f b6 00             	movzbl (%rax),%eax
  800fc1:	84 c0                	test   %al,%al
  800fc3:	75 dc                	jne    800fa1 <strcpy+0x19>
		/* do nothing */;
	return ret;
  800fc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fc9:	c9                   	leaveq 
  800fca:	c3                   	retq   

0000000000800fcb <strcat>:

char *
strcat(char *dst, const char *src)
{
  800fcb:	55                   	push   %rbp
  800fcc:	48 89 e5             	mov    %rsp,%rbp
  800fcf:	48 83 ec 20          	sub    $0x20,%rsp
  800fd3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fd7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800fdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fdf:	48 89 c7             	mov    %rax,%rdi
  800fe2:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  800fe9:	00 00 00 
  800fec:	ff d0                	callq  *%rax
  800fee:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800ff1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ff4:	48 63 d0             	movslq %eax,%rdx
  800ff7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffb:	48 01 c2             	add    %rax,%rdx
  800ffe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801002:	48 89 c6             	mov    %rax,%rsi
  801005:	48 89 d7             	mov    %rdx,%rdi
  801008:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  80100f:	00 00 00 
  801012:	ff d0                	callq  *%rax
	return dst;
  801014:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801018:	c9                   	leaveq 
  801019:	c3                   	retq   

000000000080101a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80101a:	55                   	push   %rbp
  80101b:	48 89 e5             	mov    %rsp,%rbp
  80101e:	48 83 ec 28          	sub    $0x28,%rsp
  801022:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801026:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80102a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80102e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801032:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801036:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80103d:	00 
  80103e:	eb 2a                	jmp    80106a <strncpy+0x50>
		*dst++ = *src;
  801040:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801044:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801048:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80104c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801050:	0f b6 12             	movzbl (%rdx),%edx
  801053:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801055:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801059:	0f b6 00             	movzbl (%rax),%eax
  80105c:	84 c0                	test   %al,%al
  80105e:	74 05                	je     801065 <strncpy+0x4b>
			src++;
  801060:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801065:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80106a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80106e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801072:	72 cc                	jb     801040 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801074:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801078:	c9                   	leaveq 
  801079:	c3                   	retq   

000000000080107a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80107a:	55                   	push   %rbp
  80107b:	48 89 e5             	mov    %rsp,%rbp
  80107e:	48 83 ec 28          	sub    $0x28,%rsp
  801082:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801086:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80108a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80108e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801092:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801096:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80109b:	74 3d                	je     8010da <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80109d:	eb 1d                	jmp    8010bc <strlcpy+0x42>
			*dst++ = *src++;
  80109f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010a7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010ab:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010af:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8010b3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8010b7:	0f b6 12             	movzbl (%rdx),%edx
  8010ba:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010bc:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8010c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8010c6:	74 0b                	je     8010d3 <strlcpy+0x59>
  8010c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010cc:	0f b6 00             	movzbl (%rax),%eax
  8010cf:	84 c0                	test   %al,%al
  8010d1:	75 cc                	jne    80109f <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8010d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d7:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8010da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e2:	48 29 c2             	sub    %rax,%rdx
  8010e5:	48 89 d0             	mov    %rdx,%rax
}
  8010e8:	c9                   	leaveq 
  8010e9:	c3                   	retq   

00000000008010ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010ea:	55                   	push   %rbp
  8010eb:	48 89 e5             	mov    %rsp,%rbp
  8010ee:	48 83 ec 10          	sub    $0x10,%rsp
  8010f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8010fa:	eb 0a                	jmp    801106 <strcmp+0x1c>
		p++, q++;
  8010fc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801101:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801106:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80110a:	0f b6 00             	movzbl (%rax),%eax
  80110d:	84 c0                	test   %al,%al
  80110f:	74 12                	je     801123 <strcmp+0x39>
  801111:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801115:	0f b6 10             	movzbl (%rax),%edx
  801118:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80111c:	0f b6 00             	movzbl (%rax),%eax
  80111f:	38 c2                	cmp    %al,%dl
  801121:	74 d9                	je     8010fc <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801123:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801127:	0f b6 00             	movzbl (%rax),%eax
  80112a:	0f b6 d0             	movzbl %al,%edx
  80112d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801131:	0f b6 00             	movzbl (%rax),%eax
  801134:	0f b6 c0             	movzbl %al,%eax
  801137:	29 c2                	sub    %eax,%edx
  801139:	89 d0                	mov    %edx,%eax
}
  80113b:	c9                   	leaveq 
  80113c:	c3                   	retq   

000000000080113d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80113d:	55                   	push   %rbp
  80113e:	48 89 e5             	mov    %rsp,%rbp
  801141:	48 83 ec 18          	sub    $0x18,%rsp
  801145:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801149:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80114d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801151:	eb 0f                	jmp    801162 <strncmp+0x25>
		n--, p++, q++;
  801153:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801158:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80115d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801162:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801167:	74 1d                	je     801186 <strncmp+0x49>
  801169:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116d:	0f b6 00             	movzbl (%rax),%eax
  801170:	84 c0                	test   %al,%al
  801172:	74 12                	je     801186 <strncmp+0x49>
  801174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801178:	0f b6 10             	movzbl (%rax),%edx
  80117b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80117f:	0f b6 00             	movzbl (%rax),%eax
  801182:	38 c2                	cmp    %al,%dl
  801184:	74 cd                	je     801153 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801186:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80118b:	75 07                	jne    801194 <strncmp+0x57>
		return 0;
  80118d:	b8 00 00 00 00       	mov    $0x0,%eax
  801192:	eb 18                	jmp    8011ac <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801194:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801198:	0f b6 00             	movzbl (%rax),%eax
  80119b:	0f b6 d0             	movzbl %al,%edx
  80119e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a2:	0f b6 00             	movzbl (%rax),%eax
  8011a5:	0f b6 c0             	movzbl %al,%eax
  8011a8:	29 c2                	sub    %eax,%edx
  8011aa:	89 d0                	mov    %edx,%eax
}
  8011ac:	c9                   	leaveq 
  8011ad:	c3                   	retq   

00000000008011ae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011ae:	55                   	push   %rbp
  8011af:	48 89 e5             	mov    %rsp,%rbp
  8011b2:	48 83 ec 0c          	sub    $0xc,%rsp
  8011b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011ba:	89 f0                	mov    %esi,%eax
  8011bc:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011bf:	eb 17                	jmp    8011d8 <strchr+0x2a>
		if (*s == c)
  8011c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c5:	0f b6 00             	movzbl (%rax),%eax
  8011c8:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011cb:	75 06                	jne    8011d3 <strchr+0x25>
			return (char *) s;
  8011cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d1:	eb 15                	jmp    8011e8 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dc:	0f b6 00             	movzbl (%rax),%eax
  8011df:	84 c0                	test   %al,%al
  8011e1:	75 de                	jne    8011c1 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8011e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e8:	c9                   	leaveq 
  8011e9:	c3                   	retq   

00000000008011ea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ea:	55                   	push   %rbp
  8011eb:	48 89 e5             	mov    %rsp,%rbp
  8011ee:	48 83 ec 0c          	sub    $0xc,%rsp
  8011f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011f6:	89 f0                	mov    %esi,%eax
  8011f8:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8011fb:	eb 13                	jmp    801210 <strfind+0x26>
		if (*s == c)
  8011fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801201:	0f b6 00             	movzbl (%rax),%eax
  801204:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801207:	75 02                	jne    80120b <strfind+0x21>
			break;
  801209:	eb 10                	jmp    80121b <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80120b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801210:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801214:	0f b6 00             	movzbl (%rax),%eax
  801217:	84 c0                	test   %al,%al
  801219:	75 e2                	jne    8011fd <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80121b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80121f:	c9                   	leaveq 
  801220:	c3                   	retq   

0000000000801221 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801221:	55                   	push   %rbp
  801222:	48 89 e5             	mov    %rsp,%rbp
  801225:	48 83 ec 18          	sub    $0x18,%rsp
  801229:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80122d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801230:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801234:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801239:	75 06                	jne    801241 <memset+0x20>
		return v;
  80123b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123f:	eb 69                	jmp    8012aa <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801245:	83 e0 03             	and    $0x3,%eax
  801248:	48 85 c0             	test   %rax,%rax
  80124b:	75 48                	jne    801295 <memset+0x74>
  80124d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801251:	83 e0 03             	and    $0x3,%eax
  801254:	48 85 c0             	test   %rax,%rax
  801257:	75 3c                	jne    801295 <memset+0x74>
		c &= 0xFF;
  801259:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801260:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801263:	c1 e0 18             	shl    $0x18,%eax
  801266:	89 c2                	mov    %eax,%edx
  801268:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80126b:	c1 e0 10             	shl    $0x10,%eax
  80126e:	09 c2                	or     %eax,%edx
  801270:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801273:	c1 e0 08             	shl    $0x8,%eax
  801276:	09 d0                	or     %edx,%eax
  801278:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80127b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127f:	48 c1 e8 02          	shr    $0x2,%rax
  801283:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801286:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80128a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80128d:	48 89 d7             	mov    %rdx,%rdi
  801290:	fc                   	cld    
  801291:	f3 ab                	rep stos %eax,%es:(%rdi)
  801293:	eb 11                	jmp    8012a6 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801295:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801299:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80129c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8012a0:	48 89 d7             	mov    %rdx,%rdi
  8012a3:	fc                   	cld    
  8012a4:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8012a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012aa:	c9                   	leaveq 
  8012ab:	c3                   	retq   

00000000008012ac <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012ac:	55                   	push   %rbp
  8012ad:	48 89 e5             	mov    %rsp,%rbp
  8012b0:	48 83 ec 28          	sub    $0x28,%rsp
  8012b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8012c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8012c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8012d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012d8:	0f 83 88 00 00 00    	jae    801366 <memmove+0xba>
  8012de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012e2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012e6:	48 01 d0             	add    %rdx,%rax
  8012e9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8012ed:	76 77                	jbe    801366 <memmove+0xba>
		s += n;
  8012ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8012f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012fb:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8012ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801303:	83 e0 03             	and    $0x3,%eax
  801306:	48 85 c0             	test   %rax,%rax
  801309:	75 3b                	jne    801346 <memmove+0x9a>
  80130b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80130f:	83 e0 03             	and    $0x3,%eax
  801312:	48 85 c0             	test   %rax,%rax
  801315:	75 2f                	jne    801346 <memmove+0x9a>
  801317:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80131b:	83 e0 03             	and    $0x3,%eax
  80131e:	48 85 c0             	test   %rax,%rax
  801321:	75 23                	jne    801346 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801323:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801327:	48 83 e8 04          	sub    $0x4,%rax
  80132b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80132f:	48 83 ea 04          	sub    $0x4,%rdx
  801333:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801337:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80133b:	48 89 c7             	mov    %rax,%rdi
  80133e:	48 89 d6             	mov    %rdx,%rsi
  801341:	fd                   	std    
  801342:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801344:	eb 1d                	jmp    801363 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801346:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80134a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80134e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801352:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801356:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80135a:	48 89 d7             	mov    %rdx,%rdi
  80135d:	48 89 c1             	mov    %rax,%rcx
  801360:	fd                   	std    
  801361:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801363:	fc                   	cld    
  801364:	eb 57                	jmp    8013bd <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136a:	83 e0 03             	and    $0x3,%eax
  80136d:	48 85 c0             	test   %rax,%rax
  801370:	75 36                	jne    8013a8 <memmove+0xfc>
  801372:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801376:	83 e0 03             	and    $0x3,%eax
  801379:	48 85 c0             	test   %rax,%rax
  80137c:	75 2a                	jne    8013a8 <memmove+0xfc>
  80137e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801382:	83 e0 03             	and    $0x3,%eax
  801385:	48 85 c0             	test   %rax,%rax
  801388:	75 1e                	jne    8013a8 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80138a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138e:	48 c1 e8 02          	shr    $0x2,%rax
  801392:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801395:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801399:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80139d:	48 89 c7             	mov    %rax,%rdi
  8013a0:	48 89 d6             	mov    %rdx,%rsi
  8013a3:	fc                   	cld    
  8013a4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013a6:	eb 15                	jmp    8013bd <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8013a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013b0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013b4:	48 89 c7             	mov    %rax,%rdi
  8013b7:	48 89 d6             	mov    %rdx,%rsi
  8013ba:	fc                   	cld    
  8013bb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8013bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8013c1:	c9                   	leaveq 
  8013c2:	c3                   	retq   

00000000008013c3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8013c3:	55                   	push   %rbp
  8013c4:	48 89 e5             	mov    %rsp,%rbp
  8013c7:	48 83 ec 18          	sub    $0x18,%rsp
  8013cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8013d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013db:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8013df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e3:	48 89 ce             	mov    %rcx,%rsi
  8013e6:	48 89 c7             	mov    %rax,%rdi
  8013e9:	48 b8 ac 12 80 00 00 	movabs $0x8012ac,%rax
  8013f0:	00 00 00 
  8013f3:	ff d0                	callq  *%rax
}
  8013f5:	c9                   	leaveq 
  8013f6:	c3                   	retq   

00000000008013f7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8013f7:	55                   	push   %rbp
  8013f8:	48 89 e5             	mov    %rsp,%rbp
  8013fb:	48 83 ec 28          	sub    $0x28,%rsp
  8013ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801403:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801407:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80140b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80140f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801413:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801417:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80141b:	eb 36                	jmp    801453 <memcmp+0x5c>
		if (*s1 != *s2)
  80141d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801421:	0f b6 10             	movzbl (%rax),%edx
  801424:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801428:	0f b6 00             	movzbl (%rax),%eax
  80142b:	38 c2                	cmp    %al,%dl
  80142d:	74 1a                	je     801449 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80142f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801433:	0f b6 00             	movzbl (%rax),%eax
  801436:	0f b6 d0             	movzbl %al,%edx
  801439:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143d:	0f b6 00             	movzbl (%rax),%eax
  801440:	0f b6 c0             	movzbl %al,%eax
  801443:	29 c2                	sub    %eax,%edx
  801445:	89 d0                	mov    %edx,%eax
  801447:	eb 20                	jmp    801469 <memcmp+0x72>
		s1++, s2++;
  801449:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80144e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801457:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80145b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80145f:	48 85 c0             	test   %rax,%rax
  801462:	75 b9                	jne    80141d <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801469:	c9                   	leaveq 
  80146a:	c3                   	retq   

000000000080146b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80146b:	55                   	push   %rbp
  80146c:	48 89 e5             	mov    %rsp,%rbp
  80146f:	48 83 ec 28          	sub    $0x28,%rsp
  801473:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801477:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80147a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80147e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801482:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801486:	48 01 d0             	add    %rdx,%rax
  801489:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80148d:	eb 15                	jmp    8014a4 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80148f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801493:	0f b6 10             	movzbl (%rax),%edx
  801496:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801499:	38 c2                	cmp    %al,%dl
  80149b:	75 02                	jne    80149f <memfind+0x34>
			break;
  80149d:	eb 0f                	jmp    8014ae <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80149f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8014a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a8:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8014ac:	72 e1                	jb     80148f <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8014ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014b2:	c9                   	leaveq 
  8014b3:	c3                   	retq   

00000000008014b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014b4:	55                   	push   %rbp
  8014b5:	48 89 e5             	mov    %rsp,%rbp
  8014b8:	48 83 ec 34          	sub    $0x34,%rsp
  8014bc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8014c0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8014c4:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8014c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8014ce:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8014d5:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d6:	eb 05                	jmp    8014dd <strtol+0x29>
		s++;
  8014d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e1:	0f b6 00             	movzbl (%rax),%eax
  8014e4:	3c 20                	cmp    $0x20,%al
  8014e6:	74 f0                	je     8014d8 <strtol+0x24>
  8014e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ec:	0f b6 00             	movzbl (%rax),%eax
  8014ef:	3c 09                	cmp    $0x9,%al
  8014f1:	74 e5                	je     8014d8 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f7:	0f b6 00             	movzbl (%rax),%eax
  8014fa:	3c 2b                	cmp    $0x2b,%al
  8014fc:	75 07                	jne    801505 <strtol+0x51>
		s++;
  8014fe:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801503:	eb 17                	jmp    80151c <strtol+0x68>
	else if (*s == '-')
  801505:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801509:	0f b6 00             	movzbl (%rax),%eax
  80150c:	3c 2d                	cmp    $0x2d,%al
  80150e:	75 0c                	jne    80151c <strtol+0x68>
		s++, neg = 1;
  801510:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801515:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80151c:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801520:	74 06                	je     801528 <strtol+0x74>
  801522:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801526:	75 28                	jne    801550 <strtol+0x9c>
  801528:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152c:	0f b6 00             	movzbl (%rax),%eax
  80152f:	3c 30                	cmp    $0x30,%al
  801531:	75 1d                	jne    801550 <strtol+0x9c>
  801533:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801537:	48 83 c0 01          	add    $0x1,%rax
  80153b:	0f b6 00             	movzbl (%rax),%eax
  80153e:	3c 78                	cmp    $0x78,%al
  801540:	75 0e                	jne    801550 <strtol+0x9c>
		s += 2, base = 16;
  801542:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801547:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80154e:	eb 2c                	jmp    80157c <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801550:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801554:	75 19                	jne    80156f <strtol+0xbb>
  801556:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155a:	0f b6 00             	movzbl (%rax),%eax
  80155d:	3c 30                	cmp    $0x30,%al
  80155f:	75 0e                	jne    80156f <strtol+0xbb>
		s++, base = 8;
  801561:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801566:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80156d:	eb 0d                	jmp    80157c <strtol+0xc8>
	else if (base == 0)
  80156f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801573:	75 07                	jne    80157c <strtol+0xc8>
		base = 10;
  801575:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80157c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801580:	0f b6 00             	movzbl (%rax),%eax
  801583:	3c 2f                	cmp    $0x2f,%al
  801585:	7e 1d                	jle    8015a4 <strtol+0xf0>
  801587:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80158b:	0f b6 00             	movzbl (%rax),%eax
  80158e:	3c 39                	cmp    $0x39,%al
  801590:	7f 12                	jg     8015a4 <strtol+0xf0>
			dig = *s - '0';
  801592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801596:	0f b6 00             	movzbl (%rax),%eax
  801599:	0f be c0             	movsbl %al,%eax
  80159c:	83 e8 30             	sub    $0x30,%eax
  80159f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015a2:	eb 4e                	jmp    8015f2 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8015a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a8:	0f b6 00             	movzbl (%rax),%eax
  8015ab:	3c 60                	cmp    $0x60,%al
  8015ad:	7e 1d                	jle    8015cc <strtol+0x118>
  8015af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b3:	0f b6 00             	movzbl (%rax),%eax
  8015b6:	3c 7a                	cmp    $0x7a,%al
  8015b8:	7f 12                	jg     8015cc <strtol+0x118>
			dig = *s - 'a' + 10;
  8015ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015be:	0f b6 00             	movzbl (%rax),%eax
  8015c1:	0f be c0             	movsbl %al,%eax
  8015c4:	83 e8 57             	sub    $0x57,%eax
  8015c7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8015ca:	eb 26                	jmp    8015f2 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8015cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d0:	0f b6 00             	movzbl (%rax),%eax
  8015d3:	3c 40                	cmp    $0x40,%al
  8015d5:	7e 48                	jle    80161f <strtol+0x16b>
  8015d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015db:	0f b6 00             	movzbl (%rax),%eax
  8015de:	3c 5a                	cmp    $0x5a,%al
  8015e0:	7f 3d                	jg     80161f <strtol+0x16b>
			dig = *s - 'A' + 10;
  8015e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e6:	0f b6 00             	movzbl (%rax),%eax
  8015e9:	0f be c0             	movsbl %al,%eax
  8015ec:	83 e8 37             	sub    $0x37,%eax
  8015ef:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8015f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015f5:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8015f8:	7c 02                	jl     8015fc <strtol+0x148>
			break;
  8015fa:	eb 23                	jmp    80161f <strtol+0x16b>
		s++, val = (val * base) + dig;
  8015fc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801601:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801604:	48 98                	cltq   
  801606:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80160b:	48 89 c2             	mov    %rax,%rdx
  80160e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801611:	48 98                	cltq   
  801613:	48 01 d0             	add    %rdx,%rax
  801616:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80161a:	e9 5d ff ff ff       	jmpq   80157c <strtol+0xc8>

	if (endptr)
  80161f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801624:	74 0b                	je     801631 <strtol+0x17d>
		*endptr = (char *) s;
  801626:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80162a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80162e:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801631:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801635:	74 09                	je     801640 <strtol+0x18c>
  801637:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80163b:	48 f7 d8             	neg    %rax
  80163e:	eb 04                	jmp    801644 <strtol+0x190>
  801640:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801644:	c9                   	leaveq 
  801645:	c3                   	retq   

0000000000801646 <strstr>:

char * strstr(const char *in, const char *str)
{
  801646:	55                   	push   %rbp
  801647:	48 89 e5             	mov    %rsp,%rbp
  80164a:	48 83 ec 30          	sub    $0x30,%rsp
  80164e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801652:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801656:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80165a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80165e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801662:	0f b6 00             	movzbl (%rax),%eax
  801665:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801668:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80166c:	75 06                	jne    801674 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80166e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801672:	eb 6b                	jmp    8016df <strstr+0x99>

	len = strlen(str);
  801674:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801678:	48 89 c7             	mov    %rax,%rdi
  80167b:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  801682:	00 00 00 
  801685:	ff d0                	callq  *%rax
  801687:	48 98                	cltq   
  801689:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80168d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801691:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801695:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801699:	0f b6 00             	movzbl (%rax),%eax
  80169c:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80169f:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8016a3:	75 07                	jne    8016ac <strstr+0x66>
				return (char *) 0;
  8016a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016aa:	eb 33                	jmp    8016df <strstr+0x99>
		} while (sc != c);
  8016ac:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8016b0:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8016b3:	75 d8                	jne    80168d <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8016b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016b9:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8016bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016c1:	48 89 ce             	mov    %rcx,%rsi
  8016c4:	48 89 c7             	mov    %rax,%rdi
  8016c7:	48 b8 3d 11 80 00 00 	movabs $0x80113d,%rax
  8016ce:	00 00 00 
  8016d1:	ff d0                	callq  *%rax
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	75 b6                	jne    80168d <strstr+0x47>

	return (char *) (in - 1);
  8016d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016db:	48 83 e8 01          	sub    $0x1,%rax
}
  8016df:	c9                   	leaveq 
  8016e0:	c3                   	retq   

00000000008016e1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8016e1:	55                   	push   %rbp
  8016e2:	48 89 e5             	mov    %rsp,%rbp
  8016e5:	53                   	push   %rbx
  8016e6:	48 83 ec 48          	sub    $0x48,%rsp
  8016ea:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8016ed:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8016f0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016f4:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8016f8:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8016fc:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801700:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801703:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801707:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80170b:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80170f:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801713:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801717:	4c 89 c3             	mov    %r8,%rbx
  80171a:	cd 30                	int    $0x30
  80171c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801720:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801724:	74 3e                	je     801764 <syscall+0x83>
  801726:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80172b:	7e 37                	jle    801764 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80172d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801731:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801734:	49 89 d0             	mov    %rdx,%r8
  801737:	89 c1                	mov    %eax,%ecx
  801739:	48 ba c8 46 80 00 00 	movabs $0x8046c8,%rdx
  801740:	00 00 00 
  801743:	be 4a 00 00 00       	mov    $0x4a,%esi
  801748:	48 bf e5 46 80 00 00 	movabs $0x8046e5,%rdi
  80174f:	00 00 00 
  801752:	b8 00 00 00 00       	mov    $0x0,%eax
  801757:	49 b9 9a 01 80 00 00 	movabs $0x80019a,%r9
  80175e:	00 00 00 
  801761:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801768:	48 83 c4 48          	add    $0x48,%rsp
  80176c:	5b                   	pop    %rbx
  80176d:	5d                   	pop    %rbp
  80176e:	c3                   	retq   

000000000080176f <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  80176f:	55                   	push   %rbp
  801770:	48 89 e5             	mov    %rsp,%rbp
  801773:	48 83 ec 20          	sub    $0x20,%rsp
  801777:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80177b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  80177f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801783:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801787:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80178e:	00 
  80178f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801795:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80179b:	48 89 d1             	mov    %rdx,%rcx
  80179e:	48 89 c2             	mov    %rax,%rdx
  8017a1:	be 00 00 00 00       	mov    $0x0,%esi
  8017a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8017ab:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  8017b2:	00 00 00 
  8017b5:	ff d0                	callq  *%rax
}
  8017b7:	c9                   	leaveq 
  8017b8:	c3                   	retq   

00000000008017b9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017b9:	55                   	push   %rbp
  8017ba:	48 89 e5             	mov    %rsp,%rbp
  8017bd:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8017c1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017c8:	00 
  8017c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017d5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017da:	ba 00 00 00 00       	mov    $0x0,%edx
  8017df:	be 00 00 00 00       	mov    $0x0,%esi
  8017e4:	bf 01 00 00 00       	mov    $0x1,%edi
  8017e9:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  8017f0:	00 00 00 
  8017f3:	ff d0                	callq  *%rax
}
  8017f5:	c9                   	leaveq 
  8017f6:	c3                   	retq   

00000000008017f7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017f7:	55                   	push   %rbp
  8017f8:	48 89 e5             	mov    %rsp,%rbp
  8017fb:	48 83 ec 10          	sub    $0x10,%rsp
  8017ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801802:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801805:	48 98                	cltq   
  801807:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80180e:	00 
  80180f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801815:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80181b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801820:	48 89 c2             	mov    %rax,%rdx
  801823:	be 01 00 00 00       	mov    $0x1,%esi
  801828:	bf 03 00 00 00       	mov    $0x3,%edi
  80182d:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  801834:	00 00 00 
  801837:	ff d0                	callq  *%rax
}
  801839:	c9                   	leaveq 
  80183a:	c3                   	retq   

000000000080183b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80183b:	55                   	push   %rbp
  80183c:	48 89 e5             	mov    %rsp,%rbp
  80183f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801843:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80184a:	00 
  80184b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801851:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801857:	b9 00 00 00 00       	mov    $0x0,%ecx
  80185c:	ba 00 00 00 00       	mov    $0x0,%edx
  801861:	be 00 00 00 00       	mov    $0x0,%esi
  801866:	bf 02 00 00 00       	mov    $0x2,%edi
  80186b:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  801872:	00 00 00 
  801875:	ff d0                	callq  *%rax
}
  801877:	c9                   	leaveq 
  801878:	c3                   	retq   

0000000000801879 <sys_yield>:

void
sys_yield(void)
{
  801879:	55                   	push   %rbp
  80187a:	48 89 e5             	mov    %rsp,%rbp
  80187d:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801881:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801888:	00 
  801889:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801895:	b9 00 00 00 00       	mov    $0x0,%ecx
  80189a:	ba 00 00 00 00       	mov    $0x0,%edx
  80189f:	be 00 00 00 00       	mov    $0x0,%esi
  8018a4:	bf 0b 00 00 00       	mov    $0xb,%edi
  8018a9:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  8018b0:	00 00 00 
  8018b3:	ff d0                	callq  *%rax
}
  8018b5:	c9                   	leaveq 
  8018b6:	c3                   	retq   

00000000008018b7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8018b7:	55                   	push   %rbp
  8018b8:	48 89 e5             	mov    %rsp,%rbp
  8018bb:	48 83 ec 20          	sub    $0x20,%rsp
  8018bf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018c2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018c6:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  8018c9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018cc:	48 63 c8             	movslq %eax,%rcx
  8018cf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d6:	48 98                	cltq   
  8018d8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018df:	00 
  8018e0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018e6:	49 89 c8             	mov    %rcx,%r8
  8018e9:	48 89 d1             	mov    %rdx,%rcx
  8018ec:	48 89 c2             	mov    %rax,%rdx
  8018ef:	be 01 00 00 00       	mov    $0x1,%esi
  8018f4:	bf 04 00 00 00       	mov    $0x4,%edi
  8018f9:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  801900:	00 00 00 
  801903:	ff d0                	callq  *%rax
}
  801905:	c9                   	leaveq 
  801906:	c3                   	retq   

0000000000801907 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801907:	55                   	push   %rbp
  801908:	48 89 e5             	mov    %rsp,%rbp
  80190b:	48 83 ec 30          	sub    $0x30,%rsp
  80190f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801912:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801916:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801919:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80191d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801921:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801924:	48 63 c8             	movslq %eax,%rcx
  801927:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80192b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80192e:	48 63 f0             	movslq %eax,%rsi
  801931:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801935:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801938:	48 98                	cltq   
  80193a:	48 89 0c 24          	mov    %rcx,(%rsp)
  80193e:	49 89 f9             	mov    %rdi,%r9
  801941:	49 89 f0             	mov    %rsi,%r8
  801944:	48 89 d1             	mov    %rdx,%rcx
  801947:	48 89 c2             	mov    %rax,%rdx
  80194a:	be 01 00 00 00       	mov    $0x1,%esi
  80194f:	bf 05 00 00 00       	mov    $0x5,%edi
  801954:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  80195b:	00 00 00 
  80195e:	ff d0                	callq  *%rax
}
  801960:	c9                   	leaveq 
  801961:	c3                   	retq   

0000000000801962 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801962:	55                   	push   %rbp
  801963:	48 89 e5             	mov    %rsp,%rbp
  801966:	48 83 ec 20          	sub    $0x20,%rsp
  80196a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80196d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801971:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801975:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801978:	48 98                	cltq   
  80197a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801981:	00 
  801982:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801988:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80198e:	48 89 d1             	mov    %rdx,%rcx
  801991:	48 89 c2             	mov    %rax,%rdx
  801994:	be 01 00 00 00       	mov    $0x1,%esi
  801999:	bf 06 00 00 00       	mov    $0x6,%edi
  80199e:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  8019a5:	00 00 00 
  8019a8:	ff d0                	callq  *%rax
}
  8019aa:	c9                   	leaveq 
  8019ab:	c3                   	retq   

00000000008019ac <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019ac:	55                   	push   %rbp
  8019ad:	48 89 e5             	mov    %rsp,%rbp
  8019b0:	48 83 ec 10          	sub    $0x10,%rsp
  8019b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019b7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8019ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019bd:	48 63 d0             	movslq %eax,%rdx
  8019c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c3:	48 98                	cltq   
  8019c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019cc:	00 
  8019cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019d9:	48 89 d1             	mov    %rdx,%rcx
  8019dc:	48 89 c2             	mov    %rax,%rdx
  8019df:	be 01 00 00 00       	mov    $0x1,%esi
  8019e4:	bf 08 00 00 00       	mov    $0x8,%edi
  8019e9:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  8019f0:	00 00 00 
  8019f3:	ff d0                	callq  *%rax
}
  8019f5:	c9                   	leaveq 
  8019f6:	c3                   	retq   

00000000008019f7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019f7:	55                   	push   %rbp
  8019f8:	48 89 e5             	mov    %rsp,%rbp
  8019fb:	48 83 ec 20          	sub    $0x20,%rsp
  8019ff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0d:	48 98                	cltq   
  801a0f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a16:	00 
  801a17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a23:	48 89 d1             	mov    %rdx,%rcx
  801a26:	48 89 c2             	mov    %rax,%rdx
  801a29:	be 01 00 00 00       	mov    $0x1,%esi
  801a2e:	bf 09 00 00 00       	mov    $0x9,%edi
  801a33:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  801a3a:	00 00 00 
  801a3d:	ff d0                	callq  *%rax
}
  801a3f:	c9                   	leaveq 
  801a40:	c3                   	retq   

0000000000801a41 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a41:	55                   	push   %rbp
  801a42:	48 89 e5             	mov    %rsp,%rbp
  801a45:	48 83 ec 20          	sub    $0x20,%rsp
  801a49:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a57:	48 98                	cltq   
  801a59:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a60:	00 
  801a61:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a67:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a6d:	48 89 d1             	mov    %rdx,%rcx
  801a70:	48 89 c2             	mov    %rax,%rdx
  801a73:	be 01 00 00 00       	mov    $0x1,%esi
  801a78:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a7d:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  801a84:	00 00 00 
  801a87:	ff d0                	callq  *%rax
}
  801a89:	c9                   	leaveq 
  801a8a:	c3                   	retq   

0000000000801a8b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a8b:	55                   	push   %rbp
  801a8c:	48 89 e5             	mov    %rsp,%rbp
  801a8f:	48 83 ec 20          	sub    $0x20,%rsp
  801a93:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a96:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a9a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a9e:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801aa1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aa4:	48 63 f0             	movslq %eax,%rsi
  801aa7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aae:	48 98                	cltq   
  801ab0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ab4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801abb:	00 
  801abc:	49 89 f1             	mov    %rsi,%r9
  801abf:	49 89 c8             	mov    %rcx,%r8
  801ac2:	48 89 d1             	mov    %rdx,%rcx
  801ac5:	48 89 c2             	mov    %rax,%rdx
  801ac8:	be 00 00 00 00       	mov    $0x0,%esi
  801acd:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ad2:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  801ad9:	00 00 00 
  801adc:	ff d0                	callq  *%rax
}
  801ade:	c9                   	leaveq 
  801adf:	c3                   	retq   

0000000000801ae0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ae0:	55                   	push   %rbp
  801ae1:	48 89 e5             	mov    %rsp,%rbp
  801ae4:	48 83 ec 10          	sub    $0x10,%rsp
  801ae8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801aec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801af0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af7:	00 
  801af8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801afe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b04:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b09:	48 89 c2             	mov    %rax,%rdx
  801b0c:	be 01 00 00 00       	mov    $0x1,%esi
  801b11:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b16:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  801b1d:	00 00 00 
  801b20:	ff d0                	callq  *%rax
}
  801b22:	c9                   	leaveq 
  801b23:	c3                   	retq   

0000000000801b24 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801b24:	55                   	push   %rbp
  801b25:	48 89 e5             	mov    %rsp,%rbp
  801b28:	48 83 ec 08          	sub    $0x8,%rsp
  801b2c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801b30:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801b34:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801b3b:	ff ff ff 
  801b3e:	48 01 d0             	add    %rdx,%rax
  801b41:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801b45:	c9                   	leaveq 
  801b46:	c3                   	retq   

0000000000801b47 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801b47:	55                   	push   %rbp
  801b48:	48 89 e5             	mov    %rsp,%rbp
  801b4b:	48 83 ec 08          	sub    $0x8,%rsp
  801b4f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801b53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b57:	48 89 c7             	mov    %rax,%rdi
  801b5a:	48 b8 24 1b 80 00 00 	movabs $0x801b24,%rax
  801b61:	00 00 00 
  801b64:	ff d0                	callq  *%rax
  801b66:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801b6c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801b70:	c9                   	leaveq 
  801b71:	c3                   	retq   

0000000000801b72 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	48 83 ec 18          	sub    $0x18,%rsp
  801b7a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b85:	eb 6b                	jmp    801bf2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801b87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b8a:	48 98                	cltq   
  801b8c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801b92:	48 c1 e0 0c          	shl    $0xc,%rax
  801b96:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801b9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b9e:	48 c1 e8 15          	shr    $0x15,%rax
  801ba2:	48 89 c2             	mov    %rax,%rdx
  801ba5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801bac:	01 00 00 
  801baf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bb3:	83 e0 01             	and    $0x1,%eax
  801bb6:	48 85 c0             	test   %rax,%rax
  801bb9:	74 21                	je     801bdc <fd_alloc+0x6a>
  801bbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bbf:	48 c1 e8 0c          	shr    $0xc,%rax
  801bc3:	48 89 c2             	mov    %rax,%rdx
  801bc6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801bcd:	01 00 00 
  801bd0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801bd4:	83 e0 01             	and    $0x1,%eax
  801bd7:	48 85 c0             	test   %rax,%rax
  801bda:	75 12                	jne    801bee <fd_alloc+0x7c>
			*fd_store = fd;
  801bdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801be4:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801be7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bec:	eb 1a                	jmp    801c08 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801bee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801bf2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801bf6:	7e 8f                	jle    801b87 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bfc:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801c03:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801c08:	c9                   	leaveq 
  801c09:	c3                   	retq   

0000000000801c0a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c0a:	55                   	push   %rbp
  801c0b:	48 89 e5             	mov    %rsp,%rbp
  801c0e:	48 83 ec 20          	sub    $0x20,%rsp
  801c12:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c15:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c19:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801c1d:	78 06                	js     801c25 <fd_lookup+0x1b>
  801c1f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801c23:	7e 07                	jle    801c2c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c2a:	eb 6c                	jmp    801c98 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801c2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801c2f:	48 98                	cltq   
  801c31:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801c37:	48 c1 e0 0c          	shl    $0xc,%rax
  801c3b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c43:	48 c1 e8 15          	shr    $0x15,%rax
  801c47:	48 89 c2             	mov    %rax,%rdx
  801c4a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801c51:	01 00 00 
  801c54:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c58:	83 e0 01             	and    $0x1,%eax
  801c5b:	48 85 c0             	test   %rax,%rax
  801c5e:	74 21                	je     801c81 <fd_lookup+0x77>
  801c60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c64:	48 c1 e8 0c          	shr    $0xc,%rax
  801c68:	48 89 c2             	mov    %rax,%rdx
  801c6b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801c72:	01 00 00 
  801c75:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801c79:	83 e0 01             	and    $0x1,%eax
  801c7c:	48 85 c0             	test   %rax,%rax
  801c7f:	75 07                	jne    801c88 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801c81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c86:	eb 10                	jmp    801c98 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801c88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c8c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c90:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c98:	c9                   	leaveq 
  801c99:	c3                   	retq   

0000000000801c9a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801c9a:	55                   	push   %rbp
  801c9b:	48 89 e5             	mov    %rsp,%rbp
  801c9e:	48 83 ec 30          	sub    $0x30,%rsp
  801ca2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ca6:	89 f0                	mov    %esi,%eax
  801ca8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801caf:	48 89 c7             	mov    %rax,%rdi
  801cb2:	48 b8 24 1b 80 00 00 	movabs $0x801b24,%rax
  801cb9:	00 00 00 
  801cbc:	ff d0                	callq  *%rax
  801cbe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cc2:	48 89 d6             	mov    %rdx,%rsi
  801cc5:	89 c7                	mov    %eax,%edi
  801cc7:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  801cce:	00 00 00 
  801cd1:	ff d0                	callq  *%rax
  801cd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801cd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801cda:	78 0a                	js     801ce6 <fd_close+0x4c>
	    || fd != fd2)
  801cdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce0:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801ce4:	74 12                	je     801cf8 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801ce6:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801cea:	74 05                	je     801cf1 <fd_close+0x57>
  801cec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cef:	eb 05                	jmp    801cf6 <fd_close+0x5c>
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf6:	eb 69                	jmp    801d61 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801cf8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cfc:	8b 00                	mov    (%rax),%eax
  801cfe:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801d02:	48 89 d6             	mov    %rdx,%rsi
  801d05:	89 c7                	mov    %eax,%edi
  801d07:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  801d0e:	00 00 00 
  801d11:	ff d0                	callq  *%rax
  801d13:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d16:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801d1a:	78 2a                	js     801d46 <fd_close+0xac>
		if (dev->dev_close)
  801d1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d20:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d24:	48 85 c0             	test   %rax,%rax
  801d27:	74 16                	je     801d3f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801d29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d2d:	48 8b 40 20          	mov    0x20(%rax),%rax
  801d31:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801d35:	48 89 d7             	mov    %rdx,%rdi
  801d38:	ff d0                	callq  *%rax
  801d3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801d3d:	eb 07                	jmp    801d46 <fd_close+0xac>
		else
			r = 0;
  801d3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d4a:	48 89 c6             	mov    %rax,%rsi
  801d4d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d52:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  801d59:	00 00 00 
  801d5c:	ff d0                	callq  *%rax
	return r;
  801d5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801d61:	c9                   	leaveq 
  801d62:	c3                   	retq   

0000000000801d63 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d63:	55                   	push   %rbp
  801d64:	48 89 e5             	mov    %rsp,%rbp
  801d67:	48 83 ec 20          	sub    $0x20,%rsp
  801d6b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801d72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d79:	eb 41                	jmp    801dbc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801d7b:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d82:	00 00 00 
  801d85:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d88:	48 63 d2             	movslq %edx,%rdx
  801d8b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d8f:	8b 00                	mov    (%rax),%eax
  801d91:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801d94:	75 22                	jne    801db8 <dev_lookup+0x55>
			*dev = devtab[i];
  801d96:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801d9d:	00 00 00 
  801da0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801da3:	48 63 d2             	movslq %edx,%rdx
  801da6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801daa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dae:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
  801db6:	eb 60                	jmp    801e18 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801db8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dbc:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801dc3:	00 00 00 
  801dc6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801dc9:	48 63 d2             	movslq %edx,%rdx
  801dcc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dd0:	48 85 c0             	test   %rax,%rax
  801dd3:	75 a6                	jne    801d7b <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801dd5:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801ddc:	00 00 00 
  801ddf:	48 8b 00             	mov    (%rax),%rax
  801de2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801de8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801deb:	89 c6                	mov    %eax,%esi
  801ded:	48 bf f8 46 80 00 00 	movabs $0x8046f8,%rdi
  801df4:	00 00 00 
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	48 b9 d3 03 80 00 00 	movabs $0x8003d3,%rcx
  801e03:	00 00 00 
  801e06:	ff d1                	callq  *%rcx
	*dev = 0;
  801e08:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e0c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801e13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e18:	c9                   	leaveq 
  801e19:	c3                   	retq   

0000000000801e1a <close>:

int
close(int fdnum)
{
  801e1a:	55                   	push   %rbp
  801e1b:	48 89 e5             	mov    %rsp,%rbp
  801e1e:	48 83 ec 20          	sub    $0x20,%rsp
  801e22:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e25:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e2c:	48 89 d6             	mov    %rdx,%rsi
  801e2f:	89 c7                	mov    %eax,%edi
  801e31:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  801e38:	00 00 00 
  801e3b:	ff d0                	callq  *%rax
  801e3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e44:	79 05                	jns    801e4b <close+0x31>
		return r;
  801e46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e49:	eb 18                	jmp    801e63 <close+0x49>
	else
		return fd_close(fd, 1);
  801e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e4f:	be 01 00 00 00       	mov    $0x1,%esi
  801e54:	48 89 c7             	mov    %rax,%rdi
  801e57:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  801e5e:	00 00 00 
  801e61:	ff d0                	callq  *%rax
}
  801e63:	c9                   	leaveq 
  801e64:	c3                   	retq   

0000000000801e65 <close_all>:

void
close_all(void)
{
  801e65:	55                   	push   %rbp
  801e66:	48 89 e5             	mov    %rsp,%rbp
  801e69:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e74:	eb 15                	jmp    801e8b <close_all+0x26>
		close(i);
  801e76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e79:	89 c7                	mov    %eax,%edi
  801e7b:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  801e82:	00 00 00 
  801e85:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e87:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e8b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e8f:	7e e5                	jle    801e76 <close_all+0x11>
		close(i);
}
  801e91:	c9                   	leaveq 
  801e92:	c3                   	retq   

0000000000801e93 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e93:	55                   	push   %rbp
  801e94:	48 89 e5             	mov    %rsp,%rbp
  801e97:	48 83 ec 40          	sub    $0x40,%rsp
  801e9b:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801e9e:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ea1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801ea5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801ea8:	48 89 d6             	mov    %rdx,%rsi
  801eab:	89 c7                	mov    %eax,%edi
  801ead:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  801eb4:	00 00 00 
  801eb7:	ff d0                	callq  *%rax
  801eb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ebc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ec0:	79 08                	jns    801eca <dup+0x37>
		return r;
  801ec2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec5:	e9 70 01 00 00       	jmpq   80203a <dup+0x1a7>
	close(newfdnum);
  801eca:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ecd:	89 c7                	mov    %eax,%edi
  801ecf:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  801ed6:	00 00 00 
  801ed9:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  801edb:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801ede:	48 98                	cltq   
  801ee0:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801ee6:	48 c1 e0 0c          	shl    $0xc,%rax
  801eea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801eee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef2:	48 89 c7             	mov    %rax,%rdi
  801ef5:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  801efc:	00 00 00 
  801eff:	ff d0                	callq  *%rax
  801f01:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801f05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f09:	48 89 c7             	mov    %rax,%rdi
  801f0c:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  801f13:	00 00 00 
  801f16:	ff d0                	callq  *%rax
  801f18:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f20:	48 c1 e8 15          	shr    $0x15,%rax
  801f24:	48 89 c2             	mov    %rax,%rdx
  801f27:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801f2e:	01 00 00 
  801f31:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f35:	83 e0 01             	and    $0x1,%eax
  801f38:	48 85 c0             	test   %rax,%rax
  801f3b:	74 73                	je     801fb0 <dup+0x11d>
  801f3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f41:	48 c1 e8 0c          	shr    $0xc,%rax
  801f45:	48 89 c2             	mov    %rax,%rdx
  801f48:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f4f:	01 00 00 
  801f52:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f56:	83 e0 01             	and    $0x1,%eax
  801f59:	48 85 c0             	test   %rax,%rax
  801f5c:	74 52                	je     801fb0 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f62:	48 c1 e8 0c          	shr    $0xc,%rax
  801f66:	48 89 c2             	mov    %rax,%rdx
  801f69:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f70:	01 00 00 
  801f73:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f77:	25 07 0e 00 00       	and    $0xe07,%eax
  801f7c:	89 c1                	mov    %eax,%ecx
  801f7e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801f82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f86:	41 89 c8             	mov    %ecx,%r8d
  801f89:	48 89 d1             	mov    %rdx,%rcx
  801f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f91:	48 89 c6             	mov    %rax,%rsi
  801f94:	bf 00 00 00 00       	mov    $0x0,%edi
  801f99:	48 b8 07 19 80 00 00 	movabs $0x801907,%rax
  801fa0:	00 00 00 
  801fa3:	ff d0                	callq  *%rax
  801fa5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fac:	79 02                	jns    801fb0 <dup+0x11d>
			goto err;
  801fae:	eb 57                	jmp    802007 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fb4:	48 c1 e8 0c          	shr    $0xc,%rax
  801fb8:	48 89 c2             	mov    %rax,%rdx
  801fbb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801fc2:	01 00 00 
  801fc5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801fc9:	25 07 0e 00 00       	and    $0xe07,%eax
  801fce:	89 c1                	mov    %eax,%ecx
  801fd0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801fd8:	41 89 c8             	mov    %ecx,%r8d
  801fdb:	48 89 d1             	mov    %rdx,%rcx
  801fde:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe3:	48 89 c6             	mov    %rax,%rsi
  801fe6:	bf 00 00 00 00       	mov    $0x0,%edi
  801feb:	48 b8 07 19 80 00 00 	movabs $0x801907,%rax
  801ff2:	00 00 00 
  801ff5:	ff d0                	callq  *%rax
  801ff7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ffa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ffe:	79 02                	jns    802002 <dup+0x16f>
		goto err;
  802000:	eb 05                	jmp    802007 <dup+0x174>

	return newfdnum;
  802002:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802005:	eb 33                	jmp    80203a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802007:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80200b:	48 89 c6             	mov    %rax,%rsi
  80200e:	bf 00 00 00 00       	mov    $0x0,%edi
  802013:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  80201a:	00 00 00 
  80201d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80201f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802023:	48 89 c6             	mov    %rax,%rsi
  802026:	bf 00 00 00 00       	mov    $0x0,%edi
  80202b:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  802032:	00 00 00 
  802035:	ff d0                	callq  *%rax
	return r;
  802037:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80203a:	c9                   	leaveq 
  80203b:	c3                   	retq   

000000000080203c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80203c:	55                   	push   %rbp
  80203d:	48 89 e5             	mov    %rsp,%rbp
  802040:	48 83 ec 40          	sub    $0x40,%rsp
  802044:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802047:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80204b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80204f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802053:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802056:	48 89 d6             	mov    %rdx,%rsi
  802059:	89 c7                	mov    %eax,%edi
  80205b:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  802062:	00 00 00 
  802065:	ff d0                	callq  *%rax
  802067:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80206a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80206e:	78 24                	js     802094 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802070:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802074:	8b 00                	mov    (%rax),%eax
  802076:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80207a:	48 89 d6             	mov    %rdx,%rsi
  80207d:	89 c7                	mov    %eax,%edi
  80207f:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  802086:	00 00 00 
  802089:	ff d0                	callq  *%rax
  80208b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80208e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802092:	79 05                	jns    802099 <read+0x5d>
		return r;
  802094:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802097:	eb 76                	jmp    80210f <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802099:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80209d:	8b 40 08             	mov    0x8(%rax),%eax
  8020a0:	83 e0 03             	and    $0x3,%eax
  8020a3:	83 f8 01             	cmp    $0x1,%eax
  8020a6:	75 3a                	jne    8020e2 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020a8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8020af:	00 00 00 
  8020b2:	48 8b 00             	mov    (%rax),%rax
  8020b5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8020bb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8020be:	89 c6                	mov    %eax,%esi
  8020c0:	48 bf 17 47 80 00 00 	movabs $0x804717,%rdi
  8020c7:	00 00 00 
  8020ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cf:	48 b9 d3 03 80 00 00 	movabs $0x8003d3,%rcx
  8020d6:	00 00 00 
  8020d9:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8020db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020e0:	eb 2d                	jmp    80210f <read+0xd3>
	}
	if (!dev->dev_read)
  8020e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020e6:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020ea:	48 85 c0             	test   %rax,%rax
  8020ed:	75 07                	jne    8020f6 <read+0xba>
		return -E_NOT_SUPP;
  8020ef:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8020f4:	eb 19                	jmp    80210f <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8020f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fa:	48 8b 40 10          	mov    0x10(%rax),%rax
  8020fe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802102:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802106:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80210a:	48 89 cf             	mov    %rcx,%rdi
  80210d:	ff d0                	callq  *%rax
}
  80210f:	c9                   	leaveq 
  802110:	c3                   	retq   

0000000000802111 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802111:	55                   	push   %rbp
  802112:	48 89 e5             	mov    %rsp,%rbp
  802115:	48 83 ec 30          	sub    $0x30,%rsp
  802119:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80211c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802120:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80212b:	eb 49                	jmp    802176 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80212d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802130:	48 98                	cltq   
  802132:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802136:	48 29 c2             	sub    %rax,%rdx
  802139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80213c:	48 63 c8             	movslq %eax,%rcx
  80213f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802143:	48 01 c1             	add    %rax,%rcx
  802146:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802149:	48 89 ce             	mov    %rcx,%rsi
  80214c:	89 c7                	mov    %eax,%edi
  80214e:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  802155:	00 00 00 
  802158:	ff d0                	callq  *%rax
  80215a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80215d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802161:	79 05                	jns    802168 <readn+0x57>
			return m;
  802163:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802166:	eb 1c                	jmp    802184 <readn+0x73>
		if (m == 0)
  802168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80216c:	75 02                	jne    802170 <readn+0x5f>
			break;
  80216e:	eb 11                	jmp    802181 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802170:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802173:	01 45 fc             	add    %eax,-0x4(%rbp)
  802176:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802179:	48 98                	cltq   
  80217b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80217f:	72 ac                	jb     80212d <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802181:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802184:	c9                   	leaveq 
  802185:	c3                   	retq   

0000000000802186 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802186:	55                   	push   %rbp
  802187:	48 89 e5             	mov    %rsp,%rbp
  80218a:	48 83 ec 40          	sub    $0x40,%rsp
  80218e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802191:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802195:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802199:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80219d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021a0:	48 89 d6             	mov    %rdx,%rsi
  8021a3:	89 c7                	mov    %eax,%edi
  8021a5:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  8021ac:	00 00 00 
  8021af:	ff d0                	callq  *%rax
  8021b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b8:	78 24                	js     8021de <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021be:	8b 00                	mov    (%rax),%eax
  8021c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021c4:	48 89 d6             	mov    %rdx,%rsi
  8021c7:	89 c7                	mov    %eax,%edi
  8021c9:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  8021d0:	00 00 00 
  8021d3:	ff d0                	callq  *%rax
  8021d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021dc:	79 05                	jns    8021e3 <write+0x5d>
		return r;
  8021de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021e1:	eb 75                	jmp    802258 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e7:	8b 40 08             	mov    0x8(%rax),%eax
  8021ea:	83 e0 03             	and    $0x3,%eax
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	75 3a                	jne    80222b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8021f1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8021f8:	00 00 00 
  8021fb:	48 8b 00             	mov    (%rax),%rax
  8021fe:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802204:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802207:	89 c6                	mov    %eax,%esi
  802209:	48 bf 33 47 80 00 00 	movabs $0x804733,%rdi
  802210:	00 00 00 
  802213:	b8 00 00 00 00       	mov    $0x0,%eax
  802218:	48 b9 d3 03 80 00 00 	movabs $0x8003d3,%rcx
  80221f:	00 00 00 
  802222:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802224:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802229:	eb 2d                	jmp    802258 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80222b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802233:	48 85 c0             	test   %rax,%rax
  802236:	75 07                	jne    80223f <write+0xb9>
		return -E_NOT_SUPP;
  802238:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80223d:	eb 19                	jmp    802258 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80223f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802243:	48 8b 40 18          	mov    0x18(%rax),%rax
  802247:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80224b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80224f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802253:	48 89 cf             	mov    %rcx,%rdi
  802256:	ff d0                	callq  *%rax
}
  802258:	c9                   	leaveq 
  802259:	c3                   	retq   

000000000080225a <seek>:

int
seek(int fdnum, off_t offset)
{
  80225a:	55                   	push   %rbp
  80225b:	48 89 e5             	mov    %rsp,%rbp
  80225e:	48 83 ec 18          	sub    $0x18,%rsp
  802262:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802265:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802268:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80226c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80226f:	48 89 d6             	mov    %rdx,%rsi
  802272:	89 c7                	mov    %eax,%edi
  802274:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  80227b:	00 00 00 
  80227e:	ff d0                	callq  *%rax
  802280:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802283:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802287:	79 05                	jns    80228e <seek+0x34>
		return r;
  802289:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228c:	eb 0f                	jmp    80229d <seek+0x43>
	fd->fd_offset = offset;
  80228e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802292:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802295:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802298:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229d:	c9                   	leaveq 
  80229e:	c3                   	retq   

000000000080229f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80229f:	55                   	push   %rbp
  8022a0:	48 89 e5             	mov    %rsp,%rbp
  8022a3:	48 83 ec 30          	sub    $0x30,%rsp
  8022a7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022aa:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022ad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022b1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022b4:	48 89 d6             	mov    %rdx,%rsi
  8022b7:	89 c7                	mov    %eax,%edi
  8022b9:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  8022c0:	00 00 00 
  8022c3:	ff d0                	callq  *%rax
  8022c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022cc:	78 24                	js     8022f2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022d2:	8b 00                	mov    (%rax),%eax
  8022d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8022d8:	48 89 d6             	mov    %rdx,%rsi
  8022db:	89 c7                	mov    %eax,%edi
  8022dd:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  8022e4:	00 00 00 
  8022e7:	ff d0                	callq  *%rax
  8022e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022f0:	79 05                	jns    8022f7 <ftruncate+0x58>
		return r;
  8022f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f5:	eb 72                	jmp    802369 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022fb:	8b 40 08             	mov    0x8(%rax),%eax
  8022fe:	83 e0 03             	and    $0x3,%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	75 3a                	jne    80233f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802305:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80230c:	00 00 00 
  80230f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802312:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802318:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80231b:	89 c6                	mov    %eax,%esi
  80231d:	48 bf 50 47 80 00 00 	movabs $0x804750,%rdi
  802324:	00 00 00 
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
  80232c:	48 b9 d3 03 80 00 00 	movabs $0x8003d3,%rcx
  802333:	00 00 00 
  802336:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802338:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80233d:	eb 2a                	jmp    802369 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80233f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802343:	48 8b 40 30          	mov    0x30(%rax),%rax
  802347:	48 85 c0             	test   %rax,%rax
  80234a:	75 07                	jne    802353 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80234c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802351:	eb 16                	jmp    802369 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802357:	48 8b 40 30          	mov    0x30(%rax),%rax
  80235b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80235f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802362:	89 ce                	mov    %ecx,%esi
  802364:	48 89 d7             	mov    %rdx,%rdi
  802367:	ff d0                	callq  *%rax
}
  802369:	c9                   	leaveq 
  80236a:	c3                   	retq   

000000000080236b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80236b:	55                   	push   %rbp
  80236c:	48 89 e5             	mov    %rsp,%rbp
  80236f:	48 83 ec 30          	sub    $0x30,%rsp
  802373:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802376:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80237a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80237e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802381:	48 89 d6             	mov    %rdx,%rsi
  802384:	89 c7                	mov    %eax,%edi
  802386:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  80238d:	00 00 00 
  802390:	ff d0                	callq  *%rax
  802392:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802395:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802399:	78 24                	js     8023bf <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80239b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239f:	8b 00                	mov    (%rax),%eax
  8023a1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023a5:	48 89 d6             	mov    %rdx,%rsi
  8023a8:	89 c7                	mov    %eax,%edi
  8023aa:	48 b8 63 1d 80 00 00 	movabs $0x801d63,%rax
  8023b1:	00 00 00 
  8023b4:	ff d0                	callq  *%rax
  8023b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023bd:	79 05                	jns    8023c4 <fstat+0x59>
		return r;
  8023bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023c2:	eb 5e                	jmp    802422 <fstat+0xb7>
	if (!dev->dev_stat)
  8023c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023c8:	48 8b 40 28          	mov    0x28(%rax),%rax
  8023cc:	48 85 c0             	test   %rax,%rax
  8023cf:	75 07                	jne    8023d8 <fstat+0x6d>
		return -E_NOT_SUPP;
  8023d1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023d6:	eb 4a                	jmp    802422 <fstat+0xb7>
	stat->st_name[0] = 0;
  8023d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023dc:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8023df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023e3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8023ea:	00 00 00 
	stat->st_isdir = 0;
  8023ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023f1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8023f8:	00 00 00 
	stat->st_dev = dev;
  8023fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802403:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80240a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80240e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802412:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802416:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80241a:	48 89 ce             	mov    %rcx,%rsi
  80241d:	48 89 d7             	mov    %rdx,%rdi
  802420:	ff d0                	callq  *%rax
}
  802422:	c9                   	leaveq 
  802423:	c3                   	retq   

0000000000802424 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802424:	55                   	push   %rbp
  802425:	48 89 e5             	mov    %rsp,%rbp
  802428:	48 83 ec 20          	sub    $0x20,%rsp
  80242c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802430:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802438:	be 00 00 00 00       	mov    $0x0,%esi
  80243d:	48 89 c7             	mov    %rax,%rdi
  802440:	48 b8 12 25 80 00 00 	movabs $0x802512,%rax
  802447:	00 00 00 
  80244a:	ff d0                	callq  *%rax
  80244c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802453:	79 05                	jns    80245a <stat+0x36>
		return fd;
  802455:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802458:	eb 2f                	jmp    802489 <stat+0x65>
	r = fstat(fd, stat);
  80245a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80245e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802461:	48 89 d6             	mov    %rdx,%rsi
  802464:	89 c7                	mov    %eax,%edi
  802466:	48 b8 6b 23 80 00 00 	movabs $0x80236b,%rax
  80246d:	00 00 00 
  802470:	ff d0                	callq  *%rax
  802472:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802475:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802478:	89 c7                	mov    %eax,%edi
  80247a:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  802481:	00 00 00 
  802484:	ff d0                	callq  *%rax
	return r;
  802486:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802489:	c9                   	leaveq 
  80248a:	c3                   	retq   

000000000080248b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80248b:	55                   	push   %rbp
  80248c:	48 89 e5             	mov    %rsp,%rbp
  80248f:	48 83 ec 10          	sub    $0x10,%rsp
  802493:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802496:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80249a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024a1:	00 00 00 
  8024a4:	8b 00                	mov    (%rax),%eax
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	75 1d                	jne    8024c7 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8024aa:	bf 01 00 00 00       	mov    $0x1,%edi
  8024af:	48 b8 46 40 80 00 00 	movabs $0x804046,%rax
  8024b6:	00 00 00 
  8024b9:	ff d0                	callq  *%rax
  8024bb:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8024c2:	00 00 00 
  8024c5:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8024c7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8024ce:	00 00 00 
  8024d1:	8b 00                	mov    (%rax),%eax
  8024d3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024d6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8024db:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8024e2:	00 00 00 
  8024e5:	89 c7                	mov    %eax,%edi
  8024e7:	48 b8 a9 3f 80 00 00 	movabs $0x803fa9,%rax
  8024ee:	00 00 00 
  8024f1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8024f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fc:	48 89 c6             	mov    %rax,%rsi
  8024ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802504:	48 b8 e3 3e 80 00 00 	movabs $0x803ee3,%rax
  80250b:	00 00 00 
  80250e:	ff d0                	callq  *%rax
}
  802510:	c9                   	leaveq 
  802511:	c3                   	retq   

0000000000802512 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802512:	55                   	push   %rbp
  802513:	48 89 e5             	mov    %rsp,%rbp
  802516:	48 83 ec 20          	sub    $0x20,%rsp
  80251a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80251e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802525:	48 89 c7             	mov    %rax,%rdi
  802528:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  80252f:	00 00 00 
  802532:	ff d0                	callq  *%rax
  802534:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802539:	7e 0a                	jle    802545 <open+0x33>
  80253b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802540:	e9 a5 00 00 00       	jmpq   8025ea <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802545:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802549:	48 89 c7             	mov    %rax,%rdi
  80254c:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  802553:	00 00 00 
  802556:	ff d0                	callq  *%rax
  802558:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80255f:	79 08                	jns    802569 <open+0x57>
		return r;
  802561:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802564:	e9 81 00 00 00       	jmpq   8025ea <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802569:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802570:	00 00 00 
  802573:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802576:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80257c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802580:	48 89 c6             	mov    %rax,%rsi
  802583:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80258a:	00 00 00 
  80258d:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  802594:	00 00 00 
  802597:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802599:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259d:	48 89 c6             	mov    %rax,%rsi
  8025a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8025a5:	48 b8 8b 24 80 00 00 	movabs $0x80248b,%rax
  8025ac:	00 00 00 
  8025af:	ff d0                	callq  *%rax
  8025b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b8:	79 1d                	jns    8025d7 <open+0xc5>
		fd_close(fd, 0);
  8025ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025be:	be 00 00 00 00       	mov    $0x0,%esi
  8025c3:	48 89 c7             	mov    %rax,%rdi
  8025c6:	48 b8 9a 1c 80 00 00 	movabs $0x801c9a,%rax
  8025cd:	00 00 00 
  8025d0:	ff d0                	callq  *%rax
		return r;
  8025d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d5:	eb 13                	jmp    8025ea <open+0xd8>
	}
	return fd2num(fd);
  8025d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025db:	48 89 c7             	mov    %rax,%rdi
  8025de:	48 b8 24 1b 80 00 00 	movabs $0x801b24,%rax
  8025e5:	00 00 00 
  8025e8:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  8025ea:	c9                   	leaveq 
  8025eb:	c3                   	retq   

00000000008025ec <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025ec:	55                   	push   %rbp
  8025ed:	48 89 e5             	mov    %rsp,%rbp
  8025f0:	48 83 ec 10          	sub    $0x10,%rsp
  8025f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025fc:	8b 50 0c             	mov    0xc(%rax),%edx
  8025ff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802606:	00 00 00 
  802609:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80260b:	be 00 00 00 00       	mov    $0x0,%esi
  802610:	bf 06 00 00 00       	mov    $0x6,%edi
  802615:	48 b8 8b 24 80 00 00 	movabs $0x80248b,%rax
  80261c:	00 00 00 
  80261f:	ff d0                	callq  *%rax
}
  802621:	c9                   	leaveq 
  802622:	c3                   	retq   

0000000000802623 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802623:	55                   	push   %rbp
  802624:	48 89 e5             	mov    %rsp,%rbp
  802627:	48 83 ec 30          	sub    $0x30,%rsp
  80262b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80262f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802633:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802637:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80263b:	8b 50 0c             	mov    0xc(%rax),%edx
  80263e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802645:	00 00 00 
  802648:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80264a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802651:	00 00 00 
  802654:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802658:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  80265c:	be 00 00 00 00       	mov    $0x0,%esi
  802661:	bf 03 00 00 00       	mov    $0x3,%edi
  802666:	48 b8 8b 24 80 00 00 	movabs $0x80248b,%rax
  80266d:	00 00 00 
  802670:	ff d0                	callq  *%rax
  802672:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802675:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802679:	79 05                	jns    802680 <devfile_read+0x5d>
		return r;
  80267b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267e:	eb 26                	jmp    8026a6 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802680:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802683:	48 63 d0             	movslq %eax,%rdx
  802686:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80268a:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802691:	00 00 00 
  802694:	48 89 c7             	mov    %rax,%rdi
  802697:	48 b8 c3 13 80 00 00 	movabs $0x8013c3,%rax
  80269e:	00 00 00 
  8026a1:	ff d0                	callq  *%rax
	return r;
  8026a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  8026a6:	c9                   	leaveq 
  8026a7:	c3                   	retq   

00000000008026a8 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8026a8:	55                   	push   %rbp
  8026a9:	48 89 e5             	mov    %rsp,%rbp
  8026ac:	48 83 ec 30          	sub    $0x30,%rsp
  8026b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  8026bc:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  8026c3:	00 
	n = n > max ? max : n;
  8026c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026c8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8026cc:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8026d1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8026d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d9:	8b 50 0c             	mov    0xc(%rax),%edx
  8026dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026e3:	00 00 00 
  8026e6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8026e8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8026ef:	00 00 00 
  8026f2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026f6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8026fa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802702:	48 89 c6             	mov    %rax,%rsi
  802705:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  80270c:	00 00 00 
  80270f:	48 b8 c3 13 80 00 00 	movabs $0x8013c3,%rax
  802716:	00 00 00 
  802719:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  80271b:	be 00 00 00 00       	mov    $0x0,%esi
  802720:	bf 04 00 00 00       	mov    $0x4,%edi
  802725:	48 b8 8b 24 80 00 00 	movabs $0x80248b,%rax
  80272c:	00 00 00 
  80272f:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802731:	c9                   	leaveq 
  802732:	c3                   	retq   

0000000000802733 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802733:	55                   	push   %rbp
  802734:	48 89 e5             	mov    %rsp,%rbp
  802737:	48 83 ec 20          	sub    $0x20,%rsp
  80273b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80273f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802743:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802747:	8b 50 0c             	mov    0xc(%rax),%edx
  80274a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802751:	00 00 00 
  802754:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802756:	be 00 00 00 00       	mov    $0x0,%esi
  80275b:	bf 05 00 00 00       	mov    $0x5,%edi
  802760:	48 b8 8b 24 80 00 00 	movabs $0x80248b,%rax
  802767:	00 00 00 
  80276a:	ff d0                	callq  *%rax
  80276c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80276f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802773:	79 05                	jns    80277a <devfile_stat+0x47>
		return r;
  802775:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802778:	eb 56                	jmp    8027d0 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80277a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80277e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802785:	00 00 00 
  802788:	48 89 c7             	mov    %rax,%rdi
  80278b:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802797:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80279e:	00 00 00 
  8027a1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8027a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ab:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8027b1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027b8:	00 00 00 
  8027bb:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8027c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027c5:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8027cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d0:	c9                   	leaveq 
  8027d1:	c3                   	retq   

00000000008027d2 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8027d2:	55                   	push   %rbp
  8027d3:	48 89 e5             	mov    %rsp,%rbp
  8027d6:	48 83 ec 10          	sub    $0x10,%rsp
  8027da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027de:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8027e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027e5:	8b 50 0c             	mov    0xc(%rax),%edx
  8027e8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027ef:	00 00 00 
  8027f2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8027f4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8027fb:	00 00 00 
  8027fe:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802801:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802804:	be 00 00 00 00       	mov    $0x0,%esi
  802809:	bf 02 00 00 00       	mov    $0x2,%edi
  80280e:	48 b8 8b 24 80 00 00 	movabs $0x80248b,%rax
  802815:	00 00 00 
  802818:	ff d0                	callq  *%rax
}
  80281a:	c9                   	leaveq 
  80281b:	c3                   	retq   

000000000080281c <remove>:

// Delete a file
int
remove(const char *path)
{
  80281c:	55                   	push   %rbp
  80281d:	48 89 e5             	mov    %rsp,%rbp
  802820:	48 83 ec 10          	sub    $0x10,%rsp
  802824:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802828:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80282c:	48 89 c7             	mov    %rax,%rdi
  80282f:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  802836:	00 00 00 
  802839:	ff d0                	callq  *%rax
  80283b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802840:	7e 07                	jle    802849 <remove+0x2d>
		return -E_BAD_PATH;
  802842:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802847:	eb 33                	jmp    80287c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802849:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80284d:	48 89 c6             	mov    %rax,%rsi
  802850:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802857:	00 00 00 
  80285a:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  802861:	00 00 00 
  802864:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802866:	be 00 00 00 00       	mov    $0x0,%esi
  80286b:	bf 07 00 00 00       	mov    $0x7,%edi
  802870:	48 b8 8b 24 80 00 00 	movabs $0x80248b,%rax
  802877:	00 00 00 
  80287a:	ff d0                	callq  *%rax
}
  80287c:	c9                   	leaveq 
  80287d:	c3                   	retq   

000000000080287e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80287e:	55                   	push   %rbp
  80287f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802882:	be 00 00 00 00       	mov    $0x0,%esi
  802887:	bf 08 00 00 00       	mov    $0x8,%edi
  80288c:	48 b8 8b 24 80 00 00 	movabs $0x80248b,%rax
  802893:	00 00 00 
  802896:	ff d0                	callq  *%rax
}
  802898:	5d                   	pop    %rbp
  802899:	c3                   	retq   

000000000080289a <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80289a:	55                   	push   %rbp
  80289b:	48 89 e5             	mov    %rsp,%rbp
  80289e:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8028a5:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8028ac:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8028b3:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8028ba:	be 00 00 00 00       	mov    $0x0,%esi
  8028bf:	48 89 c7             	mov    %rax,%rdi
  8028c2:	48 b8 12 25 80 00 00 	movabs $0x802512,%rax
  8028c9:	00 00 00 
  8028cc:	ff d0                	callq  *%rax
  8028ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8028d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d5:	79 28                	jns    8028ff <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8028d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028da:	89 c6                	mov    %eax,%esi
  8028dc:	48 bf 76 47 80 00 00 	movabs $0x804776,%rdi
  8028e3:	00 00 00 
  8028e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028eb:	48 ba d3 03 80 00 00 	movabs $0x8003d3,%rdx
  8028f2:	00 00 00 
  8028f5:	ff d2                	callq  *%rdx
		return fd_src;
  8028f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fa:	e9 74 01 00 00       	jmpq   802a73 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8028ff:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802906:	be 01 01 00 00       	mov    $0x101,%esi
  80290b:	48 89 c7             	mov    %rax,%rdi
  80290e:	48 b8 12 25 80 00 00 	movabs $0x802512,%rax
  802915:	00 00 00 
  802918:	ff d0                	callq  *%rax
  80291a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80291d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802921:	79 39                	jns    80295c <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802923:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802926:	89 c6                	mov    %eax,%esi
  802928:	48 bf 8c 47 80 00 00 	movabs $0x80478c,%rdi
  80292f:	00 00 00 
  802932:	b8 00 00 00 00       	mov    $0x0,%eax
  802937:	48 ba d3 03 80 00 00 	movabs $0x8003d3,%rdx
  80293e:	00 00 00 
  802941:	ff d2                	callq  *%rdx
		close(fd_src);
  802943:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802946:	89 c7                	mov    %eax,%edi
  802948:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  80294f:	00 00 00 
  802952:	ff d0                	callq  *%rax
		return fd_dest;
  802954:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802957:	e9 17 01 00 00       	jmpq   802a73 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80295c:	eb 74                	jmp    8029d2 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80295e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802961:	48 63 d0             	movslq %eax,%rdx
  802964:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80296b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80296e:	48 89 ce             	mov    %rcx,%rsi
  802971:	89 c7                	mov    %eax,%edi
  802973:	48 b8 86 21 80 00 00 	movabs $0x802186,%rax
  80297a:	00 00 00 
  80297d:	ff d0                	callq  *%rax
  80297f:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802982:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802986:	79 4a                	jns    8029d2 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802988:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80298b:	89 c6                	mov    %eax,%esi
  80298d:	48 bf a6 47 80 00 00 	movabs $0x8047a6,%rdi
  802994:	00 00 00 
  802997:	b8 00 00 00 00       	mov    $0x0,%eax
  80299c:	48 ba d3 03 80 00 00 	movabs $0x8003d3,%rdx
  8029a3:	00 00 00 
  8029a6:	ff d2                	callq  *%rdx
			close(fd_src);
  8029a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ab:	89 c7                	mov    %eax,%edi
  8029ad:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  8029b4:	00 00 00 
  8029b7:	ff d0                	callq  *%rax
			close(fd_dest);
  8029b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029bc:	89 c7                	mov    %eax,%edi
  8029be:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  8029c5:	00 00 00 
  8029c8:	ff d0                	callq  *%rax
			return write_size;
  8029ca:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029cd:	e9 a1 00 00 00       	jmpq   802a73 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8029d2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8029d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029dc:	ba 00 02 00 00       	mov    $0x200,%edx
  8029e1:	48 89 ce             	mov    %rcx,%rsi
  8029e4:	89 c7                	mov    %eax,%edi
  8029e6:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  8029ed:	00 00 00 
  8029f0:	ff d0                	callq  *%rax
  8029f2:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8029f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8029f9:	0f 8f 5f ff ff ff    	jg     80295e <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8029ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802a03:	79 47                	jns    802a4c <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802a05:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a08:	89 c6                	mov    %eax,%esi
  802a0a:	48 bf b9 47 80 00 00 	movabs $0x8047b9,%rdi
  802a11:	00 00 00 
  802a14:	b8 00 00 00 00       	mov    $0x0,%eax
  802a19:	48 ba d3 03 80 00 00 	movabs $0x8003d3,%rdx
  802a20:	00 00 00 
  802a23:	ff d2                	callq  *%rdx
		close(fd_src);
  802a25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a28:	89 c7                	mov    %eax,%edi
  802a2a:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  802a31:	00 00 00 
  802a34:	ff d0                	callq  *%rax
		close(fd_dest);
  802a36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a39:	89 c7                	mov    %eax,%edi
  802a3b:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  802a42:	00 00 00 
  802a45:	ff d0                	callq  *%rax
		return read_size;
  802a47:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802a4a:	eb 27                	jmp    802a73 <copy+0x1d9>
	}
	close(fd_src);
  802a4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4f:	89 c7                	mov    %eax,%edi
  802a51:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  802a58:	00 00 00 
  802a5b:	ff d0                	callq  *%rax
	close(fd_dest);
  802a5d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a60:	89 c7                	mov    %eax,%edi
  802a62:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  802a69:	00 00 00 
  802a6c:	ff d0                	callq  *%rax
	return 0;
  802a6e:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802a73:	c9                   	leaveq 
  802a74:	c3                   	retq   

0000000000802a75 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802a75:	55                   	push   %rbp
  802a76:	48 89 e5             	mov    %rsp,%rbp
  802a79:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  802a80:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  802a87:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802a8e:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  802a95:	be 00 00 00 00       	mov    $0x0,%esi
  802a9a:	48 89 c7             	mov    %rax,%rdi
  802a9d:	48 b8 12 25 80 00 00 	movabs $0x802512,%rax
  802aa4:	00 00 00 
  802aa7:	ff d0                	callq  *%rax
  802aa9:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802aac:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802ab0:	79 08                	jns    802aba <spawn+0x45>
		return r;
  802ab2:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ab5:	e9 14 03 00 00       	jmpq   802dce <spawn+0x359>
	fd = r;
  802aba:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802abd:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  802ac0:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  802ac7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802acb:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  802ad2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802ad5:	ba 00 02 00 00       	mov    $0x200,%edx
  802ada:	48 89 ce             	mov    %rcx,%rsi
  802add:	89 c7                	mov    %eax,%edi
  802adf:	48 b8 11 21 80 00 00 	movabs $0x802111,%rax
  802ae6:	00 00 00 
  802ae9:	ff d0                	callq  *%rax
  802aeb:	3d 00 02 00 00       	cmp    $0x200,%eax
  802af0:	75 0d                	jne    802aff <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  802af2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802af6:	8b 00                	mov    (%rax),%eax
  802af8:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  802afd:	74 43                	je     802b42 <spawn+0xcd>
		close(fd);
  802aff:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802b02:	89 c7                	mov    %eax,%edi
  802b04:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  802b0b:	00 00 00 
  802b0e:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b14:	8b 00                	mov    (%rax),%eax
  802b16:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  802b1b:	89 c6                	mov    %eax,%esi
  802b1d:	48 bf d0 47 80 00 00 	movabs $0x8047d0,%rdi
  802b24:	00 00 00 
  802b27:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2c:	48 b9 d3 03 80 00 00 	movabs $0x8003d3,%rcx
  802b33:	00 00 00 
  802b36:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  802b38:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802b3d:	e9 8c 02 00 00       	jmpq   802dce <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802b42:	b8 07 00 00 00       	mov    $0x7,%eax
  802b47:	cd 30                	int    $0x30
  802b49:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802b4c:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802b4f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802b52:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802b56:	79 08                	jns    802b60 <spawn+0xeb>
		return r;
  802b58:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b5b:	e9 6e 02 00 00       	jmpq   802dce <spawn+0x359>
	child = r;
  802b60:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b63:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802b66:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802b69:	25 ff 03 00 00       	and    $0x3ff,%eax
  802b6e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  802b75:	00 00 00 
  802b78:	48 63 d0             	movslq %eax,%rdx
  802b7b:	48 89 d0             	mov    %rdx,%rax
  802b7e:	48 c1 e0 03          	shl    $0x3,%rax
  802b82:	48 01 d0             	add    %rdx,%rax
  802b85:	48 c1 e0 05          	shl    $0x5,%rax
  802b89:	48 01 c8             	add    %rcx,%rax
  802b8c:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802b93:	48 89 c6             	mov    %rax,%rsi
  802b96:	b8 18 00 00 00       	mov    $0x18,%eax
  802b9b:	48 89 d7             	mov    %rdx,%rdi
  802b9e:	48 89 c1             	mov    %rax,%rcx
  802ba1:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  802ba4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ba8:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bac:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  802bb3:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  802bba:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  802bc1:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  802bc8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802bcb:	48 89 ce             	mov    %rcx,%rsi
  802bce:	89 c7                	mov    %eax,%edi
  802bd0:	48 b8 38 30 80 00 00 	movabs $0x803038,%rax
  802bd7:	00 00 00 
  802bda:	ff d0                	callq  *%rax
  802bdc:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802bdf:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802be3:	79 08                	jns    802bed <spawn+0x178>
		return r;
  802be5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802be8:	e9 e1 01 00 00       	jmpq   802dce <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802bed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bf1:	48 8b 40 20          	mov    0x20(%rax),%rax
  802bf5:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  802bfc:	48 01 d0             	add    %rdx,%rax
  802bff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802c03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c0a:	e9 a3 00 00 00       	jmpq   802cb2 <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  802c0f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c13:	8b 00                	mov    (%rax),%eax
  802c15:	83 f8 01             	cmp    $0x1,%eax
  802c18:	74 05                	je     802c1f <spawn+0x1aa>
			continue;
  802c1a:	e9 8a 00 00 00       	jmpq   802ca9 <spawn+0x234>
		perm = PTE_P | PTE_U;
  802c1f:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802c26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c2a:	8b 40 04             	mov    0x4(%rax),%eax
  802c2d:	83 e0 02             	and    $0x2,%eax
  802c30:	85 c0                	test   %eax,%eax
  802c32:	74 04                	je     802c38 <spawn+0x1c3>
			perm |= PTE_W;
  802c34:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  802c38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c3c:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802c40:	41 89 c1             	mov    %eax,%r9d
  802c43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c47:	4c 8b 40 20          	mov    0x20(%rax),%r8
  802c4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c4f:	48 8b 50 28          	mov    0x28(%rax),%rdx
  802c53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c57:	48 8b 70 10          	mov    0x10(%rax),%rsi
  802c5b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802c5e:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802c61:	8b 7d ec             	mov    -0x14(%rbp),%edi
  802c64:	89 3c 24             	mov    %edi,(%rsp)
  802c67:	89 c7                	mov    %eax,%edi
  802c69:	48 b8 e1 32 80 00 00 	movabs $0x8032e1,%rax
  802c70:	00 00 00 
  802c73:	ff d0                	callq  *%rax
  802c75:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802c78:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802c7c:	79 2b                	jns    802ca9 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  802c7e:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802c7f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802c82:	89 c7                	mov    %eax,%edi
  802c84:	48 b8 f7 17 80 00 00 	movabs $0x8017f7,%rax
  802c8b:	00 00 00 
  802c8e:	ff d0                	callq  *%rax
	close(fd);
  802c90:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c93:	89 c7                	mov    %eax,%edi
  802c95:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  802c9c:	00 00 00 
  802c9f:	ff d0                	callq  *%rax
	return r;
  802ca1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802ca4:	e9 25 01 00 00       	jmpq   802dce <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ca9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802cad:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  802cb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cb6:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  802cba:	0f b7 c0             	movzwl %ax,%eax
  802cbd:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802cc0:	0f 8f 49 ff ff ff    	jg     802c0f <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802cc6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802cc9:	89 c7                	mov    %eax,%edi
  802ccb:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  802cd2:	00 00 00 
  802cd5:	ff d0                	callq  *%rax
	fd = -1;
  802cd7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802cde:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802ce1:	89 c7                	mov    %eax,%edi
  802ce3:	48 b8 cd 34 80 00 00 	movabs $0x8034cd,%rax
  802cea:	00 00 00 
  802ced:	ff d0                	callq  *%rax
  802cef:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802cf2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802cf6:	79 30                	jns    802d28 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  802cf8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802cfb:	89 c1                	mov    %eax,%ecx
  802cfd:	48 ba ea 47 80 00 00 	movabs $0x8047ea,%rdx
  802d04:	00 00 00 
  802d07:	be 82 00 00 00       	mov    $0x82,%esi
  802d0c:	48 bf 00 48 80 00 00 	movabs $0x804800,%rdi
  802d13:	00 00 00 
  802d16:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1b:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  802d22:	00 00 00 
  802d25:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802d28:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  802d2f:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d32:	48 89 d6             	mov    %rdx,%rsi
  802d35:	89 c7                	mov    %eax,%edi
  802d37:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  802d3e:	00 00 00 
  802d41:	ff d0                	callq  *%rax
  802d43:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d46:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d4a:	79 30                	jns    802d7c <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  802d4c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d4f:	89 c1                	mov    %eax,%ecx
  802d51:	48 ba 0c 48 80 00 00 	movabs $0x80480c,%rdx
  802d58:	00 00 00 
  802d5b:	be 85 00 00 00       	mov    $0x85,%esi
  802d60:	48 bf 00 48 80 00 00 	movabs $0x804800,%rdi
  802d67:	00 00 00 
  802d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6f:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  802d76:	00 00 00 
  802d79:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802d7c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  802d7f:	be 02 00 00 00       	mov    $0x2,%esi
  802d84:	89 c7                	mov    %eax,%edi
  802d86:	48 b8 ac 19 80 00 00 	movabs $0x8019ac,%rax
  802d8d:	00 00 00 
  802d90:	ff d0                	callq  *%rax
  802d92:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802d95:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  802d99:	79 30                	jns    802dcb <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  802d9b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802d9e:	89 c1                	mov    %eax,%ecx
  802da0:	48 ba 26 48 80 00 00 	movabs $0x804826,%rdx
  802da7:	00 00 00 
  802daa:	be 88 00 00 00       	mov    $0x88,%esi
  802daf:	48 bf 00 48 80 00 00 	movabs $0x804800,%rdi
  802db6:	00 00 00 
  802db9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbe:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  802dc5:	00 00 00 
  802dc8:	41 ff d0             	callq  *%r8

	return child;
  802dcb:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802dce:	c9                   	leaveq 
  802dcf:	c3                   	retq   

0000000000802dd0 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802dd0:	55                   	push   %rbp
  802dd1:	48 89 e5             	mov    %rsp,%rbp
  802dd4:	41 55                	push   %r13
  802dd6:	41 54                	push   %r12
  802dd8:	53                   	push   %rbx
  802dd9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  802de0:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  802de7:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  802dee:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  802df5:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  802dfc:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  802e03:	84 c0                	test   %al,%al
  802e05:	74 26                	je     802e2d <spawnl+0x5d>
  802e07:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  802e0e:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  802e15:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  802e19:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  802e1d:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  802e21:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  802e25:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  802e29:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  802e2d:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802e34:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  802e3b:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  802e3e:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802e45:	00 00 00 
  802e48:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802e4f:	00 00 00 
  802e52:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e56:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802e5d:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802e64:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  802e6b:	eb 07                	jmp    802e74 <spawnl+0xa4>
		argc++;
  802e6d:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802e74:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802e7a:	83 f8 30             	cmp    $0x30,%eax
  802e7d:	73 23                	jae    802ea2 <spawnl+0xd2>
  802e7f:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  802e86:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802e8c:	89 c0                	mov    %eax,%eax
  802e8e:	48 01 d0             	add    %rdx,%rax
  802e91:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802e97:	83 c2 08             	add    $0x8,%edx
  802e9a:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  802ea0:	eb 15                	jmp    802eb7 <spawnl+0xe7>
  802ea2:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  802ea9:	48 89 d0             	mov    %rdx,%rax
  802eac:	48 83 c2 08          	add    $0x8,%rdx
  802eb0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  802eb7:	48 8b 00             	mov    (%rax),%rax
  802eba:	48 85 c0             	test   %rax,%rax
  802ebd:	75 ae                	jne    802e6d <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802ebf:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802ec5:	83 c0 02             	add    $0x2,%eax
  802ec8:	48 89 e2             	mov    %rsp,%rdx
  802ecb:	48 89 d3             	mov    %rdx,%rbx
  802ece:	48 63 d0             	movslq %eax,%rdx
  802ed1:	48 83 ea 01          	sub    $0x1,%rdx
  802ed5:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  802edc:	48 63 d0             	movslq %eax,%rdx
  802edf:	49 89 d4             	mov    %rdx,%r12
  802ee2:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  802ee8:	48 63 d0             	movslq %eax,%rdx
  802eeb:	49 89 d2             	mov    %rdx,%r10
  802eee:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  802ef4:	48 98                	cltq   
  802ef6:	48 c1 e0 03          	shl    $0x3,%rax
  802efa:	48 8d 50 07          	lea    0x7(%rax),%rdx
  802efe:	b8 10 00 00 00       	mov    $0x10,%eax
  802f03:	48 83 e8 01          	sub    $0x1,%rax
  802f07:	48 01 d0             	add    %rdx,%rax
  802f0a:	bf 10 00 00 00       	mov    $0x10,%edi
  802f0f:	ba 00 00 00 00       	mov    $0x0,%edx
  802f14:	48 f7 f7             	div    %rdi
  802f17:	48 6b c0 10          	imul   $0x10,%rax,%rax
  802f1b:	48 29 c4             	sub    %rax,%rsp
  802f1e:	48 89 e0             	mov    %rsp,%rax
  802f21:	48 83 c0 07          	add    $0x7,%rax
  802f25:	48 c1 e8 03          	shr    $0x3,%rax
  802f29:	48 c1 e0 03          	shl    $0x3,%rax
  802f2d:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  802f34:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802f3b:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  802f42:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  802f45:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802f4b:	8d 50 01             	lea    0x1(%rax),%edx
  802f4e:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802f55:	48 63 d2             	movslq %edx,%rdx
  802f58:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  802f5f:	00 

	va_start(vl, arg0);
  802f60:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  802f67:	00 00 00 
  802f6a:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  802f71:	00 00 00 
  802f74:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802f78:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  802f7f:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  802f86:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  802f8d:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  802f94:	00 00 00 
  802f97:	eb 63                	jmp    802ffc <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  802f99:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  802f9f:	8d 70 01             	lea    0x1(%rax),%esi
  802fa2:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802fa8:	83 f8 30             	cmp    $0x30,%eax
  802fab:	73 23                	jae    802fd0 <spawnl+0x200>
  802fad:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  802fb4:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  802fba:	89 c0                	mov    %eax,%eax
  802fbc:	48 01 d0             	add    %rdx,%rax
  802fbf:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  802fc5:	83 c2 08             	add    $0x8,%edx
  802fc8:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  802fce:	eb 15                	jmp    802fe5 <spawnl+0x215>
  802fd0:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  802fd7:	48 89 d0             	mov    %rdx,%rax
  802fda:	48 83 c2 08          	add    $0x8,%rdx
  802fde:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  802fe5:	48 8b 08             	mov    (%rax),%rcx
  802fe8:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  802fef:	89 f2                	mov    %esi,%edx
  802ff1:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802ff5:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  802ffc:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803002:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803008:	77 8f                	ja     802f99 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  80300a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803011:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803018:	48 89 d6             	mov    %rdx,%rsi
  80301b:	48 89 c7             	mov    %rax,%rdi
  80301e:	48 b8 75 2a 80 00 00 	movabs $0x802a75,%rax
  803025:	00 00 00 
  803028:	ff d0                	callq  *%rax
  80302a:	48 89 dc             	mov    %rbx,%rsp
}
  80302d:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  803031:	5b                   	pop    %rbx
  803032:	41 5c                	pop    %r12
  803034:	41 5d                	pop    %r13
  803036:	5d                   	pop    %rbp
  803037:	c3                   	retq   

0000000000803038 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803038:	55                   	push   %rbp
  803039:	48 89 e5             	mov    %rsp,%rbp
  80303c:	48 83 ec 50          	sub    $0x50,%rsp
  803040:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803043:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803047:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80304b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803052:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  803053:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  80305a:	eb 33                	jmp    80308f <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80305c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80305f:	48 98                	cltq   
  803061:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803068:	00 
  803069:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80306d:	48 01 d0             	add    %rdx,%rax
  803070:	48 8b 00             	mov    (%rax),%rax
  803073:	48 89 c7             	mov    %rax,%rdi
  803076:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  80307d:	00 00 00 
  803080:	ff d0                	callq  *%rax
  803082:	83 c0 01             	add    $0x1,%eax
  803085:	48 98                	cltq   
  803087:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80308b:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80308f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803092:	48 98                	cltq   
  803094:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80309b:	00 
  80309c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8030a0:	48 01 d0             	add    %rdx,%rax
  8030a3:	48 8b 00             	mov    (%rax),%rax
  8030a6:	48 85 c0             	test   %rax,%rax
  8030a9:	75 b1                	jne    80305c <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8030ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030af:	48 f7 d8             	neg    %rax
  8030b2:	48 05 00 10 40 00    	add    $0x401000,%rax
  8030b8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8030bc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030c0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8030c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030c8:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8030cc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8030cf:	83 c2 01             	add    $0x1,%edx
  8030d2:	c1 e2 03             	shl    $0x3,%edx
  8030d5:	48 63 d2             	movslq %edx,%rdx
  8030d8:	48 f7 da             	neg    %rdx
  8030db:	48 01 d0             	add    %rdx,%rax
  8030de:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8030e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030e6:	48 83 e8 10          	sub    $0x10,%rax
  8030ea:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8030f0:	77 0a                	ja     8030fc <init_stack+0xc4>
		return -E_NO_MEM;
  8030f2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8030f7:	e9 e3 01 00 00       	jmpq   8032df <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8030fc:	ba 07 00 00 00       	mov    $0x7,%edx
  803101:	be 00 00 40 00       	mov    $0x400000,%esi
  803106:	bf 00 00 00 00       	mov    $0x0,%edi
  80310b:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  803112:	00 00 00 
  803115:	ff d0                	callq  *%rax
  803117:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80311a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80311e:	79 08                	jns    803128 <init_stack+0xf0>
		return r;
  803120:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803123:	e9 b7 01 00 00       	jmpq   8032df <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803128:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80312f:	e9 8a 00 00 00       	jmpq   8031be <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803134:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803137:	48 98                	cltq   
  803139:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803140:	00 
  803141:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803145:	48 01 c2             	add    %rax,%rdx
  803148:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80314d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803151:	48 01 c8             	add    %rcx,%rax
  803154:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80315a:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  80315d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803160:	48 98                	cltq   
  803162:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803169:	00 
  80316a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80316e:	48 01 d0             	add    %rdx,%rax
  803171:	48 8b 10             	mov    (%rax),%rdx
  803174:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803178:	48 89 d6             	mov    %rdx,%rsi
  80317b:	48 89 c7             	mov    %rax,%rdi
  80317e:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  803185:	00 00 00 
  803188:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  80318a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80318d:	48 98                	cltq   
  80318f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803196:	00 
  803197:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80319b:	48 01 d0             	add    %rdx,%rax
  80319e:	48 8b 00             	mov    (%rax),%rax
  8031a1:	48 89 c7             	mov    %rax,%rdi
  8031a4:	48 b8 1c 0f 80 00 00 	movabs $0x800f1c,%rax
  8031ab:	00 00 00 
  8031ae:	ff d0                	callq  *%rax
  8031b0:	48 98                	cltq   
  8031b2:	48 83 c0 01          	add    $0x1,%rax
  8031b6:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8031ba:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8031be:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8031c1:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8031c4:	0f 8c 6a ff ff ff    	jl     803134 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8031ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8031cd:	48 98                	cltq   
  8031cf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8031d6:	00 
  8031d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8031db:	48 01 d0             	add    %rdx,%rax
  8031de:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8031e5:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8031ec:	00 
  8031ed:	74 35                	je     803224 <init_stack+0x1ec>
  8031ef:	48 b9 40 48 80 00 00 	movabs $0x804840,%rcx
  8031f6:	00 00 00 
  8031f9:	48 ba 66 48 80 00 00 	movabs $0x804866,%rdx
  803200:	00 00 00 
  803203:	be f1 00 00 00       	mov    $0xf1,%esi
  803208:	48 bf 00 48 80 00 00 	movabs $0x804800,%rdi
  80320f:	00 00 00 
  803212:	b8 00 00 00 00       	mov    $0x0,%eax
  803217:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  80321e:	00 00 00 
  803221:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803224:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803228:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  80322c:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803231:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803235:	48 01 c8             	add    %rcx,%rax
  803238:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80323e:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  803241:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803245:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803249:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80324c:	48 98                	cltq   
  80324e:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  803251:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803256:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80325a:	48 01 d0             	add    %rdx,%rax
  80325d:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803263:	48 89 c2             	mov    %rax,%rdx
  803266:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80326a:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80326d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803270:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803276:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80327b:	89 c2                	mov    %eax,%edx
  80327d:	be 00 00 40 00       	mov    $0x400000,%esi
  803282:	bf 00 00 00 00       	mov    $0x0,%edi
  803287:	48 b8 07 19 80 00 00 	movabs $0x801907,%rax
  80328e:	00 00 00 
  803291:	ff d0                	callq  *%rax
  803293:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803296:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80329a:	79 02                	jns    80329e <init_stack+0x266>
		goto error;
  80329c:	eb 28                	jmp    8032c6 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80329e:	be 00 00 40 00       	mov    $0x400000,%esi
  8032a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8032a8:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  8032af:	00 00 00 
  8032b2:	ff d0                	callq  *%rax
  8032b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032bb:	79 02                	jns    8032bf <init_stack+0x287>
		goto error;
  8032bd:	eb 07                	jmp    8032c6 <init_stack+0x28e>

	return 0;
  8032bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c4:	eb 19                	jmp    8032df <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8032c6:	be 00 00 40 00       	mov    $0x400000,%esi
  8032cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d0:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  8032d7:	00 00 00 
  8032da:	ff d0                	callq  *%rax
	return r;
  8032dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8032df:	c9                   	leaveq 
  8032e0:	c3                   	retq   

00000000008032e1 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8032e1:	55                   	push   %rbp
  8032e2:	48 89 e5             	mov    %rsp,%rbp
  8032e5:	48 83 ec 50          	sub    $0x50,%rsp
  8032e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8032ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8032f0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  8032f4:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  8032f7:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8032fb:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8032ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803303:	25 ff 0f 00 00       	and    $0xfff,%eax
  803308:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80330f:	74 21                	je     803332 <map_segment+0x51>
		va -= i;
  803311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803314:	48 98                	cltq   
  803316:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80331a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331d:	48 98                	cltq   
  80331f:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803323:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803326:	48 98                	cltq   
  803328:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80332c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80332f:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803332:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803339:	e9 79 01 00 00       	jmpq   8034b7 <map_segment+0x1d6>
		if (i >= filesz) {
  80333e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803341:	48 98                	cltq   
  803343:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803347:	72 3c                	jb     803385 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803349:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334c:	48 63 d0             	movslq %eax,%rdx
  80334f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803353:	48 01 d0             	add    %rdx,%rax
  803356:	48 89 c1             	mov    %rax,%rcx
  803359:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80335c:	8b 55 10             	mov    0x10(%rbp),%edx
  80335f:	48 89 ce             	mov    %rcx,%rsi
  803362:	89 c7                	mov    %eax,%edi
  803364:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  80336b:	00 00 00 
  80336e:	ff d0                	callq  *%rax
  803370:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803373:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803377:	0f 89 33 01 00 00    	jns    8034b0 <map_segment+0x1cf>
				return r;
  80337d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803380:	e9 46 01 00 00       	jmpq   8034cb <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803385:	ba 07 00 00 00       	mov    $0x7,%edx
  80338a:	be 00 00 40 00       	mov    $0x400000,%esi
  80338f:	bf 00 00 00 00       	mov    $0x0,%edi
  803394:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  80339b:	00 00 00 
  80339e:	ff d0                	callq  *%rax
  8033a0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8033a3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033a7:	79 08                	jns    8033b1 <map_segment+0xd0>
				return r;
  8033a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033ac:	e9 1a 01 00 00       	jmpq   8034cb <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8033b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b4:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8033b7:	01 c2                	add    %eax,%edx
  8033b9:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8033bc:	89 d6                	mov    %edx,%esi
  8033be:	89 c7                	mov    %eax,%edi
  8033c0:	48 b8 5a 22 80 00 00 	movabs $0x80225a,%rax
  8033c7:	00 00 00 
  8033ca:	ff d0                	callq  *%rax
  8033cc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8033cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8033d3:	79 08                	jns    8033dd <map_segment+0xfc>
				return r;
  8033d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033d8:	e9 ee 00 00 00       	jmpq   8034cb <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8033dd:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  8033e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e7:	48 98                	cltq   
  8033e9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8033ed:	48 29 c2             	sub    %rax,%rdx
  8033f0:	48 89 d0             	mov    %rdx,%rax
  8033f3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8033f7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033fa:	48 63 d0             	movslq %eax,%rdx
  8033fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803401:	48 39 c2             	cmp    %rax,%rdx
  803404:	48 0f 47 d0          	cmova  %rax,%rdx
  803408:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80340b:	be 00 00 40 00       	mov    $0x400000,%esi
  803410:	89 c7                	mov    %eax,%edi
  803412:	48 b8 11 21 80 00 00 	movabs $0x802111,%rax
  803419:	00 00 00 
  80341c:	ff d0                	callq  *%rax
  80341e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803421:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803425:	79 08                	jns    80342f <map_segment+0x14e>
				return r;
  803427:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80342a:	e9 9c 00 00 00       	jmpq   8034cb <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80342f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803432:	48 63 d0             	movslq %eax,%rdx
  803435:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803439:	48 01 d0             	add    %rdx,%rax
  80343c:	48 89 c2             	mov    %rax,%rdx
  80343f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803442:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803446:	48 89 d1             	mov    %rdx,%rcx
  803449:	89 c2                	mov    %eax,%edx
  80344b:	be 00 00 40 00       	mov    $0x400000,%esi
  803450:	bf 00 00 00 00       	mov    $0x0,%edi
  803455:	48 b8 07 19 80 00 00 	movabs $0x801907,%rax
  80345c:	00 00 00 
  80345f:	ff d0                	callq  *%rax
  803461:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803464:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803468:	79 30                	jns    80349a <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  80346a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80346d:	89 c1                	mov    %eax,%ecx
  80346f:	48 ba 7b 48 80 00 00 	movabs $0x80487b,%rdx
  803476:	00 00 00 
  803479:	be 24 01 00 00       	mov    $0x124,%esi
  80347e:	48 bf 00 48 80 00 00 	movabs $0x804800,%rdi
  803485:	00 00 00 
  803488:	b8 00 00 00 00       	mov    $0x0,%eax
  80348d:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  803494:	00 00 00 
  803497:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  80349a:	be 00 00 40 00       	mov    $0x400000,%esi
  80349f:	bf 00 00 00 00       	mov    $0x0,%edi
  8034a4:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  8034ab:	00 00 00 
  8034ae:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8034b0:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8034b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ba:	48 98                	cltq   
  8034bc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8034c0:	0f 82 78 fe ff ff    	jb     80333e <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8034c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034cb:	c9                   	leaveq 
  8034cc:	c3                   	retq   

00000000008034cd <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8034cd:	55                   	push   %rbp
  8034ce:	48 89 e5             	mov    %rsp,%rbp
  8034d1:	48 83 ec 70          	sub    $0x70,%rsp
  8034d5:	89 7d 9c             	mov    %edi,-0x64(%rbp)
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  8034d8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8034df:	00 
  8034e0:	e9 70 01 00 00       	jmpq   803655 <copy_shared_pages+0x188>
		if(uvpml4e[pml4e] & PTE_P){
  8034e5:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  8034ec:	01 00 00 
  8034ef:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8034f3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034f7:	83 e0 01             	and    $0x1,%eax
  8034fa:	48 85 c0             	test   %rax,%rax
  8034fd:	0f 84 4d 01 00 00    	je     803650 <copy_shared_pages+0x183>
			base_pml4e = pml4e * NPDPENTRIES;
  803503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803507:	48 c1 e0 09          	shl    $0x9,%rax
  80350b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  80350f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803516:	00 
  803517:	e9 26 01 00 00       	jmpq   803642 <copy_shared_pages+0x175>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  80351c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803520:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803524:	48 01 c2             	add    %rax,%rdx
  803527:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80352e:	01 00 00 
  803531:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803535:	83 e0 01             	and    $0x1,%eax
  803538:	48 85 c0             	test   %rax,%rax
  80353b:	0f 84 fc 00 00 00    	je     80363d <copy_shared_pages+0x170>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  803541:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803545:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803549:	48 01 d0             	add    %rdx,%rax
  80354c:	48 c1 e0 09          	shl    $0x9,%rax
  803550:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  803554:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  80355b:	00 
  80355c:	e9 ce 00 00 00       	jmpq   80362f <copy_shared_pages+0x162>
						if(uvpd[base_pdpe + pde] & PTE_P){
  803561:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803565:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803569:	48 01 c2             	add    %rax,%rdx
  80356c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803573:	01 00 00 
  803576:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80357a:	83 e0 01             	and    $0x1,%eax
  80357d:	48 85 c0             	test   %rax,%rax
  803580:	0f 84 a4 00 00 00    	je     80362a <copy_shared_pages+0x15d>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  803586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80358e:	48 01 d0             	add    %rdx,%rax
  803591:	48 c1 e0 09          	shl    $0x9,%rax
  803595:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  803599:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  8035a0:	00 
  8035a1:	eb 79                	jmp    80361c <copy_shared_pages+0x14f>
								entry = base_pde + pte;
  8035a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8035ab:	48 01 d0             	add    %rdx,%rax
  8035ae:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
								perm = uvpt[entry] & PTE_SYSCALL;
  8035b2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8035b9:	01 00 00 
  8035bc:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8035c0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8035c4:	25 07 0e 00 00       	and    $0xe07,%eax
  8035c9:	89 45 bc             	mov    %eax,-0x44(%rbp)
								if(perm & PTE_SHARE){
  8035cc:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8035cf:	25 00 04 00 00       	and    $0x400,%eax
  8035d4:	85 c0                	test   %eax,%eax
  8035d6:	74 3f                	je     803617 <copy_shared_pages+0x14a>
									va = (void*)(PGSIZE * entry);
  8035d8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8035dc:	48 c1 e0 0c          	shl    $0xc,%rax
  8035e0:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
									r = sys_page_map(0, va, child, va, perm);		
  8035e4:	8b 75 bc             	mov    -0x44(%rbp),%esi
  8035e7:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  8035eb:	8b 55 9c             	mov    -0x64(%rbp),%edx
  8035ee:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8035f2:	41 89 f0             	mov    %esi,%r8d
  8035f5:	48 89 c6             	mov    %rax,%rsi
  8035f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8035fd:	48 b8 07 19 80 00 00 	movabs $0x801907,%rax
  803604:	00 00 00 
  803607:	ff d0                	callq  *%rax
  803609:	89 45 ac             	mov    %eax,-0x54(%rbp)
									if(r < 0) return r;
  80360c:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  803610:	79 05                	jns    803617 <copy_shared_pages+0x14a>
  803612:	8b 45 ac             	mov    -0x54(%rbp),%eax
  803615:	eb 4e                	jmp    803665 <copy_shared_pages+0x198>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  803617:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  80361c:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  803623:	00 
  803624:	0f 86 79 ff ff ff    	jbe    8035a3 <copy_shared_pages+0xd6>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  80362a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80362f:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  803636:	00 
  803637:	0f 86 24 ff ff ff    	jbe    803561 <copy_shared_pages+0x94>
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  80363d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  803642:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  803649:	00 
  80364a:	0f 86 cc fe ff ff    	jbe    80351c <copy_shared_pages+0x4f>
{
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  803650:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803655:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80365a:	0f 84 85 fe ff ff    	je     8034e5 <copy_shared_pages+0x18>
					}
				}
			}
		}
	}
	return 0;
  803660:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803665:	c9                   	leaveq 
  803666:	c3                   	retq   

0000000000803667 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803667:	55                   	push   %rbp
  803668:	48 89 e5             	mov    %rsp,%rbp
  80366b:	53                   	push   %rbx
  80366c:	48 83 ec 38          	sub    $0x38,%rsp
  803670:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803674:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803678:	48 89 c7             	mov    %rax,%rdi
  80367b:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  803682:	00 00 00 
  803685:	ff d0                	callq  *%rax
  803687:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80368a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80368e:	0f 88 bf 01 00 00    	js     803853 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803694:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803698:	ba 07 04 00 00       	mov    $0x407,%edx
  80369d:	48 89 c6             	mov    %rax,%rsi
  8036a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8036a5:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  8036ac:	00 00 00 
  8036af:	ff d0                	callq  *%rax
  8036b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036b8:	0f 88 95 01 00 00    	js     803853 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8036be:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8036c2:	48 89 c7             	mov    %rax,%rdi
  8036c5:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  8036cc:	00 00 00 
  8036cf:	ff d0                	callq  *%rax
  8036d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036d8:	0f 88 5d 01 00 00    	js     80383b <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036e2:	ba 07 04 00 00       	mov    $0x407,%edx
  8036e7:	48 89 c6             	mov    %rax,%rsi
  8036ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8036ef:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  8036f6:	00 00 00 
  8036f9:	ff d0                	callq  *%rax
  8036fb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803702:	0f 88 33 01 00 00    	js     80383b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803708:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80370c:	48 89 c7             	mov    %rax,%rdi
  80370f:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  803716:	00 00 00 
  803719:	ff d0                	callq  *%rax
  80371b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80371f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803723:	ba 07 04 00 00       	mov    $0x407,%edx
  803728:	48 89 c6             	mov    %rax,%rsi
  80372b:	bf 00 00 00 00       	mov    $0x0,%edi
  803730:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  803737:	00 00 00 
  80373a:	ff d0                	callq  *%rax
  80373c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80373f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803743:	79 05                	jns    80374a <pipe+0xe3>
		goto err2;
  803745:	e9 d9 00 00 00       	jmpq   803823 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80374a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80374e:	48 89 c7             	mov    %rax,%rdi
  803751:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  803758:	00 00 00 
  80375b:	ff d0                	callq  *%rax
  80375d:	48 89 c2             	mov    %rax,%rdx
  803760:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803764:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80376a:	48 89 d1             	mov    %rdx,%rcx
  80376d:	ba 00 00 00 00       	mov    $0x0,%edx
  803772:	48 89 c6             	mov    %rax,%rsi
  803775:	bf 00 00 00 00       	mov    $0x0,%edi
  80377a:	48 b8 07 19 80 00 00 	movabs $0x801907,%rax
  803781:	00 00 00 
  803784:	ff d0                	callq  *%rax
  803786:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803789:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80378d:	79 1b                	jns    8037aa <pipe+0x143>
		goto err3;
  80378f:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803790:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803794:	48 89 c6             	mov    %rax,%rsi
  803797:	bf 00 00 00 00       	mov    $0x0,%edi
  80379c:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  8037a3:	00 00 00 
  8037a6:	ff d0                	callq  *%rax
  8037a8:	eb 79                	jmp    803823 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ae:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8037b5:	00 00 00 
  8037b8:	8b 12                	mov    (%rdx),%edx
  8037ba:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8037bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037c0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8037c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037cb:	48 ba 80 60 80 00 00 	movabs $0x806080,%rdx
  8037d2:	00 00 00 
  8037d5:	8b 12                	mov    (%rdx),%edx
  8037d7:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8037d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037dd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8037e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e8:	48 89 c7             	mov    %rax,%rdi
  8037eb:	48 b8 24 1b 80 00 00 	movabs $0x801b24,%rax
  8037f2:	00 00 00 
  8037f5:	ff d0                	callq  *%rax
  8037f7:	89 c2                	mov    %eax,%edx
  8037f9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8037fd:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8037ff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803803:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803807:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80380b:	48 89 c7             	mov    %rax,%rdi
  80380e:	48 b8 24 1b 80 00 00 	movabs $0x801b24,%rax
  803815:	00 00 00 
  803818:	ff d0                	callq  *%rax
  80381a:	89 03                	mov    %eax,(%rbx)
	return 0;
  80381c:	b8 00 00 00 00       	mov    $0x0,%eax
  803821:	eb 33                	jmp    803856 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803823:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803827:	48 89 c6             	mov    %rax,%rsi
  80382a:	bf 00 00 00 00       	mov    $0x0,%edi
  80382f:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80383b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80383f:	48 89 c6             	mov    %rax,%rsi
  803842:	bf 00 00 00 00       	mov    $0x0,%edi
  803847:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  80384e:	00 00 00 
  803851:	ff d0                	callq  *%rax
err:
	return r;
  803853:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803856:	48 83 c4 38          	add    $0x38,%rsp
  80385a:	5b                   	pop    %rbx
  80385b:	5d                   	pop    %rbp
  80385c:	c3                   	retq   

000000000080385d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80385d:	55                   	push   %rbp
  80385e:	48 89 e5             	mov    %rsp,%rbp
  803861:	53                   	push   %rbx
  803862:	48 83 ec 28          	sub    $0x28,%rsp
  803866:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80386a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80386e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803875:	00 00 00 
  803878:	48 8b 00             	mov    (%rax),%rax
  80387b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803881:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803888:	48 89 c7             	mov    %rax,%rdi
  80388b:	48 b8 c8 40 80 00 00 	movabs $0x8040c8,%rax
  803892:	00 00 00 
  803895:	ff d0                	callq  *%rax
  803897:	89 c3                	mov    %eax,%ebx
  803899:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80389d:	48 89 c7             	mov    %rax,%rdi
  8038a0:	48 b8 c8 40 80 00 00 	movabs $0x8040c8,%rax
  8038a7:	00 00 00 
  8038aa:	ff d0                	callq  *%rax
  8038ac:	39 c3                	cmp    %eax,%ebx
  8038ae:	0f 94 c0             	sete   %al
  8038b1:	0f b6 c0             	movzbl %al,%eax
  8038b4:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8038b7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038be:	00 00 00 
  8038c1:	48 8b 00             	mov    (%rax),%rax
  8038c4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8038ca:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8038cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038d0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038d3:	75 05                	jne    8038da <_pipeisclosed+0x7d>
			return ret;
  8038d5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8038d8:	eb 4f                	jmp    803929 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8038da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038dd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8038e0:	74 42                	je     803924 <_pipeisclosed+0xc7>
  8038e2:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8038e6:	75 3c                	jne    803924 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8038e8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8038ef:	00 00 00 
  8038f2:	48 8b 00             	mov    (%rax),%rax
  8038f5:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8038fb:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803901:	89 c6                	mov    %eax,%esi
  803903:	48 bf 9d 48 80 00 00 	movabs $0x80489d,%rdi
  80390a:	00 00 00 
  80390d:	b8 00 00 00 00       	mov    $0x0,%eax
  803912:	49 b8 d3 03 80 00 00 	movabs $0x8003d3,%r8
  803919:	00 00 00 
  80391c:	41 ff d0             	callq  *%r8
	}
  80391f:	e9 4a ff ff ff       	jmpq   80386e <_pipeisclosed+0x11>
  803924:	e9 45 ff ff ff       	jmpq   80386e <_pipeisclosed+0x11>
}
  803929:	48 83 c4 28          	add    $0x28,%rsp
  80392d:	5b                   	pop    %rbx
  80392e:	5d                   	pop    %rbp
  80392f:	c3                   	retq   

0000000000803930 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803930:	55                   	push   %rbp
  803931:	48 89 e5             	mov    %rsp,%rbp
  803934:	48 83 ec 30          	sub    $0x30,%rsp
  803938:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80393b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80393f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803942:	48 89 d6             	mov    %rdx,%rsi
  803945:	89 c7                	mov    %eax,%edi
  803947:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  80394e:	00 00 00 
  803951:	ff d0                	callq  *%rax
  803953:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803956:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80395a:	79 05                	jns    803961 <pipeisclosed+0x31>
		return r;
  80395c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395f:	eb 31                	jmp    803992 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803961:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803965:	48 89 c7             	mov    %rax,%rdi
  803968:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  80396f:	00 00 00 
  803972:	ff d0                	callq  *%rax
  803974:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803978:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80397c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803980:	48 89 d6             	mov    %rdx,%rsi
  803983:	48 89 c7             	mov    %rax,%rdi
  803986:	48 b8 5d 38 80 00 00 	movabs $0x80385d,%rax
  80398d:	00 00 00 
  803990:	ff d0                	callq  *%rax
}
  803992:	c9                   	leaveq 
  803993:	c3                   	retq   

0000000000803994 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803994:	55                   	push   %rbp
  803995:	48 89 e5             	mov    %rsp,%rbp
  803998:	48 83 ec 40          	sub    $0x40,%rsp
  80399c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039a0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ac:	48 89 c7             	mov    %rax,%rdi
  8039af:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  8039b6:	00 00 00 
  8039b9:	ff d0                	callq  *%rax
  8039bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8039c7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8039ce:	00 
  8039cf:	e9 92 00 00 00       	jmpq   803a66 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8039d4:	eb 41                	jmp    803a17 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8039d6:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8039db:	74 09                	je     8039e6 <devpipe_read+0x52>
				return i;
  8039dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e1:	e9 92 00 00 00       	jmpq   803a78 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8039e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039ee:	48 89 d6             	mov    %rdx,%rsi
  8039f1:	48 89 c7             	mov    %rax,%rdi
  8039f4:	48 b8 5d 38 80 00 00 	movabs $0x80385d,%rax
  8039fb:	00 00 00 
  8039fe:	ff d0                	callq  *%rax
  803a00:	85 c0                	test   %eax,%eax
  803a02:	74 07                	je     803a0b <devpipe_read+0x77>
				return 0;
  803a04:	b8 00 00 00 00       	mov    $0x0,%eax
  803a09:	eb 6d                	jmp    803a78 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a0b:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  803a12:	00 00 00 
  803a15:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a1b:	8b 10                	mov    (%rax),%edx
  803a1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a21:	8b 40 04             	mov    0x4(%rax),%eax
  803a24:	39 c2                	cmp    %eax,%edx
  803a26:	74 ae                	je     8039d6 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a2c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a30:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803a34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a38:	8b 00                	mov    (%rax),%eax
  803a3a:	99                   	cltd   
  803a3b:	c1 ea 1b             	shr    $0x1b,%edx
  803a3e:	01 d0                	add    %edx,%eax
  803a40:	83 e0 1f             	and    $0x1f,%eax
  803a43:	29 d0                	sub    %edx,%eax
  803a45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a49:	48 98                	cltq   
  803a4b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803a50:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803a52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a56:	8b 00                	mov    (%rax),%eax
  803a58:	8d 50 01             	lea    0x1(%rax),%edx
  803a5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a5f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a61:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a6a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a6e:	0f 82 60 ff ff ff    	jb     8039d4 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a78:	c9                   	leaveq 
  803a79:	c3                   	retq   

0000000000803a7a <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a7a:	55                   	push   %rbp
  803a7b:	48 89 e5             	mov    %rsp,%rbp
  803a7e:	48 83 ec 40          	sub    $0x40,%rsp
  803a82:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a86:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a8a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a92:	48 89 c7             	mov    %rax,%rdi
  803a95:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  803a9c:	00 00 00 
  803a9f:	ff d0                	callq  *%rax
  803aa1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803aa5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803aa9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803aad:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ab4:	00 
  803ab5:	e9 8e 00 00 00       	jmpq   803b48 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803aba:	eb 31                	jmp    803aed <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803abc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ac0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac4:	48 89 d6             	mov    %rdx,%rsi
  803ac7:	48 89 c7             	mov    %rax,%rdi
  803aca:	48 b8 5d 38 80 00 00 	movabs $0x80385d,%rax
  803ad1:	00 00 00 
  803ad4:	ff d0                	callq  *%rax
  803ad6:	85 c0                	test   %eax,%eax
  803ad8:	74 07                	je     803ae1 <devpipe_write+0x67>
				return 0;
  803ada:	b8 00 00 00 00       	mov    $0x0,%eax
  803adf:	eb 79                	jmp    803b5a <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803ae1:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  803ae8:	00 00 00 
  803aeb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803aed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af1:	8b 40 04             	mov    0x4(%rax),%eax
  803af4:	48 63 d0             	movslq %eax,%rdx
  803af7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803afb:	8b 00                	mov    (%rax),%eax
  803afd:	48 98                	cltq   
  803aff:	48 83 c0 20          	add    $0x20,%rax
  803b03:	48 39 c2             	cmp    %rax,%rdx
  803b06:	73 b4                	jae    803abc <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803b08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0c:	8b 40 04             	mov    0x4(%rax),%eax
  803b0f:	99                   	cltd   
  803b10:	c1 ea 1b             	shr    $0x1b,%edx
  803b13:	01 d0                	add    %edx,%eax
  803b15:	83 e0 1f             	and    $0x1f,%eax
  803b18:	29 d0                	sub    %edx,%eax
  803b1a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b1e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803b22:	48 01 ca             	add    %rcx,%rdx
  803b25:	0f b6 0a             	movzbl (%rdx),%ecx
  803b28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b2c:	48 98                	cltq   
  803b2e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803b32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b36:	8b 40 04             	mov    0x4(%rax),%eax
  803b39:	8d 50 01             	lea    0x1(%rax),%edx
  803b3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b40:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b43:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b4c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b50:	0f 82 64 ff ff ff    	jb     803aba <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803b56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b5a:	c9                   	leaveq 
  803b5b:	c3                   	retq   

0000000000803b5c <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803b5c:	55                   	push   %rbp
  803b5d:	48 89 e5             	mov    %rsp,%rbp
  803b60:	48 83 ec 20          	sub    $0x20,%rsp
  803b64:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b68:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b70:	48 89 c7             	mov    %rax,%rdi
  803b73:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  803b7a:	00 00 00 
  803b7d:	ff d0                	callq  *%rax
  803b7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b87:	48 be b0 48 80 00 00 	movabs $0x8048b0,%rsi
  803b8e:	00 00 00 
  803b91:	48 89 c7             	mov    %rax,%rdi
  803b94:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  803b9b:	00 00 00 
  803b9e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803ba0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba4:	8b 50 04             	mov    0x4(%rax),%edx
  803ba7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bab:	8b 00                	mov    (%rax),%eax
  803bad:	29 c2                	sub    %eax,%edx
  803baf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bb3:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803bb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bbd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803bc4:	00 00 00 
	stat->st_dev = &devpipe;
  803bc7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803bcb:	48 b9 80 60 80 00 00 	movabs $0x806080,%rcx
  803bd2:	00 00 00 
  803bd5:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803bdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803be1:	c9                   	leaveq 
  803be2:	c3                   	retq   

0000000000803be3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803be3:	55                   	push   %rbp
  803be4:	48 89 e5             	mov    %rsp,%rbp
  803be7:	48 83 ec 10          	sub    $0x10,%rsp
  803beb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803bef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803bf3:	48 89 c6             	mov    %rax,%rsi
  803bf6:	bf 00 00 00 00       	mov    $0x0,%edi
  803bfb:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  803c02:	00 00 00 
  803c05:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803c07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c0b:	48 89 c7             	mov    %rax,%rdi
  803c0e:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  803c15:	00 00 00 
  803c18:	ff d0                	callq  *%rax
  803c1a:	48 89 c6             	mov    %rax,%rsi
  803c1d:	bf 00 00 00 00       	mov    $0x0,%edi
  803c22:	48 b8 62 19 80 00 00 	movabs $0x801962,%rax
  803c29:	00 00 00 
  803c2c:	ff d0                	callq  *%rax
}
  803c2e:	c9                   	leaveq 
  803c2f:	c3                   	retq   

0000000000803c30 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803c30:	55                   	push   %rbp
  803c31:	48 89 e5             	mov    %rsp,%rbp
  803c34:	48 83 ec 20          	sub    $0x20,%rsp
  803c38:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803c3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c3e:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803c41:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803c45:	be 01 00 00 00       	mov    $0x1,%esi
  803c4a:	48 89 c7             	mov    %rax,%rdi
  803c4d:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  803c54:	00 00 00 
  803c57:	ff d0                	callq  *%rax
}
  803c59:	c9                   	leaveq 
  803c5a:	c3                   	retq   

0000000000803c5b <getchar>:

int
getchar(void)
{
  803c5b:	55                   	push   %rbp
  803c5c:	48 89 e5             	mov    %rsp,%rbp
  803c5f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803c63:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c67:	ba 01 00 00 00       	mov    $0x1,%edx
  803c6c:	48 89 c6             	mov    %rax,%rsi
  803c6f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c74:	48 b8 3c 20 80 00 00 	movabs $0x80203c,%rax
  803c7b:	00 00 00 
  803c7e:	ff d0                	callq  *%rax
  803c80:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c87:	79 05                	jns    803c8e <getchar+0x33>
		return r;
  803c89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c8c:	eb 14                	jmp    803ca2 <getchar+0x47>
	if (r < 1)
  803c8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c92:	7f 07                	jg     803c9b <getchar+0x40>
		return -E_EOF;
  803c94:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c99:	eb 07                	jmp    803ca2 <getchar+0x47>
	return c;
  803c9b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c9f:	0f b6 c0             	movzbl %al,%eax
}
  803ca2:	c9                   	leaveq 
  803ca3:	c3                   	retq   

0000000000803ca4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803ca4:	55                   	push   %rbp
  803ca5:	48 89 e5             	mov    %rsp,%rbp
  803ca8:	48 83 ec 20          	sub    $0x20,%rsp
  803cac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803caf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803cb3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cb6:	48 89 d6             	mov    %rdx,%rsi
  803cb9:	89 c7                	mov    %eax,%edi
  803cbb:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  803cc2:	00 00 00 
  803cc5:	ff d0                	callq  *%rax
  803cc7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cce:	79 05                	jns    803cd5 <iscons+0x31>
		return r;
  803cd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cd3:	eb 1a                	jmp    803cef <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803cd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd9:	8b 10                	mov    (%rax),%edx
  803cdb:	48 b8 c0 60 80 00 00 	movabs $0x8060c0,%rax
  803ce2:	00 00 00 
  803ce5:	8b 00                	mov    (%rax),%eax
  803ce7:	39 c2                	cmp    %eax,%edx
  803ce9:	0f 94 c0             	sete   %al
  803cec:	0f b6 c0             	movzbl %al,%eax
}
  803cef:	c9                   	leaveq 
  803cf0:	c3                   	retq   

0000000000803cf1 <opencons>:

int
opencons(void)
{
  803cf1:	55                   	push   %rbp
  803cf2:	48 89 e5             	mov    %rsp,%rbp
  803cf5:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803cf9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803cfd:	48 89 c7             	mov    %rax,%rdi
  803d00:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  803d07:	00 00 00 
  803d0a:	ff d0                	callq  *%rax
  803d0c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d13:	79 05                	jns    803d1a <opencons+0x29>
		return r;
  803d15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d18:	eb 5b                	jmp    803d75 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1e:	ba 07 04 00 00       	mov    $0x407,%edx
  803d23:	48 89 c6             	mov    %rax,%rsi
  803d26:	bf 00 00 00 00       	mov    $0x0,%edi
  803d2b:	48 b8 b7 18 80 00 00 	movabs $0x8018b7,%rax
  803d32:	00 00 00 
  803d35:	ff d0                	callq  *%rax
  803d37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d3e:	79 05                	jns    803d45 <opencons+0x54>
		return r;
  803d40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d43:	eb 30                	jmp    803d75 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803d45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d49:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  803d50:	00 00 00 
  803d53:	8b 12                	mov    (%rdx),%edx
  803d55:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803d57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803d62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d66:	48 89 c7             	mov    %rax,%rdi
  803d69:	48 b8 24 1b 80 00 00 	movabs $0x801b24,%rax
  803d70:	00 00 00 
  803d73:	ff d0                	callq  *%rax
}
  803d75:	c9                   	leaveq 
  803d76:	c3                   	retq   

0000000000803d77 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d77:	55                   	push   %rbp
  803d78:	48 89 e5             	mov    %rsp,%rbp
  803d7b:	48 83 ec 30          	sub    $0x30,%rsp
  803d7f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d83:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d87:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d8b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d90:	75 07                	jne    803d99 <devcons_read+0x22>
		return 0;
  803d92:	b8 00 00 00 00       	mov    $0x0,%eax
  803d97:	eb 4b                	jmp    803de4 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803d99:	eb 0c                	jmp    803da7 <devcons_read+0x30>
		sys_yield();
  803d9b:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  803da2:	00 00 00 
  803da5:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803da7:	48 b8 b9 17 80 00 00 	movabs $0x8017b9,%rax
  803dae:	00 00 00 
  803db1:	ff d0                	callq  *%rax
  803db3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803db6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dba:	74 df                	je     803d9b <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803dbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dc0:	79 05                	jns    803dc7 <devcons_read+0x50>
		return c;
  803dc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dc5:	eb 1d                	jmp    803de4 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803dc7:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803dcb:	75 07                	jne    803dd4 <devcons_read+0x5d>
		return 0;
  803dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd2:	eb 10                	jmp    803de4 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803dd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd7:	89 c2                	mov    %eax,%edx
  803dd9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ddd:	88 10                	mov    %dl,(%rax)
	return 1;
  803ddf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803de4:	c9                   	leaveq 
  803de5:	c3                   	retq   

0000000000803de6 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803de6:	55                   	push   %rbp
  803de7:	48 89 e5             	mov    %rsp,%rbp
  803dea:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803df1:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803df8:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803dff:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e0d:	eb 76                	jmp    803e85 <devcons_write+0x9f>
		m = n - tot;
  803e0f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803e16:	89 c2                	mov    %eax,%edx
  803e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e1b:	29 c2                	sub    %eax,%edx
  803e1d:	89 d0                	mov    %edx,%eax
  803e1f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803e22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e25:	83 f8 7f             	cmp    $0x7f,%eax
  803e28:	76 07                	jbe    803e31 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803e2a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803e31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e34:	48 63 d0             	movslq %eax,%rdx
  803e37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e3a:	48 63 c8             	movslq %eax,%rcx
  803e3d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803e44:	48 01 c1             	add    %rax,%rcx
  803e47:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e4e:	48 89 ce             	mov    %rcx,%rsi
  803e51:	48 89 c7             	mov    %rax,%rdi
  803e54:	48 b8 ac 12 80 00 00 	movabs $0x8012ac,%rax
  803e5b:	00 00 00 
  803e5e:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803e60:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e63:	48 63 d0             	movslq %eax,%rdx
  803e66:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e6d:	48 89 d6             	mov    %rdx,%rsi
  803e70:	48 89 c7             	mov    %rax,%rdi
  803e73:	48 b8 6f 17 80 00 00 	movabs $0x80176f,%rax
  803e7a:	00 00 00 
  803e7d:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e82:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e88:	48 98                	cltq   
  803e8a:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e91:	0f 82 78 ff ff ff    	jb     803e0f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e97:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e9a:	c9                   	leaveq 
  803e9b:	c3                   	retq   

0000000000803e9c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e9c:	55                   	push   %rbp
  803e9d:	48 89 e5             	mov    %rsp,%rbp
  803ea0:	48 83 ec 08          	sub    $0x8,%rsp
  803ea4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803ea8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ead:	c9                   	leaveq 
  803eae:	c3                   	retq   

0000000000803eaf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803eaf:	55                   	push   %rbp
  803eb0:	48 89 e5             	mov    %rsp,%rbp
  803eb3:	48 83 ec 10          	sub    $0x10,%rsp
  803eb7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ebb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803ebf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec3:	48 be bc 48 80 00 00 	movabs $0x8048bc,%rsi
  803eca:	00 00 00 
  803ecd:	48 89 c7             	mov    %rax,%rdi
  803ed0:	48 b8 88 0f 80 00 00 	movabs $0x800f88,%rax
  803ed7:	00 00 00 
  803eda:	ff d0                	callq  *%rax
	return 0;
  803edc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ee1:	c9                   	leaveq 
  803ee2:	c3                   	retq   

0000000000803ee3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803ee3:	55                   	push   %rbp
  803ee4:	48 89 e5             	mov    %rsp,%rbp
  803ee7:	48 83 ec 30          	sub    $0x30,%rsp
  803eeb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803eef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ef3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803ef7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803efc:	74 18                	je     803f16 <ipc_recv+0x33>
  803efe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f02:	48 89 c7             	mov    %rax,%rdi
  803f05:	48 b8 e0 1a 80 00 00 	movabs $0x801ae0,%rax
  803f0c:	00 00 00 
  803f0f:	ff d0                	callq  *%rax
  803f11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f14:	eb 19                	jmp    803f2f <ipc_recv+0x4c>
  803f16:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803f1d:	00 00 00 
  803f20:	48 b8 e0 1a 80 00 00 	movabs $0x801ae0,%rax
  803f27:	00 00 00 
  803f2a:	ff d0                	callq  *%rax
  803f2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  803f2f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f34:	74 26                	je     803f5c <ipc_recv+0x79>
  803f36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f3a:	75 15                	jne    803f51 <ipc_recv+0x6e>
  803f3c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f43:	00 00 00 
  803f46:	48 8b 00             	mov    (%rax),%rax
  803f49:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803f4f:	eb 05                	jmp    803f56 <ipc_recv+0x73>
  803f51:	b8 00 00 00 00       	mov    $0x0,%eax
  803f56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f5a:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803f5c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f61:	74 26                	je     803f89 <ipc_recv+0xa6>
  803f63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f67:	75 15                	jne    803f7e <ipc_recv+0x9b>
  803f69:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f70:	00 00 00 
  803f73:	48 8b 00             	mov    (%rax),%rax
  803f76:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803f7c:	eb 05                	jmp    803f83 <ipc_recv+0xa0>
  803f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f83:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803f87:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803f89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f8d:	75 15                	jne    803fa4 <ipc_recv+0xc1>
  803f8f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f96:	00 00 00 
  803f99:	48 8b 00             	mov    (%rax),%rax
  803f9c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803fa2:	eb 03                	jmp    803fa7 <ipc_recv+0xc4>
  803fa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803fa7:	c9                   	leaveq 
  803fa8:	c3                   	retq   

0000000000803fa9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803fa9:	55                   	push   %rbp
  803faa:	48 89 e5             	mov    %rsp,%rbp
  803fad:	48 83 ec 30          	sub    $0x30,%rsp
  803fb1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fb4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803fb7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803fbb:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803fbe:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803fc5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fca:	75 10                	jne    803fdc <ipc_send+0x33>
  803fcc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fd3:	00 00 00 
  803fd6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803fda:	eb 62                	jmp    80403e <ipc_send+0x95>
  803fdc:	eb 60                	jmp    80403e <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803fde:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fe2:	74 30                	je     804014 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803fe4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe7:	89 c1                	mov    %eax,%ecx
  803fe9:	48 ba c3 48 80 00 00 	movabs $0x8048c3,%rdx
  803ff0:	00 00 00 
  803ff3:	be 33 00 00 00       	mov    $0x33,%esi
  803ff8:	48 bf df 48 80 00 00 	movabs $0x8048df,%rdi
  803fff:	00 00 00 
  804002:	b8 00 00 00 00       	mov    $0x0,%eax
  804007:	49 b8 9a 01 80 00 00 	movabs $0x80019a,%r8
  80400e:	00 00 00 
  804011:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  804014:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804017:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80401a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80401e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804021:	89 c7                	mov    %eax,%edi
  804023:	48 b8 8b 1a 80 00 00 	movabs $0x801a8b,%rax
  80402a:	00 00 00 
  80402d:	ff d0                	callq  *%rax
  80402f:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  804032:	48 b8 79 18 80 00 00 	movabs $0x801879,%rax
  804039:	00 00 00 
  80403c:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  80403e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804042:	75 9a                	jne    803fde <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  804044:	c9                   	leaveq 
  804045:	c3                   	retq   

0000000000804046 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804046:	55                   	push   %rbp
  804047:	48 89 e5             	mov    %rsp,%rbp
  80404a:	48 83 ec 14          	sub    $0x14,%rsp
  80404e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804051:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804058:	eb 5e                	jmp    8040b8 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  80405a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804061:	00 00 00 
  804064:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804067:	48 63 d0             	movslq %eax,%rdx
  80406a:	48 89 d0             	mov    %rdx,%rax
  80406d:	48 c1 e0 03          	shl    $0x3,%rax
  804071:	48 01 d0             	add    %rdx,%rax
  804074:	48 c1 e0 05          	shl    $0x5,%rax
  804078:	48 01 c8             	add    %rcx,%rax
  80407b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804081:	8b 00                	mov    (%rax),%eax
  804083:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804086:	75 2c                	jne    8040b4 <ipc_find_env+0x6e>
			return envs[i].env_id;
  804088:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80408f:	00 00 00 
  804092:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804095:	48 63 d0             	movslq %eax,%rdx
  804098:	48 89 d0             	mov    %rdx,%rax
  80409b:	48 c1 e0 03          	shl    $0x3,%rax
  80409f:	48 01 d0             	add    %rdx,%rax
  8040a2:	48 c1 e0 05          	shl    $0x5,%rax
  8040a6:	48 01 c8             	add    %rcx,%rax
  8040a9:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8040af:	8b 40 08             	mov    0x8(%rax),%eax
  8040b2:	eb 12                	jmp    8040c6 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8040b4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8040b8:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8040bf:	7e 99                	jle    80405a <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8040c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040c6:	c9                   	leaveq 
  8040c7:	c3                   	retq   

00000000008040c8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8040c8:	55                   	push   %rbp
  8040c9:	48 89 e5             	mov    %rsp,%rbp
  8040cc:	48 83 ec 18          	sub    $0x18,%rsp
  8040d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8040d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040d8:	48 c1 e8 15          	shr    $0x15,%rax
  8040dc:	48 89 c2             	mov    %rax,%rdx
  8040df:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8040e6:	01 00 00 
  8040e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040ed:	83 e0 01             	and    $0x1,%eax
  8040f0:	48 85 c0             	test   %rax,%rax
  8040f3:	75 07                	jne    8040fc <pageref+0x34>
		return 0;
  8040f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8040fa:	eb 53                	jmp    80414f <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8040fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804100:	48 c1 e8 0c          	shr    $0xc,%rax
  804104:	48 89 c2             	mov    %rax,%rdx
  804107:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80410e:	01 00 00 
  804111:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804115:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804119:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80411d:	83 e0 01             	and    $0x1,%eax
  804120:	48 85 c0             	test   %rax,%rax
  804123:	75 07                	jne    80412c <pageref+0x64>
		return 0;
  804125:	b8 00 00 00 00       	mov    $0x0,%eax
  80412a:	eb 23                	jmp    80414f <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  80412c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804130:	48 c1 e8 0c          	shr    $0xc,%rax
  804134:	48 89 c2             	mov    %rax,%rdx
  804137:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  80413e:	00 00 00 
  804141:	48 c1 e2 04          	shl    $0x4,%rdx
  804145:	48 01 d0             	add    %rdx,%rax
  804148:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  80414c:	0f b7 c0             	movzwl %ax,%eax
}
  80414f:	c9                   	leaveq 
  804150:	c3                   	retq   
