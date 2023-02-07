
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
  800061:	48 bf e0 1c 80 00 00 	movabs $0x801ce0,%rdi
  800068:	00 00 00 
  80006b:	b8 00 00 00 00       	mov    $0x0,%eax
  800070:	48 ba 4a 04 80 00 00 	movabs $0x80044a,%rdx
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
  80009b:	48 b8 2e 19 80 00 00 	movabs $0x80192e,%rax
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
  8000bd:	48 ba f0 1c 80 00 00 	movabs $0x801cf0,%rdx
  8000c4:	00 00 00 
  8000c7:	be 0f 00 00 00       	mov    $0xf,%esi
  8000cc:	48 bf 1b 1d 80 00 00 	movabs $0x801d1b,%rdi
  8000d3:	00 00 00 
  8000d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000db:	49 b9 11 02 80 00 00 	movabs $0x800211,%r9
  8000e2:	00 00 00 
  8000e5:	41 ff d1             	callq  *%r9
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	48 89 d1             	mov    %rdx,%rcx
  8000f3:	48 ba 30 1d 80 00 00 	movabs $0x801d30,%rdx
  8000fa:	00 00 00 
  8000fd:	be 64 00 00 00       	mov    $0x64,%esi
  800102:	48 89 c7             	mov    %rax,%rdi
  800105:	b8 00 00 00 00       	mov    $0x0,%eax
  80010a:	49 b8 b2 0e 80 00 00 	movabs $0x800eb2,%r8
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
  800132:	48 b8 51 1b 80 00 00 	movabs $0x801b51,%rax
  800139:	00 00 00 
  80013c:	ff d0                	callq  *%rax
	sys_cputs((char*)0xDEADBEEF, 4);
  80013e:	be 04 00 00 00       	mov    $0x4,%esi
  800143:	bf ef be ad de       	mov    $0xdeadbeef,%edi
  800148:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
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
  80015a:	48 83 ec 20          	sub    $0x20,%rsp
  80015e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800161:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800165:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  80016c:	00 00 00 
  80016f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	envid_t id = sys_getenvid();
  800176:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  80017d:	00 00 00 
  800180:	ff d0                	callq  *%rax
  800182:	89 45 fc             	mov    %eax,-0x4(%rbp)
        id = ENVX(id);
  800185:	81 65 fc ff 03 00 00 	andl   $0x3ff,-0x4(%rbp)
	thisenv = &envs[id];
  80018c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018f:	48 63 d0             	movslq %eax,%rdx
  800192:	48 89 d0             	mov    %rdx,%rax
  800195:	48 c1 e0 03          	shl    $0x3,%rax
  800199:	48 01 d0             	add    %rdx,%rax
  80019c:	48 c1 e0 05          	shl    $0x5,%rax
  8001a0:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8001a7:	00 00 00 
  8001aa:	48 01 c2             	add    %rax,%rdx
  8001ad:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  8001b4:	00 00 00 
  8001b7:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001be:	7e 14                	jle    8001d4 <libmain+0x7e>
		binaryname = argv[0];
  8001c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001c4:	48 8b 10             	mov    (%rax),%rdx
  8001c7:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8001ce:	00 00 00 
  8001d1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8001d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001db:	48 89 d6             	mov    %rdx,%rsi
  8001de:	89 c7                	mov    %eax,%edi
  8001e0:	48 b8 19 01 80 00 00 	movabs $0x800119,%rax
  8001e7:	00 00 00 
  8001ea:	ff d0                	callq  *%rax
	
	//cprintf("\noutside\n");
	// exit gracefully
	exit();
  8001ec:	48 b8 fa 01 80 00 00 	movabs $0x8001fa,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax
}
  8001f8:	c9                   	leaveq 
  8001f9:	c3                   	retq   

00000000008001fa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001fa:	55                   	push   %rbp
  8001fb:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  8001fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800203:	48 b8 6e 18 80 00 00 	movabs $0x80186e,%rax
  80020a:	00 00 00 
  80020d:	ff d0                	callq  *%rax
}
  80020f:	5d                   	pop    %rbp
  800210:	c3                   	retq   

0000000000800211 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800211:	55                   	push   %rbp
  800212:	48 89 e5             	mov    %rsp,%rbp
  800215:	53                   	push   %rbx
  800216:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80021d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800224:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80022a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800231:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800238:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80023f:	84 c0                	test   %al,%al
  800241:	74 23                	je     800266 <_panic+0x55>
  800243:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80024a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80024e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800252:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800256:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80025a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80025e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800262:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800266:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80026d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800274:	00 00 00 
  800277:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80027e:	00 00 00 
  800281:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800285:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80028c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800293:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80029a:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002a1:	00 00 00 
  8002a4:	48 8b 18             	mov    (%rax),%rbx
  8002a7:	48 b8 b2 18 80 00 00 	movabs $0x8018b2,%rax
  8002ae:	00 00 00 
  8002b1:	ff d0                	callq  *%rax
  8002b3:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002b9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002c0:	41 89 c8             	mov    %ecx,%r8d
  8002c3:	48 89 d1             	mov    %rdx,%rcx
  8002c6:	48 89 da             	mov    %rbx,%rdx
  8002c9:	89 c6                	mov    %eax,%esi
  8002cb:	48 bf 60 1d 80 00 00 	movabs $0x801d60,%rdi
  8002d2:	00 00 00 
  8002d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002da:	49 b9 4a 04 80 00 00 	movabs $0x80044a,%r9
  8002e1:	00 00 00 
  8002e4:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e7:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8002ee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8002f5:	48 89 d6             	mov    %rdx,%rsi
  8002f8:	48 89 c7             	mov    %rax,%rdi
  8002fb:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  800302:	00 00 00 
  800305:	ff d0                	callq  *%rax
	cprintf("\n");
  800307:	48 bf 83 1d 80 00 00 	movabs $0x801d83,%rdi
  80030e:	00 00 00 
  800311:	b8 00 00 00 00       	mov    $0x0,%eax
  800316:	48 ba 4a 04 80 00 00 	movabs $0x80044a,%rdx
  80031d:	00 00 00 
  800320:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800322:	cc                   	int3   
  800323:	eb fd                	jmp    800322 <_panic+0x111>

0000000000800325 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800325:	55                   	push   %rbp
  800326:	48 89 e5             	mov    %rsp,%rbp
  800329:	48 83 ec 10          	sub    $0x10,%rsp
  80032d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800330:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->buf[b->idx++] = ch;
  800334:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800338:	8b 00                	mov    (%rax),%eax
  80033a:	8d 48 01             	lea    0x1(%rax),%ecx
  80033d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800341:	89 0a                	mov    %ecx,(%rdx)
  800343:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800346:	89 d1                	mov    %edx,%ecx
  800348:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80034c:	48 98                	cltq   
  80034e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
	if (b->idx == 256-1) {
  800352:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800356:	8b 00                	mov    (%rax),%eax
  800358:	3d ff 00 00 00       	cmp    $0xff,%eax
  80035d:	75 2c                	jne    80038b <putch+0x66>
		sys_cputs(b->buf, b->idx);
  80035f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800363:	8b 00                	mov    (%rax),%eax
  800365:	48 98                	cltq   
  800367:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80036b:	48 83 c2 08          	add    $0x8,%rdx
  80036f:	48 89 c6             	mov    %rax,%rsi
  800372:	48 89 d7             	mov    %rdx,%rdi
  800375:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  80037c:	00 00 00 
  80037f:	ff d0                	callq  *%rax
		b->idx = 0;
  800381:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800385:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	b->cnt++;
  80038b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80038f:	8b 40 04             	mov    0x4(%rax),%eax
  800392:	8d 50 01             	lea    0x1(%rax),%edx
  800395:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800399:	89 50 04             	mov    %edx,0x4(%rax)
}
  80039c:	c9                   	leaveq 
  80039d:	c3                   	retq   

000000000080039e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80039e:	55                   	push   %rbp
  80039f:	48 89 e5             	mov    %rsp,%rbp
  8003a2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003a9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003b0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
	struct printbuf b;
	va_list aq;
	va_copy(aq,ap);
  8003b7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003be:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8003c5:	48 8b 0a             	mov    (%rdx),%rcx
  8003c8:	48 89 08             	mov    %rcx,(%rax)
  8003cb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8003cf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8003d3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8003d7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	b.idx = 0;
  8003db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8003e2:	00 00 00 
	b.cnt = 0;
  8003e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8003ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, aq);
  8003ef:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8003f6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8003fd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800404:	48 89 c6             	mov    %rax,%rsi
  800407:	48 bf 25 03 80 00 00 	movabs $0x800325,%rdi
  80040e:	00 00 00 
  800411:	48 b8 fd 07 80 00 00 	movabs $0x8007fd,%rax
  800418:	00 00 00 
  80041b:	ff d0                	callq  *%rax
	sys_cputs(b.buf, b.idx);
  80041d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800423:	48 98                	cltq   
  800425:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80042c:	48 83 c2 08          	add    $0x8,%rdx
  800430:	48 89 c6             	mov    %rax,%rsi
  800433:	48 89 d7             	mov    %rdx,%rdi
  800436:	48 b8 e6 17 80 00 00 	movabs $0x8017e6,%rax
  80043d:	00 00 00 
  800440:	ff d0                	callq  *%rax
	va_end(aq);

	return b.cnt;
  800442:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800448:	c9                   	leaveq 
  800449:	c3                   	retq   

000000000080044a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80044a:	55                   	push   %rbp
  80044b:	48 89 e5             	mov    %rsp,%rbp
  80044e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800455:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80045c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800463:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80046a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800471:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800478:	84 c0                	test   %al,%al
  80047a:	74 20                	je     80049c <cprintf+0x52>
  80047c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800480:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800484:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800488:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80048c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800490:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800494:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800498:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80049c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
	va_list ap;
	int cnt;
	va_list aq;
	va_start(ap, fmt);
  8004a3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004aa:	00 00 00 
  8004ad:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004b4:	00 00 00 
  8004b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004bb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8004c2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8004c9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8004d0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8004d7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8004de:	48 8b 0a             	mov    (%rdx),%rcx
  8004e1:	48 89 08             	mov    %rcx,(%rax)
  8004e4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004e8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004ec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004f0:	48 89 50 10          	mov    %rdx,0x10(%rax)
	cnt = vcprintf(fmt, aq);
  8004f4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8004fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800502:	48 89 d6             	mov    %rdx,%rsi
  800505:	48 89 c7             	mov    %rax,%rdi
  800508:	48 b8 9e 03 80 00 00 	movabs $0x80039e,%rax
  80050f:	00 00 00 
  800512:	ff d0                	callq  *%rax
  800514:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return cnt;
  80051a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800520:	c9                   	leaveq 
  800521:	c3                   	retq   

0000000000800522 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800522:	55                   	push   %rbp
  800523:	48 89 e5             	mov    %rsp,%rbp
  800526:	53                   	push   %rbx
  800527:	48 83 ec 38          	sub    $0x38,%rsp
  80052b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80052f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800533:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800537:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80053a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80053e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800542:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800545:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800549:	77 3b                	ja     800586 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80054b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80054e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800552:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800555:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800559:	ba 00 00 00 00       	mov    $0x0,%edx
  80055e:	48 f7 f3             	div    %rbx
  800561:	48 89 c2             	mov    %rax,%rdx
  800564:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800567:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80056a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80056e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800572:	41 89 f9             	mov    %edi,%r9d
  800575:	48 89 c7             	mov    %rax,%rdi
  800578:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  80057f:	00 00 00 
  800582:	ff d0                	callq  *%rax
  800584:	eb 1e                	jmp    8005a4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800586:	eb 12                	jmp    80059a <printnum+0x78>
			putch(padc, putdat);
  800588:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80058c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80058f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800593:	48 89 ce             	mov    %rcx,%rsi
  800596:	89 d7                	mov    %edx,%edi
  800598:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80059a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80059e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005a2:	7f e4                	jg     800588 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005a4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b0:	48 f7 f1             	div    %rcx
  8005b3:	48 89 d0             	mov    %rdx,%rax
  8005b6:	48 ba 90 1e 80 00 00 	movabs $0x801e90,%rdx
  8005bd:	00 00 00 
  8005c0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8005c4:	0f be d0             	movsbl %al,%edx
  8005c7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005cf:	48 89 ce             	mov    %rcx,%rsi
  8005d2:	89 d7                	mov    %edx,%edi
  8005d4:	ff d0                	callq  *%rax
}
  8005d6:	48 83 c4 38          	add    $0x38,%rsp
  8005da:	5b                   	pop    %rbx
  8005db:	5d                   	pop    %rbp
  8005dc:	c3                   	retq   

00000000008005dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005dd:	55                   	push   %rbp
  8005de:	48 89 e5             	mov    %rsp,%rbp
  8005e1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8005e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8005e9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8005ec:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8005f0:	7e 52                	jle    800644 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8005f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005f6:	8b 00                	mov    (%rax),%eax
  8005f8:	83 f8 30             	cmp    $0x30,%eax
  8005fb:	73 24                	jae    800621 <getuint+0x44>
  8005fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800601:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800609:	8b 00                	mov    (%rax),%eax
  80060b:	89 c0                	mov    %eax,%eax
  80060d:	48 01 d0             	add    %rdx,%rax
  800610:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800614:	8b 12                	mov    (%rdx),%edx
  800616:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800619:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80061d:	89 0a                	mov    %ecx,(%rdx)
  80061f:	eb 17                	jmp    800638 <getuint+0x5b>
  800621:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800625:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800629:	48 89 d0             	mov    %rdx,%rax
  80062c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800630:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800634:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800638:	48 8b 00             	mov    (%rax),%rax
  80063b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80063f:	e9 a3 00 00 00       	jmpq   8006e7 <getuint+0x10a>
	else if (lflag)
  800644:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800648:	74 4f                	je     800699 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80064a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064e:	8b 00                	mov    (%rax),%eax
  800650:	83 f8 30             	cmp    $0x30,%eax
  800653:	73 24                	jae    800679 <getuint+0x9c>
  800655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800659:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80065d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800661:	8b 00                	mov    (%rax),%eax
  800663:	89 c0                	mov    %eax,%eax
  800665:	48 01 d0             	add    %rdx,%rax
  800668:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80066c:	8b 12                	mov    (%rdx),%edx
  80066e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800671:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800675:	89 0a                	mov    %ecx,(%rdx)
  800677:	eb 17                	jmp    800690 <getuint+0xb3>
  800679:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800681:	48 89 d0             	mov    %rdx,%rax
  800684:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800688:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80068c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800690:	48 8b 00             	mov    (%rax),%rax
  800693:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800697:	eb 4e                	jmp    8006e7 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800699:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80069d:	8b 00                	mov    (%rax),%eax
  80069f:	83 f8 30             	cmp    $0x30,%eax
  8006a2:	73 24                	jae    8006c8 <getuint+0xeb>
  8006a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006b0:	8b 00                	mov    (%rax),%eax
  8006b2:	89 c0                	mov    %eax,%eax
  8006b4:	48 01 d0             	add    %rdx,%rax
  8006b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bb:	8b 12                	mov    (%rdx),%edx
  8006bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006c4:	89 0a                	mov    %ecx,(%rdx)
  8006c6:	eb 17                	jmp    8006df <getuint+0x102>
  8006c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006d0:	48 89 d0             	mov    %rdx,%rax
  8006d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006df:	8b 00                	mov    (%rax),%eax
  8006e1:	89 c0                	mov    %eax,%eax
  8006e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8006e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8006eb:	c9                   	leaveq 
  8006ec:	c3                   	retq   

00000000008006ed <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ed:	55                   	push   %rbp
  8006ee:	48 89 e5             	mov    %rsp,%rbp
  8006f1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006f9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8006fc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800700:	7e 52                	jle    800754 <getint+0x67>
		x=va_arg(*ap, long long);
  800702:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800706:	8b 00                	mov    (%rax),%eax
  800708:	83 f8 30             	cmp    $0x30,%eax
  80070b:	73 24                	jae    800731 <getint+0x44>
  80070d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800711:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800719:	8b 00                	mov    (%rax),%eax
  80071b:	89 c0                	mov    %eax,%eax
  80071d:	48 01 d0             	add    %rdx,%rax
  800720:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800724:	8b 12                	mov    (%rdx),%edx
  800726:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800729:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80072d:	89 0a                	mov    %ecx,(%rdx)
  80072f:	eb 17                	jmp    800748 <getint+0x5b>
  800731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800735:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800739:	48 89 d0             	mov    %rdx,%rax
  80073c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800740:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800744:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800748:	48 8b 00             	mov    (%rax),%rax
  80074b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80074f:	e9 a3 00 00 00       	jmpq   8007f7 <getint+0x10a>
	else if (lflag)
  800754:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800758:	74 4f                	je     8007a9 <getint+0xbc>
		x=va_arg(*ap, long);
  80075a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80075e:	8b 00                	mov    (%rax),%eax
  800760:	83 f8 30             	cmp    $0x30,%eax
  800763:	73 24                	jae    800789 <getint+0x9c>
  800765:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800769:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80076d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800771:	8b 00                	mov    (%rax),%eax
  800773:	89 c0                	mov    %eax,%eax
  800775:	48 01 d0             	add    %rdx,%rax
  800778:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077c:	8b 12                	mov    (%rdx),%edx
  80077e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800781:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800785:	89 0a                	mov    %ecx,(%rdx)
  800787:	eb 17                	jmp    8007a0 <getint+0xb3>
  800789:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800791:	48 89 d0             	mov    %rdx,%rax
  800794:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800798:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80079c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007a0:	48 8b 00             	mov    (%rax),%rax
  8007a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007a7:	eb 4e                	jmp    8007f7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ad:	8b 00                	mov    (%rax),%eax
  8007af:	83 f8 30             	cmp    $0x30,%eax
  8007b2:	73 24                	jae    8007d8 <getint+0xeb>
  8007b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c0:	8b 00                	mov    (%rax),%eax
  8007c2:	89 c0                	mov    %eax,%eax
  8007c4:	48 01 d0             	add    %rdx,%rax
  8007c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007cb:	8b 12                	mov    (%rdx),%edx
  8007cd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d4:	89 0a                	mov    %ecx,(%rdx)
  8007d6:	eb 17                	jmp    8007ef <getint+0x102>
  8007d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007dc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007e0:	48 89 d0             	mov    %rdx,%rax
  8007e3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007e7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ef:	8b 00                	mov    (%rax),%eax
  8007f1:	48 98                	cltq   
  8007f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007fb:	c9                   	leaveq 
  8007fc:	c3                   	retq   

00000000008007fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007fd:	55                   	push   %rbp
  8007fe:	48 89 e5             	mov    %rsp,%rbp
  800801:	41 54                	push   %r12
  800803:	53                   	push   %rbx
  800804:	48 83 ec 60          	sub    $0x60,%rsp
  800808:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80080c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800810:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800814:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800818:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80081c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800820:	48 8b 0a             	mov    (%rdx),%rcx
  800823:	48 89 08             	mov    %rcx,(%rax)
  800826:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80082a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80082e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800832:	48 89 50 10          	mov    %rdx,0x10(%rax)
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800836:	eb 17                	jmp    80084f <vprintfmt+0x52>
			if (ch == '\0')
  800838:	85 db                	test   %ebx,%ebx
  80083a:	0f 84 cc 04 00 00    	je     800d0c <vprintfmt+0x50f>
                }
#endif

			  return;
			}
			putch(ch, putdat);
  800840:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800844:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800848:	48 89 d6             	mov    %rdx,%rsi
  80084b:	89 df                	mov    %ebx,%edi
  80084d:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80084f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800853:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800857:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80085b:	0f b6 00             	movzbl (%rax),%eax
  80085e:	0f b6 d8             	movzbl %al,%ebx
  800861:	83 fb 25             	cmp    $0x25,%ebx
  800864:	75 d2                	jne    800838 <vprintfmt+0x3b>
			  return;
			}
			putch(ch, putdat);
		}
		// Process a %-escape sequence
		padc = ' ';
  800866:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80086a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800871:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800878:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80087f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800886:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80088a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80088e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800892:	0f b6 00             	movzbl (%rax),%eax
  800895:	0f b6 d8             	movzbl %al,%ebx
  800898:	8d 43 dd             	lea    -0x23(%rbx),%eax
  80089b:	83 f8 55             	cmp    $0x55,%eax
  80089e:	0f 87 34 04 00 00    	ja     800cd8 <vprintfmt+0x4db>
  8008a4:	89 c0                	mov    %eax,%eax
  8008a6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008ad:	00 
  8008ae:	48 b8 b8 1e 80 00 00 	movabs $0x801eb8,%rax
  8008b5:	00 00 00 
  8008b8:	48 01 d0             	add    %rdx,%rax
  8008bb:	48 8b 00             	mov    (%rax),%rax
  8008be:	ff e0                	jmpq   *%rax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008c0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8008c4:	eb c0                	jmp    800886 <vprintfmt+0x89>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008c6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8008ca:	eb ba                	jmp    800886 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008cc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8008d3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8008d6:	89 d0                	mov    %edx,%eax
  8008d8:	c1 e0 02             	shl    $0x2,%eax
  8008db:	01 d0                	add    %edx,%eax
  8008dd:	01 c0                	add    %eax,%eax
  8008df:	01 d8                	add    %ebx,%eax
  8008e1:	83 e8 30             	sub    $0x30,%eax
  8008e4:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8008e7:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008eb:	0f b6 00             	movzbl (%rax),%eax
  8008ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8008f4:	7e 0c                	jle    800902 <vprintfmt+0x105>
  8008f6:	83 fb 39             	cmp    $0x39,%ebx
  8008f9:	7f 07                	jg     800902 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008fb:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800900:	eb d1                	jmp    8008d3 <vprintfmt+0xd6>
			goto process_precision;
  800902:	eb 58                	jmp    80095c <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800904:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800907:	83 f8 30             	cmp    $0x30,%eax
  80090a:	73 17                	jae    800923 <vprintfmt+0x126>
  80090c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800910:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800913:	89 c0                	mov    %eax,%eax
  800915:	48 01 d0             	add    %rdx,%rax
  800918:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80091b:	83 c2 08             	add    $0x8,%edx
  80091e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800921:	eb 0f                	jmp    800932 <vprintfmt+0x135>
  800923:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800927:	48 89 d0             	mov    %rdx,%rax
  80092a:	48 83 c2 08          	add    $0x8,%rdx
  80092e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800932:	8b 00                	mov    (%rax),%eax
  800934:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800937:	eb 23                	jmp    80095c <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800939:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80093d:	79 0c                	jns    80094b <vprintfmt+0x14e>
				width = 0;
  80093f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800946:	e9 3b ff ff ff       	jmpq   800886 <vprintfmt+0x89>
  80094b:	e9 36 ff ff ff       	jmpq   800886 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800950:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800957:	e9 2a ff ff ff       	jmpq   800886 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800960:	79 12                	jns    800974 <vprintfmt+0x177>
				width = precision, precision = -1;
  800962:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800965:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800968:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80096f:	e9 12 ff ff ff       	jmpq   800886 <vprintfmt+0x89>
  800974:	e9 0d ff ff ff       	jmpq   800886 <vprintfmt+0x89>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800979:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80097d:	e9 04 ff ff ff       	jmpq   800886 <vprintfmt+0x89>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			putch(va_arg(aq, int), putdat);
  800982:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800985:	83 f8 30             	cmp    $0x30,%eax
  800988:	73 17                	jae    8009a1 <vprintfmt+0x1a4>
  80098a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80098e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800991:	89 c0                	mov    %eax,%eax
  800993:	48 01 d0             	add    %rdx,%rax
  800996:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800999:	83 c2 08             	add    $0x8,%edx
  80099c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80099f:	eb 0f                	jmp    8009b0 <vprintfmt+0x1b3>
  8009a1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009a5:	48 89 d0             	mov    %rdx,%rax
  8009a8:	48 83 c2 08          	add    $0x8,%rdx
  8009ac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009b0:	8b 10                	mov    (%rax),%edx
  8009b2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009b6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009ba:	48 89 ce             	mov    %rcx,%rsi
  8009bd:	89 d7                	mov    %edx,%edi
  8009bf:	ff d0                	callq  *%rax
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  8009c1:	e9 40 03 00 00       	jmpq   800d06 <vprintfmt+0x509>

		// error message
		case 'e':
			err = va_arg(aq, int);
  8009c6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c9:	83 f8 30             	cmp    $0x30,%eax
  8009cc:	73 17                	jae    8009e5 <vprintfmt+0x1e8>
  8009ce:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009d2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d5:	89 c0                	mov    %eax,%eax
  8009d7:	48 01 d0             	add    %rdx,%rax
  8009da:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009dd:	83 c2 08             	add    $0x8,%edx
  8009e0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009e3:	eb 0f                	jmp    8009f4 <vprintfmt+0x1f7>
  8009e5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e9:	48 89 d0             	mov    %rdx,%rax
  8009ec:	48 83 c2 08          	add    $0x8,%rdx
  8009f0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009f4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8009f6:	85 db                	test   %ebx,%ebx
  8009f8:	79 02                	jns    8009fc <vprintfmt+0x1ff>
				err = -err;
  8009fa:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009fc:	83 fb 09             	cmp    $0x9,%ebx
  8009ff:	7f 16                	jg     800a17 <vprintfmt+0x21a>
  800a01:	48 b8 40 1e 80 00 00 	movabs $0x801e40,%rax
  800a08:	00 00 00 
  800a0b:	48 63 d3             	movslq %ebx,%rdx
  800a0e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a12:	4d 85 e4             	test   %r12,%r12
  800a15:	75 2e                	jne    800a45 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a17:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a1f:	89 d9                	mov    %ebx,%ecx
  800a21:	48 ba a1 1e 80 00 00 	movabs $0x801ea1,%rdx
  800a28:	00 00 00 
  800a2b:	48 89 c7             	mov    %rax,%rdi
  800a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a33:	49 b8 15 0d 80 00 00 	movabs $0x800d15,%r8
  800a3a:	00 00 00 
  800a3d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a40:	e9 c1 02 00 00       	jmpq   800d06 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a45:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a49:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4d:	4c 89 e1             	mov    %r12,%rcx
  800a50:	48 ba aa 1e 80 00 00 	movabs $0x801eaa,%rdx
  800a57:	00 00 00 
  800a5a:	48 89 c7             	mov    %rax,%rdi
  800a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a62:	49 b8 15 0d 80 00 00 	movabs $0x800d15,%r8
  800a69:	00 00 00 
  800a6c:	41 ff d0             	callq  *%r8
			break;
  800a6f:	e9 92 02 00 00       	jmpq   800d06 <vprintfmt+0x509>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
  800a74:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a77:	83 f8 30             	cmp    $0x30,%eax
  800a7a:	73 17                	jae    800a93 <vprintfmt+0x296>
  800a7c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a80:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a83:	89 c0                	mov    %eax,%eax
  800a85:	48 01 d0             	add    %rdx,%rax
  800a88:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a8b:	83 c2 08             	add    $0x8,%edx
  800a8e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a91:	eb 0f                	jmp    800aa2 <vprintfmt+0x2a5>
  800a93:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a97:	48 89 d0             	mov    %rdx,%rax
  800a9a:	48 83 c2 08          	add    $0x8,%rdx
  800a9e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800aa2:	4c 8b 20             	mov    (%rax),%r12
  800aa5:	4d 85 e4             	test   %r12,%r12
  800aa8:	75 0a                	jne    800ab4 <vprintfmt+0x2b7>
				p = "(null)";
  800aaa:	49 bc ad 1e 80 00 00 	movabs $0x801ead,%r12
  800ab1:	00 00 00 
			if (width > 0 && padc != '-')
  800ab4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ab8:	7e 3f                	jle    800af9 <vprintfmt+0x2fc>
  800aba:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800abe:	74 39                	je     800af9 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ac3:	48 98                	cltq   
  800ac5:	48 89 c6             	mov    %rax,%rsi
  800ac8:	4c 89 e7             	mov    %r12,%rdi
  800acb:	48 b8 c1 0f 80 00 00 	movabs $0x800fc1,%rax
  800ad2:	00 00 00 
  800ad5:	ff d0                	callq  *%rax
  800ad7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ada:	eb 17                	jmp    800af3 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800adc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ae0:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ae4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae8:	48 89 ce             	mov    %rcx,%rsi
  800aeb:	89 d7                	mov    %edx,%edi
  800aed:	ff d0                	callq  *%rax
                }
#endif
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800aef:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800af3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af7:	7f e3                	jg     800adc <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af9:	eb 37                	jmp    800b32 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800afb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800aff:	74 1e                	je     800b1f <vprintfmt+0x322>
  800b01:	83 fb 1f             	cmp    $0x1f,%ebx
  800b04:	7e 05                	jle    800b0b <vprintfmt+0x30e>
  800b06:	83 fb 7e             	cmp    $0x7e,%ebx
  800b09:	7e 14                	jle    800b1f <vprintfmt+0x322>
					putch('?', putdat);
  800b0b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b0f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b13:	48 89 d6             	mov    %rdx,%rsi
  800b16:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b1b:	ff d0                	callq  *%rax
  800b1d:	eb 0f                	jmp    800b2e <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b27:	48 89 d6             	mov    %rdx,%rsi
  800b2a:	89 df                	mov    %ebx,%edi
  800b2c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b32:	4c 89 e0             	mov    %r12,%rax
  800b35:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b39:	0f b6 00             	movzbl (%rax),%eax
  800b3c:	0f be d8             	movsbl %al,%ebx
  800b3f:	85 db                	test   %ebx,%ebx
  800b41:	74 10                	je     800b53 <vprintfmt+0x356>
  800b43:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b47:	78 b2                	js     800afb <vprintfmt+0x2fe>
  800b49:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b4d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b51:	79 a8                	jns    800afb <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b53:	eb 16                	jmp    800b6b <vprintfmt+0x36e>
				putch(' ', putdat);
  800b55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b5d:	48 89 d6             	mov    %rdx,%rsi
  800b60:	bf 20 00 00 00       	mov    $0x20,%edi
  800b65:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b67:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b6f:	7f e4                	jg     800b55 <vprintfmt+0x358>
	          putch(ch, putdat);
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			break;
  800b71:	e9 90 01 00 00       	jmpq   800d06 <vprintfmt+0x509>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getint(&aq, 3);
  800b76:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b7a:	be 03 00 00 00       	mov    $0x3,%esi
  800b7f:	48 89 c7             	mov    %rax,%rdi
  800b82:	48 b8 ed 06 80 00 00 	movabs $0x8006ed,%rax
  800b89:	00 00 00 
  800b8c:	ff d0                	callq  *%rax
  800b8e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800b92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b96:	48 85 c0             	test   %rax,%rax
  800b99:	79 1d                	jns    800bb8 <vprintfmt+0x3bb>
				putch('-', putdat);
  800b9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ba3:	48 89 d6             	mov    %rdx,%rsi
  800ba6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bab:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb1:	48 f7 d8             	neg    %rax
  800bb4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bb8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bbf:	e9 d5 00 00 00       	jmpq   800c99 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
			
			num = getuint(&aq, 3);
  800bc4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bc8:	be 03 00 00 00       	mov    $0x3,%esi
  800bcd:	48 89 c7             	mov    %rax,%rdi
  800bd0:	48 b8 dd 05 80 00 00 	movabs $0x8005dd,%rax
  800bd7:	00 00 00 
  800bda:	ff d0                	callq  *%rax
  800bdc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800be0:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800be7:	e9 ad 00 00 00       	jmpq   800c99 <vprintfmt+0x49c>
                  ch = *(unsigned char *) color;
                }
#endif

			// Replace this with your code.
		        num = getuint(&aq, 3);
  800bec:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf0:	be 03 00 00 00       	mov    $0x3,%esi
  800bf5:	48 89 c7             	mov    %rax,%rdi
  800bf8:	48 b8 dd 05 80 00 00 	movabs $0x8005dd,%rax
  800bff:	00 00 00 
  800c02:	ff d0                	callq  *%rax
  800c04:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800c08:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800c0f:	e9 85 00 00 00       	jmpq   800c99 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			putch('0', putdat);
  800c14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c1c:	48 89 d6             	mov    %rdx,%rsi
  800c1f:	bf 30 00 00 00       	mov    $0x30,%edi
  800c24:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c26:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2e:	48 89 d6             	mov    %rdx,%rsi
  800c31:	bf 78 00 00 00       	mov    $0x78,%edi
  800c36:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c38:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c3b:	83 f8 30             	cmp    $0x30,%eax
  800c3e:	73 17                	jae    800c57 <vprintfmt+0x45a>
  800c40:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c47:	89 c0                	mov    %eax,%eax
  800c49:	48 01 d0             	add    %rdx,%rax
  800c4c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c4f:	83 c2 08             	add    $0x8,%edx
  800c52:	89 55 b8             	mov    %edx,-0x48(%rbp)
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c55:	eb 0f                	jmp    800c66 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800c57:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c5b:	48 89 d0             	mov    %rdx,%rax
  800c5e:	48 83 c2 08          	add    $0x8,%rdx
  800c62:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c66:	48 8b 00             	mov    (%rax),%rax
                }
#endif

			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c69:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800c6d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800c74:	eb 23                	jmp    800c99 <vprintfmt+0x49c>
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			num = getuint(&aq, 3);
  800c76:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c7a:	be 03 00 00 00       	mov    $0x3,%esi
  800c7f:	48 89 c7             	mov    %rax,%rdi
  800c82:	48 b8 dd 05 80 00 00 	movabs $0x8005dd,%rax
  800c89:	00 00 00 
  800c8c:	ff d0                	callq  *%rax
  800c8e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800c92:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:

			printnum(putch, putdat, num, base, width, padc);
  800c99:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800c9e:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800ca1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800ca4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ca8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cb0:	45 89 c1             	mov    %r8d,%r9d
  800cb3:	41 89 f8             	mov    %edi,%r8d
  800cb6:	48 89 c7             	mov    %rax,%rdi
  800cb9:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800cc0:	00 00 00 
  800cc3:	ff d0                	callq  *%rax
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif

			break;
  800cc5:	eb 3f                	jmp    800d06 <vprintfmt+0x509>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cc7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ccb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccf:	48 89 d6             	mov    %rdx,%rsi
  800cd2:	89 df                	mov    %ebx,%edi
  800cd4:	ff d0                	callq  *%rax
			break;
  800cd6:	eb 2e                	jmp    800d06 <vprintfmt+0x509>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ce0:	48 89 d6             	mov    %rdx,%rsi
  800ce3:	bf 25 00 00 00       	mov    $0x25,%edi
  800ce8:	ff d0                	callq  *%rax

			for (fmt--; fmt[-1] != '%'; fmt--)
  800cea:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cef:	eb 05                	jmp    800cf6 <vprintfmt+0x4f9>
  800cf1:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800cf6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cfa:	48 83 e8 01          	sub    $0x1,%rax
  800cfe:	0f b6 00             	movzbl (%rax),%eax
  800d01:	3c 25                	cmp    $0x25,%al
  800d03:	75 ec                	jne    800cf1 <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800d05:	90                   	nop
		}
	}
  800d06:	90                   	nop
                  color++;
                  ch = *(unsigned char *) color;
                }
#endif
   
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d07:	e9 43 fb ff ff       	jmpq   80084f <vprintfmt+0x52>
			break;
		}
	}
    
va_end(aq);
}
  800d0c:	48 83 c4 60          	add    $0x60,%rsp
  800d10:	5b                   	pop    %rbx
  800d11:	41 5c                	pop    %r12
  800d13:	5d                   	pop    %rbp
  800d14:	c3                   	retq   

0000000000800d15 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d15:	55                   	push   %rbp
  800d16:	48 89 e5             	mov    %rsp,%rbp
  800d19:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d20:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d27:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d2e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d35:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d3c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d43:	84 c0                	test   %al,%al
  800d45:	74 20                	je     800d67 <printfmt+0x52>
  800d47:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d4b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d4f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d53:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d57:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d5b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d5f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d63:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800d67:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d6e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800d75:	00 00 00 
  800d78:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800d7f:	00 00 00 
  800d82:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d86:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800d8d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800d94:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800d9b:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800da2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800da9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800db0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800db7:	48 89 c7             	mov    %rax,%rdi
  800dba:	48 b8 fd 07 80 00 00 	movabs $0x8007fd,%rax
  800dc1:	00 00 00 
  800dc4:	ff d0                	callq  *%rax
	va_end(ap);
}
  800dc6:	c9                   	leaveq 
  800dc7:	c3                   	retq   

0000000000800dc8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dc8:	55                   	push   %rbp
  800dc9:	48 89 e5             	mov    %rsp,%rbp
  800dcc:	48 83 ec 10          	sub    $0x10,%rsp
  800dd0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800dd3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800dd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ddb:	8b 40 10             	mov    0x10(%rax),%eax
  800dde:	8d 50 01             	lea    0x1(%rax),%edx
  800de1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800de5:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800de8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dec:	48 8b 10             	mov    (%rax),%rdx
  800def:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800df3:	48 8b 40 08          	mov    0x8(%rax),%rax
  800df7:	48 39 c2             	cmp    %rax,%rdx
  800dfa:	73 17                	jae    800e13 <sprintputch+0x4b>
		*b->buf++ = ch;
  800dfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e00:	48 8b 00             	mov    (%rax),%rax
  800e03:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e0b:	48 89 0a             	mov    %rcx,(%rdx)
  800e0e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e11:	88 10                	mov    %dl,(%rax)
}
  800e13:	c9                   	leaveq 
  800e14:	c3                   	retq   

0000000000800e15 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e15:	55                   	push   %rbp
  800e16:	48 89 e5             	mov    %rsp,%rbp
  800e19:	48 83 ec 50          	sub    $0x50,%rsp
  800e1d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e21:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e24:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e28:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e2c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e30:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e34:	48 8b 0a             	mov    (%rdx),%rcx
  800e37:	48 89 08             	mov    %rcx,(%rax)
  800e3a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e3e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e42:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e46:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e4a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e4e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800e52:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800e55:	48 98                	cltq   
  800e57:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800e5b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e5f:	48 01 d0             	add    %rdx,%rax
  800e62:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800e66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800e6d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800e72:	74 06                	je     800e7a <vsnprintf+0x65>
  800e74:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800e78:	7f 07                	jg     800e81 <vsnprintf+0x6c>
		return -E_INVAL;
  800e7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e7f:	eb 2f                	jmp    800eb0 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800e81:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800e85:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800e89:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800e8d:	48 89 c6             	mov    %rax,%rsi
  800e90:	48 bf c8 0d 80 00 00 	movabs $0x800dc8,%rdi
  800e97:	00 00 00 
  800e9a:	48 b8 fd 07 80 00 00 	movabs $0x8007fd,%rax
  800ea1:	00 00 00 
  800ea4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ea6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800eaa:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ead:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800eb0:	c9                   	leaveq 
  800eb1:	c3                   	retq   

0000000000800eb2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb2:	55                   	push   %rbp
  800eb3:	48 89 e5             	mov    %rsp,%rbp
  800eb6:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800ebd:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800ec4:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800eca:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800ed1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800ed8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800edf:	84 c0                	test   %al,%al
  800ee1:	74 20                	je     800f03 <snprintf+0x51>
  800ee3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800ee7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800eeb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800eef:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ef3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ef7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800efb:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800eff:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f03:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f0a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f11:	00 00 00 
  800f14:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f1b:	00 00 00 
  800f1e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f22:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f29:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f30:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f37:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f3e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f45:	48 8b 0a             	mov    (%rdx),%rcx
  800f48:	48 89 08             	mov    %rcx,(%rax)
  800f4b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f4f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f53:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f57:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800f5b:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800f62:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800f69:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800f6f:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800f76:	48 89 c7             	mov    %rax,%rdi
  800f79:	48 b8 15 0e 80 00 00 	movabs $0x800e15,%rax
  800f80:	00 00 00 
  800f83:	ff d0                	callq  *%rax
  800f85:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800f8b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f91:	c9                   	leaveq 
  800f92:	c3                   	retq   

0000000000800f93 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f93:	55                   	push   %rbp
  800f94:	48 89 e5             	mov    %rsp,%rbp
  800f97:	48 83 ec 18          	sub    $0x18,%rsp
  800f9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800f9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fa6:	eb 09                	jmp    800fb1 <strlen+0x1e>
		n++;
  800fa8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fac:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb5:	0f b6 00             	movzbl (%rax),%eax
  800fb8:	84 c0                	test   %al,%al
  800fba:	75 ec                	jne    800fa8 <strlen+0x15>
		n++;
	return n;
  800fbc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800fbf:	c9                   	leaveq 
  800fc0:	c3                   	retq   

0000000000800fc1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fc1:	55                   	push   %rbp
  800fc2:	48 89 e5             	mov    %rsp,%rbp
  800fc5:	48 83 ec 20          	sub    $0x20,%rsp
  800fc9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fcd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800fd8:	eb 0e                	jmp    800fe8 <strnlen+0x27>
		n++;
  800fda:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fde:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800fe3:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800fe8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800fed:	74 0b                	je     800ffa <strnlen+0x39>
  800fef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff3:	0f b6 00             	movzbl (%rax),%eax
  800ff6:	84 c0                	test   %al,%al
  800ff8:	75 e0                	jne    800fda <strnlen+0x19>
		n++;
	return n;
  800ffa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ffd:	c9                   	leaveq 
  800ffe:	c3                   	retq   

0000000000800fff <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fff:	55                   	push   %rbp
  801000:	48 89 e5             	mov    %rsp,%rbp
  801003:	48 83 ec 20          	sub    $0x20,%rsp
  801007:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80100b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80100f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801013:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801017:	90                   	nop
  801018:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801020:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801024:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801028:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80102c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801030:	0f b6 12             	movzbl (%rdx),%edx
  801033:	88 10                	mov    %dl,(%rax)
  801035:	0f b6 00             	movzbl (%rax),%eax
  801038:	84 c0                	test   %al,%al
  80103a:	75 dc                	jne    801018 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80103c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801040:	c9                   	leaveq 
  801041:	c3                   	retq   

0000000000801042 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801042:	55                   	push   %rbp
  801043:	48 89 e5             	mov    %rsp,%rbp
  801046:	48 83 ec 20          	sub    $0x20,%rsp
  80104a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80104e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801056:	48 89 c7             	mov    %rax,%rdi
  801059:	48 b8 93 0f 80 00 00 	movabs $0x800f93,%rax
  801060:	00 00 00 
  801063:	ff d0                	callq  *%rax
  801065:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80106b:	48 63 d0             	movslq %eax,%rdx
  80106e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801072:	48 01 c2             	add    %rax,%rdx
  801075:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801079:	48 89 c6             	mov    %rax,%rsi
  80107c:	48 89 d7             	mov    %rdx,%rdi
  80107f:	48 b8 ff 0f 80 00 00 	movabs $0x800fff,%rax
  801086:	00 00 00 
  801089:	ff d0                	callq  *%rax
	return dst;
  80108b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80108f:	c9                   	leaveq 
  801090:	c3                   	retq   

0000000000801091 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801091:	55                   	push   %rbp
  801092:	48 89 e5             	mov    %rsp,%rbp
  801095:	48 83 ec 28          	sub    $0x28,%rsp
  801099:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80109d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010ad:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8010b4:	00 
  8010b5:	eb 2a                	jmp    8010e1 <strncpy+0x50>
		*dst++ = *src;
  8010b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8010bf:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8010c3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8010c7:	0f b6 12             	movzbl (%rdx),%edx
  8010ca:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010d0:	0f b6 00             	movzbl (%rax),%eax
  8010d3:	84 c0                	test   %al,%al
  8010d5:	74 05                	je     8010dc <strncpy+0x4b>
			src++;
  8010d7:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010dc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010e5:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8010e9:	72 cc                	jb     8010b7 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8010ef:	c9                   	leaveq 
  8010f0:	c3                   	retq   

00000000008010f1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8010f1:	55                   	push   %rbp
  8010f2:	48 89 e5             	mov    %rsp,%rbp
  8010f5:	48 83 ec 28          	sub    $0x28,%rsp
  8010f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801101:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801105:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801109:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80110d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801112:	74 3d                	je     801151 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801114:	eb 1d                	jmp    801133 <strlcpy+0x42>
			*dst++ = *src++;
  801116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80111a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80111e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801122:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801126:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80112a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80112e:	0f b6 12             	movzbl (%rdx),%edx
  801131:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801133:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801138:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80113d:	74 0b                	je     80114a <strlcpy+0x59>
  80113f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801143:	0f b6 00             	movzbl (%rax),%eax
  801146:	84 c0                	test   %al,%al
  801148:	75 cc                	jne    801116 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80114a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801151:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801155:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801159:	48 29 c2             	sub    %rax,%rdx
  80115c:	48 89 d0             	mov    %rdx,%rax
}
  80115f:	c9                   	leaveq 
  801160:	c3                   	retq   

0000000000801161 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801161:	55                   	push   %rbp
  801162:	48 89 e5             	mov    %rsp,%rbp
  801165:	48 83 ec 10          	sub    $0x10,%rsp
  801169:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80116d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801171:	eb 0a                	jmp    80117d <strcmp+0x1c>
		p++, q++;
  801173:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801178:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80117d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801181:	0f b6 00             	movzbl (%rax),%eax
  801184:	84 c0                	test   %al,%al
  801186:	74 12                	je     80119a <strcmp+0x39>
  801188:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80118c:	0f b6 10             	movzbl (%rax),%edx
  80118f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801193:	0f b6 00             	movzbl (%rax),%eax
  801196:	38 c2                	cmp    %al,%dl
  801198:	74 d9                	je     801173 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80119a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119e:	0f b6 00             	movzbl (%rax),%eax
  8011a1:	0f b6 d0             	movzbl %al,%edx
  8011a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011a8:	0f b6 00             	movzbl (%rax),%eax
  8011ab:	0f b6 c0             	movzbl %al,%eax
  8011ae:	29 c2                	sub    %eax,%edx
  8011b0:	89 d0                	mov    %edx,%eax
}
  8011b2:	c9                   	leaveq 
  8011b3:	c3                   	retq   

00000000008011b4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011b4:	55                   	push   %rbp
  8011b5:	48 89 e5             	mov    %rsp,%rbp
  8011b8:	48 83 ec 18          	sub    $0x18,%rsp
  8011bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011c0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8011c4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8011c8:	eb 0f                	jmp    8011d9 <strncmp+0x25>
		n--, p++, q++;
  8011ca:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8011cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011d4:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8011d9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011de:	74 1d                	je     8011fd <strncmp+0x49>
  8011e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e4:	0f b6 00             	movzbl (%rax),%eax
  8011e7:	84 c0                	test   %al,%al
  8011e9:	74 12                	je     8011fd <strncmp+0x49>
  8011eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ef:	0f b6 10             	movzbl (%rax),%edx
  8011f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f6:	0f b6 00             	movzbl (%rax),%eax
  8011f9:	38 c2                	cmp    %al,%dl
  8011fb:	74 cd                	je     8011ca <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8011fd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801202:	75 07                	jne    80120b <strncmp+0x57>
		return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 18                	jmp    801223 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80120f:	0f b6 00             	movzbl (%rax),%eax
  801212:	0f b6 d0             	movzbl %al,%edx
  801215:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801219:	0f b6 00             	movzbl (%rax),%eax
  80121c:	0f b6 c0             	movzbl %al,%eax
  80121f:	29 c2                	sub    %eax,%edx
  801221:	89 d0                	mov    %edx,%eax
}
  801223:	c9                   	leaveq 
  801224:	c3                   	retq   

0000000000801225 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801225:	55                   	push   %rbp
  801226:	48 89 e5             	mov    %rsp,%rbp
  801229:	48 83 ec 0c          	sub    $0xc,%rsp
  80122d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801231:	89 f0                	mov    %esi,%eax
  801233:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801236:	eb 17                	jmp    80124f <strchr+0x2a>
		if (*s == c)
  801238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80123c:	0f b6 00             	movzbl (%rax),%eax
  80123f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801242:	75 06                	jne    80124a <strchr+0x25>
			return (char *) s;
  801244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801248:	eb 15                	jmp    80125f <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80124a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80124f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801253:	0f b6 00             	movzbl (%rax),%eax
  801256:	84 c0                	test   %al,%al
  801258:	75 de                	jne    801238 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80125a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80125f:	c9                   	leaveq 
  801260:	c3                   	retq   

0000000000801261 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801261:	55                   	push   %rbp
  801262:	48 89 e5             	mov    %rsp,%rbp
  801265:	48 83 ec 0c          	sub    $0xc,%rsp
  801269:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80126d:	89 f0                	mov    %esi,%eax
  80126f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801272:	eb 13                	jmp    801287 <strfind+0x26>
		if (*s == c)
  801274:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801278:	0f b6 00             	movzbl (%rax),%eax
  80127b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80127e:	75 02                	jne    801282 <strfind+0x21>
			break;
  801280:	eb 10                	jmp    801292 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801282:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128b:	0f b6 00             	movzbl (%rax),%eax
  80128e:	84 c0                	test   %al,%al
  801290:	75 e2                	jne    801274 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801292:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801296:	c9                   	leaveq 
  801297:	c3                   	retq   

0000000000801298 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801298:	55                   	push   %rbp
  801299:	48 89 e5             	mov    %rsp,%rbp
  80129c:	48 83 ec 18          	sub    $0x18,%rsp
  8012a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012a4:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012a7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012ab:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012b0:	75 06                	jne    8012b8 <memset+0x20>
		return v;
  8012b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012b6:	eb 69                	jmp    801321 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8012b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012bc:	83 e0 03             	and    $0x3,%eax
  8012bf:	48 85 c0             	test   %rax,%rax
  8012c2:	75 48                	jne    80130c <memset+0x74>
  8012c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c8:	83 e0 03             	and    $0x3,%eax
  8012cb:	48 85 c0             	test   %rax,%rax
  8012ce:	75 3c                	jne    80130c <memset+0x74>
		c &= 0xFF;
  8012d0:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8012d7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012da:	c1 e0 18             	shl    $0x18,%eax
  8012dd:	89 c2                	mov    %eax,%edx
  8012df:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012e2:	c1 e0 10             	shl    $0x10,%eax
  8012e5:	09 c2                	or     %eax,%edx
  8012e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8012ea:	c1 e0 08             	shl    $0x8,%eax
  8012ed:	09 d0                	or     %edx,%eax
  8012ef:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8012f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012f6:	48 c1 e8 02          	shr    $0x2,%rax
  8012fa:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801301:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801304:	48 89 d7             	mov    %rdx,%rdi
  801307:	fc                   	cld    
  801308:	f3 ab                	rep stos %eax,%es:(%rdi)
  80130a:	eb 11                	jmp    80131d <memset+0x85>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80130c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801310:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801313:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801317:	48 89 d7             	mov    %rdx,%rdi
  80131a:	fc                   	cld    
  80131b:	f3 aa                	rep stos %al,%es:(%rdi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80131d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801321:	c9                   	leaveq 
  801322:	c3                   	retq   

0000000000801323 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801323:	55                   	push   %rbp
  801324:	48 89 e5             	mov    %rsp,%rbp
  801327:	48 83 ec 28          	sub    $0x28,%rsp
  80132b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80132f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801333:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801337:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80133b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80133f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801343:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80134b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80134f:	0f 83 88 00 00 00    	jae    8013dd <memmove+0xba>
  801355:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801359:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80135d:	48 01 d0             	add    %rdx,%rax
  801360:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801364:	76 77                	jbe    8013dd <memmove+0xba>
		s += n;
  801366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80136a:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80136e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801372:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801376:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137a:	83 e0 03             	and    $0x3,%eax
  80137d:	48 85 c0             	test   %rax,%rax
  801380:	75 3b                	jne    8013bd <memmove+0x9a>
  801382:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801386:	83 e0 03             	and    $0x3,%eax
  801389:	48 85 c0             	test   %rax,%rax
  80138c:	75 2f                	jne    8013bd <memmove+0x9a>
  80138e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801392:	83 e0 03             	and    $0x3,%eax
  801395:	48 85 c0             	test   %rax,%rax
  801398:	75 23                	jne    8013bd <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80139a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80139e:	48 83 e8 04          	sub    $0x4,%rax
  8013a2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013a6:	48 83 ea 04          	sub    $0x4,%rdx
  8013aa:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8013ae:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8013b2:	48 89 c7             	mov    %rax,%rdi
  8013b5:	48 89 d6             	mov    %rdx,%rsi
  8013b8:	fd                   	std    
  8013b9:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8013bb:	eb 1d                	jmp    8013da <memmove+0xb7>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8013bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c9:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8013cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013d1:	48 89 d7             	mov    %rdx,%rdi
  8013d4:	48 89 c1             	mov    %rax,%rcx
  8013d7:	fd                   	std    
  8013d8:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8013da:	fc                   	cld    
  8013db:	eb 57                	jmp    801434 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e1:	83 e0 03             	and    $0x3,%eax
  8013e4:	48 85 c0             	test   %rax,%rax
  8013e7:	75 36                	jne    80141f <memmove+0xfc>
  8013e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013ed:	83 e0 03             	and    $0x3,%eax
  8013f0:	48 85 c0             	test   %rax,%rax
  8013f3:	75 2a                	jne    80141f <memmove+0xfc>
  8013f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f9:	83 e0 03             	and    $0x3,%eax
  8013fc:	48 85 c0             	test   %rax,%rax
  8013ff:	75 1e                	jne    80141f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801401:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801405:	48 c1 e8 02          	shr    $0x2,%rax
  801409:	48 89 c1             	mov    %rax,%rcx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80140c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801410:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801414:	48 89 c7             	mov    %rax,%rdi
  801417:	48 89 d6             	mov    %rdx,%rsi
  80141a:	fc                   	cld    
  80141b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80141d:	eb 15                	jmp    801434 <memmove+0x111>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80141f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801423:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801427:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80142b:	48 89 c7             	mov    %rax,%rdi
  80142e:	48 89 d6             	mov    %rdx,%rsi
  801431:	fc                   	cld    
  801432:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801438:	c9                   	leaveq 
  801439:	c3                   	retq   

000000000080143a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80143a:	55                   	push   %rbp
  80143b:	48 89 e5             	mov    %rsp,%rbp
  80143e:	48 83 ec 18          	sub    $0x18,%rsp
  801442:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801446:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80144a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80144e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801452:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145a:	48 89 ce             	mov    %rcx,%rsi
  80145d:	48 89 c7             	mov    %rax,%rdi
  801460:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  801467:	00 00 00 
  80146a:	ff d0                	callq  *%rax
}
  80146c:	c9                   	leaveq 
  80146d:	c3                   	retq   

000000000080146e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80146e:	55                   	push   %rbp
  80146f:	48 89 e5             	mov    %rsp,%rbp
  801472:	48 83 ec 28          	sub    $0x28,%rsp
  801476:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80147a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80147e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801482:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801486:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80148a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80148e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801492:	eb 36                	jmp    8014ca <memcmp+0x5c>
		if (*s1 != *s2)
  801494:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801498:	0f b6 10             	movzbl (%rax),%edx
  80149b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80149f:	0f b6 00             	movzbl (%rax),%eax
  8014a2:	38 c2                	cmp    %al,%dl
  8014a4:	74 1a                	je     8014c0 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014aa:	0f b6 00             	movzbl (%rax),%eax
  8014ad:	0f b6 d0             	movzbl %al,%edx
  8014b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014b4:	0f b6 00             	movzbl (%rax),%eax
  8014b7:	0f b6 c0             	movzbl %al,%eax
  8014ba:	29 c2                	sub    %eax,%edx
  8014bc:	89 d0                	mov    %edx,%eax
  8014be:	eb 20                	jmp    8014e0 <memcmp+0x72>
		s1++, s2++;
  8014c0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014c5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ce:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014d2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8014d6:	48 85 c0             	test   %rax,%rax
  8014d9:	75 b9                	jne    801494 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e0:	c9                   	leaveq 
  8014e1:	c3                   	retq   

00000000008014e2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014e2:	55                   	push   %rbp
  8014e3:	48 89 e5             	mov    %rsp,%rbp
  8014e6:	48 83 ec 28          	sub    $0x28,%rsp
  8014ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014ee:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8014f1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8014f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014fd:	48 01 d0             	add    %rdx,%rax
  801500:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801504:	eb 15                	jmp    80151b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801506:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150a:	0f b6 10             	movzbl (%rax),%edx
  80150d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801510:	38 c2                	cmp    %al,%dl
  801512:	75 02                	jne    801516 <memfind+0x34>
			break;
  801514:	eb 0f                	jmp    801525 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801516:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80151b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801523:	72 e1                	jb     801506 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801529:	c9                   	leaveq 
  80152a:	c3                   	retq   

000000000080152b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80152b:	55                   	push   %rbp
  80152c:	48 89 e5             	mov    %rsp,%rbp
  80152f:	48 83 ec 34          	sub    $0x34,%rsp
  801533:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801537:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80153b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80153e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801545:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80154c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80154d:	eb 05                	jmp    801554 <strtol+0x29>
		s++;
  80154f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801558:	0f b6 00             	movzbl (%rax),%eax
  80155b:	3c 20                	cmp    $0x20,%al
  80155d:	74 f0                	je     80154f <strtol+0x24>
  80155f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801563:	0f b6 00             	movzbl (%rax),%eax
  801566:	3c 09                	cmp    $0x9,%al
  801568:	74 e5                	je     80154f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80156a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156e:	0f b6 00             	movzbl (%rax),%eax
  801571:	3c 2b                	cmp    $0x2b,%al
  801573:	75 07                	jne    80157c <strtol+0x51>
		s++;
  801575:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80157a:	eb 17                	jmp    801593 <strtol+0x68>
	else if (*s == '-')
  80157c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801580:	0f b6 00             	movzbl (%rax),%eax
  801583:	3c 2d                	cmp    $0x2d,%al
  801585:	75 0c                	jne    801593 <strtol+0x68>
		s++, neg = 1;
  801587:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80158c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801593:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801597:	74 06                	je     80159f <strtol+0x74>
  801599:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80159d:	75 28                	jne    8015c7 <strtol+0x9c>
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	0f b6 00             	movzbl (%rax),%eax
  8015a6:	3c 30                	cmp    $0x30,%al
  8015a8:	75 1d                	jne    8015c7 <strtol+0x9c>
  8015aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015ae:	48 83 c0 01          	add    $0x1,%rax
  8015b2:	0f b6 00             	movzbl (%rax),%eax
  8015b5:	3c 78                	cmp    $0x78,%al
  8015b7:	75 0e                	jne    8015c7 <strtol+0x9c>
		s += 2, base = 16;
  8015b9:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8015be:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8015c5:	eb 2c                	jmp    8015f3 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8015c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015cb:	75 19                	jne    8015e6 <strtol+0xbb>
  8015cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d1:	0f b6 00             	movzbl (%rax),%eax
  8015d4:	3c 30                	cmp    $0x30,%al
  8015d6:	75 0e                	jne    8015e6 <strtol+0xbb>
		s++, base = 8;
  8015d8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015dd:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8015e4:	eb 0d                	jmp    8015f3 <strtol+0xc8>
	else if (base == 0)
  8015e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015ea:	75 07                	jne    8015f3 <strtol+0xc8>
		base = 10;
  8015ec:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8015f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f7:	0f b6 00             	movzbl (%rax),%eax
  8015fa:	3c 2f                	cmp    $0x2f,%al
  8015fc:	7e 1d                	jle    80161b <strtol+0xf0>
  8015fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801602:	0f b6 00             	movzbl (%rax),%eax
  801605:	3c 39                	cmp    $0x39,%al
  801607:	7f 12                	jg     80161b <strtol+0xf0>
			dig = *s - '0';
  801609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160d:	0f b6 00             	movzbl (%rax),%eax
  801610:	0f be c0             	movsbl %al,%eax
  801613:	83 e8 30             	sub    $0x30,%eax
  801616:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801619:	eb 4e                	jmp    801669 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80161b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161f:	0f b6 00             	movzbl (%rax),%eax
  801622:	3c 60                	cmp    $0x60,%al
  801624:	7e 1d                	jle    801643 <strtol+0x118>
  801626:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80162a:	0f b6 00             	movzbl (%rax),%eax
  80162d:	3c 7a                	cmp    $0x7a,%al
  80162f:	7f 12                	jg     801643 <strtol+0x118>
			dig = *s - 'a' + 10;
  801631:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801635:	0f b6 00             	movzbl (%rax),%eax
  801638:	0f be c0             	movsbl %al,%eax
  80163b:	83 e8 57             	sub    $0x57,%eax
  80163e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801641:	eb 26                	jmp    801669 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801643:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801647:	0f b6 00             	movzbl (%rax),%eax
  80164a:	3c 40                	cmp    $0x40,%al
  80164c:	7e 48                	jle    801696 <strtol+0x16b>
  80164e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801652:	0f b6 00             	movzbl (%rax),%eax
  801655:	3c 5a                	cmp    $0x5a,%al
  801657:	7f 3d                	jg     801696 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801659:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165d:	0f b6 00             	movzbl (%rax),%eax
  801660:	0f be c0             	movsbl %al,%eax
  801663:	83 e8 37             	sub    $0x37,%eax
  801666:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801669:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80166c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80166f:	7c 02                	jl     801673 <strtol+0x148>
			break;
  801671:	eb 23                	jmp    801696 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801673:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801678:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80167b:	48 98                	cltq   
  80167d:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801682:	48 89 c2             	mov    %rax,%rdx
  801685:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801688:	48 98                	cltq   
  80168a:	48 01 d0             	add    %rdx,%rax
  80168d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801691:	e9 5d ff ff ff       	jmpq   8015f3 <strtol+0xc8>

	if (endptr)
  801696:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80169b:	74 0b                	je     8016a8 <strtol+0x17d>
		*endptr = (char *) s;
  80169d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016a1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016a5:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016ac:	74 09                	je     8016b7 <strtol+0x18c>
  8016ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b2:	48 f7 d8             	neg    %rax
  8016b5:	eb 04                	jmp    8016bb <strtol+0x190>
  8016b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8016bb:	c9                   	leaveq 
  8016bc:	c3                   	retq   

00000000008016bd <strstr>:

char * strstr(const char *in, const char *str)
{
  8016bd:	55                   	push   %rbp
  8016be:	48 89 e5             	mov    %rsp,%rbp
  8016c1:	48 83 ec 30          	sub    $0x30,%rsp
  8016c5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8016c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    char c;
    size_t len;

    c = *str++;
  8016cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016d1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8016d5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8016d9:	0f b6 00             	movzbl (%rax),%eax
  8016dc:	88 45 ff             	mov    %al,-0x1(%rbp)
    if (!c)
  8016df:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8016e3:	75 06                	jne    8016eb <strstr+0x2e>
        return (char *) in;	// Trivial empty string case
  8016e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e9:	eb 6b                	jmp    801756 <strstr+0x99>

    len = strlen(str);
  8016eb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016ef:	48 89 c7             	mov    %rax,%rdi
  8016f2:	48 b8 93 0f 80 00 00 	movabs $0x800f93,%rax
  8016f9:	00 00 00 
  8016fc:	ff d0                	callq  *%rax
  8016fe:	48 98                	cltq   
  801700:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    do {
        char sc;

        do {
            sc = *in++;
  801704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801708:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80170c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801710:	0f b6 00             	movzbl (%rax),%eax
  801713:	88 45 ef             	mov    %al,-0x11(%rbp)
            if (!sc)
  801716:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80171a:	75 07                	jne    801723 <strstr+0x66>
                return (char *) 0;
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
  801721:	eb 33                	jmp    801756 <strstr+0x99>
        } while (sc != c);
  801723:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801727:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80172a:	75 d8                	jne    801704 <strstr+0x47>
    } while (strncmp(in, str, len) != 0);
  80172c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801730:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801738:	48 89 ce             	mov    %rcx,%rsi
  80173b:	48 89 c7             	mov    %rax,%rdi
  80173e:	48 b8 b4 11 80 00 00 	movabs $0x8011b4,%rax
  801745:	00 00 00 
  801748:	ff d0                	callq  *%rax
  80174a:	85 c0                	test   %eax,%eax
  80174c:	75 b6                	jne    801704 <strstr+0x47>

    return (char *) (in - 1);
  80174e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801752:	48 83 e8 01          	sub    $0x1,%rax
}
  801756:	c9                   	leaveq 
  801757:	c3                   	retq   

0000000000801758 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801758:	55                   	push   %rbp
  801759:	48 89 e5             	mov    %rsp,%rbp
  80175c:	53                   	push   %rbx
  80175d:	48 83 ec 48          	sub    $0x48,%rsp
  801761:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801764:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801767:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80176b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80176f:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801773:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801777:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80177a:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80177e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801782:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801786:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80178a:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80178e:	4c 89 c3             	mov    %r8,%rbx
  801791:	cd 30                	int    $0x30
  801793:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801797:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80179b:	74 3e                	je     8017db <syscall+0x83>
  80179d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017a2:	7e 37                	jle    8017db <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017a4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017a8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017ab:	49 89 d0             	mov    %rdx,%r8
  8017ae:	89 c1                	mov    %eax,%ecx
  8017b0:	48 ba 68 21 80 00 00 	movabs $0x802168,%rdx
  8017b7:	00 00 00 
  8017ba:	be 23 00 00 00       	mov    $0x23,%esi
  8017bf:	48 bf 85 21 80 00 00 	movabs $0x802185,%rdi
  8017c6:	00 00 00 
  8017c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ce:	49 b9 11 02 80 00 00 	movabs $0x800211,%r9
  8017d5:	00 00 00 
  8017d8:	41 ff d1             	callq  *%r9

	return ret;
  8017db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017df:	48 83 c4 48          	add    $0x48,%rsp
  8017e3:	5b                   	pop    %rbx
  8017e4:	5d                   	pop    %rbp
  8017e5:	c3                   	retq   

00000000008017e6 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8017e6:	55                   	push   %rbp
  8017e7:	48 89 e5             	mov    %rsp,%rbp
  8017ea:	48 83 ec 20          	sub    $0x20,%rsp
  8017ee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017f2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8017f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017fe:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801805:	00 
  801806:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80180c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801812:	48 89 d1             	mov    %rdx,%rcx
  801815:	48 89 c2             	mov    %rax,%rdx
  801818:	be 00 00 00 00       	mov    $0x0,%esi
  80181d:	bf 00 00 00 00       	mov    $0x0,%edi
  801822:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801829:	00 00 00 
  80182c:	ff d0                	callq  *%rax
}
  80182e:	c9                   	leaveq 
  80182f:	c3                   	retq   

0000000000801830 <sys_cgetc>:

int
sys_cgetc(void)
{
  801830:	55                   	push   %rbp
  801831:	48 89 e5             	mov    %rsp,%rbp
  801834:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801838:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80183f:	00 
  801840:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801846:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80184c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
  801856:	be 00 00 00 00       	mov    $0x0,%esi
  80185b:	bf 01 00 00 00       	mov    $0x1,%edi
  801860:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801867:	00 00 00 
  80186a:	ff d0                	callq  *%rax
}
  80186c:	c9                   	leaveq 
  80186d:	c3                   	retq   

000000000080186e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80186e:	55                   	push   %rbp
  80186f:	48 89 e5             	mov    %rsp,%rbp
  801872:	48 83 ec 10          	sub    $0x10,%rsp
  801876:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801879:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80187c:	48 98                	cltq   
  80187e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801885:	00 
  801886:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80188c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801892:	b9 00 00 00 00       	mov    $0x0,%ecx
  801897:	48 89 c2             	mov    %rax,%rdx
  80189a:	be 01 00 00 00       	mov    $0x1,%esi
  80189f:	bf 03 00 00 00       	mov    $0x3,%edi
  8018a4:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  8018ab:	00 00 00 
  8018ae:	ff d0                	callq  *%rax
}
  8018b0:	c9                   	leaveq 
  8018b1:	c3                   	retq   

00000000008018b2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8018b2:	55                   	push   %rbp
  8018b3:	48 89 e5             	mov    %rsp,%rbp
  8018b6:	48 83 ec 10          	sub    $0x10,%rsp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8018ba:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018c1:	00 
  8018c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	be 00 00 00 00       	mov    $0x0,%esi
  8018dd:	bf 02 00 00 00       	mov    $0x2,%edi
  8018e2:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  8018e9:	00 00 00 
  8018ec:	ff d0                	callq  *%rax
}
  8018ee:	c9                   	leaveq 
  8018ef:	c3                   	retq   

00000000008018f0 <sys_yield>:

void
sys_yield(void)
{
  8018f0:	55                   	push   %rbp
  8018f1:	48 89 e5             	mov    %rsp,%rbp
  8018f4:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8018f8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018ff:	00 
  801900:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801906:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80190c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801911:	ba 00 00 00 00       	mov    $0x0,%edx
  801916:	be 00 00 00 00       	mov    $0x0,%esi
  80191b:	bf 0a 00 00 00       	mov    $0xa,%edi
  801920:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801927:	00 00 00 
  80192a:	ff d0                	callq  *%rax
}
  80192c:	c9                   	leaveq 
  80192d:	c3                   	retq   

000000000080192e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80192e:	55                   	push   %rbp
  80192f:	48 89 e5             	mov    %rsp,%rbp
  801932:	48 83 ec 20          	sub    $0x20,%rsp
  801936:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801939:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80193d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801940:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801943:	48 63 c8             	movslq %eax,%rcx
  801946:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80194a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80194d:	48 98                	cltq   
  80194f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801956:	00 
  801957:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80195d:	49 89 c8             	mov    %rcx,%r8
  801960:	48 89 d1             	mov    %rdx,%rcx
  801963:	48 89 c2             	mov    %rax,%rdx
  801966:	be 01 00 00 00       	mov    $0x1,%esi
  80196b:	bf 04 00 00 00       	mov    $0x4,%edi
  801970:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801977:	00 00 00 
  80197a:	ff d0                	callq  *%rax
}
  80197c:	c9                   	leaveq 
  80197d:	c3                   	retq   

000000000080197e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80197e:	55                   	push   %rbp
  80197f:	48 89 e5             	mov    %rsp,%rbp
  801982:	48 83 ec 30          	sub    $0x30,%rsp
  801986:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801989:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80198d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801990:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801994:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801998:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80199b:	48 63 c8             	movslq %eax,%rcx
  80199e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8019a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8019a5:	48 63 f0             	movslq %eax,%rsi
  8019a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019af:	48 98                	cltq   
  8019b1:	48 89 0c 24          	mov    %rcx,(%rsp)
  8019b5:	49 89 f9             	mov    %rdi,%r9
  8019b8:	49 89 f0             	mov    %rsi,%r8
  8019bb:	48 89 d1             	mov    %rdx,%rcx
  8019be:	48 89 c2             	mov    %rax,%rdx
  8019c1:	be 01 00 00 00       	mov    $0x1,%esi
  8019c6:	bf 05 00 00 00       	mov    $0x5,%edi
  8019cb:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  8019d2:	00 00 00 
  8019d5:	ff d0                	callq  *%rax
}
  8019d7:	c9                   	leaveq 
  8019d8:	c3                   	retq   

00000000008019d9 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019d9:	55                   	push   %rbp
  8019da:	48 89 e5             	mov    %rsp,%rbp
  8019dd:	48 83 ec 20          	sub    $0x20,%rsp
  8019e1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8019e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ef:	48 98                	cltq   
  8019f1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019f8:	00 
  8019f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a05:	48 89 d1             	mov    %rdx,%rcx
  801a08:	48 89 c2             	mov    %rax,%rdx
  801a0b:	be 01 00 00 00       	mov    $0x1,%esi
  801a10:	bf 06 00 00 00       	mov    $0x6,%edi
  801a15:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801a1c:	00 00 00 
  801a1f:	ff d0                	callq  *%rax
}
  801a21:	c9                   	leaveq 
  801a22:	c3                   	retq   

0000000000801a23 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a23:	55                   	push   %rbp
  801a24:	48 89 e5             	mov    %rsp,%rbp
  801a27:	48 83 ec 10          	sub    $0x10,%rsp
  801a2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a2e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801a31:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a34:	48 63 d0             	movslq %eax,%rdx
  801a37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a3a:	48 98                	cltq   
  801a3c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a43:	00 
  801a44:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a4a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a50:	48 89 d1             	mov    %rdx,%rcx
  801a53:	48 89 c2             	mov    %rax,%rdx
  801a56:	be 01 00 00 00       	mov    $0x1,%esi
  801a5b:	bf 08 00 00 00       	mov    $0x8,%edi
  801a60:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801a67:	00 00 00 
  801a6a:	ff d0                	callq  *%rax
}
  801a6c:	c9                   	leaveq 
  801a6d:	c3                   	retq   

0000000000801a6e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a6e:	55                   	push   %rbp
  801a6f:	48 89 e5             	mov    %rsp,%rbp
  801a72:	48 83 ec 20          	sub    $0x20,%rsp
  801a76:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a79:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801a7d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a84:	48 98                	cltq   
  801a86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a8d:	00 
  801a8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a9a:	48 89 d1             	mov    %rdx,%rcx
  801a9d:	48 89 c2             	mov    %rax,%rdx
  801aa0:	be 01 00 00 00       	mov    $0x1,%esi
  801aa5:	bf 09 00 00 00       	mov    $0x9,%edi
  801aaa:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801ab1:	00 00 00 
  801ab4:	ff d0                	callq  *%rax
}
  801ab6:	c9                   	leaveq 
  801ab7:	c3                   	retq   

0000000000801ab8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ab8:	55                   	push   %rbp
  801ab9:	48 89 e5             	mov    %rsp,%rbp
  801abc:	48 83 ec 20          	sub    $0x20,%rsp
  801ac0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ac3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ac7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801acb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ace:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ad1:	48 63 f0             	movslq %eax,%rsi
  801ad4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801adb:	48 98                	cltq   
  801add:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ae1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae8:	00 
  801ae9:	49 89 f1             	mov    %rsi,%r9
  801aec:	49 89 c8             	mov    %rcx,%r8
  801aef:	48 89 d1             	mov    %rdx,%rcx
  801af2:	48 89 c2             	mov    %rax,%rdx
  801af5:	be 00 00 00 00       	mov    $0x0,%esi
  801afa:	bf 0b 00 00 00       	mov    $0xb,%edi
  801aff:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801b06:	00 00 00 
  801b09:	ff d0                	callq  *%rax
}
  801b0b:	c9                   	leaveq 
  801b0c:	c3                   	retq   

0000000000801b0d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b0d:	55                   	push   %rbp
  801b0e:	48 89 e5             	mov    %rsp,%rbp
  801b11:	48 83 ec 10          	sub    $0x10,%rsp
  801b15:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801b19:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b24:	00 
  801b25:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b2b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b31:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b36:	48 89 c2             	mov    %rax,%rdx
  801b39:	be 01 00 00 00       	mov    $0x1,%esi
  801b3e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801b43:	48 b8 58 17 80 00 00 	movabs $0x801758,%rax
  801b4a:	00 00 00 
  801b4d:	ff d0                	callq  *%rax
}
  801b4f:	c9                   	leaveq 
  801b50:	c3                   	retq   

0000000000801b51 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801b51:	55                   	push   %rbp
  801b52:	48 89 e5             	mov    %rsp,%rbp
  801b55:	48 83 ec 10          	sub    $0x10,%rsp
  801b59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;
	
	if (_pgfault_handler == 0) {
  801b5d:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801b64:	00 00 00 
  801b67:	48 8b 00             	mov    (%rax),%rax
  801b6a:	48 85 c0             	test   %rax,%rax
  801b6d:	0f 85 b2 00 00 00    	jne    801c25 <set_pgfault_handler+0xd4>
		// First time through!
		// LAB 4: Your code here.
		
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP-PGSIZE), PTE_P|PTE_U|PTE_W) != 0)
  801b73:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801b7a:	00 00 00 
  801b7d:	48 8b 00             	mov    (%rax),%rax
  801b80:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801b86:	ba 07 00 00 00       	mov    $0x7,%edx
  801b8b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801b90:	89 c7                	mov    %eax,%edi
  801b92:	48 b8 2e 19 80 00 00 	movabs $0x80192e,%rax
  801b99:	00 00 00 
  801b9c:	ff d0                	callq  *%rax
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	74 2a                	je     801bcc <set_pgfault_handler+0x7b>
		  panic("\nproblem in page allocation lib/pgfault.c\n");
  801ba2:	48 ba 98 21 80 00 00 	movabs $0x802198,%rdx
  801ba9:	00 00 00 
  801bac:	be 22 00 00 00       	mov    $0x22,%esi
  801bb1:	48 bf c3 21 80 00 00 	movabs $0x8021c3,%rdi
  801bb8:	00 00 00 
  801bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc0:	48 b9 11 02 80 00 00 	movabs $0x800211,%rcx
  801bc7:	00 00 00 
  801bca:	ff d1                	callq  *%rcx
		
	         if(sys_env_set_pgfault_upcall(thisenv->env_id, (void *)_pgfault_upcall) != 0)
  801bcc:	48 b8 08 30 80 00 00 	movabs $0x803008,%rax
  801bd3:	00 00 00 
  801bd6:	48 8b 00             	mov    (%rax),%rax
  801bd9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801bdf:	48 be 38 1c 80 00 00 	movabs $0x801c38,%rsi
  801be6:	00 00 00 
  801be9:	89 c7                	mov    %eax,%edi
  801beb:	48 b8 6e 1a 80 00 00 	movabs $0x801a6e,%rax
  801bf2:	00 00 00 
  801bf5:	ff d0                	callq  *%rax
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	74 2a                	je     801c25 <set_pgfault_handler+0xd4>
		   panic("set_pgfault_handler implemented but problems lib/pgfault.c");
  801bfb:	48 ba d8 21 80 00 00 	movabs $0x8021d8,%rdx
  801c02:	00 00 00 
  801c05:	be 25 00 00 00       	mov    $0x25,%esi
  801c0a:	48 bf c3 21 80 00 00 	movabs $0x8021c3,%rdi
  801c11:	00 00 00 
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
  801c19:	48 b9 11 02 80 00 00 	movabs $0x800211,%rcx
  801c20:	00 00 00 
  801c23:	ff d1                	callq  *%rcx
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801c25:	48 b8 10 30 80 00 00 	movabs $0x803010,%rax
  801c2c:	00 00 00 
  801c2f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c33:	48 89 10             	mov    %rdx,(%rax)
}
  801c36:	c9                   	leaveq 
  801c37:	c3                   	retq   

0000000000801c38 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	// function argument: pointer to UTF
	
	movq  %rsp,%rdi                // passing the function argument in rdi
  801c38:	48 89 e7             	mov    %rsp,%rdi
	movabs _pgfault_handler, %rax
  801c3b:	48 a1 10 30 80 00 00 	movabs 0x803010,%rax
  801c42:	00 00 00 
	call *%rax
  801c45:	ff d0                	callq  *%rax
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.                
	movq %rsp, %rdi;	
  801c47:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  801c4a:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  801c51:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  801c52:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  801c59:	00 
	pushq %rbx;
  801c5a:	53                   	push   %rbx
	movq %rsp, %rbx;	
  801c5b:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  801c5e:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  801c61:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  801c68:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  801c69:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  801c6d:	4c 8b 3c 24          	mov    (%rsp),%r15
  801c71:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  801c76:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  801c7b:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  801c80:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  801c85:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  801c8a:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  801c8f:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  801c94:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  801c99:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  801c9e:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  801ca3:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  801ca8:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  801cad:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  801cb2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  801cb7:	48 83 c4 78          	add    $0x78,%rsp

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	add $8, %rsp; //Jump rip field  
  801cbb:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  801cbf:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  801cc0:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  801cc1:	c3                   	retq   
