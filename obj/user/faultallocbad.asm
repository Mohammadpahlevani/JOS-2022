
obj/user/faultallocbad:     file format elf64-x86-64


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
  80003c:	e8 15 01 00 00       	callq  800156 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80004f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800053:	48 8b 00             	mov    (%rax),%rax
  800056:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	cprintf("fault %x\n", addr);
  80005a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80005e:	48 89 c6             	mov    %rax,%rsi
  800061:	48 bf 00 37 80 00 00 	movabs $0x803700,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 42 04 80 00 00 	movabs $0x800442,%rdx
  800077:	00 00 00 
  80007a:	ff d2                	callq  *%rdx
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80007c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800080:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800088:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80008e:	ba 07 00 00 00       	mov    $0x7,%edx
  800093:	48 89 c6             	mov    %rax,%rsi
  800096:	bf 00 00 00 00       	mov    $0x0,%edi
  80009b:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  8000a2:	00 00 00 
  8000a5:	ff d0                	callq  *%rax
  8000a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8000aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8000ae:	79 38                	jns    8000e8 <handler+0xa5>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  8000b0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000b7:	41 89 d0             	mov    %edx,%r8d
  8000ba:	48 89 c1             	mov    %rax,%rcx
  8000bd:	48 ba 10 37 80 00 00 	movabs $0x803710,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0f 00 00 00       	mov    $0xf,%esi
  8000cc:	48 bf 3b 37 80 00 00 	movabs $0x80373b,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 09 02 80 00 00 	movabs $0x800209,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba 50 37 80 00 00 	movabs $0x803750,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 aa 0e 80 00 00 	movabs $0x800eaa,%r8
  800111:	00 00 00 
  800114:	41 ff d0             	callq  *%r8
}
  800117:	c9                   	leaveq 
  800118:	c3                   	retq   

0000000000800119 <umain>:

void
umain(int argc, char **argv)
{
  800119:	55                   	push   %rbp
  80011a:	48 89 e5             	mov    %rsp,%rbp
  80011d:	48 83 ec 10          	sub    $0x10,%rsp
  800121:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800124:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	set_pgfault_handler(handler);
  800128:	48 bf 43 00 80 00 00 	movabs $0x800043,%rdi
  80012f:	00 00 00 
  800132:	48 b8 93 1b 80 00 00 	movabs $0x801b93,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	sys_cputs((char*)0xDEADBEEF, 4);
  80013e:	be 04 00 00 00       	mov    $0x4,%esi
  800143:	bf ef be ad de       	mov    $0xdeadbeef,%edi
  800148:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  80014f:	00 00 00 
  800152:	ff d0                	callq  *%rax
}
  800154:	c9                   	leaveq 
  800155:	c3                   	retq   

0000000000800156 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800156:	55                   	push   %rbp
  800157:	48 89 e5             	mov    %rsp,%rbp
  80015a:	48 83 ec 10          	sub    $0x10,%rsp
  80015e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800161:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800165:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
  800171:	48 98                	cltq   
  800173:	25 ff 03 00 00       	and    $0x3ff,%eax
  800178:	48 89 c2             	mov    %rax,%rdx
  80017b:	48 89 d0             	mov    %rdx,%rax
  80017e:	48 c1 e0 03          	shl    $0x3,%rax
  800182:	48 01 d0             	add    %rdx,%rax
  800185:	48 c1 e0 05          	shl    $0x5,%rax
  800189:	48 89 c2             	mov    %rax,%rdx
  80018c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800193:	00 00 00 
  800196:	48 01 c2             	add    %rax,%rdx
  800199:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001a0:	00 00 00 
  8001a3:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001aa:	7e 14                	jle    8001c0 <libmain+0x6a>
		binaryname = argv[0];
  8001ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001b0:	48 8b 10             	mov    (%rax),%rdx
  8001b3:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001ba:	00 00 00 
  8001bd:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001c0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001c7:	48 89 d6             	mov    %rdx,%rsi
  8001ca:	89 c7                	mov    %eax,%edi
  8001cc:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  8001d3:	00 00 00 
  8001d6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001d8:	48 b8 e6 01 80 00 00 	movabs $0x8001e6,%rax
  8001df:	00 00 00 
  8001e2:	ff d0                	callq  *%rax
}
  8001e4:	c9                   	leaveq 
  8001e5:	c3                   	retq   

00000000008001e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e6:	55                   	push   %rbp
  8001e7:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8001ea:	48 b8 f3 1f 80 00 00 	movabs $0x801ff3,%rax
  8001f1:	00 00 00 
  8001f4:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8001f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fb:	48 b8 66 18 80 00 00 	movabs $0x801866,%rax
  800202:	00 00 00 
  800205:	ff d0                	callq  *%rax
}
  800207:	5d                   	pop    %rbp
  800208:	c3                   	retq   

0000000000800209 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800209:	55                   	push   %rbp
  80020a:	48 89 e5             	mov    %rsp,%rbp
  80020d:	53                   	push   %rbx
  80020e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800215:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80021c:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800222:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800229:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800230:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800237:	84 c0                	test   %al,%al
  800239:	74 23                	je     80025e <_panic+0x55>
  80023b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800242:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800246:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80024a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80024e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800252:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800256:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80025a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80025e:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800265:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80026c:	00 00 00 
  80026f:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800276:	00 00 00 
  800279:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80027d:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800284:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80028b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800292:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800299:	00 00 00 
  80029c:	48 8b 18             	mov    (%rax),%rbx
  80029f:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
  8002ab:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002b1:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002b8:	41 89 c8             	mov    %ecx,%r8d
  8002bb:	48 89 d1             	mov    %rdx,%rcx
  8002be:	48 89 da             	mov    %rbx,%rdx
  8002c1:	89 c6                	mov    %eax,%esi
  8002c3:	48 bf 80 37 80 00 00 	movabs $0x803780,%rdi
  8002ca:	00 00 00 
  8002cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d2:	49 b9 42 04 80 00 00 	movabs $0x800442,%r9
  8002d9:	00 00 00 
  8002dc:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002df:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8002e6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002ed:	48 89 d6             	mov    %rdx,%rsi
  8002f0:	48 89 c7             	mov    %rax,%rdi
  8002f3:	48 b8 96 03 80 00 00 	movabs $0x800396,%rax
  8002fa:	00 00 00 
  8002fd:	ff d0                	callq  *%rax
	cprintf("\n");
  8002ff:	48 bf a3 37 80 00 00 	movabs $0x8037a3,%rdi
  800306:	00 00 00 
  800309:	b8 00 00 00 00       	mov    $0x0,%eax
  80030e:	48 ba 42 04 80 00 00 	movabs $0x800442,%rdx
  800315:	00 00 00 
  800318:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80031a:	cc                   	int3   
  80031b:	eb fd                	jmp    80031a <_panic+0x111>

000000000080031d <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80031d:	55                   	push   %rbp
  80031e:	48 89 e5             	mov    %rsp,%rbp
  800321:	48 83 ec 10          	sub    $0x10,%rsp
  800325:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800328:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80032c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800330:	8b 00                	mov    (%rax),%eax
  800332:	8d 48 01             	lea    0x1(%rax),%ecx
  800335:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800339:	89 0a                	mov    %ecx,(%rdx)
  80033b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80033e:	89 d1                	mov    %edx,%ecx
  800340:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800344:	48 98                	cltq   
  800346:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80034a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80034e:	8b 00                	mov    (%rax),%eax
  800350:	3d ff 00 00 00       	cmp    $0xff,%eax
  800355:	75 2c                	jne    800383 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80035b:	8b 00                	mov    (%rax),%eax
  80035d:	48 98                	cltq   
  80035f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800363:	48 83 c2 08          	add    $0x8,%rdx
  800367:	48 89 c6             	mov    %rax,%rsi
  80036a:	48 89 d7             	mov    %rdx,%rdi
  80036d:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  800374:	00 00 00 
  800377:	ff d0                	callq  *%rax
        b->idx = 0;
  800379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80037d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800383:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800387:	8b 40 04             	mov    0x4(%rax),%eax
  80038a:	8d 50 01             	lea    0x1(%rax),%edx
  80038d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800391:	89 50 04             	mov    %edx,0x4(%rax)
}
  800394:	c9                   	leaveq 
  800395:	c3                   	retq   

0000000000800396 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800396:	55                   	push   %rbp
  800397:	48 89 e5             	mov    %rsp,%rbp
  80039a:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003a1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003a8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003af:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003b6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003bd:	48 8b 0a             	mov    (%rdx),%rcx
  8003c0:	48 89 08             	mov    %rcx,(%rax)
  8003c3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003c7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003cb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003cf:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8003d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003da:	00 00 00 
    b.cnt = 0;
  8003dd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8003e4:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8003e7:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8003ee:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8003f5:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8003fc:	48 89 c6             	mov    %rax,%rsi
  8003ff:	48 bf 1d 03 80 00 00 	movabs $0x80031d,%rdi
  800406:	00 00 00 
  800409:	48 b8 f5 07 80 00 00 	movabs $0x8007f5,%rax
  800410:	00 00 00 
  800413:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800415:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80041b:	48 98                	cltq   
  80041d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800424:	48 83 c2 08          	add    $0x8,%rdx
  800428:	48 89 c6             	mov    %rax,%rsi
  80042b:	48 89 d7             	mov    %rdx,%rdi
  80042e:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  800435:	00 00 00 
  800438:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80043a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800440:	c9                   	leaveq 
  800441:	c3                   	retq   

0000000000800442 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800442:	55                   	push   %rbp
  800443:	48 89 e5             	mov    %rsp,%rbp
  800446:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80044d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800454:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80045b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800462:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800469:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800470:	84 c0                	test   %al,%al
  800472:	74 20                	je     800494 <cprintf+0x52>
  800474:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800478:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80047c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800480:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800484:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800488:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80048c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800490:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800494:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80049b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004a2:	00 00 00 
  8004a5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004ac:	00 00 00 
  8004af:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004b3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004ba:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004c1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004c8:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004cf:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004d6:	48 8b 0a             	mov    (%rdx),%rcx
  8004d9:	48 89 08             	mov    %rcx,(%rax)
  8004dc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004e0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004e4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004e8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8004ec:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8004f3:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004fa:	48 89 d6             	mov    %rdx,%rsi
  8004fd:	48 89 c7             	mov    %rax,%rdi
  800500:	48 b8 96 03 80 00 00 	movabs $0x800396,%rax
  800507:	00 00 00 
  80050a:	ff d0                	callq  *%rax
  80050c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800512:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800518:	c9                   	leaveq 
  800519:	c3                   	retq   

000000000080051a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80051a:	55                   	push   %rbp
  80051b:	48 89 e5             	mov    %rsp,%rbp
  80051e:	53                   	push   %rbx
  80051f:	48 83 ec 38          	sub    $0x38,%rsp
  800523:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800527:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80052b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80052f:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800532:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800536:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80053a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80053d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800541:	77 3b                	ja     80057e <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800543:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800546:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80054a:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80054d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800551:	ba 00 00 00 00       	mov    $0x0,%edx
  800556:	48 f7 f3             	div    %rbx
  800559:	48 89 c2             	mov    %rax,%rdx
  80055c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80055f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800562:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056a:	41 89 f9             	mov    %edi,%r9d
  80056d:	48 89 c7             	mov    %rax,%rdi
  800570:	48 b8 1a 05 80 00 00 	movabs $0x80051a,%rax
  800577:	00 00 00 
  80057a:	ff d0                	callq  *%rax
  80057c:	eb 1e                	jmp    80059c <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80057e:	eb 12                	jmp    800592 <printnum+0x78>
			putch(padc, putdat);
  800580:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800584:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800587:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80058b:	48 89 ce             	mov    %rcx,%rsi
  80058e:	89 d7                	mov    %edx,%edi
  800590:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800592:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800596:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80059a:	7f e4                	jg     800580 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80059c:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80059f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a8:	48 f7 f1             	div    %rcx
  8005ab:	48 89 d0             	mov    %rdx,%rax
  8005ae:	48 ba b0 39 80 00 00 	movabs $0x8039b0,%rdx
  8005b5:	00 00 00 
  8005b8:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005bc:	0f be d0             	movsbl %al,%edx
  8005bf:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005c7:	48 89 ce             	mov    %rcx,%rsi
  8005ca:	89 d7                	mov    %edx,%edi
  8005cc:	ff d0                	callq  *%rax
}
  8005ce:	48 83 c4 38          	add    $0x38,%rsp
  8005d2:	5b                   	pop    %rbx
  8005d3:	5d                   	pop    %rbp
  8005d4:	c3                   	retq   

00000000008005d5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %rbp
  8005d6:	48 89 e5             	mov    %rsp,%rbp
  8005d9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005e1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8005e4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005e8:	7e 52                	jle    80063c <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8005ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ee:	8b 00                	mov    (%rax),%eax
  8005f0:	83 f8 30             	cmp    $0x30,%eax
  8005f3:	73 24                	jae    800619 <getuint+0x44>
  8005f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800601:	8b 00                	mov    (%rax),%eax
  800603:	89 c0                	mov    %eax,%eax
  800605:	48 01 d0             	add    %rdx,%rax
  800608:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80060c:	8b 12                	mov    (%rdx),%edx
  80060e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800611:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800615:	89 0a                	mov    %ecx,(%rdx)
  800617:	eb 17                	jmp    800630 <getuint+0x5b>
  800619:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80061d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800621:	48 89 d0             	mov    %rdx,%rax
  800624:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800628:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80062c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800637:	e9 a3 00 00 00       	jmpq   8006df <getuint+0x10a>
	else if (lflag)
  80063c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800640:	74 4f                	je     800691 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800642:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800646:	8b 00                	mov    (%rax),%eax
  800648:	83 f8 30             	cmp    $0x30,%eax
  80064b:	73 24                	jae    800671 <getuint+0x9c>
  80064d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800651:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	8b 00                	mov    (%rax),%eax
  80065b:	89 c0                	mov    %eax,%eax
  80065d:	48 01 d0             	add    %rdx,%rax
  800660:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800664:	8b 12                	mov    (%rdx),%edx
  800666:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800669:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066d:	89 0a                	mov    %ecx,(%rdx)
  80066f:	eb 17                	jmp    800688 <getuint+0xb3>
  800671:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800675:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800679:	48 89 d0             	mov    %rdx,%rax
  80067c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800680:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800684:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800688:	48 8b 00             	mov    (%rax),%rax
  80068b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80068f:	eb 4e                	jmp    8006df <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800695:	8b 00                	mov    (%rax),%eax
  800697:	83 f8 30             	cmp    $0x30,%eax
  80069a:	73 24                	jae    8006c0 <getuint+0xeb>
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a8:	8b 00                	mov    (%rax),%eax
  8006aa:	89 c0                	mov    %eax,%eax
  8006ac:	48 01 d0             	add    %rdx,%rax
  8006af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b3:	8b 12                	mov    (%rdx),%edx
  8006b5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bc:	89 0a                	mov    %ecx,(%rdx)
  8006be:	eb 17                	jmp    8006d7 <getuint+0x102>
  8006c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c8:	48 89 d0             	mov    %rdx,%rax
  8006cb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d7:	8b 00                	mov    (%rax),%eax
  8006d9:	89 c0                	mov    %eax,%eax
  8006db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006e3:	c9                   	leaveq 
  8006e4:	c3                   	retq   

00000000008006e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %rbp
  8006e6:	48 89 e5             	mov    %rsp,%rbp
  8006e9:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006f1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8006f4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006f8:	7e 52                	jle    80074c <getint+0x67>
		x=va_arg(*ap, long long);
  8006fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006fe:	8b 00                	mov    (%rax),%eax
  800700:	83 f8 30             	cmp    $0x30,%eax
  800703:	73 24                	jae    800729 <getint+0x44>
  800705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800709:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80070d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800711:	8b 00                	mov    (%rax),%eax
  800713:	89 c0                	mov    %eax,%eax
  800715:	48 01 d0             	add    %rdx,%rax
  800718:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071c:	8b 12                	mov    (%rdx),%edx
  80071e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800721:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800725:	89 0a                	mov    %ecx,(%rdx)
  800727:	eb 17                	jmp    800740 <getint+0x5b>
  800729:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80072d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800731:	48 89 d0             	mov    %rdx,%rax
  800734:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800738:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80073c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800740:	48 8b 00             	mov    (%rax),%rax
  800743:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800747:	e9 a3 00 00 00       	jmpq   8007ef <getint+0x10a>
	else if (lflag)
  80074c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800750:	74 4f                	je     8007a1 <getint+0xbc>
		x=va_arg(*ap, long);
  800752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800756:	8b 00                	mov    (%rax),%eax
  800758:	83 f8 30             	cmp    $0x30,%eax
  80075b:	73 24                	jae    800781 <getint+0x9c>
  80075d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800761:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	8b 00                	mov    (%rax),%eax
  80076b:	89 c0                	mov    %eax,%eax
  80076d:	48 01 d0             	add    %rdx,%rax
  800770:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800774:	8b 12                	mov    (%rdx),%edx
  800776:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800779:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077d:	89 0a                	mov    %ecx,(%rdx)
  80077f:	eb 17                	jmp    800798 <getint+0xb3>
  800781:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800785:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800789:	48 89 d0             	mov    %rdx,%rax
  80078c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800790:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800794:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800798:	48 8b 00             	mov    (%rax),%rax
  80079b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80079f:	eb 4e                	jmp    8007ef <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a5:	8b 00                	mov    (%rax),%eax
  8007a7:	83 f8 30             	cmp    $0x30,%eax
  8007aa:	73 24                	jae    8007d0 <getint+0xeb>
  8007ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b8:	8b 00                	mov    (%rax),%eax
  8007ba:	89 c0                	mov    %eax,%eax
  8007bc:	48 01 d0             	add    %rdx,%rax
  8007bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c3:	8b 12                	mov    (%rdx),%edx
  8007c5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cc:	89 0a                	mov    %ecx,(%rdx)
  8007ce:	eb 17                	jmp    8007e7 <getint+0x102>
  8007d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d8:	48 89 d0             	mov    %rdx,%rax
  8007db:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007e7:	8b 00                	mov    (%rax),%eax
  8007e9:	48 98                	cltq   
  8007eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007f3:	c9                   	leaveq 
  8007f4:	c3                   	retq   

00000000008007f5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f5:	55                   	push   %rbp
  8007f6:	48 89 e5             	mov    %rsp,%rbp
  8007f9:	41 54                	push   %r12
  8007fb:	53                   	push   %rbx
  8007fc:	48 83 ec 60          	sub    $0x60,%rsp
  800800:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800804:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800808:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80080c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800810:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800814:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800818:	48 8b 0a             	mov    (%rdx),%rcx
  80081b:	48 89 08             	mov    %rcx,(%rax)
  80081e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800822:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800826:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80082a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082e:	eb 17                	jmp    800847 <vprintfmt+0x52>
			if (ch == '\0')
  800830:	85 db                	test   %ebx,%ebx
  800832:	0f 84 cc 04 00 00    	je     800d04 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800838:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80083c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800840:	48 89 d6             	mov    %rdx,%rsi
  800843:	89 df                	mov    %ebx,%edi
  800845:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800847:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80084b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80084f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800853:	0f b6 00             	movzbl (%rax),%eax
  800856:	0f b6 d8             	movzbl %al,%ebx
  800859:	83 fb 25             	cmp    $0x25,%ebx
  80085c:	75 d2                	jne    800830 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80085e:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800862:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800869:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800870:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800877:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800882:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800886:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80088a:	0f b6 00             	movzbl (%rax),%eax
  80088d:	0f b6 d8             	movzbl %al,%ebx
  800890:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800893:	83 f8 55             	cmp    $0x55,%eax
  800896:	0f 87 34 04 00 00    	ja     800cd0 <vprintfmt+0x4db>
  80089c:	89 c0                	mov    %eax,%eax
  80089e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008a5:	00 
  8008a6:	48 b8 d8 39 80 00 00 	movabs $0x8039d8,%rax
  8008ad:	00 00 00 
  8008b0:	48 01 d0             	add    %rdx,%rax
  8008b3:	48 8b 00             	mov    (%rax),%rax
  8008b6:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008b8:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008bc:	eb c0                	jmp    80087e <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008be:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008c2:	eb ba                	jmp    80087e <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008c4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008cb:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008ce:	89 d0                	mov    %edx,%eax
  8008d0:	c1 e0 02             	shl    $0x2,%eax
  8008d3:	01 d0                	add    %edx,%eax
  8008d5:	01 c0                	add    %eax,%eax
  8008d7:	01 d8                	add    %ebx,%eax
  8008d9:	83 e8 30             	sub    $0x30,%eax
  8008dc:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008df:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008e3:	0f b6 00             	movzbl (%rax),%eax
  8008e6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008e9:	83 fb 2f             	cmp    $0x2f,%ebx
  8008ec:	7e 0c                	jle    8008fa <vprintfmt+0x105>
  8008ee:	83 fb 39             	cmp    $0x39,%ebx
  8008f1:	7f 07                	jg     8008fa <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f3:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008f8:	eb d1                	jmp    8008cb <vprintfmt+0xd6>
			goto process_precision;
  8008fa:	eb 58                	jmp    800954 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8008fc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008ff:	83 f8 30             	cmp    $0x30,%eax
  800902:	73 17                	jae    80091b <vprintfmt+0x126>
  800904:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800908:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80090b:	89 c0                	mov    %eax,%eax
  80090d:	48 01 d0             	add    %rdx,%rax
  800910:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800913:	83 c2 08             	add    $0x8,%edx
  800916:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800919:	eb 0f                	jmp    80092a <vprintfmt+0x135>
  80091b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80091f:	48 89 d0             	mov    %rdx,%rax
  800922:	48 83 c2 08          	add    $0x8,%rdx
  800926:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80092a:	8b 00                	mov    (%rax),%eax
  80092c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80092f:	eb 23                	jmp    800954 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800931:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800935:	79 0c                	jns    800943 <vprintfmt+0x14e>
				width = 0;
  800937:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  80093e:	e9 3b ff ff ff       	jmpq   80087e <vprintfmt+0x89>
  800943:	e9 36 ff ff ff       	jmpq   80087e <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800948:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80094f:	e9 2a ff ff ff       	jmpq   80087e <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800954:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800958:	79 12                	jns    80096c <vprintfmt+0x177>
				width = precision, precision = -1;
  80095a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80095d:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800960:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800967:	e9 12 ff ff ff       	jmpq   80087e <vprintfmt+0x89>
  80096c:	e9 0d ff ff ff       	jmpq   80087e <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800971:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800975:	e9 04 ff ff ff       	jmpq   80087e <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80097a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80097d:	83 f8 30             	cmp    $0x30,%eax
  800980:	73 17                	jae    800999 <vprintfmt+0x1a4>
  800982:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800986:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800989:	89 c0                	mov    %eax,%eax
  80098b:	48 01 d0             	add    %rdx,%rax
  80098e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800991:	83 c2 08             	add    $0x8,%edx
  800994:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800997:	eb 0f                	jmp    8009a8 <vprintfmt+0x1b3>
  800999:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80099d:	48 89 d0             	mov    %rdx,%rax
  8009a0:	48 83 c2 08          	add    $0x8,%rdx
  8009a4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009a8:	8b 10                	mov    (%rax),%edx
  8009aa:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009ae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009b2:	48 89 ce             	mov    %rcx,%rsi
  8009b5:	89 d7                	mov    %edx,%edi
  8009b7:	ff d0                	callq  *%rax
			break;
  8009b9:	e9 40 03 00 00       	jmpq   800cfe <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009be:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c1:	83 f8 30             	cmp    $0x30,%eax
  8009c4:	73 17                	jae    8009dd <vprintfmt+0x1e8>
  8009c6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009ca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009cd:	89 c0                	mov    %eax,%eax
  8009cf:	48 01 d0             	add    %rdx,%rax
  8009d2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d5:	83 c2 08             	add    $0x8,%edx
  8009d8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009db:	eb 0f                	jmp    8009ec <vprintfmt+0x1f7>
  8009dd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e1:	48 89 d0             	mov    %rdx,%rax
  8009e4:	48 83 c2 08          	add    $0x8,%rdx
  8009e8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ec:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8009ee:	85 db                	test   %ebx,%ebx
  8009f0:	79 02                	jns    8009f4 <vprintfmt+0x1ff>
				err = -err;
  8009f2:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009f4:	83 fb 15             	cmp    $0x15,%ebx
  8009f7:	7f 16                	jg     800a0f <vprintfmt+0x21a>
  8009f9:	48 b8 00 39 80 00 00 	movabs $0x803900,%rax
  800a00:	00 00 00 
  800a03:	48 63 d3             	movslq %ebx,%rdx
  800a06:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a0a:	4d 85 e4             	test   %r12,%r12
  800a0d:	75 2e                	jne    800a3d <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a0f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a13:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a17:	89 d9                	mov    %ebx,%ecx
  800a19:	48 ba c1 39 80 00 00 	movabs $0x8039c1,%rdx
  800a20:	00 00 00 
  800a23:	48 89 c7             	mov    %rax,%rdi
  800a26:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2b:	49 b8 0d 0d 80 00 00 	movabs $0x800d0d,%r8
  800a32:	00 00 00 
  800a35:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a38:	e9 c1 02 00 00       	jmpq   800cfe <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a3d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a45:	4c 89 e1             	mov    %r12,%rcx
  800a48:	48 ba ca 39 80 00 00 	movabs $0x8039ca,%rdx
  800a4f:	00 00 00 
  800a52:	48 89 c7             	mov    %rax,%rdi
  800a55:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5a:	49 b8 0d 0d 80 00 00 	movabs $0x800d0d,%r8
  800a61:	00 00 00 
  800a64:	41 ff d0             	callq  *%r8
			break;
  800a67:	e9 92 02 00 00       	jmpq   800cfe <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a6c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a6f:	83 f8 30             	cmp    $0x30,%eax
  800a72:	73 17                	jae    800a8b <vprintfmt+0x296>
  800a74:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a78:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7b:	89 c0                	mov    %eax,%eax
  800a7d:	48 01 d0             	add    %rdx,%rax
  800a80:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a83:	83 c2 08             	add    $0x8,%edx
  800a86:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a89:	eb 0f                	jmp    800a9a <vprintfmt+0x2a5>
  800a8b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a8f:	48 89 d0             	mov    %rdx,%rax
  800a92:	48 83 c2 08          	add    $0x8,%rdx
  800a96:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9a:	4c 8b 20             	mov    (%rax),%r12
  800a9d:	4d 85 e4             	test   %r12,%r12
  800aa0:	75 0a                	jne    800aac <vprintfmt+0x2b7>
				p = "(null)";
  800aa2:	49 bc cd 39 80 00 00 	movabs $0x8039cd,%r12
  800aa9:	00 00 00 
			if (width > 0 && padc != '-')
  800aac:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab0:	7e 3f                	jle    800af1 <vprintfmt+0x2fc>
  800ab2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ab6:	74 39                	je     800af1 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800abb:	48 98                	cltq   
  800abd:	48 89 c6             	mov    %rax,%rsi
  800ac0:	4c 89 e7             	mov    %r12,%rdi
  800ac3:	48 b8 b9 0f 80 00 00 	movabs $0x800fb9,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ad2:	eb 17                	jmp    800aeb <vprintfmt+0x2f6>
					putch(padc, putdat);
  800ad4:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ad8:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800adc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae0:	48 89 ce             	mov    %rcx,%rsi
  800ae3:	89 d7                	mov    %edx,%edi
  800ae5:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800aeb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aef:	7f e3                	jg     800ad4 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af1:	eb 37                	jmp    800b2a <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800af3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800af7:	74 1e                	je     800b17 <vprintfmt+0x322>
  800af9:	83 fb 1f             	cmp    $0x1f,%ebx
  800afc:	7e 05                	jle    800b03 <vprintfmt+0x30e>
  800afe:	83 fb 7e             	cmp    $0x7e,%ebx
  800b01:	7e 14                	jle    800b17 <vprintfmt+0x322>
					putch('?', putdat);
  800b03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0b:	48 89 d6             	mov    %rdx,%rsi
  800b0e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b13:	ff d0                	callq  *%rax
  800b15:	eb 0f                	jmp    800b26 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b17:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b1f:	48 89 d6             	mov    %rdx,%rsi
  800b22:	89 df                	mov    %ebx,%edi
  800b24:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b26:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b2a:	4c 89 e0             	mov    %r12,%rax
  800b2d:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b31:	0f b6 00             	movzbl (%rax),%eax
  800b34:	0f be d8             	movsbl %al,%ebx
  800b37:	85 db                	test   %ebx,%ebx
  800b39:	74 10                	je     800b4b <vprintfmt+0x356>
  800b3b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b3f:	78 b2                	js     800af3 <vprintfmt+0x2fe>
  800b41:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b45:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b49:	79 a8                	jns    800af3 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4b:	eb 16                	jmp    800b63 <vprintfmt+0x36e>
				putch(' ', putdat);
  800b4d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b51:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b55:	48 89 d6             	mov    %rdx,%rsi
  800b58:	bf 20 00 00 00       	mov    $0x20,%edi
  800b5d:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b63:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b67:	7f e4                	jg     800b4d <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800b69:	e9 90 01 00 00       	jmpq   800cfe <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b6e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b72:	be 03 00 00 00       	mov    $0x3,%esi
  800b77:	48 89 c7             	mov    %rax,%rdi
  800b7a:	48 b8 e5 06 80 00 00 	movabs $0x8006e5,%rax
  800b81:	00 00 00 
  800b84:	ff d0                	callq  *%rax
  800b86:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8e:	48 85 c0             	test   %rax,%rax
  800b91:	79 1d                	jns    800bb0 <vprintfmt+0x3bb>
				putch('-', putdat);
  800b93:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9b:	48 89 d6             	mov    %rdx,%rsi
  800b9e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ba3:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ba5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba9:	48 f7 d8             	neg    %rax
  800bac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bb0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bb7:	e9 d5 00 00 00       	jmpq   800c91 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800bbc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc0:	be 03 00 00 00       	mov    $0x3,%esi
  800bc5:	48 89 c7             	mov    %rax,%rdi
  800bc8:	48 b8 d5 05 80 00 00 	movabs $0x8005d5,%rax
  800bcf:	00 00 00 
  800bd2:	ff d0                	callq  *%rax
  800bd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800bd8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bdf:	e9 ad 00 00 00       	jmpq   800c91 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800be4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800be8:	be 03 00 00 00       	mov    $0x3,%esi
  800bed:	48 89 c7             	mov    %rax,%rdi
  800bf0:	48 b8 d5 05 80 00 00 	movabs $0x8005d5,%rax
  800bf7:	00 00 00 
  800bfa:	ff d0                	callq  *%rax
  800bfc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800c00:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800c07:	e9 85 00 00 00       	jmpq   800c91 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c0c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c10:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c14:	48 89 d6             	mov    %rdx,%rsi
  800c17:	bf 30 00 00 00       	mov    $0x30,%edi
  800c1c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c26:	48 89 d6             	mov    %rdx,%rsi
  800c29:	bf 78 00 00 00       	mov    $0x78,%edi
  800c2e:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c30:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c33:	83 f8 30             	cmp    $0x30,%eax
  800c36:	73 17                	jae    800c4f <vprintfmt+0x45a>
  800c38:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c3c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3f:	89 c0                	mov    %eax,%eax
  800c41:	48 01 d0             	add    %rdx,%rax
  800c44:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c47:	83 c2 08             	add    $0x8,%edx
  800c4a:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c4d:	eb 0f                	jmp    800c5e <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800c4f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c53:	48 89 d0             	mov    %rdx,%rax
  800c56:	48 83 c2 08          	add    $0x8,%rdx
  800c5a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c5e:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c61:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c65:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c6c:	eb 23                	jmp    800c91 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c6e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c72:	be 03 00 00 00       	mov    $0x3,%esi
  800c77:	48 89 c7             	mov    %rax,%rdi
  800c7a:	48 b8 d5 05 80 00 00 	movabs $0x8005d5,%rax
  800c81:	00 00 00 
  800c84:	ff d0                	callq  *%rax
  800c86:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c8a:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c91:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c96:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800c99:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800c9c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ca0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ca4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca8:	45 89 c1             	mov    %r8d,%r9d
  800cab:	41 89 f8             	mov    %edi,%r8d
  800cae:	48 89 c7             	mov    %rax,%rdi
  800cb1:	48 b8 1a 05 80 00 00 	movabs $0x80051a,%rax
  800cb8:	00 00 00 
  800cbb:	ff d0                	callq  *%rax
			break;
  800cbd:	eb 3f                	jmp    800cfe <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cbf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cc3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc7:	48 89 d6             	mov    %rdx,%rsi
  800cca:	89 df                	mov    %ebx,%edi
  800ccc:	ff d0                	callq  *%rax
			break;
  800cce:	eb 2e                	jmp    800cfe <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cd0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cd4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd8:	48 89 d6             	mov    %rdx,%rsi
  800cdb:	bf 25 00 00 00       	mov    $0x25,%edi
  800ce0:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ce2:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800ce7:	eb 05                	jmp    800cee <vprintfmt+0x4f9>
  800ce9:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cee:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cf2:	48 83 e8 01          	sub    $0x1,%rax
  800cf6:	0f b6 00             	movzbl (%rax),%eax
  800cf9:	3c 25                	cmp    $0x25,%al
  800cfb:	75 ec                	jne    800ce9 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800cfd:	90                   	nop
		}
	}
  800cfe:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cff:	e9 43 fb ff ff       	jmpq   800847 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d04:	48 83 c4 60          	add    $0x60,%rsp
  800d08:	5b                   	pop    %rbx
  800d09:	41 5c                	pop    %r12
  800d0b:	5d                   	pop    %rbp
  800d0c:	c3                   	retq   

0000000000800d0d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d0d:	55                   	push   %rbp
  800d0e:	48 89 e5             	mov    %rsp,%rbp
  800d11:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d18:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d1f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d26:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d2d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d34:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 20                	je     800d5f <printfmt+0x52>
  800d3f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d43:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d47:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d4b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d4f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d53:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d57:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d5b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d5f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d66:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d6d:	00 00 00 
  800d70:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d77:	00 00 00 
  800d7a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d7e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d85:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d8c:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d93:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800d9a:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800da1:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800da8:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800daf:	48 89 c7             	mov    %rax,%rdi
  800db2:	48 b8 f5 07 80 00 00 	movabs $0x8007f5,%rax
  800db9:	00 00 00 
  800dbc:	ff d0                	callq  *%rax
	va_end(ap);
}
  800dbe:	c9                   	leaveq 
  800dbf:	c3                   	retq   

0000000000800dc0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dc0:	55                   	push   %rbp
  800dc1:	48 89 e5             	mov    %rsp,%rbp
  800dc4:	48 83 ec 10          	sub    $0x10,%rsp
  800dc8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dcb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800dcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dd3:	8b 40 10             	mov    0x10(%rax),%eax
  800dd6:	8d 50 01             	lea    0x1(%rax),%edx
  800dd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ddd:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800de0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800de4:	48 8b 10             	mov    (%rax),%rdx
  800de7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800deb:	48 8b 40 08          	mov    0x8(%rax),%rax
  800def:	48 39 c2             	cmp    %rax,%rdx
  800df2:	73 17                	jae    800e0b <sprintputch+0x4b>
		*b->buf++ = ch;
  800df4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df8:	48 8b 00             	mov    (%rax),%rax
  800dfb:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800dff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e03:	48 89 0a             	mov    %rcx,(%rdx)
  800e06:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e09:	88 10                	mov    %dl,(%rax)
}
  800e0b:	c9                   	leaveq 
  800e0c:	c3                   	retq   

0000000000800e0d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e0d:	55                   	push   %rbp
  800e0e:	48 89 e5             	mov    %rsp,%rbp
  800e11:	48 83 ec 50          	sub    $0x50,%rsp
  800e15:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e19:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e1c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e20:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e24:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e28:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e2c:	48 8b 0a             	mov    (%rdx),%rcx
  800e2f:	48 89 08             	mov    %rcx,(%rax)
  800e32:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e36:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e3a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e3e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e42:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e46:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e4a:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e4d:	48 98                	cltq   
  800e4f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e53:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e57:	48 01 d0             	add    %rdx,%rax
  800e5a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e65:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e6a:	74 06                	je     800e72 <vsnprintf+0x65>
  800e6c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e70:	7f 07                	jg     800e79 <vsnprintf+0x6c>
		return -E_INVAL;
  800e72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e77:	eb 2f                	jmp    800ea8 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e79:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e7d:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e81:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e85:	48 89 c6             	mov    %rax,%rsi
  800e88:	48 bf c0 0d 80 00 00 	movabs $0x800dc0,%rdi
  800e8f:	00 00 00 
  800e92:	48 b8 f5 07 80 00 00 	movabs $0x8007f5,%rax
  800e99:	00 00 00 
  800e9c:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800e9e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ea2:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ea5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ea8:	c9                   	leaveq 
  800ea9:	c3                   	retq   

0000000000800eaa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eaa:	55                   	push   %rbp
  800eab:	48 89 e5             	mov    %rsp,%rbp
  800eae:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800eb5:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ebc:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ec2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ec9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ed0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800ed7:	84 c0                	test   %al,%al
  800ed9:	74 20                	je     800efb <snprintf+0x51>
  800edb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800edf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800ee3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800ee7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800eeb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800eef:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ef3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ef7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800efb:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f02:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f09:	00 00 00 
  800f0c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f13:	00 00 00 
  800f16:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f1a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f21:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f28:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f2f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f36:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f3d:	48 8b 0a             	mov    (%rdx),%rcx
  800f40:	48 89 08             	mov    %rcx,(%rax)
  800f43:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f47:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f4b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f4f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f53:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f5a:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f61:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f67:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f6e:	48 89 c7             	mov    %rax,%rdi
  800f71:	48 b8 0d 0e 80 00 00 	movabs $0x800e0d,%rax
  800f78:	00 00 00 
  800f7b:	ff d0                	callq  *%rax
  800f7d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f83:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f89:	c9                   	leaveq 
  800f8a:	c3                   	retq   

0000000000800f8b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f8b:	55                   	push   %rbp
  800f8c:	48 89 e5             	mov    %rsp,%rbp
  800f8f:	48 83 ec 18          	sub    $0x18,%rsp
  800f93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f9e:	eb 09                	jmp    800fa9 <strlen+0x1e>
		n++;
  800fa0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fa4:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fad:	0f b6 00             	movzbl (%rax),%eax
  800fb0:	84 c0                	test   %al,%al
  800fb2:	75 ec                	jne    800fa0 <strlen+0x15>
		n++;
	return n;
  800fb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fb7:	c9                   	leaveq 
  800fb8:	c3                   	retq   

0000000000800fb9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fb9:	55                   	push   %rbp
  800fba:	48 89 e5             	mov    %rsp,%rbp
  800fbd:	48 83 ec 20          	sub    $0x20,%rsp
  800fc1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fc5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fd0:	eb 0e                	jmp    800fe0 <strnlen+0x27>
		n++;
  800fd2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fd6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fdb:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800fe0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800fe5:	74 0b                	je     800ff2 <strnlen+0x39>
  800fe7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800feb:	0f b6 00             	movzbl (%rax),%eax
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 e0                	jne    800fd2 <strnlen+0x19>
		n++;
	return n;
  800ff2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ff5:	c9                   	leaveq 
  800ff6:	c3                   	retq   

0000000000800ff7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ff7:	55                   	push   %rbp
  800ff8:	48 89 e5             	mov    %rsp,%rbp
  800ffb:	48 83 ec 20          	sub    $0x20,%rsp
  800fff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801003:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801007:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80100b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80100f:	90                   	nop
  801010:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801014:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801018:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80101c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801020:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801024:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801028:	0f b6 12             	movzbl (%rdx),%edx
  80102b:	88 10                	mov    %dl,(%rax)
  80102d:	0f b6 00             	movzbl (%rax),%eax
  801030:	84 c0                	test   %al,%al
  801032:	75 dc                	jne    801010 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801034:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801038:	c9                   	leaveq 
  801039:	c3                   	retq   

000000000080103a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80103a:	55                   	push   %rbp
  80103b:	48 89 e5             	mov    %rsp,%rbp
  80103e:	48 83 ec 20          	sub    $0x20,%rsp
  801042:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801046:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80104a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104e:	48 89 c7             	mov    %rax,%rdi
  801051:	48 b8 8b 0f 80 00 00 	movabs $0x800f8b,%rax
  801058:	00 00 00 
  80105b:	ff d0                	callq  *%rax
  80105d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801060:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801063:	48 63 d0             	movslq %eax,%rdx
  801066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106a:	48 01 c2             	add    %rax,%rdx
  80106d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801071:	48 89 c6             	mov    %rax,%rsi
  801074:	48 89 d7             	mov    %rdx,%rdi
  801077:	48 b8 f7 0f 80 00 00 	movabs $0x800ff7,%rax
  80107e:	00 00 00 
  801081:	ff d0                	callq  *%rax
	return dst;
  801083:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801087:	c9                   	leaveq 
  801088:	c3                   	retq   

0000000000801089 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801089:	55                   	push   %rbp
  80108a:	48 89 e5             	mov    %rsp,%rbp
  80108d:	48 83 ec 28          	sub    $0x28,%rsp
  801091:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801095:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801099:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80109d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010a5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010ac:	00 
  8010ad:	eb 2a                	jmp    8010d9 <strncpy+0x50>
		*dst++ = *src;
  8010af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010b7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010bb:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010bf:	0f b6 12             	movzbl (%rdx),%edx
  8010c2:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010c8:	0f b6 00             	movzbl (%rax),%eax
  8010cb:	84 c0                	test   %al,%al
  8010cd:	74 05                	je     8010d4 <strncpy+0x4b>
			src++;
  8010cf:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010dd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010e1:	72 cc                	jb     8010af <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010e7:	c9                   	leaveq 
  8010e8:	c3                   	retq   

00000000008010e9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010e9:	55                   	push   %rbp
  8010ea:	48 89 e5             	mov    %rsp,%rbp
  8010ed:	48 83 ec 28          	sub    $0x28,%rsp
  8010f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8010fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801101:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801105:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80110a:	74 3d                	je     801149 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80110c:	eb 1d                	jmp    80112b <strlcpy+0x42>
			*dst++ = *src++;
  80110e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801112:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801116:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80111a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80111e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801122:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801126:	0f b6 12             	movzbl (%rdx),%edx
  801129:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80112b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801130:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801135:	74 0b                	je     801142 <strlcpy+0x59>
  801137:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80113b:	0f b6 00             	movzbl (%rax),%eax
  80113e:	84 c0                	test   %al,%al
  801140:	75 cc                	jne    80110e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801146:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801149:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80114d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801151:	48 29 c2             	sub    %rax,%rdx
  801154:	48 89 d0             	mov    %rdx,%rax
}
  801157:	c9                   	leaveq 
  801158:	c3                   	retq   

0000000000801159 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801159:	55                   	push   %rbp
  80115a:	48 89 e5             	mov    %rsp,%rbp
  80115d:	48 83 ec 10          	sub    $0x10,%rsp
  801161:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801165:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801169:	eb 0a                	jmp    801175 <strcmp+0x1c>
		p++, q++;
  80116b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801170:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801175:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801179:	0f b6 00             	movzbl (%rax),%eax
  80117c:	84 c0                	test   %al,%al
  80117e:	74 12                	je     801192 <strcmp+0x39>
  801180:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801184:	0f b6 10             	movzbl (%rax),%edx
  801187:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80118b:	0f b6 00             	movzbl (%rax),%eax
  80118e:	38 c2                	cmp    %al,%dl
  801190:	74 d9                	je     80116b <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801192:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801196:	0f b6 00             	movzbl (%rax),%eax
  801199:	0f b6 d0             	movzbl %al,%edx
  80119c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a0:	0f b6 00             	movzbl (%rax),%eax
  8011a3:	0f b6 c0             	movzbl %al,%eax
  8011a6:	29 c2                	sub    %eax,%edx
  8011a8:	89 d0                	mov    %edx,%eax
}
  8011aa:	c9                   	leaveq 
  8011ab:	c3                   	retq   

00000000008011ac <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011ac:	55                   	push   %rbp
  8011ad:	48 89 e5             	mov    %rsp,%rbp
  8011b0:	48 83 ec 18          	sub    $0x18,%rsp
  8011b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011c0:	eb 0f                	jmp    8011d1 <strncmp+0x25>
		n--, p++, q++;
  8011c2:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011cc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011d1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011d6:	74 1d                	je     8011f5 <strncmp+0x49>
  8011d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011dc:	0f b6 00             	movzbl (%rax),%eax
  8011df:	84 c0                	test   %al,%al
  8011e1:	74 12                	je     8011f5 <strncmp+0x49>
  8011e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e7:	0f b6 10             	movzbl (%rax),%edx
  8011ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ee:	0f b6 00             	movzbl (%rax),%eax
  8011f1:	38 c2                	cmp    %al,%dl
  8011f3:	74 cd                	je     8011c2 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011fa:	75 07                	jne    801203 <strncmp+0x57>
		return 0;
  8011fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801201:	eb 18                	jmp    80121b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801203:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801207:	0f b6 00             	movzbl (%rax),%eax
  80120a:	0f b6 d0             	movzbl %al,%edx
  80120d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801211:	0f b6 00             	movzbl (%rax),%eax
  801214:	0f b6 c0             	movzbl %al,%eax
  801217:	29 c2                	sub    %eax,%edx
  801219:	89 d0                	mov    %edx,%eax
}
  80121b:	c9                   	leaveq 
  80121c:	c3                   	retq   

000000000080121d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80121d:	55                   	push   %rbp
  80121e:	48 89 e5             	mov    %rsp,%rbp
  801221:	48 83 ec 0c          	sub    $0xc,%rsp
  801225:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801229:	89 f0                	mov    %esi,%eax
  80122b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80122e:	eb 17                	jmp    801247 <strchr+0x2a>
		if (*s == c)
  801230:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801234:	0f b6 00             	movzbl (%rax),%eax
  801237:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80123a:	75 06                	jne    801242 <strchr+0x25>
			return (char *) s;
  80123c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801240:	eb 15                	jmp    801257 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801242:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80124b:	0f b6 00             	movzbl (%rax),%eax
  80124e:	84 c0                	test   %al,%al
  801250:	75 de                	jne    801230 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801252:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801257:	c9                   	leaveq 
  801258:	c3                   	retq   

0000000000801259 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801259:	55                   	push   %rbp
  80125a:	48 89 e5             	mov    %rsp,%rbp
  80125d:	48 83 ec 0c          	sub    $0xc,%rsp
  801261:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801265:	89 f0                	mov    %esi,%eax
  801267:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80126a:	eb 13                	jmp    80127f <strfind+0x26>
		if (*s == c)
  80126c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801270:	0f b6 00             	movzbl (%rax),%eax
  801273:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801276:	75 02                	jne    80127a <strfind+0x21>
			break;
  801278:	eb 10                	jmp    80128a <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80127a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80127f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801283:	0f b6 00             	movzbl (%rax),%eax
  801286:	84 c0                	test   %al,%al
  801288:	75 e2                	jne    80126c <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80128e:	c9                   	leaveq 
  80128f:	c3                   	retq   

0000000000801290 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801290:	55                   	push   %rbp
  801291:	48 89 e5             	mov    %rsp,%rbp
  801294:	48 83 ec 18          	sub    $0x18,%rsp
  801298:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80129c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80129f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012a3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012a8:	75 06                	jne    8012b0 <memset+0x20>
		return v;
  8012aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ae:	eb 69                	jmp    801319 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b4:	83 e0 03             	and    $0x3,%eax
  8012b7:	48 85 c0             	test   %rax,%rax
  8012ba:	75 48                	jne    801304 <memset+0x74>
  8012bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c0:	83 e0 03             	and    $0x3,%eax
  8012c3:	48 85 c0             	test   %rax,%rax
  8012c6:	75 3c                	jne    801304 <memset+0x74>
		c &= 0xFF;
  8012c8:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012d2:	c1 e0 18             	shl    $0x18,%eax
  8012d5:	89 c2                	mov    %eax,%edx
  8012d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012da:	c1 e0 10             	shl    $0x10,%eax
  8012dd:	09 c2                	or     %eax,%edx
  8012df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012e2:	c1 e0 08             	shl    $0x8,%eax
  8012e5:	09 d0                	or     %edx,%eax
  8012e7:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8012ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ee:	48 c1 e8 02          	shr    $0x2,%rax
  8012f2:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012fc:	48 89 d7             	mov    %rdx,%rdi
  8012ff:	fc                   	cld    
  801300:	f3 ab                	rep stos %eax,%es:(%rdi)
  801302:	eb 11                	jmp    801315 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801304:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801308:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80130f:	48 89 d7             	mov    %rdx,%rdi
  801312:	fc                   	cld    
  801313:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801319:	c9                   	leaveq 
  80131a:	c3                   	retq   

000000000080131b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80131b:	55                   	push   %rbp
  80131c:	48 89 e5             	mov    %rsp,%rbp
  80131f:	48 83 ec 28          	sub    $0x28,%rsp
  801323:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801327:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80132b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80132f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801333:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801337:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80133b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80133f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801343:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801347:	0f 83 88 00 00 00    	jae    8013d5 <memmove+0xba>
  80134d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801351:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801355:	48 01 d0             	add    %rdx,%rax
  801358:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80135c:	76 77                	jbe    8013d5 <memmove+0xba>
		s += n;
  80135e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801362:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80136e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801372:	83 e0 03             	and    $0x3,%eax
  801375:	48 85 c0             	test   %rax,%rax
  801378:	75 3b                	jne    8013b5 <memmove+0x9a>
  80137a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80137e:	83 e0 03             	and    $0x3,%eax
  801381:	48 85 c0             	test   %rax,%rax
  801384:	75 2f                	jne    8013b5 <memmove+0x9a>
  801386:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138a:	83 e0 03             	and    $0x3,%eax
  80138d:	48 85 c0             	test   %rax,%rax
  801390:	75 23                	jne    8013b5 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801392:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801396:	48 83 e8 04          	sub    $0x4,%rax
  80139a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80139e:	48 83 ea 04          	sub    $0x4,%rdx
  8013a2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013a6:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013aa:	48 89 c7             	mov    %rax,%rdi
  8013ad:	48 89 d6             	mov    %rdx,%rsi
  8013b0:	fd                   	std    
  8013b1:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013b3:	eb 1d                	jmp    8013d2 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c1:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c9:	48 89 d7             	mov    %rdx,%rdi
  8013cc:	48 89 c1             	mov    %rax,%rcx
  8013cf:	fd                   	std    
  8013d0:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013d2:	fc                   	cld    
  8013d3:	eb 57                	jmp    80142c <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d9:	83 e0 03             	and    $0x3,%eax
  8013dc:	48 85 c0             	test   %rax,%rax
  8013df:	75 36                	jne    801417 <memmove+0xfc>
  8013e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e5:	83 e0 03             	and    $0x3,%eax
  8013e8:	48 85 c0             	test   %rax,%rax
  8013eb:	75 2a                	jne    801417 <memmove+0xfc>
  8013ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f1:	83 e0 03             	and    $0x3,%eax
  8013f4:	48 85 c0             	test   %rax,%rax
  8013f7:	75 1e                	jne    801417 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8013f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013fd:	48 c1 e8 02          	shr    $0x2,%rax
  801401:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801404:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801408:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80140c:	48 89 c7             	mov    %rax,%rdi
  80140f:	48 89 d6             	mov    %rdx,%rsi
  801412:	fc                   	cld    
  801413:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801415:	eb 15                	jmp    80142c <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80141f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801423:	48 89 c7             	mov    %rax,%rdi
  801426:	48 89 d6             	mov    %rdx,%rsi
  801429:	fc                   	cld    
  80142a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80142c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801430:	c9                   	leaveq 
  801431:	c3                   	retq   

0000000000801432 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801432:	55                   	push   %rbp
  801433:	48 89 e5             	mov    %rsp,%rbp
  801436:	48 83 ec 18          	sub    $0x18,%rsp
  80143a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80143e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801442:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801446:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80144a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80144e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801452:	48 89 ce             	mov    %rcx,%rsi
  801455:	48 89 c7             	mov    %rax,%rdi
  801458:	48 b8 1b 13 80 00 00 	movabs $0x80131b,%rax
  80145f:	00 00 00 
  801462:	ff d0                	callq  *%rax
}
  801464:	c9                   	leaveq 
  801465:	c3                   	retq   

0000000000801466 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801466:	55                   	push   %rbp
  801467:	48 89 e5             	mov    %rsp,%rbp
  80146a:	48 83 ec 28          	sub    $0x28,%rsp
  80146e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801472:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801476:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80147a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801482:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801486:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80148a:	eb 36                	jmp    8014c2 <memcmp+0x5c>
		if (*s1 != *s2)
  80148c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801490:	0f b6 10             	movzbl (%rax),%edx
  801493:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801497:	0f b6 00             	movzbl (%rax),%eax
  80149a:	38 c2                	cmp    %al,%dl
  80149c:	74 1a                	je     8014b8 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80149e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014a2:	0f b6 00             	movzbl (%rax),%eax
  8014a5:	0f b6 d0             	movzbl %al,%edx
  8014a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ac:	0f b6 00             	movzbl (%rax),%eax
  8014af:	0f b6 c0             	movzbl %al,%eax
  8014b2:	29 c2                	sub    %eax,%edx
  8014b4:	89 d0                	mov    %edx,%eax
  8014b6:	eb 20                	jmp    8014d8 <memcmp+0x72>
		s1++, s2++;
  8014b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014bd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014c6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014ce:	48 85 c0             	test   %rax,%rax
  8014d1:	75 b9                	jne    80148c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d8:	c9                   	leaveq 
  8014d9:	c3                   	retq   

00000000008014da <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014da:	55                   	push   %rbp
  8014db:	48 89 e5             	mov    %rsp,%rbp
  8014de:	48 83 ec 28          	sub    $0x28,%rsp
  8014e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014f5:	48 01 d0             	add    %rdx,%rax
  8014f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8014fc:	eb 15                	jmp    801513 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801502:	0f b6 10             	movzbl (%rax),%edx
  801505:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801508:	38 c2                	cmp    %al,%dl
  80150a:	75 02                	jne    80150e <memfind+0x34>
			break;
  80150c:	eb 0f                	jmp    80151d <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80150e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801513:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801517:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80151b:	72 e1                	jb     8014fe <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80151d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801521:	c9                   	leaveq 
  801522:	c3                   	retq   

0000000000801523 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801523:	55                   	push   %rbp
  801524:	48 89 e5             	mov    %rsp,%rbp
  801527:	48 83 ec 34          	sub    $0x34,%rsp
  80152b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80152f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801533:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801536:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80153d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801544:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801545:	eb 05                	jmp    80154c <strtol+0x29>
		s++;
  801547:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80154c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801550:	0f b6 00             	movzbl (%rax),%eax
  801553:	3c 20                	cmp    $0x20,%al
  801555:	74 f0                	je     801547 <strtol+0x24>
  801557:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80155b:	0f b6 00             	movzbl (%rax),%eax
  80155e:	3c 09                	cmp    $0x9,%al
  801560:	74 e5                	je     801547 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801562:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801566:	0f b6 00             	movzbl (%rax),%eax
  801569:	3c 2b                	cmp    $0x2b,%al
  80156b:	75 07                	jne    801574 <strtol+0x51>
		s++;
  80156d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801572:	eb 17                	jmp    80158b <strtol+0x68>
	else if (*s == '-')
  801574:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801578:	0f b6 00             	movzbl (%rax),%eax
  80157b:	3c 2d                	cmp    $0x2d,%al
  80157d:	75 0c                	jne    80158b <strtol+0x68>
		s++, neg = 1;
  80157f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801584:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80158b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80158f:	74 06                	je     801597 <strtol+0x74>
  801591:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801595:	75 28                	jne    8015bf <strtol+0x9c>
  801597:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80159b:	0f b6 00             	movzbl (%rax),%eax
  80159e:	3c 30                	cmp    $0x30,%al
  8015a0:	75 1d                	jne    8015bf <strtol+0x9c>
  8015a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a6:	48 83 c0 01          	add    $0x1,%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	3c 78                	cmp    $0x78,%al
  8015af:	75 0e                	jne    8015bf <strtol+0x9c>
		s += 2, base = 16;
  8015b1:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015b6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015bd:	eb 2c                	jmp    8015eb <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015bf:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015c3:	75 19                	jne    8015de <strtol+0xbb>
  8015c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c9:	0f b6 00             	movzbl (%rax),%eax
  8015cc:	3c 30                	cmp    $0x30,%al
  8015ce:	75 0e                	jne    8015de <strtol+0xbb>
		s++, base = 8;
  8015d0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015d5:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015dc:	eb 0d                	jmp    8015eb <strtol+0xc8>
	else if (base == 0)
  8015de:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015e2:	75 07                	jne    8015eb <strtol+0xc8>
		base = 10;
  8015e4:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ef:	0f b6 00             	movzbl (%rax),%eax
  8015f2:	3c 2f                	cmp    $0x2f,%al
  8015f4:	7e 1d                	jle    801613 <strtol+0xf0>
  8015f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fa:	0f b6 00             	movzbl (%rax),%eax
  8015fd:	3c 39                	cmp    $0x39,%al
  8015ff:	7f 12                	jg     801613 <strtol+0xf0>
			dig = *s - '0';
  801601:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801605:	0f b6 00             	movzbl (%rax),%eax
  801608:	0f be c0             	movsbl %al,%eax
  80160b:	83 e8 30             	sub    $0x30,%eax
  80160e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801611:	eb 4e                	jmp    801661 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801613:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801617:	0f b6 00             	movzbl (%rax),%eax
  80161a:	3c 60                	cmp    $0x60,%al
  80161c:	7e 1d                	jle    80163b <strtol+0x118>
  80161e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801622:	0f b6 00             	movzbl (%rax),%eax
  801625:	3c 7a                	cmp    $0x7a,%al
  801627:	7f 12                	jg     80163b <strtol+0x118>
			dig = *s - 'a' + 10;
  801629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162d:	0f b6 00             	movzbl (%rax),%eax
  801630:	0f be c0             	movsbl %al,%eax
  801633:	83 e8 57             	sub    $0x57,%eax
  801636:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801639:	eb 26                	jmp    801661 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80163b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80163f:	0f b6 00             	movzbl (%rax),%eax
  801642:	3c 40                	cmp    $0x40,%al
  801644:	7e 48                	jle    80168e <strtol+0x16b>
  801646:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164a:	0f b6 00             	movzbl (%rax),%eax
  80164d:	3c 5a                	cmp    $0x5a,%al
  80164f:	7f 3d                	jg     80168e <strtol+0x16b>
			dig = *s - 'A' + 10;
  801651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801655:	0f b6 00             	movzbl (%rax),%eax
  801658:	0f be c0             	movsbl %al,%eax
  80165b:	83 e8 37             	sub    $0x37,%eax
  80165e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801661:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801664:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801667:	7c 02                	jl     80166b <strtol+0x148>
			break;
  801669:	eb 23                	jmp    80168e <strtol+0x16b>
		s++, val = (val * base) + dig;
  80166b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801670:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801673:	48 98                	cltq   
  801675:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80167a:	48 89 c2             	mov    %rax,%rdx
  80167d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801680:	48 98                	cltq   
  801682:	48 01 d0             	add    %rdx,%rax
  801685:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801689:	e9 5d ff ff ff       	jmpq   8015eb <strtol+0xc8>

	if (endptr)
  80168e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801693:	74 0b                	je     8016a0 <strtol+0x17d>
		*endptr = (char *) s;
  801695:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801699:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80169d:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016a4:	74 09                	je     8016af <strtol+0x18c>
  8016a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016aa:	48 f7 d8             	neg    %rax
  8016ad:	eb 04                	jmp    8016b3 <strtol+0x190>
  8016af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016b3:	c9                   	leaveq 
  8016b4:	c3                   	retq   

00000000008016b5 <strstr>:

char * strstr(const char *in, const char *str)
{
  8016b5:	55                   	push   %rbp
  8016b6:	48 89 e5             	mov    %rsp,%rbp
  8016b9:	48 83 ec 30          	sub    $0x30,%rsp
  8016bd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016cd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016d1:	0f b6 00             	movzbl (%rax),%eax
  8016d4:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8016d7:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016db:	75 06                	jne    8016e3 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8016dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e1:	eb 6b                	jmp    80174e <strstr+0x99>

	len = strlen(str);
  8016e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016e7:	48 89 c7             	mov    %rax,%rdi
  8016ea:	48 b8 8b 0f 80 00 00 	movabs $0x800f8b,%rax
  8016f1:	00 00 00 
  8016f4:	ff d0                	callq  *%rax
  8016f6:	48 98                	cltq   
  8016f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8016fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801700:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801704:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801708:	0f b6 00             	movzbl (%rax),%eax
  80170b:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80170e:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801712:	75 07                	jne    80171b <strstr+0x66>
				return (char *) 0;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
  801719:	eb 33                	jmp    80174e <strstr+0x99>
		} while (sc != c);
  80171b:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80171f:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801722:	75 d8                	jne    8016fc <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801724:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801728:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80172c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801730:	48 89 ce             	mov    %rcx,%rsi
  801733:	48 89 c7             	mov    %rax,%rdi
  801736:	48 b8 ac 11 80 00 00 	movabs $0x8011ac,%rax
  80173d:	00 00 00 
  801740:	ff d0                	callq  *%rax
  801742:	85 c0                	test   %eax,%eax
  801744:	75 b6                	jne    8016fc <strstr+0x47>

	return (char *) (in - 1);
  801746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174a:	48 83 e8 01          	sub    $0x1,%rax
}
  80174e:	c9                   	leaveq 
  80174f:	c3                   	retq   

0000000000801750 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801750:	55                   	push   %rbp
  801751:	48 89 e5             	mov    %rsp,%rbp
  801754:	53                   	push   %rbx
  801755:	48 83 ec 48          	sub    $0x48,%rsp
  801759:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80175c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80175f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801763:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801767:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80176b:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  80176f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801772:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801776:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80177a:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80177e:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801782:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801786:	4c 89 c3             	mov    %r8,%rbx
  801789:	cd 30                	int    $0x30
  80178b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  80178f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801793:	74 3e                	je     8017d3 <syscall+0x83>
  801795:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80179a:	7e 37                	jle    8017d3 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80179c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017a0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017a3:	49 89 d0             	mov    %rdx,%r8
  8017a6:	89 c1                	mov    %eax,%ecx
  8017a8:	48 ba 88 3c 80 00 00 	movabs $0x803c88,%rdx
  8017af:	00 00 00 
  8017b2:	be 4a 00 00 00       	mov    $0x4a,%esi
  8017b7:	48 bf a5 3c 80 00 00 	movabs $0x803ca5,%rdi
  8017be:	00 00 00 
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c6:	49 b9 09 02 80 00 00 	movabs $0x800209,%r9
  8017cd:	00 00 00 
  8017d0:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8017d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017d7:	48 83 c4 48          	add    $0x48,%rsp
  8017db:	5b                   	pop    %rbx
  8017dc:	5d                   	pop    %rbp
  8017dd:	c3                   	retq   

00000000008017de <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017de:	55                   	push   %rbp
  8017df:	48 89 e5             	mov    %rsp,%rbp
  8017e2:	48 83 ec 20          	sub    $0x20,%rsp
  8017e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017f6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8017fd:	00 
  8017fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801804:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80180a:	48 89 d1             	mov    %rdx,%rcx
  80180d:	48 89 c2             	mov    %rax,%rdx
  801810:	be 00 00 00 00       	mov    $0x0,%esi
  801815:	bf 00 00 00 00       	mov    $0x0,%edi
  80181a:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801821:	00 00 00 
  801824:	ff d0                	callq  *%rax
}
  801826:	c9                   	leaveq 
  801827:	c3                   	retq   

0000000000801828 <sys_cgetc>:

int
sys_cgetc(void)
{
  801828:	55                   	push   %rbp
  801829:	48 89 e5             	mov    %rsp,%rbp
  80182c:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801830:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801837:	00 
  801838:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80183e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801844:	b9 00 00 00 00       	mov    $0x0,%ecx
  801849:	ba 00 00 00 00       	mov    $0x0,%edx
  80184e:	be 00 00 00 00       	mov    $0x0,%esi
  801853:	bf 01 00 00 00       	mov    $0x1,%edi
  801858:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  80185f:	00 00 00 
  801862:	ff d0                	callq  *%rax
}
  801864:	c9                   	leaveq 
  801865:	c3                   	retq   

0000000000801866 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801866:	55                   	push   %rbp
  801867:	48 89 e5             	mov    %rsp,%rbp
  80186a:	48 83 ec 10          	sub    $0x10,%rsp
  80186e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801871:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801874:	48 98                	cltq   
  801876:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80187d:	00 
  80187e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801884:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80188a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80188f:	48 89 c2             	mov    %rax,%rdx
  801892:	be 01 00 00 00       	mov    $0x1,%esi
  801897:	bf 03 00 00 00       	mov    $0x3,%edi
  80189c:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  8018a3:	00 00 00 
  8018a6:	ff d0                	callq  *%rax
}
  8018a8:	c9                   	leaveq 
  8018a9:	c3                   	retq   

00000000008018aa <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018aa:	55                   	push   %rbp
  8018ab:	48 89 e5             	mov    %rsp,%rbp
  8018ae:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018b2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018b9:	00 
  8018ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d0:	be 00 00 00 00       	mov    $0x0,%esi
  8018d5:	bf 02 00 00 00       	mov    $0x2,%edi
  8018da:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  8018e1:	00 00 00 
  8018e4:	ff d0                	callq  *%rax
}
  8018e6:	c9                   	leaveq 
  8018e7:	c3                   	retq   

00000000008018e8 <sys_yield>:

void
sys_yield(void)
{
  8018e8:	55                   	push   %rbp
  8018e9:	48 89 e5             	mov    %rsp,%rbp
  8018ec:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018f0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f7:	00 
  8018f8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018fe:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801904:	b9 00 00 00 00       	mov    $0x0,%ecx
  801909:	ba 00 00 00 00       	mov    $0x0,%edx
  80190e:	be 00 00 00 00       	mov    $0x0,%esi
  801913:	bf 0b 00 00 00       	mov    $0xb,%edi
  801918:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  80191f:	00 00 00 
  801922:	ff d0                	callq  *%rax
}
  801924:	c9                   	leaveq 
  801925:	c3                   	retq   

0000000000801926 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801926:	55                   	push   %rbp
  801927:	48 89 e5             	mov    %rsp,%rbp
  80192a:	48 83 ec 20          	sub    $0x20,%rsp
  80192e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801931:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801935:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801938:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80193b:	48 63 c8             	movslq %eax,%rcx
  80193e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801942:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801945:	48 98                	cltq   
  801947:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194e:	00 
  80194f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801955:	49 89 c8             	mov    %rcx,%r8
  801958:	48 89 d1             	mov    %rdx,%rcx
  80195b:	48 89 c2             	mov    %rax,%rdx
  80195e:	be 01 00 00 00       	mov    $0x1,%esi
  801963:	bf 04 00 00 00       	mov    $0x4,%edi
  801968:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  80196f:	00 00 00 
  801972:	ff d0                	callq  *%rax
}
  801974:	c9                   	leaveq 
  801975:	c3                   	retq   

0000000000801976 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801976:	55                   	push   %rbp
  801977:	48 89 e5             	mov    %rsp,%rbp
  80197a:	48 83 ec 30          	sub    $0x30,%rsp
  80197e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801981:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801985:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801988:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80198c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801990:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801993:	48 63 c8             	movslq %eax,%rcx
  801996:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80199a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80199d:	48 63 f0             	movslq %eax,%rsi
  8019a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019a7:	48 98                	cltq   
  8019a9:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019ad:	49 89 f9             	mov    %rdi,%r9
  8019b0:	49 89 f0             	mov    %rsi,%r8
  8019b3:	48 89 d1             	mov    %rdx,%rcx
  8019b6:	48 89 c2             	mov    %rax,%rdx
  8019b9:	be 01 00 00 00       	mov    $0x1,%esi
  8019be:	bf 05 00 00 00       	mov    $0x5,%edi
  8019c3:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  8019ca:	00 00 00 
  8019cd:	ff d0                	callq  *%rax
}
  8019cf:	c9                   	leaveq 
  8019d0:	c3                   	retq   

00000000008019d1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019d1:	55                   	push   %rbp
  8019d2:	48 89 e5             	mov    %rsp,%rbp
  8019d5:	48 83 ec 20          	sub    $0x20,%rsp
  8019d9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e7:	48 98                	cltq   
  8019e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f0:	00 
  8019f1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019fd:	48 89 d1             	mov    %rdx,%rcx
  801a00:	48 89 c2             	mov    %rax,%rdx
  801a03:	be 01 00 00 00       	mov    $0x1,%esi
  801a08:	bf 06 00 00 00       	mov    $0x6,%edi
  801a0d:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801a14:	00 00 00 
  801a17:	ff d0                	callq  *%rax
}
  801a19:	c9                   	leaveq 
  801a1a:	c3                   	retq   

0000000000801a1b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a1b:	55                   	push   %rbp
  801a1c:	48 89 e5             	mov    %rsp,%rbp
  801a1f:	48 83 ec 10          	sub    $0x10,%rsp
  801a23:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a26:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a29:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a2c:	48 63 d0             	movslq %eax,%rdx
  801a2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a32:	48 98                	cltq   
  801a34:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a3b:	00 
  801a3c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a42:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a48:	48 89 d1             	mov    %rdx,%rcx
  801a4b:	48 89 c2             	mov    %rax,%rdx
  801a4e:	be 01 00 00 00       	mov    $0x1,%esi
  801a53:	bf 08 00 00 00       	mov    $0x8,%edi
  801a58:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801a5f:	00 00 00 
  801a62:	ff d0                	callq  *%rax
}
  801a64:	c9                   	leaveq 
  801a65:	c3                   	retq   

0000000000801a66 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a66:	55                   	push   %rbp
  801a67:	48 89 e5             	mov    %rsp,%rbp
  801a6a:	48 83 ec 20          	sub    $0x20,%rsp
  801a6e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a71:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a75:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a79:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a7c:	48 98                	cltq   
  801a7e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a85:	00 
  801a86:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a8c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a92:	48 89 d1             	mov    %rdx,%rcx
  801a95:	48 89 c2             	mov    %rax,%rdx
  801a98:	be 01 00 00 00       	mov    $0x1,%esi
  801a9d:	bf 09 00 00 00       	mov    $0x9,%edi
  801aa2:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801aa9:	00 00 00 
  801aac:	ff d0                	callq  *%rax
}
  801aae:	c9                   	leaveq 
  801aaf:	c3                   	retq   

0000000000801ab0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ab0:	55                   	push   %rbp
  801ab1:	48 89 e5             	mov    %rsp,%rbp
  801ab4:	48 83 ec 20          	sub    $0x20,%rsp
  801ab8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801abb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801abf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ac6:	48 98                	cltq   
  801ac8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801acf:	00 
  801ad0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801adc:	48 89 d1             	mov    %rdx,%rcx
  801adf:	48 89 c2             	mov    %rax,%rdx
  801ae2:	be 01 00 00 00       	mov    $0x1,%esi
  801ae7:	bf 0a 00 00 00       	mov    $0xa,%edi
  801aec:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801af3:	00 00 00 
  801af6:	ff d0                	callq  *%rax
}
  801af8:	c9                   	leaveq 
  801af9:	c3                   	retq   

0000000000801afa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801afa:	55                   	push   %rbp
  801afb:	48 89 e5             	mov    %rsp,%rbp
  801afe:	48 83 ec 20          	sub    $0x20,%rsp
  801b02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b09:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b0d:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b13:	48 63 f0             	movslq %eax,%rsi
  801b16:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1d:	48 98                	cltq   
  801b1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b23:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2a:	00 
  801b2b:	49 89 f1             	mov    %rsi,%r9
  801b2e:	49 89 c8             	mov    %rcx,%r8
  801b31:	48 89 d1             	mov    %rdx,%rcx
  801b34:	48 89 c2             	mov    %rax,%rdx
  801b37:	be 00 00 00 00       	mov    $0x0,%esi
  801b3c:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b41:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801b48:	00 00 00 
  801b4b:	ff d0                	callq  *%rax
}
  801b4d:	c9                   	leaveq 
  801b4e:	c3                   	retq   

0000000000801b4f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b4f:	55                   	push   %rbp
  801b50:	48 89 e5             	mov    %rsp,%rbp
  801b53:	48 83 ec 10          	sub    $0x10,%rsp
  801b57:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b66:	00 
  801b67:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b6d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b73:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b78:	48 89 c2             	mov    %rax,%rdx
  801b7b:	be 01 00 00 00       	mov    $0x1,%esi
  801b80:	bf 0d 00 00 00       	mov    $0xd,%edi
  801b85:	48 b8 50 17 80 00 00 	movabs $0x801750,%rax
  801b8c:	00 00 00 
  801b8f:	ff d0                	callq  *%rax
}
  801b91:	c9                   	leaveq 
  801b92:	c3                   	retq   

0000000000801b93 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801b93:	55                   	push   %rbp
  801b94:	48 89 e5             	mov    %rsp,%rbp
  801b97:	48 83 ec 10          	sub    $0x10,%rsp
  801b9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  801b9f:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801ba6:	00 00 00 
  801ba9:	48 8b 00             	mov    (%rax),%rax
  801bac:	48 85 c0             	test   %rax,%rax
  801baf:	75 64                	jne    801c15 <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  801bb1:	ba 07 00 00 00       	mov    $0x7,%edx
  801bb6:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801bbb:	bf 00 00 00 00       	mov    $0x0,%edi
  801bc0:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  801bc7:	00 00 00 
  801bca:	ff d0                	callq  *%rax
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	74 2a                	je     801bfa <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  801bd0:	48 ba b8 3c 80 00 00 	movabs $0x803cb8,%rdx
  801bd7:	00 00 00 
  801bda:	be 22 00 00 00       	mov    $0x22,%esi
  801bdf:	48 bf e0 3c 80 00 00 	movabs $0x803ce0,%rdi
  801be6:	00 00 00 
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bee:	48 b9 09 02 80 00 00 	movabs $0x800209,%rcx
  801bf5:	00 00 00 
  801bf8:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801bfa:	48 be 28 1c 80 00 00 	movabs $0x801c28,%rsi
  801c01:	00 00 00 
  801c04:	bf 00 00 00 00       	mov    $0x0,%edi
  801c09:	48 b8 b0 1a 80 00 00 	movabs $0x801ab0,%rax
  801c10:	00 00 00 
  801c13:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801c15:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801c1c:	00 00 00 
  801c1f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c23:	48 89 10             	mov    %rdx,(%rax)
}
  801c26:	c9                   	leaveq 
  801c27:	c3                   	retq   

0000000000801c28 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  801c28:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801c2b:	48 a1 10 60 80 00 00 	movabs 0x806010,%rax
  801c32:	00 00 00 
call *%rax
  801c35:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  801c37:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  801c3e:	00 
mov 136(%rsp), %r9
  801c3f:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  801c46:	00 
sub $8, %r8
  801c47:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  801c4b:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  801c4e:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  801c55:	00 
add $16, %rsp
  801c56:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  801c5a:	4c 8b 3c 24          	mov    (%rsp),%r15
  801c5e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801c63:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801c68:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801c6d:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801c72:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801c77:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801c7c:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801c81:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801c86:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801c8b:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801c90:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801c95:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801c9a:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801c9f:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801ca4:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  801ca8:	48 83 c4 08          	add    $0x8,%rsp
popf
  801cac:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  801cad:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  801cb1:	c3                   	retq   

0000000000801cb2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801cb2:	55                   	push   %rbp
  801cb3:	48 89 e5             	mov    %rsp,%rbp
  801cb6:	48 83 ec 08          	sub    $0x8,%rsp
  801cba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cbe:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cc2:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801cc9:	ff ff ff 
  801ccc:	48 01 d0             	add    %rdx,%rax
  801ccf:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801cd3:	c9                   	leaveq 
  801cd4:	c3                   	retq   

0000000000801cd5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cd5:	55                   	push   %rbp
  801cd6:	48 89 e5             	mov    %rsp,%rbp
  801cd9:	48 83 ec 08          	sub    $0x8,%rsp
  801cdd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801ce1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ce5:	48 89 c7             	mov    %rax,%rdi
  801ce8:	48 b8 b2 1c 80 00 00 	movabs $0x801cb2,%rax
  801cef:	00 00 00 
  801cf2:	ff d0                	callq  *%rax
  801cf4:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801cfa:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801cfe:	c9                   	leaveq 
  801cff:	c3                   	retq   

0000000000801d00 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d00:	55                   	push   %rbp
  801d01:	48 89 e5             	mov    %rsp,%rbp
  801d04:	48 83 ec 18          	sub    $0x18,%rsp
  801d08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d13:	eb 6b                	jmp    801d80 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d18:	48 98                	cltq   
  801d1a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d20:	48 c1 e0 0c          	shl    $0xc,%rax
  801d24:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d2c:	48 c1 e8 15          	shr    $0x15,%rax
  801d30:	48 89 c2             	mov    %rax,%rdx
  801d33:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d3a:	01 00 00 
  801d3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d41:	83 e0 01             	and    $0x1,%eax
  801d44:	48 85 c0             	test   %rax,%rax
  801d47:	74 21                	je     801d6a <fd_alloc+0x6a>
  801d49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d4d:	48 c1 e8 0c          	shr    $0xc,%rax
  801d51:	48 89 c2             	mov    %rax,%rdx
  801d54:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d5b:	01 00 00 
  801d5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d62:	83 e0 01             	and    $0x1,%eax
  801d65:	48 85 c0             	test   %rax,%rax
  801d68:	75 12                	jne    801d7c <fd_alloc+0x7c>
			*fd_store = fd;
  801d6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d6e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d72:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7a:	eb 1a                	jmp    801d96 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d7c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d80:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d84:	7e 8f                	jle    801d15 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d8a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d91:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d96:	c9                   	leaveq 
  801d97:	c3                   	retq   

0000000000801d98 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d98:	55                   	push   %rbp
  801d99:	48 89 e5             	mov    %rsp,%rbp
  801d9c:	48 83 ec 20          	sub    $0x20,%rsp
  801da0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801da3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801da7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801dab:	78 06                	js     801db3 <fd_lookup+0x1b>
  801dad:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801db1:	7e 07                	jle    801dba <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801db3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801db8:	eb 6c                	jmp    801e26 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801dba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801dbd:	48 98                	cltq   
  801dbf:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801dc5:	48 c1 e0 0c          	shl    $0xc,%rax
  801dc9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801dcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dd1:	48 c1 e8 15          	shr    $0x15,%rax
  801dd5:	48 89 c2             	mov    %rax,%rdx
  801dd8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ddf:	01 00 00 
  801de2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801de6:	83 e0 01             	and    $0x1,%eax
  801de9:	48 85 c0             	test   %rax,%rax
  801dec:	74 21                	je     801e0f <fd_lookup+0x77>
  801dee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801df2:	48 c1 e8 0c          	shr    $0xc,%rax
  801df6:	48 89 c2             	mov    %rax,%rdx
  801df9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e00:	01 00 00 
  801e03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e07:	83 e0 01             	and    $0x1,%eax
  801e0a:	48 85 c0             	test   %rax,%rax
  801e0d:	75 07                	jne    801e16 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e14:	eb 10                	jmp    801e26 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e16:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e1a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e1e:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e26:	c9                   	leaveq 
  801e27:	c3                   	retq   

0000000000801e28 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e28:	55                   	push   %rbp
  801e29:	48 89 e5             	mov    %rsp,%rbp
  801e2c:	48 83 ec 30          	sub    $0x30,%rsp
  801e30:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e34:	89 f0                	mov    %esi,%eax
  801e36:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e3d:	48 89 c7             	mov    %rax,%rdi
  801e40:	48 b8 b2 1c 80 00 00 	movabs $0x801cb2,%rax
  801e47:	00 00 00 
  801e4a:	ff d0                	callq  *%rax
  801e4c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e50:	48 89 d6             	mov    %rdx,%rsi
  801e53:	89 c7                	mov    %eax,%edi
  801e55:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  801e5c:	00 00 00 
  801e5f:	ff d0                	callq  *%rax
  801e61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e68:	78 0a                	js     801e74 <fd_close+0x4c>
	    || fd != fd2)
  801e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e6e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e72:	74 12                	je     801e86 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e74:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e78:	74 05                	je     801e7f <fd_close+0x57>
  801e7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e7d:	eb 05                	jmp    801e84 <fd_close+0x5c>
  801e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e84:	eb 69                	jmp    801eef <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8a:	8b 00                	mov    (%rax),%eax
  801e8c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e90:	48 89 d6             	mov    %rdx,%rsi
  801e93:	89 c7                	mov    %eax,%edi
  801e95:	48 b8 f1 1e 80 00 00 	movabs $0x801ef1,%rax
  801e9c:	00 00 00 
  801e9f:	ff d0                	callq  *%rax
  801ea1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ea4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ea8:	78 2a                	js     801ed4 <fd_close+0xac>
		if (dev->dev_close)
  801eaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eae:	48 8b 40 20          	mov    0x20(%rax),%rax
  801eb2:	48 85 c0             	test   %rax,%rax
  801eb5:	74 16                	je     801ecd <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801eb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebb:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ebf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801ec3:	48 89 d7             	mov    %rdx,%rdi
  801ec6:	ff d0                	callq  *%rax
  801ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ecb:	eb 07                	jmp    801ed4 <fd_close+0xac>
		else
			r = 0;
  801ecd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ed4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed8:	48 89 c6             	mov    %rax,%rsi
  801edb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee0:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  801ee7:	00 00 00 
  801eea:	ff d0                	callq  *%rax
	return r;
  801eec:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801eef:	c9                   	leaveq 
  801ef0:	c3                   	retq   

0000000000801ef1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ef1:	55                   	push   %rbp
  801ef2:	48 89 e5             	mov    %rsp,%rbp
  801ef5:	48 83 ec 20          	sub    $0x20,%rsp
  801ef9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801efc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f07:	eb 41                	jmp    801f4a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f09:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f10:	00 00 00 
  801f13:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f16:	48 63 d2             	movslq %edx,%rdx
  801f19:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f1d:	8b 00                	mov    (%rax),%eax
  801f1f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f22:	75 22                	jne    801f46 <dev_lookup+0x55>
			*dev = devtab[i];
  801f24:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f2b:	00 00 00 
  801f2e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f31:	48 63 d2             	movslq %edx,%rdx
  801f34:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f3c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f44:	eb 60                	jmp    801fa6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f46:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f4a:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f51:	00 00 00 
  801f54:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f57:	48 63 d2             	movslq %edx,%rdx
  801f5a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f5e:	48 85 c0             	test   %rax,%rax
  801f61:	75 a6                	jne    801f09 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f63:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f6a:	00 00 00 
  801f6d:	48 8b 00             	mov    (%rax),%rax
  801f70:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f76:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f79:	89 c6                	mov    %eax,%esi
  801f7b:	48 bf f0 3c 80 00 00 	movabs $0x803cf0,%rdi
  801f82:	00 00 00 
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8a:	48 b9 42 04 80 00 00 	movabs $0x800442,%rcx
  801f91:	00 00 00 
  801f94:	ff d1                	callq  *%rcx
	*dev = 0;
  801f96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f9a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fa1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fa6:	c9                   	leaveq 
  801fa7:	c3                   	retq   

0000000000801fa8 <close>:

int
close(int fdnum)
{
  801fa8:	55                   	push   %rbp
  801fa9:	48 89 e5             	mov    %rsp,%rbp
  801fac:	48 83 ec 20          	sub    $0x20,%rsp
  801fb0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fb7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fba:	48 89 d6             	mov    %rdx,%rsi
  801fbd:	89 c7                	mov    %eax,%edi
  801fbf:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  801fc6:	00 00 00 
  801fc9:	ff d0                	callq  *%rax
  801fcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fd2:	79 05                	jns    801fd9 <close+0x31>
		return r;
  801fd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fd7:	eb 18                	jmp    801ff1 <close+0x49>
	else
		return fd_close(fd, 1);
  801fd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fdd:	be 01 00 00 00       	mov    $0x1,%esi
  801fe2:	48 89 c7             	mov    %rax,%rdi
  801fe5:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  801fec:	00 00 00 
  801fef:	ff d0                	callq  *%rax
}
  801ff1:	c9                   	leaveq 
  801ff2:	c3                   	retq   

0000000000801ff3 <close_all>:

void
close_all(void)
{
  801ff3:	55                   	push   %rbp
  801ff4:	48 89 e5             	mov    %rsp,%rbp
  801ff7:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ffb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802002:	eb 15                	jmp    802019 <close_all+0x26>
		close(i);
  802004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802007:	89 c7                	mov    %eax,%edi
  802009:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802010:	00 00 00 
  802013:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802015:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802019:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80201d:	7e e5                	jle    802004 <close_all+0x11>
		close(i);
}
  80201f:	c9                   	leaveq 
  802020:	c3                   	retq   

0000000000802021 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802021:	55                   	push   %rbp
  802022:	48 89 e5             	mov    %rsp,%rbp
  802025:	48 83 ec 40          	sub    $0x40,%rsp
  802029:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80202c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80202f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802033:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802036:	48 89 d6             	mov    %rdx,%rsi
  802039:	89 c7                	mov    %eax,%edi
  80203b:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  802042:	00 00 00 
  802045:	ff d0                	callq  *%rax
  802047:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80204a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80204e:	79 08                	jns    802058 <dup+0x37>
		return r;
  802050:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802053:	e9 70 01 00 00       	jmpq   8021c8 <dup+0x1a7>
	close(newfdnum);
  802058:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80205b:	89 c7                	mov    %eax,%edi
  80205d:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802064:	00 00 00 
  802067:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802069:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80206c:	48 98                	cltq   
  80206e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802074:	48 c1 e0 0c          	shl    $0xc,%rax
  802078:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80207c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802080:	48 89 c7             	mov    %rax,%rdi
  802083:	48 b8 d5 1c 80 00 00 	movabs $0x801cd5,%rax
  80208a:	00 00 00 
  80208d:	ff d0                	callq  *%rax
  80208f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802093:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802097:	48 89 c7             	mov    %rax,%rdi
  80209a:	48 b8 d5 1c 80 00 00 	movabs $0x801cd5,%rax
  8020a1:	00 00 00 
  8020a4:	ff d0                	callq  *%rax
  8020a6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020ae:	48 c1 e8 15          	shr    $0x15,%rax
  8020b2:	48 89 c2             	mov    %rax,%rdx
  8020b5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020bc:	01 00 00 
  8020bf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020c3:	83 e0 01             	and    $0x1,%eax
  8020c6:	48 85 c0             	test   %rax,%rax
  8020c9:	74 73                	je     80213e <dup+0x11d>
  8020cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020cf:	48 c1 e8 0c          	shr    $0xc,%rax
  8020d3:	48 89 c2             	mov    %rax,%rdx
  8020d6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020dd:	01 00 00 
  8020e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020e4:	83 e0 01             	and    $0x1,%eax
  8020e7:	48 85 c0             	test   %rax,%rax
  8020ea:	74 52                	je     80213e <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f0:	48 c1 e8 0c          	shr    $0xc,%rax
  8020f4:	48 89 c2             	mov    %rax,%rdx
  8020f7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020fe:	01 00 00 
  802101:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802105:	25 07 0e 00 00       	and    $0xe07,%eax
  80210a:	89 c1                	mov    %eax,%ecx
  80210c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802110:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802114:	41 89 c8             	mov    %ecx,%r8d
  802117:	48 89 d1             	mov    %rdx,%rcx
  80211a:	ba 00 00 00 00       	mov    $0x0,%edx
  80211f:	48 89 c6             	mov    %rax,%rsi
  802122:	bf 00 00 00 00       	mov    $0x0,%edi
  802127:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  80212e:	00 00 00 
  802131:	ff d0                	callq  *%rax
  802133:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802136:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80213a:	79 02                	jns    80213e <dup+0x11d>
			goto err;
  80213c:	eb 57                	jmp    802195 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80213e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802142:	48 c1 e8 0c          	shr    $0xc,%rax
  802146:	48 89 c2             	mov    %rax,%rdx
  802149:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802150:	01 00 00 
  802153:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802157:	25 07 0e 00 00       	and    $0xe07,%eax
  80215c:	89 c1                	mov    %eax,%ecx
  80215e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802162:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802166:	41 89 c8             	mov    %ecx,%r8d
  802169:	48 89 d1             	mov    %rdx,%rcx
  80216c:	ba 00 00 00 00       	mov    $0x0,%edx
  802171:	48 89 c6             	mov    %rax,%rsi
  802174:	bf 00 00 00 00       	mov    $0x0,%edi
  802179:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  802180:	00 00 00 
  802183:	ff d0                	callq  *%rax
  802185:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802188:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80218c:	79 02                	jns    802190 <dup+0x16f>
		goto err;
  80218e:	eb 05                	jmp    802195 <dup+0x174>

	return newfdnum;
  802190:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802193:	eb 33                	jmp    8021c8 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802195:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802199:	48 89 c6             	mov    %rax,%rsi
  80219c:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a1:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  8021a8:	00 00 00 
  8021ab:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021ad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021b1:	48 89 c6             	mov    %rax,%rsi
  8021b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8021b9:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  8021c0:	00 00 00 
  8021c3:	ff d0                	callq  *%rax
	return r;
  8021c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021c8:	c9                   	leaveq 
  8021c9:	c3                   	retq   

00000000008021ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8021ca:	55                   	push   %rbp
  8021cb:	48 89 e5             	mov    %rsp,%rbp
  8021ce:	48 83 ec 40          	sub    $0x40,%rsp
  8021d2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021d5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021d9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021dd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021e4:	48 89 d6             	mov    %rdx,%rsi
  8021e7:	89 c7                	mov    %eax,%edi
  8021e9:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  8021f0:	00 00 00 
  8021f3:	ff d0                	callq  *%rax
  8021f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021fc:	78 24                	js     802222 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802202:	8b 00                	mov    (%rax),%eax
  802204:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802208:	48 89 d6             	mov    %rdx,%rsi
  80220b:	89 c7                	mov    %eax,%edi
  80220d:	48 b8 f1 1e 80 00 00 	movabs $0x801ef1,%rax
  802214:	00 00 00 
  802217:	ff d0                	callq  *%rax
  802219:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802220:	79 05                	jns    802227 <read+0x5d>
		return r;
  802222:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802225:	eb 76                	jmp    80229d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802227:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222b:	8b 40 08             	mov    0x8(%rax),%eax
  80222e:	83 e0 03             	and    $0x3,%eax
  802231:	83 f8 01             	cmp    $0x1,%eax
  802234:	75 3a                	jne    802270 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802236:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80223d:	00 00 00 
  802240:	48 8b 00             	mov    (%rax),%rax
  802243:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802249:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80224c:	89 c6                	mov    %eax,%esi
  80224e:	48 bf 0f 3d 80 00 00 	movabs $0x803d0f,%rdi
  802255:	00 00 00 
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
  80225d:	48 b9 42 04 80 00 00 	movabs $0x800442,%rcx
  802264:	00 00 00 
  802267:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802269:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80226e:	eb 2d                	jmp    80229d <read+0xd3>
	}
	if (!dev->dev_read)
  802270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802274:	48 8b 40 10          	mov    0x10(%rax),%rax
  802278:	48 85 c0             	test   %rax,%rax
  80227b:	75 07                	jne    802284 <read+0xba>
		return -E_NOT_SUPP;
  80227d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802282:	eb 19                	jmp    80229d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802284:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802288:	48 8b 40 10          	mov    0x10(%rax),%rax
  80228c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802290:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802294:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802298:	48 89 cf             	mov    %rcx,%rdi
  80229b:	ff d0                	callq  *%rax
}
  80229d:	c9                   	leaveq 
  80229e:	c3                   	retq   

000000000080229f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80229f:	55                   	push   %rbp
  8022a0:	48 89 e5             	mov    %rsp,%rbp
  8022a3:	48 83 ec 30          	sub    $0x30,%rsp
  8022a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022b9:	eb 49                	jmp    802304 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022be:	48 98                	cltq   
  8022c0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022c4:	48 29 c2             	sub    %rax,%rdx
  8022c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ca:	48 63 c8             	movslq %eax,%rcx
  8022cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022d1:	48 01 c1             	add    %rax,%rcx
  8022d4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022d7:	48 89 ce             	mov    %rcx,%rsi
  8022da:	89 c7                	mov    %eax,%edi
  8022dc:	48 b8 ca 21 80 00 00 	movabs $0x8021ca,%rax
  8022e3:	00 00 00 
  8022e6:	ff d0                	callq  *%rax
  8022e8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022eb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022ef:	79 05                	jns    8022f6 <readn+0x57>
			return m;
  8022f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022f4:	eb 1c                	jmp    802312 <readn+0x73>
		if (m == 0)
  8022f6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022fa:	75 02                	jne    8022fe <readn+0x5f>
			break;
  8022fc:	eb 11                	jmp    80230f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802301:	01 45 fc             	add    %eax,-0x4(%rbp)
  802304:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802307:	48 98                	cltq   
  802309:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80230d:	72 ac                	jb     8022bb <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80230f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802312:	c9                   	leaveq 
  802313:	c3                   	retq   

0000000000802314 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802314:	55                   	push   %rbp
  802315:	48 89 e5             	mov    %rsp,%rbp
  802318:	48 83 ec 40          	sub    $0x40,%rsp
  80231c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80231f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802323:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802327:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80232b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80232e:	48 89 d6             	mov    %rdx,%rsi
  802331:	89 c7                	mov    %eax,%edi
  802333:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  80233a:	00 00 00 
  80233d:	ff d0                	callq  *%rax
  80233f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802342:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802346:	78 24                	js     80236c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802348:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234c:	8b 00                	mov    (%rax),%eax
  80234e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802352:	48 89 d6             	mov    %rdx,%rsi
  802355:	89 c7                	mov    %eax,%edi
  802357:	48 b8 f1 1e 80 00 00 	movabs $0x801ef1,%rax
  80235e:	00 00 00 
  802361:	ff d0                	callq  *%rax
  802363:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802366:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80236a:	79 05                	jns    802371 <write+0x5d>
		return r;
  80236c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80236f:	eb 75                	jmp    8023e6 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802371:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802375:	8b 40 08             	mov    0x8(%rax),%eax
  802378:	83 e0 03             	and    $0x3,%eax
  80237b:	85 c0                	test   %eax,%eax
  80237d:	75 3a                	jne    8023b9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80237f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802386:	00 00 00 
  802389:	48 8b 00             	mov    (%rax),%rax
  80238c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802392:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802395:	89 c6                	mov    %eax,%esi
  802397:	48 bf 2b 3d 80 00 00 	movabs $0x803d2b,%rdi
  80239e:	00 00 00 
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a6:	48 b9 42 04 80 00 00 	movabs $0x800442,%rcx
  8023ad:	00 00 00 
  8023b0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023b7:	eb 2d                	jmp    8023e6 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023bd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023c1:	48 85 c0             	test   %rax,%rax
  8023c4:	75 07                	jne    8023cd <write+0xb9>
		return -E_NOT_SUPP;
  8023c6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023cb:	eb 19                	jmp    8023e6 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8023cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023d1:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023d5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023d9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023dd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023e1:	48 89 cf             	mov    %rcx,%rdi
  8023e4:	ff d0                	callq  *%rax
}
  8023e6:	c9                   	leaveq 
  8023e7:	c3                   	retq   

00000000008023e8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023e8:	55                   	push   %rbp
  8023e9:	48 89 e5             	mov    %rsp,%rbp
  8023ec:	48 83 ec 18          	sub    $0x18,%rsp
  8023f0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023f3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023f6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023fd:	48 89 d6             	mov    %rdx,%rsi
  802400:	89 c7                	mov    %eax,%edi
  802402:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  802409:	00 00 00 
  80240c:	ff d0                	callq  *%rax
  80240e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802411:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802415:	79 05                	jns    80241c <seek+0x34>
		return r;
  802417:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80241a:	eb 0f                	jmp    80242b <seek+0x43>
	fd->fd_offset = offset;
  80241c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802420:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802423:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242b:	c9                   	leaveq 
  80242c:	c3                   	retq   

000000000080242d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80242d:	55                   	push   %rbp
  80242e:	48 89 e5             	mov    %rsp,%rbp
  802431:	48 83 ec 30          	sub    $0x30,%rsp
  802435:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802438:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80243b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80243f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802442:	48 89 d6             	mov    %rdx,%rsi
  802445:	89 c7                	mov    %eax,%edi
  802447:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  80244e:	00 00 00 
  802451:	ff d0                	callq  *%rax
  802453:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802456:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80245a:	78 24                	js     802480 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80245c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802460:	8b 00                	mov    (%rax),%eax
  802462:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802466:	48 89 d6             	mov    %rdx,%rsi
  802469:	89 c7                	mov    %eax,%edi
  80246b:	48 b8 f1 1e 80 00 00 	movabs $0x801ef1,%rax
  802472:	00 00 00 
  802475:	ff d0                	callq  *%rax
  802477:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80247a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80247e:	79 05                	jns    802485 <ftruncate+0x58>
		return r;
  802480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802483:	eb 72                	jmp    8024f7 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802485:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802489:	8b 40 08             	mov    0x8(%rax),%eax
  80248c:	83 e0 03             	and    $0x3,%eax
  80248f:	85 c0                	test   %eax,%eax
  802491:	75 3a                	jne    8024cd <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802493:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80249a:	00 00 00 
  80249d:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024a0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024a6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024a9:	89 c6                	mov    %eax,%esi
  8024ab:	48 bf 48 3d 80 00 00 	movabs $0x803d48,%rdi
  8024b2:	00 00 00 
  8024b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ba:	48 b9 42 04 80 00 00 	movabs $0x800442,%rcx
  8024c1:	00 00 00 
  8024c4:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8024c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024cb:	eb 2a                	jmp    8024f7 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024d1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024d5:	48 85 c0             	test   %rax,%rax
  8024d8:	75 07                	jne    8024e1 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024df:	eb 16                	jmp    8024f7 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024ed:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024f0:	89 ce                	mov    %ecx,%esi
  8024f2:	48 89 d7             	mov    %rdx,%rdi
  8024f5:	ff d0                	callq  *%rax
}
  8024f7:	c9                   	leaveq 
  8024f8:	c3                   	retq   

00000000008024f9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024f9:	55                   	push   %rbp
  8024fa:	48 89 e5             	mov    %rsp,%rbp
  8024fd:	48 83 ec 30          	sub    $0x30,%rsp
  802501:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802504:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802508:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80250c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80250f:	48 89 d6             	mov    %rdx,%rsi
  802512:	89 c7                	mov    %eax,%edi
  802514:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  80251b:	00 00 00 
  80251e:	ff d0                	callq  *%rax
  802520:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802523:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802527:	78 24                	js     80254d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802529:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80252d:	8b 00                	mov    (%rax),%eax
  80252f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802533:	48 89 d6             	mov    %rdx,%rsi
  802536:	89 c7                	mov    %eax,%edi
  802538:	48 b8 f1 1e 80 00 00 	movabs $0x801ef1,%rax
  80253f:	00 00 00 
  802542:	ff d0                	callq  *%rax
  802544:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802547:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80254b:	79 05                	jns    802552 <fstat+0x59>
		return r;
  80254d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802550:	eb 5e                	jmp    8025b0 <fstat+0xb7>
	if (!dev->dev_stat)
  802552:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802556:	48 8b 40 28          	mov    0x28(%rax),%rax
  80255a:	48 85 c0             	test   %rax,%rax
  80255d:	75 07                	jne    802566 <fstat+0x6d>
		return -E_NOT_SUPP;
  80255f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802564:	eb 4a                	jmp    8025b0 <fstat+0xb7>
	stat->st_name[0] = 0;
  802566:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80256a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80256d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802571:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802578:	00 00 00 
	stat->st_isdir = 0;
  80257b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80257f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802586:	00 00 00 
	stat->st_dev = dev;
  802589:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80258d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802591:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802598:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80259c:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025a4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025a8:	48 89 ce             	mov    %rcx,%rsi
  8025ab:	48 89 d7             	mov    %rdx,%rdi
  8025ae:	ff d0                	callq  *%rax
}
  8025b0:	c9                   	leaveq 
  8025b1:	c3                   	retq   

00000000008025b2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025b2:	55                   	push   %rbp
  8025b3:	48 89 e5             	mov    %rsp,%rbp
  8025b6:	48 83 ec 20          	sub    $0x20,%rsp
  8025ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c6:	be 00 00 00 00       	mov    $0x0,%esi
  8025cb:	48 89 c7             	mov    %rax,%rdi
  8025ce:	48 b8 a0 26 80 00 00 	movabs $0x8026a0,%rax
  8025d5:	00 00 00 
  8025d8:	ff d0                	callq  *%rax
  8025da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025e1:	79 05                	jns    8025e8 <stat+0x36>
		return fd;
  8025e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025e6:	eb 2f                	jmp    802617 <stat+0x65>
	r = fstat(fd, stat);
  8025e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ef:	48 89 d6             	mov    %rdx,%rsi
  8025f2:	89 c7                	mov    %eax,%edi
  8025f4:	48 b8 f9 24 80 00 00 	movabs $0x8024f9,%rax
  8025fb:	00 00 00 
  8025fe:	ff d0                	callq  *%rax
  802600:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802603:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802606:	89 c7                	mov    %eax,%edi
  802608:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  80260f:	00 00 00 
  802612:	ff d0                	callq  *%rax
	return r;
  802614:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802617:	c9                   	leaveq 
  802618:	c3                   	retq   

0000000000802619 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802619:	55                   	push   %rbp
  80261a:	48 89 e5             	mov    %rsp,%rbp
  80261d:	48 83 ec 10          	sub    $0x10,%rsp
  802621:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802624:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802628:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80262f:	00 00 00 
  802632:	8b 00                	mov    (%rax),%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	75 1d                	jne    802655 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802638:	bf 01 00 00 00       	mov    $0x1,%edi
  80263d:	48 b8 e2 35 80 00 00 	movabs $0x8035e2,%rax
  802644:	00 00 00 
  802647:	ff d0                	callq  *%rax
  802649:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802650:	00 00 00 
  802653:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802655:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80265c:	00 00 00 
  80265f:	8b 00                	mov    (%rax),%eax
  802661:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802664:	b9 07 00 00 00       	mov    $0x7,%ecx
  802669:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802670:	00 00 00 
  802673:	89 c7                	mov    %eax,%edi
  802675:	48 b8 45 35 80 00 00 	movabs $0x803545,%rax
  80267c:	00 00 00 
  80267f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802681:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802685:	ba 00 00 00 00       	mov    $0x0,%edx
  80268a:	48 89 c6             	mov    %rax,%rsi
  80268d:	bf 00 00 00 00       	mov    $0x0,%edi
  802692:	48 b8 7f 34 80 00 00 	movabs $0x80347f,%rax
  802699:	00 00 00 
  80269c:	ff d0                	callq  *%rax
}
  80269e:	c9                   	leaveq 
  80269f:	c3                   	retq   

00000000008026a0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026a0:	55                   	push   %rbp
  8026a1:	48 89 e5             	mov    %rsp,%rbp
  8026a4:	48 83 ec 20          	sub    $0x20,%rsp
  8026a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026ac:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  8026af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b3:	48 89 c7             	mov    %rax,%rdi
  8026b6:	48 b8 8b 0f 80 00 00 	movabs $0x800f8b,%rax
  8026bd:	00 00 00 
  8026c0:	ff d0                	callq  *%rax
  8026c2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8026c7:	7e 0a                	jle    8026d3 <open+0x33>
  8026c9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026ce:	e9 a5 00 00 00       	jmpq   802778 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8026d3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8026d7:	48 89 c7             	mov    %rax,%rdi
  8026da:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  8026e1:	00 00 00 
  8026e4:	ff d0                	callq  *%rax
  8026e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ed:	79 08                	jns    8026f7 <open+0x57>
		return r;
  8026ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f2:	e9 81 00 00 00       	jmpq   802778 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  8026f7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8026fe:	00 00 00 
  802701:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802704:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  80270a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80270e:	48 89 c6             	mov    %rax,%rsi
  802711:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802718:	00 00 00 
  80271b:	48 b8 f7 0f 80 00 00 	movabs $0x800ff7,%rax
  802722:	00 00 00 
  802725:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80272b:	48 89 c6             	mov    %rax,%rsi
  80272e:	bf 01 00 00 00       	mov    $0x1,%edi
  802733:	48 b8 19 26 80 00 00 	movabs $0x802619,%rax
  80273a:	00 00 00 
  80273d:	ff d0                	callq  *%rax
  80273f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802742:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802746:	79 1d                	jns    802765 <open+0xc5>
		fd_close(fd, 0);
  802748:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274c:	be 00 00 00 00       	mov    $0x0,%esi
  802751:	48 89 c7             	mov    %rax,%rdi
  802754:	48 b8 28 1e 80 00 00 	movabs $0x801e28,%rax
  80275b:	00 00 00 
  80275e:	ff d0                	callq  *%rax
		return r;
  802760:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802763:	eb 13                	jmp    802778 <open+0xd8>
	}
	return fd2num(fd);
  802765:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802769:	48 89 c7             	mov    %rax,%rdi
  80276c:	48 b8 b2 1c 80 00 00 	movabs $0x801cb2,%rax
  802773:	00 00 00 
  802776:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802778:	c9                   	leaveq 
  802779:	c3                   	retq   

000000000080277a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80277a:	55                   	push   %rbp
  80277b:	48 89 e5             	mov    %rsp,%rbp
  80277e:	48 83 ec 10          	sub    $0x10,%rsp
  802782:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802786:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80278a:	8b 50 0c             	mov    0xc(%rax),%edx
  80278d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802794:	00 00 00 
  802797:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802799:	be 00 00 00 00       	mov    $0x0,%esi
  80279e:	bf 06 00 00 00       	mov    $0x6,%edi
  8027a3:	48 b8 19 26 80 00 00 	movabs $0x802619,%rax
  8027aa:	00 00 00 
  8027ad:	ff d0                	callq  *%rax
}
  8027af:	c9                   	leaveq 
  8027b0:	c3                   	retq   

00000000008027b1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027b1:	55                   	push   %rbp
  8027b2:	48 89 e5             	mov    %rsp,%rbp
  8027b5:	48 83 ec 30          	sub    $0x30,%rsp
  8027b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8027c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027c9:	8b 50 0c             	mov    0xc(%rax),%edx
  8027cc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027d3:	00 00 00 
  8027d6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8027d8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027df:	00 00 00 
  8027e2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027e6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  8027ea:	be 00 00 00 00       	mov    $0x0,%esi
  8027ef:	bf 03 00 00 00       	mov    $0x3,%edi
  8027f4:	48 b8 19 26 80 00 00 	movabs $0x802619,%rax
  8027fb:	00 00 00 
  8027fe:	ff d0                	callq  *%rax
  802800:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802803:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802807:	79 05                	jns    80280e <devfile_read+0x5d>
		return r;
  802809:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80280c:	eb 26                	jmp    802834 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  80280e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802811:	48 63 d0             	movslq %eax,%rdx
  802814:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802818:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80281f:	00 00 00 
  802822:	48 89 c7             	mov    %rax,%rdi
  802825:	48 b8 32 14 80 00 00 	movabs $0x801432,%rax
  80282c:	00 00 00 
  80282f:	ff d0                	callq  *%rax
	return r;
  802831:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802834:	c9                   	leaveq 
  802835:	c3                   	retq   

0000000000802836 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802836:	55                   	push   %rbp
  802837:	48 89 e5             	mov    %rsp,%rbp
  80283a:	48 83 ec 30          	sub    $0x30,%rsp
  80283e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802842:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802846:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  80284a:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802851:	00 
	n = n > max ? max : n;
  802852:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802856:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80285a:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  80285f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802867:	8b 50 0c             	mov    0xc(%rax),%edx
  80286a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802871:	00 00 00 
  802874:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802876:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80287d:	00 00 00 
  802880:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802884:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802888:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80288c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802890:	48 89 c6             	mov    %rax,%rsi
  802893:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  80289a:	00 00 00 
  80289d:	48 b8 32 14 80 00 00 	movabs $0x801432,%rax
  8028a4:	00 00 00 
  8028a7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  8028a9:	be 00 00 00 00       	mov    $0x0,%esi
  8028ae:	bf 04 00 00 00       	mov    $0x4,%edi
  8028b3:	48 b8 19 26 80 00 00 	movabs $0x802619,%rax
  8028ba:	00 00 00 
  8028bd:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  8028bf:	c9                   	leaveq 
  8028c0:	c3                   	retq   

00000000008028c1 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8028c1:	55                   	push   %rbp
  8028c2:	48 89 e5             	mov    %rsp,%rbp
  8028c5:	48 83 ec 20          	sub    $0x20,%rsp
  8028c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d5:	8b 50 0c             	mov    0xc(%rax),%edx
  8028d8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028df:	00 00 00 
  8028e2:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8028e4:	be 00 00 00 00       	mov    $0x0,%esi
  8028e9:	bf 05 00 00 00       	mov    $0x5,%edi
  8028ee:	48 b8 19 26 80 00 00 	movabs $0x802619,%rax
  8028f5:	00 00 00 
  8028f8:	ff d0                	callq  *%rax
  8028fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802901:	79 05                	jns    802908 <devfile_stat+0x47>
		return r;
  802903:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802906:	eb 56                	jmp    80295e <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802908:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80290c:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802913:	00 00 00 
  802916:	48 89 c7             	mov    %rax,%rdi
  802919:	48 b8 f7 0f 80 00 00 	movabs $0x800ff7,%rax
  802920:	00 00 00 
  802923:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802925:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80292c:	00 00 00 
  80292f:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802935:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802939:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80293f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802946:	00 00 00 
  802949:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80294f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802953:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802959:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80295e:	c9                   	leaveq 
  80295f:	c3                   	retq   

0000000000802960 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802960:	55                   	push   %rbp
  802961:	48 89 e5             	mov    %rsp,%rbp
  802964:	48 83 ec 10          	sub    $0x10,%rsp
  802968:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80296c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80296f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802973:	8b 50 0c             	mov    0xc(%rax),%edx
  802976:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80297d:	00 00 00 
  802980:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802982:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802989:	00 00 00 
  80298c:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80298f:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802992:	be 00 00 00 00       	mov    $0x0,%esi
  802997:	bf 02 00 00 00       	mov    $0x2,%edi
  80299c:	48 b8 19 26 80 00 00 	movabs $0x802619,%rax
  8029a3:	00 00 00 
  8029a6:	ff d0                	callq  *%rax
}
  8029a8:	c9                   	leaveq 
  8029a9:	c3                   	retq   

00000000008029aa <remove>:

// Delete a file
int
remove(const char *path)
{
  8029aa:	55                   	push   %rbp
  8029ab:	48 89 e5             	mov    %rsp,%rbp
  8029ae:	48 83 ec 10          	sub    $0x10,%rsp
  8029b2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8029b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029ba:	48 89 c7             	mov    %rax,%rdi
  8029bd:	48 b8 8b 0f 80 00 00 	movabs $0x800f8b,%rax
  8029c4:	00 00 00 
  8029c7:	ff d0                	callq  *%rax
  8029c9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029ce:	7e 07                	jle    8029d7 <remove+0x2d>
		return -E_BAD_PATH;
  8029d0:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029d5:	eb 33                	jmp    802a0a <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8029d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029db:	48 89 c6             	mov    %rax,%rsi
  8029de:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  8029e5:	00 00 00 
  8029e8:	48 b8 f7 0f 80 00 00 	movabs $0x800ff7,%rax
  8029ef:	00 00 00 
  8029f2:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8029f4:	be 00 00 00 00       	mov    $0x0,%esi
  8029f9:	bf 07 00 00 00       	mov    $0x7,%edi
  8029fe:	48 b8 19 26 80 00 00 	movabs $0x802619,%rax
  802a05:	00 00 00 
  802a08:	ff d0                	callq  *%rax
}
  802a0a:	c9                   	leaveq 
  802a0b:	c3                   	retq   

0000000000802a0c <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a0c:	55                   	push   %rbp
  802a0d:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a10:	be 00 00 00 00       	mov    $0x0,%esi
  802a15:	bf 08 00 00 00       	mov    $0x8,%edi
  802a1a:	48 b8 19 26 80 00 00 	movabs $0x802619,%rax
  802a21:	00 00 00 
  802a24:	ff d0                	callq  *%rax
}
  802a26:	5d                   	pop    %rbp
  802a27:	c3                   	retq   

0000000000802a28 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802a28:	55                   	push   %rbp
  802a29:	48 89 e5             	mov    %rsp,%rbp
  802a2c:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a33:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a3a:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802a41:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802a48:	be 00 00 00 00       	mov    $0x0,%esi
  802a4d:	48 89 c7             	mov    %rax,%rdi
  802a50:	48 b8 a0 26 80 00 00 	movabs $0x8026a0,%rax
  802a57:	00 00 00 
  802a5a:	ff d0                	callq  *%rax
  802a5c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802a5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a63:	79 28                	jns    802a8d <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802a65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a68:	89 c6                	mov    %eax,%esi
  802a6a:	48 bf 6e 3d 80 00 00 	movabs $0x803d6e,%rdi
  802a71:	00 00 00 
  802a74:	b8 00 00 00 00       	mov    $0x0,%eax
  802a79:	48 ba 42 04 80 00 00 	movabs $0x800442,%rdx
  802a80:	00 00 00 
  802a83:	ff d2                	callq  *%rdx
		return fd_src;
  802a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a88:	e9 74 01 00 00       	jmpq   802c01 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802a8d:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802a94:	be 01 01 00 00       	mov    $0x101,%esi
  802a99:	48 89 c7             	mov    %rax,%rdi
  802a9c:	48 b8 a0 26 80 00 00 	movabs $0x8026a0,%rax
  802aa3:	00 00 00 
  802aa6:	ff d0                	callq  *%rax
  802aa8:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802aab:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802aaf:	79 39                	jns    802aea <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802ab1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ab4:	89 c6                	mov    %eax,%esi
  802ab6:	48 bf 84 3d 80 00 00 	movabs $0x803d84,%rdi
  802abd:	00 00 00 
  802ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac5:	48 ba 42 04 80 00 00 	movabs $0x800442,%rdx
  802acc:	00 00 00 
  802acf:	ff d2                	callq  *%rdx
		close(fd_src);
  802ad1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad4:	89 c7                	mov    %eax,%edi
  802ad6:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802add:	00 00 00 
  802ae0:	ff d0                	callq  *%rax
		return fd_dest;
  802ae2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ae5:	e9 17 01 00 00       	jmpq   802c01 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802aea:	eb 74                	jmp    802b60 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802aec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802aef:	48 63 d0             	movslq %eax,%rdx
  802af2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802af9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802afc:	48 89 ce             	mov    %rcx,%rsi
  802aff:	89 c7                	mov    %eax,%edi
  802b01:	48 b8 14 23 80 00 00 	movabs $0x802314,%rax
  802b08:	00 00 00 
  802b0b:	ff d0                	callq  *%rax
  802b0d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802b10:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b14:	79 4a                	jns    802b60 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802b16:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b19:	89 c6                	mov    %eax,%esi
  802b1b:	48 bf 9e 3d 80 00 00 	movabs $0x803d9e,%rdi
  802b22:	00 00 00 
  802b25:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2a:	48 ba 42 04 80 00 00 	movabs $0x800442,%rdx
  802b31:	00 00 00 
  802b34:	ff d2                	callq  *%rdx
			close(fd_src);
  802b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b39:	89 c7                	mov    %eax,%edi
  802b3b:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802b42:	00 00 00 
  802b45:	ff d0                	callq  *%rax
			close(fd_dest);
  802b47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b4a:	89 c7                	mov    %eax,%edi
  802b4c:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802b53:	00 00 00 
  802b56:	ff d0                	callq  *%rax
			return write_size;
  802b58:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b5b:	e9 a1 00 00 00       	jmpq   802c01 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b60:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b67:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6a:	ba 00 02 00 00       	mov    $0x200,%edx
  802b6f:	48 89 ce             	mov    %rcx,%rsi
  802b72:	89 c7                	mov    %eax,%edi
  802b74:	48 b8 ca 21 80 00 00 	movabs $0x8021ca,%rax
  802b7b:	00 00 00 
  802b7e:	ff d0                	callq  *%rax
  802b80:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b83:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b87:	0f 8f 5f ff ff ff    	jg     802aec <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802b8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b91:	79 47                	jns    802bda <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802b93:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b96:	89 c6                	mov    %eax,%esi
  802b98:	48 bf b1 3d 80 00 00 	movabs $0x803db1,%rdi
  802b9f:	00 00 00 
  802ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba7:	48 ba 42 04 80 00 00 	movabs $0x800442,%rdx
  802bae:	00 00 00 
  802bb1:	ff d2                	callq  *%rdx
		close(fd_src);
  802bb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb6:	89 c7                	mov    %eax,%edi
  802bb8:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802bbf:	00 00 00 
  802bc2:	ff d0                	callq  *%rax
		close(fd_dest);
  802bc4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc7:	89 c7                	mov    %eax,%edi
  802bc9:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802bd0:	00 00 00 
  802bd3:	ff d0                	callq  *%rax
		return read_size;
  802bd5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bd8:	eb 27                	jmp    802c01 <copy+0x1d9>
	}
	close(fd_src);
  802bda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bdd:	89 c7                	mov    %eax,%edi
  802bdf:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802be6:	00 00 00 
  802be9:	ff d0                	callq  *%rax
	close(fd_dest);
  802beb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bee:	89 c7                	mov    %eax,%edi
  802bf0:	48 b8 a8 1f 80 00 00 	movabs $0x801fa8,%rax
  802bf7:	00 00 00 
  802bfa:	ff d0                	callq  *%rax
	return 0;
  802bfc:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802c01:	c9                   	leaveq 
  802c02:	c3                   	retq   

0000000000802c03 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802c03:	55                   	push   %rbp
  802c04:	48 89 e5             	mov    %rsp,%rbp
  802c07:	53                   	push   %rbx
  802c08:	48 83 ec 38          	sub    $0x38,%rsp
  802c0c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802c10:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802c14:	48 89 c7             	mov    %rax,%rdi
  802c17:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
  802c23:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c26:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c2a:	0f 88 bf 01 00 00    	js     802def <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c34:	ba 07 04 00 00       	mov    $0x407,%edx
  802c39:	48 89 c6             	mov    %rax,%rsi
  802c3c:	bf 00 00 00 00       	mov    $0x0,%edi
  802c41:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  802c48:	00 00 00 
  802c4b:	ff d0                	callq  *%rax
  802c4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c50:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c54:	0f 88 95 01 00 00    	js     802def <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802c5a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802c5e:	48 89 c7             	mov    %rax,%rdi
  802c61:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  802c68:	00 00 00 
  802c6b:	ff d0                	callq  *%rax
  802c6d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c70:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c74:	0f 88 5d 01 00 00    	js     802dd7 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c7e:	ba 07 04 00 00       	mov    $0x407,%edx
  802c83:	48 89 c6             	mov    %rax,%rsi
  802c86:	bf 00 00 00 00       	mov    $0x0,%edi
  802c8b:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  802c92:	00 00 00 
  802c95:	ff d0                	callq  *%rax
  802c97:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c9e:	0f 88 33 01 00 00    	js     802dd7 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802ca4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ca8:	48 89 c7             	mov    %rax,%rdi
  802cab:	48 b8 d5 1c 80 00 00 	movabs $0x801cd5,%rax
  802cb2:	00 00 00 
  802cb5:	ff d0                	callq  *%rax
  802cb7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cbb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cbf:	ba 07 04 00 00       	mov    $0x407,%edx
  802cc4:	48 89 c6             	mov    %rax,%rsi
  802cc7:	bf 00 00 00 00       	mov    $0x0,%edi
  802ccc:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  802cd3:	00 00 00 
  802cd6:	ff d0                	callq  *%rax
  802cd8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802cdb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cdf:	79 05                	jns    802ce6 <pipe+0xe3>
		goto err2;
  802ce1:	e9 d9 00 00 00       	jmpq   802dbf <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ce6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802cea:	48 89 c7             	mov    %rax,%rdi
  802ced:	48 b8 d5 1c 80 00 00 	movabs $0x801cd5,%rax
  802cf4:	00 00 00 
  802cf7:	ff d0                	callq  *%rax
  802cf9:	48 89 c2             	mov    %rax,%rdx
  802cfc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d00:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802d06:	48 89 d1             	mov    %rdx,%rcx
  802d09:	ba 00 00 00 00       	mov    $0x0,%edx
  802d0e:	48 89 c6             	mov    %rax,%rsi
  802d11:	bf 00 00 00 00       	mov    $0x0,%edi
  802d16:	48 b8 76 19 80 00 00 	movabs $0x801976,%rax
  802d1d:	00 00 00 
  802d20:	ff d0                	callq  *%rax
  802d22:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d25:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d29:	79 1b                	jns    802d46 <pipe+0x143>
		goto err3;
  802d2b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802d2c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d30:	48 89 c6             	mov    %rax,%rsi
  802d33:	bf 00 00 00 00       	mov    $0x0,%edi
  802d38:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  802d3f:	00 00 00 
  802d42:	ff d0                	callq  *%rax
  802d44:	eb 79                	jmp    802dbf <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802d46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d4a:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d51:	00 00 00 
  802d54:	8b 12                	mov    (%rdx),%edx
  802d56:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802d58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802d63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d67:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d6e:	00 00 00 
  802d71:	8b 12                	mov    (%rdx),%edx
  802d73:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802d75:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d79:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802d80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d84:	48 89 c7             	mov    %rax,%rdi
  802d87:	48 b8 b2 1c 80 00 00 	movabs $0x801cb2,%rax
  802d8e:	00 00 00 
  802d91:	ff d0                	callq  *%rax
  802d93:	89 c2                	mov    %eax,%edx
  802d95:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d99:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802d9b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802d9f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802da3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802da7:	48 89 c7             	mov    %rax,%rdi
  802daa:	48 b8 b2 1c 80 00 00 	movabs $0x801cb2,%rax
  802db1:	00 00 00 
  802db4:	ff d0                	callq  *%rax
  802db6:	89 03                	mov    %eax,(%rbx)
	return 0;
  802db8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbd:	eb 33                	jmp    802df2 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802dbf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dc3:	48 89 c6             	mov    %rax,%rsi
  802dc6:	bf 00 00 00 00       	mov    $0x0,%edi
  802dcb:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  802dd2:	00 00 00 
  802dd5:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802dd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ddb:	48 89 c6             	mov    %rax,%rsi
  802dde:	bf 00 00 00 00       	mov    $0x0,%edi
  802de3:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  802dea:	00 00 00 
  802ded:	ff d0                	callq  *%rax
err:
	return r;
  802def:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802df2:	48 83 c4 38          	add    $0x38,%rsp
  802df6:	5b                   	pop    %rbx
  802df7:	5d                   	pop    %rbp
  802df8:	c3                   	retq   

0000000000802df9 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802df9:	55                   	push   %rbp
  802dfa:	48 89 e5             	mov    %rsp,%rbp
  802dfd:	53                   	push   %rbx
  802dfe:	48 83 ec 28          	sub    $0x28,%rsp
  802e02:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e06:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802e0a:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e11:	00 00 00 
  802e14:	48 8b 00             	mov    (%rax),%rax
  802e17:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e1d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802e20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e24:	48 89 c7             	mov    %rax,%rdi
  802e27:	48 b8 64 36 80 00 00 	movabs $0x803664,%rax
  802e2e:	00 00 00 
  802e31:	ff d0                	callq  *%rax
  802e33:	89 c3                	mov    %eax,%ebx
  802e35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e39:	48 89 c7             	mov    %rax,%rdi
  802e3c:	48 b8 64 36 80 00 00 	movabs $0x803664,%rax
  802e43:	00 00 00 
  802e46:	ff d0                	callq  *%rax
  802e48:	39 c3                	cmp    %eax,%ebx
  802e4a:	0f 94 c0             	sete   %al
  802e4d:	0f b6 c0             	movzbl %al,%eax
  802e50:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802e53:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e5a:	00 00 00 
  802e5d:	48 8b 00             	mov    (%rax),%rax
  802e60:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e66:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802e69:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e6c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e6f:	75 05                	jne    802e76 <_pipeisclosed+0x7d>
			return ret;
  802e71:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e74:	eb 4f                	jmp    802ec5 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802e76:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e79:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e7c:	74 42                	je     802ec0 <_pipeisclosed+0xc7>
  802e7e:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802e82:	75 3c                	jne    802ec0 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802e84:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e8b:	00 00 00 
  802e8e:	48 8b 00             	mov    (%rax),%rax
  802e91:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802e97:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802e9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e9d:	89 c6                	mov    %eax,%esi
  802e9f:	48 bf cc 3d 80 00 00 	movabs $0x803dcc,%rdi
  802ea6:	00 00 00 
  802ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  802eae:	49 b8 42 04 80 00 00 	movabs $0x800442,%r8
  802eb5:	00 00 00 
  802eb8:	41 ff d0             	callq  *%r8
	}
  802ebb:	e9 4a ff ff ff       	jmpq   802e0a <_pipeisclosed+0x11>
  802ec0:	e9 45 ff ff ff       	jmpq   802e0a <_pipeisclosed+0x11>
}
  802ec5:	48 83 c4 28          	add    $0x28,%rsp
  802ec9:	5b                   	pop    %rbx
  802eca:	5d                   	pop    %rbp
  802ecb:	c3                   	retq   

0000000000802ecc <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802ecc:	55                   	push   %rbp
  802ecd:	48 89 e5             	mov    %rsp,%rbp
  802ed0:	48 83 ec 30          	sub    $0x30,%rsp
  802ed4:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ed7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802edb:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802ede:	48 89 d6             	mov    %rdx,%rsi
  802ee1:	89 c7                	mov    %eax,%edi
  802ee3:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  802eea:	00 00 00 
  802eed:	ff d0                	callq  *%rax
  802eef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef6:	79 05                	jns    802efd <pipeisclosed+0x31>
		return r;
  802ef8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802efb:	eb 31                	jmp    802f2e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802efd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f01:	48 89 c7             	mov    %rax,%rdi
  802f04:	48 b8 d5 1c 80 00 00 	movabs $0x801cd5,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
  802f10:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f1c:	48 89 d6             	mov    %rdx,%rsi
  802f1f:	48 89 c7             	mov    %rax,%rdi
  802f22:	48 b8 f9 2d 80 00 00 	movabs $0x802df9,%rax
  802f29:	00 00 00 
  802f2c:	ff d0                	callq  *%rax
}
  802f2e:	c9                   	leaveq 
  802f2f:	c3                   	retq   

0000000000802f30 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f30:	55                   	push   %rbp
  802f31:	48 89 e5             	mov    %rsp,%rbp
  802f34:	48 83 ec 40          	sub    $0x40,%rsp
  802f38:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f3c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f40:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802f44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f48:	48 89 c7             	mov    %rax,%rdi
  802f4b:	48 b8 d5 1c 80 00 00 	movabs $0x801cd5,%rax
  802f52:	00 00 00 
  802f55:	ff d0                	callq  *%rax
  802f57:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802f5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f5f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802f63:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802f6a:	00 
  802f6b:	e9 92 00 00 00       	jmpq   803002 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802f70:	eb 41                	jmp    802fb3 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802f72:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802f77:	74 09                	je     802f82 <devpipe_read+0x52>
				return i;
  802f79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f7d:	e9 92 00 00 00       	jmpq   803014 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802f82:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8a:	48 89 d6             	mov    %rdx,%rsi
  802f8d:	48 89 c7             	mov    %rax,%rdi
  802f90:	48 b8 f9 2d 80 00 00 	movabs $0x802df9,%rax
  802f97:	00 00 00 
  802f9a:	ff d0                	callq  *%rax
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	74 07                	je     802fa7 <devpipe_read+0x77>
				return 0;
  802fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa5:	eb 6d                	jmp    803014 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802fa7:	48 b8 e8 18 80 00 00 	movabs $0x8018e8,%rax
  802fae:	00 00 00 
  802fb1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fb7:	8b 10                	mov    (%rax),%edx
  802fb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbd:	8b 40 04             	mov    0x4(%rax),%eax
  802fc0:	39 c2                	cmp    %eax,%edx
  802fc2:	74 ae                	je     802f72 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802fc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fc8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fcc:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802fd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd4:	8b 00                	mov    (%rax),%eax
  802fd6:	99                   	cltd   
  802fd7:	c1 ea 1b             	shr    $0x1b,%edx
  802fda:	01 d0                	add    %edx,%eax
  802fdc:	83 e0 1f             	and    $0x1f,%eax
  802fdf:	29 d0                	sub    %edx,%eax
  802fe1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fe5:	48 98                	cltq   
  802fe7:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802fec:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802fee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff2:	8b 00                	mov    (%rax),%eax
  802ff4:	8d 50 01             	lea    0x1(%rax),%edx
  802ff7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffb:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ffd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803002:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803006:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80300a:	0f 82 60 ff ff ff    	jb     802f70 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803010:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803014:	c9                   	leaveq 
  803015:	c3                   	retq   

0000000000803016 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803016:	55                   	push   %rbp
  803017:	48 89 e5             	mov    %rsp,%rbp
  80301a:	48 83 ec 40          	sub    $0x40,%rsp
  80301e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803022:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803026:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80302a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80302e:	48 89 c7             	mov    %rax,%rdi
  803031:	48 b8 d5 1c 80 00 00 	movabs $0x801cd5,%rax
  803038:	00 00 00 
  80303b:	ff d0                	callq  *%rax
  80303d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803041:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803045:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803049:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803050:	00 
  803051:	e9 8e 00 00 00       	jmpq   8030e4 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803056:	eb 31                	jmp    803089 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803058:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80305c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803060:	48 89 d6             	mov    %rdx,%rsi
  803063:	48 89 c7             	mov    %rax,%rdi
  803066:	48 b8 f9 2d 80 00 00 	movabs $0x802df9,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
  803072:	85 c0                	test   %eax,%eax
  803074:	74 07                	je     80307d <devpipe_write+0x67>
				return 0;
  803076:	b8 00 00 00 00       	mov    $0x0,%eax
  80307b:	eb 79                	jmp    8030f6 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80307d:	48 b8 e8 18 80 00 00 	movabs $0x8018e8,%rax
  803084:	00 00 00 
  803087:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803089:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80308d:	8b 40 04             	mov    0x4(%rax),%eax
  803090:	48 63 d0             	movslq %eax,%rdx
  803093:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803097:	8b 00                	mov    (%rax),%eax
  803099:	48 98                	cltq   
  80309b:	48 83 c0 20          	add    $0x20,%rax
  80309f:	48 39 c2             	cmp    %rax,%rdx
  8030a2:	73 b4                	jae    803058 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8030a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a8:	8b 40 04             	mov    0x4(%rax),%eax
  8030ab:	99                   	cltd   
  8030ac:	c1 ea 1b             	shr    $0x1b,%edx
  8030af:	01 d0                	add    %edx,%eax
  8030b1:	83 e0 1f             	and    $0x1f,%eax
  8030b4:	29 d0                	sub    %edx,%eax
  8030b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030ba:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030be:	48 01 ca             	add    %rcx,%rdx
  8030c1:	0f b6 0a             	movzbl (%rdx),%ecx
  8030c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030c8:	48 98                	cltq   
  8030ca:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8030ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d2:	8b 40 04             	mov    0x4(%rax),%eax
  8030d5:	8d 50 01             	lea    0x1(%rax),%edx
  8030d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030dc:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8030df:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8030e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030e8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8030ec:	0f 82 64 ff ff ff    	jb     803056 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8030f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8030f6:	c9                   	leaveq 
  8030f7:	c3                   	retq   

00000000008030f8 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8030f8:	55                   	push   %rbp
  8030f9:	48 89 e5             	mov    %rsp,%rbp
  8030fc:	48 83 ec 20          	sub    $0x20,%rsp
  803100:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803104:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310c:	48 89 c7             	mov    %rax,%rdi
  80310f:	48 b8 d5 1c 80 00 00 	movabs $0x801cd5,%rax
  803116:	00 00 00 
  803119:	ff d0                	callq  *%rax
  80311b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80311f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803123:	48 be df 3d 80 00 00 	movabs $0x803ddf,%rsi
  80312a:	00 00 00 
  80312d:	48 89 c7             	mov    %rax,%rdi
  803130:	48 b8 f7 0f 80 00 00 	movabs $0x800ff7,%rax
  803137:	00 00 00 
  80313a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80313c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803140:	8b 50 04             	mov    0x4(%rax),%edx
  803143:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803147:	8b 00                	mov    (%rax),%eax
  803149:	29 c2                	sub    %eax,%edx
  80314b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803155:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803159:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803160:	00 00 00 
	stat->st_dev = &devpipe;
  803163:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803167:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  80316e:	00 00 00 
  803171:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803178:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80317d:	c9                   	leaveq 
  80317e:	c3                   	retq   

000000000080317f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80317f:	55                   	push   %rbp
  803180:	48 89 e5             	mov    %rsp,%rbp
  803183:	48 83 ec 10          	sub    $0x10,%rsp
  803187:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  80318b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80318f:	48 89 c6             	mov    %rax,%rsi
  803192:	bf 00 00 00 00       	mov    $0x0,%edi
  803197:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  80319e:	00 00 00 
  8031a1:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8031a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a7:	48 89 c7             	mov    %rax,%rdi
  8031aa:	48 b8 d5 1c 80 00 00 	movabs $0x801cd5,%rax
  8031b1:	00 00 00 
  8031b4:	ff d0                	callq  *%rax
  8031b6:	48 89 c6             	mov    %rax,%rsi
  8031b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8031be:	48 b8 d1 19 80 00 00 	movabs $0x8019d1,%rax
  8031c5:	00 00 00 
  8031c8:	ff d0                	callq  *%rax
}
  8031ca:	c9                   	leaveq 
  8031cb:	c3                   	retq   

00000000008031cc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8031cc:	55                   	push   %rbp
  8031cd:	48 89 e5             	mov    %rsp,%rbp
  8031d0:	48 83 ec 20          	sub    $0x20,%rsp
  8031d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8031d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031da:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8031dd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8031e1:	be 01 00 00 00       	mov    $0x1,%esi
  8031e6:	48 89 c7             	mov    %rax,%rdi
  8031e9:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  8031f0:	00 00 00 
  8031f3:	ff d0                	callq  *%rax
}
  8031f5:	c9                   	leaveq 
  8031f6:	c3                   	retq   

00000000008031f7 <getchar>:

int
getchar(void)
{
  8031f7:	55                   	push   %rbp
  8031f8:	48 89 e5             	mov    %rsp,%rbp
  8031fb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8031ff:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803203:	ba 01 00 00 00       	mov    $0x1,%edx
  803208:	48 89 c6             	mov    %rax,%rsi
  80320b:	bf 00 00 00 00       	mov    $0x0,%edi
  803210:	48 b8 ca 21 80 00 00 	movabs $0x8021ca,%rax
  803217:	00 00 00 
  80321a:	ff d0                	callq  *%rax
  80321c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80321f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803223:	79 05                	jns    80322a <getchar+0x33>
		return r;
  803225:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803228:	eb 14                	jmp    80323e <getchar+0x47>
	if (r < 1)
  80322a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80322e:	7f 07                	jg     803237 <getchar+0x40>
		return -E_EOF;
  803230:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803235:	eb 07                	jmp    80323e <getchar+0x47>
	return c;
  803237:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80323b:	0f b6 c0             	movzbl %al,%eax
}
  80323e:	c9                   	leaveq 
  80323f:	c3                   	retq   

0000000000803240 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803240:	55                   	push   %rbp
  803241:	48 89 e5             	mov    %rsp,%rbp
  803244:	48 83 ec 20          	sub    $0x20,%rsp
  803248:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80324b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80324f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803252:	48 89 d6             	mov    %rdx,%rsi
  803255:	89 c7                	mov    %eax,%edi
  803257:	48 b8 98 1d 80 00 00 	movabs $0x801d98,%rax
  80325e:	00 00 00 
  803261:	ff d0                	callq  *%rax
  803263:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803266:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326a:	79 05                	jns    803271 <iscons+0x31>
		return r;
  80326c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326f:	eb 1a                	jmp    80328b <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803271:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803275:	8b 10                	mov    (%rax),%edx
  803277:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  80327e:	00 00 00 
  803281:	8b 00                	mov    (%rax),%eax
  803283:	39 c2                	cmp    %eax,%edx
  803285:	0f 94 c0             	sete   %al
  803288:	0f b6 c0             	movzbl %al,%eax
}
  80328b:	c9                   	leaveq 
  80328c:	c3                   	retq   

000000000080328d <opencons>:

int
opencons(void)
{
  80328d:	55                   	push   %rbp
  80328e:	48 89 e5             	mov    %rsp,%rbp
  803291:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803295:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803299:	48 89 c7             	mov    %rax,%rdi
  80329c:	48 b8 00 1d 80 00 00 	movabs $0x801d00,%rax
  8032a3:	00 00 00 
  8032a6:	ff d0                	callq  *%rax
  8032a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032af:	79 05                	jns    8032b6 <opencons+0x29>
		return r;
  8032b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b4:	eb 5b                	jmp    803311 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8032b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ba:	ba 07 04 00 00       	mov    $0x407,%edx
  8032bf:	48 89 c6             	mov    %rax,%rsi
  8032c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8032c7:	48 b8 26 19 80 00 00 	movabs $0x801926,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
  8032d3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032da:	79 05                	jns    8032e1 <opencons+0x54>
		return r;
  8032dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032df:	eb 30                	jmp    803311 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8032e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e5:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8032ec:	00 00 00 
  8032ef:	8b 12                	mov    (%rdx),%edx
  8032f1:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8032f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8032fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803302:	48 89 c7             	mov    %rax,%rdi
  803305:	48 b8 b2 1c 80 00 00 	movabs $0x801cb2,%rax
  80330c:	00 00 00 
  80330f:	ff d0                	callq  *%rax
}
  803311:	c9                   	leaveq 
  803312:	c3                   	retq   

0000000000803313 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803313:	55                   	push   %rbp
  803314:	48 89 e5             	mov    %rsp,%rbp
  803317:	48 83 ec 30          	sub    $0x30,%rsp
  80331b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80331f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803323:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803327:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80332c:	75 07                	jne    803335 <devcons_read+0x22>
		return 0;
  80332e:	b8 00 00 00 00       	mov    $0x0,%eax
  803333:	eb 4b                	jmp    803380 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803335:	eb 0c                	jmp    803343 <devcons_read+0x30>
		sys_yield();
  803337:	48 b8 e8 18 80 00 00 	movabs $0x8018e8,%rax
  80333e:	00 00 00 
  803341:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803343:	48 b8 28 18 80 00 00 	movabs $0x801828,%rax
  80334a:	00 00 00 
  80334d:	ff d0                	callq  *%rax
  80334f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803352:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803356:	74 df                	je     803337 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803358:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80335c:	79 05                	jns    803363 <devcons_read+0x50>
		return c;
  80335e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803361:	eb 1d                	jmp    803380 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803363:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803367:	75 07                	jne    803370 <devcons_read+0x5d>
		return 0;
  803369:	b8 00 00 00 00       	mov    $0x0,%eax
  80336e:	eb 10                	jmp    803380 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803370:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803373:	89 c2                	mov    %eax,%edx
  803375:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803379:	88 10                	mov    %dl,(%rax)
	return 1;
  80337b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803380:	c9                   	leaveq 
  803381:	c3                   	retq   

0000000000803382 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803382:	55                   	push   %rbp
  803383:	48 89 e5             	mov    %rsp,%rbp
  803386:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80338d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803394:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80339b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8033a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8033a9:	eb 76                	jmp    803421 <devcons_write+0x9f>
		m = n - tot;
  8033ab:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8033b2:	89 c2                	mov    %eax,%edx
  8033b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033b7:	29 c2                	sub    %eax,%edx
  8033b9:	89 d0                	mov    %edx,%eax
  8033bb:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8033be:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033c1:	83 f8 7f             	cmp    $0x7f,%eax
  8033c4:	76 07                	jbe    8033cd <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8033c6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8033cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033d0:	48 63 d0             	movslq %eax,%rdx
  8033d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d6:	48 63 c8             	movslq %eax,%rcx
  8033d9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8033e0:	48 01 c1             	add    %rax,%rcx
  8033e3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8033ea:	48 89 ce             	mov    %rcx,%rsi
  8033ed:	48 89 c7             	mov    %rax,%rdi
  8033f0:	48 b8 1b 13 80 00 00 	movabs $0x80131b,%rax
  8033f7:	00 00 00 
  8033fa:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8033fc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033ff:	48 63 d0             	movslq %eax,%rdx
  803402:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803409:	48 89 d6             	mov    %rdx,%rsi
  80340c:	48 89 c7             	mov    %rax,%rdi
  80340f:	48 b8 de 17 80 00 00 	movabs $0x8017de,%rax
  803416:	00 00 00 
  803419:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80341b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80341e:	01 45 fc             	add    %eax,-0x4(%rbp)
  803421:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803424:	48 98                	cltq   
  803426:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80342d:	0f 82 78 ff ff ff    	jb     8033ab <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803433:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803436:	c9                   	leaveq 
  803437:	c3                   	retq   

0000000000803438 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803438:	55                   	push   %rbp
  803439:	48 89 e5             	mov    %rsp,%rbp
  80343c:	48 83 ec 08          	sub    $0x8,%rsp
  803440:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803444:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803449:	c9                   	leaveq 
  80344a:	c3                   	retq   

000000000080344b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80344b:	55                   	push   %rbp
  80344c:	48 89 e5             	mov    %rsp,%rbp
  80344f:	48 83 ec 10          	sub    $0x10,%rsp
  803453:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803457:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80345b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80345f:	48 be eb 3d 80 00 00 	movabs $0x803deb,%rsi
  803466:	00 00 00 
  803469:	48 89 c7             	mov    %rax,%rdi
  80346c:	48 b8 f7 0f 80 00 00 	movabs $0x800ff7,%rax
  803473:	00 00 00 
  803476:	ff d0                	callq  *%rax
	return 0;
  803478:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80347d:	c9                   	leaveq 
  80347e:	c3                   	retq   

000000000080347f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80347f:	55                   	push   %rbp
  803480:	48 89 e5             	mov    %rsp,%rbp
  803483:	48 83 ec 30          	sub    $0x30,%rsp
  803487:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80348b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80348f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  803493:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803498:	74 18                	je     8034b2 <ipc_recv+0x33>
  80349a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80349e:	48 89 c7             	mov    %rax,%rdi
  8034a1:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8034a8:	00 00 00 
  8034ab:	ff d0                	callq  *%rax
  8034ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034b0:	eb 19                	jmp    8034cb <ipc_recv+0x4c>
  8034b2:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8034b9:	00 00 00 
  8034bc:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8034c3:	00 00 00 
  8034c6:	ff d0                	callq  *%rax
  8034c8:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8034cb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034d0:	74 26                	je     8034f8 <ipc_recv+0x79>
  8034d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d6:	75 15                	jne    8034ed <ipc_recv+0x6e>
  8034d8:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8034df:	00 00 00 
  8034e2:	48 8b 00             	mov    (%rax),%rax
  8034e5:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8034eb:	eb 05                	jmp    8034f2 <ipc_recv+0x73>
  8034ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8034f6:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  8034f8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8034fd:	74 26                	je     803525 <ipc_recv+0xa6>
  8034ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803503:	75 15                	jne    80351a <ipc_recv+0x9b>
  803505:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80350c:	00 00 00 
  80350f:	48 8b 00             	mov    (%rax),%rax
  803512:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803518:	eb 05                	jmp    80351f <ipc_recv+0xa0>
  80351a:	b8 00 00 00 00       	mov    $0x0,%eax
  80351f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803523:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  803525:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803529:	75 15                	jne    803540 <ipc_recv+0xc1>
  80352b:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803532:	00 00 00 
  803535:	48 8b 00             	mov    (%rax),%rax
  803538:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  80353e:	eb 03                	jmp    803543 <ipc_recv+0xc4>
  803540:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803543:	c9                   	leaveq 
  803544:	c3                   	retq   

0000000000803545 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803545:	55                   	push   %rbp
  803546:	48 89 e5             	mov    %rsp,%rbp
  803549:	48 83 ec 30          	sub    $0x30,%rsp
  80354d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803550:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803553:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803557:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  80355a:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803561:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803566:	75 10                	jne    803578 <ipc_send+0x33>
  803568:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80356f:	00 00 00 
  803572:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  803576:	eb 62                	jmp    8035da <ipc_send+0x95>
  803578:	eb 60                	jmp    8035da <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  80357a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80357e:	74 30                	je     8035b0 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803580:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803583:	89 c1                	mov    %eax,%ecx
  803585:	48 ba f2 3d 80 00 00 	movabs $0x803df2,%rdx
  80358c:	00 00 00 
  80358f:	be 33 00 00 00       	mov    $0x33,%esi
  803594:	48 bf 0e 3e 80 00 00 	movabs $0x803e0e,%rdi
  80359b:	00 00 00 
  80359e:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a3:	49 b8 09 02 80 00 00 	movabs $0x800209,%r8
  8035aa:	00 00 00 
  8035ad:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  8035b0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8035b3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8035b6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035bd:	89 c7                	mov    %eax,%edi
  8035bf:	48 b8 fa 1a 80 00 00 	movabs $0x801afa,%rax
  8035c6:	00 00 00 
  8035c9:	ff d0                	callq  *%rax
  8035cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8035ce:	48 b8 e8 18 80 00 00 	movabs $0x8018e8,%rax
  8035d5:	00 00 00 
  8035d8:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8035da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035de:	75 9a                	jne    80357a <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  8035e0:	c9                   	leaveq 
  8035e1:	c3                   	retq   

00000000008035e2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8035e2:	55                   	push   %rbp
  8035e3:	48 89 e5             	mov    %rsp,%rbp
  8035e6:	48 83 ec 14          	sub    $0x14,%rsp
  8035ea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8035ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8035f4:	eb 5e                	jmp    803654 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8035f6:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8035fd:	00 00 00 
  803600:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803603:	48 63 d0             	movslq %eax,%rdx
  803606:	48 89 d0             	mov    %rdx,%rax
  803609:	48 c1 e0 03          	shl    $0x3,%rax
  80360d:	48 01 d0             	add    %rdx,%rax
  803610:	48 c1 e0 05          	shl    $0x5,%rax
  803614:	48 01 c8             	add    %rcx,%rax
  803617:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80361d:	8b 00                	mov    (%rax),%eax
  80361f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803622:	75 2c                	jne    803650 <ipc_find_env+0x6e>
			return envs[i].env_id;
  803624:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  80362b:	00 00 00 
  80362e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803631:	48 63 d0             	movslq %eax,%rdx
  803634:	48 89 d0             	mov    %rdx,%rax
  803637:	48 c1 e0 03          	shl    $0x3,%rax
  80363b:	48 01 d0             	add    %rdx,%rax
  80363e:	48 c1 e0 05          	shl    $0x5,%rax
  803642:	48 01 c8             	add    %rcx,%rax
  803645:	48 05 c0 00 00 00    	add    $0xc0,%rax
  80364b:	8b 40 08             	mov    0x8(%rax),%eax
  80364e:	eb 12                	jmp    803662 <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803650:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803654:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80365b:	7e 99                	jle    8035f6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  80365d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803662:	c9                   	leaveq 
  803663:	c3                   	retq   

0000000000803664 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803664:	55                   	push   %rbp
  803665:	48 89 e5             	mov    %rsp,%rbp
  803668:	48 83 ec 18          	sub    $0x18,%rsp
  80366c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803670:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803674:	48 c1 e8 15          	shr    $0x15,%rax
  803678:	48 89 c2             	mov    %rax,%rdx
  80367b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803682:	01 00 00 
  803685:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803689:	83 e0 01             	and    $0x1,%eax
  80368c:	48 85 c0             	test   %rax,%rax
  80368f:	75 07                	jne    803698 <pageref+0x34>
		return 0;
  803691:	b8 00 00 00 00       	mov    $0x0,%eax
  803696:	eb 53                	jmp    8036eb <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80369c:	48 c1 e8 0c          	shr    $0xc,%rax
  8036a0:	48 89 c2             	mov    %rax,%rdx
  8036a3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036aa:	01 00 00 
  8036ad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8036b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036b9:	83 e0 01             	and    $0x1,%eax
  8036bc:	48 85 c0             	test   %rax,%rax
  8036bf:	75 07                	jne    8036c8 <pageref+0x64>
		return 0;
  8036c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c6:	eb 23                	jmp    8036eb <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8036c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036cc:	48 c1 e8 0c          	shr    $0xc,%rax
  8036d0:	48 89 c2             	mov    %rax,%rdx
  8036d3:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8036da:	00 00 00 
  8036dd:	48 c1 e2 04          	shl    $0x4,%rdx
  8036e1:	48 01 d0             	add    %rdx,%rax
  8036e4:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8036e8:	0f b7 c0             	movzwl %ax,%eax
}
  8036eb:	c9                   	leaveq 
  8036ec:	c3                   	retq   
