
obj/user/testbss:     file format elf64-x86-64


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
  80003c:	e8 6e 01 00 00       	callq  8001af <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;

	cprintf("Making sure bss works right...\n");
  800052:	48 bf 60 19 80 00 00 	movabs $0x801960,%rdi
  800059:	00 00 00 
  80005c:	b8 00 00 00 00       	mov    $0x0,%eax
  800061:	48 ba 89 04 80 00 00 	movabs $0x800489,%rdx
  800068:	00 00 00 
  80006b:	ff d2                	callq  *%rdx
	for (i = 0; i < ARRAYSIZE; i++)
  80006d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800074:	eb 4b                	jmp    8000c1 <umain+0x7e>
		if (bigarray[i] != 0)
  800076:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  80007d:	00 00 00 
  800080:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800083:	48 63 d2             	movslq %edx,%rdx
  800086:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  800089:	85 c0                	test   %eax,%eax
  80008b:	74 30                	je     8000bd <umain+0x7a>
			panic("bigarray[%d] isn't cleared!\n", i);
  80008d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800090:	89 c1                	mov    %eax,%ecx
  800092:	48 ba 80 19 80 00 00 	movabs $0x801980,%rdx
  800099:	00 00 00 
  80009c:	be 11 00 00 00       	mov    $0x11,%esi
  8000a1:	48 bf 9d 19 80 00 00 	movabs $0x80199d,%rdi
  8000a8:	00 00 00 
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	49 b8 50 02 80 00 00 	movabs $0x800250,%r8
  8000b7:	00 00 00 
  8000ba:	41 ff d0             	callq  *%r8
umain(int argc, char **argv)
{
	int i;

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
  8000bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000c1:	81 7d fc ff ff 0f 00 	cmpl   $0xfffff,-0x4(%rbp)
  8000c8:	7e ac                	jle    800076 <umain+0x33>
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  8000ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000d1:	eb 1a                	jmp    8000ed <umain+0xaa>
		bigarray[i] = i;
  8000d3:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8000d6:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  8000dd:	00 00 00 
  8000e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8000e3:	48 63 d2             	movslq %edx,%rdx
  8000e6:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)

	cprintf("Making sure bss works right...\n");
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  8000e9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8000ed:	81 7d fc ff ff 0f 00 	cmpl   $0xfffff,-0x4(%rbp)
  8000f4:	7e dd                	jle    8000d3 <umain+0x90>
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  8000f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000fd:	eb 4e                	jmp    80014d <umain+0x10a>
		if (bigarray[i] != i)
  8000ff:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  800106:	00 00 00 
  800109:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80010c:	48 63 d2             	movslq %edx,%rdx
  80010f:	8b 14 90             	mov    (%rax,%rdx,4),%edx
  800112:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800115:	39 c2                	cmp    %eax,%edx
  800117:	74 30                	je     800149 <umain+0x106>
			panic("bigarray[%d] didn't hold its value!\n", i);
  800119:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80011c:	89 c1                	mov    %eax,%ecx
  80011e:	48 ba b0 19 80 00 00 	movabs $0x8019b0,%rdx
  800125:	00 00 00 
  800128:	be 16 00 00 00       	mov    $0x16,%esi
  80012d:	48 bf 9d 19 80 00 00 	movabs $0x80199d,%rdi
  800134:	00 00 00 
  800137:	b8 00 00 00 00       	mov    $0x0,%eax
  80013c:	49 b8 50 02 80 00 00 	movabs $0x800250,%r8
  800143:	00 00 00 
  800146:	41 ff d0             	callq  *%r8
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != 0)
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
	for (i = 0; i < ARRAYSIZE; i++)
  800149:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80014d:	81 7d fc ff ff 0f 00 	cmpl   $0xfffff,-0x4(%rbp)
  800154:	7e a9                	jle    8000ff <umain+0xbc>
		if (bigarray[i] != i)
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  800156:	48 bf d8 19 80 00 00 	movabs $0x8019d8,%rdi
  80015d:	00 00 00 
  800160:	b8 00 00 00 00       	mov    $0x0,%eax
  800165:	48 ba 89 04 80 00 00 	movabs $0x800489,%rdx
  80016c:	00 00 00 
  80016f:	ff d2                	callq  *%rdx
	bigarray[ARRAYSIZE+1024] = 0;
  800171:	48 b8 20 30 80 00 00 	movabs $0x803020,%rax
  800178:	00 00 00 
  80017b:	c7 80 00 10 40 00 00 	movl   $0x0,0x401000(%rax)
  800182:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  800185:	48 ba 0b 1a 80 00 00 	movabs $0x801a0b,%rdx
  80018c:	00 00 00 
  80018f:	be 1a 00 00 00       	mov    $0x1a,%esi
  800194:	48 bf 9d 19 80 00 00 	movabs $0x80199d,%rdi
  80019b:	00 00 00 
  80019e:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a3:	48 b9 50 02 80 00 00 	movabs $0x800250,%rcx
  8001aa:	00 00 00 
  8001ad:	ff d1                	callq  *%rcx

00000000008001af <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001af:	55                   	push   %rbp
  8001b0:	48 89 e5             	mov    %rsp,%rbp
  8001b3:	48 83 ec 10          	sub    $0x10,%rsp
  8001b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	thisenv = &envs[ENVX(sys_getenvid())];
  8001be:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  8001c5:	00 00 00 
  8001c8:	ff d0                	callq  *%rax
  8001ca:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001cf:	48 98                	cltq   
  8001d1:	48 c1 e0 03          	shl    $0x3,%rax
  8001d5:	48 89 c2             	mov    %rax,%rdx
  8001d8:	48 c1 e2 05          	shl    $0x5,%rdx
  8001dc:	48 29 c2             	sub    %rax,%rdx
  8001df:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001e6:	00 00 00 
  8001e9:	48 01 c2             	add    %rax,%rdx
  8001ec:	48 b8 20 30 c0 00 00 	movabs $0xc03020,%rax
  8001f3:	00 00 00 
  8001f6:	48 89 10             	mov    %rdx,(%rax)
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001fd:	7e 14                	jle    800213 <libmain+0x64>
		binaryname = argv[0];
  8001ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800203:	48 8b 10             	mov    (%rax),%rdx
  800206:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  80020d:	00 00 00 
  800210:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800213:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800217:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80021a:	48 89 d6             	mov    %rdx,%rsi
  80021d:	89 c7                	mov    %eax,%edi
  80021f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800226:	00 00 00 
  800229:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80022b:	48 b8 39 02 80 00 00 	movabs $0x800239,%rax
  800232:	00 00 00 
  800235:	ff d0                	callq  *%rax
}
  800237:	c9                   	leaveq 
  800238:	c3                   	retq   

0000000000800239 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800239:	55                   	push   %rbp
  80023a:	48 89 e5             	mov    %rsp,%rbp
	sys_env_destroy(0);
  80023d:	bf 00 00 00 00       	mov    $0x0,%edi
  800242:	48 b8 c0 18 80 00 00 	movabs $0x8018c0,%rax
  800249:	00 00 00 
  80024c:	ff d0                	callq  *%rax
}
  80024e:	5d                   	pop    %rbp
  80024f:	c3                   	retq   

0000000000800250 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800250:	55                   	push   %rbp
  800251:	48 89 e5             	mov    %rsp,%rbp
  800254:	53                   	push   %rbx
  800255:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80025c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800263:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800269:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800270:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800277:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80027e:	84 c0                	test   %al,%al
  800280:	74 23                	je     8002a5 <_panic+0x55>
  800282:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800289:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80028d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800291:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800295:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800299:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80029d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8002a1:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  8002a5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8002ac:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8002b3:	00 00 00 
  8002b6:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8002bd:	00 00 00 
  8002c0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8002c4:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8002cb:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8002d2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002d9:	48 b8 00 30 80 00 00 	movabs $0x803000,%rax
  8002e0:	00 00 00 
  8002e3:	48 8b 18             	mov    (%rax),%rbx
  8002e6:	48 b8 04 19 80 00 00 	movabs $0x801904,%rax
  8002ed:	00 00 00 
  8002f0:	ff d0                	callq  *%rax
  8002f2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8002f8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8002ff:	41 89 c8             	mov    %ecx,%r8d
  800302:	48 89 d1             	mov    %rdx,%rcx
  800305:	48 89 da             	mov    %rbx,%rdx
  800308:	89 c6                	mov    %eax,%esi
  80030a:	48 bf 30 1a 80 00 00 	movabs $0x801a30,%rdi
  800311:	00 00 00 
  800314:	b8 00 00 00 00       	mov    $0x0,%eax
  800319:	49 b9 89 04 80 00 00 	movabs $0x800489,%r9
  800320:	00 00 00 
  800323:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800326:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80032d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800334:	48 89 d6             	mov    %rdx,%rsi
  800337:	48 89 c7             	mov    %rax,%rdi
  80033a:	48 b8 dd 03 80 00 00 	movabs $0x8003dd,%rax
  800341:	00 00 00 
  800344:	ff d0                	callq  *%rax
	cprintf("\n");
  800346:	48 bf 53 1a 80 00 00 	movabs $0x801a53,%rdi
  80034d:	00 00 00 
  800350:	b8 00 00 00 00       	mov    $0x0,%eax
  800355:	48 ba 89 04 80 00 00 	movabs $0x800489,%rdx
  80035c:	00 00 00 
  80035f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800361:	cc                   	int3   
  800362:	eb fd                	jmp    800361 <_panic+0x111>

0000000000800364 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800364:	55                   	push   %rbp
  800365:	48 89 e5             	mov    %rsp,%rbp
  800368:	48 83 ec 10          	sub    $0x10,%rsp
  80036c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80036f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800373:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800377:	8b 00                	mov    (%rax),%eax
  800379:	8d 48 01             	lea    0x1(%rax),%ecx
  80037c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800380:	89 0a                	mov    %ecx,(%rdx)
  800382:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800385:	89 d1                	mov    %edx,%ecx
  800387:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80038b:	48 98                	cltq   
  80038d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800395:	8b 00                	mov    (%rax),%eax
  800397:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039c:	75 2c                	jne    8003ca <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80039e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003a2:	8b 00                	mov    (%rax),%eax
  8003a4:	48 98                	cltq   
  8003a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003aa:	48 83 c2 08          	add    $0x8,%rdx
  8003ae:	48 89 c6             	mov    %rax,%rsi
  8003b1:	48 89 d7             	mov    %rdx,%rdi
  8003b4:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  8003bb:	00 00 00 
  8003be:	ff d0                	callq  *%rax
        b->idx = 0;
  8003c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003c4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8003ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003ce:	8b 40 04             	mov    0x4(%rax),%eax
  8003d1:	8d 50 01             	lea    0x1(%rax),%edx
  8003d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003d8:	89 50 04             	mov    %edx,0x4(%rax)
}
  8003db:	c9                   	leaveq 
  8003dc:	c3                   	retq   

00000000008003dd <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8003dd:	55                   	push   %rbp
  8003de:	48 89 e5             	mov    %rsp,%rbp
  8003e1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8003e8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8003ef:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8003f6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8003fd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800404:	48 8b 0a             	mov    (%rdx),%rcx
  800407:	48 89 08             	mov    %rcx,(%rax)
  80040a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80040e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800412:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800416:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80041a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800421:	00 00 00 
    b.cnt = 0;
  800424:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80042b:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80042e:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800435:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80043c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800443:	48 89 c6             	mov    %rax,%rsi
  800446:	48 bf 64 03 80 00 00 	movabs $0x800364,%rdi
  80044d:	00 00 00 
  800450:	48 b8 3c 08 80 00 00 	movabs $0x80083c,%rax
  800457:	00 00 00 
  80045a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80045c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800462:	48 98                	cltq   
  800464:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80046b:	48 83 c2 08          	add    $0x8,%rdx
  80046f:	48 89 c6             	mov    %rax,%rsi
  800472:	48 89 d7             	mov    %rdx,%rdi
  800475:	48 b8 38 18 80 00 00 	movabs $0x801838,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800481:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800487:	c9                   	leaveq 
  800488:	c3                   	retq   

0000000000800489 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800489:	55                   	push   %rbp
  80048a:	48 89 e5             	mov    %rsp,%rbp
  80048d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800494:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80049b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8004a2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8004a9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8004b0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8004b7:	84 c0                	test   %al,%al
  8004b9:	74 20                	je     8004db <cprintf+0x52>
  8004bb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8004bf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8004c3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8004c7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8004cb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8004cf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8004d3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8004d7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8004db:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8004e2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8004e9:	00 00 00 
  8004ec:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8004f3:	00 00 00 
  8004f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8004fa:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800501:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800508:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80050f:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800516:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80051d:	48 8b 0a             	mov    (%rdx),%rcx
  800520:	48 89 08             	mov    %rcx,(%rax)
  800523:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800527:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80052b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80052f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800533:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80053a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800541:	48 89 d6             	mov    %rdx,%rsi
  800544:	48 89 c7             	mov    %rax,%rdi
  800547:	48 b8 dd 03 80 00 00 	movabs $0x8003dd,%rax
  80054e:	00 00 00 
  800551:	ff d0                	callq  *%rax
  800553:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800559:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80055f:	c9                   	leaveq 
  800560:	c3                   	retq   

0000000000800561 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800561:	55                   	push   %rbp
  800562:	48 89 e5             	mov    %rsp,%rbp
  800565:	53                   	push   %rbx
  800566:	48 83 ec 38          	sub    $0x38,%rsp
  80056a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80056e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800572:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800576:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800579:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80057d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800581:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800584:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800588:	77 3b                	ja     8005c5 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80058a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80058d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800591:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800594:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	48 f7 f3             	div    %rbx
  8005a0:	48 89 c2             	mov    %rax,%rdx
  8005a3:	8b 7d cc             	mov    -0x34(%rbp),%edi
  8005a6:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005a9:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  8005ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005b1:	41 89 f9             	mov    %edi,%r9d
  8005b4:	48 89 c7             	mov    %rax,%rdi
  8005b7:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  8005be:	00 00 00 
  8005c1:	ff d0                	callq  *%rax
  8005c3:	eb 1e                	jmp    8005e3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005c5:	eb 12                	jmp    8005d9 <printnum+0x78>
			putch(padc, putdat);
  8005c7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8005cb:	8b 55 cc             	mov    -0x34(%rbp),%edx
  8005ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005d2:	48 89 ce             	mov    %rcx,%rsi
  8005d5:	89 d7                	mov    %edx,%edi
  8005d7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005d9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8005dd:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8005e1:	7f e4                	jg     8005c7 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005e3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8005e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ef:	48 f7 f1             	div    %rcx
  8005f2:	48 89 d0             	mov    %rdx,%rax
  8005f5:	48 ba 90 1b 80 00 00 	movabs $0x801b90,%rdx
  8005fc:	00 00 00 
  8005ff:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800603:	0f be d0             	movsbl %al,%edx
  800606:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80060a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060e:	48 89 ce             	mov    %rcx,%rsi
  800611:	89 d7                	mov    %edx,%edi
  800613:	ff d0                	callq  *%rax
}
  800615:	48 83 c4 38          	add    $0x38,%rsp
  800619:	5b                   	pop    %rbx
  80061a:	5d                   	pop    %rbp
  80061b:	c3                   	retq   

000000000080061c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80061c:	55                   	push   %rbp
  80061d:	48 89 e5             	mov    %rsp,%rbp
  800620:	48 83 ec 1c          	sub    $0x1c,%rsp
  800624:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800628:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80062b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80062f:	7e 52                	jle    800683 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  800631:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800635:	8b 00                	mov    (%rax),%eax
  800637:	83 f8 30             	cmp    $0x30,%eax
  80063a:	73 24                	jae    800660 <getuint+0x44>
  80063c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800640:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800648:	8b 00                	mov    (%rax),%eax
  80064a:	89 c0                	mov    %eax,%eax
  80064c:	48 01 d0             	add    %rdx,%rax
  80064f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800653:	8b 12                	mov    (%rdx),%edx
  800655:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800658:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80065c:	89 0a                	mov    %ecx,(%rdx)
  80065e:	eb 17                	jmp    800677 <getuint+0x5b>
  800660:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800664:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800668:	48 89 d0             	mov    %rdx,%rax
  80066b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80066f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800673:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800677:	48 8b 00             	mov    (%rax),%rax
  80067a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80067e:	e9 a3 00 00 00       	jmpq   800726 <getuint+0x10a>
	else if (lflag)
  800683:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800687:	74 4f                	je     8006d8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80068d:	8b 00                	mov    (%rax),%eax
  80068f:	83 f8 30             	cmp    $0x30,%eax
  800692:	73 24                	jae    8006b8 <getuint+0x9c>
  800694:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800698:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80069c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a0:	8b 00                	mov    (%rax),%eax
  8006a2:	89 c0                	mov    %eax,%eax
  8006a4:	48 01 d0             	add    %rdx,%rax
  8006a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ab:	8b 12                	mov    (%rdx),%edx
  8006ad:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006b0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b4:	89 0a                	mov    %ecx,(%rdx)
  8006b6:	eb 17                	jmp    8006cf <getuint+0xb3>
  8006b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006bc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8006c0:	48 89 d0             	mov    %rdx,%rax
  8006c3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8006c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006cb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006cf:	48 8b 00             	mov    (%rax),%rax
  8006d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006d6:	eb 4e                	jmp    800726 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8006d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006dc:	8b 00                	mov    (%rax),%eax
  8006de:	83 f8 30             	cmp    $0x30,%eax
  8006e1:	73 24                	jae    800707 <getuint+0xeb>
  8006e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ef:	8b 00                	mov    (%rax),%eax
  8006f1:	89 c0                	mov    %eax,%eax
  8006f3:	48 01 d0             	add    %rdx,%rax
  8006f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006fa:	8b 12                	mov    (%rdx),%edx
  8006fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800703:	89 0a                	mov    %ecx,(%rdx)
  800705:	eb 17                	jmp    80071e <getuint+0x102>
  800707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80070b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80070f:	48 89 d0             	mov    %rdx,%rax
  800712:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800716:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80071e:	8b 00                	mov    (%rax),%eax
  800720:	89 c0                	mov    %eax,%eax
  800722:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800726:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80072a:	c9                   	leaveq 
  80072b:	c3                   	retq   

000000000080072c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80072c:	55                   	push   %rbp
  80072d:	48 89 e5             	mov    %rsp,%rbp
  800730:	48 83 ec 1c          	sub    $0x1c,%rsp
  800734:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800738:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80073b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80073f:	7e 52                	jle    800793 <getint+0x67>
		x=va_arg(*ap, long long);
  800741:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800745:	8b 00                	mov    (%rax),%eax
  800747:	83 f8 30             	cmp    $0x30,%eax
  80074a:	73 24                	jae    800770 <getint+0x44>
  80074c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800750:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800758:	8b 00                	mov    (%rax),%eax
  80075a:	89 c0                	mov    %eax,%eax
  80075c:	48 01 d0             	add    %rdx,%rax
  80075f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800763:	8b 12                	mov    (%rdx),%edx
  800765:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800768:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80076c:	89 0a                	mov    %ecx,(%rdx)
  80076e:	eb 17                	jmp    800787 <getint+0x5b>
  800770:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800774:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800778:	48 89 d0             	mov    %rdx,%rax
  80077b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80077f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800783:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800787:	48 8b 00             	mov    (%rax),%rax
  80078a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80078e:	e9 a3 00 00 00       	jmpq   800836 <getint+0x10a>
	else if (lflag)
  800793:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800797:	74 4f                	je     8007e8 <getint+0xbc>
		x=va_arg(*ap, long);
  800799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079d:	8b 00                	mov    (%rax),%eax
  80079f:	83 f8 30             	cmp    $0x30,%eax
  8007a2:	73 24                	jae    8007c8 <getint+0x9c>
  8007a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b0:	8b 00                	mov    (%rax),%eax
  8007b2:	89 c0                	mov    %eax,%eax
  8007b4:	48 01 d0             	add    %rdx,%rax
  8007b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007bb:	8b 12                	mov    (%rdx),%edx
  8007bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c4:	89 0a                	mov    %ecx,(%rdx)
  8007c6:	eb 17                	jmp    8007df <getint+0xb3>
  8007c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007d0:	48 89 d0             	mov    %rdx,%rax
  8007d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007df:	48 8b 00             	mov    (%rax),%rax
  8007e2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8007e6:	eb 4e                	jmp    800836 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8007e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ec:	8b 00                	mov    (%rax),%eax
  8007ee:	83 f8 30             	cmp    $0x30,%eax
  8007f1:	73 24                	jae    800817 <getint+0xeb>
  8007f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007ff:	8b 00                	mov    (%rax),%eax
  800801:	89 c0                	mov    %eax,%eax
  800803:	48 01 d0             	add    %rdx,%rax
  800806:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080a:	8b 12                	mov    (%rdx),%edx
  80080c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80080f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800813:	89 0a                	mov    %ecx,(%rdx)
  800815:	eb 17                	jmp    80082e <getint+0x102>
  800817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081b:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80081f:	48 89 d0             	mov    %rdx,%rax
  800822:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800826:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80082e:	8b 00                	mov    (%rax),%eax
  800830:	48 98                	cltq   
  800832:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800836:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80083a:	c9                   	leaveq 
  80083b:	c3                   	retq   

000000000080083c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80083c:	55                   	push   %rbp
  80083d:	48 89 e5             	mov    %rsp,%rbp
  800840:	41 54                	push   %r12
  800842:	53                   	push   %rbx
  800843:	48 83 ec 60          	sub    $0x60,%rsp
  800847:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80084b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80084f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800853:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800857:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80085b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80085f:	48 8b 0a             	mov    (%rdx),%rcx
  800862:	48 89 08             	mov    %rcx,(%rax)
  800865:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800869:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80086d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800871:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800875:	eb 17                	jmp    80088e <vprintfmt+0x52>
			if (ch == '\0')
  800877:	85 db                	test   %ebx,%ebx
  800879:	0f 84 df 04 00 00    	je     800d5e <vprintfmt+0x522>
				return;
			putch(ch, putdat);
  80087f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800883:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800887:	48 89 d6             	mov    %rdx,%rsi
  80088a:	89 df                	mov    %ebx,%edi
  80088c:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800892:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800896:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80089a:	0f b6 00             	movzbl (%rax),%eax
  80089d:	0f b6 d8             	movzbl %al,%ebx
  8008a0:	83 fb 25             	cmp    $0x25,%ebx
  8008a3:	75 d2                	jne    800877 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008a5:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  8008a9:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8008b0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8008b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8008be:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008c5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8008c9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008cd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008d1:	0f b6 00             	movzbl (%rax),%eax
  8008d4:	0f b6 d8             	movzbl %al,%ebx
  8008d7:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8008da:	83 f8 55             	cmp    $0x55,%eax
  8008dd:	0f 87 47 04 00 00    	ja     800d2a <vprintfmt+0x4ee>
  8008e3:	89 c0                	mov    %eax,%eax
  8008e5:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8008ec:	00 
  8008ed:	48 b8 b8 1b 80 00 00 	movabs $0x801bb8,%rax
  8008f4:	00 00 00 
  8008f7:	48 01 d0             	add    %rdx,%rax
  8008fa:	48 8b 00             	mov    (%rax),%rax
  8008fd:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8008ff:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800903:	eb c0                	jmp    8008c5 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800905:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800909:	eb ba                	jmp    8008c5 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800912:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800915:	89 d0                	mov    %edx,%eax
  800917:	c1 e0 02             	shl    $0x2,%eax
  80091a:	01 d0                	add    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d8                	add    %ebx,%eax
  800920:	83 e8 30             	sub    $0x30,%eax
  800923:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800926:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80092a:	0f b6 00             	movzbl (%rax),%eax
  80092d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800930:	83 fb 2f             	cmp    $0x2f,%ebx
  800933:	7e 0c                	jle    800941 <vprintfmt+0x105>
  800935:	83 fb 39             	cmp    $0x39,%ebx
  800938:	7f 07                	jg     800941 <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093f:	eb d1                	jmp    800912 <vprintfmt+0xd6>
			goto process_precision;
  800941:	eb 58                	jmp    80099b <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  800943:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800946:	83 f8 30             	cmp    $0x30,%eax
  800949:	73 17                	jae    800962 <vprintfmt+0x126>
  80094b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80094f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800952:	89 c0                	mov    %eax,%eax
  800954:	48 01 d0             	add    %rdx,%rax
  800957:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80095a:	83 c2 08             	add    $0x8,%edx
  80095d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800960:	eb 0f                	jmp    800971 <vprintfmt+0x135>
  800962:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800966:	48 89 d0             	mov    %rdx,%rax
  800969:	48 83 c2 08          	add    $0x8,%rdx
  80096d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800971:	8b 00                	mov    (%rax),%eax
  800973:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800976:	eb 23                	jmp    80099b <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800978:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80097c:	79 0c                	jns    80098a <vprintfmt+0x14e>
				width = 0;
  80097e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800985:	e9 3b ff ff ff       	jmpq   8008c5 <vprintfmt+0x89>
  80098a:	e9 36 ff ff ff       	jmpq   8008c5 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80098f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800996:	e9 2a ff ff ff       	jmpq   8008c5 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  80099b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80099f:	79 12                	jns    8009b3 <vprintfmt+0x177>
				width = precision, precision = -1;
  8009a1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009a4:	89 45 dc             	mov    %eax,-0x24(%rbp)
  8009a7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8009ae:	e9 12 ff ff ff       	jmpq   8008c5 <vprintfmt+0x89>
  8009b3:	e9 0d ff ff ff       	jmpq   8008c5 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009b8:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8009bc:	e9 04 ff ff ff       	jmpq   8008c5 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8009c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009c4:	83 f8 30             	cmp    $0x30,%eax
  8009c7:	73 17                	jae    8009e0 <vprintfmt+0x1a4>
  8009c9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009cd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009d0:	89 c0                	mov    %eax,%eax
  8009d2:	48 01 d0             	add    %rdx,%rax
  8009d5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009d8:	83 c2 08             	add    $0x8,%edx
  8009db:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009de:	eb 0f                	jmp    8009ef <vprintfmt+0x1b3>
  8009e0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8009e4:	48 89 d0             	mov    %rdx,%rax
  8009e7:	48 83 c2 08          	add    $0x8,%rdx
  8009eb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009ef:	8b 10                	mov    (%rax),%edx
  8009f1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8009f5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8009f9:	48 89 ce             	mov    %rcx,%rsi
  8009fc:	89 d7                	mov    %edx,%edi
  8009fe:	ff d0                	callq  *%rax
			break;
  800a00:	e9 53 03 00 00       	jmpq   800d58 <vprintfmt+0x51c>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800a05:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a08:	83 f8 30             	cmp    $0x30,%eax
  800a0b:	73 17                	jae    800a24 <vprintfmt+0x1e8>
  800a0d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a11:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a14:	89 c0                	mov    %eax,%eax
  800a16:	48 01 d0             	add    %rdx,%rax
  800a19:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a1c:	83 c2 08             	add    $0x8,%edx
  800a1f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a22:	eb 0f                	jmp    800a33 <vprintfmt+0x1f7>
  800a24:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a28:	48 89 d0             	mov    %rdx,%rax
  800a2b:	48 83 c2 08          	add    $0x8,%rdx
  800a2f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a33:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800a35:	85 db                	test   %ebx,%ebx
  800a37:	79 02                	jns    800a3b <vprintfmt+0x1ff>
				err = -err;
  800a39:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a3b:	83 fb 15             	cmp    $0x15,%ebx
  800a3e:	7f 16                	jg     800a56 <vprintfmt+0x21a>
  800a40:	48 b8 e0 1a 80 00 00 	movabs $0x801ae0,%rax
  800a47:	00 00 00 
  800a4a:	48 63 d3             	movslq %ebx,%rdx
  800a4d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800a51:	4d 85 e4             	test   %r12,%r12
  800a54:	75 2e                	jne    800a84 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800a56:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a5e:	89 d9                	mov    %ebx,%ecx
  800a60:	48 ba a1 1b 80 00 00 	movabs $0x801ba1,%rdx
  800a67:	00 00 00 
  800a6a:	48 89 c7             	mov    %rax,%rdi
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a72:	49 b8 67 0d 80 00 00 	movabs $0x800d67,%r8
  800a79:	00 00 00 
  800a7c:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a7f:	e9 d4 02 00 00       	jmpq   800d58 <vprintfmt+0x51c>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a84:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800a88:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a8c:	4c 89 e1             	mov    %r12,%rcx
  800a8f:	48 ba aa 1b 80 00 00 	movabs $0x801baa,%rdx
  800a96:	00 00 00 
  800a99:	48 89 c7             	mov    %rax,%rdi
  800a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa1:	49 b8 67 0d 80 00 00 	movabs $0x800d67,%r8
  800aa8:	00 00 00 
  800aab:	41 ff d0             	callq  *%r8
			break;
  800aae:	e9 a5 02 00 00       	jmpq   800d58 <vprintfmt+0x51c>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800ab3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab6:	83 f8 30             	cmp    $0x30,%eax
  800ab9:	73 17                	jae    800ad2 <vprintfmt+0x296>
  800abb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800abf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac2:	89 c0                	mov    %eax,%eax
  800ac4:	48 01 d0             	add    %rdx,%rax
  800ac7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800aca:	83 c2 08             	add    $0x8,%edx
  800acd:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ad0:	eb 0f                	jmp    800ae1 <vprintfmt+0x2a5>
  800ad2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad6:	48 89 d0             	mov    %rdx,%rax
  800ad9:	48 83 c2 08          	add    $0x8,%rdx
  800add:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ae1:	4c 8b 20             	mov    (%rax),%r12
  800ae4:	4d 85 e4             	test   %r12,%r12
  800ae7:	75 0a                	jne    800af3 <vprintfmt+0x2b7>
				p = "(null)";
  800ae9:	49 bc ad 1b 80 00 00 	movabs $0x801bad,%r12
  800af0:	00 00 00 
			if (width > 0 && padc != '-')
  800af3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800af7:	7e 3f                	jle    800b38 <vprintfmt+0x2fc>
  800af9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800afd:	74 39                	je     800b38 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aff:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b02:	48 98                	cltq   
  800b04:	48 89 c6             	mov    %rax,%rsi
  800b07:	4c 89 e7             	mov    %r12,%rdi
  800b0a:	48 b8 13 10 80 00 00 	movabs $0x801013,%rax
  800b11:	00 00 00 
  800b14:	ff d0                	callq  *%rax
  800b16:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800b19:	eb 17                	jmp    800b32 <vprintfmt+0x2f6>
					putch(padc, putdat);
  800b1b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800b1f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b27:	48 89 ce             	mov    %rcx,%rsi
  800b2a:	89 d7                	mov    %edx,%edi
  800b2c:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b2e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b32:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b36:	7f e3                	jg     800b1b <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b38:	eb 37                	jmp    800b71 <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800b3a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800b3e:	74 1e                	je     800b5e <vprintfmt+0x322>
  800b40:	83 fb 1f             	cmp    $0x1f,%ebx
  800b43:	7e 05                	jle    800b4a <vprintfmt+0x30e>
  800b45:	83 fb 7e             	cmp    $0x7e,%ebx
  800b48:	7e 14                	jle    800b5e <vprintfmt+0x322>
					putch('?', putdat);
  800b4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b52:	48 89 d6             	mov    %rdx,%rsi
  800b55:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800b5a:	ff d0                	callq  *%rax
  800b5c:	eb 0f                	jmp    800b6d <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800b5e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b62:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b66:	48 89 d6             	mov    %rdx,%rsi
  800b69:	89 df                	mov    %ebx,%edi
  800b6b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800b71:	4c 89 e0             	mov    %r12,%rax
  800b74:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800b78:	0f b6 00             	movzbl (%rax),%eax
  800b7b:	0f be d8             	movsbl %al,%ebx
  800b7e:	85 db                	test   %ebx,%ebx
  800b80:	74 10                	je     800b92 <vprintfmt+0x356>
  800b82:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b86:	78 b2                	js     800b3a <vprintfmt+0x2fe>
  800b88:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800b8c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800b90:	79 a8                	jns    800b3a <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b92:	eb 16                	jmp    800baa <vprintfmt+0x36e>
				putch(' ', putdat);
  800b94:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b98:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9c:	48 89 d6             	mov    %rdx,%rsi
  800b9f:	bf 20 00 00 00       	mov    $0x20,%edi
  800ba4:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800baa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bae:	7f e4                	jg     800b94 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800bb0:	e9 a3 01 00 00       	jmpq   800d58 <vprintfmt+0x51c>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800bb5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bb9:	be 03 00 00 00       	mov    $0x3,%esi
  800bbe:	48 89 c7             	mov    %rax,%rdi
  800bc1:	48 b8 2c 07 80 00 00 	movabs $0x80072c,%rax
  800bc8:	00 00 00 
  800bcb:	ff d0                	callq  *%rax
  800bcd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800bd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd5:	48 85 c0             	test   %rax,%rax
  800bd8:	79 1d                	jns    800bf7 <vprintfmt+0x3bb>
				putch('-', putdat);
  800bda:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bde:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be2:	48 89 d6             	mov    %rdx,%rsi
  800be5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800bea:	ff d0                	callq  *%rax
				num = -(long long) num;
  800bec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf0:	48 f7 d8             	neg    %rax
  800bf3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800bf7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800bfe:	e9 e8 00 00 00       	jmpq   800ceb <vprintfmt+0x4af>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800c03:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c07:	be 03 00 00 00       	mov    $0x3,%esi
  800c0c:	48 89 c7             	mov    %rax,%rdi
  800c0f:	48 b8 1c 06 80 00 00 	movabs $0x80061c,%rax
  800c16:	00 00 00 
  800c19:	ff d0                	callq  *%rax
  800c1b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800c1f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800c26:	e9 c0 00 00 00       	jmpq   800ceb <vprintfmt+0x4af>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c33:	48 89 d6             	mov    %rdx,%rsi
  800c36:	bf 58 00 00 00       	mov    $0x58,%edi
  800c3b:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c3d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c41:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c45:	48 89 d6             	mov    %rdx,%rsi
  800c48:	bf 58 00 00 00       	mov    $0x58,%edi
  800c4d:	ff d0                	callq  *%rax
			putch('X', putdat);
  800c4f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c53:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c57:	48 89 d6             	mov    %rdx,%rsi
  800c5a:	bf 58 00 00 00       	mov    $0x58,%edi
  800c5f:	ff d0                	callq  *%rax
			break;
  800c61:	e9 f2 00 00 00       	jmpq   800d58 <vprintfmt+0x51c>

			// pointer
		case 'p':
			putch('0', putdat);
  800c66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6e:	48 89 d6             	mov    %rdx,%rsi
  800c71:	bf 30 00 00 00       	mov    $0x30,%edi
  800c76:	ff d0                	callq  *%rax
			putch('x', putdat);
  800c78:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c7c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c80:	48 89 d6             	mov    %rdx,%rsi
  800c83:	bf 78 00 00 00       	mov    $0x78,%edi
  800c88:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800c8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8d:	83 f8 30             	cmp    $0x30,%eax
  800c90:	73 17                	jae    800ca9 <vprintfmt+0x46d>
  800c92:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c96:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c99:	89 c0                	mov    %eax,%eax
  800c9b:	48 01 d0             	add    %rdx,%rax
  800c9e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca1:	83 c2 08             	add    $0x8,%edx
  800ca4:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca7:	eb 0f                	jmp    800cb8 <vprintfmt+0x47c>
				(uintptr_t) va_arg(aq, void *);
  800ca9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cad:	48 89 d0             	mov    %rdx,%rax
  800cb0:	48 83 c2 08          	add    $0x8,%rdx
  800cb4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb8:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800cbf:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800cc6:	eb 23                	jmp    800ceb <vprintfmt+0x4af>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800cc8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ccc:	be 03 00 00 00       	mov    $0x3,%esi
  800cd1:	48 89 c7             	mov    %rax,%rdi
  800cd4:	48 b8 1c 06 80 00 00 	movabs $0x80061c,%rax
  800cdb:	00 00 00 
  800cde:	ff d0                	callq  *%rax
  800ce0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800ce4:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ceb:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800cf0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800cf3:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800cf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800cfa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cfe:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d02:	45 89 c1             	mov    %r8d,%r9d
  800d05:	41 89 f8             	mov    %edi,%r8d
  800d08:	48 89 c7             	mov    %rax,%rdi
  800d0b:	48 b8 61 05 80 00 00 	movabs $0x800561,%rax
  800d12:	00 00 00 
  800d15:	ff d0                	callq  *%rax
			break;
  800d17:	eb 3f                	jmp    800d58 <vprintfmt+0x51c>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d19:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d21:	48 89 d6             	mov    %rdx,%rsi
  800d24:	89 df                	mov    %ebx,%edi
  800d26:	ff d0                	callq  *%rax
			break;
  800d28:	eb 2e                	jmp    800d58 <vprintfmt+0x51c>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d32:	48 89 d6             	mov    %rdx,%rsi
  800d35:	bf 25 00 00 00       	mov    $0x25,%edi
  800d3a:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d3c:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d41:	eb 05                	jmp    800d48 <vprintfmt+0x50c>
  800d43:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800d48:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d4c:	48 83 e8 01          	sub    $0x1,%rax
  800d50:	0f b6 00             	movzbl (%rax),%eax
  800d53:	3c 25                	cmp    $0x25,%al
  800d55:	75 ec                	jne    800d43 <vprintfmt+0x507>
				/* do nothing */;
			break;
  800d57:	90                   	nop
		}
	}
  800d58:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d59:	e9 30 fb ff ff       	jmpq   80088e <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800d5e:	48 83 c4 60          	add    $0x60,%rsp
  800d62:	5b                   	pop    %rbx
  800d63:	41 5c                	pop    %r12
  800d65:	5d                   	pop    %rbp
  800d66:	c3                   	retq   

0000000000800d67 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d67:	55                   	push   %rbp
  800d68:	48 89 e5             	mov    %rsp,%rbp
  800d6b:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800d72:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800d79:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800d80:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d87:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d8e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d95:	84 c0                	test   %al,%al
  800d97:	74 20                	je     800db9 <printfmt+0x52>
  800d99:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d9d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800da1:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800da5:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800da9:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800dad:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800db1:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800db5:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800db9:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800dc0:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800dc7:	00 00 00 
  800dca:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800dd1:	00 00 00 
  800dd4:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dd8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800ddf:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800de6:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800ded:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800df4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dfb:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e02:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800e09:	48 89 c7             	mov    %rax,%rdi
  800e0c:	48 b8 3c 08 80 00 00 	movabs $0x80083c,%rax
  800e13:	00 00 00 
  800e16:	ff d0                	callq  *%rax
	va_end(ap);
}
  800e18:	c9                   	leaveq 
  800e19:	c3                   	retq   

0000000000800e1a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e1a:	55                   	push   %rbp
  800e1b:	48 89 e5             	mov    %rsp,%rbp
  800e1e:	48 83 ec 10          	sub    $0x10,%rsp
  800e22:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e25:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e2d:	8b 40 10             	mov    0x10(%rax),%eax
  800e30:	8d 50 01             	lea    0x1(%rax),%edx
  800e33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e37:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e3e:	48 8b 10             	mov    (%rax),%rdx
  800e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e45:	48 8b 40 08          	mov    0x8(%rax),%rax
  800e49:	48 39 c2             	cmp    %rax,%rdx
  800e4c:	73 17                	jae    800e65 <sprintputch+0x4b>
		*b->buf++ = ch;
  800e4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e52:	48 8b 00             	mov    (%rax),%rax
  800e55:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800e59:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e5d:	48 89 0a             	mov    %rcx,(%rdx)
  800e60:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e63:	88 10                	mov    %dl,(%rax)
}
  800e65:	c9                   	leaveq 
  800e66:	c3                   	retq   

0000000000800e67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e67:	55                   	push   %rbp
  800e68:	48 89 e5             	mov    %rsp,%rbp
  800e6b:	48 83 ec 50          	sub    $0x50,%rsp
  800e6f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800e73:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800e76:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800e7a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800e7e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800e82:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800e86:	48 8b 0a             	mov    (%rdx),%rcx
  800e89:	48 89 08             	mov    %rcx,(%rax)
  800e8c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e90:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e94:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e98:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e9c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ea0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ea4:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800ea7:	48 98                	cltq   
  800ea9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800ead:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800eb1:	48 01 d0             	add    %rdx,%rax
  800eb4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800eb8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800ebf:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800ec4:	74 06                	je     800ecc <vsnprintf+0x65>
  800ec6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800eca:	7f 07                	jg     800ed3 <vsnprintf+0x6c>
		return -E_INVAL;
  800ecc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ed1:	eb 2f                	jmp    800f02 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800ed3:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800ed7:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800edb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800edf:	48 89 c6             	mov    %rax,%rsi
  800ee2:	48 bf 1a 0e 80 00 00 	movabs $0x800e1a,%rdi
  800ee9:	00 00 00 
  800eec:	48 b8 3c 08 80 00 00 	movabs $0x80083c,%rax
  800ef3:	00 00 00 
  800ef6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800ef8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800efc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800eff:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f02:	c9                   	leaveq 
  800f03:	c3                   	retq   

0000000000800f04 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f04:	55                   	push   %rbp
  800f05:	48 89 e5             	mov    %rsp,%rbp
  800f08:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800f0f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800f16:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800f1c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f23:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f2a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f31:	84 c0                	test   %al,%al
  800f33:	74 20                	je     800f55 <snprintf+0x51>
  800f35:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f39:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f3d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f41:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f45:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f49:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f4d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f51:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f55:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800f5c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800f63:	00 00 00 
  800f66:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800f6d:	00 00 00 
  800f70:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f74:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800f7b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800f82:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800f89:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800f90:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800f97:	48 8b 0a             	mov    (%rdx),%rcx
  800f9a:	48 89 08             	mov    %rcx,(%rax)
  800f9d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800fa1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800fa5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fa9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800fad:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800fb4:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800fbb:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800fc1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800fc8:	48 89 c7             	mov    %rax,%rdi
  800fcb:	48 b8 67 0e 80 00 00 	movabs $0x800e67,%rax
  800fd2:	00 00 00 
  800fd5:	ff d0                	callq  *%rax
  800fd7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800fdd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800fe3:	c9                   	leaveq 
  800fe4:	c3                   	retq   

0000000000800fe5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fe5:	55                   	push   %rbp
  800fe6:	48 89 e5             	mov    %rsp,%rbp
  800fe9:	48 83 ec 18          	sub    $0x18,%rsp
  800fed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ff8:	eb 09                	jmp    801003 <strlen+0x1e>
		n++;
  800ffa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffe:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801003:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801007:	0f b6 00             	movzbl (%rax),%eax
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ec                	jne    800ffa <strlen+0x15>
		n++;
	return n;
  80100e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801011:	c9                   	leaveq 
  801012:	c3                   	retq   

0000000000801013 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801013:	55                   	push   %rbp
  801014:	48 89 e5             	mov    %rsp,%rbp
  801017:	48 83 ec 20          	sub    $0x20,%rsp
  80101b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80101f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801023:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80102a:	eb 0e                	jmp    80103a <strnlen+0x27>
		n++;
  80102c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801030:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801035:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80103a:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80103f:	74 0b                	je     80104c <strnlen+0x39>
  801041:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801045:	0f b6 00             	movzbl (%rax),%eax
  801048:	84 c0                	test   %al,%al
  80104a:	75 e0                	jne    80102c <strnlen+0x19>
		n++;
	return n;
  80104c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80104f:	c9                   	leaveq 
  801050:	c3                   	retq   

0000000000801051 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801051:	55                   	push   %rbp
  801052:	48 89 e5             	mov    %rsp,%rbp
  801055:	48 83 ec 20          	sub    $0x20,%rsp
  801059:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80105d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801069:	90                   	nop
  80106a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801072:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801076:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80107a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80107e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801082:	0f b6 12             	movzbl (%rdx),%edx
  801085:	88 10                	mov    %dl,(%rax)
  801087:	0f b6 00             	movzbl (%rax),%eax
  80108a:	84 c0                	test   %al,%al
  80108c:	75 dc                	jne    80106a <strcpy+0x19>
		/* do nothing */;
	return ret;
  80108e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801092:	c9                   	leaveq 
  801093:	c3                   	retq   

0000000000801094 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801094:	55                   	push   %rbp
  801095:	48 89 e5             	mov    %rsp,%rbp
  801098:	48 83 ec 20          	sub    $0x20,%rsp
  80109c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8010a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a8:	48 89 c7             	mov    %rax,%rdi
  8010ab:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  8010b2:	00 00 00 
  8010b5:	ff d0                	callq  *%rax
  8010b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8010ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010bd:	48 63 d0             	movslq %eax,%rdx
  8010c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010c4:	48 01 c2             	add    %rax,%rdx
  8010c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8010cb:	48 89 c6             	mov    %rax,%rsi
  8010ce:	48 89 d7             	mov    %rdx,%rdi
  8010d1:	48 b8 51 10 80 00 00 	movabs $0x801051,%rax
  8010d8:	00 00 00 
  8010db:	ff d0                	callq  *%rax
	return dst;
  8010dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8010e1:	c9                   	leaveq 
  8010e2:	c3                   	retq   

00000000008010e3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8010e3:	55                   	push   %rbp
  8010e4:	48 89 e5             	mov    %rsp,%rbp
  8010e7:	48 83 ec 28          	sub    $0x28,%rsp
  8010eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010ef:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8010f3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8010f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8010ff:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801106:	00 
  801107:	eb 2a                	jmp    801133 <strncpy+0x50>
		*dst++ = *src;
  801109:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801111:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801115:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801119:	0f b6 12             	movzbl (%rdx),%edx
  80111c:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80111e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801122:	0f b6 00             	movzbl (%rax),%eax
  801125:	84 c0                	test   %al,%al
  801127:	74 05                	je     80112e <strncpy+0x4b>
			src++;
  801129:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80112e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801133:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801137:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80113b:	72 cc                	jb     801109 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80113d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801141:	c9                   	leaveq 
  801142:	c3                   	retq   

0000000000801143 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801143:	55                   	push   %rbp
  801144:	48 89 e5             	mov    %rsp,%rbp
  801147:	48 83 ec 28          	sub    $0x28,%rsp
  80114b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801153:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801157:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80115f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801164:	74 3d                	je     8011a3 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801166:	eb 1d                	jmp    801185 <strlcpy+0x42>
			*dst++ = *src++;
  801168:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801170:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801174:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801178:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80117c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801180:	0f b6 12             	movzbl (%rdx),%edx
  801183:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801185:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80118a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80118f:	74 0b                	je     80119c <strlcpy+0x59>
  801191:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801195:	0f b6 00             	movzbl (%rax),%eax
  801198:	84 c0                	test   %al,%al
  80119a:	75 cc                	jne    801168 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80119c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a0:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8011a3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ab:	48 29 c2             	sub    %rax,%rdx
  8011ae:	48 89 d0             	mov    %rdx,%rax
}
  8011b1:	c9                   	leaveq 
  8011b2:	c3                   	retq   

00000000008011b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011b3:	55                   	push   %rbp
  8011b4:	48 89 e5             	mov    %rsp,%rbp
  8011b7:	48 83 ec 10          	sub    $0x10,%rsp
  8011bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011bf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8011c3:	eb 0a                	jmp    8011cf <strcmp+0x1c>
		p++, q++;
  8011c5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011ca:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d3:	0f b6 00             	movzbl (%rax),%eax
  8011d6:	84 c0                	test   %al,%al
  8011d8:	74 12                	je     8011ec <strcmp+0x39>
  8011da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011de:	0f b6 10             	movzbl (%rax),%edx
  8011e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e5:	0f b6 00             	movzbl (%rax),%eax
  8011e8:	38 c2                	cmp    %al,%dl
  8011ea:	74 d9                	je     8011c5 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011f0:	0f b6 00             	movzbl (%rax),%eax
  8011f3:	0f b6 d0             	movzbl %al,%edx
  8011f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fa:	0f b6 00             	movzbl (%rax),%eax
  8011fd:	0f b6 c0             	movzbl %al,%eax
  801200:	29 c2                	sub    %eax,%edx
  801202:	89 d0                	mov    %edx,%eax
}
  801204:	c9                   	leaveq 
  801205:	c3                   	retq   

0000000000801206 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801206:	55                   	push   %rbp
  801207:	48 89 e5             	mov    %rsp,%rbp
  80120a:	48 83 ec 18          	sub    $0x18,%rsp
  80120e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801212:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801216:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80121a:	eb 0f                	jmp    80122b <strncmp+0x25>
		n--, p++, q++;
  80121c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801221:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801226:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80122b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801230:	74 1d                	je     80124f <strncmp+0x49>
  801232:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801236:	0f b6 00             	movzbl (%rax),%eax
  801239:	84 c0                	test   %al,%al
  80123b:	74 12                	je     80124f <strncmp+0x49>
  80123d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801241:	0f b6 10             	movzbl (%rax),%edx
  801244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801248:	0f b6 00             	movzbl (%rax),%eax
  80124b:	38 c2                	cmp    %al,%dl
  80124d:	74 cd                	je     80121c <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80124f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801254:	75 07                	jne    80125d <strncmp+0x57>
		return 0;
  801256:	b8 00 00 00 00       	mov    $0x0,%eax
  80125b:	eb 18                	jmp    801275 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80125d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801261:	0f b6 00             	movzbl (%rax),%eax
  801264:	0f b6 d0             	movzbl %al,%edx
  801267:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126b:	0f b6 00             	movzbl (%rax),%eax
  80126e:	0f b6 c0             	movzbl %al,%eax
  801271:	29 c2                	sub    %eax,%edx
  801273:	89 d0                	mov    %edx,%eax
}
  801275:	c9                   	leaveq 
  801276:	c3                   	retq   

0000000000801277 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801277:	55                   	push   %rbp
  801278:	48 89 e5             	mov    %rsp,%rbp
  80127b:	48 83 ec 0c          	sub    $0xc,%rsp
  80127f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801283:	89 f0                	mov    %esi,%eax
  801285:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801288:	eb 17                	jmp    8012a1 <strchr+0x2a>
		if (*s == c)
  80128a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80128e:	0f b6 00             	movzbl (%rax),%eax
  801291:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801294:	75 06                	jne    80129c <strchr+0x25>
			return (char *) s;
  801296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129a:	eb 15                	jmp    8012b1 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80129c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012a5:	0f b6 00             	movzbl (%rax),%eax
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 de                	jne    80128a <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b1:	c9                   	leaveq 
  8012b2:	c3                   	retq   

00000000008012b3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b3:	55                   	push   %rbp
  8012b4:	48 89 e5             	mov    %rsp,%rbp
  8012b7:	48 83 ec 0c          	sub    $0xc,%rsp
  8012bb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012bf:	89 f0                	mov    %esi,%eax
  8012c1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8012c4:	eb 13                	jmp    8012d9 <strfind+0x26>
		if (*s == c)
  8012c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ca:	0f b6 00             	movzbl (%rax),%eax
  8012cd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8012d0:	75 02                	jne    8012d4 <strfind+0x21>
			break;
  8012d2:	eb 10                	jmp    8012e4 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012dd:	0f b6 00             	movzbl (%rax),%eax
  8012e0:	84 c0                	test   %al,%al
  8012e2:	75 e2                	jne    8012c6 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8012e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012e8:	c9                   	leaveq 
  8012e9:	c3                   	retq   

00000000008012ea <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8012ea:	55                   	push   %rbp
  8012eb:	48 89 e5             	mov    %rsp,%rbp
  8012ee:	48 83 ec 18          	sub    $0x18,%rsp
  8012f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012f6:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8012f9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8012fd:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801302:	75 06                	jne    80130a <memset+0x20>
		return v;
  801304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801308:	eb 69                	jmp    801373 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80130a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80130e:	83 e0 03             	and    $0x3,%eax
  801311:	48 85 c0             	test   %rax,%rax
  801314:	75 48                	jne    80135e <memset+0x74>
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131a:	83 e0 03             	and    $0x3,%eax
  80131d:	48 85 c0             	test   %rax,%rax
  801320:	75 3c                	jne    80135e <memset+0x74>
		c &= 0xFF;
  801322:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801329:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80132c:	c1 e0 18             	shl    $0x18,%eax
  80132f:	89 c2                	mov    %eax,%edx
  801331:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801334:	c1 e0 10             	shl    $0x10,%eax
  801337:	09 c2                	or     %eax,%edx
  801339:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80133c:	c1 e0 08             	shl    $0x8,%eax
  80133f:	09 d0                	or     %edx,%eax
  801341:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801348:	48 c1 e8 02          	shr    $0x2,%rax
  80134c:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80134f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801353:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801356:	48 89 d7             	mov    %rdx,%rdi
  801359:	fc                   	cld    
  80135a:	f3 ab                	rep stos %eax,%es:(%rdi)
  80135c:	eb 11                	jmp    80136f <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80135e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801362:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801365:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801369:	48 89 d7             	mov    %rdx,%rdi
  80136c:	fc                   	cld    
  80136d:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80136f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801373:	c9                   	leaveq 
  801374:	c3                   	retq   

0000000000801375 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801375:	55                   	push   %rbp
  801376:	48 89 e5             	mov    %rsp,%rbp
  801379:	48 83 ec 28          	sub    $0x28,%rsp
  80137d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801381:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801385:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801389:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80138d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801391:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801395:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013a1:	0f 83 88 00 00 00    	jae    80142f <memmove+0xba>
  8013a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013af:	48 01 d0             	add    %rdx,%rax
  8013b2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8013b6:	76 77                	jbe    80142f <memmove+0xba>
		s += n;
  8013b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013bc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8013c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013c4:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8013c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013cc:	83 e0 03             	and    $0x3,%eax
  8013cf:	48 85 c0             	test   %rax,%rax
  8013d2:	75 3b                	jne    80140f <memmove+0x9a>
  8013d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d8:	83 e0 03             	and    $0x3,%eax
  8013db:	48 85 c0             	test   %rax,%rax
  8013de:	75 2f                	jne    80140f <memmove+0x9a>
  8013e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e4:	83 e0 03             	and    $0x3,%eax
  8013e7:	48 85 c0             	test   %rax,%rax
  8013ea:	75 23                	jne    80140f <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8013ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013f0:	48 83 e8 04          	sub    $0x4,%rax
  8013f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013f8:	48 83 ea 04          	sub    $0x4,%rdx
  8013fc:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801400:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801404:	48 89 c7             	mov    %rax,%rdi
  801407:	48 89 d6             	mov    %rdx,%rsi
  80140a:	fd                   	std    
  80140b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80140d:	eb 1d                	jmp    80142c <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80140f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801413:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80141b:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80141f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801423:	48 89 d7             	mov    %rdx,%rdi
  801426:	48 89 c1             	mov    %rax,%rcx
  801429:	fd                   	std    
  80142a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80142c:	fc                   	cld    
  80142d:	eb 57                	jmp    801486 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80142f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801433:	83 e0 03             	and    $0x3,%eax
  801436:	48 85 c0             	test   %rax,%rax
  801439:	75 36                	jne    801471 <memmove+0xfc>
  80143b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80143f:	83 e0 03             	and    $0x3,%eax
  801442:	48 85 c0             	test   %rax,%rax
  801445:	75 2a                	jne    801471 <memmove+0xfc>
  801447:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144b:	83 e0 03             	and    $0x3,%eax
  80144e:	48 85 c0             	test   %rax,%rax
  801451:	75 1e                	jne    801471 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801453:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801457:	48 c1 e8 02          	shr    $0x2,%rax
  80145b:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80145e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801462:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801466:	48 89 c7             	mov    %rax,%rdi
  801469:	48 89 d6             	mov    %rdx,%rsi
  80146c:	fc                   	cld    
  80146d:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80146f:	eb 15                	jmp    801486 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801471:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801475:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801479:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80147d:	48 89 c7             	mov    %rax,%rdi
  801480:	48 89 d6             	mov    %rdx,%rsi
  801483:	fc                   	cld    
  801484:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80148a:	c9                   	leaveq 
  80148b:	c3                   	retq   

000000000080148c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80148c:	55                   	push   %rbp
  80148d:	48 89 e5             	mov    %rsp,%rbp
  801490:	48 83 ec 18          	sub    $0x18,%rsp
  801494:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801498:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80149c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8014a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014a4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8014a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ac:	48 89 ce             	mov    %rcx,%rsi
  8014af:	48 89 c7             	mov    %rax,%rdi
  8014b2:	48 b8 75 13 80 00 00 	movabs $0x801375,%rax
  8014b9:	00 00 00 
  8014bc:	ff d0                	callq  *%rax
}
  8014be:	c9                   	leaveq 
  8014bf:	c3                   	retq   

00000000008014c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014c0:	55                   	push   %rbp
  8014c1:	48 89 e5             	mov    %rsp,%rbp
  8014c4:	48 83 ec 28          	sub    $0x28,%rsp
  8014c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014d0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8014d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8014dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8014e4:	eb 36                	jmp    80151c <memcmp+0x5c>
		if (*s1 != *s2)
  8014e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014ea:	0f b6 10             	movzbl (%rax),%edx
  8014ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014f1:	0f b6 00             	movzbl (%rax),%eax
  8014f4:	38 c2                	cmp    %al,%dl
  8014f6:	74 1a                	je     801512 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8014f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	0f b6 d0             	movzbl %al,%edx
  801502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801506:	0f b6 00             	movzbl (%rax),%eax
  801509:	0f b6 c0             	movzbl %al,%eax
  80150c:	29 c2                	sub    %eax,%edx
  80150e:	89 d0                	mov    %edx,%eax
  801510:	eb 20                	jmp    801532 <memcmp+0x72>
		s1++, s2++;
  801512:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801517:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80151c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801520:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801524:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801528:	48 85 c0             	test   %rax,%rax
  80152b:	75 b9                	jne    8014e6 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801532:	c9                   	leaveq 
  801533:	c3                   	retq   

0000000000801534 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801534:	55                   	push   %rbp
  801535:	48 89 e5             	mov    %rsp,%rbp
  801538:	48 83 ec 28          	sub    $0x28,%rsp
  80153c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801540:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801543:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80154f:	48 01 d0             	add    %rdx,%rax
  801552:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801556:	eb 15                	jmp    80156d <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801558:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80155c:	0f b6 10             	movzbl (%rax),%edx
  80155f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801562:	38 c2                	cmp    %al,%dl
  801564:	75 02                	jne    801568 <memfind+0x34>
			break;
  801566:	eb 0f                	jmp    801577 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801568:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80156d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801571:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801575:	72 e1                	jb     801558 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80157b:	c9                   	leaveq 
  80157c:	c3                   	retq   

000000000080157d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80157d:	55                   	push   %rbp
  80157e:	48 89 e5             	mov    %rsp,%rbp
  801581:	48 83 ec 34          	sub    $0x34,%rsp
  801585:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801589:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80158d:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801590:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801597:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80159e:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159f:	eb 05                	jmp    8015a6 <strtol+0x29>
		s++;
  8015a1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015aa:	0f b6 00             	movzbl (%rax),%eax
  8015ad:	3c 20                	cmp    $0x20,%al
  8015af:	74 f0                	je     8015a1 <strtol+0x24>
  8015b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b5:	0f b6 00             	movzbl (%rax),%eax
  8015b8:	3c 09                	cmp    $0x9,%al
  8015ba:	74 e5                	je     8015a1 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015c0:	0f b6 00             	movzbl (%rax),%eax
  8015c3:	3c 2b                	cmp    $0x2b,%al
  8015c5:	75 07                	jne    8015ce <strtol+0x51>
		s++;
  8015c7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015cc:	eb 17                	jmp    8015e5 <strtol+0x68>
	else if (*s == '-')
  8015ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015d2:	0f b6 00             	movzbl (%rax),%eax
  8015d5:	3c 2d                	cmp    $0x2d,%al
  8015d7:	75 0c                	jne    8015e5 <strtol+0x68>
		s++, neg = 1;
  8015d9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015e5:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8015e9:	74 06                	je     8015f1 <strtol+0x74>
  8015eb:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8015ef:	75 28                	jne    801619 <strtol+0x9c>
  8015f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f5:	0f b6 00             	movzbl (%rax),%eax
  8015f8:	3c 30                	cmp    $0x30,%al
  8015fa:	75 1d                	jne    801619 <strtol+0x9c>
  8015fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801600:	48 83 c0 01          	add    $0x1,%rax
  801604:	0f b6 00             	movzbl (%rax),%eax
  801607:	3c 78                	cmp    $0x78,%al
  801609:	75 0e                	jne    801619 <strtol+0x9c>
		s += 2, base = 16;
  80160b:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801610:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801617:	eb 2c                	jmp    801645 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801619:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80161d:	75 19                	jne    801638 <strtol+0xbb>
  80161f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801623:	0f b6 00             	movzbl (%rax),%eax
  801626:	3c 30                	cmp    $0x30,%al
  801628:	75 0e                	jne    801638 <strtol+0xbb>
		s++, base = 8;
  80162a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80162f:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801636:	eb 0d                	jmp    801645 <strtol+0xc8>
	else if (base == 0)
  801638:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80163c:	75 07                	jne    801645 <strtol+0xc8>
		base = 10;
  80163e:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801645:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801649:	0f b6 00             	movzbl (%rax),%eax
  80164c:	3c 2f                	cmp    $0x2f,%al
  80164e:	7e 1d                	jle    80166d <strtol+0xf0>
  801650:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801654:	0f b6 00             	movzbl (%rax),%eax
  801657:	3c 39                	cmp    $0x39,%al
  801659:	7f 12                	jg     80166d <strtol+0xf0>
			dig = *s - '0';
  80165b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165f:	0f b6 00             	movzbl (%rax),%eax
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 30             	sub    $0x30,%eax
  801668:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80166b:	eb 4e                	jmp    8016bb <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80166d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801671:	0f b6 00             	movzbl (%rax),%eax
  801674:	3c 60                	cmp    $0x60,%al
  801676:	7e 1d                	jle    801695 <strtol+0x118>
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	0f b6 00             	movzbl (%rax),%eax
  80167f:	3c 7a                	cmp    $0x7a,%al
  801681:	7f 12                	jg     801695 <strtol+0x118>
			dig = *s - 'a' + 10;
  801683:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801687:	0f b6 00             	movzbl (%rax),%eax
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	83 e8 57             	sub    $0x57,%eax
  801690:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801693:	eb 26                	jmp    8016bb <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801699:	0f b6 00             	movzbl (%rax),%eax
  80169c:	3c 40                	cmp    $0x40,%al
  80169e:	7e 48                	jle    8016e8 <strtol+0x16b>
  8016a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016a4:	0f b6 00             	movzbl (%rax),%eax
  8016a7:	3c 5a                	cmp    $0x5a,%al
  8016a9:	7f 3d                	jg     8016e8 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8016ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016af:	0f b6 00             	movzbl (%rax),%eax
  8016b2:	0f be c0             	movsbl %al,%eax
  8016b5:	83 e8 37             	sub    $0x37,%eax
  8016b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8016bb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016be:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8016c1:	7c 02                	jl     8016c5 <strtol+0x148>
			break;
  8016c3:	eb 23                	jmp    8016e8 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8016c5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016ca:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8016cd:	48 98                	cltq   
  8016cf:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8016d4:	48 89 c2             	mov    %rax,%rdx
  8016d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016da:	48 98                	cltq   
  8016dc:	48 01 d0             	add    %rdx,%rax
  8016df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8016e3:	e9 5d ff ff ff       	jmpq   801645 <strtol+0xc8>

	if (endptr)
  8016e8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8016ed:	74 0b                	je     8016fa <strtol+0x17d>
		*endptr = (char *) s;
  8016ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8016f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016f7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8016fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8016fe:	74 09                	je     801709 <strtol+0x18c>
  801700:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801704:	48 f7 d8             	neg    %rax
  801707:	eb 04                	jmp    80170d <strtol+0x190>
  801709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80170d:	c9                   	leaveq 
  80170e:	c3                   	retq   

000000000080170f <strstr>:

char * strstr(const char *in, const char *str)
{
  80170f:	55                   	push   %rbp
  801710:	48 89 e5             	mov    %rsp,%rbp
  801713:	48 83 ec 30          	sub    $0x30,%rsp
  801717:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80171b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80171f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801723:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801727:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80172b:	0f b6 00             	movzbl (%rax),%eax
  80172e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801731:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801735:	75 06                	jne    80173d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801737:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173b:	eb 6b                	jmp    8017a8 <strstr+0x99>

	len = strlen(str);
  80173d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801741:	48 89 c7             	mov    %rax,%rdi
  801744:	48 b8 e5 0f 80 00 00 	movabs $0x800fe5,%rax
  80174b:	00 00 00 
  80174e:	ff d0                	callq  *%rax
  801750:	48 98                	cltq   
  801752:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801756:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80175e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801762:	0f b6 00             	movzbl (%rax),%eax
  801765:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801768:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80176c:	75 07                	jne    801775 <strstr+0x66>
				return (char *) 0;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
  801773:	eb 33                	jmp    8017a8 <strstr+0x99>
		} while (sc != c);
  801775:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801779:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80177c:	75 d8                	jne    801756 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80177e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801782:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801786:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80178a:	48 89 ce             	mov    %rcx,%rsi
  80178d:	48 89 c7             	mov    %rax,%rdi
  801790:	48 b8 06 12 80 00 00 	movabs $0x801206,%rax
  801797:	00 00 00 
  80179a:	ff d0                	callq  *%rax
  80179c:	85 c0                	test   %eax,%eax
  80179e:	75 b6                	jne    801756 <strstr+0x47>

	return (char *) (in - 1);
  8017a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a4:	48 83 e8 01          	sub    $0x1,%rax
}
  8017a8:	c9                   	leaveq 
  8017a9:	c3                   	retq   

00000000008017aa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8017aa:	55                   	push   %rbp
  8017ab:	48 89 e5             	mov    %rsp,%rbp
  8017ae:	53                   	push   %rbx
  8017af:	48 83 ec 48          	sub    $0x48,%rsp
  8017b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8017b6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8017b9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017bd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8017c1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8017c5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017cc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8017d0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8017d4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8017d8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8017dc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8017e0:	4c 89 c3             	mov    %r8,%rbx
  8017e3:	cd 30                	int    $0x30
  8017e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017e9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8017ed:	74 3e                	je     80182d <syscall+0x83>
  8017ef:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8017f4:	7e 37                	jle    80182d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8017fd:	49 89 d0             	mov    %rdx,%r8
  801800:	89 c1                	mov    %eax,%ecx
  801802:	48 ba 68 1e 80 00 00 	movabs $0x801e68,%rdx
  801809:	00 00 00 
  80180c:	be 23 00 00 00       	mov    $0x23,%esi
  801811:	48 bf 85 1e 80 00 00 	movabs $0x801e85,%rdi
  801818:	00 00 00 
  80181b:	b8 00 00 00 00       	mov    $0x0,%eax
  801820:	49 b9 50 02 80 00 00 	movabs $0x800250,%r9
  801827:	00 00 00 
  80182a:	41 ff d1             	callq  *%r9

	return ret;
  80182d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801831:	48 83 c4 48          	add    $0x48,%rsp
  801835:	5b                   	pop    %rbx
  801836:	5d                   	pop    %rbp
  801837:	c3                   	retq   

0000000000801838 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801838:	55                   	push   %rbp
  801839:	48 89 e5             	mov    %rsp,%rbp
  80183c:	48 83 ec 20          	sub    $0x20,%rsp
  801840:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801844:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801848:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80184c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801850:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801857:	00 
  801858:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80185e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801864:	48 89 d1             	mov    %rdx,%rcx
  801867:	48 89 c2             	mov    %rax,%rdx
  80186a:	be 00 00 00 00       	mov    $0x0,%esi
  80186f:	bf 00 00 00 00       	mov    $0x0,%edi
  801874:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  80187b:	00 00 00 
  80187e:	ff d0                	callq  *%rax
}
  801880:	c9                   	leaveq 
  801881:	c3                   	retq   

0000000000801882 <sys_cgetc>:

int
sys_cgetc(void)
{
  801882:	55                   	push   %rbp
  801883:	48 89 e5             	mov    %rsp,%rbp
  801886:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80188a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801891:	00 
  801892:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801898:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80189e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a8:	be 00 00 00 00       	mov    $0x0,%esi
  8018ad:	bf 01 00 00 00       	mov    $0x1,%edi
  8018b2:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  8018b9:	00 00 00 
  8018bc:	ff d0                	callq  *%rax
}
  8018be:	c9                   	leaveq 
  8018bf:	c3                   	retq   

00000000008018c0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018c0:	55                   	push   %rbp
  8018c1:	48 89 e5             	mov    %rsp,%rbp
  8018c4:	48 83 ec 10          	sub    $0x10,%rsp
  8018c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8018cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ce:	48 98                	cltq   
  8018d0:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018d7:	00 
  8018d8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018de:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018e9:	48 89 c2             	mov    %rax,%rdx
  8018ec:	be 01 00 00 00       	mov    $0x1,%esi
  8018f1:	bf 03 00 00 00       	mov    $0x3,%edi
  8018f6:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  8018fd:	00 00 00 
  801900:	ff d0                	callq  *%rax
}
  801902:	c9                   	leaveq 
  801903:	c3                   	retq   

0000000000801904 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801904:	55                   	push   %rbp
  801905:	48 89 e5             	mov    %rsp,%rbp
  801908:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80190c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801913:	00 
  801914:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80191a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801920:	b9 00 00 00 00       	mov    $0x0,%ecx
  801925:	ba 00 00 00 00       	mov    $0x0,%edx
  80192a:	be 00 00 00 00       	mov    $0x0,%esi
  80192f:	bf 02 00 00 00       	mov    $0x2,%edi
  801934:	48 b8 aa 17 80 00 00 	movabs $0x8017aa,%rax
  80193b:	00 00 00 
  80193e:	ff d0                	callq  *%rax
}
  801940:	c9                   	leaveq 
  801941:	c3                   	retq   
