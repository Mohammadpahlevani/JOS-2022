
obj/user/cat:     file format elf64-x86-64


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
  80003c:	e8 08 02 00 00       	callq  800249 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800052:	eb 68                	jmp    8000bc <cat+0x79>
		if ((r = write(1, buf, n)) != n)
  800054:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800058:	48 89 c2             	mov    %rax,%rdx
  80005b:	48 be 20 60 80 00 00 	movabs $0x806020,%rsi
  800062:	00 00 00 
  800065:	bf 01 00 00 00       	mov    $0x1,%edi
  80006a:	48 b8 e8 22 80 00 00 	movabs $0x8022e8,%rax
  800071:	00 00 00 
  800074:	ff d0                	callq  *%rax
  800076:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800079:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80007c:	48 98                	cltq   
  80007e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800082:	74 38                	je     8000bc <cat+0x79>
			panic("write error copying %s: %e", s, r);
  800084:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80008b:	41 89 d0             	mov    %edx,%r8d
  80008e:	48 89 c1             	mov    %rax,%rcx
  800091:	48 ba e0 39 80 00 00 	movabs $0x8039e0,%rdx
  800098:	00 00 00 
  80009b:	be 0d 00 00 00       	mov    $0xd,%esi
  8000a0:	48 bf fb 39 80 00 00 	movabs $0x8039fb,%rdi
  8000a7:	00 00 00 
  8000aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000af:	49 b9 fc 02 80 00 00 	movabs $0x8002fc,%r9
  8000b6:	00 00 00 
  8000b9:	41 ff d1             	callq  *%r9
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  8000bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000bf:	ba 00 20 00 00       	mov    $0x2000,%edx
  8000c4:	48 be 20 60 80 00 00 	movabs $0x806020,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 9e 21 80 00 00 	movabs $0x80219e,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	48 98                	cltq   
  8000de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8000e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000e7:	0f 8f 67 ff ff ff    	jg     800054 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000ed:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8000f2:	79 39                	jns    80012d <cat+0xea>
		panic("error reading %s: %e", s, n);
  8000f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8000f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000fc:	49 89 d0             	mov    %rdx,%r8
  8000ff:	48 89 c1             	mov    %rax,%rcx
  800102:	48 ba 06 3a 80 00 00 	movabs $0x803a06,%rdx
  800109:	00 00 00 
  80010c:	be 0f 00 00 00       	mov    $0xf,%esi
  800111:	48 bf fb 39 80 00 00 	movabs $0x8039fb,%rdi
  800118:	00 00 00 
  80011b:	b8 00 00 00 00       	mov    $0x0,%eax
  800120:	49 b9 fc 02 80 00 00 	movabs $0x8002fc,%r9
  800127:	00 00 00 
  80012a:	41 ff d1             	callq  *%r9
}
  80012d:	c9                   	leaveq 
  80012e:	c3                   	retq   

000000000080012f <umain>:

void
umain(int argc, char **argv)
{
  80012f:	55                   	push   %rbp
  800130:	48 89 e5             	mov    %rsp,%rbp
  800133:	53                   	push   %rbx
  800134:	48 83 ec 28          	sub    $0x28,%rsp
  800138:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80013b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int f, i;

	binaryname = "cat";
  80013f:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  800146:	00 00 00 
  800149:	48 bb 1b 3a 80 00 00 	movabs $0x803a1b,%rbx
  800150:	00 00 00 
  800153:	48 89 18             	mov    %rbx,(%rax)
	if (argc == 1)
  800156:	83 7d dc 01          	cmpl   $0x1,-0x24(%rbp)
  80015a:	75 20                	jne    80017c <umain+0x4d>
		cat(0, "<stdin>");
  80015c:	48 be 1f 3a 80 00 00 	movabs $0x803a1f,%rsi
  800163:	00 00 00 
  800166:	bf 00 00 00 00       	mov    $0x0,%edi
  80016b:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800172:	00 00 00 
  800175:	ff d0                	callq  *%rax
  800177:	e9 c6 00 00 00       	jmpq   800242 <umain+0x113>
	else
		for (i = 1; i < argc; i++) {
  80017c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%rbp)
  800183:	e9 ae 00 00 00       	jmpq   800236 <umain+0x107>
			f = open(argv[i], O_RDONLY);
  800188:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80018b:	48 98                	cltq   
  80018d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800194:	00 
  800195:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800199:	48 01 d0             	add    %rdx,%rax
  80019c:	48 8b 00             	mov    (%rax),%rax
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
  8001a4:	48 89 c7             	mov    %rax,%rdi
  8001a7:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
  8001b3:	89 45 e8             	mov    %eax,-0x18(%rbp)
			if (f < 0)
  8001b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8001ba:	79 3a                	jns    8001f6 <umain+0xc7>
				printf("can't open %s: %e\n", argv[i], f);
  8001bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bf:	48 98                	cltq   
  8001c1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8001c8:	00 
  8001c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8001cd:	48 01 d0             	add    %rdx,%rax
  8001d0:	48 8b 00             	mov    (%rax),%rax
  8001d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8001d6:	48 89 c6             	mov    %rax,%rsi
  8001d9:	48 bf 27 3a 80 00 00 	movabs $0x803a27,%rdi
  8001e0:	00 00 00 
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e8:	48 b9 25 2e 80 00 00 	movabs $0x802e25,%rcx
  8001ef:	00 00 00 
  8001f2:	ff d1                	callq  *%rcx
  8001f4:	eb 3c                	jmp    800232 <umain+0x103>
			else {
				cat(f, argv[i]);
  8001f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800202:	00 
  800203:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800207:	48 01 d0             	add    %rdx,%rax
  80020a:	48 8b 10             	mov    (%rax),%rdx
  80020d:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800210:	48 89 d6             	mov    %rdx,%rsi
  800213:	89 c7                	mov    %eax,%edi
  800215:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80021c:	00 00 00 
  80021f:	ff d0                	callq  *%rax
				close(f);
  800221:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800224:	89 c7                	mov    %eax,%edi
  800226:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  80022d:	00 00 00 
  800230:	ff d0                	callq  *%rax

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800232:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  800236:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800239:	3b 45 dc             	cmp    -0x24(%rbp),%eax
  80023c:	0f 8c 46 ff ff ff    	jl     800188 <umain+0x59>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  800242:	48 83 c4 28          	add    $0x28,%rsp
  800246:	5b                   	pop    %rbx
  800247:	5d                   	pop    %rbp
  800248:	c3                   	retq   

0000000000800249 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800249:	55                   	push   %rbp
  80024a:	48 89 e5             	mov    %rsp,%rbp
  80024d:	48 83 ec 10          	sub    $0x10,%rsp
  800251:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800254:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = (struct Env*)envs + ENVX(sys_getenvid());
  800258:	48 b8 9d 19 80 00 00 	movabs $0x80199d,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
  800264:	48 98                	cltq   
  800266:	25 ff 03 00 00       	and    $0x3ff,%eax
  80026b:	48 89 c2             	mov    %rax,%rdx
  80026e:	48 89 d0             	mov    %rdx,%rax
  800271:	48 c1 e0 03          	shl    $0x3,%rax
  800275:	48 01 d0             	add    %rdx,%rax
  800278:	48 c1 e0 05          	shl    $0x5,%rax
  80027c:	48 89 c2             	mov    %rax,%rdx
  80027f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800286:	00 00 00 
  800289:	48 01 c2             	add    %rax,%rdx
  80028c:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800293:	00 00 00 
  800296:	48 89 10             	mov    %rdx,(%rax)

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800299:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029d:	7e 14                	jle    8002b3 <libmain+0x6a>
		binaryname = argv[0];
  80029f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a3:	48 8b 10             	mov    (%rax),%rdx
  8002a6:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  8002ad:	00 00 00 
  8002b0:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8002b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ba:	48 89 d6             	mov    %rdx,%rsi
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 2f 01 80 00 00 	movabs $0x80012f,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8002cb:	48 b8 d9 02 80 00 00 	movabs $0x8002d9,%rax
  8002d2:	00 00 00 
  8002d5:	ff d0                	callq  *%rax
}
  8002d7:	c9                   	leaveq 
  8002d8:	c3                   	retq   

00000000008002d9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002d9:	55                   	push   %rbp
  8002da:	48 89 e5             	mov    %rsp,%rbp
	close_all();
  8002dd:	48 b8 c7 1f 80 00 00 	movabs $0x801fc7,%rax
  8002e4:	00 00 00 
  8002e7:	ff d0                	callq  *%rax
	sys_env_destroy(0);
  8002e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8002ee:	48 b8 59 19 80 00 00 	movabs $0x801959,%rax
  8002f5:	00 00 00 
  8002f8:	ff d0                	callq  *%rax
}
  8002fa:	5d                   	pop    %rbp
  8002fb:	c3                   	retq   

00000000008002fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002fc:	55                   	push   %rbp
  8002fd:	48 89 e5             	mov    %rsp,%rbp
  800300:	53                   	push   %rbx
  800301:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800308:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80030f:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800315:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80031c:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800323:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80032a:	84 c0                	test   %al,%al
  80032c:	74 23                	je     800351 <_panic+0x55>
  80032e:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800335:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800339:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80033d:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800341:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800345:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800349:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80034d:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800351:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800358:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80035f:	00 00 00 
  800362:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800369:	00 00 00 
  80036c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800370:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800377:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80037e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800385:	48 b8 00 50 80 00 00 	movabs $0x805000,%rax
  80038c:	00 00 00 
  80038f:	48 8b 18             	mov    (%rax),%rbx
  800392:	48 b8 9d 19 80 00 00 	movabs $0x80199d,%rax
  800399:	00 00 00 
  80039c:	ff d0                	callq  *%rax
  80039e:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8003a4:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8003ab:	41 89 c8             	mov    %ecx,%r8d
  8003ae:	48 89 d1             	mov    %rdx,%rcx
  8003b1:	48 89 da             	mov    %rbx,%rdx
  8003b4:	89 c6                	mov    %eax,%esi
  8003b6:	48 bf 48 3a 80 00 00 	movabs $0x803a48,%rdi
  8003bd:	00 00 00 
  8003c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c5:	49 b9 35 05 80 00 00 	movabs $0x800535,%r9
  8003cc:	00 00 00 
  8003cf:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003d2:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8003d9:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8003e0:	48 89 d6             	mov    %rdx,%rsi
  8003e3:	48 89 c7             	mov    %rax,%rdi
  8003e6:	48 b8 89 04 80 00 00 	movabs $0x800489,%rax
  8003ed:	00 00 00 
  8003f0:	ff d0                	callq  *%rax
	cprintf("\n");
  8003f2:	48 bf 6b 3a 80 00 00 	movabs $0x803a6b,%rdi
  8003f9:	00 00 00 
  8003fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800401:	48 ba 35 05 80 00 00 	movabs $0x800535,%rdx
  800408:	00 00 00 
  80040b:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80040d:	cc                   	int3   
  80040e:	eb fd                	jmp    80040d <_panic+0x111>

0000000000800410 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800410:	55                   	push   %rbp
  800411:	48 89 e5             	mov    %rsp,%rbp
  800414:	48 83 ec 10          	sub    $0x10,%rsp
  800418:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80041b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80041f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800423:	8b 00                	mov    (%rax),%eax
  800425:	8d 48 01             	lea    0x1(%rax),%ecx
  800428:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80042c:	89 0a                	mov    %ecx,(%rdx)
  80042e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800431:	89 d1                	mov    %edx,%ecx
  800433:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800437:	48 98                	cltq   
  800439:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  80043d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800441:	8b 00                	mov    (%rax),%eax
  800443:	3d ff 00 00 00       	cmp    $0xff,%eax
  800448:	75 2c                	jne    800476 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80044a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044e:	8b 00                	mov    (%rax),%eax
  800450:	48 98                	cltq   
  800452:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800456:	48 83 c2 08          	add    $0x8,%rdx
  80045a:	48 89 c6             	mov    %rax,%rsi
  80045d:	48 89 d7             	mov    %rdx,%rdi
  800460:	48 b8 d1 18 80 00 00 	movabs $0x8018d1,%rax
  800467:	00 00 00 
  80046a:	ff d0                	callq  *%rax
        b->idx = 0;
  80046c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800470:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80047a:	8b 40 04             	mov    0x4(%rax),%eax
  80047d:	8d 50 01             	lea    0x1(%rax),%edx
  800480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800484:	89 50 04             	mov    %edx,0x4(%rax)
}
  800487:	c9                   	leaveq 
  800488:	c3                   	retq   

0000000000800489 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800489:	55                   	push   %rbp
  80048a:	48 89 e5             	mov    %rsp,%rbp
  80048d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800494:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80049b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8004a2:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8004a9:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8004b0:	48 8b 0a             	mov    (%rdx),%rcx
  8004b3:	48 89 08             	mov    %rcx,(%rax)
  8004b6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8004ba:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8004be:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8004c2:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8004c6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8004cd:	00 00 00 
    b.cnt = 0;
  8004d0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8004d7:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8004da:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8004e1:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8004e8:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8004ef:	48 89 c6             	mov    %rax,%rsi
  8004f2:	48 bf 10 04 80 00 00 	movabs $0x800410,%rdi
  8004f9:	00 00 00 
  8004fc:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800503:	00 00 00 
  800506:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800508:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80050e:	48 98                	cltq   
  800510:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800517:	48 83 c2 08          	add    $0x8,%rdx
  80051b:	48 89 c6             	mov    %rax,%rsi
  80051e:	48 89 d7             	mov    %rdx,%rdi
  800521:	48 b8 d1 18 80 00 00 	movabs $0x8018d1,%rax
  800528:	00 00 00 
  80052b:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80052d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800533:	c9                   	leaveq 
  800534:	c3                   	retq   

0000000000800535 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800535:	55                   	push   %rbp
  800536:	48 89 e5             	mov    %rsp,%rbp
  800539:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800540:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800547:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80054e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800555:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80055c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800563:	84 c0                	test   %al,%al
  800565:	74 20                	je     800587 <cprintf+0x52>
  800567:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80056b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80056f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800573:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800577:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80057b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80057f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800583:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800587:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80058e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800595:	00 00 00 
  800598:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80059f:	00 00 00 
  8005a2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8005a6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8005ad:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8005b4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8005bb:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8005c2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8005c9:	48 8b 0a             	mov    (%rdx),%rcx
  8005cc:	48 89 08             	mov    %rcx,(%rax)
  8005cf:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8005d3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005d7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005db:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8005df:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8005e6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005ed:	48 89 d6             	mov    %rdx,%rsi
  8005f0:	48 89 c7             	mov    %rax,%rdi
  8005f3:	48 b8 89 04 80 00 00 	movabs $0x800489,%rax
  8005fa:	00 00 00 
  8005fd:	ff d0                	callq  *%rax
  8005ff:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800605:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80060b:	c9                   	leaveq 
  80060c:	c3                   	retq   

000000000080060d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80060d:	55                   	push   %rbp
  80060e:	48 89 e5             	mov    %rsp,%rbp
  800611:	53                   	push   %rbx
  800612:	48 83 ec 38          	sub    $0x38,%rsp
  800616:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80061a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80061e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800622:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  800625:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800629:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80062d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800630:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800634:	77 3b                	ja     800671 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800636:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800639:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  80063d:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800640:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	48 f7 f3             	div    %rbx
  80064c:	48 89 c2             	mov    %rax,%rdx
  80064f:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800652:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800655:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800659:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80065d:	41 89 f9             	mov    %edi,%r9d
  800660:	48 89 c7             	mov    %rax,%rdi
  800663:	48 b8 0d 06 80 00 00 	movabs $0x80060d,%rax
  80066a:	00 00 00 
  80066d:	ff d0                	callq  *%rax
  80066f:	eb 1e                	jmp    80068f <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800671:	eb 12                	jmp    800685 <printnum+0x78>
			putch(padc, putdat);
  800673:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800677:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80067a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80067e:	48 89 ce             	mov    %rcx,%rsi
  800681:	89 d7                	mov    %edx,%edi
  800683:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800685:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800689:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  80068d:	7f e4                	jg     800673 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068f:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800692:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800696:	ba 00 00 00 00       	mov    $0x0,%edx
  80069b:	48 f7 f1             	div    %rcx
  80069e:	48 89 d0             	mov    %rdx,%rax
  8006a1:	48 ba 70 3c 80 00 00 	movabs $0x803c70,%rdx
  8006a8:	00 00 00 
  8006ab:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8006af:	0f be d0             	movsbl %al,%edx
  8006b2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8006b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ba:	48 89 ce             	mov    %rcx,%rsi
  8006bd:	89 d7                	mov    %edx,%edi
  8006bf:	ff d0                	callq  *%rax
}
  8006c1:	48 83 c4 38          	add    $0x38,%rsp
  8006c5:	5b                   	pop    %rbx
  8006c6:	5d                   	pop    %rbp
  8006c7:	c3                   	retq   

00000000008006c8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c8:	55                   	push   %rbp
  8006c9:	48 89 e5             	mov    %rsp,%rbp
  8006cc:	48 83 ec 1c          	sub    $0x1c,%rsp
  8006d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006d4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8006d7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8006db:	7e 52                	jle    80072f <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8006dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e1:	8b 00                	mov    (%rax),%eax
  8006e3:	83 f8 30             	cmp    $0x30,%eax
  8006e6:	73 24                	jae    80070c <getuint+0x44>
  8006e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f4:	8b 00                	mov    (%rax),%eax
  8006f6:	89 c0                	mov    %eax,%eax
  8006f8:	48 01 d0             	add    %rdx,%rax
  8006fb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006ff:	8b 12                	mov    (%rdx),%edx
  800701:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800704:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800708:	89 0a                	mov    %ecx,(%rdx)
  80070a:	eb 17                	jmp    800723 <getuint+0x5b>
  80070c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800710:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800714:	48 89 d0             	mov    %rdx,%rax
  800717:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80071b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800723:	48 8b 00             	mov    (%rax),%rax
  800726:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80072a:	e9 a3 00 00 00       	jmpq   8007d2 <getuint+0x10a>
	else if (lflag)
  80072f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800733:	74 4f                	je     800784 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800739:	8b 00                	mov    (%rax),%eax
  80073b:	83 f8 30             	cmp    $0x30,%eax
  80073e:	73 24                	jae    800764 <getuint+0x9c>
  800740:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800744:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80074c:	8b 00                	mov    (%rax),%eax
  80074e:	89 c0                	mov    %eax,%eax
  800750:	48 01 d0             	add    %rdx,%rax
  800753:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800757:	8b 12                	mov    (%rdx),%edx
  800759:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80075c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800760:	89 0a                	mov    %ecx,(%rdx)
  800762:	eb 17                	jmp    80077b <getuint+0xb3>
  800764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800768:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80076c:	48 89 d0             	mov    %rdx,%rax
  80076f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800773:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800777:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80077b:	48 8b 00             	mov    (%rax),%rax
  80077e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800782:	eb 4e                	jmp    8007d2 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800784:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800788:	8b 00                	mov    (%rax),%eax
  80078a:	83 f8 30             	cmp    $0x30,%eax
  80078d:	73 24                	jae    8007b3 <getuint+0xeb>
  80078f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800793:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800797:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079b:	8b 00                	mov    (%rax),%eax
  80079d:	89 c0                	mov    %eax,%eax
  80079f:	48 01 d0             	add    %rdx,%rax
  8007a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007a6:	8b 12                	mov    (%rdx),%edx
  8007a8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007ab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007af:	89 0a                	mov    %ecx,(%rdx)
  8007b1:	eb 17                	jmp    8007ca <getuint+0x102>
  8007b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007b7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007bb:	48 89 d0             	mov    %rdx,%rax
  8007be:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8007c2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8007ca:	8b 00                	mov    (%rax),%eax
  8007cc:	89 c0                	mov    %eax,%eax
  8007ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8007d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8007d6:	c9                   	leaveq 
  8007d7:	c3                   	retq   

00000000008007d8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d8:	55                   	push   %rbp
  8007d9:	48 89 e5             	mov    %rsp,%rbp
  8007dc:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007e4:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8007e7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007eb:	7e 52                	jle    80083f <getint+0x67>
		x=va_arg(*ap, long long);
  8007ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f1:	8b 00                	mov    (%rax),%eax
  8007f3:	83 f8 30             	cmp    $0x30,%eax
  8007f6:	73 24                	jae    80081c <getint+0x44>
  8007f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800804:	8b 00                	mov    (%rax),%eax
  800806:	89 c0                	mov    %eax,%eax
  800808:	48 01 d0             	add    %rdx,%rax
  80080b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80080f:	8b 12                	mov    (%rdx),%edx
  800811:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800814:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800818:	89 0a                	mov    %ecx,(%rdx)
  80081a:	eb 17                	jmp    800833 <getint+0x5b>
  80081c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800820:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800824:	48 89 d0             	mov    %rdx,%rax
  800827:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80082b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80082f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800833:	48 8b 00             	mov    (%rax),%rax
  800836:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80083a:	e9 a3 00 00 00       	jmpq   8008e2 <getint+0x10a>
	else if (lflag)
  80083f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800843:	74 4f                	je     800894 <getint+0xbc>
		x=va_arg(*ap, long);
  800845:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800849:	8b 00                	mov    (%rax),%eax
  80084b:	83 f8 30             	cmp    $0x30,%eax
  80084e:	73 24                	jae    800874 <getint+0x9c>
  800850:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800854:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800858:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085c:	8b 00                	mov    (%rax),%eax
  80085e:	89 c0                	mov    %eax,%eax
  800860:	48 01 d0             	add    %rdx,%rax
  800863:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800867:	8b 12                	mov    (%rdx),%edx
  800869:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80086c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800870:	89 0a                	mov    %ecx,(%rdx)
  800872:	eb 17                	jmp    80088b <getint+0xb3>
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80087c:	48 89 d0             	mov    %rdx,%rax
  80087f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800883:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800887:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80088b:	48 8b 00             	mov    (%rax),%rax
  80088e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800892:	eb 4e                	jmp    8008e2 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800898:	8b 00                	mov    (%rax),%eax
  80089a:	83 f8 30             	cmp    $0x30,%eax
  80089d:	73 24                	jae    8008c3 <getint+0xeb>
  80089f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ab:	8b 00                	mov    (%rax),%eax
  8008ad:	89 c0                	mov    %eax,%eax
  8008af:	48 01 d0             	add    %rdx,%rax
  8008b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008b6:	8b 12                	mov    (%rdx),%edx
  8008b8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008bf:	89 0a                	mov    %ecx,(%rdx)
  8008c1:	eb 17                	jmp    8008da <getint+0x102>
  8008c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c7:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008cb:	48 89 d0             	mov    %rdx,%rax
  8008ce:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008d2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008d6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008da:	8b 00                	mov    (%rax),%eax
  8008dc:	48 98                	cltq   
  8008de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008e6:	c9                   	leaveq 
  8008e7:	c3                   	retq   

00000000008008e8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008e8:	55                   	push   %rbp
  8008e9:	48 89 e5             	mov    %rsp,%rbp
  8008ec:	41 54                	push   %r12
  8008ee:	53                   	push   %rbx
  8008ef:	48 83 ec 60          	sub    $0x60,%rsp
  8008f3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8008f7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8008fb:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8008ff:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800903:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800907:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80090b:	48 8b 0a             	mov    (%rdx),%rcx
  80090e:	48 89 08             	mov    %rcx,(%rax)
  800911:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800915:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800919:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80091d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800921:	eb 17                	jmp    80093a <vprintfmt+0x52>
			if (ch == '\0')
  800923:	85 db                	test   %ebx,%ebx
  800925:	0f 84 cc 04 00 00    	je     800df7 <vprintfmt+0x50f>
				return;
			putch(ch, putdat);
  80092b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80092f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800933:	48 89 d6             	mov    %rdx,%rsi
  800936:	89 df                	mov    %ebx,%edi
  800938:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80093e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800942:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800946:	0f b6 00             	movzbl (%rax),%eax
  800949:	0f b6 d8             	movzbl %al,%ebx
  80094c:	83 fb 25             	cmp    $0x25,%ebx
  80094f:	75 d2                	jne    800923 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800951:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800955:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80095c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800963:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80096a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800971:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800975:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800979:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80097d:	0f b6 00             	movzbl (%rax),%eax
  800980:	0f b6 d8             	movzbl %al,%ebx
  800983:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800986:	83 f8 55             	cmp    $0x55,%eax
  800989:	0f 87 34 04 00 00    	ja     800dc3 <vprintfmt+0x4db>
  80098f:	89 c0                	mov    %eax,%eax
  800991:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800998:	00 
  800999:	48 b8 98 3c 80 00 00 	movabs $0x803c98,%rax
  8009a0:	00 00 00 
  8009a3:	48 01 d0             	add    %rdx,%rax
  8009a6:	48 8b 00             	mov    (%rax),%rax
  8009a9:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8009ab:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8009af:	eb c0                	jmp    800971 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b1:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8009b5:	eb ba                	jmp    800971 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8009be:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8009c1:	89 d0                	mov    %edx,%eax
  8009c3:	c1 e0 02             	shl    $0x2,%eax
  8009c6:	01 d0                	add    %edx,%eax
  8009c8:	01 c0                	add    %eax,%eax
  8009ca:	01 d8                	add    %ebx,%eax
  8009cc:	83 e8 30             	sub    $0x30,%eax
  8009cf:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8009d2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8009d6:	0f b6 00             	movzbl (%rax),%eax
  8009d9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009dc:	83 fb 2f             	cmp    $0x2f,%ebx
  8009df:	7e 0c                	jle    8009ed <vprintfmt+0x105>
  8009e1:	83 fb 39             	cmp    $0x39,%ebx
  8009e4:	7f 07                	jg     8009ed <vprintfmt+0x105>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e6:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009eb:	eb d1                	jmp    8009be <vprintfmt+0xd6>
			goto process_precision;
  8009ed:	eb 58                	jmp    800a47 <vprintfmt+0x15f>

		case '*':
			precision = va_arg(aq, int);
  8009ef:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009f2:	83 f8 30             	cmp    $0x30,%eax
  8009f5:	73 17                	jae    800a0e <vprintfmt+0x126>
  8009f7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8009fb:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8009fe:	89 c0                	mov    %eax,%eax
  800a00:	48 01 d0             	add    %rdx,%rax
  800a03:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a06:	83 c2 08             	add    $0x8,%edx
  800a09:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a0c:	eb 0f                	jmp    800a1d <vprintfmt+0x135>
  800a0e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a12:	48 89 d0             	mov    %rdx,%rax
  800a15:	48 83 c2 08          	add    $0x8,%rdx
  800a19:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a1d:	8b 00                	mov    (%rax),%eax
  800a1f:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800a22:	eb 23                	jmp    800a47 <vprintfmt+0x15f>

		case '.':
			if (width < 0)
  800a24:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a28:	79 0c                	jns    800a36 <vprintfmt+0x14e>
				width = 0;
  800a2a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800a31:	e9 3b ff ff ff       	jmpq   800971 <vprintfmt+0x89>
  800a36:	e9 36 ff ff ff       	jmpq   800971 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800a3b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800a42:	e9 2a ff ff ff       	jmpq   800971 <vprintfmt+0x89>

		process_precision:
			if (width < 0)
  800a47:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a4b:	79 12                	jns    800a5f <vprintfmt+0x177>
				width = precision, precision = -1;
  800a4d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800a50:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800a53:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800a5a:	e9 12 ff ff ff       	jmpq   800971 <vprintfmt+0x89>
  800a5f:	e9 0d ff ff ff       	jmpq   800971 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a64:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800a68:	e9 04 ff ff ff       	jmpq   800971 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800a6d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a70:	83 f8 30             	cmp    $0x30,%eax
  800a73:	73 17                	jae    800a8c <vprintfmt+0x1a4>
  800a75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800a7c:	89 c0                	mov    %eax,%eax
  800a7e:	48 01 d0             	add    %rdx,%rax
  800a81:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800a84:	83 c2 08             	add    $0x8,%edx
  800a87:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800a8a:	eb 0f                	jmp    800a9b <vprintfmt+0x1b3>
  800a8c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800a90:	48 89 d0             	mov    %rdx,%rax
  800a93:	48 83 c2 08          	add    $0x8,%rdx
  800a97:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800a9b:	8b 10                	mov    (%rax),%edx
  800a9d:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800aa1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800aa5:	48 89 ce             	mov    %rcx,%rsi
  800aa8:	89 d7                	mov    %edx,%edi
  800aaa:	ff d0                	callq  *%rax
			break;
  800aac:	e9 40 03 00 00       	jmpq   800df1 <vprintfmt+0x509>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ab1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ab4:	83 f8 30             	cmp    $0x30,%eax
  800ab7:	73 17                	jae    800ad0 <vprintfmt+0x1e8>
  800ab9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800abd:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ac0:	89 c0                	mov    %eax,%eax
  800ac2:	48 01 d0             	add    %rdx,%rax
  800ac5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ac8:	83 c2 08             	add    $0x8,%edx
  800acb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ace:	eb 0f                	jmp    800adf <vprintfmt+0x1f7>
  800ad0:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800ad4:	48 89 d0             	mov    %rdx,%rax
  800ad7:	48 83 c2 08          	add    $0x8,%rdx
  800adb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800adf:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ae1:	85 db                	test   %ebx,%ebx
  800ae3:	79 02                	jns    800ae7 <vprintfmt+0x1ff>
				err = -err;
  800ae5:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800ae7:	83 fb 15             	cmp    $0x15,%ebx
  800aea:	7f 16                	jg     800b02 <vprintfmt+0x21a>
  800aec:	48 b8 c0 3b 80 00 00 	movabs $0x803bc0,%rax
  800af3:	00 00 00 
  800af6:	48 63 d3             	movslq %ebx,%rdx
  800af9:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800afd:	4d 85 e4             	test   %r12,%r12
  800b00:	75 2e                	jne    800b30 <vprintfmt+0x248>
				printfmt(putch, putdat, "error %d", err);
  800b02:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b0a:	89 d9                	mov    %ebx,%ecx
  800b0c:	48 ba 81 3c 80 00 00 	movabs $0x803c81,%rdx
  800b13:	00 00 00 
  800b16:	48 89 c7             	mov    %rax,%rdi
  800b19:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1e:	49 b8 00 0e 80 00 00 	movabs $0x800e00,%r8
  800b25:	00 00 00 
  800b28:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b2b:	e9 c1 02 00 00       	jmpq   800df1 <vprintfmt+0x509>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b30:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800b34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b38:	4c 89 e1             	mov    %r12,%rcx
  800b3b:	48 ba 8a 3c 80 00 00 	movabs $0x803c8a,%rdx
  800b42:	00 00 00 
  800b45:	48 89 c7             	mov    %rax,%rdi
  800b48:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4d:	49 b8 00 0e 80 00 00 	movabs $0x800e00,%r8
  800b54:	00 00 00 
  800b57:	41 ff d0             	callq  *%r8
			break;
  800b5a:	e9 92 02 00 00       	jmpq   800df1 <vprintfmt+0x509>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800b5f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b62:	83 f8 30             	cmp    $0x30,%eax
  800b65:	73 17                	jae    800b7e <vprintfmt+0x296>
  800b67:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b6b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b6e:	89 c0                	mov    %eax,%eax
  800b70:	48 01 d0             	add    %rdx,%rax
  800b73:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b76:	83 c2 08             	add    $0x8,%edx
  800b79:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b7c:	eb 0f                	jmp    800b8d <vprintfmt+0x2a5>
  800b7e:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b82:	48 89 d0             	mov    %rdx,%rax
  800b85:	48 83 c2 08          	add    $0x8,%rdx
  800b89:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b8d:	4c 8b 20             	mov    (%rax),%r12
  800b90:	4d 85 e4             	test   %r12,%r12
  800b93:	75 0a                	jne    800b9f <vprintfmt+0x2b7>
				p = "(null)";
  800b95:	49 bc 8d 3c 80 00 00 	movabs $0x803c8d,%r12
  800b9c:	00 00 00 
			if (width > 0 && padc != '-')
  800b9f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ba3:	7e 3f                	jle    800be4 <vprintfmt+0x2fc>
  800ba5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ba9:	74 39                	je     800be4 <vprintfmt+0x2fc>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bab:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bae:	48 98                	cltq   
  800bb0:	48 89 c6             	mov    %rax,%rsi
  800bb3:	4c 89 e7             	mov    %r12,%rdi
  800bb6:	48 b8 ac 10 80 00 00 	movabs $0x8010ac,%rax
  800bbd:	00 00 00 
  800bc0:	ff d0                	callq  *%rax
  800bc2:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800bc5:	eb 17                	jmp    800bde <vprintfmt+0x2f6>
					putch(padc, putdat);
  800bc7:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800bcb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800bcf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd3:	48 89 ce             	mov    %rcx,%rsi
  800bd6:	89 d7                	mov    %edx,%edi
  800bd8:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bda:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800bde:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800be2:	7f e3                	jg     800bc7 <vprintfmt+0x2df>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be4:	eb 37                	jmp    800c1d <vprintfmt+0x335>
				if (altflag && (ch < ' ' || ch > '~'))
  800be6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800bea:	74 1e                	je     800c0a <vprintfmt+0x322>
  800bec:	83 fb 1f             	cmp    $0x1f,%ebx
  800bef:	7e 05                	jle    800bf6 <vprintfmt+0x30e>
  800bf1:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf4:	7e 14                	jle    800c0a <vprintfmt+0x322>
					putch('?', putdat);
  800bf6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bfe:	48 89 d6             	mov    %rdx,%rsi
  800c01:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800c06:	ff d0                	callq  *%rax
  800c08:	eb 0f                	jmp    800c19 <vprintfmt+0x331>
				else
					putch(ch, putdat);
  800c0a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c12:	48 89 d6             	mov    %rdx,%rsi
  800c15:	89 df                	mov    %ebx,%edi
  800c17:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c19:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c1d:	4c 89 e0             	mov    %r12,%rax
  800c20:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800c24:	0f b6 00             	movzbl (%rax),%eax
  800c27:	0f be d8             	movsbl %al,%ebx
  800c2a:	85 db                	test   %ebx,%ebx
  800c2c:	74 10                	je     800c3e <vprintfmt+0x356>
  800c2e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c32:	78 b2                	js     800be6 <vprintfmt+0x2fe>
  800c34:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800c38:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800c3c:	79 a8                	jns    800be6 <vprintfmt+0x2fe>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c3e:	eb 16                	jmp    800c56 <vprintfmt+0x36e>
				putch(' ', putdat);
  800c40:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c44:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c48:	48 89 d6             	mov    %rdx,%rsi
  800c4b:	bf 20 00 00 00       	mov    $0x20,%edi
  800c50:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c52:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800c56:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c5a:	7f e4                	jg     800c40 <vprintfmt+0x358>
				putch(' ', putdat);
			break;
  800c5c:	e9 90 01 00 00       	jmpq   800df1 <vprintfmt+0x509>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800c61:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c65:	be 03 00 00 00       	mov    $0x3,%esi
  800c6a:	48 89 c7             	mov    %rax,%rdi
  800c6d:	48 b8 d8 07 80 00 00 	movabs $0x8007d8,%rax
  800c74:	00 00 00 
  800c77:	ff d0                	callq  *%rax
  800c79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800c7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c81:	48 85 c0             	test   %rax,%rax
  800c84:	79 1d                	jns    800ca3 <vprintfmt+0x3bb>
				putch('-', putdat);
  800c86:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c8e:	48 89 d6             	mov    %rdx,%rsi
  800c91:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800c96:	ff d0                	callq  *%rax
				num = -(long long) num;
  800c98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c9c:	48 f7 d8             	neg    %rax
  800c9f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ca3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800caa:	e9 d5 00 00 00       	jmpq   800d84 <vprintfmt+0x49c>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800caf:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cb3:	be 03 00 00 00       	mov    $0x3,%esi
  800cb8:	48 89 c7             	mov    %rax,%rdi
  800cbb:	48 b8 c8 06 80 00 00 	movabs $0x8006c8,%rax
  800cc2:	00 00 00 
  800cc5:	ff d0                	callq  *%rax
  800cc7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ccb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800cd2:	e9 ad 00 00 00       	jmpq   800d84 <vprintfmt+0x49c>

			// (unsigned) octal
		case 'o':
			// Replace this with your code.
      num = getuint(&aq, 3);
  800cd7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800cdb:	be 03 00 00 00       	mov    $0x3,%esi
  800ce0:	48 89 c7             	mov    %rax,%rdi
  800ce3:	48 b8 c8 06 80 00 00 	movabs $0x8006c8,%rax
  800cea:	00 00 00 
  800ced:	ff d0                	callq  *%rax
  800cef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      base = 8;
  800cf3:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
      goto number;
  800cfa:	e9 85 00 00 00       	jmpq   800d84 <vprintfmt+0x49c>

			// pointer
		case 'p':
			putch('0', putdat);
  800cff:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d03:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d07:	48 89 d6             	mov    %rdx,%rsi
  800d0a:	bf 30 00 00 00       	mov    $0x30,%edi
  800d0f:	ff d0                	callq  *%rax
			putch('x', putdat);
  800d11:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d19:	48 89 d6             	mov    %rdx,%rsi
  800d1c:	bf 78 00 00 00       	mov    $0x78,%edi
  800d21:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800d23:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d26:	83 f8 30             	cmp    $0x30,%eax
  800d29:	73 17                	jae    800d42 <vprintfmt+0x45a>
  800d2b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d2f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d32:	89 c0                	mov    %eax,%eax
  800d34:	48 01 d0             	add    %rdx,%rax
  800d37:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d3a:	83 c2 08             	add    $0x8,%edx
  800d3d:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d40:	eb 0f                	jmp    800d51 <vprintfmt+0x469>
				(uintptr_t) va_arg(aq, void *);
  800d42:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d46:	48 89 d0             	mov    %rdx,%rax
  800d49:	48 83 c2 08          	add    $0x8,%rdx
  800d4d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d51:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d54:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800d58:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800d5f:	eb 23                	jmp    800d84 <vprintfmt+0x49c>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800d61:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d65:	be 03 00 00 00       	mov    $0x3,%esi
  800d6a:	48 89 c7             	mov    %rax,%rdi
  800d6d:	48 b8 c8 06 80 00 00 	movabs $0x8006c8,%rax
  800d74:	00 00 00 
  800d77:	ff d0                	callq  *%rax
  800d79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800d7d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d84:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800d89:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800d8c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800d8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800d93:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9b:	45 89 c1             	mov    %r8d,%r9d
  800d9e:	41 89 f8             	mov    %edi,%r8d
  800da1:	48 89 c7             	mov    %rax,%rdi
  800da4:	48 b8 0d 06 80 00 00 	movabs $0x80060d,%rax
  800dab:	00 00 00 
  800dae:	ff d0                	callq  *%rax
			break;
  800db0:	eb 3f                	jmp    800df1 <vprintfmt+0x509>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800db2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800db6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dba:	48 89 d6             	mov    %rdx,%rsi
  800dbd:	89 df                	mov    %ebx,%edi
  800dbf:	ff d0                	callq  *%rax
			break;
  800dc1:	eb 2e                	jmp    800df1 <vprintfmt+0x509>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dc3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800dc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dcb:	48 89 d6             	mov    %rdx,%rsi
  800dce:	bf 25 00 00 00       	mov    $0x25,%edi
  800dd3:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dd5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800dda:	eb 05                	jmp    800de1 <vprintfmt+0x4f9>
  800ddc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800de1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800de5:	48 83 e8 01          	sub    $0x1,%rax
  800de9:	0f b6 00             	movzbl (%rax),%eax
  800dec:	3c 25                	cmp    $0x25,%al
  800dee:	75 ec                	jne    800ddc <vprintfmt+0x4f4>
				/* do nothing */;
			break;
  800df0:	90                   	nop
		}
	}
  800df1:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800df2:	e9 43 fb ff ff       	jmpq   80093a <vprintfmt+0x52>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800df7:	48 83 c4 60          	add    $0x60,%rsp
  800dfb:	5b                   	pop    %rbx
  800dfc:	41 5c                	pop    %r12
  800dfe:	5d                   	pop    %rbp
  800dff:	c3                   	retq   

0000000000800e00 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e00:	55                   	push   %rbp
  800e01:	48 89 e5             	mov    %rsp,%rbp
  800e04:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800e0b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800e12:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800e19:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e20:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e27:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e2e:	84 c0                	test   %al,%al
  800e30:	74 20                	je     800e52 <printfmt+0x52>
  800e32:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e36:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e3a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e3e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e42:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e46:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e4a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e4e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800e52:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800e59:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800e60:	00 00 00 
  800e63:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800e6a:	00 00 00 
  800e6d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e71:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800e78:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e7f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800e86:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800e8d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800e94:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800e9b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800ea2:	48 89 c7             	mov    %rax,%rdi
  800ea5:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800eac:	00 00 00 
  800eaf:	ff d0                	callq  *%rax
	va_end(ap);
}
  800eb1:	c9                   	leaveq 
  800eb2:	c3                   	retq   

0000000000800eb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eb3:	55                   	push   %rbp
  800eb4:	48 89 e5             	mov    %rsp,%rbp
  800eb7:	48 83 ec 10          	sub    $0x10,%rsp
  800ebb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ebe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800ec2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ec6:	8b 40 10             	mov    0x10(%rax),%eax
  800ec9:	8d 50 01             	lea    0x1(%rax),%edx
  800ecc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ed3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ed7:	48 8b 10             	mov    (%rax),%rdx
  800eda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ede:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ee2:	48 39 c2             	cmp    %rax,%rdx
  800ee5:	73 17                	jae    800efe <sprintputch+0x4b>
		*b->buf++ = ch;
  800ee7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800eeb:	48 8b 00             	mov    (%rax),%rax
  800eee:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800ef2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ef6:	48 89 0a             	mov    %rcx,(%rdx)
  800ef9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800efc:	88 10                	mov    %dl,(%rax)
}
  800efe:	c9                   	leaveq 
  800eff:	c3                   	retq   

0000000000800f00 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f00:	55                   	push   %rbp
  800f01:	48 89 e5             	mov    %rsp,%rbp
  800f04:	48 83 ec 50          	sub    $0x50,%rsp
  800f08:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800f0c:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800f0f:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800f13:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800f17:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800f1b:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800f1f:	48 8b 0a             	mov    (%rdx),%rcx
  800f22:	48 89 08             	mov    %rcx,(%rax)
  800f25:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800f29:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800f2d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800f31:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f35:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f39:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800f3d:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800f40:	48 98                	cltq   
  800f42:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800f46:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800f4a:	48 01 d0             	add    %rdx,%rax
  800f4d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800f51:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800f58:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800f5d:	74 06                	je     800f65 <vsnprintf+0x65>
  800f5f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800f63:	7f 07                	jg     800f6c <vsnprintf+0x6c>
		return -E_INVAL;
  800f65:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f6a:	eb 2f                	jmp    800f9b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800f6c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800f70:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800f74:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800f78:	48 89 c6             	mov    %rax,%rsi
  800f7b:	48 bf b3 0e 80 00 00 	movabs $0x800eb3,%rdi
  800f82:	00 00 00 
  800f85:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  800f8c:	00 00 00 
  800f8f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800f91:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800f95:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800f98:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800f9b:	c9                   	leaveq 
  800f9c:	c3                   	retq   

0000000000800f9d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f9d:	55                   	push   %rbp
  800f9e:	48 89 e5             	mov    %rsp,%rbp
  800fa1:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800fa8:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800faf:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800fb5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fbc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fc3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fca:	84 c0                	test   %al,%al
  800fcc:	74 20                	je     800fee <snprintf+0x51>
  800fce:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fd2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fd6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fda:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fde:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800fe2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fe6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fea:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fee:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800ff5:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800ffc:	00 00 00 
  800fff:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801006:	00 00 00 
  801009:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80100d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801014:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80101b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801022:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801029:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801030:	48 8b 0a             	mov    (%rdx),%rcx
  801033:	48 89 08             	mov    %rcx,(%rax)
  801036:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80103a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80103e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801042:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801046:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80104d:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801054:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80105a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801061:	48 89 c7             	mov    %rax,%rdi
  801064:	48 b8 00 0f 80 00 00 	movabs $0x800f00,%rax
  80106b:	00 00 00 
  80106e:	ff d0                	callq  *%rax
  801070:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801076:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80107c:	c9                   	leaveq 
  80107d:	c3                   	retq   

000000000080107e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80107e:	55                   	push   %rbp
  80107f:	48 89 e5             	mov    %rsp,%rbp
  801082:	48 83 ec 18          	sub    $0x18,%rsp
  801086:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80108a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801091:	eb 09                	jmp    80109c <strlen+0x1e>
		n++;
  801093:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801097:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80109c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a0:	0f b6 00             	movzbl (%rax),%eax
  8010a3:	84 c0                	test   %al,%al
  8010a5:	75 ec                	jne    801093 <strlen+0x15>
		n++;
	return n;
  8010a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010aa:	c9                   	leaveq 
  8010ab:	c3                   	retq   

00000000008010ac <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010ac:	55                   	push   %rbp
  8010ad:	48 89 e5             	mov    %rsp,%rbp
  8010b0:	48 83 ec 20          	sub    $0x20,%rsp
  8010b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010c3:	eb 0e                	jmp    8010d3 <strnlen+0x27>
		n++;
  8010c5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8010ce:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8010d3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8010d8:	74 0b                	je     8010e5 <strnlen+0x39>
  8010da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010de:	0f b6 00             	movzbl (%rax),%eax
  8010e1:	84 c0                	test   %al,%al
  8010e3:	75 e0                	jne    8010c5 <strnlen+0x19>
		n++;
	return n;
  8010e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8010e8:	c9                   	leaveq 
  8010e9:	c3                   	retq   

00000000008010ea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010ea:	55                   	push   %rbp
  8010eb:	48 89 e5             	mov    %rsp,%rbp
  8010ee:	48 83 ec 20          	sub    $0x20,%rsp
  8010f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8010fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801102:	90                   	nop
  801103:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801107:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80110b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80110f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801113:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801117:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80111b:	0f b6 12             	movzbl (%rdx),%edx
  80111e:	88 10                	mov    %dl,(%rax)
  801120:	0f b6 00             	movzbl (%rax),%eax
  801123:	84 c0                	test   %al,%al
  801125:	75 dc                	jne    801103 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801127:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80112b:	c9                   	leaveq 
  80112c:	c3                   	retq   

000000000080112d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80112d:	55                   	push   %rbp
  80112e:	48 89 e5             	mov    %rsp,%rbp
  801131:	48 83 ec 20          	sub    $0x20,%rsp
  801135:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801139:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80113d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801141:	48 89 c7             	mov    %rax,%rdi
  801144:	48 b8 7e 10 80 00 00 	movabs $0x80107e,%rax
  80114b:	00 00 00 
  80114e:	ff d0                	callq  *%rax
  801150:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801153:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801156:	48 63 d0             	movslq %eax,%rdx
  801159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115d:	48 01 c2             	add    %rax,%rdx
  801160:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801164:	48 89 c6             	mov    %rax,%rsi
  801167:	48 89 d7             	mov    %rdx,%rdi
  80116a:	48 b8 ea 10 80 00 00 	movabs $0x8010ea,%rax
  801171:	00 00 00 
  801174:	ff d0                	callq  *%rax
	return dst;
  801176:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80117a:	c9                   	leaveq 
  80117b:	c3                   	retq   

000000000080117c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80117c:	55                   	push   %rbp
  80117d:	48 89 e5             	mov    %rsp,%rbp
  801180:	48 83 ec 28          	sub    $0x28,%rsp
  801184:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801188:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80118c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801190:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801194:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801198:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80119f:	00 
  8011a0:	eb 2a                	jmp    8011cc <strncpy+0x50>
		*dst++ = *src;
  8011a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011a6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8011aa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8011ae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8011b2:	0f b6 12             	movzbl (%rdx),%edx
  8011b5:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011bb:	0f b6 00             	movzbl (%rax),%eax
  8011be:	84 c0                	test   %al,%al
  8011c0:	74 05                	je     8011c7 <strncpy+0x4b>
			src++;
  8011c2:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011c7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d0:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8011d4:	72 cc                	jb     8011a2 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8011da:	c9                   	leaveq 
  8011db:	c3                   	retq   

00000000008011dc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8011dc:	55                   	push   %rbp
  8011dd:	48 89 e5             	mov    %rsp,%rbp
  8011e0:	48 83 ec 28          	sub    $0x28,%rsp
  8011e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8011ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8011f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8011f8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8011fd:	74 3d                	je     80123c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8011ff:	eb 1d                	jmp    80121e <strlcpy+0x42>
			*dst++ = *src++;
  801201:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801205:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801209:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80120d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801211:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801215:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801219:	0f b6 12             	movzbl (%rdx),%edx
  80121c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80121e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801223:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801228:	74 0b                	je     801235 <strlcpy+0x59>
  80122a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80122e:	0f b6 00             	movzbl (%rax),%eax
  801231:	84 c0                	test   %al,%al
  801233:	75 cc                	jne    801201 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801235:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801239:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80123c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801240:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801244:	48 29 c2             	sub    %rax,%rdx
  801247:	48 89 d0             	mov    %rdx,%rax
}
  80124a:	c9                   	leaveq 
  80124b:	c3                   	retq   

000000000080124c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80124c:	55                   	push   %rbp
  80124d:	48 89 e5             	mov    %rsp,%rbp
  801250:	48 83 ec 10          	sub    $0x10,%rsp
  801254:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801258:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80125c:	eb 0a                	jmp    801268 <strcmp+0x1c>
		p++, q++;
  80125e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801263:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126c:	0f b6 00             	movzbl (%rax),%eax
  80126f:	84 c0                	test   %al,%al
  801271:	74 12                	je     801285 <strcmp+0x39>
  801273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801277:	0f b6 10             	movzbl (%rax),%edx
  80127a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127e:	0f b6 00             	movzbl (%rax),%eax
  801281:	38 c2                	cmp    %al,%dl
  801283:	74 d9                	je     80125e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801285:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801289:	0f b6 00             	movzbl (%rax),%eax
  80128c:	0f b6 d0             	movzbl %al,%edx
  80128f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801293:	0f b6 00             	movzbl (%rax),%eax
  801296:	0f b6 c0             	movzbl %al,%eax
  801299:	29 c2                	sub    %eax,%edx
  80129b:	89 d0                	mov    %edx,%eax
}
  80129d:	c9                   	leaveq 
  80129e:	c3                   	retq   

000000000080129f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80129f:	55                   	push   %rbp
  8012a0:	48 89 e5             	mov    %rsp,%rbp
  8012a3:	48 83 ec 18          	sub    $0x18,%rsp
  8012a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8012ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8012af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8012b3:	eb 0f                	jmp    8012c4 <strncmp+0x25>
		n--, p++, q++;
  8012b5:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8012ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012bf:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8012c4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012c9:	74 1d                	je     8012e8 <strncmp+0x49>
  8012cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cf:	0f b6 00             	movzbl (%rax),%eax
  8012d2:	84 c0                	test   %al,%al
  8012d4:	74 12                	je     8012e8 <strncmp+0x49>
  8012d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012da:	0f b6 10             	movzbl (%rax),%edx
  8012dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e1:	0f b6 00             	movzbl (%rax),%eax
  8012e4:	38 c2                	cmp    %al,%dl
  8012e6:	74 cd                	je     8012b5 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8012e8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012ed:	75 07                	jne    8012f6 <strncmp+0x57>
		return 0;
  8012ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f4:	eb 18                	jmp    80130e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012fa:	0f b6 00             	movzbl (%rax),%eax
  8012fd:	0f b6 d0             	movzbl %al,%edx
  801300:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801304:	0f b6 00             	movzbl (%rax),%eax
  801307:	0f b6 c0             	movzbl %al,%eax
  80130a:	29 c2                	sub    %eax,%edx
  80130c:	89 d0                	mov    %edx,%eax
}
  80130e:	c9                   	leaveq 
  80130f:	c3                   	retq   

0000000000801310 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801310:	55                   	push   %rbp
  801311:	48 89 e5             	mov    %rsp,%rbp
  801314:	48 83 ec 0c          	sub    $0xc,%rsp
  801318:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80131c:	89 f0                	mov    %esi,%eax
  80131e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801321:	eb 17                	jmp    80133a <strchr+0x2a>
		if (*s == c)
  801323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801327:	0f b6 00             	movzbl (%rax),%eax
  80132a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80132d:	75 06                	jne    801335 <strchr+0x25>
			return (char *) s;
  80132f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801333:	eb 15                	jmp    80134a <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801335:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80133a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80133e:	0f b6 00             	movzbl (%rax),%eax
  801341:	84 c0                	test   %al,%al
  801343:	75 de                	jne    801323 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801345:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134a:	c9                   	leaveq 
  80134b:	c3                   	retq   

000000000080134c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80134c:	55                   	push   %rbp
  80134d:	48 89 e5             	mov    %rsp,%rbp
  801350:	48 83 ec 0c          	sub    $0xc,%rsp
  801354:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801358:	89 f0                	mov    %esi,%eax
  80135a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80135d:	eb 13                	jmp    801372 <strfind+0x26>
		if (*s == c)
  80135f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801363:	0f b6 00             	movzbl (%rax),%eax
  801366:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801369:	75 02                	jne    80136d <strfind+0x21>
			break;
  80136b:	eb 10                	jmp    80137d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80136d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801376:	0f b6 00             	movzbl (%rax),%eax
  801379:	84 c0                	test   %al,%al
  80137b:	75 e2                	jne    80135f <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80137d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801381:	c9                   	leaveq 
  801382:	c3                   	retq   

0000000000801383 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801383:	55                   	push   %rbp
  801384:	48 89 e5             	mov    %rsp,%rbp
  801387:	48 83 ec 18          	sub    $0x18,%rsp
  80138b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80138f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801392:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801396:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80139b:	75 06                	jne    8013a3 <memset+0x20>
		return v;
  80139d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a1:	eb 69                	jmp    80140c <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8013a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013a7:	83 e0 03             	and    $0x3,%eax
  8013aa:	48 85 c0             	test   %rax,%rax
  8013ad:	75 48                	jne    8013f7 <memset+0x74>
  8013af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b3:	83 e0 03             	and    $0x3,%eax
  8013b6:	48 85 c0             	test   %rax,%rax
  8013b9:	75 3c                	jne    8013f7 <memset+0x74>
		c &= 0xFF;
  8013bb:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013c5:	c1 e0 18             	shl    $0x18,%eax
  8013c8:	89 c2                	mov    %eax,%edx
  8013ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013cd:	c1 e0 10             	shl    $0x10,%eax
  8013d0:	09 c2                	or     %eax,%edx
  8013d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013d5:	c1 e0 08             	shl    $0x8,%eax
  8013d8:	09 d0                	or     %edx,%eax
  8013da:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8013dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e1:	48 c1 e8 02          	shr    $0x2,%rax
  8013e5:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8013e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013ef:	48 89 d7             	mov    %rdx,%rdi
  8013f2:	fc                   	cld    
  8013f3:	f3 ab                	rep stos %eax,%es:(%rdi)
  8013f5:	eb 11                	jmp    801408 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8013fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013fe:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801402:	48 89 d7             	mov    %rdx,%rdi
  801405:	fc                   	cld    
  801406:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801408:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80140c:	c9                   	leaveq 
  80140d:	c3                   	retq   

000000000080140e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80140e:	55                   	push   %rbp
  80140f:	48 89 e5             	mov    %rsp,%rbp
  801412:	48 83 ec 28          	sub    $0x28,%rsp
  801416:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80141a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80141e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801422:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801426:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80142a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801432:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801436:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80143a:	0f 83 88 00 00 00    	jae    8014c8 <memmove+0xba>
  801440:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801444:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801448:	48 01 d0             	add    %rdx,%rax
  80144b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80144f:	76 77                	jbe    8014c8 <memmove+0xba>
		s += n;
  801451:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801455:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801459:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80145d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801461:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801465:	83 e0 03             	and    $0x3,%eax
  801468:	48 85 c0             	test   %rax,%rax
  80146b:	75 3b                	jne    8014a8 <memmove+0x9a>
  80146d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801471:	83 e0 03             	and    $0x3,%eax
  801474:	48 85 c0             	test   %rax,%rax
  801477:	75 2f                	jne    8014a8 <memmove+0x9a>
  801479:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147d:	83 e0 03             	and    $0x3,%eax
  801480:	48 85 c0             	test   %rax,%rax
  801483:	75 23                	jne    8014a8 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801489:	48 83 e8 04          	sub    $0x4,%rax
  80148d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801491:	48 83 ea 04          	sub    $0x4,%rdx
  801495:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801499:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80149d:	48 89 c7             	mov    %rax,%rdi
  8014a0:	48 89 d6             	mov    %rdx,%rsi
  8014a3:	fd                   	std    
  8014a4:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8014a6:	eb 1d                	jmp    8014c5 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8014a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014ac:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8014b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014b4:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8014b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bc:	48 89 d7             	mov    %rdx,%rdi
  8014bf:	48 89 c1             	mov    %rax,%rcx
  8014c2:	fd                   	std    
  8014c3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8014c5:	fc                   	cld    
  8014c6:	eb 57                	jmp    80151f <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8014c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cc:	83 e0 03             	and    $0x3,%eax
  8014cf:	48 85 c0             	test   %rax,%rax
  8014d2:	75 36                	jne    80150a <memmove+0xfc>
  8014d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014d8:	83 e0 03             	and    $0x3,%eax
  8014db:	48 85 c0             	test   %rax,%rax
  8014de:	75 2a                	jne    80150a <memmove+0xfc>
  8014e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014e4:	83 e0 03             	and    $0x3,%eax
  8014e7:	48 85 c0             	test   %rax,%rax
  8014ea:	75 1e                	jne    80150a <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8014ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014f0:	48 c1 e8 02          	shr    $0x2,%rax
  8014f4:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8014f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014fb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8014ff:	48 89 c7             	mov    %rax,%rdi
  801502:	48 89 d6             	mov    %rdx,%rsi
  801505:	fc                   	cld    
  801506:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801508:	eb 15                	jmp    80151f <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80150a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801512:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801516:	48 89 c7             	mov    %rax,%rdi
  801519:	48 89 d6             	mov    %rdx,%rsi
  80151c:	fc                   	cld    
  80151d:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80151f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801523:	c9                   	leaveq 
  801524:	c3                   	retq   

0000000000801525 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801525:	55                   	push   %rbp
  801526:	48 89 e5             	mov    %rsp,%rbp
  801529:	48 83 ec 18          	sub    $0x18,%rsp
  80152d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801531:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801535:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801539:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80153d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801545:	48 89 ce             	mov    %rcx,%rsi
  801548:	48 89 c7             	mov    %rax,%rdi
  80154b:	48 b8 0e 14 80 00 00 	movabs $0x80140e,%rax
  801552:	00 00 00 
  801555:	ff d0                	callq  *%rax
}
  801557:	c9                   	leaveq 
  801558:	c3                   	retq   

0000000000801559 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801559:	55                   	push   %rbp
  80155a:	48 89 e5             	mov    %rsp,%rbp
  80155d:	48 83 ec 28          	sub    $0x28,%rsp
  801561:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801565:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801569:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80156d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801571:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801575:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801579:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80157d:	eb 36                	jmp    8015b5 <memcmp+0x5c>
		if (*s1 != *s2)
  80157f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801583:	0f b6 10             	movzbl (%rax),%edx
  801586:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80158a:	0f b6 00             	movzbl (%rax),%eax
  80158d:	38 c2                	cmp    %al,%dl
  80158f:	74 1a                	je     8015ab <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801595:	0f b6 00             	movzbl (%rax),%eax
  801598:	0f b6 d0             	movzbl %al,%edx
  80159b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80159f:	0f b6 00             	movzbl (%rax),%eax
  8015a2:	0f b6 c0             	movzbl %al,%eax
  8015a5:	29 c2                	sub    %eax,%edx
  8015a7:	89 d0                	mov    %edx,%eax
  8015a9:	eb 20                	jmp    8015cb <memcmp+0x72>
		s1++, s2++;
  8015ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015b9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015bd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8015c1:	48 85 c0             	test   %rax,%rax
  8015c4:	75 b9                	jne    80157f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cb:	c9                   	leaveq 
  8015cc:	c3                   	retq   

00000000008015cd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015cd:	55                   	push   %rbp
  8015ce:	48 89 e5             	mov    %rsp,%rbp
  8015d1:	48 83 ec 28          	sub    $0x28,%rsp
  8015d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015d9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8015dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8015e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015e8:	48 01 d0             	add    %rdx,%rax
  8015eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  8015ef:	eb 15                	jmp    801606 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015f5:	0f b6 10             	movzbl (%rax),%edx
  8015f8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8015fb:	38 c2                	cmp    %al,%dl
  8015fd:	75 02                	jne    801601 <memfind+0x34>
			break;
  8015ff:	eb 0f                	jmp    801610 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801601:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80160a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80160e:	72 e1                	jb     8015f1 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801610:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801614:	c9                   	leaveq 
  801615:	c3                   	retq   

0000000000801616 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801616:	55                   	push   %rbp
  801617:	48 89 e5             	mov    %rsp,%rbp
  80161a:	48 83 ec 34          	sub    $0x34,%rsp
  80161e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801622:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801626:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801629:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801630:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801637:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801638:	eb 05                	jmp    80163f <strtol+0x29>
		s++;
  80163a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80163f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801643:	0f b6 00             	movzbl (%rax),%eax
  801646:	3c 20                	cmp    $0x20,%al
  801648:	74 f0                	je     80163a <strtol+0x24>
  80164a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80164e:	0f b6 00             	movzbl (%rax),%eax
  801651:	3c 09                	cmp    $0x9,%al
  801653:	74 e5                	je     80163a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801655:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801659:	0f b6 00             	movzbl (%rax),%eax
  80165c:	3c 2b                	cmp    $0x2b,%al
  80165e:	75 07                	jne    801667 <strtol+0x51>
		s++;
  801660:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801665:	eb 17                	jmp    80167e <strtol+0x68>
	else if (*s == '-')
  801667:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80166b:	0f b6 00             	movzbl (%rax),%eax
  80166e:	3c 2d                	cmp    $0x2d,%al
  801670:	75 0c                	jne    80167e <strtol+0x68>
		s++, neg = 1;
  801672:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801677:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80167e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801682:	74 06                	je     80168a <strtol+0x74>
  801684:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801688:	75 28                	jne    8016b2 <strtol+0x9c>
  80168a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80168e:	0f b6 00             	movzbl (%rax),%eax
  801691:	3c 30                	cmp    $0x30,%al
  801693:	75 1d                	jne    8016b2 <strtol+0x9c>
  801695:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801699:	48 83 c0 01          	add    $0x1,%rax
  80169d:	0f b6 00             	movzbl (%rax),%eax
  8016a0:	3c 78                	cmp    $0x78,%al
  8016a2:	75 0e                	jne    8016b2 <strtol+0x9c>
		s += 2, base = 16;
  8016a4:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8016a9:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8016b0:	eb 2c                	jmp    8016de <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8016b2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016b6:	75 19                	jne    8016d1 <strtol+0xbb>
  8016b8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016bc:	0f b6 00             	movzbl (%rax),%eax
  8016bf:	3c 30                	cmp    $0x30,%al
  8016c1:	75 0e                	jne    8016d1 <strtol+0xbb>
		s++, base = 8;
  8016c3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8016c8:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8016cf:	eb 0d                	jmp    8016de <strtol+0xc8>
	else if (base == 0)
  8016d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8016d5:	75 07                	jne    8016de <strtol+0xc8>
		base = 10;
  8016d7:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e2:	0f b6 00             	movzbl (%rax),%eax
  8016e5:	3c 2f                	cmp    $0x2f,%al
  8016e7:	7e 1d                	jle    801706 <strtol+0xf0>
  8016e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ed:	0f b6 00             	movzbl (%rax),%eax
  8016f0:	3c 39                	cmp    $0x39,%al
  8016f2:	7f 12                	jg     801706 <strtol+0xf0>
			dig = *s - '0';
  8016f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016f8:	0f b6 00             	movzbl (%rax),%eax
  8016fb:	0f be c0             	movsbl %al,%eax
  8016fe:	83 e8 30             	sub    $0x30,%eax
  801701:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801704:	eb 4e                	jmp    801754 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801706:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170a:	0f b6 00             	movzbl (%rax),%eax
  80170d:	3c 60                	cmp    $0x60,%al
  80170f:	7e 1d                	jle    80172e <strtol+0x118>
  801711:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801715:	0f b6 00             	movzbl (%rax),%eax
  801718:	3c 7a                	cmp    $0x7a,%al
  80171a:	7f 12                	jg     80172e <strtol+0x118>
			dig = *s - 'a' + 10;
  80171c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801720:	0f b6 00             	movzbl (%rax),%eax
  801723:	0f be c0             	movsbl %al,%eax
  801726:	83 e8 57             	sub    $0x57,%eax
  801729:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80172c:	eb 26                	jmp    801754 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80172e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801732:	0f b6 00             	movzbl (%rax),%eax
  801735:	3c 40                	cmp    $0x40,%al
  801737:	7e 48                	jle    801781 <strtol+0x16b>
  801739:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80173d:	0f b6 00             	movzbl (%rax),%eax
  801740:	3c 5a                	cmp    $0x5a,%al
  801742:	7f 3d                	jg     801781 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801748:	0f b6 00             	movzbl (%rax),%eax
  80174b:	0f be c0             	movsbl %al,%eax
  80174e:	83 e8 37             	sub    $0x37,%eax
  801751:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801754:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801757:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80175a:	7c 02                	jl     80175e <strtol+0x148>
			break;
  80175c:	eb 23                	jmp    801781 <strtol+0x16b>
		s++, val = (val * base) + dig;
  80175e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801763:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801766:	48 98                	cltq   
  801768:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  80176d:	48 89 c2             	mov    %rax,%rdx
  801770:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801773:	48 98                	cltq   
  801775:	48 01 d0             	add    %rdx,%rax
  801778:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  80177c:	e9 5d ff ff ff       	jmpq   8016de <strtol+0xc8>

	if (endptr)
  801781:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801786:	74 0b                	je     801793 <strtol+0x17d>
		*endptr = (char *) s;
  801788:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80178c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801790:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801793:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801797:	74 09                	je     8017a2 <strtol+0x18c>
  801799:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179d:	48 f7 d8             	neg    %rax
  8017a0:	eb 04                	jmp    8017a6 <strtol+0x190>
  8017a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8017a6:	c9                   	leaveq 
  8017a7:	c3                   	retq   

00000000008017a8 <strstr>:

char * strstr(const char *in, const char *str)
{
  8017a8:	55                   	push   %rbp
  8017a9:	48 89 e5             	mov    %rsp,%rbp
  8017ac:	48 83 ec 30          	sub    $0x30,%rsp
  8017b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017b4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8017b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017bc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017c0:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8017c4:	0f b6 00             	movzbl (%rax),%eax
  8017c7:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8017ca:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8017ce:	75 06                	jne    8017d6 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8017d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017d4:	eb 6b                	jmp    801841 <strstr+0x99>

	len = strlen(str);
  8017d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8017da:	48 89 c7             	mov    %rax,%rdi
  8017dd:	48 b8 7e 10 80 00 00 	movabs $0x80107e,%rax
  8017e4:	00 00 00 
  8017e7:	ff d0                	callq  *%rax
  8017e9:	48 98                	cltq   
  8017eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8017ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8017f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8017fb:	0f b6 00             	movzbl (%rax),%eax
  8017fe:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801801:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801805:	75 07                	jne    80180e <strstr+0x66>
				return (char *) 0;
  801807:	b8 00 00 00 00       	mov    $0x0,%eax
  80180c:	eb 33                	jmp    801841 <strstr+0x99>
		} while (sc != c);
  80180e:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801812:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801815:	75 d8                	jne    8017ef <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801817:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80181b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80181f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801823:	48 89 ce             	mov    %rcx,%rsi
  801826:	48 89 c7             	mov    %rax,%rdi
  801829:	48 b8 9f 12 80 00 00 	movabs $0x80129f,%rax
  801830:	00 00 00 
  801833:	ff d0                	callq  *%rax
  801835:	85 c0                	test   %eax,%eax
  801837:	75 b6                	jne    8017ef <strstr+0x47>

	return (char *) (in - 1);
  801839:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183d:	48 83 e8 01          	sub    $0x1,%rax
}
  801841:	c9                   	leaveq 
  801842:	c3                   	retq   

0000000000801843 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>
#define FAST_SYSCALL 0
static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801843:	55                   	push   %rbp
  801844:	48 89 e5             	mov    %rsp,%rbp
  801847:	53                   	push   %rbx
  801848:	48 83 ec 48          	sub    $0x48,%rsp
  80184c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80184f:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801852:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801856:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  80185a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80185e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	  //asm volatile("pop %%rdx\n"
		 // 					 "pop %%rcx\n"
		//						 "int $3\n"::);
	//panic("ret = %d\n", ret);
#else
	asm volatile("int %1\n"
  801862:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801865:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801869:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  80186d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801871:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801875:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801879:	4c 89 c3             	mov    %r8,%rbx
  80187c:	cd 30                	int    $0x30
  80187e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "S" (a5)
		     : "cc", "memory");
#endif
	//asm volatile("int $3");
	//asm volatile("int $3");
	if(check && ret > 0)
  801882:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801886:	74 3e                	je     8018c6 <syscall+0x83>
  801888:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80188d:	7e 37                	jle    8018c6 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80188f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801893:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801896:	49 89 d0             	mov    %rdx,%r8
  801899:	89 c1                	mov    %eax,%ecx
  80189b:	48 ba 48 3f 80 00 00 	movabs $0x803f48,%rdx
  8018a2:	00 00 00 
  8018a5:	be 4a 00 00 00       	mov    $0x4a,%esi
  8018aa:	48 bf 65 3f 80 00 00 	movabs $0x803f65,%rdi
  8018b1:	00 00 00 
  8018b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b9:	49 b9 fc 02 80 00 00 	movabs $0x8002fc,%r9
  8018c0:	00 00 00 
  8018c3:	41 ff d1             	callq  *%r9
	//asm volatile("int $3");
	return ret;
  8018c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018ca:	48 83 c4 48          	add    $0x48,%rsp
  8018ce:	5b                   	pop    %rbx
  8018cf:	5d                   	pop    %rbp
  8018d0:	c3                   	retq   

00000000008018d1 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8018d1:	55                   	push   %rbp
  8018d2:	48 89 e5             	mov    %rsp,%rbp
  8018d5:	48 83 ec 20          	sub    $0x20,%rsp
  8018d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8018e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018e5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018e9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8018f0:	00 
  8018f1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8018f7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8018fd:	48 89 d1             	mov    %rdx,%rcx
  801900:	48 89 c2             	mov    %rax,%rdx
  801903:	be 00 00 00 00       	mov    $0x0,%esi
  801908:	bf 00 00 00 00       	mov    $0x0,%edi
  80190d:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801914:	00 00 00 
  801917:	ff d0                	callq  *%rax
}
  801919:	c9                   	leaveq 
  80191a:	c3                   	retq   

000000000080191b <sys_cgetc>:

int
sys_cgetc(void)
{
  80191b:	55                   	push   %rbp
  80191c:	48 89 e5             	mov    %rsp,%rbp
  80191f:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801923:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80192a:	00 
  80192b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801931:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801937:	b9 00 00 00 00       	mov    $0x0,%ecx
  80193c:	ba 00 00 00 00       	mov    $0x0,%edx
  801941:	be 00 00 00 00       	mov    $0x0,%esi
  801946:	bf 01 00 00 00       	mov    $0x1,%edi
  80194b:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801952:	00 00 00 
  801955:	ff d0                	callq  *%rax
}
  801957:	c9                   	leaveq 
  801958:	c3                   	retq   

0000000000801959 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801959:	55                   	push   %rbp
  80195a:	48 89 e5             	mov    %rsp,%rbp
  80195d:	48 83 ec 10          	sub    $0x10,%rsp
  801961:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801964:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801967:	48 98                	cltq   
  801969:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801970:	00 
  801971:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801977:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80197d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801982:	48 89 c2             	mov    %rax,%rdx
  801985:	be 01 00 00 00       	mov    $0x1,%esi
  80198a:	bf 03 00 00 00       	mov    $0x3,%edi
  80198f:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801996:	00 00 00 
  801999:	ff d0                	callq  *%rax
}
  80199b:	c9                   	leaveq 
  80199c:	c3                   	retq   

000000000080199d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80199d:	55                   	push   %rbp
  80199e:	48 89 e5             	mov    %rsp,%rbp
  8019a1:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8019a5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ac:	00 
  8019ad:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019b3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019be:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c3:	be 00 00 00 00       	mov    $0x0,%esi
  8019c8:	bf 02 00 00 00       	mov    $0x2,%edi
  8019cd:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  8019d4:	00 00 00 
  8019d7:	ff d0                	callq  *%rax
}
  8019d9:	c9                   	leaveq 
  8019da:	c3                   	retq   

00000000008019db <sys_yield>:

void
sys_yield(void)
{
  8019db:	55                   	push   %rbp
  8019dc:	48 89 e5             	mov    %rsp,%rbp
  8019df:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8019e3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8019ea:	00 
  8019eb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019f1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801a01:	be 00 00 00 00       	mov    $0x0,%esi
  801a06:	bf 0b 00 00 00       	mov    $0xb,%edi
  801a0b:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801a12:	00 00 00 
  801a15:	ff d0                	callq  *%rax
}
  801a17:	c9                   	leaveq 
  801a18:	c3                   	retq   

0000000000801a19 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801a19:	55                   	push   %rbp
  801a1a:	48 89 e5             	mov    %rsp,%rbp
  801a1d:	48 83 ec 20          	sub    $0x20,%rsp
  801a21:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a28:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801a2b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a2e:	48 63 c8             	movslq %eax,%rcx
  801a31:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a38:	48 98                	cltq   
  801a3a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a41:	00 
  801a42:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a48:	49 89 c8             	mov    %rcx,%r8
  801a4b:	48 89 d1             	mov    %rdx,%rcx
  801a4e:	48 89 c2             	mov    %rax,%rdx
  801a51:	be 01 00 00 00       	mov    $0x1,%esi
  801a56:	bf 04 00 00 00       	mov    $0x4,%edi
  801a5b:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801a62:	00 00 00 
  801a65:	ff d0                	callq  *%rax
}
  801a67:	c9                   	leaveq 
  801a68:	c3                   	retq   

0000000000801a69 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a69:	55                   	push   %rbp
  801a6a:	48 89 e5             	mov    %rsp,%rbp
  801a6d:	48 83 ec 30          	sub    $0x30,%rsp
  801a71:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a74:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a78:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801a7b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801a7f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801a83:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801a86:	48 63 c8             	movslq %eax,%rcx
  801a89:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801a8d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a90:	48 63 f0             	movslq %eax,%rsi
  801a93:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a9a:	48 98                	cltq   
  801a9c:	48 89 0c 24          	mov    %rcx,(%rsp)
  801aa0:	49 89 f9             	mov    %rdi,%r9
  801aa3:	49 89 f0             	mov    %rsi,%r8
  801aa6:	48 89 d1             	mov    %rdx,%rcx
  801aa9:	48 89 c2             	mov    %rax,%rdx
  801aac:	be 01 00 00 00       	mov    $0x1,%esi
  801ab1:	bf 05 00 00 00       	mov    $0x5,%edi
  801ab6:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801abd:	00 00 00 
  801ac0:	ff d0                	callq  *%rax
}
  801ac2:	c9                   	leaveq 
  801ac3:	c3                   	retq   

0000000000801ac4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801ac4:	55                   	push   %rbp
  801ac5:	48 89 e5             	mov    %rsp,%rbp
  801ac8:	48 83 ec 20          	sub    $0x20,%rsp
  801acc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801acf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801ad3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ad7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ada:	48 98                	cltq   
  801adc:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ae3:	00 
  801ae4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aea:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801af0:	48 89 d1             	mov    %rdx,%rcx
  801af3:	48 89 c2             	mov    %rax,%rdx
  801af6:	be 01 00 00 00       	mov    $0x1,%esi
  801afb:	bf 06 00 00 00       	mov    $0x6,%edi
  801b00:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801b07:	00 00 00 
  801b0a:	ff d0                	callq  *%rax
}
  801b0c:	c9                   	leaveq 
  801b0d:	c3                   	retq   

0000000000801b0e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801b0e:	55                   	push   %rbp
  801b0f:	48 89 e5             	mov    %rsp,%rbp
  801b12:	48 83 ec 10          	sub    $0x10,%rsp
  801b16:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b19:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801b1c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b1f:	48 63 d0             	movslq %eax,%rdx
  801b22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b25:	48 98                	cltq   
  801b27:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b2e:	00 
  801b2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3b:	48 89 d1             	mov    %rdx,%rcx
  801b3e:	48 89 c2             	mov    %rax,%rdx
  801b41:	be 01 00 00 00       	mov    $0x1,%esi
  801b46:	bf 08 00 00 00       	mov    $0x8,%edi
  801b4b:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801b52:	00 00 00 
  801b55:	ff d0                	callq  *%rax
}
  801b57:	c9                   	leaveq 
  801b58:	c3                   	retq   

0000000000801b59 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801b59:	55                   	push   %rbp
  801b5a:	48 89 e5             	mov    %rsp,%rbp
  801b5d:	48 83 ec 20          	sub    $0x20,%rsp
  801b61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801b68:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6f:	48 98                	cltq   
  801b71:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b78:	00 
  801b79:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b7f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b85:	48 89 d1             	mov    %rdx,%rcx
  801b88:	48 89 c2             	mov    %rax,%rdx
  801b8b:	be 01 00 00 00       	mov    $0x1,%esi
  801b90:	bf 09 00 00 00       	mov    $0x9,%edi
  801b95:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801b9c:	00 00 00 
  801b9f:	ff d0                	callq  *%rax
}
  801ba1:	c9                   	leaveq 
  801ba2:	c3                   	retq   

0000000000801ba3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ba3:	55                   	push   %rbp
  801ba4:	48 89 e5             	mov    %rsp,%rbp
  801ba7:	48 83 ec 20          	sub    $0x20,%rsp
  801bab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801bb2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bb9:	48 98                	cltq   
  801bbb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801bc2:	00 
  801bc3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bcf:	48 89 d1             	mov    %rdx,%rcx
  801bd2:	48 89 c2             	mov    %rax,%rdx
  801bd5:	be 01 00 00 00       	mov    $0x1,%esi
  801bda:	bf 0a 00 00 00       	mov    $0xa,%edi
  801bdf:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801be6:	00 00 00 
  801be9:	ff d0                	callq  *%rax
}
  801beb:	c9                   	leaveq 
  801bec:	c3                   	retq   

0000000000801bed <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801bed:	55                   	push   %rbp
  801bee:	48 89 e5             	mov    %rsp,%rbp
  801bf1:	48 83 ec 20          	sub    $0x20,%rsp
  801bf5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bfc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c00:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801c03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c06:	48 63 f0             	movslq %eax,%rsi
  801c09:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801c0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c10:	48 98                	cltq   
  801c12:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c16:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1d:	00 
  801c1e:	49 89 f1             	mov    %rsi,%r9
  801c21:	49 89 c8             	mov    %rcx,%r8
  801c24:	48 89 d1             	mov    %rdx,%rcx
  801c27:	48 89 c2             	mov    %rax,%rdx
  801c2a:	be 00 00 00 00       	mov    $0x0,%esi
  801c2f:	bf 0c 00 00 00       	mov    $0xc,%edi
  801c34:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801c3b:	00 00 00 
  801c3e:	ff d0                	callq  *%rax
}
  801c40:	c9                   	leaveq 
  801c41:	c3                   	retq   

0000000000801c42 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801c42:	55                   	push   %rbp
  801c43:	48 89 e5             	mov    %rsp,%rbp
  801c46:	48 83 ec 10          	sub    $0x10,%rsp
  801c4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801c4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c52:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c59:	00 
  801c5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c6b:	48 89 c2             	mov    %rax,%rdx
  801c6e:	be 01 00 00 00       	mov    $0x1,%esi
  801c73:	bf 0d 00 00 00       	mov    $0xd,%edi
  801c78:	48 b8 43 18 80 00 00 	movabs $0x801843,%rax
  801c7f:	00 00 00 
  801c82:	ff d0                	callq  *%rax
}
  801c84:	c9                   	leaveq 
  801c85:	c3                   	retq   

0000000000801c86 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801c86:	55                   	push   %rbp
  801c87:	48 89 e5             	mov    %rsp,%rbp
  801c8a:	48 83 ec 08          	sub    $0x8,%rsp
  801c8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c92:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c96:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801c9d:	ff ff ff 
  801ca0:	48 01 d0             	add    %rdx,%rax
  801ca3:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ca7:	c9                   	leaveq 
  801ca8:	c3                   	retq   

0000000000801ca9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ca9:	55                   	push   %rbp
  801caa:	48 89 e5             	mov    %rsp,%rbp
  801cad:	48 83 ec 08          	sub    $0x8,%rsp
  801cb1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801cb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cb9:	48 89 c7             	mov    %rax,%rdi
  801cbc:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  801cc3:	00 00 00 
  801cc6:	ff d0                	callq  *%rax
  801cc8:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801cce:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801cd2:	c9                   	leaveq 
  801cd3:	c3                   	retq   

0000000000801cd4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801cd4:	55                   	push   %rbp
  801cd5:	48 89 e5             	mov    %rsp,%rbp
  801cd8:	48 83 ec 18          	sub    $0x18,%rsp
  801cdc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ce0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801ce7:	eb 6b                	jmp    801d54 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801ce9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cec:	48 98                	cltq   
  801cee:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801cf4:	48 c1 e0 0c          	shl    $0xc,%rax
  801cf8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d00:	48 c1 e8 15          	shr    $0x15,%rax
  801d04:	48 89 c2             	mov    %rax,%rdx
  801d07:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801d0e:	01 00 00 
  801d11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d15:	83 e0 01             	and    $0x1,%eax
  801d18:	48 85 c0             	test   %rax,%rax
  801d1b:	74 21                	je     801d3e <fd_alloc+0x6a>
  801d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d21:	48 c1 e8 0c          	shr    $0xc,%rax
  801d25:	48 89 c2             	mov    %rax,%rdx
  801d28:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801d2f:	01 00 00 
  801d32:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801d36:	83 e0 01             	and    $0x1,%eax
  801d39:	48 85 c0             	test   %rax,%rax
  801d3c:	75 12                	jne    801d50 <fd_alloc+0x7c>
			*fd_store = fd;
  801d3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d42:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d46:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801d49:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4e:	eb 1a                	jmp    801d6a <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d50:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d54:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801d58:	7e 8f                	jle    801ce9 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d5e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801d65:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801d6a:	c9                   	leaveq 
  801d6b:	c3                   	retq   

0000000000801d6c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d6c:	55                   	push   %rbp
  801d6d:	48 89 e5             	mov    %rsp,%rbp
  801d70:	48 83 ec 20          	sub    $0x20,%rsp
  801d74:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801d77:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d7f:	78 06                	js     801d87 <fd_lookup+0x1b>
  801d81:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801d85:	7e 07                	jle    801d8e <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d8c:	eb 6c                	jmp    801dfa <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801d8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d91:	48 98                	cltq   
  801d93:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801d99:	48 c1 e0 0c          	shl    $0xc,%rax
  801d9d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801da1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da5:	48 c1 e8 15          	shr    $0x15,%rax
  801da9:	48 89 c2             	mov    %rax,%rdx
  801dac:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801db3:	01 00 00 
  801db6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801dba:	83 e0 01             	and    $0x1,%eax
  801dbd:	48 85 c0             	test   %rax,%rax
  801dc0:	74 21                	je     801de3 <fd_lookup+0x77>
  801dc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc6:	48 c1 e8 0c          	shr    $0xc,%rax
  801dca:	48 89 c2             	mov    %rax,%rdx
  801dcd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801dd4:	01 00 00 
  801dd7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ddb:	83 e0 01             	and    $0x1,%eax
  801dde:	48 85 c0             	test   %rax,%rax
  801de1:	75 07                	jne    801dea <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801de3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801de8:	eb 10                	jmp    801dfa <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801dea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801df2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfa:	c9                   	leaveq 
  801dfb:	c3                   	retq   

0000000000801dfc <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801dfc:	55                   	push   %rbp
  801dfd:	48 89 e5             	mov    %rsp,%rbp
  801e00:	48 83 ec 30          	sub    $0x30,%rsp
  801e04:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e08:	89 f0                	mov    %esi,%eax
  801e0a:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e11:	48 89 c7             	mov    %rax,%rdi
  801e14:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  801e1b:	00 00 00 
  801e1e:	ff d0                	callq  *%rax
  801e20:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e24:	48 89 d6             	mov    %rdx,%rsi
  801e27:	89 c7                	mov    %eax,%edi
  801e29:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  801e30:	00 00 00 
  801e33:	ff d0                	callq  *%rax
  801e35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e3c:	78 0a                	js     801e48 <fd_close+0x4c>
	    || fd != fd2)
  801e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e42:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801e46:	74 12                	je     801e5a <fd_close+0x5e>
		return (must_exist ? r : 0);
  801e48:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801e4c:	74 05                	je     801e53 <fd_close+0x57>
  801e4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e51:	eb 05                	jmp    801e58 <fd_close+0x5c>
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	eb 69                	jmp    801ec3 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e5a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e5e:	8b 00                	mov    (%rax),%eax
  801e60:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801e64:	48 89 d6             	mov    %rdx,%rsi
  801e67:	89 c7                	mov    %eax,%edi
  801e69:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  801e70:	00 00 00 
  801e73:	ff d0                	callq  *%rax
  801e75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e7c:	78 2a                	js     801ea8 <fd_close+0xac>
		if (dev->dev_close)
  801e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e82:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e86:	48 85 c0             	test   %rax,%rax
  801e89:	74 16                	je     801ea1 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  801e8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e8f:	48 8b 40 20          	mov    0x20(%rax),%rax
  801e93:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801e97:	48 89 d7             	mov    %rdx,%rdi
  801e9a:	ff d0                	callq  *%rax
  801e9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e9f:	eb 07                	jmp    801ea8 <fd_close+0xac>
		else
			r = 0;
  801ea1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ea8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eac:	48 89 c6             	mov    %rax,%rsi
  801eaf:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb4:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  801ebb:	00 00 00 
  801ebe:	ff d0                	callq  *%rax
	return r;
  801ec0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ec3:	c9                   	leaveq 
  801ec4:	c3                   	retq   

0000000000801ec5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ec5:	55                   	push   %rbp
  801ec6:	48 89 e5             	mov    %rsp,%rbp
  801ec9:	48 83 ec 20          	sub    $0x20,%rsp
  801ecd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ed0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  801ed4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801edb:	eb 41                	jmp    801f1e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  801edd:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801ee4:	00 00 00 
  801ee7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801eea:	48 63 d2             	movslq %edx,%rdx
  801eed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801ef1:	8b 00                	mov    (%rax),%eax
  801ef3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801ef6:	75 22                	jne    801f1a <dev_lookup+0x55>
			*dev = devtab[i];
  801ef8:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801eff:	00 00 00 
  801f02:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f05:	48 63 d2             	movslq %edx,%rdx
  801f08:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  801f0c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f10:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
  801f18:	eb 60                	jmp    801f7a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801f1a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f1e:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  801f25:	00 00 00 
  801f28:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f2b:	48 63 d2             	movslq %edx,%rdx
  801f2e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f32:	48 85 c0             	test   %rax,%rax
  801f35:	75 a6                	jne    801edd <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801f37:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  801f3e:	00 00 00 
  801f41:	48 8b 00             	mov    (%rax),%rax
  801f44:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801f4a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f4d:	89 c6                	mov    %eax,%esi
  801f4f:	48 bf 78 3f 80 00 00 	movabs $0x803f78,%rdi
  801f56:	00 00 00 
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5e:	48 b9 35 05 80 00 00 	movabs $0x800535,%rcx
  801f65:	00 00 00 
  801f68:	ff d1                	callq  *%rcx
	*dev = 0;
  801f6a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f6e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801f75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801f7a:	c9                   	leaveq 
  801f7b:	c3                   	retq   

0000000000801f7c <close>:

int
close(int fdnum)
{
  801f7c:	55                   	push   %rbp
  801f7d:	48 89 e5             	mov    %rsp,%rbp
  801f80:	48 83 ec 20          	sub    $0x20,%rsp
  801f84:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f87:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801f8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f8e:	48 89 d6             	mov    %rdx,%rsi
  801f91:	89 c7                	mov    %eax,%edi
  801f93:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  801f9a:	00 00 00 
  801f9d:	ff d0                	callq  *%rax
  801f9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fa6:	79 05                	jns    801fad <close+0x31>
		return r;
  801fa8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fab:	eb 18                	jmp    801fc5 <close+0x49>
	else
		return fd_close(fd, 1);
  801fad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fb1:	be 01 00 00 00       	mov    $0x1,%esi
  801fb6:	48 89 c7             	mov    %rax,%rdi
  801fb9:	48 b8 fc 1d 80 00 00 	movabs $0x801dfc,%rax
  801fc0:	00 00 00 
  801fc3:	ff d0                	callq  *%rax
}
  801fc5:	c9                   	leaveq 
  801fc6:	c3                   	retq   

0000000000801fc7 <close_all>:

void
close_all(void)
{
  801fc7:	55                   	push   %rbp
  801fc8:	48 89 e5             	mov    %rsp,%rbp
  801fcb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fd6:	eb 15                	jmp    801fed <close_all+0x26>
		close(i);
  801fd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fdb:	89 c7                	mov    %eax,%edi
  801fdd:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  801fe4:	00 00 00 
  801fe7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801fe9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801fed:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801ff1:	7e e5                	jle    801fd8 <close_all+0x11>
		close(i);
}
  801ff3:	c9                   	leaveq 
  801ff4:	c3                   	retq   

0000000000801ff5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ff5:	55                   	push   %rbp
  801ff6:	48 89 e5             	mov    %rsp,%rbp
  801ff9:	48 83 ec 40          	sub    $0x40,%rsp
  801ffd:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802000:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802003:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802007:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80200a:	48 89 d6             	mov    %rdx,%rsi
  80200d:	89 c7                	mov    %eax,%edi
  80200f:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  802016:	00 00 00 
  802019:	ff d0                	callq  *%rax
  80201b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80201e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802022:	79 08                	jns    80202c <dup+0x37>
		return r;
  802024:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802027:	e9 70 01 00 00       	jmpq   80219c <dup+0x1a7>
	close(newfdnum);
  80202c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80202f:	89 c7                	mov    %eax,%edi
  802031:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802038:	00 00 00 
  80203b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80203d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802040:	48 98                	cltq   
  802042:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802048:	48 c1 e0 0c          	shl    $0xc,%rax
  80204c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802050:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802054:	48 89 c7             	mov    %rax,%rdi
  802057:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  80205e:	00 00 00 
  802061:	ff d0                	callq  *%rax
  802063:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80206b:	48 89 c7             	mov    %rax,%rdi
  80206e:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  802075:	00 00 00 
  802078:	ff d0                	callq  *%rax
  80207a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80207e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802082:	48 c1 e8 15          	shr    $0x15,%rax
  802086:	48 89 c2             	mov    %rax,%rdx
  802089:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802090:	01 00 00 
  802093:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802097:	83 e0 01             	and    $0x1,%eax
  80209a:	48 85 c0             	test   %rax,%rax
  80209d:	74 73                	je     802112 <dup+0x11d>
  80209f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020a3:	48 c1 e8 0c          	shr    $0xc,%rax
  8020a7:	48 89 c2             	mov    %rax,%rdx
  8020aa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020b1:	01 00 00 
  8020b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b8:	83 e0 01             	and    $0x1,%eax
  8020bb:	48 85 c0             	test   %rax,%rax
  8020be:	74 52                	je     802112 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8020c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c4:	48 c1 e8 0c          	shr    $0xc,%rax
  8020c8:	48 89 c2             	mov    %rax,%rdx
  8020cb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020d2:	01 00 00 
  8020d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8020de:	89 c1                	mov    %eax,%ecx
  8020e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8020e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e8:	41 89 c8             	mov    %ecx,%r8d
  8020eb:	48 89 d1             	mov    %rdx,%rcx
  8020ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f3:	48 89 c6             	mov    %rax,%rsi
  8020f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8020fb:	48 b8 69 1a 80 00 00 	movabs $0x801a69,%rax
  802102:	00 00 00 
  802105:	ff d0                	callq  *%rax
  802107:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80210a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80210e:	79 02                	jns    802112 <dup+0x11d>
			goto err;
  802110:	eb 57                	jmp    802169 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802112:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802116:	48 c1 e8 0c          	shr    $0xc,%rax
  80211a:	48 89 c2             	mov    %rax,%rdx
  80211d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802124:	01 00 00 
  802127:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212b:	25 07 0e 00 00       	and    $0xe07,%eax
  802130:	89 c1                	mov    %eax,%ecx
  802132:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802136:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80213a:	41 89 c8             	mov    %ecx,%r8d
  80213d:	48 89 d1             	mov    %rdx,%rcx
  802140:	ba 00 00 00 00       	mov    $0x0,%edx
  802145:	48 89 c6             	mov    %rax,%rsi
  802148:	bf 00 00 00 00       	mov    $0x0,%edi
  80214d:	48 b8 69 1a 80 00 00 	movabs $0x801a69,%rax
  802154:	00 00 00 
  802157:	ff d0                	callq  *%rax
  802159:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80215c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802160:	79 02                	jns    802164 <dup+0x16f>
		goto err;
  802162:	eb 05                	jmp    802169 <dup+0x174>

	return newfdnum;
  802164:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802167:	eb 33                	jmp    80219c <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802169:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80216d:	48 89 c6             	mov    %rax,%rsi
  802170:	bf 00 00 00 00       	mov    $0x0,%edi
  802175:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  80217c:	00 00 00 
  80217f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802181:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802185:	48 89 c6             	mov    %rax,%rsi
  802188:	bf 00 00 00 00       	mov    $0x0,%edi
  80218d:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  802194:	00 00 00 
  802197:	ff d0                	callq  *%rax
	return r;
  802199:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80219c:	c9                   	leaveq 
  80219d:	c3                   	retq   

000000000080219e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80219e:	55                   	push   %rbp
  80219f:	48 89 e5             	mov    %rsp,%rbp
  8021a2:	48 83 ec 40          	sub    $0x40,%rsp
  8021a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8021ad:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021b1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8021b5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8021b8:	48 89 d6             	mov    %rdx,%rsi
  8021bb:	89 c7                	mov    %eax,%edi
  8021bd:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8021c4:	00 00 00 
  8021c7:	ff d0                	callq  *%rax
  8021c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021d0:	78 24                	js     8021f6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d6:	8b 00                	mov    (%rax),%eax
  8021d8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8021dc:	48 89 d6             	mov    %rdx,%rsi
  8021df:	89 c7                	mov    %eax,%edi
  8021e1:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  8021e8:	00 00 00 
  8021eb:	ff d0                	callq  *%rax
  8021ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021f4:	79 05                	jns    8021fb <read+0x5d>
		return r;
  8021f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021f9:	eb 76                	jmp    802271 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8021fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ff:	8b 40 08             	mov    0x8(%rax),%eax
  802202:	83 e0 03             	and    $0x3,%eax
  802205:	83 f8 01             	cmp    $0x1,%eax
  802208:	75 3a                	jne    802244 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80220a:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802211:	00 00 00 
  802214:	48 8b 00             	mov    (%rax),%rax
  802217:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80221d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802220:	89 c6                	mov    %eax,%esi
  802222:	48 bf 97 3f 80 00 00 	movabs $0x803f97,%rdi
  802229:	00 00 00 
  80222c:	b8 00 00 00 00       	mov    $0x0,%eax
  802231:	48 b9 35 05 80 00 00 	movabs $0x800535,%rcx
  802238:	00 00 00 
  80223b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80223d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802242:	eb 2d                	jmp    802271 <read+0xd3>
	}
	if (!dev->dev_read)
  802244:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802248:	48 8b 40 10          	mov    0x10(%rax),%rax
  80224c:	48 85 c0             	test   %rax,%rax
  80224f:	75 07                	jne    802258 <read+0xba>
		return -E_NOT_SUPP;
  802251:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802256:	eb 19                	jmp    802271 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80225c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802260:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802264:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802268:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80226c:	48 89 cf             	mov    %rcx,%rdi
  80226f:	ff d0                	callq  *%rax
}
  802271:	c9                   	leaveq 
  802272:	c3                   	retq   

0000000000802273 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802273:	55                   	push   %rbp
  802274:	48 89 e5             	mov    %rsp,%rbp
  802277:	48 83 ec 30          	sub    $0x30,%rsp
  80227b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80227e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802282:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80228d:	eb 49                	jmp    8022d8 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80228f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802292:	48 98                	cltq   
  802294:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802298:	48 29 c2             	sub    %rax,%rdx
  80229b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80229e:	48 63 c8             	movslq %eax,%rcx
  8022a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a5:	48 01 c1             	add    %rax,%rcx
  8022a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022ab:	48 89 ce             	mov    %rcx,%rsi
  8022ae:	89 c7                	mov    %eax,%edi
  8022b0:	48 b8 9e 21 80 00 00 	movabs $0x80219e,%rax
  8022b7:	00 00 00 
  8022ba:	ff d0                	callq  *%rax
  8022bc:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8022bf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022c3:	79 05                	jns    8022ca <readn+0x57>
			return m;
  8022c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022c8:	eb 1c                	jmp    8022e6 <readn+0x73>
		if (m == 0)
  8022ca:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022ce:	75 02                	jne    8022d2 <readn+0x5f>
			break;
  8022d0:	eb 11                	jmp    8022e3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022d5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8022d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022db:	48 98                	cltq   
  8022dd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8022e1:	72 ac                	jb     80228f <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8022e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022e6:	c9                   	leaveq 
  8022e7:	c3                   	retq   

00000000008022e8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8022e8:	55                   	push   %rbp
  8022e9:	48 89 e5             	mov    %rsp,%rbp
  8022ec:	48 83 ec 40          	sub    $0x40,%rsp
  8022f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022f3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022f7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022fb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022ff:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802302:	48 89 d6             	mov    %rdx,%rsi
  802305:	89 c7                	mov    %eax,%edi
  802307:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  80230e:	00 00 00 
  802311:	ff d0                	callq  *%rax
  802313:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802316:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80231a:	78 24                	js     802340 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80231c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802320:	8b 00                	mov    (%rax),%eax
  802322:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802326:	48 89 d6             	mov    %rdx,%rsi
  802329:	89 c7                	mov    %eax,%edi
  80232b:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  802332:	00 00 00 
  802335:	ff d0                	callq  *%rax
  802337:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80233a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80233e:	79 05                	jns    802345 <write+0x5d>
		return r;
  802340:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802343:	eb 75                	jmp    8023ba <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802345:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802349:	8b 40 08             	mov    0x8(%rax),%eax
  80234c:	83 e0 03             	and    $0x3,%eax
  80234f:	85 c0                	test   %eax,%eax
  802351:	75 3a                	jne    80238d <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802353:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80235a:	00 00 00 
  80235d:	48 8b 00             	mov    (%rax),%rax
  802360:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802366:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802369:	89 c6                	mov    %eax,%esi
  80236b:	48 bf b3 3f 80 00 00 	movabs $0x803fb3,%rdi
  802372:	00 00 00 
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	48 b9 35 05 80 00 00 	movabs $0x800535,%rcx
  802381:	00 00 00 
  802384:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802386:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80238b:	eb 2d                	jmp    8023ba <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80238d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802391:	48 8b 40 18          	mov    0x18(%rax),%rax
  802395:	48 85 c0             	test   %rax,%rax
  802398:	75 07                	jne    8023a1 <write+0xb9>
		return -E_NOT_SUPP;
  80239a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80239f:	eb 19                	jmp    8023ba <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8023a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023a9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023ad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023b1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023b5:	48 89 cf             	mov    %rcx,%rdi
  8023b8:	ff d0                	callq  *%rax
}
  8023ba:	c9                   	leaveq 
  8023bb:	c3                   	retq   

00000000008023bc <seek>:

int
seek(int fdnum, off_t offset)
{
  8023bc:	55                   	push   %rbp
  8023bd:	48 89 e5             	mov    %rsp,%rbp
  8023c0:	48 83 ec 18          	sub    $0x18,%rsp
  8023c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023c7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ca:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023d1:	48 89 d6             	mov    %rdx,%rsi
  8023d4:	89 c7                	mov    %eax,%edi
  8023d6:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8023dd:	00 00 00 
  8023e0:	ff d0                	callq  *%rax
  8023e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023e9:	79 05                	jns    8023f0 <seek+0x34>
		return r;
  8023eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ee:	eb 0f                	jmp    8023ff <seek+0x43>
	fd->fd_offset = offset;
  8023f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8023f7:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8023fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ff:	c9                   	leaveq 
  802400:	c3                   	retq   

0000000000802401 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802401:	55                   	push   %rbp
  802402:	48 89 e5             	mov    %rsp,%rbp
  802405:	48 83 ec 30          	sub    $0x30,%rsp
  802409:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80240c:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80240f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802413:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802416:	48 89 d6             	mov    %rdx,%rsi
  802419:	89 c7                	mov    %eax,%edi
  80241b:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  802422:	00 00 00 
  802425:	ff d0                	callq  *%rax
  802427:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80242a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80242e:	78 24                	js     802454 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802434:	8b 00                	mov    (%rax),%eax
  802436:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80243a:	48 89 d6             	mov    %rdx,%rsi
  80243d:	89 c7                	mov    %eax,%edi
  80243f:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  802446:	00 00 00 
  802449:	ff d0                	callq  *%rax
  80244b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80244e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802452:	79 05                	jns    802459 <ftruncate+0x58>
		return r;
  802454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802457:	eb 72                	jmp    8024cb <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802459:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245d:	8b 40 08             	mov    0x8(%rax),%eax
  802460:	83 e0 03             	and    $0x3,%eax
  802463:	85 c0                	test   %eax,%eax
  802465:	75 3a                	jne    8024a1 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802467:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80246e:	00 00 00 
  802471:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802474:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80247a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80247d:	89 c6                	mov    %eax,%esi
  80247f:	48 bf d0 3f 80 00 00 	movabs $0x803fd0,%rdi
  802486:	00 00 00 
  802489:	b8 00 00 00 00       	mov    $0x0,%eax
  80248e:	48 b9 35 05 80 00 00 	movabs $0x800535,%rcx
  802495:	00 00 00 
  802498:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80249a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80249f:	eb 2a                	jmp    8024cb <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8024a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a5:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024a9:	48 85 c0             	test   %rax,%rax
  8024ac:	75 07                	jne    8024b5 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8024ae:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024b3:	eb 16                	jmp    8024cb <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8024b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b9:	48 8b 40 30          	mov    0x30(%rax),%rax
  8024bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024c1:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8024c4:	89 ce                	mov    %ecx,%esi
  8024c6:	48 89 d7             	mov    %rdx,%rdi
  8024c9:	ff d0                	callq  *%rax
}
  8024cb:	c9                   	leaveq 
  8024cc:	c3                   	retq   

00000000008024cd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8024cd:	55                   	push   %rbp
  8024ce:	48 89 e5             	mov    %rsp,%rbp
  8024d1:	48 83 ec 30          	sub    $0x30,%rsp
  8024d5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8024d8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8024dc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8024e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8024e3:	48 89 d6             	mov    %rdx,%rsi
  8024e6:	89 c7                	mov    %eax,%edi
  8024e8:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8024ef:	00 00 00 
  8024f2:	ff d0                	callq  *%rax
  8024f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fb:	78 24                	js     802521 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8024fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802501:	8b 00                	mov    (%rax),%eax
  802503:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802507:	48 89 d6             	mov    %rdx,%rsi
  80250a:	89 c7                	mov    %eax,%edi
  80250c:	48 b8 c5 1e 80 00 00 	movabs $0x801ec5,%rax
  802513:	00 00 00 
  802516:	ff d0                	callq  *%rax
  802518:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80251b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80251f:	79 05                	jns    802526 <fstat+0x59>
		return r;
  802521:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802524:	eb 5e                	jmp    802584 <fstat+0xb7>
	if (!dev->dev_stat)
  802526:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80252a:	48 8b 40 28          	mov    0x28(%rax),%rax
  80252e:	48 85 c0             	test   %rax,%rax
  802531:	75 07                	jne    80253a <fstat+0x6d>
		return -E_NOT_SUPP;
  802533:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802538:	eb 4a                	jmp    802584 <fstat+0xb7>
	stat->st_name[0] = 0;
  80253a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80253e:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802541:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802545:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80254c:	00 00 00 
	stat->st_isdir = 0;
  80254f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802553:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80255a:	00 00 00 
	stat->st_dev = dev;
  80255d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802561:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802565:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80256c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802570:	48 8b 40 28          	mov    0x28(%rax),%rax
  802574:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802578:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80257c:	48 89 ce             	mov    %rcx,%rsi
  80257f:	48 89 d7             	mov    %rdx,%rdi
  802582:	ff d0                	callq  *%rax
}
  802584:	c9                   	leaveq 
  802585:	c3                   	retq   

0000000000802586 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802586:	55                   	push   %rbp
  802587:	48 89 e5             	mov    %rsp,%rbp
  80258a:	48 83 ec 20          	sub    $0x20,%rsp
  80258e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802592:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802596:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259a:	be 00 00 00 00       	mov    $0x0,%esi
  80259f:	48 89 c7             	mov    %rax,%rdi
  8025a2:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  8025a9:	00 00 00 
  8025ac:	ff d0                	callq  *%rax
  8025ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025b5:	79 05                	jns    8025bc <stat+0x36>
		return fd;
  8025b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025ba:	eb 2f                	jmp    8025eb <stat+0x65>
	r = fstat(fd, stat);
  8025bc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025c3:	48 89 d6             	mov    %rdx,%rsi
  8025c6:	89 c7                	mov    %eax,%edi
  8025c8:	48 b8 cd 24 80 00 00 	movabs $0x8024cd,%rax
  8025cf:	00 00 00 
  8025d2:	ff d0                	callq  *%rax
  8025d4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8025d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025da:	89 c7                	mov    %eax,%edi
  8025dc:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  8025e3:	00 00 00 
  8025e6:	ff d0                	callq  *%rax
	return r;
  8025e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8025eb:	c9                   	leaveq 
  8025ec:	c3                   	retq   

00000000008025ed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8025ed:	55                   	push   %rbp
  8025ee:	48 89 e5             	mov    %rsp,%rbp
  8025f1:	48 83 ec 10          	sub    $0x10,%rsp
  8025f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8025fc:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802603:	00 00 00 
  802606:	8b 00                	mov    (%rax),%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	75 1d                	jne    802629 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80260c:	bf 01 00 00 00       	mov    $0x1,%edi
  802611:	48 b8 ba 38 80 00 00 	movabs $0x8038ba,%rax
  802618:	00 00 00 
  80261b:	ff d0                	callq  *%rax
  80261d:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  802624:	00 00 00 
  802627:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802629:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  802630:	00 00 00 
  802633:	8b 00                	mov    (%rax),%eax
  802635:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802638:	b9 07 00 00 00       	mov    $0x7,%ecx
  80263d:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802644:	00 00 00 
  802647:	89 c7                	mov    %eax,%edi
  802649:	48 b8 1d 38 80 00 00 	movabs $0x80381d,%rax
  802650:	00 00 00 
  802653:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802655:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802659:	ba 00 00 00 00       	mov    $0x0,%edx
  80265e:	48 89 c6             	mov    %rax,%rsi
  802661:	bf 00 00 00 00       	mov    $0x0,%edi
  802666:	48 b8 57 37 80 00 00 	movabs $0x803757,%rax
  80266d:	00 00 00 
  802670:	ff d0                	callq  *%rax
}
  802672:	c9                   	leaveq 
  802673:	c3                   	retq   

0000000000802674 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802674:	55                   	push   %rbp
  802675:	48 89 e5             	mov    %rsp,%rbp
  802678:	48 83 ec 20          	sub    $0x20,%rsp
  80267c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802680:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	// unused fd address.  Do you need to allocate a page?)
	//
	// Return the file descriptor index.
	// If any step after fd_alloc fails, use fd_close to free the
	// file descriptor.
	if(strlen(path) >= MAXPATHLEN) return -E_BAD_PATH;
  802683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802687:	48 89 c7             	mov    %rax,%rdi
  80268a:	48 b8 7e 10 80 00 00 	movabs $0x80107e,%rax
  802691:	00 00 00 
  802694:	ff d0                	callq  *%rax
  802696:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80269b:	7e 0a                	jle    8026a7 <open+0x33>
  80269d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8026a2:	e9 a5 00 00 00       	jmpq   80274c <open+0xd8>
	struct Fd *fd;
	int r;
	if((r = fd_alloc(&fd)) < 0)
  8026a7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8026ab:	48 89 c7             	mov    %rax,%rdi
  8026ae:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax
  8026ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c1:	79 08                	jns    8026cb <open+0x57>
		return r;
  8026c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c6:	e9 81 00 00 00       	jmpq   80274c <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  8026cb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8026d2:	00 00 00 
  8026d5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8026d8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy(fsipcbuf.open.req_path, path);
  8026de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e2:	48 89 c6             	mov    %rax,%rsi
  8026e5:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8026ec:	00 00 00 
  8026ef:	48 b8 ea 10 80 00 00 	movabs $0x8010ea,%rax
  8026f6:	00 00 00 
  8026f9:	ff d0                	callq  *%rax
	if((r = fsipc(FSREQ_OPEN, fd)) < 0){
  8026fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ff:	48 89 c6             	mov    %rax,%rsi
  802702:	bf 01 00 00 00       	mov    $0x1,%edi
  802707:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  80270e:	00 00 00 
  802711:	ff d0                	callq  *%rax
  802713:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802716:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80271a:	79 1d                	jns    802739 <open+0xc5>
		fd_close(fd, 0);
  80271c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802720:	be 00 00 00 00       	mov    $0x0,%esi
  802725:	48 89 c7             	mov    %rax,%rdi
  802728:	48 b8 fc 1d 80 00 00 	movabs $0x801dfc,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
		return r;
  802734:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802737:	eb 13                	jmp    80274c <open+0xd8>
	}
	return fd2num(fd);
  802739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273d:	48 89 c7             	mov    %rax,%rdi
  802740:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  802747:	00 00 00 
  80274a:	ff d0                	callq  *%rax
	// LAB 5: Your code here
	//panic ("open not implemented");
}
  80274c:	c9                   	leaveq 
  80274d:	c3                   	retq   

000000000080274e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80274e:	55                   	push   %rbp
  80274f:	48 89 e5             	mov    %rsp,%rbp
  802752:	48 83 ec 10          	sub    $0x10,%rsp
  802756:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80275a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80275e:	8b 50 0c             	mov    0xc(%rax),%edx
  802761:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802768:	00 00 00 
  80276b:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80276d:	be 00 00 00 00       	mov    $0x0,%esi
  802772:	bf 06 00 00 00       	mov    $0x6,%edi
  802777:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
}
  802783:	c9                   	leaveq 
  802784:	c3                   	retq   

0000000000802785 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802785:	55                   	push   %rbp
  802786:	48 89 e5             	mov    %rsp,%rbp
  802789:	48 83 ec 30          	sub    $0x30,%rsp
  80278d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802791:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802795:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279d:	8b 50 0c             	mov    0xc(%rax),%edx
  8027a0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8027a7:	00 00 00 
  8027aa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8027ac:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8027b3:	00 00 00 
  8027b6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027ba:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if((r = fsipc(FSREQ_READ,	NULL)) < 0)
  8027be:	be 00 00 00 00       	mov    $0x0,%esi
  8027c3:	bf 03 00 00 00       	mov    $0x3,%edi
  8027c8:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  8027cf:	00 00 00 
  8027d2:	ff d0                	callq  *%rax
  8027d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027db:	79 05                	jns    8027e2 <devfile_read+0x5d>
		return r;
  8027dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e0:	eb 26                	jmp    802808 <devfile_read+0x83>
	memcpy(buf, fsipcbuf.readRet.ret_buf, r);
  8027e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027e5:	48 63 d0             	movslq %eax,%rdx
  8027e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ec:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8027f3:	00 00 00 
  8027f6:	48 89 c7             	mov    %rax,%rdi
  8027f9:	48 b8 25 15 80 00 00 	movabs $0x801525,%rax
  802800:	00 00 00 
  802803:	ff d0                	callq  *%rax
	return r;
  802805:	8b 45 fc             	mov    -0x4(%rbp),%eax
	//panic("devfile_read not implemented");
}
  802808:	c9                   	leaveq 
  802809:	c3                   	retq   

000000000080280a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80280a:	55                   	push   %rbp
  80280b:	48 89 e5             	mov    %rsp,%rbp
  80280e:	48 83 ec 30          	sub    $0x30,%rsp
  802812:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802816:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80281a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// Make an FSREQ_WRITE request to the file system server.  Be
	// careful: fsipcbuf.write.req_buf is only so large, but
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
	size_t max = PGSIZE - (sizeof(int) + sizeof(size_t));
  80281e:	48 c7 45 f8 f4 0f 00 	movq   $0xff4,-0x8(%rbp)
  802825:	00 
	n = n > max ? max : n;
  802826:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80282a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80282e:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802833:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	int r;
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80283b:	8b 50 0c             	mov    0xc(%rax),%edx
  80283e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802845:	00 00 00 
  802848:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80284a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802851:	00 00 00 
  802854:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802858:	48 89 50 08          	mov    %rdx,0x8(%rax)
	//fsipcbuf.write.req_buf = (char*)buf;
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80285c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802860:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802864:	48 89 c6             	mov    %rax,%rsi
  802867:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80286e:	00 00 00 
  802871:	48 b8 25 15 80 00 00 	movabs $0x801525,%rax
  802878:	00 00 00 
  80287b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_WRITE, NULL);
  80287d:	be 00 00 00 00       	mov    $0x0,%esi
  802882:	bf 04 00 00 00       	mov    $0x4,%edi
  802887:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  80288e:	00 00 00 
  802891:	ff d0                	callq  *%rax

	//panic("devfile_write not implemented");
}
  802893:	c9                   	leaveq 
  802894:	c3                   	retq   

0000000000802895 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802895:	55                   	push   %rbp
  802896:	48 89 e5             	mov    %rsp,%rbp
  802899:	48 83 ec 20          	sub    $0x20,%rsp
  80289d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8028a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a9:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ac:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028b3:	00 00 00 
  8028b6:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8028b8:	be 00 00 00 00       	mov    $0x0,%esi
  8028bd:	bf 05 00 00 00       	mov    $0x5,%edi
  8028c2:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  8028c9:	00 00 00 
  8028cc:	ff d0                	callq  *%rax
  8028ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028d5:	79 05                	jns    8028dc <devfile_stat+0x47>
		return r;
  8028d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028da:	eb 56                	jmp    802932 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8028dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028e0:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8028e7:	00 00 00 
  8028ea:	48 89 c7             	mov    %rax,%rdi
  8028ed:	48 b8 ea 10 80 00 00 	movabs $0x8010ea,%rax
  8028f4:	00 00 00 
  8028f7:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8028f9:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802900:	00 00 00 
  802903:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802909:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80290d:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802913:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80291a:	00 00 00 
  80291d:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802923:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802927:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80292d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802932:	c9                   	leaveq 
  802933:	c3                   	retq   

0000000000802934 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802934:	55                   	push   %rbp
  802935:	48 89 e5             	mov    %rsp,%rbp
  802938:	48 83 ec 10          	sub    $0x10,%rsp
  80293c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802940:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802943:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802947:	8b 50 0c             	mov    0xc(%rax),%edx
  80294a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802951:	00 00 00 
  802954:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802956:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80295d:	00 00 00 
  802960:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802963:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802966:	be 00 00 00 00       	mov    $0x0,%esi
  80296b:	bf 02 00 00 00       	mov    $0x2,%edi
  802970:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  802977:	00 00 00 
  80297a:	ff d0                	callq  *%rax
}
  80297c:	c9                   	leaveq 
  80297d:	c3                   	retq   

000000000080297e <remove>:

// Delete a file
int
remove(const char *path)
{
  80297e:	55                   	push   %rbp
  80297f:	48 89 e5             	mov    %rsp,%rbp
  802982:	48 83 ec 10          	sub    $0x10,%rsp
  802986:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80298a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80298e:	48 89 c7             	mov    %rax,%rdi
  802991:	48 b8 7e 10 80 00 00 	movabs $0x80107e,%rax
  802998:	00 00 00 
  80299b:	ff d0                	callq  *%rax
  80299d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8029a2:	7e 07                	jle    8029ab <remove+0x2d>
		return -E_BAD_PATH;
  8029a4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8029a9:	eb 33                	jmp    8029de <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8029ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029af:	48 89 c6             	mov    %rax,%rsi
  8029b2:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8029b9:	00 00 00 
  8029bc:	48 b8 ea 10 80 00 00 	movabs $0x8010ea,%rax
  8029c3:	00 00 00 
  8029c6:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8029c8:	be 00 00 00 00       	mov    $0x0,%esi
  8029cd:	bf 07 00 00 00       	mov    $0x7,%edi
  8029d2:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  8029d9:	00 00 00 
  8029dc:	ff d0                	callq  *%rax
}
  8029de:	c9                   	leaveq 
  8029df:	c3                   	retq   

00000000008029e0 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8029e0:	55                   	push   %rbp
  8029e1:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8029e4:	be 00 00 00 00       	mov    $0x0,%esi
  8029e9:	bf 08 00 00 00       	mov    $0x8,%edi
  8029ee:	48 b8 ed 25 80 00 00 	movabs $0x8025ed,%rax
  8029f5:	00 00 00 
  8029f8:	ff d0                	callq  *%rax
}
  8029fa:	5d                   	pop    %rbp
  8029fb:	c3                   	retq   

00000000008029fc <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8029fc:	55                   	push   %rbp
  8029fd:	48 89 e5             	mov    %rsp,%rbp
  802a00:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802a07:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802a0e:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802a15:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802a1c:	be 00 00 00 00       	mov    $0x0,%esi
  802a21:	48 89 c7             	mov    %rax,%rdi
  802a24:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	callq  *%rax
  802a30:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802a33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a37:	79 28                	jns    802a61 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802a39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a3c:	89 c6                	mov    %eax,%esi
  802a3e:	48 bf f6 3f 80 00 00 	movabs $0x803ff6,%rdi
  802a45:	00 00 00 
  802a48:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4d:	48 ba 35 05 80 00 00 	movabs $0x800535,%rdx
  802a54:	00 00 00 
  802a57:	ff d2                	callq  *%rdx
		return fd_src;
  802a59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a5c:	e9 74 01 00 00       	jmpq   802bd5 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802a61:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802a68:	be 01 01 00 00       	mov    $0x101,%esi
  802a6d:	48 89 c7             	mov    %rax,%rdi
  802a70:	48 b8 74 26 80 00 00 	movabs $0x802674,%rax
  802a77:	00 00 00 
  802a7a:	ff d0                	callq  *%rax
  802a7c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802a7f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802a83:	79 39                	jns    802abe <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802a85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802a88:	89 c6                	mov    %eax,%esi
  802a8a:	48 bf 0c 40 80 00 00 	movabs $0x80400c,%rdi
  802a91:	00 00 00 
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
  802a99:	48 ba 35 05 80 00 00 	movabs $0x800535,%rdx
  802aa0:	00 00 00 
  802aa3:	ff d2                	callq  *%rdx
		close(fd_src);
  802aa5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa8:	89 c7                	mov    %eax,%edi
  802aaa:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802ab1:	00 00 00 
  802ab4:	ff d0                	callq  *%rax
		return fd_dest;
  802ab6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ab9:	e9 17 01 00 00       	jmpq   802bd5 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802abe:	eb 74                	jmp    802b34 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802ac0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ac3:	48 63 d0             	movslq %eax,%rdx
  802ac6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802acd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ad0:	48 89 ce             	mov    %rcx,%rsi
  802ad3:	89 c7                	mov    %eax,%edi
  802ad5:	48 b8 e8 22 80 00 00 	movabs $0x8022e8,%rax
  802adc:	00 00 00 
  802adf:	ff d0                	callq  *%rax
  802ae1:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802ae4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802ae8:	79 4a                	jns    802b34 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802aea:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802aed:	89 c6                	mov    %eax,%esi
  802aef:	48 bf 26 40 80 00 00 	movabs $0x804026,%rdi
  802af6:	00 00 00 
  802af9:	b8 00 00 00 00       	mov    $0x0,%eax
  802afe:	48 ba 35 05 80 00 00 	movabs $0x800535,%rdx
  802b05:	00 00 00 
  802b08:	ff d2                	callq  *%rdx
			close(fd_src);
  802b0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0d:	89 c7                	mov    %eax,%edi
  802b0f:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
			close(fd_dest);
  802b1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b1e:	89 c7                	mov    %eax,%edi
  802b20:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802b27:	00 00 00 
  802b2a:	ff d0                	callq  *%rax
			return write_size;
  802b2c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b2f:	e9 a1 00 00 00       	jmpq   802bd5 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802b34:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3e:	ba 00 02 00 00       	mov    $0x200,%edx
  802b43:	48 89 ce             	mov    %rcx,%rsi
  802b46:	89 c7                	mov    %eax,%edi
  802b48:	48 b8 9e 21 80 00 00 	movabs $0x80219e,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
  802b54:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b57:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b5b:	0f 8f 5f ff ff ff    	jg     802ac0 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802b65:	79 47                	jns    802bae <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  802b67:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802b6a:	89 c6                	mov    %eax,%esi
  802b6c:	48 bf 39 40 80 00 00 	movabs $0x804039,%rdi
  802b73:	00 00 00 
  802b76:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7b:	48 ba 35 05 80 00 00 	movabs $0x800535,%rdx
  802b82:	00 00 00 
  802b85:	ff d2                	callq  *%rdx
		close(fd_src);
  802b87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8a:	89 c7                	mov    %eax,%edi
  802b8c:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802b93:	00 00 00 
  802b96:	ff d0                	callq  *%rax
		close(fd_dest);
  802b98:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b9b:	89 c7                	mov    %eax,%edi
  802b9d:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802ba4:	00 00 00 
  802ba7:	ff d0                	callq  *%rax
		return read_size;
  802ba9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802bac:	eb 27                	jmp    802bd5 <copy+0x1d9>
	}
	close(fd_src);
  802bae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb1:	89 c7                	mov    %eax,%edi
  802bb3:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802bba:	00 00 00 
  802bbd:	ff d0                	callq  *%rax
	close(fd_dest);
  802bbf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bc2:	89 c7                	mov    %eax,%edi
  802bc4:	48 b8 7c 1f 80 00 00 	movabs $0x801f7c,%rax
  802bcb:	00 00 00 
  802bce:	ff d0                	callq  *%rax
	return 0;
  802bd0:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802bd5:	c9                   	leaveq 
  802bd6:	c3                   	retq   

0000000000802bd7 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  802bd7:	55                   	push   %rbp
  802bd8:	48 89 e5             	mov    %rsp,%rbp
  802bdb:	48 83 ec 20          	sub    $0x20,%rsp
  802bdf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  802be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be7:	8b 40 0c             	mov    0xc(%rax),%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	7e 67                	jle    802c55 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802bee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bf2:	8b 40 04             	mov    0x4(%rax),%eax
  802bf5:	48 63 d0             	movslq %eax,%rdx
  802bf8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfc:	48 8d 48 10          	lea    0x10(%rax),%rcx
  802c00:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c04:	8b 00                	mov    (%rax),%eax
  802c06:	48 89 ce             	mov    %rcx,%rsi
  802c09:	89 c7                	mov    %eax,%edi
  802c0b:	48 b8 e8 22 80 00 00 	movabs $0x8022e8,%rax
  802c12:	00 00 00 
  802c15:	ff d0                	callq  *%rax
  802c17:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  802c1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1e:	7e 13                	jle    802c33 <writebuf+0x5c>
			b->result += result;
  802c20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c24:	8b 50 08             	mov    0x8(%rax),%edx
  802c27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2a:	01 c2                	add    %eax,%edx
  802c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c30:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  802c33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c37:	8b 40 04             	mov    0x4(%rax),%eax
  802c3a:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  802c3d:	74 16                	je     802c55 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  802c3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c48:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  802c4c:	89 c2                	mov    %eax,%edx
  802c4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c52:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  802c55:	c9                   	leaveq 
  802c56:	c3                   	retq   

0000000000802c57 <putch>:

static void
putch(int ch, void *thunk)
{
  802c57:	55                   	push   %rbp
  802c58:	48 89 e5             	mov    %rsp,%rbp
  802c5b:	48 83 ec 20          	sub    $0x20,%rsp
  802c5f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c62:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  802c66:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c6a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  802c6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c72:	8b 40 04             	mov    0x4(%rax),%eax
  802c75:	8d 48 01             	lea    0x1(%rax),%ecx
  802c78:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c7c:	89 4a 04             	mov    %ecx,0x4(%rdx)
  802c7f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802c82:	89 d1                	mov    %edx,%ecx
  802c84:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c88:	48 98                	cltq   
  802c8a:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  802c8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c92:	8b 40 04             	mov    0x4(%rax),%eax
  802c95:	3d 00 01 00 00       	cmp    $0x100,%eax
  802c9a:	75 1e                	jne    802cba <putch+0x63>
		writebuf(b);
  802c9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ca0:	48 89 c7             	mov    %rax,%rdi
  802ca3:	48 b8 d7 2b 80 00 00 	movabs $0x802bd7,%rax
  802caa:	00 00 00 
  802cad:	ff d0                	callq  *%rax
		b->idx = 0;
  802caf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  802cba:	c9                   	leaveq 
  802cbb:	c3                   	retq   

0000000000802cbc <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802cbc:	55                   	push   %rbp
  802cbd:	48 89 e5             	mov    %rsp,%rbp
  802cc0:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  802cc7:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  802ccd:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  802cd4:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  802cdb:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  802ce1:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  802ce7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802cee:	00 00 00 
	b.result = 0;
  802cf1:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  802cf8:	00 00 00 
	b.error = 1;
  802cfb:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  802d02:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802d05:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  802d0c:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  802d13:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802d1a:	48 89 c6             	mov    %rax,%rsi
  802d1d:	48 bf 57 2c 80 00 00 	movabs $0x802c57,%rdi
  802d24:	00 00 00 
  802d27:	48 b8 e8 08 80 00 00 	movabs $0x8008e8,%rax
  802d2e:	00 00 00 
  802d31:	ff d0                	callq  *%rax
	if (b.idx > 0)
  802d33:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  802d39:	85 c0                	test   %eax,%eax
  802d3b:	7e 16                	jle    802d53 <vfprintf+0x97>
		writebuf(&b);
  802d3d:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802d44:	48 89 c7             	mov    %rax,%rdi
  802d47:	48 b8 d7 2b 80 00 00 	movabs $0x802bd7,%rax
  802d4e:	00 00 00 
  802d51:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  802d53:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802d59:	85 c0                	test   %eax,%eax
  802d5b:	74 08                	je     802d65 <vfprintf+0xa9>
  802d5d:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  802d63:	eb 06                	jmp    802d6b <vfprintf+0xaf>
  802d65:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  802d6b:	c9                   	leaveq 
  802d6c:	c3                   	retq   

0000000000802d6d <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802d6d:	55                   	push   %rbp
  802d6e:	48 89 e5             	mov    %rsp,%rbp
  802d71:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802d78:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  802d7e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802d85:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802d8c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802d93:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802d9a:	84 c0                	test   %al,%al
  802d9c:	74 20                	je     802dbe <fprintf+0x51>
  802d9e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802da2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802da6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802daa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802dae:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802db2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802db6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802dba:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802dbe:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802dc5:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  802dcc:	00 00 00 
  802dcf:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802dd6:	00 00 00 
  802dd9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802ddd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802de4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802deb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  802df2:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802df9:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  802e00:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  802e06:	48 89 ce             	mov    %rcx,%rsi
  802e09:	89 c7                	mov    %eax,%edi
  802e0b:	48 b8 bc 2c 80 00 00 	movabs $0x802cbc,%rax
  802e12:	00 00 00 
  802e15:	ff d0                	callq  *%rax
  802e17:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802e1d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802e23:	c9                   	leaveq 
  802e24:	c3                   	retq   

0000000000802e25 <printf>:

int
printf(const char *fmt, ...)
{
  802e25:	55                   	push   %rbp
  802e26:	48 89 e5             	mov    %rsp,%rbp
  802e29:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  802e30:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802e37:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802e3e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802e45:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802e4c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802e53:	84 c0                	test   %al,%al
  802e55:	74 20                	je     802e77 <printf+0x52>
  802e57:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802e5b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802e5f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802e63:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802e67:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802e6b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802e6f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802e73:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  802e77:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802e7e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802e85:	00 00 00 
  802e88:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802e8f:	00 00 00 
  802e92:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802e96:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802e9d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802ea4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  802eab:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802eb2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  802eb9:	48 89 c6             	mov    %rax,%rsi
  802ebc:	bf 01 00 00 00       	mov    $0x1,%edi
  802ec1:	48 b8 bc 2c 80 00 00 	movabs $0x802cbc,%rax
  802ec8:	00 00 00 
  802ecb:	ff d0                	callq  *%rax
  802ecd:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  802ed3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802ed9:	c9                   	leaveq 
  802eda:	c3                   	retq   

0000000000802edb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802edb:	55                   	push   %rbp
  802edc:	48 89 e5             	mov    %rsp,%rbp
  802edf:	53                   	push   %rbx
  802ee0:	48 83 ec 38          	sub    $0x38,%rsp
  802ee4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802ee8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  802eec:	48 89 c7             	mov    %rax,%rdi
  802eef:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  802ef6:	00 00 00 
  802ef9:	ff d0                	callq  *%rax
  802efb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802efe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f02:	0f 88 bf 01 00 00    	js     8030c7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f0c:	ba 07 04 00 00       	mov    $0x407,%edx
  802f11:	48 89 c6             	mov    %rax,%rsi
  802f14:	bf 00 00 00 00       	mov    $0x0,%edi
  802f19:	48 b8 19 1a 80 00 00 	movabs $0x801a19,%rax
  802f20:	00 00 00 
  802f23:	ff d0                	callq  *%rax
  802f25:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f28:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f2c:	0f 88 95 01 00 00    	js     8030c7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802f32:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802f36:	48 89 c7             	mov    %rax,%rdi
  802f39:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  802f40:	00 00 00 
  802f43:	ff d0                	callq  *%rax
  802f45:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f48:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f4c:	0f 88 5d 01 00 00    	js     8030af <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f52:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f56:	ba 07 04 00 00       	mov    $0x407,%edx
  802f5b:	48 89 c6             	mov    %rax,%rsi
  802f5e:	bf 00 00 00 00       	mov    $0x0,%edi
  802f63:	48 b8 19 1a 80 00 00 	movabs $0x801a19,%rax
  802f6a:	00 00 00 
  802f6d:	ff d0                	callq  *%rax
  802f6f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802f72:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802f76:	0f 88 33 01 00 00    	js     8030af <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802f7c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f80:	48 89 c7             	mov    %rax,%rdi
  802f83:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  802f8a:	00 00 00 
  802f8d:	ff d0                	callq  *%rax
  802f8f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f97:	ba 07 04 00 00       	mov    $0x407,%edx
  802f9c:	48 89 c6             	mov    %rax,%rsi
  802f9f:	bf 00 00 00 00       	mov    $0x0,%edi
  802fa4:	48 b8 19 1a 80 00 00 	movabs $0x801a19,%rax
  802fab:	00 00 00 
  802fae:	ff d0                	callq  *%rax
  802fb0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802fb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fb7:	79 05                	jns    802fbe <pipe+0xe3>
		goto err2;
  802fb9:	e9 d9 00 00 00       	jmpq   803097 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802fbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fc2:	48 89 c7             	mov    %rax,%rdi
  802fc5:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  802fcc:	00 00 00 
  802fcf:	ff d0                	callq  *%rax
  802fd1:	48 89 c2             	mov    %rax,%rdx
  802fd4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fd8:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802fde:	48 89 d1             	mov    %rdx,%rcx
  802fe1:	ba 00 00 00 00       	mov    $0x0,%edx
  802fe6:	48 89 c6             	mov    %rax,%rsi
  802fe9:	bf 00 00 00 00       	mov    $0x0,%edi
  802fee:	48 b8 69 1a 80 00 00 	movabs $0x801a69,%rax
  802ff5:	00 00 00 
  802ff8:	ff d0                	callq  *%rax
  802ffa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802ffd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803001:	79 1b                	jns    80301e <pipe+0x143>
		goto err3;
  803003:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803004:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803008:	48 89 c6             	mov    %rax,%rsi
  80300b:	bf 00 00 00 00       	mov    $0x0,%edi
  803010:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  803017:	00 00 00 
  80301a:	ff d0                	callq  *%rax
  80301c:	eb 79                	jmp    803097 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80301e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803022:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803029:	00 00 00 
  80302c:	8b 12                	mov    (%rdx),%edx
  80302e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803030:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803034:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80303b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80303f:	48 ba 80 50 80 00 00 	movabs $0x805080,%rdx
  803046:	00 00 00 
  803049:	8b 12                	mov    (%rdx),%edx
  80304b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80304d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803051:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803058:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80305c:	48 89 c7             	mov    %rax,%rdi
  80305f:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  803066:	00 00 00 
  803069:	ff d0                	callq  *%rax
  80306b:	89 c2                	mov    %eax,%edx
  80306d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803071:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803073:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803077:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80307b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80307f:	48 89 c7             	mov    %rax,%rdi
  803082:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  803089:	00 00 00 
  80308c:	ff d0                	callq  *%rax
  80308e:	89 03                	mov    %eax,(%rbx)
	return 0;
  803090:	b8 00 00 00 00       	mov    $0x0,%eax
  803095:	eb 33                	jmp    8030ca <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803097:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80309b:	48 89 c6             	mov    %rax,%rsi
  80309e:	bf 00 00 00 00       	mov    $0x0,%edi
  8030a3:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  8030aa:	00 00 00 
  8030ad:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8030af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b3:	48 89 c6             	mov    %rax,%rsi
  8030b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8030bb:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
err:
	return r;
  8030c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8030ca:	48 83 c4 38          	add    $0x38,%rsp
  8030ce:	5b                   	pop    %rbx
  8030cf:	5d                   	pop    %rbp
  8030d0:	c3                   	retq   

00000000008030d1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8030d1:	55                   	push   %rbp
  8030d2:	48 89 e5             	mov    %rsp,%rbp
  8030d5:	53                   	push   %rbx
  8030d6:	48 83 ec 28          	sub    $0x28,%rsp
  8030da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8030e2:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8030e9:	00 00 00 
  8030ec:	48 8b 00             	mov    (%rax),%rax
  8030ef:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8030f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8030f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030fc:	48 89 c7             	mov    %rax,%rdi
  8030ff:	48 b8 3c 39 80 00 00 	movabs $0x80393c,%rax
  803106:	00 00 00 
  803109:	ff d0                	callq  *%rax
  80310b:	89 c3                	mov    %eax,%ebx
  80310d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803111:	48 89 c7             	mov    %rax,%rdi
  803114:	48 b8 3c 39 80 00 00 	movabs $0x80393c,%rax
  80311b:	00 00 00 
  80311e:	ff d0                	callq  *%rax
  803120:	39 c3                	cmp    %eax,%ebx
  803122:	0f 94 c0             	sete   %al
  803125:	0f b6 c0             	movzbl %al,%eax
  803128:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80312b:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803132:	00 00 00 
  803135:	48 8b 00             	mov    (%rax),%rax
  803138:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80313e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803141:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803144:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803147:	75 05                	jne    80314e <_pipeisclosed+0x7d>
			return ret;
  803149:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80314c:	eb 4f                	jmp    80319d <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80314e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803151:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803154:	74 42                	je     803198 <_pipeisclosed+0xc7>
  803156:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80315a:	75 3c                	jne    803198 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80315c:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803163:	00 00 00 
  803166:	48 8b 00             	mov    (%rax),%rax
  803169:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80316f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803172:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803175:	89 c6                	mov    %eax,%esi
  803177:	48 bf 54 40 80 00 00 	movabs $0x804054,%rdi
  80317e:	00 00 00 
  803181:	b8 00 00 00 00       	mov    $0x0,%eax
  803186:	49 b8 35 05 80 00 00 	movabs $0x800535,%r8
  80318d:	00 00 00 
  803190:	41 ff d0             	callq  *%r8
	}
  803193:	e9 4a ff ff ff       	jmpq   8030e2 <_pipeisclosed+0x11>
  803198:	e9 45 ff ff ff       	jmpq   8030e2 <_pipeisclosed+0x11>
}
  80319d:	48 83 c4 28          	add    $0x28,%rsp
  8031a1:	5b                   	pop    %rbx
  8031a2:	5d                   	pop    %rbp
  8031a3:	c3                   	retq   

00000000008031a4 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8031a4:	55                   	push   %rbp
  8031a5:	48 89 e5             	mov    %rsp,%rbp
  8031a8:	48 83 ec 30          	sub    $0x30,%rsp
  8031ac:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031af:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031b3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031b6:	48 89 d6             	mov    %rdx,%rsi
  8031b9:	89 c7                	mov    %eax,%edi
  8031bb:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  8031c2:	00 00 00 
  8031c5:	ff d0                	callq  *%rax
  8031c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ce:	79 05                	jns    8031d5 <pipeisclosed+0x31>
		return r;
  8031d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031d3:	eb 31                	jmp    803206 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8031d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031d9:	48 89 c7             	mov    %rax,%rdi
  8031dc:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  8031e3:	00 00 00 
  8031e6:	ff d0                	callq  *%rax
  8031e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8031ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8031f4:	48 89 d6             	mov    %rdx,%rsi
  8031f7:	48 89 c7             	mov    %rax,%rdi
  8031fa:	48 b8 d1 30 80 00 00 	movabs $0x8030d1,%rax
  803201:	00 00 00 
  803204:	ff d0                	callq  *%rax
}
  803206:	c9                   	leaveq 
  803207:	c3                   	retq   

0000000000803208 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803208:	55                   	push   %rbp
  803209:	48 89 e5             	mov    %rsp,%rbp
  80320c:	48 83 ec 40          	sub    $0x40,%rsp
  803210:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803214:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803218:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80321c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803220:	48 89 c7             	mov    %rax,%rdi
  803223:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  80322a:	00 00 00 
  80322d:	ff d0                	callq  *%rax
  80322f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803233:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803237:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80323b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803242:	00 
  803243:	e9 92 00 00 00       	jmpq   8032da <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803248:	eb 41                	jmp    80328b <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80324a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80324f:	74 09                	je     80325a <devpipe_read+0x52>
				return i;
  803251:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803255:	e9 92 00 00 00       	jmpq   8032ec <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80325a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80325e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803262:	48 89 d6             	mov    %rdx,%rsi
  803265:	48 89 c7             	mov    %rax,%rdi
  803268:	48 b8 d1 30 80 00 00 	movabs $0x8030d1,%rax
  80326f:	00 00 00 
  803272:	ff d0                	callq  *%rax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 07                	je     80327f <devpipe_read+0x77>
				return 0;
  803278:	b8 00 00 00 00       	mov    $0x0,%eax
  80327d:	eb 6d                	jmp    8032ec <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80327f:	48 b8 db 19 80 00 00 	movabs $0x8019db,%rax
  803286:	00 00 00 
  803289:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80328b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80328f:	8b 10                	mov    (%rax),%edx
  803291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803295:	8b 40 04             	mov    0x4(%rax),%eax
  803298:	39 c2                	cmp    %eax,%edx
  80329a:	74 ae                	je     80324a <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80329c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032a4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8032a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ac:	8b 00                	mov    (%rax),%eax
  8032ae:	99                   	cltd   
  8032af:	c1 ea 1b             	shr    $0x1b,%edx
  8032b2:	01 d0                	add    %edx,%eax
  8032b4:	83 e0 1f             	and    $0x1f,%eax
  8032b7:	29 d0                	sub    %edx,%eax
  8032b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032bd:	48 98                	cltq   
  8032bf:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8032c4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8032c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032ca:	8b 00                	mov    (%rax),%eax
  8032cc:	8d 50 01             	lea    0x1(%rax),%edx
  8032cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8032d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8032da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032de:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8032e2:	0f 82 60 ff ff ff    	jb     803248 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8032e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8032ec:	c9                   	leaveq 
  8032ed:	c3                   	retq   

00000000008032ee <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8032ee:	55                   	push   %rbp
  8032ef:	48 89 e5             	mov    %rsp,%rbp
  8032f2:	48 83 ec 40          	sub    $0x40,%rsp
  8032f6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8032fe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803306:	48 89 c7             	mov    %rax,%rdi
  803309:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  803310:	00 00 00 
  803313:	ff d0                	callq  *%rax
  803315:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803319:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80331d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803321:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803328:	00 
  803329:	e9 8e 00 00 00       	jmpq   8033bc <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80332e:	eb 31                	jmp    803361 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803330:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803334:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803338:	48 89 d6             	mov    %rdx,%rsi
  80333b:	48 89 c7             	mov    %rax,%rdi
  80333e:	48 b8 d1 30 80 00 00 	movabs $0x8030d1,%rax
  803345:	00 00 00 
  803348:	ff d0                	callq  *%rax
  80334a:	85 c0                	test   %eax,%eax
  80334c:	74 07                	je     803355 <devpipe_write+0x67>
				return 0;
  80334e:	b8 00 00 00 00       	mov    $0x0,%eax
  803353:	eb 79                	jmp    8033ce <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803355:	48 b8 db 19 80 00 00 	movabs $0x8019db,%rax
  80335c:	00 00 00 
  80335f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803361:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803365:	8b 40 04             	mov    0x4(%rax),%eax
  803368:	48 63 d0             	movslq %eax,%rdx
  80336b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80336f:	8b 00                	mov    (%rax),%eax
  803371:	48 98                	cltq   
  803373:	48 83 c0 20          	add    $0x20,%rax
  803377:	48 39 c2             	cmp    %rax,%rdx
  80337a:	73 b4                	jae    803330 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80337c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803380:	8b 40 04             	mov    0x4(%rax),%eax
  803383:	99                   	cltd   
  803384:	c1 ea 1b             	shr    $0x1b,%edx
  803387:	01 d0                	add    %edx,%eax
  803389:	83 e0 1f             	and    $0x1f,%eax
  80338c:	29 d0                	sub    %edx,%eax
  80338e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803392:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803396:	48 01 ca             	add    %rcx,%rdx
  803399:	0f b6 0a             	movzbl (%rdx),%ecx
  80339c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8033a0:	48 98                	cltq   
  8033a2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8033a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033aa:	8b 40 04             	mov    0x4(%rax),%eax
  8033ad:	8d 50 01             	lea    0x1(%rax),%edx
  8033b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033b4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8033b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8033bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033c0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8033c4:	0f 82 64 ff ff ff    	jb     80332e <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8033ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8033ce:	c9                   	leaveq 
  8033cf:	c3                   	retq   

00000000008033d0 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8033d0:	55                   	push   %rbp
  8033d1:	48 89 e5             	mov    %rsp,%rbp
  8033d4:	48 83 ec 20          	sub    $0x20,%rsp
  8033d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8033e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033e4:	48 89 c7             	mov    %rax,%rdi
  8033e7:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  8033ee:	00 00 00 
  8033f1:	ff d0                	callq  *%rax
  8033f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8033f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033fb:	48 be 67 40 80 00 00 	movabs $0x804067,%rsi
  803402:	00 00 00 
  803405:	48 89 c7             	mov    %rax,%rdi
  803408:	48 b8 ea 10 80 00 00 	movabs $0x8010ea,%rax
  80340f:	00 00 00 
  803412:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803414:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803418:	8b 50 04             	mov    0x4(%rax),%edx
  80341b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80341f:	8b 00                	mov    (%rax),%eax
  803421:	29 c2                	sub    %eax,%edx
  803423:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803427:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80342d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803431:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803438:	00 00 00 
	stat->st_dev = &devpipe;
  80343b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80343f:	48 b9 80 50 80 00 00 	movabs $0x805080,%rcx
  803446:	00 00 00 
  803449:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803450:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803455:	c9                   	leaveq 
  803456:	c3                   	retq   

0000000000803457 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803457:	55                   	push   %rbp
  803458:	48 89 e5             	mov    %rsp,%rbp
  80345b:	48 83 ec 10          	sub    $0x10,%rsp
  80345f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803463:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803467:	48 89 c6             	mov    %rax,%rsi
  80346a:	bf 00 00 00 00       	mov    $0x0,%edi
  80346f:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  803476:	00 00 00 
  803479:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80347b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80347f:	48 89 c7             	mov    %rax,%rdi
  803482:	48 b8 a9 1c 80 00 00 	movabs $0x801ca9,%rax
  803489:	00 00 00 
  80348c:	ff d0                	callq  *%rax
  80348e:	48 89 c6             	mov    %rax,%rsi
  803491:	bf 00 00 00 00       	mov    $0x0,%edi
  803496:	48 b8 c4 1a 80 00 00 	movabs $0x801ac4,%rax
  80349d:	00 00 00 
  8034a0:	ff d0                	callq  *%rax
}
  8034a2:	c9                   	leaveq 
  8034a3:	c3                   	retq   

00000000008034a4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8034a4:	55                   	push   %rbp
  8034a5:	48 89 e5             	mov    %rsp,%rbp
  8034a8:	48 83 ec 20          	sub    $0x20,%rsp
  8034ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8034af:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034b2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8034b5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8034b9:	be 01 00 00 00       	mov    $0x1,%esi
  8034be:	48 89 c7             	mov    %rax,%rdi
  8034c1:	48 b8 d1 18 80 00 00 	movabs $0x8018d1,%rax
  8034c8:	00 00 00 
  8034cb:	ff d0                	callq  *%rax
}
  8034cd:	c9                   	leaveq 
  8034ce:	c3                   	retq   

00000000008034cf <getchar>:

int
getchar(void)
{
  8034cf:	55                   	push   %rbp
  8034d0:	48 89 e5             	mov    %rsp,%rbp
  8034d3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8034d7:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8034db:	ba 01 00 00 00       	mov    $0x1,%edx
  8034e0:	48 89 c6             	mov    %rax,%rsi
  8034e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8034e8:	48 b8 9e 21 80 00 00 	movabs $0x80219e,%rax
  8034ef:	00 00 00 
  8034f2:	ff d0                	callq  *%rax
  8034f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8034f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034fb:	79 05                	jns    803502 <getchar+0x33>
		return r;
  8034fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803500:	eb 14                	jmp    803516 <getchar+0x47>
	if (r < 1)
  803502:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803506:	7f 07                	jg     80350f <getchar+0x40>
		return -E_EOF;
  803508:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80350d:	eb 07                	jmp    803516 <getchar+0x47>
	return c;
  80350f:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803513:	0f b6 c0             	movzbl %al,%eax
}
  803516:	c9                   	leaveq 
  803517:	c3                   	retq   

0000000000803518 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803518:	55                   	push   %rbp
  803519:	48 89 e5             	mov    %rsp,%rbp
  80351c:	48 83 ec 20          	sub    $0x20,%rsp
  803520:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803523:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803527:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80352a:	48 89 d6             	mov    %rdx,%rsi
  80352d:	89 c7                	mov    %eax,%edi
  80352f:	48 b8 6c 1d 80 00 00 	movabs $0x801d6c,%rax
  803536:	00 00 00 
  803539:	ff d0                	callq  *%rax
  80353b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803542:	79 05                	jns    803549 <iscons+0x31>
		return r;
  803544:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803547:	eb 1a                	jmp    803563 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803549:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80354d:	8b 10                	mov    (%rax),%edx
  80354f:	48 b8 c0 50 80 00 00 	movabs $0x8050c0,%rax
  803556:	00 00 00 
  803559:	8b 00                	mov    (%rax),%eax
  80355b:	39 c2                	cmp    %eax,%edx
  80355d:	0f 94 c0             	sete   %al
  803560:	0f b6 c0             	movzbl %al,%eax
}
  803563:	c9                   	leaveq 
  803564:	c3                   	retq   

0000000000803565 <opencons>:

int
opencons(void)
{
  803565:	55                   	push   %rbp
  803566:	48 89 e5             	mov    %rsp,%rbp
  803569:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80356d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803571:	48 89 c7             	mov    %rax,%rdi
  803574:	48 b8 d4 1c 80 00 00 	movabs $0x801cd4,%rax
  80357b:	00 00 00 
  80357e:	ff d0                	callq  *%rax
  803580:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803583:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803587:	79 05                	jns    80358e <opencons+0x29>
		return r;
  803589:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80358c:	eb 5b                	jmp    8035e9 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80358e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803592:	ba 07 04 00 00       	mov    $0x407,%edx
  803597:	48 89 c6             	mov    %rax,%rsi
  80359a:	bf 00 00 00 00       	mov    $0x0,%edi
  80359f:	48 b8 19 1a 80 00 00 	movabs $0x801a19,%rax
  8035a6:	00 00 00 
  8035a9:	ff d0                	callq  *%rax
  8035ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035b2:	79 05                	jns    8035b9 <opencons+0x54>
		return r;
  8035b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035b7:	eb 30                	jmp    8035e9 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8035b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035bd:	48 ba c0 50 80 00 00 	movabs $0x8050c0,%rdx
  8035c4:	00 00 00 
  8035c7:	8b 12                	mov    (%rdx),%edx
  8035c9:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8035cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035cf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8035d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035da:	48 89 c7             	mov    %rax,%rdi
  8035dd:	48 b8 86 1c 80 00 00 	movabs $0x801c86,%rax
  8035e4:	00 00 00 
  8035e7:	ff d0                	callq  *%rax
}
  8035e9:	c9                   	leaveq 
  8035ea:	c3                   	retq   

00000000008035eb <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8035eb:	55                   	push   %rbp
  8035ec:	48 89 e5             	mov    %rsp,%rbp
  8035ef:	48 83 ec 30          	sub    $0x30,%rsp
  8035f3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035f7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035fb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8035ff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803604:	75 07                	jne    80360d <devcons_read+0x22>
		return 0;
  803606:	b8 00 00 00 00       	mov    $0x0,%eax
  80360b:	eb 4b                	jmp    803658 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  80360d:	eb 0c                	jmp    80361b <devcons_read+0x30>
		sys_yield();
  80360f:	48 b8 db 19 80 00 00 	movabs $0x8019db,%rax
  803616:	00 00 00 
  803619:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80361b:	48 b8 1b 19 80 00 00 	movabs $0x80191b,%rax
  803622:	00 00 00 
  803625:	ff d0                	callq  *%rax
  803627:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80362a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80362e:	74 df                	je     80360f <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803630:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803634:	79 05                	jns    80363b <devcons_read+0x50>
		return c;
  803636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803639:	eb 1d                	jmp    803658 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80363b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80363f:	75 07                	jne    803648 <devcons_read+0x5d>
		return 0;
  803641:	b8 00 00 00 00       	mov    $0x0,%eax
  803646:	eb 10                	jmp    803658 <devcons_read+0x6d>
	*(char*)vbuf = c;
  803648:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364b:	89 c2                	mov    %eax,%edx
  80364d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803651:	88 10                	mov    %dl,(%rax)
	return 1;
  803653:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803658:	c9                   	leaveq 
  803659:	c3                   	retq   

000000000080365a <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80365a:	55                   	push   %rbp
  80365b:	48 89 e5             	mov    %rsp,%rbp
  80365e:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803665:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80366c:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803673:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80367a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803681:	eb 76                	jmp    8036f9 <devcons_write+0x9f>
		m = n - tot;
  803683:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80368a:	89 c2                	mov    %eax,%edx
  80368c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80368f:	29 c2                	sub    %eax,%edx
  803691:	89 d0                	mov    %edx,%eax
  803693:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803696:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803699:	83 f8 7f             	cmp    $0x7f,%eax
  80369c:	76 07                	jbe    8036a5 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80369e:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8036a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036a8:	48 63 d0             	movslq %eax,%rdx
  8036ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ae:	48 63 c8             	movslq %eax,%rcx
  8036b1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8036b8:	48 01 c1             	add    %rax,%rcx
  8036bb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8036c2:	48 89 ce             	mov    %rcx,%rsi
  8036c5:	48 89 c7             	mov    %rax,%rdi
  8036c8:	48 b8 0e 14 80 00 00 	movabs $0x80140e,%rax
  8036cf:	00 00 00 
  8036d2:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8036d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036d7:	48 63 d0             	movslq %eax,%rdx
  8036da:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8036e1:	48 89 d6             	mov    %rdx,%rsi
  8036e4:	48 89 c7             	mov    %rax,%rdi
  8036e7:	48 b8 d1 18 80 00 00 	movabs $0x8018d1,%rax
  8036ee:	00 00 00 
  8036f1:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8036f3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036f6:	01 45 fc             	add    %eax,-0x4(%rbp)
  8036f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036fc:	48 98                	cltq   
  8036fe:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803705:	0f 82 78 ff ff ff    	jb     803683 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80370b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80370e:	c9                   	leaveq 
  80370f:	c3                   	retq   

0000000000803710 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803710:	55                   	push   %rbp
  803711:	48 89 e5             	mov    %rsp,%rbp
  803714:	48 83 ec 08          	sub    $0x8,%rsp
  803718:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80371c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803721:	c9                   	leaveq 
  803722:	c3                   	retq   

0000000000803723 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803723:	55                   	push   %rbp
  803724:	48 89 e5             	mov    %rsp,%rbp
  803727:	48 83 ec 10          	sub    $0x10,%rsp
  80372b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80372f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803737:	48 be 73 40 80 00 00 	movabs $0x804073,%rsi
  80373e:	00 00 00 
  803741:	48 89 c7             	mov    %rax,%rdi
  803744:	48 b8 ea 10 80 00 00 	movabs $0x8010ea,%rax
  80374b:	00 00 00 
  80374e:	ff d0                	callq  *%rax
	return 0;
  803750:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803755:	c9                   	leaveq 
  803756:	c3                   	retq   

0000000000803757 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803757:	55                   	push   %rbp
  803758:	48 89 e5             	mov    %rsp,%rbp
  80375b:	48 83 ec 30          	sub    $0x30,%rsp
  80375f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803763:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803767:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int result;
	if(pg) result = sys_ipc_recv(pg); else result = sys_ipc_recv((void*) UTOP);
  80376b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803770:	74 18                	je     80378a <ipc_recv+0x33>
  803772:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803776:	48 89 c7             	mov    %rax,%rdi
  803779:	48 b8 42 1c 80 00 00 	movabs $0x801c42,%rax
  803780:	00 00 00 
  803783:	ff d0                	callq  *%rax
  803785:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803788:	eb 19                	jmp    8037a3 <ipc_recv+0x4c>
  80378a:	48 bf 00 00 80 00 80 	movabs $0x8000800000,%rdi
  803791:	00 00 00 
  803794:	48 b8 42 1c 80 00 00 	movabs $0x801c42,%rax
  80379b:	00 00 00 
  80379e:	ff d0                	callq  *%rax
  8037a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if(from_env_store) *from_env_store = result ? 0 : thisenv->env_ipc_from;
  8037a3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8037a8:	74 26                	je     8037d0 <ipc_recv+0x79>
  8037aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037ae:	75 15                	jne    8037c5 <ipc_recv+0x6e>
  8037b0:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8037b7:	00 00 00 
  8037ba:	48 8b 00             	mov    (%rax),%rax
  8037bd:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8037c3:	eb 05                	jmp    8037ca <ipc_recv+0x73>
  8037c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037ce:	89 02                	mov    %eax,(%rdx)
	if(perm_store) *perm_store = result ? 0 : thisenv->env_ipc_perm;
  8037d0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8037d5:	74 26                	je     8037fd <ipc_recv+0xa6>
  8037d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037db:	75 15                	jne    8037f2 <ipc_recv+0x9b>
  8037dd:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8037e4:	00 00 00 
  8037e7:	48 8b 00             	mov    (%rax),%rax
  8037ea:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  8037f0:	eb 05                	jmp    8037f7 <ipc_recv+0xa0>
  8037f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8037fb:	89 02                	mov    %eax,(%rdx)
	return result ? result : thisenv->env_ipc_value;
  8037fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803801:	75 15                	jne    803818 <ipc_recv+0xc1>
  803803:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80380a:	00 00 00 
  80380d:	48 8b 00             	mov    (%rax),%rax
  803810:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803816:	eb 03                	jmp    80381b <ipc_recv+0xc4>
  803818:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80381b:	c9                   	leaveq 
  80381c:	c3                   	retq   

000000000080381d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80381d:	55                   	push   %rbp
  80381e:	48 89 e5             	mov    %rsp,%rbp
  803821:	48 83 ec 30          	sub    $0x30,%rsp
  803825:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803828:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80382b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80382f:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
  803832:	c7 45 fc f8 ff ff ff 	movl   $0xfffffff8,-0x4(%rbp)
	if(!pg) pg = (void*)UTOP;
  803839:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80383e:	75 10                	jne    803850 <ipc_send+0x33>
  803840:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803847:	00 00 00 
  80384a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while(result != 0){
  80384e:	eb 62                	jmp    8038b2 <ipc_send+0x95>
  803850:	eb 60                	jmp    8038b2 <ipc_send+0x95>
		if(result != -E_IPC_NOT_RECV){
  803852:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803856:	74 30                	je     803888 <ipc_send+0x6b>
			//cprintf("to=%016x\n", to_env);
			panic("ipc sending failed with %e\n", result);
  803858:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80385b:	89 c1                	mov    %eax,%ecx
  80385d:	48 ba 7a 40 80 00 00 	movabs $0x80407a,%rdx
  803864:	00 00 00 
  803867:	be 33 00 00 00       	mov    $0x33,%esi
  80386c:	48 bf 96 40 80 00 00 	movabs $0x804096,%rdi
  803873:	00 00 00 
  803876:	b8 00 00 00 00       	mov    $0x0,%eax
  80387b:	49 b8 fc 02 80 00 00 	movabs $0x8002fc,%r8
  803882:	00 00 00 
  803885:	41 ff d0             	callq  *%r8
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
  803888:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80388b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80388e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803892:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803895:	89 c7                	mov    %eax,%edi
  803897:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  80389e:	00 00 00 
  8038a1:	ff d0                	callq  *%rax
  8038a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
		sys_yield();
  8038a6:	48 b8 db 19 80 00 00 	movabs $0x8019db,%rax
  8038ad:	00 00 00 
  8038b0:	ff d0                	callq  *%rax
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	int result = -E_IPC_NOT_RECV;
	if(!pg) pg = (void*)UTOP;
	while(result != 0){
  8038b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b6:	75 9a                	jne    803852 <ipc_send+0x35>
			panic("ipc sending failed with %e\n", result);
		}
		result = sys_ipc_try_send(to_env, val, pg, perm);
		sys_yield();
	}
}
  8038b8:	c9                   	leaveq 
  8038b9:	c3                   	retq   

00000000008038ba <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8038ba:	55                   	push   %rbp
  8038bb:	48 89 e5             	mov    %rsp,%rbp
  8038be:	48 83 ec 14          	sub    $0x14,%rsp
  8038c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8038c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038cc:	eb 5e                	jmp    80392c <ipc_find_env+0x72>
		if (envs[i].env_type == type)
  8038ce:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  8038d5:	00 00 00 
  8038d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038db:	48 63 d0             	movslq %eax,%rdx
  8038de:	48 89 d0             	mov    %rdx,%rax
  8038e1:	48 c1 e0 03          	shl    $0x3,%rax
  8038e5:	48 01 d0             	add    %rdx,%rax
  8038e8:	48 c1 e0 05          	shl    $0x5,%rax
  8038ec:	48 01 c8             	add    %rcx,%rax
  8038ef:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8038f5:	8b 00                	mov    (%rax),%eax
  8038f7:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8038fa:	75 2c                	jne    803928 <ipc_find_env+0x6e>
			return envs[i].env_id;
  8038fc:	48 b9 00 00 80 00 80 	movabs $0x8000800000,%rcx
  803903:	00 00 00 
  803906:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803909:	48 63 d0             	movslq %eax,%rdx
  80390c:	48 89 d0             	mov    %rdx,%rax
  80390f:	48 c1 e0 03          	shl    $0x3,%rax
  803913:	48 01 d0             	add    %rdx,%rax
  803916:	48 c1 e0 05          	shl    $0x5,%rax
  80391a:	48 01 c8             	add    %rcx,%rax
  80391d:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803923:	8b 40 08             	mov    0x8(%rax),%eax
  803926:	eb 12                	jmp    80393a <ipc_find_env+0x80>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803928:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80392c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803933:	7e 99                	jle    8038ce <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803935:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80393a:	c9                   	leaveq 
  80393b:	c3                   	retq   

000000000080393c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80393c:	55                   	push   %rbp
  80393d:	48 89 e5             	mov    %rsp,%rbp
  803940:	48 83 ec 18          	sub    $0x18,%rsp
  803944:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803948:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394c:	48 c1 e8 15          	shr    $0x15,%rax
  803950:	48 89 c2             	mov    %rax,%rdx
  803953:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80395a:	01 00 00 
  80395d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803961:	83 e0 01             	and    $0x1,%eax
  803964:	48 85 c0             	test   %rax,%rax
  803967:	75 07                	jne    803970 <pageref+0x34>
		return 0;
  803969:	b8 00 00 00 00       	mov    $0x0,%eax
  80396e:	eb 53                	jmp    8039c3 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803970:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803974:	48 c1 e8 0c          	shr    $0xc,%rax
  803978:	48 89 c2             	mov    %rax,%rdx
  80397b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803982:	01 00 00 
  803985:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803989:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80398d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803991:	83 e0 01             	and    $0x1,%eax
  803994:	48 85 c0             	test   %rax,%rax
  803997:	75 07                	jne    8039a0 <pageref+0x64>
		return 0;
  803999:	b8 00 00 00 00       	mov    $0x0,%eax
  80399e:	eb 23                	jmp    8039c3 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8039a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8039a8:	48 89 c2             	mov    %rax,%rdx
  8039ab:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8039b2:	00 00 00 
  8039b5:	48 c1 e2 04          	shl    $0x4,%rdx
  8039b9:	48 01 d0             	add    %rdx,%rax
  8039bc:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8039c0:	0f b7 c0             	movzwl %ax,%eax
}
  8039c3:	c9                   	leaveq 
  8039c4:	c3                   	retq   
