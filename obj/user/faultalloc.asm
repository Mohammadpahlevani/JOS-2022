
obj/user/faultalloc:     file format elf64-x86-64


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
  80003c:	e8 3f 01 00 00       	callq  800180 <libmain>
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
  800061:	48 bf 20 37 80 00 00 	movabs $0x803720,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
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
  80009b:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
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
  8000bd:	48 ba 30 37 80 00 00 	movabs $0x803730,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0e 00 00 00       	mov    $0xe,%esi
  8000cc:	48 bf 5b 37 80 00 00 	movabs $0x80375b,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba 70 37 80 00 00 	movabs $0x803770,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 d4 0e 80 00 00 	movabs $0x800ed4,%r8
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
  800132:	48 b8 bd 1b 80 00 00 	movabs $0x801bbd,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	cprintf("%s\n", (char*)0xDeadBeef);
  80013e:	be ef be ad de       	mov    $0xdeadbeef,%esi
  800143:	48 bf 91 37 80 00 00 	movabs $0x803791,%rdi
  80014a:	00 00 00 
  80014d:	b8 00 00 00 00       	mov    $0x0,%eax
  800152:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
  800159:	00 00 00 
  80015c:	ff d2                	callq  *%rdx
	cprintf("%s\n", (char*)0xCafeBffe);
  80015e:	be fe bf fe ca       	mov    $0xcafebffe,%esi
  800163:	48 bf 91 37 80 00 00 	movabs $0x803791,%rdi
  80016a:	00 00 00 
  80016d:	b8 00 00 00 00       	mov    $0x0,%eax
  800172:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
  800179:	00 00 00 
  80017c:	ff d2                	callq  *%rdx
}
  80017e:	c9                   	leaveq 
  80017f:	c3                   	retq   

0000000000800180 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800180:	55                   	push   %rbp
  800181:	48 89 e5             	mov    %rsp,%rbp
  800184:	48 83 ec 10          	sub    $0x10,%rsp
  800188:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80018b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  80018f:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  800196:	00 00 00 
  800199:	ff d0                	callq  *%rax
  80019b:	48 98                	cltq   
  80019d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a2:	48 89 c2             	mov    %rax,%rdx
  8001a5:	48 89 d0             	mov    %rdx,%rax
  8001a8:	48 c1 e0 03          	shl    $0x3,%rax
  8001ac:	48 01 d0             	add    %rdx,%rax
  8001af:	48 c1 e0 05          	shl    $0x5,%rax
  8001b3:	48 89 c2             	mov    %rax,%rdx
  8001b6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001bd:	00 00 00 
  8001c0:	48 01 c2             	add    %rax,%rdx
  8001c3:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8001ca:	00 00 00 
  8001cd:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d4:	7e 14                	jle    8001ea <libmain+0x6a>
		binaryname = argv[0];
  8001d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001da:	48 8b 10             	mov    (%rax),%rdx
  8001dd:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8001e4:	00 00 00 
  8001e7:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001ea:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001f1:	48 89 d6             	mov    %rdx,%rsi
  8001f4:	89 c7                	mov    %eax,%edi
  8001f6:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  8001fd:	00 00 00 
  800200:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800202:	48 b8 10 02 80 00 00 	movabs $0x800210,%rax
  800209:	00 00 00 
  80020c:	ff d0                	callq  *%rax
}
  80020e:	c9                   	leaveq 
  80020f:	c3                   	retq   

0000000000800210 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800210:	55                   	push   %rbp
  800211:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  800214:	48 b8 1d 20 80 00 00 	movabs $0x80201d,%rax
  80021b:	00 00 00 
  80021e:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800220:	bf 00 00 00 00       	mov    $0x0,%edi
  800225:	48 b8 90 18 80 00 00 	movabs $0x801890,%rax
  80022c:	00 00 00 
  80022f:	ff d0                	callq  *%rax
}
  800231:	5d                   	pop    %rbp
  800232:	c3                   	retq   

0000000000800233 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800233:	55                   	push   %rbp
  800234:	48 89 e5             	mov    %rsp,%rbp
  800237:	53                   	push   %rbx
  800238:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80023f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800246:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80024c:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800253:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80025a:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800261:	84 c0                	test   %al,%al
  800263:	74 23                	je     800288 <_panic+0x55>
  800265:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80026c:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800270:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800274:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800278:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80027c:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800280:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800284:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800288:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80028f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800296:	00 00 00 
  800299:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002a0:	00 00 00 
  8002a3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002a7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002ae:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002b5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002bc:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002c3:	00 00 00 
  8002c6:	48 8b 18             	mov    (%rax),%rbx
  8002c9:	48 b8 d4 18 80 00 00 	movabs $0x8018d4,%rax
  8002d0:	00 00 00 
  8002d3:	ff d0                	callq  *%rax
  8002d5:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002db:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002e2:	41 89 c8             	mov    %ecx,%r8d
  8002e5:	48 89 d1             	mov    %rdx,%rcx
  8002e8:	48 89 da             	mov    %rbx,%rdx
  8002eb:	89 c6                	mov    %eax,%esi
  8002ed:	48 bf a0 37 80 00 00 	movabs $0x8037a0,%rdi
  8002f4:	00 00 00 
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	49 b9 6c 04 80 00 00 	movabs $0x80046c,%r9
  800303:	00 00 00 
  800306:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800309:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800310:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800317:	48 89 d6             	mov    %rdx,%rsi
  80031a:	48 89 c7             	mov    %rax,%rdi
  80031d:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  800324:	00 00 00 
  800327:	ff d0                	callq  *%rax
	cprintf("\n");
  800329:	48 bf c3 37 80 00 00 	movabs $0x8037c3,%rdi
  800330:	00 00 00 
  800333:	b8 00 00 00 00       	mov    $0x0,%eax
  800338:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
  80033f:	00 00 00 
  800342:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800344:	cc                   	int3   
  800345:	eb fd                	jmp    800344 <_panic+0x111>

0000000000800347 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800347:	55                   	push   %rbp
  800348:	48 89 e5             	mov    %rsp,%rbp
  80034b:	48 83 ec 10          	sub    $0x10,%rsp
  80034f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800352:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800356:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80035a:	8b 00                	mov    (%rax),%eax
  80035c:	8d 48 01             	lea    0x1(%rax),%ecx
  80035f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800363:	89 0a                	mov    %ecx,(%rdx)
  800365:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800368:	89 d1                	mov    %edx,%ecx
  80036a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80036e:	48 98                	cltq   
  800370:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800374:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800378:	8b 00                	mov    (%rax),%eax
  80037a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80037f:	75 2c                	jne    8003ad <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800385:	8b 00                	mov    (%rax),%eax
  800387:	48 98                	cltq   
  800389:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038d:	48 83 c2 08          	add    $0x8,%rdx
  800391:	48 89 c6             	mov    %rax,%rsi
  800394:	48 89 d7             	mov    %rdx,%rdi
  800397:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  80039e:	00 00 00 
  8003a1:	ff d0                	callq  *%rax
        b->idx = 0;
  8003a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003b1:	8b 40 04             	mov    0x4(%rax),%eax
  8003b4:	8d 50 01             	lea    0x1(%rax),%edx
  8003b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003bb:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003be:	c9                   	leaveq 
  8003bf:	c3                   	retq   

00000000008003c0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003c0:	55                   	push   %rbp
  8003c1:	48 89 e5             	mov    %rsp,%rbp
  8003c4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003cb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003d2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003d9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003e0:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003e7:	48 8b 0a             	mov    (%rdx),%rcx
  8003ea:	48 89 08             	mov    %rcx,(%rax)
  8003ed:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003f1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003f5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003f9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8003fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800404:	00 00 00 
    b.cnt = 0;
  800407:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80040e:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800411:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800418:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80041f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800426:	48 89 c6             	mov    %rax,%rsi
  800429:	48 bf 47 03 80 00 00 	movabs $0x800347,%rdi
  800430:	00 00 00 
  800433:	48 b8 1f 08 80 00 00 	movabs $0x80081f,%rax
  80043a:	00 00 00 
  80043d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80043f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800445:	48 98                	cltq   
  800447:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80044e:	48 83 c2 08          	add    $0x8,%rdx
  800452:	48 89 c6             	mov    %rax,%rsi
  800455:	48 89 d7             	mov    %rdx,%rdi
  800458:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  80045f:	00 00 00 
  800462:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800464:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80046a:	c9                   	leaveq 
  80046b:	c3                   	retq   

000000000080046c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80046c:	55                   	push   %rbp
  80046d:	48 89 e5             	mov    %rsp,%rbp
  800470:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800477:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80047e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800485:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80048c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800493:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80049a:	84 c0                	test   %al,%al
  80049c:	74 20                	je     8004be <cprintf+0x52>
  80049e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004a2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004a6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004aa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004ae:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004b2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004b6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004ba:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004be:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004c5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004cc:	00 00 00 
  8004cf:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004d6:	00 00 00 
  8004d9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004dd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004e4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004eb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8004f2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004f9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800500:	48 8b 0a             	mov    (%rdx),%rcx
  800503:	48 89 08             	mov    %rcx,(%rax)
  800506:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80050a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80050e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800512:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800516:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80051d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800524:	48 89 d6             	mov    %rdx,%rsi
  800527:	48 89 c7             	mov    %rax,%rdi
  80052a:	48 b8 c0 03 80 00 00 	movabs $0x8003c0,%rax
  800531:	00 00 00 
  800534:	ff d0                	callq  *%rax
  800536:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80053c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800542:	c9                   	leaveq 
  800543:	c3                   	retq   

0000000000800544 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800544:	55                   	push   %rbp
  800545:	48 89 e5             	mov    %rsp,%rbp
  800548:	53                   	push   %rbx
  800549:	48 83 ec 38          	sub    $0x38,%rsp
  80054d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800551:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800555:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800559:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80055c:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800560:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800564:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800567:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80056b:	77 3b                	ja     8005a8 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80056d:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800570:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800574:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80057b:	ba 00 00 00 00       	mov    $0x0,%edx
  800580:	48 f7 f3             	div    %rbx
  800583:	48 89 c2             	mov    %rax,%rdx
  800586:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800589:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80058c:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800590:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800594:	41 89 f9             	mov    %edi,%r9d
  800597:	48 89 c7             	mov    %rax,%rdi
  80059a:	48 b8 44 05 80 00 00 	movabs $0x800544,%rax
  8005a1:	00 00 00 
  8005a4:	ff d0                	callq  *%rax
  8005a6:	eb 1e                	jmp    8005c6 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005a8:	eb 12                	jmp    8005bc <printnum+0x78>
			putch(padc, putdat);
  8005aa:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005ae:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b5:	48 89 ce             	mov    %rcx,%rsi
  8005b8:	89 d7                	mov    %edx,%edi
  8005ba:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005bc:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005c0:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005c4:	7f e4                	jg     8005aa <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005c6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d2:	48 f7 f1             	div    %rcx
  8005d5:	48 89 d0             	mov    %rdx,%rax
  8005d8:	48 ba d0 39 80 00 00 	movabs $0x8039d0,%rdx
  8005df:	00 00 00 
  8005e2:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005e6:	0f be d0             	movsbl %al,%edx
  8005e9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f1:	48 89 ce             	mov    %rcx,%rsi
  8005f4:	89 d7                	mov    %edx,%edi
  8005f6:	ff d0                	callq  *%rax
}
  8005f8:	48 83 c4 38          	add    $0x38,%rsp
  8005fc:	5b                   	pop    %rbx
  8005fd:	5d                   	pop    %rbp
  8005fe:	c3                   	retq   

00000000008005ff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005ff:	55                   	push   %rbp
  800600:	48 89 e5             	mov    %rsp,%rbp
  800603:	48 83 ec 1c          	sub    $0x1c,%rsp
  800607:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80060b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80060e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800612:	7e 52                	jle    800666 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800614:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800618:	8b 00                	mov    (%rax),%eax
  80061a:	83 f8 30             	cmp    $0x30,%eax
  80061d:	73 24                	jae    800643 <getuint+0x44>
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
  800641:	eb 17                	jmp    80065a <getuint+0x5b>
  800643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800647:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80064b:	48 89 d0             	mov    %rdx,%rax
  80064e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800656:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80065a:	48 8b 00             	mov    (%rax),%rax
  80065d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800661:	e9 a3 00 00 00       	jmpq   800709 <getuint+0x10a>
	else if (lflag)
  800666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80066a:	74 4f                	je     8006bb <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80066c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800670:	8b 00                	mov    (%rax),%eax
  800672:	83 f8 30             	cmp    $0x30,%eax
  800675:	73 24                	jae    80069b <getuint+0x9c>
  800677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80067f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800683:	8b 00                	mov    (%rax),%eax
  800685:	89 c0                	mov    %eax,%eax
  800687:	48 01 d0             	add    %rdx,%rax
  80068a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068e:	8b 12                	mov    (%rdx),%edx
  800690:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800697:	89 0a                	mov    %ecx,(%rdx)
  800699:	eb 17                	jmp    8006b2 <getuint+0xb3>
  80069b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006a3:	48 89 d0             	mov    %rdx,%rax
  8006a6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006b2:	48 8b 00             	mov    (%rax),%rax
  8006b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006b9:	eb 4e                	jmp    800709 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bf:	8b 00                	mov    (%rax),%eax
  8006c1:	83 f8 30             	cmp    $0x30,%eax
  8006c4:	73 24                	jae    8006ea <getuint+0xeb>
  8006c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ca:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006d2:	8b 00                	mov    (%rax),%eax
  8006d4:	89 c0                	mov    %eax,%eax
  8006d6:	48 01 d0             	add    %rdx,%rax
  8006d9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006dd:	8b 12                	mov    (%rdx),%edx
  8006df:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006e6:	89 0a                	mov    %ecx,(%rdx)
  8006e8:	eb 17                	jmp    800701 <getuint+0x102>
  8006ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ee:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006f2:	48 89 d0             	mov    %rdx,%rax
  8006f5:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800701:	8b 00                	mov    (%rax),%eax
  800703:	89 c0                	mov    %eax,%eax
  800705:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800709:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80070d:	c9                   	leaveq 
  80070e:	c3                   	retq   

000000000080070f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80070f:	55                   	push   %rbp
  800710:	48 89 e5             	mov    %rsp,%rbp
  800713:	48 83 ec 1c          	sub    $0x1c,%rsp
  800717:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80071b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80071e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800722:	7e 52                	jle    800776 <getint+0x67>
		x=va_arg(*ap, long long);
  800724:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800728:	8b 00                	mov    (%rax),%eax
  80072a:	83 f8 30             	cmp    $0x30,%eax
  80072d:	73 24                	jae    800753 <getint+0x44>
  80072f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800733:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800737:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80073b:	8b 00                	mov    (%rax),%eax
  80073d:	89 c0                	mov    %eax,%eax
  80073f:	48 01 d0             	add    %rdx,%rax
  800742:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800746:	8b 12                	mov    (%rdx),%edx
  800748:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80074b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80074f:	89 0a                	mov    %ecx,(%rdx)
  800751:	eb 17                	jmp    80076a <getint+0x5b>
  800753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800757:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80075b:	48 89 d0             	mov    %rdx,%rax
  80075e:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800762:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800766:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80076a:	48 8b 00             	mov    (%rax),%rax
  80076d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800771:	e9 a3 00 00 00       	jmpq   800819 <getint+0x10a>
	else if (lflag)
  800776:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80077a:	74 4f                	je     8007cb <getint+0xbc>
		x=va_arg(*ap, long);
  80077c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800780:	8b 00                	mov    (%rax),%eax
  800782:	83 f8 30             	cmp    $0x30,%eax
  800785:	73 24                	jae    8007ab <getint+0x9c>
  800787:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	8b 00                	mov    (%rax),%eax
  800795:	89 c0                	mov    %eax,%eax
  800797:	48 01 d0             	add    %rdx,%rax
  80079a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079e:	8b 12                	mov    (%rdx),%edx
  8007a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a7:	89 0a                	mov    %ecx,(%rdx)
  8007a9:	eb 17                	jmp    8007c2 <getint+0xb3>
  8007ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007af:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007b3:	48 89 d0             	mov    %rdx,%rax
  8007b6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007be:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007c2:	48 8b 00             	mov    (%rax),%rax
  8007c5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007c9:	eb 4e                	jmp    800819 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cf:	8b 00                	mov    (%rax),%eax
  8007d1:	83 f8 30             	cmp    $0x30,%eax
  8007d4:	73 24                	jae    8007fa <getint+0xeb>
  8007d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007da:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e2:	8b 00                	mov    (%rax),%eax
  8007e4:	89 c0                	mov    %eax,%eax
  8007e6:	48 01 d0             	add    %rdx,%rax
  8007e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ed:	8b 12                	mov    (%rdx),%edx
  8007ef:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007f6:	89 0a                	mov    %ecx,(%rdx)
  8007f8:	eb 17                	jmp    800811 <getint+0x102>
  8007fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fe:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800802:	48 89 d0             	mov    %rdx,%rax
  800805:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800809:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800811:	8b 00                	mov    (%rax),%eax
  800813:	48 98                	cltq   
  800815:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800819:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80081d:	c9                   	leaveq 
  80081e:	c3                   	retq   

000000000080081f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081f:	55                   	push   %rbp
  800820:	48 89 e5             	mov    %rsp,%rbp
  800823:	41 54                	push   %r12
  800825:	53                   	push   %rbx
  800826:	48 83 ec 60          	sub    $0x60,%rsp
  80082a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80082e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800832:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800836:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80083a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80083e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800842:	48 8b 0a             	mov    (%rdx),%rcx
  800845:	48 89 08             	mov    %rcx,(%rax)
  800848:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80084c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800850:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800854:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800858:	eb 17                	jmp    800871 <vprintfmt+0x52>
			if (ch == '\0')
  80085a:	85 db                	test   %ebx,%ebx
  80085c:	0f 84 cc 04 00 00    	je     800d2e <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  800862:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800866:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80086a:	48 89 d6             	mov    %rdx,%rsi
  80086d:	89 df                	mov    %ebx,%edi
  80086f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800871:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800875:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800879:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80087d:	0f b6 00             	movzbl (%rax),%eax
  800880:	0f b6 d8             	movzbl %al,%ebx
  800883:	83 fb 25             	cmp    $0x25,%ebx
  800886:	75 d2                	jne    80085a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800888:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80088c:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800893:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80089a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008a1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008a8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008b0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008b4:	0f b6 00             	movzbl (%rax),%eax
  8008b7:	0f b6 d8             	movzbl %al,%ebx
  8008ba:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008bd:	83 f8 55             	cmp    $0x55,%eax
  8008c0:	0f 87 34 04 00 00    	ja     800cfa <vprintfmt+0x4db>
  8008c6:	89 c0                	mov    %eax,%eax
  8008c8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008cf:	00 
  8008d0:	48 b8 f8 39 80 00 00 	movabs $0x8039f8,%rax
  8008d7:	00 00 00 
  8008da:	48 01 d0             	add    %rdx,%rax
  8008dd:	48 8b 00             	mov    (%rax),%rax
  8008e0:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008e2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008e6:	eb c0                	jmp    8008a8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008e8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008ec:	eb ba                	jmp    8008a8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ee:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008f5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008f8:	89 d0                	mov    %edx,%eax
  8008fa:	c1 e0 02             	shl    $0x2,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d8                	add    %ebx,%eax
  800903:	83 e8 30             	sub    $0x30,%eax
  800906:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800909:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80090d:	0f b6 00             	movzbl (%rax),%eax
  800910:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800913:	83 fb 2f             	cmp    $0x2f,%ebx
  800916:	7e 0c                	jle    800924 <vprintfmt+0x105>
  800918:	83 fb 39             	cmp    $0x39,%ebx
  80091b:	7f 07                	jg     800924 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800922:	eb d1                	jmp    8008f5 <vprintfmt+0xd6>
			goto process_precision;
  800924:	eb 58                	jmp    80097e <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800926:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800929:	83 f8 30             	cmp    $0x30,%eax
  80092c:	73 17                	jae    800945 <vprintfmt+0x126>
  80092e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800932:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800935:	89 c0                	mov    %eax,%eax
  800937:	48 01 d0             	add    %rdx,%rax
  80093a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80093d:	83 c2 08             	add    $0x8,%edx
  800940:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800943:	eb 0f                	jmp    800954 <vprintfmt+0x135>
  800945:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800949:	48 89 d0             	mov    %rdx,%rax
  80094c:	48 83 c2 08          	add    $0x8,%rdx
  800950:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800954:	8b 00                	mov    (%rax),%eax
  800956:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800959:	eb 23                	jmp    80097e <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  80095b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80095f:	79 0c                	jns    80096d <vprintfmt+0x14e>
				width = 0;
  800961:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800968:	e9 3b ff ff ff       	jmpq   8008a8 <vprintfmt+0x89>
  80096d:	e9 36 ff ff ff       	jmpq   8008a8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800972:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800979:	e9 2a ff ff ff       	jmpq   8008a8 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80097e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800982:	79 12                	jns    800996 <vprintfmt+0x177>
				width = precision, precision = -1;
  800984:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800987:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80098a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800991:	e9 12 ff ff ff       	jmpq   8008a8 <vprintfmt+0x89>
  800996:	e9 0d ff ff ff       	jmpq   8008a8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80099b:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80099f:	e9 04 ff ff ff       	jmpq   8008a8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009a4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009a7:	83 f8 30             	cmp    $0x30,%eax
  8009aa:	73 17                	jae    8009c3 <vprintfmt+0x1a4>
  8009ac:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009b0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009b3:	89 c0                	mov    %eax,%eax
  8009b5:	48 01 d0             	add    %rdx,%rax
  8009b8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009bb:	83 c2 08             	add    $0x8,%edx
  8009be:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009c1:	eb 0f                	jmp    8009d2 <vprintfmt+0x1b3>
  8009c3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009c7:	48 89 d0             	mov    %rdx,%rax
  8009ca:	48 83 c2 08          	add    $0x8,%rdx
  8009ce:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009d2:	8b 10                	mov    (%rax),%edx
  8009d4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009d8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009dc:	48 89 ce             	mov    %rcx,%rsi
  8009df:	89 d7                	mov    %edx,%edi
  8009e1:	ff d0                	callq  *%rax
			break;
  8009e3:	e9 40 03 00 00       	jmpq   800d28 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8009e8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009eb:	83 f8 30             	cmp    $0x30,%eax
  8009ee:	73 17                	jae    800a07 <vprintfmt+0x1e8>
  8009f0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009f4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f7:	89 c0                	mov    %eax,%eax
  8009f9:	48 01 d0             	add    %rdx,%rax
  8009fc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009ff:	83 c2 08             	add    $0x8,%edx
  800a02:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a05:	eb 0f                	jmp    800a16 <vprintfmt+0x1f7>
  800a07:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a0b:	48 89 d0             	mov    %rdx,%rax
  800a0e:	48 83 c2 08          	add    $0x8,%rdx
  800a12:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a16:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a18:	85 db                	test   %ebx,%ebx
  800a1a:	79 02                	jns    800a1e <vprintfmt+0x1ff>
				err = -err;
  800a1c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a1e:	83 fb 15             	cmp    $0x15,%ebx
  800a21:	7f 16                	jg     800a39 <vprintfmt+0x21a>
  800a23:	48 b8 20 39 80 00 00 	movabs $0x803920,%rax
  800a2a:	00 00 00 
  800a2d:	48 63 d3             	movslq %ebx,%rdx
  800a30:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a34:	4d 85 e4             	test   %r12,%r12
  800a37:	75 2e                	jne    800a67 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a39:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a41:	89 d9                	mov    %ebx,%ecx
  800a43:	48 ba e1 39 80 00 00 	movabs $0x8039e1,%rdx
  800a4a:	00 00 00 
  800a4d:	48 89 c7             	mov    %rax,%rdi
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
  800a55:	49 b8 37 0d 80 00 00 	movabs $0x800d37,%r8
  800a5c:	00 00 00 
  800a5f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a62:	e9 c1 02 00 00       	jmpq   800d28 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a67:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a6b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a6f:	4c 89 e1             	mov    %r12,%rcx
  800a72:	48 ba ea 39 80 00 00 	movabs $0x8039ea,%rdx
  800a79:	00 00 00 
  800a7c:	48 89 c7             	mov    %rax,%rdi
  800a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a84:	49 b8 37 0d 80 00 00 	movabs $0x800d37,%r8
  800a8b:	00 00 00 
  800a8e:	41 ff d0             	callq  *%r8
			break;
  800a91:	e9 92 02 00 00       	jmpq   800d28 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800a96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a99:	83 f8 30             	cmp    $0x30,%eax
  800a9c:	73 17                	jae    800ab5 <vprintfmt+0x296>
  800a9e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800aa2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800aa5:	89 c0                	mov    %eax,%eax
  800aa7:	48 01 d0             	add    %rdx,%rax
  800aaa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aad:	83 c2 08             	add    $0x8,%edx
  800ab0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ab3:	eb 0f                	jmp    800ac4 <vprintfmt+0x2a5>
  800ab5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ab9:	48 89 d0             	mov    %rdx,%rax
  800abc:	48 83 c2 08          	add    $0x8,%rdx
  800ac0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ac4:	4c 8b 20             	mov    (%rax),%r12
  800ac7:	4d 85 e4             	test   %r12,%r12
  800aca:	75 0a                	jne    800ad6 <vprintfmt+0x2b7>
				p = "(null)";
  800acc:	49 bc ed 39 80 00 00 	movabs $0x8039ed,%r12
  800ad3:	00 00 00 
			if (width > 0 && padc != '-')
  800ad6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ada:	7e 3f                	jle    800b1b <vprintfmt+0x2fc>
  800adc:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ae0:	74 39                	je     800b1b <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ae5:	48 98                	cltq   
  800ae7:	48 89 c6             	mov    %rax,%rsi
  800aea:	4c 89 e7             	mov    %r12,%rdi
  800aed:	48 b8 e3 0f 80 00 00 	movabs $0x800fe3,%rax
  800af4:	00 00 00 
  800af7:	ff d0                	callq  *%rax
  800af9:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800afc:	eb 17                	jmp    800b15 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800afe:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b02:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0a:	48 89 ce             	mov    %rcx,%rsi
  800b0d:	89 d7                	mov    %edx,%edi
  800b0f:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b11:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b15:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b19:	7f e3                	jg     800afe <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b1b:	eb 37                	jmp    800b54 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b21:	74 1e                	je     800b41 <vprintfmt+0x322>
  800b23:	83 fb 1f             	cmp    $0x1f,%ebx
  800b26:	7e 05                	jle    800b2d <vprintfmt+0x30e>
  800b28:	83 fb 7e             	cmp    $0x7e,%ebx
  800b2b:	7e 14                	jle    800b41 <vprintfmt+0x322>
					putch('?', putdat);
  800b2d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b35:	48 89 d6             	mov    %rdx,%rsi
  800b38:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b3d:	ff d0                	callq  *%rax
  800b3f:	eb 0f                	jmp    800b50 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b41:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b49:	48 89 d6             	mov    %rdx,%rsi
  800b4c:	89 df                	mov    %ebx,%edi
  800b4e:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b50:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b54:	4c 89 e0             	mov    %r12,%rax
  800b57:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b5b:	0f b6 00             	movzbl (%rax),%eax
  800b5e:	0f be d8             	movsbl %al,%ebx
  800b61:	85 db                	test   %ebx,%ebx
  800b63:	74 10                	je     800b75 <vprintfmt+0x356>
  800b65:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b69:	78 b2                	js     800b1d <vprintfmt+0x2fe>
  800b6b:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b6f:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b73:	79 a8                	jns    800b1d <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b75:	eb 16                	jmp    800b8d <vprintfmt+0x36e>
				putch(' ', putdat);
  800b77:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b7f:	48 89 d6             	mov    %rdx,%rsi
  800b82:	bf 20 00 00 00       	mov    $0x20,%edi
  800b87:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b89:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b91:	7f e4                	jg     800b77 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800b93:	e9 90 01 00 00       	jmpq   800d28 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800b98:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b9c:	be 03 00 00 00       	mov    $0x3,%esi
  800ba1:	48 89 c7             	mov    %rax,%rdi
  800ba4:	48 b8 0f 07 80 00 00 	movabs $0x80070f,%rax
  800bab:	00 00 00 
  800bae:	ff d0                	callq  *%rax
  800bb0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb8:	48 85 c0             	test   %rax,%rax
  800bbb:	79 1d                	jns    800bda <vprintfmt+0x3bb>
				putch('-', putdat);
  800bbd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bc1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bc5:	48 89 d6             	mov    %rdx,%rsi
  800bc8:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bcd:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd3:	48 f7 d8             	neg    %rax
  800bd6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bda:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800be1:	e9 d5 00 00 00       	jmpq   800cbb <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800be6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bea:	be 03 00 00 00       	mov    $0x3,%esi
  800bef:	48 89 c7             	mov    %rax,%rdi
  800bf2:	48 b8 ff 05 80 00 00 	movabs $0x8005ff,%rax
  800bf9:	00 00 00 
  800bfc:	ff d0                	callq  *%rax
  800bfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c02:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c09:	e9 ad 00 00 00       	jmpq   800cbb <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800c0e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c12:	be 03 00 00 00       	mov    $0x3,%esi
  800c17:	48 89 c7             	mov    %rax,%rdi
  800c1a:	48 b8 ff 05 80 00 00 	movabs $0x8005ff,%rax
  800c21:	00 00 00 
  800c24:	ff d0                	callq  *%rax
  800c26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800c2a:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800c31:	e9 85 00 00 00       	jmpq   800cbb <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c36:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c3e:	48 89 d6             	mov    %rdx,%rsi
  800c41:	bf 30 00 00 00       	mov    $0x30,%edi
  800c46:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c48:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c50:	48 89 d6             	mov    %rdx,%rsi
  800c53:	bf 78 00 00 00       	mov    $0x78,%edi
  800c58:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5d:	83 f8 30             	cmp    $0x30,%eax
  800c60:	73 17                	jae    800c79 <vprintfmt+0x45a>
  800c62:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c69:	89 c0                	mov    %eax,%eax
  800c6b:	48 01 d0             	add    %rdx,%rax
  800c6e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c71:	83 c2 08             	add    $0x8,%edx
  800c74:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c77:	eb 0f                	jmp    800c88 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800c79:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c7d:	48 89 d0             	mov    %rdx,%rax
  800c80:	48 83 c2 08          	add    $0x8,%rdx
  800c84:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c88:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c8f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c96:	eb 23                	jmp    800cbb <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800c98:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c9c:	be 03 00 00 00       	mov    $0x3,%esi
  800ca1:	48 89 c7             	mov    %rax,%rdi
  800ca4:	48 b8 ff 05 80 00 00 	movabs $0x8005ff,%rax
  800cab:	00 00 00 
  800cae:	ff d0                	callq  *%rax
  800cb0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800cb4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cbb:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cc0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cc3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cc6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cca:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cd2:	45 89 c1             	mov    %r8d,%r9d
  800cd5:	41 89 f8             	mov    %edi,%r8d
  800cd8:	48 89 c7             	mov    %rax,%rdi
  800cdb:	48 b8 44 05 80 00 00 	movabs $0x800544,%rax
  800ce2:	00 00 00 
  800ce5:	ff d0                	callq  *%rax
			break;
  800ce7:	eb 3f                	jmp    800d28 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ced:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf1:	48 89 d6             	mov    %rdx,%rsi
  800cf4:	89 df                	mov    %ebx,%edi
  800cf6:	ff d0                	callq  *%rax
			break;
  800cf8:	eb 2e                	jmp    800d28 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d02:	48 89 d6             	mov    %rdx,%rsi
  800d05:	bf 25 00 00 00       	mov    $0x25,%edi
  800d0a:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d11:	eb 05                	jmp    800d18 <vprintfmt+0x4f9>
  800d13:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d18:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d1c:	48 83 e8 01          	sub    $0x1,%rax
  800d20:	0f b6 00             	movzbl (%rax),%eax
  800d23:	3c 25                	cmp    $0x25,%al
  800d25:	75 ec                	jne    800d13 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d27:	90                   	nop
		}
	}
  800d28:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d29:	e9 43 fb ff ff       	jmpq   800871 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d2e:	48 83 c4 60          	add    $0x60,%rsp
  800d32:	5b                   	pop    %rbx
  800d33:	41 5c                	pop    %r12
  800d35:	5d                   	pop    %rbp
  800d36:	c3                   	retq   

0000000000800d37 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d37:	55                   	push   %rbp
  800d38:	48 89 e5             	mov    %rsp,%rbp
  800d3b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d42:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d49:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d50:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d57:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d5e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d65:	84 c0                	test   %al,%al
  800d67:	74 20                	je     800d89 <printfmt+0x52>
  800d69:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d6d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d71:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d75:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d79:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d7d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d81:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d85:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d89:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d90:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d97:	00 00 00 
  800d9a:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800da1:	00 00 00 
  800da4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800da8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800daf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800db6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800dbd:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800dc4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dcb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800dd2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800dd9:	48 89 c7             	mov    %rax,%rdi
  800ddc:	48 b8 1f 08 80 00 00 	movabs $0x80081f,%rax
  800de3:	00 00 00 
  800de6:	ff d0                	callq  *%rax
	va_end(ap);
}
  800de8:	c9                   	leaveq 
  800de9:	c3                   	retq   

0000000000800dea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dea:	55                   	push   %rbp
  800deb:	48 89 e5             	mov    %rsp,%rbp
  800dee:	48 83 ec 10          	sub    $0x10,%rsp
  800df2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800df5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800df9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dfd:	8b 40 10             	mov    0x10(%rax),%eax
  800e00:	8d 50 01             	lea    0x1(%rax),%edx
  800e03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e07:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e0e:	48 8b 10             	mov    (%rax),%rdx
  800e11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e15:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e19:	48 39 c2             	cmp    %rax,%rdx
  800e1c:	73 17                	jae    800e35 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e22:	48 8b 00             	mov    (%rax),%rax
  800e25:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e2d:	48 89 0a             	mov    %rcx,(%rdx)
  800e30:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e33:	88 10                	mov    %dl,(%rax)
}
  800e35:	c9                   	leaveq 
  800e36:	c3                   	retq   

0000000000800e37 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e37:	55                   	push   %rbp
  800e38:	48 89 e5             	mov    %rsp,%rbp
  800e3b:	48 83 ec 50          	sub    $0x50,%rsp
  800e3f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e43:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e46:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e4a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e4e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e52:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e56:	48 8b 0a             	mov    (%rdx),%rcx
  800e59:	48 89 08             	mov    %rcx,(%rax)
  800e5c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e60:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e64:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e68:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e6c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e70:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e74:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e77:	48 98                	cltq   
  800e79:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e7d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e81:	48 01 d0             	add    %rdx,%rax
  800e84:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e88:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e8f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e94:	74 06                	je     800e9c <vsnprintf+0x65>
  800e96:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e9a:	7f 07                	jg     800ea3 <vsnprintf+0x6c>
		return -E_INVAL;
  800e9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea1:	eb 2f                	jmp    800ed2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ea3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ea7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800eab:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800eaf:	48 89 c6             	mov    %rax,%rsi
  800eb2:	48 bf ea 0d 80 00 00 	movabs $0x800dea,%rdi
  800eb9:	00 00 00 
  800ebc:	48 b8 1f 08 80 00 00 	movabs $0x80081f,%rax
  800ec3:	00 00 00 
  800ec6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ec8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ecc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ecf:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ed2:	c9                   	leaveq 
  800ed3:	c3                   	retq   

0000000000800ed4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ed4:	55                   	push   %rbp
  800ed5:	48 89 e5             	mov    %rsp,%rbp
  800ed8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800edf:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ee6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800eec:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ef3:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800efa:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f01:	84 c0                	test   %al,%al
  800f03:	74 20                	je     800f25 <snprintf+0x51>
  800f05:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f09:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f0d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f11:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f15:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f19:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f1d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f21:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f25:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f2c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f33:	00 00 00 
  800f36:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f3d:	00 00 00 
  800f40:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f44:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f4b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f52:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f59:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f60:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f67:	48 8b 0a             	mov    (%rdx),%rcx
  800f6a:	48 89 08             	mov    %rcx,(%rax)
  800f6d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f71:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f75:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f79:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f7d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f84:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f8b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f91:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f98:	48 89 c7             	mov    %rax,%rdi
  800f9b:	48 b8 37 0e 80 00 00 	movabs $0x800e37,%rax
  800fa2:	00 00 00 
  800fa5:	ff d0                	callq  *%rax
  800fa7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fad:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fb3:	c9                   	leaveq 
  800fb4:	c3                   	retq   

0000000000800fb5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fb5:	55                   	push   %rbp
  800fb6:	48 89 e5             	mov    %rsp,%rbp
  800fb9:	48 83 ec 18          	sub    $0x18,%rsp
  800fbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800fc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fc8:	eb 09                	jmp    800fd3 <strlen+0x1e>
		n++;
  800fca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fce:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd7:	0f b6 00             	movzbl (%rax),%eax
  800fda:	84 c0                	test   %al,%al
  800fdc:	75 ec                	jne    800fca <strlen+0x15>
		n++;
	return n;
  800fde:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fe1:	c9                   	leaveq 
  800fe2:	c3                   	retq   

0000000000800fe3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fe3:	55                   	push   %rbp
  800fe4:	48 89 e5             	mov    %rsp,%rbp
  800fe7:	48 83 ec 20          	sub    $0x20,%rsp
  800feb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ffa:	eb 0e                	jmp    80100a <strnlen+0x27>
		n++;
  800ffc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801000:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801005:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80100a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80100f:	74 0b                	je     80101c <strnlen+0x39>
  801011:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801015:	0f b6 00             	movzbl (%rax),%eax
  801018:	84 c0                	test   %al,%al
  80101a:	75 e0                	jne    800ffc <strnlen+0x19>
		n++;
	return n;
  80101c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80101f:	c9                   	leaveq 
  801020:	c3                   	retq   

0000000000801021 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801021:	55                   	push   %rbp
  801022:	48 89 e5             	mov    %rsp,%rbp
  801025:	48 83 ec 20          	sub    $0x20,%rsp
  801029:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801031:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801035:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801039:	90                   	nop
  80103a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801042:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801046:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80104a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80104e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801052:	0f b6 12             	movzbl (%rdx),%edx
  801055:	88 10                	mov    %dl,(%rax)
  801057:	0f b6 00             	movzbl (%rax),%eax
  80105a:	84 c0                	test   %al,%al
  80105c:	75 dc                	jne    80103a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80105e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801062:	c9                   	leaveq 
  801063:	c3                   	retq   

0000000000801064 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801064:	55                   	push   %rbp
  801065:	48 89 e5             	mov    %rsp,%rbp
  801068:	48 83 ec 20          	sub    $0x20,%rsp
  80106c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801070:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801078:	48 89 c7             	mov    %rax,%rdi
  80107b:	48 b8 b5 0f 80 00 00 	movabs $0x800fb5,%rax
  801082:	00 00 00 
  801085:	ff d0                	callq  *%rax
  801087:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80108a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80108d:	48 63 d0             	movslq %eax,%rdx
  801090:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801094:	48 01 c2             	add    %rax,%rdx
  801097:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80109b:	48 89 c6             	mov    %rax,%rsi
  80109e:	48 89 d7             	mov    %rdx,%rdi
  8010a1:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  8010a8:	00 00 00 
  8010ab:	ff d0                	callq  *%rax
	return dst;
  8010ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010b1:	c9                   	leaveq 
  8010b2:	c3                   	retq   

00000000008010b3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010b3:	55                   	push   %rbp
  8010b4:	48 89 e5             	mov    %rsp,%rbp
  8010b7:	48 83 ec 28          	sub    $0x28,%rsp
  8010bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010cf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010d6:	00 
  8010d7:	eb 2a                	jmp    801103 <strncpy+0x50>
		*dst++ = *src;
  8010d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010e1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010e5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010e9:	0f b6 12             	movzbl (%rdx),%edx
  8010ec:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010f2:	0f b6 00             	movzbl (%rax),%eax
  8010f5:	84 c0                	test   %al,%al
  8010f7:	74 05                	je     8010fe <strncpy+0x4b>
			src++;
  8010f9:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801107:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80110b:	72 cc                	jb     8010d9 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801111:	c9                   	leaveq 
  801112:	c3                   	retq   

0000000000801113 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801113:	55                   	push   %rbp
  801114:	48 89 e5             	mov    %rsp,%rbp
  801117:	48 83 ec 28          	sub    $0x28,%rsp
  80111b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80111f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801123:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801127:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80112b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80112f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801134:	74 3d                	je     801173 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801136:	eb 1d                	jmp    801155 <strlcpy+0x42>
			*dst++ = *src++;
  801138:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801140:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801144:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801148:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80114c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801150:	0f b6 12             	movzbl (%rdx),%edx
  801153:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801155:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80115a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80115f:	74 0b                	je     80116c <strlcpy+0x59>
  801161:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801165:	0f b6 00             	movzbl (%rax),%eax
  801168:	84 c0                	test   %al,%al
  80116a:	75 cc                	jne    801138 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80116c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801170:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801173:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801177:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80117b:	48 29 c2             	sub    %rax,%rdx
  80117e:	48 89 d0             	mov    %rdx,%rax
}
  801181:	c9                   	leaveq 
  801182:	c3                   	retq   

0000000000801183 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801183:	55                   	push   %rbp
  801184:	48 89 e5             	mov    %rsp,%rbp
  801187:	48 83 ec 10          	sub    $0x10,%rsp
  80118b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80118f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801193:	eb 0a                	jmp    80119f <strcmp+0x1c>
		p++, q++;
  801195:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80119a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80119f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011a3:	0f b6 00             	movzbl (%rax),%eax
  8011a6:	84 c0                	test   %al,%al
  8011a8:	74 12                	je     8011bc <strcmp+0x39>
  8011aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ae:	0f b6 10             	movzbl (%rax),%edx
  8011b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011b5:	0f b6 00             	movzbl (%rax),%eax
  8011b8:	38 c2                	cmp    %al,%dl
  8011ba:	74 d9                	je     801195 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011c0:	0f b6 00             	movzbl (%rax),%eax
  8011c3:	0f b6 d0             	movzbl %al,%edx
  8011c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ca:	0f b6 00             	movzbl (%rax),%eax
  8011cd:	0f b6 c0             	movzbl %al,%eax
  8011d0:	29 c2                	sub    %eax,%edx
  8011d2:	89 d0                	mov    %edx,%eax
}
  8011d4:	c9                   	leaveq 
  8011d5:	c3                   	retq   

00000000008011d6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011d6:	55                   	push   %rbp
  8011d7:	48 89 e5             	mov    %rsp,%rbp
  8011da:	48 83 ec 18          	sub    $0x18,%rsp
  8011de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011ea:	eb 0f                	jmp    8011fb <strncmp+0x25>
		n--, p++, q++;
  8011ec:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011f6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011fb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801200:	74 1d                	je     80121f <strncmp+0x49>
  801202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801206:	0f b6 00             	movzbl (%rax),%eax
  801209:	84 c0                	test   %al,%al
  80120b:	74 12                	je     80121f <strncmp+0x49>
  80120d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801211:	0f b6 10             	movzbl (%rax),%edx
  801214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801218:	0f b6 00             	movzbl (%rax),%eax
  80121b:	38 c2                	cmp    %al,%dl
  80121d:	74 cd                	je     8011ec <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80121f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801224:	75 07                	jne    80122d <strncmp+0x57>
		return 0;
  801226:	b8 00 00 00 00       	mov    $0x0,%eax
  80122b:	eb 18                	jmp    801245 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80122d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801231:	0f b6 00             	movzbl (%rax),%eax
  801234:	0f b6 d0             	movzbl %al,%edx
  801237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80123b:	0f b6 00             	movzbl (%rax),%eax
  80123e:	0f b6 c0             	movzbl %al,%eax
  801241:	29 c2                	sub    %eax,%edx
  801243:	89 d0                	mov    %edx,%eax
}
  801245:	c9                   	leaveq 
  801246:	c3                   	retq   

0000000000801247 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801247:	55                   	push   %rbp
  801248:	48 89 e5             	mov    %rsp,%rbp
  80124b:	48 83 ec 0c          	sub    $0xc,%rsp
  80124f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801253:	89 f0                	mov    %esi,%eax
  801255:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801258:	eb 17                	jmp    801271 <strchr+0x2a>
		if (*s == c)
  80125a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80125e:	0f b6 00             	movzbl (%rax),%eax
  801261:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801264:	75 06                	jne    80126c <strchr+0x25>
			return (char *) s;
  801266:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126a:	eb 15                	jmp    801281 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80126c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801271:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801275:	0f b6 00             	movzbl (%rax),%eax
  801278:	84 c0                	test   %al,%al
  80127a:	75 de                	jne    80125a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80127c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801281:	c9                   	leaveq 
  801282:	c3                   	retq   

0000000000801283 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801283:	55                   	push   %rbp
  801284:	48 89 e5             	mov    %rsp,%rbp
  801287:	48 83 ec 0c          	sub    $0xc,%rsp
  80128b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80128f:	89 f0                	mov    %esi,%eax
  801291:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801294:	eb 13                	jmp    8012a9 <strfind+0x26>
		if (*s == c)
  801296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129a:	0f b6 00             	movzbl (%rax),%eax
  80129d:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012a0:	75 02                	jne    8012a4 <strfind+0x21>
			break;
  8012a2:	eb 10                	jmp    8012b4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012a4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ad:	0f b6 00             	movzbl (%rax),%eax
  8012b0:	84 c0                	test   %al,%al
  8012b2:	75 e2                	jne    801296 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012b8:	c9                   	leaveq 
  8012b9:	c3                   	retq   

00000000008012ba <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012ba:	55                   	push   %rbp
  8012bb:	48 89 e5             	mov    %rsp,%rbp
  8012be:	48 83 ec 18          	sub    $0x18,%rsp
  8012c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012c6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012c9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012cd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012d2:	75 06                	jne    8012da <memset+0x20>
		return v;
  8012d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d8:	eb 69                	jmp    801343 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012de:	83 e0 03             	and    $0x3,%eax
  8012e1:	48 85 c0             	test   %rax,%rax
  8012e4:	75 48                	jne    80132e <memset+0x74>
  8012e6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ea:	83 e0 03             	and    $0x3,%eax
  8012ed:	48 85 c0             	test   %rax,%rax
  8012f0:	75 3c                	jne    80132e <memset+0x74>
		c &= 0xFF;
  8012f2:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012f9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012fc:	c1 e0 18             	shl    $0x18,%eax
  8012ff:	89 c2                	mov    %eax,%edx
  801301:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801304:	c1 e0 10             	shl    $0x10,%eax
  801307:	09 c2                	or     %eax,%edx
  801309:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80130c:	c1 e0 08             	shl    $0x8,%eax
  80130f:	09 d0                	or     %edx,%eax
  801311:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801314:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801318:	48 c1 e8 02          	shr    $0x2,%rax
  80131c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80131f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801323:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801326:	48 89 d7             	mov    %rdx,%rdi
  801329:	fc                   	cld    
  80132a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80132c:	eb 11                	jmp    80133f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80132e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801332:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801335:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801339:	48 89 d7             	mov    %rdx,%rdi
  80133c:	fc                   	cld    
  80133d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80133f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801343:	c9                   	leaveq 
  801344:	c3                   	retq   

0000000000801345 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801345:	55                   	push   %rbp
  801346:	48 89 e5             	mov    %rsp,%rbp
  801349:	48 83 ec 28          	sub    $0x28,%rsp
  80134d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801351:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801355:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801359:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801365:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801369:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801371:	0f 83 88 00 00 00    	jae    8013ff <memmove+0xba>
  801377:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80137b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80137f:	48 01 d0             	add    %rdx,%rax
  801382:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801386:	76 77                	jbe    8013ff <memmove+0xba>
		s += n;
  801388:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80138c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801390:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801394:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801398:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139c:	83 e0 03             	and    $0x3,%eax
  80139f:	48 85 c0             	test   %rax,%rax
  8013a2:	75 3b                	jne    8013df <memmove+0x9a>
  8013a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a8:	83 e0 03             	and    $0x3,%eax
  8013ab:	48 85 c0             	test   %rax,%rax
  8013ae:	75 2f                	jne    8013df <memmove+0x9a>
  8013b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013b4:	83 e0 03             	and    $0x3,%eax
  8013b7:	48 85 c0             	test   %rax,%rax
  8013ba:	75 23                	jne    8013df <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c0:	48 83 e8 04          	sub    $0x4,%rax
  8013c4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013c8:	48 83 ea 04          	sub    $0x4,%rdx
  8013cc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013d0:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013d4:	48 89 c7             	mov    %rax,%rdi
  8013d7:	48 89 d6             	mov    %rdx,%rsi
  8013da:	fd                   	std    
  8013db:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013dd:	eb 1d                	jmp    8013fc <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013e3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013eb:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f3:	48 89 d7             	mov    %rdx,%rdi
  8013f6:	48 89 c1             	mov    %rax,%rcx
  8013f9:	fd                   	std    
  8013fa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013fc:	fc                   	cld    
  8013fd:	eb 57                	jmp    801456 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801403:	83 e0 03             	and    $0x3,%eax
  801406:	48 85 c0             	test   %rax,%rax
  801409:	75 36                	jne    801441 <memmove+0xfc>
  80140b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80140f:	83 e0 03             	and    $0x3,%eax
  801412:	48 85 c0             	test   %rax,%rax
  801415:	75 2a                	jne    801441 <memmove+0xfc>
  801417:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80141b:	83 e0 03             	and    $0x3,%eax
  80141e:	48 85 c0             	test   %rax,%rax
  801421:	75 1e                	jne    801441 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801423:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801427:	48 c1 e8 02          	shr    $0x2,%rax
  80142b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80142e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801432:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801436:	48 89 c7             	mov    %rax,%rdi
  801439:	48 89 d6             	mov    %rdx,%rsi
  80143c:	fc                   	cld    
  80143d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80143f:	eb 15                	jmp    801456 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801441:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801445:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801449:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80144d:	48 89 c7             	mov    %rax,%rdi
  801450:	48 89 d6             	mov    %rdx,%rsi
  801453:	fc                   	cld    
  801454:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80145a:	c9                   	leaveq 
  80145b:	c3                   	retq   

000000000080145c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80145c:	55                   	push   %rbp
  80145d:	48 89 e5             	mov    %rsp,%rbp
  801460:	48 83 ec 18          	sub    $0x18,%rsp
  801464:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801468:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80146c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801470:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801474:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801478:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147c:	48 89 ce             	mov    %rcx,%rsi
  80147f:	48 89 c7             	mov    %rax,%rdi
  801482:	48 b8 45 13 80 00 00 	movabs $0x801345,%rax
  801489:	00 00 00 
  80148c:	ff d0                	callq  *%rax
}
  80148e:	c9                   	leaveq 
  80148f:	c3                   	retq   

0000000000801490 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801490:	55                   	push   %rbp
  801491:	48 89 e5             	mov    %rsp,%rbp
  801494:	48 83 ec 28          	sub    $0x28,%rsp
  801498:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80149c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014b4:	eb 36                	jmp    8014ec <memcmp+0x5c>
		if (*s1 != *s2)
  8014b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ba:	0f b6 10             	movzbl (%rax),%edx
  8014bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c1:	0f b6 00             	movzbl (%rax),%eax
  8014c4:	38 c2                	cmp    %al,%dl
  8014c6:	74 1a                	je     8014e2 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cc:	0f b6 00             	movzbl (%rax),%eax
  8014cf:	0f b6 d0             	movzbl %al,%edx
  8014d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d6:	0f b6 00             	movzbl (%rax),%eax
  8014d9:	0f b6 c0             	movzbl %al,%eax
  8014dc:	29 c2                	sub    %eax,%edx
  8014de:	89 d0                	mov    %edx,%eax
  8014e0:	eb 20                	jmp    801502 <memcmp+0x72>
		s1++, s2++;
  8014e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014e7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014f8:	48 85 c0             	test   %rax,%rax
  8014fb:	75 b9                	jne    8014b6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801502:	c9                   	leaveq 
  801503:	c3                   	retq   

0000000000801504 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801504:	55                   	push   %rbp
  801505:	48 89 e5             	mov    %rsp,%rbp
  801508:	48 83 ec 28          	sub    $0x28,%rsp
  80150c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801510:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801513:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801517:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80151f:	48 01 d0             	add    %rdx,%rax
  801522:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801526:	eb 15                	jmp    80153d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801528:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152c:	0f b6 10             	movzbl (%rax),%edx
  80152f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801532:	38 c2                	cmp    %al,%dl
  801534:	75 02                	jne    801538 <memfind+0x34>
			break;
  801536:	eb 0f                	jmp    801547 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801538:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80153d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801541:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801545:	72 e1                	jb     801528 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801547:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80154b:	c9                   	leaveq 
  80154c:	c3                   	retq   

000000000080154d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80154d:	55                   	push   %rbp
  80154e:	48 89 e5             	mov    %rsp,%rbp
  801551:	48 83 ec 34          	sub    $0x34,%rsp
  801555:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801559:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80155d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801560:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801567:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80156e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80156f:	eb 05                	jmp    801576 <strtol+0x29>
		s++;
  801571:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801576:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157a:	0f b6 00             	movzbl (%rax),%eax
  80157d:	3c 20                	cmp    $0x20,%al
  80157f:	74 f0                	je     801571 <strtol+0x24>
  801581:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	3c 09                	cmp    $0x9,%al
  80158a:	74 e5                	je     801571 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80158c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	3c 2b                	cmp    $0x2b,%al
  801595:	75 07                	jne    80159e <strtol+0x51>
		s++;
  801597:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80159c:	eb 17                	jmp    8015b5 <strtol+0x68>
	else if (*s == '-')
  80159e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a2:	0f b6 00             	movzbl (%rax),%eax
  8015a5:	3c 2d                	cmp    $0x2d,%al
  8015a7:	75 0c                	jne    8015b5 <strtol+0x68>
		s++, neg = 1;
  8015a9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015ae:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015b5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015b9:	74 06                	je     8015c1 <strtol+0x74>
  8015bb:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015bf:	75 28                	jne    8015e9 <strtol+0x9c>
  8015c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c5:	0f b6 00             	movzbl (%rax),%eax
  8015c8:	3c 30                	cmp    $0x30,%al
  8015ca:	75 1d                	jne    8015e9 <strtol+0x9c>
  8015cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d0:	48 83 c0 01          	add    $0x1,%rax
  8015d4:	0f b6 00             	movzbl (%rax),%eax
  8015d7:	3c 78                	cmp    $0x78,%al
  8015d9:	75 0e                	jne    8015e9 <strtol+0x9c>
		s += 2, base = 16;
  8015db:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015e0:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015e7:	eb 2c                	jmp    801615 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015ed:	75 19                	jne    801608 <strtol+0xbb>
  8015ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f3:	0f b6 00             	movzbl (%rax),%eax
  8015f6:	3c 30                	cmp    $0x30,%al
  8015f8:	75 0e                	jne    801608 <strtol+0xbb>
		s++, base = 8;
  8015fa:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015ff:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801606:	eb 0d                	jmp    801615 <strtol+0xc8>
	else if (base == 0)
  801608:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80160c:	75 07                	jne    801615 <strtol+0xc8>
		base = 10;
  80160e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801615:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801619:	0f b6 00             	movzbl (%rax),%eax
  80161c:	3c 2f                	cmp    $0x2f,%al
  80161e:	7e 1d                	jle    80163d <strtol+0xf0>
  801620:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801624:	0f b6 00             	movzbl (%rax),%eax
  801627:	3c 39                	cmp    $0x39,%al
  801629:	7f 12                	jg     80163d <strtol+0xf0>
			dig = *s - '0';
  80162b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162f:	0f b6 00             	movzbl (%rax),%eax
  801632:	0f be c0             	movsbl %al,%eax
  801635:	83 e8 30             	sub    $0x30,%eax
  801638:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80163b:	eb 4e                	jmp    80168b <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80163d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801641:	0f b6 00             	movzbl (%rax),%eax
  801644:	3c 60                	cmp    $0x60,%al
  801646:	7e 1d                	jle    801665 <strtol+0x118>
  801648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	3c 7a                	cmp    $0x7a,%al
  801651:	7f 12                	jg     801665 <strtol+0x118>
			dig = *s - 'a' + 10;
  801653:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801657:	0f b6 00             	movzbl (%rax),%eax
  80165a:	0f be c0             	movsbl %al,%eax
  80165d:	83 e8 57             	sub    $0x57,%eax
  801660:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801663:	eb 26                	jmp    80168b <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801665:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801669:	0f b6 00             	movzbl (%rax),%eax
  80166c:	3c 40                	cmp    $0x40,%al
  80166e:	7e 48                	jle    8016b8 <strtol+0x16b>
  801670:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801674:	0f b6 00             	movzbl (%rax),%eax
  801677:	3c 5a                	cmp    $0x5a,%al
  801679:	7f 3d                	jg     8016b8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80167b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167f:	0f b6 00             	movzbl (%rax),%eax
  801682:	0f be c0             	movsbl %al,%eax
  801685:	83 e8 37             	sub    $0x37,%eax
  801688:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80168b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80168e:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801691:	7c 02                	jl     801695 <strtol+0x148>
			break;
  801693:	eb 23                	jmp    8016b8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801695:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80169a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80169d:	48 98                	cltq   
  80169f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016a4:	48 89 c2             	mov    %rax,%rdx
  8016a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016aa:	48 98                	cltq   
  8016ac:	48 01 d0             	add    %rdx,%rax
  8016af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016b3:	e9 5d ff ff ff       	jmpq   801615 <strtol+0xc8>

	if (endptr)
  8016b8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016bd:	74 0b                	je     8016ca <strtol+0x17d>
		*endptr = (char *) s;
  8016bf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016c3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016c7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016ce:	74 09                	je     8016d9 <strtol+0x18c>
  8016d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d4:	48 f7 d8             	neg    %rax
  8016d7:	eb 04                	jmp    8016dd <strtol+0x190>
  8016d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016dd:	c9                   	leaveq 
  8016de:	c3                   	retq   

00000000008016df <strstr>:

char * strstr(const char *in, const char *str)
{
  8016df:	55                   	push   %rbp
  8016e0:	48 89 e5             	mov    %rsp,%rbp
  8016e3:	48 83 ec 30          	sub    $0x30,%rsp
  8016e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8016ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016f7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016fb:	0f b6 00             	movzbl (%rax),%eax
  8016fe:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801701:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801705:	75 06                	jne    80170d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801707:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170b:	eb 6b                	jmp    801778 <strstr+0x99>

	len = strlen(str);
  80170d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801711:	48 89 c7             	mov    %rax,%rdi
  801714:	48 b8 b5 0f 80 00 00 	movabs $0x800fb5,%rax
  80171b:	00 00 00 
  80171e:	ff d0                	callq  *%rax
  801720:	48 98                	cltq   
  801722:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801726:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80172a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80172e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801732:	0f b6 00             	movzbl (%rax),%eax
  801735:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801738:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80173c:	75 07                	jne    801745 <strstr+0x66>
				return (char *) 0;
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
  801743:	eb 33                	jmp    801778 <strstr+0x99>
		} while (sc != c);
  801745:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801749:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80174c:	75 d8                	jne    801726 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80174e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801752:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801756:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175a:	48 89 ce             	mov    %rcx,%rsi
  80175d:	48 89 c7             	mov    %rax,%rdi
  801760:	48 b8 d6 11 80 00 00 	movabs $0x8011d6,%rax
  801767:	00 00 00 
  80176a:	ff d0                	callq  *%rax
  80176c:	85 c0                	test   %eax,%eax
  80176e:	75 b6                	jne    801726 <strstr+0x47>

	return (char *) (in - 1);
  801770:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801774:	48 83 e8 01          	sub    $0x1,%rax
}
  801778:	c9                   	leaveq 
  801779:	c3                   	retq   

000000000080177a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80177a:	55                   	push   %rbp
  80177b:	48 89 e5             	mov    %rsp,%rbp
  80177e:	53                   	push   %rbx
  80177f:	48 83 ec 48          	sub    $0x48,%rsp
  801783:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801786:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801789:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80178d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801791:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801795:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801799:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80179c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017a0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017a4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017a8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017ac:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017b0:	4c 89 c3             	mov    %r8,%rbx
  8017b3:	cd 30                	int    $0x30
  8017b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  8017b9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017bd:	74 3e                	je     8017fd <syscall+0x83>
  8017bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017c4:	7e 37                	jle    8017fd <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017cd:	49 89 d0             	mov    %rdx,%r8
  8017d0:	89 c1                	mov    %eax,%ecx
  8017d2:	48 ba a8 3c 80 00 00 	movabs $0x803ca8,%rdx
  8017d9:	00 00 00 
  8017dc:	be 4a 00 00 00       	mov    $0x4a,%esi
  8017e1:	48 bf c5 3c 80 00 00 	movabs $0x803cc5,%rdi
  8017e8:	00 00 00 
  8017eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f0:	49 b9 33 02 80 00 00 	movabs $0x800233,%r9
  8017f7:	00 00 00 
  8017fa:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8017fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801801:	48 83 c4 48          	add    $0x48,%rsp
  801805:	5b                   	pop    %rbx
  801806:	5d                   	pop    %rbp
  801807:	c3                   	retq   

0000000000801808 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801808:	55                   	push   %rbp
  801809:	48 89 e5             	mov    %rsp,%rbp
  80180c:	48 83 ec 20          	sub    $0x20,%rsp
  801810:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801814:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801818:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80181c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801820:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801827:	00 
  801828:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801834:	48 89 d1             	mov    %rdx,%rcx
  801837:	48 89 c2             	mov    %rax,%rdx
  80183a:	be 00 00 00 00       	mov    $0x0,%esi
  80183f:	bf 00 00 00 00       	mov    $0x0,%edi
  801844:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  80184b:	00 00 00 
  80184e:	ff d0                	callq  *%rax
}
  801850:	c9                   	leaveq 
  801851:	c3                   	retq   

0000000000801852 <sys_cgetc>:

int
sys_cgetc(void)
{
  801852:	55                   	push   %rbp
  801853:	48 89 e5             	mov    %rsp,%rbp
  801856:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80185a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801861:	00 
  801862:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801868:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80186e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801873:	ba 00 00 00 00       	mov    $0x0,%edx
  801878:	be 00 00 00 00       	mov    $0x0,%esi
  80187d:	bf 01 00 00 00       	mov    $0x1,%edi
  801882:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  801889:	00 00 00 
  80188c:	ff d0                	callq  *%rax
}
  80188e:	c9                   	leaveq 
  80188f:	c3                   	retq   

0000000000801890 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801890:	55                   	push   %rbp
  801891:	48 89 e5             	mov    %rsp,%rbp
  801894:	48 83 ec 10          	sub    $0x10,%rsp
  801898:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80189b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80189e:	48 98                	cltq   
  8018a0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018a7:	00 
  8018a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b9:	48 89 c2             	mov    %rax,%rdx
  8018bc:	be 01 00 00 00       	mov    $0x1,%esi
  8018c1:	bf 03 00 00 00       	mov    $0x3,%edi
  8018c6:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  8018cd:	00 00 00 
  8018d0:	ff d0                	callq  *%rax
}
  8018d2:	c9                   	leaveq 
  8018d3:	c3                   	retq   

00000000008018d4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018d4:	55                   	push   %rbp
  8018d5:	48 89 e5             	mov    %rsp,%rbp
  8018d8:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018dc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018e3:	00 
  8018e4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018ea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fa:	be 00 00 00 00       	mov    $0x0,%esi
  8018ff:	bf 02 00 00 00       	mov    $0x2,%edi
  801904:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  80190b:	00 00 00 
  80190e:	ff d0                	callq  *%rax
}
  801910:	c9                   	leaveq 
  801911:	c3                   	retq   

0000000000801912 <sys_yield>:

void
sys_yield(void)
{
  801912:	55                   	push   %rbp
  801913:	48 89 e5             	mov    %rsp,%rbp
  801916:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80191a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801921:	00 
  801922:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801928:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80192e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801933:	ba 00 00 00 00       	mov    $0x0,%edx
  801938:	be 00 00 00 00       	mov    $0x0,%esi
  80193d:	bf 0b 00 00 00       	mov    $0xb,%edi
  801942:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  801949:	00 00 00 
  80194c:	ff d0                	callq  *%rax
}
  80194e:	c9                   	leaveq 
  80194f:	c3                   	retq   

0000000000801950 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801950:	55                   	push   %rbp
  801951:	48 89 e5             	mov    %rsp,%rbp
  801954:	48 83 ec 20          	sub    $0x20,%rsp
  801958:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80195b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80195f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801962:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801965:	48 63 c8             	movslq %eax,%rcx
  801968:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80196c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196f:	48 98                	cltq   
  801971:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801978:	00 
  801979:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197f:	49 89 c8             	mov    %rcx,%r8
  801982:	48 89 d1             	mov    %rdx,%rcx
  801985:	48 89 c2             	mov    %rax,%rdx
  801988:	be 01 00 00 00       	mov    $0x1,%esi
  80198d:	bf 04 00 00 00       	mov    $0x4,%edi
  801992:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  801999:	00 00 00 
  80199c:	ff d0                	callq  *%rax
}
  80199e:	c9                   	leaveq 
  80199f:	c3                   	retq   

00000000008019a0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8019a0:	55                   	push   %rbp
  8019a1:	48 89 e5             	mov    %rsp,%rbp
  8019a4:	48 83 ec 30          	sub    $0x30,%rsp
  8019a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8019af:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8019b2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8019b6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8019ba:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019bd:	48 63 c8             	movslq %eax,%rcx
  8019c0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019c7:	48 63 f0             	movslq %eax,%rsi
  8019ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d1:	48 98                	cltq   
  8019d3:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019d7:	49 89 f9             	mov    %rdi,%r9
  8019da:	49 89 f0             	mov    %rsi,%r8
  8019dd:	48 89 d1             	mov    %rdx,%rcx
  8019e0:	48 89 c2             	mov    %rax,%rdx
  8019e3:	be 01 00 00 00       	mov    $0x1,%esi
  8019e8:	bf 05 00 00 00       	mov    $0x5,%edi
  8019ed:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  8019f4:	00 00 00 
  8019f7:	ff d0                	callq  *%rax
}
  8019f9:	c9                   	leaveq 
  8019fa:	c3                   	retq   

00000000008019fb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019fb:	55                   	push   %rbp
  8019fc:	48 89 e5             	mov    %rsp,%rbp
  8019ff:	48 83 ec 20          	sub    $0x20,%rsp
  801a03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801a0a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a11:	48 98                	cltq   
  801a13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a1a:	00 
  801a1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a27:	48 89 d1             	mov    %rdx,%rcx
  801a2a:	48 89 c2             	mov    %rax,%rdx
  801a2d:	be 01 00 00 00       	mov    $0x1,%esi
  801a32:	bf 06 00 00 00       	mov    $0x6,%edi
  801a37:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  801a3e:	00 00 00 
  801a41:	ff d0                	callq  *%rax
}
  801a43:	c9                   	leaveq 
  801a44:	c3                   	retq   

0000000000801a45 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a45:	55                   	push   %rbp
  801a46:	48 89 e5             	mov    %rsp,%rbp
  801a49:	48 83 ec 10          	sub    $0x10,%rsp
  801a4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a50:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a53:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a56:	48 63 d0             	movslq %eax,%rdx
  801a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5c:	48 98                	cltq   
  801a5e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a65:	00 
  801a66:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a6c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a72:	48 89 d1             	mov    %rdx,%rcx
  801a75:	48 89 c2             	mov    %rax,%rdx
  801a78:	be 01 00 00 00       	mov    $0x1,%esi
  801a7d:	bf 08 00 00 00       	mov    $0x8,%edi
  801a82:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  801a89:	00 00 00 
  801a8c:	ff d0                	callq  *%rax
}
  801a8e:	c9                   	leaveq 
  801a8f:	c3                   	retq   

0000000000801a90 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a90:	55                   	push   %rbp
  801a91:	48 89 e5             	mov    %rsp,%rbp
  801a94:	48 83 ec 20          	sub    $0x20,%rsp
  801a98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801a9f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801aa6:	48 98                	cltq   
  801aa8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aaf:	00 
  801ab0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ab6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801abc:	48 89 d1             	mov    %rdx,%rcx
  801abf:	48 89 c2             	mov    %rax,%rdx
  801ac2:	be 01 00 00 00       	mov    $0x1,%esi
  801ac7:	bf 09 00 00 00       	mov    $0x9,%edi
  801acc:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  801ad3:	00 00 00 
  801ad6:	ff d0                	callq  *%rax
}
  801ad8:	c9                   	leaveq 
  801ad9:	c3                   	retq   

0000000000801ada <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ada:	55                   	push   %rbp
  801adb:	48 89 e5             	mov    %rsp,%rbp
  801ade:	48 83 ec 20          	sub    $0x20,%rsp
  801ae2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ae5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801ae9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af0:	48 98                	cltq   
  801af2:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801af9:	00 
  801afa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b00:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b06:	48 89 d1             	mov    %rdx,%rcx
  801b09:	48 89 c2             	mov    %rax,%rdx
  801b0c:	be 01 00 00 00       	mov    $0x1,%esi
  801b11:	bf 0a 00 00 00       	mov    $0xa,%edi
  801b16:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  801b1d:	00 00 00 
  801b20:	ff d0                	callq  *%rax
}
  801b22:	c9                   	leaveq 
  801b23:	c3                   	retq   

0000000000801b24 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801b24:	55                   	push   %rbp
  801b25:	48 89 e5             	mov    %rsp,%rbp
  801b28:	48 83 ec 20          	sub    $0x20,%rsp
  801b2c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b33:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b37:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801b3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b3d:	48 63 f0             	movslq %eax,%rsi
  801b40:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801b44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b47:	48 98                	cltq   
  801b49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b54:	00 
  801b55:	49 89 f1             	mov    %rsi,%r9
  801b58:	49 89 c8             	mov    %rcx,%r8
  801b5b:	48 89 d1             	mov    %rdx,%rcx
  801b5e:	48 89 c2             	mov    %rax,%rdx
  801b61:	be 00 00 00 00       	mov    $0x0,%esi
  801b66:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b6b:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  801b72:	00 00 00 
  801b75:	ff d0                	callq  *%rax
}
  801b77:	c9                   	leaveq 
  801b78:	c3                   	retq   

0000000000801b79 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b79:	55                   	push   %rbp
  801b7a:	48 89 e5             	mov    %rsp,%rbp
  801b7d:	48 83 ec 10          	sub    $0x10,%rsp
  801b81:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b89:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b90:	00 
  801b91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ba2:	48 89 c2             	mov    %rax,%rdx
  801ba5:	be 01 00 00 00       	mov    $0x1,%esi
  801baa:	bf 0d 00 00 00       	mov    $0xd,%edi
  801baf:	48 b8 7a 17 80 00 00 	movabs $0x80177a,%rax
  801bb6:	00 00 00 
  801bb9:	ff d0                	callq  *%rax
}
  801bbb:	c9                   	leaveq 
  801bbc:	c3                   	retq   

0000000000801bbd <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801bbd:	55                   	push   %rbp
  801bbe:	48 89 e5             	mov    %rsp,%rbp
  801bc1:	48 83 ec 10          	sub    $0x10,%rsp
  801bc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  801bc9:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801bd0:	00 00 00 
  801bd3:	48 8b 00             	mov    (%rax),%rax
  801bd6:	48 85 c0             	test   %rax,%rax
  801bd9:	75 64                	jne    801c3f <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  801bdb:	ba 07 00 00 00       	mov    $0x7,%edx
  801be0:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801be5:	bf 00 00 00 00       	mov    $0x0,%edi
  801bea:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  801bf1:	00 00 00 
  801bf4:	ff d0                	callq  *%rax
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	74 2a                	je     801c24 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  801bfa:	48 ba d8 3c 80 00 00 	movabs $0x803cd8,%rdx
  801c01:	00 00 00 
  801c04:	be 22 00 00 00       	mov    $0x22,%esi
  801c09:	48 bf 00 3d 80 00 00 	movabs $0x803d00,%rdi
  801c10:	00 00 00 
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
  801c18:	48 b9 33 02 80 00 00 	movabs $0x800233,%rcx
  801c1f:	00 00 00 
  801c22:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801c24:	48 be 52 1c 80 00 00 	movabs $0x801c52,%rsi
  801c2b:	00 00 00 
  801c2e:	bf 00 00 00 00       	mov    $0x0,%edi
  801c33:	48 b8 da 1a 80 00 00 	movabs $0x801ada,%rax
  801c3a:	00 00 00 
  801c3d:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801c3f:	48 b8 10 60 80 00 00 	movabs $0x806010,%rax
  801c46:	00 00 00 
  801c49:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c4d:	48 89 10             	mov    %rdx,(%rax)
}
  801c50:	c9                   	leaveq 
  801c51:	c3                   	retq   

0000000000801c52 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  801c52:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  801c55:	48 a1 10 60 80 00 00 	movabs 0x806010,%rax
  801c5c:	00 00 00 
call *%rax
  801c5f:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  801c61:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  801c68:	00 
mov 136(%rsp), %r9
  801c69:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  801c70:	00 
sub $8, %r8
  801c71:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  801c75:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  801c78:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  801c7f:	00 
add $16, %rsp
  801c80:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  801c84:	4c 8b 3c 24          	mov    (%rsp),%r15
  801c88:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801c8d:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801c92:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801c97:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801c9c:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801ca1:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801ca6:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801cab:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801cb0:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801cb5:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801cba:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801cbf:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801cc4:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801cc9:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801cce:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  801cd2:	48 83 c4 08          	add    $0x8,%rsp
popf
  801cd6:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  801cd7:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  801cdb:	c3                   	retq   

0000000000801cdc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801cdc:	55                   	push   %rbp
  801cdd:	48 89 e5             	mov    %rsp,%rbp
  801ce0:	48 83 ec 08          	sub    $0x8,%rsp
  801ce4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ce8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cec:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801cf3:	ff ff ff 
  801cf6:	48 01 d0             	add    %rdx,%rax
  801cf9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801cfd:	c9                   	leaveq 
  801cfe:	c3                   	retq   

0000000000801cff <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cff:	55                   	push   %rbp
  801d00:	48 89 e5             	mov    %rsp,%rbp
  801d03:	48 83 ec 08          	sub    $0x8,%rsp
  801d07:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801d0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d0f:	48 89 c7             	mov    %rax,%rdi
  801d12:	48 b8 dc 1c 80 00 00 	movabs $0x801cdc,%rax
  801d19:	00 00 00 
  801d1c:	ff d0                	callq  *%rax
  801d1e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801d24:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801d28:	c9                   	leaveq 
  801d29:	c3                   	retq   

0000000000801d2a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d2a:	55                   	push   %rbp
  801d2b:	48 89 e5             	mov    %rsp,%rbp
  801d2e:	48 83 ec 18          	sub    $0x18,%rsp
  801d32:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d3d:	eb 6b                	jmp    801daa <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801d3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d42:	48 98                	cltq   
  801d44:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d4a:	48 c1 e0 0c          	shl    $0xc,%rax
  801d4e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d56:	48 c1 e8 15          	shr    $0x15,%rax
  801d5a:	48 89 c2             	mov    %rax,%rdx
  801d5d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d64:	01 00 00 
  801d67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d6b:	83 e0 01             	and    $0x1,%eax
  801d6e:	48 85 c0             	test   %rax,%rax
  801d71:	74 21                	je     801d94 <fd_alloc+0x6a>
  801d73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d77:	48 c1 e8 0c          	shr    $0xc,%rax
  801d7b:	48 89 c2             	mov    %rax,%rdx
  801d7e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d85:	01 00 00 
  801d88:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d8c:	83 e0 01             	and    $0x1,%eax
  801d8f:	48 85 c0             	test   %rax,%rax
  801d92:	75 12                	jne    801da6 <fd_alloc+0x7c>
			*fd_store = fd;
  801d94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d9c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801da4:	eb 1a                	jmp    801dc0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801da6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801daa:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801dae:	7e 8f                	jle    801d3f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801db4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801dbb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801dc0:	c9                   	leaveq 
  801dc1:	c3                   	retq   

0000000000801dc2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801dc2:	55                   	push   %rbp
  801dc3:	48 89 e5             	mov    %rsp,%rbp
  801dc6:	48 83 ec 20          	sub    $0x20,%rsp
  801dca:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801dcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801dd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801dd5:	78 06                	js     801ddd <fd_lookup+0x1b>
  801dd7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ddb:	7e 07                	jle    801de4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ddd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801de2:	eb 6c                	jmp    801e50 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801de4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801de7:	48 98                	cltq   
  801de9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801def:	48 c1 e0 0c          	shl    $0xc,%rax
  801df3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801df7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dfb:	48 c1 e8 15          	shr    $0x15,%rax
  801dff:	48 89 c2             	mov    %rax,%rdx
  801e02:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e09:	01 00 00 
  801e0c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e10:	83 e0 01             	and    $0x1,%eax
  801e13:	48 85 c0             	test   %rax,%rax
  801e16:	74 21                	je     801e39 <fd_lookup+0x77>
  801e18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e1c:	48 c1 e8 0c          	shr    $0xc,%rax
  801e20:	48 89 c2             	mov    %rax,%rdx
  801e23:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e2a:	01 00 00 
  801e2d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e31:	83 e0 01             	and    $0x1,%eax
  801e34:	48 85 c0             	test   %rax,%rax
  801e37:	75 07                	jne    801e40 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e3e:	eb 10                	jmp    801e50 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801e40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e44:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e48:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e50:	c9                   	leaveq 
  801e51:	c3                   	retq   

0000000000801e52 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e52:	55                   	push   %rbp
  801e53:	48 89 e5             	mov    %rsp,%rbp
  801e56:	48 83 ec 30          	sub    $0x30,%rsp
  801e5a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e5e:	89 f0                	mov    %esi,%eax
  801e60:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e67:	48 89 c7             	mov    %rax,%rdi
  801e6a:	48 b8 dc 1c 80 00 00 	movabs $0x801cdc,%rax
  801e71:	00 00 00 
  801e74:	ff d0                	callq  *%rax
  801e76:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e7a:	48 89 d6             	mov    %rdx,%rsi
  801e7d:	89 c7                	mov    %eax,%edi
  801e7f:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  801e86:	00 00 00 
  801e89:	ff d0                	callq  *%rax
  801e8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e92:	78 0a                	js     801e9e <fd_close+0x4c>
	    || fd != fd2)
  801e94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e98:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e9c:	74 12                	je     801eb0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e9e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801ea2:	74 05                	je     801ea9 <fd_close+0x57>
  801ea4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea7:	eb 05                	jmp    801eae <fd_close+0x5c>
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eae:	eb 69                	jmp    801f19 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801eb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eb4:	8b 00                	mov    (%rax),%eax
  801eb6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801eba:	48 89 d6             	mov    %rdx,%rsi
  801ebd:	89 c7                	mov    %eax,%edi
  801ebf:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  801ec6:	00 00 00 
  801ec9:	ff d0                	callq  *%rax
  801ecb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ece:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ed2:	78 2a                	js     801efe <fd_close+0xac>
		if (dev->dev_close)
  801ed4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed8:	48 8b 40 20          	mov    0x20(%rax),%rax
  801edc:	48 85 c0             	test   %rax,%rax
  801edf:	74 16                	je     801ef7 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801ee1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee5:	48 8b 40 20          	mov    0x20(%rax),%rax
  801ee9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801eed:	48 89 d7             	mov    %rdx,%rdi
  801ef0:	ff d0                	callq  *%rax
  801ef2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ef5:	eb 07                	jmp    801efe <fd_close+0xac>
		else
			r = 0;
  801ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801efe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f02:	48 89 c6             	mov    %rax,%rsi
  801f05:	bf 00 00 00 00       	mov    $0x0,%edi
  801f0a:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  801f11:	00 00 00 
  801f14:	ff d0                	callq  *%rax
	return r;
  801f16:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f19:	c9                   	leaveq 
  801f1a:	c3                   	retq   

0000000000801f1b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801f1b:	55                   	push   %rbp
  801f1c:	48 89 e5             	mov    %rsp,%rbp
  801f1f:	48 83 ec 20          	sub    $0x20,%rsp
  801f23:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801f26:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801f2a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f31:	eb 41                	jmp    801f74 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801f33:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f3a:	00 00 00 
  801f3d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f40:	48 63 d2             	movslq %edx,%rdx
  801f43:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f47:	8b 00                	mov    (%rax),%eax
  801f49:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801f4c:	75 22                	jne    801f70 <dev_lookup+0x55>
			*dev = devtab[i];
  801f4e:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f55:	00 00 00 
  801f58:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f5b:	48 63 d2             	movslq %edx,%rdx
  801f5e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f62:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f66:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6e:	eb 60                	jmp    801fd0 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f70:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f74:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f7b:	00 00 00 
  801f7e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f81:	48 63 d2             	movslq %edx,%rdx
  801f84:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f88:	48 85 c0             	test   %rax,%rax
  801f8b:	75 a6                	jne    801f33 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f8d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  801f94:	00 00 00 
  801f97:	48 8b 00             	mov    (%rax),%rax
  801f9a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801fa0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fa3:	89 c6                	mov    %eax,%esi
  801fa5:	48 bf 10 3d 80 00 00 	movabs $0x803d10,%rdi
  801fac:	00 00 00 
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb4:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  801fbb:	00 00 00 
  801fbe:	ff d1                	callq  *%rcx
	*dev = 0;
  801fc0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fc4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801fcb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801fd0:	c9                   	leaveq 
  801fd1:	c3                   	retq   

0000000000801fd2 <close>:

int
close(int fdnum)
{
  801fd2:	55                   	push   %rbp
  801fd3:	48 89 e5             	mov    %rsp,%rbp
  801fd6:	48 83 ec 20          	sub    $0x20,%rsp
  801fda:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fdd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801fe1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fe4:	48 89 d6             	mov    %rdx,%rsi
  801fe7:	89 c7                	mov    %eax,%edi
  801fe9:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  801ff0:	00 00 00 
  801ff3:	ff d0                	callq  *%rax
  801ff5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ff8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ffc:	79 05                	jns    802003 <close+0x31>
		return r;
  801ffe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802001:	eb 18                	jmp    80201b <close+0x49>
	else
		return fd_close(fd, 1);
  802003:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802007:	be 01 00 00 00       	mov    $0x1,%esi
  80200c:	48 89 c7             	mov    %rax,%rdi
  80200f:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  802016:	00 00 00 
  802019:	ff d0                	callq  *%rax
}
  80201b:	c9                   	leaveq 
  80201c:	c3                   	retq   

000000000080201d <close_all>:

void
close_all(void)
{
  80201d:	55                   	push   %rbp
  80201e:	48 89 e5             	mov    %rsp,%rbp
  802021:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802025:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80202c:	eb 15                	jmp    802043 <close_all+0x26>
		close(i);
  80202e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802031:	89 c7                	mov    %eax,%edi
  802033:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  80203a:	00 00 00 
  80203d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80203f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802043:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802047:	7e e5                	jle    80202e <close_all+0x11>
		close(i);
}
  802049:	c9                   	leaveq 
  80204a:	c3                   	retq   

000000000080204b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80204b:	55                   	push   %rbp
  80204c:	48 89 e5             	mov    %rsp,%rbp
  80204f:	48 83 ec 40          	sub    $0x40,%rsp
  802053:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802056:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802059:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80205d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802060:	48 89 d6             	mov    %rdx,%rsi
  802063:	89 c7                	mov    %eax,%edi
  802065:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  80206c:	00 00 00 
  80206f:	ff d0                	callq  *%rax
  802071:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802074:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802078:	79 08                	jns    802082 <dup+0x37>
		return r;
  80207a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207d:	e9 70 01 00 00       	jmpq   8021f2 <dup+0x1a7>
	close(newfdnum);
  802082:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802085:	89 c7                	mov    %eax,%edi
  802087:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  80208e:	00 00 00 
  802091:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802093:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802096:	48 98                	cltq   
  802098:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80209e:	48 c1 e0 0c          	shl    $0xc,%rax
  8020a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8020a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020aa:	48 89 c7             	mov    %rax,%rdi
  8020ad:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  8020b4:	00 00 00 
  8020b7:	ff d0                	callq  *%rax
  8020b9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8020bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020c1:	48 89 c7             	mov    %rax,%rdi
  8020c4:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  8020cb:	00 00 00 
  8020ce:	ff d0                	callq  *%rax
  8020d0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8020d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d8:	48 c1 e8 15          	shr    $0x15,%rax
  8020dc:	48 89 c2             	mov    %rax,%rdx
  8020df:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020e6:	01 00 00 
  8020e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020ed:	83 e0 01             	and    $0x1,%eax
  8020f0:	48 85 c0             	test   %rax,%rax
  8020f3:	74 73                	je     802168 <dup+0x11d>
  8020f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020f9:	48 c1 e8 0c          	shr    $0xc,%rax
  8020fd:	48 89 c2             	mov    %rax,%rdx
  802100:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802107:	01 00 00 
  80210a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80210e:	83 e0 01             	and    $0x1,%eax
  802111:	48 85 c0             	test   %rax,%rax
  802114:	74 52                	je     802168 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211a:	48 c1 e8 0c          	shr    $0xc,%rax
  80211e:	48 89 c2             	mov    %rax,%rdx
  802121:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802128:	01 00 00 
  80212b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212f:	25 07 0e 00 00       	and    $0xe07,%eax
  802134:	89 c1                	mov    %eax,%ecx
  802136:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80213a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80213e:	41 89 c8             	mov    %ecx,%r8d
  802141:	48 89 d1             	mov    %rdx,%rcx
  802144:	ba 00 00 00 00       	mov    $0x0,%edx
  802149:	48 89 c6             	mov    %rax,%rsi
  80214c:	bf 00 00 00 00       	mov    $0x0,%edi
  802151:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  802158:	00 00 00 
  80215b:	ff d0                	callq  *%rax
  80215d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802160:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802164:	79 02                	jns    802168 <dup+0x11d>
			goto err;
  802166:	eb 57                	jmp    8021bf <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802168:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80216c:	48 c1 e8 0c          	shr    $0xc,%rax
  802170:	48 89 c2             	mov    %rax,%rdx
  802173:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80217a:	01 00 00 
  80217d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802181:	25 07 0e 00 00       	and    $0xe07,%eax
  802186:	89 c1                	mov    %eax,%ecx
  802188:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80218c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802190:	41 89 c8             	mov    %ecx,%r8d
  802193:	48 89 d1             	mov    %rdx,%rcx
  802196:	ba 00 00 00 00       	mov    $0x0,%edx
  80219b:	48 89 c6             	mov    %rax,%rsi
  80219e:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a3:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  8021aa:	00 00 00 
  8021ad:	ff d0                	callq  *%rax
  8021af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021b6:	79 02                	jns    8021ba <dup+0x16f>
		goto err;
  8021b8:	eb 05                	jmp    8021bf <dup+0x174>

	return newfdnum;
  8021ba:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8021bd:	eb 33                	jmp    8021f2 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8021bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021c3:	48 89 c6             	mov    %rax,%rsi
  8021c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8021cb:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  8021d2:	00 00 00 
  8021d5:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8021d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021db:	48 89 c6             	mov    %rax,%rsi
  8021de:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e3:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  8021ea:	00 00 00 
  8021ed:	ff d0                	callq  *%rax
	return r;
  8021ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8021f2:	c9                   	leaveq 
  8021f3:	c3                   	retq   

00000000008021f4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8021f4:	55                   	push   %rbp
  8021f5:	48 89 e5             	mov    %rsp,%rbp
  8021f8:	48 83 ec 40          	sub    $0x40,%rsp
  8021fc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021ff:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802203:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802207:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80220b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80220e:	48 89 d6             	mov    %rdx,%rsi
  802211:	89 c7                	mov    %eax,%edi
  802213:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  80221a:	00 00 00 
  80221d:	ff d0                	callq  *%rax
  80221f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802222:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802226:	78 24                	js     80224c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802228:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222c:	8b 00                	mov    (%rax),%eax
  80222e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802232:	48 89 d6             	mov    %rdx,%rsi
  802235:	89 c7                	mov    %eax,%edi
  802237:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  80223e:	00 00 00 
  802241:	ff d0                	callq  *%rax
  802243:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802246:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80224a:	79 05                	jns    802251 <read+0x5d>
		return r;
  80224c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80224f:	eb 76                	jmp    8022c7 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802251:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802255:	8b 40 08             	mov    0x8(%rax),%eax
  802258:	83 e0 03             	and    $0x3,%eax
  80225b:	83 f8 01             	cmp    $0x1,%eax
  80225e:	75 3a                	jne    80229a <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802260:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802267:	00 00 00 
  80226a:	48 8b 00             	mov    (%rax),%rax
  80226d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802273:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802276:	89 c6                	mov    %eax,%esi
  802278:	48 bf 2f 3d 80 00 00 	movabs $0x803d2f,%rdi
  80227f:	00 00 00 
  802282:	b8 00 00 00 00       	mov    $0x0,%eax
  802287:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  80228e:	00 00 00 
  802291:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802293:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802298:	eb 2d                	jmp    8022c7 <read+0xd3>
	}
	if (!dev->dev_read)
  80229a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80229e:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022a2:	48 85 c0             	test   %rax,%rax
  8022a5:	75 07                	jne    8022ae <read+0xba>
		return -E_NOT_SUPP;
  8022a7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8022ac:	eb 19                	jmp    8022c7 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8022ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022b6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8022ba:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8022be:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8022c2:	48 89 cf             	mov    %rcx,%rdi
  8022c5:	ff d0                	callq  *%rax
}
  8022c7:	c9                   	leaveq 
  8022c8:	c3                   	retq   

00000000008022c9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022c9:	55                   	push   %rbp
  8022ca:	48 89 e5             	mov    %rsp,%rbp
  8022cd:	48 83 ec 30          	sub    $0x30,%rsp
  8022d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8022d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8022e3:	eb 49                	jmp    80232e <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022e8:	48 98                	cltq   
  8022ea:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8022ee:	48 29 c2             	sub    %rax,%rdx
  8022f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f4:	48 63 c8             	movslq %eax,%rcx
  8022f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022fb:	48 01 c1             	add    %rax,%rcx
  8022fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802301:	48 89 ce             	mov    %rcx,%rsi
  802304:	89 c7                	mov    %eax,%edi
  802306:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  80230d:	00 00 00 
  802310:	ff d0                	callq  *%rax
  802312:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802315:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802319:	79 05                	jns    802320 <readn+0x57>
			return m;
  80231b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80231e:	eb 1c                	jmp    80233c <readn+0x73>
		if (m == 0)
  802320:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802324:	75 02                	jne    802328 <readn+0x5f>
			break;
  802326:	eb 11                	jmp    802339 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802328:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80232b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80232e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802331:	48 98                	cltq   
  802333:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802337:	72 ac                	jb     8022e5 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802339:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80233c:	c9                   	leaveq 
  80233d:	c3                   	retq   

000000000080233e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80233e:	55                   	push   %rbp
  80233f:	48 89 e5             	mov    %rsp,%rbp
  802342:	48 83 ec 40          	sub    $0x40,%rsp
  802346:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802349:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80234d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802351:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802355:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802358:	48 89 d6             	mov    %rdx,%rsi
  80235b:	89 c7                	mov    %eax,%edi
  80235d:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  802364:	00 00 00 
  802367:	ff d0                	callq  *%rax
  802369:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80236c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802370:	78 24                	js     802396 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802372:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802376:	8b 00                	mov    (%rax),%eax
  802378:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80237c:	48 89 d6             	mov    %rdx,%rsi
  80237f:	89 c7                	mov    %eax,%edi
  802381:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  802388:	00 00 00 
  80238b:	ff d0                	callq  *%rax
  80238d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802390:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802394:	79 05                	jns    80239b <write+0x5d>
		return r;
  802396:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802399:	eb 75                	jmp    802410 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80239b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80239f:	8b 40 08             	mov    0x8(%rax),%eax
  8023a2:	83 e0 03             	and    $0x3,%eax
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	75 3a                	jne    8023e3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8023a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8023b0:	00 00 00 
  8023b3:	48 8b 00             	mov    (%rax),%rax
  8023b6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8023bc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023bf:	89 c6                	mov    %eax,%esi
  8023c1:	48 bf 4b 3d 80 00 00 	movabs $0x803d4b,%rdi
  8023c8:	00 00 00 
  8023cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d0:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  8023d7:	00 00 00 
  8023da:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8023dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8023e1:	eb 2d                	jmp    802410 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8023e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023eb:	48 85 c0             	test   %rax,%rax
  8023ee:	75 07                	jne    8023f7 <write+0xb9>
		return -E_NOT_SUPP;
  8023f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8023f5:	eb 19                	jmp    802410 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8023f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023fb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023ff:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802403:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802407:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80240b:	48 89 cf             	mov    %rcx,%rdi
  80240e:	ff d0                	callq  *%rax
}
  802410:	c9                   	leaveq 
  802411:	c3                   	retq   

0000000000802412 <seek>:

int
seek(int fdnum, off_t offset)
{
  802412:	55                   	push   %rbp
  802413:	48 89 e5             	mov    %rsp,%rbp
  802416:	48 83 ec 18          	sub    $0x18,%rsp
  80241a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80241d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802420:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802427:	48 89 d6             	mov    %rdx,%rsi
  80242a:	89 c7                	mov    %eax,%edi
  80242c:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  802433:	00 00 00 
  802436:	ff d0                	callq  *%rax
  802438:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80243b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80243f:	79 05                	jns    802446 <seek+0x34>
		return r;
  802441:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802444:	eb 0f                	jmp    802455 <seek+0x43>
	fd->fd_offset = offset;
  802446:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80244a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80244d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802450:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802455:	c9                   	leaveq 
  802456:	c3                   	retq   

0000000000802457 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802457:	55                   	push   %rbp
  802458:	48 89 e5             	mov    %rsp,%rbp
  80245b:	48 83 ec 30          	sub    $0x30,%rsp
  80245f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802462:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802465:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802469:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80246c:	48 89 d6             	mov    %rdx,%rsi
  80246f:	89 c7                	mov    %eax,%edi
  802471:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  802478:	00 00 00 
  80247b:	ff d0                	callq  *%rax
  80247d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802480:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802484:	78 24                	js     8024aa <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80248a:	8b 00                	mov    (%rax),%eax
  80248c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802490:	48 89 d6             	mov    %rdx,%rsi
  802493:	89 c7                	mov    %eax,%edi
  802495:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  80249c:	00 00 00 
  80249f:	ff d0                	callq  *%rax
  8024a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a8:	79 05                	jns    8024af <ftruncate+0x58>
		return r;
  8024aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ad:	eb 72                	jmp    802521 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8024af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8024b3:	8b 40 08             	mov    0x8(%rax),%eax
  8024b6:	83 e0 03             	and    $0x3,%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	75 3a                	jne    8024f7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8024bd:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8024c4:	00 00 00 
  8024c7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8024ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024d0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024d3:	89 c6                	mov    %eax,%esi
  8024d5:	48 bf 68 3d 80 00 00 	movabs $0x803d68,%rdi
  8024dc:	00 00 00 
  8024df:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e4:	48 b9 6c 04 80 00 00 	movabs $0x80046c,%rcx
  8024eb:	00 00 00 
  8024ee:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8024f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024f5:	eb 2a                	jmp    802521 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024ff:	48 85 c0             	test   %rax,%rax
  802502:	75 07                	jne    80250b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802504:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802509:	eb 16                	jmp    802521 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80250b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80250f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802513:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802517:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80251a:	89 ce                	mov    %ecx,%esi
  80251c:	48 89 d7             	mov    %rdx,%rdi
  80251f:	ff d0                	callq  *%rax
}
  802521:	c9                   	leaveq 
  802522:	c3                   	retq   

0000000000802523 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802523:	55                   	push   %rbp
  802524:	48 89 e5             	mov    %rsp,%rbp
  802527:	48 83 ec 30          	sub    $0x30,%rsp
  80252b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80252e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802532:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802536:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802539:	48 89 d6             	mov    %rdx,%rsi
  80253c:	89 c7                	mov    %eax,%edi
  80253e:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  802545:	00 00 00 
  802548:	ff d0                	callq  *%rax
  80254a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80254d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802551:	78 24                	js     802577 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802557:	8b 00                	mov    (%rax),%eax
  802559:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80255d:	48 89 d6             	mov    %rdx,%rsi
  802560:	89 c7                	mov    %eax,%edi
  802562:	48 b8 1b 1f 80 00 00 	movabs $0x801f1b,%rax
  802569:	00 00 00 
  80256c:	ff d0                	callq  *%rax
  80256e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802571:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802575:	79 05                	jns    80257c <fstat+0x59>
		return r;
  802577:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257a:	eb 5e                	jmp    8025da <fstat+0xb7>
	if (!dev->dev_stat)
  80257c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802580:	48 8b 40 28          	mov    0x28(%rax),%rax
  802584:	48 85 c0             	test   %rax,%rax
  802587:	75 07                	jne    802590 <fstat+0x6d>
		return -E_NOT_SUPP;
  802589:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80258e:	eb 4a                	jmp    8025da <fstat+0xb7>
	stat->st_name[0] = 0;
  802590:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802594:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802597:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80259b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8025a2:	00 00 00 
	stat->st_isdir = 0;
  8025a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025a9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8025b0:	00 00 00 
	stat->st_dev = dev;
  8025b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025bb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8025c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8025ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8025ce:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8025d2:	48 89 ce             	mov    %rcx,%rsi
  8025d5:	48 89 d7             	mov    %rdx,%rdi
  8025d8:	ff d0                	callq  *%rax
}
  8025da:	c9                   	leaveq 
  8025db:	c3                   	retq   

00000000008025dc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8025dc:	55                   	push   %rbp
  8025dd:	48 89 e5             	mov    %rsp,%rbp
  8025e0:	48 83 ec 20          	sub    $0x20,%rsp
  8025e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8025ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025f0:	be 00 00 00 00       	mov    $0x0,%esi
  8025f5:	48 89 c7             	mov    %rax,%rdi
  8025f8:	48 b8 ca 26 80 00 00 	movabs $0x8026ca,%rax
  8025ff:	00 00 00 
  802602:	ff d0                	callq  *%rax
  802604:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802607:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80260b:	79 05                	jns    802612 <stat+0x36>
		return fd;
  80260d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802610:	eb 2f                	jmp    802641 <stat+0x65>
	r = fstat(fd, stat);
  802612:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802616:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802619:	48 89 d6             	mov    %rdx,%rsi
  80261c:	89 c7                	mov    %eax,%edi
  80261e:	48 b8 23 25 80 00 00 	movabs $0x802523,%rax
  802625:	00 00 00 
  802628:	ff d0                	callq  *%rax
  80262a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80262d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802630:	89 c7                	mov    %eax,%edi
  802632:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802639:	00 00 00 
  80263c:	ff d0                	callq  *%rax
	return r;
  80263e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802641:	c9                   	leaveq 
  802642:	c3                   	retq   

0000000000802643 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802643:	55                   	push   %rbp
  802644:	48 89 e5             	mov    %rsp,%rbp
  802647:	48 83 ec 10          	sub    $0x10,%rsp
  80264b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80264e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802652:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802659:	00 00 00 
  80265c:	8b 00                	mov    (%rax),%eax
  80265e:	85 c0                	test   %eax,%eax
  802660:	75 1d                	jne    80267f <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802662:	bf 01 00 00 00       	mov    $0x1,%edi
  802667:	48 b8 0c 36 80 00 00 	movabs $0x80360c,%rax
  80266e:	00 00 00 
  802671:	ff d0                	callq  *%rax
  802673:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  80267a:	00 00 00 
  80267d:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80267f:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802686:	00 00 00 
  802689:	8b 00                	mov    (%rax),%eax
  80268b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80268e:	b9 07 00 00 00       	mov    $0x7,%ecx
  802693:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80269a:	00 00 00 
  80269d:	89 c7                	mov    %eax,%edi
  80269f:	48 b8 6f 35 80 00 00 	movabs $0x80356f,%rax
  8026a6:	00 00 00 
  8026a9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8026ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026af:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b4:	48 89 c6             	mov    %rax,%rsi
  8026b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026bc:	48 b8 a9 34 80 00 00 	movabs $0x8034a9,%rax
  8026c3:	00 00 00 
  8026c6:	ff d0                	callq  *%rax
}
  8026c8:	c9                   	leaveq 
  8026c9:	c3                   	retq   

00000000008026ca <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026ca:	55                   	push   %rbp
  8026cb:	48 89 e5             	mov    %rsp,%rbp
  8026ce:	48 83 ec 20          	sub    $0x20,%rsp
  8026d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026d6:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  8026d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026dd:	48 89 c7             	mov    %rax,%rdi
  8026e0:	48 b8 b5 0f 80 00 00 	movabs $0x800fb5,%rax
  8026e7:	00 00 00 
  8026ea:	ff d0                	callq  *%rax
  8026ec:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8026f1:	7e 0a                	jle    8026fd <open+0x33>
  8026f3:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026f8:	e9 a5 00 00 00       	jmpq   8027a2 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8026fd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802701:	48 89 c7             	mov    %rax,%rdi
  802704:	48 b8 2a 1d 80 00 00 	movabs $0x801d2a,%rax
  80270b:	00 00 00 
  80270e:	ff d0                	callq  *%rax
  802710:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802713:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802717:	79 08                	jns    802721 <open+0x57>
		return r;
  802719:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271c:	e9 81 00 00 00       	jmpq   8027a2 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802721:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802728:	00 00 00 
  80272b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80272e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802734:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802738:	48 89 c6             	mov    %rax,%rsi
  80273b:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802742:	00 00 00 
  802745:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  80274c:	00 00 00 
  80274f:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802755:	48 89 c6             	mov    %rax,%rsi
  802758:	bf 01 00 00 00       	mov    $0x1,%edi
  80275d:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  802764:	00 00 00 
  802767:	ff d0                	callq  *%rax
  802769:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80276c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802770:	79 1d                	jns    80278f <open+0xc5>
		fd_close(fd, 0);
  802772:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802776:	be 00 00 00 00       	mov    $0x0,%esi
  80277b:	48 89 c7             	mov    %rax,%rdi
  80277e:	48 b8 52 1e 80 00 00 	movabs $0x801e52,%rax
  802785:	00 00 00 
  802788:	ff d0                	callq  *%rax
		return r;
  80278a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278d:	eb 13                	jmp    8027a2 <open+0xd8>
	}
	return fd2num(fd);
  80278f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802793:	48 89 c7             	mov    %rax,%rdi
  802796:	48 b8 dc 1c 80 00 00 	movabs $0x801cdc,%rax
  80279d:	00 00 00 
  8027a0:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  8027a2:	c9                   	leaveq 
  8027a3:	c3                   	retq   

00000000008027a4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8027a4:	55                   	push   %rbp
  8027a5:	48 89 e5             	mov    %rsp,%rbp
  8027a8:	48 83 ec 10          	sub    $0x10,%rsp
  8027ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8027b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027b4:	8b 50 0c             	mov    0xc(%rax),%edx
  8027b7:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027be:	00 00 00 
  8027c1:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8027c3:	be 00 00 00 00       	mov    $0x0,%esi
  8027c8:	bf 06 00 00 00       	mov    $0x6,%edi
  8027cd:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  8027d4:	00 00 00 
  8027d7:	ff d0                	callq  *%rax
}
  8027d9:	c9                   	leaveq 
  8027da:	c3                   	retq   

00000000008027db <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027db:	55                   	push   %rbp
  8027dc:	48 89 e5             	mov    %rsp,%rbp
  8027df:	48 83 ec 30          	sub    $0x30,%rsp
  8027e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8027eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8027ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027f3:	8b 50 0c             	mov    0xc(%rax),%edx
  8027f6:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8027fd:	00 00 00 
  802800:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802802:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802809:	00 00 00 
  80280c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802810:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802814:	be 00 00 00 00       	mov    $0x0,%esi
  802819:	bf 03 00 00 00       	mov    $0x3,%edi
  80281e:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  802825:	00 00 00 
  802828:	ff d0                	callq  *%rax
  80282a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80282d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802831:	79 05                	jns    802838 <devfile_read+0x5d>
		return r;
  802833:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802836:	eb 26                	jmp    80285e <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802838:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283b:	48 63 d0             	movslq %eax,%rdx
  80283e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802842:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  802849:	00 00 00 
  80284c:	48 89 c7             	mov    %rax,%rdi
  80284f:	48 b8 5c 14 80 00 00 	movabs $0x80145c,%rax
  802856:	00 00 00 
  802859:	ff d0                	callq  *%rax
	return r;
  80285b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  80285e:	c9                   	leaveq 
  80285f:	c3                   	retq   

0000000000802860 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802860:	55                   	push   %rbp
  802861:	48 89 e5             	mov    %rsp,%rbp
  802864:	48 83 ec 30          	sub    $0x30,%rsp
  802868:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80286c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802870:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802874:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  80287b:	00 
	n = n > max ? max : n;
  80287c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802880:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802884:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802889:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80288d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802891:	8b 50 0c             	mov    0xc(%rax),%edx
  802894:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80289b:	00 00 00 
  80289e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8028a0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8028a7:	00 00 00 
  8028aa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028ae:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8028b2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028ba:	48 89 c6             	mov    %rax,%rsi
  8028bd:	48 bf 10 70 80 00 00 	movabs $0x807010,%rdi
  8028c4:	00 00 00 
  8028c7:	48 b8 5c 14 80 00 00 	movabs $0x80145c,%rax
  8028ce:	00 00 00 
  8028d1:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  8028d3:	be 00 00 00 00       	mov    $0x0,%esi
  8028d8:	bf 04 00 00 00       	mov    $0x4,%edi
  8028dd:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  8028e4:	00 00 00 
  8028e7:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  8028e9:	c9                   	leaveq 
  8028ea:	c3                   	retq   

00000000008028eb <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8028eb:	55                   	push   %rbp
  8028ec:	48 89 e5             	mov    %rsp,%rbp
  8028ef:	48 83 ec 20          	sub    $0x20,%rsp
  8028f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ff:	8b 50 0c             	mov    0xc(%rax),%edx
  802902:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802909:	00 00 00 
  80290c:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80290e:	be 00 00 00 00       	mov    $0x0,%esi
  802913:	bf 05 00 00 00       	mov    $0x5,%edi
  802918:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  80291f:	00 00 00 
  802922:	ff d0                	callq  *%rax
  802924:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802927:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80292b:	79 05                	jns    802932 <devfile_stat+0x47>
		return r;
  80292d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802930:	eb 56                	jmp    802988 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802932:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802936:	48 be 00 70 80 00 00 	movabs $0x807000,%rsi
  80293d:	00 00 00 
  802940:	48 89 c7             	mov    %rax,%rdi
  802943:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  80294a:	00 00 00 
  80294d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80294f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802956:	00 00 00 
  802959:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80295f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802963:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802969:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  802970:	00 00 00 
  802973:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802979:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80297d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802983:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802988:	c9                   	leaveq 
  802989:	c3                   	retq   

000000000080298a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80298a:	55                   	push   %rbp
  80298b:	48 89 e5             	mov    %rsp,%rbp
  80298e:	48 83 ec 10          	sub    $0x10,%rsp
  802992:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802996:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802999:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80299d:	8b 50 0c             	mov    0xc(%rax),%edx
  8029a0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029a7:	00 00 00 
  8029aa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8029ac:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029b3:	00 00 00 
  8029b6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029b9:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8029bc:	be 00 00 00 00       	mov    $0x0,%esi
  8029c1:	bf 02 00 00 00       	mov    $0x2,%edi
  8029c6:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	callq  *%rax
}
  8029d2:	c9                   	leaveq 
  8029d3:	c3                   	retq   

00000000008029d4 <remove>:

// Delete a file
int
remove(const char *path)
{
  8029d4:	55                   	push   %rbp
  8029d5:	48 89 e5             	mov    %rsp,%rbp
  8029d8:	48 83 ec 10          	sub    $0x10,%rsp
  8029dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8029e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029e4:	48 89 c7             	mov    %rax,%rdi
  8029e7:	48 b8 b5 0f 80 00 00 	movabs $0x800fb5,%rax
  8029ee:	00 00 00 
  8029f1:	ff d0                	callq  *%rax
  8029f3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029f8:	7e 07                	jle    802a01 <remove+0x2d>
		return -E_BAD_PATH;
  8029fa:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029ff:	eb 33                	jmp    802a34 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802a01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a05:	48 89 c6             	mov    %rax,%rsi
  802a08:	48 bf 00 70 80 00 00 	movabs $0x807000,%rdi
  802a0f:	00 00 00 
  802a12:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  802a19:	00 00 00 
  802a1c:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802a1e:	be 00 00 00 00       	mov    $0x0,%esi
  802a23:	bf 07 00 00 00       	mov    $0x7,%edi
  802a28:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  802a2f:	00 00 00 
  802a32:	ff d0                	callq  *%rax
}
  802a34:	c9                   	leaveq 
  802a35:	c3                   	retq   

0000000000802a36 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802a36:	55                   	push   %rbp
  802a37:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802a3a:	be 00 00 00 00       	mov    $0x0,%esi
  802a3f:	bf 08 00 00 00       	mov    $0x8,%edi
  802a44:	48 b8 43 26 80 00 00 	movabs $0x802643,%rax
  802a4b:	00 00 00 
  802a4e:	ff d0                	callq  *%rax
}
  802a50:	5d                   	pop    %rbp
  802a51:	c3                   	retq   

0000000000802a52 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802a52:	55                   	push   %rbp
  802a53:	48 89 e5             	mov    %rsp,%rbp
  802a56:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a5d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a64:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802a6b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802a72:	be 00 00 00 00       	mov    $0x0,%esi
  802a77:	48 89 c7             	mov    %rax,%rdi
  802a7a:	48 b8 ca 26 80 00 00 	movabs $0x8026ca,%rax
  802a81:	00 00 00 
  802a84:	ff d0                	callq  *%rax
  802a86:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802a89:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a8d:	79 28                	jns    802ab7 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802a8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a92:	89 c6                	mov    %eax,%esi
  802a94:	48 bf 8e 3d 80 00 00 	movabs $0x803d8e,%rdi
  802a9b:	00 00 00 
  802a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa3:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
  802aaa:	00 00 00 
  802aad:	ff d2                	callq  *%rdx
		return fd_src;
  802aaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab2:	e9 74 01 00 00       	jmpq   802c2b <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802ab7:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802abe:	be 01 01 00 00       	mov    $0x101,%esi
  802ac3:	48 89 c7             	mov    %rax,%rdi
  802ac6:	48 b8 ca 26 80 00 00 	movabs $0x8026ca,%rax
  802acd:	00 00 00 
  802ad0:	ff d0                	callq  *%rax
  802ad2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802ad5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ad9:	79 39                	jns    802b14 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802adb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ade:	89 c6                	mov    %eax,%esi
  802ae0:	48 bf a4 3d 80 00 00 	movabs $0x803da4,%rdi
  802ae7:	00 00 00 
  802aea:	b8 00 00 00 00       	mov    $0x0,%eax
  802aef:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
  802af6:	00 00 00 
  802af9:	ff d2                	callq  *%rdx
		close(fd_src);
  802afb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802afe:	89 c7                	mov    %eax,%edi
  802b00:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802b07:	00 00 00 
  802b0a:	ff d0                	callq  *%rax
		return fd_dest;
  802b0c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b0f:	e9 17 01 00 00       	jmpq   802c2b <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b14:	eb 74                	jmp    802b8a <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802b16:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b19:	48 63 d0             	movslq %eax,%rdx
  802b1c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b23:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b26:	48 89 ce             	mov    %rcx,%rsi
  802b29:	89 c7                	mov    %eax,%edi
  802b2b:	48 b8 3e 23 80 00 00 	movabs $0x80233e,%rax
  802b32:	00 00 00 
  802b35:	ff d0                	callq  *%rax
  802b37:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802b3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b3e:	79 4a                	jns    802b8a <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802b40:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b43:	89 c6                	mov    %eax,%esi
  802b45:	48 bf be 3d 80 00 00 	movabs $0x803dbe,%rdi
  802b4c:	00 00 00 
  802b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b54:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
  802b5b:	00 00 00 
  802b5e:	ff d2                	callq  *%rdx
			close(fd_src);
  802b60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b63:	89 c7                	mov    %eax,%edi
  802b65:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802b6c:	00 00 00 
  802b6f:	ff d0                	callq  *%rax
			close(fd_dest);
  802b71:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b74:	89 c7                	mov    %eax,%edi
  802b76:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802b7d:	00 00 00 
  802b80:	ff d0                	callq  *%rax
			return write_size;
  802b82:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b85:	e9 a1 00 00 00       	jmpq   802c2b <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b8a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b94:	ba 00 02 00 00       	mov    $0x200,%edx
  802b99:	48 89 ce             	mov    %rcx,%rsi
  802b9c:	89 c7                	mov    %eax,%edi
  802b9e:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  802ba5:	00 00 00 
  802ba8:	ff d0                	callq  *%rax
  802baa:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802bad:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802bb1:	0f 8f 5f ff ff ff    	jg     802b16 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802bb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802bbb:	79 47                	jns    802c04 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802bbd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bc0:	89 c6                	mov    %eax,%esi
  802bc2:	48 bf d1 3d 80 00 00 	movabs $0x803dd1,%rdi
  802bc9:	00 00 00 
  802bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd1:	48 ba 6c 04 80 00 00 	movabs $0x80046c,%rdx
  802bd8:	00 00 00 
  802bdb:	ff d2                	callq  *%rdx
		close(fd_src);
  802bdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be0:	89 c7                	mov    %eax,%edi
  802be2:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802be9:	00 00 00 
  802bec:	ff d0                	callq  *%rax
		close(fd_dest);
  802bee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
		return read_size;
  802bff:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802c02:	eb 27                	jmp    802c2b <copy+0x1d9>
	}
	close(fd_src);
  802c04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c07:	89 c7                	mov    %eax,%edi
  802c09:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802c10:	00 00 00 
  802c13:	ff d0                	callq  *%rax
	close(fd_dest);
  802c15:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c18:	89 c7                	mov    %eax,%edi
  802c1a:	48 b8 d2 1f 80 00 00 	movabs $0x801fd2,%rax
  802c21:	00 00 00 
  802c24:	ff d0                	callq  *%rax
	return 0;
  802c26:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802c2b:	c9                   	leaveq 
  802c2c:	c3                   	retq   

0000000000802c2d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802c2d:	55                   	push   %rbp
  802c2e:	48 89 e5             	mov    %rsp,%rbp
  802c31:	53                   	push   %rbx
  802c32:	48 83 ec 38          	sub    $0x38,%rsp
  802c36:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802c3a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802c3e:	48 89 c7             	mov    %rax,%rdi
  802c41:	48 b8 2a 1d 80 00 00 	movabs $0x801d2a,%rax
  802c48:	00 00 00 
  802c4b:	ff d0                	callq  *%rax
  802c4d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c50:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c54:	0f 88 bf 01 00 00    	js     802e19 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c5e:	ba 07 04 00 00       	mov    $0x407,%edx
  802c63:	48 89 c6             	mov    %rax,%rsi
  802c66:	bf 00 00 00 00       	mov    $0x0,%edi
  802c6b:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
  802c77:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c7e:	0f 88 95 01 00 00    	js     802e19 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802c84:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802c88:	48 89 c7             	mov    %rax,%rdi
  802c8b:	48 b8 2a 1d 80 00 00 	movabs $0x801d2a,%rax
  802c92:	00 00 00 
  802c95:	ff d0                	callq  *%rax
  802c97:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802c9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802c9e:	0f 88 5d 01 00 00    	js     802e01 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ca4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ca8:	ba 07 04 00 00       	mov    $0x407,%edx
  802cad:	48 89 c6             	mov    %rax,%rsi
  802cb0:	bf 00 00 00 00       	mov    $0x0,%edi
  802cb5:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  802cbc:	00 00 00 
  802cbf:	ff d0                	callq  *%rax
  802cc1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802cc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cc8:	0f 88 33 01 00 00    	js     802e01 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802cce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cd2:	48 89 c7             	mov    %rax,%rdi
  802cd5:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  802cdc:	00 00 00 
  802cdf:	ff d0                	callq  *%rax
  802ce1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ce5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce9:	ba 07 04 00 00       	mov    $0x407,%edx
  802cee:	48 89 c6             	mov    %rax,%rsi
  802cf1:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf6:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  802cfd:	00 00 00 
  802d00:	ff d0                	callq  *%rax
  802d02:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d05:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d09:	79 05                	jns    802d10 <pipe+0xe3>
		goto err2;
  802d0b:	e9 d9 00 00 00       	jmpq   802de9 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d14:	48 89 c7             	mov    %rax,%rdi
  802d17:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  802d1e:	00 00 00 
  802d21:	ff d0                	callq  *%rax
  802d23:	48 89 c2             	mov    %rax,%rdx
  802d26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d2a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802d30:	48 89 d1             	mov    %rdx,%rcx
  802d33:	ba 00 00 00 00       	mov    $0x0,%edx
  802d38:	48 89 c6             	mov    %rax,%rsi
  802d3b:	bf 00 00 00 00       	mov    $0x0,%edi
  802d40:	48 b8 a0 19 80 00 00 	movabs $0x8019a0,%rax
  802d47:	00 00 00 
  802d4a:	ff d0                	callq  *%rax
  802d4c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802d4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802d53:	79 1b                	jns    802d70 <pipe+0x143>
		goto err3;
  802d55:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802d56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d5a:	48 89 c6             	mov    %rax,%rsi
  802d5d:	bf 00 00 00 00       	mov    $0x0,%edi
  802d62:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  802d69:	00 00 00 
  802d6c:	ff d0                	callq  *%rax
  802d6e:	eb 79                	jmp    802de9 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802d70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d74:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d7b:	00 00 00 
  802d7e:	8b 12                	mov    (%rdx),%edx
  802d80:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802d82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802d8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d91:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  802d98:	00 00 00 
  802d9b:	8b 12                	mov    (%rdx),%edx
  802d9d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802d9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802da3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802daa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dae:	48 89 c7             	mov    %rax,%rdi
  802db1:	48 b8 dc 1c 80 00 00 	movabs $0x801cdc,%rax
  802db8:	00 00 00 
  802dbb:	ff d0                	callq  *%rax
  802dbd:	89 c2                	mov    %eax,%edx
  802dbf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802dc3:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802dc5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802dc9:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802dcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802dd1:	48 89 c7             	mov    %rax,%rdi
  802dd4:	48 b8 dc 1c 80 00 00 	movabs $0x801cdc,%rax
  802ddb:	00 00 00 
  802dde:	ff d0                	callq  *%rax
  802de0:	89 03                	mov    %eax,(%rbx)
	return 0;
  802de2:	b8 00 00 00 00       	mov    $0x0,%eax
  802de7:	eb 33                	jmp    802e1c <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802de9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ded:	48 89 c6             	mov    %rax,%rsi
  802df0:	bf 00 00 00 00       	mov    $0x0,%edi
  802df5:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802e01:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e05:	48 89 c6             	mov    %rax,%rsi
  802e08:	bf 00 00 00 00       	mov    $0x0,%edi
  802e0d:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  802e14:	00 00 00 
  802e17:	ff d0                	callq  *%rax
err:
	return r;
  802e19:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802e1c:	48 83 c4 38          	add    $0x38,%rsp
  802e20:	5b                   	pop    %rbx
  802e21:	5d                   	pop    %rbp
  802e22:	c3                   	retq   

0000000000802e23 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802e23:	55                   	push   %rbp
  802e24:	48 89 e5             	mov    %rsp,%rbp
  802e27:	53                   	push   %rbx
  802e28:	48 83 ec 28          	sub    $0x28,%rsp
  802e2c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802e30:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802e34:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e3b:	00 00 00 
  802e3e:	48 8b 00             	mov    (%rax),%rax
  802e41:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e47:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802e4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e4e:	48 89 c7             	mov    %rax,%rdi
  802e51:	48 b8 8e 36 80 00 00 	movabs $0x80368e,%rax
  802e58:	00 00 00 
  802e5b:	ff d0                	callq  *%rax
  802e5d:	89 c3                	mov    %eax,%ebx
  802e5f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e63:	48 89 c7             	mov    %rax,%rdi
  802e66:	48 b8 8e 36 80 00 00 	movabs $0x80368e,%rax
  802e6d:	00 00 00 
  802e70:	ff d0                	callq  *%rax
  802e72:	39 c3                	cmp    %eax,%ebx
  802e74:	0f 94 c0             	sete   %al
  802e77:	0f b6 c0             	movzbl %al,%eax
  802e7a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802e7d:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802e84:	00 00 00 
  802e87:	48 8b 00             	mov    (%rax),%rax
  802e8a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802e90:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802e93:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e96:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802e99:	75 05                	jne    802ea0 <_pipeisclosed+0x7d>
			return ret;
  802e9b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802e9e:	eb 4f                	jmp    802eef <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  802ea0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea3:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802ea6:	74 42                	je     802eea <_pipeisclosed+0xc7>
  802ea8:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802eac:	75 3c                	jne    802eea <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802eae:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  802eb5:	00 00 00 
  802eb8:	48 8b 00             	mov    (%rax),%rax
  802ebb:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802ec1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802ec4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ec7:	89 c6                	mov    %eax,%esi
  802ec9:	48 bf ec 3d 80 00 00 	movabs $0x803dec,%rdi
  802ed0:	00 00 00 
  802ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed8:	49 b8 6c 04 80 00 00 	movabs $0x80046c,%r8
  802edf:	00 00 00 
  802ee2:	41 ff d0             	callq  *%r8
	}
  802ee5:	e9 4a ff ff ff       	jmpq   802e34 <_pipeisclosed+0x11>
  802eea:	e9 45 ff ff ff       	jmpq   802e34 <_pipeisclosed+0x11>
}
  802eef:	48 83 c4 28          	add    $0x28,%rsp
  802ef3:	5b                   	pop    %rbx
  802ef4:	5d                   	pop    %rbp
  802ef5:	c3                   	retq   

0000000000802ef6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802ef6:	55                   	push   %rbp
  802ef7:	48 89 e5             	mov    %rsp,%rbp
  802efa:	48 83 ec 30          	sub    $0x30,%rsp
  802efe:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f01:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f05:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f08:	48 89 d6             	mov    %rdx,%rsi
  802f0b:	89 c7                	mov    %eax,%edi
  802f0d:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  802f14:	00 00 00 
  802f17:	ff d0                	callq  *%rax
  802f19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f20:	79 05                	jns    802f27 <pipeisclosed+0x31>
		return r;
  802f22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f25:	eb 31                	jmp    802f58 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f2b:	48 89 c7             	mov    %rax,%rdi
  802f2e:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  802f35:	00 00 00 
  802f38:	ff d0                	callq  *%rax
  802f3a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802f3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f46:	48 89 d6             	mov    %rdx,%rsi
  802f49:	48 89 c7             	mov    %rax,%rdi
  802f4c:	48 b8 23 2e 80 00 00 	movabs $0x802e23,%rax
  802f53:	00 00 00 
  802f56:	ff d0                	callq  *%rax
}
  802f58:	c9                   	leaveq 
  802f59:	c3                   	retq   

0000000000802f5a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f5a:	55                   	push   %rbp
  802f5b:	48 89 e5             	mov    %rsp,%rbp
  802f5e:	48 83 ec 40          	sub    $0x40,%rsp
  802f62:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802f66:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f6a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802f6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f72:	48 89 c7             	mov    %rax,%rdi
  802f75:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  802f7c:	00 00 00 
  802f7f:	ff d0                	callq  *%rax
  802f81:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802f85:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f89:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802f8d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802f94:	00 
  802f95:	e9 92 00 00 00       	jmpq   80302c <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  802f9a:	eb 41                	jmp    802fdd <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802f9c:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802fa1:	74 09                	je     802fac <devpipe_read+0x52>
				return i;
  802fa3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802fa7:	e9 92 00 00 00       	jmpq   80303e <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802fac:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802fb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fb4:	48 89 d6             	mov    %rdx,%rsi
  802fb7:	48 89 c7             	mov    %rax,%rdi
  802fba:	48 b8 23 2e 80 00 00 	movabs $0x802e23,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	74 07                	je     802fd1 <devpipe_read+0x77>
				return 0;
  802fca:	b8 00 00 00 00       	mov    $0x0,%eax
  802fcf:	eb 6d                	jmp    80303e <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802fd1:	48 b8 12 19 80 00 00 	movabs $0x801912,%rax
  802fd8:	00 00 00 
  802fdb:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe1:	8b 10                	mov    (%rax),%edx
  802fe3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe7:	8b 40 04             	mov    0x4(%rax),%eax
  802fea:	39 c2                	cmp    %eax,%edx
  802fec:	74 ae                	je     802f9c <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802fee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ff6:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802ffa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ffe:	8b 00                	mov    (%rax),%eax
  803000:	99                   	cltd   
  803001:	c1 ea 1b             	shr    $0x1b,%edx
  803004:	01 d0                	add    %edx,%eax
  803006:	83 e0 1f             	and    $0x1f,%eax
  803009:	29 d0                	sub    %edx,%eax
  80300b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80300f:	48 98                	cltq   
  803011:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803016:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803018:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80301c:	8b 00                	mov    (%rax),%eax
  80301e:	8d 50 01             	lea    0x1(%rax),%edx
  803021:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803025:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803027:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80302c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803030:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803034:	0f 82 60 ff ff ff    	jb     802f9a <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80303a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80303e:	c9                   	leaveq 
  80303f:	c3                   	retq   

0000000000803040 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803040:	55                   	push   %rbp
  803041:	48 89 e5             	mov    %rsp,%rbp
  803044:	48 83 ec 40          	sub    $0x40,%rsp
  803048:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80304c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803050:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803054:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803058:	48 89 c7             	mov    %rax,%rdi
  80305b:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  803062:	00 00 00 
  803065:	ff d0                	callq  *%rax
  803067:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80306b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80306f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803073:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80307a:	00 
  80307b:	e9 8e 00 00 00       	jmpq   80310e <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803080:	eb 31                	jmp    8030b3 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803082:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803086:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80308a:	48 89 d6             	mov    %rdx,%rsi
  80308d:	48 89 c7             	mov    %rax,%rdi
  803090:	48 b8 23 2e 80 00 00 	movabs $0x802e23,%rax
  803097:	00 00 00 
  80309a:	ff d0                	callq  *%rax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	74 07                	je     8030a7 <devpipe_write+0x67>
				return 0;
  8030a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a5:	eb 79                	jmp    803120 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8030a7:	48 b8 12 19 80 00 00 	movabs $0x801912,%rax
  8030ae:	00 00 00 
  8030b1:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8030b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030b7:	8b 40 04             	mov    0x4(%rax),%eax
  8030ba:	48 63 d0             	movslq %eax,%rdx
  8030bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030c1:	8b 00                	mov    (%rax),%eax
  8030c3:	48 98                	cltq   
  8030c5:	48 83 c0 20          	add    $0x20,%rax
  8030c9:	48 39 c2             	cmp    %rax,%rdx
  8030cc:	73 b4                	jae    803082 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8030ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d2:	8b 40 04             	mov    0x4(%rax),%eax
  8030d5:	99                   	cltd   
  8030d6:	c1 ea 1b             	shr    $0x1b,%edx
  8030d9:	01 d0                	add    %edx,%eax
  8030db:	83 e0 1f             	and    $0x1f,%eax
  8030de:	29 d0                	sub    %edx,%eax
  8030e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030e4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8030e8:	48 01 ca             	add    %rcx,%rdx
  8030eb:	0f b6 0a             	movzbl (%rdx),%ecx
  8030ee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030f2:	48 98                	cltq   
  8030f4:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8030f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030fc:	8b 40 04             	mov    0x4(%rax),%eax
  8030ff:	8d 50 01             	lea    0x1(%rax),%edx
  803102:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803106:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803109:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80310e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803112:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803116:	0f 82 64 ff ff ff    	jb     803080 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80311c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803120:	c9                   	leaveq 
  803121:	c3                   	retq   

0000000000803122 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803122:	55                   	push   %rbp
  803123:	48 89 e5             	mov    %rsp,%rbp
  803126:	48 83 ec 20          	sub    $0x20,%rsp
  80312a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80312e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803132:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803136:	48 89 c7             	mov    %rax,%rdi
  803139:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  803140:	00 00 00 
  803143:	ff d0                	callq  *%rax
  803145:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803149:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314d:	48 be ff 3d 80 00 00 	movabs $0x803dff,%rsi
  803154:	00 00 00 
  803157:	48 89 c7             	mov    %rax,%rdi
  80315a:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  803161:	00 00 00 
  803164:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803166:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80316a:	8b 50 04             	mov    0x4(%rax),%edx
  80316d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803171:	8b 00                	mov    (%rax),%eax
  803173:	29 c2                	sub    %eax,%edx
  803175:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803179:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80317f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803183:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80318a:	00 00 00 
	stat->st_dev = &devpipe;
  80318d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803191:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803198:	00 00 00 
  80319b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8031a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031a7:	c9                   	leaveq 
  8031a8:	c3                   	retq   

00000000008031a9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8031a9:	55                   	push   %rbp
  8031aa:	48 89 e5             	mov    %rsp,%rbp
  8031ad:	48 83 ec 10          	sub    $0x10,%rsp
  8031b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8031b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031b9:	48 89 c6             	mov    %rax,%rsi
  8031bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8031c1:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  8031c8:	00 00 00 
  8031cb:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8031cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031d1:	48 89 c7             	mov    %rax,%rdi
  8031d4:	48 b8 ff 1c 80 00 00 	movabs $0x801cff,%rax
  8031db:	00 00 00 
  8031de:	ff d0                	callq  *%rax
  8031e0:	48 89 c6             	mov    %rax,%rsi
  8031e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8031e8:	48 b8 fb 19 80 00 00 	movabs $0x8019fb,%rax
  8031ef:	00 00 00 
  8031f2:	ff d0                	callq  *%rax
}
  8031f4:	c9                   	leaveq 
  8031f5:	c3                   	retq   

00000000008031f6 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8031f6:	55                   	push   %rbp
  8031f7:	48 89 e5             	mov    %rsp,%rbp
  8031fa:	48 83 ec 20          	sub    $0x20,%rsp
  8031fe:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803201:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803204:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803207:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80320b:	be 01 00 00 00       	mov    $0x1,%esi
  803210:	48 89 c7             	mov    %rax,%rdi
  803213:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  80321a:	00 00 00 
  80321d:	ff d0                	callq  *%rax
}
  80321f:	c9                   	leaveq 
  803220:	c3                   	retq   

0000000000803221 <getchar>:

int
getchar(void)
{
  803221:	55                   	push   %rbp
  803222:	48 89 e5             	mov    %rsp,%rbp
  803225:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803229:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80322d:	ba 01 00 00 00       	mov    $0x1,%edx
  803232:	48 89 c6             	mov    %rax,%rsi
  803235:	bf 00 00 00 00       	mov    $0x0,%edi
  80323a:	48 b8 f4 21 80 00 00 	movabs $0x8021f4,%rax
  803241:	00 00 00 
  803244:	ff d0                	callq  *%rax
  803246:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803249:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80324d:	79 05                	jns    803254 <getchar+0x33>
		return r;
  80324f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803252:	eb 14                	jmp    803268 <getchar+0x47>
	if (r < 1)
  803254:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803258:	7f 07                	jg     803261 <getchar+0x40>
		return -E_EOF;
  80325a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80325f:	eb 07                	jmp    803268 <getchar+0x47>
	return c;
  803261:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803265:	0f b6 c0             	movzbl %al,%eax
}
  803268:	c9                   	leaveq 
  803269:	c3                   	retq   

000000000080326a <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80326a:	55                   	push   %rbp
  80326b:	48 89 e5             	mov    %rsp,%rbp
  80326e:	48 83 ec 20          	sub    $0x20,%rsp
  803272:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803275:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80327c:	48 89 d6             	mov    %rdx,%rsi
  80327f:	89 c7                	mov    %eax,%edi
  803281:	48 b8 c2 1d 80 00 00 	movabs $0x801dc2,%rax
  803288:	00 00 00 
  80328b:	ff d0                	callq  *%rax
  80328d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803290:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803294:	79 05                	jns    80329b <iscons+0x31>
		return r;
  803296:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803299:	eb 1a                	jmp    8032b5 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80329b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80329f:	8b 10                	mov    (%rax),%edx
  8032a1:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  8032a8:	00 00 00 
  8032ab:	8b 00                	mov    (%rax),%eax
  8032ad:	39 c2                	cmp    %eax,%edx
  8032af:	0f 94 c0             	sete   %al
  8032b2:	0f b6 c0             	movzbl %al,%eax
}
  8032b5:	c9                   	leaveq 
  8032b6:	c3                   	retq   

00000000008032b7 <opencons>:

int
opencons(void)
{
  8032b7:	55                   	push   %rbp
  8032b8:	48 89 e5             	mov    %rsp,%rbp
  8032bb:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8032bf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8032c3:	48 89 c7             	mov    %rax,%rdi
  8032c6:	48 b8 2a 1d 80 00 00 	movabs $0x801d2a,%rax
  8032cd:	00 00 00 
  8032d0:	ff d0                	callq  *%rax
  8032d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d9:	79 05                	jns    8032e0 <opencons+0x29>
		return r;
  8032db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032de:	eb 5b                	jmp    80333b <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8032e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e4:	ba 07 04 00 00       	mov    $0x407,%edx
  8032e9:	48 89 c6             	mov    %rax,%rsi
  8032ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8032f1:	48 b8 50 19 80 00 00 	movabs $0x801950,%rax
  8032f8:	00 00 00 
  8032fb:	ff d0                	callq  *%rax
  8032fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803300:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803304:	79 05                	jns    80330b <opencons+0x54>
		return r;
  803306:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803309:	eb 30                	jmp    80333b <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80330b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330f:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  803316:	00 00 00 
  803319:	8b 12                	mov    (%rdx),%edx
  80331b:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80331d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803321:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803328:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80332c:	48 89 c7             	mov    %rax,%rdi
  80332f:	48 b8 dc 1c 80 00 00 	movabs $0x801cdc,%rax
  803336:	00 00 00 
  803339:	ff d0                	callq  *%rax
}
  80333b:	c9                   	leaveq 
  80333c:	c3                   	retq   

000000000080333d <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80333d:	55                   	push   %rbp
  80333e:	48 89 e5             	mov    %rsp,%rbp
  803341:	48 83 ec 30          	sub    $0x30,%rsp
  803345:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803349:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80334d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803351:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803356:	75 07                	jne    80335f <devcons_read+0x22>
		return 0;
  803358:	b8 00 00 00 00       	mov    $0x0,%eax
  80335d:	eb 4b                	jmp    8033aa <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80335f:	eb 0c                	jmp    80336d <devcons_read+0x30>
		sys_yield();
  803361:	48 b8 12 19 80 00 00 	movabs $0x801912,%rax
  803368:	00 00 00 
  80336b:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80336d:	48 b8 52 18 80 00 00 	movabs $0x801852,%rax
  803374:	00 00 00 
  803377:	ff d0                	callq  *%rax
  803379:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80337c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803380:	74 df                	je     803361 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803382:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803386:	79 05                	jns    80338d <devcons_read+0x50>
		return c;
  803388:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80338b:	eb 1d                	jmp    8033aa <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80338d:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803391:	75 07                	jne    80339a <devcons_read+0x5d>
		return 0;
  803393:	b8 00 00 00 00       	mov    $0x0,%eax
  803398:	eb 10                	jmp    8033aa <devcons_read+0x6d>
	*(char*)vbuf = c;
  80339a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80339d:	89 c2                	mov    %eax,%edx
  80339f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a3:	88 10                	mov    %dl,(%rax)
	return 1;
  8033a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8033aa:	c9                   	leaveq 
  8033ab:	c3                   	retq   

00000000008033ac <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8033ac:	55                   	push   %rbp
  8033ad:	48 89 e5             	mov    %rsp,%rbp
  8033b0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8033b7:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8033be:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8033c5:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8033cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8033d3:	eb 76                	jmp    80344b <devcons_write+0x9f>
		m = n - tot;
  8033d5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8033dc:	89 c2                	mov    %eax,%edx
  8033de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033e1:	29 c2                	sub    %eax,%edx
  8033e3:	89 d0                	mov    %edx,%eax
  8033e5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8033e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033eb:	83 f8 7f             	cmp    $0x7f,%eax
  8033ee:	76 07                	jbe    8033f7 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8033f0:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8033f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033fa:	48 63 d0             	movslq %eax,%rdx
  8033fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803400:	48 63 c8             	movslq %eax,%rcx
  803403:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80340a:	48 01 c1             	add    %rax,%rcx
  80340d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803414:	48 89 ce             	mov    %rcx,%rsi
  803417:	48 89 c7             	mov    %rax,%rdi
  80341a:	48 b8 45 13 80 00 00 	movabs $0x801345,%rax
  803421:	00 00 00 
  803424:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803426:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803429:	48 63 d0             	movslq %eax,%rdx
  80342c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803433:	48 89 d6             	mov    %rdx,%rsi
  803436:	48 89 c7             	mov    %rax,%rdi
  803439:	48 b8 08 18 80 00 00 	movabs $0x801808,%rax
  803440:	00 00 00 
  803443:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803445:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803448:	01 45 fc             	add    %eax,-0x4(%rbp)
  80344b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344e:	48 98                	cltq   
  803450:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803457:	0f 82 78 ff ff ff    	jb     8033d5 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80345d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803460:	c9                   	leaveq 
  803461:	c3                   	retq   

0000000000803462 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803462:	55                   	push   %rbp
  803463:	48 89 e5             	mov    %rsp,%rbp
  803466:	48 83 ec 08          	sub    $0x8,%rsp
  80346a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80346e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803473:	c9                   	leaveq 
  803474:	c3                   	retq   

0000000000803475 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803475:	55                   	push   %rbp
  803476:	48 89 e5             	mov    %rsp,%rbp
  803479:	48 83 ec 10          	sub    $0x10,%rsp
  80347d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803481:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803489:	48 be 0b 3e 80 00 00 	movabs $0x803e0b,%rsi
  803490:	00 00 00 
  803493:	48 89 c7             	mov    %rax,%rdi
  803496:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  80349d:	00 00 00 
  8034a0:	ff d0                	callq  *%rax
	return 0;
  8034a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034a7:	c9                   	leaveq 
  8034a8:	c3                   	retq   

00000000008034a9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8034a9:	55                   	push   %rbp
  8034aa:	48 89 e5             	mov    %rsp,%rbp
  8034ad:	48 83 ec 30          	sub    $0x30,%rsp
  8034b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034b9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  8034bd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8034c2:	74 18                	je     8034dc <ipc_recv+0x33>
  8034c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034c8:	48 89 c7             	mov    %rax,%rdi
  8034cb:	48 b8 79 1b 80 00 00 	movabs $0x801b79,%rax
  8034d2:	00 00 00 
  8034d5:	ff d0                	callq  *%rax
  8034d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034da:	eb 19                	jmp    8034f5 <ipc_recv+0x4c>
  8034dc:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8034e3:	00 00 00 
  8034e6:	48 b8 79 1b 80 00 00 	movabs $0x801b79,%rax
  8034ed:	00 00 00 
  8034f0:	ff d0                	callq  *%rax
  8034f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8034f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8034fa:	74 26                	je     803522 <ipc_recv+0x79>
  8034fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803500:	75 15                	jne    803517 <ipc_recv+0x6e>
  803502:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803509:	00 00 00 
  80350c:	48 8b 00             	mov    (%rax),%rax
  80350f:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  803515:	eb 05                	jmp    80351c <ipc_recv+0x73>
  803517:	b8 00 00 00 00       	mov    $0x0,%eax
  80351c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803520:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  803522:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803527:	74 26                	je     80354f <ipc_recv+0xa6>
  803529:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80352d:	75 15                	jne    803544 <ipc_recv+0x9b>
  80352f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  803536:	00 00 00 
  803539:	48 8b 00             	mov    (%rax),%rax
  80353c:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803542:	eb 05                	jmp    803549 <ipc_recv+0xa0>
  803544:	b8 00 00 00 00       	mov    $0x0,%eax
  803549:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80354d:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  80354f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803553:	75 15                	jne    80356a <ipc_recv+0xc1>
  803555:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  80355c:	00 00 00 
  80355f:	48 8b 00             	mov    (%rax),%rax
  803562:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803568:	eb 03                	jmp    80356d <ipc_recv+0xc4>
  80356a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80356d:	c9                   	leaveq 
  80356e:	c3                   	retq   

000000000080356f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80356f:	55                   	push   %rbp
  803570:	48 89 e5             	mov    %rsp,%rbp
  803573:	48 83 ec 30          	sub    $0x30,%rsp
  803577:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80357a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80357d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803581:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803584:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  80358b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803590:	75 10                	jne    8035a2 <ipc_send+0x33>
  803592:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803599:	00 00 00 
  80359c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  8035a0:	eb 62                	jmp    803604 <ipc_send+0x95>
  8035a2:	eb 60                	jmp    803604 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  8035a4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8035a8:	74 30                	je     8035da <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  8035aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ad:	89 c1                	mov    %eax,%ecx
  8035af:	48 ba 12 3e 80 00 00 	movabs $0x803e12,%rdx
  8035b6:	00 00 00 
  8035b9:	be 33 00 00 00       	mov    $0x33,%esi
  8035be:	48 bf 2e 3e 80 00 00 	movabs $0x803e2e,%rdi
  8035c5:	00 00 00 
  8035c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8035cd:	49 b8 33 02 80 00 00 	movabs $0x800233,%r8
  8035d4:	00 00 00 
  8035d7:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  8035da:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8035dd:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8035e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8035e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035e7:	89 c7                	mov    %eax,%edi
  8035e9:	48 b8 24 1b 80 00 00 	movabs $0x801b24,%rax
  8035f0:	00 00 00 
  8035f3:	ff d0                	callq  *%rax
  8035f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8035f8:	48 b8 12 19 80 00 00 	movabs $0x801912,%rax
  8035ff:	00 00 00 
  803602:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  803604:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803608:	75 9a                	jne    8035a4 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  80360a:	c9                   	leaveq 
  80360b:	c3                   	retq   

000000000080360c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80360c:	55                   	push   %rbp
  80360d:	48 89 e5             	mov    %rsp,%rbp
  803610:	48 83 ec 14          	sub    $0x14,%rsp
  803614:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803617:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80361e:	eb 5e                	jmp    80367e <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  803620:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803627:	00 00 00 
  80362a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80362d:	48 63 d0             	movslq %eax,%rdx
  803630:	48 89 d0             	mov    %rdx,%rax
  803633:	48 c1 e0 03          	shl    $0x3,%rax
  803637:	48 01 d0             	add    %rdx,%rax
  80363a:	48 c1 e0 05          	shl    $0x5,%rax
  80363e:	48 01 c8             	add    %rcx,%rax
  803641:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803647:	8b 00                	mov    (%rax),%eax
  803649:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80364c:	75 2c                	jne    80367a <ipc_find_env+0x6e>
			return envs[i].env_id;
  80364e:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803655:	00 00 00 
  803658:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365b:	48 63 d0             	movslq %eax,%rdx
  80365e:	48 89 d0             	mov    %rdx,%rax
  803661:	48 c1 e0 03          	shl    $0x3,%rax
  803665:	48 01 d0             	add    %rdx,%rax
  803668:	48 c1 e0 05          	shl    $0x5,%rax
  80366c:	48 01 c8             	add    %rcx,%rax
  80366f:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803675:	8b 40 08             	mov    0x8(%rax),%eax
  803678:	eb 12                	jmp    80368c <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80367a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80367e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803685:	7e 99                	jle    803620 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803687:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80368c:	c9                   	leaveq 
  80368d:	c3                   	retq   

000000000080368e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80368e:	55                   	push   %rbp
  80368f:	48 89 e5             	mov    %rsp,%rbp
  803692:	48 83 ec 18          	sub    $0x18,%rsp
  803696:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80369a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80369e:	48 c1 e8 15          	shr    $0x15,%rax
  8036a2:	48 89 c2             	mov    %rax,%rdx
  8036a5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8036ac:	01 00 00 
  8036af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036b3:	83 e0 01             	and    $0x1,%eax
  8036b6:	48 85 c0             	test   %rax,%rax
  8036b9:	75 07                	jne    8036c2 <pageref+0x34>
		return 0;
  8036bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c0:	eb 53                	jmp    803715 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8036c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c6:	48 c1 e8 0c          	shr    $0xc,%rax
  8036ca:	48 89 c2             	mov    %rax,%rdx
  8036cd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8036d4:	01 00 00 
  8036d7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8036db:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8036df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e3:	83 e0 01             	and    $0x1,%eax
  8036e6:	48 85 c0             	test   %rax,%rax
  8036e9:	75 07                	jne    8036f2 <pageref+0x64>
		return 0;
  8036eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f0:	eb 23                	jmp    803715 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8036f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f6:	48 c1 e8 0c          	shr    $0xc,%rax
  8036fa:	48 89 c2             	mov    %rax,%rdx
  8036fd:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803704:	00 00 00 
  803707:	48 c1 e2 04          	shl    $0x4,%rdx
  80370b:	48 01 d0             	add    %rdx,%rax
  80370e:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803712:	0f b7 c0             	movzwl %ax,%eax
}
  803715:	c9                   	leaveq 
  803716:	c3                   	retq   
