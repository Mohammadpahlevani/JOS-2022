
obj/user/testpteshare:     file format elf64-x86-64


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
  80003c:	e8 67 02 00 00       	callq  8002a8 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (argc != 0)
  800052:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800056:	74 0c                	je     800064 <umain+0x21>
		childofspawn();
  800058:	48 b8 75 02 80 00 00 	movabs $0x800275,%rax
  80005f:	00 00 00 
  800062:	ff d0                	callq  *%rax

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	ba 07 04 00 00       	mov    $0x407,%edx
  800069:	be 00 00 00 a0       	mov    $0xa0000000,%esi
  80006e:	bf 00 00 00 00       	mov    $0x0,%edi
  800073:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80007a:	00 00 00 
  80007d:	ff d0                	callq  *%rax
  80007f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800082:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800086:	79 30                	jns    8000b8 <umain+0x75>
		panic("sys_page_alloc: %e", r);
  800088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80008b:	89 c1                	mov    %eax,%ecx
  80008d:	48 ba 3e 4a 80 00 00 	movabs $0x804a3e,%rdx
  800094:	00 00 00 
  800097:	be 13 00 00 00       	mov    $0x13,%esi
  80009c:	48 bf 51 4a 80 00 00 	movabs $0x804a51,%rdi
  8000a3:	00 00 00 
  8000a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ab:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  8000b2:	00 00 00 
  8000b5:	41 ff d0             	callq  *%r8

	// check fork
	if ((r = fork()) < 0)
  8000b8:	48 b8 38 1f 80 00 00 	movabs $0x801f38,%rax
  8000bf:	00 00 00 
  8000c2:	ff d0                	callq  *%rax
  8000c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000cb:	79 30                	jns    8000fd <umain+0xba>
		panic("fork: %e", r);
  8000cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 65 4a 80 00 00 	movabs $0x804a65,%rdx
  8000d9:	00 00 00 
  8000dc:	be 17 00 00 00       	mov    $0x17,%esi
  8000e1:	48 bf 51 4a 80 00 00 	movabs $0x804a51,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if (r == 0) {
  8000fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800101:	75 2d                	jne    800130 <umain+0xed>
		strcpy(VA, msg);
  800103:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80010a:	00 00 00 
  80010d:	48 8b 00             	mov    (%rax),%rax
  800110:	48 89 c6             	mov    %rax,%rsi
  800113:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800118:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  80011f:	00 00 00 
  800122:	ff d0                	callq  *%rax
		exit();
  800124:	48 b8 38 03 80 00 00 	movabs $0x800338,%rax
  80012b:	00 00 00 
  80012e:	ff d0                	callq  *%rax
	}
	wait(r);
  800130:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800133:	89 c7                	mov    %eax,%edi
  800135:	48 b8 3c 43 80 00 00 	movabs $0x80433c,%rax
  80013c:	00 00 00 
  80013f:	ff d0                	callq  *%rax
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  800141:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800148:	00 00 00 
  80014b:	48 8b 00             	mov    (%rax),%rax
  80014e:	48 89 c6             	mov    %rax,%rsi
  800151:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  800156:	48 b8 ab 12 80 00 00 	movabs $0x8012ab,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	85 c0                	test   %eax,%eax
  800164:	75 0c                	jne    800172 <umain+0x12f>
  800166:	48 b8 6e 4a 80 00 00 	movabs $0x804a6e,%rax
  80016d:	00 00 00 
  800170:	eb 0a                	jmp    80017c <umain+0x139>
  800172:	48 b8 74 4a 80 00 00 	movabs $0x804a74,%rax
  800179:	00 00 00 
  80017c:	48 89 c6             	mov    %rax,%rsi
  80017f:	48 bf 7a 4a 80 00 00 	movabs $0x804a7a,%rdi
  800186:	00 00 00 
  800189:	b8 00 00 00 00       	mov    $0x0,%eax
  80018e:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  800195:	00 00 00 
  800198:	ff d2                	callq  *%rdx

	// check spawn
	if ((r = spawnl("/bin/testpteshare", "testpteshare", "arg", 0)) < 0)
  80019a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80019f:	48 ba 95 4a 80 00 00 	movabs $0x804a95,%rdx
  8001a6:	00 00 00 
  8001a9:	48 be 99 4a 80 00 00 	movabs $0x804a99,%rsi
  8001b0:	00 00 00 
  8001b3:	48 bf a6 4a 80 00 00 	movabs $0x804aa6,%rdi
  8001ba:	00 00 00 
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8001c2:	49 b8 dc 34 80 00 00 	movabs $0x8034dc,%r8
  8001c9:	00 00 00 
  8001cc:	41 ff d0             	callq  *%r8
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001d6:	79 30                	jns    800208 <umain+0x1c5>
		panic("spawn: %e", r);
  8001d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001db:	89 c1                	mov    %eax,%ecx
  8001dd:	48 ba b8 4a 80 00 00 	movabs $0x804ab8,%rdx
  8001e4:	00 00 00 
  8001e7:	be 21 00 00 00       	mov    $0x21,%esi
  8001ec:	48 bf 51 4a 80 00 00 	movabs $0x804a51,%rdi
  8001f3:	00 00 00 
  8001f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fb:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  800202:	00 00 00 
  800205:	41 ff d0             	callq  *%r8
	wait(r);
  800208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80020b:	89 c7                	mov    %eax,%edi
  80020d:	48 b8 3c 43 80 00 00 	movabs $0x80433c,%rax
  800214:	00 00 00 
  800217:	ff d0                	callq  *%rax
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  800219:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800220:	00 00 00 
  800223:	48 8b 00             	mov    (%rax),%rax
  800226:	48 89 c6             	mov    %rax,%rsi
  800229:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80022e:	48 b8 ab 12 80 00 00 	movabs $0x8012ab,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	75 0c                	jne    80024a <umain+0x207>
  80023e:	48 b8 6e 4a 80 00 00 	movabs $0x804a6e,%rax
  800245:	00 00 00 
  800248:	eb 0a                	jmp    800254 <umain+0x211>
  80024a:	48 b8 74 4a 80 00 00 	movabs $0x804a74,%rax
  800251:	00 00 00 
  800254:	48 89 c6             	mov    %rax,%rsi
  800257:	48 bf c2 4a 80 00 00 	movabs $0x804ac2,%rdi
  80025e:	00 00 00 
  800261:	b8 00 00 00 00       	mov    $0x0,%eax
  800266:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  80026d:	00 00 00 
  800270:	ff d2                	callq  *%rdx
static __inline void read_gdtr (uint64_t *gdtbase, uint16_t *gdtlimit) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800272:	cc                   	int3   

	breakpoint();
}
  800273:	c9                   	leaveq 
  800274:	c3                   	retq   

0000000000800275 <childofspawn>:

void
childofspawn(void)
{
  800275:	55                   	push   %rbp
  800276:	48 89 e5             	mov    %rsp,%rbp
	strcpy(VA, msg2);
  800279:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800280:	00 00 00 
  800283:	48 8b 00             	mov    (%rax),%rax
  800286:	48 89 c6             	mov    %rax,%rsi
  800289:	bf 00 00 00 a0       	mov    $0xa0000000,%edi
  80028e:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	exit();
  80029a:	48 b8 38 03 80 00 00 	movabs $0x800338,%rax
  8002a1:	00 00 00 
  8002a4:	ff d0                	callq  *%rax
}
  8002a6:	5d                   	pop    %rbp
  8002a7:	c3                   	retq   

00000000008002a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002a8:	55                   	push   %rbp
  8002a9:	48 89 e5             	mov    %rsp,%rbp
  8002ac:	48 83 ec 10          	sub    $0x10,%rsp
  8002b0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8002b3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  8002b7:	48 b8 fc 19 80 00 00 	movabs $0x8019fc,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
  8002c3:	48 98                	cltq   
  8002c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ca:	48 89 c2             	mov    %rax,%rdx
  8002cd:	48 89 d0             	mov    %rdx,%rax
  8002d0:	48 c1 e0 03          	shl    $0x3,%rax
  8002d4:	48 01 d0             	add    %rdx,%rax
  8002d7:	48 c1 e0 05          	shl    $0x5,%rax
  8002db:	48 89 c2             	mov    %rax,%rdx
  8002de:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8002e5:	00 00 00 
  8002e8:	48 01 c2             	add    %rax,%rdx
  8002eb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002f2:	00 00 00 
  8002f5:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002fc:	7e 14                	jle    800312 <libmain+0x6a>
		binaryname = argv[0];
  8002fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800302:	48 8b 10             	mov    (%rax),%rdx
  800305:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  80030c:	00 00 00 
  80030f:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800312:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800316:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800319:	48 89 d6             	mov    %rdx,%rsi
  80031c:	89 c7                	mov    %eax,%edi
  80031e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800325:	00 00 00 
  800328:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80032a:	48 b8 38 03 80 00 00 	movabs $0x800338,%rax
  800331:	00 00 00 
  800334:	ff d0                	callq  *%rax
}
  800336:	c9                   	leaveq 
  800337:	c3                   	retq   

0000000000800338 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800338:	55                   	push   %rbp
  800339:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  80033c:	48 b8 71 25 80 00 00 	movabs $0x802571,%rax
  800343:	00 00 00 
  800346:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  800348:	bf 00 00 00 00       	mov    $0x0,%edi
  80034d:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  800354:	00 00 00 
  800357:	ff d0                	callq  *%rax
}
  800359:	5d                   	pop    %rbp
  80035a:	c3                   	retq   

000000000080035b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80035b:	55                   	push   %rbp
  80035c:	48 89 e5             	mov    %rsp,%rbp
  80035f:	53                   	push   %rbx
  800360:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800367:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80036e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800374:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80037b:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800382:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800389:	84 c0                	test   %al,%al
  80038b:	74 23                	je     8003b0 <_panic+0x55>
  80038d:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800394:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800398:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80039c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8003a0:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8003a4:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8003a8:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8003ac:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8003b0:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8003b7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8003be:	00 00 00 
  8003c1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8003c8:	00 00 00 
  8003cb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8003cf:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8003d6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8003dd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003e4:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8003eb:	00 00 00 
  8003ee:	48 8b 18             	mov    (%rax),%rbx
  8003f1:	48 b8 fc 19 80 00 00 	movabs $0x8019fc,%rax
  8003f8:	00 00 00 
  8003fb:	ff d0                	callq  *%rax
  8003fd:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800403:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80040a:	41 89 c8             	mov    %ecx,%r8d
  80040d:	48 89 d1             	mov    %rdx,%rcx
  800410:	48 89 da             	mov    %rbx,%rdx
  800413:	89 c6                	mov    %eax,%esi
  800415:	48 bf e8 4a 80 00 00 	movabs $0x804ae8,%rdi
  80041c:	00 00 00 
  80041f:	b8 00 00 00 00       	mov    $0x0,%eax
  800424:	49 b9 94 05 80 00 00 	movabs $0x800594,%r9
  80042b:	00 00 00 
  80042e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800431:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800438:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80043f:	48 89 d6             	mov    %rdx,%rsi
  800442:	48 89 c7             	mov    %rax,%rdi
  800445:	48 b8 e8 04 80 00 00 	movabs $0x8004e8,%rax
  80044c:	00 00 00 
  80044f:	ff d0                	callq  *%rax
	cprintf("\n");
  800451:	48 bf 0b 4b 80 00 00 	movabs $0x804b0b,%rdi
  800458:	00 00 00 
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
  800460:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  800467:	00 00 00 
  80046a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80046c:	cc                   	int3   
  80046d:	eb fd                	jmp    80046c <_panic+0x111>

000000000080046f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80046f:	55                   	push   %rbp
  800470:	48 89 e5             	mov    %rsp,%rbp
  800473:	48 83 ec 10          	sub    $0x10,%rsp
  800477:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80047a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80047e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800482:	8b 00                	mov    (%rax),%eax
  800484:	8d 48 01             	lea    0x1(%rax),%ecx
  800487:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80048b:	89 0a                	mov    %ecx,(%rdx)
  80048d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800490:	89 d1                	mov    %edx,%ecx
  800492:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800496:	48 98                	cltq   
  800498:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80049c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004a0:	8b 00                	mov    (%rax),%eax
  8004a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004a7:	75 2c                	jne    8004d5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8004a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004ad:	8b 00                	mov    (%rax),%eax
  8004af:	48 98                	cltq   
  8004b1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004b5:	48 83 c2 08          	add    $0x8,%rdx
  8004b9:	48 89 c6             	mov    %rax,%rsi
  8004bc:	48 89 d7             	mov    %rdx,%rdi
  8004bf:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  8004c6:	00 00 00 
  8004c9:	ff d0                	callq  *%rax
        b->idx = 0;
  8004cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004cf:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8004d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004d9:	8b 40 04             	mov    0x4(%rax),%eax
  8004dc:	8d 50 01             	lea    0x1(%rax),%edx
  8004df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004e3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8004e6:	c9                   	leaveq 
  8004e7:	c3                   	retq   

00000000008004e8 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8004e8:	55                   	push   %rbp
  8004e9:	48 89 e5             	mov    %rsp,%rbp
  8004ec:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8004f3:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8004fa:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800501:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800508:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80050f:	48 8b 0a             	mov    (%rdx),%rcx
  800512:	48 89 08             	mov    %rcx,(%rax)
  800515:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800519:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80051d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800521:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800525:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80052c:	00 00 00 
    b.cnt = 0;
  80052f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800536:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800539:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800540:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800547:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80054e:	48 89 c6             	mov    %rax,%rsi
  800551:	48 bf 6f 04 80 00 00 	movabs $0x80046f,%rdi
  800558:	00 00 00 
  80055b:	48 b8 47 09 80 00 00 	movabs $0x800947,%rax
  800562:	00 00 00 
  800565:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800567:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80056d:	48 98                	cltq   
  80056f:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800576:	48 83 c2 08          	add    $0x8,%rdx
  80057a:	48 89 c6             	mov    %rax,%rsi
  80057d:	48 89 d7             	mov    %rdx,%rdi
  800580:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  800587:	00 00 00 
  80058a:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80058c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800592:	c9                   	leaveq 
  800593:	c3                   	retq   

0000000000800594 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800594:	55                   	push   %rbp
  800595:	48 89 e5             	mov    %rsp,%rbp
  800598:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80059f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8005a6:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8005ad:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8005b4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8005bb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8005c2:	84 c0                	test   %al,%al
  8005c4:	74 20                	je     8005e6 <cprintf+0x52>
  8005c6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8005ca:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8005ce:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8005d2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8005d6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8005da:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8005de:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8005e2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8005e6:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8005ed:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8005f4:	00 00 00 
  8005f7:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8005fe:	00 00 00 
  800601:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800605:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80060c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800613:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80061a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800621:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800628:	48 8b 0a             	mov    (%rdx),%rcx
  80062b:	48 89 08             	mov    %rcx,(%rax)
  80062e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800632:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800636:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80063a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80063e:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800645:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80064c:	48 89 d6             	mov    %rdx,%rsi
  80064f:	48 89 c7             	mov    %rax,%rdi
  800652:	48 b8 e8 04 80 00 00 	movabs $0x8004e8,%rax
  800659:	00 00 00 
  80065c:	ff d0                	callq  *%rax
  80065e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800664:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80066a:	c9                   	leaveq 
  80066b:	c3                   	retq   

000000000080066c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80066c:	55                   	push   %rbp
  80066d:	48 89 e5             	mov    %rsp,%rbp
  800670:	53                   	push   %rbx
  800671:	48 83 ec 38          	sub    $0x38,%rsp
  800675:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800679:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80067d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800681:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800684:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800688:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80068f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800693:	77 3b                	ja     8006d0 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800695:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800698:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80069c:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  80069f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a8:	48 f7 f3             	div    %rbx
  8006ab:	48 89 c2             	mov    %rax,%rdx
  8006ae:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8006b1:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006b4:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	41 89 f9             	mov    %edi,%r9d
  8006bf:	48 89 c7             	mov    %rax,%rdi
  8006c2:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  8006c9:	00 00 00 
  8006cc:	ff d0                	callq  *%rax
  8006ce:	eb 1e                	jmp    8006ee <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d0:	eb 12                	jmp    8006e4 <printnum+0x78>
			putch(padc, putdat);
  8006d2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006d6:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8006d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006dd:	48 89 ce             	mov    %rcx,%rsi
  8006e0:	89 d7                	mov    %edx,%edi
  8006e2:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e4:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8006e8:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8006ec:	7f e4                	jg     8006d2 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ee:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8006f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8006f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fa:	48 f7 f1             	div    %rcx
  8006fd:	48 89 d0             	mov    %rdx,%rax
  800700:	48 ba 10 4d 80 00 00 	movabs $0x804d10,%rdx
  800707:	00 00 00 
  80070a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  80070e:	0f be d0             	movsbl %al,%edx
  800711:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800715:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800719:	48 89 ce             	mov    %rcx,%rsi
  80071c:	89 d7                	mov    %edx,%edi
  80071e:	ff d0                	callq  *%rax
}
  800720:	48 83 c4 38          	add    $0x38,%rsp
  800724:	5b                   	pop    %rbx
  800725:	5d                   	pop    %rbp
  800726:	c3                   	retq   

0000000000800727 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800727:	55                   	push   %rbp
  800728:	48 89 e5             	mov    %rsp,%rbp
  80072b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80072f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800733:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800736:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80073a:	7e 52                	jle    80078e <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  80073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800740:	8b 00                	mov    (%rax),%eax
  800742:	83 f8 30             	cmp    $0x30,%eax
  800745:	73 24                	jae    80076b <getuint+0x44>
  800747:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80074f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800753:	8b 00                	mov    (%rax),%eax
  800755:	89 c0                	mov    %eax,%eax
  800757:	48 01 d0             	add    %rdx,%rax
  80075a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80075e:	8b 12                	mov    (%rdx),%edx
  800760:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800763:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800767:	89 0a                	mov    %ecx,(%rdx)
  800769:	eb 17                	jmp    800782 <getuint+0x5b>
  80076b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80076f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800773:	48 89 d0             	mov    %rdx,%rax
  800776:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80077a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80077e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800782:	48 8b 00             	mov    (%rax),%rax
  800785:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800789:	e9 a3 00 00 00       	jmpq   800831 <getuint+0x10a>
	else if (lflag)
  80078e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800792:	74 4f                	je     8007e3 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800798:	8b 00                	mov    (%rax),%eax
  80079a:	83 f8 30             	cmp    $0x30,%eax
  80079d:	73 24                	jae    8007c3 <getuint+0x9c>
  80079f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ab:	8b 00                	mov    (%rax),%eax
  8007ad:	89 c0                	mov    %eax,%eax
  8007af:	48 01 d0             	add    %rdx,%rax
  8007b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007b6:	8b 12                	mov    (%rdx),%edx
  8007b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bf:	89 0a                	mov    %ecx,(%rdx)
  8007c1:	eb 17                	jmp    8007da <getuint+0xb3>
  8007c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007cb:	48 89 d0             	mov    %rdx,%rax
  8007ce:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007d6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007da:	48 8b 00             	mov    (%rax),%rax
  8007dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e1:	eb 4e                	jmp    800831 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8007e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007e7:	8b 00                	mov    (%rax),%eax
  8007e9:	83 f8 30             	cmp    $0x30,%eax
  8007ec:	73 24                	jae    800812 <getuint+0xeb>
  8007ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fa:	8b 00                	mov    (%rax),%eax
  8007fc:	89 c0                	mov    %eax,%eax
  8007fe:	48 01 d0             	add    %rdx,%rax
  800801:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800805:	8b 12                	mov    (%rdx),%edx
  800807:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080e:	89 0a                	mov    %ecx,(%rdx)
  800810:	eb 17                	jmp    800829 <getuint+0x102>
  800812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800816:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081a:	48 89 d0             	mov    %rdx,%rax
  80081d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800821:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800825:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800829:	8b 00                	mov    (%rax),%eax
  80082b:	89 c0                	mov    %eax,%eax
  80082d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800831:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800835:	c9                   	leaveq 
  800836:	c3                   	retq   

0000000000800837 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800837:	55                   	push   %rbp
  800838:	48 89 e5             	mov    %rsp,%rbp
  80083b:	48 83 ec 1c          	sub    $0x1c,%rsp
  80083f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800843:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800846:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80084a:	7e 52                	jle    80089e <getint+0x67>
		x=va_arg(*ap, long long);
  80084c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800850:	8b 00                	mov    (%rax),%eax
  800852:	83 f8 30             	cmp    $0x30,%eax
  800855:	73 24                	jae    80087b <getint+0x44>
  800857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80085f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800863:	8b 00                	mov    (%rax),%eax
  800865:	89 c0                	mov    %eax,%eax
  800867:	48 01 d0             	add    %rdx,%rax
  80086a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80086e:	8b 12                	mov    (%rdx),%edx
  800870:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800873:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800877:	89 0a                	mov    %ecx,(%rdx)
  800879:	eb 17                	jmp    800892 <getint+0x5b>
  80087b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80087f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800883:	48 89 d0             	mov    %rdx,%rax
  800886:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80088a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800892:	48 8b 00             	mov    (%rax),%rax
  800895:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800899:	e9 a3 00 00 00       	jmpq   800941 <getint+0x10a>
	else if (lflag)
  80089e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008a2:	74 4f                	je     8008f3 <getint+0xbc>
		x=va_arg(*ap, long);
  8008a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a8:	8b 00                	mov    (%rax),%eax
  8008aa:	83 f8 30             	cmp    $0x30,%eax
  8008ad:	73 24                	jae    8008d3 <getint+0x9c>
  8008af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bb:	8b 00                	mov    (%rax),%eax
  8008bd:	89 c0                	mov    %eax,%eax
  8008bf:	48 01 d0             	add    %rdx,%rax
  8008c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c6:	8b 12                	mov    (%rdx),%edx
  8008c8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008cf:	89 0a                	mov    %ecx,(%rdx)
  8008d1:	eb 17                	jmp    8008ea <getint+0xb3>
  8008d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008db:	48 89 d0             	mov    %rdx,%rax
  8008de:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008e6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008ea:	48 8b 00             	mov    (%rax),%rax
  8008ed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008f1:	eb 4e                	jmp    800941 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8008f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f7:	8b 00                	mov    (%rax),%eax
  8008f9:	83 f8 30             	cmp    $0x30,%eax
  8008fc:	73 24                	jae    800922 <getint+0xeb>
  8008fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800902:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090a:	8b 00                	mov    (%rax),%eax
  80090c:	89 c0                	mov    %eax,%eax
  80090e:	48 01 d0             	add    %rdx,%rax
  800911:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800915:	8b 12                	mov    (%rdx),%edx
  800917:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091e:	89 0a                	mov    %ecx,(%rdx)
  800920:	eb 17                	jmp    800939 <getint+0x102>
  800922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800926:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80092a:	48 89 d0             	mov    %rdx,%rax
  80092d:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800931:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800935:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800939:	8b 00                	mov    (%rax),%eax
  80093b:	48 98                	cltq   
  80093d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800941:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800945:	c9                   	leaveq 
  800946:	c3                   	retq   

0000000000800947 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800947:	55                   	push   %rbp
  800948:	48 89 e5             	mov    %rsp,%rbp
  80094b:	41 54                	push   %r12
  80094d:	53                   	push   %rbx
  80094e:	48 83 ec 60          	sub    $0x60,%rsp
  800952:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800956:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80095a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80095e:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800962:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800966:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80096a:	48 8b 0a             	mov    (%rdx),%rcx
  80096d:	48 89 08             	mov    %rcx,(%rax)
  800970:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800974:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800978:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80097c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800980:	eb 17                	jmp    800999 <vprintfmt+0x52>
			if (ch == '\0')
  800982:	85 db                	test   %ebx,%ebx
  800984:	0f 84 cc 04 00 00    	je     800e56 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80098a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80098e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800992:	48 89 d6             	mov    %rdx,%rsi
  800995:	89 df                	mov    %ebx,%edi
  800997:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800999:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80099d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009a1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009a5:	0f b6 00             	movzbl (%rax),%eax
  8009a8:	0f b6 d8             	movzbl %al,%ebx
  8009ab:	83 fb 25             	cmp    $0x25,%ebx
  8009ae:	75 d2                	jne    800982 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b0:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8009b4:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8009bb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8009c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8009c9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8009d8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009dc:	0f b6 00             	movzbl (%rax),%eax
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8009e5:	83 f8 55             	cmp    $0x55,%eax
  8009e8:	0f 87 34 04 00 00    	ja     800e22 <vprintfmt+0x4db>
  8009ee:	89 c0                	mov    %eax,%eax
  8009f0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8009f7:	00 
  8009f8:	48 b8 38 4d 80 00 00 	movabs $0x804d38,%rax
  8009ff:	00 00 00 
  800a02:	48 01 d0             	add    %rdx,%rax
  800a05:	48 8b 00             	mov    (%rax),%rax
  800a08:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800a0a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800a0e:	eb c0                	jmp    8009d0 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a10:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800a14:	eb ba                	jmp    8009d0 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a16:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800a1d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800a20:	89 d0                	mov    %edx,%eax
  800a22:	c1 e0 02             	shl    $0x2,%eax
  800a25:	01 d0                	add    %edx,%eax
  800a27:	01 c0                	add    %eax,%eax
  800a29:	01 d8                	add    %ebx,%eax
  800a2b:	83 e8 30             	sub    $0x30,%eax
  800a2e:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800a31:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a35:	0f b6 00             	movzbl (%rax),%eax
  800a38:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a3b:	83 fb 2f             	cmp    $0x2f,%ebx
  800a3e:	7e 0c                	jle    800a4c <vprintfmt+0x105>
  800a40:	83 fb 39             	cmp    $0x39,%ebx
  800a43:	7f 07                	jg     800a4c <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a45:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a4a:	eb d1                	jmp    800a1d <vprintfmt+0xd6>
			goto process_precision;
  800a4c:	eb 58                	jmp    800aa6 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800a4e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a51:	83 f8 30             	cmp    $0x30,%eax
  800a54:	73 17                	jae    800a6d <vprintfmt+0x126>
  800a56:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a5a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a5d:	89 c0                	mov    %eax,%eax
  800a5f:	48 01 d0             	add    %rdx,%rax
  800a62:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a65:	83 c2 08             	add    $0x8,%edx
  800a68:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a6b:	eb 0f                	jmp    800a7c <vprintfmt+0x135>
  800a6d:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a71:	48 89 d0             	mov    %rdx,%rax
  800a74:	48 83 c2 08          	add    $0x8,%rdx
  800a78:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a7c:	8b 00                	mov    (%rax),%eax
  800a7e:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a81:	eb 23                	jmp    800aa6 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a83:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a87:	79 0c                	jns    800a95 <vprintfmt+0x14e>
				width = 0;
  800a89:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a90:	e9 3b ff ff ff       	jmpq   8009d0 <vprintfmt+0x89>
  800a95:	e9 36 ff ff ff       	jmpq   8009d0 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a9a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800aa1:	e9 2a ff ff ff       	jmpq   8009d0 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800aa6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800aaa:	79 12                	jns    800abe <vprintfmt+0x177>
				width = precision, precision = -1;
  800aac:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800aaf:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800ab2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800ab9:	e9 12 ff ff ff       	jmpq   8009d0 <vprintfmt+0x89>
  800abe:	e9 0d ff ff ff       	jmpq   8009d0 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ac3:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800ac7:	e9 04 ff ff ff       	jmpq   8009d0 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800acc:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800acf:	83 f8 30             	cmp    $0x30,%eax
  800ad2:	73 17                	jae    800aeb <vprintfmt+0x1a4>
  800ad4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ad8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800adb:	89 c0                	mov    %eax,%eax
  800add:	48 01 d0             	add    %rdx,%rax
  800ae0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ae3:	83 c2 08             	add    $0x8,%edx
  800ae6:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ae9:	eb 0f                	jmp    800afa <vprintfmt+0x1b3>
  800aeb:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800aef:	48 89 d0             	mov    %rdx,%rax
  800af2:	48 83 c2 08          	add    $0x8,%rdx
  800af6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800afa:	8b 10                	mov    (%rax),%edx
  800afc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b04:	48 89 ce             	mov    %rcx,%rsi
  800b07:	89 d7                	mov    %edx,%edi
  800b09:	ff d0                	callq  *%rax
			break;
  800b0b:	e9 40 03 00 00       	jmpq   800e50 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800b10:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b13:	83 f8 30             	cmp    $0x30,%eax
  800b16:	73 17                	jae    800b2f <vprintfmt+0x1e8>
  800b18:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b1f:	89 c0                	mov    %eax,%eax
  800b21:	48 01 d0             	add    %rdx,%rax
  800b24:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b27:	83 c2 08             	add    $0x8,%edx
  800b2a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b2d:	eb 0f                	jmp    800b3e <vprintfmt+0x1f7>
  800b2f:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b33:	48 89 d0             	mov    %rdx,%rax
  800b36:	48 83 c2 08          	add    $0x8,%rdx
  800b3a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b3e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800b40:	85 db                	test   %ebx,%ebx
  800b42:	79 02                	jns    800b46 <vprintfmt+0x1ff>
				err = -err;
  800b44:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b46:	83 fb 15             	cmp    $0x15,%ebx
  800b49:	7f 16                	jg     800b61 <vprintfmt+0x21a>
  800b4b:	48 b8 60 4c 80 00 00 	movabs $0x804c60,%rax
  800b52:	00 00 00 
  800b55:	48 63 d3             	movslq %ebx,%rdx
  800b58:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800b5c:	4d 85 e4             	test   %r12,%r12
  800b5f:	75 2e                	jne    800b8f <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b61:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b69:	89 d9                	mov    %ebx,%ecx
  800b6b:	48 ba 21 4d 80 00 00 	movabs $0x804d21,%rdx
  800b72:	00 00 00 
  800b75:	48 89 c7             	mov    %rax,%rdi
  800b78:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7d:	49 b8 5f 0e 80 00 00 	movabs $0x800e5f,%r8
  800b84:	00 00 00 
  800b87:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b8a:	e9 c1 02 00 00       	jmpq   800e50 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b8f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b97:	4c 89 e1             	mov    %r12,%rcx
  800b9a:	48 ba 2a 4d 80 00 00 	movabs $0x804d2a,%rdx
  800ba1:	00 00 00 
  800ba4:	48 89 c7             	mov    %rax,%rdi
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bac:	49 b8 5f 0e 80 00 00 	movabs $0x800e5f,%r8
  800bb3:	00 00 00 
  800bb6:	41 ff d0             	callq  *%r8
			break;
  800bb9:	e9 92 02 00 00       	jmpq   800e50 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800bbe:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bc1:	83 f8 30             	cmp    $0x30,%eax
  800bc4:	73 17                	jae    800bdd <vprintfmt+0x296>
  800bc6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bca:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bcd:	89 c0                	mov    %eax,%eax
  800bcf:	48 01 d0             	add    %rdx,%rax
  800bd2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bd5:	83 c2 08             	add    $0x8,%edx
  800bd8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bdb:	eb 0f                	jmp    800bec <vprintfmt+0x2a5>
  800bdd:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800be1:	48 89 d0             	mov    %rdx,%rax
  800be4:	48 83 c2 08          	add    $0x8,%rdx
  800be8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bec:	4c 8b 20             	mov    (%rax),%r12
  800bef:	4d 85 e4             	test   %r12,%r12
  800bf2:	75 0a                	jne    800bfe <vprintfmt+0x2b7>
				p = "(null)";
  800bf4:	49 bc 2d 4d 80 00 00 	movabs $0x804d2d,%r12
  800bfb:	00 00 00 
			if (width > 0 && padc != '-')
  800bfe:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c02:	7e 3f                	jle    800c43 <vprintfmt+0x2fc>
  800c04:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c08:	74 39                	je     800c43 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c0a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c0d:	48 98                	cltq   
  800c0f:	48 89 c6             	mov    %rax,%rsi
  800c12:	4c 89 e7             	mov    %r12,%rdi
  800c15:	48 b8 0b 11 80 00 00 	movabs $0x80110b,%rax
  800c1c:	00 00 00 
  800c1f:	ff d0                	callq  *%rax
  800c21:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800c24:	eb 17                	jmp    800c3d <vprintfmt+0x2f6>
					putch(padc, putdat);
  800c26:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800c2a:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c32:	48 89 ce             	mov    %rcx,%rsi
  800c35:	89 d7                	mov    %edx,%edi
  800c37:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c39:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c41:	7f e3                	jg     800c26 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c43:	eb 37                	jmp    800c7c <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800c45:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800c49:	74 1e                	je     800c69 <vprintfmt+0x322>
  800c4b:	83 fb 1f             	cmp    $0x1f,%ebx
  800c4e:	7e 05                	jle    800c55 <vprintfmt+0x30e>
  800c50:	83 fb 7e             	cmp    $0x7e,%ebx
  800c53:	7e 14                	jle    800c69 <vprintfmt+0x322>
					putch('?', putdat);
  800c55:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c59:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c5d:	48 89 d6             	mov    %rdx,%rsi
  800c60:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c65:	ff d0                	callq  *%rax
  800c67:	eb 0f                	jmp    800c78 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c71:	48 89 d6             	mov    %rdx,%rsi
  800c74:	89 df                	mov    %ebx,%edi
  800c76:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c78:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c7c:	4c 89 e0             	mov    %r12,%rax
  800c7f:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c83:	0f b6 00             	movzbl (%rax),%eax
  800c86:	0f be d8             	movsbl %al,%ebx
  800c89:	85 db                	test   %ebx,%ebx
  800c8b:	74 10                	je     800c9d <vprintfmt+0x356>
  800c8d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c91:	78 b2                	js     800c45 <vprintfmt+0x2fe>
  800c93:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c97:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c9b:	79 a8                	jns    800c45 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c9d:	eb 16                	jmp    800cb5 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c9f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ca3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ca7:	48 89 d6             	mov    %rdx,%rsi
  800caa:	bf 20 00 00 00       	mov    $0x20,%edi
  800caf:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cb1:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cb5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cb9:	7f e4                	jg     800c9f <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800cbb:	e9 90 01 00 00       	jmpq   800e50 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800cc0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cc4:	be 03 00 00 00       	mov    $0x3,%esi
  800cc9:	48 89 c7             	mov    %rax,%rdi
  800ccc:	48 b8 37 08 80 00 00 	movabs $0x800837,%rax
  800cd3:	00 00 00 
  800cd6:	ff d0                	callq  *%rax
  800cd8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800cdc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ce0:	48 85 c0             	test   %rax,%rax
  800ce3:	79 1d                	jns    800d02 <vprintfmt+0x3bb>
				putch('-', putdat);
  800ce5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ce9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ced:	48 89 d6             	mov    %rdx,%rsi
  800cf0:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800cf5:	ff d0                	callq  *%rax
				num = -(long long) num;
  800cf7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800cfb:	48 f7 d8             	neg    %rax
  800cfe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d02:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d09:	e9 d5 00 00 00       	jmpq   800de3 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800d0e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d12:	be 03 00 00 00       	mov    $0x3,%esi
  800d17:	48 89 c7             	mov    %rax,%rdi
  800d1a:	48 b8 27 07 80 00 00 	movabs $0x800727,%rax
  800d21:	00 00 00 
  800d24:	ff d0                	callq  *%rax
  800d26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800d2a:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800d31:	e9 ad 00 00 00       	jmpq   800de3 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800d36:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d3a:	be 03 00 00 00       	mov    $0x3,%esi
  800d3f:	48 89 c7             	mov    %rax,%rdi
  800d42:	48 b8 27 07 80 00 00 	movabs $0x800727,%rax
  800d49:	00 00 00 
  800d4c:	ff d0                	callq  *%rax
  800d4e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800d52:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800d59:	e9 85 00 00 00       	jmpq   800de3 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800d5e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d66:	48 89 d6             	mov    %rdx,%rsi
  800d69:	bf 30 00 00 00       	mov    $0x30,%edi
  800d6e:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d70:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d78:	48 89 d6             	mov    %rdx,%rsi
  800d7b:	bf 78 00 00 00       	mov    $0x78,%edi
  800d80:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d82:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d85:	83 f8 30             	cmp    $0x30,%eax
  800d88:	73 17                	jae    800da1 <vprintfmt+0x45a>
  800d8a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d8e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d91:	89 c0                	mov    %eax,%eax
  800d93:	48 01 d0             	add    %rdx,%rax
  800d96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d99:	83 c2 08             	add    $0x8,%edx
  800d9c:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d9f:	eb 0f                	jmp    800db0 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800da1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da5:	48 89 d0             	mov    %rdx,%rax
  800da8:	48 83 c2 08          	add    $0x8,%rdx
  800dac:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db0:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800db3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800db7:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800dbe:	eb 23                	jmp    800de3 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800dc0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dc4:	be 03 00 00 00       	mov    $0x3,%esi
  800dc9:	48 89 c7             	mov    %rax,%rdi
  800dcc:	48 b8 27 07 80 00 00 	movabs $0x800727,%rax
  800dd3:	00 00 00 
  800dd6:	ff d0                	callq  *%rax
  800dd8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ddc:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800de3:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800de8:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800deb:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800dee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800df2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800df6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfa:	45 89 c1             	mov    %r8d,%r9d
  800dfd:	41 89 f8             	mov    %edi,%r8d
  800e00:	48 89 c7             	mov    %rax,%rdi
  800e03:	48 b8 6c 06 80 00 00 	movabs $0x80066c,%rax
  800e0a:	00 00 00 
  800e0d:	ff d0                	callq  *%rax
			break;
  800e0f:	eb 3f                	jmp    800e50 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e11:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e19:	48 89 d6             	mov    %rdx,%rsi
  800e1c:	89 df                	mov    %ebx,%edi
  800e1e:	ff d0                	callq  *%rax
			break;
  800e20:	eb 2e                	jmp    800e50 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e22:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e26:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2a:	48 89 d6             	mov    %rdx,%rsi
  800e2d:	bf 25 00 00 00       	mov    $0x25,%edi
  800e32:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e34:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e39:	eb 05                	jmp    800e40 <vprintfmt+0x4f9>
  800e3b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800e40:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800e44:	48 83 e8 01          	sub    $0x1,%rax
  800e48:	0f b6 00             	movzbl (%rax),%eax
  800e4b:	3c 25                	cmp    $0x25,%al
  800e4d:	75 ec                	jne    800e3b <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800e4f:	90                   	nop
		}
	}
  800e50:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e51:	e9 43 fb ff ff       	jmpq   800999 <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800e56:	48 83 c4 60          	add    $0x60,%rsp
  800e5a:	5b                   	pop    %rbx
  800e5b:	41 5c                	pop    %r12
  800e5d:	5d                   	pop    %rbp
  800e5e:	c3                   	retq   

0000000000800e5f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e5f:	55                   	push   %rbp
  800e60:	48 89 e5             	mov    %rsp,%rbp
  800e63:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e6a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e71:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e78:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e7f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e86:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e8d:	84 c0                	test   %al,%al
  800e8f:	74 20                	je     800eb1 <printfmt+0x52>
  800e91:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e95:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e99:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e9d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800ea1:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800ea5:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800ea9:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ead:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800eb1:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800eb8:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ebf:	00 00 00 
  800ec2:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ec9:	00 00 00 
  800ecc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ed0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ed7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800ede:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ee5:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800eec:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800ef3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800efa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800f01:	48 89 c7             	mov    %rax,%rdi
  800f04:	48 b8 47 09 80 00 00 	movabs $0x800947,%rax
  800f0b:	00 00 00 
  800f0e:	ff d0                	callq  *%rax
	va_end(ap);
}
  800f10:	c9                   	leaveq 
  800f11:	c3                   	retq   

0000000000800f12 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f12:	55                   	push   %rbp
  800f13:	48 89 e5             	mov    %rsp,%rbp
  800f16:	48 83 ec 10          	sub    $0x10,%rsp
  800f1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800f1d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800f21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f25:	8b 40 10             	mov    0x10(%rax),%eax
  800f28:	8d 50 01             	lea    0x1(%rax),%edx
  800f2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f2f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800f32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f36:	48 8b 10             	mov    (%rax),%rdx
  800f39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f3d:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f41:	48 39 c2             	cmp    %rax,%rdx
  800f44:	73 17                	jae    800f5d <sprintputch+0x4b>
		*b->buf++ = ch;
  800f46:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f4a:	48 8b 00             	mov    (%rax),%rax
  800f4d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800f51:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f55:	48 89 0a             	mov    %rcx,(%rdx)
  800f58:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800f5b:	88 10                	mov    %dl,(%rax)
}
  800f5d:	c9                   	leaveq 
  800f5e:	c3                   	retq   

0000000000800f5f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f5f:	55                   	push   %rbp
  800f60:	48 89 e5             	mov    %rsp,%rbp
  800f63:	48 83 ec 50          	sub    $0x50,%rsp
  800f67:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f6b:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f6e:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f72:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f76:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f7a:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f7e:	48 8b 0a             	mov    (%rdx),%rcx
  800f81:	48 89 08             	mov    %rcx,(%rax)
  800f84:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f88:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f8c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f90:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f94:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f98:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f9c:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f9f:	48 98                	cltq   
  800fa1:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800fa5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fa9:	48 01 d0             	add    %rdx,%rax
  800fac:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800fb0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800fb7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800fbc:	74 06                	je     800fc4 <vsnprintf+0x65>
  800fbe:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800fc2:	7f 07                	jg     800fcb <vsnprintf+0x6c>
		return -E_INVAL;
  800fc4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fc9:	eb 2f                	jmp    800ffa <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800fcb:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800fcf:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800fd3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800fd7:	48 89 c6             	mov    %rax,%rsi
  800fda:	48 bf 12 0f 80 00 00 	movabs $0x800f12,%rdi
  800fe1:	00 00 00 
  800fe4:	48 b8 47 09 80 00 00 	movabs $0x800947,%rax
  800feb:	00 00 00 
  800fee:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ff0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ff4:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800ff7:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800ffa:	c9                   	leaveq 
  800ffb:	c3                   	retq   

0000000000800ffc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ffc:	55                   	push   %rbp
  800ffd:	48 89 e5             	mov    %rsp,%rbp
  801000:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801007:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80100e:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801014:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80101b:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801022:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801029:	84 c0                	test   %al,%al
  80102b:	74 20                	je     80104d <snprintf+0x51>
  80102d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801031:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801035:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801039:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80103d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801041:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801045:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801049:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80104d:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801054:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80105b:	00 00 00 
  80105e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801065:	00 00 00 
  801068:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80106c:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801073:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80107a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801081:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801088:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80108f:	48 8b 0a             	mov    (%rdx),%rcx
  801092:	48 89 08             	mov    %rcx,(%rax)
  801095:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801099:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80109d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010a1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8010a5:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8010ac:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8010b3:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8010b9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8010c0:	48 89 c7             	mov    %rax,%rdi
  8010c3:	48 b8 5f 0f 80 00 00 	movabs $0x800f5f,%rax
  8010ca:	00 00 00 
  8010cd:	ff d0                	callq  *%rax
  8010cf:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8010d5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8010db:	c9                   	leaveq 
  8010dc:	c3                   	retq   

00000000008010dd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010dd:	55                   	push   %rbp
  8010de:	48 89 e5             	mov    %rsp,%rbp
  8010e1:	48 83 ec 18          	sub    $0x18,%rsp
  8010e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010f0:	eb 09                	jmp    8010fb <strlen+0x1e>
		n++;
  8010f2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010ff:	0f b6 00             	movzbl (%rax),%eax
  801102:	84 c0                	test   %al,%al
  801104:	75 ec                	jne    8010f2 <strlen+0x15>
		n++;
	return n;
  801106:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801109:	c9                   	leaveq 
  80110a:	c3                   	retq   

000000000080110b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80110b:	55                   	push   %rbp
  80110c:	48 89 e5             	mov    %rsp,%rbp
  80110f:	48 83 ec 20          	sub    $0x20,%rsp
  801113:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801117:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801122:	eb 0e                	jmp    801132 <strnlen+0x27>
		n++;
  801124:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801128:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80112d:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801132:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801137:	74 0b                	je     801144 <strnlen+0x39>
  801139:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113d:	0f b6 00             	movzbl (%rax),%eax
  801140:	84 c0                	test   %al,%al
  801142:	75 e0                	jne    801124 <strnlen+0x19>
		n++;
	return n;
  801144:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801147:	c9                   	leaveq 
  801148:	c3                   	retq   

0000000000801149 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801149:	55                   	push   %rbp
  80114a:	48 89 e5             	mov    %rsp,%rbp
  80114d:	48 83 ec 20          	sub    $0x20,%rsp
  801151:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801155:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801161:	90                   	nop
  801162:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801166:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80116a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80116e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801172:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801176:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80117a:	0f b6 12             	movzbl (%rdx),%edx
  80117d:	88 10                	mov    %dl,(%rax)
  80117f:	0f b6 00             	movzbl (%rax),%eax
  801182:	84 c0                	test   %al,%al
  801184:	75 dc                	jne    801162 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801186:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80118a:	c9                   	leaveq 
  80118b:	c3                   	retq   

000000000080118c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80118c:	55                   	push   %rbp
  80118d:	48 89 e5             	mov    %rsp,%rbp
  801190:	48 83 ec 20          	sub    $0x20,%rsp
  801194:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801198:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80119c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a0:	48 89 c7             	mov    %rax,%rdi
  8011a3:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  8011aa:	00 00 00 
  8011ad:	ff d0                	callq  *%rax
  8011af:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8011b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011b5:	48 63 d0             	movslq %eax,%rdx
  8011b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bc:	48 01 c2             	add    %rax,%rdx
  8011bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011c3:	48 89 c6             	mov    %rax,%rsi
  8011c6:	48 89 d7             	mov    %rdx,%rdi
  8011c9:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  8011d0:	00 00 00 
  8011d3:	ff d0                	callq  *%rax
	return dst;
  8011d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8011d9:	c9                   	leaveq 
  8011da:	c3                   	retq   

00000000008011db <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8011db:	55                   	push   %rbp
  8011dc:	48 89 e5             	mov    %rsp,%rbp
  8011df:	48 83 ec 28          	sub    $0x28,%rsp
  8011e3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011eb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8011ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8011f7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8011fe:	00 
  8011ff:	eb 2a                	jmp    80122b <strncpy+0x50>
		*dst++ = *src;
  801201:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801205:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801209:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80120d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801211:	0f b6 12             	movzbl (%rdx),%edx
  801214:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801216:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80121a:	0f b6 00             	movzbl (%rax),%eax
  80121d:	84 c0                	test   %al,%al
  80121f:	74 05                	je     801226 <strncpy+0x4b>
			src++;
  801221:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801226:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80122b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80122f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801233:	72 cc                	jb     801201 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801235:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801239:	c9                   	leaveq 
  80123a:	c3                   	retq   

000000000080123b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80123b:	55                   	push   %rbp
  80123c:	48 89 e5             	mov    %rsp,%rbp
  80123f:	48 83 ec 28          	sub    $0x28,%rsp
  801243:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801247:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80124b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80124f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801253:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801257:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80125c:	74 3d                	je     80129b <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80125e:	eb 1d                	jmp    80127d <strlcpy+0x42>
			*dst++ = *src++;
  801260:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801264:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801268:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80126c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801270:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801274:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801278:	0f b6 12             	movzbl (%rdx),%edx
  80127b:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80127d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801282:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801287:	74 0b                	je     801294 <strlcpy+0x59>
  801289:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128d:	0f b6 00             	movzbl (%rax),%eax
  801290:	84 c0                	test   %al,%al
  801292:	75 cc                	jne    801260 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801294:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801298:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80129b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80129f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a3:	48 29 c2             	sub    %rax,%rdx
  8012a6:	48 89 d0             	mov    %rdx,%rax
}
  8012a9:	c9                   	leaveq 
  8012aa:	c3                   	retq   

00000000008012ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8012ab:	55                   	push   %rbp
  8012ac:	48 89 e5             	mov    %rsp,%rbp
  8012af:	48 83 ec 10          	sub    $0x10,%rsp
  8012b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8012bb:	eb 0a                	jmp    8012c7 <strcmp+0x1c>
		p++, q++;
  8012bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012c2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cb:	0f b6 00             	movzbl (%rax),%eax
  8012ce:	84 c0                	test   %al,%al
  8012d0:	74 12                	je     8012e4 <strcmp+0x39>
  8012d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012d6:	0f b6 10             	movzbl (%rax),%edx
  8012d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012dd:	0f b6 00             	movzbl (%rax),%eax
  8012e0:	38 c2                	cmp    %al,%dl
  8012e2:	74 d9                	je     8012bd <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012e8:	0f b6 00             	movzbl (%rax),%eax
  8012eb:	0f b6 d0             	movzbl %al,%edx
  8012ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012f2:	0f b6 00             	movzbl (%rax),%eax
  8012f5:	0f b6 c0             	movzbl %al,%eax
  8012f8:	29 c2                	sub    %eax,%edx
  8012fa:	89 d0                	mov    %edx,%eax
}
  8012fc:	c9                   	leaveq 
  8012fd:	c3                   	retq   

00000000008012fe <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8012fe:	55                   	push   %rbp
  8012ff:	48 89 e5             	mov    %rsp,%rbp
  801302:	48 83 ec 18          	sub    $0x18,%rsp
  801306:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80130a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80130e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801312:	eb 0f                	jmp    801323 <strncmp+0x25>
		n--, p++, q++;
  801314:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801319:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80131e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801323:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801328:	74 1d                	je     801347 <strncmp+0x49>
  80132a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80132e:	0f b6 00             	movzbl (%rax),%eax
  801331:	84 c0                	test   %al,%al
  801333:	74 12                	je     801347 <strncmp+0x49>
  801335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801339:	0f b6 10             	movzbl (%rax),%edx
  80133c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801340:	0f b6 00             	movzbl (%rax),%eax
  801343:	38 c2                	cmp    %al,%dl
  801345:	74 cd                	je     801314 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801347:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80134c:	75 07                	jne    801355 <strncmp+0x57>
		return 0;
  80134e:	b8 00 00 00 00       	mov    $0x0,%eax
  801353:	eb 18                	jmp    80136d <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801359:	0f b6 00             	movzbl (%rax),%eax
  80135c:	0f b6 d0             	movzbl %al,%edx
  80135f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801363:	0f b6 00             	movzbl (%rax),%eax
  801366:	0f b6 c0             	movzbl %al,%eax
  801369:	29 c2                	sub    %eax,%edx
  80136b:	89 d0                	mov    %edx,%eax
}
  80136d:	c9                   	leaveq 
  80136e:	c3                   	retq   

000000000080136f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80136f:	55                   	push   %rbp
  801370:	48 89 e5             	mov    %rsp,%rbp
  801373:	48 83 ec 0c          	sub    $0xc,%rsp
  801377:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80137b:	89 f0                	mov    %esi,%eax
  80137d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801380:	eb 17                	jmp    801399 <strchr+0x2a>
		if (*s == c)
  801382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801386:	0f b6 00             	movzbl (%rax),%eax
  801389:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80138c:	75 06                	jne    801394 <strchr+0x25>
			return (char *) s;
  80138e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801392:	eb 15                	jmp    8013a9 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801394:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	0f b6 00             	movzbl (%rax),%eax
  8013a0:	84 c0                	test   %al,%al
  8013a2:	75 de                	jne    801382 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a9:	c9                   	leaveq 
  8013aa:	c3                   	retq   

00000000008013ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013ab:	55                   	push   %rbp
  8013ac:	48 89 e5             	mov    %rsp,%rbp
  8013af:	48 83 ec 0c          	sub    $0xc,%rsp
  8013b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013b7:	89 f0                	mov    %esi,%eax
  8013b9:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8013bc:	eb 13                	jmp    8013d1 <strfind+0x26>
		if (*s == c)
  8013be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013c2:	0f b6 00             	movzbl (%rax),%eax
  8013c5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8013c8:	75 02                	jne    8013cc <strfind+0x21>
			break;
  8013ca:	eb 10                	jmp    8013dc <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013d5:	0f b6 00             	movzbl (%rax),%eax
  8013d8:	84 c0                	test   %al,%al
  8013da:	75 e2                	jne    8013be <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8013dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013e0:	c9                   	leaveq 
  8013e1:	c3                   	retq   

00000000008013e2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013e2:	55                   	push   %rbp
  8013e3:	48 89 e5             	mov    %rsp,%rbp
  8013e6:	48 83 ec 18          	sub    $0x18,%rsp
  8013ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013ee:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8013f1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8013f5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013fa:	75 06                	jne    801402 <memset+0x20>
		return v;
  8013fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801400:	eb 69                	jmp    80146b <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801406:	83 e0 03             	and    $0x3,%eax
  801409:	48 85 c0             	test   %rax,%rax
  80140c:	75 48                	jne    801456 <memset+0x74>
  80140e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801412:	83 e0 03             	and    $0x3,%eax
  801415:	48 85 c0             	test   %rax,%rax
  801418:	75 3c                	jne    801456 <memset+0x74>
		c &= 0xFF;
  80141a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801421:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801424:	c1 e0 18             	shl    $0x18,%eax
  801427:	89 c2                	mov    %eax,%edx
  801429:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80142c:	c1 e0 10             	shl    $0x10,%eax
  80142f:	09 c2                	or     %eax,%edx
  801431:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801434:	c1 e0 08             	shl    $0x8,%eax
  801437:	09 d0                	or     %edx,%eax
  801439:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80143c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801440:	48 c1 e8 02          	shr    $0x2,%rax
  801444:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801447:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80144b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80144e:	48 89 d7             	mov    %rdx,%rdi
  801451:	fc                   	cld    
  801452:	f3 ab                	rep stos %eax,%es:(%rdi)
  801454:	eb 11                	jmp    801467 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801456:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80145a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80145d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801461:	48 89 d7             	mov    %rdx,%rdi
  801464:	fc                   	cld    
  801465:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801467:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80146b:	c9                   	leaveq 
  80146c:	c3                   	retq   

000000000080146d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80146d:	55                   	push   %rbp
  80146e:	48 89 e5             	mov    %rsp,%rbp
  801471:	48 83 ec 28          	sub    $0x28,%rsp
  801475:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801479:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80147d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801481:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801485:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801489:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801495:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801499:	0f 83 88 00 00 00    	jae    801527 <memmove+0xba>
  80149f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014a3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014a7:	48 01 d0             	add    %rdx,%rax
  8014aa:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8014ae:	76 77                	jbe    801527 <memmove+0xba>
		s += n;
  8014b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014b4:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8014b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bc:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c4:	83 e0 03             	and    $0x3,%eax
  8014c7:	48 85 c0             	test   %rax,%rax
  8014ca:	75 3b                	jne    801507 <memmove+0x9a>
  8014cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d0:	83 e0 03             	and    $0x3,%eax
  8014d3:	48 85 c0             	test   %rax,%rax
  8014d6:	75 2f                	jne    801507 <memmove+0x9a>
  8014d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014dc:	83 e0 03             	and    $0x3,%eax
  8014df:	48 85 c0             	test   %rax,%rax
  8014e2:	75 23                	jne    801507 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8014e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014e8:	48 83 e8 04          	sub    $0x4,%rax
  8014ec:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014f0:	48 83 ea 04          	sub    $0x4,%rdx
  8014f4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8014f8:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8014fc:	48 89 c7             	mov    %rax,%rdi
  8014ff:	48 89 d6             	mov    %rdx,%rsi
  801502:	fd                   	std    
  801503:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801505:	eb 1d                	jmp    801524 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801507:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80150f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801513:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801517:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80151b:	48 89 d7             	mov    %rdx,%rdi
  80151e:	48 89 c1             	mov    %rax,%rcx
  801521:	fd                   	std    
  801522:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801524:	fc                   	cld    
  801525:	eb 57                	jmp    80157e <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801527:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152b:	83 e0 03             	and    $0x3,%eax
  80152e:	48 85 c0             	test   %rax,%rax
  801531:	75 36                	jne    801569 <memmove+0xfc>
  801533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801537:	83 e0 03             	and    $0x3,%eax
  80153a:	48 85 c0             	test   %rax,%rax
  80153d:	75 2a                	jne    801569 <memmove+0xfc>
  80153f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801543:	83 e0 03             	and    $0x3,%eax
  801546:	48 85 c0             	test   %rax,%rax
  801549:	75 1e                	jne    801569 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80154b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154f:	48 c1 e8 02          	shr    $0x2,%rax
  801553:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801556:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80155a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80155e:	48 89 c7             	mov    %rax,%rdi
  801561:	48 89 d6             	mov    %rdx,%rsi
  801564:	fc                   	cld    
  801565:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801567:	eb 15                	jmp    80157e <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801571:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801575:	48 89 c7             	mov    %rax,%rdi
  801578:	48 89 d6             	mov    %rdx,%rsi
  80157b:	fc                   	cld    
  80157c:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80157e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801582:	c9                   	leaveq 
  801583:	c3                   	retq   

0000000000801584 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801584:	55                   	push   %rbp
  801585:	48 89 e5             	mov    %rsp,%rbp
  801588:	48 83 ec 18          	sub    $0x18,%rsp
  80158c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801590:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801594:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801598:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80159c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8015a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a4:	48 89 ce             	mov    %rcx,%rsi
  8015a7:	48 89 c7             	mov    %rax,%rdi
  8015aa:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  8015b1:	00 00 00 
  8015b4:	ff d0                	callq  *%rax
}
  8015b6:	c9                   	leaveq 
  8015b7:	c3                   	retq   

00000000008015b8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015b8:	55                   	push   %rbp
  8015b9:	48 89 e5             	mov    %rsp,%rbp
  8015bc:	48 83 ec 28          	sub    $0x28,%rsp
  8015c0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015c4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015c8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8015cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015d0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8015d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015d8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8015dc:	eb 36                	jmp    801614 <memcmp+0x5c>
		if (*s1 != *s2)
  8015de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e2:	0f b6 10             	movzbl (%rax),%edx
  8015e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015e9:	0f b6 00             	movzbl (%rax),%eax
  8015ec:	38 c2                	cmp    %al,%dl
  8015ee:	74 1a                	je     80160a <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8015f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f4:	0f b6 00             	movzbl (%rax),%eax
  8015f7:	0f b6 d0             	movzbl %al,%edx
  8015fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fe:	0f b6 00             	movzbl (%rax),%eax
  801601:	0f b6 c0             	movzbl %al,%eax
  801604:	29 c2                	sub    %eax,%edx
  801606:	89 d0                	mov    %edx,%eax
  801608:	eb 20                	jmp    80162a <memcmp+0x72>
		s1++, s2++;
  80160a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80160f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801618:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80161c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801620:	48 85 c0             	test   %rax,%rax
  801623:	75 b9                	jne    8015de <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162a:	c9                   	leaveq 
  80162b:	c3                   	retq   

000000000080162c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80162c:	55                   	push   %rbp
  80162d:	48 89 e5             	mov    %rsp,%rbp
  801630:	48 83 ec 28          	sub    $0x28,%rsp
  801634:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801638:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80163b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801647:	48 01 d0             	add    %rdx,%rax
  80164a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80164e:	eb 15                	jmp    801665 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801654:	0f b6 10             	movzbl (%rax),%edx
  801657:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80165a:	38 c2                	cmp    %al,%dl
  80165c:	75 02                	jne    801660 <memfind+0x34>
			break;
  80165e:	eb 0f                	jmp    80166f <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801660:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801669:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80166d:	72 e1                	jb     801650 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80166f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801673:	c9                   	leaveq 
  801674:	c3                   	retq   

0000000000801675 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801675:	55                   	push   %rbp
  801676:	48 89 e5             	mov    %rsp,%rbp
  801679:	48 83 ec 34          	sub    $0x34,%rsp
  80167d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801681:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801685:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801688:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80168f:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801696:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801697:	eb 05                	jmp    80169e <strtol+0x29>
		s++;
  801699:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80169e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a2:	0f b6 00             	movzbl (%rax),%eax
  8016a5:	3c 20                	cmp    $0x20,%al
  8016a7:	74 f0                	je     801699 <strtol+0x24>
  8016a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ad:	0f b6 00             	movzbl (%rax),%eax
  8016b0:	3c 09                	cmp    $0x9,%al
  8016b2:	74 e5                	je     801699 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016b8:	0f b6 00             	movzbl (%rax),%eax
  8016bb:	3c 2b                	cmp    $0x2b,%al
  8016bd:	75 07                	jne    8016c6 <strtol+0x51>
		s++;
  8016bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c4:	eb 17                	jmp    8016dd <strtol+0x68>
	else if (*s == '-')
  8016c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ca:	0f b6 00             	movzbl (%rax),%eax
  8016cd:	3c 2d                	cmp    $0x2d,%al
  8016cf:	75 0c                	jne    8016dd <strtol+0x68>
		s++, neg = 1;
  8016d1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016dd:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016e1:	74 06                	je     8016e9 <strtol+0x74>
  8016e3:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8016e7:	75 28                	jne    801711 <strtol+0x9c>
  8016e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ed:	0f b6 00             	movzbl (%rax),%eax
  8016f0:	3c 30                	cmp    $0x30,%al
  8016f2:	75 1d                	jne    801711 <strtol+0x9c>
  8016f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f8:	48 83 c0 01          	add    $0x1,%rax
  8016fc:	0f b6 00             	movzbl (%rax),%eax
  8016ff:	3c 78                	cmp    $0x78,%al
  801701:	75 0e                	jne    801711 <strtol+0x9c>
		s += 2, base = 16;
  801703:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801708:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80170f:	eb 2c                	jmp    80173d <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801711:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801715:	75 19                	jne    801730 <strtol+0xbb>
  801717:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80171b:	0f b6 00             	movzbl (%rax),%eax
  80171e:	3c 30                	cmp    $0x30,%al
  801720:	75 0e                	jne    801730 <strtol+0xbb>
		s++, base = 8;
  801722:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801727:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80172e:	eb 0d                	jmp    80173d <strtol+0xc8>
	else if (base == 0)
  801730:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801734:	75 07                	jne    80173d <strtol+0xc8>
		base = 10;
  801736:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80173d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801741:	0f b6 00             	movzbl (%rax),%eax
  801744:	3c 2f                	cmp    $0x2f,%al
  801746:	7e 1d                	jle    801765 <strtol+0xf0>
  801748:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80174c:	0f b6 00             	movzbl (%rax),%eax
  80174f:	3c 39                	cmp    $0x39,%al
  801751:	7f 12                	jg     801765 <strtol+0xf0>
			dig = *s - '0';
  801753:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801757:	0f b6 00             	movzbl (%rax),%eax
  80175a:	0f be c0             	movsbl %al,%eax
  80175d:	83 e8 30             	sub    $0x30,%eax
  801760:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801763:	eb 4e                	jmp    8017b3 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801765:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801769:	0f b6 00             	movzbl (%rax),%eax
  80176c:	3c 60                	cmp    $0x60,%al
  80176e:	7e 1d                	jle    80178d <strtol+0x118>
  801770:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801774:	0f b6 00             	movzbl (%rax),%eax
  801777:	3c 7a                	cmp    $0x7a,%al
  801779:	7f 12                	jg     80178d <strtol+0x118>
			dig = *s - 'a' + 10;
  80177b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177f:	0f b6 00             	movzbl (%rax),%eax
  801782:	0f be c0             	movsbl %al,%eax
  801785:	83 e8 57             	sub    $0x57,%eax
  801788:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80178b:	eb 26                	jmp    8017b3 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80178d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801791:	0f b6 00             	movzbl (%rax),%eax
  801794:	3c 40                	cmp    $0x40,%al
  801796:	7e 48                	jle    8017e0 <strtol+0x16b>
  801798:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80179c:	0f b6 00             	movzbl (%rax),%eax
  80179f:	3c 5a                	cmp    $0x5a,%al
  8017a1:	7f 3d                	jg     8017e0 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8017a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a7:	0f b6 00             	movzbl (%rax),%eax
  8017aa:	0f be c0             	movsbl %al,%eax
  8017ad:	83 e8 37             	sub    $0x37,%eax
  8017b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8017b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017b6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8017b9:	7c 02                	jl     8017bd <strtol+0x148>
			break;
  8017bb:	eb 23                	jmp    8017e0 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8017bd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017c2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8017c5:	48 98                	cltq   
  8017c7:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8017cc:	48 89 c2             	mov    %rax,%rdx
  8017cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017d2:	48 98                	cltq   
  8017d4:	48 01 d0             	add    %rdx,%rax
  8017d7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8017db:	e9 5d ff ff ff       	jmpq   80173d <strtol+0xc8>

	if (endptr)
  8017e0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8017e5:	74 0b                	je     8017f2 <strtol+0x17d>
		*endptr = (char *) s;
  8017e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017eb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8017ef:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8017f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017f6:	74 09                	je     801801 <strtol+0x18c>
  8017f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017fc:	48 f7 d8             	neg    %rax
  8017ff:	eb 04                	jmp    801805 <strtol+0x190>
  801801:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801805:	c9                   	leaveq 
  801806:	c3                   	retq   

0000000000801807 <strstr>:

char * strstr(const char *in, const char *str)
{
  801807:	55                   	push   %rbp
  801808:	48 89 e5             	mov    %rsp,%rbp
  80180b:	48 83 ec 30          	sub    $0x30,%rsp
  80180f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801813:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801817:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80181b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80181f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801823:	0f b6 00             	movzbl (%rax),%eax
  801826:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801829:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80182d:	75 06                	jne    801835 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80182f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801833:	eb 6b                	jmp    8018a0 <strstr+0x99>

	len = strlen(str);
  801835:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801839:	48 89 c7             	mov    %rax,%rdi
  80183c:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  801843:	00 00 00 
  801846:	ff d0                	callq  *%rax
  801848:	48 98                	cltq   
  80184a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80184e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801852:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801856:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80185a:	0f b6 00             	movzbl (%rax),%eax
  80185d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801860:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801864:	75 07                	jne    80186d <strstr+0x66>
				return (char *) 0;
  801866:	b8 00 00 00 00       	mov    $0x0,%eax
  80186b:	eb 33                	jmp    8018a0 <strstr+0x99>
		} while (sc != c);
  80186d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801871:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801874:	75 d8                	jne    80184e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801876:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80187a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80187e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801882:	48 89 ce             	mov    %rcx,%rsi
  801885:	48 89 c7             	mov    %rax,%rdi
  801888:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  80188f:	00 00 00 
  801892:	ff d0                	callq  *%rax
  801894:	85 c0                	test   %eax,%eax
  801896:	75 b6                	jne    80184e <strstr+0x47>

	return (char *) (in - 1);
  801898:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80189c:	48 83 e8 01          	sub    $0x1,%rax
}
  8018a0:	c9                   	leaveq 
  8018a1:	c3                   	retq   

00000000008018a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8018a2:	55                   	push   %rbp
  8018a3:	48 89 e5             	mov    %rsp,%rbp
  8018a6:	53                   	push   %rbx
  8018a7:	48 83 ec 48          	sub    $0x48,%rsp
  8018ab:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018ae:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8018b1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018b5:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8018b9:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8018bd:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  8018c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018c4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8018c8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8018cc:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8018d0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8018d4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8018d8:	4c 89 c3             	mov    %r8,%rbx
  8018db:	cd 30                	int    $0x30
  8018dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  8018e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8018e5:	74 3e                	je     801925 <syscall+0x83>
  8018e7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8018ec:	7e 37                	jle    801925 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018f5:	49 89 d0             	mov    %rdx,%r8
  8018f8:	89 c1                	mov    %eax,%ecx
  8018fa:	48 ba e8 4f 80 00 00 	movabs $0x804fe8,%rdx
  801901:	00 00 00 
  801904:	be 4a 00 00 00       	mov    $0x4a,%esi
  801909:	48 bf 05 50 80 00 00 	movabs $0x805005,%rdi
  801910:	00 00 00 
  801913:	b8 00 00 00 00       	mov    $0x0,%eax
  801918:	49 b9 5b 03 80 00 00 	movabs $0x80035b,%r9
  80191f:	00 00 00 
  801922:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  801925:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801929:	48 83 c4 48          	add    $0x48,%rsp
  80192d:	5b                   	pop    %rbx
  80192e:	5d                   	pop    %rbp
  80192f:	c3                   	retq   

0000000000801930 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801930:	55                   	push   %rbp
  801931:	48 89 e5             	mov    %rsp,%rbp
  801934:	48 83 ec 20          	sub    $0x20,%rsp
  801938:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80193c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801940:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801944:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801948:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80194f:	00 
  801950:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801956:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80195c:	48 89 d1             	mov    %rdx,%rcx
  80195f:	48 89 c2             	mov    %rax,%rdx
  801962:	be 00 00 00 00       	mov    $0x0,%esi
  801967:	bf 00 00 00 00       	mov    $0x0,%edi
  80196c:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  801973:	00 00 00 
  801976:	ff d0                	callq  *%rax
}
  801978:	c9                   	leaveq 
  801979:	c3                   	retq   

000000000080197a <sys_cgetc>:

int
sys_cgetc(void)
{
  80197a:	55                   	push   %rbp
  80197b:	48 89 e5             	mov    %rsp,%rbp
  80197e:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801982:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801989:	00 
  80198a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801990:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801996:	b9 00 00 00 00       	mov    $0x0,%ecx
  80199b:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a0:	be 00 00 00 00       	mov    $0x0,%esi
  8019a5:	bf 01 00 00 00       	mov    $0x1,%edi
  8019aa:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  8019b1:	00 00 00 
  8019b4:	ff d0                	callq  *%rax
}
  8019b6:	c9                   	leaveq 
  8019b7:	c3                   	retq   

00000000008019b8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8019b8:	55                   	push   %rbp
  8019b9:	48 89 e5             	mov    %rsp,%rbp
  8019bc:	48 83 ec 10          	sub    $0x10,%rsp
  8019c0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8019c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c6:	48 98                	cltq   
  8019c8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019cf:	00 
  8019d0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019d6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019e1:	48 89 c2             	mov    %rax,%rdx
  8019e4:	be 01 00 00 00       	mov    $0x1,%esi
  8019e9:	bf 03 00 00 00       	mov    $0x3,%edi
  8019ee:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  8019f5:	00 00 00 
  8019f8:	ff d0                	callq  *%rax
}
  8019fa:	c9                   	leaveq 
  8019fb:	c3                   	retq   

00000000008019fc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8019fc:	55                   	push   %rbp
  8019fd:	48 89 e5             	mov    %rsp,%rbp
  801a00:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801a04:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a0b:	00 
  801a0c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a12:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a18:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a22:	be 00 00 00 00       	mov    $0x0,%esi
  801a27:	bf 02 00 00 00       	mov    $0x2,%edi
  801a2c:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  801a33:	00 00 00 
  801a36:	ff d0                	callq  *%rax
}
  801a38:	c9                   	leaveq 
  801a39:	c3                   	retq   

0000000000801a3a <sys_yield>:

void
sys_yield(void)
{
  801a3a:	55                   	push   %rbp
  801a3b:	48 89 e5             	mov    %rsp,%rbp
  801a3e:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801a42:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a49:	00 
  801a4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a56:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a60:	be 00 00 00 00       	mov    $0x0,%esi
  801a65:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a6a:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  801a71:	00 00 00 
  801a74:	ff d0                	callq  *%rax
}
  801a76:	c9                   	leaveq 
  801a77:	c3                   	retq   

0000000000801a78 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a78:	55                   	push   %rbp
  801a79:	48 89 e5             	mov    %rsp,%rbp
  801a7c:	48 83 ec 20          	sub    $0x20,%rsp
  801a80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a83:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a87:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a8a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a8d:	48 63 c8             	movslq %eax,%rcx
  801a90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a97:	48 98                	cltq   
  801a99:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801aa0:	00 
  801aa1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aa7:	49 89 c8             	mov    %rcx,%r8
  801aaa:	48 89 d1             	mov    %rdx,%rcx
  801aad:	48 89 c2             	mov    %rax,%rdx
  801ab0:	be 01 00 00 00       	mov    $0x1,%esi
  801ab5:	bf 04 00 00 00       	mov    $0x4,%edi
  801aba:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  801ac1:	00 00 00 
  801ac4:	ff d0                	callq  *%rax
}
  801ac6:	c9                   	leaveq 
  801ac7:	c3                   	retq   

0000000000801ac8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801ac8:	55                   	push   %rbp
  801ac9:	48 89 e5             	mov    %rsp,%rbp
  801acc:	48 83 ec 30          	sub    $0x30,%rsp
  801ad0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ad3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ad7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ada:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ade:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ae2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ae5:	48 63 c8             	movslq %eax,%rcx
  801ae8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801aec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aef:	48 63 f0             	movslq %eax,%rsi
  801af2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801af6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af9:	48 98                	cltq   
  801afb:	48 89 0c 24          	mov    %rcx,(%rsp)
  801aff:	49 89 f9             	mov    %rdi,%r9
  801b02:	49 89 f0             	mov    %rsi,%r8
  801b05:	48 89 d1             	mov    %rdx,%rcx
  801b08:	48 89 c2             	mov    %rax,%rdx
  801b0b:	be 01 00 00 00       	mov    $0x1,%esi
  801b10:	bf 05 00 00 00       	mov    $0x5,%edi
  801b15:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  801b1c:	00 00 00 
  801b1f:	ff d0                	callq  *%rax
}
  801b21:	c9                   	leaveq 
  801b22:	c3                   	retq   

0000000000801b23 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801b23:	55                   	push   %rbp
  801b24:	48 89 e5             	mov    %rsp,%rbp
  801b27:	48 83 ec 20          	sub    $0x20,%rsp
  801b2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801b32:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b39:	48 98                	cltq   
  801b3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b42:	00 
  801b43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b4f:	48 89 d1             	mov    %rdx,%rcx
  801b52:	48 89 c2             	mov    %rax,%rdx
  801b55:	be 01 00 00 00       	mov    $0x1,%esi
  801b5a:	bf 06 00 00 00       	mov    $0x6,%edi
  801b5f:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  801b66:	00 00 00 
  801b69:	ff d0                	callq  *%rax
}
  801b6b:	c9                   	leaveq 
  801b6c:	c3                   	retq   

0000000000801b6d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	48 83 ec 10          	sub    $0x10,%rsp
  801b75:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b78:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b7b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b7e:	48 63 d0             	movslq %eax,%rdx
  801b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b84:	48 98                	cltq   
  801b86:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b8d:	00 
  801b8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b9a:	48 89 d1             	mov    %rdx,%rcx
  801b9d:	48 89 c2             	mov    %rax,%rdx
  801ba0:	be 01 00 00 00       	mov    $0x1,%esi
  801ba5:	bf 08 00 00 00       	mov    $0x8,%edi
  801baa:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  801bb1:	00 00 00 
  801bb4:	ff d0                	callq  *%rax
}
  801bb6:	c9                   	leaveq 
  801bb7:	c3                   	retq   

0000000000801bb8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801bb8:	55                   	push   %rbp
  801bb9:	48 89 e5             	mov    %rsp,%rbp
  801bbc:	48 83 ec 20          	sub    $0x20,%rsp
  801bc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bc3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801bc7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bce:	48 98                	cltq   
  801bd0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bd7:	00 
  801bd8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bde:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801be4:	48 89 d1             	mov    %rdx,%rcx
  801be7:	48 89 c2             	mov    %rax,%rdx
  801bea:	be 01 00 00 00       	mov    $0x1,%esi
  801bef:	bf 09 00 00 00       	mov    $0x9,%edi
  801bf4:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  801bfb:	00 00 00 
  801bfe:	ff d0                	callq  *%rax
}
  801c00:	c9                   	leaveq 
  801c01:	c3                   	retq   

0000000000801c02 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801c02:	55                   	push   %rbp
  801c03:	48 89 e5             	mov    %rsp,%rbp
  801c06:	48 83 ec 20          	sub    $0x20,%rsp
  801c0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801c11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c18:	48 98                	cltq   
  801c1a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c21:	00 
  801c22:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c28:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2e:	48 89 d1             	mov    %rdx,%rcx
  801c31:	48 89 c2             	mov    %rax,%rdx
  801c34:	be 01 00 00 00       	mov    $0x1,%esi
  801c39:	bf 0a 00 00 00       	mov    $0xa,%edi
  801c3e:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  801c45:	00 00 00 
  801c48:	ff d0                	callq  *%rax
}
  801c4a:	c9                   	leaveq 
  801c4b:	c3                   	retq   

0000000000801c4c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801c4c:	55                   	push   %rbp
  801c4d:	48 89 e5             	mov    %rsp,%rbp
  801c50:	48 83 ec 20          	sub    $0x20,%rsp
  801c54:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c57:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c5b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c5f:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c62:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c65:	48 63 f0             	movslq %eax,%rsi
  801c68:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c6f:	48 98                	cltq   
  801c71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c75:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c7c:	00 
  801c7d:	49 89 f1             	mov    %rsi,%r9
  801c80:	49 89 c8             	mov    %rcx,%r8
  801c83:	48 89 d1             	mov    %rdx,%rcx
  801c86:	48 89 c2             	mov    %rax,%rdx
  801c89:	be 00 00 00 00       	mov    $0x0,%esi
  801c8e:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c93:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  801c9a:	00 00 00 
  801c9d:	ff d0                	callq  *%rax
}
  801c9f:	c9                   	leaveq 
  801ca0:	c3                   	retq   

0000000000801ca1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ca1:	55                   	push   %rbp
  801ca2:	48 89 e5             	mov    %rsp,%rbp
  801ca5:	48 83 ec 10          	sub    $0x10,%rsp
  801ca9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801cad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cb8:	00 
  801cb9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cbf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cca:	48 89 c2             	mov    %rax,%rdx
  801ccd:	be 01 00 00 00       	mov    $0x1,%esi
  801cd2:	bf 0d 00 00 00       	mov    $0xd,%edi
  801cd7:	48 b8 a2 18 80 00 00 	movabs $0x8018a2,%rax
  801cde:	00 00 00 
  801ce1:	ff d0                	callq  *%rax
}
  801ce3:	c9                   	leaveq 
  801ce4:	c3                   	retq   

0000000000801ce5 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ce5:	55                   	push   %rbp
  801ce6:	48 89 e5             	mov    %rsp,%rbp
  801ce9:	53                   	push   %rbx
  801cea:	48 83 ec 48          	sub    $0x48,%rsp
  801cee:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801cf2:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801cf6:	48 8b 00             	mov    (%rax),%rax
  801cf9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	uint32_t err = utf->utf_err;
  801cfd:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801d01:	48 8b 40 08          	mov    0x8(%rax),%rax
  801d05:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	pte_t pte = uvpt[VPN(addr)];
  801d08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d0c:	48 c1 e8 0c          	shr    $0xc,%rax
  801d10:	48 89 c2             	mov    %rax,%rdx
  801d13:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d1a:	01 00 00 
  801d1d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d21:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	envid_t pid = sys_getenvid();
  801d25:	48 b8 fc 19 80 00 00 	movabs $0x8019fc,%rax
  801d2c:	00 00 00 
  801d2f:	ff d0                	callq  *%rax
  801d31:	89 45 d4             	mov    %eax,-0x2c(%rbp)
	void* va = ROUNDDOWN(addr, PGSIZE);
  801d34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d38:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  801d3c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d40:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801d46:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
	if((err & FEC_WR) && (pte & PTE_COW)){
  801d4a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d4d:	83 e0 02             	and    $0x2,%eax
  801d50:	85 c0                	test   %eax,%eax
  801d52:	0f 84 8d 00 00 00    	je     801de5 <pgfault+0x100>
  801d58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d5c:	25 00 08 00 00       	and    $0x800,%eax
  801d61:	48 85 c0             	test   %rax,%rax
  801d64:	74 7f                	je     801de5 <pgfault+0x100>
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
  801d66:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801d69:	ba 07 00 00 00       	mov    $0x7,%edx
  801d6e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801d73:	89 c7                	mov    %eax,%edi
  801d75:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  801d7c:	00 00 00 
  801d7f:	ff d0                	callq  *%rax
  801d81:	85 c0                	test   %eax,%eax
  801d83:	75 60                	jne    801de5 <pgfault+0x100>
			memmove(PFTEMP, va, PGSIZE);
  801d85:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801d89:	ba 00 10 00 00       	mov    $0x1000,%edx
  801d8e:	48 89 c6             	mov    %rax,%rsi
  801d91:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801d96:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  801d9d:	00 00 00 
  801da0:	ff d0                	callq  *%rax
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801da2:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  801da6:	8b 55 d4             	mov    -0x2c(%rbp),%edx
  801da9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801dac:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  801db2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801db7:	89 c7                	mov    %eax,%edi
  801db9:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801dc0:	00 00 00 
  801dc3:	ff d0                	callq  *%rax
  801dc5:	89 c3                	mov    %eax,%ebx
					 sys_page_unmap(pid, (void*) PFTEMP)))
  801dc7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801dca:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801dcf:	89 c7                	mov    %eax,%edi
  801dd1:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  801dd8:	00 00 00 
  801ddb:	ff d0                	callq  *%rax
	envid_t pid = sys_getenvid();
	void* va = ROUNDDOWN(addr, PGSIZE);
	if((err & FEC_WR) && (pte & PTE_COW)){
		if(!sys_page_alloc(pid, (void*)PFTEMP, PTE_P | PTE_W | PTE_U)){
			memmove(PFTEMP, va, PGSIZE);
			if(!(sys_page_map(pid, (void*)PFTEMP, pid, va, PTE_P | PTE_W | PTE_U) | 
  801ddd:	09 d8                	or     %ebx,%eax
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	75 02                	jne    801de5 <pgfault+0x100>
					 sys_page_unmap(pid, (void*) PFTEMP)))
					return;
  801de3:	eb 2a                	jmp    801e0f <pgfault+0x12a>
		}
	}
	panic("Page fault handler failure\n");
  801de5:	48 ba 13 50 80 00 00 	movabs $0x805013,%rdx
  801dec:	00 00 00 
  801def:	be 26 00 00 00       	mov    $0x26,%esi
  801df4:	48 bf 2f 50 80 00 00 	movabs $0x80502f,%rdi
  801dfb:	00 00 00 
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801e03:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  801e0a:	00 00 00 
  801e0d:	ff d1                	callq  *%rcx
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.

	//panic("pgfault not implemented");
}
  801e0f:	48 83 c4 48          	add    $0x48,%rsp
  801e13:	5b                   	pop    %rbx
  801e14:	5d                   	pop    %rbp
  801e15:	c3                   	retq   

0000000000801e16 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801e16:	55                   	push   %rbp
  801e17:	48 89 e5             	mov    %rsp,%rbp
  801e1a:	53                   	push   %rbx
  801e1b:	48 83 ec 38          	sub    $0x38,%rsp
  801e1f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801e22:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	//struct Env *env;
	pte_t pte = uvpt[pn];
  801e25:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e2c:	01 00 00 
  801e2f:	8b 55 c8             	mov    -0x38(%rbp),%edx
  801e32:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e36:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	int perm = pte & PTE_SYSCALL;
  801e3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e3e:	25 07 0e 00 00       	and    $0xe07,%eax
  801e43:	89 45 dc             	mov    %eax,-0x24(%rbp)
	void *va = (void*)((uintptr_t)pn * PGSIZE);
  801e46:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801e49:	48 c1 e0 0c          	shl    $0xc,%rax
  801e4d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	if(perm & PTE_SHARE){
  801e51:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e54:	25 00 04 00 00       	and    $0x400,%eax
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	74 30                	je     801e8d <duppage+0x77>
		r = sys_page_map(0, va, envid, va, perm);
  801e5d:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801e60:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801e64:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801e67:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801e6b:	41 89 f0             	mov    %esi,%r8d
  801e6e:	48 89 c6             	mov    %rax,%rsi
  801e71:	bf 00 00 00 00       	mov    $0x0,%edi
  801e76:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801e7d:	00 00 00 
  801e80:	ff d0                	callq  *%rax
  801e82:	89 45 ec             	mov    %eax,-0x14(%rbp)
		return r;
  801e85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801e88:	e9 a4 00 00 00       	jmpq   801f31 <duppage+0x11b>
	}
	//envid_t pid = sys_getenvid();
	if((perm & PTE_W) || (perm & PTE_COW)){
  801e8d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e90:	83 e0 02             	and    $0x2,%eax
  801e93:	85 c0                	test   %eax,%eax
  801e95:	75 0c                	jne    801ea3 <duppage+0x8d>
  801e97:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801e9a:	25 00 08 00 00       	and    $0x800,%eax
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	74 63                	je     801f06 <duppage+0xf0>
		perm &= ~PTE_W;
  801ea3:	83 65 dc fd          	andl   $0xfffffffd,-0x24(%rbp)
		perm |= PTE_COW;
  801ea7:	81 4d dc 00 08 00 00 	orl    $0x800,-0x24(%rbp)
		r = sys_page_map(0, va, envid, va, perm) | sys_page_map(0, va, 0, va, perm);
  801eae:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801eb1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801eb5:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801eb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ebc:	41 89 f0             	mov    %esi,%r8d
  801ebf:	48 89 c6             	mov    %rax,%rsi
  801ec2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec7:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801ece:	00 00 00 
  801ed1:	ff d0                	callq  *%rax
  801ed3:	89 c3                	mov    %eax,%ebx
  801ed5:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801ed8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801edc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ee0:	41 89 c8             	mov    %ecx,%r8d
  801ee3:	48 89 d1             	mov    %rdx,%rcx
  801ee6:	ba 00 00 00 00       	mov    $0x0,%edx
  801eeb:	48 89 c6             	mov    %rax,%rsi
  801eee:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef3:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801efa:	00 00 00 
  801efd:	ff d0                	callq  *%rax
  801eff:	09 d8                	or     %ebx,%eax
  801f01:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f04:	eb 28                	jmp    801f2e <duppage+0x118>
	}
	else{
		r = sys_page_map(0, va, envid, va, perm);
  801f06:	8b 75 dc             	mov    -0x24(%rbp),%esi
  801f09:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801f0d:	8b 55 cc             	mov    -0x34(%rbp),%edx
  801f10:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f14:	41 89 f0             	mov    %esi,%r8d
  801f17:	48 89 c6             	mov    %rax,%rsi
  801f1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1f:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  801f26:	00 00 00 
  801f29:	ff d0                	callq  *%rax
  801f2b:	89 45 ec             	mov    %eax,-0x14(%rbp)
	}

	// LAB 4: Your code here.
	//panic("duppage not implemented");
	//if(r != 0) panic("Duplicating page failed: %e\n", r);
	return r;
  801f2e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  801f31:	48 83 c4 38          	add    $0x38,%rsp
  801f35:	5b                   	pop    %rbx
  801f36:	5d                   	pop    %rbp
  801f37:	c3                   	retq   

0000000000801f38 <fork>:
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  801f38:	55                   	push   %rbp
  801f39:	48 89 e5             	mov    %rsp,%rbp
  801f3c:	53                   	push   %rbx
  801f3d:	48 83 ec 58          	sub    $0x58,%rsp
	// LAB 4: Your code here.
	extern void _pgfault_upcall(void);
	set_pgfault_handler(pgfault);
  801f41:	48 bf e5 1c 80 00 00 	movabs $0x801ce5,%rdi
  801f48:	00 00 00 
  801f4b:	48 b8 8c 46 80 00 00 	movabs $0x80468c,%rax
  801f52:	00 00 00 
  801f55:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801f57:	b8 07 00 00 00       	mov    $0x7,%eax
  801f5c:	cd 30                	int    $0x30
  801f5e:	89 45 a4             	mov    %eax,-0x5c(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  801f61:	8b 45 a4             	mov    -0x5c(%rbp),%eax
	envid_t cid = sys_exofork();
  801f64:	89 45 cc             	mov    %eax,-0x34(%rbp)
	if(cid < 0) panic("fork failed: %e\n", cid);
  801f67:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801f6b:	79 30                	jns    801f9d <fork+0x65>
  801f6d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f70:	89 c1                	mov    %eax,%ecx
  801f72:	48 ba 3a 50 80 00 00 	movabs $0x80503a,%rdx
  801f79:	00 00 00 
  801f7c:	be 72 00 00 00       	mov    $0x72,%esi
  801f81:	48 bf 2f 50 80 00 00 	movabs $0x80502f,%rdi
  801f88:	00 00 00 
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f90:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  801f97:	00 00 00 
  801f9a:	41 ff d0             	callq  *%r8
	if(cid == 0){
  801f9d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801fa1:	75 46                	jne    801fe9 <fork+0xb1>
		thisenv = &envs[ENVX(sys_getenvid())];
  801fa3:	48 b8 fc 19 80 00 00 	movabs $0x8019fc,%rax
  801faa:	00 00 00 
  801fad:	ff d0                	callq  *%rax
  801faf:	25 ff 03 00 00       	and    $0x3ff,%eax
  801fb4:	48 63 d0             	movslq %eax,%rdx
  801fb7:	48 89 d0             	mov    %rdx,%rax
  801fba:	48 c1 e0 03          	shl    $0x3,%rax
  801fbe:	48 01 d0             	add    %rdx,%rax
  801fc1:	48 c1 e0 05          	shl    $0x5,%rax
  801fc5:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  801fcc:	00 00 00 
  801fcf:	48 01 c2             	add    %rax,%rdx
  801fd2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  801fd9:	00 00 00 
  801fdc:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	e9 12 02 00 00       	jmpq   8021fb <fork+0x2c3>
	}
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801fe9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801fec:	ba 07 00 00 00       	mov    $0x7,%edx
  801ff1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  801ff6:	89 c7                	mov    %eax,%edi
  801ff8:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  801fff:	00 00 00 
  802002:	ff d0                	callq  *%rax
  802004:	89 45 c8             	mov    %eax,-0x38(%rbp)
  802007:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
  80200b:	79 30                	jns    80203d <fork+0x105>
		panic("fork failed: %e\n", result);
  80200d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802010:	89 c1                	mov    %eax,%ecx
  802012:	48 ba 3a 50 80 00 00 	movabs $0x80503a,%rdx
  802019:	00 00 00 
  80201c:	be 79 00 00 00       	mov    $0x79,%esi
  802021:	48 bf 2f 50 80 00 00 	movabs $0x80502f,%rdi
  802028:	00 00 00 
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
  802030:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  802037:	00 00 00 
  80203a:	41 ff d0             	callq  *%r8
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  80203d:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802044:	00 
  802045:	e9 40 01 00 00       	jmpq   80218a <fork+0x252>
		if(uvpml4e[pml4e] & PTE_P){
  80204a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802051:	01 00 00 
  802054:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802058:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80205c:	83 e0 01             	and    $0x1,%eax
  80205f:	48 85 c0             	test   %rax,%rax
  802062:	0f 84 1d 01 00 00    	je     802185 <fork+0x24d>
			base_pml4e = pml4e * NPDPENTRIES;
  802068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206c:	48 c1 e0 09          	shl    $0x9,%rax
  802070:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  802074:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  80207b:	00 
  80207c:	e9 f6 00 00 00       	jmpq   802177 <fork+0x23f>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  802081:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802085:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  802089:	48 01 c2             	add    %rax,%rdx
  80208c:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802093:	01 00 00 
  802096:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80209a:	83 e0 01             	and    $0x1,%eax
  80209d:	48 85 c0             	test   %rax,%rax
  8020a0:	0f 84 cc 00 00 00    	je     802172 <fork+0x23a>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  8020a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020aa:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8020ae:	48 01 d0             	add    %rdx,%rax
  8020b1:	48 c1 e0 09          	shl    $0x9,%rax
  8020b5:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  8020b9:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  8020c0:	00 
  8020c1:	e9 9e 00 00 00       	jmpq   802164 <fork+0x22c>
						if(uvpd[base_pdpe + pde] & PTE_P){
  8020c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ca:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8020ce:	48 01 c2             	add    %rax,%rdx
  8020d1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020d8:	01 00 00 
  8020db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020df:	83 e0 01             	and    $0x1,%eax
  8020e2:	48 85 c0             	test   %rax,%rax
  8020e5:	74 78                	je     80215f <fork+0x227>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  8020e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020eb:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8020ef:	48 01 d0             	add    %rdx,%rax
  8020f2:	48 c1 e0 09          	shl    $0x9,%rax
  8020f6:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  8020fa:	48 c7 45 d0 00 00 00 	movq   $0x0,-0x30(%rbp)
  802101:	00 
  802102:	eb 51                	jmp    802155 <fork+0x21d>
								entry = base_pde + pte;
  802104:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802108:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80210c:	48 01 d0             	add    %rdx,%rax
  80210f:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
								if((uvpt[entry] & PTE_P) && (entry != VPN(UXSTACKTOP - PGSIZE))){
  802113:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80211a:	01 00 00 
  80211d:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  802121:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802125:	83 e0 01             	and    $0x1,%eax
  802128:	48 85 c0             	test   %rax,%rax
  80212b:	74 23                	je     802150 <fork+0x218>
  80212d:	48 81 7d a8 ff f7 0e 	cmpq   $0xef7ff,-0x58(%rbp)
  802134:	00 
  802135:	74 19                	je     802150 <fork+0x218>
									duppage(cid, entry);
  802137:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80213b:	89 c2                	mov    %eax,%edx
  80213d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802140:	89 d6                	mov    %edx,%esi
  802142:	89 c7                	mov    %eax,%edi
  802144:	48 b8 16 1e 80 00 00 	movabs $0x801e16,%rax
  80214b:	00 00 00 
  80214e:	ff d0                	callq  *%rax
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  802150:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
  802155:	48 81 7d d0 ff 01 00 	cmpq   $0x1ff,-0x30(%rbp)
  80215c:	00 
  80215d:	76 a5                	jbe    802104 <fork+0x1cc>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  80215f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802164:	48 81 7d d8 ff 01 00 	cmpq   $0x1ff,-0x28(%rbp)
  80216b:	00 
  80216c:	0f 86 54 ff ff ff    	jbe    8020c6 <fork+0x18e>
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  802172:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  802177:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  80217e:	00 
  80217f:	0f 86 fc fe ff ff    	jbe    802081 <fork+0x149>
	int result;
	if((result = sys_page_alloc(cid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		panic("fork failed: %e\n", result);
	
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  802185:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80218a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80218f:	0f 84 b5 fe ff ff    	je     80204a <fork+0x112>
					}
				}
			}
		}
	}
	if(sys_env_set_pgfault_upcall(cid, _pgfault_upcall) | sys_env_set_status(cid, ENV_RUNNABLE))
  802195:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802198:	48 be 21 47 80 00 00 	movabs $0x804721,%rsi
  80219f:	00 00 00 
  8021a2:	89 c7                	mov    %eax,%edi
  8021a4:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  8021ab:	00 00 00 
  8021ae:	ff d0                	callq  *%rax
  8021b0:	89 c3                	mov    %eax,%ebx
  8021b2:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021b5:	be 02 00 00 00       	mov    $0x2,%esi
  8021ba:	89 c7                	mov    %eax,%edi
  8021bc:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  8021c3:	00 00 00 
  8021c6:	ff d0                	callq  *%rax
  8021c8:	09 d8                	or     %ebx,%eax
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	74 2a                	je     8021f8 <fork+0x2c0>
		panic("fork failed\n");
  8021ce:	48 ba 4b 50 80 00 00 	movabs $0x80504b,%rdx
  8021d5:	00 00 00 
  8021d8:	be 92 00 00 00       	mov    $0x92,%esi
  8021dd:	48 bf 2f 50 80 00 00 	movabs $0x80502f,%rdi
  8021e4:	00 00 00 
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ec:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  8021f3:	00 00 00 
  8021f6:	ff d1                	callq  *%rcx
	return cid;
  8021f8:	8b 45 cc             	mov    -0x34(%rbp),%eax
	//panic("fork not implemented");
}
  8021fb:	48 83 c4 58          	add    $0x58,%rsp
  8021ff:	5b                   	pop    %rbx
  802200:	5d                   	pop    %rbp
  802201:	c3                   	retq   

0000000000802202 <sfork>:


// Challenge!
int
sfork(void)
{
  802202:	55                   	push   %rbp
  802203:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802206:	48 ba 58 50 80 00 00 	movabs $0x805058,%rdx
  80220d:	00 00 00 
  802210:	be 9c 00 00 00       	mov    $0x9c,%esi
  802215:	48 bf 2f 50 80 00 00 	movabs $0x80502f,%rdi
  80221c:	00 00 00 
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
  802224:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  80222b:	00 00 00 
  80222e:	ff d1                	callq  *%rcx

0000000000802230 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802230:	55                   	push   %rbp
  802231:	48 89 e5             	mov    %rsp,%rbp
  802234:	48 83 ec 08          	sub    $0x8,%rsp
  802238:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80223c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802240:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802247:	ff ff ff 
  80224a:	48 01 d0             	add    %rdx,%rax
  80224d:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802251:	c9                   	leaveq 
  802252:	c3                   	retq   

0000000000802253 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802253:	55                   	push   %rbp
  802254:	48 89 e5             	mov    %rsp,%rbp
  802257:	48 83 ec 08          	sub    $0x8,%rsp
  80225b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80225f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802263:	48 89 c7             	mov    %rax,%rdi
  802266:	48 b8 30 22 80 00 00 	movabs $0x802230,%rax
  80226d:	00 00 00 
  802270:	ff d0                	callq  *%rax
  802272:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802278:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80227c:	c9                   	leaveq 
  80227d:	c3                   	retq   

000000000080227e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80227e:	55                   	push   %rbp
  80227f:	48 89 e5             	mov    %rsp,%rbp
  802282:	48 83 ec 18          	sub    $0x18,%rsp
  802286:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80228a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802291:	eb 6b                	jmp    8022fe <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802293:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802296:	48 98                	cltq   
  802298:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80229e:	48 c1 e0 0c          	shl    $0xc,%rax
  8022a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8022a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022aa:	48 c1 e8 15          	shr    $0x15,%rax
  8022ae:	48 89 c2             	mov    %rax,%rdx
  8022b1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8022b8:	01 00 00 
  8022bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022bf:	83 e0 01             	and    $0x1,%eax
  8022c2:	48 85 c0             	test   %rax,%rax
  8022c5:	74 21                	je     8022e8 <fd_alloc+0x6a>
  8022c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022cb:	48 c1 e8 0c          	shr    $0xc,%rax
  8022cf:	48 89 c2             	mov    %rax,%rdx
  8022d2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022d9:	01 00 00 
  8022dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022e0:	83 e0 01             	and    $0x1,%eax
  8022e3:	48 85 c0             	test   %rax,%rax
  8022e6:	75 12                	jne    8022fa <fd_alloc+0x7c>
			*fd_store = fd;
  8022e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022f0:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f8:	eb 1a                	jmp    802314 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8022fa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022fe:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802302:	7e 8f                	jle    802293 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802308:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80230f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802314:	c9                   	leaveq 
  802315:	c3                   	retq   

0000000000802316 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802316:	55                   	push   %rbp
  802317:	48 89 e5             	mov    %rsp,%rbp
  80231a:	48 83 ec 20          	sub    $0x20,%rsp
  80231e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802321:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802325:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802329:	78 06                	js     802331 <fd_lookup+0x1b>
  80232b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80232f:	7e 07                	jle    802338 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802331:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802336:	eb 6c                	jmp    8023a4 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802338:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80233b:	48 98                	cltq   
  80233d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802343:	48 c1 e0 0c          	shl    $0xc,%rax
  802347:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80234b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80234f:	48 c1 e8 15          	shr    $0x15,%rax
  802353:	48 89 c2             	mov    %rax,%rdx
  802356:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80235d:	01 00 00 
  802360:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802364:	83 e0 01             	and    $0x1,%eax
  802367:	48 85 c0             	test   %rax,%rax
  80236a:	74 21                	je     80238d <fd_lookup+0x77>
  80236c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802370:	48 c1 e8 0c          	shr    $0xc,%rax
  802374:	48 89 c2             	mov    %rax,%rdx
  802377:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80237e:	01 00 00 
  802381:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802385:	83 e0 01             	and    $0x1,%eax
  802388:	48 85 c0             	test   %rax,%rax
  80238b:	75 07                	jne    802394 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80238d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802392:	eb 10                	jmp    8023a4 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802394:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802398:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80239c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80239f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a4:	c9                   	leaveq 
  8023a5:	c3                   	retq   

00000000008023a6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8023a6:	55                   	push   %rbp
  8023a7:	48 89 e5             	mov    %rsp,%rbp
  8023aa:	48 83 ec 30          	sub    $0x30,%rsp
  8023ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8023b2:	89 f0                	mov    %esi,%eax
  8023b4:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8023b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023bb:	48 89 c7             	mov    %rax,%rdi
  8023be:	48 b8 30 22 80 00 00 	movabs $0x802230,%rax
  8023c5:	00 00 00 
  8023c8:	ff d0                	callq  *%rax
  8023ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ce:	48 89 d6             	mov    %rdx,%rsi
  8023d1:	89 c7                	mov    %eax,%edi
  8023d3:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  8023da:	00 00 00 
  8023dd:	ff d0                	callq  *%rax
  8023df:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e6:	78 0a                	js     8023f2 <fd_close+0x4c>
	    || fd != fd2)
  8023e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ec:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8023f0:	74 12                	je     802404 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8023f2:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8023f6:	74 05                	je     8023fd <fd_close+0x57>
  8023f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023fb:	eb 05                	jmp    802402 <fd_close+0x5c>
  8023fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802402:	eb 69                	jmp    80246d <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802404:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802408:	8b 00                	mov    (%rax),%eax
  80240a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80240e:	48 89 d6             	mov    %rdx,%rsi
  802411:	89 c7                	mov    %eax,%edi
  802413:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  80241a:	00 00 00 
  80241d:	ff d0                	callq  *%rax
  80241f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802422:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802426:	78 2a                	js     802452 <fd_close+0xac>
		if (dev->dev_close)
  802428:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242c:	48 8b 40 20          	mov    0x20(%rax),%rax
  802430:	48 85 c0             	test   %rax,%rax
  802433:	74 16                	je     80244b <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802435:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802439:	48 8b 40 20          	mov    0x20(%rax),%rax
  80243d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802441:	48 89 d7             	mov    %rdx,%rdi
  802444:	ff d0                	callq  *%rax
  802446:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802449:	eb 07                	jmp    802452 <fd_close+0xac>
		else
			r = 0;
  80244b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802452:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802456:	48 89 c6             	mov    %rax,%rsi
  802459:	bf 00 00 00 00       	mov    $0x0,%edi
  80245e:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  802465:	00 00 00 
  802468:	ff d0                	callq  *%rax
	return r;
  80246a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80246d:	c9                   	leaveq 
  80246e:	c3                   	retq   

000000000080246f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80246f:	55                   	push   %rbp
  802470:	48 89 e5             	mov    %rsp,%rbp
  802473:	48 83 ec 20          	sub    $0x20,%rsp
  802477:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80247a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80247e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802485:	eb 41                	jmp    8024c8 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802487:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80248e:	00 00 00 
  802491:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802494:	48 63 d2             	movslq %edx,%rdx
  802497:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80249b:	8b 00                	mov    (%rax),%eax
  80249d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8024a0:	75 22                	jne    8024c4 <dev_lookup+0x55>
			*dev = devtab[i];
  8024a2:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8024a9:	00 00 00 
  8024ac:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024af:	48 63 d2             	movslq %edx,%rdx
  8024b2:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8024b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024ba:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8024bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c2:	eb 60                	jmp    802524 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8024c4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024c8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8024cf:	00 00 00 
  8024d2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024d5:	48 63 d2             	movslq %edx,%rdx
  8024d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024dc:	48 85 c0             	test   %rax,%rax
  8024df:	75 a6                	jne    802487 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8024e1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024e8:	00 00 00 
  8024eb:	48 8b 00             	mov    (%rax),%rax
  8024ee:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024f7:	89 c6                	mov    %eax,%esi
  8024f9:	48 bf 70 50 80 00 00 	movabs $0x805070,%rdi
  802500:	00 00 00 
  802503:	b8 00 00 00 00       	mov    $0x0,%eax
  802508:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  80250f:	00 00 00 
  802512:	ff d1                	callq  *%rcx
	*dev = 0;
  802514:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802518:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80251f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802524:	c9                   	leaveq 
  802525:	c3                   	retq   

0000000000802526 <close>:

int
close(int fdnum)
{
  802526:	55                   	push   %rbp
  802527:	48 89 e5             	mov    %rsp,%rbp
  80252a:	48 83 ec 20          	sub    $0x20,%rsp
  80252e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802531:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802535:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802538:	48 89 d6             	mov    %rdx,%rsi
  80253b:	89 c7                	mov    %eax,%edi
  80253d:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  802544:	00 00 00 
  802547:	ff d0                	callq  *%rax
  802549:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80254c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802550:	79 05                	jns    802557 <close+0x31>
		return r;
  802552:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802555:	eb 18                	jmp    80256f <close+0x49>
	else
		return fd_close(fd, 1);
  802557:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255b:	be 01 00 00 00       	mov    $0x1,%esi
  802560:	48 89 c7             	mov    %rax,%rdi
  802563:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  80256a:	00 00 00 
  80256d:	ff d0                	callq  *%rax
}
  80256f:	c9                   	leaveq 
  802570:	c3                   	retq   

0000000000802571 <close_all>:

void
close_all(void)
{
  802571:	55                   	push   %rbp
  802572:	48 89 e5             	mov    %rsp,%rbp
  802575:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802579:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802580:	eb 15                	jmp    802597 <close_all+0x26>
		close(i);
  802582:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802585:	89 c7                	mov    %eax,%edi
  802587:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  80258e:	00 00 00 
  802591:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802593:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802597:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80259b:	7e e5                	jle    802582 <close_all+0x11>
		close(i);
}
  80259d:	c9                   	leaveq 
  80259e:	c3                   	retq   

000000000080259f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80259f:	55                   	push   %rbp
  8025a0:	48 89 e5             	mov    %rsp,%rbp
  8025a3:	48 83 ec 40          	sub    $0x40,%rsp
  8025a7:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8025aa:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8025ad:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8025b1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8025b4:	48 89 d6             	mov    %rdx,%rsi
  8025b7:	89 c7                	mov    %eax,%edi
  8025b9:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  8025c0:	00 00 00 
  8025c3:	ff d0                	callq  *%rax
  8025c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025cc:	79 08                	jns    8025d6 <dup+0x37>
		return r;
  8025ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d1:	e9 70 01 00 00       	jmpq   802746 <dup+0x1a7>
	close(newfdnum);
  8025d6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025d9:	89 c7                	mov    %eax,%edi
  8025db:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  8025e2:	00 00 00 
  8025e5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8025e7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8025ea:	48 98                	cltq   
  8025ec:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025f2:	48 c1 e0 0c          	shl    $0xc,%rax
  8025f6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8025fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025fe:	48 89 c7             	mov    %rax,%rdi
  802601:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  802608:	00 00 00 
  80260b:	ff d0                	callq  *%rax
  80260d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802611:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802615:	48 89 c7             	mov    %rax,%rdi
  802618:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  80261f:	00 00 00 
  802622:	ff d0                	callq  *%rax
  802624:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80262c:	48 c1 e8 15          	shr    $0x15,%rax
  802630:	48 89 c2             	mov    %rax,%rdx
  802633:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80263a:	01 00 00 
  80263d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802641:	83 e0 01             	and    $0x1,%eax
  802644:	48 85 c0             	test   %rax,%rax
  802647:	74 73                	je     8026bc <dup+0x11d>
  802649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264d:	48 c1 e8 0c          	shr    $0xc,%rax
  802651:	48 89 c2             	mov    %rax,%rdx
  802654:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80265b:	01 00 00 
  80265e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802662:	83 e0 01             	and    $0x1,%eax
  802665:	48 85 c0             	test   %rax,%rax
  802668:	74 52                	je     8026bc <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80266a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80266e:	48 c1 e8 0c          	shr    $0xc,%rax
  802672:	48 89 c2             	mov    %rax,%rdx
  802675:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267c:	01 00 00 
  80267f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802683:	25 07 0e 00 00       	and    $0xe07,%eax
  802688:	89 c1                	mov    %eax,%ecx
  80268a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80268e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802692:	41 89 c8             	mov    %ecx,%r8d
  802695:	48 89 d1             	mov    %rdx,%rcx
  802698:	ba 00 00 00 00       	mov    $0x0,%edx
  80269d:	48 89 c6             	mov    %rax,%rsi
  8026a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026a5:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  8026ac:	00 00 00 
  8026af:	ff d0                	callq  *%rax
  8026b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026b8:	79 02                	jns    8026bc <dup+0x11d>
			goto err;
  8026ba:	eb 57                	jmp    802713 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8026bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c0:	48 c1 e8 0c          	shr    $0xc,%rax
  8026c4:	48 89 c2             	mov    %rax,%rdx
  8026c7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026ce:	01 00 00 
  8026d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8026da:	89 c1                	mov    %eax,%ecx
  8026dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026e4:	41 89 c8             	mov    %ecx,%r8d
  8026e7:	48 89 d1             	mov    %rdx,%rcx
  8026ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ef:	48 89 c6             	mov    %rax,%rsi
  8026f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8026f7:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  8026fe:	00 00 00 
  802701:	ff d0                	callq  *%rax
  802703:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802706:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80270a:	79 02                	jns    80270e <dup+0x16f>
		goto err;
  80270c:	eb 05                	jmp    802713 <dup+0x174>

	return newfdnum;
  80270e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802711:	eb 33                	jmp    802746 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802713:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802717:	48 89 c6             	mov    %rax,%rsi
  80271a:	bf 00 00 00 00       	mov    $0x0,%edi
  80271f:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  802726:	00 00 00 
  802729:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80272b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80272f:	48 89 c6             	mov    %rax,%rsi
  802732:	bf 00 00 00 00       	mov    $0x0,%edi
  802737:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  80273e:	00 00 00 
  802741:	ff d0                	callq  *%rax
	return r;
  802743:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802746:	c9                   	leaveq 
  802747:	c3                   	retq   

0000000000802748 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802748:	55                   	push   %rbp
  802749:	48 89 e5             	mov    %rsp,%rbp
  80274c:	48 83 ec 40          	sub    $0x40,%rsp
  802750:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802753:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802757:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80275b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80275f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802762:	48 89 d6             	mov    %rdx,%rsi
  802765:	89 c7                	mov    %eax,%edi
  802767:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  80276e:	00 00 00 
  802771:	ff d0                	callq  *%rax
  802773:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802776:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80277a:	78 24                	js     8027a0 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80277c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802780:	8b 00                	mov    (%rax),%eax
  802782:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802786:	48 89 d6             	mov    %rdx,%rsi
  802789:	89 c7                	mov    %eax,%edi
  80278b:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  802792:	00 00 00 
  802795:	ff d0                	callq  *%rax
  802797:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279e:	79 05                	jns    8027a5 <read+0x5d>
		return r;
  8027a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a3:	eb 76                	jmp    80281b <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8027a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a9:	8b 40 08             	mov    0x8(%rax),%eax
  8027ac:	83 e0 03             	and    $0x3,%eax
  8027af:	83 f8 01             	cmp    $0x1,%eax
  8027b2:	75 3a                	jne    8027ee <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8027b4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8027bb:	00 00 00 
  8027be:	48 8b 00             	mov    (%rax),%rax
  8027c1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8027c7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8027ca:	89 c6                	mov    %eax,%esi
  8027cc:	48 bf 8f 50 80 00 00 	movabs $0x80508f,%rdi
  8027d3:	00 00 00 
  8027d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027db:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  8027e2:	00 00 00 
  8027e5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8027e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027ec:	eb 2d                	jmp    80281b <read+0xd3>
	}
	if (!dev->dev_read)
  8027ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027f2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8027f6:	48 85 c0             	test   %rax,%rax
  8027f9:	75 07                	jne    802802 <read+0xba>
		return -E_NOT_SUPP;
  8027fb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802800:	eb 19                	jmp    80281b <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802802:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802806:	48 8b 40 10          	mov    0x10(%rax),%rax
  80280a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80280e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802812:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802816:	48 89 cf             	mov    %rcx,%rdi
  802819:	ff d0                	callq  *%rax
}
  80281b:	c9                   	leaveq 
  80281c:	c3                   	retq   

000000000080281d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80281d:	55                   	push   %rbp
  80281e:	48 89 e5             	mov    %rsp,%rbp
  802821:	48 83 ec 30          	sub    $0x30,%rsp
  802825:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802828:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80282c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802830:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802837:	eb 49                	jmp    802882 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802839:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283c:	48 98                	cltq   
  80283e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802842:	48 29 c2             	sub    %rax,%rdx
  802845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802848:	48 63 c8             	movslq %eax,%rcx
  80284b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80284f:	48 01 c1             	add    %rax,%rcx
  802852:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802855:	48 89 ce             	mov    %rcx,%rsi
  802858:	89 c7                	mov    %eax,%edi
  80285a:	48 b8 48 27 80 00 00 	movabs $0x802748,%rax
  802861:	00 00 00 
  802864:	ff d0                	callq  *%rax
  802866:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802869:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80286d:	79 05                	jns    802874 <readn+0x57>
			return m;
  80286f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802872:	eb 1c                	jmp    802890 <readn+0x73>
		if (m == 0)
  802874:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802878:	75 02                	jne    80287c <readn+0x5f>
			break;
  80287a:	eb 11                	jmp    80288d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80287c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80287f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802882:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802885:	48 98                	cltq   
  802887:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80288b:	72 ac                	jb     802839 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80288d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802890:	c9                   	leaveq 
  802891:	c3                   	retq   

0000000000802892 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802892:	55                   	push   %rbp
  802893:	48 89 e5             	mov    %rsp,%rbp
  802896:	48 83 ec 40          	sub    $0x40,%rsp
  80289a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80289d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028a1:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028a5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028a9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028ac:	48 89 d6             	mov    %rdx,%rsi
  8028af:	89 c7                	mov    %eax,%edi
  8028b1:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  8028b8:	00 00 00 
  8028bb:	ff d0                	callq  *%rax
  8028bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c4:	78 24                	js     8028ea <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ca:	8b 00                	mov    (%rax),%eax
  8028cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028d0:	48 89 d6             	mov    %rdx,%rsi
  8028d3:	89 c7                	mov    %eax,%edi
  8028d5:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  8028dc:	00 00 00 
  8028df:	ff d0                	callq  *%rax
  8028e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028e8:	79 05                	jns    8028ef <write+0x5d>
		return r;
  8028ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028ed:	eb 75                	jmp    802964 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8028ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f3:	8b 40 08             	mov    0x8(%rax),%eax
  8028f6:	83 e0 03             	and    $0x3,%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	75 3a                	jne    802937 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8028fd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802904:	00 00 00 
  802907:	48 8b 00             	mov    (%rax),%rax
  80290a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802910:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802913:	89 c6                	mov    %eax,%esi
  802915:	48 bf ab 50 80 00 00 	movabs $0x8050ab,%rdi
  80291c:	00 00 00 
  80291f:	b8 00 00 00 00       	mov    $0x0,%eax
  802924:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  80292b:	00 00 00 
  80292e:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802930:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802935:	eb 2d                	jmp    802964 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802937:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80293b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80293f:	48 85 c0             	test   %rax,%rax
  802942:	75 07                	jne    80294b <write+0xb9>
		return -E_NOT_SUPP;
  802944:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802949:	eb 19                	jmp    802964 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80294b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80294f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802953:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802957:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80295b:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80295f:	48 89 cf             	mov    %rcx,%rdi
  802962:	ff d0                	callq  *%rax
}
  802964:	c9                   	leaveq 
  802965:	c3                   	retq   

0000000000802966 <seek>:

int
seek(int fdnum, off_t offset)
{
  802966:	55                   	push   %rbp
  802967:	48 89 e5             	mov    %rsp,%rbp
  80296a:	48 83 ec 18          	sub    $0x18,%rsp
  80296e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802971:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802974:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802978:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80297b:	48 89 d6             	mov    %rdx,%rsi
  80297e:	89 c7                	mov    %eax,%edi
  802980:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  802987:	00 00 00 
  80298a:	ff d0                	callq  *%rax
  80298c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80298f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802993:	79 05                	jns    80299a <seek+0x34>
		return r;
  802995:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802998:	eb 0f                	jmp    8029a9 <seek+0x43>
	fd->fd_offset = offset;
  80299a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80299e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8029a1:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8029a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a9:	c9                   	leaveq 
  8029aa:	c3                   	retq   

00000000008029ab <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8029ab:	55                   	push   %rbp
  8029ac:	48 89 e5             	mov    %rsp,%rbp
  8029af:	48 83 ec 30          	sub    $0x30,%rsp
  8029b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029b6:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029b9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029c0:	48 89 d6             	mov    %rdx,%rsi
  8029c3:	89 c7                	mov    %eax,%edi
  8029c5:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  8029cc:	00 00 00 
  8029cf:	ff d0                	callq  *%rax
  8029d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d8:	78 24                	js     8029fe <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029de:	8b 00                	mov    (%rax),%eax
  8029e0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029e4:	48 89 d6             	mov    %rdx,%rsi
  8029e7:	89 c7                	mov    %eax,%edi
  8029e9:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  8029f0:	00 00 00 
  8029f3:	ff d0                	callq  *%rax
  8029f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fc:	79 05                	jns    802a03 <ftruncate+0x58>
		return r;
  8029fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a01:	eb 72                	jmp    802a75 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a03:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a07:	8b 40 08             	mov    0x8(%rax),%eax
  802a0a:	83 e0 03             	and    $0x3,%eax
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	75 3a                	jne    802a4b <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802a11:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a18:	00 00 00 
  802a1b:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802a1e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a24:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a27:	89 c6                	mov    %eax,%esi
  802a29:	48 bf c8 50 80 00 00 	movabs $0x8050c8,%rdi
  802a30:	00 00 00 
  802a33:	b8 00 00 00 00       	mov    $0x0,%eax
  802a38:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  802a3f:	00 00 00 
  802a42:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802a44:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a49:	eb 2a                	jmp    802a75 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802a4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4f:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a53:	48 85 c0             	test   %rax,%rax
  802a56:	75 07                	jne    802a5f <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802a58:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a5d:	eb 16                	jmp    802a75 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802a5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a63:	48 8b 40 30          	mov    0x30(%rax),%rax
  802a67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a6b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802a6e:	89 ce                	mov    %ecx,%esi
  802a70:	48 89 d7             	mov    %rdx,%rdi
  802a73:	ff d0                	callq  *%rax
}
  802a75:	c9                   	leaveq 
  802a76:	c3                   	retq   

0000000000802a77 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802a77:	55                   	push   %rbp
  802a78:	48 89 e5             	mov    %rsp,%rbp
  802a7b:	48 83 ec 30          	sub    $0x30,%rsp
  802a7f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a82:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a86:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a8a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a8d:	48 89 d6             	mov    %rdx,%rsi
  802a90:	89 c7                	mov    %eax,%edi
  802a92:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  802a99:	00 00 00 
  802a9c:	ff d0                	callq  *%rax
  802a9e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aa1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aa5:	78 24                	js     802acb <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802aa7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802aab:	8b 00                	mov    (%rax),%eax
  802aad:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ab1:	48 89 d6             	mov    %rdx,%rsi
  802ab4:	89 c7                	mov    %eax,%edi
  802ab6:	48 b8 6f 24 80 00 00 	movabs $0x80246f,%rax
  802abd:	00 00 00 
  802ac0:	ff d0                	callq  *%rax
  802ac2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac9:	79 05                	jns    802ad0 <fstat+0x59>
		return r;
  802acb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ace:	eb 5e                	jmp    802b2e <fstat+0xb7>
	if (!dev->dev_stat)
  802ad0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad4:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ad8:	48 85 c0             	test   %rax,%rax
  802adb:	75 07                	jne    802ae4 <fstat+0x6d>
		return -E_NOT_SUPP;
  802add:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ae2:	eb 4a                	jmp    802b2e <fstat+0xb7>
	stat->st_name[0] = 0;
  802ae4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ae8:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802aeb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802aef:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802af6:	00 00 00 
	stat->st_isdir = 0;
  802af9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802afd:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802b04:	00 00 00 
	stat->st_dev = dev;
  802b07:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b0f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802b16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b1a:	48 8b 40 28          	mov    0x28(%rax),%rax
  802b1e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802b22:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802b26:	48 89 ce             	mov    %rcx,%rsi
  802b29:	48 89 d7             	mov    %rdx,%rdi
  802b2c:	ff d0                	callq  *%rax
}
  802b2e:	c9                   	leaveq 
  802b2f:	c3                   	retq   

0000000000802b30 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802b30:	55                   	push   %rbp
  802b31:	48 89 e5             	mov    %rsp,%rbp
  802b34:	48 83 ec 20          	sub    $0x20,%rsp
  802b38:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b3c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802b40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b44:	be 00 00 00 00       	mov    $0x0,%esi
  802b49:	48 89 c7             	mov    %rax,%rdi
  802b4c:	48 b8 1e 2c 80 00 00 	movabs $0x802c1e,%rax
  802b53:	00 00 00 
  802b56:	ff d0                	callq  *%rax
  802b58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5f:	79 05                	jns    802b66 <stat+0x36>
		return fd;
  802b61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b64:	eb 2f                	jmp    802b95 <stat+0x65>
	r = fstat(fd, stat);
  802b66:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6d:	48 89 d6             	mov    %rdx,%rsi
  802b70:	89 c7                	mov    %eax,%edi
  802b72:	48 b8 77 2a 80 00 00 	movabs $0x802a77,%rax
  802b79:	00 00 00 
  802b7c:	ff d0                	callq  *%rax
  802b7e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b84:	89 c7                	mov    %eax,%edi
  802b86:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  802b8d:	00 00 00 
  802b90:	ff d0                	callq  *%rax
	return r;
  802b92:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802b95:	c9                   	leaveq 
  802b96:	c3                   	retq   

0000000000802b97 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802b97:	55                   	push   %rbp
  802b98:	48 89 e5             	mov    %rsp,%rbp
  802b9b:	48 83 ec 10          	sub    $0x10,%rsp
  802b9f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ba2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802ba6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bad:	00 00 00 
  802bb0:	8b 00                	mov    (%rax),%eax
  802bb2:	85 c0                	test   %eax,%eax
  802bb4:	75 1d                	jne    802bd3 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802bb6:	bf 01 00 00 00       	mov    $0x1,%edi
  802bbb:	48 b8 0e 49 80 00 00 	movabs $0x80490e,%rax
  802bc2:	00 00 00 
  802bc5:	ff d0                	callq  *%rax
  802bc7:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802bce:	00 00 00 
  802bd1:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802bd3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bda:	00 00 00 
  802bdd:	8b 00                	mov    (%rax),%eax
  802bdf:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802be2:	b9 07 00 00 00       	mov    $0x7,%ecx
  802be7:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802bee:	00 00 00 
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	48 b8 71 48 80 00 00 	movabs $0x804871,%rax
  802bfa:	00 00 00 
  802bfd:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802bff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c03:	ba 00 00 00 00       	mov    $0x0,%edx
  802c08:	48 89 c6             	mov    %rax,%rsi
  802c0b:	bf 00 00 00 00       	mov    $0x0,%edi
  802c10:	48 b8 ab 47 80 00 00 	movabs $0x8047ab,%rax
  802c17:	00 00 00 
  802c1a:	ff d0                	callq  *%rax
}
  802c1c:	c9                   	leaveq 
  802c1d:	c3                   	retq   

0000000000802c1e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802c1e:	55                   	push   %rbp
  802c1f:	48 89 e5             	mov    %rsp,%rbp
  802c22:	48 83 ec 20          	sub    $0x20,%rsp
  802c26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c2a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802c2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c31:	48 89 c7             	mov    %rax,%rdi
  802c34:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
  802c40:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802c45:	7e 0a                	jle    802c51 <open+0x33>
  802c47:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802c4c:	e9 a5 00 00 00       	jmpq   802cf6 <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  802c51:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c55:	48 89 c7             	mov    %rax,%rdi
  802c58:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  802c5f:	00 00 00 
  802c62:	ff d0                	callq  *%rax
  802c64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6b:	79 08                	jns    802c75 <open+0x57>
		return r;
  802c6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c70:	e9 81 00 00 00       	jmpq   802cf6 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802c75:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802c7c:	00 00 00 
  802c7f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802c82:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  802c88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c8c:	48 89 c6             	mov    %rax,%rsi
  802c8f:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802c96:	00 00 00 
  802c99:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  802ca0:	00 00 00 
  802ca3:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  802ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca9:	48 89 c6             	mov    %rax,%rsi
  802cac:	bf 01 00 00 00       	mov    $0x1,%edi
  802cb1:	48 b8 97 2b 80 00 00 	movabs $0x802b97,%rax
  802cb8:	00 00 00 
  802cbb:	ff d0                	callq  *%rax
  802cbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc4:	79 1d                	jns    802ce3 <open+0xc5>
		fd_close(fd, 0);
  802cc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cca:	be 00 00 00 00       	mov    $0x0,%esi
  802ccf:	48 89 c7             	mov    %rax,%rdi
  802cd2:	48 b8 a6 23 80 00 00 	movabs $0x8023a6,%rax
  802cd9:	00 00 00 
  802cdc:	ff d0                	callq  *%rax
		return r;
  802cde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce1:	eb 13                	jmp    802cf6 <open+0xd8>
	}
	return fd2num(fd);
  802ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce7:	48 89 c7             	mov    %rax,%rdi
  802cea:	48 b8 30 22 80 00 00 	movabs $0x802230,%rax
  802cf1:	00 00 00 
  802cf4:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  802cf6:	c9                   	leaveq 
  802cf7:	c3                   	retq   

0000000000802cf8 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802cf8:	55                   	push   %rbp
  802cf9:	48 89 e5             	mov    %rsp,%rbp
  802cfc:	48 83 ec 10          	sub    $0x10,%rsp
  802d00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d08:	8b 50 0c             	mov    0xc(%rax),%edx
  802d0b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802d12:	00 00 00 
  802d15:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802d17:	be 00 00 00 00       	mov    $0x0,%esi
  802d1c:	bf 06 00 00 00       	mov    $0x6,%edi
  802d21:	48 b8 97 2b 80 00 00 	movabs $0x802b97,%rax
  802d28:	00 00 00 
  802d2b:	ff d0                	callq  *%rax
}
  802d2d:	c9                   	leaveq 
  802d2e:	c3                   	retq   

0000000000802d2f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802d2f:	55                   	push   %rbp
  802d30:	48 89 e5             	mov    %rsp,%rbp
  802d33:	48 83 ec 30          	sub    $0x30,%rsp
  802d37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d3b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d3f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802d43:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d47:	8b 50 0c             	mov    0xc(%rax),%edx
  802d4a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802d51:	00 00 00 
  802d54:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802d56:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802d5d:	00 00 00 
  802d60:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802d64:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  802d68:	be 00 00 00 00       	mov    $0x0,%esi
  802d6d:	bf 03 00 00 00       	mov    $0x3,%edi
  802d72:	48 b8 97 2b 80 00 00 	movabs $0x802b97,%rax
  802d79:	00 00 00 
  802d7c:	ff d0                	callq  *%rax
  802d7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d85:	79 05                	jns    802d8c <devfile_read+0x5d>
		return r;
  802d87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8a:	eb 26                	jmp    802db2 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  802d8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8f:	48 63 d0             	movslq %eax,%rdx
  802d92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d96:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802d9d:	00 00 00 
  802da0:	48 89 c7             	mov    %rax,%rdi
  802da3:	48 b8 84 15 80 00 00 	movabs $0x801584,%rax
  802daa:	00 00 00 
  802dad:	ff d0                	callq  *%rax
	return r;
  802daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802db2:	c9                   	leaveq 
  802db3:	c3                   	retq   

0000000000802db4 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802db4:	55                   	push   %rbp
  802db5:	48 89 e5             	mov    %rsp,%rbp
  802db8:	48 83 ec 30          	sub    $0x30,%rsp
  802dbc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dc0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dc4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  802dc8:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802dcf:	00 
	n = n > max ? max : n;
  802dd0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802dd8:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802ddd:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802de5:	8b 50 0c             	mov    0xc(%rax),%edx
  802de8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802def:	00 00 00 
  802df2:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802df4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802dfb:	00 00 00 
  802dfe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e02:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  802e06:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e0a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e0e:	48 89 c6             	mov    %rax,%rsi
  802e11:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802e18:	00 00 00 
  802e1b:	48 b8 84 15 80 00 00 	movabs $0x801584,%rax
  802e22:	00 00 00 
  802e25:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  802e27:	be 00 00 00 00       	mov    $0x0,%esi
  802e2c:	bf 04 00 00 00       	mov    $0x4,%edi
  802e31:	48 b8 97 2b 80 00 00 	movabs $0x802b97,%rax
  802e38:	00 00 00 
  802e3b:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802e3d:	c9                   	leaveq 
  802e3e:	c3                   	retq   

0000000000802e3f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802e3f:	55                   	push   %rbp
  802e40:	48 89 e5             	mov    %rsp,%rbp
  802e43:	48 83 ec 20          	sub    $0x20,%rsp
  802e47:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e4b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802e4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e53:	8b 50 0c             	mov    0xc(%rax),%edx
  802e56:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e5d:	00 00 00 
  802e60:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802e62:	be 00 00 00 00       	mov    $0x0,%esi
  802e67:	bf 05 00 00 00       	mov    $0x5,%edi
  802e6c:	48 b8 97 2b 80 00 00 	movabs $0x802b97,%rax
  802e73:	00 00 00 
  802e76:	ff d0                	callq  *%rax
  802e78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7f:	79 05                	jns    802e86 <devfile_stat+0x47>
		return r;
  802e81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e84:	eb 56                	jmp    802edc <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802e86:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e8a:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802e91:	00 00 00 
  802e94:	48 89 c7             	mov    %rax,%rdi
  802e97:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802ea3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802eaa:	00 00 00 
  802ead:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802eb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802eb7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802ebd:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ec4:	00 00 00 
  802ec7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802ecd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ed1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802ed7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802edc:	c9                   	leaveq 
  802edd:	c3                   	retq   

0000000000802ede <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802ede:	55                   	push   %rbp
  802edf:	48 89 e5             	mov    %rsp,%rbp
  802ee2:	48 83 ec 10          	sub    $0x10,%rsp
  802ee6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802eea:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802eed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ef1:	8b 50 0c             	mov    0xc(%rax),%edx
  802ef4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802efb:	00 00 00 
  802efe:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802f00:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f07:	00 00 00 
  802f0a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802f0d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802f10:	be 00 00 00 00       	mov    $0x0,%esi
  802f15:	bf 02 00 00 00       	mov    $0x2,%edi
  802f1a:	48 b8 97 2b 80 00 00 	movabs $0x802b97,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
}
  802f26:	c9                   	leaveq 
  802f27:	c3                   	retq   

0000000000802f28 <remove>:

// Delete a file
int
remove(const char *path)
{
  802f28:	55                   	push   %rbp
  802f29:	48 89 e5             	mov    %rsp,%rbp
  802f2c:	48 83 ec 10          	sub    $0x10,%rsp
  802f30:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802f34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f38:	48 89 c7             	mov    %rax,%rdi
  802f3b:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  802f42:	00 00 00 
  802f45:	ff d0                	callq  *%rax
  802f47:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802f4c:	7e 07                	jle    802f55 <remove+0x2d>
		return -E_BAD_PATH;
  802f4e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802f53:	eb 33                	jmp    802f88 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802f55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f59:	48 89 c6             	mov    %rax,%rsi
  802f5c:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802f63:	00 00 00 
  802f66:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  802f6d:	00 00 00 
  802f70:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802f72:	be 00 00 00 00       	mov    $0x0,%esi
  802f77:	bf 07 00 00 00       	mov    $0x7,%edi
  802f7c:	48 b8 97 2b 80 00 00 	movabs $0x802b97,%rax
  802f83:	00 00 00 
  802f86:	ff d0                	callq  *%rax
}
  802f88:	c9                   	leaveq 
  802f89:	c3                   	retq   

0000000000802f8a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802f8a:	55                   	push   %rbp
  802f8b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802f8e:	be 00 00 00 00       	mov    $0x0,%esi
  802f93:	bf 08 00 00 00       	mov    $0x8,%edi
  802f98:	48 b8 97 2b 80 00 00 	movabs $0x802b97,%rax
  802f9f:	00 00 00 
  802fa2:	ff d0                	callq  *%rax
}
  802fa4:	5d                   	pop    %rbp
  802fa5:	c3                   	retq   

0000000000802fa6 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802fa6:	55                   	push   %rbp
  802fa7:	48 89 e5             	mov    %rsp,%rbp
  802faa:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802fb1:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802fb8:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802fbf:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802fc6:	be 00 00 00 00       	mov    $0x0,%esi
  802fcb:	48 89 c7             	mov    %rax,%rdi
  802fce:	48 b8 1e 2c 80 00 00 	movabs $0x802c1e,%rax
  802fd5:	00 00 00 
  802fd8:	ff d0                	callq  *%rax
  802fda:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802fdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe1:	79 28                	jns    80300b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802fe3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe6:	89 c6                	mov    %eax,%esi
  802fe8:	48 bf ee 50 80 00 00 	movabs $0x8050ee,%rdi
  802fef:	00 00 00 
  802ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff7:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  802ffe:	00 00 00 
  803001:	ff d2                	callq  *%rdx
		return fd_src;
  803003:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803006:	e9 74 01 00 00       	jmpq   80317f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80300b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803012:	be 01 01 00 00       	mov    $0x101,%esi
  803017:	48 89 c7             	mov    %rax,%rdi
  80301a:	48 b8 1e 2c 80 00 00 	movabs $0x802c1e,%rax
  803021:	00 00 00 
  803024:	ff d0                	callq  *%rax
  803026:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803029:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80302d:	79 39                	jns    803068 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80302f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803032:	89 c6                	mov    %eax,%esi
  803034:	48 bf 04 51 80 00 00 	movabs $0x805104,%rdi
  80303b:	00 00 00 
  80303e:	b8 00 00 00 00       	mov    $0x0,%eax
  803043:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  80304a:	00 00 00 
  80304d:	ff d2                	callq  *%rdx
		close(fd_src);
  80304f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803052:	89 c7                	mov    %eax,%edi
  803054:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  80305b:	00 00 00 
  80305e:	ff d0                	callq  *%rax
		return fd_dest;
  803060:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803063:	e9 17 01 00 00       	jmpq   80317f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803068:	eb 74                	jmp    8030de <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80306a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80306d:	48 63 d0             	movslq %eax,%rdx
  803070:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803077:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80307a:	48 89 ce             	mov    %rcx,%rsi
  80307d:	89 c7                	mov    %eax,%edi
  80307f:	48 b8 92 28 80 00 00 	movabs $0x802892,%rax
  803086:	00 00 00 
  803089:	ff d0                	callq  *%rax
  80308b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80308e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803092:	79 4a                	jns    8030de <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803094:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803097:	89 c6                	mov    %eax,%esi
  803099:	48 bf 1e 51 80 00 00 	movabs $0x80511e,%rdi
  8030a0:	00 00 00 
  8030a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a8:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  8030af:	00 00 00 
  8030b2:	ff d2                	callq  *%rdx
			close(fd_src);
  8030b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b7:	89 c7                	mov    %eax,%edi
  8030b9:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  8030c0:	00 00 00 
  8030c3:	ff d0                	callq  *%rax
			close(fd_dest);
  8030c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030c8:	89 c7                	mov    %eax,%edi
  8030ca:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
			return write_size;
  8030d6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8030d9:	e9 a1 00 00 00       	jmpq   80317f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8030de:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8030e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e8:	ba 00 02 00 00       	mov    $0x200,%edx
  8030ed:	48 89 ce             	mov    %rcx,%rsi
  8030f0:	89 c7                	mov    %eax,%edi
  8030f2:	48 b8 48 27 80 00 00 	movabs $0x802748,%rax
  8030f9:	00 00 00 
  8030fc:	ff d0                	callq  *%rax
  8030fe:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803101:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803105:	0f 8f 5f ff ff ff    	jg     80306a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80310b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80310f:	79 47                	jns    803158 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803111:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803114:	89 c6                	mov    %eax,%esi
  803116:	48 bf 31 51 80 00 00 	movabs $0x805131,%rdi
  80311d:	00 00 00 
  803120:	b8 00 00 00 00       	mov    $0x0,%eax
  803125:	48 ba 94 05 80 00 00 	movabs $0x800594,%rdx
  80312c:	00 00 00 
  80312f:	ff d2                	callq  *%rdx
		close(fd_src);
  803131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803134:	89 c7                	mov    %eax,%edi
  803136:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  80313d:	00 00 00 
  803140:	ff d0                	callq  *%rax
		close(fd_dest);
  803142:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803145:	89 c7                	mov    %eax,%edi
  803147:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  80314e:	00 00 00 
  803151:	ff d0                	callq  *%rax
		return read_size;
  803153:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803156:	eb 27                	jmp    80317f <copy+0x1d9>
	}
	close(fd_src);
  803158:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315b:	89 c7                	mov    %eax,%edi
  80315d:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  803164:	00 00 00 
  803167:	ff d0                	callq  *%rax
	close(fd_dest);
  803169:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80316c:	89 c7                	mov    %eax,%edi
  80316e:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  803175:	00 00 00 
  803178:	ff d0                	callq  *%rax
	return 0;
  80317a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80317f:	c9                   	leaveq 
  803180:	c3                   	retq   

0000000000803181 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  803181:	55                   	push   %rbp
  803182:	48 89 e5             	mov    %rsp,%rbp
  803185:	48 81 ec 10 03 00 00 	sub    $0x310,%rsp
  80318c:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  803193:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80319a:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  8031a1:	be 00 00 00 00       	mov    $0x0,%esi
  8031a6:	48 89 c7             	mov    %rax,%rdi
  8031a9:	48 b8 1e 2c 80 00 00 	movabs $0x802c1e,%rax
  8031b0:	00 00 00 
  8031b3:	ff d0                	callq  *%rax
  8031b5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8031b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8031bc:	79 08                	jns    8031c6 <spawn+0x45>
		return r;
  8031be:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031c1:	e9 14 03 00 00       	jmpq   8034da <spawn+0x359>
	fd = r;
  8031c6:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8031c9:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  8031cc:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  8031d3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8031d7:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8031de:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8031e1:	ba 00 02 00 00       	mov    $0x200,%edx
  8031e6:	48 89 ce             	mov    %rcx,%rsi
  8031e9:	89 c7                	mov    %eax,%edi
  8031eb:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  8031f2:	00 00 00 
  8031f5:	ff d0                	callq  *%rax
  8031f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8031fc:	75 0d                	jne    80320b <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  8031fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803202:	8b 00                	mov    (%rax),%eax
  803204:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  803209:	74 43                	je     80324e <spawn+0xcd>
		close(fd);
  80320b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80320e:	89 c7                	mov    %eax,%edi
  803210:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  803217:	00 00 00 
  80321a:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80321c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803220:	8b 00                	mov    (%rax),%eax
  803222:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  803227:	89 c6                	mov    %eax,%esi
  803229:	48 bf 48 51 80 00 00 	movabs $0x805148,%rdi
  803230:	00 00 00 
  803233:	b8 00 00 00 00       	mov    $0x0,%eax
  803238:	48 b9 94 05 80 00 00 	movabs $0x800594,%rcx
  80323f:	00 00 00 
  803242:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  803244:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803249:	e9 8c 02 00 00       	jmpq   8034da <spawn+0x359>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80324e:	b8 07 00 00 00       	mov    $0x7,%eax
  803253:	cd 30                	int    $0x30
  803255:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803258:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80325b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80325e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803262:	79 08                	jns    80326c <spawn+0xeb>
		return r;
  803264:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803267:	e9 6e 02 00 00       	jmpq   8034da <spawn+0x359>
	child = r;
  80326c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80326f:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  803272:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803275:	25 ff 03 00 00       	and    $0x3ff,%eax
  80327a:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803281:	00 00 00 
  803284:	48 63 d0             	movslq %eax,%rdx
  803287:	48 89 d0             	mov    %rdx,%rax
  80328a:	48 c1 e0 03          	shl    $0x3,%rax
  80328e:	48 01 d0             	add    %rdx,%rax
  803291:	48 c1 e0 05          	shl    $0x5,%rax
  803295:	48 01 c8             	add    %rcx,%rax
  803298:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80329f:	48 89 c6             	mov    %rax,%rsi
  8032a2:	b8 18 00 00 00       	mov    $0x18,%eax
  8032a7:	48 89 d7             	mov    %rdx,%rdi
  8032aa:	48 89 c1             	mov    %rax,%rcx
  8032ad:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  8032b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032b4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8032b8:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  8032bf:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  8032c6:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  8032cd:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  8032d4:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8032d7:	48 89 ce             	mov    %rcx,%rsi
  8032da:	89 c7                	mov    %eax,%edi
  8032dc:	48 b8 44 37 80 00 00 	movabs $0x803744,%rax
  8032e3:	00 00 00 
  8032e6:	ff d0                	callq  *%rax
  8032e8:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8032eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8032ef:	79 08                	jns    8032f9 <spawn+0x178>
		return r;
  8032f1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8032f4:	e9 e1 01 00 00       	jmpq   8034da <spawn+0x359>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8032f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032fd:	48 8b 40 20          	mov    0x20(%rax),%rax
  803301:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  803308:	48 01 d0             	add    %rdx,%rax
  80330b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80330f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803316:	e9 a3 00 00 00       	jmpq   8033be <spawn+0x23d>
		if (ph->p_type != ELF_PROG_LOAD)
  80331b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80331f:	8b 00                	mov    (%rax),%eax
  803321:	83 f8 01             	cmp    $0x1,%eax
  803324:	74 05                	je     80332b <spawn+0x1aa>
			continue;
  803326:	e9 8a 00 00 00       	jmpq   8033b5 <spawn+0x234>
		perm = PTE_P | PTE_U;
  80332b:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803332:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803336:	8b 40 04             	mov    0x4(%rax),%eax
  803339:	83 e0 02             	and    $0x2,%eax
  80333c:	85 c0                	test   %eax,%eax
  80333e:	74 04                	je     803344 <spawn+0x1c3>
			perm |= PTE_W;
  803340:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  803344:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803348:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80334c:	41 89 c1             	mov    %eax,%r9d
  80334f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803353:	4c 8b 40 20          	mov    0x20(%rax),%r8
  803357:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80335b:	48 8b 50 28          	mov    0x28(%rax),%rdx
  80335f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803363:	48 8b 70 10          	mov    0x10(%rax),%rsi
  803367:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80336a:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80336d:	8b 7d ec             	mov    -0x14(%rbp),%edi
  803370:	89 3c 24             	mov    %edi,(%rsp)
  803373:	89 c7                	mov    %eax,%edi
  803375:	48 b8 ed 39 80 00 00 	movabs $0x8039ed,%rax
  80337c:	00 00 00 
  80337f:	ff d0                	callq  *%rax
  803381:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803384:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803388:	79 2b                	jns    8033b5 <spawn+0x234>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  80338a:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  80338b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80338e:	89 c7                	mov    %eax,%edi
  803390:	48 b8 b8 19 80 00 00 	movabs $0x8019b8,%rax
  803397:	00 00 00 
  80339a:	ff d0                	callq  *%rax
	close(fd);
  80339c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80339f:	89 c7                	mov    %eax,%edi
  8033a1:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  8033a8:	00 00 00 
  8033ab:	ff d0                	callq  *%rax
	return r;
  8033ad:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8033b0:	e9 25 01 00 00       	jmpq   8034da <spawn+0x359>
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8033b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8033b9:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  8033be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033c2:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  8033c6:	0f b7 c0             	movzwl %ax,%eax
  8033c9:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8033cc:	0f 8f 49 ff ff ff    	jg     80331b <spawn+0x19a>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8033d2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8033d5:	89 c7                	mov    %eax,%edi
  8033d7:	48 b8 26 25 80 00 00 	movabs $0x802526,%rax
  8033de:	00 00 00 
  8033e1:	ff d0                	callq  *%rax
	fd = -1;
  8033e3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  8033ea:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8033ed:	89 c7                	mov    %eax,%edi
  8033ef:	48 b8 d9 3b 80 00 00 	movabs $0x803bd9,%rax
  8033f6:	00 00 00 
  8033f9:	ff d0                	callq  *%rax
  8033fb:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8033fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803402:	79 30                	jns    803434 <spawn+0x2b3>
		panic("copy_shared_pages: %e", r);
  803404:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803407:	89 c1                	mov    %eax,%ecx
  803409:	48 ba 62 51 80 00 00 	movabs $0x805162,%rdx
  803410:	00 00 00 
  803413:	be 82 00 00 00       	mov    $0x82,%esi
  803418:	48 bf 78 51 80 00 00 	movabs $0x805178,%rdi
  80341f:	00 00 00 
  803422:	b8 00 00 00 00       	mov    $0x0,%eax
  803427:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  80342e:	00 00 00 
  803431:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803434:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  80343b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80343e:	48 89 d6             	mov    %rdx,%rsi
  803441:	89 c7                	mov    %eax,%edi
  803443:	48 b8 b8 1b 80 00 00 	movabs $0x801bb8,%rax
  80344a:	00 00 00 
  80344d:	ff d0                	callq  *%rax
  80344f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  803452:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  803456:	79 30                	jns    803488 <spawn+0x307>
		panic("sys_env_set_trapframe: %e", r);
  803458:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80345b:	89 c1                	mov    %eax,%ecx
  80345d:	48 ba 84 51 80 00 00 	movabs $0x805184,%rdx
  803464:	00 00 00 
  803467:	be 85 00 00 00       	mov    $0x85,%esi
  80346c:	48 bf 78 51 80 00 00 	movabs $0x805178,%rdi
  803473:	00 00 00 
  803476:	b8 00 00 00 00       	mov    $0x0,%eax
  80347b:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  803482:	00 00 00 
  803485:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  803488:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80348b:	be 02 00 00 00       	mov    $0x2,%esi
  803490:	89 c7                	mov    %eax,%edi
  803492:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  803499:	00 00 00 
  80349c:	ff d0                	callq  *%rax
  80349e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8034a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8034a5:	79 30                	jns    8034d7 <spawn+0x356>
		panic("sys_env_set_status: %e", r);
  8034a7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8034aa:	89 c1                	mov    %eax,%ecx
  8034ac:	48 ba 9e 51 80 00 00 	movabs $0x80519e,%rdx
  8034b3:	00 00 00 
  8034b6:	be 88 00 00 00       	mov    $0x88,%esi
  8034bb:	48 bf 78 51 80 00 00 	movabs $0x805178,%rdi
  8034c2:	00 00 00 
  8034c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ca:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  8034d1:	00 00 00 
  8034d4:	41 ff d0             	callq  *%r8

	return child;
  8034d7:	8b 45 d4             	mov    -0x2c(%rbp),%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8034da:	c9                   	leaveq 
  8034db:	c3                   	retq   

00000000008034dc <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8034dc:	55                   	push   %rbp
  8034dd:	48 89 e5             	mov    %rsp,%rbp
  8034e0:	41 55                	push   %r13
  8034e2:	41 54                	push   %r12
  8034e4:	53                   	push   %rbx
  8034e5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8034ec:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  8034f3:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  8034fa:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  803501:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  803508:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  80350f:	84 c0                	test   %al,%al
  803511:	74 26                	je     803539 <spawnl+0x5d>
  803513:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80351a:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  803521:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  803525:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  803529:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80352d:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  803531:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  803535:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
  803539:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  803540:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  803547:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  80354a:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803551:	00 00 00 
  803554:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80355b:	00 00 00 
  80355e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803562:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  803569:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803570:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  803577:	eb 07                	jmp    803580 <spawnl+0xa4>
		argc++;
  803579:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  803580:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803586:	83 f8 30             	cmp    $0x30,%eax
  803589:	73 23                	jae    8035ae <spawnl+0xd2>
  80358b:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  803592:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  803598:	89 c0                	mov    %eax,%eax
  80359a:	48 01 d0             	add    %rdx,%rax
  80359d:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8035a3:	83 c2 08             	add    $0x8,%edx
  8035a6:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8035ac:	eb 15                	jmp    8035c3 <spawnl+0xe7>
  8035ae:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8035b5:	48 89 d0             	mov    %rdx,%rax
  8035b8:	48 83 c2 08          	add    $0x8,%rdx
  8035bc:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8035c3:	48 8b 00             	mov    (%rax),%rax
  8035c6:	48 85 c0             	test   %rax,%rax
  8035c9:	75 ae                	jne    803579 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8035cb:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8035d1:	83 c0 02             	add    $0x2,%eax
  8035d4:	48 89 e2             	mov    %rsp,%rdx
  8035d7:	48 89 d3             	mov    %rdx,%rbx
  8035da:	48 63 d0             	movslq %eax,%rdx
  8035dd:	48 83 ea 01          	sub    $0x1,%rdx
  8035e1:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  8035e8:	48 63 d0             	movslq %eax,%rdx
  8035eb:	49 89 d4             	mov    %rdx,%r12
  8035ee:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  8035f4:	48 63 d0             	movslq %eax,%rdx
  8035f7:	49 89 d2             	mov    %rdx,%r10
  8035fa:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  803600:	48 98                	cltq   
  803602:	48 c1 e0 03          	shl    $0x3,%rax
  803606:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80360a:	b8 10 00 00 00       	mov    $0x10,%eax
  80360f:	48 83 e8 01          	sub    $0x1,%rax
  803613:	48 01 d0             	add    %rdx,%rax
  803616:	bf 10 00 00 00       	mov    $0x10,%edi
  80361b:	ba 00 00 00 00       	mov    $0x0,%edx
  803620:	48 f7 f7             	div    %rdi
  803623:	48 6b c0 10          	imul   $0x10,%rax,%rax
  803627:	48 29 c4             	sub    %rax,%rsp
  80362a:	48 89 e0             	mov    %rsp,%rax
  80362d:	48 83 c0 07          	add    $0x7,%rax
  803631:	48 c1 e8 03          	shr    $0x3,%rax
  803635:	48 c1 e0 03          	shl    $0x3,%rax
  803639:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  803640:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803647:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  80364e:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  803651:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803657:	8d 50 01             	lea    0x1(%rax),%edx
  80365a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803661:	48 63 d2             	movslq %edx,%rdx
  803664:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  80366b:	00 

	va_start(vl, arg0);
  80366c:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  803673:	00 00 00 
  803676:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  80367d:	00 00 00 
  803680:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803684:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  80368b:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  803692:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  803699:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8036a0:	00 00 00 
  8036a3:	eb 63                	jmp    803708 <spawnl+0x22c>
		argv[i+1] = va_arg(vl, const char *);
  8036a5:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8036ab:	8d 70 01             	lea    0x1(%rax),%esi
  8036ae:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8036b4:	83 f8 30             	cmp    $0x30,%eax
  8036b7:	73 23                	jae    8036dc <spawnl+0x200>
  8036b9:	48 8b 95 10 ff ff ff 	mov    -0xf0(%rbp),%rdx
  8036c0:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8036c6:	89 c0                	mov    %eax,%eax
  8036c8:	48 01 d0             	add    %rdx,%rax
  8036cb:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8036d1:	83 c2 08             	add    $0x8,%edx
  8036d4:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8036da:	eb 15                	jmp    8036f1 <spawnl+0x215>
  8036dc:	48 8b 95 08 ff ff ff 	mov    -0xf8(%rbp),%rdx
  8036e3:	48 89 d0             	mov    %rdx,%rax
  8036e6:	48 83 c2 08          	add    $0x8,%rdx
  8036ea:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8036f1:	48 8b 08             	mov    (%rax),%rcx
  8036f4:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8036fb:	89 f2                	mov    %esi,%edx
  8036fd:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803701:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  803708:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80370e:	3b 85 28 ff ff ff    	cmp    -0xd8(%rbp),%eax
  803714:	77 8f                	ja     8036a5 <spawnl+0x1c9>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  803716:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80371d:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  803724:	48 89 d6             	mov    %rdx,%rsi
  803727:	48 89 c7             	mov    %rax,%rdi
  80372a:	48 b8 81 31 80 00 00 	movabs $0x803181,%rax
  803731:	00 00 00 
  803734:	ff d0                	callq  *%rax
  803736:	48 89 dc             	mov    %rbx,%rsp
}
  803739:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  80373d:	5b                   	pop    %rbx
  80373e:	41 5c                	pop    %r12
  803740:	41 5d                	pop    %r13
  803742:	5d                   	pop    %rbp
  803743:	c3                   	retq   

0000000000803744 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  803744:	55                   	push   %rbp
  803745:	48 89 e5             	mov    %rsp,%rbp
  803748:	48 83 ec 50          	sub    $0x50,%rsp
  80374c:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80374f:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  803753:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  803757:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80375e:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  80375f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  803766:	eb 33                	jmp    80379b <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  803768:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80376b:	48 98                	cltq   
  80376d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803774:	00 
  803775:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803779:	48 01 d0             	add    %rdx,%rax
  80377c:	48 8b 00             	mov    (%rax),%rax
  80377f:	48 89 c7             	mov    %rax,%rdi
  803782:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  803789:	00 00 00 
  80378c:	ff d0                	callq  *%rax
  80378e:	83 c0 01             	add    $0x1,%eax
  803791:	48 98                	cltq   
  803793:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  803797:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  80379b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80379e:	48 98                	cltq   
  8037a0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8037a7:	00 
  8037a8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8037ac:	48 01 d0             	add    %rdx,%rax
  8037af:	48 8b 00             	mov    (%rax),%rax
  8037b2:	48 85 c0             	test   %rax,%rax
  8037b5:	75 b1                	jne    803768 <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8037b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037bb:	48 f7 d8             	neg    %rax
  8037be:	48 05 00 10 40 00    	add    $0x401000,%rax
  8037c4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8037c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037cc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8037d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037d4:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8037d8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037db:	83 c2 01             	add    $0x1,%edx
  8037de:	c1 e2 03             	shl    $0x3,%edx
  8037e1:	48 63 d2             	movslq %edx,%rdx
  8037e4:	48 f7 da             	neg    %rdx
  8037e7:	48 01 d0             	add    %rdx,%rax
  8037ea:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8037ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037f2:	48 83 e8 10          	sub    $0x10,%rax
  8037f6:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  8037fc:	77 0a                	ja     803808 <init_stack+0xc4>
		return -E_NO_MEM;
  8037fe:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  803803:	e9 e3 01 00 00       	jmpq   8039eb <init_stack+0x2a7>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803808:	ba 07 00 00 00       	mov    $0x7,%edx
  80380d:	be 00 00 40 00       	mov    $0x400000,%esi
  803812:	bf 00 00 00 00       	mov    $0x0,%edi
  803817:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80381e:	00 00 00 
  803821:	ff d0                	callq  *%rax
  803823:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803826:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80382a:	79 08                	jns    803834 <init_stack+0xf0>
		return r;
  80382c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80382f:	e9 b7 01 00 00       	jmpq   8039eb <init_stack+0x2a7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  803834:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80383b:	e9 8a 00 00 00       	jmpq   8038ca <init_stack+0x186>
		argv_store[i] = UTEMP2USTACK(string_store);
  803840:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803843:	48 98                	cltq   
  803845:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80384c:	00 
  80384d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803851:	48 01 c2             	add    %rax,%rdx
  803854:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803859:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80385d:	48 01 c8             	add    %rcx,%rax
  803860:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  803866:	48 89 02             	mov    %rax,(%rdx)
		strcpy(string_store, argv[i]);
  803869:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80386c:	48 98                	cltq   
  80386e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803875:	00 
  803876:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80387a:	48 01 d0             	add    %rdx,%rax
  80387d:	48 8b 10             	mov    (%rax),%rdx
  803880:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803884:	48 89 d6             	mov    %rdx,%rsi
  803887:	48 89 c7             	mov    %rax,%rdi
  80388a:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  803891:	00 00 00 
  803894:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  803896:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803899:	48 98                	cltq   
  80389b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038a2:	00 
  8038a3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8038a7:	48 01 d0             	add    %rdx,%rax
  8038aa:	48 8b 00             	mov    (%rax),%rax
  8038ad:	48 89 c7             	mov    %rax,%rdi
  8038b0:	48 b8 dd 10 80 00 00 	movabs $0x8010dd,%rax
  8038b7:	00 00 00 
  8038ba:	ff d0                	callq  *%rax
  8038bc:	48 98                	cltq   
  8038be:	48 83 c0 01          	add    $0x1,%rax
  8038c2:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8038c6:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8038ca:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038cd:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8038d0:	0f 8c 6a ff ff ff    	jl     803840 <init_stack+0xfc>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8038d6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8038d9:	48 98                	cltq   
  8038db:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8038e2:	00 
  8038e3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038e7:	48 01 d0             	add    %rdx,%rax
  8038ea:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8038f1:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  8038f8:	00 
  8038f9:	74 35                	je     803930 <init_stack+0x1ec>
  8038fb:	48 b9 b8 51 80 00 00 	movabs $0x8051b8,%rcx
  803902:	00 00 00 
  803905:	48 ba de 51 80 00 00 	movabs $0x8051de,%rdx
  80390c:	00 00 00 
  80390f:	be f1 00 00 00       	mov    $0xf1,%esi
  803914:	48 bf 78 51 80 00 00 	movabs $0x805178,%rdi
  80391b:	00 00 00 
  80391e:	b8 00 00 00 00       	mov    $0x0,%eax
  803923:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  80392a:	00 00 00 
  80392d:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  803930:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803934:	48 8d 50 f8          	lea    -0x8(%rax),%rdx
  803938:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80393d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803941:	48 01 c8             	add    %rcx,%rax
  803944:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80394a:	48 89 02             	mov    %rax,(%rdx)
	argv_store[-2] = argc;
  80394d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803951:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  803955:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803958:	48 98                	cltq   
  80395a:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80395d:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  803962:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803966:	48 01 d0             	add    %rdx,%rax
  803969:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  80396f:	48 89 c2             	mov    %rax,%rdx
  803972:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  803976:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  803979:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80397c:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803982:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  803987:	89 c2                	mov    %eax,%edx
  803989:	be 00 00 40 00       	mov    $0x400000,%esi
  80398e:	bf 00 00 00 00       	mov    $0x0,%edi
  803993:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  80399a:	00 00 00 
  80399d:	ff d0                	callq  *%rax
  80399f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039a6:	79 02                	jns    8039aa <init_stack+0x266>
		goto error;
  8039a8:	eb 28                	jmp    8039d2 <init_stack+0x28e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8039aa:	be 00 00 40 00       	mov    $0x400000,%esi
  8039af:	bf 00 00 00 00       	mov    $0x0,%edi
  8039b4:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  8039bb:	00 00 00 
  8039be:	ff d0                	callq  *%rax
  8039c0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039c7:	79 02                	jns    8039cb <init_stack+0x287>
		goto error;
  8039c9:	eb 07                	jmp    8039d2 <init_stack+0x28e>

	return 0;
  8039cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d0:	eb 19                	jmp    8039eb <init_stack+0x2a7>

error:
	sys_page_unmap(0, UTEMP);
  8039d2:	be 00 00 40 00       	mov    $0x400000,%esi
  8039d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8039dc:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  8039e3:	00 00 00 
  8039e6:	ff d0                	callq  *%rax
	return r;
  8039e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8039eb:	c9                   	leaveq 
  8039ec:	c3                   	retq   

00000000008039ed <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  8039ed:	55                   	push   %rbp
  8039ee:	48 89 e5             	mov    %rsp,%rbp
  8039f1:	48 83 ec 50          	sub    $0x50,%rsp
  8039f5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8039f8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8039fc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  803a00:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  803a03:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  803a07:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  803a0b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a0f:	25 ff 0f 00 00       	and    $0xfff,%eax
  803a14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a1b:	74 21                	je     803a3e <map_segment+0x51>
		va -= i;
  803a1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a20:	48 98                	cltq   
  803a22:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  803a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a29:	48 98                	cltq   
  803a2b:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  803a2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a32:	48 98                	cltq   
  803a34:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  803a38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3b:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803a3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803a45:	e9 79 01 00 00       	jmpq   803bc3 <map_segment+0x1d6>
		if (i >= filesz) {
  803a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a4d:	48 98                	cltq   
  803a4f:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  803a53:	72 3c                	jb     803a91 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  803a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a58:	48 63 d0             	movslq %eax,%rdx
  803a5b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a5f:	48 01 d0             	add    %rdx,%rax
  803a62:	48 89 c1             	mov    %rax,%rcx
  803a65:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a68:	8b 55 10             	mov    0x10(%rbp),%edx
  803a6b:	48 89 ce             	mov    %rcx,%rsi
  803a6e:	89 c7                	mov    %eax,%edi
  803a70:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  803a77:	00 00 00 
  803a7a:	ff d0                	callq  *%rax
  803a7c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803a7f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803a83:	0f 89 33 01 00 00    	jns    803bbc <map_segment+0x1cf>
				return r;
  803a89:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a8c:	e9 46 01 00 00       	jmpq   803bd7 <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803a91:	ba 07 00 00 00       	mov    $0x7,%edx
  803a96:	be 00 00 40 00       	mov    $0x400000,%esi
  803a9b:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa0:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  803aa7:	00 00 00 
  803aaa:	ff d0                	callq  *%rax
  803aac:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803aaf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ab3:	79 08                	jns    803abd <map_segment+0xd0>
				return r;
  803ab5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ab8:	e9 1a 01 00 00       	jmpq   803bd7 <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  803abd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ac0:	8b 55 bc             	mov    -0x44(%rbp),%edx
  803ac3:	01 c2                	add    %eax,%edx
  803ac5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803ac8:	89 d6                	mov    %edx,%esi
  803aca:	89 c7                	mov    %eax,%edi
  803acc:	48 b8 66 29 80 00 00 	movabs $0x802966,%rax
  803ad3:	00 00 00 
  803ad6:	ff d0                	callq  *%rax
  803ad8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803adb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803adf:	79 08                	jns    803ae9 <map_segment+0xfc>
				return r;
  803ae1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ae4:	e9 ee 00 00 00       	jmpq   803bd7 <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  803ae9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  803af0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803af3:	48 98                	cltq   
  803af5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803af9:	48 29 c2             	sub    %rax,%rdx
  803afc:	48 89 d0             	mov    %rdx,%rax
  803aff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803b03:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803b06:	48 63 d0             	movslq %eax,%rdx
  803b09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b0d:	48 39 c2             	cmp    %rax,%rdx
  803b10:	48 0f 47 d0          	cmova  %rax,%rdx
  803b14:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803b17:	be 00 00 40 00       	mov    $0x400000,%esi
  803b1c:	89 c7                	mov    %eax,%edi
  803b1e:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  803b25:	00 00 00 
  803b28:	ff d0                	callq  *%rax
  803b2a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b2d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b31:	79 08                	jns    803b3b <map_segment+0x14e>
				return r;
  803b33:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b36:	e9 9c 00 00 00       	jmpq   803bd7 <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  803b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b3e:	48 63 d0             	movslq %eax,%rdx
  803b41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b45:	48 01 d0             	add    %rdx,%rax
  803b48:	48 89 c2             	mov    %rax,%rdx
  803b4b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803b4e:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  803b52:	48 89 d1             	mov    %rdx,%rcx
  803b55:	89 c2                	mov    %eax,%edx
  803b57:	be 00 00 40 00       	mov    $0x400000,%esi
  803b5c:	bf 00 00 00 00       	mov    $0x0,%edi
  803b61:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  803b68:	00 00 00 
  803b6b:	ff d0                	callq  *%rax
  803b6d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803b70:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803b74:	79 30                	jns    803ba6 <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  803b76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803b79:	89 c1                	mov    %eax,%ecx
  803b7b:	48 ba f3 51 80 00 00 	movabs $0x8051f3,%rdx
  803b82:	00 00 00 
  803b85:	be 24 01 00 00       	mov    $0x124,%esi
  803b8a:	48 bf 78 51 80 00 00 	movabs $0x805178,%rdi
  803b91:	00 00 00 
  803b94:	b8 00 00 00 00       	mov    $0x0,%eax
  803b99:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  803ba0:	00 00 00 
  803ba3:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  803ba6:	be 00 00 40 00       	mov    $0x400000,%esi
  803bab:	bf 00 00 00 00       	mov    $0x0,%edi
  803bb0:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  803bb7:	00 00 00 
  803bba:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  803bbc:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  803bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc6:	48 98                	cltq   
  803bc8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803bcc:	0f 82 78 fe ff ff    	jb     803a4a <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  803bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bd7:	c9                   	leaveq 
  803bd8:	c3                   	retq   

0000000000803bd9 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  803bd9:	55                   	push   %rbp
  803bda:	48 89 e5             	mov    %rsp,%rbp
  803bdd:	48 83 ec 70          	sub    $0x70,%rsp
  803be1:	89 7d 9c             	mov    %edi,-0x64(%rbp)
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  803be4:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803beb:	00 
  803bec:	e9 70 01 00 00       	jmpq   803d61 <copy_shared_pages+0x188>
		if(uvpml4e[pml4e] & PTE_P){
  803bf1:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  803bf8:	01 00 00 
  803bfb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803bff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c03:	83 e0 01             	and    $0x1,%eax
  803c06:	48 85 c0             	test   %rax,%rax
  803c09:	0f 84 4d 01 00 00    	je     803d5c <copy_shared_pages+0x183>
			base_pml4e = pml4e * NPDPENTRIES;
  803c0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c13:	48 c1 e0 09          	shl    $0x9,%rax
  803c17:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  803c1b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803c22:	00 
  803c23:	e9 26 01 00 00       	jmpq   803d4e <copy_shared_pages+0x175>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
  803c28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c2c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c30:	48 01 c2             	add    %rax,%rdx
  803c33:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  803c3a:	01 00 00 
  803c3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c41:	83 e0 01             	and    $0x1,%eax
  803c44:	48 85 c0             	test   %rax,%rax
  803c47:	0f 84 fc 00 00 00    	je     803d49 <copy_shared_pages+0x170>
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
  803c4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c51:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803c55:	48 01 d0             	add    %rdx,%rax
  803c58:	48 c1 e0 09          	shl    $0x9,%rax
  803c5c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
					for(pde = 0; pde < NPDENTRIES; pde++){
  803c60:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  803c67:	00 
  803c68:	e9 ce 00 00 00       	jmpq   803d3b <copy_shared_pages+0x162>
						if(uvpd[base_pdpe + pde] & PTE_P){
  803c6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c71:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803c75:	48 01 c2             	add    %rax,%rdx
  803c78:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c7f:	01 00 00 
  803c82:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c86:	83 e0 01             	and    $0x1,%eax
  803c89:	48 85 c0             	test   %rax,%rax
  803c8c:	0f 84 a4 00 00 00    	je     803d36 <copy_shared_pages+0x15d>
							base_pde = (base_pdpe + pde) * NPTENTRIES;
  803c92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c96:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  803c9a:	48 01 d0             	add    %rdx,%rax
  803c9d:	48 c1 e0 09          	shl    $0x9,%rax
  803ca1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
							for(pte = 0; pte < NPTENTRIES; pte++){
  803ca5:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
  803cac:	00 
  803cad:	eb 79                	jmp    803d28 <copy_shared_pages+0x14f>
								entry = base_pde + pte;
  803caf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cb3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803cb7:	48 01 d0             	add    %rdx,%rax
  803cba:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
								perm = uvpt[entry] & PTE_SYSCALL;
  803cbe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cc5:	01 00 00 
  803cc8:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803ccc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cd0:	25 07 0e 00 00       	and    $0xe07,%eax
  803cd5:	89 45 bc             	mov    %eax,-0x44(%rbp)
								if(perm & PTE_SHARE){
  803cd8:	8b 45 bc             	mov    -0x44(%rbp),%eax
  803cdb:	25 00 04 00 00       	and    $0x400,%eax
  803ce0:	85 c0                	test   %eax,%eax
  803ce2:	74 3f                	je     803d23 <copy_shared_pages+0x14a>
									va = (void*)(PGSIZE * entry);
  803ce4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803ce8:	48 c1 e0 0c          	shl    $0xc,%rax
  803cec:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
									r = sys_page_map(0, va, child, va, perm);		
  803cf0:	8b 75 bc             	mov    -0x44(%rbp),%esi
  803cf3:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  803cf7:	8b 55 9c             	mov    -0x64(%rbp),%edx
  803cfa:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  803cfe:	41 89 f0             	mov    %esi,%r8d
  803d01:	48 89 c6             	mov    %rax,%rsi
  803d04:	bf 00 00 00 00       	mov    $0x0,%edi
  803d09:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  803d10:	00 00 00 
  803d13:	ff d0                	callq  *%rax
  803d15:	89 45 ac             	mov    %eax,-0x54(%rbp)
									if(r < 0) return r;
  803d18:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
  803d1c:	79 05                	jns    803d23 <copy_shared_pages+0x14a>
  803d1e:	8b 45 ac             	mov    -0x54(%rbp),%eax
  803d21:	eb 4e                	jmp    803d71 <copy_shared_pages+0x198>
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
						if(uvpd[base_pdpe + pde] & PTE_P){
							base_pde = (base_pdpe + pde) * NPTENTRIES;
							for(pte = 0; pte < NPTENTRIES; pte++){
  803d23:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
  803d28:	48 81 7d e0 ff 01 00 	cmpq   $0x1ff,-0x20(%rbp)
  803d2f:	00 
  803d30:	0f 86 79 ff ff ff    	jbe    803caf <copy_shared_pages+0xd6>
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
				if(uvpde[base_pml4e + pdpe] & PTE_P){
					base_pdpe = (base_pml4e + pdpe) * NPDENTRIES;
					for(pde = 0; pde < NPDENTRIES; pde++){
  803d36:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803d3b:	48 81 7d e8 ff 01 00 	cmpq   $0x1ff,-0x18(%rbp)
  803d42:	00 
  803d43:	0f 86 24 ff ff ff    	jbe    803c6d <copy_shared_pages+0x94>
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
		if(uvpml4e[pml4e] & PTE_P){
			base_pml4e = pml4e * NPDPENTRIES;
			for(pdpe = 0; pdpe < NPDPENTRIES; pdpe++){
  803d49:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  803d4e:	48 81 7d f0 ff 01 00 	cmpq   $0x1ff,-0x10(%rbp)
  803d55:	00 
  803d56:	0f 86 cc fe ff ff    	jbe    803c28 <copy_shared_pages+0x4f>
{
	// LAB 5: Your code here.
	int r, perm;
	void* va;
	uint64_t pml4e, pdpe, pde, pte, base_pml4e, base_pdpe, base_pde, entry;
	for(pml4e = 0; pml4e < VPML4E(UTOP); pml4e++){
  803d5c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d61:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d66:	0f 84 85 fe ff ff    	je     803bf1 <copy_shared_pages+0x18>
					}
				}
			}
		}
	}
	return 0;
  803d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d71:	c9                   	leaveq 
  803d72:	c3                   	retq   

0000000000803d73 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803d73:	55                   	push   %rbp
  803d74:	48 89 e5             	mov    %rsp,%rbp
  803d77:	53                   	push   %rbx
  803d78:	48 83 ec 38          	sub    $0x38,%rsp
  803d7c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803d80:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803d84:	48 89 c7             	mov    %rax,%rdi
  803d87:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  803d8e:	00 00 00 
  803d91:	ff d0                	callq  *%rax
  803d93:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803d96:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d9a:	0f 88 bf 01 00 00    	js     803f5f <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803da0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803da4:	ba 07 04 00 00       	mov    $0x407,%edx
  803da9:	48 89 c6             	mov    %rax,%rsi
  803dac:	bf 00 00 00 00       	mov    $0x0,%edi
  803db1:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  803db8:	00 00 00 
  803dbb:	ff d0                	callq  *%rax
  803dbd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803dc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803dc4:	0f 88 95 01 00 00    	js     803f5f <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803dca:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803dce:	48 89 c7             	mov    %rax,%rdi
  803dd1:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  803dd8:	00 00 00 
  803ddb:	ff d0                	callq  *%rax
  803ddd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803de0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803de4:	0f 88 5d 01 00 00    	js     803f47 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803dea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dee:	ba 07 04 00 00       	mov    $0x407,%edx
  803df3:	48 89 c6             	mov    %rax,%rsi
  803df6:	bf 00 00 00 00       	mov    $0x0,%edi
  803dfb:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  803e02:	00 00 00 
  803e05:	ff d0                	callq  *%rax
  803e07:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e0e:	0f 88 33 01 00 00    	js     803f47 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803e14:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e18:	48 89 c7             	mov    %rax,%rdi
  803e1b:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  803e22:	00 00 00 
  803e25:	ff d0                	callq  *%rax
  803e27:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e2f:	ba 07 04 00 00       	mov    $0x407,%edx
  803e34:	48 89 c6             	mov    %rax,%rsi
  803e37:	bf 00 00 00 00       	mov    $0x0,%edi
  803e3c:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  803e43:	00 00 00 
  803e46:	ff d0                	callq  *%rax
  803e48:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e4f:	79 05                	jns    803e56 <pipe+0xe3>
		goto err2;
  803e51:	e9 d9 00 00 00       	jmpq   803f2f <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e56:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e5a:	48 89 c7             	mov    %rax,%rdi
  803e5d:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  803e64:	00 00 00 
  803e67:	ff d0                	callq  *%rax
  803e69:	48 89 c2             	mov    %rax,%rdx
  803e6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e70:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803e76:	48 89 d1             	mov    %rdx,%rcx
  803e79:	ba 00 00 00 00       	mov    $0x0,%edx
  803e7e:	48 89 c6             	mov    %rax,%rsi
  803e81:	bf 00 00 00 00       	mov    $0x0,%edi
  803e86:	48 b8 c8 1a 80 00 00 	movabs $0x801ac8,%rax
  803e8d:	00 00 00 
  803e90:	ff d0                	callq  *%rax
  803e92:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e95:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e99:	79 1b                	jns    803eb6 <pipe+0x143>
		goto err3;
  803e9b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803e9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ea0:	48 89 c6             	mov    %rax,%rsi
  803ea3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ea8:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  803eaf:	00 00 00 
  803eb2:	ff d0                	callq  *%rax
  803eb4:	eb 79                	jmp    803f2f <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803eb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eba:	48 ba 80 70 80 00 00 	movabs $0x807080,%rdx
  803ec1:	00 00 00 
  803ec4:	8b 12                	mov    (%rdx),%edx
  803ec6:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803ec8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ecc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803ed3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ed7:	48 ba 80 70 80 00 00 	movabs $0x807080,%rdx
  803ede:	00 00 00 
  803ee1:	8b 12                	mov    (%rdx),%edx
  803ee3:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803ee5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ee9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803ef0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef4:	48 89 c7             	mov    %rax,%rdi
  803ef7:	48 b8 30 22 80 00 00 	movabs $0x802230,%rax
  803efe:	00 00 00 
  803f01:	ff d0                	callq  *%rax
  803f03:	89 c2                	mov    %eax,%edx
  803f05:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f09:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803f0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f0f:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803f13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f17:	48 89 c7             	mov    %rax,%rdi
  803f1a:	48 b8 30 22 80 00 00 	movabs $0x802230,%rax
  803f21:	00 00 00 
  803f24:	ff d0                	callq  *%rax
  803f26:	89 03                	mov    %eax,(%rbx)
	return 0;
  803f28:	b8 00 00 00 00       	mov    $0x0,%eax
  803f2d:	eb 33                	jmp    803f62 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803f2f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f33:	48 89 c6             	mov    %rax,%rsi
  803f36:	bf 00 00 00 00       	mov    $0x0,%edi
  803f3b:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  803f42:	00 00 00 
  803f45:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803f47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f4b:	48 89 c6             	mov    %rax,%rsi
  803f4e:	bf 00 00 00 00       	mov    $0x0,%edi
  803f53:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  803f5a:	00 00 00 
  803f5d:	ff d0                	callq  *%rax
err:
	return r;
  803f5f:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803f62:	48 83 c4 38          	add    $0x38,%rsp
  803f66:	5b                   	pop    %rbx
  803f67:	5d                   	pop    %rbp
  803f68:	c3                   	retq   

0000000000803f69 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803f69:	55                   	push   %rbp
  803f6a:	48 89 e5             	mov    %rsp,%rbp
  803f6d:	53                   	push   %rbx
  803f6e:	48 83 ec 28          	sub    $0x28,%rsp
  803f72:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f76:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803f7a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803f81:	00 00 00 
  803f84:	48 8b 00             	mov    (%rax),%rax
  803f87:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803f8d:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803f90:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f94:	48 89 c7             	mov    %rax,%rdi
  803f97:	48 b8 90 49 80 00 00 	movabs $0x804990,%rax
  803f9e:	00 00 00 
  803fa1:	ff d0                	callq  *%rax
  803fa3:	89 c3                	mov    %eax,%ebx
  803fa5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fa9:	48 89 c7             	mov    %rax,%rdi
  803fac:	48 b8 90 49 80 00 00 	movabs $0x804990,%rax
  803fb3:	00 00 00 
  803fb6:	ff d0                	callq  *%rax
  803fb8:	39 c3                	cmp    %eax,%ebx
  803fba:	0f 94 c0             	sete   %al
  803fbd:	0f b6 c0             	movzbl %al,%eax
  803fc0:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803fc3:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803fca:	00 00 00 
  803fcd:	48 8b 00             	mov    (%rax),%rax
  803fd0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803fd6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803fd9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fdc:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fdf:	75 05                	jne    803fe6 <_pipeisclosed+0x7d>
			return ret;
  803fe1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803fe4:	eb 4f                	jmp    804035 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803fe6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fe9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803fec:	74 42                	je     804030 <_pipeisclosed+0xc7>
  803fee:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803ff2:	75 3c                	jne    804030 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803ff4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ffb:	00 00 00 
  803ffe:	48 8b 00             	mov    (%rax),%rax
  804001:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804007:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80400a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80400d:	89 c6                	mov    %eax,%esi
  80400f:	48 bf 15 52 80 00 00 	movabs $0x805215,%rdi
  804016:	00 00 00 
  804019:	b8 00 00 00 00       	mov    $0x0,%eax
  80401e:	49 b8 94 05 80 00 00 	movabs $0x800594,%r8
  804025:	00 00 00 
  804028:	41 ff d0             	callq  *%r8
	}
  80402b:	e9 4a ff ff ff       	jmpq   803f7a <_pipeisclosed+0x11>
  804030:	e9 45 ff ff ff       	jmpq   803f7a <_pipeisclosed+0x11>
}
  804035:	48 83 c4 28          	add    $0x28,%rsp
  804039:	5b                   	pop    %rbx
  80403a:	5d                   	pop    %rbp
  80403b:	c3                   	retq   

000000000080403c <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80403c:	55                   	push   %rbp
  80403d:	48 89 e5             	mov    %rsp,%rbp
  804040:	48 83 ec 30          	sub    $0x30,%rsp
  804044:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804047:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80404b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80404e:	48 89 d6             	mov    %rdx,%rsi
  804051:	89 c7                	mov    %eax,%edi
  804053:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  80405a:	00 00 00 
  80405d:	ff d0                	callq  *%rax
  80405f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804062:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804066:	79 05                	jns    80406d <pipeisclosed+0x31>
		return r;
  804068:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80406b:	eb 31                	jmp    80409e <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80406d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804071:	48 89 c7             	mov    %rax,%rdi
  804074:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  80407b:	00 00 00 
  80407e:	ff d0                	callq  *%rax
  804080:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804084:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804088:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80408c:	48 89 d6             	mov    %rdx,%rsi
  80408f:	48 89 c7             	mov    %rax,%rdi
  804092:	48 b8 69 3f 80 00 00 	movabs $0x803f69,%rax
  804099:	00 00 00 
  80409c:	ff d0                	callq  *%rax
}
  80409e:	c9                   	leaveq 
  80409f:	c3                   	retq   

00000000008040a0 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040a0:	55                   	push   %rbp
  8040a1:	48 89 e5             	mov    %rsp,%rbp
  8040a4:	48 83 ec 40          	sub    $0x40,%rsp
  8040a8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040ac:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8040b0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8040b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040b8:	48 89 c7             	mov    %rax,%rdi
  8040bb:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  8040c2:	00 00 00 
  8040c5:	ff d0                	callq  *%rax
  8040c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8040cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040cf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8040d3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8040da:	00 
  8040db:	e9 92 00 00 00       	jmpq   804172 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  8040e0:	eb 41                	jmp    804123 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8040e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8040e7:	74 09                	je     8040f2 <devpipe_read+0x52>
				return i;
  8040e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ed:	e9 92 00 00 00       	jmpq   804184 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8040f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8040f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040fa:	48 89 d6             	mov    %rdx,%rsi
  8040fd:	48 89 c7             	mov    %rax,%rdi
  804100:	48 b8 69 3f 80 00 00 	movabs $0x803f69,%rax
  804107:	00 00 00 
  80410a:	ff d0                	callq  *%rax
  80410c:	85 c0                	test   %eax,%eax
  80410e:	74 07                	je     804117 <devpipe_read+0x77>
				return 0;
  804110:	b8 00 00 00 00       	mov    $0x0,%eax
  804115:	eb 6d                	jmp    804184 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804117:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  80411e:	00 00 00 
  804121:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804123:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804127:	8b 10                	mov    (%rax),%edx
  804129:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80412d:	8b 40 04             	mov    0x4(%rax),%eax
  804130:	39 c2                	cmp    %eax,%edx
  804132:	74 ae                	je     8040e2 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804138:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80413c:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804140:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804144:	8b 00                	mov    (%rax),%eax
  804146:	99                   	cltd   
  804147:	c1 ea 1b             	shr    $0x1b,%edx
  80414a:	01 d0                	add    %edx,%eax
  80414c:	83 e0 1f             	and    $0x1f,%eax
  80414f:	29 d0                	sub    %edx,%eax
  804151:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804155:	48 98                	cltq   
  804157:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80415c:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80415e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804162:	8b 00                	mov    (%rax),%eax
  804164:	8d 50 01             	lea    0x1(%rax),%edx
  804167:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80416b:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80416d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804172:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804176:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80417a:	0f 82 60 ff ff ff    	jb     8040e0 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804180:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804184:	c9                   	leaveq 
  804185:	c3                   	retq   

0000000000804186 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804186:	55                   	push   %rbp
  804187:	48 89 e5             	mov    %rsp,%rbp
  80418a:	48 83 ec 40          	sub    $0x40,%rsp
  80418e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804192:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804196:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80419a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80419e:	48 89 c7             	mov    %rax,%rdi
  8041a1:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  8041a8:	00 00 00 
  8041ab:	ff d0                	callq  *%rax
  8041ad:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8041b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8041b9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8041c0:	00 
  8041c1:	e9 8e 00 00 00       	jmpq   804254 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8041c6:	eb 31                	jmp    8041f9 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8041c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041d0:	48 89 d6             	mov    %rdx,%rsi
  8041d3:	48 89 c7             	mov    %rax,%rdi
  8041d6:	48 b8 69 3f 80 00 00 	movabs $0x803f69,%rax
  8041dd:	00 00 00 
  8041e0:	ff d0                	callq  *%rax
  8041e2:	85 c0                	test   %eax,%eax
  8041e4:	74 07                	je     8041ed <devpipe_write+0x67>
				return 0;
  8041e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8041eb:	eb 79                	jmp    804266 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8041ed:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  8041f4:	00 00 00 
  8041f7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8041f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041fd:	8b 40 04             	mov    0x4(%rax),%eax
  804200:	48 63 d0             	movslq %eax,%rdx
  804203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804207:	8b 00                	mov    (%rax),%eax
  804209:	48 98                	cltq   
  80420b:	48 83 c0 20          	add    $0x20,%rax
  80420f:	48 39 c2             	cmp    %rax,%rdx
  804212:	73 b4                	jae    8041c8 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804218:	8b 40 04             	mov    0x4(%rax),%eax
  80421b:	99                   	cltd   
  80421c:	c1 ea 1b             	shr    $0x1b,%edx
  80421f:	01 d0                	add    %edx,%eax
  804221:	83 e0 1f             	and    $0x1f,%eax
  804224:	29 d0                	sub    %edx,%eax
  804226:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80422a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80422e:	48 01 ca             	add    %rcx,%rdx
  804231:	0f b6 0a             	movzbl (%rdx),%ecx
  804234:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804238:	48 98                	cltq   
  80423a:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80423e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804242:	8b 40 04             	mov    0x4(%rax),%eax
  804245:	8d 50 01             	lea    0x1(%rax),%edx
  804248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80424c:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80424f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804254:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804258:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80425c:	0f 82 64 ff ff ff    	jb     8041c6 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804266:	c9                   	leaveq 
  804267:	c3                   	retq   

0000000000804268 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804268:	55                   	push   %rbp
  804269:	48 89 e5             	mov    %rsp,%rbp
  80426c:	48 83 ec 20          	sub    $0x20,%rsp
  804270:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804274:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80427c:	48 89 c7             	mov    %rax,%rdi
  80427f:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  804286:	00 00 00 
  804289:	ff d0                	callq  *%rax
  80428b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80428f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804293:	48 be 28 52 80 00 00 	movabs $0x805228,%rsi
  80429a:	00 00 00 
  80429d:	48 89 c7             	mov    %rax,%rdi
  8042a0:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  8042a7:	00 00 00 
  8042aa:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8042ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042b0:	8b 50 04             	mov    0x4(%rax),%edx
  8042b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042b7:	8b 00                	mov    (%rax),%eax
  8042b9:	29 c2                	sub    %eax,%edx
  8042bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042bf:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8042c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042c9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8042d0:	00 00 00 
	stat->st_dev = &devpipe;
  8042d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042d7:	48 b9 80 70 80 00 00 	movabs $0x807080,%rcx
  8042de:	00 00 00 
  8042e1:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8042e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042ed:	c9                   	leaveq 
  8042ee:	c3                   	retq   

00000000008042ef <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8042ef:	55                   	push   %rbp
  8042f0:	48 89 e5             	mov    %rsp,%rbp
  8042f3:	48 83 ec 10          	sub    $0x10,%rsp
  8042f7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  8042fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ff:	48 89 c6             	mov    %rax,%rsi
  804302:	bf 00 00 00 00       	mov    $0x0,%edi
  804307:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  80430e:	00 00 00 
  804311:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  804313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804317:	48 89 c7             	mov    %rax,%rdi
  80431a:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  804321:	00 00 00 
  804324:	ff d0                	callq  *%rax
  804326:	48 89 c6             	mov    %rax,%rsi
  804329:	bf 00 00 00 00       	mov    $0x0,%edi
  80432e:	48 b8 23 1b 80 00 00 	movabs $0x801b23,%rax
  804335:	00 00 00 
  804338:	ff d0                	callq  *%rax
}
  80433a:	c9                   	leaveq 
  80433b:	c3                   	retq   

000000000080433c <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80433c:	55                   	push   %rbp
  80433d:	48 89 e5             	mov    %rsp,%rbp
  804340:	48 83 ec 20          	sub    $0x20,%rsp
  804344:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  804347:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80434b:	75 35                	jne    804382 <wait+0x46>
  80434d:	48 b9 2f 52 80 00 00 	movabs $0x80522f,%rcx
  804354:	00 00 00 
  804357:	48 ba 3a 52 80 00 00 	movabs $0x80523a,%rdx
  80435e:	00 00 00 
  804361:	be 09 00 00 00       	mov    $0x9,%esi
  804366:	48 bf 4f 52 80 00 00 	movabs $0x80524f,%rdi
  80436d:	00 00 00 
  804370:	b8 00 00 00 00       	mov    $0x0,%eax
  804375:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  80437c:	00 00 00 
  80437f:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804382:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804385:	25 ff 03 00 00       	and    $0x3ff,%eax
  80438a:	48 63 d0             	movslq %eax,%rdx
  80438d:	48 89 d0             	mov    %rdx,%rax
  804390:	48 c1 e0 03          	shl    $0x3,%rax
  804394:	48 01 d0             	add    %rdx,%rax
  804397:	48 c1 e0 05          	shl    $0x5,%rax
  80439b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8043a2:	00 00 00 
  8043a5:	48 01 d0             	add    %rdx,%rax
  8043a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8043ac:	eb 0c                	jmp    8043ba <wait+0x7e>
		sys_yield();
  8043ae:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  8043b5:	00 00 00 
  8043b8:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8043ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043be:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8043c4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8043c7:	75 0e                	jne    8043d7 <wait+0x9b>
  8043c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043cd:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  8043d3:	85 c0                	test   %eax,%eax
  8043d5:	75 d7                	jne    8043ae <wait+0x72>
		sys_yield();
}
  8043d7:	c9                   	leaveq 
  8043d8:	c3                   	retq   

00000000008043d9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8043d9:	55                   	push   %rbp
  8043da:	48 89 e5             	mov    %rsp,%rbp
  8043dd:	48 83 ec 20          	sub    $0x20,%rsp
  8043e1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8043e4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043e7:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8043ea:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8043ee:	be 01 00 00 00       	mov    $0x1,%esi
  8043f3:	48 89 c7             	mov    %rax,%rdi
  8043f6:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  8043fd:	00 00 00 
  804400:	ff d0                	callq  *%rax
}
  804402:	c9                   	leaveq 
  804403:	c3                   	retq   

0000000000804404 <getchar>:

int
getchar(void)
{
  804404:	55                   	push   %rbp
  804405:	48 89 e5             	mov    %rsp,%rbp
  804408:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80440c:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804410:	ba 01 00 00 00       	mov    $0x1,%edx
  804415:	48 89 c6             	mov    %rax,%rsi
  804418:	bf 00 00 00 00       	mov    $0x0,%edi
  80441d:	48 b8 48 27 80 00 00 	movabs $0x802748,%rax
  804424:	00 00 00 
  804427:	ff d0                	callq  *%rax
  804429:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80442c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804430:	79 05                	jns    804437 <getchar+0x33>
		return r;
  804432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804435:	eb 14                	jmp    80444b <getchar+0x47>
	if (r < 1)
  804437:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80443b:	7f 07                	jg     804444 <getchar+0x40>
		return -E_EOF;
  80443d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804442:	eb 07                	jmp    80444b <getchar+0x47>
	return c;
  804444:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804448:	0f b6 c0             	movzbl %al,%eax
}
  80444b:	c9                   	leaveq 
  80444c:	c3                   	retq   

000000000080444d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80444d:	55                   	push   %rbp
  80444e:	48 89 e5             	mov    %rsp,%rbp
  804451:	48 83 ec 20          	sub    $0x20,%rsp
  804455:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804458:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80445c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80445f:	48 89 d6             	mov    %rdx,%rsi
  804462:	89 c7                	mov    %eax,%edi
  804464:	48 b8 16 23 80 00 00 	movabs $0x802316,%rax
  80446b:	00 00 00 
  80446e:	ff d0                	callq  *%rax
  804470:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804473:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804477:	79 05                	jns    80447e <iscons+0x31>
		return r;
  804479:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80447c:	eb 1a                	jmp    804498 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80447e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804482:	8b 10                	mov    (%rax),%edx
  804484:	48 b8 c0 70 80 00 00 	movabs $0x8070c0,%rax
  80448b:	00 00 00 
  80448e:	8b 00                	mov    (%rax),%eax
  804490:	39 c2                	cmp    %eax,%edx
  804492:	0f 94 c0             	sete   %al
  804495:	0f b6 c0             	movzbl %al,%eax
}
  804498:	c9                   	leaveq 
  804499:	c3                   	retq   

000000000080449a <opencons>:

int
opencons(void)
{
  80449a:	55                   	push   %rbp
  80449b:	48 89 e5             	mov    %rsp,%rbp
  80449e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8044a2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8044a6:	48 89 c7             	mov    %rax,%rdi
  8044a9:	48 b8 7e 22 80 00 00 	movabs $0x80227e,%rax
  8044b0:	00 00 00 
  8044b3:	ff d0                	callq  *%rax
  8044b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044bc:	79 05                	jns    8044c3 <opencons+0x29>
		return r;
  8044be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044c1:	eb 5b                	jmp    80451e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8044c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c7:	ba 07 04 00 00       	mov    $0x407,%edx
  8044cc:	48 89 c6             	mov    %rax,%rsi
  8044cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8044d4:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  8044db:	00 00 00 
  8044de:	ff d0                	callq  *%rax
  8044e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044e7:	79 05                	jns    8044ee <opencons+0x54>
		return r;
  8044e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044ec:	eb 30                	jmp    80451e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8044ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044f2:	48 ba c0 70 80 00 00 	movabs $0x8070c0,%rdx
  8044f9:	00 00 00 
  8044fc:	8b 12                	mov    (%rdx),%edx
  8044fe:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804504:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80450b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80450f:	48 89 c7             	mov    %rax,%rdi
  804512:	48 b8 30 22 80 00 00 	movabs $0x802230,%rax
  804519:	00 00 00 
  80451c:	ff d0                	callq  *%rax
}
  80451e:	c9                   	leaveq 
  80451f:	c3                   	retq   

0000000000804520 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804520:	55                   	push   %rbp
  804521:	48 89 e5             	mov    %rsp,%rbp
  804524:	48 83 ec 30          	sub    $0x30,%rsp
  804528:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80452c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804530:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804534:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804539:	75 07                	jne    804542 <devcons_read+0x22>
		return 0;
  80453b:	b8 00 00 00 00       	mov    $0x0,%eax
  804540:	eb 4b                	jmp    80458d <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804542:	eb 0c                	jmp    804550 <devcons_read+0x30>
		sys_yield();
  804544:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  80454b:	00 00 00 
  80454e:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804550:	48 b8 7a 19 80 00 00 	movabs $0x80197a,%rax
  804557:	00 00 00 
  80455a:	ff d0                	callq  *%rax
  80455c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80455f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804563:	74 df                	je     804544 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  804565:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804569:	79 05                	jns    804570 <devcons_read+0x50>
		return c;
  80456b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80456e:	eb 1d                	jmp    80458d <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804570:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804574:	75 07                	jne    80457d <devcons_read+0x5d>
		return 0;
  804576:	b8 00 00 00 00       	mov    $0x0,%eax
  80457b:	eb 10                	jmp    80458d <devcons_read+0x6d>
	*(char*)vbuf = c;
  80457d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804580:	89 c2                	mov    %eax,%edx
  804582:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804586:	88 10                	mov    %dl,(%rax)
	return 1;
  804588:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80458d:	c9                   	leaveq 
  80458e:	c3                   	retq   

000000000080458f <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80458f:	55                   	push   %rbp
  804590:	48 89 e5             	mov    %rsp,%rbp
  804593:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80459a:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8045a1:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8045a8:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045b6:	eb 76                	jmp    80462e <devcons_write+0x9f>
		m = n - tot;
  8045b8:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8045bf:	89 c2                	mov    %eax,%edx
  8045c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045c4:	29 c2                	sub    %eax,%edx
  8045c6:	89 d0                	mov    %edx,%eax
  8045c8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8045cb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045ce:	83 f8 7f             	cmp    $0x7f,%eax
  8045d1:	76 07                	jbe    8045da <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8045d3:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8045da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045dd:	48 63 d0             	movslq %eax,%rdx
  8045e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e3:	48 63 c8             	movslq %eax,%rcx
  8045e6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8045ed:	48 01 c1             	add    %rax,%rcx
  8045f0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045f7:	48 89 ce             	mov    %rcx,%rsi
  8045fa:	48 89 c7             	mov    %rax,%rdi
  8045fd:	48 b8 6d 14 80 00 00 	movabs $0x80146d,%rax
  804604:	00 00 00 
  804607:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804609:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80460c:	48 63 d0             	movslq %eax,%rdx
  80460f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804616:	48 89 d6             	mov    %rdx,%rsi
  804619:	48 89 c7             	mov    %rax,%rdi
  80461c:	48 b8 30 19 80 00 00 	movabs $0x801930,%rax
  804623:	00 00 00 
  804626:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804628:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80462b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80462e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804631:	48 98                	cltq   
  804633:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80463a:	0f 82 78 ff ff ff    	jb     8045b8 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804640:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804643:	c9                   	leaveq 
  804644:	c3                   	retq   

0000000000804645 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804645:	55                   	push   %rbp
  804646:	48 89 e5             	mov    %rsp,%rbp
  804649:	48 83 ec 08          	sub    $0x8,%rsp
  80464d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804651:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804656:	c9                   	leaveq 
  804657:	c3                   	retq   

0000000000804658 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804658:	55                   	push   %rbp
  804659:	48 89 e5             	mov    %rsp,%rbp
  80465c:	48 83 ec 10          	sub    $0x10,%rsp
  804660:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804664:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80466c:	48 be 5f 52 80 00 00 	movabs $0x80525f,%rsi
  804673:	00 00 00 
  804676:	48 89 c7             	mov    %rax,%rdi
  804679:	48 b8 49 11 80 00 00 	movabs $0x801149,%rax
  804680:	00 00 00 
  804683:	ff d0                	callq  *%rax
	return 0;
  804685:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80468a:	c9                   	leaveq 
  80468b:	c3                   	retq   

000000000080468c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80468c:	55                   	push   %rbp
  80468d:	48 89 e5             	mov    %rsp,%rbp
  804690:	48 83 ec 10          	sub    $0x10,%rsp
  804694:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804698:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  80469f:	00 00 00 
  8046a2:	48 8b 00             	mov    (%rax),%rax
  8046a5:	48 85 c0             	test   %rax,%rax
  8046a8:	75 64                	jne    80470e <set_pgfault_handler+0x82>
		// First time through!
		// LAB 4: Your code here.
		//envid_t eid = sys_getenvid();
		if(sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) 
  8046aa:	ba 07 00 00 00       	mov    $0x7,%edx
  8046af:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8046b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8046b9:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  8046c0:	00 00 00 
  8046c3:	ff d0                	callq  *%rax
  8046c5:	85 c0                	test   %eax,%eax
  8046c7:	74 2a                	je     8046f3 <set_pgfault_handler+0x67>
			panic("Allocation of space for UXSTACK failed\n");
  8046c9:	48 ba 68 52 80 00 00 	movabs $0x805268,%rdx
  8046d0:	00 00 00 
  8046d3:	be 22 00 00 00       	mov    $0x22,%esi
  8046d8:	48 bf 90 52 80 00 00 	movabs $0x805290,%rdi
  8046df:	00 00 00 
  8046e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8046e7:	48 b9 5b 03 80 00 00 	movabs $0x80035b,%rcx
  8046ee:	00 00 00 
  8046f1:	ff d1                	callq  *%rcx
		else
			sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8046f3:	48 be 21 47 80 00 00 	movabs $0x804721,%rsi
  8046fa:	00 00 00 
  8046fd:	bf 00 00 00 00       	mov    $0x0,%edi
  804702:	48 b8 02 1c 80 00 00 	movabs $0x801c02,%rax
  804709:	00 00 00 
  80470c:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80470e:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  804715:	00 00 00 
  804718:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80471c:	48 89 10             	mov    %rdx,(%rax)
}
  80471f:	c9                   	leaveq 
  804720:	c3                   	retq   

0000000000804721 <_pgfault_upcall>:
// Call the C page fault handler.
// function argument: pointer to UTF



movq  %rsp,%rdi                // passing the function argument in rdi
  804721:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804724:	48 a1 08 a0 80 00 00 	movabs 0x80a008,%rax
  80472b:	00 00 00 
call *%rax
  80472e:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
mov 152(%rsp), %r8
  804730:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
  804737:	00 
mov 136(%rsp), %r9
  804738:	4c 8b 8c 24 88 00 00 	mov    0x88(%rsp),%r9
  80473f:	00 
sub $8, %r8
  804740:	49 83 e8 08          	sub    $0x8,%r8
mov %r9, (%r8)
  804744:	4d 89 08             	mov    %r9,(%r8)
mov %r8, 152(%rsp)
  804747:	4c 89 84 24 98 00 00 	mov    %r8,0x98(%rsp)
  80474e:	00 
add $16, %rsp
  80474f:	48 83 c4 10          	add    $0x10,%rsp

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
POPA_
  804753:	4c 8b 3c 24          	mov    (%rsp),%r15
  804757:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80475c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804761:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804766:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80476b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804770:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804775:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80477a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80477f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804784:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804789:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80478e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804793:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804798:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80479d:	48 83 c4 78          	add    $0x78,%rsp
    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
		// LAB 4: Your code here.
add $8, %rsp
  8047a1:	48 83 c4 08          	add    $0x8,%rsp
popf
  8047a5:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
mov (%rsp), %rsp
  8047a6:	48 8b 24 24          	mov    (%rsp),%rsp
    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
ret
  8047aa:	c3                   	retq   

00000000008047ab <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8047ab:	55                   	push   %rbp
  8047ac:	48 89 e5             	mov    %rsp,%rbp
  8047af:	48 83 ec 30          	sub    $0x30,%rsp
  8047b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  8047bf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047c4:	74 18                	je     8047de <ipc_recv+0x33>
  8047c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047ca:	48 89 c7             	mov    %rax,%rdi
  8047cd:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  8047d4:	00 00 00 
  8047d7:	ff d0                	callq  *%rax
  8047d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047dc:	eb 19                	jmp    8047f7 <ipc_recv+0x4c>
  8047de:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  8047e5:	00 00 00 
  8047e8:	48 b8 a1 1c 80 00 00 	movabs $0x801ca1,%rax
  8047ef:	00 00 00 
  8047f2:	ff d0                	callq  *%rax
  8047f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8047f7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047fc:	74 26                	je     804824 <ipc_recv+0x79>
  8047fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804802:	75 15                	jne    804819 <ipc_recv+0x6e>
  804804:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80480b:	00 00 00 
  80480e:	48 8b 00             	mov    (%rax),%rax
  804811:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  804817:	eb 05                	jmp    80481e <ipc_recv+0x73>
  804819:	b8 00 00 00 00       	mov    $0x0,%eax
  80481e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804822:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  804824:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804829:	74 26                	je     804851 <ipc_recv+0xa6>
  80482b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80482f:	75 15                	jne    804846 <ipc_recv+0x9b>
  804831:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804838:	00 00 00 
  80483b:	48 8b 00             	mov    (%rax),%rax
  80483e:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  804844:	eb 05                	jmp    80484b <ipc_recv+0xa0>
  804846:	b8 00 00 00 00       	mov    $0x0,%eax
  80484b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80484f:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  804851:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804855:	75 15                	jne    80486c <ipc_recv+0xc1>
  804857:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80485e:	00 00 00 
  804861:	48 8b 00             	mov    (%rax),%rax
  804864:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  80486a:	eb 03                	jmp    80486f <ipc_recv+0xc4>
  80486c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80486f:	c9                   	leaveq 
  804870:	c3                   	retq   

0000000000804871 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804871:	55                   	push   %rbp
  804872:	48 89 e5             	mov    %rsp,%rbp
  804875:	48 83 ec 30          	sub    $0x30,%rsp
  804879:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80487c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80487f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804883:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  804886:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  80488d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804892:	75 10                	jne    8048a4 <ipc_send+0x33>
  804894:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80489b:	00 00 00 
  80489e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  8048a2:	eb 62                	jmp    804906 <ipc_send+0x95>
  8048a4:	eb 60                	jmp    804906 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  8048a6:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8048aa:	74 30                	je     8048dc <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  8048ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048af:	89 c1                	mov    %eax,%ecx
  8048b1:	48 ba 9e 52 80 00 00 	movabs $0x80529e,%rdx
  8048b8:	00 00 00 
  8048bb:	be 33 00 00 00       	mov    $0x33,%esi
  8048c0:	48 bf ba 52 80 00 00 	movabs $0x8052ba,%rdi
  8048c7:	00 00 00 
  8048ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8048cf:	49 b8 5b 03 80 00 00 	movabs $0x80035b,%r8
  8048d6:	00 00 00 
  8048d9:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  8048dc:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8048df:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8048e2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8048e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048e9:	89 c7                	mov    %eax,%edi
  8048eb:	48 b8 4c 1c 80 00 00 	movabs $0x801c4c,%rax
  8048f2:	00 00 00 
  8048f5:	ff d0                	callq  *%rax
  8048f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8048fa:	48 b8 3a 1a 80 00 00 	movabs $0x801a3a,%rax
  804901:	00 00 00 
  804904:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  804906:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80490a:	75 9a                	jne    8048a6 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  80490c:	c9                   	leaveq 
  80490d:	c3                   	retq   

000000000080490e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80490e:	55                   	push   %rbp
  80490f:	48 89 e5             	mov    %rsp,%rbp
  804912:	48 83 ec 14          	sub    $0x14,%rsp
  804916:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804919:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804920:	eb 5e                	jmp    804980 <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  804922:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804929:	00 00 00 
  80492c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80492f:	48 63 d0             	movslq %eax,%rdx
  804932:	48 89 d0             	mov    %rdx,%rax
  804935:	48 c1 e0 03          	shl    $0x3,%rax
  804939:	48 01 d0             	add    %rdx,%rax
  80493c:	48 c1 e0 05          	shl    $0x5,%rax
  804940:	48 01 c8             	add    %rcx,%rax
  804943:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804949:	8b 00                	mov    (%rax),%eax
  80494b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80494e:	75 2c                	jne    80497c <ipc_find_env+0x6e>
			return envs[i].env_id;
  804950:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  804957:	00 00 00 
  80495a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80495d:	48 63 d0             	movslq %eax,%rdx
  804960:	48 89 d0             	mov    %rdx,%rax
  804963:	48 c1 e0 03          	shl    $0x3,%rax
  804967:	48 01 d0             	add    %rdx,%rax
  80496a:	48 c1 e0 05          	shl    $0x5,%rax
  80496e:	48 01 c8             	add    %rcx,%rax
  804971:	48 05 c0 00 00 00    	add    $0xc0,%rax
  804977:	8b 40 08             	mov    0x8(%rax),%eax
  80497a:	eb 12                	jmp    80498e <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  80497c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804980:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804987:	7e 99                	jle    804922 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804989:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80498e:	c9                   	leaveq 
  80498f:	c3                   	retq   

0000000000804990 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  804990:	55                   	push   %rbp
  804991:	48 89 e5             	mov    %rsp,%rbp
  804994:	48 83 ec 18          	sub    $0x18,%rsp
  804998:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80499c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049a0:	48 c1 e8 15          	shr    $0x15,%rax
  8049a4:	48 89 c2             	mov    %rax,%rdx
  8049a7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8049ae:	01 00 00 
  8049b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8049b5:	83 e0 01             	and    $0x1,%eax
  8049b8:	48 85 c0             	test   %rax,%rax
  8049bb:	75 07                	jne    8049c4 <pageref+0x34>
		return 0;
  8049bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8049c2:	eb 53                	jmp    804a17 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8049c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049c8:	48 c1 e8 0c          	shr    $0xc,%rax
  8049cc:	48 89 c2             	mov    %rax,%rdx
  8049cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8049d6:	01 00 00 
  8049d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8049dd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8049e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049e5:	83 e0 01             	and    $0x1,%eax
  8049e8:	48 85 c0             	test   %rax,%rax
  8049eb:	75 07                	jne    8049f4 <pageref+0x64>
		return 0;
  8049ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8049f2:	eb 23                	jmp    804a17 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8049f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049f8:	48 c1 e8 0c          	shr    $0xc,%rax
  8049fc:	48 89 c2             	mov    %rax,%rdx
  8049ff:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804a06:	00 00 00 
  804a09:	48 c1 e2 04          	shl    $0x4,%rdx
  804a0d:	48 01 d0             	add    %rdx,%rax
  804a10:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804a14:	0f b7 c0             	movzwl %ax,%eax
}
  804a17:	c9                   	leaveq 
  804a18:	c3                   	retq   
